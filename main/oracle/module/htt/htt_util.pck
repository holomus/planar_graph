create or replace package Htt_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person     in out nocopy Htt_Pref.Person_Rt,
    i_Company_Id number,
    i_Person_Id  number,
    i_Pin        varchar2,
    i_Pin_Code   number,
    i_Rfid_Code  varchar2,
    i_Qr_Code    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Add_Photo
  (
    p_Person    in out nocopy Htt_Pref.Person_Rt,
    i_Photo_Sha varchar2,
    i_Is_Main   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_Add_Day
  (
    o_Calendar      in out nocopy Htt_Pref.Calendar_Rt,
    i_Calendar_Date date,
    i_Name          varchar2,
    i_Day_Kind      varchar2,
    i_Swapped_Date  date
  );
  ------------------------------------------------------------------------------------------------
  Procedure Calendar_Add_Week_Day
  (
    o_Calendar        in out nocopy Htt_Pref.Calendar_Rt,
    i_Order_No        number,
    i_Plan_Time       number,
    i_Preholiday_Hour number,
    i_Preweekend_Hour number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_New
  (
    o_Calendar      in out nocopy Htt_Pref.Calendar_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Calendar_Id   number,
    i_Name          varchar2,
    i_Code          varchar2,
    i_Year          number,
    i_Monthly_Limit varchar2,
    i_Daily_Limit   varchar2,
    i_Rest_Day      Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Marks_Add
  (
    o_Marks      in out nocopy Htt_Pref.Mark_Nt,
    i_Begin_Time number,
    i_End_Time   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Weights_Add
  (
    o_Weights    in out nocopy Htt_Pref.Time_Weight_Nt,
    i_Begin_Time number,
    i_End_Time   number,
    i_Weight     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_New
  (
    o_Day              in out nocopy Htt_Pref.Schedule_Day_Rt,
    i_Schedule_Date    date,
    i_Day_Kind         varchar2,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time number,
    i_Break_End_Time   number,
    i_Plan_Time        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Add
  (
    o_Schedule in out nocopy Htt_Pref.Schedule_Rt,
    i_Day      Htt_Pref.Schedule_Day_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Marks_New
  (
    o_Schedule_Day_Marks in out nocopy Htt_Pref.Schedule_Day_Marks_Rt,
    i_Schedule_Date      date,
    i_Begin_Date         number,
    i_End_Date           number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Marks_Add
  (
    o_Schedule  in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Marks Htt_Pref.Schedule_Day_Marks_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Weights_New
  (
    o_Schedule_Day_Weights in out nocopy Htt_Pref.Schedule_Day_Weights_Rt,
    i_Schedule_Date        date,
    i_Begin_Date           number,
    i_End_Date             number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Weights_Add
  (
    o_Schedule    in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Weights Htt_Pref.Schedule_Day_Weights_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_Day_New
  (
    o_Pattern_Day      in out nocopy Htt_Pref.Schedule_Pattern_Day_Rt,
    i_Day_No           number,
    i_Day_Kind         varchar2,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time number,
    i_Break_End_Time   number,
    i_Plan_Time        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_Day_Add
  (
    o_Schedule_Pattern in out nocopy Htt_Pref.Schedule_Pattern_Rt,
    i_Day              Htt_Pref.Schedule_Pattern_Day_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_New
  (
    o_Pattern        in out nocopy Htt_Pref.Schedule_Pattern_Rt,
    i_Pattern_Kind   varchar2,
    i_All_Days_Equal varchar2,
    i_Count_Days     number,
    i_Begin_Date     date,
    i_End_Date       date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Registry_Unit_New
  (
    o_Registry_Unit   in out nocopy Htt_Pref.Registry_Unit_Rt,
    i_Unit_Id         number,
    i_Staff_Id        number,
    i_Robot_Id        number,
    i_Monthly_Minutes number,
    i_Monthly_Days    number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_New
  (
    o_Schedule_Registry         in out nocopy Htt_Pref.Schedule_Registry_Rt,
    i_Company_Id                number,
    i_Filial_Id                 number,
    i_Registry_Id               number,
    i_Registry_Date             date,
    i_Registry_Number           varchar2,
    i_Registry_Kind             varchar2,
    i_Schedule_Kind             varchar2,
    i_Month                     date,
    i_Division_Id               number,
    i_Note                      varchar2,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Count_Free                varchar2,
    i_Allowed_Late_Time         number,
    i_Allowed_Early_Time        number,
    i_Begin_Late_Time           number,
    i_End_Early_Time            number,
    i_Calendar_Id               number,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Gps_Turnout_Enabled       varchar2,
    i_Gps_Use_Location          varchar2,
    i_Gps_Max_Interval          number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Check_Schedule_By_Calendar
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Calendar_Id number,
    i_Year_Begin  date,
    i_Registry_Id number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_New
  (
    o_Schedule                  in out nocopy Htt_Pref.Schedule_Rt,
    i_Company_Id                number,
    i_Filial_Id                 number,
    i_Schedule_Id               number,
    i_Name                      varchar2,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Count_Free                varchar2,
    i_Use_Weights               varchar2,
    i_Allowed_Late_Time         number,
    i_Allowed_Early_Time        number,
    i_Begin_Late_Time           number,
    i_End_Early_Time            number,
    i_Calendar_Id               number,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Gps_Turnout_Enabled       varchar2,
    i_Gps_Use_Location          varchar2,
    i_Gps_Max_Interval          number,
    i_State                     varchar2,
    i_Code                      varchar2,
    i_Year                      number,
    i_Schedule_Kind             varchar2 := Htt_Pref.c_Schedule_Kind_Flexible
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Pattern_Add
  (
    o_Schedule_Template in out nocopy Htt_Pref.Schedule_Template_Rt,
    i_Pattern_Day       Htt_Pref.Schedule_Pattern_Day_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_New
  (
    o_Schedule_Template         in out nocopy Htt_Pref.Schedule_Template_Rt,
    i_Template_Id               number,
    i_Name                      varchar2,
    i_Description               varchar2,
    i_Schedule_Kind             varchar2,
    i_All_Days_Equal            varchar2,
    i_Count_Days                number,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Order_No                  number,
    i_State                     varchar2,
    i_Code                      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Calendar_Monthly_Limit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Year_Begin  date
  ) return Array_Number;
  ---------------------------------------------------------------------------------------------------- 
  Function Schedule_Day_Kind
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number := null,
    i_Robot_Id      number := null,
    i_Schedule_Id   number,
    i_Schedule_Date date
  ) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Check_Day_Kind
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number := null,
    i_Robot_Id    number := null,
    i_Schedule_Id number := null,
    i_Date        date,
    i_Day_Kind    varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Plan_Time
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number := null,
    i_Robot_Id        number := null,
    i_Schedule_Id     number := null,
    i_Date            date,
    i_Plan_Time       number,
    i_Preholiday_Time number,
    i_Preweekend_Time number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Add
  (
    o_Timesheets   in out nocopy Htt_Pref.Timesheet_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Input_Time   date,
    i_Output_Time  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Fact_Add
  (
    o_Facts        in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Time_Kind_Id number,
    i_Fact_Value   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_New
  (
    o_Change      in out nocopy Htt_Pref.Change_Rt,
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Change_Id   number,
    i_Staff_Id    number,
    i_Change_Kind varchar2,
    i_Note        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Add
  (
    o_Change           in out nocopy Htt_Pref.Change_Rt,
    i_Change_Date      date,
    i_Swapped_Date     date := null,
    i_Day_Kind         varchar2,
    i_Begin_Time       date,
    i_End_Time         date,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time date,
    i_Break_End_Time   date,
    i_Plan_Time        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weight_New
  (
    o_Change_Day_Weights in out nocopy Htt_Pref.Change_Day_Weights,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Change_Id          number,
    i_Change_Date        date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weight_Add
  (
    o_Change_Day_Weights in out nocopy Htt_Pref.Change_Day_Weights,
    i_Begin_Time         number,
    i_End_Time           number,
    i_Weight             number
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone
  (
    i_Company_Id  number,
    i_Location_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Timestamp_To_Date
  (
    i_Timestamp timestamp with time zone,
    i_Timezone  varchar2 := null
  ) return date;
  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Date
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return date;
  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Serial_Number
  (
    i_Company_Id     number,
    i_Device_Type_Id number,
    i_Serial_Number  varchar2
  ) return Htt_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Parent_Time_Kinds(i_Company_Id number) return Htt_Pref.Time_Kind_Nt;
  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_Parent_Or_Self_Id
  (
    i_Company_Id   number,
    i_Time_Kind_Id varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_With_Child_Ids
  (
    i_Company_Id number,
    i_Pcodes     Array_Varchar2
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Id
  (
    i_Company_Id number,
    i_Pin        varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Trim_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Pin_Autogenerate(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Photo_As_Face_Rec(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Pin
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Filial_Ids
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Person_Id   number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Location_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Location_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id_By_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id(i_Pcode varchar2) return number;
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Pcode(i_Device_Type_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Qr_Code_Gen(i_Person_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Manager_Device_Sn(i_Serial_Number varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Convert_Timestamp
  (
    i_Date     date,
    i_Timezone varchar2
  ) return timestamp
    with time zone;
  ----------------------------------------------------------------------------------------------------
  Function Iso_Week_Day_No(i_Date date) return number;
  ----------------------------------------------------------------------------------------------------
  Function Default_Calendar_Id
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calendar_Rest_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number := null
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Is_Calendar_Day
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Calendar_Id  number,
    i_Date         date,
    o_Calendar_Day out nocopy Htt_Calendar_Days%rowtype
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Official_Rest_Day
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Date        date
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Official_Rest_Days_Count
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Exist_Track
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Person_Id      number,
    i_Track_Type     varchar2,
    i_Track_Datetime date,
    i_Device_Id      number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Exist_Timesheet
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date,
    o_Timesheet      out Htt_Timesheets%rowtype
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Timesheet
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  ) return Htt_Timesheets%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Is_Prohibited
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Latlng     varchar2
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Track_Accepted_Period
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Period      date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Track_Not_Accepted_Periods
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return Href_Pref.Period_Nt;
  ----------------------------------------------------------------------------------------------------
  Function To_Minutes(i_Date date) return number;
  ----------------------------------------------------------------------------------------------------
  Function To_Time(i_Minutes number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function To_Time_Seconds_Text
  (
    i_Seconds      number,
    i_Show_Minutes boolean := false,
    i_Show_Words   boolean := true,
    i_Show_Seconds boolean := false
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function To_Time_Text
  (
    i_Minutes      number,
    i_Show_Minutes boolean := false,
    i_Show_Words   boolean := true
  ) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Load_Request_Kind_Accrual
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Accrual_Kind    varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  ) return Htt_Request_Kind_Accruals%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Count_Request_Days
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Day_Count_Type     varchar2,
    i_Request_Begin_Time date,
    i_Request_End_Time   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Request_Kind_Used_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Accrual_Kind    varchar2,
    i_Period          date,
    i_Request_Id      number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Marks
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Weights
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Change_Day_Weights
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Change_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Timesheet_Locks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Dates      Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Template_Marks
  (
    i_Template_Id number,
    i_Day_Numbers Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Request_Has_Available_Days
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Request_Id         number,
    i_Request_Kind_Id    number,
    i_Request_Begin_Time date,
    i_Request_End_Time   date,
    i_Accrual_Kind       varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Intersection_Request
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Staff_Id     number,
    i_Begin_Time   date,
    i_End_Time     date,
    i_Request_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Approved_Plan_Change
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Change_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Function Calc_Full_Time
  (
    i_Day_Kind         varchar2,
    i_Begin_Time       date,
    i_End_Time         date,
    i_Break_Begin_Time date,
    i_Break_End_Time   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Time_Diff
  (
    i_Time1 date,
    i_Time2 date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Timeline_Intersection
  (
    i_Fr_Begin date,
    i_Fr_End   date,
    i_Sc_Begin date,
    i_Sc_End   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Intime
  (
    i_Begin_Time       date,
    i_End_Time         date,
    i_Begin_Break_Time date,
    i_End_Break_Time   date,
    i_Input            date,
    i_Output           date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Track_Date date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Change(i_Change_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Request(i_Request_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Track(i_Track_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Request_Kind_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Request_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Nls_Language return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Request_Time
  (
    i_Request_Type varchar2,
    i_Begin_Time   date,
    i_End_Time     date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Requests_Time_Sum
  (
    i_Company_Id            number,
    i_Filial_Id             number,
    i_Timesheet_Id          number,
    i_Take_Turnout_Requests boolean := false
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Fact_Value
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date,
    i_Time_Kind_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Fact_Value
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Timesheet_Id  number,
    i_Time_Kind_Id  number,
    i_Take_Children boolean := false
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Full_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number
  ) return Htt_Pref.Timesheet_Aggregated_Fact_Nt;
  ----------------------------------------------------------------------------------------------------
  Function Get_Full_Facts
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Htt_Pref.Timesheet_Aggregated_Fact_Nt;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Turnout_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Locked_Turnout_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Locked_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Seconds
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Minutes
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Time_Kind_Facts
  (
    o_Fact_Seconds out number,
    o_Fact_Days    out number,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Time_Kind_Id number,
    i_Begin_Date   date,
    i_End_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Function Calc_Weighted_Turnout_Seconds
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Has_Undefined_Schedule
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Year_Last_Day(i_Date date) return date;
  ---------------------------------------------------------------------------------------------------- 
  Function Quarter_Last_Day(i_Date date) return date;
  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Datas
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Only_Gps   varchar2 := 'Y'
  ) return Htt_Pref.Gps_Track_Data_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Schedule_Day
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Unit_Id    number,
    i_Date       date
  ) return Htt_Staff_Schedule_Days%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Schedule_Day
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Unit_Id    number,
    i_Date       date
  ) return Htt_Robot_Schedule_Days%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Distance
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Gps_Track_Distance
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Track_Date date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Location_Sync_Global_Load
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Change_Monthly_Count
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Month      date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Change_Monthly_Count
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number,
    i_Month      date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind(i_Day_Kind varchar2) return varchar2;
  Function Day_Kinds return Matrix_Varchar2;
  Function Calendar_Day_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Pattern_Kind(i_Pattern_Kind varchar2) return varchar2;
  Function Pattern_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Schedule_Kind(i_Schedule_Kind varchar2) return varchar2;
  Function Schedule_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Protocol(i_Protocol varchar2) return varchar2;
  Function Protocols return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind(i_Command_Kind varchar2) return varchar2;
  Function Command_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status(i_Command_Status varchar2) return varchar2;
  Function Command_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Role(i_Person_Role varchar2) return varchar2;
  Function Person_Roles return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type(i_Track_Type varchar2) return varchar2;
  Function Track_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Provider(i_Provider varchar2) return varchar2;
  Function Providers return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type(i_Mark_Type varchar2) return varchar2;
  Function Mark_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status(i_Status varchar2) return varchar2;
  Function Track_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Load(i_Plan_Load varchar2) return varchar2;
  Function Plan_Loads return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Day_Count_Type(i_Day_Count_Type varchar2) return varchar2;
  Function Day_Count_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Carryover_Policy(i_Carryover_Policy varchar2) return varchar2;
  Function Carryover_Policies return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Type(i_Request_Type varchar2) return varchar2;
  Function Request_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status(i_Request_Status varchar2) return varchar2;
  Function Request_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Notification_Title
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Notify_Type     varchar2,
    t_Request_Kind_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Attach_Type(i_Attach_Type varchar2) return varchar2;
  Function Attach_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status(i_Change_Status varchar2) return varchar2;
  Function Change_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Change_Kind(i_Change_Kind varchar2) return varchar2;
  Function Change_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Change_Notification_Title
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Notify_Type varchar2,
    i_Change_Kind varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Status_Kinds(i_Dashboard_Status_Kinds varchar2) return varchar2;
  Function Dashboard_Status_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Accrual_Kinds(i_Accrual_Kind varchar2) return varchar2;
  Function Accrual_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Track_Status(i_Track_Status varchar2) return varchar2;
  Function Acms_Track_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Mark_Type(i_Mark_Type varchar2) return varchar2;
  Function Acms_Mark_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Location_Defined_Type(i_Location_Defined_Type varchar2) return varchar2;
  Function Location_Defined_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Work_Status(i_Work_Status varchar2) return varchar2;
  Function Work_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Device_Statuses return Matrix_Varchar2;
end Htt_Util;
/
create or replace package body Htt_Util is
  ----------------------------------------------------------------------------------------------------
  g_Cache_Company_Timezones  Fazo.Varchar2_Code_Aat;
  g_Cache_Filial_Timezones   Fazo.Varchar2_Code_Aat;
  g_Cache_Location_Timezones Fazo.Varchar2_Code_Aat;
  g_Cache_Time_Kind_Ids      Fazo.Number_Code_Aat;

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
    return b.Translate('HTT:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person     in out nocopy Htt_Pref.Person_Rt,
    i_Company_Id number,
    i_Person_Id  number,
    i_Pin        varchar2,
    i_Pin_Code   number,
    i_Rfid_Code  varchar2,
    i_Qr_Code    varchar2
  ) is
  begin
    o_Person.Company_Id := i_Company_Id;
    o_Person.Person_Id  := i_Person_Id;
    o_Person.Pin        := i_Pin;
    o_Person.Pin_Code   := i_Pin_Code;
    o_Person.Rfid_Code  := i_Rfid_Code;
    o_Person.Qr_Code    := i_Qr_Code;
  
    o_Person.Photos := Htt_Pref.Photo_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Add_Photo
  (
    p_Person    in out nocopy Htt_Pref.Person_Rt,
    i_Photo_Sha varchar2,
    i_Is_Main   varchar2
  ) is
    v_Photo Htt_Pref.Photo_Rt;
  begin
    v_Photo.Photo_Sha := i_Photo_Sha;
    v_Photo.Is_Main   := i_Is_Main;
  
    p_Person.Photos.Extend;
    p_Person.Photos(p_Person.Photos.Count) := v_Photo;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_Add_Day
  (
    o_Calendar      in out nocopy Htt_Pref.Calendar_Rt,
    i_Calendar_Date date,
    i_Name          varchar2,
    i_Day_Kind      varchar2,
    i_Swapped_Date  date
  ) is
    v_Day Htt_Pref.Calendar_Day_Rt;
  begin
    v_Day.Calendar_Date := i_Calendar_Date;
    v_Day.Name          := i_Name;
    v_Day.Day_Kind      := i_Day_Kind;
    v_Day.Swapped_Date  := i_Swapped_Date;
  
    o_Calendar.Days.Extend();
    o_Calendar.Days(o_Calendar.Days.Count) := v_Day;
  end;

  ------------------------------------------------------------------------------------------------
  Procedure Calendar_Add_Week_Day
  (
    o_Calendar        in out nocopy Htt_Pref.Calendar_Rt,
    i_Order_No        number,
    i_Plan_Time       number,
    i_Preholiday_Hour number,
    i_Preweekend_Hour number
  ) is
    v_Week_Day Htt_Pref.Calendar_Week_Days_Rt;
  begin
    v_Week_Day.Order_No        := i_Order_No;
    v_Week_Day.Plan_Time       := i_Plan_Time;
    v_Week_Day.Preholiday_Hour := i_Preholiday_Hour;
    v_Week_Day.Preweekend_Hour := i_Preweekend_Hour;
  
    o_Calendar.Week_Days.Extend();
    o_Calendar.Week_Days(o_Calendar.Week_Days.Count) := v_Week_Day;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_New
  (
    o_Calendar      in out nocopy Htt_Pref.Calendar_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Calendar_Id   number,
    i_Name          varchar2,
    i_Code          varchar2,
    i_Year          number,
    i_Monthly_Limit varchar2,
    i_Daily_Limit   varchar2,
    i_Rest_Day      Array_Number
  ) is
  begin
    o_Calendar.Company_Id    := i_Company_Id;
    o_Calendar.Filial_Id     := i_Filial_Id;
    o_Calendar.Calendar_Id   := i_Calendar_Id;
    o_Calendar.Name          := i_Name;
    o_Calendar.Code          := i_Code;
    o_Calendar.Year          := i_Year;
    o_Calendar.Monthly_Limit := i_Monthly_Limit;
    o_Calendar.Daily_Limit   := i_Daily_Limit;
    o_Calendar.Rest_Days     := i_Rest_Day;
  
    o_Calendar.Days      := Htt_Pref.Calendar_Day_Nt();
    o_Calendar.Week_Days := Htt_Pref.Calender_Week_Days_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Marks_Add
  (
    o_Marks      in out nocopy Htt_Pref.Mark_Nt,
    i_Begin_Time number,
    i_End_Time   number
  ) is
    v_Mark Htt_Pref.Mark_Rt;
  begin
    o_Marks.Extend();
  
    v_Mark.Begin_Time := i_Begin_Time;
    v_Mark.End_Time   := i_End_Time;
  
    o_Marks(o_Marks.Count) := v_Mark;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Weights_Add
  (
    o_Weights    in out nocopy Htt_Pref.Time_Weight_Nt,
    i_Begin_Time number,
    i_End_Time   number,
    i_Weight     number
  ) is
    v_Weight Htt_Pref.Time_Weight_Rt;
  begin
    o_Weights.Extend();
  
    v_Weight.Begin_Time := i_Begin_Time;
    v_Weight.End_Time   := i_End_Time;
    v_Weight.Weight     := i_Weight;
  
    o_Weights(o_Weights.Count) := v_Weight;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_New
  (
    o_Day              in out nocopy Htt_Pref.Schedule_Day_Rt,
    i_Schedule_Date    date,
    i_Day_Kind         varchar2,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time number,
    i_Break_End_Time   number,
    i_Plan_Time        number
  ) is
  begin
    o_Day.Schedule_Date    := i_Schedule_Date;
    o_Day.Day_Kind         := i_Day_Kind;
    o_Day.Begin_Time       := i_Begin_Time;
    o_Day.End_Time         := i_End_Time;
    o_Day.Break_Enabled    := i_Break_Enabled;
    o_Day.Break_Begin_Time := i_Break_Begin_Time;
    o_Day.Break_End_Time   := i_Break_End_Time;
    o_Day.Plan_Time        := i_Plan_Time;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Add
  (
    o_Schedule in out nocopy Htt_Pref.Schedule_Rt,
    i_Day      Htt_Pref.Schedule_Day_Rt
  ) is
  begin
    o_Schedule.Days.Extend();
    o_Schedule.Days(o_Schedule.Days.Count) := i_Day;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Marks_New
  (
    o_Schedule_Day_Marks in out nocopy Htt_Pref.Schedule_Day_Marks_Rt,
    i_Schedule_Date      date,
    i_Begin_Date         number,
    i_End_Date           number
  ) is
  begin
    o_Schedule_Day_Marks.Schedule_Date := i_Schedule_Date;
    o_Schedule_Day_Marks.Begin_Time    := i_Begin_Date;
    o_Schedule_Day_Marks.End_Time      := i_End_Date;
  
    o_Schedule_Day_Marks.Marks := Htt_Pref.Mark_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Marks_Add
  (
    o_Schedule  in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Marks Htt_Pref.Schedule_Day_Marks_Rt
  ) is
  begin
    o_Schedule.Marks.Extend();
    o_Schedule.Marks(o_Schedule.Marks.Count) := i_Day_Marks;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Weights_New
  (
    o_Schedule_Day_Weights in out nocopy Htt_Pref.Schedule_Day_Weights_Rt,
    i_Schedule_Date        date,
    i_Begin_Date           number,
    i_End_Date             number
  ) is
  begin
    o_Schedule_Day_Weights.Schedule_Date := i_Schedule_Date;
    o_Schedule_Day_Weights.Begin_Time    := i_Begin_Date;
    o_Schedule_Day_Weights.End_Time      := i_End_Date;
  
    o_Schedule_Day_Weights.Weights := Htt_Pref.Time_Weight_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Day_Weights_Add
  (
    o_Schedule    in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Weights Htt_Pref.Schedule_Day_Weights_Rt
  ) is
  begin
    o_Schedule.Weights.Extend();
    o_Schedule.Weights(o_Schedule.Weights.Count) := i_Day_Weights;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_Day_New
  (
    o_Pattern_Day      in out nocopy Htt_Pref.Schedule_Pattern_Day_Rt,
    i_Day_No           number,
    i_Day_Kind         varchar2,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time number,
    i_Break_End_Time   number,
    i_Plan_Time        number
  ) is
  begin
    o_Pattern_Day.Day_No           := i_Day_No;
    o_Pattern_Day.Day_Kind         := i_Day_Kind;
    o_Pattern_Day.Begin_Time       := i_Begin_Time;
    o_Pattern_Day.End_Time         := i_End_Time;
    o_Pattern_Day.Break_Enabled    := i_Break_Enabled;
    o_Pattern_Day.Break_Begin_Time := i_Break_Begin_Time;
    o_Pattern_Day.Break_End_Time   := i_Break_End_Time;
    o_Pattern_Day.Plan_Time        := i_Plan_Time;
  
    o_Pattern_Day.Pattern_Marks   := Htt_Pref.Mark_Nt();
    o_Pattern_Day.Pattern_Weights := Htt_Pref.Time_Weight_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_Day_Add
  (
    o_Schedule_Pattern in out nocopy Htt_Pref.Schedule_Pattern_Rt,
    i_Day              Htt_Pref.Schedule_Pattern_Day_Rt
  ) is
  begin
    o_Schedule_Pattern.Pattern_Day.Extend();
    o_Schedule_Pattern.Pattern_Day(o_Schedule_Pattern.Pattern_Day.Count) := i_Day;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Pattern_New
  (
    o_Pattern        in out nocopy Htt_Pref.Schedule_Pattern_Rt,
    i_Pattern_Kind   varchar2,
    i_All_Days_Equal varchar2,
    i_Count_Days     number,
    i_Begin_Date     date,
    i_End_Date       date
  ) is
  begin
    o_Pattern.Pattern_Kind   := i_Pattern_Kind;
    o_Pattern.All_Days_Equal := i_All_Days_Equal;
    o_Pattern.Count_Days     := i_Count_Days;
    o_Pattern.Begin_Date     := i_Begin_Date;
    o_Pattern.End_Date       := i_End_Date;
  
    o_Pattern.Pattern_Day := Htt_Pref.Schedule_Pattern_Day_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Registry_Unit_New
  (
    o_Registry_Unit   in out nocopy Htt_Pref.Registry_Unit_Rt,
    i_Unit_Id         number,
    i_Staff_Id        number,
    i_Robot_Id        number,
    i_Monthly_Minutes number,
    i_Monthly_Days    number
  ) is
  begin
    o_Registry_Unit.Unit_Id         := i_Unit_Id;
    o_Registry_Unit.Staff_Id        := i_Staff_Id;
    o_Registry_Unit.Robot_Id        := i_Robot_Id;
    o_Registry_Unit.Monthly_Minutes := i_Monthly_Minutes;
    o_Registry_Unit.Monthly_Days    := i_Monthly_Days;
  
    o_Registry_Unit.Unit_Days    := Htt_Pref.Schedule_Day_Nt();
    o_Registry_Unit.Unit_Marks   := Htt_Pref.Schedule_Day_Marks_Nt();
    o_Registry_Unit.Unit_Weights := Htt_Pref.Schedule_Day_Weights_Nt();
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_New
  (
    o_Schedule_Registry         in out nocopy Htt_Pref.Schedule_Registry_Rt,
    i_Company_Id                number,
    i_Filial_Id                 number,
    i_Registry_Id               number,
    i_Registry_Date             date,
    i_Registry_Number           varchar2,
    i_Registry_Kind             varchar2,
    i_Schedule_Kind             varchar2,
    i_Month                     date,
    i_Division_Id               number,
    i_Note                      varchar2,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Count_Free                varchar2,
    i_Allowed_Late_Time         number,
    i_Allowed_Early_Time        number,
    i_Begin_Late_Time           number,
    i_End_Early_Time            number,
    i_Calendar_Id               number,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Gps_Turnout_Enabled       varchar2,
    i_Gps_Use_Location          varchar2,
    i_Gps_Max_Interval          number
  ) is
  begin
    o_Schedule_Registry.Company_Id                := i_Company_Id;
    o_Schedule_Registry.Filial_Id                 := i_Filial_Id;
    o_Schedule_Registry.Registry_Id               := i_Registry_Id;
    o_Schedule_Registry.Registry_Date             := i_Registry_Date;
    o_Schedule_Registry.Registry_Number           := i_Registry_Number;
    o_Schedule_Registry.Registry_Kind             := i_Registry_Kind;
    o_Schedule_Registry.Schedule_Kind             := i_Schedule_Kind;
    o_Schedule_Registry.Month                     := i_Month;
    o_Schedule_Registry.Division_Id               := i_Division_Id;
    o_Schedule_Registry.Note                      := i_Note;
    o_Schedule_Registry.Shift                     := Nvl(i_Shift, 0);
    o_Schedule_Registry.Input_Acceptance          := Nvl(i_Input_Acceptance, 0);
    o_Schedule_Registry.Output_Acceptance         := Nvl(i_Output_Acceptance, 0);
    o_Schedule_Registry.Track_Duration            := Nvl(i_Track_Duration, 1440);
    o_Schedule_Registry.Count_Late                := i_Count_Late;
    o_Schedule_Registry.Count_Early               := i_Count_Early;
    o_Schedule_Registry.Count_Lack                := i_Count_Lack;
    o_Schedule_Registry.Count_Free                := i_Count_Free;
    o_Schedule_Registry.Advanced_Setting          := 'N';
    o_Schedule_Registry.Allowed_Late_Time         := i_Allowed_Late_Time;
    o_Schedule_Registry.Allowed_Early_Time        := i_Allowed_Early_Time;
    o_Schedule_Registry.Begin_Late_Time           := i_Begin_Late_Time;
    o_Schedule_Registry.End_Early_Time            := i_End_Early_Time;
    o_Schedule_Registry.Calendar_Id               := i_Calendar_Id;
    o_Schedule_Registry.Take_Holidays             := i_Take_Holidays;
    o_Schedule_Registry.Take_Nonworking           := i_Take_Nonworking;
    o_Schedule_Registry.Take_Additional_Rest_Days := i_Take_Additional_Rest_Days;
    o_Schedule_Registry.Gps_Turnout_Enabled       := i_Gps_Turnout_Enabled;
    o_Schedule_Registry.Gps_Use_Location          := i_Gps_Use_Location;
    o_Schedule_Registry.Gps_Max_Interval          := i_Gps_Max_Interval;
  
    if i_Allowed_Late_Time <> 0 or i_Allowed_Early_Time <> 0 or --
       i_Begin_Late_Time <> 0 or i_End_Early_Time <> 0 then
      o_Schedule_Registry.Advanced_Setting := 'Y';
    end if;
  
    o_Schedule_Registry.Units := Htt_Pref.Registry_Unit_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Staff_Schedule_By_Calendar
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Year_Begin  date,
    i_Registry_Id number
  ) is
    v_Monthly_Limits     Array_Number;
    r_Calendar           Htt_Calendars%rowtype;
    v_Nls_Language       varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Dk_Holiday         varchar2(1) := Htt_Pref.c_Day_Kind_Holiday;
    v_Dk_Additional_Rest varchar2(1) := Htt_Pref.c_Day_Kind_Additional_Rest;
    v_Dk_Rest            varchar2(1) := Htt_Pref.c_Day_Kind_Rest;
  begin
    r_Calendar := z_Htt_Calendars.Take(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Calendar_Id => i_Calendar_Id);
  
    if r_Calendar.Monthly_Limit = 'Y' then
      v_Monthly_Limits := Calendar_Monthly_Limit(i_Company_Id  => i_Company_Id,
                                                 i_Filial_Id   => i_Filial_Id,
                                                 i_Calendar_Id => i_Calendar_Id,
                                                 i_Year_Begin  => i_Year_Begin);
      for r in (select Sd.Staff_Id,
                       Trunc(max(Sd.Schedule_Date), 'mon') month,
                       to_char(max(Sd.Schedule_Date), 'mm') Month_No,
                       count(*) Working_Day_Count
                  from Htt_Staff_Schedule_Days Sd
                 where Sd.Company_Id = i_Company_Id
                   and Sd.Filial_Id = i_Filial_Id
                   and Sd.Registry_Id = i_Registry_Id
                   and Sd.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
                 group by Sd.Staff_Id)
      loop
        if r.Working_Day_Count <> v_Monthly_Limits(to_number(r.Month_No)) then
          Htt_Error.Raise_123(i_Month      => to_char(r.Month, 'Month', v_Nls_Language),
                              i_Plan_Days  => r.Working_Day_Count,
                              i_Limit_Days => v_Monthly_Limits(to_number(r.Month_No)),
                              i_Staff_Name => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                   i_Filial_Id  => i_Filial_Id,
                                                                   i_Staff_Id   => r.Staff_Id));
        end if;
      end loop;
    end if;
  
    if r_Calendar.Daily_Limit = 'Y' then
      for r in (select *
                  from (select Sd.Staff_Id,
                               Sd.Schedule_Date,
                               Sd.Plan_Time,
                               (case
                                  when Td.Day_Kind = v_Dk_Holiday and Otd.Day_Kind = v_Dk_Rest then
                                   Greatest(0, w.Plan_Time - w.Preholiday_Time - w.Preweekend_Time)
                                  when Td.Day_Kind = v_Dk_Holiday then
                                   Greatest(0, w.Plan_Time - w.Preholiday_Time)
                                  when Td.Day_Kind in (v_Dk_Additional_Rest, v_Dk_Rest) then
                                   Greatest(0, w.Plan_Time - w.Preweekend_Time)
                                  else
                                   w.Plan_Time
                                end) Limit_Time
                          from Htt_Staff_Schedule_Days Sd
                          join Htt_Calendar_Week_Days w
                            on w.Company_Id = Sd.Company_Id
                           and w.Filial_Id = Sd.Filial_Id
                           and w.Calendar_Id = r_Calendar.Calendar_Id
                           and w.Order_No = Iso_Week_Day_No(Sd.Schedule_Date)
                          left join Htt_Staff_Schedule_Days Td -- schedule tomorrow day
                            on Td.Company_Id = Sd.Company_Id
                           and Td.Filial_Id = Sd.Filial_Id
                           and Td.Registry_Id = Sd.Registry_Id
                           and Td.Unit_Id = Sd.Unit_Id
                           and Td.Schedule_Date = Sd.Schedule_Date + 1
                          left join Htt_Unit_Schedule_Days Otd -- origin schedule tommorrow day
                            on Otd.Company_Id = Sd.Company_Id
                           and Otd.Filial_Id = Sd.Filial_Id
                           and Otd.Unit_Id = Sd.Unit_Id
                           and Otd.Schedule_Date = Sd.Schedule_Date + 1
                         where Sd.Company_Id = i_Company_Id
                           and Sd.Filial_Id = i_Filial_Id
                           and Sd.Registry_Id = i_Registry_Id) t
                 where t.Plan_Time > t.Limit_Time)
      loop
        Htt_Error.Raise_122(i_Schedule_Date => r.Schedule_Date,
                            i_Plan_Time     => r.Plan_Time,
                            i_Limit_Time    => r.Limit_Time,
                            i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => r.Staff_Id));
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Robot_Schedule_By_Calendar
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Year_Begin  date,
    i_Registry_Id number
  ) is
    v_Monthly_Limits     Array_Number;
    r_Calendar           Htt_Calendars%rowtype;
    v_Nls_Language       varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Dk_Holiday         varchar2(1) := Htt_Pref.c_Day_Kind_Holiday;
    v_Dk_Additional_Rest varchar2(1) := Htt_Pref.c_Day_Kind_Additional_Rest;
    v_Dk_Rest            varchar2(1) := Htt_Pref.c_Day_Kind_Rest;
  begin
    r_Calendar := z_Htt_Calendars.Take(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Calendar_Id => i_Calendar_Id);
  
    if r_Calendar.Monthly_Limit = 'Y' then
      v_Monthly_Limits := Calendar_Monthly_Limit(i_Company_Id  => i_Company_Id,
                                                 i_Filial_Id   => i_Filial_Id,
                                                 i_Calendar_Id => i_Calendar_Id,
                                                 i_Year_Begin  => i_Year_Begin);
      for r in (select (select Rob.Name
                          from Mrf_Robots Rob
                         where Rob.Company_Id = i_Company_Id
                           and Rob.Filial_Id = i_Filial_Id
                           and Rob.Robot_Id = Sd.Robot_Id) Robot_Name,
                       Trunc(max(Sd.Schedule_Date), 'mon') month,
                       to_char(max(Sd.Schedule_Date), 'mm') Month_No,
                       count(*) Working_Day_Count
                  from Htt_Robot_Schedule_Days Sd
                 where Sd.Company_Id = i_Company_Id
                   and Sd.Filial_Id = i_Filial_Id
                   and Sd.Registry_Id = i_Registry_Id
                   and Sd.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
                 group by Sd.Robot_Id)
      loop
        if r.Working_Day_Count <> v_Monthly_Limits(to_number(r.Month_No)) then
          Htt_Error.Raise_123(i_Month      => to_char(r.Month, 'Month', v_Nls_Language),
                              i_Plan_Days  => r.Working_Day_Count,
                              i_Limit_Days => v_Monthly_Limits(to_number(r.Month_No)),
                              i_Robot_Name => r.Robot_Name);
        end if;
      end loop;
    end if;
  
    if r_Calendar.Daily_Limit = 'Y' then
      for r in (select *
                  from (select (select Rob.Name
                                  from Mrf_Robots Rob
                                 where Rob.Company_Id = Sd.Company_Id
                                   and Rob.Filial_Id = Sd.Filial_Id
                                   and Rob.Robot_Id = Sd.Robot_Id) Robot_Name,
                               Sd.Schedule_Date,
                               Sd.Plan_Time,
                               (case
                                  when Td.Day_Kind = v_Dk_Holiday and Otd.Day_Kind = v_Dk_Rest then
                                   Greatest(0, w.Plan_Time - w.Preholiday_Time - w.Preweekend_Time)
                                  when Td.Day_Kind = v_Dk_Holiday then
                                   Greatest(0, w.Plan_Time - w.Preholiday_Time)
                                  when Td.Day_Kind in (v_Dk_Additional_Rest, v_Dk_Rest) then
                                   Greatest(0, w.Plan_Time - w.Preweekend_Time)
                                  else
                                   w.Plan_Time
                                end) Limit_Time
                          from Htt_Robot_Schedule_Days Sd
                          join Htt_Calendar_Week_Days w
                            on w.Company_Id = Sd.Company_Id
                           and w.Filial_Id = Sd.Filial_Id
                           and w.Calendar_Id = r_Calendar.Calendar_Id
                           and w.Order_No = Iso_Week_Day_No(Sd.Schedule_Date)
                          left join Htt_Robot_Schedule_Days Td -- schedule tomorrow day
                            on Td.Company_Id = Sd.Company_Id
                           and Td.Filial_Id = Sd.Filial_Id
                           and Td.Registry_Id = Sd.Registry_Id
                           and Td.Unit_Id = Sd.Unit_Id
                           and Td.Schedule_Date = Sd.Schedule_Date + 1
                          left join Htt_Unit_Schedule_Days Otd -- origin schedule tommorrow day
                            on Otd.Company_Id = Sd.Company_Id
                           and Otd.Filial_Id = Sd.Filial_Id
                           and Otd.Unit_Id = Sd.Unit_Id
                           and Otd.Schedule_Date = Sd.Schedule_Date + 1
                         where Sd.Company_Id = i_Company_Id
                           and Sd.Filial_Id = i_Filial_Id
                           and Sd.Registry_Id = i_Registry_Id) t
                 where t.Plan_Time > t.Limit_Time)
      loop
        Htt_Error.Raise_122(i_Schedule_Date => r.Schedule_Date,
                            i_Plan_Time     => r.Plan_Time,
                            i_Limit_Time    => r.Limit_Time,
                            i_Robot_Name    => r.Robot_Name);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Schedule_By_Calendar
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Calendar_Id number,
    i_Year_Begin  date,
    i_Registry_Id number := null
  ) is
    r_Calendar           Htt_Calendars%rowtype;
    v_Monthly_Limits     Array_Number;
    v_Nls_Language       varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Dk_Holiday         varchar2(1) := Htt_Pref.c_Day_Kind_Holiday;
    v_Dk_Additional_Rest varchar2(1) := Htt_Pref.c_Day_Kind_Additional_Rest;
    v_Dk_Rest            varchar2(1) := Htt_Pref.c_Day_Kind_Rest;
  begin
    if i_Schedule_Id =
       Schedule_Id(i_Company_Id => i_Company_Id,
                   i_Filial_Id  => i_Filial_Id,
                   i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      Check_Staff_Schedule_By_Calendar(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Calendar_Id => i_Calendar_Id,
                                       i_Year_Begin  => i_Year_Begin,
                                       i_Registry_Id => i_Registry_Id);
    elsif i_Schedule_Id =
          Schedule_Id(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      Check_Robot_Schedule_By_Calendar(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Calendar_Id => i_Calendar_Id,
                                       i_Year_Begin  => i_Year_Begin,
                                       i_Registry_Id => i_Registry_Id);
    
    else
      r_Calendar := z_Htt_Calendars.Take(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Calendar_Id => i_Calendar_Id);
    
      if r_Calendar.Monthly_Limit = 'Y' then
        v_Monthly_Limits := Calendar_Monthly_Limit(i_Company_Id  => i_Company_Id,
                                                   i_Filial_Id   => i_Filial_Id,
                                                   i_Calendar_Id => i_Calendar_Id,
                                                   i_Year_Begin  => i_Year_Begin);
      
        for r in (select *
                    from (select to_char(q.Schedule_Date, 'mm') Month_No, count(*) Working_Day_Count
                            from Htt_Schedule_Days q
                           where q.Company_Id = i_Company_Id
                             and q.Filial_Id = i_Filial_Id
                             and q.Schedule_Id = i_Schedule_Id
                             and Trunc(q.Schedule_Date, 'year') = i_Year_Begin
                             and q.Day_Kind in
                                 (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
                           group by to_char(q.Schedule_Date, 'mm')) t)
        loop
          if r.Working_Day_Count <> v_Monthly_Limits(to_number(r.Month_No)) then
            Htt_Error.Raise_123(i_Month      => to_char(Add_Months(i_Year_Begin, r.Month_No - 1),
                                                        'Month',
                                                        v_Nls_Language),
                                i_Plan_Days  => r.Working_Day_Count,
                                i_Limit_Days => v_Monthly_Limits(to_number(r.Month_No)));
          end if;
        end loop;
      end if;
    
      if r_Calendar.Daily_Limit = 'Y' then
        for r in (select *
                    from (select q.Schedule_Date,
                                 q.Plan_Time,
                                 (case
                                    when Tm.Day_Kind = v_Dk_Holiday and Otm.Day_Kind = v_Dk_Rest then
                                     Greatest(0, w.Plan_Time - w.Preholiday_Time - w.Preweekend_Time)
                                    when Tm.Day_Kind = v_Dk_Holiday then
                                     Greatest(0, w.Plan_Time - w.Preholiday_Time)
                                    when Tm.Day_Kind in (v_Dk_Additional_Rest, v_Dk_Rest) then
                                     Greatest(0, w.Plan_Time - w.Preweekend_Time)
                                    else
                                     w.Plan_Time
                                  end) Limit_Time
                            from Htt_Schedule_Days q
                            join Htt_Calendar_Week_Days w
                              on w.Company_Id = q.Company_Id
                             and w.Filial_Id = q.Filial_Id
                             and w.Calendar_Id = r_Calendar.Calendar_Id
                             and w.Order_No = Iso_Week_Day_No(q.Schedule_Date)
                            left join Htt_Schedule_Days Tm -- schedule tomorrow day
                              on Tm.Company_Id = q.Company_Id
                             and Tm.Filial_Id = q.Filial_Id
                             and Tm.Schedule_Id = q.Schedule_Id
                             and Tm.Schedule_Date = q.Schedule_Date + 1
                            left join Htt_Schedule_Origin_Days Otm -- origin schedule tommorrow day
                              on Otm.Company_Id = q.Company_Id
                             and Otm.Filial_Id = q.Filial_Id
                             and Otm.Schedule_Id = q.Schedule_Id
                             and Otm.Schedule_Date = q.Schedule_Date + 1
                           where q.Company_Id = i_Company_Id
                             and q.Filial_Id = i_Filial_Id
                             and q.Schedule_Id = i_Schedule_Id) t
                   where t.Plan_Time > t.Limit_Time)
        loop
          Htt_Error.Raise_122(i_Schedule_Date => r.Schedule_Date,
                              i_Plan_Time     => r.Plan_Time,
                              i_Limit_Time    => r.Limit_Time);
        end loop;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_New
  (
    o_Schedule                  in out nocopy Htt_Pref.Schedule_Rt,
    i_Company_Id                number,
    i_Filial_Id                 number,
    i_Schedule_Id               number,
    i_Name                      varchar2,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Count_Free                varchar2,
    i_Use_Weights               varchar2,
    i_Allowed_Late_Time         number,
    i_Allowed_Early_Time        number,
    i_Begin_Late_Time           number,
    i_End_Early_Time            number,
    i_Calendar_Id               number,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Gps_Turnout_Enabled       varchar2,
    i_Gps_Use_Location          varchar2,
    i_Gps_Max_Interval          number,
    i_State                     varchar2,
    i_Code                      varchar2,
    i_Year                      number,
    i_Schedule_Kind             varchar2 := Htt_Pref.c_Schedule_Kind_Flexible
  ) is
  begin
    o_Schedule.Company_Id                := i_Company_Id;
    o_Schedule.Filial_Id                 := i_Filial_Id;
    o_Schedule.Schedule_Id               := i_Schedule_Id;
    o_Schedule.Name                      := i_Name;
    o_Schedule.Shift                     := i_Shift;
    o_Schedule.Schedule_Kind             := i_Schedule_Kind;
    o_Schedule.Input_Acceptance          := i_Input_Acceptance;
    o_Schedule.Output_Acceptance         := i_Output_Acceptance;
    o_Schedule.Track_Duration            := Nvl(i_Track_Duration, 1440);
    o_Schedule.Count_Late                := i_Count_Late;
    o_Schedule.Count_Early               := i_Count_Early;
    o_Schedule.Count_Lack                := i_Count_Lack;
    o_Schedule.Count_Free                := i_Count_Free;
    o_Schedule.Use_Weights               := i_Use_Weights;
    o_Schedule.Advanced_Setting          := 'N';
    o_Schedule.Allowed_Late_Time         := i_Allowed_Late_Time;
    o_Schedule.Allowed_Early_Time        := i_Allowed_Early_Time;
    o_Schedule.Begin_Late_Time           := i_Begin_Late_Time;
    o_Schedule.End_Early_Time            := i_End_Early_Time;
    o_Schedule.Calendar_Id               := i_Calendar_Id;
    o_Schedule.Take_Holidays             := i_Take_Holidays;
    o_Schedule.Take_Nonworking           := i_Take_Nonworking;
    o_Schedule.Take_Additional_Rest_Days := i_Take_Additional_Rest_Days;
    o_Schedule.Gps_Turnout_Enabled       := i_Gps_Turnout_Enabled;
    o_Schedule.Gps_Use_Location          := i_Gps_Use_Location;
    o_Schedule.Gps_Max_Interval          := i_Gps_Max_Interval;
    o_Schedule.State                     := i_State;
    o_Schedule.Code                      := i_Code;
    o_Schedule.Year                      := i_Year;
  
    if i_Allowed_Late_Time <> 0 or i_Allowed_Early_Time <> 0 or --
       i_Begin_Late_Time <> 0 or i_End_Early_Time <> 0 then
      o_Schedule.Advanced_Setting := 'Y';
    end if;
  
    o_Schedule.Days    := Htt_Pref.Schedule_Day_Nt();
    o_Schedule.Marks   := Htt_Pref.Schedule_Day_Marks_Nt();
    o_Schedule.Weights := Htt_Pref.Schedule_Day_Weights_Nt();
    o_Schedule.Pattern := Htt_Pref.Schedule_Pattern_Rt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Pattern_Add
  (
    o_Schedule_Template in out nocopy Htt_Pref.Schedule_Template_Rt,
    i_Pattern_Day       Htt_Pref.Schedule_Pattern_Day_Rt
  ) is
  begin
    o_Schedule_Template.Pattern_Days.Extend();
    o_Schedule_Template.Pattern_Days(o_Schedule_Template.Pattern_Days.Count) := i_Pattern_Day;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_New
  (
    o_Schedule_Template         in out nocopy Htt_Pref.Schedule_Template_Rt,
    i_Template_Id               number,
    i_Name                      varchar2,
    i_Description               varchar2,
    i_Schedule_Kind             varchar2,
    i_All_Days_Equal            varchar2,
    i_Count_Days                number,
    i_Shift                     number,
    i_Input_Acceptance          number,
    i_Output_Acceptance         number,
    i_Track_Duration            number,
    i_Count_Late                varchar2,
    i_Count_Early               varchar2,
    i_Count_Lack                varchar2,
    i_Take_Holidays             varchar2,
    i_Take_Nonworking           varchar2,
    i_Take_Additional_Rest_Days varchar2,
    i_Order_No                  number,
    i_State                     varchar2,
    i_Code                      varchar2
  ) is
  begin
    o_Schedule_Template.Template_Id               := i_Template_Id;
    o_Schedule_Template.Name                      := i_Name;
    o_Schedule_Template.Description               := i_Description;
    o_Schedule_Template.Schedule_Kind             := i_Schedule_Kind;
    o_Schedule_Template.All_Days_Equal            := i_All_Days_Equal;
    o_Schedule_Template.Count_Days                := i_Count_Days;
    o_Schedule_Template.Shift                     := Nvl(i_Shift, 0);
    o_Schedule_Template.Input_Acceptance          := Nvl(i_Input_Acceptance, 0);
    o_Schedule_Template.Output_Acceptance         := Nvl(i_Output_Acceptance, 0);
    o_Schedule_Template.Track_Duration            := Nvl(i_Track_Duration, 1440);
    o_Schedule_Template.Count_Late                := i_Count_Late;
    o_Schedule_Template.Count_Early               := i_Count_Early;
    o_Schedule_Template.Count_Lack                := i_Count_Lack;
    o_Schedule_Template.Take_Holidays             := i_Take_Holidays;
    o_Schedule_Template.Take_Nonworking           := i_Take_Nonworking;
    o_Schedule_Template.Take_Additional_Rest_Days := i_Take_Additional_Rest_Days;
    o_Schedule_Template.Order_No                  := i_Order_No;
    o_Schedule_Template.State                     := i_State;
    o_Schedule_Template.Code                      := i_Code;
  
    o_Schedule_Template.Pattern_Days := Htt_Pref.Schedule_Pattern_Day_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calendar_Monthly_Limit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Year_Begin  date
  ) return Array_Number is
    v_Month_Begin    date;
    v_Month_End      date;
    v_Monthly_Limits Array_Number := Array_Number();
  begin
    v_Monthly_Limits.Extend(12);
  
    for i in 1 .. 12
    loop
      v_Month_Begin := Add_Months(i_Year_Begin, i - 1);
      v_Month_End   := Last_Day(v_Month_Begin);
    
      v_Monthly_Limits(i) := v_Month_End - v_Month_Begin + 1 -
                             Official_Rest_Days_Count(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Calendar_Id => i_Calendar_Id,
                                                      i_Begin_Date  => v_Month_Begin,
                                                      i_End_Date    => v_Month_End);
    end loop;
  
    return v_Monthly_Limits;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Day_Kind
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number := null,
    i_Robot_Id      number := null,
    i_Schedule_Id   number,
    i_Schedule_Date date
  ) return varchar2 is
    v_Day_Kind varchar2(1);
    v_Unit_Id  number;
    v_Robot_Id number := i_Robot_Id;
  begin
    if i_Schedule_Id =
       Schedule_Id(i_Company_Id => i_Company_Id,
                   i_Filial_Id  => i_Filial_Id,
                   i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      v_Unit_Id := z_Htt_Staff_Schedule_Days.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Staff_Id => i_Staff_Id, --
                   i_Schedule_Date => i_Schedule_Date).Unit_Id;
    
      v_Day_Kind := z_Htt_Unit_Schedule_Days.Take(i_Company_Id => i_Company_Id, --
                    i_Filial_Id => i_Filial_Id, --
                    i_Unit_Id => v_Unit_Id, --
                    i_Schedule_Date => i_Schedule_Date).Day_Kind;
    elsif i_Schedule_Id =
          Schedule_Id(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      if v_Robot_Id is not null then
        v_Robot_Id := Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => i_Staff_Id,
                                                    i_Period     => i_Schedule_Date);
      end if;
    
      v_Unit_Id := z_Htt_Robot_Schedule_Days.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Robot_Id => v_Robot_Id, --
                   i_Schedule_Date => i_Schedule_Date).Unit_Id;
    
      v_Day_Kind := z_Htt_Unit_Schedule_Days.Take(i_Company_Id => i_Company_Id, --
                    i_Filial_Id => i_Filial_Id, --
                    i_Unit_Id => v_Unit_Id, --
                    i_Schedule_Date => i_Schedule_Date).Day_Kind;
    else
      v_Day_Kind := z_Htt_Schedule_Origin_Days.Take(i_Company_Id => i_Company_Id, --
                    i_Filial_Id => i_Filial_Id, --
                    i_Schedule_Id => i_Schedule_Id, --
                    i_Schedule_Date => i_Schedule_Date).Day_Kind;
    end if;
  
    return v_Day_Kind;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Check_Day_Kind
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number := null,
    i_Robot_Id    number := null,
    i_Schedule_Id number := null,
    i_Date        date,
    i_Day_Kind    varchar2
  ) return varchar2 is
    r_Timesheet         Htt_Timesheets%rowtype;
    v_Schedule_Day_Kind varchar2(1);
  begin
    r_Timesheet := Timesheet(i_Company_Id     => i_Company_Id,
                             i_Filial_Id      => i_Filial_Id,
                             i_Staff_Id       => i_Staff_Id,
                             i_Timesheet_Date => i_Date);
  
    v_Schedule_Day_Kind := Schedule_Day_Kind(i_Company_Id    => i_Company_Id,
                                             i_Filial_Id     => i_Filial_Id,
                                             i_Staff_Id      => i_Staff_Id,
                                             i_Robot_Id      => i_Robot_Id,
                                             i_Schedule_Id   => Nvl(r_Timesheet.Schedule_Id,
                                                                    i_Schedule_Id),
                                             i_Schedule_Date => i_Date);
  
    if r_Timesheet.Day_Kind = i_Day_Kind or v_Schedule_Day_Kind = i_Day_Kind then
      return 'Y';
    end if;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Plan_Time
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number := null,
    i_Robot_Id        number := null,
    i_Schedule_Id     number := null,
    i_Date            date,
    i_Plan_Time       number,
    i_Preholiday_Time number,
    i_Preweekend_Time number
  ) return number is
    v_Plan_Time number := i_Plan_Time;
  begin
    if Htt_Util.Check_Day_Kind(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Staff_Id    => i_Staff_Id,
                               i_Robot_Id    => i_Robot_Id,
                               i_Schedule_Id => i_Schedule_Id,
                               i_Date        => i_Date + 1,
                               i_Day_Kind    => Htt_Pref.c_Day_Kind_Holiday) = 'Y' then
      v_Plan_Time := Greatest(v_Plan_Time - i_Preholiday_Time, 0);
    end if;
  
    if Htt_Util.Check_Day_Kind(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Staff_Id    => i_Staff_Id,
                               i_Robot_Id    => i_Robot_Id,
                               i_Schedule_Id => i_Schedule_Id,
                               i_Date        => i_Date + 1,
                               i_Day_Kind    => Htt_Pref.c_Day_Kind_Additional_Rest) = 'Y' or
       Htt_Util.Check_Day_Kind(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Staff_Id    => i_Staff_Id,
                               i_Robot_Id    => i_Robot_Id,
                               i_Schedule_Id => i_Schedule_Id,
                               i_Date        => i_Date + 1,
                               i_Day_Kind    => Htt_Pref.c_Day_Kind_Rest) = 'Y' then
      v_Plan_Time := Greatest(v_Plan_Time - i_Preweekend_Time, 0);
    end if;
  
    return v_Plan_Time;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Add
  (
    o_Timesheets   in out nocopy Htt_Pref.Timesheet_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Input_Time   date,
    i_Output_Time  date
  ) is
  begin
    o_Timesheets.Extend;
    o_Timesheets(o_Timesheets.Count) := Htt_Pref.Timesheet_Rt(Company_Id   => i_Company_Id,
                                                              Filial_Id    => i_Filial_Id,
                                                              Timesheet_Id => i_Timesheet_Id,
                                                              Input_Time   => i_Input_Time,
                                                              Output_Time  => i_Output_Time);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Fact_Add
  (
    o_Facts        in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Time_Kind_Id number,
    i_Fact_Value   number
  ) is
  begin
    o_Facts.Extend();
    o_Facts(o_Facts.Count) := Htt_Pref.Timesheet_Fact_Rt(Company_Id   => i_Company_Id,
                                                         Filial_Id    => i_Filial_Id,
                                                         Timesheet_Id => i_Timesheet_Id,
                                                         Time_Kind_Id => i_Time_Kind_Id,
                                                         Fact_Value   => i_Fact_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_New
  (
    o_Change      in out nocopy Htt_Pref.Change_Rt,
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Change_Id   number,
    i_Staff_Id    number,
    i_Change_Kind varchar2,
    i_Note        varchar2
  ) is
  begin
    o_Change.Company_Id  := i_Company_Id;
    o_Change.Filial_Id   := i_Filial_Id;
    o_Change.Change_Id   := i_Change_Id;
    o_Change.Staff_Id    := i_Staff_Id;
    o_Change.Change_Kind := i_Change_Kind;
    o_Change.Note        := i_Note;
  
    o_Change.Change_Days := Htt_Pref.Change_Day_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Add
  (
    o_Change           in out nocopy Htt_Pref.Change_Rt,
    i_Change_Date      date,
    i_Swapped_Date     date := null,
    i_Day_Kind         varchar2,
    i_Begin_Time       date,
    i_End_Time         date,
    i_Break_Enabled    varchar2,
    i_Break_Begin_Time date,
    i_Break_End_Time   date,
    i_Plan_Time        number
  ) is
    v_Change_Day Htt_Pref.Change_Day_Rt;
  begin
    v_Change_Day.Change_Date      := i_Change_Date;
    v_Change_Day.Swapped_Date     := i_Swapped_Date;
    v_Change_Day.Begin_Time       := i_Begin_Time;
    v_Change_Day.End_Time         := i_End_Time;
    v_Change_Day.Day_Kind         := i_Day_Kind;
    v_Change_Day.Break_Enabled    := i_Break_Enabled;
    v_Change_Day.Break_Begin_Time := i_Break_Begin_Time;
    v_Change_Day.Break_End_Time   := i_Break_End_Time;
    v_Change_Day.Plan_Time        := i_Plan_Time;
  
    o_Change.Change_Days.Extend();
    o_Change.Change_Days(o_Change.Change_Days.Count) := v_Change_Day;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weight_New
  (
    o_Change_Day_Weights in out nocopy Htt_Pref.Change_Day_Weights,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Change_Id          number,
    i_Change_Date        date
  ) is
  begin
    o_Change_Day_Weights.Company_Id  := i_Company_Id;
    o_Change_Day_Weights.Filial_Id   := i_Filial_Id;
    o_Change_Day_Weights.Staff_Id    := i_Staff_Id;
    o_Change_Day_Weights.Change_Id   := i_Change_Id;
    o_Change_Day_Weights.Change_Date := i_Change_Date;
  
    o_Change_Day_Weights.Weights := Htt_Pref.Time_Weight_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weight_Add
  (
    o_Change_Day_Weights in out nocopy Htt_Pref.Change_Day_Weights,
    i_Begin_Time         number,
    i_End_Time           number,
    i_Weight             number
  ) is
    v_Weight Htt_Pref.Time_Weight_Rt;
  begin
    v_Weight.Begin_Time := i_Begin_Time;
    v_Weight.End_Time   := i_End_Time;
    v_Weight.Weight     := i_Weight;
  
    o_Change_Day_Weights.Weights.Extend();
    o_Change_Day_Weights.Weights(o_Change_Day_Weights.Weights.Count) := v_Weight;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone(i_Company_Id number) return varchar2 is
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
  begin
    return g_Cache_Company_Timezones(i_Company_Id);
  exception
    when No_Data_Found then
      v_Timezone_Code := z_Md_Company_Infos.Load(i_Company_Id).Timezone_Code;
    
      if v_Timezone_Code is null then
        v_Timezone_Code := Dbtimezone;
      end if;
    
      g_Cache_Company_Timezones(i_Company_Id) := v_Timezone_Code;
    
      return v_Timezone_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
    v_Code          varchar2(100) := i_Company_Id || ' ' || i_Filial_Id;
  begin
    return g_Cache_Filial_Timezones(v_Code);
  exception
    when No_Data_Found then
      v_Timezone_Code := z_Md_Filials.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Timezone_Code;
    
      if v_Timezone_Code is null then
        v_Timezone_Code := Load_Timezone(i_Company_Id);
      end if;
    
      g_Cache_Filial_Timezones(v_Code) := v_Timezone_Code;
    
      return v_Timezone_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timezone
  (
    i_Company_Id  number,
    i_Location_Id number
  ) return varchar2 is
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
    v_Code          varchar2(100) := i_Company_Id || ' ' || i_Location_Id;
  begin
    return g_Cache_Location_Timezones(v_Code);
  exception
    when No_Data_Found then
      v_Timezone_Code := z_Htt_Locations.Load(i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id).Timezone_Code;
    
      if v_Timezone_Code is null then
        v_Timezone_Code := Load_Timezone(i_Company_Id);
      end if;
    
      g_Cache_Location_Timezones(v_Code) := v_Timezone_Code;
    
      return v_Timezone_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timestamp_To_Date
  (
    i_Timestamp timestamp with time zone,
    i_Timezone  varchar2 := null
  ) return date is
  begin
    if i_Timezone is not null then
      return to_date(to_char(i_Timestamp At time zone i_Timezone, 'ddmmyyyyhh24miss'),
                     'ddmmyyyyhh24miss');
    end if;
  
    return to_date(to_char(i_Timestamp, 'ddmmyyyyhh24miss'), 'ddmmyyyyhh24miss');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Date
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return date is
  begin
    return Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                             i_Timezone  => Load_Timezone(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id));
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Serial_Number
  (
    i_Company_Id     number,
    i_Device_Type_Id number,
    i_Serial_Number  varchar2
  ) return Htt_Devices%rowtype is
    r_Device Htt_Devices%rowtype;
  begin
    select q.*
      into r_Device
      from Htt_Devices q
     where q.Company_Id = i_Company_Id
       and q.Device_Type_Id = i_Device_Type_Id
       and q.Serial_Number = i_Serial_Number;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Parent_Time_Kinds(i_Company_Id number) return Htt_Pref.Time_Kind_Nt is
    result Htt_Pref.Time_Kind_Nt;
  begin
    select Tk.Name, Lower(Tk.Pcode)
      bulk collect
      into result
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = i_Company_Id
       and Tk.Pcode is not null;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_Parent_Or_Self_Id
  (
    i_Company_Id   number,
    i_Time_Kind_Id varchar2
  ) return number is
    result number;
  begin
    result := z_Htt_Time_Kinds.Take(i_Company_Id => i_Company_Id, i_Time_Kind_Id => i_Time_Kind_Id).Parent_Id;
  
    if result is null then
      result := i_Time_Kind_Id;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Code varchar2(100) := i_Company_Id || ' ' || i_Pcode;
    result number;
  begin
    return g_Cache_Time_Kind_Ids(v_Code);
  exception
    when No_Data_Found then
      select Time_Kind_Id
        into result
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    
      g_Cache_Time_Kind_Ids(v_Code) := result;
    
      return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_With_Child_Ids
  (
    i_Company_Id number,
    i_Pcodes     Array_Varchar2
  ) return Array_Number is
    result Array_Number;
  begin
    select Tk.Time_Kind_Id
      bulk collect
      into result
      from Htt_Time_Kinds Tk
      left join Htt_Time_Kinds p
        on p.Company_Id = Tk.Company_Id
       and p.Time_Kind_Id = Tk.Parent_Id
     where Tk.Company_Id = i_Company_Id
       and (Tk.Pcode member of i_Pcodes or p.Pcode member of i_Pcodes);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Id
  (
    i_Company_Id number,
    i_Pin        varchar2
  ) return number is
    result number;
  begin
    select t.Person_Id
      into result
      from Htt_Persons t
     where t.Company_Id = i_Company_Id
       and t.Pin = i_Pin;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select p.Schedule_Id
      into result
      from Htt_Schedules p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Pcode = i_Pcode;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Trim_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Code       => Htt_Pref.c_Schedule_Trimmed_Tracks),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Pin_Autogenerate(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Htt_Pref.c_Pin_Autogenerate),
               'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Photo_As_Face_Rec(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Htt_Pref.c_Photo_As_Face_Rec),
               'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Pin
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2 is
  begin
    return z_Htt_Persons.Load(i_Company_Id => i_Company_Id, --
                              i_Person_Id  => i_Person_Id).Pin;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Filial_Ids
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Person_Id   number
  ) return Array_Number is
    result Array_Number;
  begin
    select q.Filial_Id
      bulk collect
      into result
      from Htt_Location_Persons q
     where q.Company_Id = i_Company_Id
       and q.Location_Id = i_Location_Id
       and q.Person_Id = i_Person_Id
       and not exists (select 1
              from Htt_Blocked_Person_Tracking Bp
             where Bp.Company_Id = q.Company_Id
               and Bp.Filial_Id = q.Filial_Id
               and Bp.Employee_Id = q.Person_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Location_Id
      into result
      from Htt_Locations q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  
  exception
    when No_Data_Found then
      Htt_Error.Raise_009(i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Location_Id
      into result
      from Htt_Locations q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when others then
      Htt_Error.Raise_010(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id_By_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Schedule_Id
      into result
      from Htt_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Code = i_Code;
  
    return result;
  
  exception
    when No_Data_Found then
      Htt_Error.Raise_011(i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Schedule_Id
      into result
      from Htt_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Htt_Error.Raise_012(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id(i_Pcode varchar2) return number is
    result number;
  begin
    select q.Device_Type_Id
      into result
      from Htt_Device_Types q
     where q.Pcode = i_Pcode;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Pcode(i_Device_Type_Id number) return varchar2 is
    result varchar2(20);
  begin
    select q.Pcode
      into result
      from Htt_Device_Types q
     where q.Device_Type_Id = i_Device_Type_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Qr_Code_Gen(i_Person_Id number) return varchar2 is
    v_Key varchar2(100 char) := to_char(Dbms_Crypto.Randombytes(32));
  begin
    return Fazo.Hash_Sha1(i_Person_Id || ':qr_code_secret_key:' || v_Key);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Manager_Device_Sn(i_Serial_Number varchar2) return varchar2 is
  begin
    return 'manager_device:' || i_Serial_Number;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Convert_Timestamp
  (
    i_Date     date,
    i_Timezone varchar2
  ) return timestamp
    with time zone is
  begin
    return From_Tz(cast(i_Date as timestamp), i_Timezone);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Iso_Week_Day_No(i_Date date) return number is
  begin
    return Trunc(i_Date) - Trunc(i_Date, 'iw') + 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Default_Calendar_Id
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number is
    result number;
  begin
    select Calendar_Id
      into result
      from Htt_Calendars c
     where c.Company_Id = i_Company_Id
       and c.Filial_Id = i_Filial_Id
       and c.Pcode = Htt_Pref.c_Pcode_Default_Calendar;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calendar_Rest_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number := null
  ) return Array_Number is
    v_Calendar_Id number;
    result        Array_Number;
  begin
    v_Calendar_Id := Nvl(i_Calendar_Id,
                         Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id));
  
    select Cd.Week_Day_No
      bulk collect
      into result
      from Htt_Calendar_Rest_Days Cd
     where Cd.Company_Id = i_Company_Id
       and Cd.Filial_Id = i_Filial_Id
       and Cd.Calendar_Id = v_Calendar_Id;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Calendar_Day
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Calendar_Id  number,
    i_Date         date,
    o_Calendar_Day out nocopy Htt_Calendar_Days%rowtype
  ) return boolean is
  begin
    if not z_Htt_Calendar_Days.Exist(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Calendar_Id   => i_Calendar_Id,
                                     i_Calendar_Date => i_Date,
                                     o_Row           => o_Calendar_Day) then
      begin
        select *
          into o_Calendar_Day
          from Htt_Calendar_Days Cd
         where Cd.Company_Id = i_Company_Id
           and Cd.Filial_Id = i_Filial_Id
           and Cd.Calendar_Id = i_Calendar_Id
           and Cd.Swapped_Date = i_Date;
      exception
        when No_Data_Found then
          return false;
      end;
    end if;
  
    return true;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Official_Rest_Day
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Date        date
  ) return boolean is
    r_Calendar_Day Htt_Calendar_Days%rowtype;
    v_Rest_Days    Array_Number;
    v_Calendar_Id  number;
  begin
    v_Calendar_Id := Nvl(i_Calendar_Id,
                         Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id));
  
    v_Rest_Days := Calendar_Rest_Days(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Calendar_Id => v_Calendar_Id);
  
    if Is_Calendar_Day(i_Company_Id   => i_Company_Id,
                       i_Filial_Id    => i_Filial_Id,
                       i_Calendar_Id  => v_Calendar_Id,
                       i_Date         => i_Date,
                       o_Calendar_Day => r_Calendar_Day) and
       r_Calendar_Day.Day_Kind in
       (Htt_Pref.c_Day_Kind_Holiday, Htt_Pref.c_Day_Kind_Additional_Rest) then
      return true;
    end if;
  
    return Fazo.Contains(v_Rest_Days, Iso_Week_Day_No(i_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Official_Rest_Days_Count
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number is
    v_Rest_Days_Count number := 0;
    v_Holiday_Count   number;
  begin
    if i_End_Date < i_Begin_Date then
      return 0;
    end if;
  
    select count(*)
      into v_Holiday_Count
      from Htt_Calendar_Days Cd
     where Cd.Company_Id = i_Company_Id
       and Cd.Filial_Id = i_Filial_Id
       and Cd.Calendar_Id = i_Calendar_Id
       and Cd.Calendar_Date between i_Begin_Date and i_End_Date
       and Cd.Day_Kind in (Htt_Pref.c_Day_Kind_Holiday, Htt_Pref.c_Day_Kind_Additional_Rest)
       and not exists (select *
              from Htt_Calendar_Rest_Days w
             where w.Company_Id = Cd.Company_Id
               and w.Filial_Id = Cd.Filial_Id
               and w.Calendar_Id = Cd.Calendar_Id
               and w.Week_Day_No = Iso_Week_Day_No(Cd.Calendar_Date));
  
    for r in (select Rd.Week_Day_No
                from Htt_Calendar_Rest_Days Rd
               where Rd.Company_Id = i_Company_Id
                 and Rd.Filial_Id = i_Filial_Id
                 and Rd.Calendar_Id = i_Calendar_Id)
    loop
      v_Rest_Days_Count := v_Rest_Days_Count +
                           (Trunc(i_End_Date, 'iw') - Trunc(i_Begin_Date + 7, 'iw')) / 7;
    
      if i_End_Date - Trunc(i_End_Date, 'iw') + 1 >= r.Week_Day_No then
        v_Rest_Days_Count := v_Rest_Days_Count + 1;
      end if;
    
      if i_Begin_Date - Trunc(i_Begin_Date, 'iw') + 1 <= r.Week_Day_No then
        v_Rest_Days_Count := v_Rest_Days_Count + 1;
      end if;
    end loop;
  
    return v_Holiday_Count + v_Rest_Days_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Exist_Track
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Person_Id      number,
    i_Track_Type     varchar2,
    i_Track_Datetime date,
    i_Device_Id      number
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Htt_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = i_Person_Id
       and q.Track_Type = i_Track_Type
       and q.Track_Datetime = i_Track_Datetime
       and q.Device_Id = i_Device_Id;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Exist_Timesheet
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date,
    o_Timesheet      out Htt_Timesheets%rowtype
  ) return boolean is
  begin
    o_Timesheet := Timesheet(i_Company_Id     => i_Company_Id,
                             i_Filial_Id      => i_Filial_Id,
                             i_Staff_Id       => i_Staff_Id,
                             i_Timesheet_Date => i_Timesheet_Date);
  
    return o_Timesheet.Company_Id is not null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Exist_Request
  (
    i_Company_Id      number,
    i_Staff_Id        number,
    i_Request_Kind_Id number
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Htt_Requests q
     where q.Company_Id = i_Company_Id
       and q.Staff_Id = i_Staff_Id
       and q.Request_Kind_Id = i_Request_Kind_Id
       and q.Status = Htt_Pref.c_Request_Status_Completed
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timesheet
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  ) return Htt_Timesheets%rowtype is
    result Htt_Timesheets%rowtype;
  begin
    select *
      into result
      from Htt_Timesheets q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Timesheet_Date = i_Timesheet_Date;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Prohibited
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Latlng     varchar2
  ) return boolean is
    v_Track_Latlng    Array_Varchar2;
    v_Location_Latlng Array_Varchar2;
  begin
    v_Track_Latlng := Fazo.Split(i_Latlng, ',');
  
    for r in (select l.Latlng, l.Accuracy
                from Htt_Locations l
               where l.Company_Id = i_Company_Id
                 and l.Prohibited = 'Y'
                 and l.State = 'A'
                 and exists (select 1
                        from Htt_Location_Persons Lp
                       where Lp.Company_Id = i_Company_Id
                         and Lp.Filial_Id = i_Filial_Id
                         and Lp.Location_Id = l.Location_Id
                         and Lp.Person_Id = i_Person_Id))
    loop
      v_Location_Latlng := Fazo.Split(r.Latlng, ',');
    
      if r.Accuracy >= Nvl(Trunc(Power(Power(69.1 * (v_Location_Latlng(1) - v_Track_Latlng(1)), 2) +
                                       Power(53.0 * (v_Location_Latlng(2) - v_Track_Latlng(2)), 2),
                                       0.5) / 0.00062137),
                           0) then
        return true;
      end if;
    end loop;
  
    return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Track_Accepted_Period
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Period      date
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date + Href_Pref.c_Diff_Hiring <= i_Period
       and Nvl(s.Dismissal_Date + Href_Pref.c_Diff_Dismissal, i_Period) >= i_Period
       and Rownum = 1;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Not_Accepted_Periods
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return Href_Pref.Period_Nt is
    result Href_Pref.Period_Nt;
  begin
    select q.Begin_Date, q.End_Date
      bulk collect
      into result
      from (select Nvl(Lag(s.Dismissal_Date)
                       Over(order by s.Hiring_Date) + Href_Pref.c_Diff_Dismissal,
                       Href_Pref.c_Min_Date) as Begin_Date,
                   s.Hiring_Date + Href_Pref.c_Diff_Hiring as End_Date
              from Href_Staffs s
             where s.Company_Id = i_Company_Id
               and s.Filial_Id = i_Filial_Id
               and s.Employee_Id = i_Employee_Id
               and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and s.State = 'A'
            union
            select s.Dismissal_Date + Href_Pref.c_Diff_Dismissal as Begin_Date,
                   Href_Pref.c_Max_Date as End_Date
              from Href_Staffs s
             where s.Company_Id = i_Company_Id
               and s.Filial_Id = i_Filial_Id
               and s.Employee_Id = i_Employee_Id
               and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and s.State = 'A'
               and s.Hiring_Date = (select max(S1.Hiring_Date)
                                      from Href_Staffs S1
                                     where S1.Company_Id = i_Company_Id
                                       and S1.Filial_Id = i_Filial_Id
                                       and S1.Employee_Id = i_Employee_Id
                                       and S1.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                                       and S1.State = 'A')
               and s.Dismissal_Date is not null) q;
  
    if Result.Count = 0 then
      Result.Extend;
      result(Result.Last) := Href_Pref.Period_Rt(Href_Pref.c_Min_Date, Href_Pref.c_Max_Date);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Minutes(i_Date date) return number is
    f_Arr  Array_Number;
    v_Time varchar2(5) := to_char(i_Date, Href_Pref.c_Time_Format_Minute);
  begin
    f_Arr := Fazo.To_Array_Number(Fazo.Split(v_Time, ':'));
    return f_Arr(1) * 60 + f_Arr(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Time(i_Minutes number) return varchar2 is
  begin
    if i_Minutes is null then
      return null;
    end if;
    return Lpad(Trunc(i_Minutes / 60), 2, '0') || ':' || Lpad(mod(i_Minutes, 60), 2, '0');
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Time_Seconds_Text
  (
    i_Seconds      number,
    i_Show_Minutes boolean := false,
    i_Show_Words   boolean := true,
    i_Show_Seconds boolean := false
  ) return varchar2 is
    v_Seconds number := i_Seconds;
    v_Value   number;
    v_Sign    varchar2(1);
    result    varchar2(50 char);
  begin
    if Nvl(v_Seconds, 0) = 0 then
      return null;
    end if;
  
    if v_Seconds < 0 then
      v_Sign    := '-';
      v_Seconds := -v_Seconds;
    end if;
  
    if i_Show_Minutes then
      v_Value := Trunc(v_Seconds / 3600);
    else
      v_Value := Round(v_Seconds / 3600, 2);
    end if;
  
    if v_Value > 0 or not i_Show_Words then
      result := Rtrim(to_char(v_Value, 'FM999990.99'), '.');
    end if;
  
    if i_Show_Minutes then
      v_Value := Trunc(mod(v_Seconds, 3600) / 60);
    
      if i_Show_Words then
        if result is not null then
          result := result || ' ' || t('hh');
        end if;
      
        if v_Value > 0 then
          if result is not null then
            result := result || ' ';
          end if;
          result := result || v_Value || ' ' || t('min');
        end if;
      else
        result := result || ':' || v_Value;
      end if;
    end if;
  
    if i_Show_Minutes and i_Show_Seconds then
      v_Value := Trunc(mod(v_Seconds, 60));
    
      if i_Show_Words then
        if v_Value > 0 then
          if result is not null then
            result := result || ' ';
          end if;
        
          result := result || v_Value || ' ' || t('sec');
        end if;
      else
        result := result || ':' || v_Value;
      end if;
    end if;
  
    return v_Sign || result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Time_Text
  (
    i_Minutes      number,
    i_Show_Minutes boolean := false,
    i_Show_Words   boolean := true
  ) return varchar2 is
    v_Value number;
    result  varchar2(50 char);
  begin
    if Nvl(i_Minutes, 0) = 0 then
      return null;
    end if;
  
    if i_Show_Minutes then
      v_Value := Trunc(i_Minutes / 60);
    else
      v_Value := Round(i_Minutes / 60, 2);
    end if;
  
    if v_Value > 0 or not i_Show_Words then
      result := Rtrim(to_char(v_Value, 'FM999990.99'), '.');
    end if;
  
    if i_Show_Minutes then
      v_Value := mod(Trunc(i_Minutes), 60);
    
      if i_Show_Words then
        if result is not null then
          result := result || ' ' || t('hh');
        end if;
      
        if v_Value > 0 then
          if result is not null then
            result := result || ' ';
          end if;
          result := result || v_Value || ' ' || t('min');
        end if;
      else
        result := result || ':' || v_Value;
      end if;
    end if;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Load_Request_Kind_Accrual
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Accrual_Kind    varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  ) return Htt_Request_Kind_Accruals%rowtype is
    result Htt_Request_Kind_Accruals%rowtype;
  begin
    select p.*
      into result
      from Htt_Request_Kind_Accruals p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Request_Kind_Id = i_Request_Kind_Id
       and p.Accrual_Kind = i_Accrual_Kind
       and i_Period_End <= p.Period
       and Trunc(p.Period, 'yyyy') <= i_Period_Begin;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Count_Request_Days
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Day_Count_Type     varchar2,
    i_Request_Begin_Time date,
    i_Request_End_Time   date
  ) return number is
    v_Date      date := i_Request_Begin_Time;
    r_Timesheet Htt_Timesheets%rowtype;
    r_Schedule  Htt_Schedules%rowtype;
    result      number := 0;
  begin
    for i in 0 .. Floor(i_Request_End_Time - v_Date)
    loop
      r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => i_Company_Id,
                                        i_Filial_Id      => i_Filial_Id,
                                        i_Staff_Id       => i_Staff_Id,
                                        i_Timesheet_Date => v_Date + i);
    
      r_Schedule := z_Htt_Schedules.Take(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Schedule_Id => r_Timesheet.Schedule_Id);
    
      if i_Day_Count_Type = Htt_Pref.c_Day_Count_Type_Calendar_Days then
        result := result + 1;
      end if;
    
      if i_Day_Count_Type = Htt_Pref.c_Day_Count_Type_Work_Days and
         r_Timesheet.Day_Kind = Htt_Pref.c_Day_Kind_Work then
        result := result + 1;
      end if;
    
      if i_Day_Count_Type = Htt_Pref.c_Day_Count_Type_Production_Days and
         not Is_Official_Rest_Day(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Calendar_Id => r_Schedule.Calendar_Id,
                                  i_Date        => r_Timesheet.Timesheet_Date) then
        result := result + 1;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Request_Kind_Used_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Accrual_Kind    varchar2,
    i_Period          date,
    i_Request_Id      number := null
  ) return number is
    r_Request_Kind Htt_Request_Kinds%rowtype;
    v_Period_Start date := Trunc(i_Period, 'yyyy');
    v_Period_End   date := Year_Last_Day(i_Period);
    v_Request_Id   number := Nvl(i_Request_Id, -1);
    v_Calendar_Id  number := Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id);
  
    v_Days_Cnt number;
  begin
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => i_Company_Id,
                                               i_Request_Kind_Id => i_Request_Kind_Id);
  
    if r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Calendar_Days then
      select count(*)
        into v_Days_Cnt
        from (select p.Interval_Date
                from Htt_Requests q
                join Htt_Request_Helpers p
                  on p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Staff_Id = i_Staff_Id
                 and p.Interval_Date between v_Period_Start and v_Period_End
                 and p.Request_Id = q.Request_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Request_Id <> v_Request_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Request_Kind_Id = i_Request_Kind_Id
                 and q.Accrual_Kind = i_Accrual_Kind
                 and q.Status = Htt_Pref.c_Request_Status_Completed
                 and exists
               (select 1
                        from Htt_Timesheets k
                       where k.Company_Id = p.Company_Id
                         and k.Filial_Id = p.Filial_Id
                         and k.Staff_Id = p.Staff_Id
                         and k.Timesheet_Date = p.Interval_Date
                         and k.Day_Kind in (Htt_Pref.c_Day_Kind_Work,
                                            Htt_Pref.c_Day_Kind_Rest,
                                            Htt_Pref.c_Day_Kind_Nonworking)
                         and not exists
                       (select 1
                                from Htt_Calendar_Rest_Days Rd
                               where Rd.Company_Id = k.Company_Id
                                 and Rd.Filial_Id = k.Filial_Id
                                 and Rd.Calendar_Id = Nvl(k.Calendar_Id, v_Calendar_Id)
                                 and Rd.Week_Day_No =
                                     (Trunc(k.Timesheet_Date) - Trunc(k.Timesheet_Date, 'iw') + 1)))
               group by p.Interval_Date);
    elsif r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Work_Days then
      select count(*)
        into v_Days_Cnt
        from (select p.Interval_Date
                from Htt_Requests q
                join Htt_Request_Helpers p
                  on p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Staff_Id = i_Staff_Id
                 and p.Interval_Date between v_Period_Start and v_Period_End
                 and p.Request_Id = q.Request_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Request_Id <> v_Request_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Request_Kind_Id = i_Request_Kind_Id
                 and q.Accrual_Kind = i_Accrual_Kind
                 and q.Status = Htt_Pref.c_Request_Status_Completed
                 and exists (select 1
                        from Htt_Timesheets k
                       where k.Company_Id = p.Company_Id
                         and k.Filial_Id = p.Filial_Id
                         and k.Staff_Id = p.Staff_Id
                         and k.Timesheet_Date = p.Interval_Date
                         and k.Day_Kind = Htt_Pref.c_Day_Kind_Work)
               group by p.Interval_Date);
    else
      select count(*)
        into v_Days_Cnt
        from (select p.Interval_Date
                from Htt_Requests q
                join Htt_Request_Helpers p
                  on p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Staff_Id = i_Staff_Id
                 and p.Interval_Date between v_Period_Start and v_Period_End
                 and p.Request_Id = q.Request_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Request_Id <> v_Request_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Request_Kind_Id = i_Request_Kind_Id
                 and q.Accrual_Kind = i_Accrual_Kind
                 and q.Status = Htt_Pref.c_Request_Status_Completed
               group by p.Interval_Date);
    end if;
  
    return v_Days_Cnt;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Marks
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  ) is
    v_Error_Date date;
  begin
    select Dm.Schedule_Date
      into v_Error_Date
      from Htt_Schedule_Origin_Day_Marks Dm
     where Dm.Company_Id = i_Company_Id
       and Dm.Filial_Id = i_Filial_Id
       and Dm.Schedule_Id = i_Schedule_Id
       and Dm.Schedule_Date member of i_Dates
       and exists (select 1
              from Htt_Schedule_Origin_Day_Marks Sm
             where Sm.Company_Id = Dm.Company_Id
               and Sm.Filial_Id = Dm.Filial_Id
               and Sm.Schedule_Id = Dm.Schedule_Id
               and Sm.Schedule_Date = Dm.Schedule_Date
               and Sm.Begin_Time <> Dm.Begin_Time
               and Dm.Begin_Time < Sm.End_Time
               and Dm.End_Time > Sm.Begin_Time)
       and Rownum = 1;
  
    Htt_Error.Raise_013(i_Schedule_Name => z_Htt_Schedules.Load(i_Company_Id => i_Company_Id, --
                                           i_Filial_Id => i_Filial_Id, --
                                           i_Schedule_Id => i_Schedule_Id).Name,
                        i_Schedule_Date => v_Error_Date);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Weights
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  ) is
    v_Error_Date date;
  begin
    select Dm.Schedule_Date
      into v_Error_Date
      from Htt_Schedule_Origin_Day_Weights Dm
     where Dm.Company_Id = i_Company_Id
       and Dm.Filial_Id = i_Filial_Id
       and Dm.Schedule_Id = i_Schedule_Id
       and Dm.Schedule_Date member of i_Dates
       and exists (select 1
              from Htt_Schedule_Origin_Day_Weights Sm
             where Sm.Company_Id = Dm.Company_Id
               and Sm.Filial_Id = Dm.Filial_Id
               and Sm.Schedule_Id = Dm.Schedule_Id
               and Sm.Schedule_Date = Dm.Schedule_Date
               and Sm.Begin_Time <> Dm.Begin_Time
               and Dm.Begin_Time < Sm.End_Time
               and Dm.End_Time > Sm.Begin_Time)
       and Rownum = 1;
  
    Htt_Error.Raise_128(i_Schedule_Name => z_Htt_Schedules.Load(i_Company_Id => i_Company_Id, --
                                           i_Filial_Id => i_Filial_Id, --
                                           i_Schedule_Id => i_Schedule_Id).Name,
                        i_Schedule_Date => v_Error_Date);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Change_Day_Weights
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Change_Id   number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Htt_Change_Day_Weights q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Change_Date = i_Change_Date
       and q.Change_Id = i_Change_Id
       and exists (select 1
              from Htt_Change_Day_Weights w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Staff_Id = q.Staff_Id
               and w.Change_Date = q.Change_Date
               and w.Change_Id = q.Change_Id
               and w.Begin_Time <> q.Begin_Time
               and q.Begin_Time < w.End_Time
               and q.End_Time > w.Begin_Time)
       and Rownum = 1;
  
    Htt_Error.Raise_131(i_Change_Date => i_Change_Date);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Schedule_Template_Marks
  (
    i_Template_Id number,
    i_Day_Numbers Array_Number
  ) is
    v_Error_Day number;
  begin
    select Dm.Day_No
      into v_Error_Day
      from Htt_Schedule_Template_Marks Dm
     where Dm.Template_Id = i_Template_Id
       and Dm.Day_No member of i_Day_Numbers
       and exists (select 1
              from Htt_Schedule_Template_Marks Sm
             where Sm.Template_Id = Dm.Template_Id
               and Sm.Day_No = Dm.Day_No
               and Sm.Begin_Time <> Dm.Begin_Time
               and Dm.Begin_Time < Sm.End_Time
               and Dm.End_Time > Sm.Begin_Time)
       and Rownum = 1;
  
    Htt_Error.Raise_014(i_Template_Name => z_Htt_Schedule_Templates.Load(i_Template_Id).Name,
                        i_Day_No        => v_Error_Day);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Timesheet_Locks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Dates      Array_Date
  ) is
    r_Timebook    Hpr_Timebooks%rowtype;
    v_Locked_Date date;
  begin
    begin
      select Tl.Timesheet_Date
        into v_Locked_Date
        from Htt_Timesheet_Locks Tl
       where Tl.Company_Id = i_Company_Id
         and Tl.Filial_Id = i_Filial_Id
         and Tl.Staff_Id = i_Staff_Id
         and Tl.Timesheet_Date member of i_Dates
         and Rownum = 1;
    
      r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Timebook_Id => z_Hpr_Timesheet_Locks.Load(i_Company_Id => i_Company_Id, --
                                                          i_Filial_Id => i_Filial_Id, --
                                                          i_Staff_Id => i_Staff_Id, --
                                                          i_Timesheet_Date => v_Locked_Date).Timebook_Id);
    
      Htt_Error.Raise_015(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                          i_Timesheet_Date  => v_Locked_Date,
                          i_Timebook_Number => r_Timebook.Timebook_Number,
                          i_Timebook_Month  => r_Timebook.Month);
    exception
      when No_Data_Found then
        null;
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Request_Has_Available_Days
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Id           number,
    i_Request_Id         number,
    i_Request_Kind_Id    number,
    i_Request_Begin_Time date,
    i_Request_End_Time   date,
    i_Accrual_Kind       varchar2
  ) is
    r_Request_Kind Htt_Request_Kinds%rowtype;
    v_Period_Begin date := Year_Last_Day(i_Request_Begin_Time);
    v_Period_End   date := Year_Last_Day(i_Request_End_Time);
  
    --------------------------------------------------
    Procedure Assert_Year
    (
      i_Year_Begin date,
      i_Year_End   date
    ) is
      v_Used_Days    number;
      v_Request_Days number;
      r_Accrual      Htt_Request_Kind_Accruals%rowtype;
    
      v_Begin_Time date := Greatest(i_Request_Begin_Time, i_Year_Begin);
      v_End_Time   date := Least(i_Request_End_Time, i_Year_End);
    begin
      v_Request_Days := Count_Request_Days(i_Company_Id         => i_Company_Id,
                                           i_Filial_Id          => i_Filial_Id,
                                           i_Staff_Id           => i_Staff_Id,
                                           i_Day_Count_Type     => r_Request_Kind.Day_Count_Type,
                                           i_Request_Begin_Time => v_Begin_Time,
                                           i_Request_End_Time   => v_End_Time);
    
      r_Accrual := Load_Request_Kind_Accrual(i_Company_Id      => i_Company_Id,
                                             i_Filial_Id       => i_Filial_Id,
                                             i_Staff_Id        => i_Staff_Id,
                                             i_Request_Kind_Id => i_Request_Kind_Id,
                                             i_Accrual_Kind    => i_Accrual_Kind,
                                             i_Period_Begin    => v_Begin_Time,
                                             i_Period_End      => v_End_Time);
    
      r_Accrual.Accrued_Days := Nvl(r_Accrual.Accrued_Days, 0);
    
      v_Used_Days := Get_Request_Kind_Used_Days(i_Company_Id      => i_Company_Id,
                                                i_Filial_Id       => i_Filial_Id,
                                                i_Staff_Id        => i_Staff_Id,
                                                i_Request_Kind_Id => i_Request_Kind_Id,
                                                i_Accrual_Kind    => i_Accrual_Kind,
                                                i_Period          => v_End_Time,
                                                i_Request_Id      => i_Request_Id);
      if v_Used_Days + v_Request_Days > r_Accrual.Accrued_Days then
        Htt_Error.Raise_016(i_Staff_Name        => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                        i_Filial_Id  => i_Filial_Id,
                                                                        i_Staff_Id   => i_Staff_Id),
                            i_Request_Kind_Name => r_Request_Kind.Name,
                            i_Year              => i_Year_End,
                            i_Used_Cnt          => v_Used_Days,
                            i_Request_Cnt       => v_Request_Days,
                            i_Annual_Limit      => r_Accrual.Accrued_Days);
      end if;
    end;
  begin
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => i_Company_Id,
                                               i_Request_Kind_Id => i_Request_Kind_Id);
  
    if r_Request_Kind.Annually_Limited = 'N' then
      return;
    end if;
  
    while v_Period_Begin <= v_Period_End
    loop
      v_Period_Begin := Year_Last_Day(v_Period_Begin);
    
      Assert_Year(i_Year_Begin => Trunc(v_Period_Begin, 'yyyy'), i_Year_End => v_Period_Begin);
    
      v_Period_Begin := v_Period_Begin + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Intersection_Request
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Staff_Id     number,
    i_Begin_Time   date,
    i_End_Time     date,
    i_Request_Type varchar2
  ) is
    v_Request_Id number;
    v_Begin_Time date;
    v_End_Time   date;
  begin
    select q.Request_Id, q.Begin_Time, q.End_Time
      into v_Request_Id, v_Begin_Time, v_End_Time
      from Htt_Requests q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Request_Id <> i_Request_Id
       and q.Staff_Id = i_Staff_Id
       and q.Status in (Htt_Pref.c_Request_Status_Completed, Htt_Pref.c_Request_Status_Approved)
       and (q.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day and
           i_Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day and --
           q.End_Time > i_Begin_Time and q.Begin_Time < i_End_Time or
           not (q.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day and
            i_Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day) and
           Trunc(q.End_Time) >= Trunc(i_Begin_Time) and Trunc(q.Begin_Time) <= Trunc(i_End_Time))
       and Rownum = 1;
  
    Htt_Error.Raise_017(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                  i_Filial_Id  => i_Filial_Id,
                                                                  i_Staff_Id   => i_Staff_Id),
                        i_Intersect_Id    => v_Request_Id,
                        i_Intersect_Begin => v_Begin_Time,
                        i_Intersect_End   => v_End_Time,
                        i_Request_Type    => i_Request_Type,
                        i_Begin_Time      => i_Begin_Time,
                        i_End_Time        => i_End_Time);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Approved_Plan_Change
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Change_Id  number
  ) is
    v_Error_Date   date;
    v_Intersect_Id number;
  begin
    select Sd.Change_Date, Sd.Change_Id
      into v_Error_Date, v_Intersect_Id
      from Htt_Change_Days Sd
     where Sd.Company_Id = i_Company_Id
       and Sd.Filial_Id = i_Filial_Id
       and Sd.Staff_Id = i_Staff_Id
       and Sd.Change_Id <> i_Change_Id
       and exists (select 1
              from Htt_Change_Days Cd
             where Cd.Company_Id = i_Company_Id
               and Cd.Filial_Id = i_Filial_Id
               and Cd.Staff_Id = i_Staff_Id
               and Cd.Change_Id = i_Change_Id
               and Cd.Change_Date = Sd.Change_Date)
       and exists (select 1
              from Htt_Plan_Changes Pc
             where Pc.Company_Id = i_Company_Id
               and Pc.Filial_Id = i_Filial_Id
               and Pc.Change_Id = Sd.Change_Id
               and Pc.Status in (Htt_Pref.c_Change_Status_Approved,
                                 Htt_Pref.c_Change_Status_Completed))
       and Rownum = 1;
  
    Htt_Error.Raise_100(i_Staff_Name   => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                               i_Filial_Id  => i_Filial_Id,
                                                               i_Staff_Id   => i_Staff_Id),
                        i_Intersect_Id => v_Intersect_Id,
                        i_Change_Date  => v_Error_Date);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Full_Time
  (
    i_Day_Kind         varchar2,
    i_Begin_Time       date,
    i_End_Time         date,
    i_Break_Begin_Time date,
    i_Break_End_Time   date
  ) return number is
  begin
    if i_Day_Kind in
       (Htt_Pref.c_Day_Kind_Rest, Htt_Pref.c_Day_Kind_Additional_Rest, Htt_Pref.c_Day_Kind_Holiday) then
      return 0;
    end if;
  
    return Nvl((i_End_Time - i_Begin_Time - Nvl(i_Break_End_Time - i_Break_Begin_Time, 0)) * 1440,
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Time difference in seconds
  ----------------------------------------------------------------------------------------------------
  Function Time_Diff
  (
    i_Time1 date,
    i_Time2 date
  ) return number is
  begin
    return Greatest(Round((i_Time1 - i_Time2) * 86400), 0);
  end;

  ----------------------------------------------------------------------------------------------------
  -- intersection part of two timelines
  ----------------------------------------------------------------------------------------------------
  Function Timeline_Intersection
  (
    i_Fr_Begin date,
    i_Fr_End   date,
    i_Sc_Begin date,
    i_Sc_End   date
  ) return number is
  begin
    if i_Fr_Begin >= i_Fr_End or i_Sc_Begin >= i_Sc_End then
      return 0;
    end if;
  
    return Time_Diff(Least(i_Sc_End, Greatest(i_Fr_End, i_Sc_Begin)),
                     Greatest(Least(i_Fr_Begin, i_Sc_End), i_Sc_Begin));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Intime
  (
    i_Begin_Time       date,
    i_End_Time         date,
    i_Begin_Break_Time date,
    i_End_Break_Time   date,
    i_Input            date,
    i_Output           date
  ) return number is
  begin
    return Timeline_Intersection(i_Fr_Begin => i_Begin_Time,
                                 i_Fr_End   => i_End_Time,
                                 i_Sc_Begin => i_Input,
                                 i_Sc_End   => i_Output) - --
    Timeline_Intersection(i_Fr_Begin => i_Begin_Break_Time,
                          i_Fr_End   => i_End_Break_Time,
                          i_Sc_Begin => i_Input,
                          i_Sc_End   => i_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Track_Date date
  ) return number is
    result number;
  begin
    select q.Track_Id
      into result
      from Htt_Gps_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = i_Person_Id
       and q.Track_Date = i_Track_Date;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Change(i_Change_Id number) return varchar2 is
    r_Change Htt_Plan_Changes%rowtype;
    result   varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Htt_Plan_Changes.Name)));
  
    r_Change := z_Htt_Plan_Changes.Take(i_Company_Id => Md_Env.Company_Id,
                                        i_Filial_Id  => Md_Env.Filial_Id,
                                        i_Change_Id  => i_Change_Id);
  
    if r_Change.Change_Id is null then
      return result;
    end if;
  
    return result || ': ' || t('# $1{staff_name} by $2{created_on}',
                               Href_Util.Staff_Name(i_Company_Id => r_Change.Company_Id,
                                                    i_Filial_Id  => r_Change.Filial_Id,
                                                    i_Staff_Id   => r_Change.Staff_Id),
                               r_Change.Created_On);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Request(i_Request_Id number) return varchar2 is
    r_Request Htt_Requests%rowtype;
    result    varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Htt_Requests.Name)));
  
    r_Request := z_Htt_Requests.Take(i_Company_Id => Md_Env.Company_Id,
                                     i_Filial_Id  => Md_Env.Filial_Id,
                                     i_Request_Id => i_Request_Id);
  
    if r_Request.Request_Id is null then
      return result;
    end if;
  
    return result || ': ' || t('# $1{staff_name} by $2{created_on}',
                               Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                                    i_Filial_Id  => r_Request.Filial_Id,
                                                    i_Staff_Id   => r_Request.Staff_Id),
                               r_Request.Created_On);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Track(i_Track_Id number) return varchar2 is
    r_Track Htt_Tracks%rowtype;
    result  varchar(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Htt_Tracks.Name)));
  
    r_Track := z_Htt_Tracks.Take(i_Company_Id => Md_Env.Company_Id,
                                 i_Filial_Id  => Md_Env.Filial_Id,
                                 i_Track_Id   => i_Track_Id);
  
    if r_Track.Track_Id is null then
      return result;
    end if;
  
    return result || ': ' || t('# $1{person_name} by $2{created_on}',
                               z_Mr_Natural_Persons.Take(i_Company_Id => r_Track.Company_Id, i_Person_Id => r_Track.Person_Id).Name,
                               r_Track.Created_On);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Kind_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Request_Kind_Id
      into result
      from Htt_Request_Kinds
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) return varchar2 is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Request_Id => i_Request_Id);
  
    return z_Htt_Request_Kinds.Load(i_Company_Id      => r_Request.Company_Id,
                                    i_Request_Kind_Id => r_Request.Request_Kind_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Nls_Language return varchar2 is
    v_Language varchar2(20);
  begin
    if Biruni_Route.Get_Lang_Code = 'en' then
      v_Language := 'english';
    elsif Biruni_Route.Get_Lang_Code = 'uz' then
      v_Language := '''latin uzbek''';
    else
      v_Language := 'russian';
    end if;
  
    return 'nls_date_language = ' || v_Language;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Time
  (
    i_Request_Type varchar2,
    i_Begin_Time   date,
    i_End_Time     date
  ) return varchar2 is
    v_Format       varchar2(20) := 'fmdd mon. yyyy';
    v_Nls_Language varchar2(100) := Get_Nls_Language;
  begin
    case i_Request_Type
      when Htt_Pref.c_Request_Type_Part_Of_Day then
        return t('$1{request_date}, $2{request_begin_time}-$3{request_end_time}',
                 to_char(i_Begin_Time, v_Format, v_Nls_Language),
                 to_char(i_Begin_Time, Href_Pref.c_Time_Format_Minute, v_Nls_Language),
                 to_char(i_End_Time, Href_Pref.c_Time_Format_Minute, v_Nls_Language));
      when Htt_Pref.c_Request_Type_Full_Day then
        return t('$1{request_date} (full day)', to_char(i_Begin_Time, v_Format, v_Nls_Language));
      else
        return t('$1{request_begin_date} - $2{request_end_date} ($3 days)',
                 to_char(i_Begin_Time, v_Format, v_Nls_Language),
                 to_char(i_End_Time, v_Format, v_Nls_Language),
                 Trunc(i_End_Time - i_Begin_Time) + 1);
    end case;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Requests_Time_Sum
  (
    i_Company_Id            number,
    i_Filial_Id             number,
    i_Timesheet_Id          number,
    i_Take_Turnout_Requests boolean := false
  ) return number is
    result                 number;
    v_Turnout_Time_Kind_Id number;
    v_Take_Turnout         varchar2(1) := 'N';
  begin
    v_Turnout_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    if i_Take_Turnout_Requests then
      v_Take_Turnout := 'Y';
    end if;
  
    select sum(t.Fact_Value)
      into result
      from Htt_Timesheet_Facts t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Timesheet_Id = i_Timesheet_Id
       and exists (select 1
              from Htt_Time_Kinds p
             where p.Company_Id = t.Company_Id
               and p.Time_Kind_Id = t.Time_Kind_Id
               and p.Requestable = 'Y'
               and (v_Take_Turnout = 'Y' or --
                   (v_Take_Turnout = 'N' and --
                   (p.Parent_Id is null or --
                   p.Parent_Id <> v_Turnout_Time_Kind_Id))));
  
    return Nvl(result, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  -- gets facts with children
  ----------------------------------------------------------------------------------------------------
  Function Get_Fact_Value
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date,
    i_Time_Kind_Id   number
  ) return number is
    result number;
  begin
    select sum(Tf.Fact_Value)
      into result
      from Htt_Timesheets t
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = t.Company_Id
       and Tf.Filial_Id = t.Filial_Id
       and Tf.Timesheet_Id = t.Timesheet_Id
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Tf.Company_Id
       and Tk.Time_Kind_Id = Tf.Time_Kind_Id
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date = i_Timesheet_Date
       and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = i_Time_Kind_Id;
  
    return Nvl(result, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Fact_Value
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Timesheet_Id  number,
    i_Time_Kind_Id  number,
    i_Take_Children boolean := false
  ) return number is
    r_Timesheet_Fact Htt_Timesheet_Facts%rowtype;
    v_Fact_Value     number;
    v_Children_Value number := 0;
  begin
    r_Timesheet_Fact := z_Htt_Timesheet_Facts.Take(i_Company_Id   => i_Company_Id,
                                                   i_Filial_Id    => i_Filial_Id,
                                                   i_Timesheet_Id => i_Timesheet_Id,
                                                   i_Time_Kind_Id => i_Time_Kind_Id);
  
    v_Fact_Value := Nvl(r_Timesheet_Fact.Fact_Value, 0);
  
    if i_Take_Children then
      select sum(t.Fact_Value)
        into v_Children_Value
        from Htt_Timesheet_Facts t
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Timesheet_Id = i_Timesheet_Id
         and exists (select 1
                from Htt_Time_Kinds p
               where p.Company_Id = t.Company_Id
                 and p.Time_Kind_Id = t.Time_Kind_Id
                 and p.Parent_Id = i_Time_Kind_Id);
    
      v_Children_Value := Nvl(v_Children_Value, 0);
    end if;
  
    v_Fact_Value := v_Fact_Value + v_Children_Value;
  
    return v_Fact_Value;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Full_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number
  ) return Htt_Pref.Timesheet_Aggregated_Fact_Nt is
    result Htt_Pref.Timesheet_Aggregated_Fact_Nt;
  begin
    select Nvl(q.Parent_Id, q.Time_Kind_Id), sum(q.Fact_Value)
      bulk collect
      into result
      from (select Tk.Parent_Id, Tk.Time_Kind_Id, f.Fact_Value
              from Htt_Timesheet_Facts f
              join Htt_Time_Kinds Tk
                on Tk.Company_Id = f.Company_Id
               and Tk.Time_Kind_Id = f.Time_Kind_Id
             where f.Company_Id = i_Company_Id
               and f.Filial_Id = i_Filial_Id
               and f.Timesheet_Id = i_Timesheet_Id
             order by Tk.Pcode) q
     group by Nvl(q.Parent_Id, q.Time_Kind_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  -- sum of time kind facts over period [i_Begin_Date, i_End_Date]
  -- only parent time kinds are taken
  -- if time kind is child (has parent_id) it is converted to its parent
  Function Get_Full_Facts
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Htt_Pref.Timesheet_Aggregated_Fact_Nt is
    result Htt_Pref.Timesheet_Aggregated_Fact_Nt;
  begin
    select Nvl(Tk.Parent_Id, Tk.Time_Kind_Id), sum(Tf.Fact_Value)
      bulk collect
      into result
      from Htt_Timesheet_Facts Tf
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Tf.Company_Id
       and Tk.Time_Kind_Id = Tf.Time_Kind_Id
      join Htt_Timesheets t
        on t.Company_Id = Tf.Company_Id
       and t.Filial_Id = Tf.Filial_Id
       and t.Timesheet_Id = Tf.Timesheet_Id
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date >= i_Begin_Date
       and t.Timesheet_Date <= i_End_Date
     group by Nvl(Tk.Parent_Id, Tk.Time_Kind_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Turnout_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number is
    v_Turnout_Count number;
    v_Turnout_Ids   Array_Number;
  begin
    v_Turnout_Ids := Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                              i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    select max(Qr.Cnt)
      into v_Turnout_Count
      from (select count(*) Cnt
              from Htt_Timesheets t
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Employee_Id = i_Employee_Id
               and t.Timesheet_Date between i_Begin_Date and i_End_Date
               and exists (select *
                      from Htt_Timesheet_Facts Tf
                     where Tf.Company_Id = t.Company_Id
                       and Tf.Filial_Id = t.Filial_Id
                       and Tf.Timesheet_Id = t.Timesheet_Id
                       and Tf.Time_Kind_Id member of v_Turnout_Ids
                       and Tf.Fact_Value > 0)
             group by t.Staff_Id) Qr;
  
    return Nvl(v_Turnout_Count, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Locked_Turnout_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Turnout_Ids Array_Number;
    result        number;
  begin
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    select count(*)
      into result
      from Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and exists (select 1
              from Htt_Timesheet_Locks Tl
             where Tl.Company_Id = t.Company_Id
               and Tl.Filial_Id = t.Filial_Id
               and Tl.Staff_Id = t.Staff_Id
               and Tl.Timesheet_Date = t.Timesheet_Date)
       and exists (select *
              from Htt_Timesheet_Facts Tf
             where Tf.Company_Id = t.Company_Id
               and Tf.Filial_Id = t.Filial_Id
               and Tf.Timesheet_Id = t.Timesheet_Id
               and Tf.Time_Kind_Id member of v_Turnout_Ids
               and Tf.Fact_Value > 0);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  -- calculates number of vacation days
  -- that has locked fact days
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Locked_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Turnout_Ids Array_Number;
    v_Rest_Days   Array_Number;
    v_Calendar_Id number;
    result        number;
  begin
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
    v_Calendar_Id := Htt_Util.Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id);
    v_Rest_Days   := Htt_Util.Calendar_Rest_Days(i_Company_Id  => i_Company_Id,
                                                 i_Filial_Id   => i_Filial_Id,
                                                 i_Calendar_Id => v_Calendar_Id);
  
    select count(*)
      into result
      from Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and (Trunc(t.Timesheet_Date) - Trunc(t.Timesheet_Date, 'iw') + 1) not member of
     v_Rest_Days
       and not exists
     (select *
              from Htt_Calendar_Days Cd
             where Cd.Company_Id = t.Company_Id
               and Cd.Filial_Id = t.Filial_Id
               and Cd.Calendar_Id = v_Calendar_Id
               and Cd.Calendar_Date = t.Timesheet_Date
               and Cd.Day_Kind in (Htt_Pref.c_Day_Kind_Holiday, Htt_Pref.c_Day_Kind_Additional_Rest))
       and exists (select 1
              from Htt_Timesheet_Locks Tl
             where Tl.Company_Id = t.Company_Id
               and Tl.Filial_Id = t.Filial_Id
               and Tl.Staff_Id = t.Staff_Id
               and Tl.Timesheet_Date = t.Timesheet_Date)
       and exists (select *
              from Htt_Timesheet_Facts Tf
             where Tf.Company_Id = t.Company_Id
               and Tf.Filial_Id = t.Filial_Id
               and Tf.Timesheet_Id = t.Timesheet_Id
               and Tf.Time_Kind_Id member of v_Turnout_Ids
               and Tf.Fact_Value > 0);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    result number;
  begin
    select count(*)
      into result
      from Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and t.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
       and t.Plan_Time > 0;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Seconds
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    result number;
  begin
    select sum(q.Plan_Time)
      into result
      from Htt_Timesheets q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Timesheet_Date between i_Begin_Date and i_End_Date
       and q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
       and q.Plan_Time > 0;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Vacation_Days_Count      number := i_End_Date - i_Begin_Date + 1;
    v_Official_Rest_Days_Count number;
    v_Default_Calendar_Id      number;
    v_Fact_Days                number;
  begin
    v_Default_Calendar_Id := Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id);
  
    v_Official_Rest_Days_Count := Official_Rest_Days_Count(i_Company_Id  => i_Company_Id,
                                                           i_Filial_Id   => i_Filial_Id,
                                                           i_Calendar_Id => v_Default_Calendar_Id,
                                                           i_Begin_Date  => i_Begin_Date,
                                                           i_End_Date    => i_End_Date);
  
    v_Fact_Days := Calc_Fact_Locked_Vacation_Days(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Begin_Date => i_Begin_Date,
                                                  i_End_Date   => i_End_Date);
  
    return Nvl(v_Vacation_Days_Count - v_Official_Rest_Days_Count - v_Fact_Days, 0);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Calc_Schedule_Plan
  (
    o_Plan_Days    out number,
    o_Plan_Minutes out number,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Schedule_Id  number,
    i_Period       date
  ) is
    v_Days_Cnt number;
  begin
    select count(*),
           count(case
                    when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                         q.Plan_Time > 0 then
                     1
                    else
                     null
                  end),
           sum(case
                  when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                       q.Plan_Time > 0 then
                   q.Plan_Time
                  else
                   null
                end)
      into v_Days_Cnt, o_Plan_Days, o_Plan_Minutes
      from Htt_Schedule_Days q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Schedule_Id = i_Schedule_Id
       and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon');
  
    if v_Days_Cnt <> Last_Day(i_Period) - Trunc(i_Period, 'Mon') + 1 then
      Htt_Error.Raise_103(i_Schedule_Name => z_Htt_Schedules.Load(i_Company_Id => i_Company_Id, --
                                             i_Filial_Id => i_Filial_Id, --
                                             i_Schedule_Id => i_Schedule_Id).Name,
                          i_Month         => i_Period);
    end if;
  
    o_Plan_Minutes := Nvl(o_Plan_Minutes, 0);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Calc_Staff_Plan
  (
    o_Plan_Days    out number,
    o_Plan_Minutes out number,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period       date
  ) is
    v_Days_Cnt number;
  begin
    select count(*),
           count(case
                    when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                         q.Plan_Time > 0 then
                     1
                    else
                     null
                  end),
           sum(case
                  when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                       q.Plan_Time > 0 then
                   q.Plan_Time
                  else
                   null
                end)
      into v_Days_Cnt, o_Plan_Days, o_Plan_Minutes
      from Htt_Staff_Schedule_Days q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon');
  
    if v_Days_Cnt <> Last_Day(i_Period) - Trunc(i_Period, 'Mon') + 1 then
      Htt_Error.Raise_104(i_Staff_Name => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                               i_Filial_Id  => i_Filial_Id,
                                                               i_Staff_Id   => i_Staff_Id),
                          i_Month      => i_Period);
    end if;
  
    o_Plan_Minutes := Nvl(o_Plan_Minutes, 0);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Calc_Robot_Plan
  (
    o_Plan_Days    out number,
    o_Plan_Minutes out number,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period       date
  ) is
    v_Robot_Id number;
    v_Days_Cnt number;
  begin
    select count(*),
           count(case
                    when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                         q.Plan_Time > 0 then
                     1
                    else
                     null
                  end),
           sum(case
                  when q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
                       q.Plan_Time > 0 then
                   q.Plan_Time
                  else
                   null
                end),
           max(p.Robot_Id)
      into v_Days_Cnt, o_Plan_Days, o_Plan_Minutes, v_Robot_Id
      from Hpd_Agreements_Cache p
      join Htt_Robot_Schedule_Days q
        on q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = p.Robot_Id
       and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon')
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and i_Period between p.Begin_Date and p.End_Date;
  
    if v_Days_Cnt <> Last_Day(i_Period) - Trunc(i_Period, 'Mon') + 1 then
      Htt_Error.Raise_106(i_Robot_Name => z_Mrf_Robots.Take(i_Company_Id => i_Company_Id, --
                                          i_Filial_Id => i_Filial_Id, --
                                          i_Robot_Id => v_Robot_Id).Name,
                          i_Month      => i_Period);
    end if;
  
    o_Plan_Minutes := Nvl(o_Plan_Minutes, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return number is
    v_Dummy number;
    result  number;
  begin
    if i_Schedule_Id =
       Schedule_Id(i_Company_Id => i_Company_Id, --
                   i_Filial_Id  => i_Filial_Id,
                   i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      Calc_Staff_Plan(o_Plan_Days    => result,
                      o_Plan_Minutes => v_Dummy,
                      i_Company_Id   => i_Company_Id,
                      i_Filial_Id    => i_Filial_Id,
                      i_Staff_Id     => i_Staff_Id,
                      i_Period       => i_Period);
    elsif i_Schedule_Id =
          Schedule_Id(i_Company_Id => i_Company_Id, --
                      i_Filial_Id  => i_Filial_Id,
                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      Calc_Robot_Plan(o_Plan_Days    => result,
                      o_Plan_Minutes => v_Dummy,
                      i_Company_Id   => i_Company_Id,
                      i_Filial_Id    => i_Filial_Id,
                      i_Staff_Id     => i_Staff_Id,
                      i_Period       => i_Period);
    else
      Calc_Schedule_Plan(o_Plan_Days    => result,
                         o_Plan_Minutes => v_Dummy,
                         i_Company_Id   => i_Company_Id,
                         i_Filial_Id    => i_Filial_Id,
                         i_Schedule_Id  => i_Schedule_Id,
                         i_Period       => i_Period);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Minutes
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return number is
    v_Dummy number;
    result  number;
  begin
    if i_Schedule_Id =
       Schedule_Id(i_Company_Id => i_Company_Id, --
                   i_Filial_Id  => i_Filial_Id,
                   i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      Calc_Staff_Plan(o_Plan_Days    => v_Dummy,
                      o_Plan_Minutes => result,
                      i_Company_Id   => i_Company_Id,
                      i_Filial_Id    => i_Filial_Id,
                      i_Staff_Id     => i_Staff_Id,
                      i_Period       => i_Period);
    elsif i_Schedule_Id =
          Schedule_Id(i_Company_Id => i_Company_Id, --
                      i_Filial_Id  => i_Filial_Id,
                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      Calc_Robot_Plan(o_Plan_Days    => v_Dummy,
                      o_Plan_Minutes => result,
                      i_Company_Id   => i_Company_Id,
                      i_Filial_Id    => i_Filial_Id,
                      i_Staff_Id     => i_Staff_Id,
                      i_Period       => i_Period);
    else
      Calc_Schedule_Plan(o_Plan_Days    => v_Dummy,
                         o_Plan_Minutes => result,
                         i_Company_Id   => i_Company_Id,
                         i_Filial_Id    => i_Filial_Id,
                         i_Schedule_Id  => i_Schedule_Id,
                         i_Period       => i_Period);
    end if;
  
    return Nvl(result, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Time_Kind_Facts
  (
    o_Fact_Seconds out number,
    o_Fact_Days    out number,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Time_Kind_Id number,
    i_Begin_Date   date,
    i_End_Date     date
  ) is
    v_Tk_Ids Array_Number;
  begin
    select Tk.Time_Kind_Id
      bulk collect
      into v_Tk_Ids
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = i_Company_Id
       and Tk.Parent_Id = i_Time_Kind_Id;
  
    Fazo.Push(v_Tk_Ids, i_Time_Kind_Id);
  
    select sum(Tf.Fact_Value), count(distinct t.Timesheet_Id)
      into o_Fact_Seconds, o_Fact_Days
      from Htt_Timesheets t
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = t.Company_Id
       and Tf.Filial_Id = t.Filial_Id
       and Tf.Timesheet_Id = t.Timesheet_Id
       and Tf.Time_Kind_Id member of v_Tk_Ids
       and Tf.Fact_Value > 0
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date;
  
    o_Fact_Seconds := Nvl(o_Fact_Seconds, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Weighted_Turnout_Seconds
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    result number;
  begin
    select Nvl(sum(t.Coef * t.Weight *
                   Round(86400 * (t.Intersection_End - t.Intersection_Begin), 2)),
               0)
      into result
      from (select Tw.Coef,
                   Tw.Weight,
                   Least(Tw.End_Time, i.Interval_End) Intersection_End,
                   Greatest(Tw.Begin_Time, i.Interval_Begin) Intersection_Begin
              from Htt_Timesheets q
              join Htt_Timesheet_Intervals i
                on i.Company_Id = q.Company_Id
               and i.Filial_Id = q.Filial_Id
               and i.Timesheet_Id = q.Timesheet_Id
              join Htt_Timesheet_Weights Tw
                on Tw.Company_Id = q.Company_Id
               and Tw.Filial_Id = q.Filial_Id
               and Tw.Timesheet_Id = q.Timesheet_Id
               and Greatest(Tw.Begin_Time, i.Interval_Begin) < Least(Tw.End_Time, i.Interval_End)
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Staff_Id = i_Staff_Id
               and q.Timesheet_Date between i_Begin_Date and i_End_Date) t;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Undefined_Schedule
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Period      date
  ) return boolean is
    v_Days_Cnt number := 0;
  begin
    if i_Schedule_Id =
       Schedule_Id(i_Company_Id => i_Company_Id, --
                   i_Filial_Id  => i_Filial_Id,
                   i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      select count(*)
        into v_Days_Cnt
        from Htt_Staff_Schedule_Days q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon');
    elsif i_Schedule_Id =
          Schedule_Id(i_Company_Id => i_Company_Id, --
                      i_Filial_Id  => i_Filial_Id,
                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      select count(*)
        into v_Days_Cnt
        from Hpd_Agreements_Cache p
        join Htt_Robot_Schedule_Days q
          on q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Robot_Id = p.Robot_Id
         and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon')
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Staff_Id = i_Staff_Id
         and i_Period between p.Begin_Date and p.End_Date;
    else
      select count(*)
        into v_Days_Cnt
        from Htt_Schedule_Days q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Schedule_Id = i_Schedule_Id
         and Trunc(q.Schedule_Date, 'Mon') = Trunc(i_Period, 'Mon');
    end if;
  
    return v_Days_Cnt <> Last_Day(i_Period) - Trunc(i_Period, 'Mon') + 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Year_Last_Day(i_Date date) return date is
  begin
    return Add_Months(Trunc(i_Date, 'yyyy'), 12) - 1;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Quarter_Last_Day(i_Date date) return date is
  begin
    return Last_Day(Add_Months(Trunc(i_Date, 'Q'), 2));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Datas
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Only_Gps   varchar2 := 'Y'
  ) return Htt_Pref.Gps_Track_Data_Nt
    pipelined is
    v_Track         Htt_Pref.Gps_Track_Data_Rt;
    v_Track_Arr     Array_Varchar2;
    v_Len           number;
    v_Offset        number;
    v_Pos           pls_integer;
    v_Last_Pos      pls_integer;
    v_Part_Data     varchar2(32767);
    c_Row_Delimiter varchar(1) := Chr(10);
  begin
    v_Track.Company_Id := i_Company_Id;
    v_Track.Filial_Id  := i_Filial_Id;
    v_Track.Person_Id  := i_Person_Id;
  
    for Gps_Track in (select q.*,
                             (select w.Data
                                from Htt_Gps_Track_Datas w
                               where w.Company_Id = i_Company_Id
                                 and w.Filial_Id = i_Filial_Id
                                 and w.Track_Id = q.Track_Id) as Data
                        from Htt_Gps_Tracks q
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Person_Id = i_Person_Id
                         and q.Track_Date between i_Begin_Date and i_End_Date)
    loop
      if Dbms_Lob.Isopen(Gps_Track.Data) = 0 then
        Dbms_Lob.Open(Lob_Loc => Gps_Track.Data, Open_Mode => Dbms_Lob.Lob_Readonly);
      end if;
    
      v_Track.Track_Id   := Gps_Track.Track_Id;
      v_Track.Track_Date := Gps_Track.Track_Date;
    
      v_Offset := 1;
      v_Len    := Dbms_Lob.Getlength(Gps_Track.Data);
    
      while v_Offset < v_Len
      loop
        v_Part_Data := v_Part_Data ||
                       Utl_Raw.Cast_To_Varchar2(Dbms_Lob.Substr(Lob_Loc => Gps_Track.Data,
                                                                Amount  => 30000,
                                                                Offset  => v_Offset));
      
        v_Pos      := 1;
        v_Last_Pos := 1;
      
        loop
          v_Pos := Instr(v_Part_Data, Htt_Pref.c_Gps_Track_Row_Delimiter, v_Last_Pos);
        
          if v_Pos > 0 then
            v_Track_Arr := Fazo.Split(Substr(v_Part_Data, v_Last_Pos, v_Pos - v_Last_Pos),
                                      Htt_Pref.c_Gps_Track_Column_Delimiter);
          
            if v_Track_Arr.Count < 5 then
              v_Track_Arr.Extend(5); -- handling error
            end if;
          
            v_Track.Track_Time := to_date(to_char(v_Track.Track_Date, Href_Pref.c_Date_Format_Day) || ' ' ||
                                          v_Track_Arr(1),
                                          Href_Pref.c_Date_Format_Second);
            v_Track.Lat        := v_Track_Arr(2);
            v_Track.Lng        := v_Track_Arr(3);
            v_Track.Accuracy   := v_Track_Arr(4);
            v_Track.Provider   := Substr(v_Track_Arr(5), 1, 1);
            -- TODO: temporary provider filters only GPS
            if (i_Only_Gps = 'Y' and v_Track.Provider = Htt_Pref.c_Provider_Gps or i_Only_Gps = 'N') and
               v_Track.Accuracy <= 50 then
              pipe row(v_Track);
            end if;
          else
            v_Part_Data := Substr(v_Part_Data, v_Last_Pos);
            exit;
          end if;
        
          v_Last_Pos := v_Pos + Length(c_Row_Delimiter);
        end loop;
      
        v_Offset := v_Offset + 30000;
      end loop;
    
      Dbms_Lob.Close(Gps_Track.Data);
    end loop;
  
    return;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Schedule_Day
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Unit_Id    number,
    i_Date       date
  ) return Htt_Staff_Schedule_Days%rowtype is
    v_Staff_Schedule_Date Htt_Staff_Schedule_Days%rowtype;
  begin
    select *
      into v_Staff_Schedule_Date
      from Htt_Staff_Schedule_Days q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Unit_Id = i_Unit_Id
       and q.Schedule_Date = i_Date;
  
    return v_Staff_Schedule_Date;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Schedule_Day
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Unit_Id    number,
    i_Date       date
  ) return Htt_Robot_Schedule_Days%rowtype is
    v_Robot_Schedule_Date Htt_Robot_Schedule_Days%rowtype;
  begin
    select *
      into v_Robot_Schedule_Date
      from Htt_Robot_Schedule_Days q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Unit_Id = i_Unit_Id
       and q.Schedule_Date = i_Date;
  
    return v_Robot_Schedule_Date;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Distance
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    result number;
  begin
    select sum(q.Total_Distance)
      into result
      from Htt_Gps_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = i_Person_Id
       and q.Track_Date between i_Begin_Date and i_End_Date;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Gps_Track_Distance
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Track_Date date
  ) return number is
    result number;
  begin
    select Nvl(Trunc(sum(Power(Power(69.1 * (Lat2 - Lat1), 2) + Power(53.0 * (Lng2 - Lng1), 2), 0.5)) /
                     0.00062137),
               0)
      into result
      from (select Lat Lat1,
                   Lng Lng1,
                   Lag(Lat) Over(order by Rownum) Lat2,
                   Lag(Lng) Over(order by Rownum) Lng2
              from (select q.*
                      from Gps_Track_Datas(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Person_Id  => i_Person_Id,
                                           i_Begin_Date => i_Track_Date,
                                           i_End_Date   => i_Track_Date) q
                     order by q.Track_Time))
     where Lat2 is not null;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Sync_Global_Load
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Code       => Htt_Pref.c_Location_Sync_Person_Global),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Change_Monthly_Count
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Month      date
  ) return number is
    v_Change_Count number;
  begin
    select count(1)
      into v_Change_Count
      from Htt_Plan_Changes t
      join Htt_Change_Days q
        on q.Company_Id = t.Company_Id
       and q.Filial_Id = t.Filial_Id
       and q.Change_Id = t.Change_Id
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Status = Htt_Pref.c_Change_Status_Completed
       and q.Change_Date between Trunc(i_Month, 'mon') and Last_Day(i_Month)
       and (t.Change_Kind = Htt_Pref.c_Change_Kind_Change_Plan or q.Change_Date < q.Swapped_Date);
  
    return v_Change_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Change_Monthly_Count
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number,
    i_Month      date
  ) return number is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Count number;
  begin
    r_Change := z_Htt_Plan_Changes.Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Change_Id  => i_Change_Id);
    select count(1)
      into v_Change_Count
      from Htt_Plan_Changes t
      join Htt_Change_Days q
        on q.Company_Id = t.Company_Id
       and q.Filial_Id = t.Filial_Id
       and q.Change_Id = t.Change_Id
     where t.Company_Id = r_Change.Company_Id
       and t.Filial_Id = r_Change.Filial_Id
       and t.Staff_Id = r_Change.Staff_Id
       and (t.Change_Id = r_Change.Change_Id or t.Status = Htt_Pref.c_Change_Status_Completed)
       and q.Change_Date between Trunc(i_Month, 'mon') and Last_Day(i_Month)
       and (t.Change_Kind = Htt_Pref.c_Change_Kind_Change_Plan or q.Change_Date < q.Swapped_Date);
  
    return v_Change_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  -- day kind
  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Work return varchar2 is
  begin
    return t('day_kind:work');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Rest return varchar2 is
  begin
    return t('day_kind:rest');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Additional_Rest return varchar2 is
  begin
    return t('day_kind:additional rest');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Holiday return varchar2 is
  begin
    return t('day_kind:holiday');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Nonworking return varchar2 is
  begin
    return t('day_kind:nonworking');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind_Swapped return varchar2 is
  begin
    return t('day_kind:swapped');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Kind(i_Day_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Day_Kind --
    when Htt_Pref.c_Day_Kind_Work then t_Day_Kind_Work --
    when Htt_Pref.c_Day_Kind_Rest then t_Day_Kind_Rest --
    when Htt_Pref.c_Day_Kind_Additional_Rest then t_Day_Kind_Additional_Rest --      
    when Htt_Pref.c_Day_Kind_Holiday then t_Day_Kind_Holiday --
    when Htt_Pref.c_Day_Kind_Nonworking then t_Day_Kind_Nonworking --
    when Htt_Pref.c_Day_Kind_Swapped then t_Day_Kind_Swapped --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Day_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Day_Kind_Work, --
                                          Htt_Pref.c_Day_Kind_Rest,
                                          Htt_Pref.c_Day_Kind_Additional_Rest,
                                          Htt_Pref.c_Day_Kind_Holiday,
                                          Htt_Pref.c_Day_Kind_Nonworking,
                                          Htt_Pref.c_Day_Kind_Swapped),
                           Array_Varchar2(t_Day_Kind_Work, --
                                          t_Day_Kind_Rest,
                                          t_Day_Kind_Additional_Rest,
                                          t_Day_Kind_Holiday,
                                          t_Day_Kind_Nonworking,
                                          t_Day_Kind_Swapped));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calendar_Day_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Day_Kind_Holiday,
                                          Htt_Pref.c_Day_Kind_Additional_Rest,
                                          Htt_Pref.c_Day_Kind_Nonworking,
                                          Htt_Pref.c_Day_Kind_Swapped),
                           Array_Varchar2(t_Day_Kind_Holiday,
                                          t_Day_Kind_Additional_Rest,
                                          t_Day_Kind_Nonworking,
                                          t_Day_Kind_Swapped));
  end;

  ----------------------------------------------------------------------------------------------------
  -- pattern kind (translate message should be renamed to pattern kind)
  ----------------------------------------------------------------------------------------------------
  Function t_Pattern_Kind_Weekly return varchar2 is
  begin
    return t('schedule_kind:weekly');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Pattern_Kind_Periodic return varchar2 is
  begin
    return t('schedule_kind:periodic');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Pattern_Kind(i_Pattern_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Pattern_Kind --
    when Htt_Pref.c_Pattern_Kind_Weekly then t_Pattern_Kind_Weekly --
    when Htt_Pref.c_Pattern_Kind_Periodic then t_Pattern_Kind_Periodic --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Pattern_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Pattern_Kind_Weekly, --
                                          Htt_Pref.c_Pattern_Kind_Periodic),
                           Array_Varchar2(t_Pattern_Kind_Weekly, --
                                          t_Pattern_Kind_Periodic));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Schedule_Kind_Custom return varchar2 is
  begin
    return t('schedule_kind:custom');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Schedule_Kind_Flexible return varchar2 is
  begin
    return t('schedule_kind:flexible');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Schedule_Kind_Hourly return varchar2 is
  begin
    return t('schedule_kind:hourly');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Schedule_Kind(i_Schedule_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Schedule_Kind --
    when Htt_Pref.c_Schedule_Kind_Custom then t_Schedule_Kind_Custom --
    when Htt_Pref.c_Schedule_Kind_Flexible then t_Schedule_Kind_Flexible --
    when Htt_Pref.c_Schedule_Kind_Hourly then t_Schedule_Kind_Hourly --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Schedule_Kind_Custom, --
                                          Htt_Pref.c_Schedule_Kind_Flexible,
                                          Htt_Pref.c_Schedule_Kind_Hourly),
                           Array_Varchar2(t_Schedule_Kind_Custom, --
                                          t_Schedule_Kind_Flexible,
                                          t_Schedule_Kind_Hourly));
  end;

  ----------------------------------------------------------------------------------------------------
  -- protocol
  ----------------------------------------------------------------------------------------------------
  Function t_Protocol_Http return varchar2 is
  begin
    return t('protocol:http');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Protocol_Https return varchar2 is
  begin
    return t('protocol:https');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Protocol(i_Protocol varchar2) return varchar2 is
  begin
    return --
    case i_Protocol --
    when Htt_Pref.c_Protocol_Http then t_Protocol_Http --
    when Htt_Pref.c_Protocol_Https then t_Protocol_Https --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Protocols return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Protocol_Http, --
                                          Htt_Pref.c_Protocol_Https),
                           Array_Varchar2(t_Protocol_Http, --
                                          t_Protocol_Https));
  end;

  ----------------------------------------------------------------------------------------------------
  -- command kind
  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Update_Device return varchar2 is
  begin
    return t('command_kind: update device');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Update_All_Device_Persons return varchar2 is
  begin
    return t('command_kind: update all device persons');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Update_Person return varchar2 is
  begin
    return t('command_kind: update person');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Remove_Device return varchar2 is
  begin
    return t('command_kind: remove device');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Remove_Person return varchar2 is
  begin
    return t('command_kind: remove person');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind_Sync_Tracks return varchar2 is
  begin
    return t('command_kind: sync tracks');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Kind(i_Command_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Command_Kind --
    when Htt_Pref.c_Command_Kind_Update_Device then t_Command_Kind_Update_Device --
    when Htt_Pref.c_Command_Kind_Update_All_Device_Persons then t_Command_Kind_Update_All_Device_Persons --
    when Htt_Pref.c_Command_Kind_Update_Person then t_Command_Kind_Update_Person --
    when Htt_Pref.c_Command_Kind_Remove_Device then t_Command_Kind_Remove_Device --
    when Htt_Pref.c_Command_Kind_Remove_Person then t_Command_Kind_Remove_Person --
    when Htt_Pref.c_Command_Kind_Sync_Tracks then t_Command_Kind_Sync_Tracks --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Command_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Command_Kind_Update_Device,
                                          Htt_Pref.c_Command_Kind_Update_All_Device_Persons,
                                          Htt_Pref.c_Command_Kind_Update_Person,
                                          Htt_Pref.c_Command_Kind_Remove_Device,
                                          Htt_Pref.c_Command_Kind_Remove_Person,
                                          Htt_Pref.c_Command_Kind_Sync_Tracks),
                           Array_Varchar2(t_Command_Kind_Update_Device,
                                          t_Command_Kind_Update_All_Device_Persons,
                                          t_Command_Kind_Update_Person,
                                          t_Command_Kind_Remove_Device,
                                          t_Command_Kind_Remove_Person,
                                          t_Command_Kind_Sync_Tracks));
  end;

  ----------------------------------------------------------------------------------------------------
  -- command status
  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status_New return varchar2 is
  begin
    return t('command_status: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status_Sent return varchar2 is
  begin
    return t('command_status: sent');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status_Complited return varchar2 is
  begin
    return t('command_status: complited');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status_Failed return varchar2 is
  begin
    return t('command_status: failed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_Status(i_Command_Status varchar2) return varchar2 is
  begin
    return --
    case i_Command_Status --
    when Htt_Pref.c_Command_Status_New then t_Command_Status_New --
    when Htt_Pref.c_Command_Status_Sent then t_Command_Status_Sent --
    when Htt_Pref.c_Command_Status_Complited then t_Command_Status_Complited --
    when Htt_Pref.c_Command_Status_Failed then t_Command_Status_Failed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Command_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Command_Status_New,
                                          Htt_Pref.c_Command_Status_Sent,
                                          Htt_Pref.c_Command_Status_Complited,
                                          Htt_Pref.c_Command_Status_Failed),
                           Array_Varchar2(t_Command_Status_New,
                                          t_Command_Status_Sent,
                                          t_Command_Status_Complited,
                                          t_Command_Status_Failed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- person role
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Role_Admin return varchar2 is
  begin
    return t('person_role:admin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Role_Normal return varchar2 is
  begin
    return t('person_role:normal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Role(i_Person_Role varchar2) return varchar2 is
  begin
    return --
    case i_Person_Role --
    when Htt_Pref.c_Person_Role_Admin then t_Person_Role_Admin --
    when Htt_Pref.c_Person_Role_Normal then t_Person_Role_Normal --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Roles return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Person_Role_Admin, --
                                          Htt_Pref.c_Person_Role_Normal),
                           Array_Varchar2(t_Person_Role_Admin, --
                                          t_Person_Role_Normal));
  end;

  ----------------------------------------------------------------------------------------------------
  -- track type
  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Input return varchar2 is
  begin
    return t('track_type:input');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Output return varchar2 is
  begin
    return t('track_type:output');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Check return varchar2 is
  begin
    return t('track_type:check');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Merger return varchar2 is
  begin
    return t('track_type:merger');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Potential_Output return varchar2 is
  begin
    return t('track_type:potential');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type_Gps_Output return varchar2 is
  begin
    return t('track_type:potential gps output');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Type(i_Track_Type varchar2) return varchar2 is
  begin
    return --
    case i_Track_Type --
    when Htt_Pref.c_Track_Type_Input then t_Track_Type_Input --
    when Htt_Pref.c_Track_Type_Output then t_Track_Type_Output --
    when Htt_Pref.c_Track_Type_Check then t_Track_Type_Check --
    when Htt_Pref.c_Track_Type_Merger then t_Track_Type_Merger --
    when Htt_Pref.c_Track_Type_Potential_Output then t_Track_Type_Potential_Output --
    when Htt_Pref.c_Track_Type_Gps_Output then t_Track_Type_Gps_Output --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Track_Type_Input,
                                          Htt_Pref.c_Track_Type_Output,
                                          Htt_Pref.c_Track_Type_Check,
                                          Htt_Pref.c_Track_Type_Merger,
                                          Htt_Pref.c_Track_Type_Potential_Output,
                                          Htt_Pref.c_Track_Type_Gps_Output),
                           Array_Varchar2(t_Track_Type_Input,
                                          t_Track_Type_Output,
                                          t_Track_Type_Check,
                                          t_Track_Type_Merger,
                                          t_Track_Type_Potential_Output,
                                          t_Track_Type_Gps_Output));
  end;

  ----------------------------------------------------------------------------------------------------
  -- provider
  ----------------------------------------------------------------------------------------------------
  Function t_Provider_Gps return varchar2 is
  begin
    return t('provider:gps');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Provider_Network return varchar2 is
  begin
    return t('provider:network');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Provider(i_Provider varchar2) return varchar2 is
  begin
    return --
    case i_Provider --
    when Htt_Pref.c_Provider_Gps then t_Provider_Gps --
    when Htt_Pref.c_Provider_Network then t_Provider_Network --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Providers return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Provider_Gps, --
                                          Htt_Pref.c_Provider_Network),
                           Array_Varchar2(t_Provider_Gps, --
                                          t_Provider_Network));
  end;

  ----------------------------------------------------------------------------------------------------
  -- mark type
  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Password return varchar2 is
  begin
    return t('mark_type:password');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Touch return varchar2 is
  begin
    return t('mark_type:touch');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Rfid_Card return varchar2 is
  begin
    return t('mark_type:rfid_card');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Qr_Code return varchar2 is
  begin
    return t('mark_type:qr_code');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Face return varchar2 is
  begin
    return t('mark_type:face');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Manual return varchar2 is
  begin
    return t('mark_type:manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type_Auto return varchar2 is
  begin
    return t('mark_type:auto');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mark_Type(i_Mark_Type varchar2) return varchar2 is
  begin
    return --
    case i_Mark_Type --
    when Htt_Pref.c_Mark_Type_Password then t_Mark_Type_Password --
    when Htt_Pref.c_Mark_Type_Touch then t_Mark_Type_Touch --
    when Htt_Pref.c_Mark_Type_Rfid_Card then t_Mark_Type_Rfid_Card --
    when Htt_Pref.c_Mark_Type_Qr_Code then t_Mark_Type_Qr_Code --
    when Htt_Pref.c_Mark_Type_Face then t_Mark_Type_Face --
    when Htt_Pref.c_Mark_Type_Manual then t_Mark_Type_Manual --
    when Htt_Pref.c_Mark_Type_Auto then t_Mark_Type_Auto --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Mark_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Mark_Type_Password,
                                          Htt_Pref.c_Mark_Type_Touch,
                                          Htt_Pref.c_Mark_Type_Rfid_Card,
                                          Htt_Pref.c_Mark_Type_Qr_Code,
                                          Htt_Pref.c_Mark_Type_Face,
                                          Htt_Pref.c_Mark_Type_Manual,
                                          Htt_Pref.c_Mark_Type_Auto),
                           Array_Varchar2(t_Mark_Type_Password,
                                          t_Mark_Type_Touch,
                                          t_Mark_Type_Rfid_Card,
                                          t_Mark_Type_Qr_Code,
                                          t_Mark_Type_Face,
                                          t_Mark_Type_Manual,
                                          t_Mark_Type_Auto));
  end;

  ----------------------------------------------------------------------------------------------------
  -- track status
  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status_Draft return varchar2 is
  begin
    return t('track_status:draft');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status_Not_Used return varchar2 is
  begin
    return t('track_status:not_used');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status_Partially_Used return varchar2 is
  begin
    return t('track_status:partially_used');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status_Used return varchar2 is
  begin
    return t('track_status:used');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Track_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Htt_Pref.c_Track_Status_Draft then t_Track_Status_Draft --
    when Htt_Pref.c_Track_Status_Not_Used then t_Track_Status_Not_Used --
    when Htt_Pref.c_Track_Status_Partially_Used then t_Track_Status_Partially_Used --
    when Htt_Pref.c_Track_Status_Used then t_Track_Status_Used --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Track_Status_Draft,
                                          Htt_Pref.c_Track_Status_Not_Used,
                                          Htt_Pref.c_Track_Status_Partially_Used,
                                          Htt_Pref.c_Track_Status_Used),
                           Array_Varchar2(t_Track_Status_Draft,
                                          t_Track_Status_Not_Used,
                                          t_Track_Status_Partially_Used,
                                          t_Track_Status_Used));
  end;

  ----------------------------------------------------------------------------------------------------
  -- plan load
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Load_Part return varchar2 is
  begin
    return t('plan_load:part');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Load_Full return varchar2 is
  begin
    return t('plan_load:full');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Load_Extra return varchar2 is
  begin
    return t('plan_load:extra');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Load(i_Plan_Load varchar2) return varchar2 is
  begin
    return case i_Plan_Load --
    when Htt_Pref.c_Plan_Load_Part then t_Plan_Load_Part --
    when Htt_Pref.c_Plan_Load_Full then t_Plan_Load_Full --
    when Htt_Pref.c_Plan_Load_Extra then t_Plan_Load_Extra --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Loads return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Plan_Load_Part,
                                          Htt_Pref.c_Plan_Load_Full,
                                          Htt_Pref.c_Plan_Load_Extra),
                           Array_Varchar2(t_Plan_Load_Part, --
                                          t_Plan_Load_Full, --
                                          t_Plan_Load_Extra));
  end;

  ----------------------------------------------------------------------------------------------------
  -- day count type
  ----------------------------------------------------------------------------------------------------
  Function t_Day_Count_Type_Calendar_Days return varchar2 is
  begin
    return t('day_count_type:calendar days');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Count_Type_Work_Days return varchar2 is
  begin
    return t('day_count_type:work days');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Count_Type_Production_Days return varchar2 is
  begin
    return t('day_count_type:production days');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Day_Count_Type(i_Day_Count_Type varchar2) return varchar2 is
  begin
    return case i_Day_Count_Type --
    when Htt_Pref.c_Day_Count_Type_Calendar_Days then t_Day_Count_Type_Calendar_Days --
    when Htt_Pref.c_Day_Count_Type_Work_Days then t_Day_Count_Type_Work_Days --
    when Htt_Pref.c_Day_Count_Type_Production_Days then t_Day_Count_Type_Production_Days end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Day_Count_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Day_Count_Type_Calendar_Days,
                                          Htt_Pref.c_Day_Count_Type_Work_Days,
                                          Htt_Pref.c_Day_Count_Type_Production_Days),
                           Array_Varchar2(t_Day_Count_Type_Calendar_Days,
                                          t_Day_Count_Type_Work_Days,
                                          t_Day_Count_Type_Production_Days));
  end;

  ----------------------------------------------------------------------------------------------------
  -- carryover policy
  ----------------------------------------------------------------------------------------------------
  Function t_Carryover_Policy_All return varchar2 is
  begin
    return t('carryover_policy: all');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Carryover_Policy_Zero return varchar2 is
  begin
    return t('carryover_policy: zero');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Carryover_Policy_Cap return varchar2 is
  begin
    return t('carryover_policy: cap');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Carryover_Policy(i_Carryover_Policy varchar2) return varchar2 is
  begin
    return case i_Carryover_Policy --
    when Htt_Pref.c_Carryover_Policy_All then t_Carryover_Policy_All --
    when Htt_Pref.c_Carryover_Policy_Zero then t_Carryover_Policy_Zero --
    when Htt_Pref.c_Carryover_Policy_Cap then t_Carryover_Policy_Cap end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Carryover_Policies return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Carryover_Policy_All,
                                          Htt_Pref.c_Carryover_Policy_Zero,
                                          Htt_Pref.c_Carryover_Policy_Cap),
                           Array_Varchar2(t_Carryover_Policy_All,
                                          t_Carryover_Policy_Zero,
                                          t_Carryover_Policy_Cap));
  end;

  ----------------------------------------------------------------------------------------------------
  -- request kind
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Type_Part_Of_Day return varchar2 is
  begin
    return t('request_type:part_of_day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Type_Full_Day return varchar2 is
  begin
    return t('request_type:full_day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Type_Multiple_Days return varchar2 is
  begin
    return t('request_type:multiple_days');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Type(i_Request_Type varchar2) return varchar2 is
  begin
    return case i_Request_Type --
    when Htt_Pref.c_Request_Type_Part_Of_Day then t_Request_Type_Part_Of_Day --
    when Htt_Pref.c_Request_Type_Full_Day then t_Request_Type_Full_Day --
    when Htt_Pref.c_Request_Type_Multiple_Days then t_Request_Type_Multiple_Days --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Request_Type_Part_Of_Day,
                                          Htt_Pref.c_Request_Type_Full_Day,
                                          Htt_Pref.c_Request_Type_Multiple_Days),
                           Array_Varchar2(t_Request_Type_Part_Of_Day,
                                          t_Request_Type_Full_Day,
                                          t_Request_Type_Multiple_Days));
  end;

  ----------------------------------------------------------------------------------------------------
  -- request status
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_New return varchar2 is
  begin
    return t('request_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_Approved return varchar2 is
  begin
    return t('request_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_Completed return varchar2 is
  begin
    return t('request_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_Denied return varchar2 is
  begin
    return t('request_status:denied');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status(i_Request_Status varchar2) return varchar2 is
  begin
    return case i_Request_Status --
    when Htt_Pref.c_Request_Status_New then t_Request_Status_New --
    when Htt_Pref.c_Request_Status_Approved then t_Request_Status_Approved --
    when Htt_Pref.c_Request_Status_Completed then t_Request_Status_Completed --
    when Htt_Pref.c_Request_Status_Denied then t_Request_Status_Denied --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Request_Status_New,
                                          Htt_Pref.c_Request_Status_Approved,
                                          Htt_Pref.c_Request_Status_Completed,
                                          Htt_Pref.c_Request_Status_Denied),
                           Array_Varchar2(t_Request_Status_New,
                                          t_Request_Status_Approved,
                                          t_Request_Status_Completed,
                                          t_Request_Status_Denied));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Notification_Title
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Notify_Type     varchar2,
    t_Request_Kind_Id number
  ) return varchar2 is
    v_Request_Type varchar2(100);
  begin
    v_Request_Type := z_Htt_Request_Kinds.Load(i_Company_Id => i_Company_Id, i_Request_Kind_Id => t_Request_Kind_Id).Name;
  
    case i_Notify_Type
      when Hes_Pref.c_Pref_Nt_Request then
        return t('for $1{person_name} $2{request_kind_name} saved',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 v_Request_Type);
      when Hes_Pref.c_Pref_Nt_Request_Change_Status then
        return t('for $1{person_name} $2{request_kind_name} status change',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 v_Request_Type);
      when Hes_Pref.c_Pref_Nt_Request_Manager_Approval then
        return t('for $1{person_name} $2{request_kind_name} approved',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 v_Request_Type);
    end case;
  end;

  ----------------------------------------------------------------------------------------------------
  -- attach types
  ----------------------------------------------------------------------------------------------------
  Function t_Attach_Type_Auto return varchar2 is
  begin
    return t('attach_type:auto');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attach_Type_Manual return varchar2 is
  begin
    return t('attach_type:manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attach_Type_Global return varchar2 is
  begin
    return t('attach_type:global');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attach_Type(i_Attach_Type varchar2) return varchar2 is
  begin
    return case i_Attach_Type --
    when Htt_Pref.c_Attach_Type_Manual then t_Attach_Type_Manual --
    when Htt_Pref.c_Attach_Type_Auto then t_Attach_Type_Auto --
    when Htt_Pref.c_Attach_Type_Global then t_Attach_Type_Global --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Attach_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Attach_Type_Manual,
                                          Htt_Pref.c_Attach_Type_Auto,
                                          Htt_Pref.c_Attach_Type_Global),
                           Array_Varchar2(t_Attach_Type_Manual,
                                          t_Attach_Type_Auto,
                                          t_Attach_Type_Global));
  end;

  ----------------------------------------------------------------------------------------------------
  -- change status
  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status_New return varchar2 is
  begin
    return t('change_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status_Approved return varchar2 is
  begin
    return t('change_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status_Completed return varchar2 is
  begin
    return t('change_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status_Denied return varchar2 is
  begin
    return t('change_status:denied');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Status(i_Change_Status varchar2) return varchar2 is
  begin
    return case i_Change_Status --
    when Htt_Pref.c_Change_Status_New then t_Change_Status_New --
    when Htt_Pref.c_Change_Status_Approved then t_Change_Status_Approved --
    when Htt_Pref.c_Change_Status_Completed then t_Change_Status_Completed --
    when Htt_Pref.c_Change_Status_Denied then t_Change_Status_Denied --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Change_Status_New,
                                          Htt_Pref.c_Change_Status_Approved,
                                          Htt_Pref.c_Change_Status_Completed,
                                          Htt_Pref.c_Change_Status_Denied),
                           Array_Varchar2(t_Change_Status_New,
                                          t_Change_Status_Approved,
                                          t_Change_Status_Completed,
                                          t_Change_Status_Denied));
  end;

  ----------------------------------------------------------------------------------------------------
  -- change kind
  ----------------------------------------------------------------------------------------------------
  Function t_Change_Kind_Swap return varchar2 is
  begin
    return t('change_kind:swap');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Kind_Change_Plan return varchar2 is
  begin
    return t('change_kind:change_plan');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Kind(i_Change_Kind varchar2) return varchar2 is
  begin
    return case i_Change_Kind --
    when Htt_Pref.c_Change_Kind_Swap then t_Change_Kind_Swap --
    when Htt_Pref.c_Change_Kind_Change_Plan then t_Change_Kind_Change_Plan --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Change_Kind_Swap,
                                          Htt_Pref.c_Change_Kind_Change_Plan),
                           Array_Varchar2(t_Change_Kind_Swap, --
                                          t_Change_Kind_Change_Plan));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Notification_Title
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Notify_Type varchar2,
    i_Change_Kind varchar2
  ) return varchar2 is
  begin
    case i_Notify_Type
      when Hes_Pref.c_Pref_Nt_Plan_Change then
        return t('for $1{person_name} $2{change_kind} saved',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 t_Change_Kind(i_Change_Kind));
      when Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change then
        return t('for $1{person_name} $2{change_kind} status changed',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 t_Change_Kind(i_Change_Kind));
      when Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval then
        return t('for $1{person_name} $2{change_kind} approved',
                 z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
                 t_Change_Kind(i_Change_Kind));
    end case;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  -- dashboard status kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Worktime_Not_Started return varchar2 is
  begin
    return t('dashboard:working time not begin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Leave_Exists return varchar2 is
  begin
    return t('dashboard:leave');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Staff_Late return varchar2 is
  begin
    return t('dashboard:late');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Staff_Intime return varchar2 is
  begin
    return t('dashboard:intime');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Staff_Not_Come return varchar2 is
  begin
    return t('dashboard:not come');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Rest_Day return varchar2 is
  begin
    return t('dashboard:rest day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Additional_Rest_Day return varchar2 is
  begin
    return t('dashboard:additional rest day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Holiday return varchar2 is
  begin
    return t('dashboard:holiday');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Nonworking_Day return varchar2 is
  begin
    return t('dashboard:nonworking day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Not_Licensed_Day return varchar2 is
  begin
    return t('dashboard: not licensed day');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_No_Timesheet return varchar2 is
  begin
    return t('dashboard:no timesheet');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dashboard_Status_Kinds(i_Dashboard_Status_Kinds varchar2) return varchar2 is
  begin
    return case i_Dashboard_Status_Kinds --
    when Htt_Pref.c_Dashboard_Worktime_Not_Started then t_Dashboard_Worktime_Not_Started --
    when Htt_Pref.c_Dashboard_Leave_Exists then t_Dashboard_Leave_Exists --
    when Htt_Pref.c_Dashboard_Staff_Late then t_Dashboard_Staff_Late --
    when Htt_Pref.c_Dashboard_Staff_Intime then t_Dashboard_Staff_Intime --
    when Htt_Pref.c_Dashboard_Staff_Not_Come then t_Dashboard_Staff_Not_Come --
    when Htt_Pref.c_Dashboard_Rest_Day then t_Dashboard_Rest_Day --
    when Htt_Pref.c_Dashboard_Holiday then t_Dashboard_Holiday --
    when Htt_Pref.c_Dashboard_Additional_Rest_Day then t_Dashboard_Additional_Rest_Day --      
    when Htt_Pref.c_Dashboard_Nonworking_Day then t_Dashboard_Nonworking_Day --
    when Htt_Pref.c_Dashboard_Not_Licensed_Day then t_Dashboard_Not_Licensed_Day --
    when Htt_Pref.c_Dashboard_No_Timesheet then t_Dashboard_No_Timesheet --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dashboard_Status_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Dashboard_Worktime_Not_Started,
                                          Htt_Pref.c_Dashboard_Leave_Exists,
                                          Htt_Pref.c_Dashboard_Staff_Late,
                                          Htt_Pref.c_Dashboard_Staff_Intime,
                                          Htt_Pref.c_Dashboard_Staff_Not_Come,
                                          Htt_Pref.c_Dashboard_Rest_Day,
                                          Htt_Pref.c_Dashboard_Holiday,
                                          Htt_Pref.c_Dashboard_Additional_Rest_Day,
                                          Htt_Pref.c_Dashboard_Nonworking_Day,
                                          Htt_Pref.c_Dashboard_Not_Licensed_Day,
                                          Htt_Pref.c_Dashboard_No_Timesheet),
                           Array_Varchar2(t_Dashboard_Worktime_Not_Started, --
                                          t_Dashboard_Leave_Exists,
                                          t_Dashboard_Staff_Late,
                                          t_Dashboard_Staff_Intime,
                                          t_Dashboard_Staff_Not_Come,
                                          t_Dashboard_Rest_Day,
                                          t_Dashboard_Holiday,
                                          t_Dashboard_Additional_Rest_Day,
                                          t_Dashboard_Nonworking_Day,
                                          t_Dashboard_Not_Licensed_Day,
                                          t_Dashboard_No_Timesheet));
  end;

  ----------------------------------------------------------------------------------------------------
  -- request  accrual kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Accrual_Kind_Plan return varchar2 is
  begin
    return t('accrual_kind:plan');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Accrual_Kind_Carryover return varchar2 is
  begin
    return t('accrual_kind:carryover');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Accrual_Kinds(i_Accrual_Kind varchar2) return varchar2 is
  begin
    return case i_Accrual_Kind --
    when Htt_Pref.c_Accrual_Kind_Plan then t_Accrual_Kind_Plan --
    when Htt_Pref.c_Accrual_Kind_Carryover then t_Accrual_Kind_Carryover --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Accrual_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Accrual_Kind_Plan,
                                          Htt_Pref.c_Accrual_Kind_Carryover),
                           Array_Varchar2(t_Accrual_Kind_Plan, --
                                          t_Accrual_Kind_Carryover));
  end;

  ----------------------------------------------------------------------------------------------------
  -- acms track status
  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Track_Status_New return varchar2 is
  begin
    return t('acms_track_status: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Track_Status_Completed return varchar2 is
  begin
    return t('acms_track_status: completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Track_Status_Failed return varchar2 is
  begin
    return t('acms_track_status: failed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Track_Status(i_Track_Status varchar2) return varchar2 is
  begin
    return case i_Track_Status --
    when Htt_Pref.c_Acms_Track_Status_New then t_Acms_Track_Status_New --
    when Htt_Pref.c_Acms_Track_Status_Completed then t_Acms_Track_Status_Completed --
    when Htt_Pref.c_Acms_Track_Status_Failed then t_Acms_Track_Status_Failed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Acms_Track_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Acms_Track_Status_New,
                                          Htt_Pref.c_Acms_Track_Status_Completed,
                                          Htt_Pref.c_Acms_Track_Status_Failed),
                           Array_Varchar2(t_Acms_Track_Status_New,
                                          t_Acms_Track_Status_Completed,
                                          t_Acms_Track_Status_Failed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- acms mark type
  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Mark_Type_Touch return varchar2 is
  begin
    return t('acms_mark_type:touch');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Mark_Type_Face return varchar2 is
  begin
    return t('acms_mark_type:face');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Acms_Mark_Type(i_Mark_Type varchar2) return varchar2 is
  begin
    return case i_Mark_Type --
    when Htt_Pref.c_Acms_Mark_Type_Face then t_Acms_Mark_Type_Face --
    when Htt_Pref.c_Acms_Mark_Type_Touch then t_Acms_Mark_Type_Touch --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Acms_Mark_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Acms_Mark_Type_Face, --
                                          Htt_Pref.c_Acms_Mark_Type_Touch),
                           Array_Varchar2(t_Acms_Mark_Type_Face, --
                                          t_Acms_Mark_Type_Touch));
  end;

  ----------------------------------------------------------------------------------------------------
  -- location defined by
  ----------------------------------------------------------------------------------------------------
  Function t_Location_Defined_By_Gps return varchar2 is
  begin
    return t('location_defined_by:gps');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Location_Defined_By_Bssid return varchar2 is
  begin
    return t('location_defined_by:bssid');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Location_Defined_Type(i_Location_Defined_Type varchar2) return varchar2 is
  begin
    return case i_Location_Defined_Type --
    when Htt_Pref.c_Location_Defined_By_Gps then t_Location_Defined_By_Gps --
    when Htt_Pref.c_Location_Defined_By_Bssid then t_Location_Defined_By_Bssid --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Defined_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Location_Defined_By_Gps, --
                                          Htt_Pref.c_Location_Defined_By_Bssid),
                           Array_Varchar2(t_Location_Defined_By_Gps, --
                                          t_Location_Defined_By_Bssid));
  end;

  ----------------------------------------------------------------------------------------------------
  -- work statuses
  ----------------------------------------------------------------------------------------------------
  Function t_Work_Status_In return varchar2 is
  begin
    return t('work_status:in');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Work_Status_Out return varchar2 is
  begin
    return t('work_status:out');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Work_Status_Returned return varchar2 is
  begin
    return t('work_status:returned');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Work_Status(i_Work_Status varchar2) return varchar2 is
  begin
    return case i_Work_Status --
    when Htt_Pref.c_Work_Status_In then t_Work_Status_In --
    when Htt_Pref.c_Work_Status_Out then t_Work_Status_Out --
    when Htt_Pref.c_Work_Status_Returned then t_Work_Status_Returned --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Work_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Work_Status_In, --
                                          Htt_Pref.c_Work_Status_Out,
                                          Htt_Pref.c_Work_Status_Returned),
                           Array_Varchar2(t_Work_Status_In, --
                                          t_Work_Status_Out,
                                          t_Work_Status_Returned));
  end;

  ----------------------------------------------------------------------------------------------------
  -- device statuses
  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status_Online return varchar2 is
  begin
    return t('device_status:online');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Device_Status_Offline return varchar2 is
  begin
    return t('device_status:offline');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status_Unknown return varchar2 is
  begin
    return t('device_status:unknown');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status(i_Status varchar2) return varchar2 is
  begin
    return case i_Status --
    when Htt_Pref.c_Device_Status_Online then t_Device_Status_Online --
    when Htt_Pref.c_Device_Status_Offline then t_Device_Status_Offline --
    when Htt_Pref.c_Device_Status_Unknown then t_Device_Status_Unknown --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htt_Pref.c_Device_Status_Online,
                                          Htt_Pref.c_Device_Status_Offline,
                                          Htt_Pref.c_Device_Status_Unknown),
                           Array_Varchar2(t_Device_Status_Online,
                                          t_Device_Status_Offline,
                                          t_Device_Status_Unknown));
  end;

end Htt_Util;
/
