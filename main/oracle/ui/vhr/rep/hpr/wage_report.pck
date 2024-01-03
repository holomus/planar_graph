create or replace package Ui_Vhr322 is
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr322;
/
create or replace package body Ui_Vhr322 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr322:settings';

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
    return b.Translate('UI-VHR322:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data', Fazo.Zip_Map('month', to_char(sysdate, Href_Pref.c_Date_Format_Month)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Matrix Matrix_Varchar2;
    v_Month  date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    q        Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs w
                  where w.company_id = :company_id
                  and w.filial_id = :filial_id
                  and w.hiring_date <= :max_date
                  and (w.dismissal_date is null or
                      w.dismissal_date >= :min_date)
                  and w.state = ''A''
                  and exists (select 1
                         from mhr_employees e
                        where e.company_id = w.company_id
                          and e.filial_id = w.filial_id
                          and e.employee_id = w.employee_id
                          and e.state = ''A'')';
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'min_date',
                                 Trunc(v_Month, 'mon'),
                                 'max_date',
                                 Last_Day(v_Month)));
    q.Number_Field('employee_id', 'staff_id', 'division_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    v_Matrix := Href_Util.Staff_Kinds;
  
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('name',
                'select q.name
                  from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Wage
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Staff_Number    varchar2(1) := Nvl(v_Settings.o_Varchar2('staff_number'), 'N');
    v_Show_Bonus           boolean := Nvl(v_Settings.o_Varchar2('bonus'), 'N') = 'Y';
    v_Show_Onetime_Sheets  boolean := Nvl(v_Settings.o_Varchar2('onetime_sheets'), 'N') = 'Y';
    v_Show_Onetime_Accrual boolean := Nvl(v_Settings.o_Varchar2('onetime_accrual'), 'N') = 'Y' and
                                      v_Show_Onetime_Sheets;
    v_Show_Onetime_Penalty boolean := Nvl(v_Settings.o_Varchar2('onetime_penalty'), 'N') = 'Y' and
                                      v_Show_Onetime_Sheets;
    v_Show_Overtime        boolean := Nvl(v_Settings.o_Varchar2('overtime'), 'N') = 'Y';
    v_Show_Wage            boolean := Nvl(v_Settings.o_Varchar2('wage'), 'N') = 'Y';
    v_Show_Lateness        boolean := Nvl(v_Settings.o_Varchar2('lateness'), 'N') = 'Y';
    v_Show_Lack            boolean := Nvl(v_Settings.o_Varchar2('lack'), 'N') = 'Y';
    v_Show_Early_Check_Out boolean := Nvl(v_Settings.o_Varchar2('early_check_out'), 'N') = 'Y';
    v_Show_Skip_Day        boolean := Nvl(v_Settings.o_Varchar2('skip_day'), 'N') = 'Y';
    v_Show_Skip_Mark       boolean := Nvl(v_Settings.o_Varchar2('skip_mark'), 'N') = 'Y';
    v_Show_Accruals        boolean := v_Show_Skip_Mark or v_Show_Skip_Day or v_Show_Early_Check_Out or
                                      v_Show_Lack or v_Show_Lateness or v_Show_Wage or
                                      v_Show_Overtime;
  
    v_Show_Division boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Job      boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Schedule boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Fte      boolean := Nvl(v_Settings.o_Varchar2('fte'), 'N') = 'Y';
  
    v_Accrual_Count   number;
    v_Deduction_Count number;
    v_Division_Count  number := i_Division_Ids.Count;
    v_Division_Names  Array_Varchar2;
    v_Staff_Count     number := i_Staff_Ids.Count;
  
    a               b_Table := b_Report.New_Table();
    v_Column        number := 1;
    v_Total_Colspan number := 0;
    v_Part_Begin    date;
    v_Part_End      date;
    v_Plan_Sum      number := 0;
    v_Wage_Sum      number := 0;
    v_Overtime_Sum  number := 0;
    v_Late_Sum      number := 0;
    v_Early_Sum     number := 0;
    v_Lack_Sum      number := 0;
    v_Day_Skip_Sum  number := 0;
    v_Mark_Skip_Sum number := 0;
    v_Penalty_Sum   number := 0;
    v_Amount_Sum    number := 0;
  
    v_Plan_Bonus         number := 0;
    v_Plan_Extra         number := 0;
    v_Fact_Bonus         number := 0;
    v_Fact_Extra         number := 0;
    v_Fact_Bonus_Percent number := 0;
    v_Fact_Extra_Percent number := 0;
    v_Onetime_Accrual    number := 0;
    v_Onetime_Penalty    number := 0;
    v_Onetime_Total      number := 0;
    v_Plan_Total         number := 0;
    v_Fact_Total         number := 0;
    v_Penalty_Total      number := 0;
    v_Total              number := 0;
    v_Bonused_Total      number := 0;
  
    v_Calc Calc := Calc();
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Divisions Array_Number := Array_Number();
    v_Nls_Language          varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Function Print_Amount(i_Amount number) return number is
    begin
      return Nullif(i_Amount, 0);
    end;
  
    -------------------------------------------------- 
    Procedure Print_Header
    (
      i_Name          varchar2,
      i_Colspan       number,
      i_Rowspan       number,
      i_Column_Width  number,
      i_Total_Colspan boolean := false
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
    
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    
      if i_Total_Colspan then
        v_Total_Colspan := v_Total_Colspan + i_Colspan;
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      if v_Division_Count <> 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Division_Names
          from Mhr_Divisions d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Division_Id member of i_Division_Ids;
      
        a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
      end if;
    
      a.New_Row;
      a.Data(t('period: $1 - $2',
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => 5);
      a.New_Row;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Header is
      --------------------------------------------------       
      Function Num(i_Bool boolean) return number is
      begin
        return case when i_Bool then 1 else 0 end;
      end;
    begin
      v_Accrual_Count := Num(v_Show_Onetime_Accrual) + Num(v_Show_Wage) + Num(v_Show_Overtime);
    
      v_Deduction_Count := Num(v_Show_Onetime_Penalty) + Num(v_Show_Lateness) + Num(v_Show_Lack) +
                           Num(v_Show_Early_Check_Out) + Num(v_Show_Skip_Day) +
                           Num(v_Show_Skip_Mark);
    
      a.Current_Style('header');
    
      a.New_Row;
      Print_Header(t('rownum'), 1, 2, 50, true);
    
      if v_Show_Staff_Number = 'Y' then
        Print_Header(t('staff number'), 1, 2, 100, true);
      end if;
    
      Print_Header(t('staff_name'), 1, 2, 250, true);
    
      if v_Show_Division then
        Print_Header(t('division'), 1, 2, 100, true);
      end if;
    
      if v_Show_Job then
        Print_Header(t('job'), 1, 2, 100, true);
      end if;
    
      if v_Show_Schedule then
        Print_Header(t('schedule'), 1, 2, 100, true);
      end if;
    
      if v_Show_Fte then
        Print_Header(t('type'), 1, 2, 100, true);
      end if;
    
      if v_Show_Bonus then
        Print_Header(t('plan'), 4, 1, 100);
      else
        Print_Header(t('plan'), 1, 2, 100);
      end if;
    
      Print_Header(t('fact'), v_Accrual_Count + 1, 1, 100);
      Print_Header(t('penalty'), v_Deduction_Count + 1, 1, 100);
      Print_Header(t('salary'), 1, 2, 100);
    
      if v_Show_Bonus then
        Print_Header(t('bonus'), 2, 1, 100);
        Print_Header(t('extra bonus'), 2, 1, 100);
        Print_Header(t('total'), 1, 2, 100);
      end if;
    
      a.New_Row;
    
      if v_Show_Bonus then
        Print_Header(t('plan amount'), 1, 1, 100);
        Print_Header(t('bonus amount'), 1, 1, 100);
        Print_Header(t('extra bonus'), 1, 1, 100);
        Print_Header(t('total'), 1, 1, 100);
      end if;
    
      if v_Show_Wage then
        Print_Header(t('wage amount'), 1, 1, 100);
      end if;
    
      if v_Show_Overtime then
        Print_Header(t('over time amount'), 1, 1, 100);
      end if;
    
      if v_Show_Onetime_Accrual then
        Print_Header(t('onetime_accrual'), 1, 1, 100);
      end if;
    
      Print_Header(t('total'), 1, 1, 100);
    
      if v_Show_Lateness then
        Print_Header(t('late amount'), 1, 1, 100);
      end if;
    
      if v_Show_Early_Check_Out then
        Print_Header(t('early amount'), 1, 1, 100);
      end if;
    
      if v_Show_Lack then
        Print_Header(t('lack amount'), 1, 1, 100);
      end if;
    
      if v_Show_Skip_Day then
        Print_Header(t('day_skip_amount'), 1, 1, 100);
      end if;
    
      if v_Show_Skip_Mark then
        Print_Header(t('mark_skip_amount'), 1, 1, 100);
      end if;
    
      if v_Show_Onetime_Penalty then
        Print_Header(t('onetime_penalty'), 1, 1, 100);
      end if;
    
      Print_Header(t('total'), 1, 1, 100);
    
      if v_Show_Bonus then
        Print_Header(t('percent'), 1, 1, 100);
        Print_Header(t('amount'), 1, 1, 100);
      
        Print_Header(t('percent'), 1, 1, 100);
        Print_Header(t('amount'), 1, 1, 100);
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Footer is
      v_Plan_Amount      number := v_Calc.Get_Value('plan_amount');
      v_Plan_Bonus       number := v_Calc.Get_Value('plan_bonus');
      v_Plan_Extra       number := v_Calc.Get_Value('plan_extra');
      v_Wage_Amount      number := v_Calc.Get_Value('wage_amount');
      v_Overtime_Amount  number := v_Calc.Get_Value('overtime_amount');
      v_Late_Amount      number := v_Calc.Get_Value('late_amount');
      v_Early_Amount     number := v_Calc.Get_Value('early_amount');
      v_Lack_Amount      number := v_Calc.Get_Value('lack_amount');
      v_Day_Skip_Amount  number := v_Calc.Get_Value('day_skip_amount');
      v_Mark_Skip_Amount number := v_Calc.Get_Value('mark_skip_amount');
      v_Fact_Bonus       number := v_Calc.Get_Value('fact_bonus');
      v_Fact_Extra       number := v_Calc.Get_Value('fact_extra');
      v_Onetime_Accrual  number := v_Calc.Get_Value('onetime_accrual');
      v_Onetime_Penalty  number := v_Calc.Get_Value('onetime_penalty');
    
      v_Plan_Total    number := v_Plan_Amount + v_Plan_Bonus + v_Plan_Extra;
      v_Fact_Total    number := v_Wage_Amount + v_Overtime_Amount + v_Onetime_Accrual;
      v_Penalty_Total number := v_Late_Amount + v_Early_Amount + v_Lack_Amount + v_Day_Skip_Amount +
                                v_Mark_Skip_Amount + v_Onetime_Penalty;
      v_Salary_Total  number := v_Fact_Total - v_Penalty_Total;
      v_Wage_Total    number := v_Salary_Total + v_Fact_Bonus + v_Fact_Extra;
    begin
      a.Current_Style('footer');
    
      a.New_Row;
      a.Data(t('total'), 'footer right', i_Colspan => v_Total_Colspan);
    
      a.Data(Print_Amount(v_Plan_Amount), 'footer right');
    
      -- bonus plan
      if v_Show_Bonus then
        a.Data(Print_Amount(v_Plan_Bonus), 'footer right');
        a.Data(Print_Amount(v_Plan_Extra), 'footer right');
        a.Data(Print_Amount(v_Plan_Total), 'footer right');
      end if;
    
      -- accrual
      if v_Show_Wage then
        a.Data(Print_Amount(v_Wage_Amount), 'footer right');
      end if;
    
      if v_Show_Overtime then
        a.Data(Print_Amount(v_Overtime_Amount), 'footer right');
      end if;
    
      if v_Show_Onetime_Accrual then
        a.Data(Print_Amount(v_Onetime_Accrual), 'footer right');
      end if;
    
      a.Data(Print_Amount(v_Fact_Total), 'footer right');
    
      -- penalty
      if v_Show_Lateness then
        a.Data(Print_Amount(v_Late_Amount), 'footer right');
      end if;
    
      if v_Show_Early_Check_Out then
        a.Data(Print_Amount(v_Early_Amount), 'footer right');
      end if;
    
      if v_Show_Lack then
        a.Data(Print_Amount(v_Lack_Amount), 'footer right');
      end if;
    
      if v_Show_Skip_Day then
        a.Data(Print_Amount(v_Day_Skip_Amount), 'footer right');
      end if;
    
      if v_Show_Skip_Mark then
        a.Data(Print_Amount(v_Mark_Skip_Amount), 'footer right');
      end if;
    
      if v_Show_Onetime_Penalty then
        a.Data(Print_Amount(v_Onetime_Penalty), 'footer right');
      end if;
    
      a.Data(Print_Amount(v_Penalty_Total), 'footer right');
    
      -- total
      a.Data(Print_Amount(v_Salary_Total), 'footer right');
    
      if v_Show_Bonus then
        -- bonus fact
        a.Data(Print_Amount(v_Fact_Bonus), 'footer right', i_Colspan => 2);
        a.Data(Print_Amount(v_Fact_Extra), 'footer right', i_Colspan => 2);
        a.Data(Print_Amount(v_Wage_Total), 'footer right');
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Amounts
    (
      i_Plan_Amount      number,
      i_Plan_Bonus       number,
      i_Plan_Extra       number,
      i_Wage_Amount      number,
      i_Overtime_Amount  number,
      i_Late_Amount      number,
      i_Early_Amount     number,
      i_Lack_Amount      number,
      i_Day_Skip_Amount  number,
      i_Mark_Skip_Amount number,
      i_Fact_Bonus       number,
      i_Fact_Extra       number,
      i_Onetime_Accrual  number,
      i_Onetime_Penalty  number
    ) is
    begin
      v_Calc.Plus('plan_amount', i_Plan_Amount);
      v_Calc.Plus('plan_bonus', i_Plan_Bonus);
      v_Calc.Plus('plan_extra', i_Plan_Extra);
    
      if v_Show_Wage then
        v_Calc.Plus('wage_amount', i_Wage_Amount);
      end if;
    
      if v_Show_Overtime then
        v_Calc.Plus('overtime_amount', i_Overtime_Amount);
      end if;
    
      if v_Show_Lateness then
        v_Calc.Plus('late_amount', i_Late_Amount);
      end if;
    
      if v_Show_Early_Check_Out then
        v_Calc.Plus('early_amount', i_Early_Amount);
      end if;
    
      if v_Show_Lack then
        v_Calc.Plus('lack_amount', i_Lack_Amount);
      end if;
    
      if v_Show_Skip_Day then
        v_Calc.Plus('day_skip_amount', i_Day_Skip_Amount);
      end if;
    
      if v_Show_Skip_Mark then
        v_Calc.Plus('mark_skip_amount', i_Mark_Skip_Amount);
      end if;
    
      v_Calc.Plus('fact_bonus', i_Fact_Bonus);
      v_Calc.Plus('fact_extra', i_Fact_Extra);
    
      if v_Show_Onetime_Accrual then
        v_Calc.Plus('onetime_accrual', i_Onetime_Accrual);
      end if;
    
      if v_Show_Onetime_Penalty then
        v_Calc.Plus('onetime_penalty', i_Onetime_Penalty);
      end if;
    end;
  begin
    Print_Info;
  
    Print_Header;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                    i_Indirect => true,
                                                                    i_Manual   => true);
    end if;
  
    -- body
    a.Current_Style('body_centralized');
  
    for r in (select Al.*, Rownum Row_Num
                from (select q.*,
                             (select w.Name
                                from Mr_Natural_Persons w
                               where w.Company_Id = i_Company_Id
                                 and w.Person_Id = q.Employee_Id) Staff_Name,
                             (select d.Name
                                from Mhr_Divisions d
                               where d.Company_Id = i_Company_Id
                                 and d.Filial_Id = i_Filial_Id
                                 and d.Division_Id = q.Division_Id) Division_Name,
                             (select j.Name
                                from Mhr_Jobs j
                               where j.Company_Id = i_Company_Id
                                 and j.Filial_Id = i_Filial_Id
                                 and j.Job_Id = q.Job_Id) Job_Name,
                             (select Ft.Name
                                from Href_Ftes Ft
                               where Ft.Company_Id = i_Company_Id
                                 and Ft.Fte_Id = q.Fte_Id) Fte_Name,
                             (select Sc.Name
                                from Htt_Schedules Sc
                               where Sc.Company_Id = i_Company_Id
                                 and Sc.Filial_Id = i_Filial_Id
                                 and Sc.Schedule_Id = q.Schedule_Id) Schedule_Name
                        from Href_Staffs q
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and (v_Staff_Count = 0 or q.Staff_Id member of i_Staff_Ids)
                         and (v_Division_Count = 0 or q.Division_Id member of i_Division_Ids)
                         and (v_Access_All_Employees = 'Y' or --
                             q.Employee_Id = v_User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                         and exists
                       (select 1
                                from Mhr_Employees e
                               where e.Company_Id = q.Company_Id
                                 and e.Filial_Id = q.Filial_Id
                                 and e.Employee_Id = q.Employee_Id
                                 and e.State = 'A')
                         and (exists (select 1
                                        from Hpr_Sheet_Parts w
                                       where w.Company_Id = q.Company_Id
                                         and w.Filial_Id = q.Filial_Id
                                         and w.Staff_Id = q.Staff_Id
                                         and w.Part_Begin >= i_Begin_Date
                                         and w.Part_End <= i_End_Date
                                         and exists (select 1
                                                from Hpr_Wage_Sheets Ws
                                               where Ws.Company_Id = w.Company_Id
                                                 and Ws.Filial_Id = w.Filial_Id
                                                 and Ws.Sheet_Id = w.Sheet_Id
                                                 and Ws.Posted = 'Y')) --
                              or exists (select 1
                                           from Hpr_Onetime_Sheet_Staffs Ss
                                          where Ss.Company_Id = q.Company_Id
                                            and Ss.Filial_Id = q.Filial_Id
                                            and Ss.Staff_Id = q.Staff_Id
                                            and Ss.Month = Trunc(i_Begin_Date, 'mon')
                                            and exists (select 1
                                                   from Hpr_Wage_Sheets Ws
                                                  where Ws.Company_Id = Ss.Company_Id
                                                    and Ws.Filial_Id = Ss.Filial_Id
                                                    and Ws.Sheet_Id = Ss.Sheet_Id
                                                    and Ws.Posted = 'Y')))
                       order by case
                                  when v_Show_Staff_Number = 'Y' then
                                   q.Staff_Number
                                  else
                                   Staff_Name
                                end) Al)
    loop
      v_Fact_Total    := 0;
      v_Plan_Total    := 0;
      v_Penalty_Total := 0;
    
      if v_Show_Bonus then
        select Nvl(sum(t.Main_Plan_Amount), 0),
               Nvl(sum(t.Extra_Plan_Amount), 0),
               Nvl(sum(t.Main_Fact_Amount), 0),
               Nvl(sum(t.Extra_Fact_Amount), 0),
               Nvl(avg(t.Main_Fact_Percent), 0),
               Nvl(avg(t.Extra_Fact_Percent), 0)
          into v_Plan_Bonus,
               v_Plan_Extra,
               v_Fact_Bonus,
               v_Fact_Extra,
               v_Fact_Bonus_Percent,
               v_Fact_Extra_Percent
          from Hper_Staff_Plans t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Staff_Id = r.Staff_Id
           and t.Plan_Date = Trunc(i_Begin_Date, 'mon')
           and t.Status = Hper_Pref.c_Staff_Plan_Status_Completed;
      end if;
    
      if v_Show_Onetime_Sheets then
        select Nvl(sum(p.Accrual_Amount), 0),
               Nvl(sum(p.Penalty_Amount), 0),
               Nvl(sum(p.Total_Amount), 0)
          into v_Onetime_Accrual, --
               v_Onetime_Penalty,
               v_Onetime_Total
          from Hpr_Onetime_Sheet_Staffs p
         where p.Company_Id = i_Company_Id
           and p.Filial_Id = i_Filial_Id
           and p.Staff_Id = r.Staff_Id
           and p.Month = Trunc(i_Begin_Date, 'mon')
           and exists (select *
                  from Hpr_Wage_Sheets q
                 where q.Company_Id = p.Company_Id
                   and q.Filial_Id = p.Filial_Id
                   and q.Sheet_Id = p.Sheet_Id
                   and q.Posted = 'Y');
      end if;
    
      if v_Show_Accruals then
        select sum(q.Plan_Amount),
               sum(q.Wage_Amount),
               sum(q.Overtime_Amount),
               sum(q.Late_Amount),
               sum(q.Early_Amount),
               sum(q.Lack_Amount),
               sum(q.Day_Skip_Amount),
               sum(q.Mark_Skip_Amount),
               sum(q.Penalty_Amount),
               sum(q.Amount),
               min(q.Part_Begin),
               max(q.Part_End)
          into v_Plan_Sum,
               v_Wage_Sum,
               v_Overtime_Sum,
               v_Late_Sum,
               v_Early_Sum,
               v_Lack_Sum,
               v_Day_Skip_Sum,
               v_Mark_Skip_Sum,
               v_Penalty_Sum,
               v_Amount_Sum,
               v_Part_Begin,
               v_Part_End
          from Hpr_Sheet_Parts q
         where q.Company_Id = r.Company_Id
           and q.Filial_Id = r.Filial_Id
           and q.Staff_Id = r.Staff_Id
           and q.Part_Begin >= i_Begin_Date
           and q.Part_End <= i_End_Date
           and exists (select 1
                  from Hpr_Wage_Sheets w
                 where w.Company_Id = q.Company_Id
                   and w.Filial_Id = q.Filial_Id
                   and w.Sheet_Id = q.Sheet_Id
                   and w.Posted = 'Y');
      end if;
    
      if r.Fte_Name is null and v_Show_Fte then
        r.Fte_Name := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id, --
                      i_Filial_Id => i_Filial_Id, --
                      i_Staff_Id => r.Staff_Id, --
                      i_Period => v_Part_End).Fte;
      end if;
    
      if v_Show_Wage and v_Wage_Sum is not null then
        v_Fact_Total := v_Fact_Total + v_Wage_Sum;
      end if;
    
      if v_Show_Overtime and v_Overtime_Sum is not null then
        v_Fact_Total := v_Fact_Total + v_Overtime_Sum;
      end if;
    
      if v_Show_Onetime_Accrual and v_Onetime_Accrual is not null then
        v_Fact_Total := v_Fact_Total + v_Onetime_Accrual;
      end if;
    
      v_Plan_Total := v_Plan_Sum + v_Plan_Bonus + v_Plan_Extra;
    
      if v_Show_Lateness and v_Late_Sum is not null then
        v_Penalty_Total := v_Penalty_Total + v_Late_Sum;
      end if;
    
      if v_Show_Early_Check_Out and v_Early_Sum is not null then
        v_Penalty_Total := v_Penalty_Total + v_Early_Sum;
      end if;
    
      if v_Show_Lack and v_Lack_Sum is not null then
        v_Penalty_Total := v_Penalty_Total + v_Lack_Sum;
      end if;
    
      if v_Show_Skip_Day and v_Day_Skip_Sum is not null then
        v_Penalty_Total := v_Penalty_Total + v_Day_Skip_Sum;
      end if;
    
      if v_Show_Skip_Mark and v_Mark_Skip_Sum is not null then
        v_Penalty_Total := v_Penalty_Total + v_Mark_Skip_Sum;
      end if;
    
      if v_Show_Onetime_Penalty and v_Onetime_Penalty is not null then
        v_Penalty_Total := v_Penalty_Total + v_Onetime_Penalty;
      end if;
    
      v_Total         := v_Fact_Total - v_Penalty_Total;
      v_Bonused_Total := v_Total + v_Fact_Bonus + v_Fact_Extra;
    
      a.New_Row;
    
      a.Data(r.Row_Num);
    
      if v_Show_Staff_Number = 'Y' then
        a.Data(r.Staff_Number);
      end if;
    
      a.Data(r.Staff_Name, 'body left');
    
      if v_Show_Division then
        a.Data(r.Division_Name, 'body left');
      end if;
    
      if v_Show_Job then
        a.Data(r.Job_Name, 'body left');
      end if;
    
      if v_Show_Schedule then
        a.Data(r.Schedule_Name, 'body left');
      end if;
    
      if v_Show_Fte then
        a.Data(r.Fte_Name, 'body left');
      end if;
    
      -- planned wage
      a.Data(Print_Amount(v_Plan_Sum), 'body right');
    
      -- bonus plan
      if v_Show_Bonus then
        a.Data(Print_Amount(v_Plan_Bonus), 'body right');
        a.Data(Print_Amount(v_Plan_Extra), 'body right');
        a.Data(Print_Amount(v_Plan_Total), 'body right');
      end if;
    
      -- accrual
      if v_Show_Wage then
        a.Data(Print_Amount(v_Wage_Sum), 'body right');
      end if;
    
      if v_Show_Overtime then
        a.Data(Print_Amount(v_Overtime_Sum), 'body right');
      end if;
    
      if v_Show_Onetime_Accrual then
        a.Data(Print_Amount(v_Onetime_Accrual), 'body right');
      end if;
    
      a.Data(Print_Amount(v_Fact_Total), 'body right');
    
      -- penalty
      if v_Show_Lateness then
        a.Data(Print_Amount(v_Late_Sum), 'body right');
      end if;
    
      if v_Show_Early_Check_Out then
        a.Data(Print_Amount(v_Early_Sum), 'body right');
      end if;
    
      if v_Show_Lack then
        a.Data(Print_Amount(v_Lack_Sum), 'body right');
      end if;
    
      if v_Show_Skip_Day then
        a.Data(Print_Amount(v_Day_Skip_Sum), 'body right');
      end if;
    
      if v_Show_Skip_Mark then
        a.Data(Print_Amount(v_Mark_Skip_Sum), 'body right');
      end if;
    
      if v_Show_Onetime_Penalty then
        a.Data(Print_Amount(v_Onetime_Penalty), 'body right');
      end if;
    
      a.Data(Print_Amount(v_Penalty_Total), 'body right');
    
      -- total
      a.Data(Print_Amount(v_Total), 'body right');
    
      -- bonus fact
      if v_Show_Bonus then
        a.Data(Print_Amount(v_Fact_Bonus_Percent), 'body right');
        a.Data(Print_Amount(v_Fact_Bonus), 'body right');
        a.Data(Print_Amount(v_Fact_Extra_Percent), 'body right');
        a.Data(Print_Amount(v_Fact_Extra), 'body right');
        a.Data(Print_Amount(v_Bonused_Total));
      end if;
    
      Add_Amounts(i_Plan_Amount      => v_Plan_Sum,
                  i_Plan_Bonus       => v_Plan_Bonus,
                  i_Plan_Extra       => v_Plan_Extra,
                  i_Wage_Amount      => v_Wage_Sum,
                  i_Overtime_Amount  => v_Overtime_Sum,
                  i_Late_Amount      => v_Late_Sum,
                  i_Early_Amount     => v_Early_Sum,
                  i_Lack_Amount      => v_Lack_Sum,
                  i_Day_Skip_Amount  => v_Day_Skip_Sum,
                  i_Mark_Skip_Amount => v_Mark_Skip_Sum,
                  i_Fact_Bonus       => v_Fact_Bonus,
                  i_Fact_Extra       => v_Fact_Extra,
                  i_Onetime_Accrual  => v_Onetime_Accrual,
                  i_Onetime_Penalty  => v_Onetime_Penalty);
    end loop;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    Rt           varchar2(50) := p.o_Varchar2('rt');
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => Rt, i_File_Name => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Wage(i_Company_Id   => v_Company_Id,
             i_Filial_Id    => v_Filial_Id,
             i_Begin_Date   => Trunc(p.r_Date('month', Href_Pref.c_Date_Format_Month), 'mon'),
             i_End_Date     => Last_Day(p.r_Date('month', Href_Pref.c_Date_Format_Month)),
             i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
             i_Staff_Ids    => Nvl(p.o_Array_Number('staff_ids'), Array_Number()));
  
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
           Staff_Kind     = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr322;
/
