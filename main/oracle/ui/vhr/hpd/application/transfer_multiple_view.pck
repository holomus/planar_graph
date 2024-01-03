create or replace package Ui_Vhr625 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Transfers(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_New_To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_From_Waiting_To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_In_Progress_To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Canceled(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_In_Progress(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Completed(p Hashmap);
end Ui_Vhr625;
/
create or replace package body Ui_Vhr625 is
  ----------------------------------------------------------------------------------------------------
  Function Grant_Has(i_Grant varchar2) return varchar2 is
  begin
    return Uit_Hpd.Application_Grant_Has(Hpd_Pref.c_App_Grant_Part_Transfer || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Grant(i_Grant varchar2) is
  begin
    Uit_Hpd.Application_Assert_Grant(Hpd_Pref.c_App_Grant_Part_Transfer || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date,
                                        z.Status,
                                        z.Closing_Note,
                                        z.Created_On,
                                        z.Modified_On);
  
    Result.Put('status_name', Hpd_Util.t_Application_Status(r_Application.Status));
    Result.Put('created_by_name',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Application.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Application.Modified_By).Name);
    Result.Put('journal_id',
               z_Hpd_Application_Journals.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Application_Id => r_Application.Application_Id).Journal_Id);
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple));
  
    Result.Put('grant_has_applicant', Grant_Has(Hpd_Pref.c_App_Grantee_Applicant));
    Result.Put('grant_has_manager', Grant_Has(Hpd_Pref.c_App_Grantee_Manager));
    Result.Put('grant_has_hr', Grant_Has(Hpd_Pref.c_App_Grantee_Hr));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Transfers(p Hashmap) return Hashmap is
    v_Application_Id number := p.r_Number('application_id');
    v_Data           Hashmap;
    v_List           Arraylist := Arraylist();
    result           Hashmap := Hashmap();
  begin
    for r in (select *
                from Hpd_Application_Transfers t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.Application_Id = v_Application_Id)
    loop
      v_Data := Fazo.Zip_Map('application_unit_id',
                             r.Application_Unit_Id,
                             'staff_id',
                             r.Staff_Id,
                             'transfer_begin',
                             r.Transfer_Begin,
                             'robot_id',
                             r.Robot_Id,
                             'note',
                             r.Note);
    
      v_Data.Put('staff_name',
                 Href_Util.Staff_Name(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Staff_Id   => r.Staff_Id));
      v_Data.Put('robot_name',
                 z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => r.Robot_Id).Name);
    
      v_List.Push(v_Data);
    end loop;
  
    Result.Put('transfer_units', v_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Bind_Journal(i_Company_Id     => Ui.Company_Id,
                                     i_Filial_Id      => Ui.Filial_Id,
                                     i_Application_Id => p.r_Number('application_id'),
                                     i_Journal_Id     => p.r_Number('journal_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_New_To_Waiting(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Api.Application_Status_Waiting(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Application_Id => p.r_Number('application_id'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Change_Status_To_Waiting(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Waiting(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_New(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Api.Application_Status_New(i_Company_Id     => Ui.Company_Id,
                                   i_Filial_Id      => Ui.Filial_Id,
                                   i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_From_Waiting_To_Approved(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Approved(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_In_Progress_To_Approved(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_Approved(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Canceled(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Canceled(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'),
                                        i_Closing_Note   => p.o_Varchar2('closing_note'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_In_Progress(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_In_Progress(i_Company_Id     => Ui.Company_Id,
                                           i_Filial_Id      => Ui.Filial_Id,
                                           i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Completed(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_Completed(i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Application_Id => p.r_Number('application_id'));
  end;

end Ui_Vhr625;
/
