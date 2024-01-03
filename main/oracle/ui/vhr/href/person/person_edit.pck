create or replace package Ui_Vhr501 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Person(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Location(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_Photo(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap);
end Ui_Vhr501;
/
create or replace package body Ui_Vhr501 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Person(p Hashmap) return Hashmap is
    r_Person           Md_Persons%rowtype;
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    result             Hashmap;
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => p.r_Number('person_id'));
  
    result := z_Md_Persons.To_Map(r_Person, z.Photo_Sha, z.Email);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person, z.Name, z.Gender));
  
    r_Mr_Person_Detail := z_Mr_Person_Details.Load(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
  
    Result.Put('main_phone', r_Mr_Person_Detail.Main_Phone);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Location(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    v_Loc_Ids   Array_Number;
    v_Loc_Names Array_Varchar2;
  begin
    select Lp.Location_Id
      bulk collect
      into v_Loc_Ids
      from Htt_Location_Persons Lp
     where Lp.Company_Id = Ui.Company_Id
       and Lp.Filial_Id = Ui.Filial_Id
       and Lp.Person_Id = v_Person_Id
       and not exists (select *
              from Htt_Blocked_Person_Tracking Bp
             where Bp.Company_Id = Lp.Company_Id
               and Bp.Filial_Id = Lp.Filial_Id
               and Bp.Employee_Id = Lp.Person_Id);
  
    select Lc.Name
      bulk collect
      into v_Loc_Names
      from Htt_Locations Lc
     where Lc.Company_Id = Ui.Company_Id
       and Lc.Location_Id member of v_Loc_Ids
     order by Lc.Name
     fetch first 3 Rows only;
  
    return Fazo.Zip_Map('location_names',
                        Fazo.Gather(v_Loc_Names, ', '),
                        'location_count',
                        v_Loc_Ids.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id   number := p.r_Number('person_id');
    v_Is_Detached varchar2(1) := 'Y';
    v_Doc_Type_Id number;
    r_Document    Href_Person_Documents%rowtype;
    result        Hashmap := Hashmap();
  begin
    Result.Put_All(Load_Person(p));
    Result.Put_All(Load_Location(p));
  
    if z_Mhr_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                             i_Filial_Id   => Ui.Filial_Id,
                             i_Employee_Id => v_Person_Id) then
      v_Is_Detached := 'N';
    end if;
  
    Result.Put('is_detached', v_Is_Detached);
  
    -- get passport info
    v_Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                           i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
    begin
      select q.*
        into r_Document
        from Href_Person_Documents q
       where q.Company_Id = Ui.Company_Id
         and q.Person_Id = v_Person_Id
         and q.Doc_Type_Id = v_Doc_Type_Id
       order by q.Begin_Date desc nulls last
       fetch first 1 row only;
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('passport_series', r_Document.Doc_Series);
    Result.Put('passport_number', r_Document.Doc_Number);
    Result.Put('passport_id', r_Document.Document_Id);
  
    Result.Put('references', Fazo.Zip_Map('pg_female', Md_Pref.c_Pg_Female));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Photo(p Hashmap) return Hashmap is
    r_Person            Md_Persons%rowtype;
    v_Photo_Sha         Md_Persons.Photo_Sha%type := p.r_Varchar2('photo_sha');
    v_Photo_As_Face_Rec varchar2(1);
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => p.r_Number('person_id'));
  
    Md_Api.Person_Update(i_Company_Id => r_Person.Company_Id,
                         i_Person_Id  => r_Person.Person_Id,
                         i_Photo_Sha  => Option_Varchar2(v_Photo_Sha));
  
    v_Photo_As_Face_Rec := Htt_Util.Photo_As_Face_Rec(Ui.Company_Id);
  
    if v_Photo_As_Face_Rec = 'Y' then
      Htt_Api.Person_Photo_Update(i_Company_Id    => r_Person.Company_Id,
                                  i_Person_Id     => r_Person.Person_Id,
                                  i_Old_Photo_Sha => r_Person.Photo_Sha,
                                  i_New_Photo_Sha => v_Photo_Sha);
    end if;
  
    return Fazo.Zip_Map('photo_sha', v_Photo_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap) is
    r_User       Md_Users%rowtype;
    r_Person     Mr_Natural_Persons%rowtype;
    v_Person_Id  number := p.r_Number('person_id');
    r_Employee   Mhr_Employees%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Role_Id    number;
  begin
    r_Employee.Company_Id := v_Company_Id;
    r_Employee.Filial_Id  := v_Filial_Id;
    r_Employee.State      := 'A';
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Person_Id  => v_Person_Id);
  
    Mrf_Api.Filial_Add_Person(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Id,
                              i_Person_Id  => v_Person_Id,
                              i_State      => r_Person.State);
  
    if not z_Mhr_Employees.Exist(i_Company_Id  => r_Employee.Company_Id,
                                 i_Filial_Id   => r_Employee.Filial_Id,
                                 i_Employee_Id => v_Person_Id) then
      r_Employee.Employee_Id := v_Person_Id;
    
      Mhr_Api.Employee_Save(i_Employee => r_Employee);
    end if;
  
    if not z_Md_Users.Exist(i_Company_Id => v_Company_Id, i_User_Id => v_Person_Id, o_Row => r_User) then
      z_Md_Users.Init(p_Row        => r_User,
                      i_Company_Id => r_Person.Company_Id,
                      i_User_Id    => r_Person.Person_Id,
                      i_Name       => r_Person.Name,
                      i_User_Kind  => Md_Pref.c_Uk_Normal,
                      i_Gender     => r_Person.Gender,
                      i_State      => 'A');
    
      Md_Api.User_Save(r_User);
    end if;
  
    if not z_Md_User_Filials.Exist(i_Company_Id => v_Company_Id,
                                   i_User_Id    => r_Person.Person_Id,
                                   i_Filial_Id  => v_Filial_Id) then
      Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                             i_User_Id    => r_Person.Person_Id,
                             i_Filial_Id  => v_Filial_Id);
    end if;
  
    if not z_Md_User_Roles.Exist(i_Company_Id => v_Company_Id,
                                 i_User_Id    => r_Person.Person_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

end Ui_Vhr501;
/
