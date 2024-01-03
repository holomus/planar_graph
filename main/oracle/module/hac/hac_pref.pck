create or replace package Hac_Pref is
  ----------------------------------------------------------------------------------------------------
  type Dss_Server_Rt is record(
    Acms     Hac_Servers%rowtype,
    Username varchar2(300 char),
    Password varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  type Dss_Device_Rt is record(
    Company_Id    number,
    Acms          Hac_Devices%rowtype,
    Register_Code varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  type Hik_Server_Rt is record(
    Acms           Hac_Servers%rowtype,
    Partner_Key    varchar2(300 char),
    Partner_Secret varchar2(300 char),
    Token          varchar2(64 char));
  ----------------------------------------------------------------------------------------------------
  type Hik_Device_Rt is record(
    Company_Id    number,
    Acms          Hac_Devices%rowtype,
    Isup_Password varchar2(300 char),
    Ignore_Tracks varchar2(1),
    Event_Types   Array_Number);
  ----------------------------------------------------------------------------------------------------
  c_Acms_Final_Service_Name constant varchar2(100) := 'com.verifix.vhr.AcmsFinalService';
  ----------------------------------------------------------------------------------------------------
  -- Dahua integration preferences
  ----------------------------------------------------------------------------------------------------
  c_Dahua_Api_Service_Name        constant varchar2(100) := 'com.verifix.vhr.dahua.DahuaRuntimeService';
  c_Start_Page_Num                constant number := 1; -- used in get list requests
  c_Default_Page_Size             constant number := 500; -- used in get list requests, max number of items in list
  c_Ascending_Order_Direction     constant number := 0; -- used in get list requests
  c_Descending_Order_Direction    constant number := 1; -- used in get list requests
  c_Dahua_Gender_Neutral          constant number := 0;
  c_Person_Source_Management_List constant number := 0;
  c_Auth_Start_Time               constant number := 1615824000; -- unix timestamp in seconds, 01.01.2000 00:00:00
  c_Auth_End_Time                 constant number := 1931443199; -- unix timestamp in seconds, 01.01.2050 00:00:00
  ----------------------------------------------------------------------------------------------------
  -- DAHUA DEVICE CHANNEL CODE
  ---------------------------------------------------------------------------------------------------- 
  -- channel code consists of: 
  -- device_code + '$' + device_type + '$' + channel_sequence_val + '$' + unit_sequence_val
  -- by default device type is '7' (access_control)
  -- by default channel_sequence_val is '0' (only one)
  -- by default unit_sequence_val is '0' (only one)
  ---------------------------------------------------------------------------------------------------- 
  c_Default_Channel_Id_Tail constant varchar2(10) := '$7$0$0';
  ----------------------------------------------------------------------------------------------------
  -- DAHUA API METHODS
  ---------------------------------------------------------------------------------------------------- 
  c_Org_Tree_Uri     constant varchar2(50) := '/brms/api/v1.0/tree/deviceOrg';
  c_Person_Group_Uri constant varchar2(50) := '/obms/api/v1.1/acs/person-group';
  c_Device_Uri       constant varchar2(50) := '/brms/api/v1.1/device';
  c_Door_Group_Uri   constant varchar2(50) := '/obms/api/v1.0/accessControl/doorGroup';
  c_Access_Group_Uri constant varchar2(50) := '/obms/api/v1.1/acs/access-group';
  c_Person_Uri       constant varchar2(50) := '/obms/api/v1.1/acs/person';
  c_Tracks_Fetch_Uri constant varchar2(50) := '/obms/api/v1.1/acs/access/record/fetch/page';
  ----------------------------------------------------------------------------------------------------
  -- DAHUA API RESOURCE uris (are added to the api method uris)
  ----------------------------------------------------------------------------------------------------
  c_List_Uri                  constant varchar2(50) := '/list';
  c_Page_Uri                  constant varchar2(50) := '/page';
  c_Person_Access_Authorize   constant varchar2(50) := '/person/authorize';
  c_Person_Access_Deauthorize constant varchar2(50) := '/person/unauthorize';
  ----------------------------------------------------------------------------------------------------
  -- Dahua default role ids (are kept in DSS server)
  ----------------------------------------------------------------------------------------------------
  c_Superadmin_Role_Id constant number := 1;
  c_Admin_Role_Id      constant number := 2;
  ----------------------------------------------------------------------------------------------------
  -- Dahua default org code
  ----------------------------------------------------------------------------------------------------
  c_Default_Root_Org_Code constant varchar2(3) := '001';
  ----------------------------------------------------------------------------------------------------
  c_Utc_Timezone_Code constant varchar2(3) := 'UTC';
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision integration preferences
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Api_Service_Name constant varchar2(100) := 'com.verifix.vhr.hikvision.HikvisionRuntimeService';
  c_Hik_Begin_Time       constant varchar2(50) := '2020-01-01T00:00:00+00:00';
  c_Hik_End_Time         constant varchar2(50) := '2037-12-31T23:59:59+00:00'; -- max allowed effective date
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision request paths
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Request_Path_Get_Events              constant varchar2(100 char) := '/artemis/api/acs/v1/door/events';
  c_Hik_Request_Path_Get_Access_Levels       constant varchar2(100 char) := '/artemis/api/acs/v1/privilege/group';
  c_Hik_Request_Path_Get_Devices             constant varchar2(100 char) := '/artemis/api/resource/v1/acsDevice/acsDeviceList';
  c_Hik_Request_Path_Get_Doors               constant varchar2(100 char) := '/artemis/api/resource/v1/acsDoor/acsDoorList';
  c_Hik_Request_Path_Get_Organizations       constant varchar2(100 char) := '/artemis/api/resource/v1/org/orgList';
  c_Hik_Request_Path_Get_Persons             constant varchar2(100 char) := '/artemis/api/resource/v1/person/personList';
  c_Hik_Request_Path_Get_Person_Photo        constant varchar2(100 char) := '/artemis/api/resource/v1/person/picture_data';
  c_Hik_Request_Path_Subscribe_To_Tracks     constant varchar2(100 char) := '/artemis/api/eventService/v1/eventSubscriptionByEventTypes';
  c_Hik_Request_Path_Unsubscribe_From_Tracks constant varchar2(100 char) := '/artemis/api/eventService/v1/eventUnSubscriptionByEventTypes';
  c_Hik_Request_Path_Subscriptions_List      constant varchar2(100 char) := '/artemis/api/eventService/v1/eventSubscriptionView';
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision device statuses
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Device_Status_Offline constant number := 2;
  c_Hik_Device_Status_Online  constant number := 1;
  c_Hik_Device_Status_Unknown constant number := 0;
  ----------------------------------------------------------------------------------------------------  
  -- Dahua device statuses
  ----------------------------------------------------------------------------------------------------  
  c_Dss_Device_Status_Offline constant number := 0;
  c_Dss_Device_Status_Online  constant number := 1;
  c_Dss_Device_Status_Unknown constant number := 2;
  ----------------------------------------------------------------------------------------------------
  -- device statuses
  ---------------------------------------------------------------------------------------------------- 
  c_Device_Status_Offline constant varchar2(1) := 'F';
  c_Device_Status_Online  constant varchar2(1) := 'O';
  c_Device_Status_Unknown constant varchar2(1) := 'U';
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision door states
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Door_State_Remain_Open   constant varchar2(2) := 'RO';
  c_Hik_Door_State_Closed        constant varchar2(1) := 'C';
  c_Hik_Door_State_Open          constant varchar2(1) := 'O';
  c_Hik_Door_State_Remain_Closed constant varchar2(2) := 'RC';
  c_Hik_Door_State_Offline       constant varchar2(1) := 'F';
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision access level types
  ----------------------------------------------------------------------------------------------------
  c_Hik_Access_Level_Type_Access_Control number := 1;
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision event types (Verifix side)
  ----------------------------------------------------------------------------------------------------
  c_Hik_Event_Type_From_Notifications constant varchar2(1) := 'N';
  c_Hik_Event_Type_Manually_Retrieved constant varchar2(1) := 'M';
  c_Hik_Event_Type_Loaded_By_Job      constant varchar2(1) := 'J';
  ---------------------------------------------------------------------------------------------------- 
  -- Hikvision event type codes
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Event_Code_By_Face        constant number := 196893;
  c_Hik_Event_Code_By_Fingerprint constant number := 200516;
  c_Hik_Event_Code_By_Card        constant number := 198914;
  ----------------------------------------------------------------------------------------------------
  -- Hikvision event receiver data
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Event_Receiver_Route_Uri        constant varchar2(100 char) := 'hik/event_receiver';
  c_Hik_Device_Event_Receiver_Route_Uri constant varchar2(100 char) := '/hik/device/event_receiver';
  ----------------------------------------------------------------------------------------------------
  -- device attach kind
  ----------------------------------------------------------------------------------------------------
  c_Device_Attach_Primary   constant varchar2(1) := 'P';
  c_Device_Attach_Secondary constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- device types 
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Device_Type_Hikvision constant varchar2(20) := 'VHR:1';
  c_Pcode_Device_Type_Dahua     constant varchar2(20) := 'VHR:2';
  ----------------------------------------------------------------------------------------------------
  -- DSS TRACK SOURCE
  ----------------------------------------------------------------------------------------------------
  c_Dss_Track_Source_Manual constant varchar2(1) := 'M';
  c_Dss_Track_Source_Queue  constant varchar2(1) := 'Q';
  c_Dss_Track_Source_Job    constant varchar2(1) := 'J';
  ----------------------------------------------------------------------------------------------------
  -- HIK TRACK TYPES
  ---------------------------------------------------------------------------------------------------- 
  c_Hik_Track_Type_Input  constant number := 1;
  c_Hik_Track_Type_Output constant number := 2;
  ----------------------------------------------------------------------------------------------------
  c_Unknown_Person_Code constant number := -1;
  ----------------------------------------------------------------------------------------------------
  c_Event_Type_Delimiter constant varchar2(1) := '#';
  ----------------------------------------------------------------------------------------------------
  -- person auth types
  ----------------------------------------------------------------------------------------------------
  c_Person_Auth_Type_Person_Code   constant varchar2(1) := 'C';
  c_Person_Auth_Type_External_Code constant varchar2(1) := 'E';
  c_Person_Auth_Type_Pin           constant varchar2(1) := 'P';
  ----------------------------------------------------------------------------------------------------
  -- Hik listening Device attendance statuses
  ----------------------------------------------------------------------------------------------------
  c_Attendance_Status_Input  constant varchar2(100) := 'checkIn';
  c_Attendance_Status_Output constant varchar2(100) := 'checkOut';
  ----------------------------------------------------------------------------------------------------
  c_Event_Type_Source_Dss        constant varchar2(1) := 'D';
  c_Event_Type_Source_Hikcentral constant varchar2(1) := 'H';
  c_Event_Type_Source_Hik_Device constant varchar2(1) := 'L';
  ----------------------------------------------------------------------------------------------------
  c_Accepted_Major_Event_Type constant number := 5;
end Hac_Pref;
/
create or replace package body Hac_Pref is
end Hac_Pref;
/
