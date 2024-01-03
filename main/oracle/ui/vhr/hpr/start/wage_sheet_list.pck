create or replace package Ui_Vhr315 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Regular_Sheets return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Onetime_Sheets return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr315;
/
create or replace package body Ui_Vhr315 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code   Md_User_Settings.Setting_Code%type := 'ui_vhr315';
  g_Request_Styles Fazo.Varchar2_Id_Aat;

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
    return b.Translate('UI-VHR315:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(i_Sheet_Kind varchar2) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(32767);
    v_Params Hashmap;
  begin
    v_Query := 'select *
                  from hpr_wage_sheets q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.sheet_kind = :sheet_kind';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'sheet_kind',
                             i_Sheet_Kind);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      if i_Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Regular then
        v_Query := v_Query ||
                   ' and not exists (select 1
                                from hpr_sheet_parts w
                                join href_staffs s
                                  on s.company_id = w.company_id
                                 and s.filial_id = w.filial_id
                                 and s.staff_id = w.staff_id
                               where w.company_id = q.company_id
                                 and w.filial_id = q.filial_id
                                 and w.sheet_id = q.sheet_id
                                 and s.employee_id <> :user_id
                                 and hpd_util.get_closest_org_unit_id(i_company_id => s.company_id,
                                                                      i_filial_id  => s.filial_id,
                                                                      i_staff_id   => s.staff_id,
                                                                      i_period     => least(nvl(s.dismissal_date,
                                                                                                w.part_end),
                                                                                            w.part_end)) not member of :division_ids)';
      elsif i_Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Onetime then
        v_Query := v_Query ||
                   ' and not exists (select 1
                                from hpr_onetime_sheet_staffs w
                                join href_staffs s
                                  on s.company_id = w.company_id
                                 and s.filial_id = w.filial_id
                                 and s.staff_id = w.staff_id
                               where w.company_id = q.company_id
                                 and w.filial_id = q.filial_id
                                 and w.sheet_id = q.sheet_id
                                 and s.employee_id <> :user_id
                                 and hpd_util.get_closest_org_unit_id(i_company_id => s.company_id,
                                                                      i_filial_id  => s.filial_id,
                                                                      i_staff_id   => s.staff_id,
                                                                      i_period     => least(nvl(s.dismissal_date,
                                                                                                last_day(w.month)),
                                                                                            last_day(w.month))) not member of :division_ids)';
      end if;
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Params.Put('user_id', Ui.User_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('sheet_id', 'created_by', 'modified_by');
    q.Varchar2_Field('sheet_number', 'posted', 'note');
    q.Date_Field('sheet_date', 'month', 'period_begin', 'period_end', 'created_on', 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
    q.Multi_Number_Field('division_ids',
                         'select w.division_id, w.sheet_id
                            from hpr_wage_sheet_divisions w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id',
                         '@sheet_id=$sheet_id',
                         'division_id');
    q.Refer_Field('division_names',
                  'division_ids',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Regular_Sheets return Fazo_Query is
  begin
    return Query(Hpr_Pref.c_Wage_Sheet_Regular);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Onetime_Sheets return Fazo_Query is
  begin
    return Query(Hpr_Pref.c_Wage_Sheet_Onetime);
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
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Sheet_Kind
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  ) return varchar2 is
  begin
    return z_Hpr_Wage_Sheets.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Sheet_Id   => i_Sheet_Id).Sheet_Kind;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Sheet_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('sheet_id'));
  begin
    for i in 1 .. v_Sheet_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => v_Sheet_Ids(i),
                                          i_Sheet_Kind => Get_Sheet_Kind(i_Company_Id => v_Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_Sheet_Id   => v_Sheet_Ids(i)));
    
      Hpr_Api.Wage_Sheet_Post(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Id,
                              i_Sheet_Id   => v_Sheet_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Sheet_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('sheet_id'));
  begin
    for i in 1 .. v_Sheet_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => v_Sheet_Ids(i),
                                          i_Sheet_Kind => Get_Sheet_Kind(i_Company_Id => v_Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_Sheet_Id   => v_Sheet_Ids(i)));
    
      Hpr_Api.Wage_Sheet_Unpost(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Sheet_Id   => v_Sheet_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Sheet_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('sheet_id'));
  begin
    for i in 1 .. v_Sheet_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => v_Sheet_Ids(i),
                                          i_Sheet_Kind => Get_Sheet_Kind(i_Company_Id => v_Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_Sheet_Id   => v_Sheet_Ids(i)));
    
      Hpr_Api.Wage_Sheet_Delete(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Sheet_Id   => v_Sheet_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Wage_Sheet(i_Sheet Hpr_Wage_Sheets%rowtype) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Staff_Number  varchar2(1) := Nvl(v_Settings.o_Varchar2('staff_number'), 'N');
    v_Show_Detail        boolean := Nvl(v_Settings.o_Varchar2('detail'), 'N') = 'Y';
    v_Show_Monthly_Plan  boolean := Nvl(v_Settings.o_Varchar2('monthly_plan'), 'N') = 'Y';
    v_Show_Period_Plan   boolean := Nvl(v_Settings.o_Varchar2('period_plan'), 'N') = 'Y';
    v_Show_Fact_Time     boolean := Nvl(v_Settings.o_Varchar2('fact_time'), 'N') = 'Y';
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Division      boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Job           boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Schedule      boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Fte           boolean := Nvl(v_Settings.o_Varchar2('fte'), 'N') = 'Y';
    v_Show_Onetime       boolean := Nvl(v_Settings.o_Varchar2('onetime_aviable'), 'N') = 'Y';
  
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
  
    v_Total_Colspan      number := 0;
    v_Left_Total_Colspan number := 0;
    v_Initial_Rowspan    number := 1;
    v_Has_Onetime        number := 0;
    v_Onetime_Accrual    number := 0;
    v_Onetime_Penalty    number := 0;
  
    v_Row_Number number := 1;
  
    v_g_Has_Total boolean;
  
    v_Calc       Calc := Calc();
    v_Total_Calc Calc := Calc();
  
    v_Monthly_Time number := 0;
    v_Monthly_Days number := 0;
    v_Plan_Time    number := 0;
    v_Plan_Days    number := 0;
    v_Fact_Time    number := 0;
    v_Fact_Days    number := 0;
  
    v_g_Monthly_Time   number := 0;
    v_g_Monthly_Days   number := 0;
    v_g_Monthly_Amount number := 0;
  
    v_Division_Names Array_Varchar2 := Array_Varchar2();
    v_Job_Names      Array_Varchar2 := Array_Varchar2();
    v_Schedule_Names Array_Varchar2 := Array_Varchar2();
    v_Fte_Names      Array_Varchar2 := Array_Varchar2();
    v_Parts          Array_Date := Array_Date();
  
    v_Prev_Staff_Id number := -1;
    v_Turnout_Id    number;
  
    --------------------------------------------------
    Function Print_Amount(i_Amount number) return number is
    begin
      return Round(Nullif(i_Amount, 0), 2);
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
      v_Limit          number := 5;
      v_Division_Ids   Array_Number;
      v_Division_Names Array_Varchar2 := Array_Varchar2();
    begin
      a.Current_Style('root bold');
      a.New_Row;
      a.New_Row;
      a.Data(t('sheet_number: $1', i_Sheet.Sheet_Number), i_Colspan => 3);
      a.New_Row;
      a.Data(t('month: $1', to_char(i_Sheet.Month, 'Month YYYY')), i_Colspan => 3);
      a.New_Row;
      a.Data(t('period kind: $1{period_kind} ($2{period_begin} - $3{period_end})',
               Hpr_Util.t_Period_Kind(i_Sheet.Period_Kind),
               to_char(i_Sheet.Period_Begin, 'dd mon yyyy'),
               to_char(i_Sheet.Period_End, 'dd mon yyyy')),
             i_Colspan => 6);
    
      select q.Division_Id
        bulk collect
        into v_Division_Ids
        from Hpr_Wage_Sheet_Divisions q
       where q.Company_Id = i_Sheet.Company_Id
         and q.Filial_Id = i_Sheet.Filial_Id
         and q.Sheet_Id = i_Sheet.Sheet_Id;
    
      if v_Division_Ids.Count > 0 then
        a.New_Row;
        a.New_Row;
      
        v_Limit := Least(v_Limit, v_Division_Ids.Count);
      
        v_Division_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Division_Names(i) := z_Mhr_Divisions.Load(i_Company_Id => i_Sheet.Company_Id, --
                                 i_Filial_Id => i_Sheet.Filial_Id, --
                                 i_Division_Id => v_Division_Ids(i)).Name;
        end loop;
      
        if v_Limit < v_Division_Names.Count then
          Fazo.Push(v_Division_Names, t('others ..'));
        end if;
      
        a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
      end if;
    
      for r in (select q.Job_Id, q.Staff_Id
                  from Hpr_Sheet_Parts q
                 where q.Company_Id = i_Sheet.Company_Id
                   and q.Filial_Id = i_Sheet.Filial_Id
                   and q.Sheet_Id = i_Sheet.Sheet_Id)
      loop
        if Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r.Job_Id,
                                               i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Sheet.Company_Id,
                                                                                          i_Filial_Id  => i_Sheet.Filial_Id,
                                                                                          i_Staff_Id   => r.Staff_Id)) = 'N' then
          a.New_Row;
          a.New_Row;
          a.Data(t('you can not see rows that contain jobs that you do not have access to'),
                 'root',
                 i_Colspan => 5);
          exit;
        end if;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
    
      a.New_Row;
      a.New_Row;
    
      Print_Header(t('rownum'), 1, 2, 50, true);
      v_Left_Total_Colspan := v_Left_Total_Colspan + 1;
    
      if v_Show_Staff_Number = 'Y' then
        Print_Header(t('staff number'), 1, 2, 100, true);
        v_Left_Total_Colspan := v_Left_Total_Colspan + 1;
      end if;
    
      Print_Header(t('staff name'), 1, 2, 250, true);
      v_Left_Total_Colspan := v_Left_Total_Colspan + 1;
    
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
    
      Print_Header(t('part begin'), 1, 2, 100, true);
    
      if v_Show_Monthly_Plan then
        Print_Header(t('monthly plan'), 3, 1, 100);
      end if;
    
      if v_Show_Period_Plan then
        Print_Header(t('period plan'), 3, 1, 100);
      end if;
    
      if v_Show_Fact_Time then
        Print_Header(t('fact'), 2, 1, 100);
      end if;
    
      if v_Show_Onetime and i_Sheet.Period_Begin = Trunc(i_Sheet.Period_Begin, 'mon') and
         i_Sheet.Period_End = Last_Day(i_Sheet.Period_End) then
        v_Has_Onetime := 1;
      end if;
    
      Print_Header(t('accrual'), 4 + v_Has_Onetime, 1, 100);
    
      Print_Header(t('penalty'), 6 + v_Has_Onetime, 1, 100);
    
      Print_Header(t('total amount'), 1, 2, 100);
    
      a.New_Row;
    
      if v_Show_Monthly_Plan then
        Print_Header(t('monthly time'), 1, 1, 100);
        Print_Header(t('monthly days'), 1, 1, 100);
        Print_Header(t('monthly amount'), 1, 1, 100);
      end if;
    
      if v_Show_Period_Plan then
        Print_Header(t('plan time'), 1, 1, 100);
        Print_Header(t('plan days'), 1, 1, 100);
        Print_Header(t('plan amount'), 1, 1, 100);
      end if;
    
      if v_Show_Fact_Time then
        Print_Header(t('wage time'), 1, 1, 100);
        Print_Header(t('wage days'), 1, 1, 100);
      end if;
    
      Print_Header(t('wage amount'), 1, 1, 100);
      Print_Header(t('overtime amount'), 1, 1, 100);
      Print_Header(t('nighttime amount'), 1, 1, 100);
    
      if v_Has_Onetime = 1 then
        Print_Header(t('onetime accrual'), 1, 1, 100);
      end if;
    
      Print_Header(t('accrual amount'), 1, 1, 100);
    
      Print_Header(t('late amount'), 1, 1, 100);
      Print_Header(t('early amount'), 1, 1, 100);
      Print_Header(t('lack amount'), 1, 1, 100);
      Print_Header(t('day_skip_amount'), 1, 1, 100);
      Print_Header(t('mark_skip_amount'), 1, 1, 100);
    
      if v_Has_Onetime = 1 then
        Print_Header(t('onetime penalty'), 1, 1, 100);
      end if;
    
      Print_Header(t('penalty amount'), 1, 1, 100);
    end;
  
    --------------------------------------------------
    Procedure Print_Footer is
      v_Monthly_Amount   number := v_Total_Calc.Get_Value('monthly_amount');
      v_Plan_Amount      number := v_Total_Calc.Get_Value('plan_amount');
      v_Wage_Amount      number := v_Total_Calc.Get_Value('wage_amount');
      v_Overtime_Amount  number := v_Total_Calc.Get_Value('overtime_amount');
      v_Nighttime_Amount number := v_Total_Calc.Get_Value('nighttime_amountr');
      v_Onetime_Accrual  number := v_Total_Calc.Get_Value('onetime_accrual');
      v_Late_Amount      number := v_Total_Calc.Get_Value('late_amount');
      v_Early_Amount     number := v_Total_Calc.Get_Value('early_amount');
      v_Lack_Amount      number := v_Total_Calc.Get_Value('lack_amount');
      v_Day_Skip_Amount  number := v_Total_Calc.Get_Value('day_skip_amount');
      v_Mark_Skip_Amount number := v_Total_Calc.Get_Value('mark_skip_amount');
      v_Onetime_Penalty  number := v_Total_Calc.Get_Value('onetime_penalty');
      v_Accrual_Amount   number := v_Total_Calc.Get_Value('accrual_amount');
      v_Penalty_Amount   number := v_Total_Calc.Get_Value('penalty_amount');
      v_Total_Amount     number := v_Total_Calc.Get_Value('total_amount');
    begin
      a.Current_Style('footer');
    
      a.New_Row;
    
      a.Data(t('total'), 'footer right', i_Colspan => v_Total_Colspan);
    
      if v_Show_Monthly_Plan then
        a.Data(Print_Amount(v_Monthly_Amount), 'footer right', i_Colspan => 3);
      end if;
    
      if v_Show_Period_Plan then
        a.Data(Print_Amount(v_Plan_Amount), 'footer right', i_Colspan => 3);
      end if;
    
      a.Data(Print_Amount(v_Wage_Amount),
             'footer right',
             i_Colspan => case
                            when v_Show_Fact_Time then
                             3
                            else
                             1
                          end);
      a.Data(Print_Amount(v_Overtime_Amount), 'footer right');
      a.Data(Print_Amount(v_Nighttime_Amount), 'footer right');
    
      if v_Has_Onetime = 1 then
        a.Data(Print_Amount(v_Onetime_Accrual), 'footer right');
      end if;
    
      a.Data(Print_Amount(v_Accrual_Amount), 'footer right');
    
      a.Data(Print_Amount(v_Late_Amount), 'footer right');
      a.Data(Print_Amount(v_Early_Amount), 'footer right');
      a.Data(Print_Amount(v_Lack_Amount), 'footer right');
      a.Data(Print_Amount(v_Day_Skip_Amount), 'footer right');
      a.Data(Print_Amount(v_Mark_Skip_Amount), 'footer right');
    
      if v_Has_Onetime = 1 then
        a.Data(Print_Amount(v_Onetime_Penalty), 'footer right');
      end if;
    
      a.Data(Print_Amount(v_Penalty_Amount), 'footer right');
      a.Data(Print_Amount(v_Total_Amount), 'footer right');
    end;
  
    --------------------------------------------------
    Procedure Print_Total is
      v_Plan_Time        number := v_Calc.Get_Value('plan_time');
      v_Plan_Days        number := v_Calc.Get_Value('plan_days');
      v_Plan_Amount      number := v_Calc.Get_Value('plan_amount');
      v_Fact_Time        number := v_Calc.Get_Value('fact_time');
      v_Fact_Days        number := v_Calc.Get_Value('fact_days');
      v_Wage_Amount      number := v_Calc.Get_Value('wage_amount');
      v_Overtime_Amount  number := v_Calc.Get_Value('overtime_amount');
      v_Nighttime_Amount number := v_Calc.Get_Value('nighttime_amount');
      v_Onetime_Accrual  number := v_Calc.Get_Value('onetime_accrual');
      v_Late_Amount      number := v_Calc.Get_Value('late_amount');
      v_Early_Amount     number := v_Calc.Get_Value('early_amount');
      v_Lack_Amount      number := v_Calc.Get_Value('lack_amount');
      v_Day_Skip_Amount  number := v_Calc.Get_Value('day_skip_amount');
      v_Mark_Skip_Amount number := v_Calc.Get_Value('mark_skip_amount');
      v_Accrual_Amount   number := v_Calc.Get_Value('accrual_amount');
      v_Onetime_Penalty  number := v_Calc.Get_Value('onetime_penalty');
      v_Penalty_Amount   number := v_Calc.Get_Value('penalty_amount');
      v_Total_Amount     number := v_Calc.Get_Value('total_amount');
    
      v_Divisions_Name varchar2(1000) := Fazo.Gather(set(v_Division_Names), '/');
      v_Jobs_Name      varchar2(1000) := Fazo.Gather(set(v_Job_Names), '/');
      v_Schedules_Name varchar2(1000) := Fazo.Gather(set(v_Schedule_Names), '/');
      v_Ftes_Name      varchar2(1000) := Fazo.Gather(set(v_Fte_Names), '/');
      v_Parts_Name     varchar2(1000) := Fazo.Gather(v_Parts, '/');
    begin
      if v_g_Has_Total then
        if v_Show_Detail then
          a.New_Row;
          a.Data(t('total:'), 'body right', i_Colspan => v_Total_Colspan - v_Left_Total_Colspan);
        else
          if v_Show_Division then
            a.Data(v_Divisions_Name, 'body left');
          end if;
        
          if v_Show_Job then
            a.Data(v_Jobs_Name, 'body left');
          end if;
        
          if v_Show_Schedule then
            a.Data(v_Schedules_Name, 'body left');
          end if;
        
          if v_Show_Fte then
            a.Data(v_Ftes_Name, 'body left');
          end if;
        
          a.Data(v_Parts_Name);
        end if;
      
        if v_Show_Monthly_Plan then
          a.Data(Htt_Util.To_Time_Text(v_g_Monthly_Time,
                                       i_Show_Minutes   => v_Show_Minutes,
                                       i_Show_Words     => v_Show_Minutes_Words));
          a.Data(Nullif(v_g_Monthly_Days, 0));
          a.Data(Print_Amount(v_g_Monthly_Amount), 'body right');
        end if;
      
        if v_Show_Period_Plan then
          a.Data(Htt_Util.To_Time_Seconds_Text(v_Plan_Time,
                                               i_Show_Minutes => v_Show_Minutes,
                                               i_Show_Words   => v_Show_Minutes_Words));
          a.Data(Nullif(v_Plan_Days, 0));
          a.Data(Print_Amount(v_Plan_Amount), 'body right');
        end if;
      
        if v_Show_Fact_Time then
          a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Time,
                                               i_Show_Minutes => v_Show_Minutes,
                                               i_Show_Words   => v_Show_Minutes_Words));
          a.Data(Nullif(v_Fact_Days, 0));
        end if;
      
        a.Data(Print_Amount(v_Wage_Amount), 'body right');
        a.Data(Print_Amount(v_Overtime_Amount), 'body right');
        a.Data(Print_Amount(v_Nighttime_Amount), 'body right');
      
        if v_Has_Onetime = 1 then
          a.Data(Print_Amount(v_Onetime_Accrual), 'body right');
        end if;
      
        a.Data(Print_Amount(v_Accrual_Amount), 'body right');
      
        a.Data(Print_Amount(v_Late_Amount), 'body right');
        a.Data(Print_Amount(v_Early_Amount), 'body right');
        a.Data(Print_Amount(v_Lack_Amount), 'body right');
        a.Data(Print_Amount(v_Day_Skip_Amount), 'body right');
        a.Data(Print_Amount(v_Mark_Skip_Amount), 'body right');
      
        if v_Has_Onetime = 1 then
          a.Data(Print_Amount(v_Onetime_Penalty), 'body right');
        end if;
      
        a.Data(Print_Amount(v_Penalty_Amount), 'body right');
        a.Data(Print_Amount(v_Total_Amount), 'body right');
      end if;
    
      v_Calc           := Calc();
      v_Division_Names := Array_Varchar2();
      v_Job_Names      := Array_Varchar2();
      v_Schedule_Names := Array_Varchar2();
      v_Fte_Names      := Array_Varchar2();
      v_Parts          := Array_Date();
    end;
  
    --------------------------------------------------
    Procedure Calc_Time
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Staff_Id    number,
      i_Schedule_Id number,
      i_Part_Begin  date,
      i_Part_End    date
    ) is
    begin
      if v_Show_Monthly_Plan then
        v_Monthly_Time := Htt_Util.Calc_Plan_Minutes(i_Company_Id  => i_Company_Id,
                                                     i_Filial_Id   => i_Filial_Id,
                                                     i_Staff_Id    => i_Staff_Id,
                                                     i_Schedule_Id => i_Schedule_Id,
                                                     i_Period      => i_Part_End);
      
        v_Monthly_Days := Htt_Util.Calc_Plan_Days(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Staff_Id    => i_Staff_Id,
                                                  i_Schedule_Id => i_Schedule_Id,
                                                  i_Period      => i_Part_End);
      end if;
    
      if v_Show_Period_Plan then
        v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => i_Company_Id,
                                                     i_Filial_Id  => i_Filial_Id,
                                                     i_Staff_Id   => i_Staff_Id,
                                                     i_Begin_Date => i_Part_Begin,
                                                     i_End_Date   => i_Part_End);
      
        v_Plan_Days := Htt_Util.Calc_Working_Days(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Begin_Date => i_Part_Begin,
                                                  i_End_Date   => i_Part_End);
      end if;
    
      if v_Show_Fact_Time then
        Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Time,
                                      o_Fact_Days    => v_Fact_Days,
                                      i_Company_Id   => i_Company_Id,
                                      i_Filial_Id    => i_Filial_Id,
                                      i_Staff_Id     => i_Staff_Id,
                                      i_Time_Kind_Id => v_Turnout_Id,
                                      i_Begin_Date   => i_Part_Begin,
                                      i_End_Date     => i_Part_End);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Calc_Amounts
    (
      i_Monthly_Time     number,
      i_Monthly_Days     number,
      i_Monthly_Amount   number,
      i_Plan_Time        number,
      i_Plan_Days        number,
      i_Plan_Amount      number,
      i_Fact_Time        number,
      i_Fact_Days        number,
      i_Wage_Amount      number,
      i_Overtime_Amount  number,
      i_Nighttime_Amount number,
      i_Onetime_Accrual  number,
      i_Late_Amount      number,
      i_Early_Amount     number,
      i_Lack_Amount      number,
      i_Day_Skip_Amount  number,
      i_Mark_Skip_Amount number,
      i_Accrual_Amount   number,
      i_Penalty_Amount   number,
      i_Onetime_Penalty  number,
      i_Total_Amount     number
    ) is
    begin
      v_g_Monthly_Time   := i_Monthly_Time;
      v_g_Monthly_Days   := i_Monthly_Days;
      v_g_Monthly_Amount := i_Monthly_Amount;
    
      v_Calc.Plus('plan_time', i_Plan_Time);
      v_Calc.Plus('plan_days', i_Plan_Days);
      v_Calc.Plus('plan_amount', i_Plan_Amount);
      v_Calc.Plus('fact_time', i_Fact_Time);
      v_Calc.Plus('fact_days', i_Fact_Days);
      v_Calc.Plus('wage_amount', i_Wage_Amount);
      v_Calc.Plus('overtime_amount', i_Overtime_Amount);
      v_Calc.Plus('nighttime_amount', i_Nighttime_Amount);
      v_Calc.Plus('onetime_accrual', i_Onetime_Accrual);
      v_Calc.Plus('late_amount', i_Late_Amount);
      v_Calc.Plus('early_amount', i_Early_Amount);
      v_Calc.Plus('lack_amount', i_Lack_Amount);
      v_Calc.Plus('day_skip_amount', i_Day_Skip_Amount);
      v_Calc.Plus('mark_skip_amount', i_Mark_Skip_Amount);
      v_Calc.Plus('onetime_penalty', i_Onetime_Penalty);
      v_Calc.Plus('accrual_amount', i_Accrual_Amount + i_Onetime_Accrual);
      v_Calc.Plus('penalty_amount', i_Penalty_Amount + i_Onetime_Penalty);
      v_Calc.Plus('total_amount', i_Total_Amount + i_Onetime_Accrual - i_Onetime_Penalty);
    
      v_Total_Calc.Plus('monthly_amount', i_Plan_Amount);
      v_Total_Calc.Plus('plan_amount', i_Plan_Amount);
      v_Total_Calc.Plus('wage_amount', i_Wage_Amount);
      v_Total_Calc.Plus('overtime_amount', i_Overtime_Amount);
      v_Total_Calc.Plus('nighttime_amount', i_Nighttime_Amount);
      v_Total_Calc.Plus('onetime_accrual', i_Onetime_Accrual);
      v_Total_Calc.Plus('late_amount', i_Late_Amount);
      v_Total_Calc.Plus('early_amount', i_Early_Amount);
      v_Total_Calc.Plus('lack_amount', i_Lack_Amount);
      v_Total_Calc.Plus('day_skip_amount', i_Day_Skip_Amount);
      v_Total_Calc.Plus('mark_skip_amount', i_Mark_Skip_Amount);
      v_Total_Calc.Plus('onetime_penalty', i_Onetime_Penalty);
      v_Total_Calc.Plus('accrual_amount', i_Accrual_Amount + i_Onetime_Accrual);
      v_Total_Calc.Plus('penalty_amount', i_Penalty_Amount + i_Onetime_Penalty);
      v_Total_Calc.Plus('total_amount', i_Total_Amount + i_Onetime_Accrual - i_Onetime_Penalty);
    end;
  begin
    Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => i_Sheet.Sheet_Id,
                                        i_Sheet_Kind => i_Sheet.Sheet_Kind);
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Sheet.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Print_Info;
  
    Print_Header;
  
    a.Current_Style('body_centralized');
  
    for r in (select count(1) Over(partition by p.Staff_Id) Rowspan,
                     q.Staff_Number,
                     p.Staff_Id,
                     Np.Name Staff_Name,
                     Np.Person_Id,
                     p.Part_Id,
                     p.Part_Begin,
                     p.Part_End,
                     p.Job_Id,
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = p.Company_Id
                         and Dv.Filial_Id = p.Filial_Id
                         and Dv.Division_Id = p.Division_Id) Division_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = p.Company_Id
                         and Jb.Filial_Id = p.Filial_Id
                         and Jb.Job_Id = p.Job_Id) Job_Name,
                     (select Sch.Name
                        from Htt_Schedules Sch
                       where Sch.Company_Id = p.Company_Id
                         and Sch.Filial_Id = p.Filial_Id
                         and Sch.Schedule_Id = p.Schedule_Id) Schedule_Name,
                     (select Ft.Name
                        from Href_Ftes Ft
                       where Ft.Company_Id = p.Company_Id
                         and Ft.Fte_Id = p.Fte_Id) Fte_Name,
                     p.Schedule_Id,
                     p.Monthly_Amount,
                     p.Plan_Amount,
                     p.Wage_Amount,
                     p.Overtime_Amount,
                     p.Nighttime_Amount,
                     p.Late_Amount,
                     p.Early_Amount,
                     p.Lack_Amount,
                     p.Day_Skip_Amount,
                     p.Mark_Skip_Amount,
                     p.Accrual_Amount,
                     p.Penalty_Amount,
                     p.Amount Total_Amount
                from Hpr_Sheet_Parts p
                join Href_Staffs q
                  on q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Staff_Id = p.Staff_Id
                join Mr_Natural_Persons Np
                  on Np.Company_Id = q.Company_Id
                 and Np.Person_Id = q.Employee_Id
               where p.Company_Id = i_Sheet.Company_Id
                 and p.Filial_Id = i_Sheet.Filial_Id
                 and p.Sheet_Id = i_Sheet.Sheet_Id
               order by case
                          when v_Show_Staff_Number = 'Y' then
                           q.Staff_Number
                          else
                           Np.Name
                        end,
                        p.Staff_Id,
                        p.Part_Begin)
    loop
      continue when Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r.Job_Id,
                                                        i_Employee_Id => r.Person_Id) = 'N';
    
      if r.Fte_Name is null then
        r.Fte_Name := Hpd_Util.Closest_Robot(i_Company_Id => i_Sheet.Company_Id, --
                      i_Filial_Id => i_Sheet.Filial_Id, --
                      i_Staff_Id => r.Staff_Id, --
                      i_Period => r.Part_End).Fte;
      end if;
    
      Calc_Time(i_Company_Id  => i_Sheet.Company_Id,
                i_Filial_Id   => i_Sheet.Filial_Id,
                i_Staff_Id    => r.Staff_Id,
                i_Schedule_Id => r.Schedule_Id,
                i_Part_Begin  => r.Part_Begin,
                i_Part_End    => r.Part_End);
    
      if v_Has_Onetime = 1 then
        select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0)
          into v_Onetime_Accrual, --
               v_Onetime_Penalty
          from Hpr_Onetime_Sheet_Staffs p
         where p.Company_Id = i_Sheet.Company_Id
           and p.Filial_Id = i_Sheet.Filial_Id
           and p.Staff_Id = r.Staff_Id
           and p.Month = i_Sheet.Period_Begin
           and exists (select *
                  from Hpr_Wage_Sheets q
                 where q.Company_Id = p.Company_Id
                   and q.Filial_Id = p.Filial_Id
                   and q.Sheet_Id = p.Sheet_Id
                   and q.Posted = 'Y');
      end if;
    
      if v_Prev_Staff_Id <> r.Staff_Id then
        Print_Total;
        v_g_Has_Total := r.Rowspan > 1 or not v_Show_Detail;
      
        a.New_Row;
        if v_g_Has_Total and v_Show_Detail then
          v_Initial_Rowspan := r.Rowspan + 1;
        else
          v_Initial_Rowspan := 1;
        end if;
      
        a.Data(v_Row_Number, i_Rowspan => v_Initial_Rowspan);
      
        if v_Show_Staff_Number = 'Y' then
          a.Data(r.Staff_Number, i_Rowspan => v_Initial_Rowspan);
        end if;
      
        a.Data(r.Staff_Name,
               i_Param      => Fazo.Zip_Map('part_id', r.Part_Id).Json(),
               i_Rowspan    => v_Initial_Rowspan);
      
        v_Row_Number := v_Row_Number + 1;
      else
        if v_Show_Detail then
          a.New_Row;
        end if;
      end if;
    
      if v_Show_Detail then
      
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
      
        a.Data(r.Part_Begin);
      
        if v_Show_Monthly_Plan then
          a.Data(Htt_Util.To_Time_Text(v_Monthly_Time,
                                       i_Show_Minutes => v_Show_Minutes,
                                       i_Show_Words   => v_Show_Minutes_Words));
          a.Data(Nullif(v_Monthly_Days, 0));
          a.Data(Print_Amount(r.Monthly_Amount), 'body right');
        end if;
      
        if v_Show_Period_Plan then
          a.Data(Htt_Util.To_Time_Seconds_Text(v_Plan_Time,
                                               i_Show_Minutes => v_Show_Minutes,
                                               i_Show_Words   => v_Show_Minutes_Words));
          a.Data(Nullif(v_Plan_Days, 0));
          a.Data(Print_Amount(r.Plan_Amount), 'body right');
        end if;
      
        if v_Show_Fact_Time then
          a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Time,
                                               i_Show_Minutes => v_Show_Minutes,
                                               i_Show_Words   => v_Show_Minutes_Words));
          a.Data(Nullif(v_Fact_Days, 0));
        end if;
      
        a.Data(Print_Amount(r.Wage_Amount), 'body right');
        a.Data(Print_Amount(r.Overtime_Amount), 'body right');
        a.Data(Print_Amount(r.Nighttime_Amount), 'body right');
      
        if v_Has_Onetime = 1 then
          a.Data(Print_Amount(v_Onetime_Accrual), 'body right');
          a.Data(Print_Amount(r.Accrual_Amount + v_Onetime_Accrual), 'body right');
        else
          a.Data(Print_Amount(r.Accrual_Amount), 'body right');
        end if;
      
        a.Data(Print_Amount(r.Late_Amount), 'body right');
        a.Data(Print_Amount(r.Early_Amount), 'body right');
        a.Data(Print_Amount(r.Lack_Amount), 'body right');
        a.Data(Print_Amount(r.Day_Skip_Amount), 'body right');
        a.Data(Print_Amount(r.Mark_Skip_Amount), 'body right');
      
        if v_Has_Onetime = 1 then
          a.Data(Print_Amount(v_Onetime_Penalty), 'body right');
          a.Data(Print_Amount(r.Penalty_Amount + v_Onetime_Penalty), 'body right');
        else
          a.Data(Print_Amount(r.Penalty_Amount), 'body right');
        end if;
      
        a.Data(Print_Amount(r.Total_Amount + v_Onetime_Accrual - v_Onetime_Penalty), 'body right');
      else
        Fazo.Push(v_Division_Names, r.Division_Name);
        Fazo.Push(v_Job_Names, r.Job_Name);
        Fazo.Push(v_Schedule_Names, r.Schedule_Name);
        Fazo.Push(v_Fte_Names, r.Fte_Name);
        Fazo.Push(v_Parts, r.Part_Begin);
      end if;
    
      Calc_Amounts(i_Monthly_Time     => v_Monthly_Time,
                   i_Monthly_Days     => v_Monthly_Days,
                   i_Monthly_Amount   => r.Monthly_Amount,
                   i_Plan_Time        => v_Plan_Time,
                   i_Plan_Days        => v_Plan_Days,
                   i_Plan_Amount      => r.Plan_Amount,
                   i_Fact_Time        => v_Fact_Time,
                   i_Fact_Days        => v_Fact_Days,
                   i_Wage_Amount      => r.Wage_Amount,
                   i_Overtime_Amount  => r.Overtime_Amount,
                   i_Nighttime_Amount => r.Nighttime_Amount,
                   i_Onetime_Accrual  => v_Onetime_Accrual,
                   i_Late_Amount      => r.Late_Amount,
                   i_Early_Amount     => r.Early_Amount,
                   i_Lack_Amount      => r.Lack_Amount,
                   i_Day_Skip_Amount  => r.Day_Skip_Amount,
                   i_Mark_Skip_Amount => r.Mark_Skip_Amount,
                   i_Accrual_Amount   => r.Accrual_Amount,
                   i_Penalty_Amount   => r.Penalty_Amount,
                   i_Onetime_Penalty  => v_Onetime_Penalty,
                   i_Total_Amount     => r.Total_Amount);
    
      v_Prev_Staff_Id := r.Staff_Id;
    end loop;
  
    Print_Total;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name, --
                       p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staff(i_Part Hpr_Sheet_Parts%rowtype) is
    a                b_Table := b_Report.New_Table();
    v_Column_Count   number;
    v_Row_Number     number := 0;
    v_Column         number := 1;
    v_Style          varchar2(100);
    v_Calc           Calc := Calc();
    v_Start_Of_Month date := Trunc(i_Part.Part_Begin, 'mon');
    v_Nls_Language   varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Round_Model    Round_Model := Round_Model(Md_Pref.Round_Model(i_Part.Company_Id));
    v_Part_End       date;
    r_Staff          Href_Staffs%rowtype;
  
    v_Settings           Hashmap := Load_Preferences;
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Break_Time    boolean := Nvl(v_Settings.o_Varchar2('break_time'), 'N') = 'Y';
    v_Show_Overtime_Fact boolean := Nvl(v_Settings.o_Varchar2('overtime_fact'), 'N') = 'Y';
    v_Show_Late_Fact     boolean := Nvl(v_Settings.o_Varchar2('late_fact'), 'N') = 'Y';
    v_Show_Early_Fact    boolean := Nvl(v_Settings.o_Varchar2('early_fact'), 'N') = 'Y';
    v_Show_Lack_Fact     boolean := Nvl(v_Settings.o_Varchar2('lack_fact'), 'N') = 'Y';
    v_Show_Onetime       boolean := Nvl(v_Settings.o_Varchar2('onetime_aviable'), 'N') = 'Y';
  
    v_Has_Onetime     number := 0;
    v_Onetime_Accrual number := 0;
    v_Onetime_Penalty number := 0;
  
    v_Column_Count_Part_Detail_Sheet number;
  
    v_Overtime_Type_Id  number;
    v_Nighttime_Type_Id number;
    v_Oper_Type_Id      number;
    v_Oper_Group_Id     number;
    v_Hourly_Wage       number;
    v_Late_Id           number;
    v_Early_Id          number;
    v_Lack_Id           number;
    v_Turnout_Id        number;
    v_Overtime_Id       number;
  
    v_Wage_Amount      number;
    v_Overtime_Amount  number;
    v_Nighttime_Amount number;
    v_Late_Amount      number;
    v_Early_Amount     number;
    v_Lack_Amount      number;
    v_Day_Skip_Amount  number;
    v_Mark_Skip_Amount number;
    v_Total_Amount     number;
    v_Daily_Penalties  Matrix_Number;
  
    --------------------------------------------------
    Function Day_Index(i_Date date) return number is
    begin
      return i_Date - v_Start_Of_Month + 1;
    end;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Seconds number,
      i_Style   varchar2 := null
    ) is
      v_Style varchar2(20) := i_Style;
    begin
      if i_Seconds < 0 then
        v_Style := 'danger';
      end if;
    
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words),
               v_Style);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), v_Style);
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Print_General_Info is
      -------------------------
      Procedure Print_New_Row
      (
        i_Name      varchar2,
        i_Fact_Time number := null,
        i_Day_Count number := null,
        i_Amount    number,
        i_Style     varchar
      ) is
      begin
        a.Current_Style(i_Style);
        a.Data(i_Name, i_Colspan => 2);
      
        Put_Time(i_Fact_Time);
      
        a.Data(i_Day_Count);
        a.Data(i_Amount, i_Style || ' right');
      end;
    begin
      v_Row_Number := v_Row_Number + 1;
    
      case v_Row_Number
        when 1 then
          a.Current_Style('header');
          a.Data('', i_Colspan => 2);
          a.Data(t('time'));
          a.Data(t('days'));
          a.Data(t('amount'));
        when 2 then
          Print_New_Row(i_Name      => t('plan'),
                        i_Fact_Time => v_Calc.Get_Value('plan_time'),
                        i_Day_Count => v_Calc.Get_Value('plan_days'),
                        i_Amount    => i_Part.Plan_Amount,
                        i_Style     => 'body_centralized');
        when 3 then
          Print_New_Row(i_Name   => t('accrued'),
                        i_Amount => i_Part.Accrual_Amount + v_Onetime_Accrual,
                        i_Style  => 'success');
        when 4 then
          Print_New_Row(i_Name      => t('wage'),
                        i_Fact_Time => v_Calc.Get_Value('wage_time'),
                        i_Day_Count => v_Calc.Get_Value('wage_days'),
                        i_Amount    => i_Part.Wage_Amount,
                        i_Style     => 'body_centralized');
        when 5 then
          Print_New_Row(i_Name      => t('overtime'),
                        i_Fact_Time => v_Calc.Get_Value('overtime_time'),
                        i_Day_Count => v_Calc.Get_Value('overtime_days'),
                        i_Amount    => i_Part.Overtime_Amount,
                        i_Style     => 'body_centralized');
        when 6 then
          Print_New_Row(i_Name   => t('nighttime'),
                        i_Amount => i_Part.Nighttime_Amount,
                        i_Style  => 'body_centralized');
        when 7 then
          if v_Has_Onetime = 1 then
            Print_New_Row(i_Name   => t('onetime accrual'),
                          i_Amount => v_Onetime_Accrual,
                          i_Style  => 'body_centralized');
          else
            Print_General_Info;
          end if;
        when 8 then
          Print_New_Row(i_Name   => t('deduction'),
                        i_Amount => i_Part.Penalty_Amount + v_Onetime_Penalty,
                        i_Style  => 'danger');
        when 9 then
          Print_New_Row(i_Name      => t('late'),
                        i_Fact_Time => v_Calc.Get_Value('late_time'),
                        i_Day_Count => v_Calc.Get_Value('late_days'),
                        i_Amount    => i_Part.Late_Amount,
                        i_Style     => 'body_centralized');
        when 10 then
          Print_New_Row(i_Name      => t('early'),
                        i_Fact_Time => v_Calc.Get_Value('early_time'),
                        i_Day_Count => v_Calc.Get_Value('early_days'),
                        i_Amount    => i_Part.Early_Amount,
                        i_Style     => 'body_centralized');
        when 11 then
          Print_New_Row(i_Name      => t('lack'),
                        i_Fact_Time => v_Calc.Get_Value('lack_time'),
                        i_Day_Count => v_Calc.Get_Value('lack_days'),
                        i_Amount    => i_Part.Lack_Amount,
                        i_Style     => 'body_centralized');
        when 12 then
          Print_New_Row(i_Name      => t('skip day'),
                        i_Fact_Time => v_Calc.Get_Value('skip_day_time'),
                        i_Day_Count => v_Calc.Get_Value('skip_day_days'),
                        i_Amount    => i_Part.Day_Skip_Amount,
                        i_Style     => 'body_centralized');
        when 13 then
          Print_New_Row(i_Name      => t('skip mark'),
                        i_Fact_Time => v_Calc.Get_Value('skip_mark_time'),
                        i_Day_Count => v_Calc.Get_Value('skip_mark_days'),
                        i_Amount    => i_Part.Mark_Skip_Amount,
                        i_Style     => 'body_centralized');
        when 14 then
          if v_Has_Onetime = 1 then
            Print_New_Row(i_Name   => t('onetime penalty'),
                          i_Amount => v_Onetime_Penalty,
                          i_Style  => 'body_centralized');
          else
            Print_General_Info;
          end if;
        when 15 then
          Print_New_Row(i_Name   => t('total'),
                        i_Amount => i_Part.Amount + v_Onetime_Accrual - v_Onetime_Penalty,
                        i_Style  => 'total');
      end case;
    
      a.Current_Style('root bold');
    end;
  
    --------------------------------------------------
    Procedure Print_Top is
      v_Colspan      number := v_Column_Count_Part_Detail_Sheet - 5;
      v_Manager_Name varchar2(100);
    begin
      a.Current_Style('root bold');
      a.New_Row;
      a.New_Row;
      a.Data(t('staff: $1{staff_name}',
               Href_Util.Staff_Name(i_Company_Id => i_Part.Company_Id,
                                    i_Filial_Id  => i_Part.Filial_Id,
                                    i_Staff_Id   => i_Part.Staff_Id)),
             i_Colspan => v_Colspan);
      Print_General_Info;
    
      a.New_Row;
      a.Data(t('period: from $1{begin_date} to $2{end_date}', i_Part.Part_Begin, v_Part_End),
             i_Colspan => v_Colspan);
      Print_General_Info;
    
      a.New_Row;
      a.Data(t('division: $1{division_name}',
               z_Mhr_Divisions.Load(i_Company_Id => i_Part.Company_Id, i_Filial_Id => i_Part.Filial_Id, i_Division_Id => i_Part.Division_Id).Name),
             i_Colspan => v_Colspan);
      Print_General_Info;
    
      a.New_Row;
      a.Data(t('job: $1{job_name}',
               z_Mhr_Jobs.Load(i_Company_Id => i_Part.Company_Id, i_Filial_Id => i_Part.Filial_Id, i_Job_Id => i_Part.Job_Id).Name),
             i_Colspan => v_Colspan);
      Print_General_Info;
    
      if i_Part.Schedule_Id is not null then
        a.New_Row;
        a.Data(t('schedule: $1{schedule_name}',
                 z_Htt_Schedules.Load(i_Company_Id => i_Part.Company_Id, i_Filial_Id => i_Part.Filial_Id, i_Schedule_Id => i_Part.Schedule_Id).Name),
               i_Colspan => v_Colspan);
        Print_General_Info;
      end if;
    
      if i_Part.Fte_Id is not null then
        a.New_Row;
        a.Data(t('fte: $1{fte_name}',
                 z_Href_Ftes.Load(i_Company_Id => i_Part.Company_Id, i_Fte_Id => i_Part.Fte_Id).Name),
               i_Colspan => v_Colspan);
        Print_General_Info;
      end if;
    
      v_Manager_Name := Href_Util.Get_Manager_Name(i_Company_Id => i_Part.Company_Id,
                                                   i_Filial_Id  => i_Part.Filial_Id,
                                                   i_Staff_Id   => i_Part.Staff_Id);
    
      if v_Manager_Name is not null then
        a.New_Row;
        a.Data(t('manager: $1{manager_name}', v_Manager_Name), i_Colspan => v_Colspan);
        Print_General_Info;
      end if;
    
      while v_Row_Number < 15
      loop
        a.New_Row;
        a.Data('', i_Colspan => v_Colspan);
        Print_General_Info;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
      Print_Header(t('date'), 1, 2, 100);
      Print_Header(t('day'), 1, 2, 50);
    
      v_Column_Count := 3;
    
      if v_Show_Break_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      Print_Header(t('plan'), v_Column_Count, 1, 75);
      Print_Header(t('fact'), 3, 1, 75);
    
      v_Column_Count := 4;
    
      if v_Show_Overtime_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      Print_Header(t('accrued'), v_Column_Count, 1, 75);
    
      v_Column_Count := 4;
    
      if v_Show_Late_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Early_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Lack_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      Print_Header(t('deduction'), v_Column_Count, 1, 75);
      Print_Header(t('total'), 1, 2, 100);
    
      a.New_Row;
    
      a.Data(t('input'));
      a.Data(t('output'));
    
      if v_Show_Break_Time then
        a.Data(t('break time'));
      end if;
    
      a.Data(t('plan time'));
      --
      a.Data(t('input'));
      a.Data(t('output'));
      a.Data(t('fact time'));
      --
      a.Data(t('accrual'));
      a.Data(t('overtime'));
    
      if v_Show_Overtime_Fact then
        a.Data(t('overtime fact'));
      end if;
    
      a.Data(t('nighttime'));
    
      --
      a.Data(t('late'));
    
      if v_Show_Late_Fact then
        a.Data(t('late fact'));
      end if;
    
      a.Data(t('early'));
    
      if v_Show_Early_Fact then
        a.Data(t('early fact'));
      end if;
    
      a.Data(t('lack'));
    
      if v_Show_Lack_Fact then
        a.Data(t('lack fact'));
      end if;
    
      a.Data(t('skip day'));
      a.Data(t('skip mark'));
    end;
  
    --------------------------------------------------
    Procedure Print_Footer is
    begin
      a.Current_Style('footer');
    
      a.New_Row;
    
      v_Column_Count := 8;
    
      if v_Show_Break_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      a.Data(t('total:'), 'footer right', i_Colspan => v_Column_Count);
      a.Data(v_Calc.Get_Value('wage_amount'), 'footer right');
      a.Data(v_Calc.Get_Value('overtime_amount'), 'footer right');
    
      if v_Show_Overtime_Fact then
        Put_Time(v_Calc.Get_Value('overtime_fact'), 'footer right');
      end if;
    
      a.Data(v_Calc.Get_Value('nighttime_amount'), 'footer right');
    
      a.Data(v_Calc.Get_Value('late_amount'), 'footer right');
    
      if v_Show_Late_Fact then
        Put_Time(v_Calc.Get_Value('late_fact'), 'footer right');
      end if;
    
      a.Data(v_Calc.Get_Value('early_amount'), 'footer right');
    
      if v_Show_Early_Fact then
        Put_Time(v_Calc.Get_Value('early_fact'), 'footer right');
      end if;
    
      a.Data(v_Calc.Get_Value('lack_amount'), 'footer right');
    
      if v_Show_Lack_Fact then
        Put_Time(v_Calc.Get_Value('lack_fact'), 'footer right');
      end if;
    
      a.Data(v_Calc.Get_Value('skip_day'), 'footer right');
      a.Data(v_Calc.Get_Value('skip_mark'), 'footer right');
    
      a.Data(v_Calc.Get_Value('total'), 'footer right');
    end;
  
    --------------------------------------------------
    Function Get_Time_Kind_Style
    (
      i_Time_Kind_Id number,
      i_Bg_Color     varchar2,
      i_Color        varchar2
    ) return varchar2 is
      v_Style_Name varchar2(100);
    begin
      return g_Request_Styles(i_Time_Kind_Id);
    exception
      when No_Data_Found then
        v_Style_Name := 'time_kind' || i_Time_Kind_Id;
      
        b_Report.New_Style(i_Style_Name        => v_Style_Name,
                           i_Parent_Style_Name => 'body_centralized',
                           i_Font_Color        => i_Color,
                           i_Background_Color  => i_Bg_Color);
      
        g_Request_Styles(i_Time_Kind_Id) := v_Style_Name;
      
        return v_Style_Name;
    end;
  
    --------------------------------------------------
    Procedure Put_Tk_Facts
    (
      i_Time_Kind_Id number,
      i_Key_Name     varchar2,
      i_Begin_Date   date,
      i_End_Date     date
    ) is
      v_Fact_Seconds number;
      v_Fact_Days    number;
    begin
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Seconds,
                                    o_Fact_Days    => v_Fact_Days,
                                    i_Company_Id   => i_Part.Company_Id,
                                    i_Filial_Id    => i_Part.Filial_Id,
                                    i_Staff_Id     => i_Part.Staff_Id,
                                    i_Time_Kind_Id => i_Time_Kind_Id,
                                    i_Begin_Date   => i_Begin_Date,
                                    i_End_Date     => i_End_Date);
    
      Put_Time(v_Fact_Seconds);
      v_Calc.Plus(i_Key_Name || '_fact', v_Fact_Seconds);
    end;
  
    --------------------------------------------------
    Procedure Set_Calendar_Day
    (
      i_Pcode     varchar2,
      i_Plan_Time varchar2 := null
    ) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind    := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Part.Company_Id,
                                              i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                                                                      i_Pcode      => i_Pcode));
      v_Column_Count := 3;
    
      if v_Show_Break_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      a.Data(r_Time_Kind.Name || case when i_Plan_Time is not null then '(' || i_Plan_Time || ')' else null end,
             Get_Time_Kind_Style(i_Time_Kind_Id => r_Time_Kind.Time_Kind_Id,
                                 i_Bg_Color     => r_Time_Kind.Bg_Color,
                                 i_Color        => r_Time_Kind.Color),
             i_Colspan => v_Column_Count);
    end;
  
    -------------------------------------------------- 
    Function Column_Count_Part_Detail_Sheet return number is
      v_Column_Count number := 17;
    begin
      if v_Show_Break_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Overtime_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Late_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Early_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Lack_Fact then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      return v_Column_Count;
    end;
  
    --------------------------------------------------
    Procedure Put_Tk_Facts_With_Day
    (
      i_Time_Kind_Id number,
      i_Key_Name     varchar2
    ) is
      v_Fact_Seconds number;
      v_Fact_Days    number;
    begin
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Seconds,
                                    o_Fact_Days    => v_Fact_Days,
                                    i_Company_Id   => i_Part.Company_Id,
                                    i_Filial_Id    => i_Part.Filial_Id,
                                    i_Staff_Id     => i_Part.Staff_Id,
                                    i_Time_Kind_Id => i_Time_Kind_Id,
                                    i_Begin_Date   => i_Part.Part_Begin,
                                    i_End_Date     => v_Part_End);
    
      v_Calc.Plus(i_Key_Name || '_time', v_Fact_Seconds);
      v_Calc.Plus(i_Key_Name || '_days', v_Fact_Days);
    end;
  
    -------------------------------------------------- 
    Procedure Put_Lack_n_Skip_Facts(i_Time_Kind_Id number) is
      v_Lack_Seconds   number;
      v_Lack_Days      number;
      v_Skip_Seconds   number;
      v_Skip_Days      number;
      v_Skip_Times     number;
      v_Mark_Skip_Days number;
    begin
      select sum(Tf.Fact_Value), count(*)
        into v_Lack_Seconds, v_Lack_Days
        from Htt_Timesheets t
        join Htt_Timesheet_Facts Tf
          on Tf.Company_Id = t.Company_Id
         and Tf.Filial_Id = t.Filial_Id
         and Tf.Timesheet_Id = t.Timesheet_Id
         and Tf.Time_Kind_Id = i_Time_Kind_Id
         and Tf.Fact_Value < t.Plan_Time
         and Tf.Fact_Value > 0
       where t.Company_Id = i_Part.Company_Id
         and t.Filial_Id = i_Part.Filial_Id
         and t.Staff_Id = i_Part.Staff_Id
         and t.Timesheet_Date between i_Part.Part_Begin and i_Part.Part_End;
    
      select sum(Tf.Fact_Value), count(*)
        into v_Skip_Seconds, v_Skip_Days
        from Htt_Timesheets t
        join Htt_Timesheet_Facts Tf
          on Tf.Company_Id = t.Company_Id
         and Tf.Filial_Id = t.Filial_Id
         and Tf.Timesheet_Id = t.Timesheet_Id
         and Tf.Time_Kind_Id = i_Time_Kind_Id
         and Tf.Fact_Value = t.Plan_Time
         and Tf.Fact_Value > 0
       where t.Company_Id = i_Part.Company_Id
         and t.Filial_Id = i_Part.Filial_Id
         and t.Staff_Id = i_Part.Staff_Id
         and t.Timesheet_Date between i_Part.Part_Begin and i_Part.Part_End;
    
      select sum(t.Planned_Marks - t.Done_Marks), count(*)
        into v_Skip_Times, v_Mark_Skip_Days
        from Htt_Timesheets t
       where t.Company_Id = i_Part.Company_Id
         and t.Filial_Id = i_Part.Filial_Id
         and t.Staff_Id = i_Part.Staff_Id
         and t.Timesheet_Date between i_Part.Part_Begin and i_Part.Part_End
         and t.Day_Kind = Htt_Pref.c_Day_Kind_Work
         and t.Planned_Marks > t.Done_Marks;
    
      v_Calc.Plus('lack_time', Nvl(v_Lack_Seconds, 0));
      v_Calc.Plus('lack_days', v_Lack_Days);
      v_Calc.Plus('day_skip_time', Nvl(v_Skip_Seconds, 0));
      v_Calc.Plus('day_skip_days', v_Skip_Days);
      v_Calc.Plus('mark_skip_times', v_Skip_Times);
      v_Calc.Plus('mark_skip_days', v_Mark_Skip_Days);
    end;
  
    --------------------------------------------------
    Procedure Load_Month_Stats is
      v_Plan_Time number;
      v_Plan_Days number;
    begin
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => i_Part.Company_Id,
                                                   i_Filial_Id  => i_Part.Filial_Id,
                                                   i_Staff_Id   => i_Part.Staff_Id,
                                                   i_Begin_Date => i_Part.Part_Begin,
                                                   i_End_Date   => i_Part.Part_End);
    
      v_Plan_Days := Htt_Util.Calc_Working_Days(i_Company_Id => i_Part.Company_Id,
                                                i_Filial_Id  => i_Part.Filial_Id,
                                                i_Staff_Id   => i_Part.Staff_Id,
                                                i_Begin_Date => i_Part.Part_Begin,
                                                i_End_Date   => i_Part.Part_End);
    
      v_Calc.Plus('plan_time', v_Plan_Time);
      v_Calc.Plus('plan_days', v_Plan_Days);
    
      -- turnout
      Put_Tk_Facts_With_Day(v_Turnout_Id, 'wage');
    
      -- overtime
      Put_Tk_Facts_With_Day(v_Overtime_Id, 'overtime');
    
      -- late
      Put_Tk_Facts_With_Day(v_Late_Id, 'late');
    
      -- early
      Put_Tk_Facts_With_Day(v_Early_Id, 'early');
    
      -- put time and days for lack and day skips
      Put_Lack_n_Skip_Facts(v_Lack_Id);
    end;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Part.Company_Id,
                                  i_Filial_Id  => i_Part.Filial_Id,
                                  i_Staff_Id   => i_Part.Staff_Id);
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Staff.Employee_Id);
  
    if Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => i_Part.Job_Id,
                                           i_Employee_Id => r_Staff.Employee_Id) = 'N' then
      Hpr_Error.Raise_046;
    end if;
  
    v_Part_End := Least(i_Part.Part_End, Nvl(r_Staff.Dismissal_Date, i_Part.Part_End));
  
    if v_Show_Onetime and i_Part.Part_Begin = Trunc(i_Part.Part_Begin, 'mon') and
       i_Part.Part_End = Last_Day(i_Part.Part_End) then
    
      select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0), count(*)
        into v_Onetime_Accrual, --
             v_Onetime_Penalty,
             v_Has_Onetime
        from Hpr_Onetime_Sheet_Staffs p
       where p.Company_Id = i_Part.Company_Id
         and p.Filial_Id = i_Part.Filial_Id
         and p.Staff_Id = i_Part.Staff_Id
         and p.Month = i_Part.Part_Begin
         and exists (select *
                from Hpr_Wage_Sheets q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Sheet_Id = p.Sheet_Id
                 and q.Posted = 'Y');
    
      if v_Has_Onetime > 0 then
        v_Has_Onetime := 1;
      end if;
    end if;
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Overtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Early_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                        i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
  
    v_Lack_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Part.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    v_Column_Count_Part_Detail_Sheet := Column_Count_Part_Detail_Sheet;
  
    Load_Month_Stats;
  
    -- info
    Print_Top;
  
    -- header
    Print_Header;
  
    -- body
    a.Current_Style('body_centralized');
  
    v_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Part.Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_Oper_Type_Id := Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => i_Part.Company_Id,
                                                        i_Filial_Id     => i_Part.Filial_Id,
                                                        i_Staff_Id      => i_Part.Staff_Id,
                                                        i_Oper_Group_Id => v_Oper_Group_Id,
                                                        i_Period        => i_Part.Part_Begin);
  
    v_Overtime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Part.Company_Id,
                                                i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Overtime);
  
    v_Nighttime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Part.Company_Id,
                                                 i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Nighttime);
  
    v_Hourly_Wage := Hpr_Util.Calc_Hourly_Wage(i_Company_Id   => i_Part.Company_Id,
                                               i_Filial_Id    => i_Part.Filial_Id,
                                               i_Staff_Id     => i_Part.Staff_Id,
                                               i_Oper_Type_Id => v_Oper_Type_Id,
                                               i_Schedule_Id  => i_Part.Schedule_Id,
                                               i_Part_Begin   => i_Part.Part_Begin,
                                               i_Part_End     => v_Part_End);
  
    v_Daily_Penalties := Hpr_Util.Calc_Daily_Penalty_Amounts(i_Company_Id   => i_Part.Company_Id,
                                                             i_Filial_Id    => i_Part.Filial_Id,
                                                             i_Staff_Id     => i_Part.Staff_Id,
                                                             i_Division_Id  => i_Part.Division_Id,
                                                             i_Hourly_Wage  => v_Hourly_Wage,
                                                             i_Period_Begin => i_Part.Part_Begin,
                                                             i_Period_End   => v_Part_End);
  
    for r in (select q.Timesheet_Date,
                     q.Day_Kind,
                     q.Break_Enabled,
                     q.Plan_Time,
                     q.Begin_Time,
                     q.End_Time,
                     q.Break_Begin_Time,
                     q.Break_End_Time,
                     q.Input_Time,
                     q.Output_Time
                from Htt_Timesheets q
               where q.Company_Id = i_Part.Company_Id
                 and q.Filial_Id = i_Part.Filial_Id
                 and q.Staff_Id = i_Part.Staff_Id
                 and q.Timesheet_Date between i_Part.Part_Begin and v_Part_End)
    loop
      a.New_Row;
      a.Data(to_char(r.Timesheet_Date, 'dd/mm/yyyy'));
      a.Data(to_char(r.Timesheet_Date, 'Dy', v_Nls_Language));
    
      -- plan
      case r.Day_Kind
        when Htt_Pref.c_Day_Kind_Work then
          a.Data(to_char(r.Begin_Time, Href_Pref.c_Time_Format_Minute));
          a.Data(to_char(r.End_Time, Href_Pref.c_Time_Format_Minute));
        
          if v_Show_Break_Time then
            a.Data(to_char(r.Break_Begin_Time, Href_Pref.c_Time_Format_Minute) || '-' ||
                   to_char(r.Break_End_Time, Href_Pref.c_Time_Format_Minute));
          end if;
        
          Put_Time(r.Plan_Time);
        
        when Htt_Pref.c_Day_Kind_Rest then
          v_Column_Count := 3;
        
          if v_Show_Break_Time then
            v_Column_Count := v_Column_Count + 1;
          end if;
        
          a.Data(t('rest day'), 'rest', i_Colspan => v_Column_Count);
        when Htt_Pref.c_Day_Kind_Holiday then
          Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Holiday);
        when Htt_Pref.c_Day_Kind_Additional_Rest then
          Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
        when Htt_Pref.c_Day_Kind_Nonworking then
          Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Nonworking,
                           Htt_Util.To_Time_Text(Round(r.Plan_Time / 60, 2)));
        else
          a.Add_Data(3);
      end case;
    
      -- fact
      a.Data(to_char(r.Input_Time, Href_Pref.c_Time_Format_Minute));
      a.Data(to_char(r.Output_Time, Href_Pref.c_Time_Format_Minute));
      Put_Tk_Facts(v_Turnout_Id, 'turnout', r.Timesheet_Date, r.Timesheet_Date);
    
      v_Wage_Amount := v_Round_Model.Eval(Hpr_Util.Calc_Amount(i_Company_Id   => i_Part.Company_Id,
                                                               i_Filial_Id    => i_Part.Filial_Id,
                                                               i_Staff_Id     => i_Part.Staff_Id,
                                                               i_Oper_Type_Id => v_Oper_Type_Id,
                                                               i_Part_Begin   => r.Timesheet_Date,
                                                               i_Part_End     => r.Timesheet_Date));
    
      v_Overtime_Amount := v_Round_Model.Eval(Hpr_Util.Calc_Amount(i_Company_Id   => i_Part.Company_Id,
                                                                   i_Filial_Id    => i_Part.Filial_Id,
                                                                   i_Staff_Id     => i_Part.Staff_Id,
                                                                   i_Oper_Type_Id => v_Overtime_Type_Id,
                                                                   i_Part_Begin   => r.Timesheet_Date,
                                                                   i_Part_End     => r.Timesheet_Date));
    
      v_Nighttime_Amount := v_Round_Model.Eval(Hpr_Util.Calc_Amount(i_Company_Id   => i_Part.Company_Id,
                                                                    i_Filial_Id    => i_Part.Filial_Id,
                                                                    i_Staff_Id     => i_Part.Staff_Id,
                                                                    i_Oper_Type_Id => v_Nighttime_Type_Id,
                                                                    i_Part_Begin   => r.Timesheet_Date,
                                                                    i_Part_End     => r.Timesheet_Date));
    
      v_Late_Amount      := v_Round_Model.Eval(v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (1));
      v_Early_Amount     := v_Round_Model.Eval(v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (2));
      v_Lack_Amount      := v_Round_Model.Eval(v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (3));
      v_Day_Skip_Amount  := v_Round_Model.Eval(v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (4));
      v_Mark_Skip_Amount := v_Round_Model.Eval(v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (5));
    
      v_Total_Amount := v_Wage_Amount + v_Overtime_Amount + v_Nighttime_Amount - v_Late_Amount -
                        v_Early_Amount - v_Lack_Amount - v_Day_Skip_Amount - v_Mark_Skip_Amount;
    
      a.Data(v_Wage_Amount);
      a.Data(v_Overtime_Amount);
    
      if v_Show_Overtime_Fact then
        Put_Tk_Facts(v_Overtime_Id, 'overtime', r.Timesheet_Date, r.Timesheet_Date);
      end if;
    
      a.Data(v_Nighttime_Amount);
      a.Data(v_Late_Amount);
    
      if v_Show_Late_Fact then
        Put_Tk_Facts(v_Late_Id, 'late', r.Timesheet_Date, r.Timesheet_Date);
      end if;
    
      a.Data(v_Early_Amount);
    
      if v_Show_Early_Fact then
        Put_Tk_Facts(v_Early_Id, 'early', r.Timesheet_Date, r.Timesheet_Date);
      end if;
    
      a.Data(v_Lack_Amount);
    
      if v_Show_Lack_Fact then
        Put_Tk_Facts(v_Lack_Id, 'lack', r.Timesheet_Date, r.Timesheet_Date);
      end if;
    
      a.Data(v_Day_Skip_Amount);
      a.Data(v_Mark_Skip_Amount);
      a.Data(v_Total_Amount);
    
      v_Calc.Plus('skip_day', v_Day_Skip_Amount);
      v_Calc.Plus('skip_mark', v_Mark_Skip_Amount);
      v_Calc.Plus('wage_amount', v_Wage_Amount);
      v_Calc.Plus('overtime_amount', v_Overtime_Amount);
      v_Calc.Plus('nighttime_amount', v_Nighttime_Amount);
      v_Calc.Plus('late_amount', v_Late_Amount);
      v_Calc.Plus('early_amount', v_Early_Amount);
      v_Calc.Plus('lack_amount', v_Lack_Amount);
      v_Calc.Plus('total', v_Total_Amount);
    end loop;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name, --
                       p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Rt varchar2(50) := p.o_Varchar2('rt');
  
    r_Sheet   Hpr_Wage_Sheets%rowtype;
    r_Part    Hpr_Sheet_Parts%rowtype;
    v_Part_Id number := p.o_Number('part_id');
    v_Param   Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
    
      if v_Param.Has('part_id') then
        v_Param := Fazo.Zip_Map('part_id', v_Param.r_Number('part_id'));
        v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
        b_Report.Redirect_To_Report('/vhr/hpr/start/wage_sheet_list:run', v_Param);
      end if;
    else
      b_Report.Open_Book_With_Styles(i_Report_Type => v_Rt, --
                                     i_File_Name   => Ui.Current_Form_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
      -- rest
      b_Report.New_Style(i_Style_Name        => 'rest',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Font_Color        => '#16365c',
                         i_Background_Color  => '#daeef3');
      -- success
      b_Report.New_Style(i_Style_Name        => 'success',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#bfefed');
      -- danger
      b_Report.New_Style(i_Style_Name        => 'danger',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#fccdd2');
      -- total
      b_Report.New_Style(i_Style_Name        => 'total',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#decefe');
    
      if v_Part_Id is not null then
        r_Part := z_Hpr_Sheet_Parts.Load(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Part_Id    => v_Part_Id);
      
        Run_Staff(r_Part);
      else
        r_Sheet := z_Hpr_Wage_Sheets.Load(i_Company_Id => Ui.Company_Id, --
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Sheet_Id   => p.r_Number('sheet_id'));
      
        if r_Sheet.Posted != 'Y' then
          b.Raise_Error(t('sheet is not posted, sheet_id=$1', r_Sheet.Sheet_Id));
        end if;
      
        Run_Wage_Sheet(r_Sheet);
      end if;
    
      b_Report.Close_Book();
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpr_Wage_Sheets
       set Company_Id   = null,
           Filial_Id    = null,
           Sheet_Id     = null,
           Sheet_Number = null,
           Sheet_Date   = null,
           month        = null,
           Period_Begin = null,
           Period_End   = null,
           Period_Kind  = null,
           Posted       = null,
           Note         = null,
           Sheet_Kind   = null,
           Created_By   = null,
           Created_On   = null,
           Modified_By  = null,
           Modified_On  = null;
    update Hpr_Wage_Sheet_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Sheet_Id    = null,
           Division_Id = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           name        = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Employee_Id    = null,
           Dismissal_Date = null;
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
  end;

end Ui_Vhr315;
/
