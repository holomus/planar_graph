create or replace package Hes_Util is
  ---------------------------------------------------------------------------------------------------
  Function Get_Lang_Code(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Timepad_User_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Qr_Code_Limit_Time(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  -- bu funksiya faqat Apple iOSga ma'lumot yuborib aldash uchun chiqarilgan
  -- boshqa logic ahamiyati yo'q
  Function Biometric_Recognition_Enabled
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Use_Task_Manager(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Staff_Track_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Track_Settings_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Face_Register_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Face_Register_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Request_Manager_Approval_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Request_Manager_Approval_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Change_Manager_Approval_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Change_Manager_Approval_Rt;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Change_Day_Limit_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Change_Day_Limit_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Timepad_Track_Settings(i_Company_Id number) return Hes_Pref.Timepad_Track_Settings_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Gps_Tracking_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Notify_Settings
  (
    i_Company_Id number,
    i_User_Id    number
  ) return Hes_Pref.Staff_Notify_Settings_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Enabled_Notify
  (
    i_Company_Id   number,
    i_User_Id      number,
    i_Setting_Code varchar2
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Gen_State_Token
  (
    i_Company_Id number,
    i_Session_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind(i_Gps_Tracking_Qualty_Kind varchar2) return varchar2;
  Function Gps_Tracking_Qualty_Kinds return Matrix_Varchar2;
  Function Gps_Tracking_Qualty_Kind
  (
    i_Distance number,
    i_Interval number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Notification_Uri_Key(i_Uri varchar2) return varchar2;
end Hes_Util;
/
create or replace package body Hes_Util is
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
  Function Get_Lang_Code(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hes_Pref.c_Timepad_Lang_Code),
               z_Md_Companies.Load(i_Company_Id).Lang_Code);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Timepad_User_Id(i_Company_Id number) return number is
  begin
    return z_Href_Timepad_Users.Load(i_Company_Id).User_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Qr_Code_Limit_Time(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hes_Pref.c_Timepad_Qr_Code_Limit_Time),
               10);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nvl_Pref_Load
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Code          varchar2,
    i_Default_Value varchar2
  ) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Code       => i_Code),
               i_Default_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Biometric_Recognition_Enabled
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
  begin
    return Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                         i_Filial_Id     => i_Filial_Id,
                         i_Code          => Hes_Pref.c_Pref_Biometric_Recognition_Enabled,
                         i_Default_Value => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Use_Task_Manager(i_Company_Id number) return varchar2 is
  begin
    return Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                         i_Filial_Id     => Md_Pref.Filial_Head(i_Company_Id),
                         i_Code          => Hes_Pref.c_Pref_Staff_Use_Task_Manager,
                         i_Default_Value => 'N');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Staff_Track_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Track_Settings_Rt is
    result Hes_Pref.Staff_Track_Settings_Rt;
  
    -------------------------------------------------
    Function Setting_Load
    (
      i_Code          varchar2,
      i_Default_Value varchar2
    ) return varchar2 is
    begin
      if Result.User_Settings = 'Y' then
        return Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                        i_User_Id       => i_User_Id,
                                        i_Filial_Id     => i_Filial_Id,
                                        i_Setting_Code  => i_Code,
                                        i_Default_Value => i_Default_Value);
      end if;
    
      return Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                           i_Filial_Id     => i_Filial_Id,
                           i_Code          => i_Code,
                           i_Default_Value => i_Default_Value);
    end;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Track_Type_Input) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    Result.Track_Type_Input     := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Type_Input, 'N');
    Result.Track_Type_Output    := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Type_Output, 'N');
    Result.Track_Type_Check     := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Type_Check, 'N');
    Result.Track_Check_Location := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Check_Location, 'N');
    Result.Track_By_Qr_Code     := Setting_Load(Hes_Pref.c_Pref_Staff_Track_By_Qr_Code, 'N');
    Result.Track_Potential      := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Potential, 'N');
    Result.Track_Start          := Setting_Load(Hes_Pref.c_Pref_Staff_Track_Start,
                                                Hes_Pref.c_Pref_Staff_Ts_Gps_Determination);
    Result.Gps_Determination    := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Determination, 'N');
    Result.Face_Recognition     := Setting_Load(Hes_Pref.c_Pref_Staff_Face_Recognition, 'N');
    Result.Ignore_Invalid_Track := Setting_Load(Hes_Pref.c_Pref_Staff_Ignore_Invalid_Track, 'N');
    Result.Emotion_Wink         := Setting_Load(Hes_Pref.c_Pref_Staff_Emotion_Wink, 'N');
    Result.Emotion_Smile        := Setting_Load(Hes_Pref.c_Pref_Staff_Emotion_Smile, 'N');
    Result.Last_Track_Type      := Setting_Load(Hes_Pref.c_Pref_Staff_Last_Track_Type, 'Y');
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Face_Register_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Face_Register_Rt is
    result Hes_Pref.Staff_Face_Register_Rt;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Face_Register) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    if Result.User_Settings = 'Y' then
      Result.Face_Register := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                       i_User_Id       => i_User_Id,
                                                       i_Filial_Id     => i_Filial_Id,
                                                       i_Setting_Code  => Hes_Pref.c_Pref_Staff_Face_Register,
                                                       i_Default_Value => 'N');
      Result.Allow_Gallery := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                       i_User_Id       => i_User_Id,
                                                       i_Filial_Id     => i_Filial_Id,
                                                       i_Setting_Code  => Hes_Pref.c_Pref_Staff_Allow_Gallery,
                                                       i_Default_Value => 'N');
    else
      Result.Face_Register := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                            i_Filial_Id     => i_Filial_Id,
                                            i_Code          => Hes_Pref.c_Pref_Staff_Face_Register,
                                            i_Default_Value => 'N');
      Result.Allow_Gallery := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                            i_Filial_Id     => i_Filial_Id,
                                            i_Code          => Hes_Pref.c_Pref_Staff_Allow_Gallery,
                                            i_Default_Value => 'N');
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Request_Manager_Approval_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Request_Manager_Approval_Rt is
    result Hes_Pref.Staff_Request_Manager_Approval_Rt;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Request_Manager_Approval) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    if Result.User_Settings = 'Y' then
      Result.Request_Settings := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                          i_User_Id       => i_User_Id,
                                                          i_Filial_Id     => i_Filial_Id,
                                                          i_Setting_Code  => Hes_Pref.c_Pref_Staff_Request_Manager_Approval,
                                                          i_Default_Value => 'N');
    
      Result.Enable_Request := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                        i_User_Id       => i_User_Id,
                                                        i_Filial_Id     => i_Filial_Id,
                                                        i_Setting_Code  => Hes_Pref.c_Pref_Staff_Enable_Request,
                                                        i_Default_Value => 'Y');
    else
      Result.Request_Settings := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                               i_Filial_Id     => i_Filial_Id,
                                               i_Code          => Hes_Pref.c_Pref_Staff_Request_Manager_Approval,
                                               i_Default_Value => 'N');
    
      Result.Enable_Request := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                             i_Filial_Id     => i_Filial_Id,
                                             i_Code          => Hes_Pref.c_Pref_Staff_Enable_Request,
                                             i_Default_Value => 'Y');
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Change_Manager_Approval_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Change_Manager_Approval_Rt is
    result Hes_Pref.Staff_Change_Manager_Approval_Rt;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Manager_Approval) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    if Result.User_Settings = 'Y' then
      Result.Change_Settings := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                         i_User_Id       => i_User_Id,
                                                         i_Filial_Id     => i_Filial_Id,
                                                         i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_Manager_Approval,
                                                         i_Default_Value => 'N');
    
      Result.Enable_Schedule_Change := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                                i_User_Id       => i_User_Id,
                                                                i_Filial_Id     => i_Filial_Id,
                                                                i_Setting_Code  => Hes_Pref.c_Pref_Staff_Enable_Schedule_Change,
                                                                i_Default_Value => 'Y');
    else
      Result.Change_Settings := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                              i_Filial_Id     => i_Filial_Id,
                                              i_Code          => Hes_Pref.c_Pref_Staff_Change_Manager_Approval,
                                              i_Default_Value => 'N');
    
      Result.Enable_Schedule_Change := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                                     i_Filial_Id     => i_Filial_Id,
                                                     i_Code          => Hes_Pref.c_Pref_Staff_Enable_Schedule_Change,
                                                     i_Default_Value => 'Y');
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Change_Day_Limit_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Change_Day_Limit_Rt is
    result Hes_Pref.Change_Day_Limit_Rt;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    if Result.User_Settings = 'Y' then
      Result.Change_With_Restriction_Days := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                                      i_User_Id       => i_User_Id,
                                                                      i_Filial_Id     => i_Filial_Id,
                                                                      i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days,
                                                                      i_Default_Value => 'N');
      if Result.Change_With_Restriction_Days = 'Y' then
        Result.Change_Restriction_Days := Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                                                   i_User_Id      => i_User_Id,
                                                                   i_Filial_Id    => i_Filial_Id,
                                                                   i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Restriction_Days);
      end if;
    
      Result.Change_With_Monthly_Limit := Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                                                   i_User_Id       => i_User_Id,
                                                                   i_Filial_Id     => i_Filial_Id,
                                                                   i_Setting_Code  => Hes_Pref.c_Pref_Staff_Change_With_Monthly_Limit,
                                                                   i_Default_Value => 'N');
      if Result.Change_With_Monthly_Limit = 'Y' then
        Result.Change_Monthly_Limit := Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                                                i_User_Id      => i_User_Id,
                                                                i_Filial_Id    => i_Filial_Id,
                                                                i_Setting_Code => Hes_Pref.c_Pref_Staff_Change_Monthly_Limit);
      end if;
    else
      Result.Change_With_Restriction_Days := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                                           i_Filial_Id     => i_Filial_Id,
                                                           i_Code          => Hes_Pref.c_Pref_Staff_Change_With_Restriction_Days,
                                                           i_Default_Value => 'N');
    
      if Result.Change_With_Restriction_Days = 'Y' then
        Result.Change_Restriction_Days := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Code       => Hes_Pref.c_Pref_Staff_Change_Restriction_Days);
      end if;
    
      Result.Change_With_Monthly_Limit := Nvl_Pref_Load(i_Company_Id    => i_Company_Id,
                                                        i_Filial_Id     => i_Filial_Id,
                                                        i_Code          => Hes_Pref.c_Pref_Staff_Change_With_Monthly_Limit,
                                                        i_Default_Value => 'N');
    
      if Result.Change_With_Monthly_Limit = 'Y' then
        Result.Change_Monthly_Limit := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Code       => Hes_Pref.c_Pref_Staff_Change_Monthly_Limit);
      end if;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timepad_Track_Settings(i_Company_Id number) return Hes_Pref.Timepad_Track_Settings_Rt is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    result        Hes_Pref.Timepad_Track_Settings_Rt;
  begin
    Result.Qr_Code_Limit_Time := Get_Qr_Code_Limit_Time(i_Company_Id);
    Result.Track_Types        := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => v_Filial_Head,
                                              i_Code       => Hes_Pref.c_Timepad_Track_Types);
    Result.Mark_Types         := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => v_Filial_Head,
                                              i_Code       => Hes_Pref.c_Timepad_Mark_Types);
    Result.Emotion_Types      := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => v_Filial_Head,
                                              i_Code       => Hes_Pref.c_Timepad_Emotion_Types);
    Result.Lang_Code          := Get_Lang_Code(i_Company_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Gps_Tracking_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number := null
  ) return Hes_Pref.Staff_Gps_Tracking_Settings_Rt is
    result Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
  
    -------------------------------------------------
    Function Setting_Load
    (
      i_Code          varchar2,
      i_Default_Value varchar2
    ) return varchar2 is
    begin
      if i_User_Id is not null and Result.User_Settings = 'Y' then
        return Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                        i_User_Id       => i_User_Id,
                                        i_Filial_Id     => i_Filial_Id,
                                        i_Setting_Code  => i_Code,
                                        i_Default_Value => i_Default_Value);
      end if;
    
      return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Code       => i_Code),
                 i_Default_Value);
    end;
  begin
    if i_User_Id is not null then
      if Md_Api.User_Setting_Load(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => i_User_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Setting_Code => Hes_Pref.c_Pref_Staff_Gps_Tracking) is not null then
        Result.User_Settings := 'Y';
      else
        Result.User_Settings := 'N';
      end if;
    end if;
  
    Result.Enabled                   := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Tracking, 'N');
    Result.Gps_Track_Collect_Enabled := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Tracking_Gps_Track_Collect,
                                                     'N');
    Result.Auto_Output_Enabled       := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Tracking_Auto_Output,
                                                     'N');
    Result.Disable_Auto_Checkout     := Setting_Load(Hes_Pref.c_Pref_Staff_Disable_Auto_Checkout,
                                                     'N');
    Result.Distance                  := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Tracking_Distance,
                                                     Hes_Pref.c_Staff_Gps_Tracking_Distance_Min);
    Result.Interval                  := Setting_Load(Hes_Pref.c_Pref_Staff_Gps_Tracking_Interval,
                                                     Hes_Pref.c_Staff_Gps_Tracking_Interval_Min);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Notify_Settings
  (
    i_Company_Id number,
    i_User_Id    number
  ) return Hes_Pref.Staff_Notify_Settings_Rt is
    v_Filial_Id number := Md_Pref.Filial_Head(i_Company_Id);
    result      Hes_Pref.Staff_Notify_Settings_Rt;
  
    -------------------------------------------------
    Function Setting_Load(i_Code varchar2) return varchar2 is
    begin
      return Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                      i_User_Id       => i_User_Id,
                                      i_Filial_Id     => v_Filial_Id,
                                      i_Setting_Code  => i_Code,
                                      i_Default_Value => 'Y');
    end;
  begin
    Result.Calendar_Day_Change          := Setting_Load(Hes_Pref.c_Pref_Nt_Calendar_Day_Change);
    Result.Late_Time                    := Setting_Load(Hes_Pref.c_Pref_Nt_Late_Time);
    Result.Early_Time                   := Setting_Load(Hes_Pref.c_Pref_Nt_Early_Time);
    Result.Request                      := Setting_Load(Hes_Pref.c_Pref_Nt_Request);
    Result.Request_Change_Status        := Setting_Load(Hes_Pref.c_Pref_Nt_Request_Change_Status);
    Result.Request_Manager_Approval     := Setting_Load(Hes_Pref.c_Pref_Nt_Request_Manager_Approval);
    Result.Plan_Change                  := Setting_Load(Hes_Pref.c_Pref_Nt_Plan_Change);
    Result.Plan_Change_Status_Change    := Setting_Load(Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change);
    Result.Plan_Change_Manager_Approval := Setting_Load(Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval);
    Result.Gps_Tracking_Change          := Setting_Load(Hes_Pref.c_Pref_Nt_Gps_Tracking_Change);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Enabled_Notify
  (
    i_Company_Id   number,
    i_User_Id      number,
    i_Setting_Code varchar2
  ) return boolean is
  begin
    return Md_Api.User_Setting_Load(i_Company_Id    => i_Company_Id,
                                    i_User_Id       => i_User_Id,
                                    i_Filial_Id     => Md_Pref.Filial_Head(i_Company_Id),
                                    i_Setting_Code  => i_Setting_Code,
                                    i_Default_Value => 'Y') = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_State_Token
  (
    i_Company_Id number,
    i_Session_Id number
  ) return varchar2 is
    v_Src raw(256) := Utl_Raw.Cast_To_Raw(i_Company_Id || '#' || i_Session_Id) ||
                      Dbms_Crypto.Randombytes(128);
  begin
    return Dbms_Crypto.Hash(Src => v_Src, Typ => Dbms_Crypto.Hash_Sh512);
  end;

  ----------------------------------------------------------------------------------------------------
  -- gps tracking qualty kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind_High return varchar2 is
  begin
    return t('gps_tracking_qualty_kind: high');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind_Medium return varchar2 is
  begin
    return t('gps_tracking_qualty_kind: medium');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind_Low return varchar2 is
  begin
    return t('gps_tracking_qualty_kind: low');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind_Custom return varchar2 is
  begin
    return t('gps_tracking_qualty_kind: custom');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gps_Tracking_Qualty_Kind(i_Gps_Tracking_Qualty_Kind varchar2) return varchar2 is
  begin
    return case i_Gps_Tracking_Qualty_Kind --
    when Hes_Pref.c_Gps_Tracking_Qualty_Kind_High then t_Gps_Tracking_Qualty_Kind_High --
    when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium then t_Gps_Tracking_Qualty_Kind_Medium --
    when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low then t_Gps_Tracking_Qualty_Kind_Low --
    when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom then t_Gps_Tracking_Qualty_Kind_Custom --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Tracking_Qualty_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hes_Pref.c_Gps_Tracking_Qualty_Kind_High,
                                          Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium,
                                          Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low,
                                          Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom),
                           Array_Varchar2(t_Gps_Tracking_Qualty_Kind_High,
                                          t_Gps_Tracking_Qualty_Kind_Medium,
                                          t_Gps_Tracking_Qualty_Kind_Low,
                                          t_Gps_Tracking_Qualty_Kind_Custom));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Tracking_Qualty_Kind
  (
    i_Distance number,
    i_Interval number
  ) return varchar2 is
    v_Kind varchar2(1);
  begin
    if i_Distance = Hes_Pref.c_Gps_Tracking_Qualty_Kind_High_Distance and
       i_Interval = Hes_Pref.c_Gps_Tracking_Qualty_Kind_High_Interval then
      v_Kind := Hes_Pref.c_Gps_Tracking_Qualty_Kind_High;
    elsif i_Distance = Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium_Distance and
          i_Interval = Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium_Interval then
      v_Kind := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium;
    elsif i_Distance = Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low_Distance and
          i_Interval = Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low_Interval then
      v_Kind := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low;
    else
      v_Kind := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom;
    end if;
  
    return v_Kind;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Notification_Uri_Key(i_Uri varchar2) return varchar2 is
  begin
    return case i_Uri --
    when Htt_Pref.c_Form_Request_View then Hes_Pref.c_Key_Uri_Request --
    when Htt_Pref.c_Form_Change_View then Hes_Pref.c_Key_Uri_Change --
    else null end;
  end;

end Hes_Util;
/
