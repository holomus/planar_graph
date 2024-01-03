PL/SQL Developer Test script 3.0
72
-- Created on 12/15/2022 by ADHAM 
declare
  v_Company_Id number := 580;
  v_Filial_Id  number := 48905;

  v_Sch Array_Number;

  v_Dates Array_Date;

  v_Mat Matrix_Number := Matrix_Number(Array_Number(19926, 480, 120, 120),
                                       Array_Number(19931, 480, 120, 120),
                                       Array_Number(20356, 540, 120, 120));
begin
  Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;
  for i in 1 .. v_Mat.Count
  loop
    v_Sch := v_Mat(i);
  
    z_Htt_Schedules.Update_One(i_Company_Id        => v_Company_Id,
                               i_Filial_Id         => v_Filial_Id,
                               i_Schedule_Id       => v_Sch(1),
                               i_Shift             => Option_Number(v_Sch(2)),
                               i_Input_Acceptance  => Option_Number(v_Sch(3)),
                               i_Output_Acceptance => Option_Number(v_Sch(4)),
                               i_Track_Duration    => Option_Number(1440 + v_Sch(3) + v_Sch(4)));
    begin
      update Htt_Schedule_Origin_Days p
         set p.Shift_Begin_Time = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute'),
             p.Shift_End_Time   = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') +
                                  Numtodsinterval(1440, 'minute'),
             p.Input_Border     = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') -
                                  Numtodsinterval(v_Sch(3), 'minute'),
             p.Output_Border    = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') +
                                  Numtodsinterval(1440, 'minute') +
                                  Numtodsinterval(v_Sch(4), 'minute')
       where p.Company_Id = v_Company_Id
         and p.Filial_Id = v_Filial_Id
         and p.Schedule_Id = v_Sch(1);
    exception
      when others then
        b.Raise_Error(v_Sch(1));
    end;
    update Htt_Schedule_Days p
       set p.Shift_Begin_Time = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute'),
           p.Shift_End_Time   = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') +
                                Numtodsinterval(1440, 'minute'),
           p.Input_Border     = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') -
                                Numtodsinterval(v_Sch(3), 'minute'),
           p.Output_Border    = p.Schedule_Date + Numtodsinterval(v_Sch(2), 'minute') +
                                Numtodsinterval(1440, 'minute') +
                                Numtodsinterval(v_Sch(4), 'minute')
     where p.Company_Id = v_Company_Id
       and p.Filial_Id = v_Filial_Id
       and p.Schedule_Id = v_Sch(1);
  
    select p.Timesheet_Date
      bulk collect
      into v_Dates
      from Htt_Timesheets p
     where p.Company_Id = v_Company_Id
       and p.Filial_Id = v_Filial_Id
       and p.Schedule_Id = v_Sch(1)
     group by p.Timesheet_Date;
  
    Htt_Core.Regen_Timesheet_Plan(i_Company_Id  => v_Company_Id,
                                  i_Filial_Id   => v_Filial_Id,
                                  i_Schedule_Id => v_Sch(1),
                                  i_Dates       => v_Dates);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
