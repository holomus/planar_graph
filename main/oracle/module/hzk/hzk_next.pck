create or replace package Hzk_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Command_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Migr_Track_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Attlog_Error_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Migr_Person_Id return number;
end Hzk_Next;
/
create or replace package body Hzk_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Command_Id return number is
  begin
    return Hzk_Commands_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Migr_Track_Id return number is
  begin
    return Hzk_Migr_Tracks_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Attlog_Error_Id return number is
  begin
    return Hzk_Attlog_Errors_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Migr_Person_Id return number is
  begin
    return Hzk_Migr_Tracks_Sq.Nextval;
  end;

end Hzk_Next;
/
