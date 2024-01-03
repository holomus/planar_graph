create or replace package Ui_Vhr623 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Overtime_Day_Audits(p Hashmap) return Fazo_Query;
end Ui_Vhr623;
/
create or replace package body Ui_Vhr623 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*                         
                       from x_hpd_journal_overtimes q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.journal_id = :journal_id',
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
                   'journal_id',
                   'employee_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp', 'begin_date', 'end_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'employee_id',
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
  Function Query_Overtime_Day_Audits(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.employee_id
                       from x_hpd_overtime_days q
                       join x_hpd_journal_overtimes w
                         on w.t_company_id = q.t_company_id
                        and w.t_filial_id = q.t_filial_id 
                        and w.journal_id = :journal_id
                        and w.overtime_id = q.overtime_id
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id',
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
                   'journal_id',
                   'employee_id',
                   'overtime_seconds');
    q.Varchar2_Field('t_event', 't_source_project_code', 'note');
    q.Date_Field('t_date', 't_timestamp', 'overtime_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'employee_id',
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
    update x_Hpd_Journal_Overtimes
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Journal_Id            = null,
           Employee_Id           = null,
           Begin_Date            = null,
           End_Date              = null;
    update x_Hpd_Overtime_Days
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Overtime_Date         = null,
           Overtime_Seconds      = null,
           Overtime_Id           = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
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
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr623;
/
