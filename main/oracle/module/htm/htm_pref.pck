create or replace package Htm_Pref is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ---------------------------------------------------------------------------------------------------- 
  type Experience_Period_Attempt_Rt is record(
    Period            number,
    Nearest           number,
    Penalty_Period    number,
    Exam_Id           number,
    Success_Score     number,
    Ignore_Score      number,
    Recommend_Failure varchar2(1),
    Indicators        Array_Number,
    Subjects          Array_Number);
  type Experience_Period_Attempt_Nt is table of Experience_Period_Attempt_Rt;
  ---------------------------------------------------------------------------------------------------- 
  type Experience_Period_Rt is record(
    From_Rank_Id number,
    To_Rank_Id   number,
    Order_No     number,
    Attempts     Experience_Period_Attempt_Nt);
  type Experience_Period_Nt is table of Experience_Period_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Experience_Rt is record(
    Company_Id    number,
    Filial_Id     number,
    Experience_Id number,
    name          varchar2(100 char),
    Order_No      number,
    State         varchar2(1),
    Code          varchar2(50),
    Periods       Experience_Period_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  type Recommended_Rank_Training_Rt is record(
    Staff_Id    number,
    Exam_Id     number,
    Subject_Ids Array_Number);
  type Recommended_Rank_Training_Nt is table of Recommended_Rank_Training_Rt;
  ----------------------------------------------------------------------------------------------------
  type Recommended_Rank_Status_Rt is record(
    Staff_Id         number,
    Increment_Status varchar2(1),
    Indicators       Href_Pref.Indicator_Nt);
  type Recommended_Rank_Status_Nt is table of Recommended_Rank_Status_Rt;
  ---------------------------------------------------------------------------------------------------- 
  type Recommended_Rank_Staff_Rt is record(
    Staff_Id           number,
    Robot_Id           number,
    From_Rank_Id       number,
    Last_Change_Date   date,
    To_Rank_Id         number,
    New_Change_Date    date,
    Attempt_No         number,
    Experience_Id      number,
    Period             number,
    Nearest            number,
    Old_Penalty_Period number,
    Note               varchar2(300 char));
  type Recommended_Rank_Staff_Nt is table of Recommended_Rank_Staff_Rt;
  ----------------------------------------------------------------------------------------------------
  type Recommended_Rank_Document_Rt is record(
    Company_Id      number,
    Filial_Id       number,
    Document_Id     number,
    Document_Number varchar2(50 char),
    Document_Date   date,
    Division_Id     number,
    Note            Htm_Recommended_Rank_Documents.Note%type,
    Staffs          Recommended_Rank_Staff_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document Status
  ----------------------------------------------------------------------------------------------------
  c_Document_Status_New          constant varchar2(1) := 'N';
  c_Document_Status_Set_Training constant varchar2(1) := 'S';
  c_Document_Status_Training     constant varchar2(1) := 'T';
  c_Document_Status_Waiting      constant varchar2(1) := 'W';
  c_Document_Status_Approved     constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- Recommend Rank Staff Increment Status
  ----------------------------------------------------------------------------------------------------
  c_Increment_Status_Success constant varchar2(1) := 'S';
  c_Increment_Status_Failure constant varchar2(1) := 'F';
  c_Increment_Status_Ignored constant varchar2(1) := 'I';
end Htm_Pref;
/
create or replace package body Htm_Pref is

end Htm_Pref;
/
