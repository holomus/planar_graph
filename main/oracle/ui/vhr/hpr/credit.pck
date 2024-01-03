create or replace package Ui_Vhr679 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Currencies(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Closest_Wage(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr679;
/
create or replace package body Ui_Vhr679 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Currencies(p Hashmap) return Fazo_Query is
    v_Currency_Id number;
    v_Credit_Date date := p.r_Date('credit_date');
    q             Fazo_Query;
  begin
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id);
  
    q := Fazo_Query('select * 
                       from mk_currencies q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and (q.currency_id = :base_currency_id
                         or exists (select 1
                               from mk_currency_rates w
                              where w.company_id = q.company_id
                                and w.filial_id = :filial_id
                                and w.currency_id = q.currency_id
                                and w.rate_date <= :credit_date))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'base_currency_id',
                                 v_Currency_Id,
                                 'credit_date',
                                 v_Credit_Date));
  
    q.Number_Field('currency_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mkcs_cashboxes',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('cashbox_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mkcs_bank_accounts',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('bank_account_id', 'person_id', 'currency_id');
    q.Varchar2_Field('name', 'is_main');
  
    q.Map_Field('currency_name',
                'select s.name 
                   from mk_currencies s 
                  where s.company_id = :company_id 
                    and s.currency_id = $currency_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Employees return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select (select s.name
                               from mr_natural_persons s
                              where s.company_id = q.company_id
                                and s.person_id = q.employee_id) as name,
                            q.employee_id
                       from mhr_employees q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('employee_id', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Closest_Wage(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('wage',
               Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                                                        i_Filial_Id   => Ui.Filial_Id,
                                                                                        i_Employee_Id => p.r_Number('employee_id')),
                                         i_Period     => p.r_Date('period')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('payment_types', Fazo.Zip_Matrix_Transposed(Mpr_Util.Payment_Types));
    Result.Put('cs_draft', Hpr_Pref.c_Credit_Status_Draft);
    Result.Put('cs_book', Hpr_Pref.c_Credit_Status_Booked);
    Result.Put('cs_complete', Hpr_Pref.c_Credit_Status_Complete);
    Result.Put('ct_archive', Hpr_Pref.c_Credit_Status_Archived);
    Result.Put('pt_cashbox', Mpr_Pref.c_Pt_Cashbox);
    Result.Put('filial_id', Ui.Filial_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    v_Currency_Id number;
    v_Date        date := Trunc(sysdate);
    result        Hashmap;
  begin
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id);
  
    result := Fazo.Zip_Map('payment_type',
                           Mpr_Pref.c_Pt_Cashbox,
                           'credit_date',
                           v_Date,
                           'booked_date',
                           v_Date,
                           'begin_month',
                           to_char(v_Date, Href_Pref.c_Date_Format_Month),
                           'end_month',
                           to_char(v_Date, Href_Pref.c_Date_Format_Month));
  
    Result.Put('currency_id', v_Currency_Id);
    Result.Put('currency_name',
               z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => v_Currency_Id).Name);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    result   Hashmap;
    r_Credit Hpr_Credits%rowtype;
  begin
    r_Credit := z_Hpr_Credits.Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Credit_Id  => p.r_Number('credit_id'));
  
    result := z_Hpr_Credits.To_Map(r_Credit,
                                   z.Credit_Id,
                                   z.Credit_Number,
                                   z.Credit_Date,
                                   z.Booked_Date,
                                   z.Employee_Id,
                                   z.Credit_Amount,
                                   z.Currency_Id,
                                   z.Payment_Type,
                                   z.Cashbox_Id,
                                   z.Bank_Account_Id,
                                   z.Status,
                                   z.Note);
  
    Result.Put('begin_month', to_char(r_Credit.Begin_Month, Href_Pref.c_Date_Format_Month));
    Result.Put('end_month', to_char(r_Credit.End_Month, Href_Pref.c_Date_Format_Month));
    Result.Put('employee_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Credit.Company_Id, i_Person_Id => r_Credit.Employee_Id).Name);
    Result.Put('currency_name',
               z_Mk_Currencies.Load(i_Company_Id => r_Credit.Company_Id, i_Currency_Id => r_Credit.Currency_Id).Name);
    Result.Put('cashbox_name',
               z_Mkcs_Cashboxes.Take(i_Company_Id => r_Credit.Company_Id, i_Cashbox_Id => r_Credit.Cashbox_Id).Name);
    Result.Put('bank_account_name',
               z_Mkcs_Bank_Accounts.Take(i_Company_Id => r_Credit.Company_Id, i_Bank_Account_Id => r_Credit.Bank_Account_Id).Name);
    Result.Put('closest_wage',
               Hpd_Util.Get_Closest_Wage(i_Company_Id => r_Credit.Company_Id,
                                         i_Filial_Id  => r_Credit.Filial_Id,
                                         i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Credit.Company_Id,
                                                                                        i_Filial_Id   => r_Credit.Filial_Id,
                                                                                        i_Employee_Id => r_Credit.Employee_Id),
                                         i_Period     => r_Credit.Credit_Date));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    p           Hashmap,
    i_Credit_Id number
  ) return Hashmap is
    v_Credit Hpr_Pref.Credit_Rt;
    v_Status varchar2(1) := p.r_Varchar2('status');
  begin
    Hpr_Util.Credit_New(o_Credit          => v_Credit,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Credit_Id       => i_Credit_Id,
                        i_Credit_Number   => p.o_Varchar2('credit_number'),
                        i_Credit_Date     => p.r_Date('credit_date'),
                        i_Booked_Date     => p.r_Date('booked_date'),
                        i_Employee_Id     => p.r_Number('employee_id'),
                        i_Begin_Month     => p.r_Date('begin_month'),
                        i_End_Month       => p.r_Date('end_month'),
                        i_Credit_Amount   => p.r_Number('credit_amount'),
                        i_Currency_Id     => p.r_Number('currency_id'),
                        i_Payment_Type    => p.r_Varchar2('payment_type'),
                        i_Cashbox_Id      => p.o_Number('cashbox_id'),
                        i_Bank_Account_Id => p.o_Number('bank_account_id'),
                        i_Status          => v_Status,
                        i_Note            => p.o_Varchar2('note'));
  
    Hpr_Api.Credit_Save(v_Credit);
  
    if v_Status = Hpr_Pref.c_Credit_Status_Booked then
      Hpr_Api.Credit_Book(i_Company_Id => v_Credit.Company_Id,
                          i_Filial_Id  => v_Credit.Filial_Id,
                          i_Credit_Id  => v_Credit.Credit_Id);
    elsif v_Status = Hpr_Pref.c_Credit_Status_Complete then
      Hpr_Api.Credit_Complete(i_Company_Id => v_Credit.Company_Id,
                              i_Filial_Id  => v_Credit.Filial_Id,
                              i_Credit_Id  => v_Credit.Credit_Id);
    end if;
  
    return Fazo.Zip_Map('credit_id', i_Credit_Id, 'credit_number', v_Credit.Credit_Number);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hpr_Next.Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Credit Hpr_Credits%rowtype;
  begin
    r_Credit := z_Hpr_Credits.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Credit_Id  => p.r_Number('credit_id'));
  
    if r_Credit.Status <> Hpr_Pref.c_Credit_Status_Draft then
      Hpr_Api.Credit_Draft(i_Company_Id => r_Credit.Company_Id,
                           i_Filial_Id  => r_Credit.Filial_Id,
                           i_Credit_Id  => r_Credit.Credit_Id);
    end if;
  
    return save(p, r_Credit.Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null,
           State       = null;
    update Mk_Currency_Rates
       set Company_Id  = null,
           Filial_Id   = null,
           Currency_Id = null,
           Rate_Date   = null;
    update Mkcs_Cashboxes
       set Company_Id = null,
           Cashbox_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mkcs_Bank_Accounts
       set Company_Id      = null,
           Bank_Account_Id = null,
           name            = null,
           Person_Id       = null,
           Currency_Id     = null,
           Is_Main         = null,
           State           = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Division_Id = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr679;
/
