create or replace package Ui_Vhr397 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Wage_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr397;
/
create or replace package body Ui_Vhr397 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Wage_Audit(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_href_wages q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.wage_id = :wage_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'wage_id',
                                 p.r_Number('wage_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'wage_id',
                   'job_id',
                   'rank_id',
                   'wage_begin',
                   'wage_end');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = q.company_id
                              and w.user_id = q.user_id
                              and w.filial_id = :filial_id)');
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
                             from md_company_filial_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code
                              and k.filial_id = :filial_id)');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data       Href_Wages%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    result       Hashmap;
  begin
    r_Data := z_Href_Wages.Load(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Wage_Id    => p.r_Number('wage_id'));
  
    result := z_Href_Wages.To_Map(r_Data,
                                  z.Wage_Id,
                                  z.Wage_Begin,
                                  z.Wage_End,
                                  z.Created_On,
                                  z.Modified_On);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Job_Id => r_Data.Job_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Rank_Id => r_Data.Rank_Id).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Href_Wages
       set t_Company_Id = null,
           t_Filial_Id  = null,
           t_Audit_Id   = null,
           t_Event      = null,
           t_Timestamp  = null,
           t_Date       = null,
           t_User_Id    = null,
           Wage_Id      = null,
           Job_Id       = null,
           Rank_Id      = null,
           Wage_Begin   = null,
           Wage_End     = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Md_Company_Filial_Projects
       set Company_Id   = null,
           Project_Code = null,
           Filial_Id    = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
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
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr397;
/
