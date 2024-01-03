create or replace package Ui_Vhr273 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
end Ui_Vhr273;
/
create or replace package body Ui_Vhr273 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_vacation_limit_changes q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.journal_id = :journal_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_company_id',
                   't_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_session_id',
                   't_context_id',
                   'division_id',
                   'days_limit',
                   'journal_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 'change_date', 't_timestamp');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
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
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Vacation_Limit_Changes
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
           Division_Id           = null,
           Change_Date           = null,
           Days_Limit            = null;
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
    update Md_Company_Projects
       set Project_Code = null,
           Company_Id   = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr273;
/
