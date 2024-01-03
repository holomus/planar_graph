PL/SQL Developer Test script 3.0
35
-- Created on 5/4/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  v_Company_Id number := 1420;
  v_Begin      date := to_date('01.04.2023', 'dd.mm.yyyy');
  v_End        date := to_date('01.05.2023', 'dd.mm.yyyy') - 1;
  r_Track      Htt_Tracks%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select *
              from Htt_Timesheets q
             where q.Company_Id = v_Company_Id
               and q.Employee_Id not in (58673)
               and q.Timesheet_Date between v_Begin and v_End
               and q.Day_Kind = Htt_Pref.c_Day_Kind_Work
               and q.Input_Time is not null
               and (q.Output_Time is null))
  loop
    r_Track.Company_Id := r.Company_Id;
    r_Track.Filial_Id  := r.Filial_Id;
    r_Track.Person_Id  := r.Employee_Id;
    r_Track.Track_Id   := Htt_Next. Track_Id;
    r_Track.Track_Type := Htt_Pref.c_Track_Type_Output;
    r_Track.Track_Time := r.End_Time;
    r_Track.Mark_Type  := Htt_Pref.c_Mark_Type_Manual;
  
    Htt_Api.Track_Add(r_Track);
  end loop;

  Biruni_Route.Context_End;
  commit;
end;
0
0
