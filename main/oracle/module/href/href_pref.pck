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
    Note             varchar2(2000 char),
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
