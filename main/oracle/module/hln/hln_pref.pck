create or replace package Hln_Pref is
  ----------------------------------------------------------------------------------------------------
  type Question_Option_Rt is record(
    Question_Option_Id number,
    name               varchar2(1000 char),
    File_Sha           varchar2(64),
    Is_Correct         varchar2(1),
    Order_No           number(2));
  type Question_Option_Nt is table of Question_Option_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Question_Group_Rt is record(
    Question_Group_Id number,
    Question_Type_Id  number);
  type Question_Group_Nt is table of Question_Group_Rt;
  ----------------------------------------------------------------------------------------------------
  type Question_Rt is record(
    Company_Id   number,
    Filial_Id    number,
    Question_Id  number,
    name         varchar2(2000 char),
    Answer_Type  varchar2(1),
    Code         varchar2(50 char),
    State        varchar2(1),
    Writing_Hint varchar2(500 char),
    Files        Array_Varchar2,
    Options      Question_Option_Nt,
    Group_Binds  Question_Group_Nt);
  ----------------------------------------------------------------------------------------------------  
  type Exam_Question_Rt is record(
    Question_Id number,
    Order_No    number);
  type Exam_Question_Nt is table of Exam_Question_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Exam_Pattern_Rt is record(
    Pattern_Id               number,
    Quantity                 number,
    Has_Writing_Question     varchar2(1),
    Max_Cnt_Writing_Question number,
    Order_No                 number,
    Question_Types           Question_Group_Nt);
  type Exam_Pattern_Nt is table of Exam_Pattern_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Exam_Rt is record(
    Company_Id          number,
    Filial_Id           number,
    Exam_Id             number,
    name                varchar2(100 char),
    Pick_Kind           varchar2(1),
    Duration            number(5),
    Passing_Score       number(4),
    Passing_Percentage  number(3),
    Question_Count      number(4),
    Randomize_Questions varchar2(1),
    Randomize_Options   varchar2(1),
    For_Recruitment     varchar2(1),
    State               varchar2(1),
    Exam_Question       Exam_Question_Nt,
    Exam_Pattern        Exam_Pattern_Nt);
  ----------------------------------------------------------------------------------------------------
  type Testing_Rt is record(
    Testing_Id number,
    Person_Id  number,
    Exam_Id    number);
  type Testing_Nt is table of Testing_Rt;
  ----------------------------------------------------------------------------------------------------
  type Attestation_Rt is record(
    Company_Id              number,
    Filial_Id               number,
    Attestation_Id          number,
    Attestation_Number      varchar2(50),
    name                    varchar2(100 char),
    Attestation_Date        date,
    Begin_Time_Period_Begin date,
    Begin_Time_Period_End   date,
    Examiner_Id             number,
    Note                    varchar2(300 char),
    Testings                Testing_Nt);
  ----------------------------------------------------------------------------------------------------
  type Training_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Training_Id      number,
    Training_Number  varchar2(50),
    Begin_Date       date,
    Mentor_Id        number,
    Subject_Group_Id number,
    Subject_Ids      Array_Number,
    Address          varchar2(300 char),
    Persons          Array_Number);
  ----------------------------------------------------------------------------------------------------  
  type Training_Subject_Group_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Subject_Group_Id number,
    name             varchar(100 char),
    Code             varchar2(50),
    State            varchar2(1),
    Subject_Ids      Array_Number);
  ----------------------------------------------------------------------------------------------------  
  -- exam pick kinds
  ----------------------------------------------------------------------------------------------------  
  c_Exam_Pick_Kind_Manual constant varchar2(1) := 'M';
  c_Exam_Pick_Kind_Auto   constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- answer types
  ----------------------------------------------------------------------------------------------------
  c_Answer_Type_Single   varchar2(1) := 'S';
  c_Answer_Type_Multiple varchar2(1) := 'M';
  c_Answer_Type_Writing  varchar2(1) := 'W';
  ----------------------------------------------------------------------------------------------------  
  -- testing statuses
  ----------------------------------------------------------------------------------------------------
  c_Testing_Status_New      varchar2(1) := 'N';
  c_Testing_Status_Executed varchar2(1) := 'E';
  c_Testing_Status_Paused   varchar2(1) := 'P';
  c_Testing_Status_Checking varchar2(1) := 'C';
  c_Testing_Status_Finished varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------
  -- attestation statuses
  ----------------------------------------------------------------------------------------------------
  c_Attestation_Status_New        varchar2(1) := 'N';
  c_Attestation_Status_Processing varchar2(1) := 'P';
  c_Attestation_Status_Finished   varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------
  -- training statuses
  ----------------------------------------------------------------------------------------------------
  c_Training_Status_New      varchar2(1) := 'N';
  c_Training_Status_Executed varchar2(1) := 'E';
  c_Training_Status_Finished varchar2(1) := 'F';
  ----------------------------------------------------------------------------------------------------  
  -- passed indeterminate
  ----------------------------------------------------------------------------------------------------  
  c_Passed_Indeterminate varchar2(1) := 'I';
  ----------------------------------------------------------------------------------------------------
  -- action kinds
  ----------------------------------------------------------------------------------------------------
  c_Action_Kind_Testing     constant varchar2(1) := 'T'; -- (T)esting
  c_Action_Kind_Attestation constant varchar2(1) := 'A'; -- (A)ttestation
  c_Action_Kind_Training    constant varchar2(1) := 'R'; -- t(R)aining
  ----------------------------------------------------------------------------------------------------
  -- person kind
  ----------------------------------------------------------------------------------------------------
  c_Person_Kind_Mentor      constant varchar2(1) := 'M'; -- (M)entor
  c_Person_Kind_Examiner    constant varchar2(1) := 'E'; -- (E)xaminer
  c_Person_Kind_Participant constant varchar2(1) := 'P'; -- (P)articipant
  ----------------------------------------------------------------------------------------------------
  -- testing period change setting
  ----------------------------------------------------------------------------------------------------  
  c_Testing_Period_Change_Setting constant varchar2(50) := 'VHR:HLN:TESTING_PERIOD_CHANGE';
end Hln_Pref;
/
create or replace package body Hln_Pref is
end Hln_Pref;
/
