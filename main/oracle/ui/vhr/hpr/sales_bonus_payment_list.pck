create or replace package Ui_Vhr483 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap);
end Ui_Vhr483;
/
create or replace package body Ui_Vhr483 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hpr_sales_bonus_payments',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('payment_id',
                   'division_id',
                   'job_id',
                   'cashbox_id',
                   'bank_account_id',
                   'amount',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('payment_number',
                     'payment_name',
                     'bonus_type',
                     'payment_type',
                     'posted',
                     'barcode',
                     'note');
    q.Date_Field('payment_date', 'begin_date', 'end_date', 'created_on', 'modified_on');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('cashbox_name',
                  'cashbox_id',
                  'mkcs_cashboxes',
                  'cashbox_id',
                  'name',
                  'select *
                     from mkcs_cashboxes s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('bank_account_name',
                  'bank_account_id',
                  'mkcs_bank_accounts',
                  'bank_account_id',
                  'name',
                  'select *
                     from mkcs_bank_accounts s
                    where s.company_id = :company_id
                      and s.person_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id');
  
    v_Matrix := Hrm_Util.Bonus_Types;
    q.Option_Field('bonus_type_name', 'bonus_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Mpr_Util.Payment_Types;
    q.Option_Field('payment_type_name', 'payment_type', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Payment_Ids Array_Number := Fazo.Sort(p.r_Array_Number('payment_id'));
  begin
    for i in 1 .. v_Payment_Ids.Count
    loop
      Hpr_Api.Sales_Bonus_Payment_Delete(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Payment_Id => v_Payment_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Post(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Payment_Ids Array_Number := Fazo.Sort(p.r_Array_Number('payment_id'));
  begin
    for i in 1 .. v_Payment_Ids.Count
    loop
      Hpr_Api.Sales_Bonus_Payment_Post(i_Company_Id => v_Company_Id,
                                       i_Filial_Id  => v_Filial_Id,
                                       i_Payment_Id => v_Payment_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Unpost(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Payment_Ids Array_Number := Fazo.Sort(p.r_Array_Number('payment_id'));
  begin
    for i in 1 .. v_Payment_Ids.Count
    loop
      Hpr_Api.Sales_Bonus_Payment_Unpost(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Payment_Id => v_Payment_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap) is
  begin
    Ui.Grant_Check('transactions');
  
    Uit_Mkr.Journal_Transactions_Run(i_Company_Id   => Ui.Company_Id,
                                     i_Filial_Id    => Ui.Filial_Id,
                                     i_Journal_Code => Hpr_Util.Jcode_Sales_Bonus_Payment(p.r_Number('payment_id')),
                                     i_Report_Type  => p.r_Varchar2('rt'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hpr_Sales_Bonus_Payments
       set Company_Id      = null,
           Filial_Id       = null,
           Payment_Id      = null,
           Payment_Number  = null,
           Payment_Date    = null,
           Payment_Name    = null,
           Begin_Date      = null,
           End_Date        = null,
           Division_Id     = null,
           Bonus_Type      = null,
           Payment_Type    = null,
           Cashbox_Id      = null,
           Bank_Account_Id = null,
           Amount          = null,
           Posted          = null,
           Barcode         = null,
           Note            = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Mkcs_Cashboxes
       set Company_Id = null,
           Filial_Id  = null,
           Cashbox_Id = null,
           name       = null;
    update Mkcs_Bank_Accounts
       set Company_Id      = null,
           Bank_Account_Id = null,
           name            = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr483;
/
