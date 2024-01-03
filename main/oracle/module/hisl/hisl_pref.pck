create or replace package Hisl_Pref is
  ----------------------------------------------------------------------------------------------------
  c_User_Create_Uri        constant varchar2(200 char) := '/user';
  c_User_Update_Uri        constant varchar2(200 char) := '/user/{user_code}';
  c_User_Update_Status_Uri constant varchar2(200 char) := '/user/{user_code}/status';
  ----------------------------------------------------------------------------------------------------
  c_User_Status_Active  constant varchar2(1) := '1';
  c_User_Status_Passive constant varchar2(1) := '3';
  ----------------------------------------------------------------------------------------------------
  c_User_Role_Learner constant varchar2(20) := 'learner';
  ----------------------------------------------------------------------------------------------------
  c_Request_Status_Success constant varchar2(1) := 'S';
  c_Request_Status_Error   constant varchar2(1) := 'E';
end Hisl_Pref;
/
create or replace package body Hisl_Pref is
end Hisl_Pref;
/
