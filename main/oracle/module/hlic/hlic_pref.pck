create or replace package Hlic_Pref is
  ----------------------------------------------------------------------------------------------------
  c_Interval_Status_Continue constant varchar2(1) := 'C';
  c_Interval_Status_Stop     constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  c_License_Code_Hrm_Full    constant varchar2(20) := 'VHR:HRM_FULL';
  c_License_Code_Hrm_Limited constant varchar2(20) := 'VHR:HRM_LIMITED';
  c_License_Code_Hrm_Base    constant varchar2(20) := 'VHR:HRM_BASE';
  ----------------------------------------------------------------------------------------------------
  c_Count_Days_Need_To_Generate constant number := 70;
  ----------------------------------------------------------------------------------------------------
  c_License_Warning_Soft_Limit constant number := 10;
  c_License_Warning_Hard_Limit constant number := 3;
end Hlic_Pref;
/
create or replace package body Hlic_Pref is

end Hlic_Pref;
/
