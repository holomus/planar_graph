create or replace package Ui_Vhr644 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr644;
/
create or replace package body Ui_Vhr644 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hsc_job_rounds',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('round_id', 'object_id', 'job_id');
    q.Varchar2_Field('round_model_type');
    q.Number_Field('modified_by', 'created_by');
    q.Date_Field('month', 'created_on', 'modified_on');
  
    v_Matrix := Fazo.Transpose(Mkr_Util.Round_Model_Types);
  
    q.Option_Field('round_model_type_name', 'round_model_type', v_Matrix(1), v_Matrix(2));
  
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
    v_Round_Ids Array_Number := Fazo.Sort(p.r_Array_Number('round_id'));
  begin
    for i in 1 .. v_Round_Ids.Count
    loop
      Hsc_Api.Job_Round_Delete(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Round_Id   => v_Round_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Job_Rounds
       set Company_Id       = null,
           Filial_Id        = null,
           Round_Id         = null,
           Object_Id        = null,
           Division_Id      = null,
           Job_Id           = null,
           Round_Model_Type = null,
           Created_By       = null,
           Created_On       = null,
           Modified_By      = null,
           Modified_On      = null;
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

end Ui_Vhr644;
/
