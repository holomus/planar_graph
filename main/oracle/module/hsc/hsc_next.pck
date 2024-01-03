create or replace package Hsc_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Process_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Process_Action_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Driver_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Area_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Object_Norm_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Job_Norm_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Job_Round_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Driver_Fact_Id return number;
end Hsc_Next;
/
create or replace package body Hsc_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Process_Id return number is
  begin
    return Hsc_Processes_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Process_Action_Id return number is
  begin
    return Hsc_Process_Actions_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Driver_Id return number is
  begin
    return Hsc_Drivers_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Area_Id return number is
  begin
    return Hsc_Areas_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Object_Norm_Id return number is
  begin
    return Hsc_Object_Norms_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Job_Norm_Id return number is
  begin
    return Hsc_Job_Norms_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Job_Round_Id return number is
  begin
    return Hsc_Job_Rounds_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Driver_Fact_Id return number is
  begin
    return Hsc_Driver_Facts_Sq.Nextval;
  end;

end Hsc_Next;
/
