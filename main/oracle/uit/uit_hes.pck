create or replace package Uit_Hes is
  ----------------------------------------------------------------------------------------------------
  -- action keys
  c_Action_Key_Request_Approve  constant varchar2(50) := 'request_approve';
  c_Action_Key_Request_Deny     constant varchar2(50) := 'request_deny';
  c_Action_Key_Request_Complete constant varchar2(50) := 'request_complete';
  c_Action_Key_Request_Delete   constant varchar2(50) := 'request_delete';
  c_Action_Key_Request_Reset    constant varchar2(50) := 'request_reset';
  c_Action_Key_Change_Approve   constant varchar2(50) := 'change_approve';
  c_Action_Key_Change_Deny      constant varchar2(50) := 'change_deny';
  c_Action_Key_Change_Complete  constant varchar2(50) := 'change_complete';
  c_Action_Key_Change_Delete    constant varchar2(50) := 'change_delete';
  c_Action_Key_Change_Reset     constant varchar2(50) := 'change_reset';
  c_Change_Save_For_Subordinate constant varchar2(50) := 'change_save_for_subordinate';

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Settings
  (
    p                      Hashmap,
    p_Staff_Track_Settings in out Hes_Pref.Staff_Track_Settings_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gps_Tracking_Settings
  (
    p                       Hashmap,
    p_Gps_Tracking_Settings in out Hes_Pref.Staff_Gps_Tracking_Settings_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Function Prepare_Oauth2_Auth_Url
  (
    i_Provider_Id          number,
    i_Use_Head_Credentials boolean := false
  ) return varchar2;
end Uit_Hes;
/
create or replace package body Uit_Hes is
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Settings
  (
    p                      Hashmap,
    p_Staff_Track_Settings in out Hes_Pref.Staff_Track_Settings_Rt
  ) is
  begin
    p_Staff_Track_Settings.Track_Type_Input     := p.r_Varchar2('staff_track_type_input');
    p_Staff_Track_Settings.Track_Type_Output    := p.r_Varchar2('staff_track_type_output');
    p_Staff_Track_Settings.Track_Type_Check     := p.r_Varchar2('staff_track_type_check');
    p_Staff_Track_Settings.Track_Check_Location := p.r_Varchar2('staff_track_check_location');
    p_Staff_Track_Settings.Track_By_Qr_Code     := p.r_Varchar2('staff_track_by_qr_code');
    p_Staff_Track_Settings.Track_Potential      := p.r_Varchar2('staff_track_potential');
  
    p_Staff_Track_Settings.Track_Start          := p.r_Varchar2('staff_track_start');
    p_Staff_Track_Settings.Gps_Determination    := p.r_Varchar2('staff_gps_determination');
    p_Staff_Track_Settings.Face_Recognition     := p.r_Varchar2('staff_face_recognition');
    p_Staff_Track_Settings.Ignore_Invalid_Track := Nvl(p.o_Varchar2('staff_ignore_invalid_track'),
                                                       'N');
    p_Staff_Track_Settings.Last_Track_Type      := p.r_Varchar2('staff_last_track_type');
  
    if p_Staff_Track_Settings.Face_Recognition = 'Y' then
      p_Staff_Track_Settings.Emotion_Wink  := p.r_Varchar2('staff_emotion_wink');
      p_Staff_Track_Settings.Emotion_Smile := p.r_Varchar2('staff_emotion_smile');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gps_Tracking_Settings
  (
    p                       Hashmap,
    p_Gps_Tracking_Settings in out Hes_Pref.Staff_Gps_Tracking_Settings_Rt
  ) is
  begin
    p_Gps_Tracking_Settings.Enabled := p.r_Varchar2('staff_gps_tracking');
  
    if p_Gps_Tracking_Settings.Enabled = 'Y' then
      p_Gps_Tracking_Settings.Gps_Track_Collect_Enabled := p.r_Varchar2('staff_gps_tracking_gps_track_collect');
      p_Gps_Tracking_Settings.Auto_Output_Enabled       := p.r_Varchar2('staff_gps_tracking_auto_output');
      p_Gps_Tracking_Settings.Disable_Auto_Checkout     := p.r_Varchar2('disable_auto_checkout');
    
      case p.r_Varchar2('staff_gps_tracking_quality_kind')
        when Hes_Pref.c_Gps_Tracking_Qualty_Kind_High then
          p_Gps_Tracking_Settings.Distance := Hes_Pref.c_Gps_Tracking_Qualty_Kind_High_Distance;
          p_Gps_Tracking_Settings.Interval := Hes_Pref.c_Gps_Tracking_Qualty_Kind_High_Interval;
        when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium then
          p_Gps_Tracking_Settings.Distance := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium_Distance;
          p_Gps_Tracking_Settings.Interval := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Medium_Interval;
        when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low then
          p_Gps_Tracking_Settings.Distance := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low_Distance;
          p_Gps_Tracking_Settings.Interval := Hes_Pref.c_Gps_Tracking_Qualty_Kind_Low_Interval;
        when Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom then
          p_Gps_Tracking_Settings.Distance := p.r_Number('staff_gps_tracking_distance');
          p_Gps_Tracking_Settings.Interval := p.r_Number('staff_gps_tracking_interval');
        else
          b.Raise_Not_Implemented;
      end case;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Prepare_Oauth2_Auth_Url
  (
    i_Provider_Id          number,
    i_Use_Head_Credentials boolean := false
  ) return varchar2 is
    r_Provider    Hes_Oauth2_Providers%rowtype;
    r_Session     Hes_Oauth2_Session_States%rowtype;
    r_Credentials Hes_Oauth2_Credentials%rowtype;
    v_Auth_Url    varchar2(300);
  
    v_Credentials_Company_Id number := Ui.Company_Id;
  begin
    if i_Use_Head_Credentials then
      v_Credentials_Company_Id := Md_Pref.Company_Head;
    end if;
  
    r_Provider    := z_Hes_Oauth2_Providers.Load(i_Provider_Id);
    r_Credentials := z_Hes_Oauth2_Credentials.Load(i_Company_Id  => v_Credentials_Company_Id,
                                                   i_Provider_Id => i_Provider_Id);
  
    z_Hes_Oauth2_Session_States.Init(p_Row         => r_Session,
                                     i_Company_Id  => Ui.Company_Id,
                                     i_Session_Id  => Ui.Session_Id,
                                     i_Provider_Id => i_Provider_Id,
                                     i_State_Token => Hes_Util.Gen_State_Token(i_Company_Id => Ui.Company_Id,
                                                                               i_Session_Id => Ui.Session_Id));
  
    Hes_Api.Save_State_Token(r_Session);
  
    v_Auth_Url := r_Provider.Auth_Url || '?response_type=code&state=' || r_Session.State_Token;
  
    v_Auth_Url := v_Auth_Url || '&client_id=' || r_Credentials.Client_Id;
  
    if r_Provider.Scope is not null then
      v_Auth_Url := v_Auth_Url || '&scope=' || r_Provider.Scope;
    end if;
  
    return v_Auth_Url;
  end;

end Uit_Hes;
/
