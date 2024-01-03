create or replace package Ui_Vhr205 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
end Ui_Vhr205;
/
create or replace package body Ui_Vhr205 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hper_staff_plan_parts q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.staff_plan_id = :staff_plan_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'staff_plan_id',
                                 p.r_Number('staff_plan_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'staff_plan_id',
                   'plan_type_id',
                   'amount');
    q.Varchar2_Field('t_event', 't_source_project_code', 'note');
    q.Date_Field('t_date', 't_timestamp', 'part_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('plan_type_name',
                  'plan_type_id',
                  'hper_plan_types',
                  'plan_type_id',
                  'name',
                  'select *
                     from hper_plan_types s
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
  Procedure Validation is
  begin
    update x_Hper_Staff_Plan_Parts
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Staff_Plan_Id         = null,
           Plan_Type_Id          = null,
           Part_Date             = null,
           Amount                = null,
           Note                  = null;
    update Hper_Plan_Types
       set Company_Id   = null,
           Filial_Id    = null,
           Plan_Type_Id = null,
           name         = null;
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

end Ui_Vhr205;
/