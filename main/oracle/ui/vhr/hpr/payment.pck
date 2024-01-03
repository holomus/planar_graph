create or replace package Ui_Vhr591 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Currencies(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Employee(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Fill_Data(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr591;
/
create or replace package body Ui_Vhr591 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr591';

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Currencies(p Hashmap) return Fazo_Query is
    v_Currency_Id  number;
    v_Payment_Date date := p.r_Date('payment_date');
    q              Fazo_Query;
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
                                and w.rate_date <= :payment_date))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'base_currency_id',
                                 v_Currency_Id,
                                 'payment_date',
                                 v_Payment_Date));
  
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
    q := Fazo_Query('select *
                       from mhr_employees q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and exists (select 1
                               from mpr_books w
                              where w.company_id = q.company_id
                                and w.filial_id = q.filial_id
                                and w.posted = ''Y''
                                and exists (select 1
                                       from mpr_book_operations s
                                      where s.company_id = w.company_id
                                        and s.filial_id = w.filial_id
                                        and s.book_id = w.book_id
                                        and s.employee_id = q.employee_id))',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('employee_id', 'division_id');
    q.Map_Field('name',
                'select s.name 
                   from mr_natural_persons s 
                  where s.company_id = :company_id 
                    and s.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee(p Hashmap) return Hashmap is
    v_Employee_Id     number := p.r_Number('employee_id');
    v_Currency_Id     number := p.o_Number('currency_id');
    v_Period          date := p.o_Date('payment_date');
    v_Bank_Account_Id number;
    r_Person_Detail   Href_Person_Details%rowtype;
    result            Hashmap;
  begin
    if v_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
    end if;
  
    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => v_Employee_Id);
  
    result := Fazo.Zip_Map('amount',
                           Mpr_Util.Employee_Salary(i_Company_Id  => Ui.Company_Id,
                                                    i_Filial_Id   => Ui.Filial_Id,
                                                    i_Period      => v_Period,
                                                    i_Currency_Id => v_Currency_Id,
                                                    i_Employee_Id => v_Employee_Id));
  
    Result.Put('iapa', r_Person_Detail.Iapa);
    Result.Put('npin', r_Person_Detail.Npin);
    Result.Put('tin',
               z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => v_Employee_Id).Tin);
  
    begin
      select q.Bank_Account_Id
        into v_Bank_Account_Id
        from Mkcs_Bank_Accounts q
       where q.Company_Id = Ui.Company_Id
         and q.Person_Id = v_Employee_Id
         and q.Is_Main = 'Y';
      Result.Put('bank_account_id', v_Bank_Account_Id);
      Result.Put('bank_account_name',
                 z_Mkcs_Bank_Accounts.Load(i_Company_Id => Ui.Company_Id, --
                 i_Bank_Account_Id => v_Bank_Account_Id).Name);
    exception
      when No_Data_Found then
        null;
    end;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fill_Data(p Hashmap) return Hashmap is
    v_Currency_Id number := p.o_Number('currency_id');
    v_Period      date := p.r_Date('payment_date');
    v_Matrix      Matrix_Varchar2;
    result        Hashmap := Hashmap();
  begin
    if v_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
    end if;
  
    select Array_Varchar2(Employee_Id,
                          Employee_Name,
                          Iapa,
                          Npin,
                          Tin,
                          Amount,
                          Bank_Account_Id,
                          Bank_Account_Name)
      bulk collect
      into v_Matrix
      from (select distinct w.Employee_Id,
                            (select s.Name
                               from Mr_Natural_Persons s
                              where s.Company_Id = w.Company_Id
                                and s.Person_Id = w.Employee_Id) Employee_Name,
                            Pd.Iapa,
                            Pd.Npin,
                            (select Mr.Tin
                               from Mr_Person_Details Mr
                              where Mr.Company_Id = w.Company_Id
                                and Mr.Person_Id = w.Employee_Id) Tin,
                            Mpr_Util.Employee_Salary(i_Company_Id  => w.Company_Id,
                                                     i_Filial_Id   => w.Filial_Id,
                                                     i_Period      => v_Period,
                                                     i_Currency_Id => v_Currency_Id,
                                                     i_Employee_Id => w.Employee_Id) Amount,
                            k.Bank_Account_Id,
                            k.Name Bank_Account_Name
              from Mpr_Books q
              join Mpr_Book_Operations w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Book_Id = q.Book_Id
              left join Mkcs_Bank_Accounts k
                on k.Company_Id = w.Company_Id
               and k.Person_Id = w.Employee_Id
               and k.Is_Main = 'Y'
               and k.State = 'A'
              left join Href_Person_Details Pd
                on Pd.Company_Id = w.Company_Id
               and Pd.Person_Id = w.Employee_Id
             where q.Company_Id = Ui.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Posted = 'Y');
  
    Result.Put('employees', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id  => i_Division_Id,
                                                 i_Check_Access => false)));
    Result.Put('payment_types', Fazo.Zip_Matrix_Transposed(Mpr_Util.Payment_Types));
    Result.Put('ps_draft', Mpr_Pref.c_Ps_Draft);
    Result.Put('ps_book', Mpr_Pref.c_Ps_Booked);
    Result.Put('ps_complete', Mpr_Pref.c_Ps_Completed);
    Result.Put('pt_cashbox', Mpr_Pref.c_Pt_Cashbox);
    Result.Put_All(Uit_Mpr.Load_Round_Value(g_Setting_Code));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Currency_Id number;
    result        Hashmap := Hashmap();
  begin
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id);
  
    Result.Put('data',
               Fazo.Zip_Map('filial_id',
                            Ui.Filial_Id,
                            'payment_date',
                            Trunc(sysdate),
                            'booked_date',
                            Trunc(sysdate),
                            'payment_type',
                            Mpr_Pref.c_Pt_Cashbox,
                            'currency_id',
                            v_Currency_Id,
                            'currency_name',
                            z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => v_Currency_Id).Name));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Payment Mpr_Payments%rowtype;
    v_Matrix  Matrix_Varchar2;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    r_Payment := z_Mpr_Payments.Load(i_Company_Id => Ui.Company_Id,
                                     i_Payment_Id => p.r_Number('payment_id'));
  
    v_Data := z_Mpr_Payments.To_Map(r_Payment,
                                    z.Filial_Id,
                                    z.Payment_Id,
                                    z.Payment_Number,
                                    z.Payment_Date,
                                    z.Booked_Date,
                                    z.Currency_Id,
                                    z.Payment_Type,
                                    z.Cashbox_Id,
                                    z.Bank_Account_Id,
                                    z.Amount,
                                    z.Note);
  
    v_Data.Put('currency_name',
               z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => r_Payment.Currency_Id).Name);
    v_Data.Put('cashbox_name',
               z_Mkcs_Cashboxes.Take(i_Company_Id => Ui.Company_Id, i_Cashbox_Id => r_Payment.Cashbox_Id).Name);
    v_Data.Put('bank_account_name',
               z_Mkcs_Bank_Accounts.Take(i_Company_Id => Ui.Company_Id, i_Bank_Account_Id => r_Payment.Bank_Account_Id).Name);
  
    select Array_Varchar2(q.Employee_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where w.Company_Id = q.Company_Id
                              and w.Person_Id = q.Employee_Id),
                          Pd.Iapa,
                          Pd.Npin,
                          (select Mr.Tin
                             from Mr_Person_Details Mr
                            where Mr.Company_Id = q.Company_Id
                              and Mr.Person_Id = q.Employee_Id),
                          q.Bank_Account_Id,
                          (select w.Name
                             from Mkcs_Bank_Accounts w
                            where w.Company_Id = q.Company_Id
                              and w.Bank_Account_Id = q.Bank_Account_Id),
                          q.Pay_Amount,
                          Mpr_Util.Employee_Salary(i_Company_Id  => r_Payment.Company_Id,
                                                   i_Filial_Id   => r_Payment.Filial_Id,
                                                   i_Period      => r_Payment.Payment_Date,
                                                   i_Currency_Id => r_Payment.Currency_Id,
                                                   i_Employee_Id => q.Employee_Id),
                          q.Paid_Date,
                          q.Paid,
                          q.Note)
      bulk collect
      into v_Matrix
      from Mpr_Payment_Employees q
      left join Href_Person_Details Pd
        on Pd.Company_Id = q.Company_Id
       and Pd.Person_Id = q.Employee_Id
     where q.Company_Id = r_Payment.Company_Id
       and q.Filial_Id = r_Payment.Filial_Id
       and q.Payment_Id = r_Payment.Payment_Id
     order by q.Order_No;
  
    v_Data.Put('employees', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('data', v_Data);
    Result.Put('references', References(r_Payment.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Payment_Id number,
    p            Hashmap
  ) is
    v_Payment     Mpr_Pref.Payment_Rt;
    v_Employees   Arraylist := p.r_Arraylist('employees');
    v_Employee    Hashmap;
    v_Status      varchar2(1) := p.r_Varchar2('status');
    v_Round_Value varchar2(100) := p.o_Varchar2('round_value');
  begin
    -- payment save
    Mpr_Util.Payment_New(o_Payment         => v_Payment,
                         i_Company_Id      => Ui.Company_Id,
                         i_Filial_Id       => Ui.Filial_Id,
                         i_Payment_Id      => i_Payment_Id,
                         i_Payment_Kind    => Mpr_Pref.c_Pk_Payroll,
                         i_Payment_Number  => p.o_Varchar2('payment_number'),
                         i_Payment_Date    => p.r_Date('payment_date'),
                         i_Booked_Date     => p.r_Date('booked_date'),
                         i_Division_Id     => p.o_Number('division_id'),
                         i_Currency_Id     => p.o_Number('currency_id'),
                         i_Payment_Type    => p.r_Varchar2('payment_type'),
                         i_Cashbox_Id      => p.o_Number('cashbox_id'),
                         i_Bank_Account_Id => p.o_Number('bank_account_id'),
                         i_Note            => p.o_Varchar2('note'),
                         i_Souce_Table     => Zt.Mpr_Payments.Name);
  
    for i in 1 .. v_Employees.Count
    loop
      v_Employee := Treat(v_Employees.r_Hashmap(i) as Hashmap);
    
      Mpr_Util.Payment_Add_Employee(p_Payment         => v_Payment,
                                    i_Employee_Id     => v_Employee.r_Number('employee_id'),
                                    i_Pay_Amount      => v_Employee.r_Number('pay_amount'),
                                    i_Bank_Account_Id => v_Employee.o_Number('bank_account_id'),
                                    i_Paid_Date       => v_Employee.o_Date('paid_date'),
                                    i_Paid            => v_Employee.r_Varchar2('paid'),
                                    i_Note            => v_Employee.o_Varchar2('note'));
    end loop;
  
    Mpr_Api.Payment_Save(v_Payment);
  
    -- status change
    if v_Status = Mpr_Pref.c_Ps_Booked then
      Mpr_Api.Payment_Book(i_Company_Id => v_Payment.Company_Id, --
                           i_Payment_Id => i_Payment_Id);
    elsif v_Status = Mpr_Pref.c_Ps_Completed then
      Mpr_Api.Payment_Complete(i_Company_Id => v_Payment.Company_Id, --
                               i_Payment_Id => i_Payment_Id);
    end if;
  
    -- user preference
    if v_Round_Value is not null then
      Md_Api.User_Setting_Save(i_Company_Id    => Ui.Company_Id,
                               i_User_Id       => Ui.User_Id,
                               i_Filial_Id     => Ui.Filial_Id,
                               i_Setting_Code  => g_Setting_Code,
                               i_Setting_Value => v_Round_Value);
    else
      Md_Api.User_Settings_Delete(i_Company_Id   => Ui.Company_Id,
                                  i_User_Id      => Ui.User_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Setting_Code => g_Setting_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Mpr_Next.Payment_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    v_Payment_Id number := p.r_Number('payment_id');
    r_Payment    Mpr_Payments%rowtype;
  begin
    r_Payment := z_Mpr_Payments.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Payment_Id => v_Payment_Id);
  
    if r_Payment.Status <> Mpr_Pref.c_Ps_Draft then
      Mpr_Api.Payment_Draft(i_Company_Id => Ui.Company_Id, --
                            i_Payment_Id => v_Payment_Id);
    end if;
  
    save(v_Payment_Id, p);
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
    update Mpr_Books
       set Company_Id = null,
           Filial_Id  = null,
           Book_Id    = null,
           Posted     = null;
    update Mpr_Book_Operations
       set Company_Id  = null,
           Filial_Id   = null,
           Book_Id     = null,
           Employee_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr591;
/
