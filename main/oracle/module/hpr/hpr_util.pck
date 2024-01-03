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
  Function Calc_Completed_Exam_Score
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Exam_Id    number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Completed_Training_Subjects
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date,
    i_Subject_Ids Array_Number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Average_Attendance_Percentage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perfomance_Percentage
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
    i_Indicator_Id number,
    i_Exam_Id      number := null,
    i_Subject_Ids  Array_Number := null
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
  Function Calc_Employee_Credit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Month       date
  ) return number;
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
  Function Oper_Type_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Jcode_Credit(i_Credit_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------     
  Procedure Credit_New
  (
    o_Credit          out Hpr_Pref.Credit_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Credit_Id       number,
    i_Credit_Number   varchar2,
    i_Credit_Date     date,
    i_Booked_Date     date,
    i_Employee_Id     number,
    i_Begin_Month     date,
    i_End_Month       date,
    i_Credit_Amount   number,
    i_Currency_Id     number,
    i_Payment_Type    varchar2,
    i_Cashbox_Id      number,
    i_Bank_Account_Id number,
    i_Status          varchar2,
    i_Note            varchar2
  );
  ----------------------------------------------------------------------------------------------------       
  Function Payment_Credit
  (
    i_Company_Id                   number,
    i_Filial_Id                    number,
    i_Currency_Id                  number,
    i_Person_Id                    number := null,
    i_Payroll_Accrual_Condition_Id number := null,
    i_Ref_Codes                    Array_Number := null
  ) return Mk_Account;
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
  ----------------------------------------------------------------------------------------------------
  Function t_Credit_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Credit_Statuses return Matrix_Varchar2;
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
    v_Formula          varchar2(32767) := i_Formula;
    v_Global_Variables Hide_Pref.Global_Variable_Nt := Hide_Pref.Global_Variable_Nt();
    result             number;
  begin
    for i in 1 .. i_Arguments.Count
    loop
      Hide_Util.Add_Global_Variable_Value(o_Global_Variable_Value => v_Global_Variables,
                                          i_Name                  => i_Arguments(i) (1),
                                          i_Value                 => i_Arguments(i) (2));
    end loop;
  
    result := Hide_Util.Expression_Execute(i_Expression       => i_Formula,
                                           i_Global_Variables => v_Global_Variables);
  
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
  
    v_Identifiers := Hide_Util.Get_Global_Variables(result);
  
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
    v_Variables := Hide_Util.Get_Global_Variables(i_Formula);
  
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
    v_Dummy         number;
    v_Dummy1        varchar2(1);
    v_Error_Message Gmap;
    v_Variables     Array_Varchar2 := Array_Varchar2();
    v_Arguments     Matrix_Varchar2;
    result          Array_Varchar2 := Array_Varchar2();
  begin
    begin
      v_Variables := Hide_Util.Get_Global_Variables(i_Formula);
    exception
      when others then
        v_Error_Message := Gmap(Json_Object_t.Parse(Substr(sqlerrm, 12)));
        Fazo.Push(result,
                  Nvl(v_Error_Message.r_Varchar2('message'),
                      t('an error occurred while validating a formula calculation')));
    end;
  
    for i in 1 .. v_Variables.Count
    loop
      begin
        select 'x'
          into v_Dummy1
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
    select Array_Varchar2(Column_Value, '1')
      bulk collect
      into v_Arguments
      from table(v_Variables)
     order by Length(Column_Value) desc;
  
    if Result.Count = 0 then
      begin
        v_Dummy := Formula_Execute(i_Formula => i_Formula, i_Arguments => v_Arguments);
      exception
        when others then
          v_Error_Message := Gmap(Json_Object_t.Parse(Substr(sqlerrm, 12)));
          Fazo.Push(result,
                    Nvl(v_Error_Message.r_Varchar2('message'),
                        t('an error occurred while validating a formula calculation')));
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
    end if;
  
    if result is null then
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
  
    select sum(q.Main_Fact_Amount), sum(q.Extra_Fact_Amount)
      into o_Main_Fact_Amount, o_Extra_Fact_Amount
      from Hper_Staff_Plans q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Plan_Date between v_Begin_Date and v_End_Date
       and q.Status = Hper_Pref.c_Staff_Plan_Status_Completed;
  
    o_Main_Fact_Amount  := o_Main_Fact_Amount / 12;
    o_Extra_Fact_Amount := o_Extra_Fact_Amount / 12;
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
  Function Calc_Completed_Exam_Score
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Exam_Id    number,
    i_Period     date
  ) return number is
    r_Staff       Href_Staffs%rowtype;
    r_Exam        Hln_Exams%rowtype;
    v_Correct_Cnt number;
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    r_Exam := z_Hln_Exams.Take(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Exam_Id    => i_Exam_Id);
  
    if r_Exam.Question_Count = 0 then
      return 0;
    end if;
  
    begin
      select q.Correct_Questions_Count
        into v_Correct_Cnt
        from Hln_Testings q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Exam_Id = i_Exam_Id
         and q.Person_Id = r_Staff.Employee_Id
         and q.Status = Hln_Pref.c_Testing_Status_Finished
         and q.Testing_Date <= i_Period
       order by q.Testing_Date desc, q.Fact_Begin_Time desc
       fetch first row only;
    exception
      when No_Data_Found then
        v_Correct_Cnt := 0;
    end;
  
    return Nvl(v_Correct_Cnt / r_Exam.Question_Count * 100, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Completed_Training_Subjects
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date,
    i_Subject_Ids Array_Number
  ) return number is
    r_Staff Href_Staffs%rowtype;
  
    v_Passed_Cnt number;
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if i_Subject_Ids is null or i_Subject_Ids.Count = 0 then
      return 0;
    end if;
  
    select count(distinct q.Subject_Id)
      into v_Passed_Cnt
      from Hln_Training_Person_Subjects q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = r_Staff.Employee_Id
       and q.Subject_Id member of i_Subject_Ids
       and q.Passed = 'Y'
       and exists (select 1
              from Hln_Trainings p
             where p.Company_Id = q.Company_Id
               and p.Filial_Id = q.Filial_Id
               and p.Training_Id = q.Training_Id
               and p.Begin_Date between i_Begin_Date and i_End_Date
               and p.Status = Hln_Pref.c_Training_Status_Finished);
  
    return Nvl(v_Passed_Cnt / i_Subject_Ids.Count * 100, 0);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Average_Attendance_Percentage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Turnout_Tk_Ids Array_Number;
    v_Fact_Cnt       number;
    v_Days_Cnt       number;
  begin
    v_Turnout_Tk_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                                          i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    select count(case
                    when exists (select *
                            from Htt_Timesheet_Facts Tf
                           where Tf.Company_Id = q.Company_Id
                             and Tf.Filial_Id = q.Filial_Id
                             and Tf.Timesheet_Id = q.Timesheet_Id
                             and Tf.Time_Kind_Id member of v_Turnout_Tk_Ids
                             and Tf.Fact_Value > 0) then
                     1
                    else
                     null
                  end),
           count(*)
      into v_Fact_Cnt, v_Days_Cnt
      from Htt_Timesheets q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Timesheet_Date between i_Begin_Date and i_End_Date
       and q.Day_Kind = Htt_Pref.c_Day_Kind_Work;
  
    if v_Days_Cnt is null or v_Days_Cnt = 0 then
      return 0;
    end if;
  
    return Nvl(v_Fact_Cnt / v_Days_Cnt * 100, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Average_Perfomance_Percentage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Charge_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Begin_Date date := Trunc(i_Begin_Date);
    v_End_Date   date := Last_Day(i_End_Date);
    result       number;
  begin
    select avg(q.Main_Fact_Percent)
      into result
      from Hper_Staff_Plans q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Plan_Date between v_Begin_Date and v_End_Date
       and q.Status = Hper_Pref.c_Staff_Plan_Status_Completed;
  
    return Nvl(result, 0);
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
    when Href_Pref.c_Pcode_Indicator_Average_Attendance_Percentage then 'hpr_util.calc_average_attendance_percentage' --
    when Href_Pref.c_Pcode_Indicator_Average_Perfomance_Percentage then 'hpr_util.calc_average_perfomance_percentage' --
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
    i_Indicator_Id number,
    i_Exam_Id      number := null,
    i_Subject_Ids  Array_Number := null
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
      v_Currency_Id          number;
      v_Wage_Indicator_Group number;
    begin
      if i_Indicator.Used != Href_Pref.c_Indicator_Used_Constantly and
         i_Indicator.Pcode not in
         (Href_Pref.c_Pcode_Indicator_Perf_Penalty, Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty) then
        return i_Amount;
      end if;
    
      v_Wage_Indicator_Group := Href_Util.Indicator_Group_Id(i_Company_Id => i_Company_Id,
                                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Group_Wage);
    
      if i_Indicator.Indicator_Group_Id <> v_Wage_Indicator_Group then
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
    elsif r_Indicator.Pcode = Href_Pref.c_Pcode_Indicator_Trainings_Subjects then
      return Calc_Completed_Training_Subjects(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Staff_Id    => i_Staff_Id,
                                              i_Begin_Date  => i_Begin_Date,
                                              i_End_Date    => i_End_Date,
                                              i_Subject_Ids => i_Subject_Ids);
    elsif r_Indicator.Pcode = Href_Pref.c_Pcode_Indicator_Exam_Results then
      return Calc_Completed_Exam_Score(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Exam_Id    => i_Exam_Id,
                                       i_Period     => i_End_Date);
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
  Function Calc_Employee_Credit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Month       date
  ) return number is
    v_Credit_Amount number := 0;
    v_Begin_Month   date;
    v_End_Month     date;
  begin
    for r in (select q.Credit_Amount, q.Begin_Month, q.End_Month
                from Hpr_Credits q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Employee_Id = i_Employee_Id
                 and i_Month between q.Begin_Month and q.End_Month
                 and q.Status = Hpr_Pref.c_Credit_Status_Complete)
    loop
      v_Credit_Amount := v_Credit_Amount +
                         Round(r.Credit_Amount / (Months_Between(r.End_Month, r.Begin_Month) + 1),
                               2);
    end loop;
  
    return v_Credit_Amount;
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
  Function Oper_Type_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    v_Id number;
  begin
    select q.Oper_Type_Id
      into v_Id
      from Mpr_Oper_Types q
     where q.Company_Id = i_Company_Id
       and q.Name = i_Name
       and exists (select 1
              from Hpr_Oper_Types w
             where w.Company_Id = q.Company_Id
               and w.Oper_Type_Id = q.Oper_Type_Id);
  
    return v_Id;
  exception
    when No_Data_Found then
      Hpr_Error.Raise_056(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Jcode_Credit(i_Credit_Id number) return varchar2 is
  begin
    return Mkr_Util.Journal_Code(i_Source_Table => Zt.Hpr_Credits, i_Source_Id => i_Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Credit_New
  (
    o_Credit          out Hpr_Pref.Credit_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Credit_Id       number,
    i_Credit_Number   varchar2,
    i_Credit_Date     date,
    i_Booked_Date     date,
    i_Employee_Id     number,
    i_Begin_Month     date,
    i_End_Month       date,
    i_Credit_Amount   number,
    i_Currency_Id     number,
    i_Payment_Type    varchar2,
    i_Cashbox_Id      number,
    i_Bank_Account_Id number,
    i_Status          varchar2,
    i_Note            varchar2
  ) is
  begin
    o_Credit.Company_Id      := i_Company_Id;
    o_Credit.Filial_Id       := i_Filial_Id;
    o_Credit.Credit_Id       := i_Credit_Id;
    o_Credit.Credit_Number   := i_Credit_Number;
    o_Credit.Credit_Date     := i_Credit_Date;
    o_Credit.Booked_Date     := i_Booked_Date;
    o_Credit.Employee_Id     := i_Employee_Id;
    o_Credit.Begin_Month     := i_Begin_Month;
    o_Credit.End_Month       := i_End_Month;
    o_Credit.Credit_Amount   := i_Credit_Amount;
    o_Credit.Currency_Id     := i_Currency_Id;
    o_Credit.Payment_Type    := i_Payment_Type;
    o_Credit.Cashbox_Id      := i_Cashbox_Id;
    o_Credit.Bank_Account_Id := i_Bank_Account_Id;
    o_Credit.Status          := i_Status;
    o_Credit.Note            := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------     
  Function Account
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Coa_Id      number,
    i_Ref_Codes   Array_Number := null,
    i_Currency_Id number := null
  ) return Mk_Account is
    v_Currency_Id number := i_Currency_Id;
  begin
    if i_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id);
    end if;
  
    return Mk_Util.Account(i_Company_Id  => i_Company_Id,
                           i_Filial_Id   => i_Filial_Id,
                           i_Coa_Id      => i_Coa_Id,
                           i_Currency_Id => v_Currency_Id,
                           i_Ref_Codes   => i_Ref_Codes);
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Payment_Credit
  (
    i_Company_Id                   number,
    i_Filial_Id                    number,
    i_Currency_Id                  number,
    i_Person_Id                    number := null,
    i_Payroll_Accrual_Condition_Id number := null,
    i_Ref_Codes                    Array_Number := null
  ) return Mk_Account is
    v_Ref_Codes Array_Number;
  begin
    v_Ref_Codes := Mkr_Account.Ref_Codes(i_Person_Id                    => i_Person_Id,
                                         i_Payroll_Accrual_Condition_Id => i_Payroll_Accrual_Condition_Id,
                                         i_Extras                       => i_Ref_Codes);
  
    return Account(i_Company_Id  => i_Company_Id,
                   i_Filial_Id   => i_Filial_Id,
                   i_Coa_Id      => z_Mkr_Coa_Defaults.Take(i_Company_Id => i_Company_Id, --
                                    i_Filial_Id => i_Filial_Id, --
                                    i_Code => Hpr_Pref.c_Pref_Coa_Employee_Credit).Coa_Id,
                   i_Currency_Id => i_Currency_Id,
                   i_Ref_Codes   => v_Ref_Codes);
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

  ----------------------------------------------------------------------------------------------------     
  Function t_Credit_Status_Draft return varchar2 is
  begin
    return t('credit status: draft');
  end;

  ----------------------------------------------------------------------------------------------------     
  Function t_Credit_Status_Booked return varchar2 is
  begin
    return t('credit status: booked');
  end;

  ----------------------------------------------------------------------------------------------------     
  Function t_Credit_Status_Complete return varchar2 is
  begin
    return t('credit status: complete');
  end;

  ----------------------------------------------------------------------------------------------------     
  Function t_Credit_Status_Archived return varchar2 is
  begin
    return t('credit status: archived');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Credit_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hpr_Pref.c_Credit_Status_Booked then t_Credit_Status_Booked --
    when Hpr_Pref.c_Credit_Status_Archived then t_Credit_Status_Archived --  
    when Hpr_Pref.c_Credit_Status_Complete then t_Credit_Status_Complete --
    when Hpr_Pref.c_Credit_Status_Draft then t_Credit_Status_Draft --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Credit_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpr_Pref.c_Credit_Status_Booked,
                                          Hpr_Pref.c_Credit_Status_Archived,
                                          Hpr_Pref.c_Credit_Status_Complete,
                                          Hpr_Pref.c_Credit_Status_Draft),
                           Array_Varchar2(t_Credit_Status_Booked,
                                          t_Credit_Status_Archived,
                                          t_Credit_Status_Complete,
                                          t_Credit_Status_Draft));
  end;

end Hpr_Util;
/
