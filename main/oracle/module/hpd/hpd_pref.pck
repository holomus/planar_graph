create or replace package Hpd_Pref is
  ----------------------------------------------------------------------------------------------------
  type Contract_Rt is record(
    Contract_Number      varchar2(50 char),
    Contract_Date        date,
    Fixed_Term           varchar2(1),
    Expiry_Date          date,
    Fixed_Term_Base_Id   number,
    Concluding_Term      varchar2(300 char),
    Hiring_Conditions    varchar2(300 char),
    Other_Conditions     varchar2(300 char),
    Workplace_Equipment  varchar2(300 char),
    Representative_Basis varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  type Robot_Rt is record(
    Robot_Id        number,
    Division_Id     number,
    Job_Id          number,
    Org_Unit_Id     number,
    Rank_Id         number,
    Allow_Rank      varchar2(1),
    Wage_Scale_Id   number,
    Employment_Type varchar2(1),
    Fte_Id          number,
    Fte             number);
  ----------------------------------------------------------------------------------------------------
  type Page_Rt is record(
    Page_Id  number,
    Staff_Id number);
  type Page_Nt is table of Page_Rt;
  ---------------------------------------------------------------------------------------------------- 
  -- CV Contracts
  ----------------------------------------------------------------------------------------------------
  type Cv_Contract_Item_Rt is record(
    Contract_Item_Id number,
    name             varchar2(150 char),
    Quantity         number,
    Amount           number);
  type Cv_Contract_Item_Nt is table of Cv_Contract_Item_Rt;
  ---------------------------------------------------------------------------------------------------- 
  type Cv_Contract_File_Rt is record(
    File_Sha varchar2(64),
    Note     varchar2(300 char));
  type Cv_Contract_File_Nt is table of Cv_Contract_File_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Cv_Contract_Rt is record(
    Company_Id               number,
    Filial_Id                number,
    Contract_Id              number,
    Contract_Number          varchar2(50),
    Page_Id                  number,
    Division_Id              number,
    Person_Id                number,
    Begin_Date               date,
    End_Date                 date,
    Contract_Kind            varchar2(1),
    Contract_Employment_Kind varchar2(1),
    Access_To_Add_Item       varchar2(1),
    Early_Closed_Date        date,
    Early_Closed_Note        varchar2(300 char),
    Note                     varchar2(300 char),
    Items                    Cv_Contract_Item_Nt,
    Files                    Cv_Contract_File_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Hiring
  ----------------------------------------------------------------------------------------------------
  type Hiring_Rt is record(
    Page_Id              number,
    Employee_Id          number,
    Staff_Number         varchar2(50),
    Hiring_Date          date,
    Dismissal_Date       date,
    Trial_Period         number,
    Employment_Source_Id number,
    Schedule_Id          number,
    Currency_Id          number,
    Vacation_Days_Limit  number,
    Is_Booked            varchar2(1),
    Robot                Robot_Rt,
    Contract             Contract_Rt,
    Cv_Contract          Cv_Contract_Rt,
    Indicators           Href_Pref.Indicator_Nt,
    Oper_Types           Href_Pref.Oper_Type_Nt);
  type Hiring_Nt is table of Hiring_Rt;
  ----------------------------------------------------------------------------------------------------
  type Hiring_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Hirings         Hiring_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Transfer
  ----------------------------------------------------------------------------------------------------
  type Transfer_Rt is record(
    Page_Id             number,
    Transfer_Begin      date,
    Transfer_End        date,
    Staff_Id            number,
    Schedule_Id         number,
    Currency_Id         number,
    Vacation_Days_Limit number,
    Is_Booked           varchar2(1),
    Transfer_Reason     varchar2(300 char),
    Transfer_Base       varchar2(300 char),
    Robot               Robot_Rt,
    Contract            Contract_Rt,
    Indicators          Href_Pref.Indicator_Nt,
    Oper_Types          Href_Pref.Oper_Type_Nt);
  type Transfer_Nt is table of Transfer_Rt;
  ----------------------------------------------------------------------------------------------------
  type Transfer_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Transfers       Transfer_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Dismissal
  ----------------------------------------------------------------------------------------------------
  type Dismissal_Rt is record(
    Page_Id              number,
    Staff_Id             number,
    Dismissal_Date       date,
    Dismissal_Reason_Id  number,
    Employment_Source_Id number,
    Based_On_Doc         varchar2(300 char),
    Note                 varchar2(300 char));
  type Dismissal_Nt is table of Dismissal_Rt;
  ----------------------------------------------------------------------------------------------------
  type Dismissal_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Dismissals      Dismissal_Nt);
  ----------------------------------------------------------------------------------------------------  
  -- Wage Change
  ----------------------------------------------------------------------------------------------------  
  type Wage_Change_Rt is record(
    Page_Id     number,
    Staff_Id    number,
    Change_Date date,
    Currency_Id number,
    Indicators  Href_Pref.Indicator_Nt,
    Oper_Types  Href_Pref.Oper_Type_Nt);
  type Wage_Change_Nt is table of Wage_Change_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Wage_Change_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Wage_Changes    Wage_Change_Nt);
  ----------------------------------------------------------------------------------------------------  
  -- Rank Change
  ----------------------------------------------------------------------------------------------------  
  type Rank_Change_Rt is record(
    Page_Id     number,
    Staff_Id    number,
    Change_Date date,
    Rank_Id     number);
  type Rank_Change_Nt is table of Rank_Change_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Rank_Change_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Journal_Type_Id number,
    Source_Table    varchar2(100),
    Source_Id       number,
    Rank_Changes    Rank_Change_Nt);
  ----------------------------------------------------------------------------------------------------  
  -- Vacation limit change
  ----------------------------------------------------------------------------------------------------  
  type Limit_Change_Journal_Rt is record(
    Company_Id     number,
    Filial_Id      number,
    Journal_Id     number,
    Journal_Number varchar2(50 char),
    Journal_Date   date,
    Journal_Name   varchar2(150 char),
    Lang_Code      varchar2(10),
    Division_Id    number,
    Days_Limit     number,
    Change_Date    date,
    Pages          Page_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Schedule Change
  ----------------------------------------------------------------------------------------------------
  type Schedule_Change_Rt is record(
    Page_Id     number,
    Staff_Id    number,
    Schedule_Id number);
  type Schedule_Change_Nt is table of Schedule_Change_Rt;
  ----------------------------------------------------------------------------------------------------
  type Schedule_Change_Journal_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Journal_Id       number,
    Journal_Number   varchar2(50 char),
    Journal_Date     date,
    Journal_Name     varchar2(150 char),
    Lang_Code        varchar2(10),
    Division_Id      number,
    Begin_Date       date,
    End_Date         date,
    Schedule_Changes Schedule_Change_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Sick Leave
  ----------------------------------------------------------------------------------------------------
  type Sick_Leave_Rt is record(
    Timeoff_Id        number,
    Staff_Id          number,
    Reason_Id         number,
    Coefficient       number,
    Sick_Leave_Number varchar2(100 char),
    Begin_Date        date,
    End_Date          date,
    Shas              Array_Varchar2);
  type Sick_Leave_Nt is table of Sick_Leave_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Sick_Leave_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Sick_Leaves     Sick_Leave_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Businnes trip
  ----------------------------------------------------------------------------------------------------
  type Business_Trip_Rt is record(
    Timeoff_Id number,
    Staff_Id   number,
    Region_Ids Array_Number,
    Person_Id  number,
    Reason_Id  number,
    Begin_Date date,
    End_Date   date,
    Note       varchar2(300 char),
    Shas       Array_Varchar2);
  type Business_Trip_Nt is table of Business_Trip_Rt;
  ----------------------------------------------------------------------------------------------------
  type Business_Trip_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Business_Trips  Business_Trip_Nt);
  ----------------------------------------------------------------------------------------------------  
  -- Vacation
  ----------------------------------------------------------------------------------------------------
  type Vacation_Rt is record(
    Timeoff_Id   number,
    Staff_Id     number,
    Time_Kind_Id number,
    Begin_Date   date,
    End_Date     date,
    Shas         Array_Varchar2);
  type Vacation_Nt is table of Vacation_Rt;
  ----------------------------------------------------------------------------------------------------
  type Vacation_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Type_Id number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Vacations       Vacation_Nt);
  ----------------------------------------------------------------------------------------------------  
  -- Overtime 
  ---------------------------------------------------------------------------------------------------- 
  type Overtime_Rt is record(
    Overtime_Date    date,
    Overtime_Seconds number);
  type Overtime_Nt is table of Overtime_Rt;
  ----------------------------------------------------------------------------------------------------
  type Overtime_Staff_Rt is record(
    Staff_Id    number,
    month       date,
    Overtime_Id number,
    Overtimes   Overtime_Nt);
  type Overtime_Staff_Nt is table of Overtime_Staff_Rt;
  ----------------------------------------------------------------------------------------------------
  type Overtime_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Division_Id     number,
    Overtime_Staffs Overtime_Staff_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Timebook Adjustment
  ----------------------------------------------------------------------------------------------------
  type Adjustment_Kind_Rt is record(
    Kind         varchar2(1),
    Free_Time    number,
    Overtime     number,
    Turnout_Time number);
  type Adjustment_Kind_Nt is table of Adjustment_Kind_Rt;
  ----------------------------------------------------------------------------------------------------
  type Adjustment_Rt is record(
    Page_Id  number,
    Staff_Id number,
    Kinds    Adjustment_Kind_Nt);
  type Adjustment_Nt is table of Adjustment_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timebook_Adjustment_Journal_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Journal_Id      number,
    Journal_Number  varchar2(50 char),
    Journal_Date    date,
    Journal_Name    varchar2(150 char),
    Lang_Code       varchar2(10),
    Division_Id     number,
    Adjustment_Date date,
    Adjustments     Adjustment_Nt);
  ----------------------------------------------------------------------------------------------------
  type Transaction_Part_Rt is record(
    Part_Begin date,
    Part_End   date);
  type Transaction_Part_Nt is table of Transaction_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  type Agreement_Cache_Rt is record(
    Staff_Id    number,
    Robot_Id    number,
    Schedule_Id number,
    Begin_Date  date,
    End_Date    date);
  type Agreement_Cache_Nt is table of Agreement_Cache_Rt;
  ----------------------------------------------------------------------------------------------------
  type Application_Create_Robot_Rt is record(
    Company_Id     number(20),
    Filial_Id      number(20),
    Application_Id number(20),
    name           varchar2(200 char),
    Opened_Date    date,
    Division_Id    number(20),
    Job_Id         number(20),
    Quantity       number(20),
    Note           varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  type Application_Hiring_Rt is record(
    Company_Id      number(20),
    Filial_Id       number(20),
    Application_Id  number(20),
    Hiring_Date     date,
    Robot_Id        number(20),
    Note            varchar2(300 char),
    First_Name      varchar2(250 char),
    Last_Name       varchar2(250 char),
    Middle_Name     varchar2(250 char),
    Birthday        date,
    Gender          varchar2(1),
    Phone           varchar2(100 char),
    Email           varchar2(300),
    Photo_Sha       varchar2(64),
    Address         varchar2(500 char),
    Legal_Address   varchar2(300 char),
    Region_Id       number(20),
    Passport_Series varchar2(50 char),
    Passport_Number varchar2(50 char),
    Npin            varchar2(14 char),
    Iapa            varchar2(20 char),
    Employment_Type varchar2(1));
  ----------------------------------------------------------------------------------------------------
  type Application_Transfer_Unit_Rt is record(
    Application_Unit_Id number(20),
    Staff_Id            number(20),
    Transfer_Begin      date,
    Robot_Id            number(20),
    Note                varchar2(300 char));
  type Application_Transfer_Unit_Nt is table of Application_Transfer_Unit_Rt;
  ----------------------------------------------------------------------------------------------------
  type Application_Transfer_Rt is record(
    Company_Id     number(20),
    Filial_Id      number(20),
    Application_Id number(20),
    Transfer_Units Application_Transfer_Unit_Nt);
  ----------------------------------------------------------------------------------------------------
  type Application_Dismissal_Rt is record(
    Company_Id          number(20),
    Filial_Id           number(20),
    Application_Id      number(20),
    Staff_Id            number(20),
    Dismissal_Date      date,
    Dismissal_Reason_Id number(20),
    Note                varchar2(300 char));
  ----------------------------------------------------------------------------------------------------  
  -- Sigm Template 
  ----------------------------------------------------------------------------------------------------  
  type Sign_Template_Rt is record(
    Template        Mdf_Pref.Sign_Rt,
    Journal_Type_Id number);
  ----------------------------------------------------------------------------------------------------
  -- Document Type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Journal_Type_Hiring                 constant varchar2(50) := 'VHR:HPD:1';
  c_Pcode_Journal_Type_Hiring_Multiple        constant varchar2(50) := 'VHR:HPD:2';
  c_Pcode_Journal_Type_Transfer               constant varchar2(50) := 'VHR:HPD:3';
  c_Pcode_Journal_Type_Transfer_Multiple      constant varchar2(50) := 'VHR:HPD:4';
  c_Pcode_Journal_Type_Dismissal              constant varchar2(50) := 'VHR:HPD:5';
  c_Pcode_Journal_Type_Dismissal_Multiple     constant varchar2(50) := 'VHR:HPD:6';
  c_Pcode_Journal_Type_Wage_Change            constant varchar2(50) := 'VHR:HPD:7';
  c_Pcode_Journal_Type_Schedule_Change        constant varchar2(50) := 'VHR:HPD:8';
  c_Pcode_Journal_Type_Sick_Leave             constant varchar2(50) := 'VHR:HPD:9';
  c_Pcode_Journal_Type_Business_Trip          constant varchar2(50) := 'VHR:HPD:10';
  c_Pcode_Journal_Type_Vacation               constant varchar2(50) := 'VHR:HPD:11';
  c_Pcode_Journal_Type_Rank_Change            constant varchar2(50) := 'VHR:HPD:12';
  c_Pcode_Journal_Type_Limit_Change           constant varchar2(50) := 'VHR:HPD:13';
  c_Pcode_Journal_Type_Overtime               constant varchar2(50) := 'VHR:HPD:14';
  c_Pcode_Journal_Type_Wage_Change_Multiple   constant varchar2(50) := 'VHR:HPD:15';
  c_Pcode_Journal_Type_Timebook_Adjustment    constant varchar2(50) := 'VHR:HPD:16';
  c_Pcode_Journal_Type_Rank_Change_Multiple   constant varchar2(50) := 'VHR:HPD:17';
  c_Pcode_Journal_Type_Business_Trip_Multiple constant varchar2(50) := 'VHR:HPD:18';
  c_Pcode_Journal_Type_Hiring_Contractor      constant varchar2(50) := 'VHR:HPD:19';
  c_Pcode_Journal_Type_Sick_Leave_Multiple    constant varchar2(50) := 'VHR:HPD:20';
  c_Pcode_Journal_Type_Vacation_Multiple      constant varchar2(50) := 'VHR:HPD:21';
  ----------------------------------------------------------------------------------------------------
  -- Employment Type
  ----------------------------------------------------------------------------------------------------
  c_Employment_Type_Main_Job          constant varchar2(1) := 'M';
  c_Employment_Type_External_Parttime constant varchar2(1) := 'E';
  c_Employment_Type_Internal_Parttime constant varchar2(1) := 'I';
  c_Employment_Type_Contractor        constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- Lock Interval Kind
  ----------------------------------------------------------------------------------------------------
  c_Lock_Interval_Kind_Timebook                        constant varchar2(1) := 'T';
  c_Lock_Interval_Kind_Timeoff                         constant varchar2(1) := 'O';
  c_Lock_Interval_Kind_Performance                     constant varchar2(1) := 'P';
  c_Lock_Interval_Kind_Sales_Bonus_Personal_Sales      constant varchar2(1) := 'S';
  c_Lock_Interval_Kind_Sales_Bonus_Department_Sales    constant varchar2(1) := 'R';
  c_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery constant varchar2(1) := 'L';
  ----------------------------------------------------------------------------------------------------
  -- Lock Interval Timeoff Kinds
  ---------------------------------------------------------------------------------------------------- 
  c_Lock_Interval_Kind_Timeoff_Business_Trip constant varchar2(1) := 'B';
  c_Lock_Interval_Kind_Timeoff_Sick_Leave    constant varchar2(1) := 'C';
  c_Lock_Interval_Kind_Timeoff_Vacation      constant varchar2(1) := 'V';
  ----------------------------------------------------------------------------------------------------
  -- Transaction Types Ro(B)ot, (O)peration, (S)chedule, (R)ank, Vacation (L)imit
  ----------------------------------------------------------------------------------------------------
  c_Transaction_Type_Robot          constant varchar2(1) := 'B';
  c_Transaction_Type_Operation      constant varchar2(1) := 'O';
  c_Transaction_Type_Schedule       constant varchar2(1) := 'S';
  c_Transaction_Type_Rank           constant varchar2(1) := 'R';
  c_Transaction_Type_Vacation_Limit constant varchar2(1) := 'L';
  c_Transaction_Type_Currency       constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- Transfer Kind
  ----------------------------------------------------------------------------------------------------
  c_Transfer_Kind_Permanently constant varchar2(1) := 'P';
  c_Transfer_Kind_Temporarily constant varchar2(1) := 'T';
  ----------------------------------------------------------------------------------------------------
  c_Transaction_Action_Continue constant varchar2(1) := 'C';
  c_Transaction_Action_Stop     constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  c_Transaction_Event_To_Be_Integrated constant varchar2(1) := 'I';
  c_Transaction_Event_In_Progress      constant varchar2(1) := 'P';
  c_Transaction_Event_To_Be_Deleted    constant varchar2(1) := 'D';
  ----------------------------------------------------------------------------------------------------
  g_Migration_Active boolean := false;
  ----------------------------------------------------------------------------------------------------
  -- Journal Types
  ----------------------------------------------------------------------------------------------------
  c_Journal_Type_Hiring          constant varchar2(1) := 'H';
  c_Journal_Type_Transfer        constant varchar2(1) := 'T';
  c_Journal_Type_Dismissal       constant varchar2(1) := 'D';
  c_Journal_Type_Schedule_Change constant varchar2(1) := 'S';
  c_Journal_Type_Wage_Change     constant varchar2(1) := 'W';
  c_Journal_Type_Rank_Change     constant varchar2(1) := 'R';
  c_Journal_Type_Limit_Change    constant varchar2(1) := 'L';
  ----------------------------------------------------------------------------------------------------
  -- Adjustment Kinds
  ----------------------------------------------------------------------------------------------------
  c_Adjustment_Kind_Full       constant varchar2(1) := 'F';
  c_Adjustment_Kind_Incomplete constant varchar2(1) := 'I';
  ----------------------------------------------------------------------------------------------------
  -- vacation turnover days kind
  ----------------------------------------------------------------------------------------------------
  c_Vacation_Turnover_Planned_Days constant varchar2(1) := 'P';
  c_Vacation_Turnover_Used_Days    constant varchar2(1) := 'U';
  ----------------------------------------------------------------------------------------------------
  -- fte kinds
  ----------------------------------------------------------------------------------------------------
  c_Fte_Kind_Full     constant varchar2(1) := 'F';
  c_Fte_Kind_Half     constant varchar2(1) := 'H';
  c_Fte_Kind_Quarter  constant varchar2(1) := 'Q';
  c_Fte_Kind_Occupied constant varchar2(1) := 'O';
  c_Fte_Kind_Custom   constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------  
  -- contracts
  ----------------------------------------------------------------------------------------------------  
  c_Cv_Contract_Kind_Simple   constant varchar2(1) := 'S';
  c_Cv_Contract_Kind_Cyclical constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- Application Type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Application_Type_Create_Robot      constant varchar2(50) := 'VHR:HPD:1';
  c_Pcode_Application_Type_Hiring            constant varchar2(50) := 'VHR:HPD:2';
  c_Pcode_Application_Type_Transfer          constant varchar2(50) := 'VHR:HPD:3';
  c_Pcode_Application_Type_Dismissal         constant varchar2(50) := 'VHR:HPD:4';
  c_Pcode_Application_Type_Transfer_Multiple constant varchar2(50) := 'VHR:HPD:5';
  ----------------------------------------------------------------------------------------------------
  -- Application Status
  ----------------------------------------------------------------------------------------------------
  c_Application_Status_New         constant varchar2(1) := 'N';
  c_Application_Status_Waiting     constant varchar2(1) := 'W';
  c_Application_Status_Approved    constant varchar2(1) := 'A';
  c_Application_Status_In_Progress constant varchar2(1) := 'P';
  c_Application_Status_Completed   constant varchar2(1) := 'O';
  c_Application_Status_Canceled    constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- view forms
  ----------------------------------------------------------------------------------------------------
  c_Form_Hiring_Journal_View        constant varchar2(200) := '/vhr/hpd/view/hiring_view';
  c_Form_Hiring_Multiple_View       constant varchar2(200) := '/vhr/hpd/view/hiring_view';
  c_Form_Transfer_View              constant varchar2(200) := '/vhr/hpd/view/transfer_view';
  c_Form_Transfer_Multiple_View     constant varchar2(200) := '/vhr/hpd/view/transfer_view';
  c_Form_Dismissal_View             constant varchar2(200) := '/vhr/hpd/view/dismissal_view';
  c_Form_Dismissal_Multiple_View    constant varchar2(200) := '/vhr/hpd/view/dismissal_view';
  c_Form_Wage_Change_View           constant varchar2(200) := '/vhr/hpd/view/wage_change_view';
  c_Form_Schedule_Change_View       constant varchar2(200) := '/vhr/hpd/view/schedule_change_view';
  c_Form_Rank_Change_View           constant varchar2(200) := '/vhr/hpd/view/rank_change_view';
  c_Form_Vacation_Limit_Change_View constant varchar2(200) := '/vhr/hpd/view/vacation_limit_change_view';
  c_Form_Overtime_View              constant varchar2(200) := '/vhr/hpd/view/overtime_view';
  c_Form_Timebook_Adjustment_View   constant varchar2(200) := '/vhr/hpd/view/timebook_adjustment_view';
  ----------------------------------------------------------------------------------------------------
  -- Easy Report Origins
  ----------------------------------------------------------------------------------------------------
  c_Easy_Report_Form_Hiring              constant varchar2(200) := '/vhr/rep/hpd/hiring';
  c_Easy_Report_Form_Hiring_Multiple     constant varchar2(200) := '/vhr/rep/hpd/hiring_multiple';
  c_Easy_Report_Form_Transfer            constant varchar2(200) := '/vhr/rep/hpd/transfer';
  c_Easy_Report_Form_Transfer_Multiple   constant varchar2(200) := '/vhr/rep/hpd/transfer_multiple';
  c_Easy_Report_Form_Dismissal           constant varchar2(200) := '/vhr/rep/hpd/dismissal';
  c_Easy_Report_Form_Dismissal_Multiple  constant varchar2(200) := '/vhr/rep/hpd/dismissal_multiple';
  c_Easy_Report_Form_Labor_Contract      constant varchar2(200) := '/vhr/rep/hpd/labor_contract';
  c_Easy_Report_Form_Sick_Leave          constant varchar2(200) := '/vhr/rep/hpd/sick_leave';
  c_Easy_Report_Form_Sick_Leave_Multiple constant varchar2(200) := '/vhr/rep/hpd/sick_leave_multiple';
  ----------------------------------------------------------------------------------------------------
  -- Application forms
  ----------------------------------------------------------------------------------------------------
  c_Form_Application_List constant varchar2(200) := '/vhr/hpd/application/application_list';
  c_Uri_Application_Part  constant varchar2(200) := '/vhr/hpd/application/';
  ----------------------------------------------------------------------------------------------------
  -- Application Grant parts
  ----------------------------------------------------------------------------------------------------
  c_App_Grant_Part_Create_Robot constant varchar2(200) := 'create_robot_';
  c_App_Grant_Part_Hiring       constant varchar2(200) := 'hiring_';
  c_App_Grant_Part_Transfer     constant varchar2(200) := 'transfer_';
  c_App_Grant_Part_Dismissal    constant varchar2(200) := 'dismissal_';
  ----------------------------------------------------------------------------------------------------
  -- Application Grantees
  ----------------------------------------------------------------------------------------------------
  c_App_Grantee_Applicant constant varchar2(200) := 'applicant';
  c_App_Grantee_Manager   constant varchar2(200) := 'manager';
  c_App_Grantee_Hr        constant varchar2(200) := 'hr';
  ----------------------------------------------------------------------------------------------------
  -- Application form action
  ----------------------------------------------------------------------------------------------------
  c_App_Form_Action_Edit constant varchar2(200) := 'edit';
  c_App_Form_Action_View constant varchar2(200) := 'view';
  ----------------------------------------------------------------------------------------------------
  -- Contract Employment Kinds
  ----------------------------------------------------------------------------------------------------
  c_Contract_Employment_Freelancer   constant varchar2(1) := 'F';
  c_Contract_Employment_Staff_Member constant varchar2(1) := 'M';
  ----------------------------------------------------------------------------------------------------  
  -- Pcode for Sign process
  ----------------------------------------------------------------------------------------------------  
  c_Pcode_Journal_Sign_Processes constant varchar2(100) := 'VHR:HPD:1';

end Hpd_Pref;
/
create or replace package body Hpd_Pref is
end Hpd_Pref;
/
