create or replace package Ui_Vhr202 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
end Ui_Vhr202;
/
create or replace package body Ui_Vhr202 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hper_staff_plans q
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
                   'staff_id',
                   'journal_page_id',
                   'division_id',
                   'job_id');
    q.Number_Field('rank_id',
                   'main_plan_amount',
                   'extra_plan_amount',
                   'main_fact_amount',
                   'extra_fact_amount',
                   'main_fact_percent',
                   'extra_fact_percent',
                   'c_main_fact_percent',
                   'c_extra_fact_percent');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'main_calc_type',
                     'extra_calc_type ',
                     'employment_type',
                     'status',
                     'note');
    q.Date_Field('t_date',
                 't_timestamp',
                 'plan_date',
                 'month_begin_date',
                 'month_end_date',
                 'begin_date',
                 'end_date');
  
    v_Matrix := Md_Util.Events;
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hper_Util.Staff_Plan_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpd_Util.Employment_Types;
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'staff_id',
                  'select q.staff_id,
                          (select s.name
                             from md_persons s
                            where s.company_id = q.company_id
                              and s.person_id = q.employee_id) name
                      from href_staffs q 
                     where q.company_id = :company_id
                       and q.filial_id = :filial_id',
                  'staff_id',
                  'name',
                  'select q.staff_id,
                          (select s.name
                             from md_persons s
                            where s.company_id = q.company_id
                              and s.person_id = q.employee_id) name
                     from href_staffs q 
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs s
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
    update x_Hper_Staff_Plans
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
           Staff_Id              = null,
           Plan_Date             = null,
           Main_Calc_Type        = null,
           Extra_Calc_Type       = null,
           Month_Begin_Date      = null,
           Month_End_Date        = null,
           Journal_Page_Id       = null,
           Division_Id           = null,
           Job_Id                = null,
           Rank_Id               = null,
           Employment_Type       = null,
           Begin_Date            = null,
           End_Date              = null,
           Main_Plan_Amount      = null,
           Extra_Plan_Amount     = null,
           Main_Fact_Amount      = null,
           Extra_Fact_Amount     = null,
           Main_Fact_Percent     = null,
           Extra_Fact_Percent    = null,
           c_Main_Fact_Percent   = null,
           c_Extra_Fact_Percent  = null,
           Status                = null,
           Note                  = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Staff_Id    = null;
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

end Ui_Vhr202;
/
