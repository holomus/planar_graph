create or replace package Ui_Vhr279 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr279;
/
create or replace package body Ui_Vhr279 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.template_id,
                            q.division_id,
                            q.job_id,
                            q.rank_id,
                            q.schedule_id,
                            q.vacation_days_limit,
                            case
                               when uit_hrm.access_to_hidden_salary_job(i_job_id => q.job_id) = ''Y'' then
                                q.wage_scale_id
                               else
                                null
                            end as wage_scale_id,
                            q.created_by,
                            q.created_on,
                            q.modified_by,
                            q.modified_on 
                       from hrm_job_templates q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('template_id',
                   'division_id',
                   'job_id',
                   'rank_id',
                   'schedule_id',
                   'vacation_days_limit',
                   'wage_scale_id',
                   'created_by',
                   'modified_by');
    q.Date_Field('created_on', 'modified_on');
  
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
                     from mhr_jobs r
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
    q.Refer_Field('wage_scale_name',
                  'wage_scale_id',
                  'hrm_wage_scales',
                  'wage_scale_id',
                  'name',
                  'select *
                     from hrm_wage_scales r
                    where r.company_id = :company_id
                      and r.filial_id = :filial_id');
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
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Template_Ids Array_Number := Fazo.Sort(p.r_Array_Number('template_id'));
  begin
    for i in 1 .. v_Template_Ids.Count
    loop
      Hrm_Api.Job_Template_Delete(i_Company_Id  => v_Company_Id,
                                  i_Filial_Id   => v_Filial_Id,
                                  i_Template_Id => v_Template_Ids(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hrm_Job_Templates
       set Company_Id          = null,
           Filial_Id           = null,
           Template_Id         = null,
           Rank_Id             = null,
           Schedule_Id         = null,
           Vacation_Days_Limit = null,
           Wage_Scale_Id       = null,
           Created_By          = null,
           Created_On          = null,
           Modified_By         = null,
           Modified_On         = null;
    update Hrm_Hidden_Salary_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null;
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
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
  end;

end Ui_Vhr279;
/
