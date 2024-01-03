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
