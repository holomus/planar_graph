create or replace package Ui_Vhr308 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Part_Details(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Period_Wages(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
end Ui_Vhr308;
/
create or replace package body Ui_Vhr308 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
  
    q                      Fazo_Query;
    v_Period_Begin         date := p.r_Date('period_begin');
    v_Period_End           date := p.r_Date('period_end');
    v_Division_Ids         Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Period_Kind          varchar2(1) := p.o_Varchar2('period_kind');
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  begin
    v_Query := 'select st.*
                  from (select s.*,
                               case
                                  when :access_all_employees = ''N'' or :division_count > 0 then
                                   hpd_util.get_closest_org_unit_id(s.company_id,
                                                                    s.filial_id,
                                                                    s.staff_id,
                                                                    least(:period_end,
                                                                          nvl(s.dismissal_date, :period_end)))
                                  else
                                   null
                                end cur_division_id
                          from href_staffs s
                         where s.company_id = :company_id
                           and s.filial_id = :filial_id
                           and s.staff_kind = :primary_kind
                           and s.state = ''A''
                           and s.hiring_date <= :period_end
                           and (s.dismissal_date is null or s.dismissal_date >= :period_begin)
                           and uit_hrm.access_to_hidden_salary_job(i_job_id      => hpd_util.get_closest_job_id(s.company_id,
                                                                                                                s.filial_id,
                                                                                                                s.staff_id,
                                                                                                                least(:period_end,
                                                                                                                      nvl(s.dismissal_date,
                                                                                                                          :period_end))),
                                                                   i_employee_id => s.employee_id) = ''Y''
                           and not exists (select 1
                                  from hpr_sheet_parts p
                                 where p.company_id = :company_id
                                   and p.filial_id = :filial_id
                                   and p.staff_id = s.staff_id
                                   and p.part_begin <= :period_end
                                   and p.part_end >= :period_begin
                                   and exists (select 1
                                          from hpr_wage_sheets ws
                                         where ws.company_id = p.company_id
                                           and ws.filial_id = p.filial_id
                                           and ws.sheet_id = p.sheet_id
                                           and ws.sheet_id <> nvl(:sheet_id, -1)
                                           and ws.posted = ''Y''))
                           and not exists (select 1
                                  from href_util.staff_licensed_period(:company_id,
                                                                       :filial_id,
                                                                       s.staff_id,
                                                                       :period_begin,
                                                                       :period_end) lp
                                 where lp.licensed = ''N'')';
  
    if v_Period_Kind is not null then
      v_Query := v_Query ||
                 ' and hpd_util.get_closest_oper_type_id(i_company_id    => :company_id,
                                                         i_filial_id     => :filial_id,
                                                         i_staff_id      => s.staff_id,
                                                         i_oper_group_id => :wage_oper_group_id,
                                                         i_period        => :period_end) = :wage_hourly_oper_type_id';
    end if;
  
    v_Query := v_Query ||
               ') st where (:division_count = 0 or st.cur_division_id member of :division)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'period_begin',
                             v_Period_Begin,
                             'period_end',
                             v_Period_End,
                             'sheet_id',
                             p.o_Number('sheet_id'));
  
    v_Params.Put('division', v_Division_Ids);
    v_Params.Put('division_count', v_Division_Ids.Count);
    v_Params.Put('primary_kind', Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('access_all_employees', v_Access_All_Employees);
  
    if v_Period_Kind is not null then
      v_Params.Put('wage_oper_group_id',
                   Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage));
      v_Params.Put('wage_hourly_oper_type_id',
                   Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id,
                                         i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly));
    end if;
  
    if v_Access_All_Employees = 'N' then
      v_Query := v_Query || --
                 ' and (st.employee_id = :user_id or
                        st.cur_division_id member of :division_ids)';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Params.Put('user_id', Ui.User_Id);
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
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap is
    v_Company_Id         number := Ui.Company_Id;
    v_Filial_Id          number := Ui.Filial_Id;
    v_Period_Begin       date := p.r_Date('period_begin');
    v_Period_End         date := p.r_Date('period_end');
    v_Sheet_Id           number := p.o_Number('sheet_id');
    v_Wage_Oper_Group_Id number := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                          i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    v_Hourly_Wage_Id     number := Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly);
    v_Array              Array_Number;
    v_Access_Ids         Array_Number;
    result               Hashmap := Hashmap();
  begin
    select Sp.Staff_Id
      bulk collect
      into v_Array
      from Hpr_Wage_Sheets Ws
      join Hpr_Sheet_Parts Sp
        on Sp.Company_Id = Ws.Company_Id
       and Sp.Filial_Id = Ws.Filial_Id
       and Sp.Sheet_Id = Ws.Sheet_Id
     where Ws.Company_Id = v_Company_Id
       and Ws.Filial_Id = v_Filial_Id
       and Ws.Sheet_Id <> Nvl(v_Sheet_Id, -1)
       and Ws.Period_End >= v_Period_Begin
       and Ws.Period_Begin <= v_Period_End
       and Ws.Posted = 'Y'
     group by Sp.Staff_Id
    union
    select s.Staff_Id
      from Href_Staffs s
     where s.Company_Id = v_Company_Id
       and s.Filial_Id = v_Filial_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= v_Period_End
       and Nvl(s.Dismissal_Date, v_Period_Begin) >= v_Period_Begin
       and (Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => s.Company_Id,
                                                                                             i_Filial_Id  => s.Filial_Id,
                                                                                             i_Staff_Id   => s.Staff_Id,
                                                                                             i_Period     => Least(Nvl(s.Dismissal_Date,
                                                                                                                       v_Period_End),
                                                                                                                   v_Period_End)),
                                                i_Employee_Id => s.Employee_Id) = 'N' or -- 
           exists (select 1
                     from Href_Util.Staff_Licensed_Period(i_Company_Id   => v_Company_Id,
                                                          i_Filial_Id    => v_Filial_Id,
                                                          i_Staff_Id     => s.Staff_Id,
                                                          i_Period_Begin => v_Period_Begin,
                                                          i_Period_End   => v_Period_End) Lp
                    where Lp.Licensed = 'N'));
  
    Result.Put('staff_ids', v_Array);
  
    if p.o_Varchar2('period_kind') is not null then
      select s.Staff_Id
        bulk collect
        into v_Access_Ids
        from Href_Staffs s
       where s.Company_Id = v_Company_Id
         and s.Filial_Id = v_Filial_Id
         and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and s.State = 'A'
         and s.Hiring_Date <= v_Period_End
         and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Period_Begin)
         and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(s.Company_Id,
                                                                                              s.Filial_Id,
                                                                                              s.Staff_Id,
                                                                                              Least(v_Period_End,
                                                                                                    Nvl(s.Dismissal_Date,
                                                                                                        v_Period_End))),
                                                 i_Employee_Id => s.Employee_Id) = 'Y'
         and not exists (select 1
                from Hpr_Sheet_Parts p
               where p.Company_Id = v_Company_Id
                 and p.Filial_Id = v_Filial_Id
                 and p.Staff_Id = s.Staff_Id
                 and p.Part_Begin <= v_Period_End
                 and p.Part_End >= v_Period_Begin
                 and exists (select 1
                        from Hpr_Wage_Sheets Ws
                       where Ws.Company_Id = p.Company_Id
                         and Ws.Filial_Id = p.Filial_Id
                         and Ws.Sheet_Id = p.Sheet_Id
                         and Ws.Sheet_Id <> Nvl(v_Sheet_Id, -1)
                         and Ws.Posted = 'Y'))
         and not exists
       (select 1
                from Href_Util.Staff_Licensed_Period(v_Company_Id,
                                                     v_Filial_Id,
                                                     s.Staff_Id,
                                                     v_Period_Begin,
                                                     v_Period_End) Lp
               where Lp.Licensed = 'N')
         and Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => v_Company_Id,
                                               i_Filial_Id     => v_Filial_Id,
                                               i_Staff_Id      => s.Staff_Id,
                                               i_Oper_Group_Id => v_Wage_Oper_Group_Id,
                                               i_Period        => v_Period_End) = v_Hourly_Wage_Id;
    
      select Column_Value
        bulk collect
        into v_Array
        from table(v_Access_Ids)
      minus
      select Column_Value
        from table(v_Array);
    
      Result.Put('access_staff_ids', v_Array);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Part_Details(p Hashmap) return Hashmap is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Staff_Id       number := p.r_Number('staff_id');
    v_Division_Id    number := p.r_Number('division_id');
    v_Schedule_Id    number := p.r_Number('schedule_id');
    v_Part_Begin     date := p.r_Date('part_begin');
    v_Part_End       date := p.r_Date('part_end');
    v_Start_Of_Month date := Trunc(v_Part_Begin, 'mon');
    v_Fte_Id         number := p.o_Number('fte_id');
    v_Round_Value    varchar2(5) := p.r_Varchar2('round_value');
    v_Model_Round    Round_Model := Round_Model(v_Round_Value);
  
    v_Access_To_Hidden_Salary varchar2(1);
    r_Robot                   Mrf_Robots%rowtype;
    r_Staff                   Href_Staffs%rowtype;
  
    v_Overtime_Type_Id  number;
    v_Oper_Type_Id      number;
    v_Oper_Group_Id     number;
    v_Hourly_Wage       number;
    v_Nighttime_Type_Id number;
  
    v_Late_Id     number;
    v_Early_Id    number;
    v_Lack_Id     number;
    v_Turnout_Id  number;
    v_Overtime_Id number;
  
    v_Wage_Amount      number;
    v_Overtime_Amount  number;
    v_Nighttime_Amount number;
    v_Late_Amount      number;
    v_Early_Amount     number;
    v_Lack_Amount      number;
    v_Day_Skip_Amount  number;
    v_Mark_Skip_Amount number;
    v_Total_Amount     number;
    v_Onetime_Accrual  number;
    v_Onetime_Penalty  number;
    v_Onetime_Count    number;
    v_Daily_Penalties  Matrix_Number;
  
    v_Day_Info Hashmap;
    v_Days     Arraylist := Arraylist();
    result     Hashmap := Hashmap();
  
    -------------------------------------------------- 
    Function Day_Index(i_Date date) return number is
    begin
      return i_Date - v_Start_Of_Month + 1;
    end;
  
    -------------------------------------------------- 
    Function Get_Fte_Name return varchar2 is
    begin
      if v_Fte_Id is not null then
        return z_Href_Ftes.Load(i_Company_Id => v_Company_Id, --
                                i_Fte_Id     => v_Fte_Id).Name;
      else
        return Hpd_Util.Closest_Robot(i_Company_Id => v_Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Staff_Id   => v_Staff_Id,
                                      i_Period     => v_Part_End).Fte;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Put_Tk_Facts
    (
      p_Map          in out nocopy Hashmap,
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
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => v_Staff_Id,
                                    i_Time_Kind_Id => i_Time_Kind_Id,
                                    i_Begin_Date   => i_Begin_Date,
                                    i_End_Date     => i_End_Date);
      p_Map.Put(i_Key_Name || '_time', Htt_Util.To_Time_Seconds_Text(v_Fact_Seconds, true, true));
      p_Map.Put(i_Key_Name || '_days', v_Fact_Days);
    end;
  
    -------------------------------------------------- 
    Procedure Put_Lack_n_Skip_Facts
    (
      p_Map          in out nocopy Hashmap,
      i_Time_Kind_Id number,
      i_Begin_Date   date,
      i_End_Date     date
    ) is
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
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
    
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
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
    
      select sum(t.Planned_Marks - t.Done_Marks), count(*)
        into v_Skip_Times, v_Mark_Skip_Days
        from Htt_Timesheets t
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date
         and t.Day_Kind = Htt_Pref.c_Day_Kind_Work
         and t.Planned_Marks > t.Done_Marks;
    
      p_Map.Put('lack_time', Htt_Util.To_Time_Seconds_Text(Nvl(v_Lack_Seconds, 0), true, true));
      p_Map.Put('lack_days', v_Lack_Days);
      p_Map.Put('day_skip_time', Htt_Util.To_Time_Seconds_Text(Nvl(v_Skip_Seconds, 0), true, true));
      p_Map.Put('day_skip_days', v_Skip_Days);
      p_Map.Put('mark_skip_times', v_Skip_Times);
      p_Map.Put('mark_skip_days', v_Mark_Skip_Days);
    end;
  
    --------------------------------------------------
    Function Load_Month_Stats return Hashmap is
      v_Monthly_Time number;
      v_Monthly_Days number;
      v_Plan_Time    number;
      v_Plan_Days    number;
    
      Month_Stats Hashmap;
    begin
      v_Monthly_Time := Htt_Util.Calc_Plan_Minutes(i_Company_Id  => v_Company_Id,
                                                   i_Filial_Id   => v_Filial_Id,
                                                   i_Staff_Id    => v_Staff_Id,
                                                   i_Schedule_Id => v_Schedule_Id,
                                                   i_Period      => v_Part_End);
    
      v_Monthly_Days := Htt_Util.Calc_Plan_Days(i_Company_Id  => v_Company_Id,
                                                i_Filial_Id   => v_Filial_Id,
                                                i_Staff_Id    => v_Staff_Id,
                                                i_Schedule_Id => v_Schedule_Id,
                                                i_Period      => v_Part_End);
    
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => v_Filial_Id,
                                                   i_Staff_Id   => v_Staff_Id,
                                                   i_Begin_Date => v_Part_Begin,
                                                   i_End_Date   => v_Part_End);
    
      v_Plan_Days := Htt_Util.Calc_Working_Days(i_Company_Id => v_Company_Id,
                                                i_Filial_Id  => v_Filial_Id,
                                                i_Staff_Id   => v_Staff_Id,
                                                i_Begin_Date => v_Part_Begin,
                                                i_End_Date   => v_Part_End);
    
      Month_Stats := Fazo.Zip_Map('monthly_time',
                                  Htt_Util.To_Time_Text(v_Monthly_Time, true, true),
                                  'monthly_days',
                                  v_Monthly_Days,
                                  'plan_time',
                                  Htt_Util.To_Time_Seconds_Text(v_Plan_Time, true, true),
                                  'plan_days',
                                  v_Plan_Days);
    
      -- turnout
      Put_Tk_Facts(Month_Stats, v_Turnout_Id, 'turnout', v_Part_Begin, v_Part_End);
    
      -- overtime
      Put_Tk_Facts(Month_Stats, v_Overtime_Id, 'overtime', v_Part_Begin, v_Part_End);
    
      -- late
      Put_Tk_Facts(Month_Stats, v_Late_Id, 'late', v_Part_Begin, v_Part_End);
    
      -- early
      Put_Tk_Facts(Month_Stats, v_Early_Id, 'early', v_Part_Begin, v_Part_End);
    
      -- put time and days for lack and day skips
      Put_Lack_n_Skip_Facts(Month_Stats, v_Lack_Id, v_Part_Begin, v_Part_End);
    
      return Month_Stats;
    end;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => v_Staff_Id);
  
    v_Part_End := Least(v_Part_End, Nvl(r_Staff.Dismissal_Date, v_Part_End));
  
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => v_Company_Id,
                                          i_Filial_Id  => v_Filial_Id,
                                          i_Staff_Id   => v_Staff_Id,
                                          i_Period     => v_Part_End);
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Robot.Person_Id);
  
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Robot.Job_Id,
                                                                     i_Employee_Id => r_Robot.Person_Id);
  
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'N' then
      return result;
    end if;
  
    v_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_Oper_Type_Id := Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => v_Company_Id,
                                                        i_Filial_Id     => v_Filial_Id,
                                                        i_Staff_Id      => v_Staff_Id,
                                                        i_Oper_Group_Id => v_Oper_Group_Id,
                                                        i_Period        => v_Part_Begin);
  
    v_Overtime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => v_Company_Id,
                                                i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Overtime);
  
    v_Nighttime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => v_Company_Id,
                                                 i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Nighttime);
  
    v_Hourly_Wage := Hpr_Util.Calc_Hourly_Wage(i_Company_Id   => v_Company_Id,
                                               i_Filial_Id    => v_Filial_Id,
                                               i_Staff_Id     => v_Staff_Id,
                                               i_Oper_Type_Id => v_Oper_Type_Id,
                                               i_Schedule_Id  => v_Schedule_Id,
                                               i_Part_Begin   => v_Part_Begin,
                                               i_Part_End     => v_Part_End);
  
    v_Daily_Penalties := Hpr_Util.Calc_Daily_Penalty_Amounts(i_Company_Id   => v_Company_Id,
                                                             i_Filial_Id    => v_Filial_Id,
                                                             i_Staff_Id     => v_Staff_Id,
                                                             i_Division_Id  => v_Division_Id,
                                                             i_Hourly_Wage  => v_Hourly_Wage,
                                                             i_Period_Begin => v_Part_Begin,
                                                             i_Period_End   => v_Part_End);
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Overtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Early_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                        i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
  
    v_Lack_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
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
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Staff_Id = v_Staff_Id
                 and q.Timesheet_Date between v_Part_Begin and v_Part_End)
    loop
      v_Day_Info := Fazo.Zip_Map('timesheet_date', --
                                 r.Timesheet_Date,
                                 'day_kind',
                                 r.Day_Kind,
                                 'break_enabled',
                                 r.Break_Enabled);
    
      v_Day_Info.Put('begin_time', to_char(r.Begin_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('end_time', to_char(r.End_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('input_time', to_char(r.Input_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('output_time', to_char(r.Output_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('break_begin_time',
                     to_char(r.Break_Begin_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('break_end_time', to_char(r.Break_End_Time, Href_Pref.c_Time_Format_Minute));
    
      v_Day_Info.Put('plan_time', Htt_Util.To_Time_Seconds_Text(r.Plan_Time, true, true));
    
      -- turnout
      Put_Tk_Facts(v_Day_Info, v_Turnout_Id, 'turnout', r.Timesheet_Date, r.Timesheet_Date);
    
      -- overtime
      Put_Tk_Facts(v_Day_Info, v_Overtime_Id, 'overtime', r.Timesheet_Date, r.Timesheet_Date);
    
      -- late
      Put_Tk_Facts(v_Day_Info, v_Late_Id, 'late', r.Timesheet_Date, r.Timesheet_Date);
    
      -- early
      Put_Tk_Facts(v_Day_Info, v_Early_Id, 'early', r.Timesheet_Date, r.Timesheet_Date);
    
      -- lack
      Put_Tk_Facts(v_Day_Info, v_Lack_Id, 'lack', r.Timesheet_Date, r.Timesheet_Date);
    
      v_Wage_Amount := Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                            i_Filial_Id    => v_Filial_Id,
                                            i_Staff_Id     => v_Staff_Id,
                                            i_Oper_Type_Id => v_Oper_Type_Id,
                                            i_Part_Begin   => r.Timesheet_Date,
                                            i_Part_End     => r.Timesheet_Date);
    
      v_Overtime_Amount := Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                                i_Filial_Id    => v_Filial_Id,
                                                i_Staff_Id     => v_Staff_Id,
                                                i_Oper_Type_Id => v_Overtime_Type_Id,
                                                i_Part_Begin   => r.Timesheet_Date,
                                                i_Part_End     => r.Timesheet_Date);
    
      v_Nighttime_Amount := Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                                 i_Filial_Id    => v_Filial_Id,
                                                 i_Staff_Id     => v_Staff_Id,
                                                 i_Oper_Type_Id => v_Nighttime_Type_Id,
                                                 i_Part_Begin   => r.Timesheet_Date,
                                                 i_Part_End     => r.Timesheet_Date);
    
      v_Late_Amount      := v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (1);
      v_Early_Amount     := v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (2);
      v_Lack_Amount      := v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (3);
      v_Day_Skip_Amount  := v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (4);
      v_Mark_Skip_Amount := v_Daily_Penalties(Day_Index(r.Timesheet_Date)) (5);
    
      v_Wage_Amount      := v_Model_Round.Eval(v_Wage_Amount);
      v_Overtime_Amount  := v_Model_Round.Eval(v_Overtime_Amount);
      v_Nighttime_Amount := v_Model_Round.Eval(v_Nighttime_Amount);
      v_Late_Amount      := v_Model_Round.Eval(v_Late_Amount);
      v_Early_Amount     := v_Model_Round.Eval(v_Early_Amount);
      v_Lack_Amount      := v_Model_Round.Eval(v_Lack_Amount);
      v_Day_Skip_Amount  := v_Model_Round.Eval(v_Day_Skip_Amount);
      v_Mark_Skip_Amount := v_Model_Round.Eval(v_Mark_Skip_Amount);
    
      v_Total_Amount := v_Wage_Amount + v_Overtime_Amount + v_Nighttime_Amount - v_Late_Amount -
                        v_Early_Amount - v_Lack_Amount - v_Day_Skip_Amount - v_Mark_Skip_Amount;
    
      v_Day_Info.Put('wage_amount', v_Wage_Amount);
      v_Day_Info.Put('overtime_amount', v_Overtime_Amount);
      v_Day_Info.Put('nighttime_amount', v_Nighttime_Amount);
      v_Day_Info.Put('late_amount', v_Late_Amount);
      v_Day_Info.Put('early_amount', v_Early_Amount);
      v_Day_Info.Put('lack_amount', v_Lack_Amount);
      v_Day_Info.Put('day_skip_amount', v_Day_Skip_Amount);
      v_Day_Info.Put('mark_skip_amount', v_Mark_Skip_Amount);
      v_Day_Info.Put('total_amount', v_Total_Amount);
    
      v_Days.Push(v_Day_Info);
    end loop;
  
    if v_Part_Begin = Trunc(v_Part_Begin, 'mon') and v_Part_End = Last_Day(v_Part_End) then
      select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0), count(*)
        into v_Onetime_Accrual, --
             v_Onetime_Penalty,
             v_Onetime_Count
        from Hpr_Onetime_Sheet_Staffs p
       where p.Company_Id = v_Company_Id
         and p.Filial_Id = v_Filial_Id
         and p.Staff_Id = v_Staff_Id
         and p.Month = v_Part_Begin
         and exists (select *
                from Hpr_Wage_Sheets q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Sheet_Id = p.Sheet_Id
                 and q.Posted = 'Y');
    
      if v_Onetime_Count > 0 then
        Result.Put('onetime_accrual', v_Onetime_Accrual);
        Result.Put('onetime_penalty', v_Onetime_Penalty);
      end if;
    end if;
  
    Result.Put('days', v_Days);
    Result.Put('month_stats', Load_Month_Stats);
    Result.Put('fte_name', Get_Fte_Name);
    Result.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id => v_Company_Id,
                                          i_Filial_Id  => v_Filial_Id,
                                          i_Staff_Id   => v_Staff_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Ids
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Division_Ids Array_Number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Period_Kind  varchar2 := null
  ) return Array_Number is
    v_Division_Count      number := i_Division_Ids.Count;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Division_Id         Array_Number;
    v_Wage_Group_Id       number := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    v_Hourly_Wage_Id      number := Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id,
                                                          i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly);
    result                Array_Number;
  begin
    if v_Access_All_Employee = 'N' then
      v_Division_Id := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    select St.Staff_Id
      bulk collect
      into result
      from (select s.Staff_Id,
                   s.Employee_Id,
                   case
                      when v_Access_All_Employee = 'N' or v_Division_Count > 0 then
                       Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => s.Company_Id,
                                                        i_Filial_Id  => s.Filial_Id,
                                                        i_Staff_Id   => s.Staff_Id,
                                                        i_Period     => Least(i_Period_End,
                                                                              Nvl(s.Dismissal_Date,
                                                                                  i_Period_End)))
                      else
                       null
                    end Division_Id
              from Href_Staffs s
             where s.Company_Id = i_Company_Id
               and s.Filial_Id = i_Filial_Id
               and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and s.State = 'A'
               and s.Hiring_Date <= i_Period_End
               and (s.Dismissal_Date is null or s.Dismissal_Date >= i_Period_Begin)
               and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => s.Company_Id,
                                                                                                    i_Filial_Id  => s.Filial_Id,
                                                                                                    i_Staff_Id   => s.Staff_Id,
                                                                                                    i_Period     => Least(i_Period_End,
                                                                                                                          Nvl(s.Dismissal_Date,
                                                                                                                              i_Period_End))),
                                                       i_Employee_Id => s.Employee_Id) = 'Y'
               and not exists (select 1
                      from Hpr_Sheet_Parts p
                     where p.Company_Id = i_Company_Id
                       and p.Filial_Id = i_Filial_Id
                       and p.Staff_Id = s.Staff_Id
                       and p.Sheet_Id <> Nvl(i_Sheet_Id, -1)
                       and p.Part_Begin <= i_Period_End
                       and p.Part_End >= i_Period_Begin
                       and exists (select *
                              from Hpr_Wage_Sheets Ws
                             where Ws.Company_Id = p.Company_Id
                               and Ws.Filial_Id = p.Filial_Id
                               and Ws.Sheet_Id = p.Sheet_Id
                               and Ws.Posted = 'Y'))
               and exists (select 1
                      from Href_Util.Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                                           i_Filial_Id    => i_Filial_Id,
                                                           i_Staff_Id     => s.Staff_Id,
                                                           i_Period_Begin => i_Period_Begin,
                                                           i_Period_End   => i_Period_End) Lp
                     where Lp.Licensed = 'Y')
               and (i_Period_Kind is null or Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => i_Company_Id,
                                                                               i_Filial_Id     => i_Filial_Id,
                                                                               i_Staff_Id      => s.Staff_Id,
                                                                               i_Oper_Group_Id => v_Wage_Group_Id,
                                                                               i_Period        => i_Period_End) =
                   v_Hourly_Wage_Id)) St
     where (v_Division_Count = 0 or St.Division_Id member of i_Division_Ids)
       and (v_Access_All_Employee = 'Y' or --
           St.Employee_Id = Ui.User_Id or --
           St.Division_Id member of v_Division_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Period_Wages(p Hashmap) return Arraylist is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Round_Value  varchar2(50) := p.r_Varchar2('round_value');
    v_Round_Model  Round_Model := Round_Model(v_Round_Value);
  
    v_Staff_Ids Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
  
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Sheet_Id     number := p.o_Number('sheet_id');
  
    v_Sheet_Parts Hpr_Pref.Sheet_Part_Nt;
  
    result Arraylist := Arraylist();
  
    -------------------------------------------------- 
    Procedure Push_Sheet_Parts
    (
      i_Sheet_Parts Hpr_Pref.Sheet_Part_Nt,
      i_Staff_Id    number,
      i_Staff_Name  varchar2
    ) is
      v_Accrual_Amount              number;
      v_Penalty_Amount              number;
      v_Onetime_Accrual             number;
      v_Onetime_Penalty             number;
      v_Sheet_Part                  Hpr_Pref.Sheet_Part_Rt;
      v_Part                        Hashmap;
      v_Employee_Id                 number;
      v_Access_To_Hidden_Salary_Job varchar2(1);
    begin
      v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => v_Company_Id,
                                                 i_Filial_Id  => v_Filial_Id,
                                                 i_Staff_Id   => i_Staff_Id);
    
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id);
    
      for i in 1 .. i_Sheet_Parts.Count
      loop
        v_Sheet_Part := i_Sheet_Parts(i);
      
        v_Part := Fazo.Zip_Map('staff_id',
                               i_Staff_Id,
                               'part_begin',
                               v_Sheet_Part.Part_Begin,
                               'part_end',
                               v_Sheet_Part.Part_End,
                               'division_id',
                               v_Sheet_Part.Division_Id,
                               'job_id',
                               v_Sheet_Part.Job_Id,
                               'schedule_id',
                               v_Sheet_Part.Schedule_Id);
      
        v_Part.Put('staff_name', i_Staff_Name);
        v_Part.Put('fte_id', v_Sheet_Part.Fte_Id);
      
        v_Access_To_Hidden_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                                                                                          i_Filial_Id  => v_Filial_Id,
                                                                                                                          i_Staff_Id   => i_Staff_Id,
                                                                                                                          i_Period     => v_Sheet_Part.Part_End),
                                                                             i_Employee_Id => v_Employee_Id);
      
        v_Part.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary_Job);
      
        if v_Access_To_Hidden_Salary_Job = 'Y' then
          v_Accrual_Amount := v_Sheet_Part.Wage_Amount + v_Sheet_Part.Overtime_Amount +
                              v_Sheet_Part.Nighttime_Amount;
        
          v_Penalty_Amount := v_Sheet_Part.Late_Amount + v_Sheet_Part.Early_Amount +
                              v_Sheet_Part.Lack_Amount + v_Sheet_Part.Day_Skip_Amount +
                              v_Sheet_Part.Mark_Skip_Amount;
        
          if v_Sheet_Part.Part_Begin = Trunc(v_Sheet_Part.Part_Begin, 'mon') and
             v_Sheet_Part.Part_End = Last_Day(v_Sheet_Part.Part_End) then
          
            select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0)
              into v_Onetime_Accrual, --
                   v_Onetime_Penalty
              from Hpr_Onetime_Sheet_Staffs p
             where p.Company_Id = v_Company_Id
               and p.Filial_Id = v_Filial_Id
               and p.Staff_Id = i_Staff_Id
               and p.Month = v_Sheet_Part.Part_Begin
               and exists (select *
                      from Hpr_Wage_Sheets q
                     where q.Company_Id = p.Company_Id
                       and q.Filial_Id = p.Filial_Id
                       and q.Sheet_Id = p.Sheet_Id
                       and q.Posted = 'Y');
          
            v_Accrual_Amount := v_Accrual_Amount + v_Round_Model.Eval(v_Onetime_Accrual);
            v_Penalty_Amount := v_Penalty_Amount + v_Round_Model.Eval(v_Onetime_Penalty);
          end if;
        
          v_Part.Put('monthly_amount', v_Sheet_Part.Monthly_Amount);
          v_Part.Put('plan_amount', v_Sheet_Part.Plan_Amount);
          v_Part.Put('wage_amount', v_Sheet_Part.Wage_Amount);
          v_Part.Put('overtime_amount', v_Sheet_Part.Overtime_Amount);
          v_Part.Put('nighttime_amount', v_Sheet_Part.Nighttime_Amount);
          v_Part.Put('late_amount', v_Sheet_Part.Late_Amount);
          v_Part.Put('early_amount', v_Sheet_Part.Early_Amount);
          v_Part.Put('lack_amount', v_Sheet_Part.Lack_Amount);
          v_Part.Put('day_skip_amount', v_Sheet_Part.Day_Skip_Amount);
          v_Part.Put('mark_skip_amount', v_Sheet_Part.Mark_Skip_Amount);
          v_Part.Put('accrual_amount', v_Accrual_Amount);
          v_Part.Put('penalty_amount', v_Penalty_Amount);
          v_Part.Put('total_amount', v_Accrual_Amount - v_Penalty_Amount);
        end if;
      
        v_Part.Put('division_name',
                   z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, --
                   i_Filial_Id => v_Filial_Id, --
                   i_Division_Id => v_Sheet_Part.Division_Id).Name);
        v_Part.Put('job_name',
                   z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, --
                   i_Filial_Id => v_Filial_Id, --
                   i_Job_Id => v_Sheet_Part.Job_Id).Name);
        v_Part.Put('schedule_name',
                   z_Htt_Schedules.Load(i_Company_Id => v_Company_Id, --
                   i_Filial_Id => v_Filial_Id, --
                   i_Schedule_Id => v_Sheet_Part.Schedule_Id).Name);
      
        Result.Push(v_Part);
      end loop;
    end;
  begin
    if v_Staff_Ids.Count = 0 then
      v_Staff_Ids := Load_Staff_Ids(i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Sheet_Id     => v_Sheet_Id,
                                    i_Division_Ids => v_Division_Ids,
                                    i_Period_Begin => v_Period_Begin,
                                    i_Period_End   => v_Period_End,
                                    i_Period_Kind  => p.o_Varchar2('period_kind'));
    end if;
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Sheet_Parts := Hpr_Util.Calc_Staff_Parts(i_Company_Id   => v_Company_Id,
                                                 i_Filial_Id    => v_Filial_Id,
                                                 i_Staff_Id     => v_Staff_Ids(i),
                                                 i_Period_Begin => v_Period_Begin,
                                                 i_Period_End   => v_Period_End,
                                                 i_Round_Model  => v_Round_Model);
    
      Push_Sheet_Parts(v_Sheet_Parts,
                       v_Staff_Ids(i),
                       Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Filial_Id,
                                            i_Staff_Id   => v_Staff_Ids(i)));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Default_Round_Values return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('round_values', Fazo.Zip_Matrix(Mkr_Util.Round_Model_Values));
    Result.Put('round_value', '-2.0');
    Result.Put('rmt_round', Md_Pref.c_Rt_Round);
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Division_Id Array_Number := Array_Number()) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('period_kinds', Fazo.Zip_Matrix_Transposed(Hpr_Util.Period_Kinds));
    Result.Put('period_kind_full_month', Hpr_Pref.c_Period_Full_Month);
    Result.Put('period_kind_first_half', Hpr_Pref.c_Period_Month_First_Half);
    Result.Put('period_kind_second_half', Hpr_Pref.c_Period_Month_Second_Half);
    Result.Put('period_kind_custom', Hpr_Pref.c_Period_Custom);
    Result.Put_All(Default_Round_Values);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Period_Begin date := Trunc(sysdate, 'mon');
    v_Period_End   date := Last_Day(v_Period_Begin);
    result         Hashmap;
  begin
    result := Fazo.Zip_Map('sheet_date', --
                           Trunc(sysdate),
                           'period_kind',
                           Hpr_Pref.c_Period_Full_Month,
                           'month',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Month),
                           'period_begin',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Day),
                           'period_end',
                           to_char(v_Period_End, Href_Pref.c_Date_Format_Day));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Sheet           Hpr_Wage_Sheets%rowtype;
    v_Division_Ids    Array_Number;
    v_Staff_Parts     Matrix_Varchar2;
    v_Onetime_Accrual number;
    v_Onetime_Penalty number;
    v_Sheet_Id        number := p.r_Number('sheet_id');
    result            Hashmap;
  begin
    Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => v_Sheet_Id,
                                        i_Sheet_Kind => Hpr_Pref.c_Wage_Sheet_Regular);
  
    r_Sheet := z_Hpr_Wage_Sheets.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Sheet_Id   => v_Sheet_Id);
  
    result := z_Hpr_Wage_Sheets.To_Map(r_Sheet,
                                       z.Sheet_Id,
                                       z.Sheet_Number,
                                       z.Sheet_Date,
                                       z.Period_Kind,
                                       z.Status,
                                       z.Note,
                                       z.Posted,
                                       z.Round_Value);
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Hpr_Wage_Sheet_Divisions q
     where q.Company_Id = r_Sheet.Company_Id
       and q.Filial_Id = r_Sheet.Filial_Id
       and q.Sheet_Id = r_Sheet.Sheet_Id;
  
    Result.Put('division_ids', v_Division_Ids);
    Result.Put('month', to_char(r_Sheet.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('period_begin', to_char(r_Sheet.Period_Begin, Href_Pref.c_Date_Format_Day));
    Result.Put('period_end', to_char(r_Sheet.Period_End, Href_Pref.c_Date_Format_Day));
  
    select Array_Varchar2(Sht.Staff_Id,
                           Sht.Staff_Name,
                           Sht.Part_Begin,
                           Sht.Part_End,
                           Sht.Division_Id,
                           Sht.Division_Name,
                           Sht.Job_Id,
                           Sht.Job_Name,
                           Sht.Schedule_Id,
                           Sht.Schedule_Name,
                           Sht.Fte_Id,
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Monthly_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Plan_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Wage_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Overtime_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Nighttime_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Late_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Early_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Lack_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Day_Skip_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Mark_Skip_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Accrual_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Penalty_Amount
                             else
                              -1
                           end),
                           (case
                             when Sht.Access_To_Hidden_Salary = 'Y' then
                              Sht.Amount
                             else
                              -1
                           end),
                           Sht.Part_Id,
                           Sht.Access_To_Hidden_Salary)
      bulk collect
      into v_Staff_Parts
      from (select q.Staff_Id,
                   (select Np.Name
                      from Mr_Natural_Persons Np
                     where Np.Company_Id = St.Company_Id
                       and Np.Person_Id = St.Employee_Id) Staff_Name,
                   to_char(q.Part_Begin, Href_Pref.c_Date_Format_Day) Part_Begin,
                   to_char(q.Part_End, Href_Pref.c_Date_Format_Day) Part_End,
                   q.Division_Id,
                   (select m.Name
                      from Mhr_Divisions m
                     where m.Company_Id = q.Company_Id
                       and m.Filial_Id = q.Filial_Id
                       and m.Division_Id = q.Division_Id) Division_Name,
                   q.Job_Id,
                   (select j.Name
                      from Mhr_Jobs j
                     where j.Company_Id = q.Company_Id
                       and j.Filial_Id = q.Filial_Id
                       and j.Job_Id = q.Job_Id) Job_Name,
                   q.Schedule_Id,
                   (select s.Name
                      from Htt_Schedules s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Schedule_Id = q.Schedule_Id) Schedule_Name,
                   q.Fte_Id,
                   q.Monthly_Amount,
                   q.Plan_Amount,
                   q.Wage_Amount,
                   q.Overtime_Amount,
                   q.Nighttime_Amount,
                   q.Late_Amount,
                   q.Early_Amount,
                   q.Lack_Amount,
                   q.Day_Skip_Amount,
                   q.Mark_Skip_Amount,
                   q.Accrual_Amount,
                   q.Penalty_Amount,
                   q.Amount,
                   q.Part_Id,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => q.Job_Id,
                                                       i_Employee_Id => St.Employee_Id) Access_To_Hidden_Salary
              from Hpr_Sheet_Parts q
              join Href_Staffs St
                on St.Company_Id = q.Company_Id
               and St.Filial_Id = q.Filial_Id
               and St.Staff_Id = q.Staff_Id
             where q.Company_Id = r_Sheet.Company_Id
               and q.Filial_Id = r_Sheet.Filial_Id
               and q.Sheet_Id = r_Sheet.Sheet_Id) Sht;
  
    if r_Sheet.Period_Begin = Trunc(r_Sheet.Period_Begin, 'month') and
       r_Sheet.Period_End = Last_Day(r_Sheet.Period_End) then
      for i in 1 .. v_Staff_Parts.Count
      loop
        select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0)
          into v_Onetime_Accrual, --
               v_Onetime_Penalty
          from Hpr_Onetime_Sheet_Staffs p
         where p.Company_Id = r_Sheet.Company_Id
           and p.Filial_Id = r_Sheet.Filial_Id
           and p.Staff_Id = v_Staff_Parts(i) (1) -- staff_id
           and p.Month = r_Sheet.Period_Begin
           and exists (select *
                  from Hpr_Wage_Sheets q
                 where q.Company_Id = p.Company_Id
                   and q.Filial_Id = p.Filial_Id
                   and q.Sheet_Id = p.Sheet_Id
                   and q.Posted = 'Y');
      
        v_Staff_Parts(i)(22) := v_Staff_Parts(i) (22) + v_Onetime_Accrual; -- v_Staff_Parts(i)(22) => Accrual_Amount
        v_Staff_Parts(i)(23) := v_Staff_Parts(i) (23) + v_Onetime_Penalty; -- v_Staff_Parts(i)(23) => Penalty_Amount
        v_Staff_Parts(i)(24) := v_Staff_Parts(i) (24) + v_Onetime_Accrual - v_Onetime_Penalty; -- v_Staff_Parts(i)(25) => Amount
      end loop;
    end if;
  
    Result.Put('staff_parts', Fazo.Zip_Matrix(v_Staff_Parts));
    Result.Put('references', References(v_Division_Ids));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Sheet_Id number,
    p          Hashmap
  ) return Hashmap is
    v_Wage_Sheet Hpr_Pref.Wage_Sheet_Rt;
    v_Staff_Ids  Array_Number := p.r_Array_Number('staff_ids');
    v_Posted     boolean := p.r_Varchar2('posted') = 'Y';
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Employee(Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                                                   i_Filial_Id  => Ui.Filial_Id,
                                                                   i_Staff_Id   => v_Staff_Ids(i)));
    end loop;
  
    Hpr_Util.Wage_Sheet_New(o_Wage_Sheet   => v_Wage_Sheet,
                            i_Company_Id   => Ui.Company_Id,
                            i_Filial_Id    => Ui.Filial_Id,
                            i_Sheet_Id     => i_Sheet_Id,
                            i_Sheet_Number => p.o_Varchar2('sheet_number'),
                            i_Sheet_Date   => p.r_Date('sheet_date'),
                            i_Period_Begin => p.r_Date('period_begin'),
                            i_Period_End   => p.r_Date('period_end'),
                            i_Period_Kind  => p.r_Varchar2('period_kind'),
                            i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                            i_Note         => p.o_Varchar2('note'),
                            i_Sheet_Kind   => Hpr_Pref.c_Wage_Sheet_Regular,
                            i_Staff_Ids    => v_Staff_Ids,
                            i_Round_Value  => p.r_Varchar2('round_value'));
  
    Hpr_Api.Wage_Sheet_Save(i_Wage_Sheet => v_Wage_Sheet);
  
    if v_Posted then
      Hpr_Api.Wage_Sheet_Post(i_Company_Id => v_Wage_Sheet.Company_Id,
                              i_Filial_Id  => v_Wage_Sheet.Filial_Id,
                              i_Sheet_Id   => v_Wage_Sheet.Sheet_Id);
    end if;
  
    return Fazo.Zip_Map('sheet_id',
                        v_Wage_Sheet.Sheet_Id,
                        'sheet_number',
                        v_Wage_Sheet.Sheet_Number);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpr_Next.Wage_Sheet_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Lock_Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Sheet_Id   => p.r_Number('sheet_id'));
  
    if r_Sheet.Posted = 'Y' then
      Hpr_Api.Wage_Sheet_Unpost(i_Company_Id => r_Sheet.Company_Id,
                                i_Filial_Id  => r_Sheet.Filial_Id,
                                i_Sheet_Id   => r_Sheet.Sheet_Id);
    end if;
  
    return save(r_Sheet.Sheet_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
    v_Dummy varchar2(1);
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
    update Hpr_Wage_Sheets
       set Company_Id = null,
           Filial_Id  = null,
           Sheet_Id   = null,
           Posted     = null;
    update Hpr_Sheet_Parts
       set Company_Id = null,
           Filial_Id  = null,
           Part_Begin = null,
           Part_End   = null,
           Staff_Id   = null;
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Period     => null));
  
    select 'X'
      into v_Dummy
      from Href_Util.Staff_Licensed_Period(i_Company_Id   => null,
                                           i_Filial_Id    => null,
                                           i_Staff_Id     => null,
                                           i_Period_Begin => null,
                                           i_Period_End   => null);
  end;

end Ui_Vhr308;
/
