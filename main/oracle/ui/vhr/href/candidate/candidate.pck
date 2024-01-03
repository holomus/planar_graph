create or replace package Ui_Vhr301 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Person_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Sources return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Procedure Attach_Person(i_Person_Id varchar2);
  ----------------------------------------------------------------------------------------------------
  Function Load_Data(i_Person_Id varchar2) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(Jo Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Add(Jo Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Edit(Jo Json_Object_t) return Json_Object_t;
end Ui_Vhr301;
/
create or replace package body Ui_Vhr301 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    q       Fazo_Query;
    v_Query varchar2(3000);
  begin
    v_Query := 'select q.person_id,
                       q.name,
                       nvl2(f.person_id, ''Y'', ''N'') as attached,
                       decode((select 1 
                                 from href_candidates c
                                where c.company_id = q.company_id
                                  and c.filial_id = :filial_id
                                  and c.candidate_id = q.person_Id), 
                              1, 
                              ''Y'', 
                              ''N'') as candidate_exists
                  from mr_natural_persons q
                  left join mrf_persons f
                    on f.company_id = q.company_id
                   and f.filial_id = :filial_id
                   and f.person_id = q.person_id
                 where q.company_id = :company_id';
  
    if not Ui.Grant_Has('attach_person') then
      v_Query := v_Query || ' and f.person_id is not null';
    end if;
  
    q := Fazo_Query(v_Query, Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name', 'attached', 'candidate_exists');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Person_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_person_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'person_group_id',
                                 Mr_Pref.Pg_Natural_Category(Ui.Company_Id),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('person_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Sources return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_employment_sources',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('source_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2 is
    v_Phone varchar2(25) := p.r_Varchar2('main_phone');
  begin
    return Href_Util.Check_Unique_Phone(i_Company_Id => Ui.Company_Id, i_Phone => v_Phone);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Region_Id number := null) return Gmap is
    v_Genders     Matrix_Varchar2 := Md_Util.Person_Genders;
    v_Array       Array_Varchar2;
    r_Setting     Href_Candidate_Ref_Settings%rowtype;
    r_Crs_Setting Href_Pref.Col_Required_Setting_Rt;
    result        Gmap := Gmap();
  begin
    r_Setting := Href_Util.Load_Candidate_Form_Settings(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id);
  
    Result.Put('has_region', r_Setting.Region);
    Result.Put('has_address', r_Setting.Address);
    Result.Put('has_experience', r_Setting.Experience);
    Result.Put('has_source', r_Setting.Source);
    Result.Put('has_recommendation', r_Setting.Recommendation);
    Result.Put('has_cv', r_Setting.Cv);
  
    r_Crs_Setting := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);
  
    Result.Put('crs_last_name', r_Crs_Setting.Last_Name);
    Result.Put('crs_middle_name', r_Crs_Setting.Middle_Name);
    Result.Put('crs_birthday', r_Crs_Setting.Birthday);
    Result.Put('crs_phone_number', r_Crs_Setting.Phone_Number);
    Result.Put('crs_email', r_Crs_Setting.Email);
    Result.Put('crs_region', r_Crs_Setting.Region);
    Result.Put('crs_address', r_Crs_Setting.Address);
    Result.Put('crs_legal_address', r_Crs_Setting.Legal_Address);
  
    Result.Put('pg_female', Md_Pref.c_Pg_Female);
  
    select Json_Array(to_char(t.Region_Id), t.Name, t.Parent_Id null on null)
      bulk collect
      into v_Array
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and (t.State = 'A' or t.Region_Id = i_Region_Id)
     order by t.Name;
  
    Result.Put('regions', v_Array);
  
    select Json_Array(to_char(t.Lang_Id), w.Name)
      bulk collect
      into v_Array
      from Href_Candidate_Langs t
      join Href_Langs w
        on t.Company_Id = w.Company_Id
       and t.Lang_Id = w.Lang_Id
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and w.State = 'A'
     order by t.Order_No;
  
    Result.Put('langs', v_Array);
  
    select Json_Array(to_char(t.Lang_Level_Id), t.Name)
      bulk collect
      into v_Array
      from Href_Lang_Levels t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A';
  
    Result.Put('lang_levels', v_Array);
  
    select Json_Array(to_char(t.Edu_Stage_Id), t.Name)
      bulk collect
      into v_Array
      from Href_Candidate_Edu_Stages e
      join Href_Edu_Stages t
        on e.Company_Id = t.Company_Id
       and e.Edu_Stage_Id = t.Edu_Stage_Id
     where e.Company_Id = Ui.Company_Id
       and e.Filial_Id = Ui.Filial_Id
       and t.State = 'A'
     order by e.Order_No;
  
    Result.Put('edu_stages', v_Array);
    Result.Put('genders', Fazo.Zip_Matrix(v_Genders).Json);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Person(i_Person_Id varchar2) is
    r_Person Mr_Natural_Persons%rowtype;
  begin
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                          i_Person_Id  => i_Person_Id);
  
    if not z_Mrf_Persons.Exist(i_Company_Id => r_Person.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Person_Id  => r_Person.Person_Id) then
      Mrf_Api.Filial_Add_Person(i_Company_Id => r_Person.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Person_Id  => r_Person.Person_Id,
                                i_State      => r_Person.State);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Person(i_Person_Id varchar2) return Gmap is
    r_Person           Md_Persons%rowtype;
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    v_Array            Array_Varchar2;
    v_Person_Type_Id   number;
    result             Gmap := Gmap();
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                  i_Person_Id  => i_Person_Id);
  
    Result.Put('person_id', r_Person.Person_Id);
    Result.Put('photo_sha', r_Person.Photo_Sha);
    Result.Put('email', r_Person.Email);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put('name', r_Natural_Person.Name);
    Result.Put('first_name', r_Natural_Person.First_Name);
    Result.Put('last_name', r_Natural_Person.Last_Name);
    Result.Put('middle_name', r_Natural_Person.Middle_Name);
    Result.Put('gender', r_Natural_Person.Gender);
    Result.Put('birthday', r_Natural_Person.Birthday);
    Result.Put('code', r_Natural_Person.Code);
  
    r_Mr_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
  
    Result.Put('main_phone', r_Mr_Person_Detail.Main_Phone);
    Result.Put('extra_phone',
               z_Href_Person_Details.Take(i_Company_Id => r_Person.Company_Id, i_Person_Id => r_Person.Person_Id).Extra_Phone);
    Result.Put('address', r_Mr_Person_Detail.Address);
    Result.Put('legal_address', r_Mr_Person_Detail.Legal_Address);
    Result.Put('region_id', r_Mr_Person_Detail.Region_Id);
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => r_Mr_Person_Detail.Company_Id, i_Region_Id => r_Mr_Person_Detail.Region_Id).Name);
  
    select Json_Array(to_char(t.Lang_Id), to_char(t.Lang_Level_Id))
      bulk collect
      into v_Array
      from Href_Person_Langs t
     where t.Company_Id = Ui.Company_Id
       and t.Person_Id = r_Person.Person_Id;
  
    Result.Put('langs', v_Array);
  
    select e.Edu_Stage_Id
      bulk collect
      into v_Array
      from Href_Person_Edu_Stages e
     where e.Company_Id = Ui.Company_Id
       and e.Person_Id = r_Person.Person_Id
     group by e.Edu_Stage_Id;
  
    Result.Put('edu_stages', v_Array);
  
    select Json_Array(to_char(j.Job_Id),
                      (select w.Name
                         from Mhr_Jobs w
                        where w.Company_Id = j.Company_Id
                          and w.Filial_Id = j.Filial_Id
                          and w.Job_Id = j.Job_Id))
      bulk collect
      into v_Array
      from Href_Candidate_Jobs j
     where j.Company_Id = Ui.Company_Id
       and j.Filial_Id = Ui.Filial_Id
       and j.Candidate_Id = r_Person.Person_Id;
  
    Result.Put('candidate_jobs', v_Array);
  
    v_Person_Type_Id := z_Mr_Person_Type_Binds.Take(i_Company_Id => Ui.Company_Id, --
                        i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(Ui.Company_Id), --
                        i_Person_Id => r_Person.Person_Id).Person_Type_Id;
  
    Result.Put('person_type_id', v_Person_Type_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Data(i_Person_Id varchar2) return Json_Object_t is
  begin
    return Load_Person(i_Person_Id).Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Json_Object_t is
    result Gmap := Gmap();
  begin
    Result.Put('gender', Md_Pref.c_Pg_Male);
    Result.Put('state', 'A');
    Result.Put('references', References);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(Jo Json_Object_t) return Json_Object_t is
    r_Candidate Href_Candidates%rowtype;
    p           Gmap := Gmap(Jo);
    result      Gmap;
  begin
    result := Load_Person(p.r_Number('person_id'));
  
    r_Candidate := z_Href_Candidates.Load(i_Company_Id   => Ui.Company_Id,
                                          i_Filial_Id    => Ui.Filial_Id,
                                          i_Candidate_Id => p.r_Number('person_id'));
  
    Result.Put('source_id', r_Candidate.Source_Id);
    Result.Put('wage_expectation', r_Candidate.Wage_Expectation);
    Result.Put('cv_sha', r_Candidate.Cv_Sha);
    Result.Put('cv_name', z_Biruni_Files.Take(r_Candidate.Cv_Sha).File_Name);
    Result.Put('note', r_Candidate.Note);
    Result.Put('person_type_name',
               z_Mr_Person_Types.Take(i_Company_Id => Ui.Company_Id, --
               i_Person_Type_Id => Result.o_Number('person_type_id')).Name);
    Result.Put('source_name',
               z_Href_Employment_Sources.Take(i_Company_Id => r_Candidate.Company_Id, --
               i_Source_Id => r_Candidate.Source_Id).Name);
    Result.Put('references', References(Result.o_Number('region_id')));
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    p                Gmap,
    i_Candidate_Id   number,
    i_Candidate_Kind varchar2
  ) return Json_Object_t is
    v_Candidate Href_Pref.Candidate_Rt;
    v_Glist     Glist := Glist();
    v_Data      Gmap := Gmap();
    result      Gmap := Gmap();
  begin
    Href_Util.Candidate_New(o_Candidate        => v_Candidate,
                            i_Company_Id       => Ui.Company_Id,
                            i_Filial_Id        => Ui.Filial_Id,
                            i_Candidate_Id     => i_Candidate_Id,
                            i_Person_Type_Id   => p.o_Number('person_type_id'),
                            i_Candidate_Kind   => i_Candidate_Kind,
                            i_First_Name       => p.r_Varchar2('first_name'),
                            i_Last_Name        => p.o_Varchar2('last_name'),
                            i_Middle_Name      => p.o_Varchar2('middle_name'),
                            i_Gender           => p.r_Varchar2('gender'),
                            i_Birthday         => p.o_Date('birthday'),
                            i_Photo_Sha        => p.o_Varchar2('photo_sha'),
                            i_Region_Id        => p.o_Number('region_id'),
                            i_Main_Phone       => p.o_Varchar2('main_phone'),
                            i_Extra_Phone      => p.o_Varchar2('extra_phone'),
                            i_Email            => p.o_Varchar2('email'),
                            i_Address          => p.o_Varchar2('address'),
                            i_Legal_Address    => p.o_Varchar2('legal_address'),
                            i_Source_Id        => p.o_Number('source_id'),
                            i_Wage_Expectation => p.o_Number('wage_expectation'),
                            i_Cv_Sha           => p.o_Varchar2('cv_sha'),
                            i_Note             => p.o_Varchar2('note'),
                            i_Edu_Stages       => Nvl(p.o_Array_Number('edu_stages'), Array_Number()),
                            i_Candidate_Jobs   => Nvl(p.o_Array_Number('candidate_jobs'),
                                                      Array_Number()));
  
    if v_Candidate.Person.Person_Id is null then
      v_Candidate.Person.Person_Id := Md_Next.Person_Id;
    end if;
  
    -- langs
    v_Glist := Nvl(p.o_Glist('langs'), Glist());
  
    for i in 0 .. v_Glist.Count - 1
    loop
      v_Data := Gmap(Json_Object_t(v_Glist.Val.Get(i)));
    
      Href_Util.Candidate_Add_Lang(p_Candidate     => v_Candidate,
                                   i_Lang_Id       => v_Data.r_Number('lang_id'),
                                   i_Lang_Level_Id => v_Data.r_Number('level_id'));
    end loop;
  
    Href_Api.Candidate_Save(v_Candidate);
  
    Result.Put('candidate_id', v_Candidate.Person.Person_Id);
    Result.Put('name',
               v_Candidate.Person.Last_Name || ' ' || v_Candidate.Person.First_Name || ' ' ||
               v_Candidate.Person.Middle_Name);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(Jo Json_Object_t) return Json_Object_t is
    p Gmap := Gmap(Jo);
  begin
    return save(p, p.o_Number('person_id'), Href_Pref.c_Candidate_Kind_New);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(Jo Json_Object_t) return Json_Object_t is
    p              Gmap := Gmap(Jo);
    v_Candidate_Id number := p.r_Number('person_id');
    r_Candidate    Href_Candidates%rowtype;
  begin
    r_Candidate := z_Href_Candidates.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                               i_Filial_Id    => Ui.Filial_Id,
                                               i_Candidate_Id => v_Candidate_Id);
  
    return save(p, v_Candidate_Id, r_Candidate.Candidate_Kind);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
    update Href_Candidates
       set Company_Id   = null,
           Filial_Id    = null,
           Candidate_Id = null;
    update Mr_Person_Types
       set Company_Id      = null,
           Person_Type_Id  = null,
           Person_Group_Id = null,
           name            = null,
           State           = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr301;
/
