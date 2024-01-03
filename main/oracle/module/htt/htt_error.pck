create or replace package Htt_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Staff_Name           varchar2,
    i_Timesheet_Date       date,
    i_Overtime_Exceed_Text varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Staff_Name     varchar2,
    i_Timesheet_Date date,
    i_Time_Kind_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Staff_Name           varchar2,
    i_Timesheet_Date       date,
    i_Schedule_Name        varchar2,
    i_Overtime_Exceed_Text varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Code varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011(i_Code varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012(i_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Schedule_Name varchar2,
    i_Schedule_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Template_Name varchar2,
    i_Day_No        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Name        varchar2,
    i_Request_Kind_Name varchar2,
    i_Year              date,
    i_Used_Cnt          number,
    i_Request_Cnt       number,
    i_Annual_Limit      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Staff_Name      varchar2,
    i_Intersect_Id    number,
    i_Intersect_Begin date,
    i_Intersect_End   date,
    i_Request_Type    varchar2,
    i_Begin_Time      date,
    i_End_Time        date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Chosen_Year   number,
    i_Calendar_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Calendar_Date date);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Calendar_Date date);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Calendar_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Chosen_Year   number,
    i_Schedule_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Day_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Day_No          number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Day_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Schedule_Date date);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Schedule_Date   date,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032(i_Day_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Day_No     number,
    i_Shift_Text varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Day_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Old_Parent_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037(i_Old_Plan_Load_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_038;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_039;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_040;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_041;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_042;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_043(i_Parent_Plan_Load varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_044(i_Time_Kind_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_045
  (
    i_Main_Photo_Cnt number,
    i_Person_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_046
  (
    i_Old_Pcode varchar2,
    i_Model_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_047;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_050;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055(i_Track_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056(i_Track_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057(i_Time_Kind_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058(i_Time_Kind_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059(i_Request_Kind_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Request_Status   varchar2,
    i_Request_Kind_New varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062(i_Allowed_Types Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_063
  (
    i_Request_Type      varchar2,
    i_Request_Type_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_064
  (
    i_Restriction_Days number,
    i_Request_Begin    date,
    i_Created_On       date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_065
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_066
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_067
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_068
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_069
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_070;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_071
  (
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_072(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_073;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_074
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_075
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_076
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_077
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_078
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_079;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_080;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_081;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_082
  (
    i_Location_Id   number,
    i_Location_Name varchar2,
    i_Created_On    date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_083;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_084;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_085
  (
    i_Chosen_Month  date,
    i_Schedule_Date date,
    i_Staff_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_086;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_087;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_088;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_089
  (
    i_Staff_Name varchar2,
    i_Date       date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_090
  (
    i_Robot_Name varchar2,
    i_Date       date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_091
  (
    i_Date       date,
    i_Staff_Name varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_092
  (
    i_Date       date,
    i_Robot_Name varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_093;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_094(i_Date date);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_095
  (
    i_Date       date,
    i_Staff_Name varchar2,
    i_Robot_Name varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_096(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_097(i_Robot_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_099
  (
    i_Chosen_Month  date,
    i_Schedule_Date date,
    i_Robot_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_100
  (
    i_Staff_Name   varchar2,
    i_Intersect_Id number,
    i_Change_Date  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_101(i_Schedule_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_102(i_Schedule_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_103
  (
    i_Schedule_Name varchar2,
    i_Month         date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_104
  (
    i_Staff_Name varchar2,
    i_Month      date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_105
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_106
  (
    i_Robot_Name varchar2,
    i_Month      date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_107
  (
    i_Staff_Name     varchar2,
    i_Timesheet_Date date,
    i_Begin_Time     date,
    i_End_Time       date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_108;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_109(i_Min_Length number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_110(i_Min_Length number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_111(i_Schedule_Kind varchar2);

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_112
  (
    i_Restriction_Days number,
    i_Change_Day       date,
    i_Created_On       date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_113;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_114;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_115;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_116;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_117;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_118;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_119
  (
    i_Change_Date   date,
    i_Swapped_Date  date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_120
  (
    i_Change_Date   date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_121
  (
    i_Change_Date   date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_122
  (
    i_Schedule_Date date,
    i_Plan_Time     number,
    i_Limit_Time    number,
    i_Robot_Name    varchar2 := null,
    i_Staff_Name    varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_123
  (
    i_Month      varchar2,
    i_Plan_Days  number,
    i_Limit_Days number,
    i_Robot_Name varchar2 := null,
    i_Staff_Name varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_124(i_Day_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_125
  (
    i_Day_No          number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_126(i_Schedule_Date date);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_127
  (
    i_Schedule_Date   date,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_128
  (
    i_Schedule_Name varchar2,
    i_Schedule_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_129(i_Part_No number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_130
  (
    i_Part_No         number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_131(i_Change_Date date);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_132(i_Change_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_133
  (
    i_Employee_Name        varchar2,
    i_Change_Month         date,
    i_Change_Monthly_Limit number,
    i_Change_Monthly_Count number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_134(i_Currenct_Track_Type varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_135(i_New_Track_Type varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_136(i_Employee_Name varchar2);
end Htt_Error;
/
create or replace package body Htt_Error is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null,
    i_P6      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HTT:' || i_Message, Array_Varchar2(i_P1, i_P2, i_P3, i_P4, i_P5, i_P6));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Error
  (
    i_Code    varchar2,
    i_Message varchar2,
    i_Title   varchar2 := null,
    i_S1      varchar2 := null,
    i_S2      varchar2 := null,
    i_S3      varchar2 := null,
    i_S4      varchar2 := null,
    i_S5      varchar2 := null
  ) is
  begin
    b.Raise_Extended(i_Code    => Verifix.Htt_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Title(i_Request_Status varchar2) return varchar2 is
  begin
    case i_Request_Status
      when Htt_Pref.c_Request_Status_New then
        return t('title:request_status:new');
      when Htt_Pref.c_Request_Status_Approved then
        return t('title:request_status:approved');
      when Htt_Pref.c_Request_Status_Completed then
        return t('title:request_status:completed');
      when Htt_Pref.c_Request_Status_Denied then
        return t('title:request_status:denied');
      else
        b.Raise_Not_Implemented;
    end case;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Change_Title(i_Request_Status varchar2) return varchar2 is
  begin
    case i_Request_Status
      when Htt_Pref.c_Request_Status_New then
        return t('title:request_status:new');
      when Htt_Pref.c_Request_Status_Approved then
        return t('title:request_status:approved');
      when Htt_Pref.c_Request_Status_Completed then
        return t('title:request_status:completed');
      when Htt_Pref.c_Request_Status_Denied then
        return t('title:request_status:denied');
      else
        b.Raise_Not_Implemented;
    end case;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:timesheet plan changes for staff $1{staff_name} on date $2{timesheet_date} are blocked by timebook on $3{timebook_month}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_Timebook_Month, 'month yyyy')),
          i_Title   => t('001:title:timesheet locked'),
          i_S1      => t('001:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:timesheet plan changes for staff $1{staff_name} on date $2{timesheet_date} are blocked by timebook on $3{timebook_month}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_Timebook_Month, 'month yyyy')),
          i_Title   => t('002:title:timesheet locked'),
          i_S1      => t('002:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Staff_Name           varchar2,
    i_Timesheet_Date       date,
    i_Overtime_Exceed_Text varchar2
  ) is
    v_t_Extra_Solution varchar2(250 char);
  begin
    if i_Overtime_Exceed_Text is not null then
      v_t_Extra_Solution := t('003:solution:reduce overtime by $1{overtime_exceed} and try again',
                              i_Overtime_Exceed_Text);
    end if;
  
    Error(i_Code    => '003',
          i_Message => t('003:message:overtime for staff $1{staff_name} exceeded free time on day $2{timesheet_date}',
                         i_Staff_Name,
                         i_Timesheet_Date),
          i_S1      => t('003:solution:increase free time on $1{timesheet_date} by adding missing tracks',
                         i_Timesheet_Date),
          i_S2      => v_t_Extra_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Staff_Name     varchar2,
    i_Timesheet_Date date,
    i_Time_Kind_Name varchar2
  ) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:fact value for $1{time_kind_name} exceeded 24 hours on timesheet $2{timesheet_date} for $3{staff_name}',
                         i_Time_Kind_Name,
                         i_Timesheet_Date,
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Staff_Name           varchar2,
    i_Timesheet_Date       date,
    i_Schedule_Name        varchar2,
    i_Overtime_Exceed_Text varchar2
  ) is
    v_t_Extra_Solution varchar2(250 char);
  begin
    if i_Overtime_Exceed_Text is not null then
      v_t_Extra_Solution := t('005:solution:reduce overtime by $1{overtime_exceed} and try again');
    end if;
  
    Error(i_Code    => '005',
          i_Message => t('005:message:overtime for staff $1{staff_name} exceeded free time on day $2{timesheet_date}',
                         i_Staff_Name,
                         i_Timesheet_Date),
          i_S1      => t('005:solution:increase free time on $1{timesheet_date} by adding missing tracks',
                         i_Timesheet_Date),
          i_S2      => t('005:solution:increase free time on $1{timesheet_date} by changing plan hours in schedule $2{schedule_name}',
                         i_Timesheet_Date,
                         i_Schedule_Name),
          i_S3      => v_t_Extra_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:request insertion for staff $1{staff_name} on date $2{timesheet_date} is blocked by timebook on $3{timebook_month}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_Timebook_Month, 'month yyyy')),
          i_Title   => t('006:title:timesheet locked'),
          i_S1      => t('006:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:track deletion for staff $1{staff_name} on date $2{timesheet_date} is blocked by timebook on $3{timebook_month}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_Timebook_Month, 'month yyyy')),
          i_Title   => t('007:title:timesheet locked'),
          i_S1      => t('007:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008 is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:{inserting overtime days} company id must be unique in dirty timesheet'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Code varchar2) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:cannot find location with $1{location_code}', i_Code),
          i_Title   => t('009:title:no data found'),
          i_S1      => t('009:solution:check code for correctness and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Name varchar2) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:cannot find location with $1{location_name}', i_Name),
          i_Title   => t('010:title:no data found'),
          i_S1      => t('010:solution:check name for correctness and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011(i_Code varchar2) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:cannot find schedule with $1{schedule_code}', i_Code),
          i_Title   => t('011:title:no data found'),
          i_S1      => t('011:solution:check code for correctness and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012(i_Name varchar2) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:cannot find schedule with $1{schedule_name}', i_Name),
          i_Title   => t('012:title:no data found'),
          i_S1      => t('012:solution:check name for correctness and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Schedule_Name varchar2,
    i_Schedule_Date date
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:marks for schedule $1{schedule_name} intersect on day $2{schedule_date}',
                         i_Schedule_Name,
                         i_Schedule_Date),
          i_S1      => t('013:solution:resolve intersection on $1{schedule_date} and try again',
                         i_Schedule_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Template_Name varchar2,
    i_Day_No        number
  ) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:marks for template $1{template_name} intersect on day $2{day_no}',
                         i_Template_Name,
                         i_Day_No),
          i_S1      => t('014:solution:resolve intersection on $1{day_no} and try again', i_Day_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name      varchar2,
    i_Timesheet_Date  date,
    i_Timebook_Number varchar2,
    i_Timebook_Month  date
  ) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:timesheet plan changes for staff $1{staff_name} on date $2{timesheet_date} are blocked by timebook on $3{timebook_month}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_Timebook_Month, 'month yyyy')),
          i_Title   => t('015:title:timesheet locked'),
          i_S1      => t('015:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Name        varchar2,
    i_Request_Kind_Name varchar2,
    i_Year              date,
    i_Used_Cnt          number,
    i_Request_Cnt       number,
    i_Annual_Limit      number
  ) is
    v_Exceed_Amount number := i_Used_Cnt + i_Request_Cnt - i_Annual_Limit;
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:staff $1{staff_name} request $2{request_kind_name} exceed annual limit $3{annual_limit} for year $4{exceed_year} by $5{exceed_amount}, used_amount:$6',
                         i_Staff_Name,
                         i_Request_Kind_Name,
                         i_Annual_Limit,
                         Extract(year from i_Year),
                         v_Exceed_Amount,
                         i_Used_Cnt),
          i_Title   => t('016:title:request annual limit exceeded'),
          i_S1      => t('016:solution:add annual limit for $1{request_kind_name}',
                         i_Request_Kind_Name),
          i_S2      => t('016:solution:decrease request days count by $1{exceed_amount}',
                         v_Exceed_Amount));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Staff_Name      varchar2,
    i_Intersect_Id    number,
    i_Intersect_Begin date,
    i_Intersect_End   date,
    i_Request_Type    varchar2,
    i_Begin_Time      date,
    i_End_Time        date
  ) is
  
    --------------------------------------------------
    Function Request_Time
    (
      i_Request_Type varchar2,
      i_Begin_Time   date,
      i_End_Time     date
    ) return varchar2 is
    begin
      case i_Request_Type
        when Htt_Pref.c_Request_Type_Part_Of_Day then
          return to_char(i_Begin_Time, 'fmdd mon (dy)') || to_char(i_Begin_Time, ', hh24:mi-') || to_char(i_End_Time,
                                                                                                          'hh24:mi');
        when Htt_Pref.c_Request_Type_Full_Day then
          return to_char(i_Begin_Time, 'fmdd mon (dy)');
        when Htt_Pref.c_Request_Type_Multiple_Days then
          return to_char(i_Begin_Time, 'fmdd mon (dy) - ') || to_char(i_End_Time, 'fmdd mon (dy)');
        else
          b.Raise_Not_Implemented;
      end case;
    
      return null;
    end;
  
    --------------------------------------------------
    Function Give_Solution return varchar2 is
      v_Begin_Inside boolean := i_Begin_Time between i_Intersect_Begin and i_Intersect_End;
      v_End_Inside   boolean := i_End_Time between i_Intersect_Begin and i_Intersect_End;
    begin
      case
        when v_Begin_Inside and not v_End_Inside then
          return t('017:solution:move request begin time after $1{intersect_end}', i_Intersect_End);
        when not v_Begin_Inside and v_End_Inside then
          return t('017:solution:move request end time before $1{intersect_start}',
                   i_Intersect_Begin);
        else
          return t('017:solution:move request out of $1{intersect_start} and $2{intersect_end}',
                   i_Intersect_Begin,
                   i_Intersect_End);
      end case;
    
      return null;
    end;
  
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:staff $1{staff_name} already has completed request during $2{request_time}',
                         i_Staff_Name,
                         Request_Time(i_Request_Type, i_Begin_Time, i_End_Time)),
          i_Title   => t('017:title:requests intersection'),
          i_S1      => t('017:solution:reset request with ID $1{request_id} and try again',
                         i_Intersect_Id),
          i_S2      => Give_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Chosen_Year   number,
    i_Calendar_Date date
  ) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:chosen year ($1{chosen_year}) and calendar date year ($2{calendar_date}) are different',
                         i_Chosen_Year,
                         i_Calendar_Date),
          i_S1      => t('018:solution:change chosen year and try again'),
          i_S2      => t('018:solution:remove $1{calendar_date} from calendar and try again',
                         i_Calendar_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Calendar_Date date) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message:date $1{calendar_date} was already used by another day',
                         i_Calendar_Date),
          i_S1      => t('019:solution:leave only one day with date $1{calendar_date}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Calendar_Date date) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:date $1{calendar_date} was already used by another day',
                         i_Calendar_Date),
          i_S1      => t('020:solution:leave only one day with date $1{calendar_date}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Calendar_Id number) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:cannot delete system calendar $1{calendar_id}', i_Calendar_Id),
          i_S1      => t('021:solution:remove this calendar from deletion list and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022 is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message:cannot change shift when schedule is attached to any staff'),
          i_Title   => t('022:title:used schedule'),
          i_S1      => t('022:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023 is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:cannot change track acceptance borders when schedule is attached to any staff'),
          i_Title   => t('023:title:used schedule'),
          i_S1      => t('023:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024 is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:cannot change track duration when schedule is attached to any staff'),
          i_Title   => t('024:title:used schedule'),
          i_S1      => t('024:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025 is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:cannot change fact settings when schedule is attached to any staff'),
          i_Title   => t('025:title:used schedule'),
          i_S1      => t('025:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Chosen_Year   number,
    i_Schedule_Date date
  ) is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:chosen year ($1{chosen_year}) and schedule date year ($2{schedule_date}) are different',
                         i_Chosen_Year,
                         i_Schedule_Date),
          i_S1      => t('026:solution:change chosen year and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Day_No number) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:marks begin time and end time is same on day $1{day_no}',
                         i_Day_No),
          i_S1      => t('027:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Day_No          number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  ) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:pattern mark outside of worktime on day $1{day_no}', i_Day_No),
          i_S1      => t('028:solution:set mark end time before work end time $1{end_time_value}',
                         i_End_Time_Text),
          i_S2      => t('028:solution:set mark begin time after work begin time $1{begin_time_value}',
                         i_Begin_Time_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Day_No number) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:found pattern mark available only on rest day on day $1{day_no}',
                         i_Day_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Schedule_Date date) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:marks begin time and end time is same on day $1{schedule_date}',
                         i_Schedule_Date),
          i_S1      => t('030:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Schedule_Date   date,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  ) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:pattern mark outside of worktime on day $1{schedule_date}',
                         i_Schedule_Date),
          i_S1      => t('031:solution:set mark end time before work end time $1{end_time_value}',
                         i_End_Time_Text),
          i_S2      => t('031:solution:set mark begin time after work begin time $1{begin_time_value}',
                         i_Begin_Time_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032(i_Day_No number) is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:marks begin time and end time is same on day $1{day_no}',
                         i_Day_No),
          i_S1      => t('032:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Day_No     number,
    i_Shift_Text varchar2
  ) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:pattern mark outside of shift on day $1{day_no}', i_Day_No),
          i_S1      => t('033:solution:set mark end time before $1{shift_value}', i_Shift_Text),
          i_S2      => t('033:solution:set mark begin time after $1{shift_value}', i_Shift_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Day_No number) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:found pattern mark available only on rest day on day $1{day_no}',
                         i_Day_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Old_Parent_Name varchar2) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:cannot change time kind parent'),
          i_S1      => t('035:solution:restore old parent ($1{old_parent_name}) and try again',
                         i_Old_Parent_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036 is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:cannot set parent for system time kind'),
          i_S1      => t('036:solution:remove parent and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037(i_Old_Plan_Load_Name varchar2) is
  begin
    Error(i_Code    => '037',
          i_Message => t('037:message:cannot change plan load of system time kind'),
          i_S1      => t('037:solution:restore old plan load ($1{old_plan_load}) and try again',
                         i_Old_Plan_Load_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_038 is
  begin
    Error(i_Code    => '038',
          i_Message => t('038:message:cannot change requestable type of system time kind'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_039 is
  begin
    Error(i_Code    => '039',
          i_Message => t('039:message:cannot create non system time kind without parent'),
          i_S1      => t('039:solution:set parent and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_040 is
  begin
    Error(i_Code => '040', i_Message => t('040:message:cannot create non requestable time kind'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_041 is
  begin
    Error(i_Code    => '041',
          i_Message => t('041:message:cannot set non system parent'),
          i_S1      => t('041:solution:choose another parent and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_042 is
  begin
    Error(i_Code    => '042',
          i_Message => t('042:message:cannot set second level parent'),
          i_S1      => t('042:solution:choose another parent and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_043(i_Parent_Plan_Load varchar2) is
  begin
    Error(i_Code    => '043',
          i_Message => t('043:message:time kind and its parent have different plan loads'),
          i_S1      => t('043:solution:set plan load to $1{parent_plan_load} and try again',
                         i_Parent_Plan_Load));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_044(i_Time_Kind_Id number) is
  begin
    Error(i_Code    => '044',
          i_Message => t('044:message:cannot delete system time kind $1{time_kind_id}',
                         i_Time_Kind_Id),
          i_S1      => t('044:solution:remove this time kind from deletion list and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_045
  (
    i_Main_Photo_Cnt number,
    i_Person_Name    varchar2
  ) is
  begin
    Error(i_Code    => '045',
          i_Message => t('045:message:found $1{main_photo_cnt} photos marked as main, only one photo can be main, person_name:$2',
                         i_Main_Photo_Cnt,
                         i_Person_Name),
          i_Title   => t('045:title:multiple main photos'),
          i_S1      => t('045:solution:unmark all photos and leave only one main photo'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_046
  (
    i_Old_Pcode varchar2,
    i_Model_Id  number
  ) is
  begin
    Error(i_Code    => '046',
          i_Message => t('046:message:cannot change terminal model pcode'),
          i_S1      => t('046:solution:restore old pcode ($1{old_pcode}) for terminal model with ID $2{model_id}',
                         i_Old_Pcode,
                         i_Model_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_047 is
  begin
    Error(i_Code    => '047',
          i_Message => t('047:message:terminal must have model selected'),
          i_Title   => t('047:title:null model value'),
          i_S1      => t('047:solution:set device{terminal} model and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048 is
  begin
    Error(i_Code    => '048',
          i_Message => t('048:message:location cannot be null'),
          i_Title   => t('048:title:null location value'),
          i_S1      => t('048:solution:set device location and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_050 is
  begin
    Error(i_Code    => '050',
          i_Message => t('050:message:timepad must have language selected'),
          i_Title   => t('050:title:null language value'),
          i_S1      => t('050:solution:set device{timepad} language and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051 is
  begin
    Error(i_Code    => '051',
          i_Message => t('051:message:terminal must have model selected'),
          i_Title   => t('051:title:null model value'),
          i_S1      => t('051:solution:set device{terminal} model and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052 is
  begin
    Error(i_Code    => '052',
          i_Message => t('052:message:location cannot be null'),
          i_Title   => t('052:title:null location value'),
          i_S1      => t('052:solution:set device location and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054 is
  begin
    Error(i_Code    => '054',
          i_Message => t('054:message:timepad must have language selected'),
          i_Title   => t('054:title:null language value'),
          i_S1      => t('054:solution:set device{timepad} language and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055(i_Track_Id number) is
  begin
    Error(i_Code    => '055',
          i_Message => t('055:message:track $1{track_id} is already valid', i_Track_Id),
          i_S1      => t('055:solution:remove track $1{track_id} from validation list and try again',
                         i_Track_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056(i_Track_Id number) is
  begin
    Error(i_Code    => '056',
          i_Message => t('056:message:track $1{track_id} is already invalid', i_Track_Id),
          i_S1      => t('056:solution:remove track $1{track_id} from invalidation list and try again',
                         i_Track_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057(i_Time_Kind_Name varchar2) is
  begin
    Error(i_Code    => '057',
          i_Message => t('057:message:cant change time kind for system defined request kind'),
          i_S1      => t('057:solution:restore old time kind ($1{time_kind_name}) and try again',
                         i_Time_Kind_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058(i_Time_Kind_Name varchar2) is
  begin
    Error(i_Code    => '058',
          i_Message => t('058:message:time kind $1{time_kind_name} is not requestable, it cannot be used for request kind',
                         i_Time_Kind_Name),
          i_S1      => t('058:solution:choose requestable time kind and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059(i_Request_Kind_Name varchar2) is
  begin
    Error(i_Code    => '059',
          i_Message => t('059:message:cant delete system defined request kind'),
          i_S1      => t('059:solution:remove request kind $1{request_kind_name} from deletion list and try again',
                         i_Request_Kind_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Request_Status   varchar2,
    i_Request_Kind_New varchar2
  ) is
  begin
    Error(i_Code    => '060',
          i_Message => t('060:message:to change/save request it shouldnt be approved, completed or denied {its status should be $1{request_status_new}}',
                         i_Request_Kind_New),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('060:solution:reset request and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '061',
          i_Message => t('061:message:request staff cannot be changed'),
          i_S1      => t('061:solution:restore old staff ($1{staff_name}) and try again',
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062(i_Allowed_Types Array_Varchar2) is
  begin
    Error(i_Code    => '062',
          i_Message => t('062:message:request type and time kind plan load dont match'),
          i_S1      => t('062:solution:change requets type to one of $1{request_types} and try again',
                         Fazo.Gather(i_Allowed_Types, ', ')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_063
  (
    i_Request_Type      varchar2,
    i_Request_Type_Name varchar2
  ) is
  
    --------------------------------------------------
    Function Request_Time_Msg return varchar2 is
    begin
      case i_Request_Type
        when Htt_Pref.c_Request_Type_Part_Of_Day then
          return t('063:request_time_msg:only part of day');
        when Htt_Pref.c_Request_Type_Full_Day then
          return t('063:request_time_msg:only one full day');
        when Htt_Pref.c_Request_Type_Multiple_Days then
          return t('063:request_time_msg:at least two days');
        else
          b.Raise_Not_Implemented;
      end case;
    
      return null;
    end;
  
  begin
    Error(i_Code    => '063',
          i_Message => t('063:message:when request type is $1{request_type_name} request time should take $2{request_time_msg}',
                         i_Request_Type_Name,
                         Request_Time_Msg),
          i_Title   => t('063:title:request time is wrong'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_064
  (
    i_Restriction_Days number,
    i_Request_Begin    date,
    i_Created_On       date
  ) is
    v_Restriction_Border date := Trunc(i_Created_On) + (i_Restriction_Days - 1);
  
    -------------------------------------------------- 
    Function Restriction_Reason return varchar2 is
      v_Restriction_Days number := Abs(i_Restriction_Days);
    begin
      if i_Restriction_Days > 0 then
        return t('064:restriction_reason:request should be created $1{restriction_days} days in advance of request begin date $2{request_begin_date}',
                 v_Restriction_Days,
                 Trunc(i_Request_Begin));
      end if;
    
      return t('064:restriction_reason:request cannot be created $1{restriction_days} days after requst begin date $2{request_begin_date}',
               v_Restriction_Days,
               Trunc(i_Request_Begin));
    end;
  
  begin
    Error(i_Code    => '064',
          i_Message => t('064:message:exceeded request restriction days, $1{restriction_reason}',
                         Restriction_Reason),
          i_Title   => t('064:title:request restriction days'),
          i_S1      => t('064:solution:move request begin time after $1{restriction_border}',
                         v_Restriction_Border));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_065
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '065',
          i_Message => t('065:message:to reset request it must be approved, completed or denied {its status should be $1{request_statuses}}',
                         Fazo.Gather(i_Request_Statuses, ', ')),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('065:solution:remove request (ID $1{request_id}) from reset list and try again',
                         i_Request_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_066
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '066',
          i_Message => t('066:message:to approve request it shouldnt be approved, completed or denied {its status should be $1{request_statuses}}',
                         Fazo.Gather(i_Request_Statuses, ', ')),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('066:solution:remove request (ID $1{request_id}) from approval list and try again',
                         i_Request_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_067
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '067',
          i_Message => t('067:message:to complete request it shouldnt be completed or denied {its status should be $1{request_statuses}}',
                         Fazo.Gather(i_Request_Statuses, ', ')),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('067:solution:remove request (ID $1{request_id}) from completion list and try again',
                         i_Request_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_068
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '068',
          i_Message => t('068:message:to deny request it shouldnt be completed or denied {its status should be $1{request_statuses}}',
                         Fazo.Gather(i_Request_Statuses, ', ')),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('068:solution:remove request (ID $1{request_id}) from denial list and try again',
                         i_Request_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_069
  (
    i_Request_Id       number,
    i_Request_Status   varchar2,
    i_Request_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '069',
          i_Message => t('069:message:to delete request it shouldnt be approved, completed or denied {its status should be $1{request_statuses}}',
                         Fazo.Gather(i_Request_Statuses, ', ')),
          i_Title   => t_Request_Title(i_Request_Status),
          i_S1      => t('069:solution:remove request (ID $1{request_id}) from deletion list and try again',
                         i_Request_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_070 is
  begin
    Error(i_Code    => '070',
          i_Message => t('070:message:change must have at least one change day'),
          i_Title   => t('070:title:no change days'),
          i_S1      => t('070:solution:add change days and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_071
  (
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '071',
          i_Message => t('071:message:to change/save plan change it shouldnt be completed, approved or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('071:solution:reset plan change and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_072(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '072',
          i_Message => t('072:message:plan change staff cannot be changed'),
          i_S1      => t('072:solution:restore old staff ($1{staff_name}) and try again',
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_073 is
  begin
    Error(i_Code    => '073',
          i_Message => t('073:message:one date has not changed date'),
          i_S1      => t('073:title:add changed date for date which has not change date'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_074
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '074',
          i_Message => t('074:message:to delete plan change it shouldnt be completed, approved or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('074:solution:remove plan change (ID $1{change_id}) from deletion list and try again',
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_075
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '075',
          i_Message => t('075:message:to reset plan change it shouldnt be approved, completed or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('075:solution:remove plan change (ID $1{change_id}) from reset list and try again',
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_076
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '076',
          i_Message => t('076:message:to approve plan change it shouldnt be approved, completed or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('076:solution:remove plan change (ID $1{change_id}) from approval list and try again',
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_077
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '077',
          i_Message => t('077:message:to complete plan change it shouldnt be completed or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('077:solution:remove plan change (ID $1{change_id}) from completion list and try again',
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_078
  (
    i_Change_Id       number,
    i_Change_Status   varchar2,
    i_Change_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '078',
          i_Message => t('078:message:to deny plan change it shouldnt be completed or denied {its status should be $1{change_statuses}}',
                         Fazo.Gather(i_Change_Statuses, ', ')),
          i_Title   => t_Change_Title(i_Change_Status),
          i_S1      => t('078:solution:remove plan change (ID $1{change_id}) from denial list and try again',
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_079 is
  begin
    Error(i_Code => '079', i_Message => t('079:message:pin autogenerate value must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_080 is
  begin
    Error(i_Code => '080', i_Message => t('080:message:photo as face rec value must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_081 is
  begin
    Error(i_Code    => '081',
          i_Message => t('081:message:plan load cannot be extra'),
          i_S1      => t('081:solution:set another time kind and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_082
  (
    i_Location_Id   number,
    i_Location_Name varchar2,
    i_Created_On    date
  ) is
  begin
    Error(i_Code    => '082',
          i_Message => t('082:message:qr code already deactivated, location_id:$1, location_name:$2, created_on:$3',
                         i_Location_Id,
                         i_Location_Name,
                         to_char(i_Created_On, Href_Pref.c_Date_Format_Second)));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_083 is
  begin
    Error(i_Code => '083', i_Message => t('083:message:cannot change posted, unpost first'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_084 is
  begin
    Error(i_Code    => '084',
          i_Message => t('084:message:cannot change registry kind, registry kinds must be same'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_085
  (
    i_Chosen_Month  date,
    i_Schedule_Date date,
    i_Staff_Name    varchar2
  ) is
  begin
    Error(i_Code    => '085',
          i_Message => t('085:message:chosen month for staff ($1{staff_name}) ($2{chosen_month}) and schedule date month ($3{schedule_date}) are different',
                         i_Staff_Name,
                         i_Chosen_Month,
                         i_Schedule_Date),
          i_S1      => t('085:solution:change chosen month and try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_086 is
  begin
    Error(i_Code    => '086',
          i_Message => t('086:message:cannot have robot unit in staff individual staff schedule'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_087 is
  begin
    Error(i_Code    => '087',
          i_Message => t('087:message:cannot have staff unit in robot individual robot schedule'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_088 is
  begin
    Error(i_Code => '088', i_Message => t('088:message:cannot delete posted schedule registry'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_089
  (
    i_Staff_Name varchar2,
    i_Date       date
  ) is
  begin
    Error(i_Code    => '089',
          i_Message => t('089:message:Date ($1{i_date}) is missing in staff individual schedule for staff ($2{i_staff_name})',
                         i_Date,
                         i_Staff_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_090
  (
    i_Robot_Name varchar2,
    i_Date       date
  ) is
  begin
    Error(i_Code    => '090',
          i_Message => t('090:message:Date ($1{i_date}) is missing in robot individual schedule for position: ($2{i_robot_name})',
                         i_Date,
                         i_Robot_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_091
  (
    i_Date       date,
    i_Staff_Name varchar2
  ) is
  begin
    Error(i_Code    => '091',
          i_Message => t('091:message:At the date of ($1{i_date}) marks of staff ($2{i_staff_name}) intersect',
                         i_Date,
                         i_Staff_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_092
  (
    i_Date       date,
    i_Robot_Name varchar2
  ) is
  begin
    Error(i_Code    => '092',
          i_Message => t('092:message:At the date of ($1{i_date}) marks of robot ($2{i_robot_name}) intersect',
                         i_Date,
                         i_Robot_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_093 is
  begin
    Error(i_Code => '093', i_Message => t('093:message:cannot post posted documnent'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_094(i_Date date) is
  begin
    Error(i_Code    => '094',
          i_Message => t('094:message:At the date of ($1{i_date}) there are no robot marks and no staff marks',
                         i_Date));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_095
  (
    i_Date       date,
    i_Staff_Name varchar2,
    i_Robot_Name varchar2
  ) is
  begin
    Error(i_Code    => '095',
          i_Message => t('095:message:At the date of ($1{i_date}) marks of staff ($2{i_staff_name}) and of robot ($3{i_robot_name}) are present',
                         i_Date,
                         i_Staff_Name,
                         i_Robot_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_096(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '096',
          i_Message => t('096:message:staff ($1{i_staff_name}) has at least two registries for individual schedule with intersecting dates.',
                         i_Staff_Name),
          i_S1      => t('096:Delete/unpost other registries then try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_097(i_Robot_Name varchar2) is
  begin
    Error(i_Code    => '097',
          i_Message => t('097:message:robot ($1{i_robot_name}) has at least two registries for individual schedule with intersecting date.',
                         i_Robot_Name),
          i_S1      => t('097:Delete/unpost other registries then try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_099
  (
    i_Chosen_Month  date,
    i_Schedule_Date date,
    i_Robot_Name    varchar2
  ) is
  begin
    Error(i_Code    => '99',
          i_Message => t('099:message:chosen month for robot ($1{robot_name}) ($2{chosen_month}) and schedule date month ($3{schedule_date}) are different',
                         i_Robot_Name,
                         i_Chosen_Month,
                         i_Schedule_Date),
          i_S1      => t('099:solution:change chosen month and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_100
  (
    i_Staff_Name   varchar2,
    i_Intersect_Id number,
    i_Change_Date  date
  ) is
  begin
    Error(i_Code    => '100',
          i_Message => t('100:message:staff $1{staff_name} already has approved plan change on $2{change_date}',
                         i_Staff_Name,
                         i_Change_Date),
          i_Title   => t('100:title:plan change intersection'),
          i_S1      => t('100:solution:reset change with ID $1{change_id} and try again',
                         i_Intersect_Id),
          i_S2      => t('100:solution:choose another change date'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_101(i_Schedule_Name varchar2) is
  begin
    Error(i_Code    => '101',
          i_Message => t('101:message:$1{schedule_name} is system schedule, system schedule cannot be edited',
                         i_Schedule_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_102(i_Schedule_Name varchar2) is
  begin
    Error(i_Code    => '102',
          i_Message => t('102:message:$1{schedule_name} is system schedule, system schedule cannot be deleted',
                         i_Schedule_Name),
          i_S1      => t('102:solution:exclude $1{schedule_name} from delete list'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_103
  (
    i_Schedule_Name varchar2,
    i_Month         date
  ) is
  begin
    Error(i_Code    => '103',
          i_Message => t('103:message:found undefined days in schedule $1{schedule_name} on $2{undefined_month}',
                         i_Schedule_Name,
                         to_char(i_Month, 'Month YYYY')),
          i_Title   => t('103:title:Undefined month'),
          i_S1      => t('103:solution:define all days in $1{undefined_month}',
                         to_char(i_Month, 'Month YYYY')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_104
  (
    i_Staff_Name varchar2,
    i_Month      date
  ) is
  begin
    Error(i_Code    => '104',
          i_Message => t('104:message:found undefined days in individual schedule for $1{staff_name} on $2{undefined_month}',
                         i_Staff_Name,
                         to_char(i_Month, 'Month YYYY')),
          i_Title   => t('104:title:Undefined month'),
          i_S1      => t('104:solution:define all days in $1{undefined_month}',
                         to_char(i_Month, 'Month YYYY')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_105
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  ) is
  begin
    Error(i_Code    => '105',
          i_Message => t('105:message:the person is not attached to the location where the device is installed, filial=$2, location=$1, person=$3',
                         
                         z_Md_Filials.Take        (i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Name,
                         z_Htt_Locations.Take     (i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id).Name,
                         z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id).Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_106
  (
    i_Robot_Name varchar2,
    i_Month      date
  ) is
  begin
    Error(i_Code    => '106',
          i_Message => t('106:message:found undefined days in individual schedule for $1{robot_name} on $2{undefined_month}',
                         i_Robot_Name,
                         to_char(i_Month, 'Month YYYY')),
          i_Title   => t('106:title:Undefined month'),
          i_S1      => t('106:solution:define all days in $1{undefined_month}',
                         to_char(i_Month, 'Month YYYY')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_107
  (
    i_Staff_Name     varchar2,
    i_Timesheet_Date date,
    i_Begin_Time     date,
    i_End_Time       date
  ) is
  begin
    Error(i_Code    => '107',
          i_Message => t('107:message:employee $1{staff_name} has worktime intersection on $2{intersection_date}, end time for previous date $3{end_time} comes after begin time for current date $4{begin_time}',
                         i_Staff_Name,
                         i_Timesheet_Date,
                         to_char(i_End_Time, Href_Pref.c_Date_Format_Minute),
                         to_char(i_Begin_Time, Href_Pref.c_Date_Format_Minute)),
          i_Title   => t('107:title:work time intersection'),
          i_S1      => t('107:solution:move schedule change date after closest rest day, so worktime will not intersect'),
          i_S2      => t('107:solution:move begin time for $1{work_day_date} after $2{end_time} to remove intersection',
                         i_Timesheet_Date,
                         i_End_Time),
          i_S3      => t('107:solution:move end time for $1{work_day_date} before $2{begin_time} to remove intersection',
                         i_Timesheet_Date - 1,
                         i_Begin_Time));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_108 is
  begin
    Error(i_Code    => '108',
          i_Message => t('108:message:max length of work day cannot exceed $1{max_length_limit} hours',
                         Htt_Pref.c_Max_Worktime_Length / 3600),
          i_Title   => t('108:title:worktime limit'),
          i_S1      => t('108:solution:reduce max length of work day {defined by track_duration} to be less than $1{max_length_limit} hours',
                         Htt_Pref.c_Max_Worktime_Length / 3600));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_109(i_Min_Length number) is
  begin
    Error(i_Code    => '109',
          i_Message => t('109:message:length of note is not enough, min length must be $1{min_length}',
                         i_Min_Length),
          i_Title   => t('109:title:length of note is not enough'),
          i_S1      => t('109:solution:enlarge note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_110(i_Min_Length number) is
  begin
    Error(i_Code    => '110',
          i_Message => t('110:message:length of note is not enough, min length must be $1{min_length}',
                         i_Min_Length),
          i_Title   => t('110:title:length of note is not enough'),
          i_S1      => t('110:solution:enlarge note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_111(i_Schedule_Kind varchar2) is
  begin
    Error(i_Code    => '111',
          i_Message => t('111:message:you do not have access $1{schedule_kind} kind of schedule',
                         i_Schedule_Kind));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_112
  (
    i_Restriction_Days number,
    i_Change_Day       date,
    i_Created_On       date
  ) is
    v_Restriction_Border date := Trunc(i_Created_On) + (i_Restriction_Days - 1);
  
    -------------------------------------------------- 
    Function Restriction_Reason return varchar2 is
      v_Restriction_Days number := Abs(i_Restriction_Days);
    begin
      if i_Restriction_Days > 0 then
        return t('112:message:restriction_reason:change should be created $1{restriction_days} days in advance of change day $2{change_day}',
                 v_Restriction_Days,
                 i_Change_Day);
      end if;
    
      return t('112:message:restriction_reason:change cannot be created $1{restriction_days} days after change day $2{change_day}',
               v_Restriction_Days,
               i_Change_Day);
    end;
  
  begin
    Error(i_Code    => '112',
          i_Message => Restriction_Reason,
          i_Title   => t('112:title:change restriction days'),
          i_S1      => t('112:solution:move change begin time after $1{restriction_border}',
                         v_Restriction_Border));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_113 is
  begin
    Error(i_Code    => '113',
          i_Message => t('113:message:cannot change allowed late time when schedule is attached to any staff'),
          i_Title   => t('113:title:used schedule'),
          i_S1      => t('113:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_114 is
  begin
    Error(i_Code    => '114',
          i_Message => t('114:message:cannot change allowed early time when schedule is attached to any staff'),
          i_Title   => t('114:title:used schedule'),
          i_S1      => t('114:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_115 is
  begin
    Error(i_Code    => '115',
          i_Message => t('115:message:cannot change begin late time when schedule is attached to any staff'),
          i_Title   => t('115:title:used schedule'),
          i_S1      => t('115:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_116 is
  begin
    Error(i_Code    => '116',
          i_Message => t('116:message:cannot change end early time when schedule is attached to any staff'),
          i_Title   => t('116:title:used schedule'),
          i_S1      => t('116:solution:remove schedule from all staffs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_117 is
  begin
    Error(i_Code    => '117',
          i_Message => t('117:message:cannot use advansed setting for $1{schedule_kind_name} schedule',
                         Htt_Util.t_Schedule_Kind(Htt_Pref.c_Schedule_Kind_Hourly)),
          i_Title   => t('117:title:used schedule'),
          i_S1      => t('117:solution:turn of advansed setting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_118 is
  begin
    Error(i_Code    => '118',
          i_Message => t('118:message:location sync person global must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_119
  (
    i_Change_Date   date,
    i_Swapped_Date  date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  ) is
  begin
    Error(i_Code    => '119',
          i_Message => t('119:message:if there is a monthly limit in the staff calendar, swapped days should be in one month.
                                        you cannot swap $1{change_date} with $2{swapped_day} as there is a monthly limit on staff calendar',
                         i_Change_Date,
                         i_Swapped_Date),
          i_Title   => t('119:title:swapped dates are in different months'),
          i_S1      => t('119:solution:turn off monthly limit from $1{calendar_name}',
                         i_Calendar_Name),
          i_S2      => t('119:solution:make the same month of swapped dates'),
          i_S3      => t('119:solution:remove $1{calendar_name} from $2{schedule_name}',
                         i_Calendar_Name,
                         i_Schedule_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_120
  (
    i_Change_Date   date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  ) is
  begin
    Error(i_Code    => '120',
          i_Message => t('120:message:plan time for $1{change_date} has exceeded the daily limit of calendar',
                         i_Change_Date),
          i_Title   => t('120:title:daily plan exceeded'),
          i_S1      => t('120:solution:turn off daily limit from $1{calendar_name}', i_Calendar_Name),
          i_S2      => t('120:solution:reduce plan time'),
          i_S3      => t('120:solution:remove $1{calendar_name} from $2{schedule_name}',
                         i_Calendar_Name,
                         i_Schedule_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_121
  (
    i_Change_Date   date,
    i_Calendar_Name varchar2,
    i_Schedule_Name varchar2
  ) is
  begin
    Error(i_Code    => '121',
          i_Message => t('121:message:because of monthly limit of calendar is on you cannot change day kind of $1{change_date}',
                         i_Change_Date),
          i_Title   => t('121:title:day kind changed'),
          i_S1      => t('121:solution:turn off monthly limit from $1{calendar_name}',
                         i_Calendar_Name),
          i_S2      => t('121:solution:do not change the day kind'),
          i_S3      => t('121:solution:remove $1{calendar_name} from $2{schedule_name}',
                         i_Calendar_Name,
                         i_Schedule_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_122
  (
    i_Schedule_Date date,
    i_Plan_Time     number,
    i_Limit_Time    number,
    i_Robot_Name    varchar2 := null,
    i_Staff_Name    varchar2 := null
  ) is
    v_Message varchar2(600);
  begin
    if i_Robot_Name is not null then
      v_Message := t('122:message:in $1{robot_name) schedule plan time has exceeded the limit of the calendar for $2{schedule_date}, plan_time = $3{plan_time}, limit_time = $4{limit_time}',
                     i_Robot_Name,
                     i_Schedule_Date,
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Plan_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false),
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Limit_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false));
    elsif i_Staff_Name is not null then
      v_Message := t('122:message:in $1{staff_name) schedule plan time has exceeded the limit of the calendar for $2{schedule_date}, plan_time = $3{plan_time}, limit_time = $4{limit_time}',
                     i_Robot_Name,
                     i_Schedule_Date,
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Plan_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false),
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Limit_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false));
    else
      v_Message := t('122:message:for $1{schedule_date}, plan time has exceeded the limit of the calendar, plan_time = $2{plan_time}, limit_time = $3{limit_time}',
                     i_Schedule_Date,
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Plan_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false),
                     Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Limit_Time * 60,
                                                   i_Show_Minutes => true,
                                                   i_Show_Words   => false));
    end if;
  
    Error(i_Code    => '122',
          i_Message => v_Message,
          i_Title   => t('122:title:daily plan time exceeded from calendar plan time'),
          i_S1      => t('122:solution:turn of daily limit from calendar'),
          i_S2      => t('122:solution:reduse daily plan time'),
          i_S3      => t('122:solution:remove calendar'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_123
  (
    i_Month      varchar2,
    i_Plan_Days  number,
    i_Limit_Days number,
    i_Robot_Name varchar2 := null,
    i_Staff_Name varchar2 := null
  ) is
    v_Message varchar2(600);
  begin
    if i_Robot_Name is not null then
      v_Message := t('123:message:in $1{robot_name} schedule, plan days count must be the same with plan day limit in calendar for $2{month}, plan days = $3{plan_day}, limit day = $4{limit_day}',
                     i_Robot_Name,
                     i_Month,
                     i_Plan_Days,
                     i_Limit_Days);
    elsif i_Staff_Name is not null then
      v_Message := t('123:message:in $1{staff_name} schedule, plan days count must be the same with plan day limit in calendar for $2{month}, plan days = $3{plan_day}, limit day = $4{limit_day}',
                     i_Staff_Name,
                     i_Month,
                     i_Plan_Days,
                     i_Limit_Days);
    else
      v_Message := t('123:message:plan days count must be the same with plan day limit in calendar for $1{month}, plan days = $2{plan_day}, limit day = $3{limit_day}',
                     i_Month,
                     i_Plan_Days,
                     i_Limit_Days);
    end if;
  
    Error(i_Code    => '123',
          i_Message => v_Message,
          i_Title   => t('123:title:monthly working day count is not the same with calendar day limit'),
          i_S1      => t('123:solution:turn of monthly limit from calendar'),
          i_S2      => t('123:solution:make the same working day count with working day limit of calendar'),
          i_S3      => t('123:solution:remove calendar'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_124(i_Day_No number) is
  begin
    Error(i_Code    => '124',
          i_Message => t('124:message:pattern weighted time part begin time and end time is same on day $1{day_no}',
                         i_Day_No),
          i_S1      => t('124:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_125
  (
    i_Day_No          number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  ) is
  begin
    Error(i_Code    => '125',
          i_Message => t('125:message:pattern weighted time part outside of worktime on day $1{day_no}',
                         i_Day_No),
          i_S1      => t('125:solution:set weighted time part end time before work end time $1{end_time_value}',
                         i_End_Time_Text),
          i_S2      => t('125:solution:set weighted time part begin time after work begin time $1{begin_time_value}',
                         i_Begin_Time_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_126(i_Schedule_Date date) is
  begin
    Error(i_Code    => '126',
          i_Message => t('126:message:weighted time part begin time and end time is same on day $1{schedule_date}',
                         i_Schedule_Date),
          i_S1      => t('126:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_127
  (
    i_Schedule_Date   date,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  ) is
  begin
    Error(i_Code    => '127',
          i_Message => t('127:message:weighted time part outside of worktime on day $1{schedule_date}',
                         i_Schedule_Date),
          i_S1      => t('127:solution:set weighted time part end time before work end time $1{end_time_value}',
                         i_End_Time_Text),
          i_S2      => t('127:solution:set weighted time part begin time after work begin time $1{begin_time_value}',
                         i_Begin_Time_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_128
  (
    i_Schedule_Name varchar2,
    i_Schedule_Date date
  ) is
  begin
    Error(i_Code    => '128',
          i_Message => t('128:message:weighted time part for schedule $1{schedule_name} intersect on day $2{schedule_date}',
                         i_Schedule_Name,
                         i_Schedule_Date),
          i_S1      => t('128:solution:resolve intersection on $1{schedule_date} and try again',
                         i_Schedule_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_129(i_Part_No number) is
  begin
    Error(i_Code    => '129',
          i_Message => t('129:message:change day weighted time part begin time and end time is same on part $1{part_no}',
                         i_Part_No),
          i_S1      => t('129:solution:fix begin and end time and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_130
  (
    i_Part_No         number,
    i_Begin_Time_Text varchar2,
    i_End_Time_Text   varchar2
  ) is
  begin
    Error(i_Code    => '130',
          i_Message => t('130:message:change day weighted time part outside of worktime on part $1{part_no}',
                         i_Part_No),
          i_S1      => t('130:solution:set weighted time part end time before work end time $1{end_time_value}',
                         i_End_Time_Text),
          i_S2      => t('130:solution:set weighted time part begin time after work begin time $1{begin_time_value}',
                         i_Begin_Time_Text));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_131(i_Change_Date date) is
  begin
    Error(i_Code    => '131',
          i_Message => t('131:message:weighted time part intersect on day $1{change_date}',
                         i_Change_Date),
          i_S1      => t('131:solution:resolve intersection on $1{change_date} and try again',
                         i_Change_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_132(i_Change_Id number) is
  begin
    Error(i_Code    => '132',
          i_Message => t('132:message:you cannot change weighted part if change status is $1{status_name}. change_id = $2{change_id}',
                         Htt_Util.t_Change_Status(Htt_Pref.c_Change_Status_Completed),
                         i_Change_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_133
  (
    i_Employee_Name        varchar2,
    i_Change_Month         date,
    i_Change_Monthly_Limit number,
    i_Change_Monthly_Count number
  ) is
  begin
    Error(i_Code    => '133',
          i_Message => t('133:message:the employee $1{employee_name} has exceeded the maximum allowed schedule changes limit by $2{exceeded_count}, allowed $3{monthly_limit}, for $4{month_year}',
                         i_Employee_Name,
                         i_Change_Monthly_Count - i_Change_Monthly_Limit,
                         i_Change_Monthly_Limit,
                         to_char(i_Change_Month, 'Month yyyy')),
          i_S1      => t('133:solution:try to exceed the maximum allowed limit from settings'),
          i_S2      => t('133:solution:try to cancel one of the change requests'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_134(i_Currenct_Track_Type varchar2) is
  begin
    Error(i_Code    => '134',
          i_Message => t('134:message:you can change track type only if currenct track type input, output or check, currenct track type: $1(current_track_type)',
                         i_Currenct_Track_Type));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_135(i_New_Track_Type varchar2) is
  begin
    Error(i_Code    => '135',
          i_Message => t('135:message:you can change track type to only input, output or check, new track type: $1(new_track_type)',
                         i_New_Track_Type));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_136(i_Employee_Name varchar2) is
  begin
    Error(i_Code    => '136',
          i_Message => t('136:message:since tracking is blocked for $1{employee_name}, it is forbidden to add a track to him',
                         i_Employee_Name),
          i_S1      => t('136:solution:unblock $1{employee_name} from tracking via employee_list and type again',
                         i_Employee_Name));
  end;

end Htt_Error;
/
