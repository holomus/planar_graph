create or replace package Ui_Vhr544 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Robot(p Hashmap);
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
end Ui_Vhr544;
/
create or replace package body Ui_Vhr544 is
  ----------------------------------------------------------------------------------------------------
  Function Grant_Has(i_Grant varchar2) return varchar2 is
  begin
    return Uit_Hpd.Application_Grant_Has(Hpd_Pref.c_App_Grant_Part_Create_Robot || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Grant(i_Grant varchar2) is
  begin
    Uit_Hpd.Application_Assert_Grant(Hpd_Pref.c_App_Grant_Part_Create_Robot || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    r_Robot       Hpd_Application_Create_Robots%rowtype;
    v_Robot_Ids   Array_Number;
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
  
    r_Robot := z_Hpd_Application_Create_Robots.Load(i_Company_Id     => Ui.Company_Id,
                                                    i_Filial_Id      => Ui.Filial_Id,
                                                    i_Application_Id => r_Application.Application_Id);
  
    Result.Put_All(z_Hpd_Application_Create_Robots.To_Map(r_Robot,
                                                          z.Name,
                                                          z.Opened_Date,
                                                          z.Division_Id,
                                                          z.Job_Id,
                                                          z.Quantity,
                                                          z.Note));
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
  
    begin
      select q.Robot_Id
        bulk collect
        into v_Robot_Ids
        from Hpd_Application_Robots q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Application_Id = r_Application.Application_Id;
    exception
      when No_Data_Found then
        null;
    end;
  
    Result.Put('robot_ids', v_Robot_Ids);
    Result.Put('grant_has_applicant', Grant_Has(Hpd_Pref.c_App_Grantee_Applicant));
    Result.Put('grant_has_manager', Grant_Has(Hpd_Pref.c_App_Grantee_Manager));
    Result.Put('grant_has_hr', Grant_Has(Hpd_Pref.c_App_Grantee_Hr));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Robot(p Hashmap) is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Application_Id number := p.r_Number('application_id');
    v_Robot_Ids      Array_Number := p.r_Array_Number('robot_ids');
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    -- todo: robot yaratish va bind qilish bitta sessiyada bo'lishini ta'minlash kerak
    for i in 1 .. v_Robot_Ids.Count
    loop
      Hpd_Api.Application_Bind_Robot(i_Company_Id     => v_Company_Id,
                                     i_Filial_Id      => v_Filial_Id,
                                     i_Application_Id => v_Application_Id,
                                     i_Robot_Id       => v_Robot_Ids(i));
    end loop;
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

end Ui_Vhr544;
/
