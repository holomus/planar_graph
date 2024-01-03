create or replace package Hper_Pref is
  ----------------------------------------------------------------------------------------------------
  type Rule_Rt is record(
    From_Percent number,
    To_Percent   number,
    Amount       number);
  type Rule_Nt is table of Rule_Rt;
  ----------------------------------------------------------------------------------------------------
  type Plan_Type_Rt is record(
    Company_Id           number,
    Filial_Id            number,
    Plan_Type_Id         number,
    name                 Hper_Plan_Types.Name%type,
    Plan_Group_Id        number,
    Calc_Kind            varchar2(1),
    With_Part            varchar2(1),
    Extra_Amount_Enabled varchar2(1),
    Sale_Kind            varchar2(1),
    State                varchar2(1),
    Code                 Hper_Plan_Types.Code%type,
    Order_No             number,
    Division_Ids         Array_Number,
    Task_Type_Ids        Array_Number,
    Rules                Rule_Nt);
  ----------------------------------------------------------------------------------------------------
  type Plan_Item_Rt is record(
    Plan_Type_Id number,
    Plan_Type    varchar2(1),
    Plan_Value   number,
    Plan_Amount  number,
    Note         varchar2(300 char),
    Rules        Rule_Nt);
  type Plan_Item_Nt is table of Plan_Item_Rt;
  ----------------------------------------------------------------------------------------------------
  type Plan_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Plan_Id         number,
    Plan_Date       date,
    Main_Calc_Type  varchar2(1),
    Extra_Calc_Type varchar2(1),
    Journal_Page_Id number,
    Division_Id     number,
    Job_Id          number,
    Rank_Id         number,
    Employment_Type varchar2(1),
    Note            varchar2(300 char),
    Items           Plan_Item_Nt);
  ----------------------------------------------------------------------------------------------------
  c_Pref_Month_End constant varchar2(50) := 'hper:month_end';
  ----------------------------------------------------------------------------------------------------
  c_Plan_Kind_Standard constant varchar2(1) := 'S';
  c_Plan_Kind_Contract constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  c_Plan_Calc_Type_Weight constant varchar2(1) := 'W';
  c_Plan_Calc_Type_Unit   constant varchar2(1) := 'U';
  ----------------------------------------------------------------------------------------------------
  c_Plan_Type_Main  constant varchar2(1) := 'M';
  c_Plan_Type_Extra constant varchar2(1) := 'E';
  ----------------------------------------------------------------------------------------------------
  c_Calc_Kind_Manual     constant varchar2(1) := 'M';
  c_Calc_Kind_Task       constant varchar2(1) := 'T';
  c_Calc_Kind_Attendance constant varchar2(1) := 'A';
  c_Calc_Kind_External   constant varchar2(1) := 'E';
  ----------------------------------------------------------------------------------------------------
  c_Sale_Kind_Personal   constant varchar2(1) := 'P';
  c_Sale_Kind_Department constant varchar2(1) := 'D';
  ----------------------------------------------------------------------------------------------------
  c_Staff_Plan_Status_Draft     constant varchar2(1) := 'D';
  c_Staff_Plan_Status_New       constant varchar2(1) := 'N';
  c_Staff_Plan_Status_Waiting   constant varchar2(1) := 'W';
  c_Staff_Plan_Status_Completed constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Task_Group_Plan constant varchar2(20) := 'VHR:1';
end Hper_Pref;
/
create or replace package body Hper_Pref is
end Hper_Pref;
/
