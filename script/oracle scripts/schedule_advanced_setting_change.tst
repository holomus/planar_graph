PL/SQL Developer Test script 3.0
57
-- Created on 07.10.2022 by Nuriddin 
declare
  v_Year       number := Extract(year from sysdate);
  v_Year_Begin date := Trunc(to_date(v_Year, 'yyyy'), 'y');
  v_Year_End   date := Add_Months(v_Year_Begin, 12) - 1;

  v_Company_Id        number := 0;
  v_Filial_Id         number := 104;
  v_Schedule_Id       number := 1;
  v_Shift             number := 120;
  v_Input_Acceptance  number := 0;
  v_Output_Acceptance number := 0;
  v_Track_Duration    number := 1440;
  v_Count_Late        varchar2(1) := 'Y';
  v_Count_Early       varchar2(1) := 'Y';
  v_Count_Lack        varchar2(1) := 'Y';

  v_Has_Blocked_Timesheet varchar2(1);
begin
  begin
    select 'Y'
      into v_Has_Blocked_Timesheet
      from Htt_Timesheets t
     where t.Company_Id = v_Company_Id
       and t.Filial_Id = v_Filial_Id
       and t.Schedule_Id = v_Schedule_Id
       and t.Timesheet_Date between v_Year_Begin and v_Year_End
       and exists (select 1
              from Hpr_Timesheet_Locks h
             where h.Company_Id = v_Company_Id
               and h.Filial_Id = v_Filial_Id
               and h.Staff_Id = t.Staff_Id
               and h.Timesheet_Date = t.Timesheet_Date)
       and Rownum = 1;
  exception
    when No_Data_Found then
      v_Has_Blocked_Timesheet := 'N';
  end;

  if v_Has_Blocked_Timesheet = 'N' then
    z_Htt_Schedules.Update_One(i_Company_Id        => v_Company_Id,
                               i_Filial_Id         => v_Filial_Id,
                               i_Schedule_Id       => v_Schedule_Id,
                               i_Shift             => Option_Number(v_Shift),
                               i_Input_Acceptance  => Option_Number(v_Input_Acceptance),
                               i_Output_Acceptance => Option_Number(v_Output_Acceptance),
                               i_Track_Duration    => Option_Number(v_Track_Duration),
                               i_Count_Late        => Option_Varchar2(v_Count_Late),
                               i_Count_Early       => Option_Varchar2(v_Count_Early),
                               i_Count_Lack        => Option_Varchar2(v_Count_Lack));
  
    Htt_Core.Gen_Timesheet_Plan(i_Company_Id  => v_Company_Id,
                                i_Filial_Id   => v_Filial_Id,
                                i_Schedule_Id => v_Schedule_Id,
                                i_Year        => v_Year);
  end if;
end;
0
0
