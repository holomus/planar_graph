prompt migr from 07.10.2022
---------------------------------------------------------------------------------------------------- 
prompt generate schedules for next(2023) year.
----------------------------------------------------------------------------------------------------
declare
  v_Company_Count number;
  v_Year          number := 2023;
  -------------------------------------------------- 
  Procedure Gen_Schedule_For_Year
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Year        number
  ) is
    r_Schedule    Htt_Schedules%rowtype;
    r_Pattern     Htt_Schedule_Patterns%rowtype;
    r_Pattern_Day Htt_Schedule_Pattern_Days%rowtype;
    r_Day         Htt_Schedule_Origin_Days%rowtype;
    v_Marks       Htt_Pref.Mark_Nt;
    v_Mark        Htt_Pref.Mark_Rt;
    v_Dates       Array_Date := Array_Date();
    v_Mark_Dates  Array_Date := Array_Date();
    v_First_Day   date := Trunc(to_date(i_Year, 'yyyy'), 'yyyy');
    v_Last_Day    date := Add_Months(v_First_Day, 12);
    v_Current_Day date;
    v_Start_Day   date;
    v_Begin_Time  number;
    v_End_Time    number;
    v_Day_No      number;
  begin
    r_Schedule := z_Htt_Schedules.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Schedule_Id => i_Schedule_Id);
  
    r_Pattern := z_Htt_Schedule_Patterns.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Schedule_Id => i_Schedule_Id);
  
    v_Current_Day := v_First_Day;
  
    if r_Pattern.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Weekly then
      v_Start_Day := Trunc(v_First_Day, 'IW');
    else
      v_Start_Day := v_First_Day;
    end if;
  
    while v_Current_Day != v_Last_Day
    loop
      v_Day_No := (v_Current_Day - v_Start_Day) mod r_Pattern.Count_Days + 1;
    
      r_Pattern_Day := z_Htt_Schedule_Pattern_Days.Load(i_Company_Id  => i_Company_Id,
                                                        i_Filial_Id   => i_Filial_Id,
                                                        i_Schedule_Id => i_Schedule_Id,
                                                        i_Day_No      => v_Day_No);
    
      r_Day := null;
    
      r_Day.Company_Id    := i_Company_Id;
      r_Day.Filial_Id     := i_Filial_Id;
      r_Day.Schedule_Id   := i_Schedule_Id;
      r_Day.Schedule_Date := v_Current_Day;
      r_Day.Day_Kind      := r_Pattern_Day.Day_Kind;
      r_Day.Break_Enabled := r_Pattern_Day.Break_Enabled;
    
      if Extract(year from v_Current_Day) <> i_Year then
        Htt_Error.Raise_026(i_Chosen_Year => i_Year, i_Schedule_Date => v_Current_Day);
      end if;
    
      if r_Pattern_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work then
        r_Day.Begin_Time := v_Current_Day + Numtodsinterval(r_Pattern_Day.Begin_Time, 'minute');
        r_Day.End_Time   := v_Current_Day + Numtodsinterval(r_Pattern_Day.End_Time, 'minute');
      
        if r_Day.End_Time <= r_Day.Begin_Time then
          r_Day.End_Time := r_Day.End_Time + 1;
        end if;
      
        if r_Pattern_Day.Break_Enabled = 'Y' then
          r_Day.Break_Begin_Time := r_Day.Schedule_Date +
                                    Numtodsinterval(r_Pattern_Day.Break_Begin_Time, 'minute');
          r_Day.Break_End_Time   := r_Day.Schedule_Date +
                                    Numtodsinterval(r_Pattern_Day.Break_End_Time, 'minute');
        
          if r_Day.Break_Begin_Time <= r_Day.Begin_Time then
            r_Day.Break_Begin_Time := r_Day.Break_Begin_Time + 1;
          end if;
        
          if r_Day.Break_End_Time <= r_Day.Break_Begin_Time then
            r_Day.Break_End_Time := r_Day.Break_End_Time + 1;
          end if;
        end if;
      
        r_Day.Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => r_Day.Day_Kind,
                                                   i_Begin_Time       => r_Day.Begin_Time,
                                                   i_End_Time         => r_Day.End_Time,
                                                   i_Break_Begin_Time => r_Day.Break_Begin_Time,
                                                   i_Break_End_Time   => r_Day.Break_End_Time);
      
        r_Day.Plan_Time := r_Pattern_Day.Plan_Time;
      else
        r_Day.Full_Time     := 0;
        r_Day.Plan_Time     := 0;
        r_Day.Break_Enabled := null;
      end if;
    
      r_Day.Shift_Begin_Time := r_Day.Schedule_Date + Numtodsinterval(r_Schedule.Shift, 'minute');
      r_Day.Shift_End_Time   := r_Day.Shift_Begin_Time + Numtodsinterval(86400, 'second');
      r_Day.Input_Border     := r_Day.Shift_Begin_Time -
                                Numtodsinterval(r_Schedule.Input_Acceptance, 'minute');
      r_Day.Output_Border    := r_Day.Shift_End_Time +
                                Numtodsinterval(r_Schedule.Output_Acceptance, 'minute');
    
      z_Htt_Schedule_Origin_Days.Save_Row(r_Day);
    
      Fazo.Push(v_Dates, r_Day.Schedule_Date);
    
      select mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440)
        bulk collect
        into v_Marks
        from Htt_Schedule_Pattern_Marks Pm
       where Pm.Company_Id = i_Company_Id
         and Pm.Filial_Id = i_Filial_Id
         and Pm.Schedule_Id = i_Schedule_Id
         and Pm.Day_No = v_Day_No;
    
      if v_Marks.Count > 0 then
        for i in 1 .. v_Marks.Count
        loop
          v_Mark := v_Marks(i);
        
          v_Begin_Time := v_Mark.Begin_Time;
          v_End_Time   := v_Mark.End_Time;
        
          if v_Begin_Time < r_Schedule.Shift then
            v_Begin_Time := v_Begin_Time + 1440;
          end if;
        
          if v_End_Time < v_Begin_Time then
            v_End_Time := v_End_Time + 1440;
          end if;
        
          if v_Begin_Time = v_End_Time then
            Htt_Error.Raise_030(v_Current_Day);
          end if;
        
          if v_End_Time > r_Schedule.Shift + 1440 then
            Htt_Error.Raise_031(i_Schedule_Date => v_Current_Day,
                                i_Shift_Text    => Htt_Util.To_Time_Text(i_Minutes      => r_Schedule.Shift,
                                                                         i_Show_Minutes => true,
                                                                         i_Show_Words   => false));
          end if;
        
          z_Htt_Schedule_Origin_Day_Marks.Insert_One(i_Company_Id    => i_Company_Id,
                                                     i_Filial_Id     => i_Filial_Id,
                                                     i_Schedule_Id   => i_Schedule_Id,
                                                     i_Schedule_Date => v_Current_Day,
                                                     i_Begin_Time    => v_Begin_Time,
                                                     i_End_Time      => v_End_Time);
        end loop;
      
        Fazo.Push(v_Mark_Dates, v_Current_Day);
      end if;
    
      v_Current_Day := v_Current_Day + 1;
    end loop;
  
    Htt_Util.Assert_Schedule_Marks(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Schedule_Id => i_Schedule_Id,
                                   i_Dates       => v_Mark_Dates);
  
    Htt_Core.Regen_Schedule_Days(i_Company_Id  => i_Company_Id,
                                 i_Filial_Id   => i_Filial_Id,
                                 i_Schedule_Id => i_Schedule_Id,
                                 i_Year        => i_Year,
                                 i_Dates       => v_Dates);
  end;

  --------------------------------------------------
  Procedure Autogen_Schedule(i_Company_Id number) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for Sch in (select *
                    from Htt_Schedules t
                   where t.Company_Id = r.Company_Id
                     and t.Filial_Id = r.Filial_Id
                     and not exists (select 1
                            from Htt_Schedule_Origin_Days k
                           where k.Company_Id = t.Company_Id
                             and k.Filial_Id = t.Filial_Id
                             and k.Schedule_Id = t.Schedule_Id
                             and Extract(year from k.Schedule_Date) = v_Year))
      loop
        Gen_Schedule_For_Year(i_Company_Id  => Sch.Company_Id,
                              i_Filial_Id   => Sch.Filial_Id,
                              i_Schedule_Id => Sch.Schedule_Id,
                              i_Year        => v_Year);
      end loop;
    
      Biruni_Route.Context_End;
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
                     and Cp.Project_Code = Href_Pref.c_Pc_Verifix_Hr) or
          c.Company_Id = Md_Pref.c_Company_Head);

  for Cmp in (select c.Company_Id, Rownum
                from Md_Companies c
               where c.State = 'A'
                 and (exists (select 1
                                from Md_Company_Projects Cp
                               where Cp.Company_Id = c.Company_Id
                                 and Cp.Project_Code = Href_Pref.c_Pc_Verifix_Hr) or
                      c.Company_Id = Md_Pref.c_Company_Head))
  loop
    Dbms_Application_Info.Set_Module('Generate_Schedule_for_2023',(Cmp.Rownum - 1) || '/' ||
                                     v_Company_Count || ' generated');
    Autogen_Schedule(Cmp.Company_Id);
  
    commit;
  end loop;
end;
/
