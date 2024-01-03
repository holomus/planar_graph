create or replace package Ui_Vhr13 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Person(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap;
end Ui_Vhr13;
/
create or replace package body Ui_Vhr13 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    v_Query varchar2(4000);
    q       Fazo_Query;
  begin
    v_Query := 'select q.person_id,
                       q.name,
                       nvl2(f.filial_id, ''Y'', ''N'') attached
                  from mr_natural_persons q
                  left join mrf_persons f
                    on f.company_id = q.company_id
                   and f.person_id = q.person_id
                   and f.filial_id = :filial_id
                 where q.company_id = :company_id';
  
    if not Ui.Is_Filial_Head and --
       not Ui.Grant_Has('attach_person') then
      v_Query := v_Query || ' and f.person_id is not null';
    end if;
  
    q := Fazo_Query(v_Query, Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name', 'attached');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_nationalities',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('nationality_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Person(p Hashmap) is
    r_Person Mr_Natural_Persons%rowtype;
  begin
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id,
                                          i_Person_Id  => p.r_Number('person_id'));
  
    if not z_Mrf_Persons.Exist(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Person_Id  => r_Person.Person_Id) then
      Mrf_Api.Filial_Add_Person(i_Company_Id => r_Person.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Person_Id  => r_Person.Person_Id,
                                i_State      => r_Person.State);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap;
  begin
    result := Fazo.Zip_Map('pg_female', Md_Pref.c_Pg_Female);
  
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Name;
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('genders', Fazo.Zip_Matrix_Transposed(Md_Util.Person_Genders));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    --Uit_Href.Assert_Access_All_Employees;
  
    result := Fazo.Zip_Map('gender', Md_Pref.c_Pg_Male, 'key_person', 'N', 'state', 'A');
  
    Result.Put('photo_as_face_rec', Htt_Util.Photo_As_Face_Rec(Ui.Company_Id));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap is
    v_Person            Href_Pref.Person_Rt;
    v_Person_Identity   Htt_Pref.Person_Rt;
    r_Person            Mr_Natural_Persons%rowtype;
    v_Photo_As_Face_Rec varchar2(1) := p.r_Varchar2('photo_as_face_rec');
  begin
    --Uit_Href.Assert_Access_All_Employees;
  
    Href_Util.Person_New(o_Person               => v_Person,
                         i_Company_Id           => Ui.Company_Id,
                         i_Person_Id            => Md_Next.Person_Id,
                         i_First_Name           => p.r_Varchar2('first_name'),
                         i_Last_Name            => p.o_Varchar2('last_name'),
                         i_Middle_Name          => p.o_Varchar2('middle_name'),
                         i_Gender               => p.r_Varchar2('gender'),
                         i_Birthday             => p.o_Varchar2('birthday'),
                         i_Nationality_Id       => p.o_Number('nationality_id'),
                         i_Photo_Sha            => p.o_Varchar2('photo_sha'),
                         i_Tin                  => p.o_Varchar2('tin'),
                         i_Iapa                 => p.o_Varchar2('iapa'),
                         i_Npin                 => p.o_Varchar2('npin'),
                         i_Region_Id            => p.o_Varchar2('region_id'),
                         i_Main_Phone           => p.o_Varchar2('main_phone'),
                         i_Email                => p.o_Varchar2('email'),
                         i_Address              => p.o_Varchar2('address'),
                         i_Legal_Address        => p.o_Varchar2('legal_address'),
                         i_Key_Person           => Nvl(p.o_Varchar2('key_person'), 'N'),
                         i_Access_All_Employees => Nvl(p.o_Varchar2('access_all_employees'), 'N'),
                         i_State                => p.r_Varchar2('state'),
                         i_Code                 => p.o_Varchar2('code'));
  
    Href_Api.Person_Save(v_Person);
  
    Htt_Util.Person_New(o_Person     => v_Person_Identity,
                        i_Company_Id => v_Person.Company_Id,
                        i_Person_Id  => v_Person.Person_Id,
                        i_Pin        => null,
                        i_Pin_Code   => null,
                        i_Rfid_Code  => null,
                        i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Person.Person_Id));
  
    if Htt_Util.Pin_Autogenerate(v_Person.Company_Id) = 'Y' then
      v_Person_Identity.Pin := Htt_Core.Next_Pin(v_Person.Company_Id);
    end if;
  
    Htt_Api.Person_Save(v_Person_Identity);
  
    if v_Photo_As_Face_Rec = 'Y' and v_Person.Photo_Sha is not null then
      Htt_Api.Person_Save_Photo(i_Company_Id => v_Person.Company_Id,
                                i_Person_Id  => v_Person.Person_Id,
                                i_Photo_Sha  => v_Person.Photo_Sha,
                                i_Is_Main    => 'Y');
    end if;
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Person.Company_Id,
                                          i_Person_Id  => v_Person.Person_Id);
  
    if not Ui.Is_Filial_Head then
      Mrf_Api.Filial_Add_Person(i_Company_Id => v_Person.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Person_Id  => v_Person.Person_Id,
                                i_State      => v_Person.State);
    end if;
  
    return z_Mr_Natural_Persons.To_Map(r_Person, z.Person_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null,
           State      = null;
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null,
           State          = null;
  end;

end Ui_Vhr13;
/
