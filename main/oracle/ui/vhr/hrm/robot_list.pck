create or replace package Ui_Vhr252 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Position_Org_Structure(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Closed_Date(p Hashmap);
end Ui_Vhr252;
/
create or replace package body Ui_Vhr252 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query                     varchar(32767);
    v_Params                    Hashmap;
    v_Matrix                    Matrix_Varchar2;
    q                           Fazo_Query;
    v_Division_Id               number := p.o_Number('division_id');
    v_User_Access_All_Employees varchar(1) := Uit_Href.User_Access_All_Employees;
  begin
    v_Query := 'select r.name,
                       r.code,
                       r.robot_group_id,
                       r.state,
                       r.division_id,
                       r.job_id,
                       r.person_id,
                       r.company_id,
                       r.filial_id,
                       r.robot_id,
                       r.opened_date,
                       r.closed_date,
                       r.schedule_id,
                       r.rank_id,
                       r.labor_function_id,
                       r.description,
                       r.hiring_condition,
                       r.org_unit_id,
                       r.position_employment_kind,
                       case
                           when r.access_to_hidden_salary_job = ''Y'' then
                            r.contractual_wage
                           else
                            ''Y''
                       end as contractual_wage,
                       case
                           when r.access_to_hidden_salary_job = ''Y'' then
                            r.wage_scale_id
                           else
                            null
                       end as wage_scale_id,
                       case
                           when r.access_to_hidden_salary_job = ''Y'' then
                           hrm_util.get_robot_wage(:company_id, :filial_id, r.robot_id, r.contractual_wage, r.wage_scale_id, r.rank_id)
                           else
                           -1
                       end as wage,
                        case
                           when r.staff_count = 1 then
                            case
                              when (r.access_to_hidden_salary_job = ''Y'' or :user_id = st.employee_id) then
                               hpd_util.get_closest_wage(:company_id, :filial_id, st.staff_id, nvl(st.dismissal_date, :period))
                              else
                               -1
                            end
                           else
                            null
                       end as staff_wage,
                       case
                         when r.access_to_hidden_salary_job = ''Y'' then 
                           r.currency_id
                           else null
                        end as currency_id,
                       case
                           when r.staff_count = 1 then
                            st.rank_id
                           else
                            null
                       end as staff_rank_id,
                       r.created_by,
                       r.created_on,
                       r.modified_by,
                       r.modified_on,
                       (select case
                                 when dm.manager_id <> r.robot_id then
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
                           and dm.division_id = r.org_unit_id) manager_id,
                       r.fte,
                       r.planned_fte,
                       r.application_id,
                       r.joining_date
                  from (select r.*,
                               w.name,
                               w.code,
                               w.robot_group_id,
                               w.state,
                               w.division_id,
                               w.job_id,
                               w.person_id,
                               nvl((select min(fte)
                                     from hrm_robot_turnover rob
                                    where rob.company_id = w.company_id
                                      and rob.filial_id = w.filial_id
                                      and rob.robot_id = w.robot_id
                                      and (rob.period >= :period or
                                          rob.period = (select max(rt.period)
                                                           from hrm_robot_turnover rt
                                                          where rt.company_id = rob.company_id
                                                            and rt.filial_id = rob.filial_id
                                                            and rt.robot_id = rob.robot_id
                                                            and rt.period <= :period))),
                                   0) fte,
                                   (select rt.fte
                                      from hrm_robot_transactions rt
                                     where rt.company_id = :company_id
                                       and rt.filial_id = :filial_id
                                       and rt.robot_id = w.robot_id
                                       and rt.fte_kind = :fte_kind
                                       and rt.fte > 0
                                       and rt.trans_date = (select max(b.trans_date)
                                                              from hrm_robot_transactions b
                                                             where b.company_id = rt.company_id
                                                               and b.filial_id = rt.filial_id
                                                               and b.robot_id = rt.robot_id
                                                               and b.fte_kind = :fte_kind
                                                               and b.fte > 0
                                                               and b.trans_date <= :period)) planned_fte,
                               (select k.application_id
                                  from hpd_application_robots k
                                 where k.company_id = w.company_id
                                   and k.filial_id = w.filial_id
                                   and k.robot_id = w.robot_id) application_id,
                               (select count(*)
                                  from mrf_robot_persons rp 
                                 where rp.company_id = :company_id
                                   and rp.filial_id = :filial_id
                                   and rp.robot_id = w.robot_id) staff_count,
                               uit_hrm.access_to_hidden_salary_job(i_job_id => w.job_id) access_to_hidden_salary_job,
                               (select min(period)
                                  from (select max(q.period) as period
                                          from hpd_agreements q
                                         where q.company_id = :company_id 
                                           and q.filial_id = :filial_id
                                           and q.staff_id in (select st.staff_id
                                                                from href_staffs st
                                                               where st.company_id = :company_id
                                                                 and st.filial_id = :filial_id
                                                                 and st.hiring_date <= :period
                                                                 and (st.dismissal_date is null or st.dismissal_date >= :period)
                                                                 and st.state = ''A''
                                                                 and st.robot_id = w.robot_id)
                                           and q.trans_type = :robot_trans_type
                                           and q.period <= :period
                                           and exists (select 1 
                                                  from hpd_trans_robots tr
                                                 where tr.company_id = q.company_id
                                                   and tr.filial_id = q.filial_id
                                                   and tr.trans_id = q.trans_id
                                                   and tr.robot_id = w.robot_id)
                                         group by q.staff_id)) as joining_date 
                          from mrf_robots w
                          join hrm_robots r
                            on r.company_id = w.company_id
                           and r.filial_id = w.filial_id
                           and r.robot_id = w.robot_id
                         where w.company_id = :company_id
                           and w.filial_id = :filial_id
                           and (:division_id is null or w.division_id = :division_id)) r
                   left join href_staffs st
                     on st.company_id = :company_id
                    and st.filial_id = :filial_id
                    and st.employee_id = r.person_id
                    and st.robot_id = r.robot_id
                    and st.state = ''A''
                    and st.hiring_date <= :period
                    and (st.dismissal_date is null or st.dismissal_date >= :period)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'division_id',
                             v_Division_Id,
                             'period',
                             Nvl(p.o_Date('period'), Trunc(sysdate)),
                             'user_access_all_employees',
                             v_User_Access_All_Employees,
                             'fte_kind',
                             Hrm_Pref.c_Fte_Kind_Planed);
  
    v_Params.Put('user_id', Ui.User_Id);
    v_Params.Put('robot_trans_type', Hpd_Pref.c_Transaction_Type_Robot);
  
    if v_User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' where r.org_unit_id in (select * from table(:division_ids))';
    
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    else
      v_Params.Put('division_ids', Array_Number());
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('robot_id',
                   'robot_group_id',
                   'division_id',
                   'job_id',
                   'manager_id',
                   'person_id',
                   'schedule_id',
                   'rank_id',
                   'labor_function_id',
                   'application_id');
    q.Number_Field('wage_scale_id',
                   'fte',
                   'planned_fte',
                   'org_unit_id',
                   'staff_wage',
                   'staff_rank_id',
                   'currency_id',
                   'created_by',
                   'modified_by',
                   'wage');
    q.Varchar2_Field('name',
                     'code',
                     'state',
                     'description',
                     'hiring_condition',
                     'contractual_wage',
                     'fte_kind',
                     'position_employment_kind');
    q.Date_Field('opened_date', 'closed_date', 'joining_date', 'created_on', 'modified_on');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('contractual_wage_name',
                   'contractual_wage',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Hrm_Util.Position_Employments;
  
    q.Option_Field('position_employment_kind_name',
                   'position_employment_kind',
                   v_Matrix(1),
                   v_Matrix(2));
  
    q.Refer_Field('robot_group_name',
                  'robot_group_id',
                  'mr_robot_groups',
                  'robot_group_id',
                  'name',
                  'select *
                     from mr_robot_groups r
                    where r.company_id = :company_id');
  
    v_Query := Uit_Hrm.Departments_Query;
  
    if v_Division_Id is not null then
      v_Query := 'select qr.* from (' || v_Query || ') qr where qr.division_id = :division_id ';
    end if;
  
    if v_User_Access_All_Employees = 'N' then
      v_Query := 'select rq.* from (' || v_Query ||
                 ') rq where rq.division_id member of :division_ids ';
    end if;
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  v_Query);
  
    v_Query := Uit_Hrm.Divisions_Query(i_Only_Departments => false);
  
    if v_Division_Id is not null then
      v_Query := 'select qr.* from (' || v_Query || ') qr where qr.division_id = :division_id ';
    end if;
  
    if v_User_Access_All_Employees = 'N' then
      v_Query := 'select rq.* from (' || v_Query ||
                 ') rq where rq.division_id member of :division_ids ';
    end if;
  
    q.Refer_Field('org_unit_name',
                  'org_unit_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  v_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select *
                     from mrf_robots r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('staff_rank_name',
                  'staff_rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('labor_function_name',
                  'labor_function_id',
                  'href_labor_functions',
                  'labor_function_id',
                  'name',
                  'select *
                     from href_labor_functions r
                    where r.company_id = :company_id');
    q.Refer_Field('wage_scale_name',
                  'wage_scale_id',
                  'hrm_wage_scales',
                  'wage_scale_id',
                  'name',
                  'select *
                     from hrm_wage_scales r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies r
                    where r.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
  
    q.Multi_Number_Field('employee_ids',
                         'select q.person_id,
                                 q.robot_id 
                            from mrf_robot_persons q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id',
                         '@robot_id = $robot_id',
                         'person_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select q.* 
                     from mr_natural_persons q
                    where q.company_id = :company_id
                      and exists (select 1
                             from mrf_robot_persons rp
                            where rp.company_id = :company_id
                              and rp.filial_id = :filial_id
                              and rp.person_id = q.person_id)');
  
    q.Refer_Field('application_number',
                  'application_id',
                  'hpd_applications',
                  'application_id',
                  'application_number',
                  'select *
                     from hpd_applications t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Multi_Number_Field('oper_type_ids',
                         'select w.oper_type_id, w.robot_id
                            from hrm_robot_oper_types w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id',
                         '@robot_id = $robot_id',
                         'oper_type_id');
    q.Refer_Field('oper_type_names',
                  'oper_type_ids',
                  'mpr_oper_types',
                  'oper_type_id',
                  'name',
                  'select w.* 
                     from mpr_oper_types w
                    where w.company_id = :company_id');
  
    q.Map_Field('application_id2', '$application_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs w
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and w.state = ''A''
                        and (w.c_divisions_exist = ''N'' 
                         or exists (select 1
                               from mhr_job_divisions r
                              where r.company_id = :company_id
                                and r.filial_id = :filial_id
                                and r.job_id = w.job_id
                                and r.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.r_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Exists   varchar2(1);
    r_Settings Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id);
    result     Hashmap;
  begin
    begin
      select 'Y'
        into v_Exists
        from Mrf_Robots q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and not exists (select 1
                from Hrm_Robots w
               where w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Robot_Id = q.Robot_Id)
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Exists := 'N';
    end;
  
    result := Fazo.Zip_Map('migr_robot_exists',
                           v_Exists,
                           'position_fixing_enabled',
                           r_Settings.Position_Fixing);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Robot_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('robot_id'));
  begin
    for i in 1 .. v_Robot_Ids.Count
    loop
      Hrm_Api.Robot_Delete(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Robot_Id   => v_Robot_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Position_Org_Structure(p Hashmap) is
  begin
    Hrm_Api.Fix_Robot_Org_Structure(i_Company_Id      => Ui.Company_Id,
                                    i_Filial_Id       => Ui.Filial_Id,
                                    i_Robot_Id        => p.r_Number('robot_id'),
                                    i_New_Division_Id => p.o_Number('division_id'),
                                    i_New_Job_Id      => p.o_Number('job_id'),
                                    i_New_Robot_Name  => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Closed_Date(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Closed_Date date := p.r_Date('closed_date');
    v_Robot_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('robot_id'));
  begin
    for i in 1 .. v_Robot_Ids.Count
    loop
      Hrm_Api.Set_Closed_Date_To_Robot(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Robot_Id    => v_Robot_Ids(i),
                                       i_Closed_Date => v_Closed_Date);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Mrf_Robots
       set name           = null,
           Code           = null,
           Robot_Group_Id = null,
           State          = null,
           Division_Id    = null,
           Job_Id         = null,
           Manager_Id     = null,
           Person_Id      = null;
    update Hrm_Robots
       set Company_Id               = null,
           Filial_Id                = null,
           Robot_Id                 = null,
           Org_Unit_Id              = null,
           Opened_Date              = null,
           Closed_Date              = null,
           Schedule_Id              = null,
           Rank_Id                  = null,
           Labor_Function_Id        = null,
           Description              = null,
           Position_Employment_Kind = null,
           Hiring_Condition         = null,
           Contractual_Wage         = null,
           Wage_Scale_Id            = null,
           Currency_Id              = null,
           Created_By               = null,
           Created_On               = null,
           Modified_By              = null,
           Modified_On              = null;
    update Hrm_Hidden_Salary_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null;
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
    update Mhr_Parent_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Parent_Id   = null,
           Lvl         = null;
    update Mr_Robot_Groups
       set Company_Id     = null,
           Robot_Group_Id = null,
           name           = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Href_Labor_Functions
       set Company_Id        = null,
           Labor_Function_Id = null,
           name              = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mrf_Robot_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Person_Id  = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hpd_Applications
       set Company_Id         = null,
           Filial_Id          = null,
           Application_Id     = null,
           Application_Number = null;
    update Hpd_Application_Robots
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Robot_Id       = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Hrm_Robot_Transactions
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Trans_Date = null,
           Fte_Kind   = null,
           Fte        = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Employee_Id    = null,
           Robot_Id       = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Job_Id         = null,
           State          = null;
    update Hrm_Robot_Oper_Types
       set Company_Id   = null,
           Filial_Id    = null,
           Robot_Id     = null,
           Oper_Type_Id = null;
    update Mpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null,
           name         = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Hrm_Robot_Transactions
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Trans_Date = null,
           Fte_Kind   = null,
           Fte        = null;
    update Hpd_Agreements
       set Company_Id = null,
           Filial_Id  = null,
           Staff_Id   = null,
           Trans_Type = null,
           Period     = null,
           Trans_Id   = null;
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(null, null));
    Uie.x(Hrm_Util.Get_Robot_Wage(i_Company_Id       => null,
                                  i_Filial_Id        => null,
                                  i_Robot_Id         => null,
                                  i_Contractual_Wage => null,
                                  i_Wage_Scale_Id    => null,
                                  i_Rank_Id          => null));
  
    Uie.x(Hpd_Util.Get_Closest_Wage(i_Company_Id => null,
                                    i_Filial_Id  => null,
                                    i_Staff_Id   => null,
                                    i_Period     => null));
  end;

end Ui_Vhr252;
/
