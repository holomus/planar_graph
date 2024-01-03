create or replace package Ui_Vhr610 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Payroll(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Yearly_Payrolls(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr610;
/
create or replace package body Ui_Vhr610 is
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
    return b.Translate('UI-VHR610:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Calculation_Start
  (
    i_Staff      in Href_Staffs%rowtype,
    i_Begin_Date date,
    i_End_Date   date
  ) return Hashmap is
    v_Total_Accrual        number;
    v_Total_Deduction      number;
    v_Worked_Days          number;
    v_Worked_Hours         number;
    v_Payment              number;
    v_Wage_Amount          number;
    v_Overtime_Amount      number;
    v_Late_Amount          number;
    v_Early_Amount         number;
    v_Lack_Amount          number;
    v_Day_Skip_Amount      number;
    v_Mark_Skip_Amount     number;
    v_Onetime_Accrual      number;
    v_Onetime_Penalty      number;
    v_Accrual_Oper_Types   Arraylist := Arraylist();
    v_Deduction_Oper_Types Arraylist := Arraylist();
    result                 Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Push_Oper_Type
    (
      i_Name           varchar2,
      i_Amount         number,
      i_Operation_Kind varchar := Mpr_Pref.c_Ok_Deduction
    ) is
    begin
      if i_Operation_Kind = Mpr_Pref.c_Ok_Accrual then
        v_Accrual_Oper_Types.Push(Fazo.Zip_Map('name', i_Name, 'amount', i_Amount));
      else
        v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name', i_Name, 'amount', i_Amount));
      end if;
    end;
  begin
    Result.Put('is_approximately',
               Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => i_Staff.Staff_Id,
                                             i_Dismissal_Date => i_Staff.Dismissal_Date,
                                             i_Hiring_Date    => i_Staff.Hiring_Date,
                                             i_Begin_Date     => i_Begin_Date,
                                             i_End_Date       => i_End_Date,
                                             i_Is_Pro         => false));
  
    Uit_Hpr.Wage_Calculation_Start(i_Staff_Id         => i_Staff.Staff_Id,
                                   i_Begin_Date       => i_Begin_Date,
                                   i_End_Date         => i_End_Date,
                                   o_Worked_Hours     => v_Worked_Hours,
                                   o_Worked_Days      => v_Worked_Days,
                                   o_Wage_Amount      => v_Wage_Amount,
                                   o_Overtime_Amount  => v_Overtime_Amount,
                                   o_Onetime_Accrual  => v_Onetime_Accrual,
                                   o_Late_Amount      => v_Late_Amount,
                                   o_Early_Amount     => v_Early_Amount,
                                   o_Lack_Amount      => v_Lack_Amount,
                                   o_Day_Skip_Amount  => v_Day_Skip_Amount,
                                   o_Mark_Skip_Amount => v_Mark_Skip_Amount,
                                   o_Onetime_Penalty  => v_Onetime_Penalty,
                                   o_Total_Accrual    => v_Total_Accrual,
                                   o_Total_Deduction  => v_Total_Deduction,
                                   o_Payment          => v_Payment);
  
    Push_Oper_Type(t('wage amount'), v_Wage_Amount, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('overtime amount'), v_Overtime_Amount, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('onetime accrual'), v_Onetime_Accrual, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('late amount'), v_Late_Amount);
    Push_Oper_Type(t('early amount'), v_Early_Amount);
    Push_Oper_Type(t('lack amount'), v_Lack_Amount);
    Push_Oper_Type(t('day skip amount'), v_Day_Skip_Amount);
    Push_Oper_Type(t('mark skip amount'), v_Mark_Skip_Amount);
    Push_Oper_Type(t('onetime penalty'), v_Onetime_Penalty);
  
    Result.Put('total_accrual', v_Total_Accrual);
    Result.Put('total_deduction', v_Total_Deduction);
    Result.Put('accrual_oper_types', v_Accrual_Oper_Types);
    Result.Put('deduction_oper_types', v_Deduction_Oper_Types);
    Result.Put('payoff', v_Total_Accrual - v_Total_Deduction);
    Result.Put('payment', v_Payment);
    Result.Put('left_amount', v_Total_Accrual - v_Total_Deduction - v_Payment);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Calculation_Pro
  (
    i_Staff      in Href_Staffs%rowtype,
    i_Begin_Date date,
    i_End_Date   date
  ) return Hashmap is
    v_Total_Accrual        number;
    v_Total_Deduction      number;
    v_Income_Tax           number;
    v_Worked_Hours         number;
    v_Worked_Days          number;
    v_Acc_Oper_Types       Matrix_Varchar2;
    v_Deduct_Oper_Types    Matrix_Varchar2;
    v_Payment              number;
    v_Credit_Amount        number;
    v_Accrual_Oper_Types   Arraylist := Arraylist();
    v_Deduction_Oper_Types Arraylist := Arraylist();
    result                 Hashmap := Hashmap();
  begin
    Result.Put('is_approximately',
               Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => i_Staff.Staff_Id,
                                             i_Dismissal_Date => i_Staff.Dismissal_Date,
                                             i_Hiring_Date    => i_Staff.Hiring_Date,
                                             i_Begin_Date     => i_Begin_Date,
                                             i_End_Date       => i_End_Date,
                                             i_Is_Pro         => true));
  
    Uit_Hpr.Wage_Calculation_Pro(i_Staff_Id             => i_Staff.Staff_Id,
                                 i_Begin_Date           => i_Begin_Date,
                                 i_End_Date             => i_End_Date,
                                 o_Total_Accrual        => v_Total_Accrual,
                                 o_Total_Deduction      => v_Total_Deduction,
                                 o_Income_Tax           => v_Income_Tax,
                                 o_Worked_Hours         => v_Worked_Hours,
                                 o_Worked_Days          => v_Worked_Days,
                                 o_Accrual_Oper_Types   => v_Acc_Oper_Types,
                                 o_Deduction_Oper_Types => v_Deduct_Oper_Types,
                                 o_Payment              => v_Payment,
                                 o_Credit               => v_Credit_Amount);
  
    for i in 1 .. v_Acc_Oper_Types.Count
    loop
      v_Accrual_Oper_Types.Push(Fazo.Zip_Map('name',
                                             v_Acc_Oper_Types(i) (1),
                                             'amount',
                                             v_Acc_Oper_Types(i) (2)));
    end loop;
  
    v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name',
                                             t('personal income tax'),
                                             'amount',
                                             v_Income_Tax));
  
    for i in 1 .. v_Deduct_Oper_Types.Count
    loop
      v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name',
                                               v_Deduct_Oper_Types(i) (1),
                                               'amount',
                                               v_Deduct_Oper_Types(i) (2)));
    end loop;
  
    if v_Credit_Amount > 0 then
      v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name', t('credit'), 'amount', v_Credit_Amount));
    end if;
  
    Result.Put('total_accrual', v_Total_Accrual);
    Result.Put('total_deduction', v_Total_Deduction);
    Result.Put('payoff', v_Total_Accrual - v_Total_Deduction);
    Result.Put('payment', v_Payment);
    Result.Put('left_amount', v_Total_Accrual - v_Total_Deduction - v_Payment);
    Result.Put('accrual_oper_types', v_Accrual_Oper_Types);
    Result.Put('deduction_oper_types', v_Deduction_Oper_Types);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Payroll
  (
    i_Employee_Id number,
    i_Month       date
  ) return Hashmap is
    r_Staff                       Href_Staffs%rowtype;
    r_Currency                    Mk_Currencies%rowtype;
    v_Job_Id                      number;
    v_Begin_Date                  date := Trunc(i_Month, 'mon');
    v_End_Date                    date := Last_Day(v_Begin_Date);
    v_Desired_Date                date;
    v_Access_To_Hidden_Salary_Job varchar2(1) := 'Y';
    v_Is_Pro                      varchar2(1) := 'Y';
    result                        Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id);
  
    r_Staff := Uit_Href.Get_Primary_Staff(i_Employee_Id => i_Employee_Id, i_Date => v_End_Date);
  
    if not Uit_Href.Is_Pro(r_Staff.Company_Id) then
      v_Is_Pro := 'N';
    end if;
  
    Result.Put('month', v_Begin_Date);
    Result.Put('is_pro', v_Is_Pro);
  
    if r_Staff.Staff_Id is null then
      Result.Put('has_data', 'N');
      return result;
    end if;
  
    Result.Put('has_data', 'Y');
  
    v_Desired_Date := Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date));
  
    v_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Staff.Company_Id,
                                            i_Filial_Id  => r_Staff.Filial_Id,
                                            i_Staff_Id   => r_Staff.Staff_Id,
                                            i_Period     => v_Desired_Date);
  
    v_Access_To_Hidden_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => v_Job_Id,
                                                                         i_Employee_Id => r_Staff.Employee_Id);
  
    Result.Put('access_to_hidden_salary_job', v_Access_To_Hidden_Salary_Job);
  
    if v_Access_To_Hidden_Salary_Job = 'Y' then
      r_Currency := z_Mk_Currencies.Load(i_Company_Id  => r_Staff.Company_Id,
                                         i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => r_Staff.Company_Id,
                                                                                i_Filial_Id  => r_Staff.Filial_Id));
    
      Result.Put('currency', r_Currency.Decimal_Name);
    
      if v_Is_Pro = 'Y' then
        Result.Put('payroll',
                   Wage_Calculation_Pro(i_Staff      => r_Staff,
                                        i_Begin_Date => v_Begin_Date,
                                        i_End_Date   => v_End_Date));
      else
        Result.Put('payroll',
                   Wage_Calculation_Start(i_Staff      => r_Staff,
                                          i_Begin_Date => v_Begin_Date,
                                          i_End_Date   => v_End_Date));
      end if;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Payroll(p Hashmap) return Hashmap is
  begin
    return Get_Payroll(i_Employee_Id => p.r_Number('employee_id'), i_Month => p.r_Date('month'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Yearly_Payrolls(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
    v_Year        number := p.r_Number('year');
    v_Begin_Date  date;
    v_End_Date    date;
    v_List        Arraylist := Arraylist();
    result        Hashmap := Hashmap();
  begin
    v_Begin_Date := Trunc(to_date(v_Year, 'YYYY'), 'YYYY');
    v_End_Date   := Least(Add_Months(v_Begin_Date, 11), Trunc(sysdate, 'mon'));
  
    for i in 0 .. Floor(Months_Between(v_End_Date, v_Begin_Date))
    loop
      v_List.Push(Get_Payroll(i_Employee_Id => v_Employee_Id,
                              i_Month       => Add_Months(v_Begin_Date, i)));
    end loop;
  
    Result.Put('begin_date', v_Begin_Date);
    Result.Put('end_date', v_End_Date);
    Result.Put('yearly_payrolls', v_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('employee_id',
                        p.r_Number('employee_id'),
                        'month',
                        Trunc(sysdate, 'mon'),
                        'year',
                        to_char(sysdate, 'YYYY'));
  end;

end Ui_Vhr610;
/
