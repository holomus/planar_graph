create or replace package Hpr_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_New
  (
    o_Contract_Fact out Hpr_Pref.Cv_Contract_Fact_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Fact_Id       number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Add_Item
  (
    o_Contract_Fact in out nocopy Hpr_Pref.Cv_Contract_Fact_Rt,
    i_Fact_Item_Id  number,
    i_Fact_Quantity number,
    i_Fact_Amount   number,
    i_Name          varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_New
  (
    o_Penalty     out Hpr_Pref.Penalty_Rt,
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Penalty_Id  number,
    i_Month       date,
    i_Name        varchar2 := null,
    i_Division_Id number := null,
    i_State       varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Add_Policy
  (
    p_Penalty              in out nocopy Hpr_Pref.Penalty_Rt,
    i_Penalty_Kind         varchar2,
    i_Penalty_Type         varchar2,
    i_From_Day             number,
    i_To_Day               number := null,
    i_From_Time            number,
    i_To_Time              number := null,
    i_Penalty_Coef         number := null,
    i_Penalty_Per_Time     number := null,
    i_Penalty_Amount       number := null,
    i_Penalty_Time         number := null,
    i_Calc_After_From_Time varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nigthtime_Policy_New
  (
    o_Nigthtime_Policy    out Hpr_Pref.Nighttime_Policy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Nigthtime_Policy_Id number,
    i_Month               date,
    i_Name                varchar2 := null,
    i_Division_Id         number := null,
    i_State               varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nigthtime_Add_Rule
  (
    o_Nigthtime_Policy in out nocopy Hpr_Pref.Nighttime_Policy_Rt,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Nighttime_Coef   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_New
  (
    o_Wage_Sheet   out Hpr_Pref.Wage_Sheet_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Sheet_Number varchar2,
    i_Sheet_Date   date,
    i_Period_Begin date,
    i_Period_End   date,
    i_Period_Kind  varchar2,
    i_Note         varchar2,
    i_Sheet_Kind   varchar2,
    i_Round_Value  varchar2 := null,
    i_Staff_Ids    Array_Number := Array_Number(),
    i_Division_Ids Array_Number := Array_Number(),
    i_Sheet_Staffs Hpr_Pref.Sheet_Staff_Nt := Hpr_Pref.Sheet_Staff_Nt()
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Sheet_Staff_Add
  (
    p_Staffs         in out nocopy Hpr_Pref.Sheet_Staff_Nt,
    i_Staff_Id       number,
    i_Accrual_Amount number,
    i_Penalty_Amount number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Add_Part
  (
    p_Parts            in out nocopy Hpr_Pref.Sheet_Part_Nt,
    i_Part_Begin       date,
    i_Part_End         date,
    i_Division_Id      number,
    i_Job_Id           number,
    i_Schedule_Id      number,
    i_Fte_Id           number,
    i_Monthly_Amount   number,
    i_Plan_Amount      number,
    i_Wage_Amount      number,
    i_Overtime_Amount  number,
    i_Nighttime_Amount number,
    i_Late_Amount      number,
    i_Early_Amount     number,
    i_Lack_Amount      number,
    i_Day_Skip_Amount  number,
    i_Mark_Skip_Amount number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_New
  (
    o_Timebook        out Hpr_Pref.Timebook_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Timebook_Id     number,
    i_Timebook_Number varchar2,
    i_Timebook_Date   date,
    i_Period_Begin    date,
    i_Period_End      date,
    i_Period_Kind     varchar2,
    i_Division_Id     number,
    i_Note            varchar2,
    i_Staff_Ids       Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_New
  (
    o_Oper_Type              out Hpr_Pref.Oper_Type_Rt,
    i_Company_Id             number,
    i_Oper_Type_Id           number,
    i_Oper_Group_Id          number,
    i_Estimation_Type        varchar2,
    i_Estimation_Formula     varchar2,
    i_Operation_Kind         varchar2,
    i_Name                   varchar2,
    i_Short_Name             varchar2,
    i_Accounting_Type        varchar2,
    i_Corr_Coa_Id            number,
    i_Corr_Ref_Set           varchar2,
    i_Income_Tax_Exists      varchar2,
    i_Income_Tax_Rate        number,
    i_Pension_Payment_Exists varchar2,
    i_Pension_Payment_Rate   number,
    i_Social_Payment_Exists  varchar2,
    i_Social_Payment_Rate    number,
    i_Note                   varchar2,
    i_State                  varchar2,
    i_Code                   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Book_New
  (
    o_Book         out Hpr_Pref.Book_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Book_Id      number,
    i_Book_Type_Id number,
    i_Book_Number  varchar2,
    i_Book_Date    date,
    i_Book_Name    varchar2 := null,
    i_Month        date := null,
    i_Division_Id  number := null,
    i_Currency_Id  number,
    i_Note         varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Book_Add_Operation
  (
    p_Book                   in out nocopy Hpr_Pref.Book_Rt,
    i_Operation_Id           number,
    i_Staff_Id               number,
    i_Oper_Type_Id           number,
    i_Charge_Id              number,
    i_Autofilled             varchar2,
    i_Note                   varchar2,
    i_Amount                 number,
    i_Net_Amount             number,
    i_Income_Tax_Amount      number := null,
    i_Pension_Payment_Amount number := null,
    i_Social_Payment_Amount  number := null,
    i_Subfilial_Id           number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_New
  (
    o_Charge_Document out Hpr_Pref.Charge_Document_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Document_Id     number,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Document_Name   varchar2,
    i_Month           date,
    i_Oper_Type_Id    number,
    i_Currency_Id     number,
    i_Division_Id     number,
    i_Document_Kind   varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Charge_Document_Add_Operation
  (
    o_Charge_Document in out Hpr_Pref.Charge_Document_Rt,
    i_Operation_Id    number,
    i_Staff_Id        number,
    i_Charge_Id       number,
    i_Oper_Type_Id    number,
    i_Amount          number,
    i_Note            varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Advance_New
  (
    o_Advance         out nocopy Hpr_Pref.Advance_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Payment_Id      number,
    i_Payment_Number  varchar2,
    i_Payment_Date    date,
    i_Booked_Date     date,
    i_Currency_Id     number,
    i_Payment_Type    varchar2,
    i_Days_Limit      number := null,
    i_Limit_Kind      varchar2,
    i_Division_Id     number := null,
    i_Cashbox_Id      number := null,
    i_Bank_Account_Id number := null,
    i_Note            varchar2,
    i_Souce_Table     varchar2,
    i_Source_Id       number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Advance_Add_Employee
  (
    p_Advance         in out nocopy Hpr_Pref.Advance_Rt,
    i_Employee_Id     number,
    i_Pay_Amount      number,
    i_Bank_Account_Id number := null,
    i_Paid_Date       date := null,
    i_Paid            varchar2 := null,
    i_Note            varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_New
  (
    o_Sales_Bonus_Payment out nocopy Hpr_Pref.Sales_Bonus_Payment_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Payment_Id          number,
    i_Payment_Number      varchar2,
    i_Payment_Date        date,
    i_Payment_Name        varchar2 := null,
    i_Begin_Date          date,
    i_End_Date            date,
    i_Division_Id         number := null,
    i_Job_Id              number := null,
    i_Bonus_Type          varchar2 := null,
    i_Payment_Type        varchar2,
    i_Cashbox_Id          number := null,
    i_Bank_Account_Id     number := null,
    i_Note                varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Add_Operation
  (
    p_Sales_Bonus_Payment in out nocopy Hpr_Pref.Sales_Bonus_Payment_Rt,
    i_Operation_Id        number,
    i_Staff_Id            number,
    i_Period_Begin        date,
    i_Period_End          date,
    i_Bonus_Type          varchar2,
    i_Job_Id              number,
    i_Percentage          number,
    i_Periods             Array_Date,
    i_Sales_Amounts       Array_Number,
    i_Amounts             Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Currency_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Use_Subfilial_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Is_Staff_Blocked
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Timebook_Id  number := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Is_Staff_Sales_Bonus_Calced
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Bonus_Type   varchar2,
    i_Period_Begin date,
    i_Period_End   date,
    i_Payment_Id   number := null,
    o_Period_Begin out date,
    o_Period_End   out date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Jcode_Sales_Bonus_Payment(i_Payment_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Oper_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Book_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Formula_Execute
  (
    i_Formula   varchar2,
    i_Arguments Matrix_Varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Formula_Variables(i_Formula varchar2) return Array_Varchar2;
  ----------------------------------------------------------------------------------------------------
  -- this function only for system oper type formula when new company added
  ----------------------------------------------------------------------------------------------------
  Function Formula_Fix
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Formula_Indicators
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Formula_Validate
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return Array_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Overtime_Coef(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Constant_Indicator
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Charge_Id    number,
    i_Indicator_Id number,
    i_Period       date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Wage_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Rate_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Hourly_Wage_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Bonus_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Extra_Bonus_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Penalty_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Extra_Penalty_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perf_Bonus
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perf_Extra_Bonus
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Sick_Leave_Coefficient_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Business_Trip_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Sick_Leave_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Mean_Working_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Overtime_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Overtime_Coef_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Additional_Nighttime_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Weighted_Turnout_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Late_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Early_Output_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Absence_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Day_Skip_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Mark_Skip_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Charge_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Indicator_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Hourly_Wage
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Schedule_Id  number,
    i_Part_Begin   date,
    i_Part_End     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Amount
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Amount_With_Indicators
  (
    o_Indicators   out Hpr_Pref.Daily_Indicators_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Part_Begin   date,
    i_Part_End     date,
    i_Calc_Planned boolean := false,
    i_Calc_Worked  boolean := false
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Amount
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Part_Begin   date,
    i_Part_End     date,
    i_Calc_Planned boolean := false,
    i_Calc_Worked  boolean := false
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Amounts
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Currency_Id            number,
    i_Date                   date,
    i_Oper_Type_Id           number,
    i_Amount                 number,
    i_Is_Net_Amount          boolean,
    o_Amount                 out number,
    o_Net_Amount             out number,
    o_Income_Tax_Amount      out number,
    o_Pension_Payment_Amount out number,
    o_Social_Payment_Amount  out number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Penalty_Amount
  (
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    o_Day_Amounts      out nocopy Matrix_Number,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Division_Id      number,
    i_Hourly_Wage      number,
    i_Period_Begin     date,
    i_Period_End       date
  );
  ----------------------------------------------------------------------------------------------------
  Function Calc_Daily_Penalty_Amounts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Division_Id  number,
    i_Hourly_Wage  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Matrix_Number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Additional_Nighttime_Amount
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Division_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Penalty_Amounts
  (
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Division_Id      number,
    i_Hourly_Wage      number,
    i_Period_Begin     date,
    i_Period_End       date
  );
  ----------------------------------------------------------------------------------------------------
  Function Calc_Staff_Parts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  ) return Hpr_Pref.Sheet_Part_Nt;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Penalty_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Period      date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Jcode_Cv_Contract_Fact(i_Fact_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Timebook_Fill_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status(i_Charge_Status varchar2) return varchar2;
  Function Charge_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Estimation_Type(i_Estimation_Type varchar2) return varchar2;
  Function Estimation_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Advance_Limit_Kind(i_Advance_Limit_Kind varchar2) return varchar2;
  Function Advance_Limit_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind(i_Period_Kind varchar2) return varchar2;
  Function Period_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind(i_Penalty_Kind varchar2) return varchar2;
  Function Penalty_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Fact_Status(i_Status varchar2) return varchar2;
  Function Cv_Fact_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Rule_Unit_Min return varchar2;
  Function t_Penalty_Rule_Unit_Times return varchar2;
  Function t_Penalty_Rule_Unit_Days return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Post
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Unpost
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Save
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Update
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Delete
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Post
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Unpost
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Save
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Update
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Delete
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2;
end Hpr_Util;
/
create or replace package body Hpr_Util is
  ----------------------------------------------------------------------------------------------------
  g_Cache_Late_Amount      Fazo.Number_Code_Aat;
  g_Cache_Early_Amount     Fazo.Number_Code_Aat;
  g_Cache_Lack_Amount      Fazo.Number_Code_Aat;
  g_Cache_Day_Skip_Amount  Fazo.Number_Code_Aat;
  g_Cache_Mark_Skip_Amount Fazo.Number_Code_Aat;

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
    return b.Translate('HPR:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_New
  (
    o_Contract_Fact out Hpr_Pref.Cv_Contract_Fact_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Fact_Id       number
  ) is
  begin
    o_Contract_Fact.Company_Id := i_Company_Id;
    o_Contract_Fact.Filial_Id  := i_Filial_Id;
    o_Contract_Fact.Fact_Id    := i_Fact_Id;
  
    o_Contract_Fact.Items := Hpr_Pref.Cv_Contract_Fact_Item_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Add_Item
  (
    o_Contract_Fact in out nocopy Hpr_Pref.Cv_Contract_Fact_Rt,
    i_Fact_Item_Id  number,
    i_Fact_Quantity number,
    i_Fact_Amount   number,
    i_Name          varchar2
  ) is
    v_Fact_Item Hpr_Pref.Cv_Contract_Fact_Item_Rt;
  begin
    v_Fact_Item.Fact_Item_Id  := i_Fact_Item_Id;
    v_Fact_Item.Fact_Quantity := i_Fact_Quantity;
    v_Fact_Item.Fact_Amount   := i_Fact_Amount;
    v_Fact_Item.Name          := i_Name;
  
    o_Contract_Fact.Items.Extend;
    o_Contract_Fact.Items(o_Contract_Fact.Items.Count) := v_Fact_Item;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_New
  (
    o_Penalty     out Hpr_Pref.Penalty_Rt,
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Penalty_Id  number,
    i_Month       date,
    i_Name        varchar2 := null,
    i_Division_Id number := null,
    i_State       varchar2
  ) is
  begin
    o_Penalty.Company_Id  := i_Company_Id;
    o_Penalty.Filial_Id   := i_Filial_Id;
    o_Penalty.Penalty_Id  := i_Penalty_Id;
    o_Penalty.Month       := i_Month;
    o_Penalty.Name        := i_Name;
    o_Penalty.Division_Id := i_Division_Id;
    o_Penalty.State       := i_State;
  
    o_Penalty.Policies := Hpr_Pref.Penalty_Policy_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Add_Policy
  (
    p_Penalty              in out nocopy Hpr_Pref.Penalty_Rt,
    i_Penalty_Kind         varchar2,
    i_Penalty_Type         varchar2,
    i_From_Day             number,
    i_To_Day               number := null,
    i_From_Time            number,
    i_To_Time              number := null,
    i_Penalty_Coef         number := null,
    i_Penalty_Per_Time     number := null,
    i_Penalty_Amount       number := null,
    i_Penalty_Time         number := null,
    i_Calc_After_From_Time varchar2 := null
  ) is
    v_Policy Hpr_Pref.Penalty_Policy_Rt;
  begin
    v_Policy.Penalty_Kind         := i_Penalty_Kind;
    v_Policy.Penalty_Type         := i_Penalty_Type;
    v_Policy.From_Day             := i_From_Day;
    v_Policy.To_Day               := i_To_Day;
    v_Policy.From_Time            := i_From_Time;
    v_Policy.To_Time              := i_To_Time;
    v_Policy.Penalty_Coef         := i_Penalty_Coef;
    v_Policy.Penalty_Per_Time     := i_Penalty_Per_Time;
    v_Policy.Penalty_Amount       := i_Penalty_Amount;
    v_Policy.Penalty_Time         := i_Penalty_Time;
    v_Policy.Calc_After_From_Time := i_Calc_After_From_Time;
  
    p_Penalty.Policies.Extend;
    p_Penalty.Policies(p_Penalty.Policies.Count) := v_Policy;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nigthtime_Policy_New
  (
    o_Nigthtime_Policy    out Hpr_Pref.Nighttime_Policy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Nigthtime_Policy_Id number,
    i_Month               date,
    i_Name                varchar2 := null,
    i_Division_Id         number := null,
    i_State               varchar2
  ) is
  begin
    o_Nigthtime_Policy.Company_Id           := i_Company_Id;
    o_Nigthtime_Policy.Filial_Id            := i_Filial_Id;
    o_Nigthtime_Policy.Nigthttime_Policy_Id := i_Nigthtime_Policy_Id;
    o_Nigthtime_Policy.Month                := i_Month;
    o_Nigthtime_Policy.Name                 := i_Name;
    o_Nigthtime_Policy.Division_Id          := i_Division_Id;
    o_Nigthtime_Policy.State                := i_State;
  
    o_Nigthtime_Policy.Rules := Hpr_Pref.Nighttime_Rule_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nigthtime_Add_Rule
  (
    o_Nigthtime_Policy in out nocopy Hpr_Pref.Nighttime_Policy_Rt,
    i_Begin_Time       number,
    i_End_Time         number,
    i_Nighttime_Coef   number
  ) is
    v_Rule     Hpr_Pref.Nighttime_Rule_Rt;
    v_End_Time number := i_End_Time;
  begin
    if v_End_Time < i_Begin_Time then
      v_End_Time := v_End_Time + 1440;
    end if;
  
    v_Rule.Begin_Time     := i_Begin_Time;
    v_Rule.End_Time       := v_End_Time;
    v_Rule.Nighttime_Coef := i_Nighttime_Coef;
  
    o_Nigthtime_Policy.Rules.Extend;
    o_Nigthtime_Policy.Rules(o_Nigthtime_Policy.Rules.Count) := v_Rule;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_New
  (
    o_Wage_Sheet   out Hpr_Pref.Wage_Sheet_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Sheet_Number varchar2,
    i_Sheet_Date   date,
    i_Period_Begin date,
    i_Period_End   date,
    i_Period_Kind  varchar2,
    i_Note         varchar2,
    i_Sheet_Kind   varchar2,
    i_Round_Value  varchar2 := null,
    i_Staff_Ids    Array_Number := Array_Number(),
    i_Division_Ids Array_Number := Array_Number(),
    i_Sheet_Staffs Hpr_Pref.Sheet_Staff_Nt := Hpr_Pref.Sheet_Staff_Nt()
  ) is
  begin
    o_Wage_Sheet.Company_Id   := i_Company_Id;
    o_Wage_Sheet.Filial_Id    := i_Filial_Id;
    o_Wage_Sheet.Sheet_Id     := i_Sheet_Id;
    o_Wage_Sheet.Sheet_Number := i_Sheet_Number;
    o_Wage_Sheet.Sheet_Date   := i_Sheet_Date;
    o_Wage_Sheet.Period_Begin := i_Period_Begin;
    o_Wage_Sheet.Period_End   := i_Period_End;
    o_Wage_Sheet.Period_Kind  := i_Period_Kind;
    o_Wage_Sheet.Note         := i_Note;
    o_Wage_Sheet.Sheet_Kind   := i_Sheet_Kind;
    o_Wage_Sheet.Round_Value  := i_Round_Value;
    o_Wage_Sheet.Staff_Ids    := i_Staff_Ids;
    o_Wage_Sheet.Division_Ids := i_Division_Ids;
    o_Wage_Sheet.Sheet_Staffs := i_Sheet_Staffs;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Sheet_Staff_Add
  (
    p_Staffs         in out nocopy Hpr_Pref.Sheet_Staff_Nt,
    i_Staff_Id       number,
    i_Accrual_Amount number,
    i_Penalty_Amount number
  ) is
    v_Staff Hpr_Pref.Sheet_Staff_Rt;
  begin
    v_Staff.Staff_Id       := i_Staff_Id;
    v_Staff.Accrual_Amount := i_Accrual_Amount;
    v_Staff.Penalty_Amount := i_Penalty_Amount;
  
    p_Staffs.Extend;
    p_Staffs(p_Staffs.Count) := v_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Add_Part
  (
    p_Parts            in out nocopy Hpr_Pref.Sheet_Part_Nt,
    i_Part_Begin       date,
    i_Part_End         date,
    i_Division_Id      number,
    i_Job_Id           number,
    i_Schedule_Id      number,
    i_Fte_Id           number,
    i_Monthly_Amount   number,
    i_Plan_Amount      number,
    i_Wage_Amount      number,
    i_Overtime_Amount  number,
    i_Nighttime_Amount number,
    i_Late_Amount      number,
    i_Early_Amount     number,
    i_Lack_Amount      number,
    i_Day_Skip_Amount  number,
    i_Mark_Skip_Amount number
  ) is
    v_Part Hpr_Pref.Sheet_Part_Rt;
  begin
    v_Part := Hpr_Pref.Sheet_Part_Rt(Part_Begin       => i_Part_Begin,
                                     Part_End         => i_Part_End,
                                     Division_Id      => i_Division_Id,
                                     Job_Id           => i_Job_Id,
                                     Schedule_Id      => i_Schedule_Id,
                                     Fte_Id           => i_Fte_Id,
                                     Monthly_Amount   => i_Monthly_Amount,
                                     Plan_Amount      => i_Plan_Amount,
                                     Wage_Amount      => i_Wage_Amount,
                                     Overtime_Amount  => i_Overtime_Amount,
                                     Nighttime_Amount => i_Nighttime_Amount,
                                     Late_Amount      => i_Late_Amount,
                                     Early_Amount     => i_Early_Amount,
                                     Lack_Amount      => i_Lack_Amount,
                                     Day_Skip_Amount  => i_Day_Skip_Amount,
                                     Mark_Skip_Amount => i_Mark_Skip_Amount);
  
    p_Parts.Extend;
    p_Parts(p_Parts.Count) := v_Part;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_New
  (
    o_Timebook        out Hpr_Pref.Timebook_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Timebook_Id     number,
    i_Timebook_Number varchar2,
    i_Timebook_Date   date,
    i_Period_Begin    date,
    i_Period_End      date,
    i_Period_Kind     varchar2,
    i_Division_Id     number,
    i_Note            varchar2,
    i_Staff_Ids       Array_Number
  ) is
  begin
    o_Timebook.Company_Id      := i_Company_Id;
    o_Timebook.Filial_Id       := i_Filial_Id;
    o_Timebook.Timebook_Id     := i_Timebook_Id;
    o_Timebook.Timebook_Number := i_Timebook_Number;
    o_Timebook.Timebook_Date   := i_Timebook_Date;
    o_Timebook.Period_Begin    := i_Period_Begin;
    o_Timebook.Period_End      := i_Period_End;
    o_Timebook.Period_Kind     := i_Period_Kind;
    o_Timebook.Division_Id     := i_Division_Id;
    o_Timebook.Note            := i_Note;
    o_Timebook.Staff_Ids       := i_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_New
  (
    o_Oper_Type              out Hpr_Pref.Oper_Type_Rt,
    i_Company_Id             number,
    i_Oper_Type_Id           number,
    i_Oper_Group_Id          number,
    i_Estimation_Type        varchar2,
    i_Estimation_Formula     varchar2,
    i_Operation_Kind         varchar2,
    i_Name                   varchar2,
    i_Short_Name             varchar2,
    i_Accounting_Type        varchar2,
    i_Corr_Coa_Id            number,
    i_Corr_Ref_Set           varchar2,
    i_Income_Tax_Exists      varchar2,
    i_Income_Tax_Rate        number,
    i_Pension_Payment_Exists varchar2,
    i_Pension_Payment_Rate   number,
    i_Social_Payment_Exists  varchar2,
    i_Social_Payment_Rate    number,
    i_Note                   varchar2,
    i_State                  varchar2,
    i_Code                   varchar2
  ) is
  begin
    o_Oper_Type.Oper_Type.Company_Id             := i_Company_Id;
    o_Oper_Type.Oper_Type.Oper_Type_Id           := i_Oper_Type_Id;
    o_Oper_Type.Oper_Type.Operation_Kind         := i_Operation_Kind;
    o_Oper_Type.Oper_Type.Name                   := i_Name;
    o_Oper_Type.Oper_Type.Short_Name             := i_Short_Name;
    o_Oper_Type.Oper_Type.Accounting_Type        := i_Accounting_Type;
    o_Oper_Type.Oper_Type.Corr_Coa_Id            := i_Corr_Coa_Id;
    o_Oper_Type.Oper_Type.Corr_Ref_Set           := i_Corr_Ref_Set;
    o_Oper_Type.Oper_Type.Income_Tax_Exists      := i_Income_Tax_Exists;
    o_Oper_Type.Oper_Type.Income_Tax_Rate        := i_Income_Tax_Rate;
    o_Oper_Type.Oper_Type.Pension_Payment_Exists := i_Pension_Payment_Exists;
    o_Oper_Type.Oper_Type.Pension_Payment_Rate   := i_Pension_Payment_Rate;
    o_Oper_Type.Oper_Type.Social_Payment_Exists  := i_Social_Payment_Exists;
    o_Oper_Type.Oper_Type.Social_Payment_Rate    := i_Social_Payment_Rate;
    o_Oper_Type.Oper_Type.Note                   := i_Note;
    o_Oper_Type.Oper_Type.State                  := i_State;
    o_Oper_Type.Oper_Type.Code                   := i_Code;
    o_Oper_Type.Oper_Group_Id                    := i_Oper_Group_Id;
    o_Oper_Type.Estimation_Type                  := i_Estimation_Type;
    o_Oper_Type.Estimation_Formula               := i_Estimation_Formula;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_New
  (
    o_Book         out Hpr_Pref.Book_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Book_Id      number,
    i_Book_Type_Id number,
    i_Book_Number  varchar2,
    i_Book_Date    date,
    i_Book_Name    varchar2 := null,
    i_Month        date := null,
    i_Division_Id  number := null,
    i_Currency_Id  number,
    i_Note         varchar2 := null
  ) is
    v_Book Mpr_Pref.Book_Rt;
  begin
    Mpr_Util.Book_New(o_Book        => v_Book,
                      i_Company_Id  => i_Company_Id,
                      i_Filial_Id   => i_Filial_Id,
                      i_Book_Id     => i_Book_Id,
                      i_Book_Number => i_Book_Number,
                      i_Book_Date   => i_Book_Date,
                      i_Book_Name   => i_Book_Name,
                      i_Month       => i_Month,
                      i_Division_Id => i_Division_Id,
                      i_Currency_Id => i_Currency_Id,
                      i_Note        => i_Note);
  
    o_Book.Book_Type_Id := i_Book_Type_Id;
    o_Book.Book         := v_Book;
    o_Book.Operations   := Hpr_Pref.Book_Opereration_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Add_Operation
  (
    p_Book                   in out nocopy Hpr_Pref.Book_Rt,
    i_Operation_Id           number,
    i_Staff_Id               number,
    i_Oper_Type_Id           number,
    i_Charge_Id              number,
    i_Autofilled             varchar2,
    i_Note                   varchar2,
    i_Amount                 number,
    i_Net_Amount             number,
    i_Income_Tax_Amount      number := null,
    i_Pension_Payment_Amount number := null,
    i_Social_Payment_Amount  number := null,
    i_Subfilial_Id           number := null
  ) is
    r_Staff     Href_Staffs%rowtype;
    v_Operation Hpr_Pref.Book_Operation_Rt;
    v_Book      Mpr_Pref.Book_Rt := p_Book.Book;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Book.Company_Id,
                                  i_Filial_Id  => v_Book.Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    Mpr_Util.Book_Add_Operation(p_Book                   => v_Book,
                                i_Operation_Id           => i_Operation_Id,
                                i_Employee_Id            => r_Staff.Employee_Id,
                                i_Oper_Type_Id           => i_Oper_Type_Id,
                                i_Amount                 => i_Amount,
                                i_Net_Amount             => i_Net_Amount,
                                i_Income_Tax_Amount      => i_Income_Tax_Amount,
                                i_Pension_Payment_Amount => i_Pension_Payment_Amount,
                                i_Social_Payment_Amount  => i_Social_Payment_Amount,
                                i_Subfilial_Id           => i_Subfilial_Id,
                                i_Note                   => i_Note);
  
    v_Operation.Operation_Id := i_Operation_Id;
    v_Operation.Staff_Id     := i_Staff_Id;
    v_Operation.Charge_Id    := i_Charge_Id;
    v_Operation.Autofilled   := i_Autofilled;
  
    p_Book.Book := v_Book;
    p_Book.Operations.Extend;
    p_Book.Operations(p_Book.Operations.Count) := v_Operation;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_New
  (
    o_Charge_Document out Hpr_Pref.Charge_Document_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Document_Id     number,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Document_Name   varchar2,
    i_Month           date,
    i_Oper_Type_Id    number,
    i_Currency_Id     number,
    i_Division_Id     number,
    i_Document_Kind   varchar2
  ) is
  begin
    o_Charge_Document.Company_Id      := i_Company_Id;
    o_Charge_Document.Filial_Id       := i_Filial_Id;
    o_Charge_Document.Document_Id     := i_Document_Id;
    o_Charge_Document.Document_Number := i_Document_Number;
    o_Charge_Document.Document_Date   := i_Document_Date;
    o_Charge_Document.Document_Name   := i_Document_Name;
    o_Charge_Document.Month           := i_Month;
    o_Charge_Document.Oper_Type_Id    := i_Oper_Type_Id;
    o_Charge_Document.Currency_Id     := i_Currency_Id;
    o_Charge_Document.Division_Id     := i_Division_Id;
    o_Charge_Document.Document_Kind   := i_Document_Kind;
    o_Charge_Document.Operations      := Hpr_Pref.Charge_Document_Operation_Nt();
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Charge_Document_Add_Operation
  (
    o_Charge_Document in out Hpr_Pref.Charge_Document_Rt,
    i_Operation_Id    number,
    i_Staff_Id        number,
    i_Charge_Id       number,
    i_Oper_Type_Id    number,
    i_Amount          number,
    i_Note            varchar2
  ) is
    v_Operation Hpr_Pref.Charge_Document_Operation_Rt;
  begin
    v_Operation.Operation_Id := i_Operation_Id;
    v_Operation.Staff_Id     := i_Staff_Id;
    v_Operation.Charge_Id    := i_Charge_Id;
    v_Operation.Oper_Type_Id := i_Oper_Type_Id;
    v_Operation.Amount       := i_Amount;
    v_Operation.Note         := i_Note;
  
    o_Charge_Document.Operations.Extend();
    o_Charge_Document.Operations(o_Charge_Document.Operations.Count) := v_Operation;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Advance_New
  (
    o_Advance         out nocopy Hpr_Pref.Advance_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Payment_Id      number,
    i_Payment_Number  varchar2,
    i_Payment_Date    date,
    i_Booked_Date     date,
    i_Currency_Id     number,
    i_Payment_Type    varchar2,
    i_Days_Limit      number := null,
    i_Limit_Kind      varchar2,
    i_Division_Id     number := null,
    i_Cashbox_Id      number := null,
    i_Bank_Account_Id number := null,
    i_Note            varchar2,
    i_Souce_Table     varchar2,
    i_Source_Id       number := null
  ) is
    v_Payment Mpr_Pref.Payment_Rt;
  begin
    Mpr_Util.Payment_New(o_Payment         => v_Payment,
                         i_Company_Id      => i_Company_Id,
                         i_Filial_Id       => i_Filial_Id,
                         i_Payment_Id      => i_Payment_Id,
                         i_Payment_Kind    => Mpr_Pref.c_Pk_Advance,
                         i_Payment_Number  => i_Payment_Number,
                         i_Payment_Date    => i_Payment_Date,
                         i_Booked_Date     => i_Booked_Date,
                         i_Currency_Id     => i_Currency_Id,
                         i_Payment_Type    => i_Payment_Type,
                         i_Division_Id     => i_Division_Id,
                         i_Cashbox_Id      => i_Cashbox_Id,
                         i_Bank_Account_Id => i_Bank_Account_Id,
                         i_Note            => i_Note,
                         i_Souce_Table     => i_Souce_Table,
                         i_Source_Id       => i_Source_Id);
  
    o_Advance.Payment      := v_Payment;
    o_Advance.Limit_Kind   := i_Limit_Kind;
    o_Advance.Days_Limit   := i_Days_Limit;
    o_Advance.Employee_Ids := Array_Number();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Advance_Add_Employee
  (
    p_Advance         in out nocopy Hpr_Pref.Advance_Rt,
    i_Employee_Id     number,
    i_Pay_Amount      number,
    i_Bank_Account_Id number := null,
    i_Paid_Date       date := null,
    i_Paid            varchar2 := null,
    i_Note            varchar2 := null
  ) is
  begin
    Mpr_Util.Payment_Add_Employee(p_Payment         => p_Advance.Payment,
                                  i_Employee_Id     => i_Employee_Id,
                                  i_Pay_Amount      => i_Pay_Amount,
                                  i_Bank_Account_Id => i_Bank_Account_Id,
                                  i_Paid_Date       => i_Paid_Date,
                                  i_Paid            => i_Paid,
                                  i_Note            => i_Note);
  
    Fazo.Push(p_Advance.Employee_Ids, i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_New
  (
    o_Sales_Bonus_Payment out nocopy Hpr_Pref.Sales_Bonus_Payment_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Payment_Id          number,
    i_Payment_Number      varchar2,
    i_Payment_Date        date,
    i_Payment_Name        varchar2 := null,
    i_Begin_Date          date,
    i_End_Date            date,
    i_Division_Id         number := null,
    i_Job_Id              number := null,
    i_Bonus_Type          varchar2 := null,
    i_Payment_Type        varchar2,
    i_Cashbox_Id          number := null,
    i_Bank_Account_Id     number := null,
    i_Note                varchar2 := null
  ) is
  begin
    o_Sales_Bonus_Payment.Company_Id      := i_Company_Id;
    o_Sales_Bonus_Payment.Filial_Id       := i_Filial_Id;
    o_Sales_Bonus_Payment.Payment_Id      := i_Payment_Id;
    o_Sales_Bonus_Payment.Payment_Number  := i_Payment_Number;
    o_Sales_Bonus_Payment.Payment_Date    := i_Payment_Date;
    o_Sales_Bonus_Payment.Payment_Name    := i_Payment_Name;
    o_Sales_Bonus_Payment.Begin_Date      := i_Begin_Date;
    o_Sales_Bonus_Payment.End_Date        := i_End_Date;
    o_Sales_Bonus_Payment.Division_Id     := i_Division_Id;
    o_Sales_Bonus_Payment.Job_Id          := i_Job_Id;
    o_Sales_Bonus_Payment.Bonus_Type      := i_Bonus_Type;
    o_Sales_Bonus_Payment.Payment_Type    := i_Payment_Type;
    o_Sales_Bonus_Payment.Cashbox_Id      := i_Cashbox_Id;
    o_Sales_Bonus_Payment.Bank_Account_Id := i_Bank_Account_Id;
    o_Sales_Bonus_Payment.Note            := i_Note;
  
    o_Sales_Bonus_Payment.Operations := Hpr_Pref.Sales_Bonus_Payment_Operation_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Add_Operation
  (
    p_Sales_Bonus_Payment in out nocopy Hpr_Pref.Sales_Bonus_Payment_Rt,
    i_Operation_Id        number,
    i_Staff_Id            number,
    i_Period_Begin        date,
    i_Period_End          date,
    i_Bonus_Type          varchar2,
    i_Job_Id              number,
    i_Percentage          number,
    i_Periods             Array_Date,
    i_Sales_Amounts       Array_Number,
    i_Amounts             Array_Number
  ) is
    v_Operation Hpr_Pref.Sales_Bonus_Payment_Operation_Rt;
  begin
    v_Operation.Operation_Id  := i_Operation_Id;
    v_Operation.Staff_Id      := i_Staff_Id;
    v_Operation.Period_Begin  := i_Period_Begin;
    v_Operation.Period_End    := i_Period_End;
    v_Operation.Bonus_Type    := i_Bonus_Type;
    v_Operation.Job_Id        := i_Job_Id;
    v_Operation.Percentage    := i_Percentage;
    v_Operation.Periods       := i_Periods;
    v_Operation.Sales_Amounts := i_Sales_Amounts;
    v_Operation.Amounts       := i_Amounts;
  
    p_Sales_Bonus_Payment.Operations.Extend;
    p_Sales_Bonus_Payment.Operations(p_Sales_Bonus_Payment.Operations.Count) := v_Operation;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Currency_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Array_Number is
    --------------------------------------------------
    Function Load_Setting(i_Code varchar2) return Array_Number is
      v_Ids varchar2(4000) := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Code       => i_Code);
    begin
      if v_Ids is null then
        return Array_Number();
      end if;
    
      return Fazo.To_Array_Number(Fazo.Split(v_Ids, Href_Pref.c_Settings_Separator));
    end;
  
  begin
    return Load_Setting(Hpr_Pref.c_Pref_Allow_Other_Currencies);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Use_Subfilial_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Code       => Hpr_Pref.c_Pref_Use_Subfilial_Settings),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Staff_Blocked
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Timebook_Id  number := null
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hpr_Timesheet_Locks w
     where w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Staff_Id = i_Staff_Id
       and w.Timesheet_Date >= i_Period_Begin
       and w.Timesheet_Date <= i_Period_End
       and (i_Timebook_Id is null or w.Timebook_Id <> i_Timebook_Id)
       and Rownum = 1;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Staff_Sales_Bonus_Calced
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Bonus_Type   varchar2,
    i_Period_Begin date,
    i_Period_End   date,
    i_Payment_Id   number := null,
    o_Period_Begin out date,
    o_Period_End   out date
  ) return varchar2 is
  begin
    select Greatest(w.Period_Begin, i_Period_Begin), Least(w.Period_End, i_Period_End)
      into o_Period_Begin, o_Period_End
      from Hpr_Sales_Bonus_Payment_Operations w
     where w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Staff_Id = i_Staff_Id
       and Greatest(w.Period_Begin, i_Period_Begin) <= Least(w.Period_End, i_Period_End)
       and (i_Payment_Id is null or w.Payment_Id <> i_Payment_Id)
       and exists (select 1
              from Hpr_Sales_Bonus_Payments p
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
               and p.Payment_Id = w.Payment_Id
               and p.Posted = 'Y')
       and Rownum = 1;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Jcode_Sales_Bonus_Payment(i_Payment_Id number) return varchar2 is
  begin
    return Mkr_Util.Journal_Code(i_Source_Table => Zt.Hpr_Sales_Bonus_Payments,
                                 i_Source_Id    => i_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Oper_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Oper_Group_Id
      into result
      from Hpr_Oper_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Book_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Book_Type_Id
      into result
      from Hpr_Book_Types
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  -- execution plan algorithm should be added and taken into account
  ----------------------------------------------------------------------------------------------------
  Function Formula_Execute
  (
    i_Formula   varchar2,
    i_Arguments Matrix_Varchar2
  ) return number is
    v_Formula varchar2(32767) := i_Formula;
    result    number;
  begin
    for i in 1 .. i_Arguments.Count
    loop
      v_Formula := Regexp_Replace(v_Formula,
                                  '(\W|^)' || i_Arguments(i) (1) || '(\W|$)',
                                  '\1to_number(' || i_Arguments(i) (2) || ')\2');
    end loop;
  
    execute immediate 'begin :result := ' || v_Formula || '; end;'
      using out result;
  
    return result;
  exception
    when others then
      b.Raise_Error('execution error: ' || Fazo.Zip_Matrix(i_Arguments).Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Formula_Variables(i_Formula varchar2) return Array_Varchar2 is
    v_Pattern varchar2(20) := '[^-+*\/() ]+';
    result    Array_Varchar2 := Array_Varchar2();
  begin
    Result.Extend(Regexp_Count(i_Formula, v_Pattern));
  
    for i in 1 .. Result.Count
    loop
      result(i) := Regexp_Substr(i_Formula, v_Pattern, 1, i);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  -- this function only for system oper type formula when new company added
  ----------------------------------------------------------------------------------------------------
  Function Formula_Fix
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return varchar2 is
    v_Company_Head   number := Md_Pref.c_Company_Head;
    v_Identifiers    Array_Varchar2;
    v_New_Identifier Href_Indicators.Identifier%type;
    result           Hpr_Oper_Types.Estimation_Formula%type := i_Formula;
  begin
    if i_Formula is null then
      return null;
    end if;
  
    v_Identifiers := Hpr_Util.Formula_Variables(result);
  
    Fazo.Sort_Desc(v_Identifiers);
  
    for i in 1 .. v_Identifiers.Count
    loop
      select q.Identifier
        into v_New_Identifier
        from Href_Indicators q
       where q.Company_Id = i_Company_Id
         and q.Pcode = (select w.Pcode
                          from Href_Indicators w
                         where w.Company_Id = v_Company_Head
                           and w.Identifier = v_Identifiers(i));
    
      result := Regexp_Replace(result,
                               '(\W|^)' || v_Identifiers(i) || '(\W|$)',
                               '\1' || v_New_Identifier || '\2');
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Formula_Indicators
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return Matrix_Varchar2 is
    v_Indicator_Id number;
    v_Variables    Array_Varchar2;
    result         Matrix_Varchar2 := Matrix_Varchar2();
  begin
    v_Variables := Formula_Variables(i_Formula);
  
    for i in 1 .. v_Variables.Count
    loop
      begin
        select t.Indicator_Id
          into v_Indicator_Id
          from Href_Indicators t
         where t.Company_Id = i_Company_Id
           and t.Identifier = v_Variables(i);
      
        Fazo.Push(result, Array_Varchar2(v_Indicator_Id, v_Variables(i)));
      exception
        when No_Data_Found then
          null;
      end;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Formula_Validate
  (
    i_Company_Id number,
    i_Formula    varchar2
  ) return Array_Varchar2 is
    v_Dummy     varchar2(1);
    v_Variables Array_Varchar2;
    v_Arguments Matrix_Varchar2;
    result      Array_Varchar2 := Array_Varchar2();
  begin
    v_Variables := Formula_Variables(i_Formula);
  
    for i in 1 .. v_Variables.Count
    loop
      begin
        select 'x'
          into v_Dummy
          from Href_Indicators t
         where t.Company_Id = i_Company_Id
           and t.Identifier = v_Variables(i);
      exception
        when No_Data_Found then
          if not Fazo.Is_Number(v_Variables(i)) then
            Fazo.Push(result, t('could not find indicator by identifier $1', v_Variables(i)));
          end if;
      end;
    end loop;
  
    -- sorting desc
    select Array_Varchar2(Column_Value, 'null')
      bulk collect
      into v_Arguments
      from table(v_Variables)
     order by Length(Column_Value) desc;
  
    if Result.Count = 0 then
      begin
        v_Dummy := Formula_Execute(i_Formula => i_Formula, i_Arguments => v_Arguments);
      exception
        when others then
          Fazo.Push(result, t('an error occurred while validating a formula calculation'));
      end;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Overtime_Coef(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hpr_Pref.c_Overtime_Coef),
               Hpr_Pref.c_Overtime_Coef_Default);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Constant_Indicator
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Charge_Id    number,
    i_Indicator_Id number,
    i_Period       date
  ) return number is
    r_Charge        Hpr_Charges%rowtype;
    v_Wage_Scale_Id number;
    v_Rank_Id       number;
    result          number;
  begin
    if i_Charge_Id is not null then
      r_Charge := z_Hpr_Charges.Take(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Charge_Id  => i_Charge_Id);
    
      v_Wage_Scale_Id := r_Charge.Wage_Scale_Id;
      v_Rank_Id       := r_Charge.Rank_Id;
    else
      v_Wage_Scale_Id := Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => i_Company_Id,
                                                            i_Filial_Id  => i_Filial_Id,
                                                            i_Staff_Id   => i_Staff_Id,
                                                            i_Period     => i_Period);
    
      v_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Staff_Id   => i_Staff_Id,
                                                i_Period     => i_Period);
    end if;
  
    if v_Wage_Scale_Id is not null then
      result := Hrm_Util.Closest_Wage_Scale_Indicator_Value(i_Company_Id    => i_Company_Id,
                                                            i_Filial_Id     => i_Filial_Id,
                                                            i_Wage_Scale_Id => v_Wage_Scale_Id,
                                                            i_Indicator_Id  => i_Indicator_Id,
                                                            i_Period        => i_Period,
                                                            i_Rank_Id       => v_Rank_Id);
    else
      result := Hpd_Util.Get_Closest_Indicator_Value(i_Company_Id   => i_Company_Id,
                                                     i_Filial_Id    => i_Filial_Id,
                                                     i_Staff_Id     => i_Staff_Id,
                                                     i_Indicator_Id => i_Indicator_Id,
                                                     i_Period       => i_Period);
    end if;
  
    return Nvl(result, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  -- calculate wage indicator by i_begin_date
  -- as wage on vacation is calculated by first day
  ----------------------------------------------------------------------------------------------------
  Function Calc_Wage_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
  begin
    return Calc_Constant_Indicator(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Staff_Id     => i_Staff_Id,
                                   i_Charge_Id    => i_Charge_Id,
                                   i_Indicator_Id => Href_Util.Indicator_Id(i_Company_Id => i_Company_Id, --
                                                                            i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage),
                                   i_Period       => i_Begin_Date);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Rate_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
  begin
    r_Closest_Robot := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Staff_Id   => i_Staff_Id,
                                              i_Period     => i_End_Date);
  
    return Nvl(r_Closest_Robot.Fte, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Hourly_Wage_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Charge Hpr_Charges%rowtype;
  
    v_Schedule_Id  number;
    v_Oper_Type_Id number;
  
    result number;
  begin
    if i_Charge_Id is not null then
      r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Charge_Id  => i_Charge_Id);
    
      v_Schedule_Id := r_Charge.Schedule_Id;
    else
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_End_Date);
    end if;
  
    v_Oper_Type_Id := Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => i_Company_Id,
                                                        i_Filial_Id     => i_Filial_Id,
                                                        i_Staff_Id      => i_Staff_Id,
                                                        i_Oper_Group_Id => Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                                                         i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage),
                                                        i_Period        => i_End_Date);
  
    return Calc_Hourly_Wage(i_Company_Id   => i_Company_Id,
                            i_Filial_Id    => i_Filial_Id,
                            i_Staff_Id     => i_Staff_Id,
                            i_Oper_Type_Id => v_Oper_Type_Id,
                            i_Schedule_Id  => v_Schedule_Id,
                            i_Part_Begin   => i_Begin_Date,
                            i_Part_End     => i_End_Date);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    result             number;
  begin
    r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => i_Staff_Id,
                                                    i_Period     => i_End_Date);
  
    return Htt_Util.Calc_Plan_Days(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Staff_Id    => i_Staff_Id,
                                   i_Schedule_Id => r_Closest_Schedule.Schedule_Id,
                                   i_Period      => i_End_Date);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Plan_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    result             number;
  begin
    r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => i_Staff_Id,
                                                    i_Period     => i_End_Date);
  
    result := Htt_Util.Calc_Plan_Minutes(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Staff_Id    => i_Staff_Id,
                                         i_Schedule_Id => r_Closest_Schedule.Schedule_Id,
                                         i_Period      => i_End_Date);
  
    return Nvl(Round(result / 60, 2), 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
  begin
    return Htt_Util.Calc_Working_Days(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => i_Staff_Id,
                                      i_Begin_Date => i_Begin_Date,
                                      i_End_Date   => i_End_Date);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Working_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    result number;
  begin
    result := Htt_Util.Calc_Working_Seconds(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Begin_Date => i_Begin_Date,
                                            i_End_Date   => i_End_Date);
  
    return Nvl(Round(result / 3600, 2), 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Time_Kind_Id number;
    v_Seconds      number;
    result         number;
  begin
    v_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Seconds,
                                  o_Fact_Days    => result,
                                  i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Time_Kind_Id => v_Time_Kind_Id,
                                  i_Begin_Date   => i_Begin_Date,
                                  i_End_Date     => i_End_Date);
  
    return result;
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Fact_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Time_Kind_Id number;
    result         number;
    v_Days         number;
  begin
    v_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => result,
                                  o_Fact_Days    => v_Days,
                                  i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Time_Kind_Id => v_Time_Kind_Id,
                                  i_Begin_Date   => i_Begin_Date,
                                  i_End_Date     => i_End_Date);
  
    return Nvl(Round(result / 3600, 2), 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Performance_Data
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date
  ) return Hper_Staff_Plans%rowtype is
    r_Charge        Hpr_Charges%rowtype;
    r_Staff_Plan    Hper_Staff_Plans%rowtype;
    v_Staff_Plan_Id number;
  
    --------------------------------------------------
    Function Get_Performance return Hper_Staff_Plans%rowtype is
    begin
      select q.*
        into r_Staff_Plan
        from Hper_Staff_Plans q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Month_Begin_Date = Trunc(i_Begin_Date, 'mon')
       order by Nvl((select h.Hiring_Date
                      from Hpd_Hirings h
                     where h.Company_Id = q.Company_Id
                       and h.Filial_Id = q.Filial_Id
                       and h.Page_Id = q.Journal_Page_Id
                       and h.Hiring_Date <= i_Begin_Date),
                    (select h.Transfer_Begin
                       from Hpd_Transfers h
                      where h.Company_Id = q.Company_Id
                        and h.Filial_Id = q.Filial_Id
                        and h.Page_Id = q.Journal_Page_Id
                        and h.Transfer_Begin <= i_Begin_Date)) desc nulls last
       fetch first row only;
    
      return r_Staff_Plan;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if i_Charge_Id is null then
      return Get_Performance;
    end if;
  
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    select q.Staff_Plan_Id
      into v_Staff_Plan_Id
      from Hper_Staff_Plan_Intervals q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Interval_Id = r_Charge.Interval_Id;
  
    r_Staff_Plan := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                                 i_Filial_Id     => i_Filial_Id,
                                                 i_Staff_Plan_Id => v_Staff_Plan_Id);
  
    return r_Staff_Plan;
  exception
    when No_Data_Found then
      return null;
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Bonus_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
  begin
    r_Staff_Plan := Load_Performance_Data(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Charge_Id  => i_Charge_Id,
                                          i_Begin_Date => i_Begin_Date);
  
    return Nvl(r_Staff_Plan.Main_Fact_Amount, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Extra_Bonus_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
  begin
    r_Staff_Plan := Load_Performance_Data(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Charge_Id  => i_Charge_Id,
                                          i_Begin_Date => i_Begin_Date);
  
    return Nvl(r_Staff_Plan.Extra_Fact_Amount, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Penalty_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
  begin
    r_Staff_Plan := Load_Performance_Data(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Charge_Id  => i_Charge_Id,
                                          i_Begin_Date => i_Begin_Date);
  
    return Nvl(-r_Staff_Plan.Main_Fact_Amount, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Perf_Extra_Penalty_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
  begin
    r_Staff_Plan := Load_Performance_Data(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Charge_Id  => i_Charge_Id,
                                          i_Begin_Date => i_Begin_Date);
  
    return Nvl(-r_Staff_Plan.Extra_Fact_Amount, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Average_Perf
  (
    o_Main_Fact_Amount  out number,
    o_Extra_Fact_Amount out number,
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Staff_Id          number,
    i_Period            date
  ) is
    r_Staff      Href_Staffs%rowtype;
    v_Begin_Date date;
    v_End_Date   date;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_End_Date   := i_Period;
    v_Begin_Date := Add_Months(v_End_Date, -12);
  
    v_Begin_Date := Trunc(Greatest(v_Begin_Date, r_Staff.Hiring_Date), 'mon');
    v_End_Date   := Trunc(Greatest(Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date)),
                                   r_Staff.Hiring_Date),
                          'mon');
  
    select avg(q.Main_Fact_Amount), avg(q.Extra_Fact_Amount)
      into o_Main_Fact_Amount, o_Extra_Fact_Amount
      from Hper_Staff_Plans q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Plan_Date between v_Begin_Date and v_End_Date
       and q.Status = Hper_Pref.c_Staff_Plan_Status_Completed;
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perf_Bonus
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Dummy            number;
    v_Main_Fact_Amount number;
  begin
    Calc_Average_Perf(o_Main_Fact_Amount  => v_Main_Fact_Amount,
                      o_Extra_Fact_Amount => v_Dummy,
                      i_Company_Id        => i_Company_Id,
                      i_Filial_Id         => i_Filial_Id,
                      i_Staff_Id          => i_Staff_Id,
                      i_Period            => i_Begin_Date);
  
    return Nvl(v_Main_Fact_Amount, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perf_Extra_Bonus
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Dummy             number;
    v_Extra_Fact_Amount number;
  begin
    Calc_Average_Perf(o_Main_Fact_Amount  => v_Dummy,
                      o_Extra_Fact_Amount => v_Extra_Fact_Amount,
                      i_Company_Id        => i_Company_Id,
                      i_Filial_Id         => i_Filial_Id,
                      i_Staff_Id          => i_Staff_Id,
                      i_Period            => i_Begin_Date);
  
    return Nvl(v_Extra_Fact_Amount, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Sick_Leave_Coefficient_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Timeoff_Id number;
    result       number;
  begin
    begin
      select q.Timeoff_Id
        into v_Timeoff_Id
        from Hpd_Timeoff_Intervals q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Interval_Id = (select w.Interval_Id
                                from Hpr_Charges w
                               where w.Company_Id = i_Company_Id
                                 and w.Filial_Id = i_Filial_Id
                                 and w.Charge_Id = i_Charge_Id);
    exception
      when No_Data_Found then
        return 0;
    end;
  
    result := z_Hpd_Sick_Leaves.Take( --
              i_Company_Id => i_Company_Id, --
              i_Filial_Id => i_Filial_Id, --
              i_Timeoff_Id => v_Timeoff_Id).Coefficient;
  
    return Nvl(result, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Business_Trip_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Fact_Days number;
  begin
    v_Fact_Days := Htt_Util.Calc_Locked_Turnout_Days(i_Company_Id => i_Company_Id,
                                                     i_Filial_Id  => i_Filial_Id,
                                                     i_Staff_Id   => i_Staff_Id,
                                                     i_Begin_Date => i_Begin_Date,
                                                     i_End_Date   => i_End_Date);
  
    return Nvl((i_End_Date - i_Begin_Date + 1) - v_Fact_Days, 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
  begin
    return Htt_Util.Calc_Vacation_Days(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Begin_Date => i_Begin_Date,
                                       i_End_Date   => i_End_Date);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Sick_Leave_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Working_Days number;
    v_Fact_Days    number;
  begin
    v_Working_Days := Calc_Working_Days_Indicator(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Charge_Id  => i_Charge_Id,
                                                  i_Begin_Date => i_Begin_Date,
                                                  i_End_Date   => i_End_Date);
  
    v_Fact_Days := Htt_Util.Calc_Locked_Turnout_Days(i_Company_Id => i_Company_Id,
                                                     i_Filial_Id  => i_Filial_Id,
                                                     i_Staff_Id   => i_Staff_Id,
                                                     i_Begin_Date => i_Begin_Date,
                                                     i_End_Date   => i_End_Date);
  
    return v_Working_Days - v_Fact_Days;
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Mean_Working_Days_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_First_Day  date := Trunc(i_Begin_Date, 'y');
    v_Last_Day   date := Add_Months(v_First_Day, 12) - 1;
    v_Days_Count number := v_Last_Day - v_First_Day + 1;
  
    v_Default_Calendar_Id      number;
    v_Official_Rest_Days_Count number;
  begin
    v_Default_Calendar_Id := Htt_Util.Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id);
  
    v_Official_Rest_Days_Count := Htt_Util.Official_Rest_Days_Count(i_Company_Id  => i_Company_Id,
                                                                    i_Filial_Id   => i_Filial_Id,
                                                                    i_Calendar_Id => v_Default_Calendar_Id,
                                                                    i_Begin_Date  => v_First_Day,
                                                                    i_End_Date    => v_Last_Day);
  
    return Nvl(Round((v_Days_Count - v_Official_Rest_Days_Count) / 12, 1), 0);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Overtime_Hours_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Fact_Seconds number;
    v_Fact_Days    number;
  begin
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Seconds,
                                  o_Fact_Days    => v_Fact_Days,
                                  i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime),
                                  i_Begin_Date   => i_Begin_Date,
                                  i_End_Date     => i_End_Date);
  
    return Round(v_Fact_Seconds / 3600, 2);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Overtime_Coef_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
  begin
    return Load_Overtime_Coef(i_Company_Id);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Additional_Nighttime_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Policy_Id   number;
    v_Division_Id number;
    result        number;
  begin
    v_Division_Id := Hpd_Util.Get_Closest_Division_Id(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Staff_Id   => i_Staff_Id,
                                                      i_Period     => i_End_Date);
  
    return Round(Calc_Additional_Nighttime_Amount(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Staff_Id    => i_Staff_Id,
                                                  i_Division_Id => v_Division_Id,
                                                  i_Begin_Date  => i_Begin_Date,
                                                  i_End_Date    => i_End_Date) / 3600,
                 2);
  end;

  -- Calc_Indicator_Value da oson foydalanish uchun keraksiz argumentlar input qilingan
  ----------------------------------------------------------------------------------------------------
  Function Calc_Weighted_Turnout_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
  begin
    return Round(Htt_Util.Calc_Weighted_Turnout_Seconds(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Begin_Date => i_Begin_Date,
                                                        i_End_Date   => i_End_Date) / 3600,
                 2);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Gen
  (
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return varchar2 is
  begin
    if i_Charge_Id is not null then
      return i_Charge_Id;
    end if;
  
    return i_Staff_Id || --
    Href_Pref.c_Settings_Separator || --
    to_char(i_Begin_Date, Href_Pref.c_Date_Format_Day) || --
    Href_Pref.c_Settings_Separator || --
    to_char(i_End_Date, Href_Pref.c_Date_Format_Day);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_Indicators
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Charge_Id     number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Penalty_Pcode varchar2
  ) return number is
    r_Charge      Hpr_Charges%rowtype;
    v_Hourly_Wage number := 0;
    v_Division_Id number;
    v_Schedule_Id number;
    v_Code        varchar(50);
  
    v_Oper_Type_Ids Array_Number;
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    if i_Charge_Id is not null then
      r_Charge := z_Hpr_Charges.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Charge_Id  => i_Charge_Id);
    
      v_Division_Id := r_Charge.Division_Id;
      v_Schedule_Id := r_Charge.Schedule_Id;
    else
      v_Division_Id := Hpd_Util.Get_Closest_Division_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_End_Date);
    
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_End_Date);
    end if;
  
    v_Oper_Type_Ids := Hpd_Util.Get_Closest_Oper_Type_Ids(i_Company_Id    => i_Company_Id,
                                                          i_Filial_Id     => i_Filial_Id,
                                                          i_Staff_Id      => i_Staff_Id,
                                                          i_Oper_Group_Id => Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                                                           i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage),
                                                          i_Period        => i_End_Date);
  
    for i in 1 .. v_Oper_Type_Ids.Count
    loop
      v_Hourly_Wage := v_Hourly_Wage +
                       Calc_Hourly_Wage(i_Company_Id   => i_Company_Id,
                                        i_Filial_Id    => i_Filial_Id,
                                        i_Staff_Id     => i_Staff_Id,
                                        i_Oper_Type_Id => v_Oper_Type_Ids(i),
                                        i_Schedule_Id  => v_Schedule_Id,
                                        i_Part_Begin   => i_Begin_Date,
                                        i_Part_End     => i_End_Date);
    end loop;
  
    Calc_Penalty_Amounts(o_Late_Amount      => g_Cache_Late_Amount(v_Code),
                         o_Early_Amount     => g_Cache_Early_Amount(v_Code),
                         o_Lack_Amount      => g_Cache_Lack_Amount(v_Code),
                         o_Day_Skip_Amount  => g_Cache_Day_Skip_Amount(v_Code),
                         o_Mark_Skip_Amount => g_Cache_Mark_Skip_Amount(v_Code),
                         i_Company_Id       => i_Company_Id,
                         i_Filial_Id        => i_Filial_Id,
                         i_Staff_Id         => i_Staff_Id,
                         i_Division_Id      => v_Division_Id,
                         i_Hourly_Wage      => v_Hourly_Wage,
                         i_Period_Begin     => i_Begin_Date,
                         i_Period_End       => i_End_Date);
  
    case i_Penalty_Pcode
      when Href_Pref.c_Pcode_Indicator_Penalty_For_Late then
        return g_Cache_Late_Amount(v_Code);
      when Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output then
        return g_Cache_Early_Amount(v_Code);
      when Href_Pref.c_Pcode_Indicator_Penalty_For_Absence then
        return g_Cache_Lack_Amount(v_Code);
      when Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip then
        return g_Cache_Day_Skip_Amount(v_Code);
      when Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip then
        return g_Cache_Mark_Skip_Amount(v_Code);
      else
        return null;
    end case;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Late_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Code varchar(50);
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    return g_Cache_Late_Amount(v_Code);
  
  exception
    when No_Data_Found then
      return Calc_Penalty_Indicators(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Id      => i_Staff_Id,
                                     i_Charge_Id     => i_Charge_Id,
                                     i_Begin_Date    => i_Begin_Date,
                                     i_End_Date      => i_End_Date,
                                     i_Penalty_Pcode => Href_Pref.c_Pcode_Indicator_Penalty_For_Late);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Early_Output_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Code varchar(50);
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    return g_Cache_Early_Amount(v_Code);
  
  exception
    when No_Data_Found then
      return Calc_Penalty_Indicators(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Id      => i_Staff_Id,
                                     i_Charge_Id     => i_Charge_Id,
                                     i_Begin_Date    => i_Begin_Date,
                                     i_End_Date      => i_End_Date,
                                     i_Penalty_Pcode => Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Absence_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Code varchar(50);
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    return g_Cache_Lack_Amount(v_Code);
  
  exception
    when No_Data_Found then
      return Calc_Penalty_Indicators(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Id      => i_Staff_Id,
                                     i_Charge_Id     => i_Charge_Id,
                                     i_Begin_Date    => i_Begin_Date,
                                     i_End_Date      => i_End_Date,
                                     i_Penalty_Pcode => Href_Pref.c_Pcode_Indicator_Penalty_For_Absence);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Day_Skip_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Code varchar(50);
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    return g_Cache_Day_Skip_Amount(v_Code);
  
  exception
    when No_Data_Found then
      return Calc_Penalty_Indicators(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Id      => i_Staff_Id,
                                     i_Charge_Id     => i_Charge_Id,
                                     i_Begin_Date    => i_Begin_Date,
                                     i_End_Date      => i_End_Date,
                                     i_Penalty_Pcode => Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Penalty_For_Mark_Skip_Indicator
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Code varchar(50);
  begin
    v_Code := Code_Gen(i_Staff_Id   => i_Staff_Id,
                       i_Charge_Id  => i_Charge_Id,
                       i_Begin_Date => i_Begin_Date,
                       i_End_Date   => i_End_Date);
  
    return g_Cache_Mark_Skip_Amount(v_Code);
  
  exception
    when No_Data_Found then
      return Calc_Penalty_Indicators(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Id      => i_Staff_Id,
                                     i_Charge_Id     => i_Charge_Id,
                                     i_Begin_Date    => i_Begin_Date,
                                     i_End_Date      => i_End_Date,
                                     i_Penalty_Pcode => Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Procedures(i_Pcode varchar2) return varchar2 is
  begin
    return --
    case i_Pcode --
    when Href_Pref.c_Pcode_Indicator_Wage then 'hpr_util.calc_wage_indicator' --
    when Href_Pref.c_Pcode_Indicator_Rate then 'hpr_util.calc_rate_indicator' --
    when Href_Pref.c_Pcode_Indicator_Hourly_Wage then 'hpr_util.calc_hourly_wage_indicator' --
    when Href_Pref.c_Pcode_Indicator_Plan_Days then 'hpr_util.calc_plan_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Plan_Hours then 'hpr_util.calc_plan_hours_indicator' --
    when Href_Pref.c_Pcode_Indicator_Working_Days then 'hpr_util.calc_working_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Working_Hours then 'hpr_util.calc_working_hours_indicator' --
    when Href_Pref.c_Pcode_Indicator_Fact_Days then 'hpr_util.calc_fact_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Fact_Hours then 'hpr_util.calc_fact_hours_indicator' --
    when Href_Pref.c_Pcode_Indicator_Perf_Bonus then 'hpr_util.calc_perf_bonus_indicator' --
    when Href_Pref.c_Pcode_Indicator_Perf_Extra_Bonus then 'hpr_util.calc_perf_extra_bonus_indicator' --
    when Href_Pref.c_Pcode_Indicator_Sick_Leave_Coefficient then 'hpr_util.calc_sick_leave_coefficient_indicator' --
    when Href_Pref.c_Pcode_Indicator_Business_Trip_Days then 'hpr_util.calc_business_trip_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Vacation_Days then 'hpr_util.calc_vacation_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Mean_Working_Days then 'hpr_util.calc_mean_working_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Sick_Leave_Days then 'hpr_util.calc_sick_leave_days_indicator' --
    when Href_Pref.c_Pcode_Indicator_Overtime_Hours then 'hpr_util.calc_overtime_hours_indicator' --
    when Href_Pref.c_Pcode_Indicator_Overtime_Coef then 'hpr_util.calc_overtime_coef_indicator' --
    when Href_Pref.c_Pcode_Indicator_Penalty_For_Late then 'hpr_util.calc_penalty_for_late_indicator' --
    when Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output then 'hpr_util.calc_penalty_for_early_output_indicator' --
    when Href_Pref.c_Pcode_Indicator_Penalty_For_Absence then 'hpr_util.calc_penalty_for_absence_indicator' --
    when Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip then 'hpr_util.calc_penalty_for_day_skip_indicator' --
    when Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip then 'hpr_util.calc_penalty_for_mark_skip_indicator' --
    when Href_Pref.c_Pcode_Indicator_Perf_Penalty then 'hpr_util.calc_perf_penalty_indicator' --
    when Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty then 'hpr_util.calc_perf_extra_penalty_indicator' --
    when Href_Pref.c_Pcode_Indicator_Additional_Nighttime then 'hpr_util.calc_additional_nighttime_indicator' --
    when Href_Pref.c_Pcode_Indicator_Weighted_Turnout then 'hpr_util.calc_weighted_turnout_indicator' --
    when Href_Pref.c_Pcode_Indicator_Average_Perf_Bonus then 'hpr_util.calc_average_perf_bonus' --
    when Href_Pref.c_Pcode_Indicator_Average_Perf_Extra_Bonus then 'hpr_util.calc_average_perf_extra_bonus' --
    else null end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Charge_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Indicator_Id number
  ) return number is
    v_Proc      varchar2(100);
    r_Indicator Href_Indicators%rowtype;
    result      number;
  
    --------------------------------------------------
    Function Convert_Indicator_Amount
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Staff_Id   number,
      i_Indicator  Href_Indicators%rowtype,
      i_Period     date,
      i_Amount     number
    ) return number is
      v_Currency_Id number;
    begin
      if i_Indicator.Used != Href_Pref.c_Indicator_Used_Constantly and
         i_Indicator.Pcode not in
         (Href_Pref.c_Pcode_Indicator_Perf_Penalty, Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty) then
        return i_Amount;
      end if;
    
      v_Currency_Id := Hpd_Util.Get_Closest_Currency_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_Period);
    
      if v_Currency_Id is null then
        return i_Amount;
      end if;
    
      return Mk_Util.Calc_Amount_Base(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Currency_Id => v_Currency_Id,
                                      i_Rate_Date   => i_Period,
                                      i_Amount      => i_Amount);
    end;
  begin
    r_Indicator := z_Href_Indicators.Load(i_Company_Id   => i_Company_Id, --
                                          i_Indicator_Id => i_Indicator_Id);
  
    v_Proc := Indicator_Procedures(r_Indicator.Pcode);
  
    if v_Proc is not null then
      execute immediate 'declare begin :result := ' || v_Proc ||
                        '(:company_id, :filial_id, :staff_id, :charge_id, :begin_date, :end_date); end;'
        using out result, i_Company_Id, i_Filial_Id, i_Staff_Id, i_Charge_Id, i_Begin_Date, i_End_Date;
    else
      result := Calc_Constant_Indicator(i_Company_Id   => i_Company_Id,
                                        i_Filial_Id    => i_Filial_Id,
                                        i_Staff_Id     => i_Staff_Id,
                                        i_Charge_Id    => i_Charge_Id,
                                        i_Indicator_Id => i_Indicator_Id,
                                        i_Period       => i_End_Date);
    end if;
  
    result := Convert_Indicator_Amount(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Indicator  => r_Indicator,
                                       i_Period     => i_End_Date,
                                       i_Amount     => result);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Hourly_Wage
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Schedule_Id  number,
    i_Part_Begin   date,
    i_Part_End     date
  ) return number is
    v_Monthly_Amount  number;
    v_Monthly_Minutes number;
  begin
    v_Monthly_Amount := Calc_Amount(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => i_Staff_Id,
                                    i_Oper_Type_Id => i_Oper_Type_Id,
                                    i_Part_Begin   => i_Part_Begin,
                                    i_Part_End     => i_Part_End,
                                    i_Calc_Planned => true);
  
    v_Monthly_Minutes := Htt_Util.Calc_Plan_Minutes(i_Company_Id  => i_Company_Id,
                                                    i_Filial_Id   => i_Filial_Id,
                                                    i_Staff_Id    => i_Staff_Id,
                                                    i_Schedule_Id => i_Schedule_Id,
                                                    i_Period      => i_Part_End);
  
    return v_Monthly_Amount / v_Monthly_Minutes * 60;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Amount
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number
  ) return number is
    r_Oper_Type Hpr_Oper_Types%rowtype;
    r_Charge    Hpr_Charges%rowtype;
    v_Arguments Matrix_Varchar2;
  begin
    r_Charge := z_Hpr_Charges.Load(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Charge_Id  => i_Charge_Id);
  
    r_Oper_Type := z_Hpr_Oper_Types.Load(i_Company_Id   => i_Company_Id,
                                         i_Oper_Type_Id => r_Charge.Oper_Type_Id);
  
    if r_Oper_Type.Estimation_Type <> Hpr_Pref.c_Estimation_Type_Formula then
      return 0;
    end if;
  
    select Array_Varchar2(w.Identifier, q.Indicator_Value)
      bulk collect
      into v_Arguments
      from Hpr_Charge_Indicators q
      join Href_Indicators w
        on w.Company_Id = q.Company_Id
       and w.Indicator_Id = q.Indicator_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Charge_Id = i_Charge_Id
     order by Length(w.Identifier) desc;
  
    return Formula_Execute(i_Formula   => r_Oper_Type.Estimation_Formula, --
                           i_Arguments => v_Arguments);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Amount_With_Indicators
  (
    o_Indicators   out Hpr_Pref.Daily_Indicators_Nt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Part_Begin   date,
    i_Part_End     date,
    i_Calc_Planned boolean := false,
    i_Calc_Worked  boolean := false
  ) return number is
    r_Oper_Type Hpr_Oper_Types%rowtype;
    v_Arguments Matrix_Varchar2 := Matrix_Varchar2();
  
    v_Indicator_Id    number;
    v_Indicator_Value number;
  
    v_Fact_Hours_Id     number := -1;
    v_Weighted_Hours_Id number := -1;
    v_Fact_Days_Id      number := -1;
    v_Plan_Hours_Id     number := -1;
    v_Plan_Days_Id      number := -1;
    v_Worked_Hours_Id   number := -1;
    v_Worked_Days_Id    number := -1;
  
    --------------------------------------------------
    Procedure Load_Indicator_Ids is
    begin
      v_Fact_Hours_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Indicator_Fact_Hours);
    
      v_Weighted_Hours_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Weighted_Turnout);
    
      v_Fact_Days_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                               i_Pcode      => Href_Pref.c_Pcode_Indicator_Fact_Days);
    
      if i_Calc_Planned then
        v_Plan_Hours_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Plan_Hours);
      
        v_Plan_Days_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                 i_Pcode      => Href_Pref.c_Pcode_Indicator_Plan_Days);
      end if;
    
      if i_Calc_Worked then
        v_Worked_Hours_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Working_Hours);
      
        v_Worked_Days_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Href_Pref.c_Pcode_Indicator_Working_Days);
      end if;
    end;
  
    --------------------------------------------------
    Function Replaced_Indicator_Id(i_Indicator_Id number) return number is
    begin
      case
        when i_Indicator_Id = v_Fact_Hours_Id and i_Calc_Planned then
          return v_Plan_Hours_Id;
        when i_Indicator_Id = v_Weighted_Hours_Id and i_Calc_Planned then
          return v_Plan_Hours_Id;
        when i_Indicator_Id = v_Fact_Days_Id and i_Calc_Planned then
          return v_Plan_Days_Id;
        when i_Indicator_Id = v_Fact_Hours_Id and i_Calc_Worked then
          return v_Worked_Hours_Id;
        when i_Indicator_Id = v_Weighted_Hours_Id and i_Calc_Worked then
          return v_Worked_Hours_Id;
        when i_Indicator_Id = v_Fact_Days_Id and i_Calc_Worked then
          return v_Worked_Days_Id;
        else
          null;
      end case;
    
      return i_Indicator_Id;
    end;
  begin
    if i_Oper_Type_Id is null then
      return 0;
    end if;
  
    r_Oper_Type := z_Hpr_Oper_Types.Load(i_Company_Id   => i_Company_Id,
                                         i_Oper_Type_Id => i_Oper_Type_Id);
  
    if r_Oper_Type.Estimation_Type <> Hpr_Pref.c_Estimation_Type_Formula then
      return 0;
    end if;
  
    if i_Calc_Planned or i_Calc_Worked then
      Load_Indicator_Ids;
    end if;
  
    o_Indicators := Hpr_Pref.Daily_Indicators_Nt();
  
    for r in (select q.Indicator_Id, q.Identifier
                from Hpr_Oper_Type_Indicators q
               where q.Company_Id = i_Company_Id
                 and q.Oper_Type_Id = i_Oper_Type_Id)
    loop
      v_Indicator_Id := r.Indicator_Id;
    
      if (i_Calc_Planned or i_Calc_Worked) and
         v_Indicator_Id in (v_Fact_Hours_Id, v_Fact_Days_Id, v_Weighted_Hours_Id) then
        v_Indicator_Id := Replaced_Indicator_Id(v_Indicator_Id);
      end if;
    
      v_Indicator_Value := Calc_Indicator_Value(i_Company_Id   => i_Company_Id,
                                                i_Filial_Id    => i_Filial_Id,
                                                i_Staff_Id     => i_Staff_Id,
                                                i_Charge_Id    => null,
                                                i_Begin_Date   => i_Part_Begin,
                                                i_End_Date     => i_Part_End,
                                                i_Indicator_Id => v_Indicator_Id);
    
      Fazo.Push(v_Arguments, Array_Varchar2(r.Identifier, v_Indicator_Value));
    
      o_Indicators.Extend;
      o_Indicators(o_Indicators.Count) := Hpr_Pref.Daily_Indicators_Rt(r.Indicator_Id,
                                                                       v_Indicator_Value);
    end loop;
  
    return Formula_Execute(i_Formula   => r_Oper_Type.Estimation_Formula, --
                           i_Arguments => v_Arguments);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Amount
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Part_Begin   date,
    i_Part_End     date,
    i_Calc_Planned boolean := false,
    i_Calc_Worked  boolean := false
  ) return number is
    v_Dummy Hpr_Pref.Daily_Indicators_Nt;
  begin
    return Calc_Amount_With_Indicators(o_Indicators   => v_Dummy,
                                       i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Staff_Id     => i_Staff_Id,
                                       i_Oper_Type_Id => i_Oper_Type_Id,
                                       i_Part_Begin   => i_Part_Begin,
                                       i_Part_End     => i_Part_End,
                                       i_Calc_Planned => i_Calc_Planned,
                                       i_Calc_Worked  => i_Calc_Worked);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Amounts
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Currency_Id            number,
    i_Date                   date,
    i_Oper_Type_Id           number,
    i_Amount                 number,
    i_Is_Net_Amount          boolean,
    o_Amount                 out number,
    o_Net_Amount             out number,
    o_Income_Tax_Amount      out number,
    o_Pension_Payment_Amount out number,
    o_Social_Payment_Amount  out number
  ) is
    r_Oper_Type   Mpr_Oper_Types%rowtype;
    r_Setting     Mpr_Settings%rowtype;
    v_Currency_Id number := i_Currency_Id;
    --------------------------------------------------
    Function Round_Amount(i_Val number) return number is
    begin
      return Mk_Util.Round_Amount(i_Company_Id  => i_Company_Id,
                                  i_Currency_Id => v_Currency_Id,
                                  i_Amount      => i_Val);
    end;
    --------------------------------------------------
    Function Calc_Base_Amount(i_Val number) return number is
    begin
      return Mk_Util.Calc_Amount_Base(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Currency_Id => v_Currency_Id,
                                      i_Rate_Date   => i_Date,
                                      i_Amount      => i_Val);
    end;
  begin
    r_Oper_Type := z_Mpr_Oper_Types.Load(i_Company_Id   => i_Company_Id,
                                         i_Oper_Type_Id => i_Oper_Type_Id);
  
    r_Setting := z_Mpr_Settings.Load(i_Company_Id => i_Company_Id, --
                                     i_Filial_Id  => i_Filial_Id);
  
    if i_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id);
    end if;
  
    o_Amount                 := Round_Amount(i_Amount);
    o_Net_Amount             := Round_Amount(i_Amount);
    o_Income_Tax_Amount      := 0;
    o_Pension_Payment_Amount := 0;
    o_Social_Payment_Amount  := 0;
  
    if r_Setting.Income_Tax_Exists = 'Y' and r_Oper_Type.Income_Tax_Exists = 'Y' then
      if i_Is_Net_Amount then
        o_Amount := Round_Amount(o_Net_Amount * 100 /
                                 (100 - Nvl(r_Oper_Type.Income_Tax_Rate, r_Setting.Income_Tax_Rate)));
      else
        o_Net_Amount := o_Amount -
                        Round_Amount(o_Amount *
                                     Nvl(r_Oper_Type.Income_Tax_Rate, r_Setting.Income_Tax_Rate) / 100);
      end if;
    
      o_Income_Tax_Amount := Round_Amount((o_Amount * Nvl(r_Oper_Type.Income_Tax_Rate,
                                                          r_Setting.Income_Tax_Rate) / 100));
    
      if r_Setting.Pension_Payment_Exists = 'Y' and r_Oper_Type.Pension_Payment_Exists = 'Y' then
        o_Pension_Payment_Amount := Round_Amount((o_Amount *
                                                 Nvl(r_Oper_Type.Pension_Payment_Rate,
                                                      r_Setting.Pension_Payment_Rate) / 100));
      
      end if;
    end if;
  
    if r_Setting.Social_Payment_Exists = 'Y' and r_Oper_Type.Social_Payment_Exists = 'Y' then
      o_Social_Payment_Amount := Round_Amount((o_Amount *
                                              Nvl(r_Oper_Type.Social_Payment_Rate,
                                                   r_Setting.Social_Payment_Rate) / 100));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- calculates penalty for (begin, end) period
  -- ignores policy changes between (begin, end)
  -- takes policy closest to period_begin date
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Penalty_Amount
  (
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    o_Day_Amounts      out nocopy Matrix_Number,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Division_Id      number,
    i_Hourly_Wage      number,
    i_Period_Begin     date,
    i_Period_End       date
  ) is
    v_Late_Id        number;
    v_Early_Id       number;
    v_Lack_Id        number;
    v_Time_Kind_Id   number;
    v_Penalty_Id     number;
    v_Days_Cnt       number;
    v_Penalty_Amount number;
    v_Policy         Hpr_Pref.Penalty_Policy_Rt;
    v_Policies       Hpr_Pref.Penalty_Policy_Nt;
  
    v_Fact_Tk_Id    number;
    v_Fact_Value    number;
    v_Plan_Time     number;
    v_Input_Time    date;
    v_Output_Time   date;
    v_Input_Times   Array_Date;
    v_Output_Times  Array_Date;
    v_Fact_Date     date;
    v_Fact_Dates    Array_Date;
    v_Mark_Dates    Array_Date;
    v_Skipped_Marks Array_Number;
    v_Facts         Matrix_Number;
  
    v_Wage_Per_Minute number := i_Hourly_Wage / 60;
  
    --------------------------------------------------
    Procedure Init_Day_Amounts is
      v_Count number;
    begin
      o_Day_Amounts := Matrix_Number();
      v_Count       := i_Period_End - Trunc(i_Period_Begin, 'Mon') + 1;
    
      o_Day_Amounts.Extend(v_Count);
    
      for i in 1 .. v_Count
      loop
        o_Day_Amounts(i) := Array_Number(0, 0, 0, 0, 0);
      end loop;
    end;
  
    --------------------------------------------------
    Function Day_Index(i_Date date) return number is
    begin
      return i_Date - Trunc(i_Period_Begin, 'Mon') + 1;
    end;
  
    --------------------------------------------------
    Function To_Minutes(i_Sec number) return number is
    begin
      return Round(i_Sec / 60, 2);
    end;
  
    --------------------------------------------------
    Function Get_Tk_Id(i_Penalty_Kind varchar2) return number is
    begin
      case i_Penalty_Kind
        when Hpr_Pref.c_Penalty_Kind_Late then
          return v_Late_Id;
        when Hpr_Pref.c_Penalty_Kind_Early then
          return v_Early_Id;
        when Hpr_Pref.c_Penalty_Kind_Lack then
          return v_Lack_Id;
        when Hpr_Pref.c_Penalty_Kind_Day_Skip then
          return v_Lack_Id;
        else
          b.Raise_Not_Implemented;
      end case;
    end;
  
    --------------------------------------------------
    Function Calc_Amount
    (
      i_Policy          Hpr_Pref.Penalty_Policy_Rt,
      i_Wage_Per_Minute number,
      i_Facts_Value     number
    ) return number is
      v_Calc_After_From_Time boolean := Nvl(i_Policy.Calc_After_From_Time, 'N') = 'Y';
    begin
      case i_Policy.Penalty_Type
        when Hpr_Pref.c_Penalty_Type_Coef then
          if v_Calc_After_From_Time then
            return i_Wage_Per_Minute * To_Minutes(i_Facts_Value - i_Policy.From_Time) * i_Policy.Penalty_Coef;
          else
            return i_Wage_Per_Minute * To_Minutes(i_Facts_Value) * i_Policy.Penalty_Coef;
          end if;
        when Hpr_Pref.c_Penalty_Type_Amount then
          if i_Policy.Penalty_Per_Time is null then
            return i_Policy.Penalty_Amount;
          else
            if v_Calc_After_From_Time then
              return i_Policy.Penalty_Amount * Trunc(To_Minutes(i_Facts_Value - i_Policy.From_Time) /
                                                     i_Policy.Penalty_Per_Time);
            else
              return i_Policy.Penalty_Amount * Trunc(To_Minutes(i_Facts_Value) /
                                                     i_Policy.Penalty_Per_Time);
            end if;
          end if;
        when Hpr_Pref.c_Penalty_Type_Time then
          return i_Wage_Per_Minute * i_Policy.Penalty_Time;
        else
          b.Raise_Not_Implemented;
      end case;
    end;
  
    --------------------------------------------------
    Procedure Add_Amounts
    (
      i_Policy          Hpr_Pref.Penalty_Policy_Rt,
      i_Penalty_Amount  number,
      i_Day_Index       number,
      p_Late_Amount     in out number,
      p_Early_Amount    in out number,
      p_Lack_Amount     in out number,
      p_Day_Skip_Amount in out number
    ) is
    begin
      case i_Policy.Penalty_Kind
        when Hpr_Pref.c_Penalty_Kind_Late then
          p_Late_Amount := p_Late_Amount + i_Penalty_Amount;
        
          o_Day_Amounts(i_Day_Index)(1) := o_Day_Amounts(i_Day_Index) (1) + i_Penalty_Amount;
        when Hpr_Pref.c_Penalty_Kind_Early then
          p_Early_Amount := p_Early_Amount + i_Penalty_Amount;
        
          o_Day_Amounts(i_Day_Index)(2) := o_Day_Amounts(i_Day_Index) (2) + i_Penalty_Amount;
        when Hpr_Pref.c_Penalty_Kind_Lack then
          p_Lack_Amount := p_Lack_Amount + i_Penalty_Amount;
        
          o_Day_Amounts(i_Day_Index)(3) := o_Day_Amounts(i_Day_Index) (3) + i_Penalty_Amount;
        when Hpr_Pref.c_Penalty_Kind_Day_Skip then
          p_Day_Skip_Amount := p_Day_Skip_Amount + i_Penalty_Amount;
        
          o_Day_Amounts(i_Day_Index)(4) := o_Day_Amounts(i_Day_Index) (4) + i_Penalty_Amount;
        else
          b.Raise_Not_Implemented;
      end case;
    end;
  
    --------------------------------------------------
    Procedure Add_Amounts
    (
      i_Penalty_Kind     varchar2,
      i_Penalty_Amount   number,
      i_Day_Index        number,
      p_Mark_Skip_Amount in out number
    ) is
    begin
      case i_Penalty_Kind
        when Hpr_Pref.c_Penalty_Kind_Mark_Skip then
          p_Mark_Skip_Amount := p_Mark_Skip_Amount + i_Penalty_Amount;
        
          o_Day_Amounts(i_Day_Index)(5) := o_Day_Amounts(i_Day_Index) (5) + i_Penalty_Amount;
        else
          b.Raise_Not_Implemented;
      end case;
    end;
  begin
    o_Late_Amount      := 0;
    o_Early_Amount     := 0;
    o_Lack_Amount      := 0;
    o_Day_Skip_Amount  := 0;
    o_Mark_Skip_Amount := 0;
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Early_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                        i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
  
    v_Lack_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    v_Penalty_Id := Get_Closest_Penalty_Id(i_Company_Id  => i_Company_Id,
                                           i_Filial_Id   => i_Filial_Id,
                                           i_Division_Id => i_Division_Id,
                                           i_Period      => i_Period_Begin);
  
    select Pp.Penalty_Kind,
           case
              when Pp.Penalty_Coef is not null then
               Hpr_Pref.c_Penalty_Type_Coef
              when Pp.Penalty_Amount is not null then
               Hpr_Pref.c_Penalty_Type_Amount
              when Pp.Penalty_Time is not null then
               Hpr_Pref.c_Penalty_Type_Time
            end case,
           Pp.From_Day,
           Pp.To_Day,
           Pp.From_Time * case
              when Pp.Penalty_Kind = Hpr_Pref.c_Penalty_Kind_Mark_Skip then
               1 -- to times
              else
               60 -- to seconds
            end,
           Pp.To_Time * case
              when Pp.Penalty_Kind = Hpr_Pref.c_Penalty_Kind_Mark_Skip then
               1 -- to times
              else
               60 -- to seconds
            end,
           Pp.Penalty_Coef,
           Pp.Penalty_Per_Time,
           Pp.Penalty_Amount,
           Pp.Penalty_Time,
           Pp.Calc_After_From_Time
      bulk collect
      into v_Policies
      from Hpr_Penalty_Policies Pp
     where Pp.Company_Id = i_Company_Id
       and Pp.Filial_Id = i_Filial_Id
       and Pp.Penalty_Id = v_Penalty_Id;
  
    select p.Timesheet_Date, --
           p.Input_Time, --
           p.Output_Time, --
           Array_Number(Tf.Time_Kind_Id, Tf.Fact_Value, p.Plan_Time)
      bulk collect
      into v_Fact_Dates, v_Input_Times, v_Output_Times, v_Facts
      from Htt_Timesheets p
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = p.Company_Id
       and Tf.Filial_Id = p.Filial_Id
       and Tf.Timesheet_Id = p.Timesheet_Id
       and Tf.Time_Kind_Id in (v_Late_Id, v_Early_Id, v_Lack_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Timesheet_Date between Trunc(i_Period_Begin, 'Mon') and i_Period_End
     order by p.Timesheet_Date, Tf.Time_Kind_Id;
  
    select p.Planned_Marks - p.Done_Marks, p.Timesheet_Date
      bulk collect
      into v_Skipped_Marks, v_Mark_Dates
      from Htt_Timesheets p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Timesheet_Date between i_Period_Begin and i_Period_End
       and p.Day_Kind = Htt_Pref.c_Day_Kind_Work
       and p.Planned_Marks > p.Done_Marks;
  
    Init_Day_Amounts;
  
    for i in 1 .. v_Policies.Count
    loop
      v_Policy := v_Policies(i);
    
      v_Days_Cnt := 0;
    
      if v_Policy.Penalty_Kind = Hpr_Pref.c_Penalty_Kind_Mark_Skip then
        for j in 1 .. v_Skipped_Marks.Count
        loop
          if v_Skipped_Marks(j) > v_Policy.From_Time and --
             v_Skipped_Marks(j) <= Nvl(v_Policy.To_Time, v_Skipped_Marks(j)) then
            Add_Amounts(i_Penalty_Kind     => v_Policy.Penalty_Kind,
                        i_Penalty_Amount   => v_Policy.Penalty_Amount,
                        i_Day_Index        => Day_Index(v_Mark_Dates(j)),
                        p_Mark_Skip_Amount => o_Mark_Skip_Amount);
          end if;
        end loop;
      else
        v_Time_Kind_Id := Get_Tk_Id(v_Policy.Penalty_Kind);
      
        for j in 1 .. v_Facts.Count
        loop
          v_Fact_Tk_Id  := v_Facts(j) (1);
          v_Fact_Value  := v_Facts(j) (2);
          v_Plan_Time   := v_Facts(j) (3);
          v_Input_Time  := v_Input_Times(j);
          v_Output_Time := v_Output_Times(j);
          v_Fact_Date   := v_Fact_Dates(j);
        
          continue when v_Fact_Tk_Id <> v_Time_Kind_Id;
          continue when v_Fact_Tk_Id = v_Lack_Id and v_Fact_Value = v_Plan_Time and v_Input_Time is not null and v_Output_Time is not null;
        
          continue when v_Fact_Tk_Id = v_Lack_Id and v_Fact_Value = v_Plan_Time and v_Policy.Penalty_Kind <> Hpr_Pref.c_Penalty_Kind_Day_Skip;
          continue when v_Fact_Tk_Id = v_Lack_Id and v_Fact_Value <> v_Plan_Time and v_Policy.Penalty_Kind <> Hpr_Pref.c_Penalty_Kind_Lack;
        
          if v_Fact_Value > v_Policy.From_Time and
             v_Fact_Value <= Nvl(v_Policy.To_Time, v_Fact_Value) then
            v_Days_Cnt := v_Days_Cnt + 1;
          
            if v_Fact_Date between i_Period_Begin and i_Period_End then
              v_Penalty_Amount := Calc_Amount(i_Policy          => v_Policy,
                                              i_Wage_Per_Minute => v_Wage_Per_Minute,
                                              i_Facts_Value     => v_Fact_Value);
            
              if v_Days_Cnt > v_Policy.From_Day and --
                 v_Days_Cnt <= Nvl(v_Policy.To_Day, v_Days_Cnt) then
                Add_Amounts(i_Policy          => v_Policy,
                            i_Penalty_Amount  => v_Penalty_Amount,
                            i_Day_Index       => Day_Index(v_Fact_Date),
                            p_Late_Amount     => o_Late_Amount,
                            p_Early_Amount    => o_Early_Amount,
                            p_Lack_Amount     => o_Lack_Amount,
                            p_Day_Skip_Amount => o_Day_Skip_Amount);
              end if;
            end if;
          end if;
        end loop;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Daily_Penalty_Amounts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Division_Id  number,
    i_Hourly_Wage  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Matrix_Number is
    v_Dummy_Late      number;
    v_Dummy_Early     number;
    v_Dummy_Lack      number;
    v_Dummy_Day_Skip  number;
    v_Dummy_Mark_Skip number;
    v_Daily_Amounts   Matrix_Number;
  begin
    Calc_Penalty_Amount(o_Late_Amount      => v_Dummy_Late,
                        o_Early_Amount     => v_Dummy_Early,
                        o_Lack_Amount      => v_Dummy_Lack,
                        o_Day_Skip_Amount  => v_Dummy_Day_Skip,
                        o_Mark_Skip_Amount => v_Dummy_Mark_Skip,
                        o_Day_Amounts      => v_Daily_Amounts,
                        i_Company_Id       => i_Company_Id,
                        i_Filial_Id        => i_Filial_Id,
                        i_Staff_Id         => i_Staff_Id,
                        i_Division_Id      => i_Division_Id,
                        i_Hourly_Wage      => i_Hourly_Wage,
                        i_Period_Begin     => i_Period_Begin,
                        i_Period_End       => i_Period_End);
  
    return v_Daily_Amounts;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Nighttime_Policy_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Period      date
  ) return number is
    v_Policy_Id number;
  begin
    select q.Nighttime_Policy_Id
      into v_Policy_Id
      from Hpr_Nighttime_Policies q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Month = (select max(p.Month)
                        from Hpr_Nighttime_Policies p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Month <= Trunc(i_Period, 'mon')
                         and p.Division_Id = i_Division_Id
                         and p.State = 'A')
       and q.Division_Id = i_Division_Id
       and q.State = 'A';
  
    return v_Policy_Id;
  
  exception
    when No_Data_Found then
      begin
        select q.Nighttime_Policy_Id
          into v_Policy_Id
          from Hpr_Nighttime_Policies q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Month = (select max(p.Month)
                            from Hpr_Nighttime_Policies p
                           where p.Company_Id = i_Company_Id
                             and p.Filial_Id = i_Filial_Id
                             and p.Month <= Trunc(i_Period, 'mon')
                             and p.Division_Id is null
                             and p.State = 'A')
           and q.Division_Id is null
           and q.State = 'A';
      
        return v_Policy_Id;
      
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Additional_Nighttime_Amount
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Division_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) return number is
    v_Policy_Id number;
    result      number;
  begin
    v_Policy_Id := Get_Closest_Nighttime_Policy_Id(i_Company_Id  => i_Company_Id,
                                                   i_Filial_Id   => i_Filial_Id,
                                                   i_Division_Id => i_Division_Id,
                                                   i_Period      => i_End_Date);
  
    select Nvl(sum((t.Nighttime_Coef - 1) *
                   Round(86400 * (t.Intersection_End - t.Intersection_Begin), 2)),
               0)
      into result
      from (select Nr.Nighttime_Coef,
                   Least(i.Interval_End, t.Interval_Date + Numtodsinterval(Nr.End_Time, 'minute')) Intersection_End,
                   Greatest(i.Interval_Begin,
                            t.Interval_Date + Numtodsinterval(Nr.Begin_Time, 'minute')) Intersection_Begin
              from Htt_Timesheets q
              join Htt_Timesheet_Helpers t
                on t.Company_Id = q.Company_Id
               and t.Filial_Id = q.Filial_Id
               and t.Timesheet_Id = q.Timesheet_Id
              join Htt_Timesheet_Intervals i
                on i.Company_Id = q.Company_Id
               and i.Filial_Id = q.Filial_Id
               and i.Timesheet_Id = q.Timesheet_Id
              join Hpr_Nighttime_Rules Nr
                on Nr.Company_Id = q.Company_Id
               and Nr.Filial_Id = q.Filial_Id
               and Nr.Nighttime_Policy_Id = v_Policy_Id
               and Greatest(t.Interval_Date + Numtodsinterval(Nr.Begin_Time, 'minute'),
                            i.Interval_Begin) <
                   Least(t.Interval_Date + Numtodsinterval(Nr.End_Time, 'minute'), i.Interval_End)
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Staff_Id = i_Staff_Id
               and q.Timesheet_Date between i_Begin_Date and i_End_Date) t;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Penalty_Amounts
  (
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Division_Id      number,
    i_Hourly_Wage      number,
    i_Period_Begin     date,
    i_Period_End       date
  ) is
    v_Dummy_Amounts Matrix_Number;
  begin
    Calc_Penalty_Amount(o_Late_Amount      => o_Late_Amount,
                        o_Early_Amount     => o_Early_Amount,
                        o_Lack_Amount      => o_Lack_Amount,
                        o_Day_Skip_Amount  => o_Day_Skip_Amount,
                        o_Mark_Skip_Amount => o_Mark_Skip_Amount,
                        o_Day_Amounts      => v_Dummy_Amounts,
                        i_Company_Id       => i_Company_Id,
                        i_Filial_Id        => i_Filial_Id,
                        i_Staff_Id         => i_Staff_Id,
                        i_Division_Id      => i_Division_Id,
                        i_Hourly_Wage      => i_Hourly_Wage,
                        i_Period_Begin     => i_Period_Begin,
                        i_Period_End       => i_Period_End);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Staff_Parts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  ) return Hpr_Pref.Sheet_Part_Nt is
    v_Overtime_Type_Id  number;
    v_Nighttime_Type_Id number;
    v_Weighted_Type_Id  number;
    v_Oper_Type_Id      number;
    v_Oper_Group_Id     number;
    v_Schedule_Id       number;
    v_Monthly_Amount    number;
    v_Plan_Amount       number;
    v_Wage_Amount       number;
    v_Overtime_Amount   number;
    v_Nighttime_Amount  number;
    v_Late_Amount       number;
    v_Early_Amount      number;
    v_Lack_Amount       number;
    v_Day_Skip_Amount   number;
    v_Mark_Skip_Amount  number;
    v_Hourly_Wage       number;
    r_Robot             Hpd_Trans_Robots%rowtype;
    v_Trans_Parts       Hpd_Pref.Transaction_Part_Nt;
    v_Sheet_Parts       Hpr_Pref.Sheet_Part_Nt := Hpr_Pref.Sheet_Part_Nt();
  begin
    v_Oper_Group_Id := Oper_Group_Id(i_Company_Id => i_Company_Id,
                                     i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_Overtime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Overtime);
  
    v_Nighttime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Company_Id,
                                                 i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Nighttime);
  
    v_Trans_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id      => i_Company_Id,
                                                           i_Filial_Id       => i_Filial_Id,
                                                           i_Staff_Id        => i_Staff_Id,
                                                           i_Begin_Date      => i_Period_Begin,
                                                           i_End_Date        => i_Period_End,
                                                           i_Trans_Types     => Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                                                                               Hpd_Pref.c_Transaction_Type_Operation,
                                                                                               Hpd_Pref.c_Transaction_Type_Schedule),
                                                           i_With_Wage_Scale => false);
  
    for i in 1 .. v_Trans_Parts.Count
    loop
      v_Oper_Type_Id := Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => i_Company_Id,
                                                          i_Filial_Id     => i_Filial_Id,
                                                          i_Staff_Id      => i_Staff_Id,
                                                          i_Oper_Group_Id => v_Oper_Group_Id,
                                                          i_Period        => v_Trans_Parts(i).Part_Begin);
    
      continue when v_Oper_Type_Id is null;
    
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => v_Trans_Parts(i).Part_Begin);
    
      continue when v_Schedule_Id is null;
    
      continue when Htt_Util.Has_Undefined_Schedule(i_Company_Id  => i_Company_Id,
                                                    i_Filial_Id   => i_Filial_Id,
                                                    i_Staff_Id    => i_Staff_Id,
                                                    i_Schedule_Id => v_Schedule_Id,
                                                    i_Period      => v_Trans_Parts(i).Part_Begin);
    
      v_Monthly_Amount := Calc_Amount(i_Company_Id   => i_Company_Id,
                                      i_Filial_Id    => i_Filial_Id,
                                      i_Staff_Id     => i_Staff_Id,
                                      i_Oper_Type_Id => v_Oper_Type_Id,
                                      i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                      i_Part_End     => v_Trans_Parts(i).Part_End,
                                      i_Calc_Planned => true);
    
      v_Plan_Amount := Calc_Amount(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Staff_Id     => i_Staff_Id,
                                   i_Oper_Type_Id => v_Oper_Type_Id,
                                   i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                   i_Part_End     => v_Trans_Parts(i).Part_End,
                                   i_Calc_Worked  => true);
    
      v_Wage_Amount := Calc_Amount(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Staff_Id     => i_Staff_Id,
                                   i_Oper_Type_Id => v_Oper_Type_Id,
                                   i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                   i_Part_End     => v_Trans_Parts(i).Part_End);
    
      v_Overtime_Amount := Calc_Amount(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Staff_Id     => i_Staff_Id,
                                       i_Oper_Type_Id => v_Overtime_Type_Id,
                                       i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                       i_Part_End     => v_Trans_Parts(i).Part_End);
    
      v_Nighttime_Amount := Hpr_Util.Calc_Amount(i_Company_Id   => i_Company_Id,
                                                 i_Filial_Id    => i_Filial_Id,
                                                 i_Staff_Id     => i_Staff_Id,
                                                 i_Oper_Type_Id => v_Nighttime_Type_Id,
                                                 i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                                 i_Part_End     => v_Trans_Parts(i).Part_End);
    
      v_Hourly_Wage := Calc_Hourly_Wage(i_Company_Id   => i_Company_Id,
                                        i_Filial_Id    => i_Filial_Id,
                                        i_Staff_Id     => i_Staff_Id,
                                        i_Oper_Type_Id => v_Oper_Type_Id,
                                        i_Schedule_Id  => v_Schedule_Id,
                                        i_Part_Begin   => v_Trans_Parts(i).Part_Begin,
                                        i_Part_End     => v_Trans_Parts(i).Part_End);
    
      r_Robot := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Staff_Id   => i_Staff_Id,
                                        i_Period     => v_Trans_Parts(i).Part_Begin);
    
      Calc_Penalty_Amounts(o_Late_Amount      => v_Late_Amount,
                           o_Early_Amount     => v_Early_Amount,
                           o_Lack_Amount      => v_Lack_Amount,
                           o_Day_Skip_Amount  => v_Day_Skip_Amount,
                           o_Mark_Skip_Amount => v_Mark_Skip_Amount,
                           i_Company_Id       => i_Company_Id,
                           i_Filial_Id        => i_Filial_Id,
                           i_Staff_Id         => i_Staff_Id,
                           i_Division_Id      => r_Robot.Division_Id,
                           i_Hourly_Wage      => v_Hourly_Wage,
                           i_Period_Begin     => v_Trans_Parts(i).Part_Begin,
                           i_Period_End       => v_Trans_Parts(i).Part_End);
    
      Sheet_Add_Part(p_Parts            => v_Sheet_Parts,
                     i_Part_Begin       => v_Trans_Parts(i).Part_Begin,
                     i_Part_End         => v_Trans_Parts(i).Part_End,
                     i_Division_Id      => r_Robot.Division_Id,
                     i_Job_Id           => r_Robot.Job_Id,
                     i_Schedule_Id      => v_Schedule_Id,
                     i_Fte_Id           => r_Robot.Fte_Id,
                     i_Monthly_Amount   => i_Round_Model.Eval(v_Monthly_Amount),
                     i_Plan_Amount      => i_Round_Model.Eval(v_Plan_Amount),
                     i_Wage_Amount      => i_Round_Model.Eval(v_Wage_Amount),
                     i_Overtime_Amount  => i_Round_Model.Eval(v_Overtime_Amount),
                     i_Nighttime_Amount => i_Round_Model.Eval(v_Nighttime_Amount),
                     i_Late_Amount      => i_Round_Model.Eval(v_Late_Amount),
                     i_Early_Amount     => i_Round_Model.Eval(v_Early_Amount),
                     i_Lack_Amount      => i_Round_Model.Eval(v_Lack_Amount),
                     i_Day_Skip_Amount  => i_Round_Model.Eval(v_Day_Skip_Amount),
                     i_Mark_Skip_Amount => i_Round_Model.Eval(v_Mark_Skip_Amount));
    end loop;
  
    return v_Sheet_Parts;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Penalty_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Period      date
  ) return number is
    v_Penalty_Id number;
  begin
    select q.Penalty_Id
      into v_Penalty_Id
      from Hpr_Penalties q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Month = (select max(p.Month)
                        from Hpr_Penalties p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Month <= Trunc(i_Period, 'mon')
                         and p.Division_Id = i_Division_Id
                         and p.State = 'A')
       and q.Division_Id = i_Division_Id
       and q.State = 'A';
  
    return v_Penalty_Id;
  
  exception
    when No_Data_Found then
      begin
        select q.Penalty_Id
          into v_Penalty_Id
          from Hpr_Penalties q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Month = (select max(p.Month)
                            from Hpr_Penalties p
                           where p.Company_Id = i_Company_Id
                             and p.Filial_Id = i_Filial_Id
                             and p.Month <= Trunc(i_Period, 'mon')
                             and p.Division_Id is null
                             and p.State = 'A')
           and q.Division_Id is null
           and q.State = 'A';
      
        return v_Penalty_Id;
      
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Jcode_Cv_Contract_Fact(i_Fact_Id number) return varchar2 is
  begin
    return Mkr_Util.Journal_Code(i_Source_Table => Zt.Hpr_Cv_Contract_Facts,
                                 i_Source_Id    => i_Fact_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timebook_Fill_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Hashmap is
    v_Pref_Value varchar2(4000);
  begin
    v_Pref_Value := Md_Pref.Load(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Code       => Hpr_Pref.c_Pref_Timebook_Fill_Settings);
  
    if v_Pref_Value is null then
      return Fazo.Zip_Map('by_plan_day',
                          'Y',
                          'by_plan_hour',
                          'Y',
                          'norm_hour',
                          'Y',
                          'norm_day',
                          'Y');
    else
      return Fazo.Parse_Map(v_Pref_Value);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- charge status
  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status_Draft return varchar2 is
  begin
    return t('charge_status:draft');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status_New return varchar2 is
  begin
    return t('charge_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status_Used return varchar2 is
  begin
    return t('charge_status:used');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status_Completed return varchar2 is
  begin
    return t('charge_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Charge_Status(i_Charge_Status varchar2) return varchar2 is
  begin
    return --
    case i_Charge_Status --
    when Hpr_Pref.c_Charge_Status_Draft then t_Charge_Status_Draft --
    when Hpr_Pref.c_Charge_Status_New then t_Charge_Status_New --
    when Hpr_Pref.c_Charge_Status_Used then t_Charge_Status_Used --
    when Hpr_Pref.c_Charge_Status_Completed then t_Charge_Status_Completed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Charge_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Charge_Status_Draft,
                                          Hpr_Pref.c_Charge_Status_New,
                                          Hpr_Pref.c_Charge_Status_Used,
                                          Hpr_Pref.c_Charge_Status_Completed),
                           Array_Varchar2(t_Charge_Status_Draft,
                                          t_Charge_Status_New,
                                          t_Charge_Status_Used,
                                          t_Charge_Status_Completed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- estimation type
  ----------------------------------------------------------------------------------------------------
  Function t_Estimation_Type_Formula return varchar2 is
  begin
    return t('estimation_type:formula');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Estimation_Type_Entered return varchar2 is
  begin
    return t('estimation_type:entered');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Estimation_Type(i_Estimation_Type varchar2) return varchar2 is
  begin
    return --
    case i_Estimation_Type --
    when Hpr_Pref.c_Estimation_Type_Formula then t_Estimation_Type_Formula --
    when Hpr_Pref.c_Estimation_Type_Entered then t_Estimation_Type_Entered --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Estimation_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Estimation_Type_Formula,
                                          Hpr_Pref.c_Estimation_Type_Entered),
                           Array_Varchar2(t_Estimation_Type_Formula, t_Estimation_Type_Entered));
  end;

  ----------------------------------------------------------------------------------------------------
  -- advance limit kind
  ----------------------------------------------------------------------------------------------------
  Function t_Advance_Limit_Turnout_Days return varchar2 is
  begin
    return t('advance_limit_kind:turnout');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Advance_Limit_Calendar_Days return varchar2 is
  begin
    return t('advance_limit_kind:calendar');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Advance_Limit_Kind(i_Advance_Limit_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Advance_Limit_Kind --
    when Hpr_Pref.c_Advance_Limit_Turnout_Days then t_Advance_Limit_Turnout_Days --
    when Hpr_Pref.c_Advance_Limit_Calendar_Days then t_Advance_Limit_Calendar_Days --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Advance_Limit_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Advance_Limit_Turnout_Days,
                                          Hpr_Pref.c_Advance_Limit_Calendar_Days),
                           Array_Varchar2(t_Advance_Limit_Turnout_Days,
                                          t_Advance_Limit_Calendar_Days));
  end;

  ----------------------------------------------------------------------------------------------------
  -- period kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind_Full_Month return varchar2 is
  begin
    return t('period kind: full month');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind_Month_First_Half return varchar2 is
  begin
    return t('period kind: month first half');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind_Month_Second_Half return varchar2 is
  begin
    return t('period kind: month second half');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind_Custom return varchar2 is
  begin
    return t('period kind: custom period');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Period_Kind(i_Period_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Period_Kind --
    when Hpr_Pref.c_Period_Full_Month then t_Period_Kind_Full_Month --
    when Hpr_Pref.c_Period_Month_First_Half then t_Period_Kind_Month_First_Half --
    when Hpr_Pref.c_Period_Month_Second_Half then t_Period_Kind_Month_Second_Half --
    when Hpr_Pref.c_Period_Custom then t_Period_Kind_Custom --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Period_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Period_Full_Month,
                                          Hpr_Pref.c_Period_Month_First_Half,
                                          Hpr_Pref.c_Period_Month_Second_Half,
                                          Hpr_Pref.c_Period_Custom),
                           Array_Varchar2(t_Period_Kind_Full_Month,
                                          t_Period_Kind_Month_First_Half,
                                          t_Period_Kind_Month_Second_Half,
                                          t_Period_Kind_Custom));
  end;

  ----------------------------------------------------------------------------------------------------
  -- penaties
  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind_Late return varchar2 is
  begin
    return t('penalty kind: late');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind_Early return varchar2 is
  begin
    return t('penalty kind: early');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind_Lack return varchar2 is
  begin
    return t('penalty kind: lack');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind_Day_Skip return varchar2 is
  begin
    return t('penalty kind: day skip');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind_Mark_Skip return varchar2 is
  begin
    return t('penalty kind: mark skip');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Kind(i_Penalty_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Penalty_Kind --
    when Hpr_Pref.c_Penalty_Kind_Late then t_Penalty_Kind_Late --
    when Hpr_Pref.c_Penalty_Kind_Early then t_Penalty_Kind_Early --
    when Hpr_Pref.c_Penalty_Kind_Lack then t_Penalty_Kind_Lack --
    when Hpr_Pref.c_Penalty_Kind_Day_Skip then t_Penalty_Kind_Day_Skip --
    when Hpr_Pref.c_Penalty_Kind_Mark_Skip then t_Penalty_Kind_Mark_Skip --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Penalty_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Penalty_Kind_Late,
                                          Hpr_Pref.c_Penalty_Kind_Early,
                                          Hpr_Pref.c_Penalty_Kind_Lack,
                                          Hpr_Pref.c_Penalty_Kind_Day_Skip,
                                          Hpr_Pref.c_Penalty_Kind_Mark_Skip),
                           Array_Varchar2(t_Penalty_Kind_Late,
                                          t_Penalty_Kind_Early,
                                          t_Penalty_Kind_Lack,
                                          t_Penalty_Kind_Day_Skip,
                                          t_Penalty_Kind_Mark_Skip));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Fact_Status_New return varchar2 is
  begin
    return t('cv fact status: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Fact_Status_Complete return varchar2 is
  begin
    return t('cv fact status: complete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Fact_Status_Accept return varchar2 is
  begin
    return t('cv fact status: accept');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Fact_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hpr_Pref.c_Cv_Contract_Fact_Status_New then t_Cv_Fact_Status_New --
    when Hpr_Pref.c_Cv_Contract_Fact_Status_Complete then t_Cv_Fact_Status_Complete --
    when Hpr_Pref.c_Cv_Contract_Fact_Status_Accept then t_Cv_Fact_Status_Accept --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Cv_Fact_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Cv_Contract_Fact_Status_New,
                                          Hpr_Pref.c_Cv_Contract_Fact_Status_Complete,
                                          Hpr_Pref.c_Cv_Contract_Fact_Status_Accept),
                           Array_Varchar2(t_Cv_Fact_Status_New,
                                          t_Cv_Fact_Status_Complete,
                                          t_Cv_Fact_Status_Accept));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Rule_Unit_Min return varchar2 is
  begin
    return t('penalty_rule:min');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Rule_Unit_Times return varchar2 is
  begin
    return t('penalty_rule:times');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Penalty_Rule_Unit_Days return varchar2 is
  begin
    return t('penalty_rule:days');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Post
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2 is
  begin
    return t('$1{person_name} posted $2{timebook_number} timebook for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Timebook_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Unpost
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2 is
  begin
    return t('$1{person_name} unposted $2{timebook_number} timebook for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Timebook_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Save
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2 is
  begin
    return t('$1{person_name} saved $2{timebook_number} timebook for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Timebook_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Update
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2 is
  begin
    return t('$1{person_name} updated $2{timebook_number} timebook for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Timebook_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Timebook_Delete
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Timebook_Number varchar2,
    i_Month           date
  ) return varchar2 is
  begin
    return t('$1{person_name} deleted $2{timebook_number} timebook for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Timebook_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Post
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2 is
  begin
    return t('$1{peson_name} posted $2{book_number} for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Book_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Unpost
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2 is
  begin
    return t('$1{peson_name} unposted $2{book_number} for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Book_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Save
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2 is
  begin
    return t('$1{peson_name} saved $2{book_number} for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Book_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Update
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2 is
  begin
    return t('$1{peson_name} updated $2{book_number} for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Book_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Book_Delete
  (
    i_Company_Id  number,
    i_User_Id     number,
    i_Book_Number varchar2,
    i_Month       date
  ) return varchar2 is
  begin
    return t('$1{peson_name} deleted $2{book_number} for $3{month}',
             z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name,
             i_Book_Number,
             to_char(i_Month, 'Month yyyy', Htt_Util.Get_Nls_Language));
  end;

end Hpr_Util;
/

create or replace package Href_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype);
  ------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype);

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  );
end Href_Api;
/
create or replace package body Href_Api is
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
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number) is
    v_Person_Id   number := Md_Next.Person_Id;
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  begin
    z_Md_Persons.Insert_One(i_Company_Id  => i_Company_Id,
                            i_Person_Id   => v_Person_Id,
                            i_Name        => 'Timepad Virtual user',
                            i_Person_Kind => Md_Pref.c_Pk_Virtual,
                            i_Email       => null,
                            i_Photo_Sha   => null,
                            i_State       => 'A',
                            i_Code        => null,
                            i_Phone       => null);
  
    z_Md_Users.Insert_One(i_Company_Id               => i_Company_Id,
                          i_User_Id                  => v_Person_Id,
                          i_Name                     => 'Timepad Virtual user',
                          i_Login                    => null,
                          i_Password                 => null,
                          i_State                    => 'A',
                          i_User_Kind                => Md_Pref.c_Uk_Virtual,
                          i_Gender                   => null,
                          i_Manager_Id               => null,
                          i_Timezone_Code            => null,
                          i_Two_Factor_Verification  => Md_Pref.c_Two_Step_Verification_Disabled,
                          i_Password_Changed_On      => null,
                          i_Password_Change_Required => null,
                          i_Order_No                 => null);
  
    z_Href_Timepad_Users.Insert_One(i_Company_Id => i_Company_Id, i_User_Id => v_Person_Id);
  
    -- attach timepad role for virtual user 
    Md_Api.Role_Grant(i_Company_Id => i_Company_Id,
                      i_User_Id    => v_Person_Id,
                      i_Filial_Id  => v_Filial_Head,
                      i_Role_Id    => Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad));
  
    -- attach user to filial
    Md_Api.User_Add_Filial(i_Company_Id => i_Company_Id,
                           i_User_Id    => v_Person_Id,
                           i_Filial_Id  => v_Filial_Head);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  ) is
    v_Exists            boolean := false;
    r_Candidate         Href_Candidates%rowtype;
    r_Person_Exp        Href_Person_Experiences%rowtype;
    r_Edu_Stage         Href_Person_Edu_Stages%rowtype;
    v_Lang_Ids          Array_Number := Array_Number();
    v_Lang              Href_Pref.Person_Lang_Rt;
    v_Exp_Ids           Array_Number;
    v_Exp               Href_Pref.Person_Experience_Rt;
    v_Recom_Ids         Array_Number;
    v_Recom             Href_Pref.Candidate_Recom_Rt;
    v_New_Edu_Stage_Ids Array_Number := Array_Number();
    v_Person_Edu_Stages Array_Number := Array_Number();
  begin
    if z_Href_Candidates.Exist(i_Company_Id   => i_Candidate.Company_Id,
                               i_Filial_Id    => i_Candidate.Filial_Id,
                               i_Candidate_Id => i_Candidate.Person.Person_Id,
                               o_Row          => r_Candidate) then
      v_Exists := true;
    else
      r_Candidate.Company_Id   := i_Candidate.Company_Id;
      r_Candidate.Filial_Id    := i_Candidate.Filial_Id;
      r_Candidate.Candidate_Id := i_Candidate.Person.Person_Id;
    end if;
  
    Person_Save(i_Person                 => i_Candidate.Person, --
                i_Only_Natural           => true,
                i_Check_Required_Columns => i_Check_Required_Columns);
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => r_Candidate.Company_Id,
                                i_Filial_Id  => r_Candidate.Filial_Id,
                                i_Person_Id  => r_Candidate.Candidate_Id,
                                i_State      => 'A');
    end if;
  
    if i_Candidate.Person_Type_Id is not null then
      Mr_Api.Person_Add_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                  i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                  i_Person_Id       => r_Candidate.Candidate_Id,
                                  i_Person_Type_Id  => i_Candidate.Person_Type_Id);
    else
      Mr_Api.Person_Remove_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                     i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                     i_Person_Id       => r_Candidate.Candidate_Id);
    end if;
  
    r_Candidate.Candidate_Kind   := i_Candidate.Candidate_Kind;
    r_Candidate.Source_Id        := i_Candidate.Source_Id;
    r_Candidate.Wage_Expectation := i_Candidate.Wage_Expectation;
    r_Candidate.Cv_Sha           := i_Candidate.Cv_Sha;
    r_Candidate.Note             := i_Candidate.Note;
  
    if v_Exists then
      z_Href_Candidates.Update_Row(r_Candidate);
    else
      z_Href_Candidates.Insert_Row(r_Candidate);
    end if;
  
    -- person details
    if i_Candidate.Extra_Phone is not null then
      z_Href_Person_Details.Save_One(i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Key_Person           => 'N',
                                     i_Access_All_Employees => 'N',
                                     i_Extra_Phone          => i_Candidate.Extra_Phone,
                                     i_Access_Hidden_Salary => 'N');
    else
      z_Href_Person_Details.Delete_One(i_Company_Id => r_Candidate.Company_Id,
                                       i_Person_Id  => r_Candidate.Candidate_Id);
    end if;
  
    -- candidate languages
    v_Lang_Ids := Array_Number();
    v_Lang_Ids.Extend(i_Candidate.Langs.Count);
  
    for i in 1 .. i_Candidate.Langs.Count
    loop
      v_Lang := i_Candidate.Langs(i);
      v_Lang_Ids(i) := v_Lang.Lang_Id;
    
      z_Href_Person_Langs.Save_One(i_Company_Id    => r_Candidate.Company_Id,
                                   i_Person_Id     => r_Candidate.Candidate_Id,
                                   i_Lang_Id       => v_Lang.Lang_Id,
                                   i_Lang_Level_Id => v_Lang.Lang_Level_Id);
    end loop;
  
    delete from Href_Person_Langs t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Person_Id = r_Candidate.Candidate_Id
       and t.Lang_Id not member of v_Lang_Ids;
  
    -- candidate experience
    v_Exp_Ids := Array_Number();
    v_Exp_Ids.Extend(i_Candidate.Experiences.Count);
  
    for i in 1 .. i_Candidate.Experiences.Count
    loop
      v_Exp := i_Candidate.Experiences(i);
      v_Exp_Ids(i) := v_Exp.Person_Experience_Id;
    
      z_Href_Person_Experiences.Init(p_Row                  => r_Person_Exp,
                                     i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Experience_Id => v_Exp.Person_Experience_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Experience_Type_Id   => v_Exp.Experience_Type_Id,
                                     i_Is_Working           => v_Exp.Is_Working,
                                     i_Start_Date           => v_Exp.Start_Date,
                                     i_Num_Year             => v_Exp.Num_Year,
                                     i_Num_Month            => v_Exp.Num_Month,
                                     i_Num_Day              => v_Exp.Num_Day);
    
      Person_Experience_Save(r_Person_Exp);
    end loop;
  
    delete from Href_Person_Experiences e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Person_Experience_Id not member of v_Exp_Ids;
  
    -- candidate recommendations
    v_Recom_Ids := Array_Number();
    v_Recom_Ids.Extend(i_Candidate.Recommendations.Count);
  
    for i in 1 .. i_Candidate.Recommendations.Count
    loop
      v_Recom := i_Candidate.Recommendations(i);
      v_Recom_Ids(i) := v_Recom.Recommendation_Id;
    
      z_Href_Candidate_Recoms.Save_One(i_Company_Id          => r_Candidate.Company_Id,
                                       i_Filial_Id           => r_Candidate.Filial_Id,
                                       i_Recommendation_Id   => v_Recom.Recommendation_Id,
                                       i_Candidate_Id        => r_Candidate.Candidate_Id,
                                       i_Sender_Name         => v_Recom.Sender_Name,
                                       i_Sender_Phone_Number => v_Recom.Sender_Phone_Number,
                                       i_Sender_Email        => v_Recom.Sender_Email,
                                       i_File_Sha            => v_Recom.File_Sha,
                                       i_Order_No            => v_Recom.Order_No,
                                       i_Feedback            => v_Recom.Feedback,
                                       i_Note                => v_Recom.Note);
    end loop;
  
    delete from Href_Candidate_Recoms t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Filial_Id = r_Candidate.Filial_Id
       and t.Candidate_Id = r_Candidate.Candidate_Id
       and t.Recommendation_Id not member of v_Recom_Ids;
  
    -- candidate possibly jobs
    delete from Href_Candidate_Jobs j
     where j.Company_Id = r_Candidate.Company_Id
       and j.Filial_Id = r_Candidate.Filial_Id
       and j.Candidate_Id = r_Candidate.Candidate_Id
       and j.Job_Id not member of i_Candidate.Candidate_Jobs;
  
    for i in 1 .. i_Candidate.Candidate_Jobs.Count
    loop
      z_Href_Candidate_Jobs.Insert_Try(i_Company_Id   => r_Candidate.Company_Id,
                                       i_Filial_Id    => r_Candidate.Filial_Id,
                                       i_Candidate_Id => r_Candidate.Candidate_Id,
                                       i_Job_Id       => i_Candidate.Candidate_Jobs(i));
    end loop;
  
    -- candidate edu stages
    if v_Exists then
      select distinct e.Edu_Stage_Id
        bulk collect
        into v_Person_Edu_Stages
        from Href_Person_Edu_Stages e
       where e.Company_Id = r_Candidate.Company_Id
         and e.Person_Id = r_Candidate.Candidate_Id;
    end if;
  
    v_New_Edu_Stage_Ids := i_Candidate.Edu_Stages multiset Except v_Person_Edu_Stages;
  
    for i in 1 .. v_New_Edu_Stage_Ids.Count
    loop
      r_Edu_Stage.Company_Id          := r_Candidate.Company_Id;
      r_Edu_Stage.Person_Edu_Stage_Id := Href_Next.Person_Edu_Stage_Id;
      r_Edu_Stage.Person_Id           := r_Candidate.Candidate_Id;
      r_Edu_Stage.Edu_Stage_Id        := v_New_Edu_Stage_Ids(i);
    
      Person_Edu_Stage_Save(r_Edu_Stage);
    end loop;
  
    delete from Href_Person_Edu_Stages e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Edu_Stage_Id not member of i_Candidate.Edu_Stages;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) is
  begin
    z_Href_Candidates.Delete_One(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Candidate_Id => i_Candidate_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate form settings
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype) is
  begin
    z_Href_Candidate_Ref_Settings.Save_Row(i_Settings);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  ) is
    r_Candidate_Lang Href_Candidate_Langs%rowtype;
  begin
    delete from Href_Candidate_Langs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Lang_Id not member of i_Lang_Ids;
  
    r_Candidate_Lang.Company_Id := i_Company_Id;
    r_Candidate_Lang.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Lang_Ids.Count
    loop
      r_Candidate_Lang.Lang_Id  := i_Lang_Ids(i);
      r_Candidate_Lang.Order_No := i;
    
      z_Href_Candidate_Langs.Save_Row(r_Candidate_Lang);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  ) is
    r_Candidate_Es Href_Candidate_Edu_Stages%rowtype;
  begin
    delete from Href_Candidate_Edu_Stages q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Edu_Stage_Id not member of i_Edu_Stage_Ids;
  
    r_Candidate_Es.Company_Id := i_Company_Id;
    r_Candidate_Es.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Edu_Stage_Ids.Count
    loop
      r_Candidate_Es.Edu_Stage_Id := i_Edu_Stage_Ids(i);
      r_Candidate_Es.Order_No     := i;
    
      z_Href_Candidate_Edu_Stages.Save_Row(r_Candidate_Es);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt) is
    r_Employee Mhr_Employees%rowtype;
    v_Exists   boolean := false;
  begin
    if z_Md_Persons.Exist_Lock(i_Company_Id => i_Employee.Person.Company_Id,
                               i_Person_Id  => i_Employee.Person.Person_Id) then
      v_Exists := true;
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Employee.Person.Company_Id then
      Person_Save(i_Employee.Person);
    end if;
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => i_Employee.Person.Company_Id,
                                i_Filial_Id  => i_Employee.Filial_Id,
                                i_Person_Id  => i_Employee.Person.Person_Id,
                                i_State      => 'A');
    end if;
  
    if not z_Mhr_Employees.Exist_Lock(i_Company_Id  => i_Employee.Person.Company_Id,
                                      i_Filial_Id   => i_Employee.Filial_Id,
                                      i_Employee_Id => i_Employee.Person.Person_Id,
                                      o_Row         => r_Employee) then
      r_Employee.Company_Id  := i_Employee.Person.Company_Id;
      r_Employee.Filial_Id   := i_Employee.Filial_Id;
      r_Employee.Employee_Id := i_Employee.Person.Person_Id;
    end if;
  
    r_Employee.State := i_Employee.State;
  
    Mhr_Api.Employee_Save(r_Employee);
  
    if Htt_Util.Location_Sync_Global_Load(i_Company_Id => r_Employee.Company_Id,
                                          i_Filial_Id  => r_Employee.Filial_Id) = 'Y' then
      Htt_Core.Person_Sync_Locations(i_Company_Id => r_Employee.Company_Id,
                                     i_Filial_Id  => r_Employee.Filial_Id,
                                     i_Person_Id  => r_Employee.Employee_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  ) is
  begin
    z_Mhr_Employees.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Employee_Id => i_Employee_Id,
                               i_Division_Id => Option_Number(i_Division_Id),
                               i_Job_Id      => Option_Number(i_Job_Id),
                               i_Rank_Id     => Option_Number(i_Rank_Id));
  
    -- person update for update modified_id on z package  
    z_Md_Persons.Update_One(i_Company_Id => i_Company_Id, --
                            i_Person_Id  => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
  begin
    Mhr_Api.Employee_Delete(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Employee_Id => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype) is
  begin
    z_Href_Fixed_Term_Bases.Save_Row(i_Fixed_Term_Base);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  ) is
  begin
    z_Href_Fixed_Term_Bases.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Fixed_Term_Base_Id => i_Fixed_Term_Base_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype) is
  begin
    z_Href_Edu_Stages.Save_Row(i_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  ) is
  begin
    z_Href_Edu_Stages.Delete_One(i_Company_Id => i_Company_Id, i_Edu_Stage_Id => i_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype) is
  begin
    z_Href_Science_Branches.Save_Row(i_Science_Branch);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  ) is
  begin
    z_Href_Science_Branches.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Science_Branch_Id => i_Science_Branch_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype) is
  begin
    z_Href_Institutions.Save_Row(i_Institution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  ) is
  begin
    z_Href_Institutions.Delete_One(i_Company_Id     => i_Company_Id,
                                   i_Institution_Id => i_Institution_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype) is
    r_Specialty Href_Specialties%rowtype;
  begin
    if z_Href_Specialties.Exist_Lock(i_Company_Id   => i_Specialty.Company_Id,
                                     i_Specialty_Id => i_Specialty.Specialty_Id,
                                     o_Row          => r_Specialty) then
      if i_Specialty.Kind <> r_Specialty.Kind then
        Href_Error.Raise_001(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name);
      end if;
    end if;
  
    if i_Specialty.Parent_Id is not null then
      r_Specialty := z_Href_Specialties.Lock_Load(i_Company_Id   => i_Specialty.Company_Id,
                                                  i_Specialty_Id => i_Specialty.Parent_Id);
    
      if r_Specialty.Kind <> Href_Pref.c_Specialty_Kind_Group then
        Href_Error.Raise_002(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name,
                             i_Parent_Name    => r_Specialty.Name);
      end if;
    end if;
  
    z_Href_Specialties.Save_Row(i_Specialty);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  ) is
  begin
    z_Href_Specialties.Delete_One(i_Company_Id => i_Company_Id, i_Specialty_Id => i_Specialty_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype) is
  begin
    z_Href_Langs.Save_Row(i_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Langs.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Id => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype) is
  begin
    z_Href_Lang_Levels.Save_Row(i_Lang_Level);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  ) is
  begin
    z_Href_Lang_Levels.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Level_Id => i_Lang_Level_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist_Lock(i_Company_Id  => i_Document_Type.Company_Id,
                                        i_Doc_Type_Id => i_Document_Type.Doc_Type_Id,
                                        o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_003(i_Document_Type_Id   => i_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => i_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Save_Row(i_Document_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  ) is
  begin
    z_Href_Document_Types.Update_One(i_Company_Id  => i_Company_Id,
                                     i_Doc_Type_Id => i_Doc_Type_Id,
                                     i_Is_Required => Option_Varchar2(i_Is_Required));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  ) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist(i_Company_Id  => i_Company_Id,
                                   i_Doc_Type_Id => i_Doc_Type_Id,
                                   o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_004(i_Document_Type_Id   => r_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => r_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Delete_One(i_Company_Id => i_Company_Id, i_Doc_Type_Id => i_Doc_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  ) is
  begin
    for i in 1 .. i_Doc_Type_Ids.Count
    loop
      z_Href_Excluded_Document_Types.Insert_Try(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => i_Division_Id,
                                                i_Job_Id      => i_Job_Id,
                                                i_Doc_Type_Id => i_Doc_Type_Ids(i));
    end loop;
  
    delete from Href_Excluded_Document_Types t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Division_Id = i_Division_Id
       and t.Job_Id = i_Job_Id
       and t.Doc_Type_Id not member of i_Doc_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) is
  begin
    Excluded_Document_Type_Save(i_Company_Id   => i_Company_Id,
                                i_Filial_Id    => i_Filial_Id,
                                i_Division_Id  => i_Division_Id,
                                i_Job_Id       => i_Job_Id,
                                i_Doc_Type_Ids => Array_Number());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype) is
  begin
    z_Href_Reference_Types.Save_Row(i_Reference_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  ) is
  begin
    z_Href_Reference_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Reference_Type_Id => i_Reference_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype) is
  begin
    z_Href_Relation_Degrees.Save_Row(i_Relation_Degree);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  ) is
  begin
    z_Href_Relation_Degrees.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Relation_Degree_Id => i_Relation_Degree_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype) is
  begin
    z_Href_Marital_Statuses.Save_Row(i_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  ) is
  begin
    z_Href_Marital_Statuses.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Marital_Status_Id => i_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype) is
  begin
    z_Href_Experience_Types.Save_Row(i_Experience_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  ) is
  begin
    z_Href_Experience_Types.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Experience_Type_Id => i_Experience_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype) is
  begin
    z_Href_Nationalities.Save_Row(i_Nationality);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  ) is
  begin
    z_Href_Nationalities.Delete_One(i_Company_Id     => i_Company_Id,
                                    i_Nationality_Id => i_Nationality_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype) is
  begin
    z_Href_Awards.Save_Row(i_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  ) is
  begin
    z_Href_Awards.Delete_One(i_Company_Id => i_Company_Id, i_Award_Id => i_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype) is
  begin
    z_Href_Inventory_Types.Save_Row(i_Inventory_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  ) is
  begin
    z_Href_Inventory_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Inventory_Type_Id => i_Inventory_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  ) is
    r_Natural_Person Mr_Natural_Persons%rowtype;
    r_Person_Detail  Mr_Person_Details%rowtype;
    r_Detail         Href_Person_Details%rowtype;
    v_Phone          varchar2(25) := Regexp_Replace(i_Person.Main_Phone, '\D', '');
  
    --------------------------------------------------
    Procedure Check_Required_Columns is
      v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    begin
      if not i_Check_Required_Columns then
        return;
      end if;
    
      v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(i_Person.Company_Id);
    
      if v_Col_Required_Settings.Last_Name = 'Y' and trim(i_Person.Last_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Last_Name);
      end if;
    
      if v_Col_Required_Settings.Middle_Name = 'Y' and trim(i_Person.Middle_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Middle_Name);
      end if;
    
      if v_Col_Required_Settings.Birthday = 'Y' and i_Person.Birthday is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Birthday);
      end if;
    
      if v_Col_Required_Settings.Phone_Number = 'Y' and trim(v_Phone) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Phone_Number);
      end if;
    
      if v_Col_Required_Settings.Email = 'Y' and trim(i_Person.Email) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Email);
      end if;
    
      if v_Col_Required_Settings.Region = 'Y' and i_Person.Region_Id is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Region);
      end if;
    
      if v_Col_Required_Settings.Address = 'Y' and trim(i_Person.Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Address);
      end if;
    
      if v_Col_Required_Settings.Legal_Address = 'Y' and trim(i_Person.Legal_Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Legal_Address);
      end if;
    end;
  begin
    -- check required columns
    Check_Required_Columns;
  
    -- natural person save
    r_Natural_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Person.Company_Id,
                                                  i_Person_Id  => i_Person.Person_Id);
  
    r_Natural_Person.Company_Id  := i_Person.Company_Id;
    r_Natural_Person.Person_Id   := i_Person.Person_Id;
    r_Natural_Person.First_Name  := i_Person.First_Name;
    r_Natural_Person.Last_Name   := i_Person.Last_Name;
    r_Natural_Person.Middle_Name := i_Person.Middle_Name;
    r_Natural_Person.Gender      := i_Person.Gender;
    r_Natural_Person.Birthday    := i_Person.Birthday;
    r_Natural_Person.State       := i_Person.State;
    r_Natural_Person.Code        := i_Person.Code;
  
    Mr_Api.Natural_Person_Save(r_Natural_Person);
  
    Md_Api.Person_Update(i_Company_Id => r_Natural_Person.Company_Id,
                         i_Person_Id  => r_Natural_Person.Person_Id,
                         i_Email      => Option_Varchar2(i_Person.Email),
                         i_Phone      => Option_Varchar2(v_Phone),
                         i_Photo_Sha  => Option_Varchar2(i_Person.Photo_Sha));
  
    -- person detail save
    r_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                                i_Person_Id  => i_Person.Person_Id);
  
    r_Person_Detail.Company_Id     := i_Person.Company_Id;
    r_Person_Detail.Person_Id      := i_Person.Person_Id;
    r_Person_Detail.Tin            := i_Person.Tin;
    r_Person_Detail.Main_Phone     := i_Person.Main_Phone;
    r_Person_Detail.Address        := i_Person.Address;
    r_Person_Detail.Legal_Address  := i_Person.Legal_Address;
    r_Person_Detail.Region_Id      := i_Person.Region_Id;
    r_Person_Detail.Is_Budgetarian := 'Y';
  
    Mr_Api.Person_Detail_Save(r_Person_Detail);
  
    r_Detail := z_Href_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                           i_Person_Id  => i_Person.Person_Id);
  
    if not i_Only_Natural then
      if i_Person.Access_All_Employees is not null then
        r_Detail.Access_All_Employees := i_Person.Access_All_Employees;
      else
        r_Detail.Access_All_Employees := Nvl(r_Detail.Access_All_Employees, 'N');
      end if;
    
      r_Detail.Company_Id           := i_Person.Company_Id;
      r_Detail.Person_Id            := i_Person.Person_Id;
      r_Detail.Iapa                 := i_Person.Iapa;
      r_Detail.Npin                 := i_Person.Npin;
      r_Detail.Nationality_Id       := i_Person.Nationality_Id;
      r_Detail.Key_Person           := i_Person.Key_Person;
      r_Detail.Access_All_Employees := r_Detail.Access_All_Employees;
      r_Detail.Access_Hidden_Salary := Coalesce(i_Person.Access_Hidden_Salary,
                                                r_Detail.Access_Hidden_Salary,
                                                'N');
    
      Person_Detail_Save(r_Detail);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    Md_Api.User_Delete(i_Company_Id => i_Company_Id, i_User_Id => i_Person_Id);
    Mr_Api.Natural_Person_Delete(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  ) is
    r_Person_Detail         Href_Person_Details%rowtype := i_Person_Detail;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(r_Person_Detail.Company_Id);
  
    if i_Requirable and v_Col_Required_Settings.Npin = 'Y' and trim(r_Person_Detail.Npin) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Npin);
    end if;
  
    if i_Requirable and v_Col_Required_Settings.Iapa = 'Y' and trim(r_Person_Detail.Iapa) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Iapa);
    end if;
  
    r_Person_Detail.Key_Person           := Nvl(r_Person_Detail.Key_Person, 'N');
    r_Person_Detail.Access_All_Employees := Nvl(r_Person_Detail.Access_All_Employees, 'N');
    r_Person_Detail.Access_Hidden_Salary := Nvl(r_Person_Detail.Access_Hidden_Salary, 'N');
  
    z_Href_Person_Details.Save_Row(r_Person_Detail);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype) is
    r_Person_Edu_Stage Href_Person_Edu_Stages%rowtype;
  begin
    if z_Href_Person_Edu_Stages.Exist_Lock(i_Company_Id          => i_Person_Edu_Stage.Company_Id,
                                           i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id,
                                           o_Row                 => r_Person_Edu_Stage) then
      if r_Person_Edu_Stage.Person_Id <> i_Person_Edu_Stage.Person_Id then
        Href_Error.Raise_005(i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id);
      end if;
    end if;
  
    z_Href_Person_Edu_Stages.Save_Row(i_Person_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  ) is
  begin
    z_Href_Person_Edu_Stages.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
    
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Insert_Try(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Delete_One(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype) is
  begin
    z_Href_Person_Langs.Save_Row(i_Person_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Person_Langs.Delete_One(i_Company_Id => i_Company_Id,
                                   i_Person_Id  => i_Person_Id,
                                   i_Lang_Id    => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype) is
    r_Person_Reference Href_Person_References%rowtype;
  begin
    if z_Href_Person_References.Exist_Lock(i_Company_Id          => i_Person_Reference.Company_Id,
                                           i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id,
                                           o_Row                 => r_Person_Reference) then
      if r_Person_Reference.Person_Id <> i_Person_Reference.Person_Id then
        Href_Error.Raise_009(i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id);
      end if;
    end if;
  
    z_Href_Person_References.Save_Row(i_Person_Reference);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  ) is
  begin
    z_Href_Person_References.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Reference_Id => i_Person_Reference_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype) is
    r_Person_Family_Member Href_Person_Family_Members%rowtype;
  begin
    if z_Href_Person_Family_Members.Exist_Lock(i_Company_Id              => i_Person_Family_Member.Company_Id,
                                               i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id,
                                               o_Row                     => r_Person_Family_Member) then
      if r_Person_Family_Member.Person_Id <> i_Person_Family_Member.Person_Id then
        Href_Error.Raise_010(i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id);
      end if;
    end if;
  
    z_Href_Person_Family_Members.Save_Row(i_Person_Family_Member);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  ) is
  begin
    z_Href_Person_Family_Members.Delete_One(i_Company_Id              => i_Company_Id,
                                            i_Person_Family_Member_Id => i_Person_Family_Member_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype) is
    r_Person_Marital_Status Href_Person_Marital_Statuses%rowtype;
  begin
    if z_Href_Person_Marital_Statuses.Exist_Lock(i_Company_Id               => i_Person_Marital_Status.Company_Id,
                                                 i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id,
                                                 o_Row                      => r_Person_Marital_Status) then
      if r_Person_Marital_Status.Person_Id <> i_Person_Marital_Status.Person_Id then
        Href_Error.Raise_011(i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id);
      end if;
    end if;
  
    z_Href_Person_Marital_Statuses.Save_Row(i_Person_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  ) is
  begin
    z_Href_Person_Marital_Statuses.Delete_One(i_Company_Id               => i_Company_Id,
                                              i_Person_Marital_Status_Id => i_Person_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype) is
    r_Person_Experience Href_Person_Experiences%rowtype;
  begin
    if z_Href_Person_Experiences.Exist_Lock(i_Company_Id           => i_Person_Experience.Company_Id,
                                            i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id,
                                            o_Row                  => r_Person_Experience) then
      if r_Person_Experience.Person_Id <> i_Person_Experience.Person_Id then
        Href_Error.Raise_012(i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id);
      end if;
    end if;
  
    r_Person_Experience.Company_Id           := i_Person_Experience.Company_Id;
    r_Person_Experience.Person_Experience_Id := i_Person_Experience.Person_Experience_Id;
    r_Person_Experience.Person_Id            := i_Person_Experience.Person_Id;
    r_Person_Experience.Experience_Type_Id   := i_Person_Experience.Experience_Type_Id;
    r_Person_Experience.Is_Working           := i_Person_Experience.Is_Working;
    r_Person_Experience.Start_Date           := i_Person_Experience.Start_Date;
  
    if r_Person_Experience.Is_Working = 'N' then
      r_Person_Experience.Num_Year  := Nvl(i_Person_Experience.Num_Year, 0);
      r_Person_Experience.Num_Month := Nvl(i_Person_Experience.Num_Month, 0);
      r_Person_Experience.Num_Day   := Nvl(i_Person_Experience.Num_Day, 0);
    else
      r_Person_Experience.Num_Year  := null;
      r_Person_Experience.Num_Month := null;
      r_Person_Experience.Num_Day   := null;
    end if;
  
    z_Href_Person_Experiences.Save_Row(r_Person_Experience);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  ) is
  begin
    z_Href_Person_Experiences.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Experience_Id => i_Person_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype) is
    r_Person_Award Href_Person_Awards%rowtype;
  begin
    if z_Href_Person_Awards.Exist_Lock(i_Company_Id      => i_Person_Award.Company_Id,
                                       i_Person_Award_Id => i_Person_Award.Person_Award_Id,
                                       o_Row             => r_Person_Award) then
      if r_Person_Award.Person_Id <> i_Person_Award.Person_Id then
        Href_Error.Raise_013(i_Person_Award_Id => i_Person_Award.Person_Award_Id);
      end if;
    end if;
  
    z_Href_Person_Awards.Save_Row(i_Person_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  ) is
  begin
    z_Href_Person_Awards.Delete_One(i_Company_Id      => i_Company_Id,
                                    i_Person_Award_Id => i_Person_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype) is
    r_Person_Work_Place Href_Person_Work_Places%rowtype;
  begin
    if z_Href_Person_Work_Places.Exist_Lock(i_Company_Id           => i_Person_Work_Place.Company_Id,
                                            i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id,
                                            o_Row                  => r_Person_Work_Place) then
      if r_Person_Work_Place.Person_Id <> i_Person_Work_Place.Person_Id then
        Href_Error.Raise_014(i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id);
      end if;
    end if;
  
    z_Href_Person_Work_Places.Save_Row(i_Person_Work_Place);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  ) is
  begin
    z_Href_Person_Work_Places.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Work_Place_Id => i_Person_Work_Place_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype) is
    r_Doc Href_Person_Documents%rowtype;
  begin
    if z_Href_Person_Documents.Exist_Lock(i_Company_Id  => i_Document.Company_Id,
                                          i_Document_Id => i_Document.Document_Id,
                                          o_Row         => r_Doc) then
      if r_Doc.Person_Id <> i_Document.Person_Id then
        Href_Error.Raise_015(i_Document_Id => i_Document.Document_Id);
      end if;
    end if;
  
    z_Href_Person_Documents.Save_Row(i_Document);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_New),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Approved),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Rejected),
                                       i_Rejected_Note => Option_Varchar2(i_Rejected_Note));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Delete_One(i_Company_Id  => i_Company_Id,
                                       i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Insert_Try(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Delete_One(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype) is
  begin
    z_Href_Person_Inventories.Save_Row(i_Person_Inventory);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  ) is
  begin
    z_Href_Person_Inventories.Delete_One(i_Company_Id          => i_Company_Id,
                                         i_Person_Inventory_Id => i_Person_Inventory_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id  => Md_Env.Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      for i in 1 .. i_Job_Group_Ids.Count
      loop
        z_Href_Person_Hidden_Salary_Job_Groups.Insert_Try(i_Company_Id   => i_Company_Id,
                                                          i_Person_Id    => i_Person_Id,
                                                          i_Job_Group_Id => i_Job_Group_Ids(i));
      end loop;
    
      delete Href_Person_Hidden_Salary_Job_Groups q
       where q.Company_Id = i_Company_Id
         and q.Person_Id = i_Person_Id
         and q.Job_Group_Id not member of i_Job_Group_Ids;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype) is
  begin
    z_Href_Labor_Functions.Save_Row(i_Labor_Function);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  ) is
  begin
    z_Href_Labor_Functions.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Labor_Function_Id => i_Labor_Function_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype) is
  begin
    z_Href_Sick_Leave_Reasons.Save_Row(i_Sick_Leave_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Sick_Leave_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype) is
  begin
    z_Href_Business_Trip_Reasons.Save_Row(i_Business_Trip_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Business_Trip_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype) is
  begin
    z_Href_Dismissal_Reasons.Save_Row(i_Dismissal_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  ) is
  begin
    z_Href_Dismissal_Reasons.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Dismissal_Reason_Id => i_Dismissal_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype) is
  begin
    z_Href_Wages.Save_Row(i_Wage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  ) is
  begin
    z_Href_Wages.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Wage_Id    => i_Wage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype) is
  begin
    z_Href_Employment_Sources.Save_Row(i_Employment_Source);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  ) is
  begin
    z_Href_Employment_Sources.Delete_One(i_Company_Id => i_Company_Id, i_Source_Id => i_Source_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype) is
  begin
    Href_Core.Indicator_Save(i_Indicator);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  ) is
    r_Indicator Href_Indicators%rowtype;
  begin
    r_Indicator := z_Href_Indicators.Load(i_Company_Id   => i_Company_Id,
                                          i_Indicator_Id => i_Indicator_Id);
  
    if r_Indicator.Pcode is not null then
      Href_Error.Raise_016(i_Indicator_Id   => r_Indicator.Indicator_Id,
                           i_Indicator_Name => r_Indicator.Name);
    end if;
  
    z_Href_Indicators.Delete_One(i_Company_Id => i_Company_Id, i_Indicator_Id => i_Indicator_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype) is
    r_Fte       Href_Ftes%rowtype;
    v_Pcode     Href_Ftes.Pcode%type;
    v_Fte_Value number := i_Fte.Fte_Value;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Fte.Company_Id,
                              i_Fte_Id     => i_Fte.Fte_Id,
                              o_Row        => r_Fte) and r_Fte.Pcode is not null then
      v_Fte_Value := r_Fte.Fte_Value;
      v_Pcode     := r_Fte.Pcode;
    end if;
  
    r_Fte           := i_Fte;
    r_Fte.Fte_Value := v_Fte_Value;
    r_Fte.Pcode     := v_Pcode;
  
    z_Href_Ftes.Save_Row(r_Fte);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  ) is
    r_Fte Href_Ftes%rowtype;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id, o_Row => r_Fte) then
      if r_Fte.Pcode is not null then
        Href_Error.Raise_017(i_Fte_Id => r_Fte.Fte_Id, i_Fte_Name => r_Fte.Name);
      end if;
    
      z_Href_Ftes.Delete_One(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  
    --------------------------------------------------
    Procedure Save_Pref
    (
      i_Code  varchar2,
      i_Value varchar2
    ) is
    begin
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => v_Filial_Head,
                             i_Code       => i_Code,
                             i_Value      => i_Value);
    end;
  begin
    if i_Setting.Request_Note = 'Y' and
       (i_Setting.Request_Note_Limit > 300 or i_Setting.Request_Note_Limit < 1) then
      Href_Error.Raise_034(i_Setting.Request_Note_Limit);
    end if;
  
    if i_Setting.Plan_Change_Note = 'Y' and
       (i_Setting.Plan_Change_Note_Limit > 300 or i_Setting.Plan_Change_Note_Limit < 1) then
      Href_Error.Raise_035(i_Setting.Plan_Change_Note_Limit);
    end if;
  
    Save_Pref(Href_Pref.c_Pref_Crs_Last_Name, i_Setting.Last_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Middle_Name, i_Setting.Middle_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Birthday, i_Setting.Birthday);
    Save_Pref(Href_Pref.c_Pref_Crs_Phone_Number, i_Setting.Phone_Number);
    Save_Pref(Href_Pref.c_Pref_Crs_Email, i_Setting.Email);
    Save_Pref(Href_Pref.c_Pref_Crs_Region, i_Setting.Region);
    Save_Pref(Href_Pref.c_Pref_Crs_Address, i_Setting.Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Legal_Address, i_Setting.Legal_Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Passport, i_Setting.Passport);
    Save_Pref(Href_Pref.c_Pref_Crs_Npin, i_Setting.Npin);
    Save_Pref(Href_Pref.c_Pref_Crs_Iapa, i_Setting.Iapa);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note, i_Setting.Request_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit, i_Setting.Request_Note_Limit);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note, i_Setting.Plan_Change_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit, i_Setting.Plan_Change_Note_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype) is
  begin
    z_Href_Badge_Templates.Save_Row(i_Badge_Template);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number) is
  begin
    z_Href_Badge_Templates.Delete_One(i_Badge_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Href_Error.Raise_031;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Setting,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in (Href_Pref.c_Vpu_Column_Name,
                       Href_Pref.c_Vpu_Column_Passport_Number,
                       Href_Pref.c_Vpu_Column_Npin) then
      Href_Error.Raise_032;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Column,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  ) is
  begin
    if i_Setting.Fte_Limit < 0 then
      Href_Error.Raise_036(i_Setting.Fte_Limit);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Fte_Limit_Setting,
                           i_Value      => Nvl(i_Setting.Fte_Limit_Setting, 'N'));
  
    if i_Setting.Fte_Limit_Setting = 'Y' then
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                             i_Code       => Href_Pref.c_Fte_Limit,
                             i_Value      => Nvl(i_Setting.Fte_Limit, Href_Pref.c_Fte_Limit_Default));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt) is
    r_Bank_Account Mkcs_Bank_Accounts%rowtype;
  begin
    r_Bank_Account.Company_Id        := i_Bank_Account.Company_Id;
    r_Bank_Account.Bank_Account_Id   := i_Bank_Account.Bank_Account_Id;
    r_Bank_Account.Bank_Id           := i_Bank_Account.Bank_Id;
    r_Bank_Account.Bank_Account_Code := i_Bank_Account.Bank_Account_Code;
    r_Bank_Account.Name              := i_Bank_Account.Name;
    r_Bank_Account.Person_Id         := i_Bank_Account.Person_Id;
    r_Bank_Account.Is_Main           := i_Bank_Account.Is_Main;
    r_Bank_Account.Currency_Id       := i_Bank_Account.Currency_Id;
    r_Bank_Account.Note              := i_Bank_Account.Note;
    r_Bank_Account.State             := i_Bank_Account.State;
  
    Mkcs_Api.Bank_Account_Save(r_Bank_Account);
  
    z_Href_Bank_Accounts.Save_One(i_Company_Id      => r_Bank_Account.Company_Id,
                                  i_Bank_Account_Id => r_Bank_Account.Bank_Account_Id,
                                  i_Card_Number     => i_Bank_Account.Card_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  ) is
  begin
    Mkcs_Api.Bank_Account_Delete(i_Company_Id      => i_Company_Id,
                                 i_Bank_Account_Id => i_Bank_Account_Id);
  end;

