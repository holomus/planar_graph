create or replace package Ui_Vhr552 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr552;
/
create or replace package body Ui_Vhr552 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_job_norms',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('norm_id',
                   'object_id',
                   'job_id',
                   'monthly_hours',
                   'monthly_days',
                   'idle_margin',
                   'absense_margin');
    q.Number_Field('modified_by', 'created_by');
    q.Date_Field('month', 'created_on', 'modified_on');
  
    q.Refer_Field('object_name',
                  'object_id',
                  'select *
                     from mhr_divisions t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'select *
                     from mhr_jobs t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'select *
                     from md_users t
                    where t.company_id = :company_id',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'select *
                     from md_users t
                    where t.company_id = :company_id',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Norm_Ids Array_Number := Fazo.Sort(p.r_Array_Number('norm_id'));
  begin
    for i in 1 .. v_Norm_Ids.Count
    loop
      Hsc_Api.Job_Norm_Delete(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Norm_Id    => v_Norm_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Job_Norms
       set Company_Id     = null,
           Filial_Id      = null,
           Norm_Id        = null,
           Object_Id      = null,
           Division_Id    = null,
           Job_Id         = null,
           Monthly_Hours  = null,
           Monthly_Days   = null,
           Idle_Margin    = null,
           Absense_Margin = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
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
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr552;
/
