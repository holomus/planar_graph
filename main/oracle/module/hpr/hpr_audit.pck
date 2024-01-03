create or replace package Hpr_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Audit_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Credit_Audit_Stop(i_Company_Id number);
end Hpr_Audit;
/
create or replace package body Hpr_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Audit_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPR_CREDITS',
                           i_Column_List => 'CREDIT_ID,CREDIT_NUMBER,CREDIT_DATE,BOOKED_DATE,EMPLOYEE_ID,BEGIN_MONTH,END_MONTH,CREDIT_AMOUNT,CURRENCY_ID,PAYMENT_TYPE,CASHBOX_ID,BANK_ACCOUNT_ID,STATUS,NOTE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPR_CREDITS_I1',
                              i_Table_Name  => 'HPR_CREDITS',
                              i_Column_List => 'T_COMPANY_ID,CREDIT_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Credit_Audit_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPR_CREDITS');
  end;

end Hpr_Audit;
/
