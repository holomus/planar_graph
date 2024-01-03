create or replace package Hes_Pref is
  ----------------------------------------------------------------------------------------------------
  type Staff_Track_Settings_Rt is record(
    Vision_Server_Id     number,
    User_Settings        varchar2(1),
    Track_Type_Input     varchar2(1),
    Track_Type_Output    varchar2(1),
    Track_Type_Check     varchar2(1),
    Track_Check_Location varchar2(1),
    Track_By_Qr_Code     varchar2(1),
    Track_Potential      varchar2(1),
    Track_Start          varchar2(1),
    Gps_Determination    varchar2(1),
    Face_Recognition     varchar2(1),
    Ignore_Invalid_Track varchar2(1),
    Emotion_Wink         varchar2(1),
    Emotion_Smile        varchar2(1),
    Last_Track_Type      varchar2(1));
  ----------------------------------------------------------------------------------------------------
  type Timepad_Track_Settings_Rt is record(
    Qr_Code_Limit_Time number,
    Track_Types        varchar2(50),
    Mark_Types         varchar2(50),
    Emotion_Types      varchar2(50),
    Lang_Code          varchar2(10));
  ----------------------------------------------------------------------------------------------------  
  type Staff_Gps_Tracking_Settings_Rt is record(
    User_Settings             varchar2(1),
    Enabled                   varchar2(1),
    Gps_Track_Collect_Enabled varchar2(1),
    Auto_Output_Enabled       varchar2(1),
    Disable_Auto_Checkout     varchar2(1),
    Distance                  number,
    interval                  number);
  ----------------------------------------------------------------------------------------------------
  type Staff_Face_Register_Rt is record(
    User_Settings varchar2(1),
    Face_Register varchar2(1),
    Allow_Gallery varchar2(1));
  ----------------------------------------------------------------------------------------------------
  type Staff_Request_Manager_Approval_Rt is record(
    User_Settings    varchar2(1),
    Request_Settings varchar2(1),
    Enable_Request   varchar2(1));
  ----------------------------------------------------------------------------------------------------
  type Staff_Change_Manager_Approval_Rt is record(
    User_Settings          varchar2(1),
    Change_Settings        varchar2(1),
    Enable_Schedule_Change varchar2(1));
  ----------------------------------------------------------------------------------------------------  
  type Staff_Notify_Settings_Rt is record(
    Calendar_Day_Change          varchar2(1),
    Late_Time                    varchar2(1),
    Early_Time                   varchar2(1),
    Request                      varchar2(1),
    Request_Change_Status        varchar2(1),
    Request_Manager_Approval     varchar2(1),
    Plan_Change                  varchar2(1),
    Plan_Change_Status_Change    varchar2(1),
    Plan_Change_Manager_Approval varchar2(1),
    Gps_Tracking_Change          varchar2(1));
  ----------------------------------------------------------------------------------------------------
  -- change day limit
  ----------------------------------------------------------------------------------------------------
  type Change_Day_Limit_Rt is record(
    User_Settings                varchar2(1),
    Change_With_Restriction_Days varchar2(1),
    Change_Restriction_Days      number,
    Change_With_Monthly_Limit    varchar2(1),
    Change_Monthly_Limit         number);
  ----------------------------------------------------------------------------------------------------
  c_Staff_Form_Name constant varchar2(50) := '/vhr/hes/staff';
  ----------------------------------------------------------------------------------------------------
  -- notification settings
  ----------------------------------------------------------------------------------------------------
  c_Pref_Nt_Calendar_Day_Change          constant varchar2(50) := 'hes:nt:calendar_day_change';
  c_Pref_Nt_Late_Time                    constant varchar2(50) := 'hes:nt:late_time';
  c_Pref_Nt_Early_Time                   constant varchar2(50) := 'hes:nt:early_time';
  c_Pref_Nt_Request                      constant varchar2(50) := 'hes:nt:request';
  c_Pref_Nt_Request_Change_Status        constant varchar2(50) := 'hes:nt:request_change_status';
  c_Pref_Nt_Request_Manager_Approval     constant varchar2(50) := 'hes:nt:request_manager_approval';
  c_Pref_Nt_Plan_Change                  constant varchar2(50) := 'hes:nt:plan_change';
  c_Pref_Nt_Plan_Change_Status_Change    constant varchar2(50) := 'hes:nt:plan_change_status_change';
  c_Pref_Nt_Plan_Change_Manager_Approval constant varchar2(50) := 'hes:nt:plan_change_manager_approval';
  c_Pref_Nt_Gps_Tracking_Change          constant varchar2(50) := 'hes:nt:gps_tracking_change';
  ----------------------------------------------------------------------------------------------------
  c_Timepad_Qr_Code_Limit_Time constant varchar2(50) := 'hes:timepad:qr_code_limit_time';
  c_Timepad_Track_Types        constant varchar2(50) := 'hes:timepad:track_types';
  c_Timepad_Mark_Types         constant varchar2(50) := 'hes:timepad:mark_types';
  c_Timepad_Emotion_Types      constant varchar2(50) := 'hes:timepad:emotion_types';
  c_Timepad_Lang_Code          constant varchar2(50) := 'hes:timepad:lang_code';
  ----------------------------------------------------------------------------------------------------
  c_Pref_Staff_Track_Type_Input     constant varchar2(50) := 'hes:staff:track_type_input';
  c_Pref_Staff_Track_Type_Output    constant varchar2(50) := 'hes:staff:track_type_output';
  c_Pref_Staff_Track_Type_Check     constant varchar2(50) := 'hes:staff:track_type_check';
  c_Pref_Staff_Track_Check_Location constant varchar2(50) := 'hes:staff:track_check_location';
  c_Pref_Staff_Track_By_Qr_Code     constant varchar2(50) := 'hes:staff:track_by_qr_code';
  c_Pref_Staff_Track_Potential      constant varchar2(50) := 'hes:staff:track_potential';
  ----------------------------------------------------------------------------------------------------
  c_Pref_Staff_Track_Start                  constant varchar2(50) := 'hes:staff:track_start';
  c_Pref_Staff_Gps_Determination            constant varchar2(50) := 'hes:staff:gps_determination';
  c_Pref_Staff_Face_Recognition             constant varchar2(50) := 'hes:staff:face_recognition';
  c_Pref_Staff_Emotion_Wink                 constant varchar2(50) := 'hes:staff:emotion_wink';
  c_Pref_Staff_Emotion_Smile                constant varchar2(50) := 'hes:staff:emotion_smile';
  c_Pref_Staff_Face_Register                constant varchar2(50) := 'hes:staff:face_register';
  c_Pref_Staff_Allow_Gallery                constant varchar2(50) := 'hes:staff:allow_gallery';
  c_Pref_Staff_Ignore_Invalid_Track         constant varchar2(50) := 'hes:staff:ignore_invalid_track';
  c_Pref_Staff_Request_Manager_Approval     constant varchar2(50) := 'hes:staff:request_manager_approval';
  c_Pref_Staff_Enable_Request               constant varchar2(50) := 'hes:staff:enable_request';
  c_Pref_Staff_Change_Manager_Approval      constant varchar2(50) := 'hes:staff:change_manager_approval';
  c_Pref_Staff_Enable_Schedule_Change       constant varchar2(50) := 'hes:staff:enable_schedule_change';
  c_Pref_Staff_Last_Track_Type              constant varchar2(50) := 'hes:staff:last_track_type';
  c_Pref_Staff_Change_With_Restriction_Days constant varchar2(50) := 'hes:staff:change_with_restriction_days';
  c_Pref_Staff_Change_Restriction_Days      constant varchar2(50) := 'hes:staff:change_restriction_days';
  c_Pref_Staff_Change_With_Monthly_Limit    constant varchar2(50) := 'hes:staff:change_with_monthly_limit';
  c_Pref_Staff_Change_Monthly_Limit         constant varchar2(50) := 'hes:staff:change_monthly_limit';
  c_Pref_Staff_Use_Task_Manager             constant varchar2(50) := 'hes:staff:use_task_manager';
  ----------------------------------------------------------------------------------------------------
  c_Pref_Staff_Gps_Tracking                   constant varchar2(50) := 'hes:staff:gps_tracking';
  c_Pref_Staff_Gps_Tracking_Gps_Track_Collect constant varchar2(50) := 'hes:staff:gps_tracking_gps_track_collect';
  c_Pref_Staff_Gps_Tracking_Auto_Output       constant varchar2(50) := 'hes:staff:gps_tracking_auto_output';
  c_Pref_Staff_Disable_Auto_Checkout          constant varchar2(50) := 'hes:staff:disable_auto_checkout';
  c_Pref_Staff_Gps_Tracking_Distance          constant varchar2(50) := 'hes:staff:gps_tracking_distance';
  c_Pref_Staff_Gps_Tracking_Interval          constant varchar2(50) := 'hes:staff:gps_tracking_interval';
  ----------------------------------------------------------------------------------------------------
  c_Pref_Staff_Ts_Gps_Determination constant varchar2(1) := 'G';
  c_Pref_Staff_Ts_Face_Recognition  constant varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------
  -- bu constant faqat Apple iOSga ma'lumot yuborib aldash uchun chiqarilgan
  -- boshqa logic ahamiyati yo'q
  ----------------------------------------------------------------------------------------------------
  c_Pref_Biometric_Recognition_Enabled constant varchar2(50) := 'hes:staff:biometric_recognition_enabled';
  ----------------------------------------------------------------------------------------------------
  -- gps tracking min values
  ----------------------------------------------------------------------------------------------------
  c_Staff_Gps_Tracking_Distance_Min constant number := 1;
  c_Staff_Gps_Tracking_Interval_Min constant number := 1;
  ----------------------------------------------------------------------------------------------------
  -- gps tracking qualty kinds
  ----------------------------------------------------------------------------------------------------
  c_Gps_Tracking_Qualty_Kind_High   constant varchar2(1) := 'H';
  c_Gps_Tracking_Qualty_Kind_Medium constant varchar2(1) := 'M';
  c_Gps_Tracking_Qualty_Kind_Low    constant varchar2(1) := 'L';
  c_Gps_Tracking_Qualty_Kind_Custom constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- gps tracking qualty kind values
  ----------------------------------------------------------------------------------------------------
  c_Gps_Tracking_Qualty_Kind_High_Distance constant number := 1;
  c_Gps_Tracking_Qualty_Kind_High_Interval constant number := 1;

  c_Gps_Tracking_Qualty_Kind_Medium_Distance constant number := 5;
  c_Gps_Tracking_Qualty_Kind_Medium_Interval constant number := 5;

  c_Gps_Tracking_Qualty_Kind_Low_Distance constant number := 10;
  c_Gps_Tracking_Qualty_Kind_Low_Interval constant number := 10;
  ---------------------------------------------------------------------------------------------------- 
  -- Billz integration preferences
  ---------------------------------------------------------------------------------------------------- 
  c_Billz_Api_Url                  varchar2(100) := 'https://api.billz.io/v2/';
  c_Billz_Api_Reports_Sales_Method varchar2(100) := 'reports.sales';
  c_Billz_Api_Reports_Sales_Id     varchar2(100) := '1200';
  c_Billz_Api_Currency_Uzs         varchar2(100) := 'UZS';
  c_Billz_Api_Service_Name         varchar2(100) := 'com.verifix.vhr.BillzRuntimeService';
  ----------------------------------------------------------------------------------------------------
  c_Default_User_Agent_Header varchar2(100) := 'verifix';
  ----------------------------------------------------------------------------------------------------
  -- key for notification uri
  ----------------------------------------------------------------------------------------------------
  c_Key_Uri_Request constant varchar2(50) := 'hes:staff:request';
  c_Key_Uri_Change  constant varchar2(50) := 'hes:staff:change';
  ----------------------------------------------------------------------------------------------------
  -- OAuth2 provider ids
  ----------------------------------------------------------------------------------------------------
  c_Provider_Hh_Id  constant number := 1;
  c_Provider_Olx_Id constant number := 2;
end Hes_Pref;
/
create or replace package body Hes_Pref is
end Hes_Pref;
/
