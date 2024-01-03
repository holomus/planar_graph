set define off
create or replace package Hrec_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Stage_Save(i_Stage Hrec_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Stage_Delete
  (
    i_Company_Id number,
    i_Stage_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_Save(i_Funnel Hrec_Pref.Funnel_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_Delete
  (
    i_Company_Id number,
    i_Funnel_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Reject_Reason_Save(i_Reject_Reason Hrec_Reject_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Reject_Reason_Delete
  (
    i_Company_Id       number,
    i_Reject_Reason_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Save(i_Application Hrec_Pref.Application_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Draft
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Waiting
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Approved
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Complited
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Canceled
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Group_Save(i_Group Hrec_Vacancy_Groups%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Group_Delete
  (
    i_Company_Id       number,
    i_Vacancy_Group_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Type_Save(i_Type Hrec_Vacancy_Types%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Type_Delete
  (
    i_Company_Id      number,
    i_Vacancy_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Save(i_Vacancy Hrec_Pref.Vacancy_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Close
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Add_Candidate(i_Candidate Hrec_Vacancy_Candidates%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Remove_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Id   number,
    i_Candidate_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Operation_Save(i_Operation Hrec_Pref.Candidate_Operation_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Operation_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Operation_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Hh_Published_Vacancy_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Id   number,
    i_Vacancy_Code varchar2,
    i_Billing_Type varchar2,
    i_Vacancy_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------      
  Function Vacancy_Runtime_Service
  (
    i_Company_Id         number,
    i_User_Id            number,
    i_Host_Uri           varchar2,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Use_Access_Token   boolean := true,
    i_Use_Refresh_Token  boolean := false,
    i_Uri_Query_Params   Gmap := null,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Job_Save
  (
    i_Company_Id number,
    i_Code       number,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Head_Hunter_Jobs_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------   
  Procedure Head_Hunter_Region_Save
  (
    i_Company_Id number,
    i_Code       number,
    i_Name       varchar2,
    i_Parent_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Region_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Experience_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Experience_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Employments_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employments_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Driver_Licence_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Driver_Licence_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Schedule_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Schedule_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Level_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Level_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Key_Skill_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Key_Skill_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Job_Save
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Integration_Job Hrec_Pref.Hh_Integration_Job_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Region_Save
  (
    i_Company_Id         number,
    i_Integration_Region Hrec_Pref.Hh_Integration_Region_Nt
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Hh_Integration_Stage_Save
  (
    i_Company_Id number,
    i_Stage      Hrec_Pref.Hh_Integration_Stage_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Experience_Save
  (
    i_Company_Id number,
    i_Experience Hrec_Pref.Hh_Integration_Experience_Nt
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Integration_Employments_Save
  (
    i_Company_Id number,
    i_Employment Hrec_Pref.Hh_Integration_Employments_Nt
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Integration_Driver_Licence_Save
  (
    i_Company_Id number,
    i_Licences   Hrec_Pref.Hh_Integration_Driver_Licence_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Schedule_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Schedule   Hrec_Pref.Hh_Integration_Schedule_Nt
  );
  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Lang_Save
  (
    i_Company_Id number,
    i_Lang       Hrec_Pref.Hh_Integration_Lang_Nt
  );
  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Lang_Level_Save
  (
    i_Company_Id number,
    i_Lang_Level Hrec_Pref.Hh_Integration_Lang_Level_Nt
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employer_Id_Save(i_Employer_Id Hrec_Hh_Employer_Ids%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employer_Id_Delete(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Resume_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Resume_Code   varchar2,
    i_Candidate_Id  number,
    i_First_Name    varchar2,
    i_Last_Name     varchar2,
    i_Middle_Name   varchar2,
    i_Gender_Code   varchar2,
    i_Date_Of_Birth date,
    i_Extra_Data    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Subscription_Save
  (
    i_Company_Id        number,
    i_Subscription_Code varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Subscription_Delete(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Negotiation_Save
  (
    i_Company_Id       number,
    i_Filial_Id        varchar2,
    i_Topic_Code       varchar2,
    i_Event_Code       varchar2,
    i_Negotiation_Date varchar2,
    i_Vacancy_Code     varchar2,
    i_Resume_Code      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Event_Save
  (
    i_Company_Id        number,
    i_Event_Code        varchar2,
    i_Subscription_Code varchar2,
    i_Event_Type        varchar2,
    i_User_Code         varchar2
  );
  ----------------------------------------------------------------------------------------------------      
  Function Olx_Runtime_Service
  (
    i_Company_Id         number,
    i_User_Id            number,
    i_Host_Uri           varchar2,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Use_Access_Token   boolean := true,
    i_Use_Refresh_Token  boolean := false,
    i_Uri_Query_Params   Gmap := null,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Job_Category_Save(i_Category Hrec_Olx_Job_Categories%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Job_Category_Delete
  (
    i_Company_Id    number,
    i_Category_Code number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Save(i_Attribute Hrec_Pref.Olx_Attribute_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Delete
  (
    i_Company_Id     number,
    i_Category_Code  number,
    i_Attribute_Code varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Region_Save(i_Region Hrec_Olx_Regions%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Region_Clear(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_City_Save(i_City Hrec_Olx_Cities%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_City_Delete
  (
    i_Company_Id number,
    i_City_Code  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_District_Save(i_District Hrec_Olx_Districts%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_District_Delete
  (
    i_Company_Id    number,
    i_District_Code number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Olx_Integration_Region_Save
  (
    i_Company_Id number,
    i_Regions    Hrec_Pref.Olx_Integration_Region_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Published_Vacancy_Save(i_Vacancy Hrec_Pref.Olx_Published_Vacancy_Rt);
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Published_Vacancy_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Vacancy_Candidates_Save
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Vacancy_Id      number,
    i_Candidate_Codes Array_Number
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Vacancy_Candidate_Save
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Vacancy_Id     number,
    i_Candidate_Code number,
    i_Candidate_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Telegram_Candidate_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number,
    i_Contact_Code number
  );
end Hrec_Api;
/
create or replace package body Hrec_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Stage_Save(i_Stage Hrec_Stages%rowtype) is
    v_State varchar2(1) := i_Stage.State;
    v_Dummy number;
    r_Stage Hrec_Stages%rowtype;
  begin
    if z_Hrec_Stages.Exist_Lock(i_Company_Id => i_Stage.Company_Id,
                                i_Stage_Id   => i_Stage.Stage_Id,
                                o_Row        => r_Stage) then
      if v_State = 'P' then
        if r_Stage.Pcode is not null then
          v_State := 'A';
        end if;
      
        begin
          select 1
            into v_Dummy
            from Hrec_Vacancy_Candidates q
           where q.Company_Id = r_Stage.Company_Id
             and q.Stage_Id = r_Stage.Stage_Id
             and Rownum = 1;
        
          Hrec_Error.Raise_016(i_Stage.Name);
        exception
          when No_Data_Found then
            null;
        end;
      end if;
    
      z_Hrec_Stages.Update_One(i_Company_Id => r_Stage.Company_Id,
                               i_Stage_Id   => r_Stage.Stage_Id,
                               i_Name       => Option_Varchar2(i_Stage.Name),
                               i_Order_No   => Option_Number(i_Stage.Order_No),
                               i_Code       => Option_Varchar2(i_Stage.Code),
                               i_State      => Option_Varchar2(v_State));
    else
      z_Hrec_Stages.Insert_One(i_Company_Id => i_Stage.Company_Id,
                               i_Stage_Id   => i_Stage.Stage_Id,
                               i_Name       => i_Stage.Name,
                               i_State      => v_State,
                               i_Order_No   => i_Stage.Order_No,
                               i_Code       => i_Stage.Code,
                               i_Pcode      => null);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Stage_Delete
  (
    i_Company_Id number,
    i_Stage_Id   number
  ) is
    r_Stage Hrec_Stages%rowtype;
  begin
    r_Stage := z_Hrec_Stages.Lock_Load(i_Company_Id => i_Company_Id, i_Stage_Id => i_Stage_Id);
  
    if r_Stage.Pcode is not null then
      Hrec_Error.Raise_003(r_Stage.Name);
    end if;
  
    z_Hrec_Stages.Delete_One(i_Company_Id => r_Stage.Company_Id, i_Stage_Id => r_Stage.Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_Save(i_Funnel Hrec_Pref.Funnel_Rt) is
    r_Funnel Hrec_Funnels%rowtype;
  begin
    if z_Hrec_Funnels.Exist_Lock(i_Company_Id => i_Funnel.Company_Id,
                                 i_Funnel_Id  => i_Funnel.Funnel_Id,
                                 o_Row        => r_Funnel) then
      if r_Funnel.Pcode is not null then
        Hrec_Error.Raise_014(r_Funnel.Name);
      end if;
    else
      r_Funnel.Company_Id := i_Funnel.Company_Id;
      r_Funnel.Funnel_Id  := i_Funnel.Funnel_Id;
    end if;
  
    r_Funnel.Name  := i_Funnel.Name;
    r_Funnel.Code  := i_Funnel.Code;
    r_Funnel.State := i_Funnel.State;
  
    z_Hrec_Funnels.Save_Row(r_Funnel);
  
    for i in 1 .. i_Funnel.Stage_Ids.Count
    loop
      z_Hrec_Funnel_Stages.Insert_Try(i_Company_Id => i_Funnel.Company_Id,
                                      i_Funnel_Id  => i_Funnel.Funnel_Id,
                                      i_Stage_Id   => i_Funnel.Stage_Ids(i));
    end loop;
  
    delete from Hrec_Funnel_Stages q
     where q.Company_Id = i_Funnel.Company_Id
       and q.Funnel_Id = i_Funnel.Funnel_Id
       and q.Stage_Id not member of i_Funnel.Stage_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_Delete
  (
    i_Company_Id number,
    i_Funnel_Id  number
  ) is
    r_Funnel Hrec_Funnels%rowtype;
  begin
    r_Funnel := z_Hrec_Funnels.Lock_Load(i_Company_Id => i_Company_Id, i_Funnel_Id => i_Funnel_Id);
  
    if r_Funnel.Pcode is not null then
      Hrec_Error.Raise_005(r_Funnel.Name);
    end if;
  
    z_Hrec_Funnels.Delete_One(i_Company_Id => i_Company_Id, i_Funnel_Id => i_Funnel_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reject_Reason_Save(i_Reject_Reason Hrec_Reject_Reasons%rowtype) is
  begin
    z_Hrec_Reject_Reasons.Save_Row(i_Reject_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reject_Reason_Delete
  (
    i_Company_Id       number,
    i_Reject_Reason_Id number
  ) is
  begin
    z_Hrec_Reject_Reasons.Delete_One(i_Company_Id       => i_Company_Id,
                                     i_Reject_Reason_Id => i_Reject_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Save(i_Application Hrec_Pref.Application_Rt) is
    r_Application Hrec_Applications%rowtype;
    v_Exists      boolean := false;
  begin
    if z_Hrec_Applications.Exist_Lock(i_Company_Id     => i_Application.Company_Id,
                                      i_Filial_Id      => i_Application.Filial_Id,
                                      i_Application_Id => i_Application.Application_Id,
                                      o_Row            => r_Application) then
      if r_Application.Status not in
         (Hrec_Pref.c_Application_Status_Draft, Hrec_Pref.c_Application_Status_Waiting) then
        Hrec_Error.Raise_001(r_Application.Application_Id,
                             Hrec_Util.t_Application_Status(r_Application.Status));
      end if;
    
      v_Exists := true;
    else
      r_Application.Company_Id     := i_Application.Company_Id;
      r_Application.Filial_Id      := i_Application.Filial_Id;
      r_Application.Application_Id := i_Application.Application_Id;
    end if;
  
    r_Application.Application_Number := i_Application.Application_Number;
    r_Application.Division_Id        := i_Application.Division_Id;
    r_Application.Job_Id             := i_Application.Job_Id;
    r_Application.Quantity           := i_Application.Quantity;
    r_Application.Wage               := i_Application.Wage;
    r_Application.Responsibilities   := i_Application.Responsibilities;
    r_Application.Requirements       := i_Application.Requirements;
    r_Application.Status             := i_Application.Status;
    r_Application.Note               := i_Application.Note;
  
    if r_Application.Status not in
       (Hrec_Pref.c_Application_Status_Draft, Hrec_Pref.c_Application_Status_Waiting) then
      Hrec_Error.Raise_006(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    if v_Exists then
      z_Hrec_Applications.Update_Row(r_Application);
    else
      if r_Application.Application_Number is null then
        r_Application.Application_Number := Md_Core.Gen_Number(i_Company_Id => r_Application.Company_Id,
                                                               i_Filial_Id  => r_Application.Filial_Id,
                                                               i_Table      => Zt.Hrec_Applications,
                                                               i_Column     => z.Application_Number);
      end if;
    
      z_Hrec_Applications.Insert_Row(r_Application);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Draft
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hrec_Pref.c_Application_Status_Canceled then
      Hrec_Error.Raise_009(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Update_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id,
                                   i_Status         => Option_Varchar2(Hrec_Pref.c_Application_Status_Draft));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Waiting
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hrec_Pref.c_Application_Status_Draft then
      Hrec_Error.Raise_010(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Update_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id,
                                   i_Status         => Option_Varchar2(Hrec_Pref.c_Application_Status_Waiting));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Approved
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hrec_Pref.c_Application_Status_Waiting then
      Hrec_Error.Raise_011(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Update_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id,
                                   i_Status         => Option_Varchar2(Hrec_Pref.c_Application_Status_Approved));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Complited
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hrec_Pref.c_Application_Status_Approved then
      Hrec_Error.Raise_012(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Update_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id,
                                   i_Status         => Option_Varchar2(Hrec_Pref.c_Application_Status_Complited));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Canceled
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hrec_Pref.c_Application_Status_Waiting then
      Hrec_Error.Raise_013(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Update_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id,
                                   i_Status         => Option_Varchar2(Hrec_Pref.c_Application_Status_Canceled));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                   i_Filial_Id      => i_Filial_Id,
                                                   i_Application_Id => i_Application_Id);
  
    if r_Application.Status not in
       (Hrec_Pref.c_Application_Status_Draft, Hrec_Pref.c_Application_Status_Waiting) then
      Hrec_Error.Raise_002(r_Application.Application_Id,
                           Hrec_Util.t_Application_Status(r_Application.Status));
    end if;
  
    z_Hrec_Applications.Delete_One(i_Company_Id     => r_Application.Company_Id,
                                   i_Filial_Id      => r_Application.Filial_Id,
                                   i_Application_Id => r_Application.Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Group_Save(i_Group Hrec_Vacancy_Groups%rowtype) is
    r_Data Hrec_Vacancy_Groups%rowtype;
  begin
    if z_Hrec_Vacancy_Groups.Exist_Lock(i_Company_Id       => i_Group.Company_Id,
                                        i_Vacancy_Group_Id => i_Group.Vacancy_Group_Id,
                                        o_Row              => r_Data) and
       r_Data.Pcode <> i_Group.Pcode then
      Hrec_Error.Raise_034(i_Group.Name);
    end if;
  
    z_Hrec_Vacancy_Groups.Save_Row(i_Group);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Group_Delete
  (
    i_Company_Id       number,
    i_Vacancy_Group_Id number
  ) is
    r_Data Hrec_Vacancy_Groups%rowtype;
  begin
    if z_Hrec_Vacancy_Groups.Exist_Lock(i_Company_Id       => i_Company_Id,
                                        i_Vacancy_Group_Id => i_Vacancy_Group_Id,
                                        o_Row              => r_Data) and r_Data.Pcode is not null then
      Hrec_Error.Raise_035(r_Data.Name);
    end if;
  
    z_Hrec_Vacancy_Groups.Delete_One(i_Company_Id       => i_Company_Id,
                                     i_Vacancy_Group_Id => i_Vacancy_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Type_Save(i_Type Hrec_Vacancy_Types%rowtype) is
    r_Data Hrec_Vacancy_Types%rowtype;
  begin
    if z_Hrec_Vacancy_Types.Exist_Lock(i_Company_Id      => i_Type.Company_Id,
                                       i_Vacancy_Type_Id => i_Type.Vacancy_Type_Id,
                                       o_Row             => r_Data) and
       r_Data.Pcode <> i_Type.Pcode then
      Hrec_Error.Raise_036(i_Type.Name);
    end if;
  
    z_Hrec_Vacancy_Types.Save_Row(i_Type);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Type_Delete
  (
    i_Company_Id      number,
    i_Vacancy_Type_Id number
  ) is
    r_Data Hrec_Vacancy_Types%rowtype;
  begin
    if z_Hrec_Vacancy_Types.Exist_Lock(i_Company_Id      => i_Company_Id,
                                       i_Vacancy_Type_Id => i_Vacancy_Type_Id,
                                       o_Row             => r_Data) and r_Data.Pcode is not null then
      Hrec_Error.Raise_037(r_Data.Name);
    end if;
  
    z_Hrec_Vacancy_Types.Delete_One(i_Company_Id      => i_Company_Id,
                                    i_Vacancy_Type_Id => i_Vacancy_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Save(i_Vacancy Hrec_Pref.Vacancy_Rt) is
    r_Vacancy   Hrec_Vacancies%rowtype;
    v_Lang      Hrec_Pref.Vacancy_Lang_Rt;
    v_Type      Hrec_Pref.Vacancy_Type_Rt;
    v_Lang_Ids  Array_Number := Array_Number();
    v_Group_Ids Array_Number := Array_Number();
    v_Exists    boolean := false;
  begin
    if z_Hrec_Vacancies.Exist_Lock(i_Company_Id => i_Vacancy.Company_Id,
                                   i_Filial_Id  => i_Vacancy.Filial_Id,
                                   i_Vacancy_Id => i_Vacancy.Vacancy_Id,
                                   o_Row        => r_Vacancy) then
      if r_Vacancy.Status <> Hrec_Pref.c_Vacancy_Status_Open then
        Hrec_Error.Raise_007(i_Vacancy_Id => r_Vacancy.Vacancy_Id,
                             i_State_Name => Hrec_Util.t_Vacancy_Status(r_Vacancy.Status));
      end if;
    
      v_Exists := true;
    else
      r_Vacancy.Company_Id := i_Vacancy.Company_Id;
      r_Vacancy.Filial_Id  := i_Vacancy.Filial_Id;
      r_Vacancy.Vacancy_Id := i_Vacancy.Vacancy_Id;
    end if;
  
    r_Vacancy.Name                := i_Vacancy.Name;
    r_Vacancy.Opened_Date         := i_Vacancy.Opened_Date;
    r_Vacancy.Deadline            := i_Vacancy.Deadline;
    r_Vacancy.Closed_Date         := i_Vacancy.Closed_Date;
    r_Vacancy.Application_Id      := i_Vacancy.Application_Id;
    r_Vacancy.Division_Id         := i_Vacancy.Division_Id;
    r_Vacancy.Job_Id              := i_Vacancy.Job_Id;
    r_Vacancy.Funnel_Id           := i_Vacancy.Funnel_Id;
    r_Vacancy.Region_Id           := i_Vacancy.Region_Id;
    r_Vacancy.Schedule_Id         := i_Vacancy.Schedule_Id;
    r_Vacancy.Exam_Id             := i_Vacancy.Exam_Id;
    r_Vacancy.Quantity            := i_Vacancy.Quantity;
    r_Vacancy.Scope               := i_Vacancy.Scope;
    r_Vacancy.Urgent              := i_Vacancy.Urgent;
    r_Vacancy.Wage_From           := i_Vacancy.Wage_From;
    r_Vacancy.Wage_To             := i_Vacancy.Wage_To;
    r_Vacancy.Description         := i_Vacancy.Description;
    r_Vacancy.Description_In_Html := i_Vacancy.Description_In_Html;
    r_Vacancy.Status              := Hrec_Pref.c_Vacancy_Status_Open;
  
    if v_Exists then
      z_Hrec_Vacancies.Update_Row(r_Vacancy);
    else
      z_Hrec_Vacancies.Insert_Row(r_Vacancy);
    end if;
  
    -- save recruiters
    for i in 1 .. i_Vacancy.Recruiter_Ids.Count
    loop
      z_Hrec_Vacancy_Recruiters.Insert_Try(i_Company_Id => r_Vacancy.Company_Id,
                                           i_Filial_Id  => r_Vacancy.Filial_Id,
                                           i_Vacancy_Id => r_Vacancy.Vacancy_Id,
                                           i_User_Id    => i_Vacancy.Recruiter_Ids(i));
    end loop;
  
    delete from Hrec_Vacancy_Recruiters q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and q.User_Id not member of i_Vacancy.Recruiter_Ids;
  
    -- save langs
    v_Lang_Ids.Extend(i_Vacancy.Langs.Count);
  
    for i in 1 .. i_Vacancy.Langs.Count
    loop
      v_Lang := i_Vacancy.Langs(i);
      v_Lang_Ids(i) := v_Lang.Lang_Id;
    
      z_Hrec_Vacancy_Langs.Save_One(i_Company_Id    => r_Vacancy.Company_Id,
                                    i_Filial_Id     => r_Vacancy.Filial_Id,
                                    i_Vacancy_Id    => r_Vacancy.Vacancy_Id,
                                    i_Lang_Id       => v_Lang.Lang_Id,
                                    i_Lang_Level_Id => v_Lang.Lang_Level_Id);
    end loop;
  
    delete from Hrec_Vacancy_Langs q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and q.Lang_Id not member of v_Lang_Ids;
  
    -- save vacancy types
    v_Group_Ids.Extend(i_Vacancy.Vacancy_Types.Count);
  
    for i in 1 .. i_Vacancy.Vacancy_Types.Count
    loop
      v_Type := i_Vacancy.Vacancy_Types(i);
      v_Group_Ids(i) := v_Type.Vacancy_Group_Id;
    
      for j in 1 .. v_Type.Vacancy_Type_Ids.Count
      loop
        z_Hrec_Vacancy_Type_Binds.Insert_Try(i_Company_Id       => r_Vacancy.Company_Id,
                                             i_Filial_Id        => r_Vacancy.Filial_Id,
                                             i_Vacancy_Id       => r_Vacancy.Vacancy_Id,
                                             i_Vacancy_Group_Id => v_Type.Vacancy_Group_Id,
                                             i_Vacancy_Type_Id  => v_Type.Vacancy_Type_Ids(j));
      end loop;
    
      delete from Hrec_Vacancy_Type_Binds q
       where q.Company_Id = r_Vacancy.Company_Id
         and q.Filial_Id = r_Vacancy.Filial_Id
         and q.Vacancy_Id = r_Vacancy.Vacancy_Id
         and q.Vacancy_Group_Id = v_Type.Vacancy_Group_Id
         and q.Vacancy_Type_Id not member of v_Type.Vacancy_Type_Ids;
    end loop;
  
    delete from Hrec_Vacancy_Type_Binds q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and q.Vacancy_Group_Id not member of v_Group_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Close
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  ) is
    r_Vacancy Hrec_Vacancies%rowtype;
  begin
    r_Vacancy := z_Hrec_Vacancies.Lock_Load(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Vacancy_Id => i_Vacancy_Id);
  
    if r_Vacancy.Status <> Hrec_Pref.c_Vacancy_Status_Open then
      Hrec_Error.Raise_017(r_Vacancy.Vacancy_Id, r_Vacancy.Closed_Date);
    end if;
  
    z_Hrec_Vacancies.Update_One(i_Company_Id  => r_Vacancy.Company_Id,
                                i_Filial_Id   => r_Vacancy.Filial_Id,
                                i_Vacancy_Id  => r_Vacancy.Vacancy_Id,
                                i_Closed_Date => Option_Date(Trunc(Htt_Util.Get_Current_Date(i_Company_Id => r_Vacancy.Company_Id,
                                                                                             i_Filial_Id  => r_Vacancy.Filial_Id))),
                                i_Status      => Option_Varchar2(Hrec_Pref.c_Vacancy_Status_Close));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Add_Candidate(i_Candidate Hrec_Vacancy_Candidates%rowtype) is
    v_Todo_Stage_Id number := Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => i_Candidate.Company_Id,
                                                          i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo);
  begin
    z_Hrec_Vacancy_Candidates.Insert_One(i_Company_Id       => i_Candidate.Company_Id,
                                         i_Filial_Id        => i_Candidate.Filial_Id,
                                         i_Vacancy_Id       => i_Candidate.Vacancy_Id,
                                         i_Candidate_Id     => i_Candidate.Candidate_Id,
                                         i_Stage_Id         => v_Todo_Stage_Id,
                                         i_Reject_Reason_Id => null);
  
    z_Hrec_Operations.Insert_One(i_Company_Id       => i_Candidate.Company_Id,
                                 i_Filial_Id        => i_Candidate.Filial_Id,
                                 i_Operation_Id     => Hrec_Next.Operation_Id,
                                 i_Operation_Kind   => Hrec_Pref.c_Operation_Kind_Action,
                                 i_Vacancy_Id       => i_Candidate.Vacancy_Id,
                                 i_Candidate_Id     => i_Candidate.Candidate_Id,
                                 i_From_Stage_Id    => null,
                                 i_To_Stage_Id      => v_Todo_Stage_Id,
                                 i_Reject_Reason_Id => null,
                                 i_Note             => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Remove_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Id   number,
    i_Candidate_Id number
  ) is
    r_Candidate Hrec_Vacancy_Candidates%rowtype;
  begin
    r_Candidate := z_Hrec_Vacancy_Candidates.Lock_Load(i_Company_Id   => i_Company_Id,
                                                       i_Filial_Id    => i_Filial_Id,
                                                       i_Vacancy_Id   => i_Vacancy_Id,
                                                       i_Candidate_Id => i_Candidate_Id);
  
    if r_Candidate.Stage_Id <>
       Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => i_Company_Id,
                                   i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo) then
      Hrec_Error.Raise_008(r_Candidate.Candidate_Id,
                           z_Hrec_Stages.Load(i_Company_Id => r_Candidate.Company_Id, i_Stage_Id => r_Candidate.Stage_Id).Name);
    end if;
  
    z_Hrec_Vacancy_Candidates.Delete_One(i_Company_Id   => r_Candidate.Company_Id,
                                         i_Filial_Id    => r_Candidate.Filial_Id,
                                         i_Vacancy_Id   => r_Candidate.Vacancy_Id,
                                         i_Candidate_Id => r_Candidate.Candidate_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  ) is
  begin
    z_Hrec_Vacancies.Delete_One(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Vacancy_Id => i_Vacancy_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Operation_Save(i_Operation Hrec_Pref.Candidate_Operation_Rt) is
    r_Vacancy_Candidate Hrec_Vacancy_Candidates%rowtype;
  begin
    if z_Hrec_Operations.Exist(i_Company_Id   => i_Operation.Company_Id,
                               i_Filial_Id    => i_Operation.Filial_Id,
                               i_Operation_Id => i_Operation.Operation_Id) then
      z_Hrec_Operations.Update_One(i_Company_Id       => i_Operation.Company_Id,
                                   i_Filial_Id        => i_Operation.Filial_Id,
                                   i_Operation_Id     => i_Operation.Operation_Id,
                                   i_Reject_Reason_Id => Option_Number(i_Operation.Reject_Reason_Id),
                                   i_Note             => Option_Varchar2(i_Operation.Note));
    else
      r_Vacancy_Candidate := z_Hrec_Vacancy_Candidates.Lock_Load(i_Company_Id   => i_Operation.Company_Id,
                                                                 i_Filial_Id    => i_Operation.Filial_Id,
                                                                 i_Vacancy_Id   => i_Operation.Vacancy_Id,
                                                                 i_Candidate_Id => i_Operation.Candidate_Id);
    
      z_Hrec_Operations.Insert_One(i_Company_Id       => i_Operation.Company_Id,
                                   i_Filial_Id        => i_Operation.Filial_Id,
                                   i_Operation_Id     => i_Operation.Operation_Id,
                                   i_Operation_Kind   => i_Operation.Operation_Kind,
                                   i_Vacancy_Id       => i_Operation.Vacancy_Id,
                                   i_Candidate_Id     => i_Operation.Candidate_Id,
                                   i_From_Stage_Id    => r_Vacancy_Candidate.Stage_Id,
                                   i_To_Stage_Id      => i_Operation.To_Stage_Id,
                                   i_Reject_Reason_Id => i_Operation.Reject_Reason_Id,
                                   i_Note             => i_Operation.Note);
    
      if i_Operation.Operation_Kind = Hrec_Pref.c_Operation_Kind_Action then
        z_Hrec_Vacancy_Candidates.Update_One(i_Company_Id       => i_Operation.Company_Id,
                                             i_Filial_Id        => i_Operation.Filial_Id,
                                             i_Vacancy_Id       => i_Operation.Vacancy_Id,
                                             i_Candidate_Id     => i_Operation.Candidate_Id,
                                             i_Stage_Id         => Option_Number(i_Operation.To_Stage_Id),
                                             i_Reject_Reason_Id => Option_Number(i_Operation.Reject_Reason_Id));
      
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Operation_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Operation_Id number
  ) is
    r_Operation Hrec_Operations%rowtype;
  begin
    r_Operation := z_Hrec_Operations.Lock_Load(i_Company_Id   => i_Company_Id,
                                               i_Filial_Id    => i_Filial_Id,
                                               i_Operation_Id => i_Operation_Id);
  
    if r_Operation.Operation_Kind <> Hrec_Pref.c_Operation_Kind_Comment then
      Hrec_Error.Raise_015(i_Operation_Id   => r_Operation.Operation_Id,
                           i_Operation_Kind => Hrec_Util.t_Operation_Kind(r_Operation.Operation_Kind));
    end if;
  
    z_Hrec_Operations.Delete_One(i_Company_Id   => r_Operation.Company_Id,
                                 i_Filial_Id    => r_Operation.Filial_Id,
                                 i_Operation_Id => r_Operation.Operation_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Published_Vacancy_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Id   number,
    i_Vacancy_Code varchar2,
    i_Billing_Type varchar2,
    i_Vacancy_Type varchar2
  ) is
  begin
    z_Hrec_Hh_Published_Vacancies.Save_One(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Vacancy_Id   => i_Vacancy_Id,
                                           i_Vacancy_Code => i_Vacancy_Code,
                                           i_Billing_Type => i_Billing_Type,
                                           i_Vacancy_Type => i_Vacancy_Type);
  end;

  ----------------------------------------------------------------------------------------------------      
  Function Vacancy_Runtime_Service
  (
    i_Company_Id         number,
    i_User_Id            number,
    i_Host_Uri           varchar2,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Use_Access_Token   boolean := true,
    i_Use_Refresh_Token  boolean := false,
    i_Uri_Query_Params   Gmap := null,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    v_Api_Uri     varchar2(300) := i_Api_Uri;
    r_Oauth_Token Hes_Oauth2_Tokens%rowtype;
  
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Get_Oauth2_Token return Hes_Oauth2_Tokens%rowtype is
      r_Oauth_Token Hes_Oauth2_Tokens%rowtype;
    begin
      r_Oauth_Token := z_Hes_Oauth2_Tokens.Take(i_Company_Id  => i_Company_Id,
                                                i_User_Id     => i_User_Id,
                                                i_Provider_Id => Hes_Pref.c_Provider_Hh_Id);
    
      if i_Use_Access_Token and
         (r_Oauth_Token.Access_Token is null or
         i_Use_Refresh_Token and r_Oauth_Token.Expires_On < Current_Timestamp) then
        Hrec_Error.Raise_018;
      end if;
    
      return r_Oauth_Token;
    end;
  
    --------------------------------------------------
    Procedure Put_Refresh_Token_Info is
      r_Credentials Hes_Oauth2_Credentials%rowtype;
      r_Provider    Hes_Oauth2_Providers%rowtype;
    begin
      v_Details.Put('refresh_token', r_Oauth_Token.Refresh_Token);
    
      r_Provider    := z_Hes_Oauth2_Providers.Load(Hes_Pref.c_Provider_Hh_Id);
      r_Credentials := z_Hes_Oauth2_Credentials.Load(i_Company_Id  => i_Company_Id,
                                                     i_Provider_Id => Hes_Pref.c_Provider_Hh_Id);
    
      v_Details.Put('provider_id', r_Provider.Provider_Id);
      v_Details.Put('token_url', r_Provider.Token_Url);
      v_Details.Put('content_type', r_Provider.Content_Type);
      v_Details.Put('scope', r_Provider.Scope);
    
      v_Details.Put('company_id', i_Company_Id);
      v_Details.Put('user_id', i_User_Id);
    
      v_Details.Put('client_id', r_Credentials.Client_Id);
      v_Details.Put('client_secret', r_Credentials.Client_Secret);
    end;
  
    --------------------------------------------------
    Function Gather_Query_Params return varchar2 is
      v_Param_Keys Array_Varchar2;
      v_Delimiter  varchar2(1) := '&';
      v_Key        varchar2(100);
      result       varchar2(4000);
    begin
      if i_Uri_Query_Params is null then
        return result;
      end if;
    
      v_Param_Keys := i_Uri_Query_Params.Keyset;
    
      if v_Param_Keys.Count = 0 then
        return result;
      end if;
    
      for i in 1 .. v_Param_Keys.Count
      loop
        v_Key := v_Param_Keys(i);
      
        result := result || v_Key || '=' || i_Uri_Query_Params.r_Varchar2(v_Key);
        if i <> v_Param_Keys.Count then
          result := result || v_Delimiter;
        end if;
      end loop;
    
      return '?' || result;
    end;
  
  begin
    if i_Uri_Query_Params is not null then
      v_Api_Uri := v_Api_Uri || Gather_Query_Params;
    end if;
  
    r_Oauth_Token := Get_Oauth2_Token;
  
    v_Details.Put('host', i_Host_Uri);
    v_Details.Put('request_path', v_Api_Uri);
    v_Details.Put('method', i_Api_Method);
  
    if i_Use_Access_Token then
      v_Details.Put('token', r_Oauth_Token.Access_Token);
    end if;
  
    if i_Use_Access_Token and i_Use_Refresh_Token and r_Oauth_Token.Expires_On < Current_Timestamp and
       r_Oauth_Token.Refresh_Token is not null then
      Put_Refresh_Token_Info;
    end if;
  
    v_Service := Runtime_Service(Hrec_Pref.c_Head_Hunter_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Responce_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Job_Save
  (
    i_Company_Id number,
    i_Code       number,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Head_Hunter_Jobs.Save_One(i_Company_Id => i_Company_Id,
                                     i_Code       => i_Code,
                                     i_Name       => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Head_Hunter_Jobs_Clear(i_Company_Id number) is
  begin
    delete Hrec_Head_Hunter_Jobs q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Head_Hunter_Region_Save
  (
    i_Company_Id number,
    i_Code       number,
    i_Name       varchar2,
    i_Parent_Id  number
  ) is
  begin
    z_Hrec_Head_Hunter_Regions.Save_One(i_Company_Id => i_Company_Id,
                                        i_Code       => i_Code,
                                        i_Name       => i_Name,
                                        i_Parent_Id  => i_Parent_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Region_Clear(i_Company_Id number) is
  begin
    delete Hrec_Head_Hunter_Regions q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Experience_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Experiences.Save_One(i_Company_Id => i_Company_Id,
                                   i_Code       => i_Code,
                                   i_Name       => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Experience_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Experiences q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Employments_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Employments.Save_One(i_Company_Id => i_Company_Id,
                                   i_Code       => i_Code,
                                   i_Name       => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employments_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Employments q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Driver_Licence_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Driver_Licences.Save_One(i_Company_Id => i_Company_Id,
                                       i_Code       => i_Code,
                                       i_Name       => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Driver_Licence_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Driver_Licences q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Schedule_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Schedules.Save_One(i_Company_Id => i_Company_Id, i_Code => i_Code, i_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Schedule_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Schedules q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Langs.Save_One(i_Company_Id => i_Company_Id, i_Code => i_Code, i_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Langs q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Level_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Lang_Levels.Save_One(i_Company_Id => i_Company_Id,
                                   i_Code       => i_Code,
                                   i_Name       => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Lang_Level_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Lang_Levels q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Key_Skill_Save
  (
    i_Company_Id number,
    i_Code       varchar2,
    i_Name       varchar2
  ) is
  begin
    z_Hrec_Hh_Key_Skills.Save_One(i_Company_Id => i_Company_Id, i_Code => i_Code, i_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Key_Skill_Clear(i_Company_Id number) is
  begin
    delete Hrec_Hh_Key_Skills q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Job_Save
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Integration_Job Hrec_Pref.Hh_Integration_Job_Nt
  ) is
    v_Integration_Job Hrec_Pref.Hh_Integration_Job_Rt;
    v_Job_Codes       Array_Number := Array_Number();
  begin
    v_Job_Codes.Extend(i_Integration_Job.Count);
  
    for i in 1 .. i_Integration_Job.Count
    loop
      v_Integration_Job := i_Integration_Job(i);
      v_Job_Codes(i) := v_Integration_Job.Job_Code;
    
      for j in 1 .. v_Integration_Job.Job_Ids.Count
      loop
        z_Hrec_Hh_Integration_Jobs.Insert_Try(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Job_Code   => v_Integration_Job.Job_Code,
                                              i_Job_Id     => v_Integration_Job.Job_Ids(j));
      end loop;
    
      delete Hrec_Hh_Integration_Jobs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Job_Code = v_Integration_Job.Job_Code
         and q.Job_Id not member of v_Integration_Job.Job_Ids;
    end loop;
  
    delete Hrec_Hh_Integration_Jobs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Job_Code not member of v_Job_Codes;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Region_Save
  
  (
    i_Company_Id         number,
    i_Integration_Region Hrec_Pref.Hh_Integration_Region_Nt
  ) is
    v_Integration_Region Hrec_Pref.Hh_Integration_Region_Rt;
    v_Region_Ids         Array_Number := Array_Number();
  begin
    v_Region_Ids.Extend(i_Integration_Region.Count);
  
    for i in 1 .. i_Integration_Region.Count
    loop
      v_Integration_Region := i_Integration_Region(i);
      v_Region_Ids(i) := v_Integration_Region.Region_Id;
    
      z_Hrec_Hh_Integration_Regions.Save_One(i_Company_Id  => i_Company_Id,
                                             i_Region_Id   => v_Integration_Region.Region_Id,
                                             i_Region_Code => v_Integration_Region.Region_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Regions q
     where q.Company_Id = i_Company_Id
       and q.Region_Id not member of v_Region_Ids;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Hh_Integration_Stage_Save
  (
    i_Company_Id number,
    i_Stage      Hrec_Pref.Hh_Integration_Stage_Nt
  ) is
    v_Stage     Hrec_Pref.Hh_Integration_Stage_Rt;
    v_Stage_Ids Array_Number := Array_Number();
  begin
    for i in 1 .. i_Stage.Count
    loop
      v_Stage := i_Stage(i);
    
      for j in 1 .. v_Stage.Stage_Ids.Count
      loop
        v_Stage_Ids.Extend;
        v_Stage_Ids(v_Stage_Ids.Count) := v_Stage.Stage_Ids(j);
      
        z_Hrec_Hh_Integration_Stages.Save_One(i_Company_Id => i_Company_Id,
                                              i_Stage_Id   => v_Stage.Stage_Ids(j),
                                              i_Stage_Code => v_Stage.Stage_Code);
      end loop;
    end loop;
  
    delete Hrec_Hh_Integration_Stages q
     where q.Company_Id = i_Company_Id
       and q.Stage_Id not member of v_Stage_Ids
       and q.Stage_Code <> Hrec_Pref.c_Hh_Todo_Stage_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Experience_Save
  (
    i_Company_Id number,
    i_Experience Hrec_Pref.Hh_Integration_Experience_Nt
  ) is
    v_Experience       Hrec_Pref.Hh_Integration_Experience_Rt;
    v_Vacancy_Type_Ids Array_Number := Array_Number();
  begin
    v_Vacancy_Type_Ids.Extend(i_Experience.Count);
  
    for i in 1 .. i_Experience.Count
    loop
      v_Experience := i_Experience(i);
      v_Vacancy_Type_Ids(i) := v_Experience.Vacancy_Type_Id;
    
      z_Hrec_Hh_Integration_Experiences.Save_One(i_Company_Id      => i_Company_Id,
                                                 i_Vacancy_Type_Id => v_Experience.Vacancy_Type_Id,
                                                 i_Experience_Code => v_Experience.Experience_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Experiences q
     where q.Company_Id = i_Company_Id
       and q.Vacancy_Type_Id not member of v_Vacancy_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Integration_Employments_Save
  (
    i_Company_Id number,
    i_Employment Hrec_Pref.Hh_Integration_Employments_Nt
  ) is
    v_Employment       Hrec_Pref.Hh_Integration_Employments_Rt;
    v_Vacancy_Type_Ids Array_Number := Array_Number();
  begin
    v_Vacancy_Type_Ids.Extend(i_Employment.Count);
  
    for i in 1 .. i_Employment.Count
    loop
      v_Employment := i_Employment(i);
      v_Vacancy_Type_Ids(i) := v_Employment.Vacancy_Type_Id;
    
      z_Hrec_Hh_Integration_Employments.Save_One(i_Company_Id      => i_Company_Id,
                                                 i_Vacancy_Type_Id => v_Employment.Vacancy_Type_Id,
                                                 i_Employment_Code => v_Employment.Employment_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Employments q
     where q.Company_Id = i_Company_Id
       and q.Vacancy_Type_Id not member of v_Vacancy_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Integration_Driver_Licence_Save
  (
    i_Company_Id number,
    i_Licences   Hrec_Pref.Hh_Integration_Driver_Licence_Nt
  ) is
    v_Licence          Hrec_Pref.Hh_Integration_Driver_Licence_Rt;
    v_Vacancy_Type_Ids Array_Number := Array_Number();
  begin
    v_Vacancy_Type_Ids.Extend(i_Licences.Count);
  
    for i in 1 .. i_Licences.Count
    loop
      v_Licence := i_Licences(i);
      v_Vacancy_Type_Ids(i) := v_Licence.Vacancy_Type_Id;
    
      z_Hrec_Hh_Integration_Driver_Licences.Save_One(i_Company_Id      => i_Company_Id,
                                                     i_Vacancy_Type_Id => v_Licence.Vacancy_Type_Id,
                                                     i_Licence_Code    => v_Licence.Licence_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Driver_Licences q
     where q.Company_Id = i_Company_Id
       and q.Vacancy_Type_Id not member of v_Vacancy_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Integration_Schedule_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Schedule   Hrec_Pref.Hh_Integration_Schedule_Nt
  ) is
    v_Schedule     Hrec_Pref.Hh_Integration_Schedule_Rt;
    v_Schedule_Ids Array_Number := Array_Number();
  begin
    v_Schedule_Ids.Extend(i_Schedule.Count);
  
    for i in 1 .. i_Schedule.Count
    loop
      v_Schedule := i_Schedule(i);
      v_Schedule_Ids(i) := v_Schedule.Schedule_Id;
    
      z_Hrec_Hh_Integration_Schedules.Save_One(i_Company_Id    => i_Company_Id,
                                               i_Filial_Id     => i_Filial_Id,
                                               i_Schedule_Id   => v_Schedule.Schedule_Id,
                                               i_Schedule_Code => v_Schedule.Schedule_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Schedule_Id not member of v_Schedule_Ids;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Lang_Save
  (
    i_Company_Id number,
    i_Lang       Hrec_Pref.Hh_Integration_Lang_Nt
  ) is
    v_Lang     Hrec_Pref.Hh_Integration_Lang_Rt;
    v_Lang_Ids Array_Number := Array_Number();
  begin
    v_Lang_Ids.Extend(i_Lang.Count);
  
    for i in 1 .. i_Lang.Count
    loop
      v_Lang := i_Lang(i);
      v_Lang_Ids(i) := v_Lang.Lang_Id;
    
      z_Hrec_Hh_Integration_Langs.Save_One(i_Company_Id => i_Company_Id,
                                           i_Lang_Id    => v_Lang.Lang_Id,
                                           i_Lang_Code  => v_Lang.Lang_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Langs q
     where q.Company_Id = i_Company_Id
       and q.Lang_Id not member of v_Lang_Ids;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Hh_Integration_Lang_Level_Save
  (
    i_Company_Id number,
    i_Lang_Level Hrec_Pref.Hh_Integration_Lang_Level_Nt
  ) is
    v_Lang_Level     Hrec_Pref.Hh_Integration_Lang_Level_Rt;
    v_Lang_Level_Ids Array_Number := Array_Number();
  begin
    v_Lang_Level_Ids.Extend(i_Lang_Level.Count);
  
    for i in 1 .. i_Lang_Level.Count
    loop
      v_Lang_Level := i_Lang_Level(i);
      v_Lang_Level_Ids(i) := v_Lang_Level.Lang_Level_Id;
    
      z_Hrec_Hh_Integration_Lang_Levels.Save_One(i_Company_Id      => i_Company_Id,
                                                 i_Lang_Level_Id   => v_Lang_Level.Lang_Level_Id,
                                                 i_Lang_Level_Code => v_Lang_Level.Lang_Level_Code);
    end loop;
  
    delete Hrec_Hh_Integration_Lang_Levels q
     where q.Company_Id = i_Company_Id
       and q.Lang_Level_Id not member of v_Lang_Level_Ids;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employer_Id_Save(i_Employer_Id Hrec_Hh_Employer_Ids%rowtype) is
  begin
    z_Hrec_Hh_Employer_Ids.Save_Row(i_Employer_Id);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Hh_Employer_Id_Delete(i_Company_Id number) is
  begin
    z_Hrec_Hh_Employer_Ids.Delete_One(i_Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Resume_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Resume_Code   varchar2,
    i_Candidate_Id  number,
    i_First_Name    varchar2,
    i_Last_Name     varchar2,
    i_Middle_Name   varchar2,
    i_Gender_Code   varchar2,
    i_Date_Of_Birth date,
    i_Extra_Data    varchar2
  ) is
  begin
    z_Hrec_Hh_Resumes.Save_One(i_Company_Id    => i_Company_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Resume_Code   => i_Resume_Code,
                               i_Candidate_Id  => i_Candidate_Id,
                               i_First_Name    => i_First_Name,
                               i_Last_Name     => i_Last_Name,
                               i_Middle_Name   => i_Middle_Name,
                               i_Gender_Code   => i_Gender_Code,
                               i_Date_Of_Birth => i_Date_Of_Birth,
                               i_Extra_Data    => i_Extra_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Subscription_Save
  (
    i_Company_Id        number,
    i_Subscription_Code varchar2
  ) is
  begin
    z_Hrec_Hh_Subscriptions.Insert_One(i_Company_Id        => i_Company_Id,
                                       i_Subscription_Code => i_Subscription_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Subscription_Delete(i_Company_Id number) is
  begin
    z_Hrec_Hh_Subscriptions.Delete_One(i_Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Negotiation_Save
  (
    i_Company_Id       number,
    i_Filial_Id        varchar2,
    i_Topic_Code       varchar2,
    i_Event_Code       varchar2,
    i_Negotiation_Date varchar2,
    i_Vacancy_Code     varchar2,
    i_Resume_Code      varchar2
  ) is
  begin
    z_Hrec_Hh_Negotiations.Save_One(i_Company_Id       => i_Company_Id,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Topic_Code       => i_Topic_Code,
                                    i_Event_Code       => i_Event_Code,
                                    i_Negotiation_Date => i_Negotiation_Date,
                                    i_Vacancy_Code     => i_Vacancy_Code,
                                    i_Resume_Code      => i_Resume_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hh_Event_Save
  (
    i_Company_Id        number,
    i_Event_Code        varchar2,
    i_Subscription_Code varchar2,
    i_Event_Type        varchar2,
    i_User_Code         varchar2
  ) is
  begin
    if i_Event_Type not in (Hrec_Pref.c_Hh_Event_Type_New_Negotiation) then
      b.Raise_Not_Implemented;
    end if;
  
    z_Hrec_Hh_Events.Save_One(i_Company_Id        => i_Company_Id,
                              i_Event_Code        => i_Event_Code,
                              i_Subscription_Code => i_Subscription_Code,
                              i_Event_Type        => i_Event_Type,
                              i_User_Code         => i_User_Code);
  end;

  ----------------------------------------------------------------------------------------------------      
  Function Olx_Runtime_Service
  (
    i_Company_Id         number,
    i_User_Id            number,
    i_Host_Uri           varchar2,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Use_Access_Token   boolean := true,
    i_Use_Refresh_Token  boolean := false,
    i_Uri_Query_Params   Gmap := null,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    v_Api_Uri     varchar2(300) := i_Api_Uri;
    r_Oauth_Token Hes_Oauth2_Tokens%rowtype;
  
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Get_Oauth2_Token return Hes_Oauth2_Tokens%rowtype is
      r_Oauth_Token Hes_Oauth2_Tokens%rowtype;
    begin
      r_Oauth_Token := z_Hes_Oauth2_Tokens.Take(i_Company_Id  => i_Company_Id,
                                                i_User_Id     => i_User_Id,
                                                i_Provider_Id => Hes_Pref.c_Provider_Olx_Id);
    
      if i_Use_Access_Token and
         (r_Oauth_Token.Access_Token is null or
         i_Use_Refresh_Token and r_Oauth_Token.Expires_On < Current_Timestamp) then
        Hrec_Error.Raise_026;
      end if;
    
      return r_Oauth_Token;
    end;
  
    --------------------------------------------------
    Procedure Put_Refresh_Token_Info is
      r_Credentials Hes_Oauth2_Credentials%rowtype;
      r_Provider    Hes_Oauth2_Providers%rowtype;
    begin
      v_Details.Put('refresh_token', r_Oauth_Token.Refresh_Token);
    
      r_Provider := z_Hes_Oauth2_Providers.Load(Hes_Pref.c_Provider_Olx_Id);
    
      r_Credentials := z_Hes_Oauth2_Credentials.Load(i_Company_Id  => Md_Pref.Company_Head,
                                                     i_Provider_Id => Hes_Pref.c_Provider_Olx_Id);
    
      v_Details.Put('provider_id', r_Provider.Provider_Id);
      v_Details.Put('token_url', r_Provider.Token_Url);
      v_Details.Put('content_type', r_Provider.Content_Type);
      v_Details.Put('scope', r_Provider.Scope);
    
      v_Details.Put('company_id', i_Company_Id);
      v_Details.Put('user_id', i_User_Id);
    
      v_Details.Put('client_id', r_Credentials.Client_Id);
      v_Details.Put('client_secret', r_Credentials.Client_Secret);
    end;
  
    --------------------------------------------------
    Function Gather_Query_Params return varchar2 is
      v_Param_Keys Array_Varchar2;
      v_Delimiter  varchar2(1) := '&';
      v_Key        varchar2(100);
      result       varchar2(4000);
    begin
      if i_Uri_Query_Params is null then
        return result;
      end if;
    
      v_Param_Keys := i_Uri_Query_Params.Keyset;
    
      if v_Param_Keys.Count = 0 then
        return result;
      end if;
    
      for i in 1 .. v_Param_Keys.Count
      loop
        v_Key := v_Param_Keys(i);
      
        result := result || v_Key || '=' || i_Uri_Query_Params.r_Varchar2(v_Key);
        if i <> v_Param_Keys.Count then
          result := result || v_Delimiter;
        end if;
      end loop;
    
      return '?' || result;
    end;
  
  begin
    if i_Uri_Query_Params is not null then
      v_Api_Uri := v_Api_Uri || Gather_Query_Params;
    end if;
  
    r_Oauth_Token := Get_Oauth2_Token;
  
    v_Details.Put('host', i_Host_Uri);
    v_Details.Put('request_path', v_Api_Uri);
    v_Details.Put('method', i_Api_Method);
  
    if i_Use_Access_Token then
      v_Details.Put('token', r_Oauth_Token.Access_Token);
    end if;
  
    if i_Use_Access_Token and i_Use_Refresh_Token and r_Oauth_Token.Expires_On < Current_Timestamp and
       r_Oauth_Token.Refresh_Token is not null then
      Put_Refresh_Token_Info;
    end if;
  
    v_Service := Runtime_Service(Hrec_Pref.c_Olx_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Responce_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Job_Category_Save(i_Category Hrec_Olx_Job_Categories%rowtype) is
  begin
    z_Hrec_Olx_Job_Categories.Save_Row(i_Category);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Job_Category_Delete
  (
    i_Company_Id    number,
    i_Category_Code number
  ) is
  begin
    z_Hrec_Olx_Job_Categories.Delete_One(i_Company_Id    => i_Company_Id,
                                         i_Category_Code => i_Category_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Save(i_Attribute Hrec_Pref.Olx_Attribute_Rt) is
    v_Attribute_Value Hrec_Pref.Olx_Attribute_Value_Rt;
    v_Codes           Array_Varchar2 := Array_Varchar2();
  begin
    z_Hrec_Olx_Attributes.Save_One(i_Company_Id               => i_Attribute.Company_Id,
                                   i_Category_Code            => i_Attribute.Category_Code,
                                   i_Attribute_Code           => i_Attribute.Attribute_Code,
                                   i_Label                    => i_Attribute.Label,
                                   i_Validation_Type          => i_Attribute.Validation_Type,
                                   i_Is_Require               => i_Attribute.Is_Required,
                                   i_Is_Number                => i_Attribute.Is_Number,
                                   i_Min_Value                => i_Attribute.Min_Value,
                                   i_Max_Value                => i_Attribute.Max_Value,
                                   i_Is_Allow_Multiple_Values => i_Attribute.Is_Allow_Multiple_Values);
  
    v_Codes.Extend(i_Attribute.Attribute_Values.Count);
    for i in 1 .. i_Attribute.Attribute_Values.Count
    loop
      v_Attribute_Value := i_Attribute.Attribute_Values(i);
      v_Codes(i) := v_Attribute_Value.Code;
    
      z_Hrec_Olx_Attribute_Values.Save_One(i_Company_Id     => i_Attribute.Company_Id,
                                           i_Category_Code  => i_Attribute.Category_Code,
                                           i_Attribute_Code => i_Attribute.Attribute_Code,
                                           i_Code           => v_Attribute_Value.Code,
                                           i_Label          => v_Attribute_Value.Label);
    end loop;
  
    delete Hrec_Olx_Attribute_Values q
     where q.Company_Id = i_Attribute.Company_Id
       and q.Category_Code = i_Attribute.Category_Code
       and q.Attribute_Code = i_Attribute.Attribute_Code
       and q.Code not member of v_Codes;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Delete
  (
    i_Company_Id     number,
    i_Category_Code  number,
    i_Attribute_Code varchar2
  ) is
  begin
    z_Hrec_Olx_Attributes.Delete_One(i_Company_Id     => i_Company_Id,
                                     i_Category_Code  => i_Category_Code,
                                     i_Attribute_Code => i_Attribute_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Region_Save(i_Region Hrec_Olx_Regions%rowtype) is
  begin
    z_Hrec_Olx_Regions.Save_Row(i_Region);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Region_Clear(i_Company_Id number) is
  begin
    delete Hrec_Olx_Regions q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_City_Save(i_City Hrec_Olx_Cities%rowtype) is
  begin
    z_Hrec_Olx_Cities.Save_Row(i_City);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_City_Delete
  (
    i_Company_Id number,
    i_City_Code  number
  ) is
  begin
    z_Hrec_Olx_Cities.Delete_One(i_Company_Id => i_Company_Id, i_City_Code => i_City_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_District_Save(i_District Hrec_Olx_Districts%rowtype) is
  begin
    z_Hrec_Olx_Districts.Save_Row(i_District);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_District_Delete
  (
    i_Company_Id    number,
    i_District_Code number
  ) is
  begin
    z_Hrec_Olx_Districts.Delete_One(i_Company_Id    => i_Company_Id,
                                    i_District_Code => i_District_Code);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Integration_Region_Save
  (
    i_Company_Id number,
    i_Regions    Hrec_Pref.Olx_Integration_Region_Nt
  ) is
    v_Region_Ids Array_Number := Array_Number();
    v_Region     Hrec_Pref.Olx_Integration_Region_Rt;
  begin
    v_Region_Ids.Extend(i_Regions.Count);
  
    for i in 1 .. i_Regions.Count
    loop
      v_Region := i_Regions(i);
      v_Region_Ids(i) := v_Region.Region_Id;
    
      z_Hrec_Olx_Integration_Regions.Save_One(i_Company_Id    => i_Company_Id,
                                              i_Region_Id     => v_Region.Region_Id,
                                              i_City_Code     => v_Region.City_Code,
                                              i_District_Code => v_Region.District_Code);
    end loop;
  
    delete Hrec_Olx_Integration_Regions q
     where q.Company_Id = i_Company_Id
       and q.Region_Id not member of v_Region_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Published_Vacancy_Save(i_Vacancy Hrec_Pref.Olx_Published_Vacancy_Rt) is
    v_Attribute Hrec_Pref.Olx_Vacancy_Attributes_Rt;
    v_Codes     Array_Varchar2 := Array_Varchar2();
  begin
    z_Hrec_Olx_Published_Vacancies.Save_One(i_Company_Id   => i_Vacancy.Company_Id,
                                            i_Filial_Id    => i_Vacancy.Filial_Id,
                                            i_Vacancy_Id   => i_Vacancy.Vacancy_Id,
                                            i_Vacancy_Code => i_Vacancy.Vacancy_Code);
  
    v_Codes.Extend(i_Vacancy.Attributes.Count);
    for i in 1 .. i_Vacancy.Attributes.Count
    loop
      v_Attribute := i_Vacancy.Attributes(i);
      v_Codes(i) := v_Attribute.Code;
    
      z_Hrec_Olx_Published_Vacancy_Attributes.Save_One(i_Company_Id    => i_Vacancy.Company_Id,
                                                       i_Filial_Id     => i_Vacancy.Filial_Id,
                                                       i_Vacancy_Id    => i_Vacancy.Vacancy_Id,
                                                       i_Category_Code => v_Attribute.Category_Code,
                                                       i_Code          => v_Attribute.Code,
                                                       i_Value         => v_Attribute.Value);
    end loop;
  
    delete Hrec_Olx_Published_Vacancy_Attributes q
     where q.Company_Id = i_Vacancy.Company_Id
       and q.Filial_Id = i_Vacancy.Filial_Id
       and q.Vacancy_Id = i_Vacancy.Vacancy_Id
       and q.Code not member of v_Codes;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Published_Vacancy_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Vacancy_Id number
  ) is
  begin
    z_Hrec_Olx_Published_Vacancies.Delete_One(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Vacancy_Id => i_Vacancy_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Vacancy_Candidates_Save
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Vacancy_Id      number,
    i_Candidate_Codes Array_Number
  ) is
  begin
    for i in 1 .. i_Candidate_Codes.Count
    loop
      z_Hrec_Olx_Vacancy_Candidates.Insert_Try(i_Company_Id     => i_Company_Id,
                                               i_Filial_Id      => i_Filial_Id,
                                               i_Vacancy_Id     => i_Vacancy_Id,
                                               i_Candidate_Code => i_Candidate_Codes(i));
    end loop;
  
    delete Hrec_Olx_Vacancy_Candidates q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Vacancy_Id = i_Vacancy_Id
       and q.Candidate_Code not member of i_Candidate_Codes;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Olx_Vacancy_Candidate_Save
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Vacancy_Id     number,
    i_Candidate_Code number,
    i_Candidate_Id   number
  ) is
  begin
    z_Hrec_Olx_Vacancy_Candidates.Save_One(i_Company_Id     => i_Company_Id,
                                           i_Filial_Id      => i_Filial_Id,
                                           i_Vacancy_Id     => i_Vacancy_Id,
                                           i_Candidate_Code => i_Candidate_Code,
                                           i_Candidate_Id   => i_Candidate_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Telegram_Candidate_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number,
    i_Contact_Code number
  ) is
  begin
    z_Hrec_Telegram_Candidates.Save_One(i_Company_Id   => i_Company_Id,
                                        i_Filial_Id    => i_Filial_Id,
                                        i_Candidate_Id => i_Candidate_Id,
                                        i_Contact_Code => i_Contact_Code);
  end;

end Hrec_Api;
/

create or replace package Hrec_Pref is
  ----------------------------------------------------------------------------------------------------
  -- Funnel
  ----------------------------------------------------------------------------------------------------
  type Funnel_Rt is record(
    Company_Id number,
    Funnel_Id  number,
    name       varchar2(200 char),
    State      varchar2(1),
    Code       varchar2(50),
    Stage_Ids  Array_Number);
  ----------------------------------------------------------------------------------------------------
  -- Application
  ----------------------------------------------------------------------------------------------------  
  type Application_Rt is record(
    Company_Id         number,
    Filial_Id          number,
    Application_Id     number,
    Application_Number varchar2(50 char),
    Division_Id        number,
    Job_Id             number,
    Quantity           number,
    Wage               number,
    Responsibilities   varchar2(4000 char),
    Requirements       varchar2(4000 char),
    Status             varchar2(1),
    Note               varchar2(300 char));
  ----------------------------------------------------------------------------------------------------  
  -- Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  type Vacancy_Type_Rt is record(
    Vacancy_Group_Id number,
    Vacancy_Type_Ids Array_Number);
  type Vacancy_Type_Nt is table of Vacancy_Type_Rt;
  ----------------------------------------------------------------------------------------------------  
  -- Vacancy Langs
  ----------------------------------------------------------------------------------------------------  
  type Vacancy_Lang_Rt is record(
    Lang_Id       number,
    Lang_Level_Id number);
  type Vacancy_Lang_Nt is table of Vacancy_Lang_Rt;
  ----------------------------------------------------------------------------------------------------
  -- Vacancies
  ----------------------------------------------------------------------------------------------------
  type Vacancy_Rt is record(
    Company_Id          number,
    Filial_Id           number,
    Vacancy_Id          number,
    name                varchar2(100 char),
    Division_Id         number,
    Job_Id              number,
    Application_Id      number,
    Quantity            number,
    Opened_Date         date,
    Closed_Date         date,
    Scope               varchar2(1),
    Urgent              varchar2(1),
    Funnel_Id           number,
    Region_Id           number,
    Schedule_Id         number,
    Exam_Id             number,
    Deadline            date,
    Description         varchar2(4000),
    Description_In_Html varchar2(4000),
    Wage_From           number,
    Wage_To             number,
    Status              varchar2(1),
    Recruiter_Ids       Array_Number,
    Langs               Vacancy_Lang_Nt,
    Vacancy_Types       Vacancy_Type_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Candidate Change Stage
  ----------------------------------------------------------------------------------------------------
  type Candidate_Operation_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Operation_Id     number,
    Vacancy_Id       number,
    Candidate_Id     number,
    Operation_Kind   varchar2(1),
    To_Stage_Id      number,
    Reject_Reason_Id number,
    Note             varchar2(2000));
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Integration    
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Job_Rt is record(
    Job_Code number,
    Job_Ids  Array_Number);
  type Hh_Integration_Job_Nt is table of Hh_Integration_Job_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Region_Rt is record(
    Region_Id   number,
    Region_Code number);
  type Hh_Integration_Region_Nt is table of Hh_Integration_Region_Rt;
  ----------------------------------------------------------------------------------------------------
  type Hh_Integration_Stage_Rt is record(
    Stage_Code varchar2(50 char),
    Stage_Ids  Array_Number);
  type Hh_Integration_Stage_Nt is table of Hh_Integration_Stage_Rt;
  ----------------------------------------------------------------------------------------------------
  type Hh_Integration_Experience_Rt is record(
    Vacancy_Type_Id number,
    Experience_Code varchar2(50));
  type Hh_Integration_Experience_Nt is table of Hh_Integration_Experience_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Employments_Rt is record(
    Vacancy_Type_Id number,
    Employment_Code varchar2(50));
  type Hh_Integration_Employments_Nt is table of Hh_Integration_Employments_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Driver_Licence_Rt is record(
    Vacancy_Type_Id number,
    Licence_Code    varchar2(50));
  type Hh_Integration_Driver_Licence_Nt is table of Hh_Integration_Driver_Licence_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Schedule_Rt is record(
    Schedule_Id   number,
    Schedule_Code varchar2(50));
  type Hh_Integration_Schedule_Nt is table of Hh_Integration_Schedule_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Lang_Rt is record(
    Lang_Id   number,
    Lang_Code varchar2(50));
  type Hh_Integration_Lang_Nt is table of Hh_Integration_Lang_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Lang_Level_Rt is record(
    Lang_Level_Id   number,
    Lang_Level_Code varchar2(50));
  type Hh_Integration_Lang_Level_Nt is table of Hh_Integration_Lang_Level_Rt;
  ----------------------------------------------------------------------------------------------------
  -- OLX Integration
  ----------------------------------------------------------------------------------------------------
  type Olx_Integration_Region_Rt is record(
    Region_Id     number,
    City_Code     number,
    District_Code number);
  type Olx_Integration_Region_Nt is table of Olx_Integration_Region_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Olx_Attribute_Value_Rt is record(
    Code  varchar2(50),
    Label varchar2(100));
  type Olx_Attribute_Value_Nt is table of Olx_Attribute_Value_Rt;
  ----------------------------------------------------------------------------------------------------
  type Olx_Attribute_Rt is record(
    Company_Id               number,
    Category_Code            number,
    Attribute_Code           varchar2(50),
    Label                    varchar2(200),
    Validation_Type          varchar2(50),
    Is_Required              varchar2(1),
    Is_Number                varchar2(1),
    Min_Value                number,
    Max_Value                number,
    Is_Allow_Multiple_Values varchar2(1),
    Attribute_Values         Olx_Attribute_Value_Nt);
  ----------------------------------------------------------------------------------------------------  
  type Olx_Vacancy_Attributes_Rt is record(
    Category_Code number,
    Code          varchar2(50),
    value         varchar2(50));
  type Olx_Vacancy_Attributes_Nt is table of Olx_Vacancy_Attributes_Rt;
  ----------------------------------------------------------------------------------------------------
  type Olx_Published_Vacancy_Rt is record(
    Company_Id   number,
    Filial_Id    number,
    Vacancy_Id   number,
    Vacancy_Code number,
    Attributes   Olx_Vacancy_Attributes_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Application Statuses
  ----------------------------------------------------------------------------------------------------
  c_Application_Status_Draft     constant varchar2(1) := 'D';
  c_Application_Status_Waiting   constant varchar2(1) := 'W';
  c_Application_Status_Approved  constant varchar2(1) := 'A';
  c_Application_Status_Complited constant varchar2(1) := 'O';
  c_Application_Status_Canceled  constant varchar2(1) := 'C';
  ---------------------------------------------------------------------------------------------------- 
  -- Vacancy
  ----------------------------------------------------------------------------------------------------  
  c_Vacancy_Scope_All           constant varchar2(1) := 'A';
  c_Vacancy_Scope_Employees     constant varchar2(1) := 'E';
  c_Vacancy_Scope_Non_Employees constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------  
  c_Vacancy_Status_Open  constant varchar2(1) := 'O';
  c_Vacancy_Status_Close constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------  
  -- Operation kinds
  ----------------------------------------------------------------------------------------------------  
  c_Operation_Kind_Comment constant varchar2(1) := 'N';
  c_Operation_Kind_Action  constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- System Stages
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Stage_Todo     constant varchar2(50) := 'VHR:HREC:1';
  c_Pcode_Stage_Accepted constant varchar2(50) := 'VHR:HREC:2';
  c_Pcode_Stage_Rejected constant varchar2(50) := 'VHR:HREC:3';
  ----------------------------------------------------------------------------------------------------  
  -- System Funnels
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Funnel_All constant varchar2(50) := 'VHR:HREC:1';
  ----------------------------------------------------------------------------------------------------
  -- Head Hunter Integration Preferences
  ----------------------------------------------------------------------------------------------------  
  c_Head_Hunter_Api_Url        constant varchar2(100) := 'https://api.hh.ru';
  c_Head_Hunter_Service_Name   constant varchar2(100) := 'com.verifix.vhr.recruitment.HeadHunterRuntimeService';
  c_Save_Vacancy_Url           constant varchar2(50) := '/vacancies';
  c_Negotiations_Url           constant varchar2(50) := '/negotiations';
  c_Webhook_Subscriptions_Url  constant varchar2(50) := '/webhook/subscriptions';
  c_Load_Candidate_Resume_Url  constant varchar2(50) := '/resumes';
  c_Get_General_References_Url constant varchar2(50) := '/dictionaries';
  c_Get_Jobs_Url               constant varchar2(50) := '/professional_roles';
  c_Get_Regions_Url            constant varchar2(50) := '/areas';
  c_Get_Languages_Url          constant varchar2(50) := '/languages';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Dictionary Keys
  ----------------------------------------------------------------------------------------------------  
  c_Dictionary_Lang_Level_Key constant varchar2(50) := 'language_level';
  c_Dictionary_Schedule_Key   constant varchar2(50) := 'schedule';
  c_Dictionary_Experience_Key constant varchar2(50) := 'experience';
  c_Dictionary_Employment_Key constant varchar2(50) := 'employment';
  c_Dictionary_Driver_Licence constant varchar2(50) := 'driver_license_types';
  ----------------------------------------------------------------------------------------------------
  -- HH Auth error code
  ---------------------------------------------------------------------------------------------------- 
  c_Hh_Error_Bad_Authorization              constant varchar2(50) := 'bad_authorization';
  c_Hh_Error_Token_Expired                  constant varchar2(50) := 'token_expired';
  c_Hh_Error_Token_Revoked                  constant varchar2(50) := 'token_revoked';
  c_Hh_Error_Application_Not_Found          constant varchar2(50) := 'application_not_found';
  c_Hh_Error_Used_Manager_Account_Forbidden constant varchar2(50) := 'used_manager_account_forbidden';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Todo_Stage_Code constant varchar2(50) := 'response';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Event_Type_New_Negotiation constant varchar2(50) := 'NEW_NEGOTIATION_VACANCY';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Billing Types
  ----------------------------------------------------------------------------------------------------  
  c_Hh_Billing_Type_Standart      constant varchar2(20) := 'standard';
  c_Hh_Billing_Type_Free          constant varchar2(20) := 'free';
  c_Hh_Billing_Type_Standart_Plus constant varchar2(20) := 'standard_plus';
  c_Hh_Billing_Type_Premium       constant varchar2(20) := 'premium';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  c_Hh_Vacancy_Type_Open      constant varchar2(20) := 'open';
  c_Hh_Vacancy_Type_Closed    constant varchar2(20) := 'closed';
  c_Hh_Vacancy_Type_Direct    constant varchar2(20) := 'direct'; -- TODO do not use this type for MVP
  c_Hh_Vacancy_Type_Anonymous constant varchar2(20) := 'anonymous'; -- TODO do not use this type for MVP
  ----------------------------------------------------------------------------------------------------
  c_Hh_Default_Page_Limit constant number := 50;
  ----------------------------------------------------------------------------------------------------
  c_Hh_Gender_Male   constant varchar2(10) := 'male';
  c_Hh_Gender_Female constant varchar2(10) := 'female';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Contact_Type_Phone constant varchar2(10) := 'cell';
  c_Hh_Contact_Type_Email constant varchar2(10) := 'email';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Event_Receiver_Path constant varchar2(50) := '/b/vhr/hrec/hh_event_receiver:event_handler';
  ---------------------------------------------------------------------------------------------------- 
  -- OLX Integration Constants
  ----------------------------------------------------------------------------------------------------
  c_Olx_Api_Url                  constant varchar2(100) := 'https://www.olx.uz';
  c_Olx_Service_Name             constant varchar2(100) := 'com.verifix.vhr.recruitment.OlxRuntimeService';
  c_Olx_Get_Regions_Url          constant varchar2(50) := '/api/partner/regions';
  c_Olx_Get_Cities_Url           constant varchar2(50) := '/api/partner/cities';
  c_Olx_Get_Districts_Url        constant varchar2(50) := '/api/partner/districts';
  c_Olx_Get_Categories_Url       constant varchar2(50) := '/api/partner/categories';
  c_Olx_Post_Adverts_Url         constant varchar2(50) := '/api/partner/adverts';
  c_Olx_Get_Thread_Url           constant varchar2(50) := '/api/partner/threads';
  v_Olx_Get_Users_Url            constant varchar2(50) := '/api/partner/users';
  c_Olx_Advertiser_Type_Private  constant varchar2(50) := 'private';
  c_Olx_Advertiser_Type_Businnes constant varchar2(50) := 'business';
  c_Olx_Salary_Type_Monthly      constant varchar2(50) := 'monthly';
  c_Olx_Salary_Type_Hourly       constant varchar2(50) := 'hourly';
  c_Olx_Job_Category_Code        constant number := 6; -- Code From Olx Server
  ----------------------------------------------------------------------------------------------------
  -- System Vacancy Groups
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Vacancy_Group_Experience      constant varchar2(20) := 'VHR:HREC:1';
  c_Pcode_Vacancy_Group_Employments     constant varchar2(20) := 'VHR:HREC:2';
  c_Pcode_Vacancy_Group_Driver_Licences constant varchar2(20) := 'VHR:HREC:3';
  c_Pcode_Vacancy_Group_Key_Skills      constant varchar2(20) := 'VHR:HREC:4';
  ----------------------------------------------------------------------------------------------------  
  -- System Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  -- Experience
  c_Pcode_Vacancy_Type_Experience_No_Experience   constant varchar2(20) := 'VHR:HREC:1';
  c_Pcode_Vacancy_Type_Experience_Between_1_And_3 constant varchar2(20) := 'VHR:HREC:2';
  c_Pcode_Vacancy_Type_Experience_Between_3_And_6 constant varchar2(20) := 'VHR:HREC:3';
  c_Pcode_Vacancy_Type_Experience_More_Than_6     constant varchar2(20) := 'VHR:HREC:4';
  -- Employments
  c_Pcode_Vacancy_Type_Employment_Full constant varchar2(20) := 'VHR:HREC:5';
  c_Pcode_Vacancy_Type_Employment_Part constant varchar2(20) := 'VHR:HREC:6';
  -- Driver Licence
  c_Pcode_Vacancy_Type_Driver_Licence_a constant varchar2(20) := 'VHR:HREC:7';
  c_Pcode_Vacancy_Type_Driver_Licence_b constant varchar2(20) := 'VHR:HREC:8';
  c_Pcode_Vacancy_Type_Driver_Licence_c constant varchar2(20) := 'VHR:HREC:9';
  -- Key Skills
  c_Pcode_Vacancy_Type_Key_Skill_Ambitious constant varchar2(20) := 'VHR:HREC:10';

end Hrec_Pref;
/
create or replace package body Hrec_Pref is
end Hrec_Pref;
/

create or replace package Hrec_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Application_New
  (
    o_Application        out Hrec_Pref.Application_Rt,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Application_Id     number,
    i_Application_Number varchar2,
    i_Division_Id        number,
    i_Job_Id             number,
    i_Quantity           number,
    i_Wage               number,
    i_Responsibilities   varchar2,
    i_Requirements       varchar2,
    i_Status             varchar2,
    i_Note               varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_New
  (
    o_Vacancy             out Hrec_Pref.Vacancy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Vacancy_Id          number,
    i_Name                varchar2,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Application_Id      number,
    i_Quantity            number,
    i_Opened_Date         date,
    i_Closed_Date         date,
    i_Scope               varchar2,
    i_Urgent              varchar2,
    i_Funnel_Id           number,
    i_Region_Id           number,
    i_Schedule_Id         number,
    i_Exam_Id             number,
    i_Deadline            date,
    i_Wage_From           number,
    i_Wage_To             number,
    i_Description         varchar2,
    i_Description_In_Html varchar2,
    i_Status              varchar2,
    i_Recruiter_Ids       Array_Number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Lang
  (
    o_Vacancy       in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Vacancy_Types
  (
    o_Vacancy          in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Vacancy_Group_Id number,
    i_Vacancy_Type_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_New
  (
    o_Funnel     out Hrec_Pref.Funnel_Rt,
    i_Company_Id number,
    i_Funnel_Id  number,
    i_Name       varchar2,
    i_State      varchar2,
    i_Code       varchar2,
    i_Stage_Ids  Array_Number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Operation_Fill
  (
    o_Operation        out Hrec_Pref.Candidate_Operation_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Operation_Id     number,
    i_Vacancy_Id       number,
    i_Candidate_Id     number,
    i_Operation_Kind   varchar2,
    i_To_Stage_Id      number,
    i_Reject_Reason_Id number,
    i_Note             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Stage_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Company_Id_By_Employer_Code(i_Employer_Code varchar2) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Published_Vacancy
  (
    i_Company_Id   number,
    i_Vacancy_Code varchar2
  ) return Hrec_Hh_Published_Vacancies%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Subscription_User_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Region_Id
  (
    i_Company_Id number,
    i_Area_Code  varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Resume_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Topic_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Code varchar2,
    i_Resume_Code  varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Auth_Response_Errors(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_New
  (
    o_Attribute                out Hrec_Pref.Olx_Attribute_Rt,
    i_Company_Id               number,
    i_Category_Code            number,
    i_Attribute_Code           varchar2,
    i_Label                    varchar2,
    i_Validation_Type          varchar2,
    i_Is_Required              varchar2,
    i_Is_Number                varchar2,
    i_Min_Value                number,
    i_Max_Value                number,
    i_Is_Allow_Multiple_Values varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Olx_Attribute_Add_Value
  (
    o_Attribute in out nocopy Hrec_Pref.Olx_Attribute_Rt,
    i_Code      varchar2,
    i_Label     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Take_Telegram_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Contact_Code number
  ) return Hrec_Telegram_Candidates%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Wage_From_To_Message
  (
    i_Wage_From number,
    i_Wage_To   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Application_Statuses return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Scope(i_Scope varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Scopes return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Statuses return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Operation_Kind(i_Kind varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Operation_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Billing_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Vacancy_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Olx_Advertiser_Types return Matrix_Varchar2;
end Hrec_Util;
/
create or replace package body Hrec_Util is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HREC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_New
  (
    o_Application        out Hrec_Pref.Application_Rt,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Application_Id     number,
    i_Application_Number varchar2,
    i_Division_Id        number,
    i_Job_Id             number,
    i_Quantity           number,
    i_Wage               number,
    i_Responsibilities   varchar2,
    i_Requirements       varchar2,
    i_Status             varchar2,
    i_Note               varchar2
  ) is
  begin
    o_Application.Company_Id         := i_Company_Id;
    o_Application.Filial_Id          := i_Filial_Id;
    o_Application.Application_Id     := i_Application_Id;
    o_Application.Application_Number := i_Application_Number;
    o_Application.Division_Id        := i_Division_Id;
    o_Application.Job_Id             := i_Job_Id;
    o_Application.Quantity           := i_Quantity;
    o_Application.Wage               := i_Wage;
    o_Application.Responsibilities   := i_Responsibilities;
    o_Application.Requirements       := i_Requirements;
    o_Application.Status             := i_Status;
    o_Application.Note               := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_New
  (
    o_Vacancy             out Hrec_Pref.Vacancy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Vacancy_Id          number,
    i_Name                varchar2,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Application_Id      number,
    i_Quantity            number,
    i_Opened_Date         date,
    i_Closed_Date         date,
    i_Scope               varchar2,
    i_Urgent              varchar2,
    i_Funnel_Id           number,
    i_Region_Id           number,
    i_Schedule_Id         number,
    i_Exam_Id             number,
    i_Deadline            date,
    i_Wage_From           number,
    i_Wage_To             number,
    i_Description         varchar2,
    i_Description_In_Html varchar2,
    i_Status              varchar2,
    i_Recruiter_Ids       Array_Number
  ) is
  begin
    o_Vacancy.Company_Id          := i_Company_Id;
    o_Vacancy.Filial_Id           := i_Filial_Id;
    o_Vacancy.Vacancy_Id          := i_Vacancy_Id;
    o_Vacancy.Name                := i_Name;
    o_Vacancy.Division_Id         := i_Division_Id;
    o_Vacancy.Job_Id              := i_Job_Id;
    o_Vacancy.Application_Id      := i_Application_Id;
    o_Vacancy.Quantity            := i_Quantity;
    o_Vacancy.Opened_Date         := i_Opened_Date;
    o_Vacancy.Closed_Date         := i_Closed_Date;
    o_Vacancy.Scope               := i_Scope;
    o_Vacancy.Urgent              := i_Urgent;
    o_Vacancy.Funnel_Id           := i_Funnel_Id;
    o_Vacancy.Region_Id           := i_Region_Id;
    o_Vacancy.Schedule_Id         := i_Schedule_Id;
    o_Vacancy.Exam_Id             := i_Exam_Id;
    o_Vacancy.Deadline            := i_Deadline;
    o_Vacancy.Wage_From           := i_Wage_From;
    o_Vacancy.Wage_To             := i_Wage_To;
    o_Vacancy.Description         := i_Description;
    o_Vacancy.Description_In_Html := i_Description_In_Html;
    o_Vacancy.Status              := i_Status;
    o_Vacancy.Recruiter_Ids       := i_Recruiter_Ids;
  
    o_Vacancy.Langs         := Hrec_Pref.Vacancy_Lang_Nt();
    o_Vacancy.Vacancy_Types := Hrec_Pref.Vacancy_Type_Nt();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Lang
  (
    o_Vacancy       in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  ) is
    v_Lang Hrec_Pref.Vacancy_Lang_Rt;
  begin
    v_Lang.Lang_Id       := i_Lang_Id;
    v_Lang.Lang_Level_Id := i_Lang_Level_Id;
  
    o_Vacancy.Langs.Extend();
    o_Vacancy.Langs(o_Vacancy.Langs.Count) := v_Lang;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Vacancy_Types
  (
    o_Vacancy          in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Vacancy_Group_Id number,
    i_Vacancy_Type_Ids Array_Number
  ) is
    v_Type Hrec_Pref.Vacancy_Type_Rt;
  begin
    v_Type.Vacancy_Group_Id := i_Vacancy_Group_Id;
    v_Type.Vacancy_Type_Ids := i_Vacancy_Type_Ids;
  
    o_Vacancy.Vacancy_Types.Extend();
    o_Vacancy.Vacancy_Types(o_Vacancy.Vacancy_Types.Count) := v_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_New
  (
    o_Funnel     out Hrec_Pref.Funnel_Rt,
    i_Company_Id number,
    i_Funnel_Id  number,
    i_Name       varchar2,
    i_State      varchar2,
    i_Code       varchar2,
    i_Stage_Ids  Array_Number
  ) is
  begin
    o_Funnel.Company_Id := i_Company_Id;
    o_Funnel.Funnel_Id  := i_Funnel_Id;
    o_Funnel.Name       := i_Name;
    o_Funnel.State      := i_State;
    o_Funnel.Code       := i_Code;
    o_Funnel.Stage_Ids  := i_Stage_Ids;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Operation_Fill
  (
    o_Operation        out Hrec_Pref.Candidate_Operation_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Operation_Id     number,
    i_Vacancy_Id       number,
    i_Candidate_Id     number,
    i_Operation_Kind   varchar2,
    i_To_Stage_Id      number,
    i_Reject_Reason_Id number,
    i_Note             varchar2
  ) is
  begin
    o_Operation.Company_Id       := i_Company_Id;
    o_Operation.Filial_Id        := i_Filial_Id;
    o_Operation.Operation_Id     := i_Operation_Id;
    o_Operation.Vacancy_Id       := i_Vacancy_Id;
    o_Operation.Candidate_Id     := i_Candidate_Id;
    o_Operation.Operation_Kind   := i_Operation_Kind;
    o_Operation.To_Stage_Id      := i_To_Stage_Id;
    o_Operation.Reject_Reason_Id := i_Reject_Reason_Id;
    o_Operation.Note             := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Stage_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Stage_Id number;
  begin
    select q.Stage_Id
      into v_Stage_Id
      from Hrec_Stages q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Stage_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Funnel_Id number;
  begin
    select q.Funnel_Id
      into v_Funnel_Id
      from Hrec_Funnels q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Funnel_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Group_Id number;
  begin
    select q.Vacancy_Group_Id
      into v_Group_Id
      from Hrec_Vacancy_Groups q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Group_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Type_Id number;
  begin
    select q.Vacancy_Type_Id
      into v_Type_Id
      from Hrec_Vacancy_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Type_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Company_Id_By_Employer_Code(i_Employer_Code varchar2) return number is
    v_Company_Id number;
  begin
    select t.Company_Id
      into v_Company_Id
      from Hrec_Hh_Employer_Ids t
     where t.Employer_Id = i_Employer_Code;
  
    return v_Company_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Published_Vacancy
  (
    i_Company_Id   number,
    i_Vacancy_Code varchar2
  ) return Hrec_Hh_Published_Vacancies%rowtype is
    r_Vacancy Hrec_Hh_Published_Vacancies%rowtype;
  begin
    select t.*
      into r_Vacancy
      from Hrec_Hh_Published_Vacancies t
     where t.Company_Id = i_Company_Id
       and t.Vacancy_Code = i_Vacancy_Code;
  
    return r_Vacancy;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Subscription_User_Id(i_Company_Id number) return number is
    v_User_Id number;
  begin
    select t.Created_By
      into v_User_Id
      from Hrec_Hh_Subscriptions t
     where t.Company_Id = i_Company_Id;
  
    return v_User_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Region_Id
  (
    i_Company_Id number,
    i_Area_Code  varchar2
  ) return number is
    result number;
  begin
    select q.Region_Id
      into result
      from Hrec_Hh_Integration_Regions q
     where q.Company_Id = i_Company_Id
       and q.Region_Code = i_Area_Code
       and Rownum = 1;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Resume_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) return varchar2 is
    result varchar2(100);
  begin
    select q.Resume_Code
      into result
      from Hrec_Hh_Resumes q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Candidate_Id = i_Candidate_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Topic_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Code varchar2,
    i_Resume_Code  varchar2
  ) return varchar2 is
    result varchar2(100);
  begin
    select q.Topic_Code
      into result
      from Hrec_Hh_Negotiations q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Vacancy_Code = i_Vacancy_Code
       and q.Resume_Code = i_Resume_Code;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Auth_Response_Errors(i_Data Hashmap) is
    v_Errors     Arraylist := i_Data.o_Arraylist('errors');
    v_Error      Hashmap;
    v_Error_Code varchar2(50);
  begin
    if v_Errors is null or v_Errors.Count = 0 then
      return;
    end if;
  
    for i in 1 .. v_Errors.Count
    loop
      v_Error := Treat(v_Errors.r_Hashmap(i) as Hashmap);
    
      v_Error_Code := v_Error.r_Varchar2('value');
    
      if v_Error_Code in (Hrec_Pref.c_Hh_Error_Bad_Authorization,
                          Hrec_Pref.c_Hh_Error_Token_Expired,
                          Hrec_Pref.c_Hh_Error_Token_Revoked,
                          Hrec_Pref.c_Hh_Error_Application_Not_Found,
                          Hrec_Pref.c_Hh_Error_Used_Manager_Account_Forbidden) then
        Hrec_Error.Raise_019(v_Error_Code);
      end if;
    end loop;
  
    if v_Error_Code is not null then
      Hrec_Error.Raise_019(v_Error_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_New
  (
    o_Attribute                out Hrec_Pref.Olx_Attribute_Rt,
    i_Company_Id               number,
    i_Category_Code            number,
    i_Attribute_Code           varchar2,
    i_Label                    varchar2,
    i_Validation_Type          varchar2,
    i_Is_Required              varchar2,
    i_Is_Number                varchar2,
    i_Min_Value                number,
    i_Max_Value                number,
    i_Is_Allow_Multiple_Values varchar2
  ) is
  begin
    o_Attribute.Company_Id               := i_Company_Id;
    o_Attribute.Category_Code            := i_Category_Code;
    o_Attribute.Attribute_Code           := i_Attribute_Code;
    o_Attribute.Label                    := i_Label;
    o_Attribute.Validation_Type          := i_Validation_Type;
    o_Attribute.Is_Required              := i_Is_Required;
    o_Attribute.Is_Number                := i_Is_Number;
    o_Attribute.Min_Value                := i_Min_Value;
    o_Attribute.Max_Value                := i_Max_Value;
    o_Attribute.Is_Allow_Multiple_Values := i_Is_Allow_Multiple_Values;
  
    o_Attribute.Attribute_Values := Hrec_Pref.Olx_Attribute_Value_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Add_Value
  (
    o_Attribute in out nocopy Hrec_Pref.Olx_Attribute_Rt,
    i_Code      varchar2,
    i_Label     varchar2
  ) is
    v_Attribute_Value Hrec_Pref.Olx_Attribute_Value_Rt;
  begin
    v_Attribute_Value.Code  := i_Code;
    v_Attribute_Value.Label := i_Label;
  
    o_Attribute.Attribute_Values.Extend();
    o_Attribute.Attribute_Values(o_Attribute.Attribute_Values.Count) := v_Attribute_Value;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Telegram_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Contact_Code number
  ) return Hrec_Telegram_Candidates%rowtype is
    result Hrec_Telegram_Candidates%rowtype;
  begin
    select q.*
      into result
      from Hrec_Telegram_Candidates q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Contact_Code = i_Contact_Code;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_From_To_Message
  (
    i_Wage_From number,
    i_Wage_To   number
  ) return varchar2 is
    result varchar2(500 char);
  begin
    if i_Wage_From is not null then
      result := t('wage from $1', i_Wage_From);
    end if;
  
    if i_Wage_To is not null then
      result := t('wage to $1', i_Wage_To);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Draft return varchar2 is
  begin
    return t('application_status:draft');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Waiting return varchar2 is
  begin
    return t('application_status:waiting');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Approved return varchar2 is
  begin
    return t('application_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Complited return varchar2 is
  begin
    return t('application_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Canceled return varchar2 is
  begin
    return t('application_status:canceled');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hrec_Pref.c_Application_Status_Draft then t_Application_Status_Draft --
    when Hrec_Pref.c_Application_Status_Waiting then t_Application_Status_Waiting --
    when Hrec_Pref.c_Application_Status_Approved then t_Application_Status_Approved --
    when Hrec_Pref.c_Application_Status_Complited then t_Application_Status_Complited --
    when Hrec_Pref.c_Application_Status_Canceled then t_Application_Status_Canceled --   
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Application_Status_Draft,
                                          Hrec_Pref.c_Application_Status_Waiting,
                                          Hrec_Pref.c_Application_Status_Approved,
                                          Hrec_Pref.c_Application_Status_Complited,
                                          Hrec_Pref.c_Application_Status_Canceled),
                           Array_Varchar2(t_Application_Status_Draft,
                                          t_Application_Status_Waiting,
                                          t_Application_Status_Approved,
                                          t_Application_Status_Complited,
                                          t_Application_Status_Canceled));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_All return varchar2 is
  begin
    return t('vacancy_scope:all');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_Employees return varchar2 is
  begin
    return t('vacancy_scope:employees');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_Non_Employees return varchar2 is
  begin
    return t('vacancy_scope:non employees');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Scope(i_Scope varchar2) return varchar2 is
  begin
    return --
    case i_Scope --
    when Hrec_Pref.c_Vacancy_Scope_All then t_Vacancy_Scope_All --
    when Hrec_Pref.c_Vacancy_Scope_Employees then t_Vacancy_Scope_Employees --
    when Hrec_Pref.c_Vacancy_Scope_Non_Employees then t_Vacancy_Scope_Non_Employees --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Scopes return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Vacancy_Scope_All,
                                          Hrec_Pref.c_Vacancy_Scope_Employees,
                                          Hrec_Pref.c_Vacancy_Scope_Non_Employees),
                           Array_Varchar2(t_Vacancy_Scope_All,
                                          t_Vacancy_Scope_Employees,
                                          t_Vacancy_Scope_Non_Employees));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Status_Open return varchar2 is
  begin
    return t('vacancy_status:open');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Status_Close return varchar2 is
  begin
    return t('vacancy_status:closed');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hrec_Pref.c_Vacancy_Status_Open then t_Vacancy_Status_Open --
    when Hrec_Pref.c_Vacancy_Status_Close then t_Vacancy_Status_Close --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Vacancy_Status_Open,
                                          Hrec_Pref.c_Vacancy_Status_Close),
                           Array_Varchar2(t_Vacancy_Status_Open, t_Vacancy_Status_Close));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Operation_Kind_Action return varchar2 is
  begin
    return t('operation_kind:action');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Operation_Kind_Comment return varchar2 is
  begin
    return t('operation_kind:comment');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Operation_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Hrec_Pref.c_Operation_Kind_Action then t_Operation_Kind_Action --
    when Hrec_Pref.c_Operation_Kind_Comment then t_Operation_Kind_Comment --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Operation_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Operation_Kind_Action,
                                          Hrec_Pref.c_Operation_Kind_Comment),
                           Array_Varchar2(t_Operation_Kind_Action, t_Operation_Kind_Comment));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Vacancy_Type_Open return varchar2 is
  begin
    return t('vacancy_type:open');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Vacancy_Type_Closed return varchar2 is
  begin
    return t('vacancy_type:closed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Billing_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Hh_Billing_Type_Standart,
                                          Hrec_Pref.c_Hh_Billing_Type_Free,
                                          Hrec_Pref.c_Hh_Billing_Type_Standart_Plus,
                                          Hrec_Pref.c_Hh_Billing_Type_Premium),
                           Array_Varchar2(t('billing_type:standard'),
                                          t('billing_type:free'),
                                          t('billing_type:standart plus'),
                                          t('billing_type:premium')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Vacancy_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Hh_Vacancy_Type_Open,
                                          Hrec_Pref.c_Hh_Vacancy_Type_Closed),
                           Array_Varchar2(t_Vacancy_Type_Open, t_Vacancy_Type_Closed));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Olx_Advertiser_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Olx_Advertiser_Type_Private,
                                          Hrec_Pref.c_Olx_Advertiser_Type_Businnes),
                           Array_Varchar2(t('olx_advertiser_type:private'),
                                          t('olx_advertiser_type:businnes')));
  end;

end Hrec_Util;
/

create or replace package Href_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype);
  ------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype);

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  );
end Href_Api;
/
create or replace package body Href_Api is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number) is
    v_Person_Id   number := Md_Next.Person_Id;
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  begin
    z_Md_Persons.Insert_One(i_Company_Id  => i_Company_Id,
                            i_Person_Id   => v_Person_Id,
                            i_Name        => 'Timepad Virtual user',
                            i_Person_Kind => Md_Pref.c_Pk_Virtual,
                            i_Email       => null,
                            i_Photo_Sha   => null,
                            i_State       => 'A',
                            i_Code        => null,
                            i_Phone       => null);
  
    z_Md_Users.Insert_One(i_Company_Id               => i_Company_Id,
                          i_User_Id                  => v_Person_Id,
                          i_Name                     => 'Timepad Virtual user',
                          i_Login                    => null,
                          i_Password                 => null,
                          i_State                    => 'A',
                          i_User_Kind                => Md_Pref.c_Uk_Virtual,
                          i_Gender                   => null,
                          i_Manager_Id               => null,
                          i_Timezone_Code            => null,
                          i_Two_Factor_Verification  => Md_Pref.c_Two_Step_Verification_Disabled,
                          i_Password_Changed_On      => null,
                          i_Password_Change_Required => null,
                          i_Order_No                 => null);
  
    z_Href_Timepad_Users.Insert_One(i_Company_Id => i_Company_Id, i_User_Id => v_Person_Id);
  
    -- attach timepad role for virtual user 
    Md_Api.Role_Grant(i_Company_Id => i_Company_Id,
                      i_User_Id    => v_Person_Id,
                      i_Filial_Id  => v_Filial_Head,
                      i_Role_Id    => Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad));
  
    -- attach user to filial
    Md_Api.User_Add_Filial(i_Company_Id => i_Company_Id,
                           i_User_Id    => v_Person_Id,
                           i_Filial_Id  => v_Filial_Head);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  ) is
    v_Exists            boolean := false;
    r_Candidate         Href_Candidates%rowtype;
    r_Person_Exp        Href_Person_Experiences%rowtype;
    r_Edu_Stage         Href_Person_Edu_Stages%rowtype;
    v_Lang_Ids          Array_Number := Array_Number();
    v_Lang              Href_Pref.Person_Lang_Rt;
    v_Exp_Ids           Array_Number;
    v_Exp               Href_Pref.Person_Experience_Rt;
    v_Recom_Ids         Array_Number;
    v_Recom             Href_Pref.Candidate_Recom_Rt;
    v_New_Edu_Stage_Ids Array_Number := Array_Number();
    v_Person_Edu_Stages Array_Number := Array_Number();
  begin
    if z_Href_Candidates.Exist(i_Company_Id   => i_Candidate.Company_Id,
                               i_Filial_Id    => i_Candidate.Filial_Id,
                               i_Candidate_Id => i_Candidate.Person.Person_Id,
                               o_Row          => r_Candidate) then
      v_Exists := true;
    else
      r_Candidate.Company_Id   := i_Candidate.Company_Id;
      r_Candidate.Filial_Id    := i_Candidate.Filial_Id;
      r_Candidate.Candidate_Id := i_Candidate.Person.Person_Id;
    end if;
  
    Person_Save(i_Person                 => i_Candidate.Person, --
                i_Only_Natural           => true,
                i_Check_Required_Columns => i_Check_Required_Columns);
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => r_Candidate.Company_Id,
                                i_Filial_Id  => r_Candidate.Filial_Id,
                                i_Person_Id  => r_Candidate.Candidate_Id,
                                i_State      => 'A');
    end if;
  
    if i_Candidate.Person_Type_Id is not null then
      Mr_Api.Person_Add_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                  i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                  i_Person_Id       => r_Candidate.Candidate_Id,
                                  i_Person_Type_Id  => i_Candidate.Person_Type_Id);
    else
      Mr_Api.Person_Remove_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                     i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                     i_Person_Id       => r_Candidate.Candidate_Id);
    end if;
  
    r_Candidate.Candidate_Kind   := i_Candidate.Candidate_Kind;
    r_Candidate.Source_Id        := i_Candidate.Source_Id;
    r_Candidate.Wage_Expectation := i_Candidate.Wage_Expectation;
    r_Candidate.Cv_Sha           := i_Candidate.Cv_Sha;
    r_Candidate.Note             := i_Candidate.Note;
  
    if v_Exists then
      z_Href_Candidates.Update_Row(r_Candidate);
    else
      z_Href_Candidates.Insert_Row(r_Candidate);
    end if;
  
    -- person details
    if i_Candidate.Extra_Phone is not null then
      z_Href_Person_Details.Save_One(i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Key_Person           => 'N',
                                     i_Access_All_Employees => 'N',
                                     i_Extra_Phone          => i_Candidate.Extra_Phone,
                                     i_Access_Hidden_Salary => 'N');
    else
      z_Href_Person_Details.Delete_One(i_Company_Id => r_Candidate.Company_Id,
                                       i_Person_Id  => r_Candidate.Candidate_Id);
    end if;
  
    -- candidate languages
    v_Lang_Ids := Array_Number();
    v_Lang_Ids.Extend(i_Candidate.Langs.Count);
  
    for i in 1 .. i_Candidate.Langs.Count
    loop
      v_Lang := i_Candidate.Langs(i);
      v_Lang_Ids(i) := v_Lang.Lang_Id;
    
      z_Href_Person_Langs.Save_One(i_Company_Id    => r_Candidate.Company_Id,
                                   i_Person_Id     => r_Candidate.Candidate_Id,
                                   i_Lang_Id       => v_Lang.Lang_Id,
                                   i_Lang_Level_Id => v_Lang.Lang_Level_Id);
    end loop;
  
    delete from Href_Person_Langs t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Person_Id = r_Candidate.Candidate_Id
       and t.Lang_Id not member of v_Lang_Ids;
  
    -- candidate experience
    v_Exp_Ids := Array_Number();
    v_Exp_Ids.Extend(i_Candidate.Experiences.Count);
  
    for i in 1 .. i_Candidate.Experiences.Count
    loop
      v_Exp := i_Candidate.Experiences(i);
      v_Exp_Ids(i) := v_Exp.Person_Experience_Id;
    
      z_Href_Person_Experiences.Init(p_Row                  => r_Person_Exp,
                                     i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Experience_Id => v_Exp.Person_Experience_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Experience_Type_Id   => v_Exp.Experience_Type_Id,
                                     i_Is_Working           => v_Exp.Is_Working,
                                     i_Start_Date           => v_Exp.Start_Date,
                                     i_Num_Year             => v_Exp.Num_Year,
                                     i_Num_Month            => v_Exp.Num_Month,
                                     i_Num_Day              => v_Exp.Num_Day);
    
      Person_Experience_Save(r_Person_Exp);
    end loop;
  
    delete from Href_Person_Experiences e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Person_Experience_Id not member of v_Exp_Ids;
  
    -- candidate recommendations
    v_Recom_Ids := Array_Number();
    v_Recom_Ids.Extend(i_Candidate.Recommendations.Count);
  
    for i in 1 .. i_Candidate.Recommendations.Count
    loop
      v_Recom := i_Candidate.Recommendations(i);
      v_Recom_Ids(i) := v_Recom.Recommendation_Id;
    
      z_Href_Candidate_Recoms.Save_One(i_Company_Id          => r_Candidate.Company_Id,
                                       i_Filial_Id           => r_Candidate.Filial_Id,
                                       i_Recommendation_Id   => v_Recom.Recommendation_Id,
                                       i_Candidate_Id        => r_Candidate.Candidate_Id,
                                       i_Sender_Name         => v_Recom.Sender_Name,
                                       i_Sender_Phone_Number => v_Recom.Sender_Phone_Number,
                                       i_Sender_Email        => v_Recom.Sender_Email,
                                       i_File_Sha            => v_Recom.File_Sha,
                                       i_Order_No            => v_Recom.Order_No,
                                       i_Feedback            => v_Recom.Feedback,
                                       i_Note                => v_Recom.Note);
    end loop;
  
    delete from Href_Candidate_Recoms t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Filial_Id = r_Candidate.Filial_Id
       and t.Candidate_Id = r_Candidate.Candidate_Id
       and t.Recommendation_Id not member of v_Recom_Ids;
  
    -- candidate possibly jobs
    delete from Href_Candidate_Jobs j
     where j.Company_Id = r_Candidate.Company_Id
       and j.Filial_Id = r_Candidate.Filial_Id
       and j.Candidate_Id = r_Candidate.Candidate_Id
       and j.Job_Id not member of i_Candidate.Candidate_Jobs;
  
    for i in 1 .. i_Candidate.Candidate_Jobs.Count
    loop
      z_Href_Candidate_Jobs.Insert_Try(i_Company_Id   => r_Candidate.Company_Id,
                                       i_Filial_Id    => r_Candidate.Filial_Id,
                                       i_Candidate_Id => r_Candidate.Candidate_Id,
                                       i_Job_Id       => i_Candidate.Candidate_Jobs(i));
    end loop;
  
    -- candidate edu stages
    if v_Exists then
      select distinct e.Edu_Stage_Id
        bulk collect
        into v_Person_Edu_Stages
        from Href_Person_Edu_Stages e
       where e.Company_Id = r_Candidate.Company_Id
         and e.Person_Id = r_Candidate.Candidate_Id;
    end if;
  
    v_New_Edu_Stage_Ids := i_Candidate.Edu_Stages multiset Except v_Person_Edu_Stages;
  
    for i in 1 .. v_New_Edu_Stage_Ids.Count
    loop
      r_Edu_Stage.Company_Id          := r_Candidate.Company_Id;
      r_Edu_Stage.Person_Edu_Stage_Id := Href_Next.Person_Edu_Stage_Id;
      r_Edu_Stage.Person_Id           := r_Candidate.Candidate_Id;
      r_Edu_Stage.Edu_Stage_Id        := v_New_Edu_Stage_Ids(i);
    
      Person_Edu_Stage_Save(r_Edu_Stage);
    end loop;
  
    delete from Href_Person_Edu_Stages e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Edu_Stage_Id not member of i_Candidate.Edu_Stages;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) is
  begin
    z_Href_Candidates.Delete_One(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Candidate_Id => i_Candidate_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate form settings
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype) is
  begin
    z_Href_Candidate_Ref_Settings.Save_Row(i_Settings);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  ) is
    r_Candidate_Lang Href_Candidate_Langs%rowtype;
  begin
    delete from Href_Candidate_Langs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Lang_Id not member of i_Lang_Ids;
  
    r_Candidate_Lang.Company_Id := i_Company_Id;
    r_Candidate_Lang.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Lang_Ids.Count
    loop
      r_Candidate_Lang.Lang_Id  := i_Lang_Ids(i);
      r_Candidate_Lang.Order_No := i;
    
      z_Href_Candidate_Langs.Save_Row(r_Candidate_Lang);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  ) is
    r_Candidate_Es Href_Candidate_Edu_Stages%rowtype;
  begin
    delete from Href_Candidate_Edu_Stages q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Edu_Stage_Id not member of i_Edu_Stage_Ids;
  
    r_Candidate_Es.Company_Id := i_Company_Id;
    r_Candidate_Es.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Edu_Stage_Ids.Count
    loop
      r_Candidate_Es.Edu_Stage_Id := i_Edu_Stage_Ids(i);
      r_Candidate_Es.Order_No     := i;
    
      z_Href_Candidate_Edu_Stages.Save_Row(r_Candidate_Es);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt) is
    r_Employee Mhr_Employees%rowtype;
    v_Exists   boolean := false;
  begin
    if z_Md_Persons.Exist_Lock(i_Company_Id => i_Employee.Person.Company_Id,
                               i_Person_Id  => i_Employee.Person.Person_Id) then
      v_Exists := true;
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Employee.Person.Company_Id then
      Person_Save(i_Employee.Person);
    end if;
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => i_Employee.Person.Company_Id,
                                i_Filial_Id  => i_Employee.Filial_Id,
                                i_Person_Id  => i_Employee.Person.Person_Id,
                                i_State      => 'A');
    end if;
  
    if not z_Mhr_Employees.Exist_Lock(i_Company_Id  => i_Employee.Person.Company_Id,
                                      i_Filial_Id   => i_Employee.Filial_Id,
                                      i_Employee_Id => i_Employee.Person.Person_Id,
                                      o_Row         => r_Employee) then
      r_Employee.Company_Id  := i_Employee.Person.Company_Id;
      r_Employee.Filial_Id   := i_Employee.Filial_Id;
      r_Employee.Employee_Id := i_Employee.Person.Person_Id;
    end if;
  
    r_Employee.State := i_Employee.State;
  
    Mhr_Api.Employee_Save(r_Employee);
  
    if Htt_Util.Location_Sync_Global_Load(i_Company_Id => r_Employee.Company_Id,
                                          i_Filial_Id  => r_Employee.Filial_Id) = 'Y' then
      Htt_Core.Person_Sync_Locations(i_Company_Id => r_Employee.Company_Id,
                                     i_Filial_Id  => r_Employee.Filial_Id,
                                     i_Person_Id  => r_Employee.Employee_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  ) is
  begin
    z_Mhr_Employees.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Employee_Id => i_Employee_Id,
                               i_Division_Id => Option_Number(i_Division_Id),
                               i_Job_Id      => Option_Number(i_Job_Id),
                               i_Rank_Id     => Option_Number(i_Rank_Id));
  
    -- person update for update modified_id on z package  
    z_Md_Persons.Update_One(i_Company_Id => i_Company_Id, --
                            i_Person_Id  => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
  begin
    Mhr_Api.Employee_Delete(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Employee_Id => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype) is
  begin
    z_Href_Fixed_Term_Bases.Save_Row(i_Fixed_Term_Base);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  ) is
  begin
    z_Href_Fixed_Term_Bases.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Fixed_Term_Base_Id => i_Fixed_Term_Base_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype) is
  begin
    z_Href_Edu_Stages.Save_Row(i_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  ) is
  begin
    z_Href_Edu_Stages.Delete_One(i_Company_Id => i_Company_Id, i_Edu_Stage_Id => i_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype) is
  begin
    z_Href_Science_Branches.Save_Row(i_Science_Branch);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  ) is
  begin
    z_Href_Science_Branches.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Science_Branch_Id => i_Science_Branch_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype) is
  begin
    z_Href_Institutions.Save_Row(i_Institution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  ) is
  begin
    z_Href_Institutions.Delete_One(i_Company_Id     => i_Company_Id,
                                   i_Institution_Id => i_Institution_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype) is
    r_Specialty Href_Specialties%rowtype;
  begin
    if z_Href_Specialties.Exist_Lock(i_Company_Id   => i_Specialty.Company_Id,
                                     i_Specialty_Id => i_Specialty.Specialty_Id,
                                     o_Row          => r_Specialty) then
      if i_Specialty.Kind <> r_Specialty.Kind then
        Href_Error.Raise_001(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name);
      end if;
    end if;
  
    if i_Specialty.Parent_Id is not null then
      r_Specialty := z_Href_Specialties.Lock_Load(i_Company_Id   => i_Specialty.Company_Id,
                                                  i_Specialty_Id => i_Specialty.Parent_Id);
    
      if r_Specialty.Kind <> Href_Pref.c_Specialty_Kind_Group then
        Href_Error.Raise_002(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name,
                             i_Parent_Name    => r_Specialty.Name);
      end if;
    end if;
  
    z_Href_Specialties.Save_Row(i_Specialty);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  ) is
  begin
    z_Href_Specialties.Delete_One(i_Company_Id => i_Company_Id, i_Specialty_Id => i_Specialty_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype) is
  begin
    z_Href_Langs.Save_Row(i_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Langs.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Id => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype) is
  begin
    z_Href_Lang_Levels.Save_Row(i_Lang_Level);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  ) is
  begin
    z_Href_Lang_Levels.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Level_Id => i_Lang_Level_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist_Lock(i_Company_Id  => i_Document_Type.Company_Id,
                                        i_Doc_Type_Id => i_Document_Type.Doc_Type_Id,
                                        o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_003(i_Document_Type_Id   => i_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => i_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Save_Row(i_Document_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  ) is
  begin
    z_Href_Document_Types.Update_One(i_Company_Id  => i_Company_Id,
                                     i_Doc_Type_Id => i_Doc_Type_Id,
                                     i_Is_Required => Option_Varchar2(i_Is_Required));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  ) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist(i_Company_Id  => i_Company_Id,
                                   i_Doc_Type_Id => i_Doc_Type_Id,
                                   o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_004(i_Document_Type_Id   => r_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => r_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Delete_One(i_Company_Id => i_Company_Id, i_Doc_Type_Id => i_Doc_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  ) is
  begin
    for i in 1 .. i_Doc_Type_Ids.Count
    loop
      z_Href_Excluded_Document_Types.Insert_Try(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => i_Division_Id,
                                                i_Job_Id      => i_Job_Id,
                                                i_Doc_Type_Id => i_Doc_Type_Ids(i));
    end loop;
  
    delete from Href_Excluded_Document_Types t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Division_Id = i_Division_Id
       and t.Job_Id = i_Job_Id
       and t.Doc_Type_Id not member of i_Doc_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) is
  begin
    Excluded_Document_Type_Save(i_Company_Id   => i_Company_Id,
                                i_Filial_Id    => i_Filial_Id,
                                i_Division_Id  => i_Division_Id,
                                i_Job_Id       => i_Job_Id,
                                i_Doc_Type_Ids => Array_Number());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype) is
  begin
    z_Href_Reference_Types.Save_Row(i_Reference_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  ) is
  begin
    z_Href_Reference_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Reference_Type_Id => i_Reference_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype) is
  begin
    z_Href_Relation_Degrees.Save_Row(i_Relation_Degree);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  ) is
  begin
    z_Href_Relation_Degrees.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Relation_Degree_Id => i_Relation_Degree_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype) is
  begin
    z_Href_Marital_Statuses.Save_Row(i_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  ) is
  begin
    z_Href_Marital_Statuses.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Marital_Status_Id => i_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype) is
  begin
    z_Href_Experience_Types.Save_Row(i_Experience_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  ) is
  begin
    z_Href_Experience_Types.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Experience_Type_Id => i_Experience_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype) is
  begin
    z_Href_Nationalities.Save_Row(i_Nationality);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  ) is
  begin
    z_Href_Nationalities.Delete_One(i_Company_Id     => i_Company_Id,
                                    i_Nationality_Id => i_Nationality_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype) is
  begin
    z_Href_Awards.Save_Row(i_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  ) is
  begin
    z_Href_Awards.Delete_One(i_Company_Id => i_Company_Id, i_Award_Id => i_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype) is
  begin
    z_Href_Inventory_Types.Save_Row(i_Inventory_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  ) is
  begin
    z_Href_Inventory_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Inventory_Type_Id => i_Inventory_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  ) is
    r_Natural_Person Mr_Natural_Persons%rowtype;
    r_Person_Detail  Mr_Person_Details%rowtype;
    r_Detail         Href_Person_Details%rowtype;
    v_Phone          varchar2(25) := Regexp_Replace(i_Person.Main_Phone, '\D', '');
  
    --------------------------------------------------
    Procedure Check_Required_Columns is
      v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    begin
      if not i_Check_Required_Columns then
        return;
      end if;
    
      v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(i_Person.Company_Id);
    
      if v_Col_Required_Settings.Last_Name = 'Y' and trim(i_Person.Last_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Last_Name);
      end if;
    
      if v_Col_Required_Settings.Middle_Name = 'Y' and trim(i_Person.Middle_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Middle_Name);
      end if;
    
      if v_Col_Required_Settings.Birthday = 'Y' and i_Person.Birthday is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Birthday);
      end if;
    
      if v_Col_Required_Settings.Phone_Number = 'Y' and trim(v_Phone) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Phone_Number);
      end if;
    
      if v_Col_Required_Settings.Email = 'Y' and trim(i_Person.Email) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Email);
      end if;
    
      if v_Col_Required_Settings.Region = 'Y' and i_Person.Region_Id is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Region);
      end if;
    
      if v_Col_Required_Settings.Address = 'Y' and trim(i_Person.Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Address);
      end if;
    
      if v_Col_Required_Settings.Legal_Address = 'Y' and trim(i_Person.Legal_Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Legal_Address);
      end if;
    end;
  begin
    -- check required columns
    Check_Required_Columns;
  
    -- natural person save
    r_Natural_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Person.Company_Id,
                                                  i_Person_Id  => i_Person.Person_Id);
  
    r_Natural_Person.Company_Id  := i_Person.Company_Id;
    r_Natural_Person.Person_Id   := i_Person.Person_Id;
    r_Natural_Person.First_Name  := i_Person.First_Name;
    r_Natural_Person.Last_Name   := i_Person.Last_Name;
    r_Natural_Person.Middle_Name := i_Person.Middle_Name;
    r_Natural_Person.Gender      := i_Person.Gender;
    r_Natural_Person.Birthday    := i_Person.Birthday;
    r_Natural_Person.State       := i_Person.State;
    r_Natural_Person.Code        := i_Person.Code;
  
    Mr_Api.Natural_Person_Save(r_Natural_Person);
  
    Md_Api.Person_Update(i_Company_Id => r_Natural_Person.Company_Id,
                         i_Person_Id  => r_Natural_Person.Person_Id,
                         i_Email      => Option_Varchar2(i_Person.Email),
                         i_Phone      => Option_Varchar2(v_Phone),
                         i_Photo_Sha  => Option_Varchar2(i_Person.Photo_Sha));
  
    -- person detail save
    r_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                                i_Person_Id  => i_Person.Person_Id);
  
    r_Person_Detail.Company_Id     := i_Person.Company_Id;
    r_Person_Detail.Person_Id      := i_Person.Person_Id;
    r_Person_Detail.Tin            := i_Person.Tin;
    r_Person_Detail.Main_Phone     := i_Person.Main_Phone;
    r_Person_Detail.Address        := i_Person.Address;
    r_Person_Detail.Legal_Address  := i_Person.Legal_Address;
    r_Person_Detail.Region_Id      := i_Person.Region_Id;
    r_Person_Detail.Note           := i_Person.Note;
    r_Person_Detail.Is_Budgetarian := 'Y';
  
    Mr_Api.Person_Detail_Save(r_Person_Detail);
  
    r_Detail := z_Href_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                           i_Person_Id  => i_Person.Person_Id);
  
    if not i_Only_Natural then
      if i_Person.Access_All_Employees is not null then
        r_Detail.Access_All_Employees := i_Person.Access_All_Employees;
      else
        r_Detail.Access_All_Employees := Nvl(r_Detail.Access_All_Employees, 'N');
      end if;
    
      r_Detail.Company_Id           := i_Person.Company_Id;
      r_Detail.Person_Id            := i_Person.Person_Id;
      r_Detail.Iapa                 := i_Person.Iapa;
      r_Detail.Npin                 := i_Person.Npin;
      r_Detail.Nationality_Id       := i_Person.Nationality_Id;
      r_Detail.Key_Person           := i_Person.Key_Person;
      r_Detail.Extra_Phone          := i_Person.Extra_Phone;
      r_Detail.Corporate_Email      := i_Person.Corporate_Email;
      r_Detail.Access_All_Employees := r_Detail.Access_All_Employees;
      r_Detail.Access_Hidden_Salary := Coalesce(i_Person.Access_Hidden_Salary,
                                                r_Detail.Access_Hidden_Salary,
                                                'N');
    
      Person_Detail_Save(r_Detail);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    Md_Api.User_Delete(i_Company_Id => i_Company_Id, i_User_Id => i_Person_Id);
    Mr_Api.Natural_Person_Delete(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  ) is
    r_Person_Detail         Href_Person_Details%rowtype := i_Person_Detail;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(r_Person_Detail.Company_Id);
  
    if i_Requirable and v_Col_Required_Settings.Npin = 'Y' and trim(r_Person_Detail.Npin) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Npin);
    end if;
  
    if i_Requirable and v_Col_Required_Settings.Iapa = 'Y' and trim(r_Person_Detail.Iapa) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Iapa);
    end if;
  
    r_Person_Detail.Key_Person           := Nvl(r_Person_Detail.Key_Person, 'N');
    r_Person_Detail.Access_All_Employees := Nvl(r_Person_Detail.Access_All_Employees, 'N');
    r_Person_Detail.Access_Hidden_Salary := Nvl(r_Person_Detail.Access_Hidden_Salary, 'N');
  
    z_Href_Person_Details.Save_Row(r_Person_Detail);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype) is
    r_Person_Edu_Stage Href_Person_Edu_Stages%rowtype;
  begin
    if z_Href_Person_Edu_Stages.Exist_Lock(i_Company_Id          => i_Person_Edu_Stage.Company_Id,
                                           i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id,
                                           o_Row                 => r_Person_Edu_Stage) then
      if r_Person_Edu_Stage.Person_Id <> i_Person_Edu_Stage.Person_Id then
        Href_Error.Raise_005(i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id);
      end if;
    end if;
  
    z_Href_Person_Edu_Stages.Save_Row(i_Person_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  ) is
  begin
    z_Href_Person_Edu_Stages.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
    
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Insert_Try(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Delete_One(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype) is
  begin
    z_Href_Person_Langs.Save_Row(i_Person_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Person_Langs.Delete_One(i_Company_Id => i_Company_Id,
                                   i_Person_Id  => i_Person_Id,
                                   i_Lang_Id    => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype) is
    r_Person_Reference Href_Person_References%rowtype;
  begin
    if z_Href_Person_References.Exist_Lock(i_Company_Id          => i_Person_Reference.Company_Id,
                                           i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id,
                                           o_Row                 => r_Person_Reference) then
      if r_Person_Reference.Person_Id <> i_Person_Reference.Person_Id then
        Href_Error.Raise_009(i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id);
      end if;
    end if;
  
    z_Href_Person_References.Save_Row(i_Person_Reference);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  ) is
  begin
    z_Href_Person_References.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Reference_Id => i_Person_Reference_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype) is
    r_Person_Family_Member Href_Person_Family_Members%rowtype;
  begin
    if z_Href_Person_Family_Members.Exist_Lock(i_Company_Id              => i_Person_Family_Member.Company_Id,
                                               i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id,
                                               o_Row                     => r_Person_Family_Member) then
      if r_Person_Family_Member.Person_Id <> i_Person_Family_Member.Person_Id then
        Href_Error.Raise_010(i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id);
      end if;
    end if;
  
    z_Href_Person_Family_Members.Save_Row(i_Person_Family_Member);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  ) is
  begin
    z_Href_Person_Family_Members.Delete_One(i_Company_Id              => i_Company_Id,
                                            i_Person_Family_Member_Id => i_Person_Family_Member_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype) is
    r_Person_Marital_Status Href_Person_Marital_Statuses%rowtype;
  begin
    if z_Href_Person_Marital_Statuses.Exist_Lock(i_Company_Id               => i_Person_Marital_Status.Company_Id,
                                                 i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id,
                                                 o_Row                      => r_Person_Marital_Status) then
      if r_Person_Marital_Status.Person_Id <> i_Person_Marital_Status.Person_Id then
        Href_Error.Raise_011(i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id);
      end if;
    end if;
  
    z_Href_Person_Marital_Statuses.Save_Row(i_Person_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  ) is
  begin
    z_Href_Person_Marital_Statuses.Delete_One(i_Company_Id               => i_Company_Id,
                                              i_Person_Marital_Status_Id => i_Person_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype) is
    r_Person_Experience Href_Person_Experiences%rowtype;
  begin
    if z_Href_Person_Experiences.Exist_Lock(i_Company_Id           => i_Person_Experience.Company_Id,
                                            i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id,
                                            o_Row                  => r_Person_Experience) then
      if r_Person_Experience.Person_Id <> i_Person_Experience.Person_Id then
        Href_Error.Raise_012(i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id);
      end if;
    end if;
  
    r_Person_Experience.Company_Id           := i_Person_Experience.Company_Id;
    r_Person_Experience.Person_Experience_Id := i_Person_Experience.Person_Experience_Id;
    r_Person_Experience.Person_Id            := i_Person_Experience.Person_Id;
    r_Person_Experience.Experience_Type_Id   := i_Person_Experience.Experience_Type_Id;
    r_Person_Experience.Is_Working           := i_Person_Experience.Is_Working;
    r_Person_Experience.Start_Date           := i_Person_Experience.Start_Date;
  
    if r_Person_Experience.Is_Working = 'N' then
      r_Person_Experience.Num_Year  := Nvl(i_Person_Experience.Num_Year, 0);
      r_Person_Experience.Num_Month := Nvl(i_Person_Experience.Num_Month, 0);
      r_Person_Experience.Num_Day   := Nvl(i_Person_Experience.Num_Day, 0);
    else
      r_Person_Experience.Num_Year  := null;
      r_Person_Experience.Num_Month := null;
      r_Person_Experience.Num_Day   := null;
    end if;
  
    z_Href_Person_Experiences.Save_Row(r_Person_Experience);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  ) is
  begin
    z_Href_Person_Experiences.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Experience_Id => i_Person_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype) is
    r_Person_Award Href_Person_Awards%rowtype;
  begin
    if z_Href_Person_Awards.Exist_Lock(i_Company_Id      => i_Person_Award.Company_Id,
                                       i_Person_Award_Id => i_Person_Award.Person_Award_Id,
                                       o_Row             => r_Person_Award) then
      if r_Person_Award.Person_Id <> i_Person_Award.Person_Id then
        Href_Error.Raise_013(i_Person_Award_Id => i_Person_Award.Person_Award_Id);
      end if;
    end if;
  
    z_Href_Person_Awards.Save_Row(i_Person_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  ) is
  begin
    z_Href_Person_Awards.Delete_One(i_Company_Id      => i_Company_Id,
                                    i_Person_Award_Id => i_Person_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype) is
    r_Person_Work_Place Href_Person_Work_Places%rowtype;
  begin
    if z_Href_Person_Work_Places.Exist_Lock(i_Company_Id           => i_Person_Work_Place.Company_Id,
                                            i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id,
                                            o_Row                  => r_Person_Work_Place) then
      if r_Person_Work_Place.Person_Id <> i_Person_Work_Place.Person_Id then
        Href_Error.Raise_014(i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id);
      end if;
    end if;
  
    z_Href_Person_Work_Places.Save_Row(i_Person_Work_Place);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  ) is
  begin
    z_Href_Person_Work_Places.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Work_Place_Id => i_Person_Work_Place_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype) is
    r_Doc Href_Person_Documents%rowtype;
  begin
    if z_Href_Person_Documents.Exist_Lock(i_Company_Id  => i_Document.Company_Id,
                                          i_Document_Id => i_Document.Document_Id,
                                          o_Row         => r_Doc) then
      if r_Doc.Person_Id <> i_Document.Person_Id then
        Href_Error.Raise_015(i_Document_Id => i_Document.Document_Id);
      end if;
    end if;
  
    z_Href_Person_Documents.Save_Row(i_Document);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_New),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Approved),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Rejected),
                                       i_Rejected_Note => Option_Varchar2(i_Rejected_Note));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Delete_One(i_Company_Id  => i_Company_Id,
                                       i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Insert_Try(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Delete_One(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype) is
  begin
    z_Href_Person_Inventories.Save_Row(i_Person_Inventory);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  ) is
  begin
    z_Href_Person_Inventories.Delete_One(i_Company_Id          => i_Company_Id,
                                         i_Person_Inventory_Id => i_Person_Inventory_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id  => Md_Env.Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      for i in 1 .. i_Job_Group_Ids.Count
      loop
        z_Href_Person_Hidden_Salary_Job_Groups.Insert_Try(i_Company_Id   => i_Company_Id,
                                                          i_Person_Id    => i_Person_Id,
                                                          i_Job_Group_Id => i_Job_Group_Ids(i));
      end loop;
    
      delete Href_Person_Hidden_Salary_Job_Groups q
       where q.Company_Id = i_Company_Id
         and q.Person_Id = i_Person_Id
         and q.Job_Group_Id not member of i_Job_Group_Ids;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype) is
  begin
    z_Href_Labor_Functions.Save_Row(i_Labor_Function);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  ) is
  begin
    z_Href_Labor_Functions.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Labor_Function_Id => i_Labor_Function_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype) is
  begin
    z_Href_Sick_Leave_Reasons.Save_Row(i_Sick_Leave_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Sick_Leave_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype) is
  begin
    z_Href_Business_Trip_Reasons.Save_Row(i_Business_Trip_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Business_Trip_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype) is
  begin
    z_Href_Dismissal_Reasons.Save_Row(i_Dismissal_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  ) is
  begin
    z_Href_Dismissal_Reasons.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Dismissal_Reason_Id => i_Dismissal_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype) is
  begin
    z_Href_Wages.Save_Row(i_Wage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  ) is
  begin
    z_Href_Wages.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Wage_Id    => i_Wage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype) is
  begin
    z_Href_Employment_Sources.Save_Row(i_Employment_Source);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  ) is
  begin
    z_Href_Employment_Sources.Delete_One(i_Company_Id => i_Company_Id, i_Source_Id => i_Source_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype) is
  begin
    Href_Core.Indicator_Save(i_Indicator);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  ) is
    r_Indicator Href_Indicators%rowtype;
  begin
    r_Indicator := z_Href_Indicators.Load(i_Company_Id   => i_Company_Id,
                                          i_Indicator_Id => i_Indicator_Id);
  
    if r_Indicator.Pcode is not null then
      Href_Error.Raise_016(i_Indicator_Id   => r_Indicator.Indicator_Id,
                           i_Indicator_Name => r_Indicator.Name);
    end if;
  
    z_Href_Indicators.Delete_One(i_Company_Id => i_Company_Id, i_Indicator_Id => i_Indicator_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype) is
    r_Fte       Href_Ftes%rowtype;
    v_Pcode     Href_Ftes.Pcode%type;
    v_Fte_Value number := i_Fte.Fte_Value;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Fte.Company_Id,
                              i_Fte_Id     => i_Fte.Fte_Id,
                              o_Row        => r_Fte) and r_Fte.Pcode is not null then
      v_Fte_Value := r_Fte.Fte_Value;
      v_Pcode     := r_Fte.Pcode;
    end if;
  
    r_Fte           := i_Fte;
    r_Fte.Fte_Value := v_Fte_Value;
    r_Fte.Pcode     := v_Pcode;
  
    z_Href_Ftes.Save_Row(r_Fte);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  ) is
    r_Fte Href_Ftes%rowtype;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id, o_Row => r_Fte) then
      if r_Fte.Pcode is not null then
        Href_Error.Raise_017(i_Fte_Id => r_Fte.Fte_Id, i_Fte_Name => r_Fte.Name);
      end if;
    
      z_Href_Ftes.Delete_One(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  
    --------------------------------------------------
    Procedure Save_Pref
    (
      i_Code  varchar2,
      i_Value varchar2
    ) is
    begin
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => v_Filial_Head,
                             i_Code       => i_Code,
                             i_Value      => i_Value);
    end;
  begin
    if i_Setting.Request_Note = 'Y' and
       (i_Setting.Request_Note_Limit > 300 or i_Setting.Request_Note_Limit < 1) then
      Href_Error.Raise_034(i_Setting.Request_Note_Limit);
    end if;
  
    if i_Setting.Plan_Change_Note = 'Y' and
       (i_Setting.Plan_Change_Note_Limit > 300 or i_Setting.Plan_Change_Note_Limit < 1) then
      Href_Error.Raise_035(i_Setting.Plan_Change_Note_Limit);
    end if;
  
    Save_Pref(Href_Pref.c_Pref_Crs_Last_Name, i_Setting.Last_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Middle_Name, i_Setting.Middle_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Birthday, i_Setting.Birthday);
    Save_Pref(Href_Pref.c_Pref_Crs_Phone_Number, i_Setting.Phone_Number);
    Save_Pref(Href_Pref.c_Pref_Crs_Email, i_Setting.Email);
    Save_Pref(Href_Pref.c_Pref_Crs_Region, i_Setting.Region);
    Save_Pref(Href_Pref.c_Pref_Crs_Address, i_Setting.Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Legal_Address, i_Setting.Legal_Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Passport, i_Setting.Passport);
    Save_Pref(Href_Pref.c_Pref_Crs_Npin, i_Setting.Npin);
    Save_Pref(Href_Pref.c_Pref_Crs_Iapa, i_Setting.Iapa);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note, i_Setting.Request_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit, i_Setting.Request_Note_Limit);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note, i_Setting.Plan_Change_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit, i_Setting.Plan_Change_Note_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype) is
  begin
    z_Href_Badge_Templates.Save_Row(i_Badge_Template);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number) is
  begin
    z_Href_Badge_Templates.Delete_One(i_Badge_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Href_Error.Raise_031;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Setting,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in (Href_Pref.c_Vpu_Column_Name,
                       Href_Pref.c_Vpu_Column_Passport_Number,
                       Href_Pref.c_Vpu_Column_Npin) then
      Href_Error.Raise_032;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Column,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  ) is
  begin
    if i_Setting.Fte_Limit < 0 then
      Href_Error.Raise_036(i_Setting.Fte_Limit);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Fte_Limit_Setting,
                           i_Value      => Nvl(i_Setting.Fte_Limit_Setting, 'N'));
  
    if i_Setting.Fte_Limit_Setting = 'Y' then
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                             i_Code       => Href_Pref.c_Fte_Limit,
                             i_Value      => Nvl(i_Setting.Fte_Limit, Href_Pref.c_Fte_Limit_Default));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt) is
    r_Bank_Account Mkcs_Bank_Accounts%rowtype;
  begin
    r_Bank_Account.Company_Id        := i_Bank_Account.Company_Id;
    r_Bank_Account.Bank_Account_Id   := i_Bank_Account.Bank_Account_Id;
    r_Bank_Account.Bank_Id           := i_Bank_Account.Bank_Id;
    r_Bank_Account.Bank_Account_Code := i_Bank_Account.Bank_Account_Code;
    r_Bank_Account.Name              := i_Bank_Account.Name;
    r_Bank_Account.Person_Id         := i_Bank_Account.Person_Id;
    r_Bank_Account.Is_Main           := i_Bank_Account.Is_Main;
    r_Bank_Account.Currency_Id       := i_Bank_Account.Currency_Id;
    r_Bank_Account.Note              := i_Bank_Account.Note;
    r_Bank_Account.State             := i_Bank_Account.State;
  
    Mkcs_Api.Bank_Account_Save(r_Bank_Account);
  
    z_Href_Bank_Accounts.Save_One(i_Company_Id      => r_Bank_Account.Company_Id,
                                  i_Bank_Account_Id => r_Bank_Account.Bank_Account_Id,
                                  i_Card_Number     => i_Bank_Account.Card_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  ) is
  begin
    Mkcs_Api.Bank_Account_Delete(i_Company_Id      => i_Company_Id,
                                 i_Bank_Account_Id => i_Bank_Account_Id);
  end;

end Href_Api;
/

create or replace package Href_Pref is
  ----------------------------------------------------------------------------------------------------
  type Person_Rt is record(
    Company_Id           number,
    Person_Id            number,
    First_Name           varchar2(250 char),
    Last_Name            varchar2(250 char),
    Middle_Name          varchar2(250 char),
    Gender               varchar2(1),
    Birthday             date,
    Nationality_Id       number,
    Photo_Sha            varchar2(64),
    Tin                  varchar2(18 char),
    Iapa                 varchar2(20 char),
    Npin                 varchar2(14 char),
    Region_Id            number,
    Main_Phone           varchar2(100 char),
    Email                varchar2(100 char),
    Address              varchar2(500 char),
    Legal_Address        varchar2(300 char),
    Key_Person           varchar2(1),
    Extra_Phone          varchar2(100 char),
    Corporate_Email      varchar2(100 char),
    Access_All_Employees varchar2(1),
    Access_Hidden_Salary varchar2(1),
    State                varchar2(1),
    Code                 varchar2(50 char),
    Note                 varchar2(500 char));
  ----------------------------------------------------------------------------------------------------
  type Person_Lang_Rt is record(
    Lang_Id       number,
    Lang_Level_Id number);
  type Person_Lang_Nt is table of Person_Lang_Rt;
  ----------------------------------------------------------------------------------------------------
  type Person_Experience_Rt is record(
    Person_Experience_Id number,
    Experience_Type_Id   number,
    Is_Working           varchar2(1),
    Start_Date           date,
    Num_Year             number,
    Num_Month            number,
    Num_Day              number);
  type Person_Experience_Nt is table of Person_Experience_Rt;
  ----------------------------------------------------------------------------------------------------
  type Employee_Info_Rt is record(
    Context_Id number,
    Column_Key varchar2(100),
    Event      varchar2(1),
    value      varchar2(2000),
    timestamp  date,
    User_Id    number);
  type Employee_Info_Nt is table of Employee_Info_Rt;
  ----------------------------------------------------------------------------------------------------
  type Candidate_Recom_Rt is record(
    Recommendation_Id   number,
    Sender_Name         varchar2(300 char),
    Sender_Phone_Number varchar2(30 char),
    Sender_Email        varchar2(320 char),
    File_Sha            varchar2(64),
    Order_No            number,
    Feedback            varchar2(300 char),
    Note                varchar2(300 char));
  type Candidate_Recom_Nt is table of Candidate_Recom_Rt;
  ----------------------------------------------------------------------------------------------------
  type Candidate_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Person_Type_Id   number,
    Candidate_Kind   varchar2(1),
    Source_Id        number,
    Wage_Expectation number,
    Cv_Sha           varchar2(64),
    Note             varchar2(300 char),
    Extra_Phone      varchar2(100 char),
    Edu_Stages       Array_Number,
    Candidate_Jobs   Array_Number,
    Person           Person_Rt,
    Langs            Person_Lang_Nt,
    Experiences      Person_Experience_Nt,
    Recommendations  Candidate_Recom_Nt);
  ----------------------------------------------------------------------------------------------------
  type Employee_Rt is record(
    Person    Person_Rt,
    Filial_Id number,
    State     varchar2(1));
  ----------------------------------------------------------------------------------------------------
  type Indicator_Rt is record(
    Indicator_Id    number,
    Indicator_Value number);
  type Indicator_Nt is table of Indicator_Rt;
  ----------------------------------------------------------------------------------------------------
  type Staff_Licensed_Rt is record(
    Staff_Id number,
    Period   date,
    Licensed varchar2(1));
  type Staff_Licensed_Nt is table of Staff_Licensed_Rt;
  ----------------------------------------------------------------------------------------------------
  type Oper_Type_Rt is record(
    Oper_Type_Id  number,
    Indicator_Ids Array_Number);
  type Oper_Type_Nt is table of Oper_Type_Rt;
  ----------------------------------------------------------------------------------------------------
  type Period_Rt is record(
    Period_Begin date,
    Period_End   date);
  type Period_Nt is table of Period_Rt;
  -- Fte limit
  ----------------------------------------------------------------------------------------------------
  type Fte_Limit_Rt is record(
    Fte_Limit_Setting varchar2(1),
    Fte_Limit         number);
  ---------------------------------------------------------------------------------------------------- 
  c_Fte_Limit_Setting constant varchar2(50) := 'VHR:FTE_LIMIT_SETTING';
  c_Fte_Limit         constant varchar2(50) := 'VHR:FTE_LIMIT';
  c_Fte_Limit_Default constant number := 1.5;
  ----------------------------------------------------------------------------------------------------
  type Col_Required_Setting_Rt is record(
    Last_Name              varchar2(1) := 'N',
    Middle_Name            varchar2(1) := 'N',
    Birthday               varchar2(1) := 'N',
    Phone_Number           varchar2(1) := 'N',
    Email                  varchar2(1) := 'N',
    Region                 varchar2(1) := 'N',
    Address                varchar2(1) := 'N',
    Legal_Address          varchar2(1) := 'N',
    Passport               varchar2(1) := 'N',
    Npin                   varchar2(1) := 'N',
    Iapa                   varchar2(1) := 'N',
    Request_Note           varchar2(1) := 'N',
    Request_Note_Limit     number := 0,
    Plan_Change_Note       varchar2(1) := 'N',
    Plan_Change_Note_Limit number := 0);
  ----------------------------------------------------------------------------------------------------  
  type Bank_Account_Rt is record(
    Company_Id        number,
    Bank_Account_Id   number,
    Bank_Id           number,
    Bank_Account_Code varchar2(100 char),
    name              varchar2(200 char),
    Person_Id         number,
    Is_Main           varchar2(1),
    Currency_Id       number,
    Note              varchar2(200 char),
    Card_Number       varchar2(20),
    State             varchar2(1));
  ----------------------------------------------------------------------------------------------------
  -- Pcode Role
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Role_Hr         constant varchar2(10) := 'VHR:1';
  c_Pcode_Role_Supervisor constant varchar2(10) := 'VHR:2';
  c_Pcode_Role_Staff      constant varchar2(10) := 'VHR:3';
  c_Pcode_Role_Accountant constant varchar2(10) := 'VHR:4';
  c_Pcode_Role_Timepad    constant varchar2(10) := 'VHR:5';
  c_Pcode_Role_Recruiter  constant varchar2(10) := 'VHR:6';
  ----------------------------------------------------------------------------------------------------
  -- Pcode Document Type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Document_Type_Default_Passport constant varchar2(20) := 'VHR:1';
  ----------------------------------------------------------------------------------------------------
  -- Person Document Status
  ----------------------------------------------------------------------------------------------------
  c_Person_Document_Status_New      constant varchar2(1) := 'N';
  c_Person_Document_Status_Approved constant varchar2(1) := 'A';
  c_Person_Document_Status_Rejected constant varchar2(1) := 'R';
  ----------------------------------------------------------------------------------------------------
  -- Person Document Owe Status
  ----------------------------------------------------------------------------------------------------
  c_Person_Document_Owe_Status_Complete constant varchar2(1) := 'C';
  c_Person_Document_Owe_Status_Partial  constant varchar2(1) := 'P';
  c_Person_Document_Owe_Status_Exempt   constant varchar2(1) := 'E';
  ----------------------------------------------------------------------------------------------------
  -- Pcode Indicator
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Indicator_Wage                          constant varchar2(20) := 'VHR:1';
  c_Pcode_Indicator_Rate                          constant varchar2(20) := 'VHR:2';
  c_Pcode_Indicator_Plan_Days                     constant varchar2(20) := 'VHR:3';
  c_Pcode_Indicator_Fact_Days                     constant varchar2(20) := 'VHR:4';
  c_Pcode_Indicator_Plan_Hours                    constant varchar2(20) := 'VHR:5';
  c_Pcode_Indicator_Fact_Hours                    constant varchar2(20) := 'VHR:6';
  c_Pcode_Indicator_Perf_Bonus                    constant varchar2(20) := 'VHR:7';
  c_Pcode_Indicator_Perf_Extra_Bonus              constant varchar2(20) := 'VHR:8';
  c_Pcode_Indicator_Working_Days                  constant varchar2(20) := 'VHR:9';
  c_Pcode_Indicator_Working_Hours                 constant varchar2(20) := 'VHR:10';
  c_Pcode_Indicator_Sick_Leave_Coefficient        constant varchar2(20) := 'VHR:11';
  c_Pcode_Indicator_Business_Trip_Days            constant varchar2(20) := 'VHR:12';
  c_Pcode_Indicator_Vacation_Days                 constant varchar2(20) := 'VHR:13';
  c_Pcode_Indicator_Mean_Working_Days             constant varchar2(20) := 'VHR:14';
  c_Pcode_Indicator_Sick_Leave_Days               constant varchar2(20) := 'VHR:15';
  c_Pcode_Indicator_Hourly_Wage                   constant varchar2(20) := 'VHR:16';
  c_Pcode_Indicator_Overtime_Hours                constant varchar2(20) := 'VHR:17';
  c_Pcode_Indicator_Overtime_Coef                 constant varchar2(20) := 'VHR:18';
  c_Pcode_Indicator_Penalty_For_Late              constant varchar2(20) := 'VHR:19';
  c_Pcode_Indicator_Penalty_For_Early_Output      constant varchar2(20) := 'VHR:20';
  c_Pcode_Indicator_Penalty_For_Absence           constant varchar2(20) := 'VHR:21';
  c_Pcode_Indicator_Penalty_For_Day_Skip          constant varchar2(20) := 'VHR:22';
  c_Pcode_Indicator_Perf_Penalty                  constant varchar2(20) := 'VHR:23';
  c_Pcode_Indicator_Perf_Extra_Penalty            constant varchar2(20) := 'VHR:24';
  c_Pcode_Indicator_Penalty_For_Mark_Skip         constant varchar2(20) := 'VHR:25';
  c_Pcode_Indicator_Additional_Nighttime          constant varchar2(20) := 'VHR:26';
  c_Pcode_Indicator_Weighted_Turnout              constant varchar2(20) := 'VHR:27';
  c_Pcode_Indicator_Average_Perf_Bonus            constant varchar2(20) := 'VHR:28';
  c_Pcode_Indicator_Average_Perf_Extra_Bonus      constant varchar2(20) := 'VHR:29';
  c_Pcode_Indicator_Trainings_Subjects            constant varchar2(20) := 'VHR:30';
  c_Pcode_Indicator_Exam_Results                  constant varchar2(20) := 'VHR:31';
  c_Pcode_Indicator_Average_Attendance_Percentage constant varchar2(20) := 'VHR:32';
  c_Pcode_Indicator_Average_Perfomance_Percentage constant varchar2(20) := 'VHR:33';
  ----------------------------------------------------------------------------------------------------
  -- indicator groups
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Indicator_Group_Wage       constant varchar2(20) := 'VHR:1';
  c_Pcode_Indicator_Group_Experience constant varchar2(20) := 'VHR:2';
  ----------------------------------------------------------------------------------------------------
  -- Fte Pcode
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Fte_Full_Time    constant varchar2(20) := 'VHR:1';
  c_Pcode_Fte_Part_Time    constant varchar2(20) := 'VHR:2';
  c_Pcode_Fte_Quarter_Time constant varchar2(20) := 'VHR:3';
  ----------------------------------------------------------------------------------------------------
  c_Custom_Fte_Id constant number := -1;
  c_Default_Fte   constant number := 1.0;
  ----------------------------------------------------------------------------------------------------
  -- Staff Status
  ----------------------------------------------------------------------------------------------------
  c_Staff_Status_Working   constant varchar2(1) := 'W';
  c_Staff_Status_Dismissed constant varchar2(1) := 'D';
  c_Staff_Status_Unknown   constant varchar2(1) := 'U';
  ----------------------------------------------------------------------------------------------------
  -- Staff Kind
  ----------------------------------------------------------------------------------------------------
  c_Staff_Kind_Primary   constant varchar2(1) := 'P';
  c_Staff_Kind_Secondary constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- Candidate Kind
  ----------------------------------------------------------------------------------------------------
  c_Candidate_Kind_New constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------
  -- Specialty Kind
  ----------------------------------------------------------------------------------------------------
  c_Specialty_Kind_Group     constant varchar2(1) := 'G';
  c_Specialty_Kind_Specialty constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- Employment Source Kind
  ----------------------------------------------------------------------------------------------------
  c_Employment_Source_Kind_Hiring    constant varchar2(1) := 'H';
  c_Employment_Source_Kind_Dismissal constant varchar2(1) := 'D';
  c_Employment_Source_Kind_Both      constant varchar2(1) := 'B';
  ----------------------------------------------------------------------------------------------------
  -- User Access Level
  ----------------------------------------------------------------------------------------------------
  c_User_Access_Level_Personal          constant varchar2(1) := 'P';
  c_User_Access_Level_Direct_Employee   constant varchar2(1) := 'D';
  c_User_Access_Level_Undirect_Employee constant varchar2(1) := 'U';
  c_User_Access_Level_Manual            constant varchar2(1) := 'M';
  c_User_Access_Level_Other             constant varchar2(1) := 'O';
  ----------------------------------------------------------------------------------------------------
  -- Indicator Used
  ----------------------------------------------------------------------------------------------------
  c_Indicator_Used_Constantly    constant varchar2(1) := 'C';
  c_Indicator_Used_Automatically constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- Time Formats
  ----------------------------------------------------------------------------------------------------
  c_Time_Format_Minute       constant varchar2(50) := 'hh24:mi';
  c_Date_Format_Year         constant varchar2(50) := 'yyyy';
  c_Date_Format_Month        constant varchar2(50) := 'mm.yyyy';
  c_Date_Format_Day          constant varchar2(50) := 'dd.mm.yyyy';
  c_Date_Format_Minute       constant varchar2(50) := 'dd.mm.yyyy hh24:mi';
  c_Date_Format_Second       constant varchar2(50) := 'dd.mm.yyyy hh24:mi:ss';
  c_Date_Format_Year_Quarter constant varchar2(50) := 'yyyy "Q"q';
  ---------------------------------------------------------------------------------------------------- 
  -- Date trunc formats
  ---------------------------------------------------------------------------------------------------- 
  c_Date_Trunc_Format_Year    constant varchar2(50) := 'yyyy';
  c_Date_Trunc_Format_Month   constant varchar2(50) := 'mm';
  c_Date_Trunc_Format_Quarter constant varchar2(50) := 'q';
  ----------------------------------------------------------------------------------------------------
  -- Max Date
  ----------------------------------------------------------------------------------------------------
  c_Max_Date constant date := to_date('31.12.9999', c_Date_Format_Day);
  ----------------------------------------------------------------------------------------------------
  -- Min Date
  ----------------------------------------------------------------------------------------------------
  c_Min_Date constant date := to_date('01.01.0001', c_Date_Format_Day);
  ----------------------------------------------------------------------------------------------------
  -- Dismissal Reason Types
  ----------------------------------------------------------------------------------------------------
  c_Dismissal_Reasons_Type_Positive constant varchar2(1) := 'P';
  c_Dismissal_Reasons_Type_Negative constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------
  -- Working Time Differences
  ----------------------------------------------------------------------------------------------------
  c_Diff_Hiring    constant number := -2;
  c_Diff_Dismissal constant number := 7;
  ----------------------------------------------------------------------------------------------------
  -- Column required settings
  ----------------------------------------------------------------------------------------------------
  c_Pref_Crs_Last_Name              constant varchar2(50) := 'vhr:href:crs:last_name';
  c_Pref_Crs_Middle_Name            constant varchar2(50) := 'vhr:href:crs:middle_name';
  c_Pref_Crs_Birthday               constant varchar2(50) := 'vhr:href:crs:birthday';
  c_Pref_Crs_Phone_Number           constant varchar2(50) := 'vhr:href:crs:phone_number';
  c_Pref_Crs_Email                  constant varchar2(50) := 'vhr:href:crs:email';
  c_Pref_Crs_Region                 constant varchar2(50) := 'vhr:href:crs:region';
  c_Pref_Crs_Address                constant varchar2(50) := 'vhr:href:crs:address';
  c_Pref_Crs_Legal_Address          constant varchar2(50) := 'vhr:href:crs:legal_address';
  c_Pref_Crs_Passport               constant varchar2(50) := 'vhr:href:crs:passport';
  c_Pref_Crs_Npin                   constant varchar2(50) := 'vhr:href:crs:npin';
  c_Pref_Crs_Iapa                   constant varchar2(50) := 'vhr:href:crs:iapa';
  c_Pref_Crs_Request_Note           constant varchar2(50) := 'vhr:href:crs:request_note';
  c_Pref_Crs_Request_Note_Limit     constant varchar2(50) := 'vhr:href:crs:request_note_limit';
  c_Pref_Crs_Plan_Change_Note       constant varchar2(50) := 'vhr:href:crs:plan_change_note';
  c_Pref_Crs_Plan_Change_Note_Limit constant varchar2(50) := 'vhr:href:crs:plan_change_note_limit';
  ----------------------------------------------------------------------------------------------------
  -- Company badge template
  ----------------------------------------------------------------------------------------------------
  c_Pref_Badge_Template_Id constant varchar2(50) := 'href:company_badge_template_id';
  ----------------------------------------------------------------------------------------------------
  -- verify person uniqueness
  ----------------------------------------------------------------------------------------------------
  c_Pref_Vpu_Setting constant varchar2(50) := 'href:vpu:setting';
  c_Pref_Vpu_Column  constant varchar2(50) := 'href:vpu:column';
  ----------------------------------------------------------------------------------------------------
  c_Vpu_Column_Name            constant varchar2(1) := 'N';
  c_Vpu_Column_Passport_Number constant varchar2(1) := 'P';
  c_Vpu_Column_Npin            constant varchar2(1) := 'I';
  ----------------------------------------------------------------------------------------------------
  c_Settings_Separator constant varchar2(1) := '$';
  ----------------------------------------------------------------------------------------------------
  -- HTTP METHODS
  ----------------------------------------------------------------------------------------------------
  c_Http_Method_Get    constant varchar2(10) := 'GET';
  c_Http_Method_Put    constant varchar2(10) := 'PUT';
  c_Http_Method_Post   constant varchar2(10) := 'POST';
  c_Http_Method_Delete constant varchar2(10) := 'DELETE';
  ----------------------------------------------------------------------------------------------------  
  -- Set Employee Photo Templates
  ----------------------------------------------------------------------------------------------------
  c_Set_Photo_Template_Fl                  constant varchar2(50) := 'first_name.last_name';
  c_Set_Photo_Template_Lf                  constant varchar2(50) := 'last_name.first_name';
  c_Set_Photo_Template_Fl_Id               constant varchar2(50) := 'first_name.last_name.#id';
  c_Set_Photo_Template_Lf_Id               constant varchar2(50) := 'last_name.first_name.#id';
  c_Set_Photo_Template_Fl_Employee_Number  constant varchar2(50) := 'first_name.last_name.#employee_number';
  c_Set_Photo_Template_Lf_Employee_Number  constant varchar2(50) := 'last_name.first_name.#employee_number';
  c_Set_Photo_Template_Flm                 constant varchar2(50) := 'first_name.last_name.middle_name';
  c_Set_Photo_Template_Lfm                 constant varchar2(50) := 'last_name.first_name.middle_name';
  c_Set_Photo_Template_Flm_Id              constant varchar2(50) := 'first_name.last_name.middle_name.#id';
  c_Set_Photo_Template_Lfm_Id              constant varchar2(50) := 'last_name.first_name.middle_name.#id';
  c_Set_Photo_Template_Flm_Employee_Number constant varchar2(50) := 'first_name.last_name.middle_name.#employee_number';
  c_Set_Photo_Template_Lfm_Employee_Number constant varchar2(50) := 'last_name.first_name.middle_name.#employee_number';
  ----------------------------------------------------------------------------------------------------  
  -- Foto Statuses
  ----------------------------------------------------------------------------------------------------  
  c_Pref_Set_Photo_Status_Success   constant varchar2(1) := 'S';
  c_Pref_Set_Photo_Status_Warning   constant varchar2(1) := 'W';
  c_Pref_Set_Photo_Status_Not_Found constant varchar2(1) := 'N';

end Href_Pref;
/
create or replace package body Href_Pref is
end Href_Pref;
/

create or replace package Href_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Extra_Phone          varchar2 := null,
    i_Corporate_Email      varchar2 := null,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2,
    i_Note                 varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicators      in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt;
  ----------------------------------------------------------------------------------------------------  
  Function Set_Photo_Templates return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2;
  Function Specialty_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2;
  Function Staff_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2;
  Function Staff_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2;
  Function Employment_Source_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2;
  Function User_Acces_Levels return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2;
  Function Indicator_Useds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2;
  Function Candidate_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2;
  Function Dismissal_Reasons_Type return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2;
  Function Person_Document_Owe_Status return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2;
end Href_Util;
/
create or replace package body Href_Util is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Extra_Phone          varchar2 := null,
    i_Corporate_Email      varchar2 := null,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2,
    i_Note                 varchar2 := null
  ) is
  begin
    o_Person.Company_Id           := i_Company_Id;
    o_Person.Person_Id            := i_Person_Id;
    o_Person.First_Name           := i_First_Name;
    o_Person.Last_Name            := i_Last_Name;
    o_Person.Middle_Name          := i_Middle_Name;
    o_Person.Gender               := i_Gender;
    o_Person.Birthday             := i_Birthday;
    o_Person.Nationality_Id       := i_Nationality_Id;
    o_Person.Photo_Sha            := i_Photo_Sha;
    o_Person.Tin                  := i_Tin;
    o_Person.Iapa                 := i_Iapa;
    o_Person.Npin                 := i_Npin;
    o_Person.Region_Id            := i_Region_Id;
    o_Person.Main_Phone           := i_Main_Phone;
    o_Person.Email                := i_Email;
    o_Person.Address              := i_Address;
    o_Person.Legal_Address        := i_Legal_Address;
    o_Person.Key_Person           := i_Key_Person;
    o_Person.Extra_Phone          := i_Extra_Phone;
    o_Person.Corporate_Email      := i_Corporate_Email;
    o_Person.Access_All_Employees := i_Access_All_Employees;
    o_Person.Access_Hidden_Salary := i_Access_Hidden_Salary;
    o_Person.State                := i_State;
    o_Person.Code                 := i_Code;
    o_Person.Note                 := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  ) is
  begin
    o_Candidate.Company_Id       := i_Company_Id;
    o_Candidate.Filial_Id        := i_Filial_Id;
    o_Candidate.Person_Type_Id   := i_Person_Type_Id;
    o_Candidate.Candidate_Kind   := i_Candidate_Kind;
    o_Candidate.Source_Id        := i_Source_Id;
    o_Candidate.Wage_Expectation := i_Wage_Expectation;
    o_Candidate.Cv_Sha           := i_Cv_Sha;
    o_Candidate.Note             := i_Note;
    o_Candidate.Extra_Phone      := i_Extra_Phone;
    o_Candidate.Edu_Stages       := i_Edu_Stages;
    o_Candidate.Candidate_Jobs   := i_Candidate_Jobs;
  
    o_Candidate.Person.Company_Id    := i_Company_Id;
    o_Candidate.Person.Person_Id     := i_Candidate_Id;
    o_Candidate.Person.First_Name    := i_First_Name;
    o_Candidate.Person.Last_Name     := i_Last_Name;
    o_Candidate.Person.Middle_Name   := i_Middle_Name;
    o_Candidate.Person.Gender        := i_Gender;
    o_Candidate.Person.Birthday      := i_Birthday;
    o_Candidate.Person.Photo_Sha     := i_Photo_Sha;
    o_Candidate.Person.Region_Id     := i_Region_Id;
    o_Candidate.Person.Main_Phone    := i_Main_Phone;
    o_Candidate.Person.Email         := i_Email;
    o_Candidate.Person.Address       := i_Address;
    o_Candidate.Person.Legal_Address := i_Legal_Address;
    o_Candidate.Person.State         := 'A';
  
    o_Candidate.Langs           := Href_Pref.Person_Lang_Nt();
    o_Candidate.Experiences     := Href_Pref.Person_Experience_Nt();
    o_Candidate.Recommendations := Href_Pref.Candidate_Recom_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  ) is
    v_Lang Href_Pref.Person_Lang_Rt;
  begin
    v_Lang.Lang_Id       := i_Lang_Id;
    v_Lang.Lang_Level_Id := i_Lang_Level_Id;
  
    p_Candidate.Langs.Extend;
    p_Candidate.Langs(p_Candidate.Langs.Count) := v_Lang;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  ) is
    v_Experience Href_Pref.Person_Experience_Rt;
  begin
    v_Experience.Person_Experience_Id := i_Person_Experience_Id;
    v_Experience.Experience_Type_Id   := i_Experience_Type_Id;
    v_Experience.Is_Working           := i_Is_Working;
    v_Experience.Start_Date           := i_Start_Date;
    v_Experience.Num_Year             := i_Num_Year;
    v_Experience.Num_Month            := i_Num_Month;
    v_Experience.Num_Day              := i_Num_Day;
  
    p_Candidate.Experiences.Extend;
    p_Candidate.Experiences(p_Candidate.Experiences.Count) := v_Experience;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  ) is
    v_Recommendation Href_Pref.Candidate_Recom_Rt;
  begin
    v_Recommendation.Recommendation_Id   := i_Recommendation_Id;
    v_Recommendation.Sender_Name         := i_Sender_Name;
    v_Recommendation.Sender_Phone_Number := i_Sender_Phone_Number;
    v_Recommendation.Sender_Email        := i_Sender_Email;
    v_Recommendation.File_Sha            := i_File_Sha;
    v_Recommendation.Order_No            := i_Order_No;
    v_Recommendation.Feedback            := i_Feedback;
    v_Recommendation.Note                := i_Note;
  
    p_Candidate.Recommendations.Extend;
    p_Candidate.Recommendations(p_Candidate.Recommendations.Count) := v_Recommendation;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicators      in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  ) is
    v_Indicator Href_Pref.Indicator_Rt;
  begin
    v_Indicator.Indicator_Id    := i_Indicator_Id;
    v_Indicator.Indicator_Value := i_Indicator_Value;
  
    p_Indicators.Extend;
    p_Indicators(p_Indicators.Count) := v_Indicator;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype is
    result Href_Candidate_Ref_Settings%rowtype;
  begin
    if not z_Href_Candidate_Ref_Settings.Exist(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               o_Row        => result) then
      Result.Company_Id     := i_Company_Id;
      Result.Filial_Id      := i_Filial_Id;
      Result.Region         := 'N';
      Result.Address        := 'N';
      Result.Experience     := 'N';
      Result.Source         := 'N';
      Result.Recommendation := 'N';
      Result.Cv             := 'N';
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number is
  begin
    return z_Href_Staffs.Take(i_Company_Id => i_Company_Id, --
                              i_Filial_Id  => i_Filial_Id, --
                              i_Staff_Id   => i_Staff_Id).Employee_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns last active staff id
  -- returns null if no staff found
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Date
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns primary staff_id that was active on duration of period
  -- returns null if no such staff found
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number is
    v_Staff_Id number;
  begin
    select s.Staff_Id
      into v_Staff_Id
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Period_Begin
       and Nvl(s.Dismissal_Date, i_Period_End) >= i_Period_End;
  
    return v_Staff_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype is
    r_Division_Manager Mrf_Division_Managers%rowtype;
  begin
    r_Division_Manager := z_Mrf_Division_Managers.Take(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Division_Id => i_Division_Id);
  
    return z_Mrf_Robots.Take(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Robot_Id   => r_Division_Manager.Manager_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number is
    r_Robot       Mrf_Robots%rowtype;
    v_Division_Id number;
  begin
    v_Division_Id := z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Robot_Id => i_Robot_Id).Org_Unit_Id;
  
    r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Division_Id => v_Division_Id);
  
    if r_Robot.Robot_Id = i_Robot_Id then
      v_Division_Id := z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                       i_Filial_Id => i_Filial_Id, --
                       i_Division_Id => r_Robot.Division_Id).Parent_Id;
    
      r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Division_Id => v_Division_Id);
    end if;
  
    return r_Robot.Person_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    v_Manager_Id number;
    r_Staff      Href_Staffs%rowtype;
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Manager_Id := Get_Manager_Id(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => r_Staff.Robot_Id);
  
    return z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                     i_Person_Id  => v_Manager_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2 is
    v_Staff_Id number;
  begin
    v_Staff_Id := Get_Primary_Staff_Id(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Employee_Id  => i_Employee_Id,
                                       i_Period_Begin => Trunc(sysdate),
                                       i_Period_End   => Trunc(sysdate));
  
    return Get_Manager_Name(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => v_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Name
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Code
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number is
    result number;
  begin
    select q.Staff_Id
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Upper(q.Staff_Number) = Upper(i_Staff_Number);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined is
    r_Staff          Href_Staffs%rowtype;
    v_Staff_Licensed Href_Pref.Staff_Licensed_Rt;
    v_Begin_Date     date;
    v_End_Date       date;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Staff_Licensed.Staff_Id := i_Staff_Id;
    v_Begin_Date              := Greatest(r_Staff.Hiring_Date, i_Period_Begin);
    v_End_Date                := Least(Nvl(r_Staff.Dismissal_Date, i_Period_End), i_Period_End);
  
    for r in (select Dates.Period,
                     Nvl((select 'N'
                           from Hlic_Unlicensed_Employees Le
                          where Le.Company_Id = r_Staff.Company_Id
                            and Le.Employee_Id = r_Staff.Employee_Id
                            and Le.Licensed_Date = Dates.Period),
                         'Y') as Licensed
                from (select (v_Begin_Date + level - 1) as Period
                        from Dual
                      connect by level <= (v_End_Date - v_Begin_Date + 1)) Dates)
    loop
      v_Staff_Licensed.Period   := r.Period;
      v_Staff_Licensed.Licensed := r.Licensed;
    
      pipe row(v_Staff_Licensed);
    end loop;
  
    return;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2 is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Id     => i_Staff_Id,
                                 i_Period_Begin => i_Period_Begin,
                                 i_Period_End   => i_Period_End) q
     where q.Licensed = 'N';
  
    if v_Count = 0 then
      return 'Y';
    else
      return 'N';
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    for r in (select q.Period
                from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Staff_Id     => i_Staff_Id,
                                           i_Period_Begin => i_Period_Begin,
                                           i_Period_End   => i_Period_End) q
               where q.Licensed = 'N'
                 and Rownum = 1)
    loop
      Href_Error.Raise_018(i_Employee_Name  => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                           i_Period_Begin   => i_Period_Begin,
                           i_Period_End     => i_Period_End,
                           i_Unlicensed_Day => r.Period);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_019(i_Labor_Function_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_020(i_Labor_Function_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_021(i_Fixed_Term_Base_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_022(i_Fixed_Term_Base_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Doc_Type_Id
      into result
      from Href_Document_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Indicator_Id
      into result
      from Href_Indicators
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select Indicator_Group_Id
      into result
      from Href_Indicator_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_023(i_Fte_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_024(i_Fte_Pcode => i_Pcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Nationality_Id
      into result
      from Href_Nationalities q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_029(i_Nationality_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns randoms integer in [low, high] interval
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number is
  begin
    return Trunc(Dbms_Random.Value(i_Low, i_High + 1));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2 is
    r_Person Mr_Natural_Persons%rowtype;
    v_Login  varchar2(100);
  begin
    r_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  
    v_Login := Regexp_Replace(i_Template, 'first_name', r_Person.First_Name);
    v_Login := Regexp_Replace(v_Login, 'last_name', r_Person.Last_Name);
    v_Login := Md_Util.Login_Fixer(v_Login);
  
    return Regexp_Replace(v_Login, '@', '');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Structural
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Pd.Division_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Hrm_Divisions Dv
        on Dv.Company_Id = Pd.Company_Id
       and Dv.Filial_Id = Pd.Filial_Id
       and Dv.Division_Id = Pd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Parents;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Manual
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    result := result multiset union
              Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                  i_Filial_Id        => i_Filial_Id,
                                  i_Only_Departments => i_Only_Departments,
                                  i_Parents          => result);
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number is
    result Array_Number;
  begin
    select Rb.Person_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Mrf_Division_Managers p
        on p.Company_Id = Pd.Company_Id
       and p.Filial_Id = Pd.Filial_Id
       and p.Division_Id = Pd.Division_Id
      join Mrf_Robots Rb
        on Rb.Company_Id = p.Company_Id
       and Rb.Filial_Id = p.Filial_Id
       and Rb.Robot_Id = p.Manager_Id
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Direct_Divisions
       and Pd.Lvl = 1;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number is
    v_Direct_Divisions Array_Number;
    result             Array_Number := Array_Number();
  begin
    v_Direct_Divisions := Get_Direct_Divisions(i_Company_Id       => i_Company_Id,
                                               i_Filial_Id        => i_Filial_Id,
                                               i_Employee_Id      => i_Employee_Id,
                                               i_Only_Departments => i_Only_Departments);
  
    o_Subordinate_Chiefs := Array_Number();
  
    if i_Direct then
      result := v_Direct_Divisions;
    
      if i_Gather_Chiefs then
        o_Subordinate_Chiefs := Get_Chief_Subordinates(i_Company_Id       => i_Company_Id,
                                                       i_Filial_Id        => i_Filial_Id,
                                                       i_Direct_Divisions => v_Direct_Divisions);
      end if;
    end if;
  
    if i_Indirect then
      result := result multiset union
                Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Parents          => v_Direct_Divisions,
                                    i_Only_Departments => i_Only_Departments);
    end if;
  
    if i_Manual then
      result := result multiset union
                Get_Manual_Divisions(i_Company_Id       => i_Company_Id,
                                     i_Filial_Id        => i_Filial_Id,
                                     i_Employee_Id      => i_Employee_Id,
                                     i_Only_Departments => i_Only_Departments);
    end if;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and exists (select 1
              from Mrf_Division_Managers m
              join Mhr_Divisions d
                on d.Company_Id = m.Company_Id
               and d.Filial_Id = m.Filial_Id
               and d.Division_Id = m.Division_Id
               and d.Parent_Id is null
             where m.Company_Id = q.Company_Id
               and m.Filial_Id = q.Filial_Id
               and m.Manager_Id = q.Robot_Id);
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number is
    v_Current_Date date := Trunc(Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id));
  
    v_Division_Ids       Array_Number;
    v_Subordinate_Chiefs Array_Number;
  
    result Array_Number := Array_Number();
  begin
    if i_Direct_Employee is null or i_Direct_Employee <> 'Y' and i_Direct_Employee <> 'N' then
      b.Raise_Not_Implemented;
    end if;
  
    v_Division_Ids := Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                i_Company_Id         => i_Company_Id,
                                                i_Filial_Id          => i_Filial_Id,
                                                i_Direct             => true,
                                                i_Indirect           => i_Direct_Employee = 'N',
                                                i_Manual             => false,
                                                i_Gather_Chiefs      => true,
                                                i_Employee_Id        => i_Employee_Id);
  
    select s.Staff_Id
      bulk collect
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and (i_Self = 'Y' or s.Employee_Id <> i_Employee_Id)
       and s.State = 'A'
       and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
       and (s.Org_Unit_Id member of v_Division_Ids or --
            s.Employee_Id member of v_Subordinate_Chiefs or --
            i_Self = 'Y' and s.Employee_Id = i_Employee_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number is
  begin
    return to_number(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                  i_Code       => Href_Pref.c_Pref_Badge_Template_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt is
    result Href_Pref.Col_Required_Setting_Rt;
  
    --------------------------------------------------
    Function Load_Pref(i_Code varchar2) return varchar2 is
    begin
      return Md_Pref.Load(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                          i_Code       => i_Code);
    end;
  begin
    Result.Last_Name              := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Last_Name), 'N');
    Result.Middle_Name            := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Middle_Name), 'N');
    Result.Birthday               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Birthday), 'N');
    Result.Phone_Number           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Phone_Number), 'N');
    Result.Email                  := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Email), 'N');
    Result.Region                 := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Region), 'N');
    Result.Address                := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Address), 'N');
    Result.Legal_Address          := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Legal_Address), 'N');
    Result.Passport               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Passport), 'N');
    Result.Npin                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Npin), 'N');
    Result.Iapa                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Iapa), 'N');
    Result.Request_Note           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note), 'N');
    Result.Request_Note_Limit     := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit), 0);
    Result.Plan_Change_Note       := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note), 'N');
    Result.Plan_Change_Note_Limit := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit), 0);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name ||
                      ' where company_id = :1 and filial_id = :2 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:3)'
                        else
                         i_Column || ' = :3'
                      end
      into v_Dummy
      using i_Company_Id, i_Filial_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name || --
                      ' where company_id = :1 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:2)'
                        else
                         i_Column || ' = :2'
                      end
      into v_Dummy
      using i_Company_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Filial_Id    => i_Filial_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Name,
                        i_Column_Value => i_Name,
                        i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2 is
    v_Dummy varchar2(1);
    v_Phone varchar2(25) := Regexp_Replace(i_Phone, '\D', '');
  begin
    select 'x'
      into v_Dummy
      from Md_Persons q
     where q.Company_Id = i_Company_Id
       and (i_Person_Id is null or q.Person_Id <> i_Person_Id)
       and q.Phone = v_Phone
       and q.State = 'A';
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Setting),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Column),
               Href_Pref.c_Vpu_Column_Passport_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache Relies_On(Href_Person_Details) is
  begin
    if i_User_Id = Md_Pref.User_Admin(i_Company_Id) then
      return 'Y';
    else
      return Nvl(z_Href_Person_Details.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_User_Id).Access_Hidden_Salary,
                 'N');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean is
  begin
    return Access_Hidden_Salary(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id) = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt is
    v_Setting Href_Pref.Fte_Limit_Rt;
  begin
    v_Setting.Fte_Limit_Setting := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                                    i_Code       => Href_Pref.c_Fte_Limit_Setting),
                                       'N');
  
    if v_Setting.Fte_Limit_Setting = 'Y' then
      v_Setting.Fte_Limit := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                              i_Code       => Href_Pref.c_Fte_Limit),
                                 Href_Pref.c_Fte_Limit_Default);
    end if;
  
    return v_Setting;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Set_Photo_Templates return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Set_Photo_Template_Fl,
                                          Href_Pref.c_Set_Photo_Template_Lf,
                                          Href_Pref.c_Set_Photo_Template_Fl_Id,
                                          Href_Pref.c_Set_Photo_Template_Lf_Id,
                                          Href_Pref.c_Set_Photo_Template_Fl_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Lf_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Flm,
                                          Href_Pref.c_Set_Photo_Template_Lfm,
                                          Href_Pref.c_Set_Photo_Template_Flm_Id,
                                          Href_Pref.c_Set_Photo_Template_Lfm_Id,
                                          Href_Pref.c_Set_Photo_Template_Flm_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Lfm_Employee_Number),
                           Array_Varchar2(t('set_photo_template:first_name.last_name'),
                                          t('set_photo_template:last_name.first_name'),
                                          t('set_photo_template:first_name.last_name.#ID'),
                                          t('set_photo_template:last_name.first_name.#ID'),
                                          t('set_photo_template:first_name.last_name.#Employee_Number'),
                                          t('set_photo_template:last_name.first_name.#Employee_Number'),
                                          t('set_photo_template:first_name.last_name.middle_name'),
                                          t('set_photo_template:last_name.first_name.middle_name'),
                                          t('set_photo_template:first_name.last_name.middle_name.#ID'),
                                          t('set_photo_template:last_name.first_name.middle_name.#ID'),
                                          t('set_photo_template:first_name.last_name.middle_name.#Employee_Number'),
                                          t('set_photo_template:last_name.first_name.middle_name.#Employee_Number')));
  end;

  ----------------------------------------------------------------------------------------------------                                          
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  ) is
  begin
    o_Bank_Account.Company_Id        := i_Company_Id;
    o_Bank_Account.Bank_Account_Id   := i_Bank_Account_Id;
    o_Bank_Account.Bank_Id           := i_Bank_Id;
    o_Bank_Account.Bank_Account_Code := i_Bank_Account_Code;
    o_Bank_Account.Name              := i_Name;
    o_Bank_Account.Person_Id         := i_Person_Id;
    o_Bank_Account.Is_Main           := i_Is_Main;
    o_Bank_Account.Currency_Id       := i_Currency_Id;
    o_Bank_Account.Note              := i_Note;
    o_Bank_Account.Card_Number       := i_Card_Number;
    o_Bank_Account.State             := i_State;
  end;

  ----------------------------------------------------------------------------------------------------
  -- specialty kind
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Group return varchar2 is
  begin
    return t('specialty_kind:group');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Specialty return varchar2 is
  begin
    return t('specialty_kind:specialty');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Specialty_Kind_Group then t_Specialty_Kind_Group --
    when Href_Pref.c_Specialty_Kind_Specialty then t_Specialty_Kind_Specialty --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Specialty_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Specialty_Kind_Group,
                                          Href_Pref.c_Specialty_Kind_Specialty),
                           Array_Varchar2(t_Specialty_Kind_Group, t_Specialty_Kind_Specialty));
  end;

  ----------------------------------------------------------------------------------------------------
  -- staff status
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Working return varchar2 is
  begin
    return t('staff_status:working');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Dismissed return varchar2 is
  begin
    return t('staff_status:dismissed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Unknown return varchar2 is
  begin
    return t('staff_status:unknown');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Status --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed,
                                          Href_Pref.c_Staff_Status_Unknown),
                           Array_Varchar2(t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed,
                                          t_Staff_Status_Unknown));
  
  end;
  ----------------------------------------------------------------------------------------------------
  -- staff kind
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Primary return varchar2 is
  begin
    return t('staff_kind:primary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Secondary return varchar2 is
  begin
    return t('staff_kind:secondary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Kind --
    when Href_Pref.c_Staff_Kind_Primary then t_Staff_Kind_Primary --
    when Href_Pref.c_Staff_Kind_Secondary then t_Staff_Kind_Secondary --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Kind_Primary,
                                          Href_Pref.c_Staff_Kind_Secondary),
                           Array_Varchar2(t_Staff_Kind_Primary, t_Staff_Kind_Secondary));
  end;

  ----------------------------------------------------------------------------------------------------
  -- employment source kind
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Hiring return varchar2 is
  begin
    return t('employment_source_kind:hiring');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Dismissal return varchar2 is
  begin
    return t('employment_source_kind:dismissal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Both return varchar2 is
  begin
    return t('employment_source_kind:both');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Source_Kind --
    when Href_Pref.c_Employment_Source_Kind_Hiring then t_Employment_Source_Kind_Hiring --
    when Href_Pref.c_Employment_Source_Kind_Dismissal then t_Employment_Source_Kind_Dismissal --
    when Href_Pref.c_Employment_Source_Kind_Both then t_Employment_Source_Kind_Both --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Source_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Employment_Source_Kind_Hiring,
                                          Href_Pref.c_Employment_Source_Kind_Dismissal,
                                          Href_Pref.c_Employment_Source_Kind_Both),
                           Array_Varchar2(t_Employment_Source_Kind_Hiring,
                                          t_Employment_Source_Kind_Dismissal,
                                          t_Employment_Source_Kind_Both));
  end;

  ----------------------------------------------------------------------------------------------------
  -- user access level
  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Personal return varchar2 is
  begin
    return t('user_access_level: personal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Direct_Employee return varchar2 is
  begin
    return t('user_access_level: direct employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Undirect_Employee return varchar2 is
  begin
    return t('user_access_level: undirect employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Manual return varchar2 is
  begin
    return t('user_access_level: manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Other return varchar2 is
  begin
    return t('user_access_level: other');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2 is
  begin
    return --
    case i_Acces_Level --
    when Href_Pref.c_User_Access_Level_Personal then t_User_Access_Level_Personal --
    when Href_Pref.c_User_Access_Level_Direct_Employee then t_User_Access_Level_Direct_Employee --
    when Href_Pref.c_User_Access_Level_Undirect_Employee then t_User_Access_Level_Undirect_Employee --
    when Href_Pref.c_User_Access_Level_Manual then t_User_Access_Level_Manual --
    when Href_Pref.c_User_Access_Level_Other then t_User_Access_Level_Other --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Acces_Levels return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_User_Access_Level_Personal,
                                          Href_Pref.c_User_Access_Level_Direct_Employee,
                                          Href_Pref.c_User_Access_Level_Undirect_Employee,
                                          Href_Pref.c_User_Access_Level_Manual,
                                          Href_Pref.c_User_Access_Level_Other),
                           Array_Varchar2(t_User_Access_Level_Personal,
                                          t_User_Access_Level_Direct_Employee,
                                          t_User_Access_Level_Undirect_Employee,
                                          t_User_Access_Level_Manual,
                                          t_User_Access_Level_Other));
  end;

  ----------------------------------------------------------------------------------------------------
  -- indicator used
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Constantly return varchar2 is
  begin
    return t('indicator_used:constantly');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Automatically return varchar2 is
  begin
    return t('indicator_used:automatically');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2 is
  begin
    return --
    case i_Used --
    when Href_Pref.c_Indicator_Used_Constantly then t_Indicator_Used_Constantly --
    when Href_Pref.c_Indicator_Used_Automatically then t_Indicator_Used_Automatically --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Useds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Indicator_Used_Constantly,
                                          Href_Pref.c_Indicator_Used_Automatically),
                           Array_Varchar2(t_Indicator_Used_Constantly,
                                          t_Indicator_Used_Automatically));
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate kind
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind_New return varchar is
  begin
    return t('candidate_kind: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Candidate_Kind_New then t_Candidate_Kind_New --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Candidate_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Candidate_Kind_New,
                                          Href_Pref.c_Staff_Status_Unknown,
                                          Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed),
                           Array_Varchar2(t_Candidate_Kind_New,
                                          t_Staff_Status_Unknown,
                                          t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- dismissal reasons type
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Positive return varchar2 is
  begin
    return t('dismissal_reasons_type: positive');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Negative return varchar2 is
  begin
    return t('dismissal_reasons_type: negative');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2 is
  begin
    return --
    case i_Dismissal_Reasons_Type --
    when Href_Pref.c_Dismissal_Reasons_Type_Positive then t_Dismissal_Reasons_Type_Positive --
    when Href_Pref.c_Dismissal_Reasons_Type_Negative then t_Dismissal_Reasons_Type_Negative --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reasons_Type return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Dismissal_Reasons_Type_Positive,
                                          Href_Pref.c_Dismissal_Reasons_Type_Negative),
                           Array_Varchar2(t_Dismissal_Reasons_Type_Positive, --
                                          t_Dismissal_Reasons_Type_Negative));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2 is
  begin
    return t('custom fte name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2 is
    v_t_From varchar2(100 char);
    v_t_To   varchar2(100 char);
  begin
    if i_From is not null or i_To is null then
      v_t_From := t('from_to_rule:from $1{from_value} $2{rule_unit}', Nvl(i_From, 0), i_Rule_Unit);
    end if;
  
    if i_To is not null then
      v_t_To := t('from_to_rule:to $1{to_value} $2{rule_unit}', i_To, i_Rule_Unit);
    end if;
  
    return trim(v_t_From || ' ' || v_t_To);
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_New return varchar2 is
  begin
    return t('person_document_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Approved return varchar2 is
  begin
    return t('person_document_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Rejected return varchar2 is
  begin
    return t('person_document_status:rejected');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Status_New then t_Person_Document_Status_New --
    when Href_Pref.c_Person_Document_Status_Approved then t_Person_Document_Status_Approved --
    when Href_Pref.c_Person_Document_Status_Rejected then t_Person_Document_Status_Rejected --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document owe status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Complete return varchar2 is
  begin
    return t('person_document_owe_status:complete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Partial return varchar2 is
  begin
    return t('person_document_owe_status:partial');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Exempt return varchar2 is
  begin
    return t('person_document_owe_status:exempt');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Owe_Status_Complete then t_Person_Document_Owe_Status_Complete --
    when Href_Pref.c_Person_Document_Owe_Status_Partial then t_Person_Document_Owe_Status_Partial --
    when Href_Pref.c_Person_Document_Owe_Status_Exempt then t_Person_Document_Owe_Status_Exempt --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Document_Owe_Status return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Person_Document_Owe_Status_Complete,
                                          Href_Pref.c_Person_Document_Owe_Status_Partial,
                                          Href_Pref.c_Person_Document_Owe_Status_Exempt),
                           Array_Varchar2(t_Person_Document_Owe_Status_Complete,
                                          t_Person_Document_Owe_Status_Partial,
                                          t_Person_Document_Owe_Status_Exempt));
  end;

  ----------------------------------------------------------------------------------------------------
  -- verify person uniqueness
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Name return varchar2 is
  begin
    return t('verify_person_uniqueness_column:name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Passport_Number return varchar2 is
  begin
    return t('verify_person_uniqueness_column:passport_number');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Npin return varchar2 is
  begin
    return t('verify_person_uniqueness_column:npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2 is
  begin
    return --
    case i_Column --
    when Href_Pref.c_Vpu_Column_Name then t_Verify_Person_Uniqueness_Column_Name --
    when Href_Pref.c_Vpu_Column_Passport_Number then t_Verify_Person_Uniqueness_Column_Passport_Number --
    when Href_Pref.c_Vpu_Column_Npin then t_Verify_Person_Uniqueness_Column_Npin --
    end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee personal audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_First_Name return varchar2 is
  begin
    return t('first name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Last_Name return varchar2 is
  begin
    return t('last name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Middle_Name return varchar2 is
  begin
    return t('middle name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Nationality return varchar2 is
  begin
    return t('nationality');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Birthday return varchar2 is
  begin
    return t('birthday');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gender return varchar2 is
  begin
    return t('gender');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Npin return varchar2 is
  begin
    return t('npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Iapa return varchar2 is
  begin
    return t('iapa');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Tin return varchar2 is
  begin
    return t('tin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Note return varchar2 is
  begin
    return t('note');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.First_Name,
                                          z.Last_Name,
                                          z.Middle_Name,
                                          z.Nationality,
                                          z.Birthday,
                                          z.Gender,
                                          z.Npin,
                                          z.Iapa,
                                          z.Tin,
                                          z.Note),
                           Array_Varchar2(t_First_Name,
                                          t_Last_Name,
                                          t_Middle_Name,
                                          t_Nationality,
                                          t_Birthday,
                                          t_Gender,
                                          t_Npin,
                                          t_Iapa,
                                          t_Tin,
                                          t_Note));
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee contact audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_Main_Phone return varchar2 is
  begin
    return t('main phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Extra_Phone return varchar2 is
  begin
    return t('extra phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Email return varchar2 is
  begin
    return t('email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Corporate_Email return varchar2 is
  begin
    return t('corporate email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Region return varchar2 is
  begin
    return t('region');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Address return varchar2 is
  begin
    return t('address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Legal_Address return varchar2 is
  begin
    return t('legal address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.Main_Phone,
                                          z.Extra_Phone,
                                          z.Email,
                                          z.Corporate_Email,
                                          z.Region,
                                          z.Address,
                                          z.Legal_Address),
                           Array_Varchar2(t_Main_Phone,
                                          t_Extra_Phone,
                                          t_Email,
                                          t_Corporate_Email,
                                          t_Region,
                                          t_Address,
                                          t_Legal_Address));
  end;

end Href_Util;
/

create or replace package Verifix_Settings is
  ----------------------------------------------------------------------------------------------------
  -- Project Code
  ----------------------------------------------------------------------------------------------------
  c_Pc_Verifix_Hr constant varchar2(10) := 'vhr';
  ----------------------------------------------------------------------------------------------------
  -- Project Version
  ----------------------------------------------------------------------------------------------------
  c_Pv_Verifix_Hr constant varchar2(10) := '3.0.3';
  ----------------------------------------------------------------------------------------------------
  -- Module error codes
  ----------------------------------------------------------------------------------------------------
  c_Href_Error_Code  constant varchar2(10) := 'A05-01';
  c_Hes_Error_Code   constant varchar2(10) := 'A05-02';
  c_Hlic_Error_Code  constant varchar2(10) := 'A05-03';
  c_Htt_Error_Code   constant varchar2(10) := 'A05-04';
  c_Hzk_Error_Code   constant varchar2(10) := 'A05-05';
  c_Hrm_Error_Code   constant varchar2(10) := 'A05-06';
  c_Hpd_Error_Code   constant varchar2(10) := 'A05-07';
  c_Hln_Error_Code   constant varchar2(10) := 'A05-08';
  c_Hper_Error_Code  constant varchar2(10) := 'A05-09';
  c_Hpr_Error_Code   constant varchar2(10) := 'A05-10';
  c_Hac_Error_Code   constant varchar2(10) := 'A05-11';
  c_Htm_Error_Code   constant varchar2(10) := 'A05-12';
  c_Hrec_Error_Code  constant varchar2(10) := 'A05-13';
  c_Hsc_Error_Code   constant varchar2(10) := 'A05-14';
  c_Hface_Error_Code constant varchar2(10) := 'A05-15';
  c_Hide_Error_Code  constant varchar2(10) := 'A05-16';
  c_Uit_Error_Code   constant varchar2(10) := 'A05-99';
end Verifix_Settings;
/
create or replace package body Verifix_Settings is
end Verifix_Settings;
/

