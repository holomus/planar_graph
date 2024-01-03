create or replace package Ui_Vhr678 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Book(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Archive(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap);
end Ui_Vhr678;
/
create or replace package body Ui_Vhr678 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hpr_credits',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('credit_id',
                   'employee_id',
                   'credit_amount',
                   'currency_id',
                   'cashbox_id',
                   'bank_account_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('credit_number', 'payment_type', 'status', 'note');
    q.Date_Field('credit_date',
                 'booked_date',
                 'begin_month',
                 'end_month',
                 'created_on',
                 'modified_on');
  
    q.Refer_Field('bank_account_name',
                  'bank_account_id',
                  'mkcs_bank_accounts',
                  'bank_account_id',
                  'name',
                  'select *
                     from mkcs_bank_accounts w
                    where w.company_id = :company_id');
    q.Refer_Field('cashbox_name',
                  'cashbox_id',
                  'mkcs_cashboxes',
                  'cashbox_id',
                  'name',
                  'select *
                     from mkcs_cashboxes w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from mhr_employees uf
                            where uf.company_id = :company_id
                              and uf.filial_id = :filial_id
                              and uf.employee_id = w.person_id)');
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies w
                    where w.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials uf
                            where uf.company_id = :company_id
                              and uf.filial_id = :filial_id
                              and uf.user_id = w.user_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials uf
                            where uf.company_id = :company_id
                              and uf.filial_id = :filial_id
                              and uf.user_id = w.user_id)');
  
    q.Map_Field('journal_code', 'hpr_util.jcode_credit($credit_id)');
  
    v_Matrix := Mpr_Util.Payment_Types;
    q.Option_Field('payment_type_name', 'payment_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpr_Util.Credit_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Ids Array_Number := Fazo.Sort(p.r_Array_Number('credit_id'));
  begin
    for i in 1 .. v_Credit_Ids.Count
    loop
      Hpr_Api.Credit_Delete(i_Company_Id => v_Company_Id,
                            i_Filial_Id  => v_Filial_Id,
                            i_Credit_Id  => v_Credit_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Draft(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Ids Array_Number := Fazo.Sort(p.r_Array_Number('credit_id'));
  begin
    for i in 1 .. v_Credit_Ids.Count
    loop
      Hpr_Api.Credit_Draft(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Credit_Id  => v_Credit_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Book(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Ids Array_Number := Fazo.Sort(p.r_Array_Number('credit_id'));
  begin
    for i in 1 .. v_Credit_Ids.Count
    loop
      Hpr_Api.Credit_Book(i_Company_Id => v_Company_Id,
                          i_Filial_Id  => v_Filial_Id,
                          i_Credit_Id  => v_Credit_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Complete(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Ids Array_Number := Fazo.Sort(p.r_Array_Number('credit_id'));
  begin
    for i in 1 .. v_Credit_Ids.Count
    loop
      Hpr_Api.Credit_Complete(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Id,
                              i_Credit_Id  => v_Credit_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Credit_Archive(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Ids Array_Number := Fazo.Sort(p.r_Array_Number('credit_id'));
  begin
    for i in 1 .. v_Credit_Ids.Count
    loop
      Hpr_Api.Credit_Archive(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Credit_Id  => v_Credit_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap) is
  begin
    Ui.Grant_Check('transactions');
  
    Ui_Anor186.Transactions(p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hpr_Credits
       set Company_Id      = null,
           Filial_Id       = null,
           Credit_Id       = null,
           Credit_Number   = null,
           Credit_Date     = null,
           Booked_Date     = null,
           Employee_Id     = null,
           Begin_Month     = null,
           End_Month       = null,
           Credit_Amount   = null,
           Currency_Id     = null,
           Payment_Type    = null,
           Cashbox_Id      = null,
           Bank_Account_Id = null,
           Status          = null,
           Note            = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mkcs_Cashboxes
       set Company_Id = null,
           Cashbox_Id = null,
           Filial_Id  = null,
           name       = null;
    update Mkcs_Bank_Accounts
       set Company_Id      = null,
           Bank_Account_Id = null,
           name            = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  end;
end Ui_Vhr678;
/
