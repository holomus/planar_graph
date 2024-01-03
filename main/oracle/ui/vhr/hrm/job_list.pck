create or replace package Ui_Vhr660 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr660;
/
create or replace package body Ui_Vhr660 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q              Fazo_Query;
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Params       Hashmap;
    v_Query        varchar2(4000);
  begin
    v_Query := 'select t.* 
                  from mhr_jobs t 
                 where t.company_id = :company_id 
                   and t.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if v_Division_Ids.Count > 0 then
      v_Query := v_Query ||
                 ' and (t.c_Divisions_Exist = ''N''
                        or exists (select 1
                              from mhr_job_divisions w
                             where w.company_id = :company_id 
                               and w.filial_id = :filial_id
                               and w.job_id = t.job_id 
                               and exists (select 1
                                      from table(:division_ids) k
                                     where k.column_value = w.division_id)))';
    
      v_Params.Put('division_ids', v_Division_Ids);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('job_id', 'job_group_id', 'expense_coa_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'expense_ref_set', 'state', 'code');
    q.Date_Field('created_on', 'modified_on');
  
    q.Multi_Number_Field('division_ids', 'mhr_job_divisions', '@job_id=$job_id', 'division_id');
    q.Multi_Number_Field('role_ids',
                         'select *
                            from hrm_job_roles t
                           where t.company_id = :company_id
                             and t.filial_id = :filial_id',
                         '@job_id=$job_id',
                         'role_id');
  
    q.Refer_Field('division_names',
                  'division_ids',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select * 
                     from mhr_divisions s 
                    where s.company_id = :company_id 
                      and s.filial_id = :filial_id');
    q.Refer_Field('role_names',
                  'role_ids',
                  'md_roles',
                  'role_id',
                  'name',
                  'select * 
                     from md_roles s 
                    where s.company_id = :company_id');
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
                  'gen_name',
                  'select *
                     from mk_coa
                    where company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Map_Field('expense_ref_set_names', 'mk_util.ref_names(:company_id, $expense_ref_set)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Job_Ids Array_Number := p.r_Array_Number('job_id');
  begin
    for i in 1 .. v_Job_Ids.Count
    loop
      Mhr_Api.Job_Delete(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Job_Id     => v_Job_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id      = null,
           Job_Id          = null,
           name            = null,
           Job_Group_Id    = null,
           Expense_Coa_Id  = null,
           Expense_Ref_Set = null,
           State           = null,
           Code            = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           Gen_Name   = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Md_User_Filials
       set Company_Id = null,
           Filial_Id  = null,
           User_Id    = null;
  
    Uie.x(Mk_Util.Ref_Names(null, ''));
  end;

end Ui_Vhr660;
/
