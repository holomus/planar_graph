create or replace package Ui_Vhr663 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Main_Robot_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Extra_Robot_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Roles_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Divisions_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Oper_Types_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Indicators_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Vacation_Limit_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Job_Groups_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr663;
/
create or replace package body Ui_Vhr663 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR663:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Main_Robot_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_mrf_robots t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id'),
                                 'pk_natural',
                                 Md_Pref.c_Pk_Natural));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'person_id',
                   'robot_group_id',
                   'division_id',
                   'job_id',
                   'manager_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'name', 'code', 'state');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('person_name',
                  'person_id',
                  'md_persons',
                  'person_id',
                  'name',
                  'select * 
                     from md_persons k 
                    where k.company_id = :company_id
                      and k.person_kind = :pk_natural
                      and k.state = ''A''
                      and exists (select 1
                             from mrf_persons r
                            where r.company_id = k.company_id
                              and r.filial_id = :filial_id
                              and r.person_id = k.person_id)');
    q.Refer_Field('robot_group_name',
                  'robot_group_id',
                  'mr_robot_groups',
                  'robot_group_id',
                  'name',
                  'select *
                     from mr_robot_groups s
                    where s.company_id = :company_id');
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select *
                     from mrf_robots s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Extra_Robot_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robots t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'org_unit_id',
                   'schedule_id',
                   'rank_id',
                   'labor_function_id',
                   'wage_scale_id');
    q.Number_Field('currency_id');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'description',
                     'hiring_condition',
                     'contractual_wage',
                     'access_hidden_salary',
                     'position_employment_kind');
    q.Date_Field('t_timestamp', 't_date', 'opened_date', 'closed_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('org_unit_name',
                  'org_unit_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('labor_function_name',
                  'labor_function_id',
                  'href_labor_functions',
                  'labor_function_id',
                  'name',
                  'select *
                     from href_labor_functions s
                    where s.company_id = :company_id');
    q.Refer_Field('wage_scale_name',
                  'wage_scale_id',
                  'hrm_wage_scales',
                  'wage_scale_id',
                  'name',
                  'select *
                     from hrm_wage_scales s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Roles_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_mrf_robot_roles t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id', 't_filial_id', 't_user_id', 't_context_id', 'robot_id', 'role_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('role_name',
                  'role_id',
                  'md_roles',
                  'role_id',
                  'name',
                  'select *
                     from md_roles s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Divisions_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robot_divisions t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'division_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'access_type');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    q.Option_Field('access_type_name',
                   'access_type',
                   Array_Varchar2(Hrm_Pref.c_Access_Type_Structural, Hrm_Pref.c_Access_Type_Manual),
                   Array_Varchar2(t('access_type:structual'), t('access_type:manual')));
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Oper_Types_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robot_oper_types t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'oper_type_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('oper_type_name',
                  'oper_type_id',
                  'mpr_oper_types',
                  'oper_type_id',
                  'name',
                  'select *
                     from mpr_oper_types s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Indicators_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robot_indicators t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'indicator_id',
                   'indicator_value');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('indicator_name',
                  'indicator_id',
                  'href_indicators',
                  'indicator_id',
                  'name',
                  'select *
                     from href_indicators s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Vacation_Limit_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robot_vacation_limits t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'days_limit');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robot_Job_Groups_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select t.*
                       from x_hrm_robot_hidden_salary_job_groups t
                      where t.t_company_id = :company_id
                        and t.t_filial_id = :filial_id
                        and t.robot_id = :robot_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'robot_id',
                                 p.r_Number('robot_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'robot_id',
                   'job_group_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('job_group_name',
                  'job_group_id',
                  'mhr_job_groups',
                  'job_group_id',
                  'name',
                  'select *
                     from mhr_job_groups s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w',
                  'project_code',
                  'project_name',
                  'select w.project_code,
                          ui_kernel.project_name(w.project_code) project_name
                     from md_projects w
                    where w.visible = ''Y''
                      and (exists (select 1
                                     from md_company_projects s
                                    where s.company_id = :company_id
                                      and s.project_code = w.project_code))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Allowed_Division_Names(i_Robot_Id number) return Hashmap is
    v_Names varchar2(32000);
    result  Hashmap := Hashmap();
  begin
    select Listagg((select w.Name
                     from Mhr_Divisions w
                    where w.Company_Id = q.Company_Id
                      and w.Filial_Id = q.Filial_Id
                      and w.Division_Id = q.Division_Id),
                   ', ')
      into v_Names
      from Hrm_Robot_Divisions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Robot_Id = i_Robot_Id;
  
    Result.Put('allowed_division_names', v_Names);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Role_Names(i_Robot_Id number) return Hashmap is
    v_Names varchar2(32000);
    result  Hashmap := Hashmap();
  begin
    select Listagg((select w.Name
                     from Md_Roles w
                    where w.Company_Id = q.Company_Id
                      and w.Role_Id = q.Role_Id),
                   ', ')
      into v_Names
      from Mrf_Robot_Roles q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Robot_Id = i_Robot_Id;
  
    Result.Put('role_names', v_Names);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Job_Group_Names
  (
    i_Robot_Id             number,
    i_Access_Hidden_Salary varchar2
  ) return Hashmap is
    v_Names varchar2(32000);
    result  Hashmap := Hashmap();
  begin
    if i_Access_Hidden_Salary = 'N' then
      select Listagg((select w.Name
                       from Mhr_Job_Groups w
                      where w.Company_Id = q.Company_Id
                        and w.Job_Group_Id = q.Job_Group_Id),
                     ', ')
        into v_Names
        from Hrm_Robot_Hidden_Salary_Job_Groups q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('access_salary_job_group_names', v_Names);
    else
      Result.Put('access_salary_job_group_names', t('all'));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Oper_Types
  (
    i_Robot_Id          number,
    i_Access_Salary_Job varchar2
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    if i_Access_Salary_Job = 'Y' then
      select Array_Varchar2(q.Oper_Type_Id,
                            (select w.Name
                               from Mpr_Oper_Types w
                              where w.Company_Id = q.Company_Id
                                and w.Oper_Type_Id = q.Oper_Type_Id))
        bulk collect
        into v_Matrix
        from Hrm_Robot_Oper_Types q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id,
                            (select w.Name
                               from Href_Indicators w
                              where w.Company_Id = q.Company_Id
                                and w.Indicator_Id = q.Indicator_Id),
                            (select w.Indicator_Value
                               from Hrm_Robot_Indicators w
                              where w.Company_Id = q.Company_Id
                                and w.Filial_Id = q.Filial_Id
                                and w.Robot_Id = q.Robot_Id
                                and w.Indicator_Id = q.Indicator_Id))
        bulk collect
        into v_Matrix
        from Hrm_Oper_Type_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Person_Names(i_Robot_Id number) return Hashmap is
    v_Names varchar2(32000);
    result  Hashmap := Hashmap();
  begin
    select Listagg(q.Name, ', ')
      into v_Names
      from Mr_Natural_Persons q
     where q.Company_Id = Ui.Company_Id
       and exists (select 1
              from Mrf_Robot_Persons Rp
             where Rp.Company_Id = Ui.Company_Id
               and Rp.Filial_Id = Ui.Filial_Id
               and Rp.Robot_Id = i_Robot_Id
               and Rp.Person_Id = q.Person_Id);
  
    Result.Put('person_names', v_Names);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Staff_Info
  (
    i_Robot_Id          number,
    i_Access_Salary_Job varchar2
  ) return Hashmap is
    v_Date       date := Trunc(sysdate);
    v_Count      number;
    v_Staff_Wage number;
    v_Rank_Name  varchar2(200);
  begin
    select count(*)
      into v_Count
      from Mrf_Robot_Persons Rp
     where Rp.Company_Id = Ui.Company_Id
       and Rp.Filial_Id = Ui.Filial_Id
       and Rp.Robot_Id = i_Robot_Id;
  
    if v_Count <> 1 then
      return Fazo.Zip_Map('staff_wage', null, 'staff_rank_name', null);
    end if;
  
    select case
             when i_Access_Salary_Job = 'Y' or Ui.User_Id = q.Employee_Id then
              Hpd_Util.Get_Closest_Wage(i_Company_Id => q.Company_Id,
                                        i_Filial_Id  => q.Filial_Id,
                                        i_Staff_Id   => q.Staff_Id,
                                        i_Period     => v_Date)
             else
              null
           end,
           (select r.Name
              from Mhr_Ranks r
             where r.Company_Id = q.Company_Id
               and r.Filial_Id = q.Filial_Id
               and r.Rank_Id = q.Rank_Id)
      into v_Staff_Wage, v_Rank_Name
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Employee_Id = (select w.Person_Id
                              from Mrf_Robot_Persons w
                             where w.Company_Id = q.Company_Id
                               and w.Filial_Id = q.Filial_Id
                               and w.Robot_Id = i_Robot_Id)
       and q.Robot_Id = i_Robot_Id
       and q.State = 'A'
       and q.Hiring_Date <= v_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date);
  
    return Fazo.Zip_Map('staff_wage', v_Staff_Wage, 'staff_rank_name', v_Rank_Name);
  
  exception
    when No_Data_Found then
      return Fazo.Zip_Map('staff_wage', null, 'staff_rank_name', null);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Mrf_Robot          Mrf_Robots%rowtype;
    r_Hrm_Robot          Hrm_Robots%rowtype;
    v_Manager_Name       varchar2(700);
    v_Application_Number varchar2(100);
    v_Fte                number;
    v_Access_Salary_Job  varchar2(1);
    v_Date               date := Trunc(sysdate);
    result               Hashmap;
  begin
    r_Mrf_Robot := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Robot_Id   => p.r_Number('robot_id'));
  
    r_Hrm_Robot := z_Hrm_Robots.Load(i_Company_Id => r_Mrf_Robot.Company_Id,
                                     i_Filial_Id  => r_Mrf_Robot.Filial_Id,
                                     i_Robot_Id   => r_Mrf_Robot.Robot_Id);
  
    Uit_Href.Assert_Access_To_Division(r_Mrf_Robot.Division_Id);
  
    v_Access_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(r_Mrf_Robot.Job_Id);
  
    result := z_Mrf_Robots.To_Map(r_Mrf_Robot, z.Robot_Id, z.Name, z.State, z.Code);
  
    Result.Put_All(z_Hrm_Robots.To_Map(r_Hrm_Robot,
                                       z.Opened_Date,
                                       z.Closed_Date,
                                       z.Description,
                                       z.Hiring_Condition,
                                       z.Contractual_Wage,
                                       z.Created_On,
                                       z.Modified_On));
  
    Result.Put('access_salary_job', v_Access_Salary_Job);
    Result.Put('robot_group_name',
               z_Mr_Robot_Groups.Take(i_Company_Id => r_Mrf_Robot.Company_Id, --
               i_Robot_Group_Id => r_Mrf_Robot.Robot_Group_Id).Name);
  
    if r_Mrf_Robot.Division_Id <> r_Hrm_Robot.Org_Unit_Id then
      Result.Put('division_name',
                 z_Mhr_Divisions.Take(i_Company_Id => r_Mrf_Robot.Company_Id, --
                 i_Filial_Id => r_Mrf_Robot.Filial_Id, --
                 i_Division_Id => r_Mrf_Robot.Division_Id).Name);
    end if;
  
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Mrf_Robot.Company_Id, --
               i_Filial_Id => r_Mrf_Robot.Filial_Id, --
               i_Job_Id => r_Mrf_Robot.Job_Id).Name);
    Result.Put('org_unit_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
               i_Filial_Id => r_Hrm_Robot.Filial_Id, --
               i_Division_Id => r_Hrm_Robot.Org_Unit_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
               i_Filial_Id => r_Hrm_Robot.Filial_Id, -- 
               i_Schedule_Id => r_Hrm_Robot.Schedule_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
               i_Filial_Id => r_Hrm_Robot.Filial_Id, -- 
               i_Rank_Id => r_Hrm_Robot.Rank_Id).Name);
    Result.Put('labor_function_name',
               z_Href_Labor_Functions.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
               i_Labor_Function_Id => r_Hrm_Robot.Labor_Function_Id).Name);
    Result.Put('contractual_wage_name',
               Md_Util.Decode(r_Hrm_Robot.Contractual_Wage, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('position_employment_kind_name',
               Hrm_Util.t_Position_Employment(r_Hrm_Robot.Position_Employment_Kind));
    Result.Put('vacation_limit',
               z_Hrm_Robot_Vacation_Limits.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
               i_Filial_Id => r_Hrm_Robot.Filial_Id, -- 
               i_Robot_Id => r_Hrm_Robot.Robot_Id).Days_Limit);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Hrm_Robot.Company_Id, i_User_Id => r_Hrm_Robot.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Hrm_Robot.Company_Id, i_User_Id => r_Hrm_Robot.Modified_By).Name);
  
    if v_Access_Salary_Job = 'Y' then
      Result.Put('wage_scale_name',
                 z_Hrm_Wage_Scales.Take(i_Company_Id => r_Hrm_Robot.Company_Id, --
                 i_Filial_Id => r_Hrm_Robot.Filial_Id, --
                 i_Wage_Scale_Id => r_Hrm_Robot.Wage_Scale_Id).Name);
      Result.Put('currency_name',
                 z_Mk_Currencies.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Currency_Id => r_Hrm_Robot.Currency_Id).Name);
    end if;
  
    -- Oper types
    Result.Put_All(Get_Oper_Types(i_Robot_Id          => r_Hrm_Robot.Robot_Id,
                                  i_Access_Salary_Job => v_Access_Salary_Job));
  
    -- Job Group Names
    Result.Put_All(Job_Group_Names(i_Robot_Id             => r_Hrm_Robot.Robot_Id,
                                   i_Access_Hidden_Salary => r_Hrm_Robot.Access_Hidden_Salary));
  
    -- Role Names 
    Result.Put_All(Role_Names(r_Hrm_Robot.Robot_Id));
  
    -- allow divisions
    Result.Put_All(Allowed_Division_Names(r_Hrm_Robot.Robot_Id));
  
    -- Person Names
    Result.Put_All(Person_Names(r_Hrm_Robot.Robot_Id));
  
    -- Staff Info
    Result.Put_All(Staff_Info(r_Hrm_Robot.Robot_Id, v_Access_Salary_Job));
  
    -- manager name 
    begin
      select (select w.Name
                from Mrf_Robots w
               where w.Company_Id = r_Hrm_Robot.Company_Id
                 and w.Filial_Id = r_Hrm_Robot.Filial_Id
                 and w.Robot_Id = case
                       when Dm.Manager_Id <> r_Hrm_Robot.Robot_Id then
                        Dm.Manager_Id
                       else
                        (select Md.Manager_Id
                           from Mhr_Parent_Divisions Pd
                           join Mrf_Division_Managers Md
                             on Md.Company_Id = Pd.Company_Id
                            and Md.Filial_Id = Pd.Filial_Id
                            and Md.Division_Id = Pd.Parent_Id
                          where Pd.Company_Id = Dm.Company_Id
                            and Pd.Filial_Id = Dm.Filial_Id
                            and Pd.Division_Id = Dm.Division_Id
                            and Pd.Lvl = 1)
                     end)
        into v_Manager_Name
        from Mrf_Division_Managers Dm
       where Dm.Company_Id = r_Hrm_Robot.Company_Id
         and Dm.Filial_Id = r_Hrm_Robot.Filial_Id
         and Dm.Division_Id = r_Hrm_Robot.Org_Unit_Id;
    
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('manager_name', v_Manager_Name);
  
    -- planned fte 
    begin
      select Rt.Fte
        into v_Fte
        from Hrm_Robot_Transactions Rt
       where Rt.Company_Id = r_Hrm_Robot.Company_Id
         and Rt.Filial_Id = r_Hrm_Robot.Filial_Id
         and Rt.Robot_Id = r_Hrm_Robot.Robot_Id
         and Rt.Fte_Kind = Hrm_Pref.c_Fte_Kind_Planed
         and Rt.Fte > 0
         and Rt.Trans_Date = (select max(b.Trans_Date)
                                from Hrm_Robot_Transactions b
                               where b.Company_Id = Rt.Company_Id
                                 and b.Filial_Id = Rt.Filial_Id
                                 and b.Robot_Id = Rt.Robot_Id
                                 and b.Fte_Kind = Hrm_Pref.c_Fte_Kind_Planed
                                 and b.Fte > 0
                                 and b.Trans_Date <= v_Date);
    
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('planned_fte', v_Fte);
  
    begin
      select min(Fte)
        into v_Fte
        from Hrm_Robot_Turnover Rob
       where Rob.Company_Id = r_Hrm_Robot.Company_Id
         and Rob.Filial_Id = r_Hrm_Robot.Filial_Id
         and Rob.Robot_Id = r_Hrm_Robot.Robot_Id
         and (Rob.Period >= v_Date or
             Rob.Period = (select max(Rt.Period)
                              from Hrm_Robot_Turnover Rt
                             where Rt.Company_Id = Rob.Company_Id
                               and Rt.Filial_Id = Rob.Filial_Id
                               and Rt.Robot_Id = Rob.Robot_Id
                               and Rt.Period <= v_Date));
    
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('fte', Nvl(v_Fte, 0));
  
    begin
      select (select w.Application_Number
                from Hpd_Applications w
               where w.Company_Id = k.Company_Id
                 and w.Filial_Id = k.Filial_Id
                 and w.Application_Id = k.Application_Id)
        into v_Application_Number
        from Hpd_Application_Robots k
       where k.Company_Id = r_Hrm_Robot.Company_Id
         and k.Filial_Id = r_Hrm_Robot.Filial_Id
         and k.Robot_Id = r_Hrm_Robot.Robot_Id;
    
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('application_number', v_Application_Number);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Mrf_Robots
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Person_Id             = null,
           State                 = null,
           Code                  = null;
  
    update x_Hrm_Robots
       set t_Company_Id             = null,
           t_Audit_Id               = null,
           t_Filial_Id              = null,
           t_Event                  = null,
           t_Timestamp              = null,
           t_Date                   = null,
           t_User_Id                = null,
           t_Source_Project_Code    = null,
           t_Context_Id             = null,
           Robot_Id                 = null,
           Org_Unit_Id              = null,
           Opened_Date              = null,
           Closed_Date              = null,
           Schedule_Id              = null,
           Rank_Id                  = null,
           Labor_Function_Id        = null,
           Description              = null,
           Hiring_Condition         = null,
           Contractual_Wage         = null,
           Wage_Scale_Id            = null,
           Access_Hidden_Salary     = null,
           Position_Employment_Kind = null,
           Currency_Id              = null;
  
    update x_Mrf_Robot_Roles
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Role_Id               = null;
  
    update x_Hrm_Robot_Divisions
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Division_Id           = null,
           Access_Type           = null;
  
    update x_Hrm_Robot_Oper_Types
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Oper_Type_Id          = null;
  
    update x_Hrm_Robot_Indicators
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Indicator_Id          = null,
           Indicator_Value       = null;
  
    update x_Hrm_Robot_Vacation_Limits
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Days_Limit            = null;
  
    update x_Hrm_Robot_Hidden_Salary_Job_Groups
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Robot_Id              = null,
           Job_Group_Id          = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
  
    update Mr_Robot_Groups
       set Company_Id     = null,
           Robot_Group_Id = null,
           name           = null;
  
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
  
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    update Md_Persons
       set Company_Id  = null,
           Person_Id   = null,
           Person_Kind = null,
           name        = null;
  
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
  
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
  
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
  
    update Md_Roles
       set Company_Id = null,
           Role_Id    = null,
           name       = null;
  
    update Mpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null,
           name         = null;
  
    update Href_Indicators
       set Company_Id   = null,
           Indicator_Id = null,
           name         = null;
  
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr663;
/
