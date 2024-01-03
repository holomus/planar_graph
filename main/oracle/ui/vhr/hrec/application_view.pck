create or replace package Ui_Vhr587 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Waiting(p Hashmap);
end Ui_Vhr587;
/
create or replace package body Ui_Vhr587 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Application Hrec_Applications%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hrec_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                              i_Filial_Id      => Ui.Filial_Id,
                                              i_Application_Id => p.r_Varchar2('application_id'));
  
    result := z_Hrec_Applications.To_Map_All(r_Application);
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Application.Company_Id, i_Filial_Id => r_Application.Filial_Id, i_Division_Id => r_Application.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Application.Company_Id, i_Filial_Id => r_Application.Filial_Id, i_Job_Id => r_Application.Job_Id).Name);
    Result.Put('status_name', Hrec_Util.t_Application_Status(r_Application.Status));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Application.Company_Id, i_User_Id => r_Application.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Application.Company_Id, i_User_Id => r_Application.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Approve(p Hashmap) is
  begin
    Hrec_Api.Application_Status_Approved(i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Cancel(p Hashmap) is
  begin
    Hrec_Api.Application_Status_Canceled(i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Complete(p Hashmap) is
  begin
    Hrec_Api.Application_Status_Complited(i_Company_Id     => Ui.Company_Id,
                                          i_Filial_Id      => Ui.Filial_Id,
                                          i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Draft(p Hashmap) is
  begin
    Hrec_Api.Application_Status_Draft(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_To_Waiting(p Hashmap) is
  begin
    Hrec_Api.Application_Status_Waiting(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'));
  end;

end Ui_Vhr587;
/
