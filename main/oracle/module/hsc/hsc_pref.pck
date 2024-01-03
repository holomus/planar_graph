create or replace package Hsc_Pref is
  ----------------------------------------------------------------------------------------------------
  -- setting
  ----------------------------------------------------------------------------------------------------
  type Setting_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Object_Group_Ids Array_Number);
  ----------------------------------------------------------------------------------------------------
  -- object
  ----------------------------------------------------------------------------------------------------
  type Object_Norm_Action_Rt is record(
    Day_No    number,
    Frequency number);
  ----------------------------------------------------------------------------------------------------
  type Object_Norm_Action_Nt is table of Object_Norm_Action_Rt;
  ----------------------------------------------------------------------------------------------------
  type Object_Norm_Rt is record(
    Company_Id    number,
    Filial_Id     number,
    Object_Id     number,
    Norm_Id       number,
    Process_Id    number,
    Action_Id     number,
    Driver_Id     number,
    Area_Id       number,
    Division_Id   number,
    Job_Id        number,
    Time_Value    number,
    Action_Period varchar2(1),
    Actions       Object_Norm_Action_Nt);
  ----------------------------------------------------------------------------------------------------
  type Object_Norm_Nt is table of Object_Norm_Rt;
  ----------------------------------------------------------------------------------------------------
  type Object_Rt is record(
    Company_Id number,
    Filial_Id  number,
    Object_Id  number,
    Note       varchar2(300 char),
    Norms      Object_Norm_Nt);
  ----------------------------------------------------------------------------------------------------
  -- pcode driver
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Driver_Constant constant varchar2(10) := 'VHR:1';
  ----------------------------------------------------------------------------------------------------
  -- action period
  ----------------------------------------------------------------------------------------------------
  c_Action_Period_Week  constant varchar2(1) := 'W';
  c_Action_Period_Month constant varchar2(1) := 'M';
  ----------------------------------------------------------------------------------------------------
  -- driver fact types
  ----------------------------------------------------------------------------------------------------
  c_Fact_Type_Weekly_Predict    constant varchar2(1) := 'W';
  c_Fact_Type_Montly_Predict    constant varchar2(1) := 'M';
  c_Fact_Type_Quarterly_Predict constant varchar2(1) := 'Q';
  c_Fact_Type_Yearly_Predict    constant varchar2(1) := 'Y';
  c_Fact_Type_Actual            constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- fact import settings
  ---------------------------------------------------------------------------------------------------- 
  c_Import_Setting_Starting_Row  constant varchar2(50) := 'HSC:STARTING_ROW';
  c_Import_Setting_Date_Column   constant varchar2(50) := 'HSC:DATE_COLUMN';
  c_Import_Setting_Object_Column constant varchar2(50) := 'HSC:OBJECT_COLUMN';
  ----------------------------------------------------------------------------------------------------
  -- fact import defaults
  ---------------------------------------------------------------------------------------------------- 
  c_Default_Starting_Row  constant number := 3;
  c_Default_Date_Column   constant number := 2;
  c_Default_Object_Column constant number := 1;
  ----------------------------------------------------------------------------------------------------
  c_Predict_Server_Url  constant varchar2(50) := 'http://127.0.0.1:5000';
  c_Predict_Api_Uri     constant varchar2(50) := '/predict';
  c_Default_Http_Method constant varchar2(50) := 'POST';
  ----------------------------------------------------------------------------------------------------
  c_Ftp_Action_List_Files constant varchar2(50) := 'LIST_FILES';
  c_Ftp_Action_Load_Files constant varchar2(50) := 'LOAD_FILES';
end Hsc_Pref;
/
create or replace package body Hsc_Pref is
end Hsc_Pref;
/
