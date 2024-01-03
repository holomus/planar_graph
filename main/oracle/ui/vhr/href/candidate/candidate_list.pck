create or replace package Ui_Vhr305 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Employee(P1 Json_Object_t);
end Ui_Vhr305;
/
create or replace package body Ui_Vhr305 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Params Hashmap := Hashmap;
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('person_group_id', Mr_Pref.Pg_Natural_Category(Ui.Company_Id));
    v_Params.Put('ck_new', Href_Pref.c_Candidate_Kind_New);
    v_Params.Put('ss_unknown', Href_Pref.c_Staff_Status_Unknown);
    v_Params.Put('ss_dismissed', Href_Pref.c_Staff_Status_Dismissed);
    v_Params.Put('ss_working', Href_Pref.c_Staff_Status_Working);
    v_Params.Put('filter_date', Trunc(sysdate));
    v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
  
    q := Fazo_Query('select q.*,
                            s.dismissal_date,
                            s.dismissal_reason_id as reason_id,
                            (select r.reason_type
                               from href_dismissal_reasons r 
                              where r.company_id = :company_id
                                and r.dismissal_reason_id = s.dismissal_reason_id) as reason_type,
                            case
                               when not exists (select *
                                       from mhr_employees e
                                      where e.company_id = :company_id
                                        and e.filial_id = :filial_id
                                        and e.employee_id = q.candidate_id) then
                                 :ck_new
                               when s.hiring_date is null or s.hiring_date > :filter_date then
                                 :ss_unknown
                               when s.dismissal_date < :filter_date then
                                 :ss_dismissed
                               else
                                 :ss_working
                             end as candidate_kind
                       from (select c.candidate_id,
                                    c.source_id,
                                    c.wage_expectation,
                                    c.cv_sha,
                                    c.note,
                                    c.created_by,
                                    c.created_on,
                                    c.modified_by,
                                    c.modified_on,
                                    n.name,
                                    n.gender,
                                    n.birthday,
                                    d.photo_sha,
                                    d.email, 
                                    t.main_phone,
                                    t.address, 
                                    t.legal_address,
                                    t.region_id,
                                    (select tb.person_type_id
                                       from mr_person_type_binds tb
                                      where tb.company_id = :company_id
                                        and tb.person_group_id = :person_group_id
                                        and tb.person_id = c.candidate_id) as person_type_id,
                                     (select s.staff_id
                                        from href_staffs s
                                       where s.company_id = :company_id
                                         and s.filial_id = :filial_id
                                         and s.employee_id = c.candidate_id
                                         and s.staff_kind = :sk_primary
                                         and s.state = ''A''
                                         and s.hiring_date = (select max(s1.hiring_date)
                                                                from href_staffs s1
                                                               where s1.company_id = :company_id
                                                                 and s1.filial_id = :filial_id
                                                                 and s1.employee_id = c.candidate_id
                                                                 and s1.staff_kind = :sk_primary
                                                                 and s1.state = ''A''
                                                                 and s1.hiring_date <= :filter_date)) as staff_id                        
                               from href_candidates c
                               join mr_natural_persons n
                                 on c.company_id = n.company_id
                                and c.candidate_id = n.person_id
                               left join mr_person_details t
                                 on c.company_id = t.company_id
                                and c.candidate_id = t.person_id 
                               join md_persons d
                                 on c.company_id = d.company_id
                                and c.candidate_id = d.person_id
                              where c.company_id = :company_id
                                and c.filial_id = :filial_id) q
                       left join href_staffs s
                         on s.company_id = :company_id
                        and s.filial_id = :filial_id
                        and s.staff_id = q.staff_id',
                    v_Params);
  
    q.Number_Field('candidate_id',
                   'person_type_id',
                   'source_id',
                   'wage_expectation',
                   'region_id',
                   'reason_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name',
                     'candidate_kind',
                     'note',
                     'gender',
                     'photo_sha',
                     'email',
                     'main_phone',
                     'address',
                     'legal_address',
                     'reason_type');
    q.Date_Field('birthday', 'created_on', 'modified_on', 'dismissal_date');
  
    q.Multi_Number_Field('job_ids',
                         'select w.job_id, w.candidate_id
                            from href_candidate_jobs w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id',
                         '@candidate_id=$candidate_id',
                         'job_id');
    q.Refer_Field('job_names',
                  'job_ids',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select j.*
                     from mhr_jobs j
                    where j.company_id = :company_id
                      and j.filial_id = :filial_id');
    q.Refer_Field('person_type_name',
                  'person_type_id',
                  'mr_person_types',
                  'person_type_id',
                  'name',
                  'select *
                     from mr_person_types s 
                    where s.company_id = :company_id');
    q.Refer_Field('source_name',
                  'source_id',
                  'href_employment_sources',
                  'source_id',
                  'name',
                  'select *
                     from href_employment_sources s 
                    where s.company_id = :company_id');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users q
                    where q.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
    q.Refer_Field('reason_name',
                  'reason_id',
                  'href_dismissal_reasons',
                  'dismissal_reason_id',
                  'name',
                  'select r.* 
                     from href_dismissal_reasons r
                    where r.company_id = :company_id');
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.Candidate_Kinds;
  
    q.Option_Field('candidate_kind_name', 'candidate_kind', v_Matrix(1), v_Matrix(2));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    v_Matrix := Href_Util.Dismissal_Reasons_Type;
  
    q.Option_Field('reason_type_name', 'reason_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Candidate_Ids Array_Number := Fazo.Sort(p.r_Array_Number('candidate_id'));
  begin
    for i in 1 .. v_Candidate_Ids.Count
    loop
      Href_Api.Candidate_Delete(i_Company_Id   => Ui.Company_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Candidate_Id => v_Candidate_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Employee(P1 Json_Object_t) is
    r_User          Md_Users%rowtype;
    r_Person        Mr_Natural_Persons%rowtype;
    r_Employee      Mhr_Employees%rowtype;
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Role_Id       number;
    v_Candidate_Ids Array_Number;
    p               Gmap := Gmap;
  begin
    p.Val                 := P1;
    v_Candidate_Ids       := Fazo.Sort(p.r_Array_Number('candidate_id'));
    r_Employee.Company_Id := v_Company_Id;
    r_Employee.Filial_Id  := v_Filial_Id;
    r_Employee.State      := 'A';
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    for i in 1 .. v_Candidate_Ids.Count
    loop
      r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => v_Company_Id,
                                                 i_Person_Id  => v_Candidate_Ids(i));
    
      if not z_Mrf_Persons.Exist_Lock(i_Company_Id => v_Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Person_Id  => v_Candidate_Ids(i)) then
        Mrf_Api.Filial_Add_Person(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Person_Id  => v_Candidate_Ids(i),
                                  i_State      => r_Person.State);
      end if;
    
      if not z_Mhr_Employees.Exist(i_Company_Id  => r_Employee.Company_Id,
                                   i_Filial_Id   => r_Employee.Filial_Id,
                                   i_Employee_Id => v_Candidate_Ids(i)) then
        r_Employee.Employee_Id := v_Candidate_Ids(i);
      
        Mhr_Api.Employee_Save(i_Employee => r_Employee);
      end if;
    
      if not z_Md_Users.Exist(i_Company_Id => v_Company_Id,
                              i_User_Id    => v_Candidate_Ids(i),
                              o_Row        => r_User) then
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
                                     i_User_Id    => v_Candidate_Ids(i),
                                     i_Filial_Id  => v_Filial_Id) then
        Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                               i_User_Id    => v_Candidate_Ids(i),
                               i_Filial_Id  => v_Filial_Id);
      end if;
    
      if not z_Md_User_Roles.Exist(i_Company_Id => v_Company_Id,
                                   i_User_Id    => v_Candidate_Ids(i),
                                   i_Filial_Id  => v_Filial_Id,
                                   i_Role_Id    => v_Role_Id) then
        Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                          i_User_Id    => v_Candidate_Ids(i),
                          i_Filial_Id  => v_Filial_Id,
                          i_Role_Id    => v_Role_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           State       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Photo_Sha  = null,
           Email      = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Main_Phone    = null,
           Address       = null,
           Legal_Address = null,
           Region_Id     = null;
    update Mr_Person_Type_Binds
       set Company_Id      = null,
           Person_Group_Id = null,
           Person_Id       = null,
           Person_Type_Id  = null;
    update Href_Candidates
       set Company_Id       = null,
           Filial_Id        = null,
           Candidate_Id     = null,
           Source_Id        = null,
           Wage_Expectation = null,
           Cv_Sha           = null,
           Note             = null,
           Created_By       = null,
           Created_On       = null,
           Modified_By      = null,
           Modified_On      = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Href_Staffs
       set Company_Id          = null,
           Filial_Id           = null,
           Staff_Id            = null,
           Employee_Id         = null,
           Staff_Kind          = null,
           Hiring_Date         = null,
           Dismissal_Date      = null,
           Dismissal_Reason_Id = null,
           State               = null;
    update Href_Candidate_Jobs
       set Company_Id   = null,
           Filial_Id    = null,
           Candidate_Id = null,
           Job_Id       = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
    update Href_Employment_Sources
       set Company_Id = null,
           Source_Id  = null,
           name       = null;
  end;

end Ui_Vhr305;
/
