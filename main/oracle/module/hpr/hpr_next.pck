create or replace package Hpr_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Timebook_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Charge_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Oper_Group_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Book_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Penalty_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Wage_Sheet_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Sheet_Part_Id return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Cv_Contract_Fact_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Cv_Contract_Fact_Item_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Sales_Bonus_Payment_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Sales_Bonus_Payment_Operation_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Charge_Document_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Charge_Document_Operation_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Nighttime_Policy_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Credit_Id return number;
end Hpr_Next;
/
create or replace package body Hpr_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Timebook_Id return number is
  begin
    return Hpr_Timebooks_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Charge_Id return number is
  begin
    return Hpr_Charges_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Oper_Group_Id return number is
  begin
    return Hpr_Oper_Groups_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Book_Type_Id return number is
  begin
    return Hpr_Book_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Penalty_Id return number is
  begin
    return Hpr_Penalties_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Sheet_Id return number is
  begin
    return Hpr_Wage_Sheets_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Sheet_Part_Id return number is
  begin
    return Hpr_Sheet_Parts_Sq.Nextval;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Cv_Contract_Fact_Id return number is
  begin
    return Hpr_Cv_Contract_Facts_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Cv_Contract_Fact_Item_Id return number is
  begin
    return Hpr_Cv_Contract_Fact_Items_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Sales_Bonus_Payment_Id return number is
  begin
    return Hpr_Sales_Bonus_Payments_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Sales_Bonus_Payment_Operation_Id return number is
  begin
    return Hpr_Sales_Bonus_Payment_Operations_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Charge_Document_Id return number is
  begin
    return Hpr_Charge_Documents_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Charge_Document_Operation_Id return number is
  begin
    return Hpr_Charge_Document_Operations_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nighttime_Policy_Id return number is
  begin
    return Hpr_Nighttime_Policies_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Credit_Id return number is
  begin
    return Hpr_Credits_Sq.Nextval;
  end;

end Hpr_Next;
/