end Href_Api;
/

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
    Access_All_Employees varchar2(1),
    Access_Hidden_Salary varchar2(1),
    State                varchar2(1),
    Code                 varchar2(50 char));
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
    Note             varchar2(300 char),
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
  -- Project Code
  ----------------------------------------------------------------------------------------------------
  c_Pc_Verifix_Hr constant varchar2(10) := 'vhr';
  ----------------------------------------------------------------------------------------------------
  -- Project Version
  ----------------------------------------------------------------------------------------------------
  c_Pv_Verifix_Hr constant varchar2(10) := '2.38.1';
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
  c_Pcode_Indicator_Wage                     constant varchar2(20) := 'VHR:1';
  c_Pcode_Indicator_Rate                     constant varchar2(20) := 'VHR:2';
  c_Pcode_Indicator_Plan_Days                constant varchar2(20) := 'VHR:3';
  c_Pcode_Indicator_Fact_Days                constant varchar2(20) := 'VHR:4';
  c_Pcode_Indicator_Plan_Hours               constant varchar2(20) := 'VHR:5';
  c_Pcode_Indicator_Fact_Hours               constant varchar2(20) := 'VHR:6';
  c_Pcode_Indicator_Perf_Bonus               constant varchar2(20) := 'VHR:7';
  c_Pcode_Indicator_Perf_Extra_Bonus         constant varchar2(20) := 'VHR:8';
  c_Pcode_Indicator_Working_Days             constant varchar2(20) := 'VHR:9';
  c_Pcode_Indicator_Working_Hours            constant varchar2(20) := 'VHR:10';
  c_Pcode_Indicator_Sick_Leave_Coefficient   constant varchar2(20) := 'VHR:11';
  c_Pcode_Indicator_Business_Trip_Days       constant varchar2(20) := 'VHR:12';
  c_Pcode_Indicator_Vacation_Days            constant varchar2(20) := 'VHR:13';
  c_Pcode_Indicator_Mean_Working_Days        constant varchar2(20) := 'VHR:14';
  c_Pcode_Indicator_Sick_Leave_Days          constant varchar2(20) := 'VHR:15';
  c_Pcode_Indicator_Hourly_Wage              constant varchar2(20) := 'VHR:16';
  c_Pcode_Indicator_Overtime_Hours           constant varchar2(20) := 'VHR:17';
  c_Pcode_Indicator_Overtime_Coef            constant varchar2(20) := 'VHR:18';
  c_Pcode_Indicator_Penalty_For_Late         constant varchar2(20) := 'VHR:19';
  c_Pcode_Indicator_Penalty_For_Early_Output constant varchar2(20) := 'VHR:20';
  c_Pcode_Indicator_Penalty_For_Absence      constant varchar2(20) := 'VHR:21';
  c_Pcode_Indicator_Penalty_For_Day_Skip     constant varchar2(20) := 'VHR:22';
  c_Pcode_Indicator_Perf_Penalty             constant varchar2(20) := 'VHR:23';
  c_Pcode_Indicator_Perf_Extra_Penalty       constant varchar2(20) := 'VHR:24';
  c_Pcode_Indicator_Penalty_For_Mark_Skip    constant varchar2(20) := 'VHR:25';
  c_Pcode_Indicator_Additional_Nighttime     constant varchar2(20) := 'VHR:26';
  c_Pcode_Indicator_Weighted_Turnout         constant varchar2(20) := 'VHR:27';
  c_Pcode_Indicator_Average_Perf_Bonus       constant varchar2(20) := 'VHR:28';
  c_Pcode_Indicator_Average_Perf_Extra_Bonus constant varchar2(20) := 'VHR:29';
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
  -- Module error codes
  ----------------------------------------------------------------------------------------------------
  c_Href_Error_Code  constant varchar2(10) := 'A05-01';
  c_Hes_Error_Code   constant varchar2(10) := 'A05-02';
  c_Hlic_Error_Code  constant varchar2(10) := 'A05-03';
  c_Htt_Error_Code   constant varchar2(10) := 'A05-04';
  c_Hzk_Error_Code   constant varchar2(10) := 'A05-05';
  c_Hrm_Error_Code   constant varchar2(10) := 'A05-06';
  c_Hpd_Error_Code   constant varchar2(10) := 'A05-07';
  c_Hln_Error_Code   constant varchar2(10) := 'A05-08';
  c_Hper_Error_Code  constant varchar2(10) := 'A05-09';
  c_Hpr_Error_Code   constant varchar2(10) := 'A05-10';
  c_Hac_Error_Code   constant varchar2(10) := 'A05-11';
  c_Htm_Error_Code   constant varchar2(10) := 'A05-12';
  c_Hrec_Error_Code  constant varchar2(10) := 'A05-13';
  c_Hsc_Error_Code   constant varchar2(10) := 'A05-14';
  c_Hface_Error_Code constant varchar2(10) := 'A05-15';
  c_Uit_Error_Code   constant varchar2(10) := 'A05-99';
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

