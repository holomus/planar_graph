create or replace package Hpd_Next is
  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Journal_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Page_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Timeoff_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Overtime_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Lock_Interval_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Trans_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Cv_Contract_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Cv_Contract_Item_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Application_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Application_Unit_Id return number;
end Hpd_Next;
/
create or replace package body Hpd_Next is
  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Id return number is
  begin
    return Hpd_Journal_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Id return number is
  begin
    return Hpd_Journals_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Page_Id return number is
  begin
    return Hpd_Journal_Pages_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timeoff_Id return number is
  begin
    return Hpd_Journal_Timeoffs_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Overtime_Id return number is
  begin
    return Hpd_Journal_Overtimes_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Lock_Interval_Id return number is
  begin
    return Hpd_Lock_Intervals_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trans_Id return number is
  begin
    return Hpd_Transactions_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Cv_Contract_Id return number is
  begin
    return Hpd_Cv_Contracts_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Cv_Contract_Item_Id return number is
  begin
    return Hpd_Cv_Contract_Items_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Id return number is
  begin
    return Hpd_Application_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Id return number is
  begin
    return Hpd_Applications_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Unit_Id return number is
  begin
    return Hpd_Application_Units_Sq.Nextval;
  end;

end Hpd_Next;
/
