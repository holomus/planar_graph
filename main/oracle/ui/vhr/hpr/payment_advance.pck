create or replace package Ui_Vhr231 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Currencies(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Employee(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Employees(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr231;
/
create or replace package body Ui_Vhr231 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr231';

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Days_Limit  number := p.o_Number('days_limit');
    v_Limit_Kind  varchar2(1) := p.r_Varchar2('limit_kind');
    v_Booked_Date date := p.r_Date('booked_date');
  
    v_Turnout_Id number;
  
    v_Query  varchar2(4000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Query := 'select *
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''
                   and q.hiring_date <= :period_end
                   and nvl(q.dismissal_date, :period_begin) >= :period_begin';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'period_begin',
                             Trunc(v_Booked_Date, 'mon'),
                             'period_end',
                             v_Booked_Date);
  
    if v_Days_Limit is not null and --
       v_Limit_Kind = Hpr_Pref.c_Advance_Limit_Turnout_Days then
      v_Query := v_Query || --
                 ' and :days_limit <= (select count(*)
                         from htt_timesheets t
                        where t.company_id = q.company_id
                          and t.filial_id = q.filial_id
                          and t.staff_id = q.staff_id
                          and t.timesheet_date between :period_begin and :period_end
                          and exists (select *
                                 from htt_timesheet_facts tf
                                where tf.company_id = t.company_id
                                  and tf.filial_id = t.filial_id
                                  and tf.timesheet_id = t.timesheet_id
                                  and tf.time_kind_id = :turnout_id
                                  and tf.fact_value > 0))';
    
      v_Params.Put('turnout_id', v_Turnout_Id);
      v_Params.Put('days_limit', v_Days_Limit);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    return q;
  end;

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
                'select s.name from mk_currencies s where s.currency_id = $currency_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee
  (
    i_Employee_Id  number,
    i_Currency_Id  number,
    i_Payment_Date date,
    i_Period_Begin date,
    i_Period_End   date
  ) return Hashmap is
    v_Bank_Account_Id number;
    v_Staff_Id        number;
    r_Person_Detail   Href_Person_Details%rowtype;
    result            Hashmap;
  begin
    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => i_Employee_Id);
  
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id   => Ui.Company_Id,
                                                 i_Filial_Id    => Ui.Filial_Id,
                                                 i_Employee_Id  => i_Employee_Id,
                                                 i_Period_Begin => i_Period_Begin,
                                                 i_Period_End   => i_Period_End);
  
    result := Fazo.Zip_Map('employee_id',
                           i_Employee_Id,
                           'staff_id',
                           v_Staff_Id,
                           'employee_name',
                           z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => i_Employee_Id).Name,
                           'advance_amount',
                           Mpr_Util.Employee_Advance(i_Company_Id  => Ui.Company_Id,
                                                     i_Filial_Id   => Ui.Filial_Id,
                                                     i_Period      => i_Payment_Date,
                                                     i_Currency_Id => i_Currency_Id,
                                                     i_Employee_Id => i_Employee_Id),
                           'wage',
                           Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Staff_Id   => v_Staff_Id,
                                                     i_Period     => i_Period_End));
  
    Result.Put('iapa', r_Person_Detail.Iapa);
    Result.Put('npin', r_Person_Detail.Npin);
    Result.Put('tin',
               z_Mr_Person_Details.Take(i_Company_Id => r_Person_Detail.Company_Id, i_Person_Id => r_Person_Detail.Person_Id).Tin);
  
    begin
      select q.Bank_Account_Id
        into v_Bank_Account_Id
        from Mkcs_Bank_Accounts q
       where q.Company_Id = Ui.Company_Id
         and q.Person_Id = i_Employee_Id
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
  Function Load_Employee(p Hashmap) return Hashmap is
    v_Currency_Id number := p.o_Number('currency_id');
    v_Booked_Date date := p.r_Date('booked_date');
    v_Days_Limit  number := Nvl(p.o_Number('days_limit'), 0);
  begin
    if v_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
    end if;
  
    return Get_Employee(i_Employee_Id  => p.r_Number('employee_id'),
                        i_Currency_Id  => v_Currency_Id,
                        i_Payment_Date => p.r_Date('payment_date'),
                        i_Period_Begin => v_Booked_Date - v_Days_Limit,
                        i_Period_End   => v_Booked_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Employees(p Hashmap) return Arraylist is
    v_Employee_Ids Array_Number := p.r_Array_Number('employee_ids');
    v_Currency_Id  number := p.o_Number('currency_id');
    v_Payment_Date date := p.o_Date('payment_date');
    v_Booked_Date  date := p.r_Date('booked_date');
    v_Days_Limit   number := Nvl(p.o_Number('days_limit'), 0);
    v_Limit_Kind   varchar2(1) := p.r_Varchar2('limit_kind');
  
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    result Arraylist := Arraylist();
  begin
    if v_Currency_Id is null then
      v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => v_Filial_Id);
    end if;
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      if v_Days_Limit is not null and v_Limit_Kind = Hpr_Pref.c_Advance_Limit_Turnout_Days and
         v_Days_Limit > Htt_Util.Calc_Turnout_Days(i_Company_Id  => v_Company_Id,
                                                   i_Filial_Id   => v_Filial_Id,
                                                   i_Employee_Id => v_Employee_Ids(i),
                                                   i_Begin_Date  => Trunc(v_Booked_Date, 'mon'),
                                                   i_End_Date    => v_Booked_Date) then
        continue;
      end if;
    
      Result.Push(Get_Employee(i_Employee_Id  => v_Employee_Ids(i),
                               i_Currency_Id  => v_Currency_Id,
                               i_Payment_Date => v_Payment_Date,
                               i_Period_Begin => v_Booked_Date - v_Days_Limit,
                               i_Period_End   => v_Booked_Date));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id  => i_Division_Id,
                                                 i_Check_Access => false)));
    Result.Put('lk_turnout', Hpr_Pref.c_Advance_Limit_Turnout_Days);
    Result.Put('lk_calendar', Hpr_Pref.c_Advance_Limit_Calendar_Days);
    Result.Put('advance_limit_kinds', Fazo.Zip_Matrix_Transposed(Hpr_Util.Advance_Limit_Kinds));
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
    v_Data        Hashmap;
    result        Hashmap := Hashmap();
  begin
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id);
  
    v_Data := Fazo.Zip_Map('filial_id',
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
                           z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => v_Currency_Id).Name);
  
    v_Data.Put('limit_kind', Hpr_Pref.c_Advance_Limit_Calendar_Days);
    v_Data.Put('days_limit', 15);
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Payment Mpr_Payments%rowtype;
    r_Setting Hpr_Advance_Settings%rowtype;
    v_Matrix  Matrix_Varchar2;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    r_Payment := z_Mpr_Payments.Load(i_Company_Id => Ui.Company_Id,
                                     i_Payment_Id => p.r_Number('payment_id'));
  
    if r_Payment.Payment_Kind <> Mpr_Pref.c_Pk_Advance then
      b.Raise_Not_Implemented;
    end if;
  
    r_Setting := z_Hpr_Advance_Settings.Take(i_Company_Id => r_Payment.Company_Id,
                                             i_Filial_Id  => r_Payment.Filial_Id,
                                             i_Payment_Id => r_Payment.Payment_Id);
  
    v_Data := z_Mpr_Payments.To_Map(r_Payment,
                                    z.Filial_Id,
                                    z.Payment_Id,
                                    z.Payment_Number,
                                    z.Payment_Date,
                                    z.Booked_Date,
                                    z.Currency_Id,
                                    z.Payment_Type,
                                    z.Division_Id,
                                    z.Cashbox_Id,
                                    z.Bank_Account_Id,
                                    z.Amount,
                                    z.Note);
  
    v_Data.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_Division_Id => r_Payment.Division_Id).Name);
    v_Data.Put('currency_name',
               z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => r_Payment.Currency_Id).Name);
    v_Data.Put('cashbox_name',
               z_Mkcs_Cashboxes.Take(i_Company_Id => Ui.Company_Id, i_Cashbox_Id => r_Payment.Cashbox_Id).Name);
    v_Data.Put('bank_account_name',
               z_Mkcs_Bank_Accounts.Take(i_Company_Id => Ui.Company_Id, i_Bank_Account_Id => r_Payment.Bank_Account_Id).Name);
  
    v_Data.Put('days_limit', r_Setting.Days_Limit);
    v_Data.Put('limit_kind', Nvl(r_Setting.Limit_Kind, Hpr_Pref.c_Advance_Limit_Calendar_Days));
  
    select Array_Varchar2(q.Employee_Id,
                          Href_Util.Get_Primary_Staff_Id(i_Company_Id  => q.Company_Id,
                                                         i_Filial_Id   => q.Filial_Id,
                                                         i_Employee_Id => q.Employee_Id,
                                                         i_Date        => r_Payment.Booked_Date),
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
                          Mpr_Util.Employee_Advance(i_Company_Id  => r_Payment.Company_Id,
                                                    i_Filial_Id   => r_Payment.Filial_Id,
                                                    i_Period      => r_Payment.Payment_Date,
                                                    i_Currency_Id => r_Payment.Currency_Id,
                                                    i_Employee_Id => q.Employee_Id),
                          q.Paid_Date,
                          q.Paid,
                          q.Note,
                          Hpd_Util.Get_Closest_Wage(i_Company_Id => r_Payment.Company_Id,
                                                    i_Filial_Id  => r_Payment.Filial_Id,
                                                    i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id   => q.Company_Id,
                                                                                                   i_Filial_Id    => q.Filial_Id,
                                                                                                   i_Employee_Id  => q.Employee_Id,
                                                                                                   i_Period_Begin => r_Payment.Booked_Date -
                                                                                                                     r_Setting.Days_Limit,
                                                                                                   i_Period_End   => r_Payment.Booked_Date),
                                                    i_Period     => r_Payment.Booked_Date))
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
    v_Advance     Hpr_Pref.Advance_Rt;
    v_Employees   Arraylist := p.r_Arraylist('employees');
    v_Employee    Hashmap;
    v_Status      varchar2(1) := p.r_Varchar2('status');
    v_Round_Value varchar2(100) := p.o_Varchar2('round_value');
  begin
    -- advance save
    Hpr_Util.Advance_New(o_Advance         => v_Advance,
                         i_Company_Id      => Ui.Company_Id,
                         i_Filial_Id       => Ui.Filial_Id,
                         i_Payment_Id      => i_Payment_Id,
                         i_Payment_Number  => p.o_Varchar2('payment_number'),
                         i_Payment_Date    => p.r_Date('payment_date'),
                         i_Booked_Date     => p.r_Date('booked_date'),
                         i_Currency_Id     => p.o_Number('currency_id'),
                         i_Payment_Type    => p.r_Varchar2('payment_type'),
                         i_Days_Limit      => p.o_Number('days_limit'),
                         i_Limit_Kind      => p.r_Varchar2('limit_kind'),
                         i_Division_Id     => p.o_Number('division_id'),
                         i_Cashbox_Id      => p.o_Number('cashbox_id'),
                         i_Bank_Account_Id => p.o_Number('bank_account_id'),
                         i_Note            => p.o_Varchar2('note'),
                         i_Souce_Table     => Zt.Mpr_Payments.Name);
  
    for i in 1 .. v_Employees.Count
    loop
      v_Employee := Treat(v_Employees.r_Hashmap(i) as Hashmap);
    
      Hpr_Util.Advance_Add_Employee(p_Advance         => v_Advance,
                                    i_Employee_Id     => v_Employee.r_Number('employee_id'),
                                    i_Pay_Amount      => v_Employee.r_Number('pay_amount'),
                                    i_Bank_Account_Id => v_Employee.o_Number('bank_account_id'),
                                    i_Paid_Date       => v_Employee.o_Date('paid_date'),
                                    i_Paid            => v_Employee.r_Varchar2('paid'),
                                    i_Note            => v_Employee.o_Varchar2('note'));
    end loop;
  
    Hpr_Api.Advance_Save(v_Advance);
  
    -- status change
    if v_Status = Mpr_Pref.c_Ps_Completed then
      Mpr_Api.Payment_Complete(i_Company_Id => v_Advance.Payment.Company_Id,
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
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Id   = null,
           Timesheet_Date = null,
           Staff_Id       = null;
    update Htt_Timesheet_Facts
       set Company_Id   = null,
           Filial_Id    = null,
           Timesheet_Id = null,
           Time_Kind_Id = null,
           Fact_Value   = null;
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
  end;

end Ui_Vhr231;
/
