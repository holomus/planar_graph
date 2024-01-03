create or replace package Htt_Next is
  ----------------------------------------------------------------------------------------------------
  Function Calendar_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Schedule_Template_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Time_Kind_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Location_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Location_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Server_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Terminal_Model_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Device_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Track_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Acms_Track_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Acms_Command_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Gps_Track_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Timesheet_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Timesheet_Interval_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Request_Kind_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Request_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Change_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Qr_Code_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Registry_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Unit_Id return number;
end Htt_Next;
/
create or replace package body Htt_Next is
  ---------------------------------------------------------------------------------------------------- 
  Function Calendar_Id return number is
  begin
    return Htt_Calendars_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Id return number is
  begin
    return Htt_Schedules_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Template_Id return number is
  begin
    return Htt_Schedule_Templates_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Time_Kind_Id return number is
  begin
    return Htt_Time_Kinds_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Location_Type_Id return number is
  begin
    return Htt_Location_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Id return number is
  begin
    return Htt_Locations_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Server_Id return number is
  begin
    return Htt_Acms_Servers_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Device_Type_Id return number is
  begin
    return Htt_Device_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Terminal_Model_Id return number is
  begin
    return Htt_Terminal_Models_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Device_Id return number is
  begin
    return Htt_Devices_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Track_Id return number is
  begin
    return Htt_Tracks_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Acms_Track_Id return number is
  begin
    return Htt_Acms_Tracks_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Acms_Command_Id return number is
  begin
    return Htt_Acms_Commands_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Gps_Track_Id return number is
  begin
    return Htt_Gps_Tracks_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Timesheet_Id return number is
  begin
    return Htt_Timesheets_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timesheet_Interval_Id return number is
  begin
    return Htt_Timesheet_Intervals_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Kind_Id return number is
  begin
    return Htt_Request_Kinds_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Id return number is
  begin
    return Htt_Requests_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Id return number is
  begin
    return Htt_Plan_Changes_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Qr_Code_Id return number is
  begin
    return Htt_Location_Qr_Codes_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Registry_Id return number is
  begin
    return Htt_Schedule_Registries_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Unit_Id return number is
  begin
    return Htt_Registry_Units_Sq.Nextval;
  end;

end Htt_Next;
/
