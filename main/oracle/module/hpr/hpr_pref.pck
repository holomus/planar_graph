create or replace package Hpr_Pref is
  ----------------------------------------------------------------------------------------------------
  -- Timebook
  ----------------------------------------------------------------------------------------------------  
  type Timebook_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Timebook_Id     number,
    Timebook_Number varchar2(50 char),
    Timebook_Date   date,
    Period_Begin    date,
    Period_End      date,
    Period_Kind     varchar2(1),
    Division_Id     number,
    Barcode         varchar2(25 char),
    Note            varchar2(300 char),
    Staff_Ids       Array_Number);
  ----------------------------------------------------------------------------------------------------
  -- Oper Type
  ----------------------------------------------------------------------------------------------------  
  type Oper_Type_Rt is record(
    Oper_Type          Mpr_Oper_Types%rowtype,
    Oper_Group_Id      number,
    Estimation_Type    varchar2(1),
    Estimation_Formula varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  -- Book
  ----------------------------------------------------------------------------------------------------
  type Book_Operation_Rt is record(
    Operation_Id number,
    Staff_Id     number,
    Charge_Id    number,
    Autofilled   varchar2(1));
  type Book_Opereration_Nt is table of Book_Operation_Rt;
  ----------------------------------------------------------------------------------------------------
  type Book_Rt is record(
    Book         Mpr_Pref.Book_Rt,
    Book_Type_Id number,
    Operations   Book_Opereration_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Payment
  ----------------------------------------------------------------------------------------------------
  type Advance_Rt is record(
    Payment      Mpr_Pref.Payment_Rt,
    Limit_Kind   varchar2(1),
    Days_Limit   number(3),
    Employee_Ids Array_Number);
  ----------------------------------------------------------------------------------------------------
  -- timebook staff info
  ----------------------------------------------------------------------------------------------------
  type Timebook_Staff_Info is record(
    Staff_Id   number,
    Plan_Hours number,
    Plan_Days  number,
    Fact_Hours number,
    Fact_Days  number);
  ----------------------------------------------------------------------------------------------------
  -- Penalty
  ----------------------------------------------------------------------------------------------------
  type Penalty_Policy_Rt is record(
    Penalty_Kind         varchar2(1),
    Penalty_Type         varchar2(1),
    From_Day             number,
    To_Day               number,
    From_Time            number,
    To_Time              number,
    Penalty_Coef         number,
    Penalty_Per_Time     number,
    Penalty_Amount       number,
    Penalty_Time         number,
    Calc_After_From_Time varchar2(1));
  type Penalty_Policy_Nt is table of Penalty_Policy_Rt;
  ----------------------------------------------------------------------------------------------------
  type Penalty_Rt is record(
    Company_Id  number,
    Filial_Id   number,
    Penalty_Id  number,
    month       date,
    name        varchar2(100 char),
    Division_Id number,
    State       varchar2(1),
    Policies    Penalty_Policy_Nt);
  ----------------------------------------------------------------------------------------------------
  -- nigthtime policy
  ----------------------------------------------------------------------------------------------------
  type Nighttime_Rule_Rt is record(
    Begin_Time     number,
    End_Time       number,
    Nighttime_Coef number);
  type Nighttime_Rule_Nt is table of Nighttime_Rule_Rt;
  ----------------------------------------------------------------------------------------------------
  type Nighttime_Policy_Rt is record(
    Company_Id           number,
    Filial_Id            number,
    Nigthttime_Policy_Id number,
    month                date,
    name                 varchar2(100 char),
    Division_Id          number,
    State                varchar2(1),
    Rules                Nighttime_Rule_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Sheet parts (regular wage sheet)
  ----------------------------------------------------------------------------------------------------
  type Sheet_Part_Rt is record(
    Part_Begin       date,
    Part_End         date,
    Division_Id      number,
    Job_Id           number,
    Schedule_Id      number,
    Fte_Id           number,
    Monthly_Amount   number,
    Plan_Amount      number,
    Wage_Amount      number,
    Overtime_Amount  number,
    Nighttime_Amount number,
    Late_Amount      number,
    Early_Amount     number,
    Lack_Amount      number,
    Day_Skip_Amount  number,
    Mark_Skip_Amount number);
  type Sheet_Part_Nt is table of Sheet_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  -- Sheet staffs (one-time wage sheet)
  ----------------------------------------------------------------------------------------------------
  type Sheet_Staff_Rt is record(
    Staff_Id       number,
    Accrual_Amount number,
    Penalty_Amount number);
  type Sheet_Staff_Nt is table of Sheet_Staff_Rt;
  ----------------------------------------------------------------------------------------------------
  -- Wage sheet
  ----------------------------------------------------------------------------------------------------
  type Wage_Sheet_Rt is record(
    Company_Id   number,
    Filial_Id    number,
    Sheet_Id     number,
    Sheet_Number varchar2(50 char),
    Sheet_Date   date,
    Period_Begin date,
    Period_End   date,
    Period_Kind  varchar2(1),
    Note         varchar2(300 char),
    Round_Value  varchar2(5),
    Sheet_Kind   varchar2(1),
    Staff_Ids    Array_Number,
    Division_Ids Array_Number,
    Sheet_Staffs Sheet_Staff_Nt);
  ---------------------------------------------------------------------------------------------------- 
  -- Cv Contracts
  ----------------------------------------------------------------------------------------------------
  type Cv_Contract_Fact_Item_Rt is record(
    Fact_Item_Id  number,
    Fact_Quantity number,
    Fact_Amount   number,
    name          varchar2(150 char));
  type Cv_Contract_Fact_Item_Nt is table of Cv_Contract_Fact_Item_Rt;
  ----------------------------------------------------------------------------------------------------
  type Cv_Contract_Fact_Rt is record(
    Company_Id number,
    Filial_Id  number,
    Fact_Id    number,
    Items      Cv_Contract_Fact_Item_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Sales Bonus Payment
  ----------------------------------------------------------------------------------------------------
  type Sales_Bonus_Payment_Operation_Rt is record(
    Operation_Id  number,
    Staff_Id      number,
    Period_Begin  date,
    Period_End    date,
    Bonus_Type    varchar2(1),
    Job_Id        number,
    Percentage    number,
    Periods       Array_Date,
    Sales_Amounts Array_Number,
    Amounts       Array_Number);
  ----------------------------------------------------------------------------------------------------
  type Sales_Bonus_Payment_Operation_Nt is table of Sales_Bonus_Payment_Operation_Rt;
  ----------------------------------------------------------------------------------------------------
  type Sales_Bonus_Payment_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Payment_Id      number,
    Payment_Number  Hpr_Sales_Bonus_Payments.Payment_Number%type,
    Payment_Date    date,
    Payment_Name    Hpr_Sales_Bonus_Payments.Payment_Name%type,
    Begin_Date      date,
    End_Date        date,
    Division_Id     number,
    Job_Id          number,
    Bonus_Type      varchar2(1),
    Payment_Type    varchar2(1),
    Cashbox_Id      number,
    Bank_Account_Id number,
    Note            Hpr_Sales_Bonus_Payments.Note%type,
    Operations      Sales_Bonus_Payment_Operation_Nt);
  ----------------------------------------------------------------------------------------------------
  type Charge_Document_Operation_Rt is record(
    Operation_Id number,
    Staff_Id     number,
    Charge_Id    number,
    Oper_Type_Id number,
    Amount       number,
    Note         varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  type Charge_Document_Operation_Nt is table of Charge_Document_Operation_Rt;
  ----------------------------------------------------------------------------------------------------
  type Charge_Document_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Document_Id     number,
    Document_Number varchar2(50 char),
    Document_Date   date,
    Document_Name   varchar2(150 char),
    month           date,
    Oper_Type_Id    number,
    Currency_Id     number,
    Division_Id     number,
    Document_Kind   varchar2(1),
    Operations      Charge_Document_Operation_Nt);
  ----------------------------------------------------------------------------------------------------
  type Daily_Indicators_Rt is record(
    Indicator_Id    number,
    Indicator_Value number);
  type Daily_Indicators_Nt is table of Daily_Indicators_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Credit_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Credit_Id       number,
    Credit_Number   varchar2(50 char),
    Credit_Date     date,
    Booked_Date     date,
    Employee_Id     number,
    Begin_Month     date,
    End_Month       date,
    Credit_Amount   number,
    Currency_Id     number,
    Payment_Type    varchar2(1),
    Cashbox_Id      number,
    Bank_Account_Id number,
    Status          varchar2(1),
    Note            varchar2(300 char));
  ----------------------------------------------------------------------------------------------------
  -- Default Round Value
  ----------------------------------------------------------------------------------------------------
  c_Default_Round_Value constant varchar2(5) := '+2.0R';
  ----------------------------------------------------------------------------------------------------  
  -- Penalty kinds 
  ---------------------------------------------------------------------------------------------------- 
  c_Penalty_Kind_Late      constant varchar2(1) := 'L';
  c_Penalty_Kind_Early     constant varchar2(1) := 'E';
  c_Penalty_Kind_Lack      constant varchar2(1) := 'C';
  c_Penalty_Kind_Day_Skip  constant varchar2(1) := 'S';
  c_Penalty_Kind_Mark_Skip constant varchar2(1) := 'M';
  ----------------------------------------------------------------------------------------------------
  -- Penalty types
  ----------------------------------------------------------------------------------------------------
  c_Penalty_Type_Coef   constant varchar2(1) := 'C';
  c_Penalty_Type_Amount constant varchar2(1) := 'A';
  c_Penalty_Type_Time   constant varchar2(1) := 'T';
  ----------------------------------------------------------------------------------------------------
  -- Pcode Operation Group
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Operation_Group_Wage                   constant varchar2(20) := 'VHR:1';
  c_Pcode_Operation_Group_Perf                   constant varchar2(20) := 'VHR:2';
  c_Pcode_Operation_Group_Sick_Leave             constant varchar2(20) := 'VHR:3';
  c_Pcode_Operation_Group_Business_Trip          constant varchar2(20) := 'VHR:4';
  c_Pcode_Operation_Group_Vacation               constant varchar2(20) := 'VHR:5';
  c_Pcode_Operation_Group_Overtime               constant varchar2(20) := 'VHR:6';
  c_Pcode_Operation_Group_Penalty_For_Discipline constant varchar2(20) := 'VHR:7';
  c_Pcode_Operation_Group_Perf_Penalty           constant varchar2(20) := 'VHR:8';
  c_Pcode_Operation_Group_Wage_No_Deduction      constant varchar2(20) := 'VHR:9';
  ----------------------------------------------------------------------------------------------------
  -- Pcode Oper Type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Oper_Type_Sick_Leave             constant varchar2(20) := 'VHR:1';
  c_Pcode_Oper_Type_Business_Trip          constant varchar2(20) := 'VHR:2';
  c_Pcode_Oper_Type_Vacation               constant varchar2(20) := 'VHR:3';
  c_Pcode_Oper_Type_Wage_Hourly            constant varchar2(20) := 'VHR:4';
  c_Pcode_Oper_Type_Wage_Daily             constant varchar2(20) := 'VHR:5';
  c_Pcode_Oper_Type_Wage_Monthly           constant varchar2(20) := 'VHR:6';
  c_Pcode_Oper_Type_Overtime               constant varchar2(20) := 'VHR:7';
  c_Pcode_Oper_Type_Monthly_Summarized     constant varchar2(20) := 'VHR:8';
  c_Pcode_Oper_Type_Penalty_For_Discipline constant varchar2(20) := 'VHR:9';
  c_Pcode_Oper_Type_Nighttime              constant varchar2(20) := 'VHR:10';
  c_Pcode_Oper_Type_Weighted_Turnout       constant varchar2(20) := 'VHR:11';
  ----------------------------------------------------------------------------------------------------
  -- Pcode Book Type
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Book_Type_Wage          constant varchar2(20) := 'VHR:1';
  c_Pcode_Book_Type_Sick_Leave    constant varchar2(20) := 'VHR:2';
  c_Pcode_Book_Type_Business_Trip constant varchar2(20) := 'VHR:3';
  c_Pcode_Book_Type_Vacation      constant varchar2(20) := 'VHR:4';
  c_Pcode_Book_Type_All           constant varchar2(20) := 'VHR:5';
  ----------------------------------------------------------------------------------------------------
  -- Charge Status
  ----------------------------------------------------------------------------------------------------
  c_Charge_Status_Draft     constant varchar2(1) := 'D';
  c_Charge_Status_New       constant varchar2(1) := 'N';
  c_Charge_Status_Used      constant varchar2(1) := 'U';
  c_Charge_Status_Completed constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- Estimation Type
  ----------------------------------------------------------------------------------------------------
  c_Estimation_Type_Formula constant varchar2(1) := 'F';
  c_Estimation_Type_Entered constant varchar2(1) := 'E';
  ----------------------------------------------------------------------------------------------------
  c_Advance_Limit_Turnout_Days  constant varchar2(1) := 'T';
  c_Advance_Limit_Calendar_Days constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- Easy Report Form
  ----------------------------------------------------------------------------------------------------
  c_Easy_Report_Form_Timebook        constant varchar2(200) := '/vhr/rep/hpr/timebook';
  c_Easy_Report_Form_Payroll_Book    constant varchar2(200) := '/vhr/rep/hpr/payroll_book';
  c_Easy_Report_Form_Charge_Document constant varchar2(200) := '/vhr/rep/hpr/charge_document';
  ----------------------------------------------------------------------------------------------------
  -- Wage Sheet Report
  ----------------------------------------------------------------------------------------------------
  c_Report_Form_Wage_Sheet constant varchar2(200) := '/vhr/rep/hpr/start/wage_report';
  c_Report_Uri_Wage_Sheet  constant varchar2(200) := '/vhr/rep/hpr/start/wage_report:run';
  ----------------------------------------------------------------------------------------------------
  -- Period Kinds
  ----------------------------------------------------------------------------------------------------
  c_Period_Full_Month        constant varchar2(1) := 'M';
  c_Period_Month_First_Half  constant varchar2(1) := 'F';
  c_Period_Month_Second_Half constant varchar2(1) := 'S';
  c_Period_Custom            constant varchar2(1) := 'C';
  ---------------------------------------------------------------------------------------------------- 
  -- Contract
  ----------------------------------------------------------------------------------------------------  
  c_Cv_Contract_Fact_Status_New      constant varchar2(1) := 'N';
  c_Cv_Contract_Fact_Status_Complete constant varchar2(1) := 'C';
  c_Cv_Contract_Fact_Status_Accept   constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- Overtime coef
  ----------------------------------------------------------------------------------------------------
  c_Overtime_Coef         constant varchar2(50) := 'VHR:OVERTIME_COEF';
  c_Overtime_Coef_Default constant number := 1;
  ----------------------------------------------------------------------------------------------------
  -- Wage sheet kinds
  ----------------------------------------------------------------------------------------------------
  c_Wage_Sheet_Regular constant varchar2(1) := 'R';
  c_Wage_Sheet_Onetime constant varchar2(1) := 'O';
  ----------------------------------------------------------------------------------------------------
  -- view forms
  ----------------------------------------------------------------------------------------------------
  c_Form_Timebook_View constant varchar2(200) := '/vhr/hpr/timebook_view';
  c_Form_Book_View     constant varchar2(200) := '/vhr/hpr/book_view';
  ----------------------------------------------------------------------------------------------------
  -- Currency setting codes
  ----------------------------------------------------------------------------------------------------
  c_Pref_Allow_Other_Currencies constant varchar2(50) := 'VHR:ALLOW_OTHER_CURRENCIES';
  ----------------------------------------------------------------------------------------------------
  -- Timebook Fill Settings
  ----------------------------------------------------------------------------------------------------
  c_Pref_Timebook_Fill_Settings constant varchar2(50) := 'VHR:HPR:TIMEBOOK_FILL_SETTINGS';
  ----------------------------------------------------------------------------------------------------
  -- Use Project Setting
  ---------------------------------------------------------------------------------------------------- 
  c_Pref_Use_Subfilial_Settings constant varchar2(50) := 'VHR:HPR:USE_SUBFILIAL_SETTINGS';
  ----------------------------------------------------------------------------------------------------  
  -- Credit Statuses
  ----------------------------------------------------------------------------------------------------  
  c_Credit_Status_Draft    constant varchar2(1) := 'D';
  c_Credit_Status_Booked   constant varchar2(1) := 'B';
  c_Credit_Status_Complete constant varchar2(1) := 'C';
  c_Credit_Status_Archived constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------  
  -- Coa For credit
  ----------------------------------------------------------------------------------------------------  
    c_Pref_Coa_Employee_Credit constant varchar2(50) := 'HPR:COA_EMPLOYEE_CREDIT';
end Hpr_Pref;
/
create or replace package body Hpr_Pref is

end Hpr_Pref;
/
