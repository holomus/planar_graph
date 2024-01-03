create or replace package Hac_Next is
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Server_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Device_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Name_Id return number;
end Hac_Next;
/
create or replace package body Hac_Next is
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id return number is
  begin
    return Hac_Device_Types_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Server_Id return number is
  begin
    return Hac_Servers_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Id return number is
  begin
    return Hac_Devices_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Name_Id return number is
  begin
    return Hac_Dss_Names_Sq.Nextval;
  end;

end Hac_Next;
/
