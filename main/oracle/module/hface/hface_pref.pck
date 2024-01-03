create or replace package Hface_Pref is
  ----------------------------------------------------------------------------------------------------
  c_Actual_Threshold       constant number := 5;
  c_Euclidian_Threshold    constant number := 10;
  c_Big_Euclidian_Distance constant number := 100;
  ----------------------------------------------------------------------------------------------------
  c_Recognition_Runtime_Service_Name constant varchar2(100) := 'com.verifix.vhr.facerecognition.RecognitionRuntimeService';
  ----------------------------------------------------------------------------------------------------
  c_Rs_Action_Add_Job          constant varchar2(50) := 'ADD_JOB';
  c_Rs_Action_Check_Job        constant varchar2(50) := 'CHECK_JOB';
  c_Rs_Action_Calculate_Vector constant varchar2(50) := 'CALCULATE_VECTOR';
  ----------------------------------------------------------------------------------------------------
  c_Recognition_Route_Embed constant varchar2(50) := '/embed';
  ----------------------------------------------------------------------------------------------------
  c_Recognition_Settings_Code constant varchar2(1) := 'U';
  ----------------------------------------------------------------------------------------------------
  c_Duplicate_Prevention constant varchar2(50) := 'VHR:DUPLICATE_PREVENTION';
  ----------------------------------------------------------------------------------------------------
  -- external error codes
  ----------------------------------------------------------------------------------------------------
  c_Df_No_Face_Found_Exception constant varchar2(10) := 'DF0001';
  c_Cf_Connection_Failure      constant varchar2(10) := 'CF0001';
end Hface_Pref;
/
create or replace package body Hface_Pref is
end Hface_Pref;
/
