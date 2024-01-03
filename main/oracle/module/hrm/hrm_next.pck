create or replace package Hrm_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Wage_Scale_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Register_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Job_Template_Id return number;
end Hrm_Next;
/
create or replace package body Hrm_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Wage_Scale_Id return number is
  begin
    return Hrm_Wage_Scales_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Register_Id return number is
  begin
    return Hrm_Wage_Scale_Registers_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Job_Template_Id return number is
  begin
    return Hrm_Job_Templates_Sq.Nextval;
  end;

end Hrm_Next;
/
