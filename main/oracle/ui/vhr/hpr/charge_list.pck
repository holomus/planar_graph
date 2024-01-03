create or replace package Ui_Vhr177 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
end Ui_Vhr177;
/
create or replace package body Ui_Vhr177 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Params Hashmap;
  begin
    v_Query := 'select ch.*,
                       w.kind,
                       w.begin_date interval_begin_date,
                       w.end_date  interval_end_date,
                       s.staff_number,
                       s.employee_id,
                       pd.iapa,
                       pd.npin,
                       (select mr.tin
                          from mr_person_details mr
                         where mr.company_id = pd.company_id
                           and mr.person_id = pd.person_id) tin,
                       ot.name oper_type_name,
                       ot.operation_kind,
                       (select ot.oper_group_id
                          from hpr_oper_types ot
                         where ot.company_id = ch.company_id
                           and ot.oper_type_id = ch.oper_type_id) oper_group_id
                  from hpr_charges ch
                  left join hpd_lock_intervals w
                    on ch.company_id = w.company_id
                   and ch.filial_id = w.filial_id
                   and ch.interval_id = w.interval_id
                  join mpr_oper_types ot
                    on ot.company_id = ch.company_id
                   and ot.oper_type_id = ch.oper_type_id
                  join href_staffs s
                    on s.company_id = ch.company_id
                   and s.filial_id = ch.filial_id
                   and s.staff_id = ch.staff_id
                  left join href_person_details pd
                    on pd.company_id = s.company_id
                   and pd.person_id = s.employee_id 
                 where ch.company_id = :company_id
                   and ch.filial_id = :filial_id ';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'user_id',
                             Ui.User_Id);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || --
                 ' and hpd_util.get_closest_org_unit_id(i_company_id => s.company_id,
                                                        i_filial_id  => s.filial_id,
                                                        i_staff_id   => s.staff_id,
                                                        i_period     => least(ch.end_date,
                                                                              nvl(s.dismissal_date,
                                                                                  ch.end_date))) member of :division_ids';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
    end if;
  
    if not Ui.Is_User_Admin and Hrm_Util.Restrict_To_View_All_Salaries(Ui.Company_Id) = 'Y' then
      v_Query := v_Query ||
                 ' and uit_hrm.access_to_hidden_salary_job(i_job_id => ch.job_id, i_employee_id => s.employee_id) = ''Y'' ';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('charge_id',
                   'interval_id',
                   'oper_type_id',
                   'amount',
                   'division_id',
                   'schedule_id',
                   'job_id',
                   'rank_id',
                   'robot_id',
                   'staff_id');
    q.Number_Field('oper_group_id', 'currency_id', 'employee_id');
    q.Varchar2_Field('status', 'kind', 'oper_type_name', 'operation_kind', 'staff_number');
    q.Varchar2_Field('iapa', 'npin', 'tin');
    q.Date_Field('begin_date', 'end_date', 'interval_begin_date', 'interval_end_date');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select w.* 
                     from htt_schedules w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select w.* 
                     from mhr_jobs w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select w.* 
                     from mhr_ranks w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('robot_name',
                  'robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select w.* 
                     from mrf_robots w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id
                      and exists (select 1
                            from hrm_robots hr
                           where hr.company_id = w.company_id
                             and hr.filial_id = w.filial_id
                             and hr.robot_id = w.robot_id)');
    q.Refer_Field('staff_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query);
    q.Refer_Field('oper_group_name',
                  'oper_group_id',
                  'hpr_oper_groups',
                  'oper_group_id',
                  'name',
                  'select w.* 
                     from hpr_oper_groups w 
                    where w.company_id = :company_id');
    q.Refer_Field('currency_name',
                  'currency_id',
                  'select w.* 
                     from mk_currencies w 
                    where w.company_id = :company_id',
                  'currency_id',
                  'name',
                  'select w.* 
                     from mk_currencies w 
                    where w.company_id = :company_id');
  
    v_Matrix := Hpr_Util.Charge_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpd_Util.Charge_Lock_Interval_Kinds;
    q.Option_Field('kind_name', 'kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Mpr_Util.Operation_Kinds;
    q.Option_Field('operation_kind_name', 'operation_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('estimation_formula',
                'select ot.estimation_formula
                   from hpr_oper_types ot
                  where ot.company_id = :company_id
                    and ot.oper_type_id = $oper_type_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hpr_Charges
       set Company_Id   = null,
           Filial_Id    = null,
           Charge_Id    = null,
           Interval_Id  = null,
           Begin_Date   = null,
           End_Date     = null,
           Oper_Type_Id = null,
           Amount       = null,
           Division_Id  = null,
           Schedule_Id  = null,
           Currency_Id  = null,
           Job_Id       = null,
           Rank_Id      = null,
           Robot_Id     = null,
           Status       = null;
    update Hpd_Lock_Intervals
       set Company_Id  = null,
           Filial_Id   = null,
           Interval_Id = null,
           Staff_Id    = null,
           Begin_Date  = null,
           End_Date    = null,
           Kind        = null;
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null;
    update Hpr_Oper_Types
       set Company_Id         = null,
           Oper_Type_Id       = null,
           Estimation_Formula = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
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
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Href_Staffs
       set Company_Id   = null,
           Filial_Id    = null,
           Staff_Id     = null,
           Staff_Number = null,
           Employee_Id  = null,
           State        = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Mr_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Tin        = null;
    update Hpr_Oper_Groups
       set Company_Id    = null,
           Oper_Group_Id = null,
           name          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
  end;

end Ui_Vhr177;
/
