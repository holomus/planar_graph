PL/SQL Developer Test script 3.0
197
declare
  c_Company_Id number := 0;
  c_Filial_Id  number := 104;

  c_Staff_Id number := 82;

  c_Change_Kind varchar2(1); -- enter manually if you want

  c_Change_Day_Count number := 5;

  c_First_Date date := '15.02.2022';

  v_Change Htt_Pref.Change_Rt;

  v_Change_Day  Htt_Pref.Change_Day_Rt;
  v_Change_Days Htt_Pref.Change_Day_Nt := Htt_Pref.Change_Day_Nt();

  v_Swap_Date date;
begin
  if Dbms_Random.Value() > 0.5 then
    c_Change_Kind := Htt_Pref.c_Change_Kind_Change_Plan;
  else
    c_Change_Kind := Htt_Pref.c_Change_Kind_Swap;
  end if;

  if c_Change_Kind = Htt_Pref.c_Change_Kind_Change_Plan then
    select Change_Date,
           Swapped_Date,
           Day_Kind,
           Begin_Time,
           End_Time,
           Break_Enabled,
           Break_Begin_Time,
           Break_End_Time,
           Plan_Time - Floor(Dbms_Random.Value(0, Plan_Time))
      bulk collect
      into v_Change_Days
      from (select Dt.*,
                   Htt_Util.Calc_Full_Time(i_Day_Kind         => Day_Kind,
                                           i_Begin_Time       => Begin_Time,
                                           i_End_Time         => End_Time,
                                           i_Break_Begin_Time => Break_Begin_Time,
                                           i_Break_End_Time   => Break_End_Time) * 60 Plan_Time
            
              from (select Change_Date,
                           null Swapped_Date,
                           Day_Kind,
                           Change_Date + Dbms_Random.Value(0.35, 0.45) Begin_Time,
                           Change_Date + Dbms_Random.Value(0.75, 0.85) End_Time,
                           Break_Enabled,
                           case
                             when Break_Enabled = 'Y' then
                              Change_Date + Dbms_Random.Value(0.53, 0.55)
                             else
                              null
                           end Break_Begin_Time,
                           case
                             when Break_Enabled = 'Y' then
                              Change_Date + Dbms_Random.Value(0.56, 0.58)
                             else
                              null
                           end Break_End_Time
                      from (select c_First_Date + level - 1 + Floor(Dbms_Random.Value(0, 10)) Change_Date,
                                   case
                                     when Dbms_Random.Value() > 0.5 then
                                      'Y'
                                     else
                                      'N'
                                   end Break_Enabled,
                                   case
                                     when Dbms_Random.Value() > 0.75 then
                                      Htt_Pref.c_Day_Kind_Rest
                                     else
                                      Htt_Pref.c_Day_Kind_Work
                                   end Day_Kind
                              from Dual
                            connect by level <= c_Change_Day_Count)) Dt);
  else
    v_Swap_Date := c_First_Date + Floor(Dbms_Random.Value(0, 10));
  
    select t.Timesheet_Date,
           t.Timesheet_Date,
           t.Day_Kind,
           t.Begin_Time,
           t.End_Time,
           t.Break_Enabled,
           t.Break_Begin_Time,
           t.Break_End_Time,
           t.Plan_Time
      into v_Change_Day
      from Htt_Timesheets t
     where t.Company_Id = c_Company_Id
       and t.Filial_Id = c_Filial_Id
       and t.Staff_Id = c_Staff_Id
       and t.Timesheet_Date = v_Swap_Date;
  
    v_Swap_Date := c_First_Date + c_Change_Day_Count + Floor(Dbms_Random.Value(0, 10));
  
    while v_Swap_Date = v_Change_Day.Change_Date
    loop
      v_Swap_Date := c_First_Date + c_Change_Day_Count + Floor(Dbms_Random.Value(0, 10));
    end loop;
  
    v_Change_Day.Change_Date := v_Swap_Date;
  
    v_Change_Day.Begin_Time       := v_Change_Day.Begin_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.End_Time         := v_Change_Day.End_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.Break_Begin_Time := v_Change_Day.Break_Begin_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.Break_End_Time   := v_Change_Day.Break_End_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
  
    v_Change_Days.Extend();
  
    v_Change_Days(v_Change_Days.Count) := v_Change_Day;
  
    select t.Timesheet_Date,
           t.Timesheet_Date,
           t.Day_Kind,
           t.Begin_Time,
           t.End_Time,
           t.Break_Enabled,
           t.Break_Begin_Time,
           t.Break_End_Time,
           t.Plan_Time
      into v_Change_Day
      from Htt_Timesheets t
     where t.Company_Id = c_Company_Id
       and t.Filial_Id = c_Filial_Id
       and t.Staff_Id = c_Staff_Id
       and t.Timesheet_Date = v_Swap_Date;
  
    v_Change_Day.Change_Date := v_Change_Days(1).Swapped_Date;
  
    v_Change_Day.Begin_Time       := v_Change_Day.Begin_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.End_Time         := v_Change_Day.End_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.Break_Begin_Time := v_Change_Day.Break_Begin_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
    v_Change_Day.Break_End_Time   := v_Change_Day.Break_End_Time +
                                     (v_Change_Day.Change_Date - v_Change_Day.Swapped_Date);
  
    v_Change_Days.Extend();
  
    v_Change_Days(v_Change_Days.Count) := v_Change_Day;
  end if;

  Htt_Util.Change_New(o_Change      => v_Change,
                      i_Company_Id  => c_Company_Id,
                      i_Filial_Id   => c_Filial_Id,
                      i_Change_Id   => Htt_Next.Change_Id,
                      i_Staff_Id    => c_Staff_Id,
                      i_Change_Kind => c_Change_Kind,
                      i_Note        => 'Testing Plan Change');

  for i in 1 .. v_Change_Days.Count
  loop
    v_Change_Day := v_Change_Days(i);
  
    if v_Change_Day.Day_Kind not in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) then
      v_Change_Day.Begin_Time       := null;
      v_Change_Day.End_Time         := null;
      v_Change_Day.Break_Enabled    := null;
      v_Change_Day.Break_Begin_Time := null;
      v_Change_Day.Break_End_Time   := null;
      v_Change_Day.Plan_Time        := 0;
    end if;
  
    Htt_Util.Change_Day_Add(o_Change           => v_Change,
                            i_Change_Date      => v_Change_Day.Change_Date,
                            i_Swapped_Date     => v_Change_Day.Swapped_Date,
                            i_Day_Kind         => v_Change_Day.Day_Kind,
                            i_Begin_Time       => v_Change_Day.Begin_Time,
                            i_End_Time         => v_Change_Day.End_Time,
                            i_Break_Enabled    => v_Change_Day.Break_Enabled,
                            i_Break_Begin_Time => v_Change_Day.Break_Begin_Time,
                            i_Break_End_Time   => v_Change_Day.Break_End_Time,
                            i_Plan_Time        => v_Change_Day.Plan_Time);
  end loop;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(c_Company_Id);
  Htt_Api.Change_Save(v_Change);

  Htt_Api.Change_Approve(i_Company_Id => v_Change.Company_Id,
                         i_Filial_Id  => v_Change.Filial_Id,
                         i_Change_Id  => v_Change.Change_Id);

  Htt_Api.Change_Complete(i_Company_Id => v_Change.Company_Id,
                          i_Filial_Id  => v_Change.Filial_Id,
                          i_Change_Id  => v_Change.Change_Id);
  Biruni_Route.Context_End;
  commit;
end;
0
0
