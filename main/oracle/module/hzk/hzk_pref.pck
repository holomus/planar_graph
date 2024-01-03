create or replace package Hzk_Pref is
  ----------------------------------------------------------------------------------------------------  
  type Zktime_Rt is record(
    Company_Id      number,
    Device_Id       number,
    Serial_Number   Htt_Devices.Serial_Number%type,
    name            Htt_Devices.Name%type,
    Model_Id        number,
    Location_Id     number,
    Autogen_Inputs  varchar2(1),
    Autogen_Outputs varchar2(1),
    Ignore_Tracks   varchar2(1),
    Ignore_Images   varchar2(1),
    Restricted_Type varchar2(1),
    State           varchar2(2));
  ----------------------------------------------------------------------------------------------------
  type Fprint_Rt is record(
    Finger_No number,
    Tmp       Hzk_Person_Fprints.Tmp%type);
  type Fprint_Nt is table of Fprint_Rt;
  ----------------------------------------------------------------------------------------------------
  type Person_Fprints_Rt is record(
    Company_Id number,
    Person_Id  number,
    Fprints    Fprint_Nt);
  ----------------------------------------------------------------------------------------------------
  -- command state
  ----------------------------------------------------------------------------------------------------
  c_Cs_New      constant varchar2(1) := 'N';
  c_Cs_Sent     constant varchar2(1) := 'S';
  c_Cs_Complete constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  -- hand side
  ----------------------------------------------------------------------------------------------------
  c_Hand_Side_Left  constant varchar2(1) := 'L';
  c_Hand_Side_Right constant varchar2(1) := 'R';
  ----------------------------------------------------------------------------------------------------
  -- attlog error status
  ---------------------------------------------------------------------------------------------------- 
  c_Attlog_Error_Status_New  constant varchar2(1) := 'N';
  c_Attlog_Error_Status_Done constant varchar2(1) := 'D';
end Hzk_Pref;
/
create or replace package body Hzk_Pref is
end Hzk_Pref;
/
