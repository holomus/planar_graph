create or replace package Ui_Vhr585 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr585;
/
create or replace package body Ui_Vhr585 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Hrec_Util.Application_Statuses;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hrec_applications',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Varchar2_Field('application_number', 'status');
    q.Number_Field('application_id',
                   'division_id',
                   'job_id',
                   'quantity',
                   'wage',
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
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials uf
                            where uf.company_id = :company_id
                              and uf.user_id = w.user_id
                              and uf.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials uf
                            where uf.company_id = :company_id
                              and uf.user_id = w.user_id
                              and uf.filial_id = :filial_id)');
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Draft(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Status_Draft(i_Company_Id     => v_Company_Id,
                                        i_Filial_Id      => v_Filial_Id,
                                        i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Waiting(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Status_Waiting(i_Company_Id     => v_Company_Id,
                                          i_Filial_Id      => v_Filial_Id,
                                          i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Approve(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Status_Approved(i_Company_Id     => v_Company_Id,
                                           i_Filial_Id      => v_Filial_Id,
                                           i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Cancel(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Status_Canceled(i_Company_Id     => v_Company_Id,
                                           i_Filial_Id      => v_Filial_Id,
                                           i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Complete(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Status_Complited(i_Company_Id     => v_Company_Id,
                                            i_Filial_Id      => v_Filial_Id,
                                            i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Application_Ids Array_Number := Fazo.Sort(p.r_Array_Number('application_id'));
  begin
    for i in 1 .. v_Application_Ids.Count
    loop
      Hrec_Api.Application_Delete(i_Company_Id     => v_Company_Id,
                                  i_Filial_Id      => v_Filial_Id,
                                  i_Application_Id => v_Application_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hrec_Applications
       set Company_Id         = null,
           Filial_Id          = null,
           Application_Id     = null,
           Application_Number = null,
           Division_Id        = null,
           Job_Id             = null,
           Quantity           = null,
           Wage               = null,
           Status             = null,
           Created_By         = null,
           Created_On         = null,
           Modified_By        = null,
           Modified_On        = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  end;

end Ui_Vhr585;
/
