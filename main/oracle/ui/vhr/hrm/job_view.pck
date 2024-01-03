create or replace package Ui_Vhr661 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr661;
/
create or replace package body Ui_Vhr661 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Audits(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Events Matrix_Varchar2 := Md_Util.Events;
  begin
    q := Fazo_Query('select *
                       from x_mhr_jobs q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.job_id = :job_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'job_id',
                                 p.r_Number('job_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'job_id',
                   'job_group_id',
                   'expense_coa_id');
    q.Date_Field('t_timestamp', 't_date', 'opened_date', 'closed_date');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'name',
                     'expense_ref_set',
                     'state',
                     'code');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
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
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
    q.Refer_Field('job_group_name',
                  'job_group_id',
                  'mhr_job_groups',
                  'job_group_id',
                  'name',
                  'select *
                     from mhr_job_groups s
                    where s.company_id = :company_id');
    q.Refer_Field('expense_coa_name',
                  'expense_coa_id',
                  'mk_coa',
                  'coa_id',
                  'name',
                  'select *
                     from mk_coa s
                    where s.company_id = :company_id');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Map_Field('expense_ref_set_names', 'mk_util.ref_names(:company_id, $expense_ref_set)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id     number := Ui.Company_Id;
    v_Job_Id         number := p.r_Number('job_id');
    v_Division_Names varchar2(4000);
    v_Role_Names     varchar2(4000);
  
    r_Data Mhr_Jobs%rowtype;
    result Hashmap;
  begin
    r_Data := z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Job_Id     => v_Job_Id);
  
    result := z_Mhr_Jobs.To_Map(r_Data,
                                z.Job_Id,
                                z.Name,
                                z.Job_Group_Id,
                                z.Expense_Coa_Id,
                                z.State,
                                z.Code,
                                z.Created_By,
                                z.Created_On,
                                z.Modified_By,
                                z.Modified_On);
  
    Result.Put('job_group_name',
               z_Mhr_Job_Groups.Take(i_Company_Id => v_Company_Id, i_Job_Group_Id => r_Data.Job_Group_Id).Name);
    Result.Put('coa',
               Mkr_Util.Coa_Info(i_Company_Id => Ui.Company_Id,
                                 i_Coa_Id     => r_Data.Expense_Coa_Id,
                                 i_Ref_Set    => r_Data.Expense_Ref_Set));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
    Result.Put('state_name', Md_Util.Decode(r_Data.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
  
    select Listagg(k.Name, ', ')
      into v_Division_Names
      from Mhr_Job_Divisions t
      join Mhr_Divisions k
        on k.Company_Id = t.Company_Id
       and k.Division_Id = t.Division_Id
     where t.Company_Id = v_Company_Id
       and k.Filial_Id =
           Decode(Ui.Filial_Id, Md_Pref.Filial_Head(v_Company_Id), k.Filial_Id, Ui.Filial_Id)
       and t.Job_Id = v_Job_Id
       and Rownum < 20;
  
    Result.Put('division_names', v_Division_Names);
  
    select Listagg(t.Name, ', ')
      into v_Role_Names
      from Md_Roles t
     where t.Company_Id = Ui.Company_Id
       and exists (select 1
              from Hrm_Job_Roles q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Job_Id = r_Data.Job_Id
               and q.Role_Id = t.Role_Id)
       and Rownum < 20;
  
    Result.Put('role_names', v_Role_Names);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Mhr_Jobs
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Job_Id                = null,
           name                  = null,
           Job_Group_Id          = null,
           Expense_Coa_Id        = null,
           Expense_Ref_Set       = null,
           State                 = null,
           Code                  = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
    Uie.x(Mk_Util.Ref_Names(null, ''));
  end;

end Ui_Vhr661;
/
