create or replace package Htt_Pref is
  ----------------------------------------------------------------------------------------------------
  type Photo_Rt is record(
    Photo_Sha varchar2(64),
    Is_Main   varchar2(1));
  type Photo_Nt is table of Photo_Rt;
  ----------------------------------------------------------------------------------------------------
  type Person_Rt is record(
    Company_Id number(20),
    Person_Id  number(20),
    Pin        varchar2(15),
    Pin_Code   number(8),
    Rfid_Code  varchar2(20),
    Qr_Code    varchar2(64),
    Photos     Photo_Nt);
  ----------------------------------------------------------------------------------------------------
  type Calendar_Day_Rt is record(
    Calendar_Date date,
    name          varchar2(100),
    year          number(4),
    Day_Kind      varchar2(1),
    Swapped_Date  date);
  type Calendar_Day_Nt is table of Calendar_Day_Rt;
  ----------------------------------------------------------------------------------------------------
  type Calendar_Week_Days_Rt is record(
    Order_No        number,
    Plan_Time       number,
    Preholiday_Hour number,
    Preweekend_Hour number);
  type Calender_Week_Days_Nt is table of Calendar_Week_Days_Rt;
  ----------------------------------------------------------------------------------------------------
  type Calendar_Rt is record(
    Company_Id    number(20),
    Filial_Id     number(20),
    Calendar_Id   number(20),
    name          varchar2(100 char),
    Code          varchar2(50 char),
    year          number,
    Monthly_Limit varchar2(1),
    Daily_Limit   varchar2(1),
    Days          Calendar_Day_Nt,
    Week_Days     Calender_Week_Days_Nt,
    Rest_Days     Array_Number);
  ----------------------------------------------------------------------------------------------------
  type Mark_Rt is record(
    Begin_Time number(4),
    End_Time   number(4));
  type Mark_Nt is table of Mark_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Day_Marks_Rt is record(
    Schedule_Date date,
    Begin_Time    number,
    End_Time      number,
    Marks         Mark_Nt);
  type Schedule_Day_Marks_Nt is table of Schedule_Day_Marks_Rt;
  ----------------------------------------------------------------------------------------------------
  type Time_Weight_Rt is record(
    Begin_Time number(4),
    End_Time   number(4),
    Weight     number(20));
  type Time_Weight_Nt is table of Time_Weight_Rt;
  ---------------------------------------------------------------------------------------------------- 
  type Interval_Weight_Rt is record(
    Begin_Time date,
    End_Time   date,
    Weight     number(20));
  type Interval_Weight_Nt is table of Interval_Weight_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Day_Weights_Rt is record(
    Schedule_Date date,
    Begin_Time    number,
    End_Time      number,
    Weights       Time_Weight_Nt);
  type Schedule_Day_Weights_Nt is table of Schedule_Day_Weights_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Day_Rt is record(
    Schedule_Date    date,
    Day_Kind         varchar2(1),
    Begin_Time       number(4),
    End_Time         number(4),
    Break_Enabled    varchar2(1),
    Break_Begin_Time number(4),
    Break_End_Time   number(4),
    Plan_Time        number(4));
  type Schedule_Day_Nt is table of Schedule_Day_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Pattern_Day_Rt is record(
    Day_No           number(4),
    Day_Kind         varchar2(1),
    Begin_Time       number(4),
    End_Time         number(4),
    Break_Enabled    varchar2(1),
    Break_Begin_Time number(4),
    Break_End_Time   number(4),
    Plan_Time        number(4),
    Pattern_Marks    Mark_Nt,
    Pattern_Weights  Time_Weight_Nt);
  type Schedule_Pattern_Day_Nt is table of Schedule_Pattern_Day_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Pattern_Rt is record(
    Pattern_Kind   varchar2(1),
    All_Days_Equal varchar2(1),
    Count_Days     number(4),
    Begin_Date     date,
    End_Date       date,
    Pattern_Day    Schedule_Pattern_Day_Nt);
  ----------------------------------------------------------------------------------------------------
  type Schedule_Rt is record(
    Company_Id                number(20),
    Filial_Id                 number(20),
    Schedule_Id               number(20),
    name                      varchar2(100 char),
    Schedule_Kind             varchar2(1),
    Shift                     number(4),
    Input_Acceptance          number(4),
    Output_Acceptance         number(4),
    Track_Duration            number(4),
    Count_Late                varchar2(1),
    Count_Early               varchar2(1),
    Count_Lack                varchar2(1),
    Count_Free                varchar2(1),
    Use_Weights               varchar2(1),
    Advanced_Setting          varchar2(1),
    Allowed_Late_Time         number,
    Allowed_Early_Time        number,
    Begin_Late_Time           number,
    End_Early_Time            number,
    Calendar_Id               number(20),
    Take_Holidays             varchar(1),
    Take_Nonworking           varchar2(1),
    Take_Additional_Rest_Days varchar2(1),
    Gps_Turnout_Enabled       varchar2(1),
    Gps_Use_Location          varchar2(1),
    Gps_Max_Interval          number,
    State                     varchar2(1),
    Code                      varchar2(50 char),
    Days                      Schedule_Day_Nt,
    Marks                     Schedule_Day_Marks_Nt,
    Weights                   Schedule_Day_Weights_Nt,
    Pattern                   Schedule_Pattern_Rt,
    year                      number(4));
  ----------------------------------------------------------------------------------------------------  
  type Schedule_Template_Rt is record(
    Template_Id               number(20),
    name                      varchar2(100 char),
    Description               varchar2(3000 char),
    Schedule_Kind             varchar2(1),
    All_Days_Equal            varchar2(1),
    Count_Days                number(4),
    Shift                     number(4),
    Input_Acceptance          number(4),
    Output_Acceptance         number(4),
    Track_Duration            number(4),
    Count_Late                varchar2(1),
    Count_Early               varchar2(1),
    Count_Lack                varchar2(1),
    Take_Holidays             varchar(1),
    Take_Nonworking           varchar2(1),
    Take_Additional_Rest_Days varchar2(1),
    Order_No                  number(6),
    State                     varchar2(1),
    Code                      varchar2(50),
    Pattern_Days              Schedule_Pattern_Day_Nt);
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Rt is record(
    Company_Id   number(20),
    Filial_Id    number(20),
    Timesheet_Id number(20),
    Input_Time   date,
    Output_Time  date);
  type Timesheet_Nt is table of Timesheet_Rt;
  ----------------------------------------------------------------------------------------------------
  type Time_Part_Rt is record(
    Input_Time  date,
    Output_Time date);
  type Time_Part_Nt is table of Time_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Track_Rt is record(
    Company_Id     number,
    Filial_Id      number,
    Timesheet_Id   number,
    Track_Id       number,
    Track_Datetime date,
    Track_Type     varchar2(1),
    Trans_Input    varchar2(1),
    Trans_Output   varchar2(1),
    Trans_Check    varchar2(1));
  type Timesheet_Track_Nt is table of Timesheet_Track_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Fact_Rt is record(
    Company_Id   number(20),
    Filial_Id    number(20),
    Timesheet_Id number(20),
    Time_Kind_Id number(20),
    Fact_Value   number(20));
  type Timesheet_Fact_Nt is table of Timesheet_Fact_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Interval_Rt is record(
    Company_Id     number(20),
    Filial_Id      number(20),
    Interval_Id    number(20),
    Timesheet_Id   number(20),
    Interval_Begin date,
    Interval_End   date);
  type Timesheet_Interval_Nt is table of Timesheet_Interval_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Aggregated_Fact_Rt is record(
    Time_Kind_Id number(20),
    Fact_Value   number(20));
  type Timesheet_Aggregated_Fact_Nt is table of Timesheet_Aggregated_Fact_Rt;
  ----------------------------------------------------------------------------------------------------
  type Time_Kind_Rt is record(
    name  varchar2(100 char),
    Pcode varchar2(20));
  type Time_Kind_Nt is table of Time_Kind_Rt;
  ----------------------------------------------------------------------------------------------------
  type Staff_Part_Rt is record(
    Staff_Id   number(20),
    Part_Begin date,
    Part_End   date);
  type Staff_Part_Nt is table of Staff_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  type Track_Rt is record(
    Company_Id number(20),
    Filial_Id  number(20),
    Track_Id   number(20));
  type Track_Nt is table of Track_Rt;
  ----------------------------------------------------------------------------------------------------
  type Gps_Track_Rt is record(
    Company_Id number,
    Filial_Id  number,
    Person_Id  number,
    Track_Date date,
    Data       blob,
    Batch_Id   number);
  ----------------------------------------------------------------------------------------------------
  type Gps_Track_Data_Rt is record(
    Company_Id number,
    Filial_Id  number,
    Track_Id   number,
    Person_Id  number,
    Track_Date date,
    Track_Time date,
    Lat        number,
    Lng        number,
    Accuracy   number,
    Provider   varchar2(1));
  type Gps_Track_Data_Nt is table of Gps_Track_Data_Rt;
  ----------------------------------------------------------------------------------------------------
  type Change_Day_Rt is record(
    Change_Date      date,
    Swapped_Date     date,
    Day_Kind         varchar2(1),
    Begin_Time       date,
    End_Time         date,
    Break_Enabled    varchar2(1),
    Break_Begin_Time date,
    Break_End_Time   date,
    Plan_Time        number(5));
  type Change_Day_Nt is table of Change_Day_Rt;
  ----------------------------------------------------------------------------------------------------
  type Change_Day_Weights is record(
    Company_Id  number,
    Filial_Id   number,
    Staff_Id    number,
    Change_Id   number,
    Change_Date date,
    Weights     Time_Weight_Nt);
  ----------------------------------------------------------------------------------------------------
  type Change_Rt is record(
    Company_Id  number(20),
    Filial_Id   number(20),
    Change_Id   number(20),
    Staff_Id    number(20),
    Change_Kind varchar2(1),
    Note        varchar2(300 char),
    Change_Days Change_Day_Nt);
  ----------------------------------------------------------------------------------------------------
  -- individual schedules  
  ----------------------------------------------------------------------------------------------------
  type Registry_Unit_Rt is record(
    Unit_Id         number,
    Staff_Id        number,
    Robot_Id        number,
    Monthly_Minutes number,
    Monthly_Days    number,
    Unit_Days       Schedule_Day_Nt,
    Unit_Marks      Schedule_Day_Marks_Nt,
    Unit_Weights    Schedule_Day_Weights_Nt);
  type Registry_Unit_Nt is table of Registry_Unit_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Registry_Rt is record(
    Company_Id                number,
    Filial_Id                 number,
    Registry_Id               number,
    Registry_Date             date,
    Registry_Number           varchar2(50 char),
    Registry_Kind             varchar2(1),
    Schedule_Kind             varchar2(1),
    month                     date,
    Division_Id               number,
    Note                      varchar2(300 char),
    Shift                     number,
    Input_Acceptance          number,
    Output_Acceptance         number,
    Track_Duration            number,
    Count_Late                varchar2(1),
    Count_Early               varchar2(1),
    Count_Lack                varchar2(1),
    Count_Free                varchar2(1),
    Advanced_Setting          varchar2(1),
    Allowed_Late_Time         number,
    Allowed_Early_Time        number,
    Begin_Late_Time           number,
    End_Early_Time            number,
    Calendar_Id               number,
    Take_Holidays             varchar(1),
    Take_Nonworking           varchar2(1),
    Take_Additional_Rest_Days varchar2(1),
    Gps_Turnout_Enabled       varchar2(1),
    Gps_Use_Location          varchar2(1),
    Gps_Max_Interval          number,
    Units                     Registry_Unit_Nt);
  ----------------------------------------------------------------------------------------------------  
  type Gps_Time_Group_Rt is record(
    Unit_Number number,
    Lat         number,
    Lng         number,
    Accuracy    number,
    Track_Time  date);
  type Gps_Time_Group_Nt is table of Gps_Time_Group_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Gps_Distance_Group_Rt is record(
    Lat        number,
    Lng        number,
    Accuracy   number,
    Track_Time date);
  type Gps_Distance_Group_Nt is table of Gps_Distance_Group_Rt;
  ----------------------------------------------------------------------------------------------------
  -- attach type
  ----------------------------------------------------------------------------------------------------
  c_Attach_Type_Manual constant varchar2(1) := 'M';
  c_Attach_Type_Auto   constant varchar2(1) := 'A';
  c_Attach_Type_Global constant varchar2(1) := 'G';
  ----------------------------------------------------------------------------------------------------
  -- day kind
  ----------------------------------------------------------------------------------------------------
  c_Day_Kind_Work            constant varchar2(1) := 'W';
  c_Day_Kind_Rest            constant varchar2(1) := 'R';
  c_Day_Kind_Holiday         constant varchar2(1) := 'H';
  c_Day_Kind_Additional_Rest constant varchar2(1) := 'A';
  c_Day_Kind_Nonworking      constant varchar2(1) := 'N';
  c_Day_Kind_Swapped         constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- schedule kind 
  ----------------------------------------------------------------------------------------------------
  c_Schedule_Kind_Custom   constant varchar2(1) := 'C';
  c_Schedule_Kind_Flexible constant varchar2(1) := 'F';
  c_Schedule_Kind_Hourly   constant varchar2(1) := 'H';
  ----------------------------------------------------------------------------------------------------
  -- pattern kind
  ----------------------------------------------------------------------------------------------------
  c_Pattern_Kind_Weekly   constant varchar2(1) := 'W';
  c_Pattern_Kind_Periodic constant varchar2(1) := 'P';
  ----------------------------------------------------------------------------------------------------
  -- protocol
  ----------------------------------------------------------------------------------------------------
  c_Protocol_Http  constant varchar2(1) := 'H';
  c_Protocol_Https constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- command kind
  ----------------------------------------------------------------------------------------------------
  c_Command_Kind_Update_Device             constant varchar2(1) := 'U';
  c_Command_Kind_Update_All_Device_Persons constant varchar2(1) := 'A';
  c_Command_Kind_Update_Person             constant varchar2(1) := 'P';
  c_Command_Kind_Remove_Device             constant varchar2(1) := 'D';
  c_Command_Kind_Remove_Person             constant varchar2(1) := 'R';
  c_Command_Kind_Sync_Tracks               constant varchar2(1) := 'T';
  ----------------------------------------------------------------------------------------------------
  -- command status
  ----------------------------------------------------------------------------------------------------
  c_Command_Status_New       constant varchar2(1) := 'N';
  c_Command_Status_Sent      constant varchar2(1) := 'S';
  c_Command_Status_Complited constant varchar2(1) := 'C';
  c_Command_Status_Failed    constant varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------
  -- person role
  ----------------------------------------------------------------------------------------------------
  c_Person_Role_Admin  constant varchar2(1) := 'A';
  c_Person_Role_Normal constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------
  -- track type
  ----------------------------------------------------------------------------------------------------
  c_Track_Type_Input            constant varchar2(1) := 'I';
  c_Track_Type_Output           constant varchar2(1) := 'O';
  c_Track_Type_Check            constant varchar2(1) := 'C';
  c_Track_Type_Merger           constant varchar2(1) := 'M';
  c_Track_Type_Potential_Output constant varchar2(1) := 'P';
  c_Track_Type_Gps_Output       constant varchar2(1) := 'G';
  ----------------------------------------------------------------------------------------------------
  -- provider
  ----------------------------------------------------------------------------------------------------
  c_Provider_Gps     constant varchar2(1) := 'G';
  c_Provider_Network constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------
  -- gps track delimetr
  ----------------------------------------------------------------------------------------------------
  c_Gps_Track_Row_Delimiter    constant varchar2(1) := Chr(10);
  c_Gps_Track_Column_Delimiter constant varchar2(1) := Chr(9);
  ----------------------------------------------------------------------------------------------------
  -- emotion type
  ----------------------------------------------------------------------------------------------------
  c_Emotion_Type_Smile constant varchar2(1) := 'S';
  c_Emotion_Type_Wink  constant varchar2(1) := 'W';
  ----------------------------------------------------------------------------------------------------
  -- mark type
  ----------------------------------------------------------------------------------------------------
  c_Mark_Type_Password  constant varchar2(1) := 'P';
  c_Mark_Type_Touch     constant varchar2(1) := 'T';
  c_Mark_Type_Rfid_Card constant varchar2(1) := 'R';
  c_Mark_Type_Qr_Code   constant varchar2(1) := 'Q';
  c_Mark_Type_Face      constant varchar2(1) := 'F';
  c_Mark_Type_Manual    constant varchar2(1) := 'M';
  c_Mark_Type_Auto      constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- track status
  ----------------------------------------------------------------------------------------------------
  c_Track_Status_Draft          constant varchar2(1) := 'D';
  c_Track_Status_Not_Used       constant varchar2(1) := 'N';
  c_Track_Status_Partially_Used constant varchar2(1) := 'P';
  c_Track_Status_Used           constant varchar2(1) := 'U';
  ----------------------------------------------------------------------------------------------------
  -- pcode time kind
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Time_Kind_Turnout             constant varchar2(20) := 'VHR:1';
  c_Pcode_Time_Kind_Late                constant varchar2(20) := 'VHR:2';
  c_Pcode_Time_Kind_Early               constant varchar2(20) := 'VHR:3';
  c_Pcode_Time_Kind_Leave               constant varchar2(20) := 'VHR:4';
  c_Pcode_Time_Kind_Rest                constant varchar2(20) := 'VHR:5';
  c_Pcode_Time_Kind_Lack                constant varchar2(20) := 'VHR:6';
  c_Pcode_Time_Kind_Free                constant varchar2(20) := 'VHR:7';
  c_Pcode_Time_Kind_Sick                constant varchar2(20) := 'VHR:8';
  c_Pcode_Time_Kind_Leave_Full          constant varchar2(20) := 'VHR:9';
  c_Pcode_Time_Kind_Trip                constant varchar2(20) := 'VHR:10';
  c_Pcode_Time_Kind_Vacation            constant varchar2(20) := 'VHR:11';
  c_Pcode_Time_Kind_Overtime            constant varchar2(20) := 'VHR:12';
  c_Pcode_Time_Kind_Meeting             constant varchar2(20) := 'VHR:13';
  c_Pcode_Time_Kind_Holiday             constant varchar2(20) := 'VHR:14';
  c_Pcode_Time_Kind_Nonworking          constant varchar2(20) := 'VHR:15';
  c_Pcode_Time_Kind_Before_Work         constant varchar2(20) := 'VHR:16';
  c_Pcode_Time_Kind_After_Work          constant varchar2(20) := 'VHR:17';
  c_Pcode_Time_Kind_Lunchtime           constant varchar2(20) := 'VHR:18';
  c_Pcode_Time_Kind_Free_Inside         constant varchar2(20) := 'VHR:19';
  c_Pcode_Time_Kind_Turnout_Adjustment  constant varchar2(20) := 'VHR:20';
  c_Pcode_Time_Kind_Overtime_Adjustment constant varchar2(20) := 'VHR:21';
  c_Pcode_Time_Kind_Additional_Rest     constant varchar2(20) := 'VHR:22';
  ----------------------------------------------------------------------------------------------------
  -- pcode request kinds
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Request_Kind_Sick_Leave constant varchar2(20) := 'VHR:1';
  c_Pcode_Request_Kind_Vacation   constant varchar2(20) := 'VHR:2';
  c_Pcode_Request_Kind_Trip       constant varchar2(20) := 'VHR:3';
  c_Pcode_Request_Kind_Leave      constant varchar2(20) := 'VHR:4';
  c_Pcode_Request_Kind_Meeting    constant varchar2(20) := 'VHR:5';
  ----------------------------------------------------------------------------------------------------
  -- view forms
  ----------------------------------------------------------------------------------------------------
  c_Form_Request_View constant varchar2(200) := '/vhr/htt/request_view+view';
  c_Form_Change_View  constant varchar2(200) := '/vhr/htt/change_view+view';
  ----------------------------------------------------------------------------------------------------
  -- pcode default calendar
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Default_Calendar constant varchar2(20) := 'VHR:1';
  ----------------------------------------------------------------------------------------------------
  -- plan load
  ----------------------------------------------------------------------------------------------------
  c_Plan_Load_Full  constant varchar2(1) := 'F';
  c_Plan_Load_Part  constant varchar2(1) := 'P';
  c_Plan_Load_Extra constant varchar2(1) := 'E';
  ----------------------------------------------------------------------------------------------------
  -- day count type
  ----------------------------------------------------------------------------------------------------
  c_Day_Count_Type_Calendar_Days   constant varchar2(1) := 'C';
  c_Day_Count_Type_Work_Days       constant varchar2(1) := 'W';
  c_Day_Count_Type_Production_Days constant varchar2(1) := 'P';
  ----------------------------------------------------------------------------------------------------
  -- carryover policy
  ----------------------------------------------------------------------------------------------------
  c_Carryover_Policy_All  constant varchar2(1) := 'A';
  c_Carryover_Policy_Zero constant varchar2(1) := 'Z';
  c_Carryover_Policy_Cap  constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- pcode device type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Device_Type_Terminal  constant varchar2(20) := 'VHR:1';
  c_Pcode_Device_Type_Timepad   constant varchar2(20) := 'VHR:2';
  c_Pcode_Device_Type_Staff     constant varchar2(20) := 'VHR:3';
  c_Pcode_Device_Type_Hikvision constant varchar2(20) := 'VHR:4';
  c_Pcode_Device_Type_Dahua     constant varchar2(20) := 'VHR:5';
  ----------------------------------------------------------------------------------------------------
  -- request type
  ----------------------------------------------------------------------------------------------------
  c_Request_Type_Part_Of_Day   constant varchar2(1) := 'P';
  c_Request_Type_Full_Day      constant varchar2(1) := 'F';
  c_Request_Type_Multiple_Days constant varchar2(1) := 'M';
  ----------------------------------------------------------------------------------------------------
  -- request status
  ----------------------------------------------------------------------------------------------------
  c_Request_Status_New       constant varchar2(1) := 'N';
  c_Request_Status_Approved  constant varchar2(1) := 'A';
  c_Request_Status_Completed constant varchar2(1) := 'C';
  c_Request_Status_Denied    constant varchar2(1) := 'D';
  ----------------------------------------------------------------------------------------------------
  -- change status
  ----------------------------------------------------------------------------------------------------
  c_Change_Status_New       constant varchar2(1) := 'N';
  c_Change_Status_Approved  constant varchar2(1) := 'A';
  c_Change_Status_Completed constant varchar2(1) := 'C';
  c_Change_Status_Denied    constant varchar2(1) := 'D';
  ----------------------------------------------------------------------------------------------------
  -- change kind
  ----------------------------------------------------------------------------------------------------
  c_Change_Kind_Swap        constant varchar2(1) := 'S';
  c_Change_Kind_Change_Plan constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  c_Dashboard_Worktime_Not_Started constant varchar2(2) := 'WN';
  c_Dashboard_Leave_Exists         constant varchar2(2) := 'LV';
  c_Dashboard_Staff_Late           constant varchar2(2) := 'L';
  c_Dashboard_Staff_Intime         constant varchar2(2) := 'I';
  c_Dashboard_Staff_Not_Come       constant varchar2(2) := 'NC';
  c_Dashboard_Rest_Day             constant varchar2(2) := 'R';
  c_Dashboard_Additional_Rest_Day  constant varchar2(2) := 'A';
  c_Dashboard_Holiday              constant varchar2(2) := 'H';
  c_Dashboard_Nonworking_Day       constant varchar2(2) := 'NW';
  c_Dashboard_Not_Licensed_Day     constant varchar2(2) := 'NL';
  c_Dashboard_No_Timesheet         constant varchar2(2) := 'N';
  ----------------------------------------------------------------------------------------------------
  c_Pin_Autogenerate            constant varchar2(50) := 'VHR:PIN_AUTOGENERATE';
  c_Photo_As_Face_Rec           constant varchar2(50) := 'VHR:PHOTO_AS_FACE_REC'; -- person main photo save as face recognation photo default value
  c_Location_Sync_Person_Global constant varchar2(50) := 'VHR:LOCATION_SYNC_PERSON_GLOBAL';
  c_Schedule_Trimmed_Tracks     constant varchar2(50) := 'VHR:SCHEDULE_TRIMMED_TRACKS';
  ----------------------------------------------------------------------------------------------------
  -- terminal model pcode
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Zkteco_F18     constant varchar2(20) := 'VHR:1';
  c_Pcode_Zkteco_Eface10 constant varchar2(20) := 'VHR:2';
  ----------------------------------------------------------------------------------------------------
  -- registry kinds
  ----------------------------------------------------------------------------------------------------
  c_Registry_Kind_Staff constant varchar2(1) := 'S';
  c_Registry_Kind_Robot constant varchar2(1) := 'R';
  ---------------------------------------------------------------------------------------------------- 
  -- individual schedules pcodes
  ---------------------------------------------------------------------------------------------------- 
  c_Pcode_Individual_Staff_Schedule constant varchar2(10) := 'VHR:1';
  c_Pcode_Individual_Robot_Schedule constant varchar2(10) := 'VHR:2';
  ----------------------------------------------------------------------------------------------------
  -- request kind accrual kinds
  ----------------------------------------------------------------------------------------------------
  c_Accrual_Kind_Carryover constant varchar2(1) := 'C';
  c_Accrual_Kind_Plan      constant varchar2(1) := 'P';
  ----------------------------------------------------------------------------------------------------
  -- acms track status
  ----------------------------------------------------------------------------------------------------
  c_Acms_Track_Status_New       constant varchar2(1) := 'N';
  c_Acms_Track_Status_Completed constant varchar2(1) := 'C';
  c_Acms_Track_Status_Failed    constant varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------    
  -- acms mark types
  ----------------------------------------------------------------------------------------------------
  c_Acms_Mark_Type_Touch constant varchar2(1) := 'T';
  c_Acms_Mark_Type_Face  constant varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------
  -- shift limits (in seconds)
  ----------------------------------------------------------------------------------------------------
  c_Max_Shift_Border     constant number := 8 * 3600;
  c_Min_Shift_Border     constant number := 4 * 3600;
  c_Max_Full_Plan        constant number := 24 * 3600;
  c_Default_Merge_Border constant number := 15 * 60;
  c_Max_Track_Duration   constant number := 72 * 3600;
  ----------------------------------------------------------------------------------------------------
  -- hourly wage limits (in seconds)
  ----------------------------------------------------------------------------------------------------
  c_Max_Worktime_Length constant number := 24 * 3600;
  ---------------------------------------------------------------------------------------------------- 
  -- location defined type
  ----------------------------------------------------------------------------------------------------
  c_Location_Defined_By_Gps   constant varchar2(1) := 'G';
  c_Location_Defined_By_Bssid constant varchar2(1) := 'B';
  ----------------------------------------------------------------------------------------------------
  -- current work statuses
  ---------------------------------------------------------------------------------------------------- 
  c_Work_Status_Out      constant varchar2(1) := 'O';
  c_Work_Status_Returned constant varchar2(1) := 'R';
  c_Work_Status_In       constant varchar2(1) := 'I';
  ----------------------------------------------------------------------------------------------------
  -- schedulr list forms
  c_Schedule_List_Form                constant varchar2(100) := '/vhr/htt/schedule_list';
  c_Staff_Schedule_Registry_List_Form constant varchar2(100) := '/vhr/htt/schedule_registry_list+staff';
  c_Robot_Schedule_Registry_List_Form constant varchar2(100) := '/vhr/htt/schedule_registry_list+robot';
  ----------------------------------------------------------------------------------------------------
  -- additional time type
  c_Additional_Time_Type_Allowed constant varchar2(1) := 'A';
  c_Additional_Time_Type_Extra   constant varchar2(1) := 'E';
  ---------------------------------------------------------------------------------------------------- 
  -- device statuses
  c_Device_Status_Offline constant varchar2(1) := 'F';
  c_Device_Status_Online  constant varchar2(1) := 'O';
  c_Device_Status_Unknown constant varchar2(1) := 'U';

  ---------------------------------------------------------------------------------------------------- 
  -- default GPS Data Limits
  ---------------------------------------------------------------------------------------------------- 
  c_Pref_Default_Gps_Time_Limit     constant number := 300; -- 5 min
  c_Pref_Default_Gps_Distance_Limit constant number := 50;

end Htt_Pref;
/
create or replace package body Htt_Pref is
end Htt_Pref;
/
