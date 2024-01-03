PL/SQL Developer Test script 3.0
36
-- Created on 11/3/2022 by ADHAM 
declare
  -- Local variables here
  i       integer;
  v_Dates Array_Date;
begin
  -- Test statements here  
  v_Dates := Array_Date();

  for i in 0 .. 200
  loop
    Fazo.Push(v_Dates, to_date('01.07.2022', 'dd.mm.yyyy') + i);
  end loop;

  for r in (select *
              from Md_Filials q
             where q.Company_Id = 181
               and q.State = 'A')
  loop
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(181);
  
    for Sc in (select *
                 from Htt_Schedules w
                where w.Company_Id = 181
                  and w.Filial_Id = r.Filial_Id
                  and w.Code like 'chp%')
    loop
      Htt_Core.Regen_Timesheet_Plan(i_Company_Id  => 181,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Schedule_Id => Sc.Schedule_Id,
                                    i_Dates       => v_Dates);
    end loop;
    Biruni_Route.Context_End;
  end loop;
end;
0
0
