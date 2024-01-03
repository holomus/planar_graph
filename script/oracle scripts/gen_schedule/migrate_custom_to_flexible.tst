PL/SQL Developer Test script 3.0
88
declare
  v_Company_Id  number := 100;
  v_Filial_Id   number := 109;
  v_Registry_Id number;

  v_Registry Htt_Pref.Schedule_Registry_Rt;
  v_Unit     Htt_Pref.Registry_Unit_Rt;
  v_Day      Htt_Pref.Schedule_Day_Rt;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select q.*
              from Htt_Schedule_Registries q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Month = Trunc(sysdate, 'mon')
               and q.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Custom
               and q.Posted = 'Y')
  loop
    v_Registry    := Htt_Pref.Schedule_Registry_Rt();
    v_Registry_Id := Htt_Next.Registry_Id;
  
    Htt_Util.Schedule_Registry_New(o_Schedule_Registry => v_Registry,
                                   i_Company_Id        => v_Company_Id,
                                   i_Filial_Id         => v_Filial_Id,
                                   i_Registry_Id       => v_Registry_Id,
                                   i_Registry_Date     => r.Registry_Date,
                                   i_Registry_Number   => r.Registry_Number,
                                   i_Registry_Kind     => r.Registry_Kind,
                                   i_Schedule_Kind     => Htt_Pref.c_Schedule_Kind_Flexible,
                                   i_Month             => r.Month,
                                   i_Division_Id       => r.Division_Id,
                                   i_Note              => r.Note,
                                   i_Shift             => null,
                                   i_Input_Acceptance  => null,
                                   i_Output_Acceptance => null,
                                   i_Track_Duration    => null,
                                   i_Count_Late        => r.Count_Late,
                                   i_Count_Early       => r.Count_Early,
                                   i_Count_Lack        => r.Count_Lack,
                                   i_Calendar_Id       => r.Calendar_Id,
                                   i_Take_Holidays     => r.Take_Holidays,
                                   i_Take_Nonworking   => r.Take_Nonworking);
  
    for Unt in (select *
                  from Htt_Registry_Units Ru
                 where Ru.Company_Id = v_Company_Id
                   and Ru.Filial_Id = v_Filial_Id
                   and Ru.Registry_Id = r.Registry_Id)
    loop
      v_Unit := Htt_Pref.Registry_Unit_Rt();
    
      Htt_Util.Registry_Unit_New(o_Registry_Unit   => v_Unit,
                                 i_Unit_Id         => Htt_Next.Unit_Id,
                                 i_Staff_Id        => Unt.Staff_Id,
                                 i_Robot_Id        => Unt.Robot_Id,
                                 i_Monthly_Minutes => Unt.Monthly_Minutes,
                                 i_Monthly_Days    => Unt.Monthly_Days);
    
      for Sday in (select *
                     from Htt_Unit_Schedule_Days Sd
                    where Sd.Company_Id = v_Company_Id
                      and Sd.Filial_Id = v_Filial_Id
                      and Sd.Unit_Id = Unt.Unit_Id)
      loop
        v_Day := Htt_Pref.Schedule_Day_Rt();
      
        Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                  i_Schedule_Date    => Sday.Schedule_Date,
                                  i_Day_Kind         => Sday.Day_Kind,
                                  i_Begin_Time       => (Sday.Begin_Time - Sday.Schedule_Date) * 24 * 60,
                                  i_End_Time         => (Sday.End_Time - Sday.Schedule_Date) * 24 * 60,
                                  i_Break_Enabled    => Sday.Break_Enabled,
                                  i_Break_Begin_Time => (Sday.Break_Begin_Time - Sday.Schedule_Date) * 24 * 60,
                                  i_Break_End_Time   => (Sday.Break_End_Time - Sday.Schedule_Date) * 24 * 60,
                                  i_Plan_Time        => Sday.Plan_Time);
      
        v_Unit.Unit_Days.Extend();
        v_Unit.Unit_Days(v_Unit.Unit_Days.Count) := v_Day;
      end loop;
    
      v_Registry.Units.Extend();
      v_Registry.Units(v_Registry.Units.Count) := v_Unit;
    end loop;
  
    Htt_Api.Schedule_Registry_Save(v_Registry);
  end loop;
end;
0
0
