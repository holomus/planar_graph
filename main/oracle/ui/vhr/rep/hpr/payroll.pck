create or replace package Ui_Vhr221 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Months return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Run(p Hashmap) return Array_Varchar2;
end Ui_Vhr221;
/
create or replace package body Ui_Vhr221 is
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
    return b.Translate('UI-VHR221:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Months return Fazo_Query is
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
    q              Fazo_Query;
  begin
    q := Fazo_Query('select to_char(q.mon, :format) code, to_char(q.mon, ''FMMonth YYYY'', :nls_lang) title
                       from (select Add_Months(Trunc(to_date(:current_date, :format), ''MON''), -level + 1) mon, 
                                    level lv
                               from Dual 
                            connect by level < 13) q
                     order by q.lv',
                    Fazo.Zip_Map('current_date',
                                 to_char(sysdate, Href_Pref.c_Date_Format_Day),
                                 'nls_lang',
                                 v_Nls_Language,
                                 'format',
                                 Href_Pref.c_Date_Format_Day));
  
    q.Varchar2_Field('code', 'title');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap is
    v_Filters Arraylist := Arraylist();
  begin
    Ktb_Util.Add_Single_Select_Filter(p              => v_Filters,
                                      i_Code         => 'month',
                                      i_Title        => t('month'),
                                      i_Button_Title => t('select month'),
                                      i_Action       => ':query_months');
  
    return Ktb_Util.Build_Model(i_Action  => ':run',
                                i_Title   => t('report payroll'),
                                i_Filters => v_Filters);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Run(p Hashmap) return Array_Varchar2 is
    r_Staff           Href_Staffs%rowtype;
    r_Person_Detail   Mr_Person_Details%rowtype;
    r_Currency        Mk_Currencies%rowtype;
    v_Job_Id          number;
    v_Rank_Id         number;
    v_Begin_Date      date := Trunc(Nvl(p.o_Date('month'), sysdate), 'mon');
    v_End_Date        date := Last_Day(v_Begin_Date);
    v_Desired_Date    date;
    v_Total_Accrual   number;
    v_Total_Deduction number;
    v_Income_Tax      number;
    v_Payment         number;
    v_Credit          number;
    result            Array_Varchar2 := Array_Varchar2();
  
    -------------------------------------------------- 
    Procedure Push(i_Message varchar2) is
    begin
      Fazo.Push(result, i_Message || Chr(10));
    end;
  
    --------------------------------------------------
    Procedure Wage_Calculation_Pro is
      v_Is_Approximately     varchar2(1);
      v_Worked_Days          number;
      v_Worked_Hours         number;
      v_Accrual_Oper_Types   Matrix_Varchar2;
      v_Deduction_Oper_Types Matrix_Varchar2;
    begin
      v_Is_Approximately := Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => r_Staff.Staff_Id,
                                                          i_Dismissal_Date => r_Staff.Dismissal_Date,
                                                          i_Hiring_Date    => r_Staff.Hiring_Date,
                                                          i_Begin_Date     => v_Begin_Date,
                                                          i_End_Date       => v_End_Date,
                                                          i_Is_Pro         => true);
    
      if v_Is_Approximately = 'Y' then
        Push(t('approximately wage calculation'));
        Push('');
      end if;
    
      Uit_Hpr.Wage_Calculation_Pro(i_Staff_Id             => r_Staff.Staff_Id,
                                   i_Begin_Date           => v_Begin_Date,
                                   i_End_Date             => v_End_Date,
                                   o_Total_Accrual        => v_Total_Accrual,
                                   o_Total_Deduction      => v_Total_Deduction,
                                   o_Income_Tax           => v_Income_Tax,
                                   o_Worked_Hours         => v_Worked_Hours,
                                   o_Worked_Days          => v_Worked_Days,
                                   o_Accrual_Oper_Types   => v_Accrual_Oper_Types,
                                   o_Deduction_Oper_Types => v_Deduction_Oper_Types,
                                   o_Payment              => v_Payment,
                                   o_Credit               => v_Credit);
    
      Push(t('worked days/hours: $1{fact_days}/$2{fact_hours}', v_Worked_Days, v_Worked_Hours));
      Push('');
    
      Push(t('accrued: $1{total_accrual} $2{currency}',
             Uit_Href.Num_To_Char(v_Total_Accrual),
             r_Currency.Decimal_Name));
    
      for i in 1 .. v_Accrual_Oper_Types.Count
      loop
        Push(t('$1{order_no}) $2{accrued_oper_type_name}: $3{amount} $4{currency}',
               i,
               v_Accrual_Oper_Types(i) (1),
               Uit_Href.Num_To_Char(v_Accrual_Oper_Types(i) (2)),
               r_Currency.Decimal_Name));
      end loop;
    
      Push('');
      Push(t('deducted: $1{total_deduction} $2{currency}',
             Uit_Href.Num_To_Char(v_Total_Deduction),
             r_Currency.Decimal_Name));
      Push(t('$1{order_no}) $2{deducted_oper_type_name}: $3{amount} $4{currency}',
             1,
             t('personal income tax'),
             Uit_Href.Num_To_Char(v_Income_Tax),
             r_Currency.Decimal_Name));
    
      for i in 1 .. v_Deduction_Oper_Types.Count
      loop
        Push(t('$1{order_no}) $2{deducted_oper_type_name}: $3{amount} $4{currency}',
               i + 1,
               v_Deduction_Oper_Types(i) (1),
               Uit_Href.Num_To_Char(v_Deduction_Oper_Types(i) (2)),
               r_Currency.Decimal_Name));
      end loop;
    end;
  
    -------------------------------------------------- 
    Procedure Wage_Calculation_Start is
      v_Wage_Amount      number;
      v_Overtime_Amount  number;
      v_Late_Amount      number;
      v_Early_Amount     number;
      v_Lack_Amount      number;
      v_Day_Skip_Amount  number;
      v_Mark_Skip_Amount number;
      v_Onetime_Accrual  number;
      v_Onetime_Penalty  number;
      v_Worked_Days      number;
      v_Worked_Hours     number;
      v_Is_Approximately varchar2(1);
    
      -------------------------------------------------- 
      Procedure Push_Oper_Type
      (
        i_Order     number,
        i_Name      varchar2,
        i_Amount    number,
        i_Oper_Kind varchar := 'D'
      ) is
      begin
        if i_Oper_Kind <> 'D' then
          Push(t('$1{order_no}) $2{accured_oper_type_name}: $3{amount} $4{currency}',
                 i_Order,
                 i_Name,
                 Uit_Href.Num_To_Char(i_Amount),
                 r_Currency.Decimal_Name));
        else
          Push(t('$1{order_no}) $2{deducted_oper_type_name}: $3{amount} $4{currency}',
                 i_Order,
                 i_Name,
                 Uit_Href.Num_To_Char(i_Amount),
                 r_Currency.Decimal_Name));
        end if;
      end;
    begin
      v_Is_Approximately := Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => r_Staff.Staff_Id,
                                                          i_Dismissal_Date => r_Staff.Dismissal_Date,
                                                          i_Hiring_Date    => r_Staff.Hiring_Date,
                                                          i_Begin_Date     => v_Begin_Date,
                                                          i_End_Date       => v_End_Date,
                                                          i_Is_Pro         => false);
    
      if v_Is_Approximately = 'Y' then
        Push(t('approximately wage calculation'));
        Push('');
      end if;
    
      Uit_Hpr.Wage_Calculation_Start(i_Staff_Id         => r_Staff.Staff_Id,
                                     i_Begin_Date       => v_Begin_Date,
                                     i_End_Date         => v_End_Date,
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
    
      Push(t('worked days/hours: $1{fact_days}/$2{fact_hours}', v_Worked_Days, v_Worked_Hours));
      Push('');
    
      Push(t('accrued: $1{total_accrual} $2{currency}',
             Uit_Href.Num_To_Char(v_Total_Accrual),
             r_Currency.Decimal_Name));
    
      Push_Oper_Type(1, t('wage'), v_Wage_Amount, 'A');
      Push_Oper_Type(2, t('overtime'), v_Overtime_Amount, 'A');
      Push_Oper_Type(3, t('onetime accrual'), v_Onetime_Accrual, 'A');
    
      Push('');
      Push(t('deducted: $1{total_deduction} $2{currency}',
             Uit_Href.Num_To_Char(v_Total_Deduction),
             r_Currency.Decimal_Name));
    
      Push_Oper_Type(1, t('lateness'), v_Late_Amount);
      Push_Oper_Type(2, t('early'), v_Early_Amount);
      Push_Oper_Type(3, t('lack'), v_Lack_Amount);
      Push_Oper_Type(4, t('day skip'), v_Day_Skip_Amount);
      Push_Oper_Type(4, t('mark skip'), v_Mark_Skip_Amount);
      Push_Oper_Type(5, t('onetime penalty'), v_Onetime_Penalty);
    end;
  begin
    if Uit_Hlic.Is_Terminated = 'Y' then
      return Array_Varchar2(t('no license'));
    end if;
  
    r_Staff := Uit_Href.Get_Primary_Staff(i_Employee_Id => Ui.User_Id, i_Date => Trunc(sysdate));
  
    if r_Staff.Company_Id is null then
      return Array_Varchar2(t('primary staff is not found for this user'));
    end if;
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => r_Staff.Company_Id,
                                       i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => r_Staff.Company_Id,
                                                                              i_Filial_Id  => r_Staff.Filial_Id));
  
    Push(z_Md_Persons.Load(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Name);
  
    r_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => r_Staff.Company_Id,
                                                i_Person_Id  => r_Staff.Employee_Id);
  
    if r_Person_Detail.Tin is not null then
      Push(t('tin: $1{tin}', r_Person_Detail.Tin));
    end if;
  
    Push(t('month: $1{yyyy-mm}', to_char(v_Begin_Date, 'fmMonth yyyy', Htt_Util.Get_Nls_Language)));
  
    v_Desired_Date := Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date));
  
    v_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Staff.Company_Id,
                                            i_Filial_Id  => r_Staff.Filial_Id,
                                            i_Staff_Id   => r_Staff.Staff_Id,
                                            i_Period     => v_Desired_Date);
  
    if v_Job_Id is not null then
      Push(t('job: $1{job_name}',
             z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, --
             i_Filial_Id => r_Staff.Filial_Id, --
             i_Job_Id => v_Job_Id).Name));
    end if;
  
    v_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Staff.Company_Id,
                                              i_Filial_Id  => r_Staff.Filial_Id,
                                              i_Staff_Id   => r_Staff.Staff_Id,
                                              i_Period     => v_Desired_Date);
  
    if v_Rank_Id is not null then
      Push(t('rank: $1{rank_name}',
             z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, --
             i_Filial_Id => r_Staff.Filial_Id, --
             i_Rank_Id => v_Rank_Id).Name));
    end if;
  
    Push('');
  
    if Uit_Href.Is_Pro(r_Staff.Company_Id) then
      Wage_Calculation_Pro;
    else
      Wage_Calculation_Start;
    end if;
  
    Push('');
    Push(t('to payoff: $1{total_accrual} $2{currency}',
           Uit_Href.Num_To_Char(v_Total_Accrual - v_Total_Deduction),
           r_Currency.Decimal_Name));
    Push(t('paid out: $1{payment} $2{currency}',
           Uit_Href.Num_To_Char(v_Payment),
           r_Currency.Decimal_Name));
    Push(t('paid out: $1{credit} $2{currency}',
           Uit_Href.Num_To_Char(v_Credit),
           r_Currency.Decimal_Name));
    Push(t('left: $1{left_amount} $2{currency}',
           Uit_Href.Num_To_Char(v_Total_Accrual - v_Total_Deduction - v_Payment),
           r_Currency.Decimal_Name));
  
    return result;
  end;

end Ui_Vhr221;
/
