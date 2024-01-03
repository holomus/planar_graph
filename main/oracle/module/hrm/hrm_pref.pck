create or replace package Hrm_Pref is
  ----------------------------------------------------------------------------------------------------  
  type Register_Rank_Indicator_Rt is record(
    Indicator_Id    number(20),
    Indicator_Value number(20, 6),
    Coefficient     number);
  type Regiser_Rank_Indicator_Nt is table of Register_Rank_Indicator_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Register_Ranks_Rt is record(
    Rank_Id    number,
    Indicators Regiser_Rank_Indicator_Nt);
  type Register_Ranks_Nt is table of Register_Ranks_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Wage_Scale_Register_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Register_Id     number,
    Register_Date   date,
    Register_Number varchar2(50),
    Wage_Scale_Id   number,
    With_Base_Wage  varchar2(1),
    Round_Model     varchar2(5),
    Base_Wage       number(20, 6),
    Valid_From      date,
    Posted          varchar2(1),
    Note            varchar2(300 char),
    Ranks           Register_Ranks_Nt);
  ----------------------------------------------------------------------------------------------------
  type Robot_Rt is record(
    Robot                    Mrf_Robots%rowtype,
    Org_Unit_Id              number,
    Opened_Date              date,
    Closed_Date              date,
    Schedule_Id              number(20),
    Rank_Id                  number(20),
    Labor_Function_Id        number(20),
    Description              varchar2(300 char),
    Hiring_Condition         varchar2(300 char),
    Vacation_Days_Limit      number(20),
    Contractual_Wage         varchar2(1),
    Wage_Scale_Id            number(20),
    Access_Hidden_Salary     varchar2(1),
    Position_Employment_Kind varchar2(1),
    Planned_Fte              number,
    Currency_Id              number(20),
    Role_Ids                 Array_Number,
    Allowed_Division_Ids     Array_Number,
    Indicators               Href_Pref.Indicator_Nt,
    Oper_Types               Href_Pref.Oper_Type_Nt);
  ----------------------------------------------------------------------------------------------------  
  type Job_Template_Rt is record(
    Company_Id          number,
    Filial_Id           number,
    Template_Id         number,
    Division_Id         number,
    Job_Id              number,
    Rank_Id             number,
    Schedule_Id         number,
    Vacation_Days_Limit number,
    Wage_Scale_Id       number,
    Indicators          Href_Pref.Indicator_Nt,
    Oper_Types          Href_Pref.Oper_Type_Nt);
  ----------------------------------------------------------------------------------------------------
  type Job_Bonus_Type_Rt is record(
    Company_Id  number,
    Filial_Id   number,
    Job_Id      number,
    Bonus_Types Array_Varchar2,
    Percentages Array_Number);
  ---------------------------------------------------------------------------------------------------- 
  type Division_Rt is record(
    Division      Mhr_Divisions%rowtype,
    Schedule_Id   number,
    Manager_Id    number,
    Is_Department varchar2(1),
    Subfilial_Id  number);
  ----------------------------------------------------------------------------------------------------
  -- employment type
  ----------------------------------------------------------------------------------------------------
  c_Employment_Type_Main_Job          constant varchar2(1) := 'M';
  c_Employment_Type_External_Parttime constant varchar2(1) := 'E';
  c_Employment_Type_Internal_Parttime constant varchar2(1) := 'I';
  ----------------------------------------------------------------------------------------------------
  -- fte kind
  ----------------------------------------------------------------------------------------------------
  c_Fte_Kind_Planed   constant varchar2(1) := 'P';
  c_Fte_Kind_Booked   constant varchar2(1) := 'B';
  c_Fte_Kind_Occupied constant varchar2(1) := 'O';
  ----------------------------------------------------------------------------------------------------  
  -- access type
  ----------------------------------------------------------------------------------------------------
  c_Access_Type_Structural constant varchar2(1) := 'S';
  c_Access_Type_Manual     constant varchar2(1) := 'M';
  ----------------------------------------------------------------------------------------------------  
  -- bonus type
  ----------------------------------------------------------------------------------------------------
  c_Bonus_Type_Personal_Sales      constant varchar2(1) := 'P';
  c_Bonus_Type_Department_Sales    constant varchar2(1) := 'D';
  c_Bonus_Type_Successful_Delivery constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  -- restrict to view all salaries
  ----------------------------------------------------------------------------------------------------
  c_Pref_Restrict_To_View_All_Salaries constant varchar2(200) := 'VHR:HRM:RESTRICT_TO_VIEW_ALL_SALARIES';
  c_Pref_Restrict_All_Salaries         constant varchar2(200) := 'VHR:HRM:RESTRICT_ALL_SALARIES';
  ----------------------------------------------------------------------------------------------------
  --- manager status of division 
  ----------------------------------------------------------------------------------------------------
  c_Division_Manager_Status_Manual constant varchar2(1) := 'M';
  c_Division_Manager_Status_Auto   constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- Position Employment Kind
  ----------------------------------------------------------------------------------------------------
  c_Position_Employment_Contractor constant varchar2(1) := 'C';
  c_Position_Employment_Staff      constant varchar2(1) := 'S';
end Hrm_Pref;
/
create or replace package body Hrm_Pref is
end Hrm_Pref;
/
