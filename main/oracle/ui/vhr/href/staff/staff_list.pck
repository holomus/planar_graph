create or replace package Ui_Vhr54 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
end Ui_Vhr54;
/
create or replace package body Ui_Vhr54 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                       (select r.person_id
                          from mrf_robots r
                         where r.company_id = :company_id
                           and r.filial_id = :filial_id
                           and r.robot_id = (select case 
                                                     when dm.manager_id <> q.robot_id then
                                                       dm.manager_id
                                                     else
                                                       (select md.manager_id
                                                          from mhr_parent_divisions pd
                                                          join mrf_division_managers md
                                                            on md.company_id = pd.company_id
                                                           and md.filial_id = pd.filial_id
                                                           and md.division_id = pd.parent_id
                                                         where pd.company_id = dm.company_id
                                                           and pd.filial_id = dm.filial_id
                                                           and pd.division_id = dm.division_id
                                                           and pd.lvl = 1)
                                                    end
                                               from mrf_division_managers dm
                                              where dm.company_id = r.company_id
                                                and dm.filial_id = r.filial_id
                                                and dm.division_id = q.org_unit_id)) manager_id,
                       k.photo_sha,
                       w.name,
                       w.first_name,
                       w.last_name,
                       w.middle_name,
                       w.gender,
                       w.birthday,
                       w.code,
                       m.tin,
                       m.region_id,
                       m.main_phone,
                       k.email,
                       m.address,
                       m.legal_address,
                       n.iapa,
                       n.npin,
                       n.key_person,
                       uit_href.get_staff_status(q.hiring_date, q.dismissal_date, :filter_date) as status
                  from href_staffs q
                  join md_persons k
                    on k.company_id = q.company_id
                   and k.person_id = q.employee_id
                  join mr_natural_persons w
                    on w.company_id = k.company_id
                   and w.person_id = k.person_id
                  join mr_person_details m
                    on m.company_id = w.company_id
                   and m.person_id = w.person_id                  
                  left join href_person_details n
                    on n.company_id = w.company_id
                   and n.person_id = w.person_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'filter_date',
                                 Nvl(p.o_Date('date'), Trunc(sysdate))));
  
    q.Number_Field('staff_id',
                   'employee_id',
                   'region_id',
                   'created_by',
                   'modified_by',
                   'division_id',
                   'job_id',
                   'rank_id',
                   'schedule_id',
                   'robot_id');
    q.Number_Field('fte',
                   'dismissal_reason_id',
                   'manager_id',
                   'access_level',
                   'org_unit_id',
                   'fte_id');
    q.Varchar2_Field('staff_number',
                     'name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'photo_sha',
                     'tin',
                     'iapa');
    q.Varchar2_Field('npin',
                     'main_phone',
                     'email',
                     'address',
                     'legal_address',
                     'code',
                     'dismissal_note',
                     'key_person');
    q.Varchar2_Field('status', 'staff_kind', 'access_level', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date', 'birthday', 'created_on', 'modified_on');
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
    q.Option_Field('key_person_name',
                   'key_person',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Href_Util.Staff_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.Staff_Kinds;
  
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
  
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpd_Util.Employment_Types(true);
  
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query);
    q.Refer_Field('employee_number',
                  'employee_id',
                  'select * 
                     from mhr_employees q 
                    where q.company_id = :company_id 
                      and q.filial_id = :filial_id',
                  'employee_id',
                  'employee_number',
                  Uit_Href.Person_Refer_Field_Filter_Query);
  
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
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('org_unit_name',
                  'org_unit_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                     from mhr_jobs q 
                    where q.company_id = ui.company_id
                      and q.filial_id = ui.filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select * 
                     from mhr_ranks q 
                    where q.company_id = ui.company_id
                      and q.filial_id = ui.filial_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select * 
                     from htt_schedules q 
                    where q.company_id = ui.company_id
                      and q.filial_id = ui.filial_id');
    q.Refer_Field('dismissal_reason_name',
                  'dismissal_reason_id',
                  'href_dismissal_reasons',
                  'dismissal_reason_id',
                  'name',
                  'select * 
                     from href_dismissal_reasons q 
                    where q.company_id = ui.company_id');
    q.Refer_Field('robot_name',
                  'robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select * 
                     from mrf_robots q 
                    where q.company_id = ui.company_id
                      and q.filial_id = ui.filial_id
                      and exists (select 1
                            from hrm_robots w
                           where w.company_id = q.company_id
                             and w.filial_id = q.filial_id
                             and w.robot_id = q.robot_id)');
    q.Refer_Field('fte_name',
                  'fte_id',
                  'href_ftes',
                  'fte_id',
                  'name',
                  'select *
                     from href_ftes s 
                    where s.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id          = null,
           Filial_Id           = null,
           Staff_Id            = null,
           Staff_Number        = null,
           Employee_Id         = null,
           Hiring_Date         = null,
           Dismissal_Date      = null,
           Division_Id         = null,
           Job_Id              = null,
           Fte                 = null,
           Fte_Id              = null,
           Rank_Id             = null,
           Schedule_Id         = null,
           Dismissal_Reason_Id = null,
           Dismissal_Note      = null,
           Staff_Kind          = null,
           State               = null,
           Created_By          = null,
           Created_On          = null,
           Modified_By         = null,
           Modified_On         = null;
    update Mhr_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Employee_Number = null;
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           State       = null,
           Code        = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Photo_Sha  = null,
           Email      = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Main_Phone    = null,
           Address       = null,
           Legal_Address = null,
           Region_Id     = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null,
           Key_Person = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null;
    Uie.x(Uit_Href.Get_Staff_Status(null, null, null));
  end;

end Ui_Vhr54;
/