end Href_Pref;
/
create or replace package body Href_Pref is
end Href_Pref;
/

create or replace package Href_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt;
  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2;
  Function Specialty_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2;
  Function Staff_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2;
  Function Staff_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2;
  Function Employment_Source_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2;
  Function User_Acces_Levels return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2;
  Function Indicator_Useds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2;
  Function Candidate_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2;
  Function Dismissal_Reasons_Type return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2;
  Function Person_Document_Owe_Status return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2;
end Href_Util;
/
create or replace package body Href_Util is
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
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2
  ) is
  begin
    o_Person.Company_Id           := i_Company_Id;
    o_Person.Person_Id            := i_Person_Id;
    o_Person.First_Name           := i_First_Name;
    o_Person.Last_Name            := i_Last_Name;
    o_Person.Middle_Name          := i_Middle_Name;
    o_Person.Gender               := i_Gender;
    o_Person.Birthday             := i_Birthday;
    o_Person.Nationality_Id       := i_Nationality_Id;
    o_Person.Photo_Sha            := i_Photo_Sha;
    o_Person.Tin                  := i_Tin;
    o_Person.Iapa                 := i_Iapa;
    o_Person.Npin                 := i_Npin;
    o_Person.Region_Id            := i_Region_Id;
    o_Person.Main_Phone           := i_Main_Phone;
    o_Person.Email                := i_Email;
    o_Person.Address              := i_Address;
    o_Person.Legal_Address        := i_Legal_Address;
    o_Person.Key_Person           := i_Key_Person;
    o_Person.Access_All_Employees := i_Access_All_Employees;
    o_Person.Access_Hidden_Salary := i_Access_Hidden_Salary;
    o_Person.State                := i_State;
    o_Person.Code                 := i_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  ) is
  begin
    o_Candidate.Company_Id       := i_Company_Id;
    o_Candidate.Filial_Id        := i_Filial_Id;
    o_Candidate.Person_Type_Id   := i_Person_Type_Id;
    o_Candidate.Candidate_Kind   := i_Candidate_Kind;
    o_Candidate.Source_Id        := i_Source_Id;
    o_Candidate.Wage_Expectation := i_Wage_Expectation;
    o_Candidate.Cv_Sha           := i_Cv_Sha;
    o_Candidate.Note             := i_Note;
    o_Candidate.Extra_Phone      := i_Extra_Phone;
    o_Candidate.Edu_Stages       := i_Edu_Stages;
    o_Candidate.Candidate_Jobs   := i_Candidate_Jobs;
  
    o_Candidate.Person.Company_Id    := i_Company_Id;
    o_Candidate.Person.Person_Id     := i_Candidate_Id;
    o_Candidate.Person.First_Name    := i_First_Name;
    o_Candidate.Person.Last_Name     := i_Last_Name;
    o_Candidate.Person.Middle_Name   := i_Middle_Name;
    o_Candidate.Person.Gender        := i_Gender;
    o_Candidate.Person.Birthday      := i_Birthday;
    o_Candidate.Person.Photo_Sha     := i_Photo_Sha;
    o_Candidate.Person.Region_Id     := i_Region_Id;
    o_Candidate.Person.Main_Phone    := i_Main_Phone;
    o_Candidate.Person.Email         := i_Email;
    o_Candidate.Person.Address       := i_Address;
    o_Candidate.Person.Legal_Address := i_Legal_Address;
    o_Candidate.Person.State         := 'A';
  
    o_Candidate.Langs           := Href_Pref.Person_Lang_Nt();
    o_Candidate.Experiences     := Href_Pref.Person_Experience_Nt();
    o_Candidate.Recommendations := Href_Pref.Candidate_Recom_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  ) is
    v_Lang Href_Pref.Person_Lang_Rt;
  begin
    v_Lang.Lang_Id       := i_Lang_Id;
    v_Lang.Lang_Level_Id := i_Lang_Level_Id;
  
    p_Candidate.Langs.Extend;
    p_Candidate.Langs(p_Candidate.Langs.Count) := v_Lang;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  ) is
    v_Experience Href_Pref.Person_Experience_Rt;
  begin
    v_Experience.Person_Experience_Id := i_Person_Experience_Id;
    v_Experience.Experience_Type_Id   := i_Experience_Type_Id;
    v_Experience.Is_Working           := i_Is_Working;
    v_Experience.Start_Date           := i_Start_Date;
    v_Experience.Num_Year             := i_Num_Year;
    v_Experience.Num_Month            := i_Num_Month;
    v_Experience.Num_Day              := i_Num_Day;
  
    p_Candidate.Experiences.Extend;
    p_Candidate.Experiences(p_Candidate.Experiences.Count) := v_Experience;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  ) is
    v_Recommendation Href_Pref.Candidate_Recom_Rt;
  begin
    v_Recommendation.Recommendation_Id   := i_Recommendation_Id;
    v_Recommendation.Sender_Name         := i_Sender_Name;
    v_Recommendation.Sender_Phone_Number := i_Sender_Phone_Number;
    v_Recommendation.Sender_Email        := i_Sender_Email;
    v_Recommendation.File_Sha            := i_File_Sha;
    v_Recommendation.Order_No            := i_Order_No;
    v_Recommendation.Feedback            := i_Feedback;
    v_Recommendation.Note                := i_Note;
  
    p_Candidate.Recommendations.Extend;
    p_Candidate.Recommendations(p_Candidate.Recommendations.Count) := v_Recommendation;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype is
    result Href_Candidate_Ref_Settings%rowtype;
  begin
    if not z_Href_Candidate_Ref_Settings.Exist(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               o_Row        => result) then
      Result.Company_Id     := i_Company_Id;
      Result.Filial_Id      := i_Filial_Id;
      Result.Region         := 'N';
      Result.Address        := 'N';
      Result.Experience     := 'N';
      Result.Source         := 'N';
      Result.Recommendation := 'N';
      Result.Cv             := 'N';
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number is
  begin
    return z_Href_Staffs.Take(i_Company_Id => i_Company_Id, --
                              i_Filial_Id  => i_Filial_Id, --
                              i_Staff_Id   => i_Staff_Id).Employee_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns last active staff id
  -- returns null if no staff found
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Date
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns primary staff_id that was active on duration of period
  -- returns null if no such staff found
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number is
    v_Staff_Id number;
  begin
    select s.Staff_Id
      into v_Staff_Id
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Period_Begin
       and Nvl(s.Dismissal_Date, i_Period_End) >= i_Period_End;
  
    return v_Staff_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype is
    r_Division_Manager Mrf_Division_Managers%rowtype;
  begin
    r_Division_Manager := z_Mrf_Division_Managers.Take(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Division_Id => i_Division_Id);
  
    return z_Mrf_Robots.Take(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Robot_Id   => r_Division_Manager.Manager_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number is
    r_Robot       Mrf_Robots%rowtype;
    v_Division_Id number;
  begin
    v_Division_Id := z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Robot_Id => i_Robot_Id).Org_Unit_Id;
  
    r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Division_Id => v_Division_Id);
  
    if r_Robot.Robot_Id = i_Robot_Id then
      v_Division_Id := z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                       i_Filial_Id => i_Filial_Id, --
                       i_Division_Id => r_Robot.Division_Id).Parent_Id;
    
      r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Division_Id => v_Division_Id);
    end if;
  
    return r_Robot.Person_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    v_Manager_Id number;
    r_Staff      Href_Staffs%rowtype;
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Manager_Id := Get_Manager_Id(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => r_Staff.Robot_Id);
  
    return z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                     i_Person_Id  => v_Manager_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2 is
    v_Staff_Id number;
  begin
    v_Staff_Id := Get_Primary_Staff_Id(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Employee_Id  => i_Employee_Id,
                                       i_Period_Begin => Trunc(sysdate),
                                       i_Period_End   => Trunc(sysdate));
  
    return Get_Manager_Name(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => v_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Name
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Code
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number is
    result number;
  begin
    select q.Staff_Id
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Upper(q.Staff_Number) = Upper(i_Staff_Number);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined is
    r_Staff          Href_Staffs%rowtype;
    v_Staff_Licensed Href_Pref.Staff_Licensed_Rt;
    v_Begin_Date     date;
    v_End_Date       date;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Staff_Licensed.Staff_Id := i_Staff_Id;
    v_Begin_Date              := Greatest(r_Staff.Hiring_Date, i_Period_Begin);
    v_End_Date                := Least(Nvl(r_Staff.Dismissal_Date, i_Period_End), i_Period_End);
  
    for r in (select Dates.Period,
                     Nvl((select 'N'
                           from Hlic_Unlicensed_Employees Le
                          where Le.Company_Id = r_Staff.Company_Id
                            and Le.Employee_Id = r_Staff.Employee_Id
                            and Le.Licensed_Date = Dates.Period),
                         'Y') as Licensed
                from (select (v_Begin_Date + level - 1) as Period
                        from Dual
                      connect by level <= (v_End_Date - v_Begin_Date + 1)) Dates)
    loop
      v_Staff_Licensed.Period   := r.Period;
      v_Staff_Licensed.Licensed := r.Licensed;
    
      pipe row(v_Staff_Licensed);
    end loop;
  
    return;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2 is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Id     => i_Staff_Id,
                                 i_Period_Begin => i_Period_Begin,
                                 i_Period_End   => i_Period_End) q
     where q.Licensed = 'N';
  
    if v_Count = 0 then
      return 'Y';
    else
      return 'N';
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    for r in (select q.Period
                from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Staff_Id     => i_Staff_Id,
                                           i_Period_Begin => i_Period_Begin,
                                           i_Period_End   => i_Period_End) q
               where q.Licensed = 'N'
                 and Rownum = 1)
    loop
      Href_Error.Raise_018(i_Employee_Name  => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                           i_Period_Begin   => i_Period_Begin,
                           i_Period_End     => i_Period_End,
                           i_Unlicensed_Day => r.Period);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_019(i_Labor_Function_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_020(i_Labor_Function_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_021(i_Fixed_Term_Base_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_022(i_Fixed_Term_Base_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Doc_Type_Id
      into result
      from Href_Document_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Indicator_Id
      into result
      from Href_Indicators
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_023(i_Fte_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_024(i_Fte_Pcode => i_Pcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Nationality_Id
      into result
      from Href_Nationalities q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_029(i_Nationality_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns randoms integer in [low, high] interval
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number is
  begin
    return Trunc(Dbms_Random.Value(i_Low, i_High + 1));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2 is
    r_Person Mr_Natural_Persons%rowtype;
    v_Login  varchar2(100);
  begin
    r_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  
    v_Login := Regexp_Replace(i_Template, 'first_name', r_Person.First_Name);
    v_Login := Regexp_Replace(v_Login, 'last_name', r_Person.Last_Name);
    v_Login := Md_Util.Login_Fixer(v_Login);
  
    return Regexp_Replace(v_Login, '@', '');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Structural
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Pd.Division_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Hrm_Divisions Dv
        on Dv.Company_Id = Pd.Company_Id
       and Dv.Filial_Id = Pd.Filial_Id
       and Dv.Division_Id = Pd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Parents;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Manual
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    result := result multiset union
              Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                  i_Filial_Id        => i_Filial_Id,
                                  i_Only_Departments => i_Only_Departments,
                                  i_Parents          => result);
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number is
    result Array_Number;
  begin
    select Rb.Person_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Mrf_Division_Managers p
        on p.Company_Id = Pd.Company_Id
       and p.Filial_Id = Pd.Filial_Id
       and p.Division_Id = Pd.Division_Id
      join Mrf_Robots Rb
        on Rb.Company_Id = p.Company_Id
       and Rb.Filial_Id = p.Filial_Id
       and Rb.Robot_Id = p.Manager_Id
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Direct_Divisions
       and Pd.Lvl = 1;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number is
    v_Direct_Divisions Array_Number;
    result             Array_Number := Array_Number();
  begin
    v_Direct_Divisions := Get_Direct_Divisions(i_Company_Id       => i_Company_Id,
                                               i_Filial_Id        => i_Filial_Id,
                                               i_Employee_Id      => i_Employee_Id,
                                               i_Only_Departments => i_Only_Departments);
  
    o_Subordinate_Chiefs := Array_Number();
  
    if i_Direct then
      result := v_Direct_Divisions;
    
      if i_Gather_Chiefs then
        o_Subordinate_Chiefs := Get_Chief_Subordinates(i_Company_Id       => i_Company_Id,
                                                       i_Filial_Id        => i_Filial_Id,
                                                       i_Direct_Divisions => v_Direct_Divisions);
      end if;
    end if;
  
    if i_Indirect then
      result := result multiset union
                Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Parents          => v_Direct_Divisions,
                                    i_Only_Departments => i_Only_Departments);
    end if;
  
    if i_Manual then
      result := result multiset union
                Get_Manual_Divisions(i_Company_Id       => i_Company_Id,
                                     i_Filial_Id        => i_Filial_Id,
                                     i_Employee_Id      => i_Employee_Id,
                                     i_Only_Departments => i_Only_Departments);
    end if;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and exists (select 1
              from Mrf_Division_Managers m
              join Mhr_Divisions d
                on d.Company_Id = m.Company_Id
               and d.Filial_Id = m.Filial_Id
               and d.Division_Id = m.Division_Id
               and d.Parent_Id is null
             where m.Company_Id = q.Company_Id
               and m.Filial_Id = q.Filial_Id
               and m.Manager_Id = q.Robot_Id);
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number is
    v_Current_Date date := Trunc(Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id));
  
    v_Division_Ids       Array_Number;
    v_Subordinate_Chiefs Array_Number;
  
    result Array_Number := Array_Number();
  begin
    if i_Direct_Employee is null or i_Direct_Employee <> 'Y' and i_Direct_Employee <> 'N' then
      b.Raise_Not_Implemented;
    end if;
  
    v_Division_Ids := Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                i_Company_Id         => i_Company_Id,
                                                i_Filial_Id          => i_Filial_Id,
                                                i_Direct             => true,
                                                i_Indirect           => i_Direct_Employee = 'N',
                                                i_Manual             => false,
                                                i_Gather_Chiefs      => true,
                                                i_Employee_Id        => i_Employee_Id);
  
    select s.Staff_Id
      bulk collect
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and (i_Self = 'Y' or s.Employee_Id <> i_Employee_Id)
       and s.State = 'A'
       and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
       and (s.Org_Unit_Id member of v_Division_Ids or --
            s.Employee_Id member of v_Subordinate_Chiefs or --
            i_Self = 'Y' and s.Employee_Id = i_Employee_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number is
  begin
    return to_number(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                  i_Code       => Href_Pref.c_Pref_Badge_Template_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt is
    result Href_Pref.Col_Required_Setting_Rt;
  
    --------------------------------------------------
    Function Load_Pref(i_Code varchar2) return varchar2 is
    begin
      return Md_Pref.Load(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                          i_Code       => i_Code);
    end;
  begin
    Result.Last_Name              := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Last_Name), 'N');
    Result.Middle_Name            := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Middle_Name), 'N');
    Result.Birthday               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Birthday), 'N');
    Result.Phone_Number           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Phone_Number), 'N');
    Result.Email                  := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Email), 'N');
    Result.Region                 := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Region), 'N');
    Result.Address                := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Address), 'N');
    Result.Legal_Address          := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Legal_Address), 'N');
    Result.Passport               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Passport), 'N');
    Result.Npin                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Npin), 'N');
    Result.Iapa                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Iapa), 'N');
    Result.Request_Note           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note), 'N');
    Result.Request_Note_Limit     := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit), 0);
    Result.Plan_Change_Note       := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note), 'N');
    Result.Plan_Change_Note_Limit := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit), 0);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name ||
                      ' where company_id = :1 and filial_id = :2 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:3)'
                        else
                         i_Column || ' = :3'
                      end
      into v_Dummy
      using i_Company_Id, i_Filial_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name || --
                      ' where company_id = :1 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:2)'
                        else
                         i_Column || ' = :2'
                      end
      into v_Dummy
      using i_Company_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Filial_Id    => i_Filial_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Name,
                        i_Column_Value => i_Name,
                        i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2 is
    v_Dummy varchar2(1);
    v_Phone varchar2(25) := Regexp_Replace(i_Phone, '\D', '');
  begin
    select 'x'
      into v_Dummy
      from Md_Persons q
     where q.Company_Id = i_Company_Id
       and (i_Person_Id is null or q.Person_Id <> i_Person_Id)
       and q.Phone = v_Phone
       and q.State = 'A';
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Setting),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Column),
               Href_Pref.c_Vpu_Column_Passport_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache Relies_On(Href_Person_Details) is
  begin
    if i_User_Id = Md_Pref.User_Admin(i_Company_Id) then
      return 'Y';
    else
      return Nvl(z_Href_Person_Details.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_User_Id).Access_Hidden_Salary,
                 'N');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean is
  begin
    return Access_Hidden_Salary(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id) = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt is
    v_Setting Href_Pref.Fte_Limit_Rt;
  begin
    v_Setting.Fte_Limit_Setting := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                                    i_Code       => Href_Pref.c_Fte_Limit_Setting),
                                       'N');
  
    if v_Setting.Fte_Limit_Setting = 'Y' then
      v_Setting.Fte_Limit := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                              i_Code       => Href_Pref.c_Fte_Limit),
                                 Href_Pref.c_Fte_Limit_Default);
    end if;
  
    return v_Setting;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  ) is
  begin
    o_Bank_Account.Company_Id        := i_Company_Id;
    o_Bank_Account.Bank_Account_Id   := i_Bank_Account_Id;
    o_Bank_Account.Bank_Id           := i_Bank_Id;
    o_Bank_Account.Bank_Account_Code := i_Bank_Account_Code;
    o_Bank_Account.Name              := i_Name;
    o_Bank_Account.Person_Id         := i_Person_Id;
    o_Bank_Account.Is_Main           := i_Is_Main;
    o_Bank_Account.Currency_Id       := i_Currency_Id;
    o_Bank_Account.Note              := i_Note;
    o_Bank_Account.Card_Number       := i_Card_Number;
    o_Bank_Account.State             := i_State;
  end;

  ----------------------------------------------------------------------------------------------------
  -- specialty kind
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Group return varchar2 is
  begin
    return t('specialty_kind:group');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Specialty return varchar2 is
  begin
    return t('specialty_kind:specialty');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Specialty_Kind_Group then t_Specialty_Kind_Group --
    when Href_Pref.c_Specialty_Kind_Specialty then t_Specialty_Kind_Specialty --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Specialty_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Specialty_Kind_Group,
                                          Href_Pref.c_Specialty_Kind_Specialty),
                           Array_Varchar2(t_Specialty_Kind_Group, t_Specialty_Kind_Specialty));
  end;

  ----------------------------------------------------------------------------------------------------
  -- staff status
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Working return varchar2 is
  begin
    return t('staff_status:working');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Dismissed return varchar2 is
  begin
    return t('staff_status:dismissed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Unknown return varchar2 is
  begin
    return t('staff_status:unknown');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Status --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed,
                                          Href_Pref.c_Staff_Status_Unknown),
                           Array_Varchar2(t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed,
                                          t_Staff_Status_Unknown));
  
  end;
  ----------------------------------------------------------------------------------------------------
  -- staff kind
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Primary return varchar2 is
  begin
    return t('staff_kind:primary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Secondary return varchar2 is
  begin
    return t('staff_kind:secondary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Kind --
    when Href_Pref.c_Staff_Kind_Primary then t_Staff_Kind_Primary --
    when Href_Pref.c_Staff_Kind_Secondary then t_Staff_Kind_Secondary --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Kind_Primary,
                                          Href_Pref.c_Staff_Kind_Secondary),
                           Array_Varchar2(t_Staff_Kind_Primary, t_Staff_Kind_Secondary));
  end;

  ----------------------------------------------------------------------------------------------------
  -- employment source kind
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Hiring return varchar2 is
  begin
    return t('employment_source_kind:hiring');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Dismissal return varchar2 is
  begin
    return t('employment_source_kind:dismissal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Both return varchar2 is
  begin
    return t('employment_source_kind:both');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Source_Kind --
    when Href_Pref.c_Employment_Source_Kind_Hiring then t_Employment_Source_Kind_Hiring --
    when Href_Pref.c_Employment_Source_Kind_Dismissal then t_Employment_Source_Kind_Dismissal --
    when Href_Pref.c_Employment_Source_Kind_Both then t_Employment_Source_Kind_Both --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Source_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Employment_Source_Kind_Hiring,
                                          Href_Pref.c_Employment_Source_Kind_Dismissal,
                                          Href_Pref.c_Employment_Source_Kind_Both),
                           Array_Varchar2(t_Employment_Source_Kind_Hiring,
                                          t_Employment_Source_Kind_Dismissal,
                                          t_Employment_Source_Kind_Both));
  end;

  ----------------------------------------------------------------------------------------------------
  -- user access level
  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Personal return varchar2 is
  begin
    return t('user_access_level: personal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Direct_Employee return varchar2 is
  begin
    return t('user_access_level: direct employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Undirect_Employee return varchar2 is
  begin
    return t('user_access_level: undirect employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Manual return varchar2 is
  begin
    return t('user_access_level: manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Other return varchar2 is
  begin
    return t('user_access_level: other');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2 is
  begin
    return --
    case i_Acces_Level --
    when Href_Pref.c_User_Access_Level_Personal then t_User_Access_Level_Personal --
    when Href_Pref.c_User_Access_Level_Direct_Employee then t_User_Access_Level_Direct_Employee --
    when Href_Pref.c_User_Access_Level_Undirect_Employee then t_User_Access_Level_Undirect_Employee --
    when Href_Pref.c_User_Access_Level_Manual then t_User_Access_Level_Manual --
    when Href_Pref.c_User_Access_Level_Other then t_User_Access_Level_Other --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Acces_Levels return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_User_Access_Level_Personal,
                                          Href_Pref.c_User_Access_Level_Direct_Employee,
                                          Href_Pref.c_User_Access_Level_Undirect_Employee,
                                          Href_Pref.c_User_Access_Level_Manual,
                                          Href_Pref.c_User_Access_Level_Other),
                           Array_Varchar2(t_User_Access_Level_Personal,
                                          t_User_Access_Level_Direct_Employee,
                                          t_User_Access_Level_Undirect_Employee,
                                          t_User_Access_Level_Manual,
                                          t_User_Access_Level_Other));
  end;

  ----------------------------------------------------------------------------------------------------
  -- indicator used
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Constantly return varchar2 is
  begin
    return t('indicator_used:constantly');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Automatically return varchar2 is
  begin
    return t('indicator_used:automatically');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2 is
  begin
    return --
    case i_Used --
    when Href_Pref.c_Indicator_Used_Constantly then t_Indicator_Used_Constantly --
    when Href_Pref.c_Indicator_Used_Automatically then t_Indicator_Used_Automatically --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Useds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Indicator_Used_Constantly,
                                          Href_Pref.c_Indicator_Used_Automatically),
                           Array_Varchar2(t_Indicator_Used_Constantly,
                                          t_Indicator_Used_Automatically));
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate kind
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind_New return varchar is
  begin
    return t('candidate_kind: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Candidate_Kind_New then t_Candidate_Kind_New --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Candidate_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Candidate_Kind_New,
                                          Href_Pref.c_Staff_Status_Unknown,
                                          Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed),
                           Array_Varchar2(t_Candidate_Kind_New,
                                          t_Staff_Status_Unknown,
                                          t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- dismissal reasons type
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Positive return varchar2 is
  begin
    return t('dismissal_reasons_type: positive');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Negative return varchar2 is
  begin
    return t('dismissal_reasons_type: negative');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2 is
  begin
    return --
    case i_Dismissal_Reasons_Type --
    when Href_Pref.c_Dismissal_Reasons_Type_Positive then t_Dismissal_Reasons_Type_Positive --
    when Href_Pref.c_Dismissal_Reasons_Type_Negative then t_Dismissal_Reasons_Type_Negative --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reasons_Type return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Dismissal_Reasons_Type_Positive,
                                          Href_Pref.c_Dismissal_Reasons_Type_Negative),
                           Array_Varchar2(t_Dismissal_Reasons_Type_Positive, --
                                          t_Dismissal_Reasons_Type_Negative));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2 is
  begin
    return t('custom fte name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2 is
    v_t_From varchar2(100 char);
    v_t_To   varchar2(100 char);
  begin
    if i_From is not null or i_To is null then
      v_t_From := t('from_to_rule:from $1{from_value} $2{rule_unit}', Nvl(i_From, 0), i_Rule_Unit);
    end if;
  
    if i_To is not null then
      v_t_To := t('from_to_rule:to $1{to_value} $2{rule_unit}', i_To, i_Rule_Unit);
    end if;
  
    return trim(v_t_From || ' ' || v_t_To);
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_New return varchar2 is
  begin
    return t('person_document_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Approved return varchar2 is
  begin
    return t('person_document_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Rejected return varchar2 is
  begin
    return t('person_document_status:rejected');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Status_New then t_Person_Document_Status_New --
    when Href_Pref.c_Person_Document_Status_Approved then t_Person_Document_Status_Approved --
    when Href_Pref.c_Person_Document_Status_Rejected then t_Person_Document_Status_Rejected --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document owe status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Complete return varchar2 is
  begin
    return t('person_document_owe_status:complete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Partial return varchar2 is
  begin
    return t('person_document_owe_status:partial');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Exempt return varchar2 is
  begin
    return t('person_document_owe_status:exempt');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Owe_Status_Complete then t_Person_Document_Owe_Status_Complete --
    when Href_Pref.c_Person_Document_Owe_Status_Partial then t_Person_Document_Owe_Status_Partial --
    when Href_Pref.c_Person_Document_Owe_Status_Exempt then t_Person_Document_Owe_Status_Exempt --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Document_Owe_Status return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Person_Document_Owe_Status_Complete,
                                          Href_Pref.c_Person_Document_Owe_Status_Partial,
                                          Href_Pref.c_Person_Document_Owe_Status_Exempt),
                           Array_Varchar2(t_Person_Document_Owe_Status_Complete,
                                          t_Person_Document_Owe_Status_Partial,
                                          t_Person_Document_Owe_Status_Exempt));
  end;

  ----------------------------------------------------------------------------------------------------
  -- verify person uniqueness
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Name return varchar2 is
  begin
    return t('verify_person_uniqueness_column:name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Passport_Number return varchar2 is
  begin
    return t('verify_person_uniqueness_column:passport_number');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Npin return varchar2 is
  begin
    return t('verify_person_uniqueness_column:npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2 is
  begin
    return --
    case i_Column --
    when Href_Pref.c_Vpu_Column_Name then t_Verify_Person_Uniqueness_Column_Name --
    when Href_Pref.c_Vpu_Column_Passport_Number then t_Verify_Person_Uniqueness_Column_Passport_Number --
    when Href_Pref.c_Vpu_Column_Npin then t_Verify_Person_Uniqueness_Column_Npin --
    end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee personal audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_First_Name return varchar2 is
  begin
    return t('first name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Last_Name return varchar2 is
  begin
    return t('last name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Middle_Name return varchar2 is
  begin
    return t('middle name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Nationality return varchar2 is
  begin
    return t('nationality');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Birthday return varchar2 is
  begin
    return t('birthday');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gender return varchar2 is
  begin
    return t('gender');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Npin return varchar2 is
  begin
    return t('npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Iapa return varchar2 is
  begin
    return t('iapa');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Tin return varchar2 is
  begin
    return t('tin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Note return varchar2 is
  begin
    return t('note');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.First_Name,
                                          z.Last_Name,
                                          z.Middle_Name,
                                          z.Nationality,
                                          z.Birthday,
                                          z.Gender,
                                          z.Npin,
                                          z.Iapa,
                                          z.Tin,
                                          z.Note),
                           Array_Varchar2(t_First_Name,
                                          t_Last_Name,
                                          t_Middle_Name,
                                          t_Nationality,
                                          t_Birthday,
                                          t_Gender,
                                          t_Npin,
                                          t_Iapa,
                                          t_Tin,
                                          t_Note));
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee contact audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_Main_Phone return varchar2 is
  begin
    return t('main phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Extra_Phone return varchar2 is
  begin
    return t('extra phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Email return varchar2 is
  begin
    return t('email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Corporate_Email return varchar2 is
  begin
    return t('corporate email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Region return varchar2 is
  begin
    return t('region');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Address return varchar2 is
  begin
    return t('address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Legal_Address return varchar2 is
  begin
    return t('legal address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.Main_Phone,
                                          z.Extra_Phone,
                                          z.Email,
                                          z.Corporate_Email,
                                          z.Region,
                                          z.Address,
                                          z.Legal_Address),
                           Array_Varchar2(t_Main_Phone,
                                          t_Extra_Phone,
                                          t_Email,
                                          t_Corporate_Email,
                                          t_Region,
                                          t_Address,
                                          t_Legal_Address));
  end;

end Href_Util;
/

