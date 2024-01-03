create or replace package Ui_Vhr560 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Currencies return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
end Ui_Vhr560;
/
create or replace package body Ui_Vhr560 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_coa', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('coa_id');
    q.Varchar2_Field('gen_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Currencies return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_currencies', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('currency_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Setting Mpr_Settings%rowtype;
  
    result Hashmap;
    --------------------------------------------------
    Procedure Put_Coa_Default
    (
      i_Key  varchar2,
      i_Code varchar2
    ) is
      r_Coa_Default Mkr_Coa_Defaults%rowtype;
      r_Coa         Mk_Coa%rowtype;
    begin
      r_Coa_Default := z_Mkr_Coa_Defaults.Take(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Code       => i_Code);
    
      r_Coa := z_Mk_Coa.Take(i_Company_Id => r_Coa_Default.Company_Id,
                             i_Coa_Id     => r_Coa_Default.Coa_Id);
    
      Result.Put_All(Fazo.Zip_Map(i_Key || '_coa_id',
                                  r_Coa.Coa_Id,
                                  i_Key || '_coa_name',
                                  r_Coa.Gen_Name));
    end;
  begin
    r_Setting := z_Mpr_Settings.Take(i_Company_Id => Ui.Company_Id, --
                                     i_Filial_Id  => Ui.Filial_Id);
  
    result := z_Mpr_Settings.To_Map(r_Setting,
                                    z.Income_Tax_Exists,
                                    z.Income_Tax_Rate,
                                    z.Pension_Payment_Exists,
                                    z.Pension_Payment_Rate,
                                    z.Social_Payment_Exists,
                                    z.Social_Payment_Rate);
  
    Put_Coa_Default('accrual', Mkr_Pref.c_Pref_Coa_Payroll_Accrual);
    Put_Coa_Default('deduction', Mkr_Pref.c_Pref_Coa_Payroll_Deduction);
    Put_Coa_Default('income_tax', Mkr_Pref.c_Pref_Coa_Payroll_Income_Tax);
    Put_Coa_Default('pension_payment', Mkr_Pref.c_Pref_Coa_Payroll_Pension_Payment);
    Put_Coa_Default('social_payment', Mkr_Pref.c_Pref_Coa_Payroll_Social_Payment);
    Put_Coa_Default('advance', Mkr_Pref.c_Pref_Coa_Payroll_Advance);
    Put_Coa_Default('credit', Hpr_Pref.c_Pref_Coa_Employee_Credit);
  
    Result.Put('currencies', Uit_Hpr.Load_Allowed_Currencies);
    Result.Put('allow_use_subfilial',
               Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Setting Mpr_Settings%rowtype;
  
    ----------------------------------------------------------------------------------------------------
    Procedure Save_Coa_Default
    (
      i_Code   varchar2,
      i_Coa_Id number := null
    ) is
    begin
      if i_Coa_Id is not null then
        Mkr_Api.Coa_Default_Save(i_Company_Id => r_Setting.Company_Id,
                                 i_Filial_Id  => r_Setting.Filial_Id,
                                 i_Code       => i_Code,
                                 i_Coa_Id     => i_Coa_Id);
      else
        Mkr_Api.Coa_Default_Delete(i_Company_Id => r_Setting.Company_Id,
                                   i_Filial_Id  => r_Setting.Filial_Id,
                                   i_Code       => i_Code);
      end if;
    end;
  begin
    if not z_Mpr_Settings.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     o_Row        => r_Setting) then
      r_Setting.Company_Id := Ui.Company_Id;
      r_Setting.Filial_Id  := Ui.Filial_Id;
    end if;
  
    z_Mpr_Settings.To_Row(r_Setting,
                          p,
                          z.Income_Tax_Exists,
                          z.Income_Tax_Rate,
                          z.Pension_Payment_Exists,
                          z.Pension_Payment_Rate,
                          z.Social_Payment_Exists,
                          z.Social_Payment_Rate);
  
    Mpr_Api.Setting_Save(r_Setting);
  
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Accrual, p.o_Number('accrual_coa_id'));
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Deduction, p.o_Number('deduction_coa_id'));
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Income_Tax, p.o_Number('income_tax_coa_id'));
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Pension_Payment,
                     p.o_Number('pension_payment_coa_id'));
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Social_Payment,
                     p.o_Number('social_payment_coa_id'));
    Save_Coa_Default(Mkr_Pref.c_Pref_Coa_Payroll_Advance, p.o_Number('advance_coa_id'));
    Save_Coa_Default(Hpr_Pref.c_Pref_Coa_Employee_Credit, p.o_Number('credit_coa_id'));
  
    Hpr_Api.Currency_Settings_Save(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Currency_Ids => p.o_Array_Number('currency_ids'));
    Hpr_Api.Use_Subfilial_Setting_Save(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Setting    => p.o_Varchar2('allow_use_subfilial'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           Gen_Name   = null;
  
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null,
           State       = null;
  end;

end Ui_Vhr560;
/
