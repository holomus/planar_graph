PL/SQL Developer Test script 3.0
437
-- Created on 12/28/2022 by SANJAR 
declare
  v_Company_Count number;
  v_Gen_Year      number := 2024;
  -------------------------------------------------- 
  Procedure Log_Error(i_Company_Id number) is
    pragma autonomous_transaction;
  begin
    insert into Gen_Year_Errors
      (Company_Id, Error_Message)
    values
      (i_Company_Id, Dbms_Utility.Format_Error_Stack || ' ' || Dbms_Utility.Format_Error_Backtrace);
    commit;
  end;

  --------------------------------------------------
  Function Find_Pattern_Start
  (
    i_Schedule Htt_Schedules%rowtype,
    i_Gen_Year number
  ) return date is
    v_Prev_Year_End   date := Trunc(to_date(i_Gen_Year, 'yyyy'), 'yyyy') - 1;
    v_Prev_Year_Begin date := Trunc(v_Prev_Year_End, 'yyyy');
  
    v_Code_Counter number := 0;
    v_Day_Codes    Fazo.Varchar2_Code_Aat;
  
    v_Encoded_Days    varchar2(1000) := '';
    v_Encoded_Pattern varchar2(1000) := '';
  
    v_Remaining_Days    varchar2(1000);
    v_Remaining_Pattern varchar2(1000);
  
    v_Period_Start_Pos number; -- starts at 1
  
    -------------------------------------------------- 
    Function Day_Code
    (
      i_Day_Kind         varchar2,
      i_Break_Enabled    varchar2,
      i_Begin_Time       varchar2,
      i_End_Time         varchar2,
      i_Break_Begin_Time varchar2,
      i_Break_End_Time   varchar2,
      i_Plan_Time        varchar2
    ) return varchar2 is
      v_Day_Keys Array_Varchar2 := Array_Varchar2(i_Day_Kind,
                                                  i_Break_Enabled,
                                                  i_Begin_Time,
                                                  i_End_Time,
                                                  i_Break_Begin_Time,
                                                  i_Break_End_Time,
                                                  i_Plan_Time);
    
      v_Gathered_Key varchar2(100) := Fazo.Gather(v_Day_Keys, ';');
    begin
      return v_Day_Codes(v_Gathered_Key);
    exception
      when No_Data_Found then
        v_Code_Counter := v_Code_Counter + 1;
      
        v_Day_Codes(v_Gathered_Key) := v_Code_Counter;
      
        return to_char(v_Code_Counter);
    end;
  begin
    for r in (select q.Day_Kind,
                     Nvl(q.Break_Enabled, 'X') Break_Enabled,
                     Lpad(Extract(Hour from cast(q.Begin_Time as timestamp)) * 60 +
                          Extract(Minute from cast(q.Begin_Time as timestamp)),
                          4,
                          '0') Begin_Time,
                     Lpad(Extract(Hour from cast(q.End_Time as timestamp)) * 60 +
                          Extract(Minute from cast(q.End_Time as timestamp)),
                          4,
                          '0') End_Time,
                     Lpad(Extract(Hour from cast(q.Break_Begin_Time as timestamp)) * 60 +
                          Extract(Minute from cast(q.Break_Begin_Time as timestamp)),
                          4,
                          '0') Break_Begin_Time,
                     Lpad(Extract(Hour from cast(q.Break_End_Time as timestamp)) * 60 +
                          Extract(Minute from cast(q.Break_End_Time as timestamp)),
                          4,
                          '0') Break_End_Time,
                     Lpad(q.Plan_Time, 4, '0') Plan_Time
                from Htt_Schedule_Origin_Days q
               where q.Company_Id = i_Schedule.Company_Id
                 and q.Filial_Id = i_Schedule.Filial_Id
                 and q.Schedule_Id = i_Schedule.Schedule_Id
                 and q.Schedule_Date between v_Prev_Year_Begin and v_Prev_Year_End
               order by q.Schedule_Date)
    loop
      v_Encoded_Days := v_Encoded_Days ||
                        Day_Code(i_Day_Kind         => r.Day_Kind,
                                 i_Break_Enabled    => r.Break_Enabled,
                                 i_Begin_Time       => r.Begin_Time,
                                 i_End_Time         => r.End_Time,
                                 i_Break_Begin_Time => r.Break_Begin_Time,
                                 i_Break_End_Time   => r.Break_End_Time,
                                 i_Plan_Time        => r.Plan_Time);
    end loop;
  
    for r in (select Pd.Day_Kind,
                     Nvl(Pd.Break_Enabled, 'X') Break_Enabled,
                     Lpad(mod(Pd.Begin_Time, 1440), 4, '0') Begin_Time,
                     Lpad(mod(Pd.End_Time, 1440), 4, '0') End_Time,
                     Lpad(mod(Pd.Break_Begin_Time, 1440), 4, '0') Break_Begin_Time,
                     Lpad(mod(Pd.Break_End_Time, 1440), 4, '0') Break_End_Time,
                     Lpad(Pd.Plan_Time, 4, '0') Plan_Time
                from Htt_Schedule_Pattern_Days Pd
               where Pd.Company_Id = i_Schedule.Company_Id
                 and Pd.Filial_Id = i_Schedule.Filial_Id
                 and Pd.Schedule_Id = i_Schedule.Schedule_Id
               order by Pd.Day_No)
    loop
      v_Encoded_Pattern := v_Encoded_Pattern ||
                           Day_Code(i_Day_Kind         => r.Day_Kind,
                                    i_Break_Enabled    => r.Break_Enabled,
                                    i_Begin_Time       => r.Begin_Time,
                                    i_End_Time         => r.End_Time,
                                    i_Break_Begin_Time => r.Break_Begin_Time,
                                    i_Break_End_Time   => r.Break_End_Time,
                                    i_Plan_Time        => r.Plan_Time);
    end loop;
  
    v_Period_Start_Pos := Instr(v_Encoded_Days, v_Encoded_Pattern, -1);
  
    v_Remaining_Days    := Substr(v_Encoded_Days, v_Period_Start_Pos + Length(v_Encoded_Pattern));
    v_Remaining_Pattern := Substr(v_Encoded_Pattern, 1, Length(v_Remaining_Days));
  
    if v_Period_Start_Pos <= 0 or not Fazo.Equal(v_Remaining_Days, v_Remaining_Pattern) or
       v_Encoded_Pattern is null then
      b.Raise_Error('couldnt detect pattern in schedule: ' || i_Schedule.Schedule_Id);
    end if;
  
    return v_Prev_Year_Begin + v_Period_Start_Pos - 1;
  end;

  --------------------------------------------------
  Procedure Gen_Schedule
  (
    i_Schedule Htt_Schedules%rowtype,
    i_Year     number
  ) is
    v_First_Day   date := Trunc(to_date(i_Year, 'yyyy'), 'yyyy');
    v_Last_Day    date := Add_Months(v_First_Day, 12);
    v_Current_Day date;
    v_Start_Day   date;
  
    v_Schedule     Htt_Pref.Schedule_Rt;
    v_Pattern      Htt_Pref.Schedule_Pattern_Rt;
    v_Pattern_Day  Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Pattern_Days Htt_Pref.Schedule_Pattern_Day_Nt;
    v_Schedule_Day Htt_Pref.Schedule_Day_Rt;
    v_Marks        Htt_Pref.Mark_Nt;
    v_Day_Marks    Htt_Pref.Schedule_Day_Marks_Rt;
    v_Day_Weights  Htt_Pref.Schedule_Day_Weights_Rt;
  
    r_Pattern Htt_Schedule_Patterns%rowtype;
  begin
    Htt_Util.Schedule_New(o_Schedule                  => v_Schedule,
                          i_Company_Id                => i_Schedule.Company_Id,
                          i_Filial_Id                 => i_Schedule.Filial_Id,
                          i_Schedule_Id               => i_Schedule.Schedule_Id,
                          i_Name                      => i_Schedule.Name,
                          i_Shift                     => i_Schedule.Shift,
                          i_Input_Acceptance          => i_Schedule.Input_Acceptance,
                          i_Output_Acceptance         => i_Schedule.Output_Acceptance,
                          i_Track_Duration            => i_Schedule.Track_Duration,
                          i_Count_Late                => i_Schedule.Count_Late,
                          i_Count_Early               => i_Schedule.Count_Early,
                          i_Count_Lack                => i_Schedule.Count_Lack,
                          i_Count_Free                => i_Schedule.Count_Free,
                          i_Use_Weights               => i_Schedule.Use_Weights,
                          i_Allowed_Late_Time         => i_Schedule.Allowed_Late_Time,
                          i_Allowed_Early_Time        => i_Schedule.Allowed_Early_Time,
                          i_Begin_Late_Time           => i_Schedule.Begin_Late_Time,
                          i_End_Early_Time            => i_Schedule.End_Early_Time,
                          i_Calendar_Id               => i_Schedule.Calendar_Id,
                          i_Take_Holidays             => i_Schedule.Take_Holidays,
                          i_Take_Nonworking           => i_Schedule.Take_Nonworking,
                          i_Take_Additional_Rest_Days => i_Schedule.Take_Additional_Rest_Days,
                          i_Gps_Turnout_Enabled       => i_Schedule.Gps_Turnout_Enabled,
                          i_Gps_Use_Location          => i_Schedule.Gps_Use_Location,
                          i_Gps_Max_Interval          => i_Schedule.Gps_Max_Interval,
                          i_State                     => i_Schedule.State,
                          i_Code                      => i_Schedule.Code,
                          i_Year                      => i_Year,
                          i_Schedule_Kind             => i_Schedule.Schedule_Kind);
  
    r_Pattern := z_Htt_Schedule_Patterns.Load(i_Company_Id  => i_Schedule.Company_Id,
                                              i_Filial_Id   => i_Schedule.Filial_Id,
                                              i_Schedule_Id => i_Schedule.Schedule_Id);
  
    Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Pattern,
                                  i_Pattern_Kind   => r_Pattern.Schedule_Kind,
                                  i_All_Days_Equal => r_Pattern.All_Days_Equal,
                                  i_Count_Days     => r_Pattern.Count_Days,
                                  i_Begin_Date     => r_Pattern.Begin_Date,
                                  i_End_Date       => r_Pattern.End_Date);
  
    v_Pattern_Days := Htt_Pref.Schedule_Pattern_Day_Nt();
  
    for Pd in (select Pd.Day_No,
                      Pd.Day_Kind,
                      Pd.Begin_Time,
                      Pd.End_Time,
                      Pd.Break_Enabled,
                      Pd.Break_Begin_Time,
                      Pd.Break_End_Time,
                      Pd.Plan_Time
                 from Htt_Schedule_Pattern_Days Pd
                where Pd.Company_Id = i_Schedule.Company_Id
                  and Pd.Filial_Id = i_Schedule.Filial_Id
                  and Pd.Schedule_Id = i_Schedule.Schedule_Id
                order by Pd.Day_No)
    loop
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
                                        i_Day_No           => Pd.Day_No,
                                        i_Day_Kind         => Pd.Day_Kind,
                                        i_Begin_Time       => Pd.Begin_Time,
                                        i_End_Time         => Pd.End_Time,
                                        i_Break_Enabled    => Pd.Break_Enabled,
                                        i_Break_Begin_Time => Pd.Break_Begin_Time,
                                        i_Break_End_Time   => Pd.Break_End_Time,
                                        i_Plan_Time        => Pd.Plan_Time);
    
      select mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440)
        bulk collect
        into v_Marks
        from Htt_Schedule_Pattern_Marks Pm
       where Pm.Company_Id = i_Schedule.Company_Id
         and Pm.Filial_Id = i_Schedule.Filial_Id
         and Pm.Schedule_Id = i_Schedule.Schedule_Id
         and Pm.Day_No = Pd.Day_No;
    
      v_Pattern_Day.Pattern_Marks := v_Marks;
    
      -- Schedule Weights
      for w in (select *
                  from Htt_Schedule_Pattern_Weights q
                 where q.Company_Id = i_Schedule.Company_Id
                   and q.Filial_Id = i_Schedule.Filial_Id
                   and q.Schedule_Id = i_Schedule.Schedule_Id
                   and q.Day_No = Pd.Day_No)
      loop
        Htt_Util.Schedule_Weights_Add(o_Weights    => v_Pattern_Day.Pattern_Weights,
                                      i_Begin_Time => w.Begin_Time,
                                      i_End_Time   => w.End_Time,
                                      i_Weight     => w.Weight);
      end loop;
    
      v_Pattern_Days.Extend();
      v_Pattern_Days(v_Pattern_Days.Count) := v_Pattern_Day;
    end loop;
  
    for i in 1 .. v_Pattern_Days.Count
    loop
      Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Pattern,
                                        i_Day              => v_Pattern_Days(i));
    end loop;
  
    v_Current_Day := v_First_Day;
  
    if v_Pattern.Pattern_Kind = Htt_Pref.c_Pattern_Kind_Weekly then
      v_Start_Day := Trunc(v_First_Day, 'IW');
    else
      v_Start_Day := Find_Pattern_Start(i_Schedule => i_Schedule, i_Gen_Year => i_Year);
    end if;
  
    while v_Current_Day != v_Last_Day
    loop
      v_Pattern_Day := v_Pattern_Days((v_Current_Day - v_Start_Day) mod v_Pattern.Count_Days + 1);
    
      Htt_Util.Schedule_Day_New(o_Day              => v_Schedule_Day,
                                i_Schedule_Date    => v_Current_Day,
                                i_Day_Kind         => v_Pattern_Day.Day_Kind,
                                i_Begin_Time       => v_Pattern_Day.Begin_Time,
                                i_End_Time         => v_Pattern_Day.End_Time,
                                i_Break_Enabled    => v_Pattern_Day.Break_Enabled,
                                i_Break_Begin_Time => v_Pattern_Day.Break_Begin_Time,
                                i_Break_End_Time   => v_Pattern_Day.Break_End_Time,
                                i_Plan_Time        => v_Pattern_Day.Plan_Time);
    
      Htt_Util.Schedule_Day_Add(o_Schedule => v_Schedule, i_Day => v_Schedule_Day);
    
      Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                      i_Schedule_Date      => v_Current_Day,
                                      i_Begin_Date         => v_Pattern_Day.Begin_Time,
                                      i_End_Date           => v_Pattern_Day.End_Time);
    
      v_Day_Marks.Marks := v_Pattern_Day.Pattern_Marks;
    
      Htt_Util.Schedule_Day_Marks_Add(o_Schedule => v_Schedule, i_Day_Marks => v_Day_Marks);
    
      Htt_Util.Schedule_Day_Weights_New(o_Schedule_Day_Weights => v_Day_Weights,
                                        i_Schedule_Date        => v_Schedule_Day.Schedule_Date,
                                        i_Begin_Date           => v_Schedule_Day.Begin_Time,
                                        i_End_Date             => v_Schedule_Day.End_Time);
    
      v_Day_Weights.Weights := v_Pattern_Day.Pattern_Weights;
    
      Htt_Util.Schedule_Day_Weights_Add(o_Schedule => v_Schedule, i_Day_Weights => v_Day_Weights);
    
      v_Current_Day := v_Current_Day + 1;
    end loop;
  
    v_Schedule.Pattern := v_Pattern;
  
    Htt_Api.Schedule_Save(v_Schedule);
  end;

  --------------------------------------------------
  Procedure Gen_Schedules
  (
    i_Company_Id     number,
    i_Company_Cnt    number,
    i_Company_Rownum number
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
  
    v_Cnt        number;
    v_Filial_Cnt number;
  
    v_Schedule_Rownum number;
  begin
    select count(*)
      into v_Filial_Cnt
      from Md_Filials q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id <> v_Filial_Head
       and q.State = 'A'
       and exists (select 1
              from Md_Company_Filial_Modules Cm
             where Cm.Company_Id = q.Company_Id
               and Cm.Project_Code = 'vhr'
               and Cm.Filial_Id = q.Filial_Id);
  
    for r in (select q.Company_Id, q.Filial_Id, Rownum Rn
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A'
                 and exists (select 1
                        from Md_Company_Filial_Modules Cm
                       where Cm.Company_Id = q.Company_Id
                         and Cm.Project_Code = 'vhr'
                         and Cm.Filial_Id = q.Filial_Id))
    loop
    
      select count(*)
        into v_Cnt
        from Htt_Schedules t
       where t.Company_Id = r.Company_Id
         and t.Filial_Id = r.Filial_Id
         and t.Pcode is null
         and not exists (select 1
                from Htt_Schedule_Days k
               where k.Company_Id = t.Company_Id
                 and k.Filial_Id = t.Filial_Id
                 and k.Schedule_Id = t.Schedule_Id
                 and Extract(year from k.Schedule_Date) = v_Gen_Year);
    
      v_Schedule_Rownum := 0;
    
      for Sch in (select t.*
                    from Htt_Schedules t
                   where t.Company_Id = r.Company_Id
                     and t.Filial_Id = r.Filial_Id
                     and t.Pcode is null
                     and not exists
                   (select 1
                            from Htt_Schedule_Days k
                           where k.Company_Id = t.Company_Id
                             and k.Filial_Id = t.Filial_Id
                             and k.Schedule_Id = t.Schedule_Id
                             and Extract(year from k.Schedule_Date) = v_Gen_Year))
      loop
        Dbms_Application_Info.Set_Module('gen schedules: cmp: ' || i_Company_Rownum || '/' ||
                                         i_Company_Cnt || '; fil: ' || r.Rn || '/' || v_Filial_Cnt,
                                         'schedules: ' || v_Schedule_Rownum || '/' || v_Cnt);
      
        begin
          savepoint Try_Catch;
          Biruni_Route.Context_Begin;
        
          Ui_Context.Init_Migr(i_Company_Id   => i_Company_Id,
                               i_Filial_Id    => r.Filial_Id,
                               i_User_Id      => v_User_System,
                               i_Project_Code => 'vhr');
        
          Gen_Schedule(i_Schedule => Sch, i_Year => v_Gen_Year);
          Biruni_Route.Context_End;
          commit;
        
          v_Schedule_Rownum := v_Schedule_Rownum + 1;
        exception
          when others then
            rollback to Try_Catch;
            Log_Error(i_Company_Id);
        end;
      end loop;
    end loop;
  end;

begin
  select count(c.Company_Id)
    into v_Company_Count
    from Md_Companies c
   where c.State = 'A'
     and (exists (select 1
                    from Md_Company_Projects Cp
                   where Cp.Company_Id = c.Company_Id
                     and Cp.Project_Code = 'vhr') or c.Company_Id = Md_Pref.c_Company_Head);

  for Cmp in (select Qr.Company_Id, Rownum Rn
                from (select c.Company_Id
                        from Md_Companies c
                       where c.State = 'A'
                         and (exists (select 1
                                        from Md_Company_Projects Cp
                                       where Cp.Company_Id = c.Company_Id
                                         and Cp.Project_Code = 'vhr') or
                              c.Company_Id = Md_Pref.c_Company_Head)
                       order by c.Company_Id) Qr)
  loop
    Dbms_Application_Info.Set_Module('gen schedule',
                                     (Cmp.Rn - 1) || '/' || v_Company_Count || ' generated');
  
    Gen_Schedules(i_Company_Id     => Cmp.Company_Id,
                  i_Company_Cnt    => v_Company_Count,
                  i_Company_Rownum => Cmp.Rn);
  
    commit;
  end loop;
end;
2
v_Remaining_Days
0
0
v_Remaining_Pattern
0
0
5
v_Encoded_Days
v_Encoded_Pattern
v_Remaining_Pattern
v_Remaining_Days
