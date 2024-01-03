create or replace package Ui_Vhr217 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run_Easy_Report(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr217;
/
create or replace package body Ui_Vhr217 is
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
    return b.Translate('UI-VHR217:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    v_Division_Ids Array_Number := p.o_Array_Number('division_ids');
    v_Params       Hashmap;
    v_Query        varchar2(32767);
    q              Fazo_Query;
  begin
    v_Query := 'select *
                  from mhr_jobs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if not Fazo.Is_Empty(v_Division_Ids) then
      v_Query := v_Query || --
                 ' and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id in (select *
                                                           from table(:division_ids))))';
    
      v_Params.Put('division_ids', v_Division_Ids);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Params       Hashmap;
    v_Query        varchar2(32767);
    v_Division_Ids Array_Number := p.o_Array_Number('division_ids');
    v_Job_Ids      Array_Number := p.o_Array_Number('job_ids');
    v_Begin_Date   date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_End_Date     date := Last_Day(v_Begin_Date);
    q              Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.hiring_date <= :end_date
                   and (w.dismissal_date is null or w.dismissal_date >= :begin_date)
                   and w.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'begin_date',
                             v_Begin_Date,
                             'end_date',
                             v_End_Date);
  
    if not Fazo.Is_Empty(v_Division_Ids) then
      v_Query := v_Query || --
                 ' and hpd_util.get_closest_division_id(w.company_id, w.filial_id, w.staff_id, :end_date) in
                   (select * from table(:division_ids))';
    
      v_Params.Put('division_ids', v_Division_Ids);
    end if;
  
    if not Fazo.Is_Empty(v_Job_Ids) then
      v_Query := v_Query || --
                 ' and hpd_util.get_closest_job_id(w.company_id, w.filial_id, w.staff_id, :end_date) in
                   (select * from table(:job_ids))';
    
      v_Params.Put('job_ids', v_Job_Ids);
    end if;
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number');
  
    q.Map_Field('name',
                'select q.name
                   from md_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Result.Put('data', Fazo.Zip_Map('month', to_char(sysdate, Href_Pref.c_Date_Format_Month)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    v_Matrix := Uit_Ker.Templates(i_Form       => Hpr_Pref.c_Easy_Report_Form_Payroll_Book,
                                  i_Action_Key => ':run_easy_report');
  
    Result.Put('reports', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Currency_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    result number;
  begin
    result := Hpd_Util.Get_Closest_Currency_Id(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Staff_Id   => i_Staff_Id,
                                               i_Period     => i_Period);
  
    if result is null then
      result := Mk_Pref.Base_Currency(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist is
    v_Staffs Arraylist := Arraylist;
    result   Arraylist := Arraylist;
  
    --------------------------------------------------
    Procedure Put
    (
      p_List       in out nocopy Arraylist,
      i_Key        varchar2,
      i_Definition varchar2,
      i_Items      Arraylist := null
    ) is
      v_Map Hashmap;
    begin
      v_Map := Fazo.Zip_Map('key', i_Key, 'definition', i_Definition);
    
      if i_Items is not null then
        v_Map.Put('items', i_Items);
      end if;
    
      p_List.Push(v_Map);
    end;
  begin
    Put(v_Staffs, 'order_no', t('order no'));
    Put(v_Staffs, 'staff number', t('staff number'));
    Put(v_Staffs, 'name', t('name'));
    Put(v_Staffs, 'tin', t('tin'));
    Put(v_Staffs, 'iapa', t('iapa'));
    Put(v_Staffs, 'job_name', t('job name'));
    Put(v_Staffs, 'rank_name', t('rank name'));
    Put(v_Staffs, 'wage', t('wage'));
    Put(v_Staffs, 'fact_days', t('fact days'));
    Put(v_Staffs, 'fact_hours', t('fact hours'));
    Put(v_Staffs, 'initial_balance', t('initial balance'));
    Put(v_Staffs, 'wage_accrual', t('wage accrual'));
    Put(v_Staffs, 'other_accrual', t('other accrual'));
    Put(v_Staffs, 'total_accrual', t('total accrual'));
    Put(v_Staffs, 'income_tax', t('income tax'));
    Put(v_Staffs, 'pension_payment', t('pension payment'));
    Put(v_Staffs, 'other_deduction', t('other deduction'));
    Put(v_Staffs, 'total_deduction', t('total deduction'));
    Put(v_Staffs, 'payment', t('payment'));
    Put(v_Staffs, 'final_balance', t('final balance'));
    Put(v_Staffs, 'social_payment', t('social payment'));
    Put(v_Staffs, 'given_year_income', t('given year income'));
    Put(v_Staffs, 'given_year_income_tax', t('given year income tax'));
    Put(v_Staffs, 'given_year_social_payment', t('given year social payment'));
  
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'date', t('date'));
    Put(result, 'divisions', t('divisions'));
    Put(result, 'begin_date', t('begin date'));
    Put(result, 'end_date', t('end date'));
    Put(result, 'initial_balance', t('initial balance'));
    Put(result, 'wage_accrual', t('wage accrual'));
    Put(result, 'other_accrual', t('other accrual'));
    Put(result, 'total_accrual', t('total accrual'));
    Put(result, 'income_tax', t('income tax'));
    Put(result, 'pension_payment', t('pension payment'));
    Put(result, 'other_deduction', t('other deduction'));
    Put(result, 'total_deduction', t('total deduction'));
    Put(result, 'payment', t('payment'));
    Put(result, 'final_balance', t('final balance'));
    Put(result, 'social_payment', t('social payment'));
    Put(result, 'given_year_income', t('given year income'));
    Put(result, 'given_year_income_tax', t('given year income tax'));
    Put(result, 'given_year_social_payment', t('given year social payment'));
    Put(result, 'staffs', t('staffs'), v_Staffs);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Easy_Report(p Hashmap) return Gmap is
    r_Staff               Href_Staffs%rowtype;
    v_Timebook_Staff_Info Hpr_Pref.Timebook_Staff_Info;
    v_Accrual             Mk_Account;
    v_Advance             Mk_Account;
    v_Acc_Balance         Mk_Pref.Balance_Rt;
    v_Adv_Balance         Mk_Pref.Balance_Rt;
    v_Staff               Gmap;
    v_Staffs              Glist := Glist();
    v_Division_Ids        Array_Number := p.o_Array_Number('division_ids');
    v_Job_Ids             Array_Number := p.o_Array_Number('job_ids');
    v_Staff_Ids           Array_Number := p.o_Array_Number('staff_ids');
    v_Employee_Ids        Array_Number;
    v_Names               Array_Varchar2;
    v_Begin_Date          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_End_Date            date := Last_Day(v_Begin_Date);
    v_Desired_Date        date;
    v_Begin_Year          date := Trunc(v_Begin_Date, Href_Pref.c_Date_Format_Year);
    v_Company_Id          number := Ui.Company_Id;
    v_Filial_Id           number := Ui.Filial_Id;
    v_Currency_Id         number := Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id,
                                                          i_Filial_Id  => v_Filial_Id);
    v_Book_Type_Id        number := Hpr_Util.Book_Type_Id(i_Company_Id => v_Company_Id,
                                                          i_Pcode      => Hpr_Pref.c_Pcode_Book_Type_Wage);
  
    v_Wage_Accrual    number;
    v_Other_Accrual   number;
    v_Income_Tax      number;
    v_Pension_Payment number;
    v_Other_Deduction number;
    v_Payment         number;
    v_Social_Payment  number;
    v_Trans_Id        number;
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Calc         Calc := Calc();
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
    result         Gmap := Gmap;
  
    --------------------------------------------------   
    Procedure Put
    (
      p_Map in out Gmap,
      i_Key varchar2,
      i_Val number
    ) is
    begin
      p_Map.Put(i_Key, Uit_Href.Num_To_Char(Nvl(i_Val, 0)));
    end;
  
    --------------------------------------------------   
    Procedure Put
    (
      p_Map in out Gmap,
      i_Key varchar2,
      i_Val varchar2
    ) is
    begin
      p_Map.Put(i_Key, Nvl(i_Val, ''));
    end;
  begin
    if not Fazo.Is_Empty(v_Division_Ids) then
      -- division names
      select q.Name
        bulk collect
        into v_Names
        from Mhr_Divisions q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Division_Id in (select *
                                 from table(v_Division_Ids));
    else
      v_Division_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Job_Ids) then
      v_Job_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Staff_Ids) then
      v_Staff_Ids := null;
    end if;
  
    Put(result,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => v_Company_Id, --
        i_Filial_Id => v_Filial_Id).Name);
    Put(result, 'date', to_char(v_Begin_Date, 'fmMonth yyyy', v_Nls_Language));
    Put(result, 'divisions', Fazo.Gather(Nvl(v_Names, Array_Varchar2()), ', '));
    Put(result, 'begin_date', to_char(v_Begin_Date, Href_Pref.c_Date_Format_Day));
    Put(result, 'end_date', to_char(v_End_Date, Href_Pref.c_Date_Format_Day));
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    -- employee ids and names
    select distinct q.Employee_Id,
                    (select Mp.Name
                       from Md_Persons Mp
                      where Mp.Company_Id = q.Company_Id
                        and Mp.Person_Id = q.Employee_Id) name
      bulk collect
      into v_Employee_Ids, v_Names
      from Href_Staffs q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= v_End_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Begin_Date)
       and q.State = 'A'
       and (v_Staff_Ids is null or
           q.Staff_Id in (select *
                             from table(v_Staff_Ids)))
       and (v_Division_Ids is null or Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => q.Company_Id,
                                                                       i_Filial_Id  => q.Filial_Id,
                                                                       i_Staff_Id   => q.Staff_Id,
                                                                       i_Period     => v_End_Date) in
           (select *
                                         from table(v_Division_Ids)))
       and (v_Job_Ids is null or Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                             i_Filial_Id  => q.Filial_Id,
                                                             i_Staff_Id   => q.Staff_Id,
                                                             i_Period     => v_End_Date) in
           (select *
                                    from table(v_Job_Ids)))
       and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
           q.Division_Id member of v_Subordinate_Divisions)
     order by name;
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      v_Staff := Gmap();
    
      if not z_Href_Staffs.Exist(i_Company_Id => v_Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                                                i_Filial_Id   => v_Filial_Id,
                                                                                i_Employee_Id => v_Employee_Ids(i),
                                                                                i_Date        => v_End_Date),
                                 o_Row        => r_Staff) then
        select q.*
          into r_Staff
          from Href_Staffs q
         where q.Company_Id = v_Company_Id
           and q.Filial_Id = v_Filial_Id
           and q.Employee_Id = v_Employee_Ids(i)
           and q.Hiring_Date <= v_End_Date
           and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Begin_Date)
           and q.State = 'A'
         order by q.Hiring_Date
         fetch first row only;
      end if;
    
      v_Accrual := Mkr_Account.Payroll_Accrual(i_Company_Id                   => r_Staff.Company_Id,
                                               i_Filial_Id                    => r_Staff.Filial_Id,
                                               i_Currency_Id                  => v_Currency_Id,
                                               i_Person_Id                    => r_Staff.Employee_Id,
                                               i_Payroll_Accrual_Condition_Id => Mkr_Pref.c_Pac_Free);
      v_Advance := Mkr_Account.Payroll_Advance(i_Company_Id  => r_Staff.Company_Id,
                                               i_Filial_Id   => r_Staff.Filial_Id,
                                               i_Currency_Id => v_Currency_Id,
                                               i_Person_Id   => r_Staff.Employee_Id);
    
      v_Desired_Date := Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date));
    
      Put(v_Staff, 'order_no', i);
      Put(v_Staff, 'staff_number', r_Staff.Staff_Number);
      Put(v_Staff, 'name', v_Names(i));
      Put(v_Staff,
          'tin',
          z_Mr_Person_Details.Take(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Tin);
      Put(v_Staff,
          'iapa',
          z_Href_Person_Details.Take(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Iapa);
      Put(v_Staff,
          'job_name',
          z_Mhr_Jobs.Load(i_Company_Id => r_Staff.Company_Id, --
          i_Filial_Id => r_Staff.Filial_Id, --
          i_Job_Id => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Staff.Company_Id, --
          i_Filial_Id => r_Staff.Filial_Id, --
          i_Staff_Id => r_Staff.Staff_Id, --
          i_Period => v_Desired_Date)).Name);
      Put(v_Staff,
          'rank_name',
          z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, --
          i_Filial_Id => r_Staff.Filial_Id, --
          i_Rank_Id => Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Staff.Company_Id, --
          i_Filial_Id => r_Staff.Filial_Id, --
          i_Staff_Id => r_Staff.Staff_Id, --
          i_Period => v_Desired_Date)).Name);
    
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => r_Staff.Company_Id,
                                                i_Filial_Id  => r_Staff.Filial_Id,
                                                i_Staff_Id   => r_Staff.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => v_Desired_Date);
    
      Put(v_Staff,
          'wage',
          Mk_Util.Calc_Amount_Base(i_Company_Id  => r_Staff.Company_Id,
                                   i_Filial_Id   => r_Staff.Filial_Id,
                                   i_Currency_Id => Get_Closest_Currency_Id(i_Company_Id => r_Staff.Company_Id,
                                                                            i_Filial_Id  => r_Staff.Filial_Id,
                                                                            i_Staff_Id   => r_Staff.Staff_Id,
                                                                            i_Period     => v_Desired_Date),
                                   i_Rate_Date   => v_Desired_Date,
                                   i_Amount      => Hpd_Util.Get_Closest_Wage(i_Company_Id => r_Staff.Company_Id,
                                                                              i_Filial_Id  => r_Staff.Filial_Id,
                                                                              i_Staff_Id   => r_Staff.Staff_Id,
                                                                              i_Period     => v_Desired_Date)));
    
      v_Timebook_Staff_Info := Uit_Hpr.Get_Timebook_Staff(i_Month    => v_Begin_Date,
                                                          i_Staff_Id => r_Staff.Staff_Id);
    
      Put(v_Staff, 'fact_days', to_char(Nvl(v_Timebook_Staff_Info.Fact_Days, 0)));
      Put(v_Staff, 'fact_hours', to_char(Nvl(v_Timebook_Staff_Info.Fact_Hours, 0)));
    
      v_Acc_Balance := Mk_Util.Balance(i_Company_Id => r_Staff.Company_Id,
                                       i_Filial_Id  => r_Staff.Filial_Id,
                                       i_Period     => v_Begin_Date,
                                       i_Account    => v_Accrual);
      v_Adv_Balance := Mk_Util.Balance(i_Company_Id => r_Staff.Company_Id,
                                       i_Filial_Id  => r_Staff.Filial_Id,
                                       i_Period     => v_Begin_Date,
                                       i_Account    => v_Advance);
    
      Put(v_Staff, 'initial_balance', v_Acc_Balance.Amount + v_Adv_Balance.Amount);
      v_Calc.Plus('initial_balance', v_Acc_Balance.Amount + v_Adv_Balance.Amount);
    
      select sum(Decode(Oper.Is_Wage || Oper.Operation_Kind,
                        'Y' || Mpr_Pref.c_Ok_Accrual,
                        Oper.Amount,
                        0)),
             sum(Decode(Oper.Is_Wage || Oper.Operation_Kind,
                        'N' || Mpr_Pref.c_Ok_Accrual,
                        Oper.Amount,
                        0)),
             sum(Oper.Income_Tax_Amount),
             sum(Oper.Pension_Payment_Amount),
             sum(Decode(Oper.Operation_Kind, Mpr_Pref.c_Ok_Accrual, 0, Oper.Amount)),
             sum(Oper.Social_Payment_Amount)
        into v_Wage_Accrual,
             v_Other_Accrual,
             v_Income_Tax,
             v_Pension_Payment,
             v_Other_Deduction,
             v_Social_Payment
        from (select q.Amount_Base Amount,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Income_Tax_Amount) Income_Tax_Amount,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Pension_Payment_Amount) Pension_Payment_Amount,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Social_Payment_Amount) Social_Payment_Amount,
                     Nvl((select 'Y'
                           from Hpr_Books Hb
                          where Hb.Company_Id = q.Company_Id
                            and Hb.Filial_Id = q.Filial_Id
                            and Hb.Book_Id = q.Book_Id
                            and Hb.Book_Type_Id = v_Book_Type_Id),
                         'N') as Is_Wage,
                     (select Ot.Operation_Kind
                        from Mpr_Oper_Types Ot
                       where Ot.Company_Id = q.Company_Id
                         and Ot.Oper_Type_Id = q.Oper_Type_Id) as Operation_Kind
                from Mpr_Book_Operations q
                join Mpr_Books w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Book_Id = q.Book_Id
               where q.Company_Id = r_Staff.Company_Id
                 and q.Filial_Id = r_Staff.Filial_Id
                 and q.Employee_Id = r_Staff.Employee_Id
                 and w.Posted = 'Y'
                 and w.Month between v_Begin_Date and v_End_Date) Oper;
    
      v_Wage_Accrual    := Nvl(v_Wage_Accrual, 0);
      v_Other_Accrual   := Nvl(v_Other_Accrual, 0);
      v_Income_Tax      := Nvl(v_Income_Tax, 0);
      v_Other_Deduction := Nvl(v_Other_Deduction, 0);
    
      Put(v_Staff, 'wage_accrual', v_Wage_Accrual);
      Put(v_Staff, 'other_accrual', v_Other_Accrual);
      Put(v_Staff, 'total_accrual', v_Wage_Accrual + v_Other_Accrual);
      Put(v_Staff, 'income_tax', v_Income_Tax);
      Put(v_Staff, 'pension_payment', v_Pension_Payment);
      Put(v_Staff, 'other_deduction', v_Other_Deduction);
      Put(v_Staff, 'total_deduction', v_Income_Tax + v_Other_Deduction);
    
      v_Calc.Plus('wage_accrual', v_Wage_Accrual);
      v_Calc.Plus('other_accrual', v_Other_Accrual);
      v_Calc.Plus('total_accrual', v_Wage_Accrual + v_Other_Accrual);
      v_Calc.Plus('income_tax', v_Income_Tax);
      v_Calc.Plus('pension_payment', v_Pension_Payment);
      v_Calc.Plus('other_deduction', v_Other_Deduction);
      v_Calc.Plus('total_deduction', v_Income_Tax + v_Other_Deduction);
    
      select Nvl(sum(q.Pay_Amount_Base), 0)
        into v_Payment
        from Mpr_Payment_Employees q
       where q.Company_Id = r_Staff.Company_Id
         and q.Filial_Id = r_Staff.Filial_Id
         and q.Employee_Id = r_Staff.Employee_Id
         and q.Paid = 'Y'
         and Trunc(q.Paid_Date, 'Mon') = v_Begin_Date
         and exists (select 1
                from Mpr_Payments Mp
               where Mp.Company_Id = q.Company_Id
                 and Mp.Filial_Id = q.Filial_Id
                 and Mp.Payment_Id = q.Payment_Id
                 and Mp.Status in (Mpr_Pref.c_Ps_Completed, --
                                   Mpr_Pref.c_Ps_Archived));
    
      Put(v_Staff, 'payment', v_Payment);
      v_Calc.Plus('payment', v_Payment);
    
      Put(v_Staff,
          'final_balance',
          v_Wage_Accrual + v_Other_Accrual - (v_Income_Tax + v_Other_Deduction) - v_Payment);
      Put(v_Staff, 'social_payment', v_Social_Payment);
    
      v_Calc.Plus('final_balance',
                  v_Wage_Accrual + v_Other_Accrual - (v_Income_Tax + v_Other_Deduction) - v_Payment);
      v_Calc.Plus('social_payment', v_Social_Payment);
    
      select sum(q.Amount_Base),
             sum(Mk_Util.Calc_Amount_Base(i_Company_Id  => Mb.Company_Id,
                                          i_Filial_Id   => Mb.Filial_Id,
                                          i_Currency_Id => Mb.Currency_Id,
                                          i_Rate_Date   => Mb.Book_Date,
                                          i_Amount      => q.Income_Tax_Amount)),
             sum(Mk_Util.Calc_Amount_Base(i_Company_Id  => Mb.Company_Id,
                                          i_Filial_Id   => Mb.Filial_Id,
                                          i_Currency_Id => Mb.Currency_Id,
                                          i_Rate_Date   => Mb.Book_Date,
                                          i_Amount      => q.Social_Payment_Amount))
        into v_Wage_Accrual, v_Income_Tax, v_Social_Payment
        from Mpr_Book_Operations q
        join Mpr_Books Mb
          on Mb.Company_Id = q.Company_Id
         and Mb.Filial_Id = q.Filial_Id
         and Mb.Book_Id = q.Book_Id
         and Mb.Posted = 'Y'
         and Mb.Month between v_Begin_Year and v_End_Date
       where q.Company_Id = r_Staff.Company_Id
         and q.Filial_Id = r_Staff.Filial_Id
         and q.Employee_Id = r_Staff.Employee_Id
         and exists (select 1
                from Mpr_Oper_Types Ot
               where Ot.Company_Id = q.Company_Id
                 and Ot.Oper_Type_Id = q.Oper_Type_Id
                 and Ot.Operation_Kind = Mpr_Pref.c_Ok_Accrual);
    
      Put(v_Staff, 'given_year_income', v_Wage_Accrual);
      Put(v_Staff, 'given_year_income_tax', v_Income_Tax);
      Put(v_Staff, 'given_year_social_payment', v_Social_Payment);
    
      v_Calc.Plus('given_year_income', v_Wage_Accrual);
      v_Calc.Plus('given_year_income_tax', v_Income_Tax);
      v_Calc.Plus('given_year_social_payment', v_Social_Payment);
    
      v_Staffs.Push(v_Staff.Val);
    end loop;
  
    Put(result, 'initial_balance', v_Calc.Get_Value('initial_balance'));
    Put(result, 'wage_accrual', v_Calc.Get_Value('wage_accrual'));
    Put(result, 'other_accrual', v_Calc.Get_Value('other_accrual'));
    Put(result, 'total_accrual', v_Calc.Get_Value('total_accrual'));
    Put(result, 'income_tax', v_Calc.Get_Value('income_tax'));
    Put(result, 'pension_payment', v_Calc.Get_Value('pension_payment'));
    Put(result, 'other_deduction', v_Calc.Get_Value('other_deduction'));
    Put(result, 'total_deduction', v_Calc.Get_Value('total_deduction'));
    Put(result, 'payment', v_Calc.Get_Value('payment'));
    Put(result, 'final_balance', v_Calc.Get_Value('final_balance'));
    Put(result, 'social_payment', v_Calc.Get_Value('social_payment'));
    Put(result, 'given_year_income', v_Calc.Get_Value('given_year_income'));
    Put(result, 'given_year_income_tax', v_Calc.Get_Value('given_year_income_tax'));
    Put(result, 'given_year_social_payment', v_Calc.Get_Value('given_year_social_payment'));
    Result.Put('staffs', v_Staffs);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run_Easy_Report(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Easy_Report(p));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
    r_Staff                    Href_Staffs%rowtype;
    r_Currency                 Mk_Currencies%rowtype;
    r_Person_Details           Href_Person_Details%rowtype;
    v_Timebook_Staff_Info      Hpr_Pref.Timebook_Staff_Info;
    v_Accrual                  Mk_Account;
    v_Advance                  Mk_Account;
    v_Acc_Balance              Mk_Pref.Balance_Rt;
    v_Adv_Balance              Mk_Pref.Balance_Rt;
    v_Division_Ids             Array_Number := p.o_Array_Number('division_ids');
    v_Job_Ids                  Array_Number := p.o_Array_Number('job_ids');
    v_Staff_Ids                Array_Number := p.o_Array_Number('staff_ids');
    v_Employee_Ids             Array_Number;
    v_Names                    Array_Varchar2;
    v_Begin_Date               date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_End_Date                 date := Last_Day(v_Begin_Date);
    v_Desired_Date             date;
    v_Begin_Year               date := Trunc(v_Begin_Date, Href_Pref.c_Date_Format_Year);
    v_Company_Id               number := Ui.Company_Id;
    v_Filial_Id                number := Ui.Filial_Id;
    v_Book_Type_Id             number := Hpr_Util.Book_Type_Id(i_Company_Id => v_Company_Id,
                                                               i_Pcode      => Hpr_Pref.c_Pcode_Book_Type_Wage);
    v_Oper_Group_Id            number := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                                i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    v_Oper_Type_Ids            Array_Number;
    v_Summ_Wage                number := 0;
    v_Wage_Accrual             number;
    v_Other_Accrual            number;
    v_Income_Tax               number;
    v_Pension_Payment          number;
    v_Other_Deduction          number;
    v_Penalty_For_Late         number;
    v_Penalty_For_Early_Output number;
    v_Penalty_For_Absence      number;
    v_Penalty_For_Day_Skip     number;
    v_Credit                   number;
    v_Advance_Payment          number;
    v_Payment                  number;
    v_Social_Payment           number;
    v_Trans_Id                 number;
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    a                b_Table;
    v_Split_Vertical number := 5;
    v_Column         number := 1;
    v_Calc           Calc := Calc();
    v_Nls_Language   varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number := null
    ) is
    begin
      a.Data(i_Val => i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
    
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
      
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Put
    (
      i_Val        number,
      i_Style_Name varchar2 := null,
      i_Colspan    number := null,
      i_Rowspan    number := null
    ) is
    begin
      a.Data(i_Val        => Uit_Href.Num_To_Char(Nvl(i_Val, 0)),
             i_Style_Name => i_Style_Name,
             i_Colspan    => i_Colspan,
             i_Rowspan    => i_Rowspan);
    end;
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    a := b_Report.New_Table();
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    -- body middle left
    b_Report.New_Style(i_Style_Name        => 'body_middle_left',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Left,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    -- body middle right
    b_Report.New_Style(i_Style_Name        => 'body_middle_right',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Right,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    -- body middle right bold
    b_Report.New_Style(i_Style_Name        => 'body_middle_right_bold',
                       i_Parent_Style_Name => 'body_middle_right',
                       i_Font_Bold         => true);
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => v_Company_Id,
                                       i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id,
                                                                              i_Filial_Id  => v_Filial_Id));
  
    if not Fazo.Is_Empty(v_Division_Ids) then
      -- division names
      select q.Name
        bulk collect
        into v_Names
        from Mhr_Divisions q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Division_Id in (select *
                                 from table(v_Division_Ids));
    else
      v_Division_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Job_Ids) then
      v_Job_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Staff_Ids) then
      v_Staff_Ids := null;
    end if;
  
    -- info
    a.New_Row();
    a.Data(t('payroll book for $1{month_year}',
             to_char(v_Begin_Date, 'fmMonth yyyy', v_Nls_Language)),
           i_Colspan => 4);
    a.New_Row();
  
    if not Fazo.Is_Empty(v_Names) then
      a.Data(t('divisions: $1{division_names}', Fazo.Gather(Nvl(v_Names, Array_Varchar2()), ', ')));
      v_Split_Vertical := v_Split_Vertical + 1;
    end if;
  
    -- header
    a.Current_Style('header');
    a.New_Row();
    a.New_Row();
  
    Print_Header(t('order no'), 1, 2, 50);
    Print_Header(t('staff number'), 1, 2, 100);
    Print_Header(t('staff name'), 1, 2, 200);
    Print_Header(t('npin'), 1, 2, 100);
    Print_Header(t('tin'), 1, 2, 100);
    Print_Header(t('iapa'), 1, 2, 150);
    Print_Header(t('job name'), 1, 2, 150);
    Print_Header(t('rank name'), 1, 2, 150);
    Print_Header(t('wage, $1{currency}', r_Currency.Decimal_Name), 1, 2, 200);
    Print_Header(t('planned wage, $1{currency}', r_Currency.Decimal_Name), 1, 2, 200);
    Print_Header(t('turnout'), 2, 1, 100);
    Print_Header(t('initial balance'), 1, 2, 100);
    Print_Header(t('accrued, $1{currency}', r_Currency.Decimal_Name), 3, 1, 150);
    Print_Header(t('deducted, $1{currency}', r_Currency.Decimal_Name), 9, 1, 150);
    Print_Header(t('payment, $1{currency}', r_Currency.Decimal_Name), 3, 1, 150);
    Print_Header(t('final balance'), 1, 2, 150);
    Print_Header(t('social payment'), 1, 2, 150);
    Print_Header(t('given year income'), 1, 2, 150);
    Print_Header(t('given year income tax'), 1, 2, 150);
    Print_Header(t('given year social payment'), 1, 2, 150);
  
    -- sub cells
    a.New_Row;
    Print_Header(t('days'), 1, 1);
    Print_Header(t('hours'), 1, 1);
    Print_Header(t('wage accrual'), 1, 1);
    Print_Header(t('other accrual'), 1, 1);
    Print_Header(t('total accrual'), 1, 1);
    Print_Header(t('income tax'), 1, 1);
    Print_Header(t('pension payment'), 1, 1);
    Print_Header(t('other deduction'), 1, 1);
    Print_Header(t('penalty for late'), 1, 1);
    Print_Header(t('penalty for early output'), 1, 1);
    Print_Header(t('penalty for absence'), 1, 1);
    Print_Header(t('penalty for day skip'), 1, 1);
    Print_Header(t('credit'), 1, 1);
    Print_Header(t('total deduction'), 1, 1);
    Print_Header(t('advance payment'), 1, 1);
    Print_Header(t('other payments'), 1, 1);
    Print_Header(t('total payment'), 1, 1);
  
    -- body
    a.Current_Style('body_middle_right');
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    -- employee ids and names
    select distinct q.Employee_Id,
                    (select Mp.Name
                       from Md_Persons Mp
                      where Mp.Company_Id = q.Company_Id
                        and Mp.Person_Id = q.Employee_Id) name
      bulk collect
      into v_Employee_Ids, v_Names
      from Href_Staffs q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= v_End_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Begin_Date)
       and State = 'A'
       and (v_Staff_Ids is null or
           q.Staff_Id in (select *
                             from table(v_Staff_Ids)))
       and (v_Division_Ids is null or
           Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => q.Company_Id,
                                             i_Filial_Id  => q.Filial_Id,
                                             i_Staff_Id   => q.Staff_Id,
                                             i_Period     => Least(v_End_Date,
                                                                   Nvl(q.Dismissal_Date, v_End_Date))) in
           (select *
               from table(v_Division_Ids)))
       and (v_Job_Ids is null or
           Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                        i_Filial_Id  => q.Filial_Id,
                                        i_Staff_Id   => q.Staff_Id,
                                        i_Period     => Least(v_End_Date,
                                                              Nvl(q.Dismissal_Date, v_End_Date))) in
           (select *
               from table(v_Job_Ids)))
       and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
           q.Division_Id member of v_Subordinate_Divisions)
     order by name;
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      v_Summ_Wage := 0;
    
      if not z_Href_Staffs.Exist(i_Company_Id => v_Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                                                i_Filial_Id   => v_Filial_Id,
                                                                                i_Employee_Id => v_Employee_Ids(i),
                                                                                i_Date        => v_End_Date),
                                 o_Row        => r_Staff) then
        select q.*
          into r_Staff
          from Href_Staffs q
         where q.Company_Id = v_Company_Id
           and q.Filial_Id = v_Filial_Id
           and q.Employee_Id = v_Employee_Ids(i)
           and q.Hiring_Date <= v_End_Date
           and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Begin_Date)
           and q.State = 'A'
         order by q.Hiring_Date
         fetch first row only;
      end if;
    
      v_Accrual := Mkr_Account.Payroll_Accrual(i_Company_Id                   => r_Staff.Company_Id,
                                               i_Filial_Id                    => r_Staff.Filial_Id,
                                               i_Currency_Id                  => r_Currency.Currency_Id,
                                               i_Person_Id                    => r_Staff.Employee_Id,
                                               i_Payroll_Accrual_Condition_Id => Mkr_Pref.c_Pc_Free);
      v_Advance := Mkr_Account.Payroll_Advance(i_Company_Id  => r_Staff.Company_Id,
                                               i_Filial_Id   => r_Staff.Filial_Id,
                                               i_Currency_Id => r_Currency.Currency_Id,
                                               i_Person_Id   => r_Staff.Employee_Id);
    
      v_Desired_Date := Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date));
    
      r_Person_Details := z_Href_Person_Details.Take(i_Company_Id => r_Staff.Company_Id,
                                                     i_Person_Id  => r_Staff.Employee_Id);
    
      a.New_Row();
      a.Data(i_Val => i, i_Style_Name => 'body_centralized');
      a.Data(i_Val => r_Staff.Staff_Number, i_Style_Name => 'body_centralized');
      a.Data(i_Val => v_Names(i), i_Style_Name => 'body_middle_left');
      a.Data(i_Val => r_Person_Details.Npin, i_Style_Name => 'body_centralized');
      a.Data(i_Val        => z_Mr_Person_Details.Take(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Tin,
             i_Style_Name => 'body_centralized');
      a.Data(i_Val => r_Person_Details.Iapa, i_Style_Name => 'body_centralized');
      a.Data(i_Val        => z_Mhr_Jobs.Load(i_Company_Id => r_Staff.Company_Id, --
                             i_Filial_Id => r_Staff.Filial_Id, --
                             i_Job_Id => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Staff.Company_Id, --
                             i_Filial_Id => r_Staff.Filial_Id, --
                             i_Staff_Id => r_Staff.Staff_Id, --
                             i_Period => v_Desired_Date)).Name,
             i_Style_Name => 'body_middle_left');
      a.Data(i_Val        => z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, --
                             i_Filial_Id => r_Staff.Filial_Id, --
                             i_Rank_Id => Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Staff.Company_Id, --
                             i_Filial_Id => r_Staff.Filial_Id, --
                             i_Staff_Id => r_Staff.Staff_Id, --
                             i_Period => v_Desired_Date)).Name,
             i_Style_Name => 'body_middle_left');
    
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => r_Staff.Company_Id,
                                                i_Filial_Id  => r_Staff.Filial_Id,
                                                i_Staff_Id   => r_Staff.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => v_Desired_Date);
    
      Put(Mk_Util.Calc_Amount_Base(i_Company_Id  => r_Staff.Company_Id,
                                   i_Filial_Id   => r_Staff.Filial_Id,
                                   i_Currency_Id => Get_Closest_Currency_Id(i_Company_Id => r_Staff.Company_Id,
                                                                            i_Filial_Id  => r_Staff.Filial_Id,
                                                                            i_Staff_Id   => r_Staff.Staff_Id,
                                                                            i_Period     => v_Desired_Date),
                                   i_Rate_Date   => v_Desired_Date,
                                   i_Amount      => Hpd_Util.Get_Closest_Wage(i_Company_Id => r_Staff.Company_Id,
                                                                              i_Filial_Id  => r_Staff.Filial_Id,
                                                                              i_Staff_Id   => r_Staff.Staff_Id,
                                                                              i_Period     => v_Desired_Date)));
    
      for Agr in (select Qr.Period Period_Begin,
                         Nvl(Lead(Qr.Period - 1) Over(order by Qr.Period), v_Desired_Date) Period_End
                    from (select p.Period
                            from Hpd_Agreements p
                           where p.Company_Id = r_Staff.Company_Id
                             and p.Filial_Id = r_Staff.Filial_Id
                             and p.Staff_Id = r_Staff.Staff_Id
                             and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Operation
                             and p.Period > v_Begin_Date
                             and p.Period <= v_Desired_Date
                          union
                          select Greatest(max(p.Period), v_Begin_Date)
                            from Hpd_Agreements p
                           where p.Company_Id = r_Staff.Company_Id
                             and p.Filial_Id = r_Staff.Filial_Id
                             and p.Staff_Id = r_Staff.Staff_Id
                             and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Operation
                             and p.Period <= v_Begin_Date) Qr)
      loop
        v_Oper_Type_Ids := Hpd_Util.Get_Closest_Oper_Type_Ids(i_Company_Id    => r_Staff.Company_Id,
                                                              i_Filial_Id     => r_Staff.Filial_Id,
                                                              i_Staff_Id      => r_Staff.Staff_Id,
                                                              i_Oper_Group_Id => v_Oper_Group_Id,
                                                              i_Period        => Agr.Period_End);
      
        for i in 1 .. v_Oper_Type_Ids.Count
        loop
          v_Summ_Wage := v_Summ_Wage + Hpr_Util.Calc_Amount(i_Company_Id   => r_Staff.Company_Id,
                                                            i_Filial_Id    => r_Staff.Filial_Id,
                                                            i_Staff_Id     => r_Staff.Staff_Id,
                                                            i_Oper_Type_Id => v_Oper_Type_Ids(i),
                                                            i_Part_Begin   => Agr.Period_Begin,
                                                            i_Part_End     => Agr.Period_End,
                                                            i_Calc_Worked  => true);
        end loop;
      end loop;
    
      Put(v_Summ_Wage);
    
      v_Timebook_Staff_Info := Uit_Hpr.Get_Timebook_Staff(i_Month    => v_Begin_Date,
                                                          i_Staff_Id => r_Staff.Staff_Id);
    
      a.Data(i_Val => Nvl(v_Timebook_Staff_Info.Fact_Days, 0), i_Style_Name => 'body_centralized');
      a.Data(i_Val => Nvl(v_Timebook_Staff_Info.Fact_Hours, 0), i_Style_Name => 'body_centralized');
    
      v_Acc_Balance := Mk_Util.Balance(i_Company_Id => r_Staff.Company_Id,
                                       i_Filial_Id  => r_Staff.Filial_Id,
                                       i_Period     => v_Begin_Date,
                                       i_Account    => v_Accrual);
      v_Adv_Balance := Mk_Util.Balance(i_Company_Id => r_Staff.Company_Id,
                                       i_Filial_Id  => r_Staff.Filial_Id,
                                       i_Period     => v_Begin_Date,
                                       i_Account    => v_Advance);
    
      Put(v_Acc_Balance.Amount + v_Adv_Balance.Amount);
      v_Calc.Plus('initial_balance', v_Acc_Balance.Amount + v_Adv_Balance.Amount);
    
      select sum(Decode(Oper.Is_Wage || Oper.Operation_Kind,
                        'Y' || Mpr_Pref.c_Ok_Accrual,
                        Oper.Amount,
                        0)),
             sum(Decode(Oper.Is_Wage || Oper.Operation_Kind,
                        'N' || Mpr_Pref.c_Ok_Accrual,
                        Oper.Amount,
                        0)),
             sum(Oper.Income_Tax_Amount),
             sum(Oper.Pension_Payment_Amount),
             sum(Decode(Oper.Operation_Kind, Mpr_Pref.c_Ok_Accrual, 0, Oper.Amount)),
             sum(Oper.Penalty_For_Late),
             sum(Oper.Penalty_For_Early_Output),
             sum(Oper.Penalty_For_Absence),
             sum(Oper.Penalty_For_Day_Skip),
             sum(Oper.Social_Payment_Amount)
        into v_Wage_Accrual,
             v_Other_Accrual,
             v_Income_Tax,
             v_Pension_Payment,
             v_Other_Deduction,
             v_Penalty_For_Late,
             v_Penalty_For_Early_Output,
             v_Penalty_For_Absence,
             v_Penalty_For_Day_Skip,
             v_Social_Payment
        from (select q.Amount_Base Amount,
                     (select s.Indicator_Value
                        from Hpr_Charge_Indicators s
                       where s.Company_Id = k.Company_Id
                         and s.Filial_Id = k.Filial_Id
                         and s.Charge_Id = k.Charge_Id
                         and s.Indicator_Id =
                             Href_Util.Indicator_Id(i_Company_Id => k.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Penalty_For_Late)) Penalty_For_Late,
                     (select s.Indicator_Value
                        from Hpr_Charge_Indicators s
                       where s.Company_Id = k.Company_Id
                         and s.Filial_Id = k.Filial_Id
                         and s.Charge_Id = k.Charge_Id
                         and s.Indicator_Id =
                             Href_Util.Indicator_Id(i_Company_Id => k.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output)) Penalty_For_Early_Output,
                     (select s.Indicator_Value
                        from Hpr_Charge_Indicators s
                       where s.Company_Id = k.Company_Id
                         and s.Filial_Id = k.Filial_Id
                         and s.Charge_Id = k.Charge_Id
                         and s.Indicator_Id =
                             Href_Util.Indicator_Id(i_Company_Id => k.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Penalty_For_Absence)) Penalty_For_Absence,
                     (select s.Indicator_Value
                        from Hpr_Charge_Indicators s
                       where s.Company_Id = k.Company_Id
                         and s.Filial_Id = k.Filial_Id
                         and s.Charge_Id = k.Charge_Id
                         and s.Indicator_Id =
                             Href_Util.Indicator_Id(i_Company_Id => k.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip)) Penalty_For_Day_Skip,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Income_Tax_Amount) Income_Tax_Amount,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Pension_Payment_Amount) Pension_Payment_Amount,
                     Mk_Util.Calc_Amount_Base(i_Company_Id  => w.Company_Id,
                                              i_Filial_Id   => w.Filial_Id,
                                              i_Currency_Id => w.Currency_Id,
                                              i_Rate_Date   => w.Book_Date,
                                              i_Amount      => q.Social_Payment_Amount) Social_Payment_Amount,
                     Nvl((select 'Y'
                           from Hpr_Books Hb
                          where Hb.Company_Id = q.Company_Id
                            and Hb.Filial_Id = q.Filial_Id
                            and Hb.Book_Id = q.Book_Id
                            and Hb.Book_Type_Id = v_Book_Type_Id),
                         'N') as Is_Wage,
                     (select Ot.Operation_Kind
                        from Mpr_Oper_Types Ot
                       where Ot.Company_Id = q.Company_Id
                         and Ot.Oper_Type_Id = q.Oper_Type_Id) as Operation_Kind
                from Mpr_Book_Operations q
                join Mpr_Books w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Book_Id = q.Book_Id
                left join Hpr_Book_Operations k
                  on k.Company_Id = q.Company_Id
                 and k.Filial_Id = q.Filial_Id
                 and k.Book_Id = q.Book_Id
                 and k.Operation_Id = q.Operation_Id
               where q.Company_Id = r_Staff.Company_Id
                 and q.Filial_Id = r_Staff.Filial_Id
                 and q.Employee_Id = r_Staff.Employee_Id
                 and w.Posted = 'Y'
                 and w.Month between v_Begin_Date and v_End_Date) Oper;
    
      v_Wage_Accrual    := Nvl(v_Wage_Accrual, 0);
      v_Other_Accrual   := Nvl(v_Other_Accrual, 0);
      v_Income_Tax      := Nvl(v_Income_Tax, 0);
      v_Other_Deduction := Nvl(v_Other_Deduction, 0);
      v_Credit          := Hpr_Util.Calc_Employee_Credit(i_Company_Id  => r_Staff.Company_Id,
                                                         i_Filial_Id   => r_Staff.Filial_Id,
                                                         i_Employee_Id => r_Staff.Employee_Id,
                                                         i_Month       => Trunc(v_Begin_Date, 'mon'));
    
      Put(v_Wage_Accrual);
      Put(v_Other_Accrual);
      Put(v_Wage_Accrual + v_Other_Accrual); -- total_accrual
      Put(v_Income_Tax);
      Put(v_Pension_Payment);
      Put(v_Other_Deduction);
      Put(v_Penalty_For_Late);
      Put(v_Penalty_For_Early_Output);
      Put(v_Penalty_For_Absence);
      Put(v_Penalty_For_Day_Skip);
      Put(v_Credit);
      Put(v_Income_Tax + v_Other_Deduction + v_Credit); -- total_deduction
    
      v_Calc.Plus('wage_accrual', v_Wage_Accrual);
      v_Calc.Plus('other_accrual', v_Other_Accrual);
      v_Calc.Plus('total_accrual', v_Wage_Accrual + v_Other_Accrual);
      v_Calc.Plus('income_tax', v_Income_Tax);
      v_Calc.Plus('pension_payment', v_Pension_Payment);
      v_Calc.Plus('other_deduction', v_Other_Deduction);
      v_Calc.Plus('penalty_for_late', v_Penalty_For_Late);
      v_Calc.Plus('penalty_for_early_output', v_Penalty_For_Early_Output);
      v_Calc.Plus('penalty_for_absence', v_Penalty_For_Absence);
      v_Calc.Plus('penalty_for_day_skip', v_Penalty_For_Day_Skip);
      v_Calc.Plus('credit', v_Credit);
      v_Calc.Plus('total_deduction', v_Income_Tax + v_Other_Deduction + v_Credit);
    
      select Nvl(sum(q.Pay_Amount_Base), 0)
        into v_Advance_Payment
        from Mpr_Payment_Employees q
        join Mpr_Payments Mp
          on Mp.Company_Id = q.Company_Id
         and Mp.Filial_Id = q.Filial_Id
         and Mp.Payment_Id = q.Payment_Id
         and Mp.Status in (Mpr_Pref.c_Ps_Completed, --
                           Mpr_Pref.c_Ps_Archived)
         and Mp.Payment_Kind = Mpr_Pref.c_Pk_Advance
         and q.Filial_Id = r_Staff.Filial_Id
         and q.Employee_Id = r_Staff.Employee_Id
         and q.Paid = 'Y'
         and Trunc(q.Paid_Date, 'Mon') = v_Begin_Date;
    
      select Nvl(sum(q.Pay_Amount_Base), 0)
        into v_Payment
        from Mpr_Payment_Employees q
        join Mpr_Payments Mp
          on Mp.Company_Id = q.Company_Id
         and Mp.Filial_Id = q.Filial_Id
         and Mp.Payment_Id = q.Payment_Id
         and Mp.Status in (Mpr_Pref.c_Ps_Completed, --
                           Mpr_Pref.c_Ps_Archived)
         and Mp.Payment_Kind = Mpr_Pref.c_Pk_Payroll
         and q.Filial_Id = r_Staff.Filial_Id
         and q.Employee_Id = r_Staff.Employee_Id
         and q.Paid = 'Y'
         and Trunc(q.Paid_Date, 'Mon') = v_Begin_Date;
    
      Put(v_Advance_Payment);
      Put(v_Payment);
      Put(v_Payment + v_Advance_Payment);
    
      v_Calc.Plus('advance_payment', v_Advance_Payment);
      v_Calc.Plus('other_payment', v_Payment);
      v_Calc.Plus('payment', v_Payment + v_Advance_Payment);
    
      Put(v_Wage_Accrual + v_Other_Accrual - (v_Income_Tax + v_Other_Deduction) - v_Payment);
      Put(v_Social_Payment);
    
      v_Calc.Plus('final_balance',
                  v_Wage_Accrual + v_Other_Accrual - (v_Income_Tax + v_Other_Deduction) - v_Payment);
      v_Calc.Plus('social_payment', v_Social_Payment);
    
      select sum(q.Amount_Base),
             sum(Mk_Util.Calc_Amount_Base(i_Company_Id  => Mb.Company_Id,
                                          i_Filial_Id   => Mb.Filial_Id,
                                          i_Currency_Id => Mb.Currency_Id,
                                          i_Rate_Date   => Mb.Book_Date,
                                          i_Amount      => q.Income_Tax_Amount)),
             sum(Mk_Util.Calc_Amount_Base(i_Company_Id  => Mb.Company_Id,
                                          i_Filial_Id   => Mb.Filial_Id,
                                          i_Currency_Id => Mb.Currency_Id,
                                          i_Rate_Date   => Mb.Book_Date,
                                          i_Amount      => q.Social_Payment_Amount))
        into v_Wage_Accrual, v_Income_Tax, v_Social_Payment
        from Mpr_Book_Operations q
        join Mpr_Books Mb
          on Mb.Company_Id = q.Company_Id
         and Mb.Filial_Id = q.Filial_Id
         and Mb.Book_Id = q.Book_Id
         and Mb.Posted = 'Y'
         and Mb.Month between v_Begin_Year and v_End_Date
       where q.Company_Id = r_Staff.Company_Id
         and q.Filial_Id = r_Staff.Filial_Id
         and q.Employee_Id = r_Staff.Employee_Id
         and exists (select 1
                from Mpr_Oper_Types Ot
               where Ot.Company_Id = q.Company_Id
                 and Ot.Oper_Type_Id = q.Oper_Type_Id
                 and Ot.Operation_Kind = Mpr_Pref.c_Ok_Accrual);
    
      Put(v_Wage_Accrual); -- given_year_income
      Put(v_Income_Tax); -- given_year_income_tax
      Put(v_Social_Payment); -- given_year_social_payment
    
      v_Calc.Plus('given_year_income', v_Wage_Accrual);
      v_Calc.Plus('given_year_income_tax', v_Income_Tax);
      v_Calc.Plus('given_year_social_payment', v_Social_Payment);
    end loop;
  
    -- body total
    a.Current_Style('body_middle_right_bold');
    a.New_Row();
    a.Add_Data(11);
    a.Data(t('total:'));
  
    Put(v_Calc.Get_Value('initial_balance'));
    Put(v_Calc.Get_Value('wage_accrual'));
    Put(v_Calc.Get_Value('other_accrual'));
    Put(v_Calc.Get_Value('total_accrual'));
    Put(v_Calc.Get_Value('income_tax'));
    Put(v_Calc.Get_Value('pension_payment'));
    Put(v_Calc.Get_Value('other_deduction'));
    Put(v_Calc.Get_Value('penalty_for_late'));
    Put(v_Calc.Get_Value('penalty_for_early_output'));
    Put(v_Calc.Get_Value('penalty_for_absence'));
    Put(v_Calc.Get_Value('penalty_for_day_skip'));
    Put(v_Calc.Get_Value('credit'));
    Put(v_Calc.Get_Value('total_deduction'));
    Put(v_Calc.Get_Value('advance_payment'));
    Put(v_Calc.Get_Value('other_payment'));
    Put(v_Calc.Get_Value('payment'));
    Put(v_Calc.Get_Value('final_balance'));
    Put(v_Calc.Get_Value('social_payment'));
    Put(v_Calc.Get_Value('given_year_income'));
    Put(v_Calc.Get_Value('given_year_income_tax'));
    Put(v_Calc.Get_Value('given_year_social_payment'));
  
    b_Report.Add_Sheet(i_Name             => t('payroll book'),
                       p_Table            => a,
                       i_Split_Horizontal => 7,
                       i_Split_Vertical   => v_Split_Vertical);
    b_Report.Close_Book();
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
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Job_Id      = null,
           Division_Id = null;
    Uie.x(Hpd_Util.Get_Closest_Division_Id(null, null, null, null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(null, null, null, null));
  end;

end Ui_Vhr217;
/
