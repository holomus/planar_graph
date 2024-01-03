create or replace package Ui_Vhr592 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Payment_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Book(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Archive(p Hashmap);
end Ui_Vhr592;
/
create or replace package body Ui_Vhr592 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR592:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data Mpr_Payments%rowtype;
    result Hashmap := Hashmap;
  begin
    r_Data := z_Mpr_Payments.Load(i_Company_Id => Ui.Company_Id,
                                  i_Payment_Id => p.r_Number('payment_id'));
  
    result := z_Mpr_Payments.To_Map(r_Data,
                                    z.Payment_Id,
                                    z.Payment_Kind,
                                    z.Status,
                                    z.Payment_Number,
                                    z.Payment_Date,
                                    z.Booked_Date,
                                    z.Payment_Type,
                                    z.Amount,
                                    z.Amount_Base,
                                    z.Paid_Amount,
                                    z.Paid_Amount_Base,
                                    z.Unpaid_Amount,
                                    z.Unpaid_Amount_Base,
                                    z.Note,
                                    z.Created_On,
                                    z.Modified_On);
  
    Result.Put('payment_kind_name', Mpr_Util.t_Payment_Kind(r_Data.Payment_Kind));
    Result.Put('status_name', Mpr_Util.t_Payment_Status(r_Data.Status));
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Data.Division_Id).Name);
    Result.Put('currency_name',
               z_Mk_Currencies.Take(i_Company_Id => Ui.Company_Id, i_Currency_Id => r_Data.Currency_Id).Name);
    Result.Put('payment_type_name', Mpr_Util.t_Payment_Type(r_Data.Payment_Type));
  
    Result.Put('cashbox_name',
               z_Mkcs_Cashboxes.Take(i_Company_Id => Ui.Company_Id, i_Cashbox_Id => r_Data.Cashbox_Id).Name);
    Result.Put('bank_account_name',
               z_Mkcs_Bank_Accounts.Take(i_Company_Id => Ui.Company_Id, i_Bank_Account_Id => r_Data.Bank_Account_Id).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
    Result.Put('references',
               Fazo.Zip_Map('pk_payroll',
                            Mpr_Pref.c_Pk_Payroll,
                            'pk_advance',
                            Mpr_Pref.c_Pk_Advance));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            pd.iapa,
                            pd.npin,
                            (select mr.tin
                               from mr_person_details mr 
                              where mr.company_id = q.company_id
                                and mr.person_id = q.employee_id) tin
                       from mpr_payment_employees q 
                       left join href_person_details pd
                         on pd.company_id = q.company_id
                        and pd.person_id = q.employee_id
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.payment_id = :payment_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'payment_id',
                                 p.r_Number('payment_id')));
  
    q.Number_Field('employee_id', 'bank_account_id', 'pay_amount', 'pay_amount_base', 'order_no');
    q.Varchar2_Field('paid', 'iapa', 'npin', 'tin', 'note');
    q.Date_Field('paid_date');
  
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1
                                    from mrf_persons t
                                   where t.company_id = w.company_id
                                     and t.filial_id = :filial_id
                                     and t.person_id = w.person_id)');
  
    q.Option_Field('paid_name',
                   'paid',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Map_Field('bank_account_name',
                'select q.name
                   from mkcs_bank_accounts q
                  where q.company_id = :company_id
                    and q.bank_account_id = $bank_account_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Payment_Audits(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select * 
                       from x_mpr_payments t
                      where t.t_company_id = :company_id
                        and t.payment_id = :payment_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'payment_id',
                                 p.r_Number('payment_id'),
                                 'user_id',
                                 Md_Pref.User_System(Ui.Company_Id)));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'payment_id',
                   'division_id',
                   'currency_id',
                   'cashbox_id',
                   'bank_account_id');
    q.Number_Field('amount',
                   'amount_base',
                   'paid_amount',
                   'paid_amount_base',
                   'unpaid_amount',
                   'unpaid_amount_base');
    q.Varchar2_Field('t_event',
                     'payment_kind',
                     'status',
                     'payment_number',
                     'payment_type',
                     'note',
                     'barcode');
    q.Date_Field('t_timestamp', 't_date', 'payment_date', 'booked_date');
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and t.user_id <> :user_id
                      and exists (select *
                             from md_user_filials f
                            where f.company_id = t.company_id
                              and f.user_id = t.user_id
                              and f.filial_id = :filial_id)');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies t
                    where t.company_id = :company_id');
    q.Refer_Field('cashbox_name',
                  'cashbox_id',
                  'mkcs_cashboxes',
                  'cashbox_id',
                  'name',
                  'select *
                     from mkcs_cashboxes t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('bank_account_name',
                  'bank_account_id',
                  'mkcs_bank_accounts',
                  'bank_account_id',
                  'name',
                  'select *
                     from mkcs_bank_accounts t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
  
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    v_Matrix := Mpr_Util.Payment_Kinds;
    q.Option_Field('payment_kind_name', 'payment_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Mpr_Util.Payment_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Mpr_Util.Payment_Types;
    q.Option_Field('payment_type_name', 'payment_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Draft(p Hashmap) is
    v_Payment_Id number := p.r_Number('payment_id');
  begin
    Mpr_Api.Payment_Draft(i_Company_Id => Ui.Company_Id, i_Payment_Id => v_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book(p Hashmap) is
    v_Payment_Id number := p.r_Number('payment_id');
  begin
    Mpr_Api.Payment_Book(i_Company_Id => Ui.Company_Id, i_Payment_Id => v_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Complete(p Hashmap) is
    v_Payment_Id number := p.r_Number('payment_id');
  begin
    Mpr_Api.Payment_Complete(i_Company_Id => Ui.Company_Id, i_Payment_Id => v_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Archive(p Hashmap) is
    v_Payment_Id number := p.r_Number('payment_id');
  begin
    Mpr_Api.Payment_Archive(i_Company_Id => Ui.Company_Id, i_Payment_Id => v_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mpr_Payment_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Bank_Account_Id = null,
           Pay_Amount      = null,
           Pay_Amount_Base = null,
           Paid_Date       = null,
           Paid            = null,
           Note            = null,
           Order_No        = null;
    update x_Mpr_Payments
       set t_Company_Id       = null,
           t_Audit_Id         = null,
           t_Filial_Id        = null,
           t_Event            = null,
           t_Timestamp        = null,
           t_Date             = null,
           t_User_Id          = null,
           t_Context_Id       = null,
           Payment_Id         = null,
           Payment_Kind       = null,
           Status             = null,
           Payment_Number     = null,
           Payment_Date       = null,
           Booked_Date        = null,
           Division_Id        = null,
           Currency_Id        = null,
           Payment_Type       = null,
           Cashbox_Id         = null,
           Bank_Account_Id    = null,
           Amount             = null,
           Amount_Base        = null,
           Paid_Amount        = null,
           Paid_Amount_Base   = null,
           Unpaid_Amount      = null,
           Unpaid_Amount_Base = null,
           Note               = null,
           Barcode            = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mr_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Tin        = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
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
       set Company_Id        = null,
           Bank_Account_Id   = null,
           name              = null,
           Bank_Account_Code = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
  end;

end Ui_Vhr592;
/
