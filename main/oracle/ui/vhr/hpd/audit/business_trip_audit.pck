create or replace package Ui_Vhr201 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Business_Trip_Regions(p Hashmap) return Fazo_Query;
end Ui_Vhr201;
/
create or replace package body Ui_Vhr201 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_business_trips q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                       and exists (select 1
                              from x_hpd_journal_timeoffs w
                             where w.t_company_id = q.t_company_id
                               and w.t_filial_id = q.t_filial_id 
                               and w.timeoff_id = q.timeoff_id
                               and w.journal_id = :journal_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'timeoff_id',
                   'person_id',
                   'reason_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'note');
    q.Date_Field('t_date', 't_timestamp');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('person_name',
                  'person_id',
                  'md_persons',
                  'person_id',
                  'name',
                  'select *
                     from md_persons s 
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees f
                            where f.company_id = s.company_id
                              and f.filial_id = :filial_id
                              and f.employee_id = s.person_id)');
    q.Refer_Field('reason_name',
                  'reason_id',
                  'href_sick_leave_reasons',
                  'reason_id',
                  'name',
                  'select *
                     from href_sick_leave_reasons s 
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Business_Trip_Regions(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_business_trip_regions q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                       and exists (select 1
                              from x_hpd_journal_timeoffs w
                             where w.t_company_id = q.t_company_id
                               and w.t_filial_id = q.t_filial_id 
                               and w.timeoff_id = q.timeoff_id
                               and w.journal_id = :journal_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'timeoff_id',
                   'region_id',
                   'order_no');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Business_Trips
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Person_Id             = null,
           Reason_Id             = null,
           Note                  = null,
           t_Filial_Id           = null,
           Timeoff_Id            = null;
    update x_Hpd_Journal_Timeoffs
       set t_Company_Id = null,
           t_Filial_Id  = null,
           Timeoff_Id   = null,
           Journal_Id   = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Href_Sick_Leave_Reasons
       set Company_Id = null,
           Filial_Id  = null,
           Reason_Id  = null,
           name       = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update x_Hpd_Business_Trip_Regions
       set t_Company_Id          = null,
           t_Filial_Id           = null,
           t_Audit_Id            = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Timeoff_Id            = null,
           Region_Id             = null,
           Order_No              = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr201;
/
