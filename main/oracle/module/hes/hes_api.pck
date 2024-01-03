create or replace package Hes_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Face_Register_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Face_Register_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Request_Manager_Approval_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Request_Manager_Approval_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Enable_Request_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Request_Manager_Approval_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Change_Manager_Approval_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Change_Manager_Approval_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Enable_Schedule_Change_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Change_Manager_Approval_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Track_Settings_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Track_Settings_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Gps_Tracking_Settings_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Gps_Tracking_Settings_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timepad_Track_Settings_Save
  (
    i_Company_Id number,
    i_Settings   Hes_Pref.Timepad_Track_Settings_Rt
  );

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Change_Days_Limit_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Change_Day_Limit_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Settings_Save
  (
    i_Company_Id            number,
    i_Filial_Id             number,
    i_Staff_Track_Settings  Hes_Pref.Staff_Track_Settings_Rt,
    i_Gps_Tracking_Settings Hes_Pref.Staff_Gps_Tracking_Settings_Rt,
    i_Face_Register         Hes_Pref.Staff_Face_Register_Rt,
    i_Request_Settings      Hes_Pref.Staff_Request_Manager_Approval_Rt,
    i_Change_Settings       Hes_Pref.Staff_Change_Manager_Approval_Rt,
    i_Change_Day_Limit      Hes_Pref.Change_Day_Limit_Rt
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Billz_Credential_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Subject_Name varchar2,
    i_Secret_Key   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Build_Billz_Runtime_Service
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date_Begin date,
    i_Date_End   date
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Billz_Sales_Response_Handler(i_Val Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_State_Token(i_Session Hes_Oauth2_Session_States%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Oauth2_Credentials(i_Credentials Hes_Oauth2_Credentials%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Oauth2_Credentials
  (
    i_Company_Id  number,
    i_Provider_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Use_Task_Manager_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
end Hes_Api;
/
create or replace package body Hes_Api is
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
    return b.Translate('HES:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Face_Register_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Face_Register_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Face_Register);
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Allow_Gallery);
      
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Face_Register,
                               i_Setting_Value => Nvl(i_Settings.Face_Register, 'N'));
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Allow_Gallery,
                               i_Setting_Value => Nvl(i_Settings.Allow_Gallery, 'N'));
    
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Face_Register,
                             i_Value      => i_Settings.Face_Register);
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Allow_Gallery,
                             i_Value      => i_Settings.Allow_Gallery);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Request_Manager_Approval_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Request_Manager_Approval_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Request_Manager_Approval);
      
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Request_Manager_Approval,
                               i_Setting_Value => Nvl(i_Settings.Request_Settings, 'N'));
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Request_Manager_Approval,
                             i_Value      => i_Settings.Request_Settings);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Enable_Request_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Request_Manager_Approval_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Enable_Request);
      
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Enable_Request,
                               i_Setting_Value => Nvl(i_Settings.Enable_Request, 'Y'));
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Enable_Request,
                             i_Value      => i_Settings.Enable_Request);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Change_Manager_Approval_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Change_Manager_Approval_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Manager_Approval);
      
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_Manager_Approval,
                               i_Setting_Value => Nvl(i_Settings.Change_Settings, 'N'));
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Change_Manager_Approval,
                             i_Value      => i_Settings.Change_Settings);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Enable_Schedule_Change_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Change_Manager_Approval_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Enable_Schedule_Change);
      
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Enable_Schedule_Change,
                               i_Setting_Value => Nvl(i_Settings.Enable_Schedule_Change, 'Y'));
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Enable_Schedule_Change,
                             i_Value      => i_Settings.Enable_Schedule_Change);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Track_Settings_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Track_Settings_Rt
  ) is
    v_User_Settings boolean := false;
  
    -------------------------------------------------
    Procedure Setting_Save
    (
      i_Code          varchar2,
      i_Value         varchar2,
      i_Default_Value varchar2 := null
    ) is
    begin
      if v_User_Settings then
        Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                                 i_User_Id       => i_User_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Setting_Code  => i_Code,
                                 i_Setting_Value => Nvl(i_Value, i_Default_Value));
      else
        Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Code       => i_Code,
                               i_Value      => i_Value);
      end if;
    end;
  
    -------------------------------------------------
    Procedure Setting_Delete(i_Code varchar2) is
    begin
      Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => i_Code);
    end;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Type_Input);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Type_Output);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Type_Check);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Check_Location);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_By_Qr_Code);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Potential);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Track_Start);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Determination);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Face_Recognition);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Ignore_Invalid_Track);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Emotion_Wink);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Emotion_Smile);
        return;
      end if;
    end if;
  
    if i_Settings.Gps_Determination = 'N' and i_Settings.Face_Recognition = 'N' then
      Hes_Error.Raise_001;
    end if;
  
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Type_Input, i_Settings.Track_Type_Input, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Type_Output, i_Settings.Track_Type_Output, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Type_Check, i_Settings.Track_Type_Check, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Check_Location, i_Settings.Track_Check_Location, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_By_Qr_Code, i_Settings.Track_By_Qr_Code, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Potential, i_Settings.Track_Potential, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Track_Start,
                 i_Settings.Track_Start,
                 Hes_Pref.c_Pref_Staff_Ts_Gps_Determination);
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Determination, i_Settings.Gps_Determination, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Face_Recognition, i_Settings.Face_Recognition, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Ignore_Invalid_Track, i_Settings.Ignore_Invalid_Track, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Emotion_Wink, i_Settings.Emotion_Wink, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Emotion_Smile, i_Settings.Emotion_Smile, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Last_Track_Type, i_Settings.Last_Track_Type, 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Gps_Tracking_Settings_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Staff_Gps_Tracking_Settings_Rt
  ) is
    v_User_Settings boolean := false;
    v_Data          Hashmap := Hashmap();
    v_Date          date := Trunc(sysdate);
    v_Old_Settings  Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    -------------------------------------------------
    Procedure Setting_Save
    (
      i_Code          varchar2,
      i_Value         varchar2,
      i_Default_Value varchar2 := null
    ) is
    begin
      if v_User_Settings then
        Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                                 i_User_Id       => i_User_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Setting_Code  => i_Code,
                                 i_Setting_Value => Nvl(i_Value, i_Default_Value));
      else
        Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Code       => i_Code,
                               i_Value      => i_Value);
      end if;
    end;
    -------------------------------------------------
    Procedure Setting_Delete(i_Code varchar2) is
    begin
      Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => i_Code);
    end;
    --------------------------------------------------           
    Procedure Notify_Gps_Tracking_Settings is
    begin
      if Fazo.Equal(v_Old_Settings.Enabled, i_Settings.Enabled) and
         Fazo.Equal(v_Old_Settings.Gps_Track_Collect_Enabled, i_Settings.Gps_Track_Collect_Enabled) and
         Fazo.Equal(v_Old_Settings.Auto_Output_Enabled, i_Settings.Auto_Output_Enabled) and
         Fazo.Equal(v_Old_Settings.Distance, i_Settings.Distance) and
         Fazo.Equal(v_Old_Settings.Interval, i_Settings.Interval) or
         (Fazo.Equal(v_Old_Settings.Enabled, i_Settings.Enabled) and v_Old_Settings.Enabled = 'N') then
        return;
      end if;
    
      v_Data := Fazo.Zip_Map('notify_type', Hes_Pref.c_Pref_Nt_Gps_Tracking_Change);
    
      if i_User_Id is not null and
         Hes_Util.Enabled_Notify(i_Company_Id   => i_Company_Id,
                                 i_User_Id      => i_User_Id,
                                 i_Setting_Code => Hes_Pref.c_Pref_Nt_Gps_Tracking_Change) then
        Mt_Fcm.Send(i_Company_Id => i_Company_Id, --
                    i_User_Id    => i_User_Id,
                    i_Data       => v_Data);
      else
        for r in (select q.Employee_Id
                    from Href_Staffs q
                   where q.Company_Id = i_Company_Id
                     and q.Filial_Id = i_Filial_Id
                     and q.Hiring_Date <= v_Date
                     and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
                     and q.State = 'A'
                   group by q.Employee_Id)
        loop
          continue when not Hes_Util.Enabled_Notify(i_Company_Id   => i_Company_Id,
                                                    i_User_Id      => r.Employee_Id,
                                                    i_Setting_Code => Hes_Pref.c_Pref_Nt_Gps_Tracking_Change) or --
          Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                   i_User_Id      => r.Employee_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Setting_Code => Hes_Pref.c_Pref_Staff_Gps_Tracking) is not null;
        
          Mt_Fcm.Send(i_Company_Id => i_Company_Id, --
                      i_User_Id    => r.Employee_Id,
                      i_Data       => v_Data);
        end loop;
      end if;
    end;
  begin
    v_Old_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id,
                                                           i_User_Id    => i_User_Id);
  
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Tracking);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Tracking_Gps_Track_Collect);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Tracking_Auto_Output);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Disable_Auto_Checkout);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Tracking_Distance);
        Setting_Delete(Hes_Pref.c_Pref_Staff_Gps_Tracking_Interval);
        return;
      end if;
    end if;
  
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Tracking, i_Settings.Enabled, 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Tracking_Gps_Track_Collect,
                 i_Settings.Gps_Track_Collect_Enabled,
                 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Tracking_Auto_Output,
                 i_Settings.Auto_Output_Enabled,
                 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Disable_Auto_Checkout,
                 i_Settings.Disable_Auto_Checkout,
                 'N');
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Tracking_Distance,
                 Greatest(i_Settings.Distance, Hes_Pref.c_Staff_Gps_Tracking_Distance_Min),
                 Hes_Pref.c_Staff_Gps_Tracking_Distance_Min);
    Setting_Save(Hes_Pref.c_Pref_Staff_Gps_Tracking_Interval,
                 Greatest(i_Settings.Interval, Hes_Pref.c_Staff_Gps_Tracking_Interval_Min),
                 Hes_Pref.c_Staff_Gps_Tracking_Interval_Min);
  
    Notify_Gps_Tracking_Settings;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timepad_Track_Settings_Save
  (
    i_Company_Id number,
    i_Settings   Hes_Pref.Timepad_Track_Settings_Rt
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  
    --------------------------------------------------
    Procedure Setting_Save
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
    if i_Settings.Qr_Code_Limit_Time < 1440 then
      Setting_Save(i_Code  => Hes_Pref.c_Timepad_Qr_Code_Limit_Time,
                   i_Value => i_Settings.Qr_Code_Limit_Time);
    else
      Hes_Error.Raise_002;
    end if;
  
    Setting_Save(i_Code => Hes_Pref.c_Timepad_Track_Types, i_Value => i_Settings.Track_Types);
    Setting_Save(i_Code => Hes_Pref.c_Timepad_Mark_Types, i_Value => i_Settings.Mark_Types);
    Setting_Save(i_Code => Hes_Pref.c_Timepad_Emotion_Types, i_Value => i_Settings.Emotion_Types);
    Setting_Save(i_Code => Hes_Pref.c_Timepad_Lang_Code, i_Value => i_Settings.Lang_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Change_Days_Limit_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null,
    i_Settings   Hes_Pref.Change_Day_Limit_Rt
  ) is
    v_User_Settings boolean := false;
  begin
    if i_User_Id is not null then
      v_User_Settings := Nvl(i_Settings.User_Settings, 'N') = 'Y';
    
      if not v_User_Settings then
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days);
      
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Restriction_Days);
      
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_With_Monthly_Limit);
      
        Md_Api.User_Settings_Delete(i_Company_Id   => i_Company_Id,
                                    i_User_Id      => i_User_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Monthly_Limit);
        return;
      end if;
    end if;
  
    if v_User_Settings then
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days,
                               i_Setting_Value => Nvl(i_Settings.Change_With_Restriction_Days, 'N'));
    
      if i_Settings.Change_With_Restriction_Days = 'Y' then
        Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                                 i_User_Id       => i_User_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_Restriction_Days,
                                 i_Setting_Value => i_Settings.Change_Restriction_Days);
      end if;
    
      Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                               i_User_Id       => i_User_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_With_Monthly_Limit,
                               i_Setting_Value => Nvl(i_Settings.Change_With_Monthly_Limit, 'N'));
    
      if i_Settings.Change_With_Monthly_Limit = 'Y' then
        Md_Api.User_Setting_Save(i_Company_Id    => i_Company_Id,
                                 i_User_Id       => i_User_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_Monthly_Limit,
                                 i_Setting_Value => i_Settings.Change_Monthly_Limit);
      end if;
    else
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days,
                             i_Value      => Nvl(i_Settings.Change_With_Restriction_Days, 'N'));
    
      if i_Settings.Change_With_Restriction_Days = 'Y' then
        Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Code       => Hes_Pref.c_Pref_Staff_Change_Restriction_Days,
                               i_Value      => i_Settings.Change_Restriction_Days);
      end if;
    
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Code       => Hes_Pref.c_Pref_Staff_Change_With_Monthly_Limit,
                             i_Value      => Nvl(i_Settings.Change_With_Monthly_Limit, 'N'));
    
      if i_Settings.Change_With_Monthly_Limit = 'Y' then
        Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Code       => Hes_Pref.c_Pref_Staff_Change_Monthly_Limit,
                               i_Value      => i_Settings.Change_Monthly_Limit);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Settings_Save
  (
    i_Company_Id            number,
    i_Filial_Id             number,
    i_Staff_Track_Settings  Hes_Pref.Staff_Track_Settings_Rt,
    i_Gps_Tracking_Settings Hes_Pref.Staff_Gps_Tracking_Settings_Rt,
    i_Face_Register         Hes_Pref.Staff_Face_Register_Rt,
    i_Request_Settings      Hes_Pref.Staff_Request_Manager_Approval_Rt,
    i_Change_Settings       Hes_Pref.Staff_Change_Manager_Approval_Rt,
    i_Change_Day_Limit      Hes_Pref.Change_Day_Limit_Rt
  ) is
  begin
    Staff_Track_Settings_Save(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Settings   => i_Staff_Track_Settings);
  
    Staff_Gps_Tracking_Settings_Save(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Settings   => i_Gps_Tracking_Settings);
  
    Staff_Face_Register_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Settings   => i_Face_Register);
  
    Staff_Request_Manager_Approval_Save(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Settings   => i_Request_Settings);
  
    Staff_Enable_Request_Save(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Settings   => i_Request_Settings);
  
    Staff_Change_Manager_Approval_Save(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Settings   => i_Change_Settings);
  
    Staff_Enable_Schedule_Change_Save(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Settings   => i_Change_Settings);
  
    Staff_Change_Days_Limit_Save(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Settings   => i_Change_Day_Limit);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Billz_Credential_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Subject_Name varchar2,
    i_Secret_Key   varchar2
  ) is
  begin
    if i_Subject_Name is null then
      Hes_Error.Raise_003;
    end if;
  
    if i_Secret_Key is null then
      Hes_Error.Raise_004;
    end if;
  
    z_Hes_Billz_Credentials.Save_One(i_Company_Id   => i_Company_Id,
                                     i_Filial_Id    => i_Filial_Id,
                                     i_Subject_Name => i_Subject_Name,
                                     i_Secret_Key   => i_Secret_Key);
  end;

  ----------------------------------------------------------------------------------------------------
  -- builds and returns a runtime service for Billz's 'reports.sales' API
  ---------------------------------------------------------------------------------------------------- 
  Function Build_Billz_Runtime_Service
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date_Begin date,
    i_Date_End   date
  ) return Runtime_Service is
    v_Service           Runtime_Service;
    v_Details           Hashmap := Hashmap();
    v_Headers           Hashmap := Hashmap();
    r_Credential        Hes_Billz_Credentials%rowtype;
    c_Max_Days_In_Month number := 31;
  begin
    if not z_Hes_Billz_Credentials.Exist(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         o_Row        => r_Credential) then
      Hes_Error.Raise_005;
    else
      if r_Credential.Subject_Name is null then
        Hes_Error.Raise_003;
      end if;
    
      if r_Credential.Secret_Key is null then
        Hes_Error.Raise_004;
      end if;
    end if;
  
    if i_Date_End - i_Date_Begin + 1 > c_Max_Days_In_Month then
      Hes_Error.Raise_006(c_Max_Days_In_Month);
    end if;
  
    v_Headers := Fazo.Zip_Map('User-Agent', Hes_Pref.c_Default_User_Agent_Header);
  
    v_Details.Put('url', Hes_Pref.c_Billz_Api_Url);
    v_Details.Put('method', Hes_Pref.c_Billz_Api_Reports_Sales_Method);
    v_Details.Put('id', Hes_Pref.c_Billz_Api_Reports_Sales_Id);
    v_Details.Put('subject', r_Credential.Subject_Name);
    v_Details.Put('secret_key', r_Credential.Secret_Key);
    v_Details.Put('date_begin', to_char(i_Date_Begin, 'YYYY-MM-DD') || 'T00:00:00Z');
    v_Details.Put('date_end', to_char(i_Date_End, 'YYYY-MM-DD') || 'T00:00:00Z');
    v_Details.Put('currency', Hes_Pref.c_Billz_Api_Currency_Uzs);
    v_Details.Put('headers', v_Headers);
  
    v_Service := Runtime_Service(Hes_Pref.c_Billz_Api_Service_Name);
    v_Service.Set_Detail(v_Details);
  
    v_Service.Set_Response_Procedure(Response_Procedure => 'hes_api.billz_sales_response_handler',
                                     Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2);
  
    Hes_Core.Sale_Dates_Lock(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Date_Begin => i_Date_Begin,
                             i_Date_End   => i_Date_End);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Billz_Sales_Response_Handler(i_Val Array_Varchar2) is
    v_Company_Id  number := Md_Env.Company_Id;
    v_Filial_Id   number := Md_Env.Filial_Id;
    v_Data        Gmap;
    v_Result      Gmap;
    v_Error       Gmap;
    v_Sales_List  Glist;
    v_Sale        Gmap;
    v_Office_Id   number;
    v_Office_Name Hes_Billz_Consolidated_Sales.Billz_Office_Name%type;
    v_Seller_Id   number;
    v_Seller_Name Hes_Billz_Consolidated_Sales.Billz_Seller_Name%type;
    v_Sale_Date   date;
    v_Sale_Amount number;
    v_Date_Begin  date;
    v_Date_End    date;
  
    -------------------------------------------------- 
    -- i_Raw_Date has the following format: 'YYYY-MM-DD"T"HH:MI:SS"Z"'
    Function Parse_Date(i_Raw_Date varchar2) return date is
    begin
      return to_date(Substr(i_Raw_Date, 0, 10), 'YYYY-MM-DD');
    end;
  begin
    v_Data := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
  
    if v_Data.Has('result') then
      v_Result     := v_Data.o_Gmap('result');
      v_Date_Begin := Parse_Date(v_Result.r_Varchar2('dateBegin'));
      v_Date_End   := Parse_Date(v_Result.r_Varchar2('dateEnd'));
      v_Sales_List := Nvl(v_Result.o_Glist('report'), Glist());
    
      for i in 0 .. v_Sales_List.Count - 1
      loop
        v_Sale := Gmap(Json_Object_t(v_Sales_List.Val.Get(i)));
      
        v_Office_Id   := v_Sale.r_Number('officeID');
        v_Office_Name := v_Sale.r_Varchar2('office');
        v_Seller_Id   := v_Sale.r_Number('sellerId');
      
        -- Billz api has a typo in key 'sellerFullName', as of 16.03.2023 it is 'sellerFullname'. Expected to be corrected
        begin
          v_Seller_Name := v_Sale.r_Varchar2('sellerFullName');
        exception
          when others then
            v_Seller_Name := v_Sale.r_Varchar2('sellerFullname');
        end;
      
        v_Sale_Date   := Trunc(v_Sale.r_Date('saleDate', 'YYYY.MM.DD HH24.MI.SS'));
        v_Sale_Amount := v_Sale.r_Number('salePrice');
      
        -- insert the needed field values from the response into temporary table
        insert into Hes_Billz_Raw_Sales
          (Company_Id,
           Filial_Id,
           Billz_Office_Id,
           Billz_Office_Name,
           Billz_Seller_Id,
           Billz_Seller_Name,
           Sale_Date,
           Sale_Amount)
        values
          (v_Company_Id,
           v_Filial_Id,
           v_Office_Id,
           v_Office_Name,
           v_Seller_Id,
           v_Seller_Name,
           v_Sale_Date,
           v_Sale_Amount);
      end loop;
    
      -- clean the records in the table for period requested
      delete from Hes_Billz_Consolidated_Sales t
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Sale_Date between v_Date_Begin and v_Date_End;
    
      -- fill data in the consolidated table computing daily sale amounts for each seller
      insert into Hes_Billz_Consolidated_Sales
        (Company_Id,
         Filial_Id,
         Sale_Id,
         Billz_Office_Id,
         Billz_Office_Name,
         Billz_Seller_Id,
         Billz_Seller_Name,
         Sale_Date,
         Sale_Amount)
        select Company_Id,
               Filial_Id,
               Hes_Next.Sale_Id,
               Billz_Office_Id,
               Billz_Office_Name,
               Billz_Seller_Id,
               Billz_Seller_Name,
               Sale_Date,
               sum(Sale_Amount)
          from Hes_Billz_Raw_Sales t
         where t.Company_Id = v_Company_Id
           and t.Filial_Id = v_Filial_Id
         group by Company_Id,
                  Filial_Id,
                  Billz_Office_Id,
                  Billz_Office_Name,
                  Billz_Seller_Id,
                  Billz_Seller_Name,
                  Sale_Date;
    elsif v_Data.Has('error') then
      v_Error := v_Data.r_Gmap('error');
    
      Hes_Error.Raise_007(i_Error_Code    => v_Error.o_Varchar2('code'),
                          i_Error_Message => v_Error.o_Varchar2('message'));
    else
      Hes_Error.Raise_008;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_State_Token(i_Session Hes_Oauth2_Session_States%rowtype) is
  begin
    z_Hes_Oauth2_Session_States.Save_Row(i_Session);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Oauth2_Credentials(i_Credentials Hes_Oauth2_Credentials%rowtype) is
  begin
    z_Hes_Oauth2_Credentials.Save_Row(i_Credentials);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Oauth2_Credentials
  (
    i_Company_Id  number,
    i_Provider_Id number
  ) is
  begin
    z_Hes_Oauth2_Credentials.Delete_One(i_Company_Id  => i_Company_Id,
                                        i_Provider_Id => i_Provider_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Use_Task_Manager_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
    v_Value varchar2(1) := 'Y';
  begin
    if i_Value <> 'Y' then
      v_Value := 'N';
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hes_Pref.c_Pref_Staff_Use_Task_Manager,
                           i_Value      => v_Value);
  end;

end Hes_Api;
/
