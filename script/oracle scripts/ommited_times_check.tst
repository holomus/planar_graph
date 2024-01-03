PL/SQL Developer Test script 3.0
71
-- Created on 11/23/2022 by ADHAM 
declare
  -- Local variables here
  v_Company_Id    number := 560;
  v_Filial_Id     number := 15689;
  v_Division_Id   number := 5689;
  v_Period        date := to_date('28.11.2022', 'dd.mm.yyyy');
  r_Division      Hrm_Division_Schedules%rowtype;
  r_Schedule_Day  Htt_Schedule_Days%rowtype;
  v_Merge_Dattime date := null;

  v_Late_Input   date;
  v_Early_Output date;
  v_Input_Date   date;
  v_Output_Date  date;

  v_Part               Htt_Pref.Time_Part_Rt;
  v_Fact_Time_Parts    Htt_Pref.Time_Part_Nt;
  v_Ommited_Time_Parts Htt_Pref.Time_Part_Nt;
begin
  -- Test statements here
  r_Division := z_Hrm_Division_Schedules.Take(i_Company_Id  => v_Company_Id,
                                              i_Filial_Id   => v_Filial_Id,
                                              i_Division_Id => v_Division_Id);

  r_Schedule_Day := z_Htt_Schedule_Days.Take(i_Company_Id    => v_Company_Id,
                                             i_Filial_Id     => v_Filial_Id,
                                             i_Schedule_Id   => r_Division.Schedule_Id,
                                             i_Schedule_Date => v_Period);

  if v_Merge_Dattime is not null then
    /*    if v_Merge_Dattime < r_Schedule_Day.Begin_Time then
      Result.Status := c_Status_Not_Begin;
      return result;
    end if;*/
  
    r_Schedule_Day.Shift_End_Time := Least(r_Schedule_Day.Shift_End_Time, v_Merge_Dattime);
    r_Schedule_Day.End_Time       := Least(r_Schedule_Day.End_Time, r_Schedule_Day.Shift_End_Time);
  end if;

  Uit_Htt.Eval_Time_Parts(i_Company_Id         => v_Company_Id,
                          i_Filial_Id          => v_Filial_Id,
                          i_Division_Id        => v_Division_Id,
                          i_Period             => v_Period,
                          i_Merge_Datetime     => v_Merge_Dattime,
                          i_Schedule_Day       => r_Schedule_Day,
                          o_Late_Input         => :v_Late_Input,
                          o_Early_Output       => :v_Early_Output,
                          o_Input_Date         => :v_Input_Date,
                          o_Output_Date        => :v_Output_Date,
                          o_Fact_Time_Parts    => v_Fact_Time_Parts,
                          o_Ommited_Time_Parts => v_Ommited_Time_Parts);

  Dbms_Output.Put_Line('================  FACT TIME  ==================');
  for i in 1 .. v_Fact_Time_Parts.Count
  loop
    v_Part := v_Fact_Time_Parts(i);
    Dbms_Output.Put_Line(to_char(v_Part.Input_Time, 'hh24:mi:ss') || ' - ' ||
                         to_char(v_Part.Output_Time, 'hh24:mi:ss') || ' ===> ' ||
                         Round((v_Part.Output_Time - v_Part.Input_Time) * 86400));
  end loop;

  Dbms_Output.Put_Line('================  OMMITED TIME  ==================');
  for i in 1 .. v_Ommited_Time_Parts.Count
  loop
    v_Part := v_Ommited_Time_Parts(i);
    Dbms_Output.Put_Line(to_char(v_Part.Input_Time, 'hh24:mi:ss') || ' - ' ||
                         to_char(v_Part.Output_Time, 'hh24:mi:ss') || ' ===> ' ||
                         Round((v_Part.Output_Time - v_Part.Input_Time) * 86400));
  end loop;
end;
4
v_Late_Input
1
28.11.22
5
v_Early_Output
1
28.11.22
5
v_Input_Date
1
28.11.22
5
v_Output_Date
1
28.11.22
5
8
r_Division
v_company_id
v_filial_id
v_division_id
r_division.schedule_id
r_schedule_day.begin_time
v_input
v_tracks
