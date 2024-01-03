create or replace package Htt_Core is
  ----------------------------------------------------------------------------------------------------
  Function Next_Pin(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Calendar_Day_Change
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    p_Dates       in out nocopy Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Year        number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Function Find_Request_Timesheets
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Request_Begin date,
    i_Request_End   date
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Find_Track_Timesheets
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Track_Datetime date
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Potential_Outputs(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Potential_Outputs;
  ----------------------------------------------------------------------------------------------------
  Procedure Revised_Timesheets;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Timesheet
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Change_Timesheet_Plans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Delete(i_Timesheet Htt_Timesheets%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Plan
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Schedule_Id    number,
    i_Calendar_Id    number,
    i_Timesheet_Date date,
    i_Track_Duration number,
    i_Schedule_Kind  varchar2,
    i_Count_Late     varchar2,
    i_Count_Early    varchar2,
    i_Count_Lack     varchar2,
    i_Count_Free     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Year        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Requests
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Timesheet_Id           number,
    i_Timesheet_Date         date,
    i_Begin_Time             date,
    i_End_Time               date,
    i_Extra_Begin_Time       date,
    i_Extra_End_Time         date,
    i_Calendar_Id            number,
    o_Has_Fd_Request         out boolean,
    o_Fd_Rq_Time_Kind_Id     out number,
    o_Fd_Request_Unused_Time out varchar2,
    o_Rq_Request_Types       out Array_Varchar2,
    o_Rq_Begin_Dates         out Array_Date,
    o_Rq_End_Dates           out Array_Date,
    o_Rq_Time_Kind_Ids       out Array_Number,
    o_Rq_Parent_Ids          out Array_Number,
    o_Rq_Unused_Times        out Array_Varchar2,
    o_Extra_Rq_Begin_Dates   out Array_Date,
    o_Extra_Rq_End_Dates     out Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Rest_Day
  (
    p_Timesheet      in out nocopy Htt_Timesheets%rowtype,
    p_Facts          in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Time_Parts     Htt_Pref.Time_Part_Nt,
    i_Requests_Exist boolean
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Free_Day
  (
    p_Timesheet       in out nocopy Htt_Timesheets%rowtype,
    p_Facts           in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Time_Parts      Htt_Pref.Time_Part_Nt,
    i_Begin_Late_Time date,
    i_Late_Input      date,
    i_Requests_Exist  boolean
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Work_Day
  (
    p_Timesheet      in out nocopy Htt_Timesheets%rowtype,
    p_Facts          in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    p_Intervals      in out nocopy Htt_Pref.Timesheet_Interval_Nt,
    i_Time_Parts     Htt_Pref.Time_Part_Nt,
    i_Late_Input     date,
    i_Early_Output   date,
    i_Requests_Exist boolean
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Fact
  (
    p_Facts         in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Timesheet_Id  number,
    i_Time_Kind_Id  number,
    i_Fact_Value    number,
    i_Schedule_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Send_Notify  boolean := false
  );
  ---------------------------------------------------------------------------------------------------- 
  -- transforms check tracks to input/output/merger/potential output
  -- one track should be transformed only once
  -- %param p_Tracks       array of all timesheet tracks, returns as with reordered and transformed tracks 
  -- %param p_Trans_Tracks array of transformed tracks, returns same array adding transformed tracks
  Procedure Transform_Check_Tracks
  (
    p_Tracks       in out nocopy Htt_Pref.Timesheet_Track_Nt,
    p_Trans_Tracks in out nocopy Htt_Pref.Timesheet_Track_Nt,
    i_Timesheet    Htt_Timesheets%rowtype
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts;
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Requests
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timeoff_Facts
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Timeoff_Id     number,
    i_Remove_Timeoff boolean := false
  );
  ----------------------------------------------------------------------------------------------------        
  Procedure Insert_Overtime_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Overtime_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Remove_Overtime_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Overtime_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Adjustment_Fact
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Id   number,
    i_Timesheet_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Track_Update_Status
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Track_Add
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Track_Id       number,
    i_Employee_Id    number,
    i_Track_Datetime date,
    i_Track_Type     varchar2,
    i_Trans_Input    varchar2,
    i_Trans_Output   varchar2,
    i_Trans_Check    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Track_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Track_Id    number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Person
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Persistent boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Trash_Track_Insert(i_Track Htt_Tracks%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Person_Changes;
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Lock
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Unlock
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Regenerate_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Regenerate_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Timesheets
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Lower_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Command_Add
  (
    i_Company_Id   number,
    i_Device_Id    number,
    i_Command_Kind varchar2,
    i_Person_Id    number := null,
    i_Data         varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Gps_Track_Distance;
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------      
  Procedure Person_Sync_Locations
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Persistent boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number,
    i_Attach_Type varchar2,
    i_Persistent  boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number,
    i_Persistent  boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Sync_Locations(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Global_Sync_Location_Persons
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Global_Sync_All_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Global_Sync_All_Location
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Qr_Codes;
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Accrual_Evaluate
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Period          date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Request_Kind_Accruals(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Request_Kind_Accruals;
  ---------------------------------------------------------------------------------------------------- 
  -- gen plan for individual staff schedule
  Procedure Gen_Timesheet_Plan_Individual
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  );
  ---------------------------------------------------------------------------------------------------- 
  -- gen plan for individual robot schedule
  Procedure Gen_Timesheet_Plan_Individual
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Robot_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Individual_Dates
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  );

end Htt_Core;
/
create or replace package body Htt_Core is
  ----------------------------------------------------------------------------------------------------
  g_Is_Individual_Schedule Fazo.Boolean_Id_Aat;
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HTT:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Individual_Staff_Schedule
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number
  ) return boolean is
  begin
    if i_Schedule_Id is null then
      return false;
    end if;
  
    if g_Is_Individual_Schedule.Exists(i_Schedule_Id) then
      return g_Is_Individual_Schedule(i_Schedule_Id);
    end if;
  
    g_Is_Individual_Schedule(i_Schedule_Id) := Fazo.Equal(z_Htt_Schedules.Load( --
                                                          i_Company_Id => i_Company_Id, --
                                                          i_Filial_Id => i_Filial_Id, --
                                                          i_Schedule_Id => i_Schedule_Id).Pcode,
                                                          Htt_Pref.c_Pcode_Individual_Staff_Schedule);
  
    return g_Is_Individual_Schedule(i_Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Next_Pin(i_Company_Id number) return number is
    result number;
  begin
    z_Htt_Pin_Locks.Lock_Only(i_Company_Id);
  
    select max(Rownum)
      into result
      from (select to_number(q.Pin) Pin
              from Htt_Persons q
             where q.Company_Id = i_Company_Id
               and to_number(q.Pin) is not null
             order by to_number(q.Pin)) q
     where q.Pin = Rownum;
  
    return Nvl(result, 0) + 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Calendar_Day_Change
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Dates       Array_Date
  ) is
    r_Calendar_Day Htt_Calendar_Days%rowtype;
    v_Data         Hashmap;
  begin
    for i in 1 .. i_Dates.Count
    loop
      v_Data         := Hashmap();
      r_Calendar_Day := z_Htt_Calendar_Days.Load(i_Company_Id    => i_Company_Id,
                                                 i_Filial_Id     => i_Filial_Id,
                                                 i_Calendar_Id   => i_Calendar_Id,
                                                 i_Calendar_Date => i_Dates(i));
    
      v_Data.Put('notify_type', Hes_Pref.c_Pref_Nt_Calendar_Day_Change);
      v_Data.Put('name', r_Calendar_Day.Name);
      v_Data.Put('day_kind', r_Calendar_Day.Day_Kind);
      v_Data.Put('day_kind_name', Htt_Util.t_Day_Kind(r_Calendar_Day.Day_Kind));
      v_Data.Put('calendar_date', r_Calendar_Day.Calendar_Date);
      v_Data.Put('swapped_date', r_Calendar_Day.Swapped_Date);
    
      for Emp in (select Ts.Employee_Id
                    from Htt_Timesheets Ts
                   where Ts.Company_Id = i_Company_Id
                     and Ts.Filial_Id = i_Filial_Id
                     and Ts.Schedule_Id in (select s.Schedule_Id
                                              from Htt_Schedules s
                                             where s.Company_Id = i_Company_Id
                                               and s.Filial_Id = i_Filial_Id
                                               and s.Calendar_Id = i_Calendar_Id)
                     and Ts.Timesheet_Date = r_Calendar_Day.Calendar_Date
                   group by Ts.Employee_Id)
      loop
        continue when not Hes_Util.Enabled_Notify(i_Company_Id   => i_Company_Id,
                                                  i_User_Id      => Emp.Employee_Id,
                                                  i_Setting_Code => Hes_Pref.c_Pref_Nt_Calendar_Day_Change);
      
        Mt_Fcm.Send(i_Company_Id => i_Company_Id, --
                    i_User_Id    => Emp.Employee_Id,
                    i_Data       => v_Data);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Timesheet
  (
    i_Timesheet   Htt_Timesheets%rowtype,
    i_Late_Time   number := 0,
    i_Early_Time  number := 0,
    i_Notify_Type varchar2
  ) is
    r_Person     Mr_Natural_Persons%rowtype;
    r_Staff      Href_Staffs%rowtype;
    v_Manager_Id number;
    result       Hashmap := Hashmap();
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Timesheet.Company_Id,
                                  i_Filial_Id  => i_Timesheet.Filial_Id,
                                  i_Staff_Id   => i_Timesheet.Staff_Id);
  
    r_Person := z_Mr_Natural_Persons.Take(i_Company_Id => r_Staff.Company_Id,
                                          i_Person_Id  => r_Staff.Employee_Id);
  
    v_Manager_Id := Href_Util.Get_Manager_Id(i_Company_Id => r_Staff.Company_Id,
                                             i_Filial_Id  => r_Staff.Filial_Id,
                                             i_Robot_Id   => r_Staff.Robot_Id);
  
    if not Hes_Util.Enabled_Notify(i_Company_Id   => i_Timesheet.Company_Id,
                                   i_User_Id      => v_Manager_Id,
                                   i_Setting_Code => i_Notify_Type) then
      return;
    end if;
  
    Result.Put('notify_type', i_Notify_Type);
    Result.Put('timesheet_id', i_Timesheet.Timesheet_Id);
    Result.Put('timesheet_date', i_Timesheet.Timesheet_Date);
    Result.Put('employee_name', r_Person.Name);
    Result.Put('begin_time', to_char(i_Timesheet.Begin_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('end_time', to_char(i_Timesheet.End_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('input_time', to_char(i_Timesheet.Input_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('output_time', to_char(i_Timesheet.Output_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('early_time', i_Early_Time);
    Result.Put('late_time', i_Late_Time);
  
    Mt_Fcm.Send(i_Company_Id => i_Timesheet.Company_Id, --
                i_User_Id    => v_Manager_Id,
                i_Data       => result);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Schedule_Day_Extras
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Schedule_Id   number,
    i_Schedule_Date date,
    i_Source_Date   date,
    i_Schedule_Day  Htt_Schedule_Origin_Days%rowtype
  ) is
    v_Weights_Sum number := 0;
    v_Weights     Htt_Pref.Interval_Weight_Nt := Htt_Pref.Interval_Weight_Nt();
  
    --------------------------------------------------
    Procedure Push_Weights
    (
      p_Weights        in out nocopy Htt_Pref.Interval_Weight_Nt,
      p_Weights_Sum    in out number,
      i_Interval_Begin date,
      i_Interval_End   date,
      i_Weight         number
    ) is
      v_Weight Htt_Pref.Interval_Weight_Rt;
    begin
      v_Weight.Begin_Time := i_Interval_Begin;
      v_Weight.End_Time   := i_Interval_End;
      v_Weight.Weight     := i_Weight;
    
      if i_Schedule_Day.Break_Enabled = 'Y' and
         v_Weight.Begin_Time < i_Schedule_Day.Break_Begin_Time and
         v_Weight.End_Time > i_Schedule_Day.Break_End_Time then
      
        v_Weight.End_Time := i_Schedule_Day.Break_Begin_Time;
      
        p_Weights.Extend;
        p_Weights(p_Weights.Count) := v_Weight;
      
        p_Weights_Sum := p_Weights_Sum +
                         v_Weight.Weight *
                         Htt_Util.Time_Diff(i_Time1 => v_Weight.End_Time,
                                            i_Time2 => v_Weight.Begin_Time);
      
        v_Weight.Begin_Time := i_Schedule_Day.Break_End_Time;
        v_Weight.End_Time   := i_Interval_End;
      elsif i_Schedule_Day.Break_Begin_Time <= v_Weight.Begin_Time and
            i_Schedule_Day.Break_End_Time >= v_Weight.End_Time then
        return;
      elsif i_Schedule_Day.Break_Enabled = 'Y' then
        if i_Schedule_Day.Break_Begin_Time between v_Weight.Begin_Time and v_Weight.End_Time then
          v_Weight.End_Time := i_Schedule_Day.Break_Begin_Time;
        end if;
      
        if i_Schedule_Day.Break_End_Time between v_Weight.Begin_Time and v_Weight.End_Time then
          v_Weight.Begin_Time := i_Schedule_Day.Break_End_Time;
        end if;
      end if;
    
      if v_Weight.Begin_Time < v_Weight.End_Time then
        p_Weights.Extend;
        p_Weights(p_Weights.Count) := v_Weight;
      
        p_Weights_Sum := p_Weights_Sum +
                         v_Weight.Weight *
                         Htt_Util.Time_Diff(i_Time1 => v_Weight.End_Time,
                                            i_Time2 => v_Weight.Begin_Time);
      end if;
    end;
  begin
    if i_Schedule_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work then
      insert into Htt_Schedule_Day_Marks Dm
        (Dm.Company_Id, --
         Dm.Filial_Id,
         Dm.Schedule_Id,
         Dm.Schedule_Date,
         Dm.Begin_Time,
         Dm.End_Time)
        select Om.Company_Id,
               Om.Filial_Id,
               Om.Schedule_Id,
               i_Schedule_Date,
               i_Schedule_Date + Numtodsinterval(Om.Begin_Time, 'minute'),
               i_Schedule_Date + Numtodsinterval(Om.End_Time, 'minute')
          from Htt_Schedule_Origin_Day_Marks Om
         where Om.Company_Id = i_Company_Id
           and Om.Filial_Id = i_Filial_Id
           and Om.Schedule_Id = i_Schedule_Id
           and Om.Schedule_Date = i_Source_Date;
    
      for r in (select i_Schedule_Date + Numtodsinterval(Om.Begin_Time, 'minute') Interval_Begin,
                       i_Schedule_Date + Numtodsinterval(Om.End_Time, 'minute') Interval_End,
                       Om.Weight
                  from Htt_Schedule_Origin_Day_Weights Om
                 where Om.Company_Id = i_Company_Id
                   and Om.Filial_Id = i_Filial_Id
                   and Om.Schedule_Id = i_Schedule_Id
                   and Om.Schedule_Date = i_Source_Date
                 order by Om.Begin_Time)
      loop
        Push_Weights(p_Weights        => v_Weights,
                     p_Weights_Sum    => v_Weights_Sum,
                     i_Interval_Begin => r.Interval_Begin,
                     i_Interval_End   => r.Interval_End,
                     i_Weight         => r.Weight);
      end loop;
    
      for i in 1 .. v_Weights.Count
      loop
        z_Htt_Schedule_Day_Weights.Insert_One(i_Company_Id    => i_Company_Id,
                                              i_Filial_Id     => i_Filial_Id,
                                              i_Schedule_Id   => i_Schedule_Id,
                                              i_Schedule_Date => i_Schedule_Date,
                                              i_Begin_Time    => v_Weights(i).Begin_Time,
                                              i_End_Time      => v_Weights(i).End_Time,
                                              i_Weight        => v_Weights(i).Weight,
                                              i_Coef          => i_Schedule_Day.Plan_Time * 60 /
                                                                 v_Weights_Sum);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- gen schedule day
  -- also gen swapped day if such exists
  -- return date of swapped day through o_swapped_date
  Procedure Gen_Schedule_Day
  (
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Schedule_Id              number,
    i_Schedule_Date            date,
    i_Calendar_Id              number,
    i_Take_Holidays            varchar2,
    i_Take_Nonworking          varchar2,
    i_Take_Additional_Rest_Day varchar2,
    o_Swapped_Date             out date
  ) is
    r_Origin_Day   Htt_Schedule_Origin_Days%rowtype;
    r_First_Day    Htt_Schedule_Origin_Days%rowtype;
    r_Second_Day   Htt_Schedule_Origin_Days%rowtype;
    r_Calendar_Day Htt_Calendar_Days%rowtype;
    v_Swappable    boolean := false;
  
    --------------------------------------------------
    Procedure Swap_Days
    (
      p_Rest_Day in out nocopy Htt_Schedule_Origin_Days%rowtype,
      p_Work_Day in out nocopy Htt_Schedule_Origin_Days%rowtype
    ) is
      v_Swap_Distance number;
      r_Day           Htt_Schedule_Origin_Days%rowtype := p_Rest_Day;
    begin
      v_Swap_Distance := p_Rest_Day.Schedule_Date - p_Work_Day.Schedule_Date;
    
      p_Rest_Day                  := p_Work_Day;
      p_Rest_Day.Schedule_Date    := r_Day.Schedule_Date;
      p_Rest_Day.Begin_Time       := p_Rest_Day.Begin_Time + v_Swap_Distance;
      p_Rest_Day.End_Time         := p_Rest_Day.End_Time + v_Swap_Distance;
      p_Rest_Day.Break_Begin_Time := p_Rest_Day.Break_Begin_Time + v_Swap_Distance;
      p_Rest_Day.Break_End_Time   := p_Rest_Day.Break_End_Time + v_Swap_Distance;
      p_Rest_Day.Shift_Begin_Time := p_Rest_Day.Shift_Begin_Time + v_Swap_Distance;
      p_Rest_Day.Shift_End_Time   := p_Rest_Day.Shift_End_Time + v_Swap_Distance;
      p_Rest_Day.Input_Border     := p_Rest_Day.Input_Border + v_Swap_Distance;
      p_Rest_Day.Output_Border    := p_Rest_Day.Output_Border + v_Swap_Distance;
    
      r_Day.Schedule_Date         := p_Work_Day.Schedule_Date;
      p_Work_Day                  := r_Day;
      p_Work_Day.Shift_Begin_Time := p_Work_Day.Shift_Begin_Time - v_Swap_Distance;
      p_Work_Day.Shift_End_Time   := p_Work_Day.Shift_End_Time - v_Swap_Distance;
      p_Work_Day.Input_Border     := p_Work_Day.Input_Border - v_Swap_Distance;
      p_Work_Day.Output_Border    := p_Work_Day.Output_Border - v_Swap_Distance;
    end;
  
  begin
    if z_Htt_Schedule_Origin_Days.Exist_Lock(i_Company_Id    => i_Company_Id,
                                             i_Filial_Id     => i_Filial_Id,
                                             i_Schedule_Id   => i_Schedule_Id,
                                             i_Schedule_Date => i_Schedule_Date,
                                             o_Row           => r_Origin_Day) then
      if Md_Pref.c_Migr_Company_Id != i_Company_Id then
        if i_Calendar_Id is not null and
           Htt_Util.Is_Calendar_Day(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Calendar_Id  => i_Calendar_Id,
                                    i_Date         => i_Schedule_Date,
                                    o_Calendar_Day => r_Calendar_Day) then
          if r_Calendar_Day.Day_Kind <> Htt_Pref.c_Day_Kind_Nonworking then
            if r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Swapped then
              if i_Schedule_Date = r_Calendar_Day.Calendar_Date then
                r_First_Day  := r_Origin_Day;
                r_Second_Day := z_Htt_Schedule_Origin_Days.Take(i_Company_Id    => i_Company_Id,
                                                                i_Filial_Id     => i_Filial_Id,
                                                                i_Schedule_Id   => i_Schedule_Id,
                                                                i_Schedule_Date => r_Calendar_Day.Swapped_Date);
              
              else
                r_First_Day  := z_Htt_Schedule_Origin_Days.Take(i_Company_Id    => i_Company_Id,
                                                                i_Filial_Id     => i_Filial_Id,
                                                                i_Schedule_Id   => i_Schedule_Id,
                                                                i_Schedule_Date => r_Calendar_Day.Calendar_Date);
                r_Second_Day := r_Origin_Day;
              end if;
            
              v_Swappable := r_First_Day.Day_Kind = Htt_Pref.c_Day_Kind_Rest and
                             r_Second_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work or
                             r_First_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work and
                             r_Second_Day.Day_Kind = Htt_Pref.c_Day_Kind_Rest;
            
              if v_Swappable then
                if r_First_Day.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                  Swap_Days(p_Rest_Day => r_First_Day, p_Work_Day => r_Second_Day);
                else
                  Swap_Days(p_Rest_Day => r_Second_Day, p_Work_Day => r_First_Day);
                end if;
              end if;
            
              if i_Schedule_Date = r_Calendar_Day.Calendar_Date then
                r_Origin_Day := r_First_Day;
              else
                r_Origin_Day := r_Second_Day;
                r_Second_Day := r_First_Day;
              end if;
            
              -- gen swapped day
              z_Htt_Schedule_Days.Save_One(i_Company_Id       => i_Company_Id,
                                           i_Filial_Id        => i_Filial_Id,
                                           i_Schedule_Id      => i_Schedule_Id,
                                           i_Schedule_Date    => r_Second_Day.Schedule_Date,
                                           i_Day_Kind         => r_Second_Day.Day_Kind,
                                           i_Begin_Time       => r_Second_Day.Begin_Time,
                                           i_End_Time         => r_Second_Day.End_Time,
                                           i_Break_Enabled    => r_Second_Day.Break_Enabled,
                                           i_Break_Begin_Time => r_Second_Day.Break_Begin_Time,
                                           i_Break_End_Time   => r_Second_Day.Break_End_Time,
                                           i_Full_Time        => r_Second_Day.Full_Time,
                                           i_Plan_Time        => r_Second_Day.Plan_Time,
                                           i_Shift_Begin_Time => r_Second_Day.Shift_Begin_Time,
                                           i_Shift_End_Time   => r_Second_Day.Shift_End_Time,
                                           i_Input_Border     => r_Second_Day.Input_Border,
                                           i_Output_Border    => r_Second_Day.Output_Border);
            
              delete Htt_Schedule_Day_Marks Dm
               where Dm.Company_Id = i_Company_Id
                 and Dm.Filial_Id = i_Filial_Id
                 and Dm.Schedule_Id = i_Schedule_Id
                 and Dm.Schedule_Date = r_Second_Day.Schedule_Date;
            
              Gen_Schedule_Day_Extras(i_Company_Id    => i_Company_Id,
                                      i_Filial_Id     => i_Filial_Id,
                                      i_Schedule_Id   => i_Schedule_Id,
                                      i_Schedule_Date => r_Second_Day.Schedule_Date,
                                      i_Source_Date   => case
                                                           when v_Swappable then
                                                            r_Origin_Day.Schedule_Date
                                                           else
                                                            r_Second_Day.Schedule_Date
                                                         end,
                                      i_Schedule_Day  => r_Second_Day);
            
              o_Swapped_Date := r_Second_Day.Schedule_Date;
            else
              if i_Take_Holidays = 'Y' and r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Holiday or
                 i_Take_Additional_Rest_Day = 'Y' and
                 r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
                r_Origin_Day.Begin_Time       := null;
                r_Origin_Day.End_Time         := null;
                r_Origin_Day.Break_Enabled    := null;
                r_Origin_Day.Break_Begin_Time := null;
                r_Origin_Day.Break_End_Time   := null;
                r_Origin_Day.Full_Time        := 0;
                r_Origin_Day.Plan_Time        := 0;
              end if;
            end if;
          end if;
        
          if i_Take_Holidays = 'Y' and r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Holiday or
             i_Take_Nonworking = 'Y' and r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking or
             i_Take_Additional_Rest_Day = 'Y' and
             r_Calendar_Day.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
            r_Origin_Day.Day_Kind := r_Calendar_Day.Day_Kind;
          end if;
        end if;
      end if;
    
      z_Htt_Schedule_Days.Save_One(i_Company_Id       => i_Company_Id,
                                   i_Filial_Id        => i_Filial_Id,
                                   i_Schedule_Id      => i_Schedule_Id,
                                   i_Schedule_Date    => i_Schedule_Date,
                                   i_Day_Kind         => r_Origin_Day.Day_Kind,
                                   i_Begin_Time       => r_Origin_Day.Begin_Time,
                                   i_End_Time         => r_Origin_Day.End_Time,
                                   i_Break_Enabled    => r_Origin_Day.Break_Enabled,
                                   i_Break_Begin_Time => r_Origin_Day.Break_Begin_Time,
                                   i_Break_End_Time   => r_Origin_Day.Break_End_Time,
                                   i_Full_Time        => r_Origin_Day.Full_Time,
                                   i_Plan_Time        => r_Origin_Day.Plan_Time,
                                   i_Shift_Begin_Time => r_Origin_Day.Shift_Begin_Time,
                                   i_Shift_End_Time   => r_Origin_Day.Shift_End_Time,
                                   i_Input_Border     => r_Origin_Day.Input_Border,
                                   i_Output_Border    => r_Origin_Day.Output_Border);
    
      Gen_Schedule_Day_Extras(i_Company_Id    => i_Company_Id,
                              i_Filial_Id     => i_Filial_Id,
                              i_Schedule_Id   => i_Schedule_Id,
                              i_Schedule_Date => r_Origin_Day.Schedule_Date,
                              i_Source_Date   => case
                                                   when v_Swappable then
                                                    r_Second_Day.Schedule_Date
                                                   else
                                                    r_Origin_Day.Schedule_Date
                                                 end,
                              i_Schedule_Day  => r_Origin_Day);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- generates schedule days
  -- dates of swapped days are added to p_dates
  ----------------------------------------------------------------------------------------------------  
  Procedure Gen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    p_Dates       in out nocopy Array_Date
  ) is
    v_Swapped_Date  date;
    v_Swapped_Dates Array_Date := Array_Date();
    r_Schedule      Htt_Schedules%rowtype;
  
    v_Swapped_Dates_At Fazo.Date_Code_Aat;
  
    -------------------------------------------------- 
    Function Date_Swapped(i_Date date) return boolean is
    begin
      if v_Swapped_Dates_At.Exists(to_char(i_Date)) then
        return true;
      end if;
    
      return false;
    end;
  
  begin
    r_Schedule := z_Htt_Schedules.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Schedule_Id => i_Schedule_Id);
  
    delete Htt_Schedule_Day_Marks Dm
     where Dm.Company_Id = i_Company_Id
       and Dm.Filial_Id = i_Filial_Id
       and Dm.Schedule_Id = i_Schedule_Id
       and Dm.Schedule_Date member of p_Dates;
  
    delete Htt_Schedule_Day_Weights Dw
     where Dw.Company_Id = i_Company_Id
       and Dw.Filial_Id = i_Filial_Id
       and Dw.Schedule_Id = i_Schedule_Id
       and Dw.Schedule_Date member of p_Dates;
  
    for i in 1 .. p_Dates.Count
    loop
      continue when Date_Swapped(p_Dates(i));
    
      Gen_Schedule_Day(i_Company_Id               => i_Company_Id,
                       i_Filial_Id                => i_Filial_Id,
                       i_Schedule_Id              => i_Schedule_Id,
                       i_Schedule_Date            => p_Dates(i),
                       i_Calendar_Id              => r_Schedule.Calendar_Id,
                       i_Take_Holidays            => r_Schedule.Take_Holidays,
                       i_Take_Nonworking          => r_Schedule.Take_Nonworking,
                       i_Take_Additional_Rest_Day => r_Schedule.Take_Additional_Rest_Days,
                       o_Swapped_Date             => v_Swapped_Date);
    
      if v_Swapped_Date is not null then
        v_Swapped_Dates_At(v_Swapped_Date) := p_Dates(i);
        v_Swapped_Dates_At(p_Dates(i)) := v_Swapped_Date;
      
        Fazo.Push(v_Swapped_Dates, v_Swapped_Date);
      end if;
    end loop;
  
    p_Dates := p_Dates multiset union v_Swapped_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  -- generates schedule days and timesheets for them
  -- if new days are being added to schedule
  -- uses separate algorithm for timesheet generation
  Procedure Regen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Year        number,
    i_Dates       Array_Date
  ) is
    v_Year_Existed varchar2(1);
    v_Dates        Array_Date := i_Dates;
  begin
    begin
      select 'Y'
        into v_Year_Existed
        from Htt_Schedule_Days d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Schedule_Id = i_Schedule_Id
         and Extract(year from d.Schedule_Date) = i_Year
         and Rownum = 1;
    
    exception
      when No_Data_Found then
        v_Year_Existed := 'N';
    end;
  
    Gen_Schedule_Days(i_Company_Id  => i_Company_Id,
                      i_Filial_Id   => i_Filial_Id,
                      i_Schedule_Id => i_Schedule_Id,
                      p_Dates       => v_Dates);
  
    v_Dates := set(v_Dates);
  
    if Md_Pref.c_Migr_Company_Id != i_Company_Id then
      if v_Year_Existed = 'N' then
        Gen_Timesheet_Plan(i_Company_Id  => i_Company_Id,
                           i_Filial_Id   => i_Filial_Id,
                           i_Schedule_Id => i_Schedule_Id,
                           i_Year        => i_Year);
      else
        Regen_Timesheet_Plan(i_Company_Id  => i_Company_Id,
                             i_Filial_Id   => i_Filial_Id,
                             i_Schedule_Id => i_Schedule_Id,
                             i_Dates       => v_Dates);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- generates schedule days and timesheets for them
  -- for every schedule that is cnnected to this calendar
  Procedure Regen_Schedule_Days
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number,
    i_Dates       Array_Date
  ) is
    v_Dates Array_Date;
  begin
    for r in (select s.Schedule_Id
                from Htt_Schedules s
               where s.Company_Id = i_Company_Id
                 and s.Filial_Id = i_Filial_Id
                 and s.Calendar_Id = i_Calendar_Id)
    loop
      v_Dates := i_Dates;
    
      Gen_Schedule_Days(i_Company_Id  => i_Company_Id,
                        i_Filial_Id   => i_Filial_Id,
                        i_Schedule_Id => r.Schedule_Id,
                        p_Dates       => v_Dates);
    
      Regen_Timesheet_Plan(i_Company_Id  => i_Company_Id,
                           i_Filial_Id   => i_Filial_Id,
                           i_Schedule_Id => r.Schedule_Id,
                           i_Dates       => v_Dates);
    end loop;
  
    for r in (select *
                from Htt_Schedule_Registries q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Calendar_Id = i_Calendar_Id)
    loop
      null;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Find_Request_Timesheets
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Request_Begin date,
    i_Request_End   date
  ) return Array_Number is
    v_Interval_Date date := Trunc(i_Request_Begin);
    result          Array_Number;
  begin
    select q.Timesheet_Id
      bulk collect
      into result
      from Htt_Timesheet_Helpers q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Interval_Date = v_Interval_Date
       and (i_Request_Begin >= q.Shift_Begin_Time and i_Request_Begin < q.Shift_End_Time or
           i_Request_End >= q.Shift_Begin_Time and i_Request_End < q.Shift_End_Time);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Find_Track_Timesheets
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Track_Datetime date
  ) return Array_Number is
    v_Interval_Date date := Trunc(i_Track_Datetime);
    result          Array_Number;
  begin
    select q.Timesheet_Id
      bulk collect
      into result
      from Htt_Timesheet_Helpers q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Interval_Date = v_Interval_Date
       and i_Track_Datetime >= q.Input_Border
       and i_Track_Datetime < q.Output_Border;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Timesheet
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Htt_Dirty_Timesheets q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Timesheet_Id = i_Timesheet_Id;
  exception
    when No_Data_Found then
      insert into Htt_Dirty_Timesheets
        (Company_Id, Filial_Id, Timesheet_Id, Locked)
        select i_Company_Id,
               i_Filial_Id,
               i_Timesheet_Id,
               Nvl((select 'Y'
                     from Htt_Timesheet_Locks Tl
                    where Tl.Company_Id = t.Company_Id
                      and Tl.Filial_Id = t.Filial_Id
                      and Tl.Staff_Id = t.Staff_Id
                      and Tl.Timesheet_Date = t.Timesheet_Date),
                   'N')
          from Htt_Timesheets t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Timesheet_Id = i_Timesheet_Id;
    
      b.Add_Post_Callback('begin htt_core.revised_timesheets; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Timesheets
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    insert into Htt_Dirty_Timesheets Dt
      (Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id, Dt.Locked)
      select t.Company_Id,
             t.Filial_Id,
             t.Timesheet_Id,
             Nvl((select 'Y'
                   from Htt_Timesheet_Locks Tl
                  where Tl.Company_Id = t.Company_Id
                    and Tl.Filial_Id = t.Filial_Id
                    and Tl.Staff_Id = t.Staff_Id
                    and Tl.Timesheet_Date = t.Timesheet_Date),
                 'N')
        from Htt_Timesheets t
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date
         and not exists (select *
                from Htt_Dirty_Timesheets p
               where p.Company_Id = t.Company_Id
                 and p.Filial_Id = t.Filial_Id
                 and p.Timesheet_Id = t.Timesheet_Id);
  
    b.Add_Post_Callback('begin htt_core.revised_timesheets; end;');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Make_Dirty_Timesheets
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Dates        Array_Date,
    i_Add_Callback boolean := true
  ) is
  begin
    insert into Htt_Dirty_Timesheets Dt
      (Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id, Dt.Locked)
      (select t.Company_Id,
              t.Filial_Id,
              t.Timesheet_Id,
              Nvl((select 'Y'
                    from Htt_Timesheet_Locks Tl
                   where Tl.Company_Id = t.Company_Id
                     and Tl.Filial_Id = t.Filial_Id
                     and Tl.Staff_Id = t.Staff_Id
                     and Tl.Timesheet_Date = t.Timesheet_Date),
                  'N')
         from Htt_Timesheets t
        where t.Company_Id = i_Company_Id
          and t.Filial_Id = i_Filial_Id
          and t.Staff_Id = i_Staff_Id
          and t.Timesheet_Date member of i_Dates
          and not exists (select *
                 from Htt_Dirty_Timesheets p
                where p.Company_Id = t.Company_Id
                  and p.Filial_Id = t.Filial_Id
                  and p.Timesheet_Id = t.Timesheet_Id));
  
    if i_Add_Callback then
      b.Add_Post_Callback('begin htt_core.revised_timesheets; end;');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Potential_Outputs(i_Company_Id number) is
    v_User_System number := Md_Pref.User_System(i_Company_Id);
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
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
                      i_Project_Code => Verifix.Project_Code);
    
      for Po in (select Tt.Company_Id, Tt.Filial_Id, Tt.Timesheet_Id
                   from Htt_Timesheet_Tracks Tt
                  where Tt.Company_Id = r.Company_Id
                    and Tt.Filial_Id = r.Filial_Id
                    and Tt.Track_Type in
                        (Htt_Pref.c_Track_Type_Potential_Output, Htt_Pref.c_Track_Type_Gps_Output)
                  group by Tt.Company_Id, Tt.Filial_Id, Tt.Timesheet_Id)
      loop
        Make_Dirty_Timesheet(i_Company_Id   => Po.Company_Id,
                             i_Filial_Id    => Po.Filial_Id,
                             i_Timesheet_Id => Po.Timesheet_Id);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Potential_Outputs is
  begin
    for Cmp in (select c.Company_Id
                  from Md_Companies c
                 where c.State = 'A'
                   and (exists (select 1
                                  from Md_Company_Projects Cp
                                 where Cp.Company_Id = c.Company_Id
                                   and Cp.Project_Code = Verifix.Project_Code) or
                        c.Company_Id = Md_Pref.c_Company_Head))
    loop
      begin
        Transform_Potential_Outputs(Cmp.Company_Id);
      
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;
  
    Dbms_Mview.Refresh('Htt_Employee_Monthly_Attendances_Mv', --
                       Atomic_Refresh => true);
  end;

  ----------------------------------------------------------------------------------------------------
  -- adds i_begin_date - 1 and i_end_date + 1 to dirty timesheets
  -- sets shift begin/end values to null if its shift is flexible and not locked
  -- %warning
  -- timesheets at i_begin_date - 1 and i_end_date + 1 should be removed from dirty timesheets before any fact generation
  Procedure Update_Border_Timesheet_Shifts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Add_Callback boolean := true
  ) is
  begin
    update Htt_Timesheets q
       set q.Shift_Begin_Time = Decode(q.Timesheet_Date, i_Begin_Date - 1, q.Shift_Begin_Time, null),
           q.Input_Border     = Decode(q.Timesheet_Date, i_Begin_Date - 1, q.Input_Border, null),
           q.Shift_End_Time   = Decode(q.Timesheet_Date, i_End_Date + 1, q.Shift_End_Time, null),
           q.Output_Border    = Decode(q.Timesheet_Date, i_End_Date + 1, q.Output_Border, null)
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Timesheet_Date in (i_Begin_Date - 1, i_End_Date + 1)
       and not exists (select 1
              from Htt_Timesheet_Locks Tl
             where Tl.Company_Id = q.Company_Id
               and Tl.Filial_Id = q.Filial_Id
               and Tl.Staff_Id = q.Staff_Id
               and Tl.Timesheet_Date = q.Timesheet_Date)
       and q.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible;
  
    Make_Dirty_Timesheets(i_Company_Id   => i_Company_Id,
                          i_Filial_Id    => i_Filial_Id,
                          i_Staff_Id     => i_Staff_Id,
                          i_Dates        => Array_Date(i_Begin_Date - 1, i_End_Date + 1),
                          i_Add_Callback => i_Add_Callback);
  end;

  ----------------------------------------------------------------------------------------------------
  -- updates shift begin/end and input/output borders for dirty timesheets with flexible shift 
  -- shift is determined as flexible if it is null at current moment
  -- deletes locked timesheets from dirty timesheets after updating shifts

  -- %raises Htt_Error.Raise_107 when end_time and begin_time for consecutive days intersect

  -- shift is calculated as middle between end_time and begin_time of consecutive days
  -- shift for work day is calculated as (24 - full_plan)/2 from begin/end_time if previous/next day is rest day
  -- shift for rest day is set to the shift of its neighbour
  -- shift between two rest days is set to the start/end of day
  -- input border is set to min(shift, merger)
  -- output border is set to max(shift, merger)
  -- merger appears when difference between end_time and begin_time of consecutive days is less than 30 minutes
  -- merger is set to shift +/- 15 minutes 

  -- flexible schedule guarantees that shift borders will not intersect between timesheets

  -- %example 1
  -- let end_time   := 01.01.2023 18:00;
  -- let next_begin := 02.01.2023 09:00;
  -- then shift_begin_time := 01.01.2023 18:00 + (02.01.2023 09:00 - 01.01.2023 18:00) / 2;
  -- meaning shift_begin_time := 01.01.2023 18:00 + 7.5 hours := 02.01.2023 01:30;

  -- %example 2
  -- let begin_time := 01.01.2023 09:00;
  -- let end_time   := 01.01.2023 18:00;
  -- let next day to be rest day
  -- then shift_end_time := 01.01.2023 18:00 + (24 - (01.01.2023 18:00 - 01.01.2023 09:00)) / 2;
  -- meaning shift_end_time := 01.01.2023 18:00 + 7.5 hours := 02.01.2023 01:30;

  -- not necessarily shift borders will fall at same hours every day
  -- this is easily seen in shifts with day/schedule

  -- %example 3
  -- let prev_end   := 31.12.2022 09:00;
  -- let begin_time := 01.01.2023 09:00;
  -- let end_time   := 01.01.2023 18:00;
  -- let next_begin := 02.01.2023 18:00;
  -- then
  -- shift_end_time := 01.01.2023 18:00 + (02.01.2023 18:00 - 01.01.2023 18:00) / 2;
  -- shift_end_time := 01.01.2023 18:00 + 12 hours := 02.01.2023 06:00;
  -- and 
  -- shift_begin_time := 01.01.2023 09:00 - (01.01.2023 09:00 - 31.12.2022 09:00) / 2;
  -- shift_begin_time := 01.01.2023 09:00 - 12 hours := 31.01.2023 21:00;
  Procedure Adjust_Flexible_Shifts is
    --------------------------------------------------
    Procedure Assert_Nonintersecting_Work_Time is
      v_Company_Id     number;
      v_Filial_Id      number;
      v_Staff_Id       number;
      v_Timesheet_Date date;
      v_Begin_Time     date;
      v_End_Time       date;
    begin
      with Timesheets as
       (select Tt.Company_Id,
               Tt.Filial_Id,
               Tt.Staff_Id,
               Tt.Timesheet_Date,
               Tt.Begin_Time,
               Tt.End_Time,
               Tt.Shift_Begin_Time,
               Tt.Shift_End_Time
          from Htt_Timesheets Tt
         where (Tt.Company_Id, Tt.Filial_Id, Tt.Timesheet_Id) in
               (select Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id
                  from Htt_Dirty_Timesheets Dt))
      select p.Company_Id,
             p.Filial_Id,
             p.Staff_Id,
             p.Timesheet_Date,
             p.Begin_Time,
             (select q.End_Time
                from Timesheets q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Staff_Id = p.Staff_Id
                 and q.Timesheet_Date = p.Timesheet_Date - 1)
        into v_Company_Id, v_Filial_Id, v_Staff_Id, v_Timesheet_Date, v_Begin_Time, v_End_Time
        from Timesheets p
       where exists (select 1
                from Timesheets q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Staff_Id = p.Staff_Id
                 and q.Timesheet_Date = p.Timesheet_Date - 1
                 and q.End_Time > p.Begin_Time)
         and Rownum = 1;
    
      Htt_Error.Raise_107(i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                                                   i_Filial_Id  => v_Filial_Id,
                                                                   i_Staff_Id   => v_Staff_Id),
                          i_Timesheet_Date => v_Timesheet_Date,
                          i_Begin_Time     => v_Begin_Time,
                          i_End_Time       => v_End_Time);
    exception
      when No_Data_Found then
        null;
    end;
  begin
    Assert_Nonintersecting_Work_Time;
  
    update Htt_Timesheets Tt
       set (Tt.Shift_Begin_Time, Tt.Shift_End_Time, Tt.Input_Border, Tt.Output_Border) =
           (select Nvl(Tt.Shift_Begin_Time,
                       Coalesce(Decode(Upd.Day_Kind,
                                       Htt_Pref.c_Day_Kind_Work,
                                       Upd.Work_Work_Shift_Begin,
                                       Htt_Pref.c_Day_Kind_Nonworking,
                                       Upd.Work_Work_Shift_Begin,
                                       Upd.Rest_Work_Shift_Begin),
                                Upd.Work_Rest_Shift_Begin,
                                Upd.Timesheet_Date)),
                   Nvl(Tt.Shift_End_Time,
                       Coalesce(Decode(Upd.Day_Kind,
                                       Htt_Pref.c_Day_Kind_Work,
                                       Upd.Work_Work_Shift_End,
                                       Htt_Pref.c_Day_Kind_Nonworking,
                                       Upd.Work_Work_Shift_End,
                                       Upd.Rest_Work_Shift_End),
                                Upd.Work_Rest_Shift_End,
                                Upd.Timesheet_Date + 1)),
                   Nvl(Tt.Input_Border,
                       Coalesce(Decode(Upd.Day_Kind,
                                       Htt_Pref.c_Day_Kind_Work,
                                       Upd.Work_Work_Shift_Begin -
                                       Upd.Input_Merger_Coef *
                                       Numtodsinterval(Htt_Pref.c_Default_Merge_Border, 'second'),
                                       Htt_Pref.c_Day_Kind_Nonworking,
                                       Upd.Work_Work_Shift_Begin -
                                       Upd.Input_Merger_Coef *
                                       Numtodsinterval(Htt_Pref.c_Default_Merge_Border, 'second'),
                                       Upd.Rest_Work_Shift_Begin),
                                Upd.Work_Rest_Shift_Begin,
                                Upd.Timesheet_Date)),
                   Nvl(Tt.Output_Border,
                       Coalesce(Decode(Upd.Day_Kind,
                                       Htt_Pref.c_Day_Kind_Work,
                                       Upd.Work_Work_Shift_End +
                                       Upd.Output_Merger_Coef *
                                       Numtodsinterval(Htt_Pref.c_Default_Merge_Border, 'second'),
                                       Htt_Pref.c_Day_Kind_Nonworking,
                                       Upd.Work_Work_Shift_End +
                                       Upd.Output_Merger_Coef *
                                       Numtodsinterval(Htt_Pref.c_Default_Merge_Border, 'second'),
                                       Upd.Rest_Work_Shift_End),
                                Upd.Work_Rest_Shift_End,
                                Upd.Timesheet_Date + 1))
              from (select Qr.Timesheet_Date,
                           Qr.Day_Kind,
                           -- if next_begin - end_time is less or equal than 2 * Htt_Pref.c_Default_Merge_Border
                           -- then coef = 1
                           -- else coef = 0
                           Decode(Sign(2 * Htt_Pref.c_Default_Merge_Border -
                                       (Qr.Next_Begin - Qr.End_Time) * 24 * 3600),
                                  -1,
                                  0,
                                  1) Output_Merger_Coef,
                           -- if begin_time - prev_time is less or equal than 2 * Htt_Pref.c_Default_Merge_Border
                           -- then coef = 1
                           -- else coef = 0
                           Decode(Sign(2 * Htt_Pref.c_Default_Merge_Border -
                                       (Qr.Begin_Time - Qr.Prev_End) * 24 * 3600),
                                  -1,
                                  0,
                                  1) Input_Merger_Coef,
                           Qr.Begin_Time - (Qr.Begin_Time - Qr.Prev_End) / 2 Work_Work_Shift_Begin,
                           Qr.End_Time + (Qr.Next_Begin - Qr.End_Time) / 2 Work_Work_Shift_End,
                           -- current day rest, previous day work
                           Qr.Prev_End +
                           Numtodsinterval(Least(Greatest((Htt_Pref.c_Max_Full_Plan - Qr.Prev_Plan) / 2,
                                                          Htt_Pref.c_Min_Shift_Border),
                                                 Htt_Pref.c_Max_Shift_Border),
                                           'second') Rest_Work_Shift_Begin,
                           -- current day rest, next day work
                           Qr.Next_Begin -
                           Numtodsinterval(Least(Greatest((Htt_Pref.c_Max_Full_Plan - Qr.Next_Plan) / 2,
                                                          Htt_Pref.c_Min_Shift_Border),
                                                 Htt_Pref.c_Max_Shift_Border),
                                           'second') Rest_Work_Shift_End,
                           -- current day work, previous day rest
                           Qr.Begin_Time -
                           Numtodsinterval(Least(Greatest((Htt_Pref.c_Max_Full_Plan - Qr.Full_Time) / 2,
                                                          Htt_Pref.c_Min_Shift_Border),
                                                 Htt_Pref.c_Max_Shift_Border),
                                           'second') Work_Rest_Shift_Begin,
                           -- current day work, next day rest
                           Qr.End_Time +
                           Numtodsinterval(Least(Greatest((Htt_Pref.c_Max_Full_Plan - Qr.Full_Time) / 2,
                                                          Htt_Pref.c_Min_Shift_Border),
                                                 Htt_Pref.c_Max_Shift_Border),
                                           'second') Work_Rest_Shift_End
                      from (select Cr.Company_Id,
                                   Cr.Filial_Id,
                                   Cr.Timesheet_Id,
                                   Cr.Timesheet_Date,
                                   Cr.Day_Kind,
                                   Cr.Begin_Time,
                                   Cr.End_Time,
                                   (Cr.End_Time - Cr.Begin_Time) * 24 * 3600 Full_Time,
                                   Cr.Shift_Begin_Time,
                                   Cr.Shift_End_Time,
                                   Cr.Input_Border,
                                   Cr.Output_Border,
                                   Pv.End_Time Prev_End,
                                   (Pv.End_Time - Pv.Begin_Time) * 24 * 3600 Prev_Plan,
                                   Nx.Begin_Time Next_Begin,
                                   (Nx.End_Time - Nx.Begin_Time) * 24 * 3600 Next_Plan
                              from Htt_Timesheets Cr
                              left join Htt_Timesheets Pv
                                on Pv.Company_Id = Cr.Company_Id
                               and Pv.Filial_Id = Cr.Filial_Id
                               and Pv.Staff_Id = Cr.Staff_Id
                               and Pv.Timesheet_Date = Cr.Timesheet_Date - 1
                              left join Htt_Timesheets Nx
                                on Nx.Company_Id = Cr.Company_Id
                               and Nx.Filial_Id = Cr.Filial_Id
                               and Nx.Staff_Id = Cr.Staff_Id
                               and Nx.Timesheet_Date = Cr.Timesheet_Date + 1
                             where (Cr.Company_Id, Cr.Filial_Id, Cr.Timesheet_Id) in
                                   (select Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id
                                      from Htt_Dirty_Timesheets Dt)) Qr
                     where Qr.Company_Id = Tt.Company_Id
                       and Qr.Filial_Id = Tt.Filial_Id
                       and Qr.Timesheet_Id = Tt.Timesheet_Id) Upd)
     where (Tt.Company_Id, Tt.Filial_Id, Tt.Timesheet_Id) in
           (select Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id
              from Htt_Dirty_Timesheets Dt
             where Dt.Locked = 'N')
       and Tt.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible
       and (Tt.Shift_Begin_Time is null or Tt.Shift_End_Time is null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Helpers_Save is
  begin
    delete Htt_Timesheet_Helpers q
     where exists (select 1
              from Htt_Dirty_Timesheets Dt
             where Dt.Company_Id = q.Company_Id
               and Dt.Filial_Id = q.Filial_Id
               and Dt.Timesheet_Id = q.Timesheet_Id);
  
    -- see: https://community.oracle.com/tech/developers/discussion/2526535/reg-sys-guid
    insert into Htt_Timesheet_Helpers Th
      (Th.Company_Id,
       Th.Filial_Id,
       Th.Staff_Id,
       Th.Interval_Date,
       Th.Timesheet_Id,
       Th.Day_Kind,
       Th.Shift_Begin_Time,
       Th.Shift_End_Time,
       Th.Input_Border,
       Th.Output_Border)
      select Qr.Company_Id,
             Qr.Filial_Id,
             Staff_Id,
             Trunc(Qr.Input_Border) + level - 1 Interval_Date,
             Qr.Timesheet_Id,
             Qr.Day_Kind,
             Qr.Shift_Begin_Time,
             Qr.Shift_End_Time,
             Qr.Input_Border,
             Qr.Output_Border
        from (select Tt.*
                from Htt_Timesheets Tt
               where (Tt.Company_Id, Tt.Filial_Id, Tt.Timesheet_Id) in
                     (select Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id
                        from Htt_Dirty_Timesheets Dt)) Qr
      connect by level <= Trunc(Qr.Output_Border) - Trunc(Qr.Input_Border) + 1
             and Qr.Timesheet_Id = prior Qr.Timesheet_Id
             and prior Sys_Guid() is not null
             and Trunc(Qr.Input_Border) + level - 1 < Qr.Output_Border;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Timesheet_Plans is
    r_Timesheet     Htt_Timesheets%rowtype;
    r_Swapped_Date  Htt_Change_Days%rowtype;
    v_Swap_Distance number := 0;
    v_Weights_Sum   number;
    v_Weights       Htt_Pref.Interval_Weight_Nt;
  
    --------------------------------------------------
    Procedure Push_Weights
    (
      p_Weights          in out nocopy Htt_Pref.Interval_Weight_Nt,
      p_Weights_Sum      in out number,
      i_Interval_Begin   date,
      i_Interval_End     date,
      i_Weight           number,
      i_Break_Enabled    varchar2,
      i_Break_Begin_Time date,
      i_Break_End_Time   date
    ) is
      v_Weight Htt_Pref.Interval_Weight_Rt;
    begin
      v_Weight.Begin_Time := i_Interval_Begin;
      v_Weight.End_Time   := i_Interval_End;
      v_Weight.Weight     := i_Weight;
    
      if i_Break_Enabled = 'Y' and v_Weight.Begin_Time < i_Break_Begin_Time and
         v_Weight.End_Time > i_Break_End_Time then
      
        v_Weight.End_Time := i_Break_Begin_Time;
      
        p_Weights.Extend;
        p_Weights(p_Weights.Count) := v_Weight;
      
        p_Weights_Sum := p_Weights_Sum +
                         v_Weight.Weight *
                         Htt_Util.Time_Diff(i_Time1 => v_Weight.End_Time,
                                            i_Time2 => v_Weight.Begin_Time);
      
        v_Weight.Begin_Time := i_Break_End_Time;
        v_Weight.End_Time   := i_Interval_End;
      elsif i_Break_Begin_Time <= v_Weight.Begin_Time and i_Break_End_Time >= v_Weight.End_Time then
        return;
      elsif i_Break_Enabled = 'Y' then
        if i_Break_Begin_Time between v_Weight.Begin_Time and v_Weight.End_Time then
          v_Weight.End_Time := i_Break_Begin_Time;
        end if;
      
        if i_Break_End_Time between v_Weight.Begin_Time and v_Weight.End_Time then
          v_Weight.Begin_Time := i_Break_End_Time;
        end if;
      end if;
    
      if v_Weight.Begin_Time < v_Weight.End_Time then
        p_Weights.Extend;
        p_Weights(p_Weights.Count) := v_Weight;
      
        p_Weights_Sum := p_Weights_Sum +
                         v_Weight.Weight *
                         Htt_Util.Time_Diff(i_Time1 => v_Weight.End_Time,
                                            i_Time2 => v_Weight.Begin_Time);
      end if;
    end;
  begin
    for r in (select d.*,
                     t.Timesheet_Id,
                     t.Schedule_Id,
                     (select count(*)
                        from Htt_Schedule_Day_Marks Dm
                       where Dm.Company_Id = t.Company_Id
                         and Dm.Filial_Id = t.Filial_Id
                         and Dm.Schedule_Id = t.Schedule_Id
                         and Dm.Schedule_Date = Nvl(d.Swapped_Date, d.Change_Date)) Planned_Marks,
                     t.Schedule_Kind
                from Htt_Change_Days d
                join Htt_Timesheets t
                  on d.Company_Id = t.Company_Id
                 and d.Filial_Id = t.Filial_Id
                 and d.Staff_Id = t.Staff_Id
                 and d.Change_Date = t.Timesheet_Date
               where exists (select *
                        from Htt_Dirty_Timesheets Dt
                       where t.Company_Id = Dt.Company_Id
                         and t.Filial_Id = Dt.Filial_Id
                         and t.Timesheet_Id = Dt.Timesheet_Id)
                 and exists (select *
                        from Htt_Plan_Changes Pc
                       where Pc.Company_Id = d.Company_Id
                         and Pc.Filial_Id = d.Filial_Id
                         and Pc.Change_Id = d.Change_Id
                         and Pc.Status = Htt_Pref.c_Change_Status_Completed))
    loop
      if r.Day_Kind is null then
        r_Swapped_Date := z_Htt_Change_Days.Load(i_Company_Id  => r.Company_Id,
                                                 i_Filial_Id   => r.Filial_Id,
                                                 i_Staff_Id    => r.Staff_Id,
                                                 i_Change_Date => r.Swapped_Date,
                                                 i_Change_Id   => r.Change_Id);
      
        v_Swap_Distance := r.Change_Date - r.Swapped_Date;
      
        r.Day_Kind         := r_Swapped_Date.Day_Kind;
        r.Begin_Time       := r_Swapped_Date.Begin_Time + v_Swap_Distance;
        r.End_Time         := r_Swapped_Date.End_Time + v_Swap_Distance;
        r.Break_Enabled    := r_Swapped_Date.Break_Enabled;
        r.Break_Begin_Time := r_Swapped_Date.Break_Begin_Time + v_Swap_Distance;
        r.Break_End_Time   := r_Swapped_Date.Break_End_Time + v_Swap_Distance;
        r.Plan_Time        := r_Swapped_Date.Plan_Time;
        r.Full_Time        := r_Swapped_Date.Full_Time;
      end if;
    
      z_Htt_Timesheets.Update_One(i_Company_Id       => r.Company_Id,
                                  i_Filial_Id        => r.Filial_Id,
                                  i_Timesheet_Id     => r.Timesheet_Id,
                                  i_Day_Kind         => Option_Varchar2(r.Day_Kind),
                                  i_Begin_Time       => Option_Date(r.Begin_Time),
                                  i_End_Time         => Option_Date(r.End_Time),
                                  i_Break_Enabled    => Option_Varchar2(r.Break_Enabled),
                                  i_Break_Begin_Time => Option_Date(r.Break_Begin_Time),
                                  i_Break_End_Time   => Option_Date(r.Break_End_Time),
                                  i_Plan_Time        => Option_Number(r.Plan_Time),
                                  i_Full_Time        => Option_Number(r.Full_Time),
                                  i_Planned_Marks    => Option_Number(r.Planned_Marks),
                                  i_Done_Marks       => Option_Number(0),
                                  i_Shift_Begin_Time => case
                                                          when r.Schedule_Kind =
                                                               Htt_Pref.c_Schedule_Kind_Flexible then
                                                           Option_Date(null)
                                                          else
                                                           null
                                                        end,
                                  i_Shift_End_Time   => case
                                                          when r.Schedule_Kind =
                                                               Htt_Pref.c_Schedule_Kind_Flexible then
                                                           Option_Date(null)
                                                          else
                                                           null
                                                        end,
                                  i_Input_Border     => case
                                                          when r.Schedule_Kind =
                                                               Htt_Pref.c_Schedule_Kind_Flexible then
                                                           Option_Date(null)
                                                          else
                                                           null
                                                        end,
                                  i_Output_Border    => case
                                                          when r.Schedule_Kind =
                                                               Htt_Pref.c_Schedule_Kind_Flexible then
                                                           Option_Date(null)
                                                          else
                                                           null
                                                        end);
    
      delete Htt_Timesheet_Marks q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Timesheet_Id = r.Timesheet_Id;
    
      delete Htt_Timesheet_Weights q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Timesheet_Id = r.Timesheet_Id;
    
      if r.Swapped_Date is not null then
        r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => r.Company_Id,
                                          i_Filial_Id      => r.Filial_Id,
                                          i_Staff_Id       => r.Staff_Id,
                                          i_Timesheet_Date => r.Swapped_Date);
      
        r.Schedule_Id := Nvl(r_Timesheet.Schedule_Id, r.Schedule_Id);
      
        v_Swap_Distance := r.Change_Date - r.Swapped_Date;
      end if;
    
      if Is_Individual_Staff_Schedule(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Schedule_Id => r.Schedule_Id) then
        insert into Htt_Timesheet_Marks Tm
          (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
          select Dm.Company_Id, --
                 Dm.Filial_Id,
                 r.Timesheet_Id,
                 Dm.Begin_Time + v_Swap_Distance,
                 Dm.End_Time + v_Swap_Distance,
                 'N'
            from Htt_Staff_Schedule_Day_Marks Dm
           where Dm.Company_Id = r.Company_Id
             and Dm.Filial_Id = r.Filial_Id
             and Dm.Staff_Id = r.Staff_Id
             and Dm.Schedule_Date = Nvl(r.Swapped_Date, r.Change_Date);
      
        select count(*)
          into r.Planned_Marks
          from Htt_Staff_Schedule_Day_Marks Sd
         where Sd.Company_Id = r.Company_Id
           and Sd.Filial_Id = r.Filial_Id
           and Sd.Staff_Id = r.Staff_Id
           and Sd.Schedule_Date = Nvl(r.Swapped_Date, r.Change_Date);
      
        z_Htt_Timesheets.Update_One(i_Company_Id    => r.Company_Id,
                                    i_Filial_Id     => r.Filial_Id,
                                    i_Timesheet_Id  => r.Timesheet_Id,
                                    i_Planned_Marks => Option_Number(r.Planned_Marks));
      else
        insert into Htt_Timesheet_Marks Tm
          (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
          select Dm.Company_Id, --
                 Dm.Filial_Id,
                 r.Timesheet_Id,
                 Dm.Begin_Time + v_Swap_Distance,
                 Dm.End_Time + v_Swap_Distance,
                 'N'
            from Htt_Schedule_Day_Marks Dm
           where Dm.Company_Id = r.Company_Id
             and Dm.Filial_Id = r.Filial_Id
             and Dm.Schedule_Id = r.Schedule_Id
             and Dm.Schedule_Date = Nvl(r.Swapped_Date, r.Change_Date);
      end if;
    
      if r.Swapped_Date is not null then
        insert into Htt_Timesheet_Weights
          (Company_Id, Filial_Id, Timesheet_Id, Begin_Time, End_Time, Weight, Coef)
          select Dm.Company_Id, --
                 Dm.Filial_Id,
                 r.Timesheet_Id,
                 Dm.Begin_Time + v_Swap_Distance,
                 Dm.End_Time + v_Swap_Distance,
                 Dm.Weight,
                 Dm.Coef
            from Htt_Schedule_Day_Weights Dm
           where Dm.Company_Id = r.Company_Id
             and Dm.Filial_Id = r.Filial_Id
             and Dm.Schedule_Id = r.Schedule_Id
             and Dm.Schedule_Date = Nvl(r.Swapped_Date, r.Change_Date);
      elsif r.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) then
      
        v_Weights_Sum := 0;
        v_Weights     := Htt_Pref.Interval_Weight_Nt();
      
        for Wt in (select r.Change_Date + Numtodsinterval(w.Begin_Time, 'minute') Interval_Begin,
                          r.Change_Date + Numtodsinterval(w.End_Time, 'minute') Interval_End,
                          w.Weight
                     from Htt_Change_Day_Weights w
                    where w.Company_Id = r.Company_Id
                      and w.Filial_Id = r.Filial_Id
                      and w.Staff_Id = r.Staff_Id
                      and w.Change_Date = r.Change_Date
                      and w.Change_Id = r.Change_Id)
        loop
          Push_Weights(p_Weights          => v_Weights,
                       p_Weights_Sum      => v_Weights_Sum,
                       i_Interval_Begin   => Wt.Interval_Begin,
                       i_Interval_End     => Wt.Interval_End,
                       i_Weight           => Wt.Weight,
                       i_Break_Enabled    => r.Break_Enabled,
                       i_Break_Begin_Time => r.Break_Begin_Time,
                       i_Break_End_Time   => r.Break_End_Time);
        end loop;
      
        for i in 1 .. v_Weights.Count
        loop
          z_Htt_Timesheet_Weights.Insert_One(i_Company_Id   => r.Company_Id,
                                             i_Filial_Id    => r.Filial_Id,
                                             i_Timesheet_Id => r.Timesheet_Id,
                                             i_Begin_Time   => v_Weights(i).Begin_Time,
                                             i_End_Time     => v_Weights(i).End_Time,
                                             i_Weight       => v_Weights(i).Weight,
                                             i_Coef         => r.Plan_Time * 60 / v_Weights_Sum);
        end loop;
      end if;
    
      Update_Border_Timesheet_Shifts(i_Company_Id   => r.Company_Id,
                                     i_Filial_Id    => r.Filial_Id,
                                     i_Staff_Id     => r.Staff_Id,
                                     i_Begin_Date   => r.Change_Date,
                                     i_End_Date     => r.Change_Date,
                                     i_Add_Callback => false);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Timesheet_Request_Facts is
  begin
    -- remove old requests
    delete Htt_Timesheet_Requests Tr
     where exists (select *
              from Htt_Dirty_Timesheets t
             where t.Company_Id = Tr.Company_Id
               and t.Filial_Id = Tr.Filial_Id
               and t.Timesheet_Id = Tr.Timesheet_Id);
  
    -- add requests according to new plan
    insert into Htt_Timesheet_Requests Tr
      select t.Company_Id, t.Filial_Id, t.Timesheet_Id, Rq.Request_Id
        from Htt_Timesheets t
        join Htt_Request_Helpers Rh
          on Rh.Company_Id = t.Company_Id
         and Rh.Filial_Id = t.Filial_Id
         and Rh.Staff_Id = t.Staff_Id
         and Rh.Interval_Date = t.Timesheet_Date
        join Htt_Requests Rq
          on Rq.Company_Id = Rh.Company_Id
         and Rq.Filial_Id = Rh.Filial_Id
         and Rq.Request_Id = Rh.Request_Id
       where exists (select *
                from Htt_Dirty_Timesheets Dt
               where t.Company_Id = Dt.Company_Id
                 and t.Filial_Id = Dt.Filial_Id
                 and t.Timesheet_Id = Dt.Timesheet_Id)
         and Rq.Status = Htt_Pref.c_Request_Status_Completed
         and Rq.Request_Type in
             (Htt_Pref.c_Request_Type_Full_Day, Htt_Pref.c_Request_Type_Multiple_Days);
  
    insert into Htt_Timesheet_Requests Tr
      select distinct t.Company_Id, t.Filial_Id, t.Timesheet_Id, Rq.Request_Id
        from Htt_Timesheets t
        join Htt_Request_Helpers Rh
          on Rh.Company_Id = t.Company_Id
         and Rh.Filial_Id = t.Filial_Id
         and Rh.Staff_Id = t.Staff_Id
         and Rh.Interval_Date between Trunc(t.Shift_Begin_Time) and Trunc(t.Shift_End_Time)
        join Htt_Requests Rq
          on Rq.Company_Id = Rh.Company_Id
         and Rq.Filial_Id = Rh.Filial_Id
         and Rq.Request_Id = Rh.Request_Id
       where exists (select *
                from Htt_Dirty_Timesheets Dt
               where t.Company_Id = Dt.Company_Id
                 and t.Filial_Id = Dt.Filial_Id
                 and t.Timesheet_Id = Dt.Timesheet_Id)
         and Rq.Status = Htt_Pref.c_Request_Status_Completed
         and Rq.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day
         and Rq.Begin_Time < t.Shift_End_Time
         and Rq.End_Time >= t.Shift_Begin_Time;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Timesheet_Track_Facts(p_Tracks in out Htt_Pref.Track_Nt) is
    v_Old_Tracks Htt_Pref.Track_Nt;
  begin
    -- remove old tracks
    delete Htt_Timesheet_Tracks Tt
     where exists (select *
              from Htt_Dirty_Timesheets t
             where t.Company_Id = Tt.Company_Id
               and t.Filial_Id = Tt.Filial_Id
               and t.Timesheet_Id = Tt.Timesheet_Id)
    returning Tt.Company_Id, Tt.Filial_Id, Tt.Track_Id bulk collect into v_Old_Tracks;
  
    -- add new tracks according to new plan
    insert into Htt_Timesheet_Tracks Tt
      (Company_Id,
       Filial_Id,
       Timesheet_Id,
       Track_Id,
       Track_Datetime,
       Track_Type,
       Track_Used,
       Trans_Input,
       Trans_Output,
       Trans_Check)
      select Tr.Company_Id,
             Tr.Filial_Id,
             t.Timesheet_Id,
             Tr.Track_Id,
             Tr.Track_Datetime,
             Tr.Track_Type,
             'Y' Track_Used,
             Tr.Trans_Input,
             Tr.Trans_Output,
             Tr.Trans_Check
        from Htt_Timesheets t
        join Htt_Tracks Tr
          on Tr.Company_Id = t.Company_Id
         and Tr.Filial_Id = t.Filial_Id
         and Tr.Person_Id = t.Employee_Id
         and Tr.Track_Date between Trunc(t.Input_Border) and Trunc(t.Output_Border)
         and Tr.Track_Datetime >= t.Input_Border
         and Tr.Track_Datetime < t.Output_Border
         and Tr.Is_Valid = 'Y'
       where (t.Company_Id, t.Filial_Id, t.Timesheet_Id) in
             (select Dt.Company_Id, Dt.Filial_Id, Dt.Timesheet_Id
                from Htt_Dirty_Timesheets Dt);
  
    select Tt.Company_Id, Tt.Filial_Id, Tt.Track_Id
      bulk collect
      into p_Tracks
      from Htt_Timesheet_Tracks Tt
      join Htt_Dirty_Timesheets Dt
        on Tt.Company_Id = Dt.Company_Id
       and Tt.Filial_Id = Dt.Filial_Id
       and Tt.Timesheet_Id = Dt.Timesheet_Id
    union
    select Ot.Company_Id, Ot.Filial_Id, Ot.Track_Id
      from table(v_Old_Tracks) Ot;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Approve_Timesheet_Marks is
  begin
    update Htt_Timesheet_Marks Tm
       set Tm.Done = 'N'
     where exists (select 1
              from Htt_Dirty_Timesheets t
             where t.Company_Id = Tm.Company_Id
               and t.Filial_Id = Tm.Filial_Id
               and t.Timesheet_Id = Tm.Timesheet_Id);
  
    update Htt_Timesheet_Marks Tm
       set Tm.Done = 'Y'
     where exists (select 1
              from Htt_Dirty_Timesheets t
             where t.Company_Id = Tm.Company_Id
               and t.Filial_Id = Tm.Filial_Id
               and t.Timesheet_Id = Tm.Timesheet_Id
               and exists
             (select *
                      from Htt_Timesheet_Tracks Tt
                     where Tt.Company_Id = t.Company_Id
                       and Tt.Filial_Id = t.Filial_Id
                       and Tt.Timesheet_Id = t.Timesheet_Id
                       and Tt.Track_Type = Htt_Pref.c_Track_Type_Check
                       and Tt.Track_Datetime between Tm.Begin_Time and Tm.End_Time));
  
    update Htt_Timesheets t
       set t.Done_Marks =
           (select count(*)
              from Htt_Timesheet_Marks Tm
             where Tm.Company_Id = t.Company_Id
               and Tm.Filial_Id = t.Filial_Id
               and Tm.Timesheet_Id = t.Timesheet_Id
               and Tm.Done = 'Y')
     where exists (select 1
              from Htt_Dirty_Timesheets Dt
             where Dt.Company_Id = t.Company_Id
               and Dt.Filial_Id = t.Filial_Id
               and Dt.Timesheet_Id = t.Timesheet_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revised_Timesheets is
    v_Tracks Htt_Pref.Track_Nt;
  
    -------------------------------------------------- 
    Procedure Track_Update_Status is
    begin
      forall i in 1 .. v_Tracks.Count
        update Htt_Tracks t
           set t.Status =
               (select case
                          when Track_Count = 0 then
                           Htt_Pref.c_Track_Status_Draft
                          when Used_Count = 0 then
                           Htt_Pref.c_Track_Status_Not_Used
                          when Used_Count < Track_Count then
                           Htt_Pref.c_Track_Status_Partially_Used
                          else
                           Htt_Pref.c_Track_Status_Used
                        end Status
                  from (select count(*) Track_Count, --
                               count(Nullif(Tt.Track_Used, 'N')) Used_Count
                          from Htt_Tracks q
                          join Htt_Timesheet_Tracks Tt
                            on q.Company_Id = Tt.Company_Id
                           and q.Filial_Id = Tt.Filial_Id
                           and q.Track_Id = Tt.Track_Id
                         where q.Company_Id = v_Tracks(i).Company_Id
                           and q.Filial_Id = v_Tracks(i).Filial_Id
                           and q.Track_Id = v_Tracks(i).Track_Id))
         where t.Company_Id = v_Tracks(i).Company_Id
           and t.Filial_Id = v_Tracks(i).Filial_Id
           and t.Track_Id = v_Tracks(i).Track_Id;
    end;
  begin
    Revise_Timesheet_Plans;
  
    Adjust_Flexible_Shifts;
  
    delete Htt_Dirty_Timesheets Dt
     where Dt.Locked = 'Y';
  
    Timesheet_Helpers_Save;
  
    Revise_Timesheet_Request_Facts;
  
    Revise_Timesheet_Track_Facts(v_Tracks);
  
    Approve_Timesheet_Marks;
  
    Gen_Timesheet_Facts;
  
    Track_Update_Status;
  
    -- need to remove
    delete Htt_Dirty_Timesheets;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Timesheet_Plans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Dates Array_Date;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    select Cd.Change_Date
      bulk collect
      into v_Change_Dates
      from Htt_Change_Days Cd
     where Cd.Company_Id = i_Company_Id
       and Cd.Filial_Id = i_Filial_Id
       and Cd.Change_Id = i_Change_Id;
  
    if r_Change.Status = Htt_Pref.c_Change_Status_Completed then
      Htt_Util.Assert_Timesheet_Locks(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => r_Change.Staff_Id,
                                      i_Dates      => v_Change_Dates);
    
      Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => r_Change.Staff_Id,
                            i_Dates      => v_Change_Dates);
    else
      -- works when plan change is cancelled from completed status
      for r in (select t.*
                  from Htt_Timesheets t
                 where t.Company_Id = i_Company_Id
                   and t.Filial_Id = i_Filial_Id
                   and t.Staff_Id = r_Change.Staff_Id
                   and t.Timesheet_Date member of v_Change_Dates)
      loop
        Gen_Timesheet_Plan(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Staff_Id       => r.Staff_Id,
                           i_Schedule_Id    => r.Schedule_Id,
                           i_Calendar_Id    => r.Calendar_Id,
                           i_Timesheet_Date => r.Timesheet_Date,
                           i_Schedule_Kind  => r.Schedule_Kind,
                           i_Track_Duration => r.Track_Duration / 60,
                           i_Count_Late     => r.Count_Late,
                           i_Count_Early    => r.Count_Early,
                           i_Count_Lack     => r.Count_Lack,
                           i_Count_Free     => r.Count_Free);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Marks_Save
  (
    i_Timesheet   Htt_Timesheets%rowtype,
    i_Only_Insert boolean := false
  ) is
  begin
    if not i_Only_Insert then
      delete Htt_Timesheet_Marks q
       where q.Company_Id = i_Timesheet.Company_Id
         and q.Filial_Id = i_Timesheet.Filial_Id
         and q.Timesheet_Id = i_Timesheet.Timesheet_Id;
    end if;
  
    insert into Htt_Timesheet_Marks Tm
      (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
      select Dm.Company_Id, --
             Dm.Filial_Id,
             i_Timesheet.Timesheet_Id,
             Dm.Begin_Time,
             Dm.End_Time,
             'N'
        from Htt_Schedule_Day_Marks Dm
       where Dm.Company_Id = i_Timesheet.Company_Id
         and Dm.Filial_Id = i_Timesheet.Filial_Id
         and Dm.Schedule_Id = i_Timesheet.Schedule_Id
         and Dm.Schedule_Date = i_Timesheet.Timesheet_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Marks_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    delete Htt_Timesheet_Marks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and exists (select *
              from Htt_Timesheets t
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Staff_Id = i_Staff_Id
               and t.Timesheet_Date between i_Begin_Date and i_End_Date
               and t.Timesheet_Id = q.Timesheet_Id);
  
    insert into Htt_Timesheet_Marks Tm
      (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
      select Dm.Company_Id, --
             Dm.Filial_Id,
             t.Timesheet_Id,
             Dm.Begin_Time,
             Dm.End_Time,
             'N'
        from Htt_Timesheets t
        join Htt_Schedule_Day_Marks Dm
          on Dm.Company_Id = i_Company_Id
         and Dm.Filial_Id = i_Filial_Id
         and Dm.Schedule_Id = t.Schedule_Id
         and Dm.Schedule_Date = t.Timesheet_Date
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Timesheet_Marks_Save_Individual
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    delete Htt_Timesheet_Marks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and exists (select *
              from Htt_Timesheets t
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Staff_Id = i_Staff_Id
               and t.Timesheet_Date between i_Begin_Date and i_End_Date
               and t.Timesheet_Id = q.Timesheet_Id);
  
    insert into Htt_Timesheet_Marks Tm
      (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
      select t.Company_Id, t.Filial_Id, t.Timesheet_Id, Dm.Begin_Time, Dm.End_Time, 'N'
        from Htt_Timesheets t
        join Htt_Staff_Schedule_Day_Marks Dm
          on Dm.Company_Id = t.Company_Id
         and Dm.Filial_Id = t.Filial_Id
         and Dm.Staff_Id = t.Staff_Id
         and Dm.Schedule_Date = t.Timesheet_Date
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Timesheet_Marks_Save_Individual
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Robot_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    delete Htt_Timesheet_Marks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Timesheet_Id in
           (select t.Timesheet_Id
              from Htt_Timesheets t
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Staff_Id = i_Staff_Id
               and t.Timesheet_Date between i_Begin_Date and i_End_Date);
  
    insert into Htt_Timesheet_Marks Tm
      (Tm.Company_Id, Tm.Filial_Id, Tm.Timesheet_Id, Tm.Begin_Time, Tm.End_Time, Tm.Done)
      select t.Company_Id, t.Filial_Id, t.Timesheet_Id, Dm.Begin_Time, Dm.End_Time, 'N'
        from Htt_Timesheets t
        join Htt_Robot_Schedule_Day_Marks Dm
          on Dm.Company_Id = t.Company_Id
         and Dm.Filial_Id = t.Filial_Id
         and Dm.Robot_Id = i_Robot_Id
         and Dm.Schedule_Date = t.Timesheet_Date
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Weights_Save
  (
    i_Timesheet   Htt_Timesheets%rowtype,
    i_Only_Insert boolean := false
  ) is
  begin
    if not i_Only_Insert then
      delete Htt_Timesheet_Weights q
       where q.Company_Id = i_Timesheet.Company_Id
         and q.Filial_Id = i_Timesheet.Filial_Id
         and q.Timesheet_Id = i_Timesheet.Timesheet_Id;
    end if;
  
    insert into Htt_Timesheet_Weights
      (Company_Id, Filial_Id, Timesheet_Id, Begin_Time, End_Time, Weight, Coef)
      select Dm.Company_Id, --
             Dm.Filial_Id,
             i_Timesheet.Timesheet_Id,
             Dm.Begin_Time,
             Dm.End_Time,
             Dm.Weight,
             Dm.Coef
        from Htt_Schedule_Day_Weights Dm
       where Dm.Company_Id = i_Timesheet.Company_Id
         and Dm.Filial_Id = i_Timesheet.Filial_Id
         and Dm.Schedule_Id = i_Timesheet.Schedule_Id
         and Dm.Schedule_Date = i_Timesheet.Timesheet_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Weights_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    delete Htt_Timesheet_Weights q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and exists (select *
              from Htt_Timesheets t
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Staff_Id = i_Staff_Id
               and t.Timesheet_Date between i_Begin_Date and i_End_Date
               and t.Timesheet_Id = q.Timesheet_Id);
  
    insert into Htt_Timesheet_Weights
      (Company_Id, Filial_Id, Timesheet_Id, Begin_Time, End_Time, Weight, Coef)
      select Dm.Company_Id, --
             Dm.Filial_Id,
             t.Timesheet_Id,
             Dm.Begin_Time,
             Dm.End_Time,
             Dm.Weight,
             Dm.Coef
        from Htt_Timesheets t
        join Htt_Schedule_Day_Weights Dm
          on Dm.Company_Id = i_Company_Id
         and Dm.Filial_Id = i_Filial_Id
         and Dm.Schedule_Id = t.Schedule_Id
         and Dm.Schedule_Date = t.Timesheet_Date
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Timesheet_Plan_Swap
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Change_Id   number,
    i_Timesheet   Htt_Timesheets%rowtype
  ) is
    v_Swap_Distance number := i_Change_Date - i_Timesheet.Timesheet_Date;
  begin
    z_Htt_Change_Days.Update_One(i_Company_Id       => i_Company_Id,
                                 i_Filial_Id        => i_Filial_Id,
                                 i_Staff_Id         => i_Staff_Id,
                                 i_Change_Date      => i_Change_Date,
                                 i_Change_Id        => i_Change_Id,
                                 i_Day_Kind         => Option_Varchar2(i_Timesheet.Day_Kind),
                                 i_Swapped_Date     => Option_Date(i_Timesheet.Timesheet_Date),
                                 i_Begin_Time       => Option_Date(i_Timesheet.Begin_Time +
                                                                   v_Swap_Distance),
                                 i_End_Time         => Option_Date(i_Timesheet.End_Time +
                                                                   v_Swap_Distance),
                                 i_Break_Enabled    => Option_Varchar2(i_Timesheet.Break_Enabled),
                                 i_Break_Begin_Time => Option_Date(i_Timesheet.Break_Begin_Time +
                                                                   v_Swap_Distance),
                                 i_Break_End_Time   => Option_Date(i_Timesheet.Break_End_Time +
                                                                   v_Swap_Distance),
                                 i_Plan_Time        => Option_Number(i_Timesheet.Plan_Time),
                                 i_Full_Time        => Option_Number(i_Timesheet.Full_Time));
  
    Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Timesheet.Staff_Id,
                          i_Dates      => Array_Date(i_Change_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Timesheet_Plan_Swaps
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
    v_Dirty_Dates Array_Date;
  begin
    update Htt_Change_Days Cd
       set (Cd.Day_Kind,
            Cd.Begin_Time,
            Cd.End_Time,
            Cd.Break_Enabled,
            Cd.Break_Begin_Time,
            Cd.Break_End_Time,
            Cd.Plan_Time,
            Cd.Full_Time) =
           (select t.Day_Kind,
                   t.Begin_Time + (Cd.Change_Date - Cd.Swapped_Date),
                   t.End_Time + (Cd.Change_Date - Cd.Swapped_Date),
                   t.Break_Enabled,
                   t.Break_Begin_Time + (Cd.Change_Date - Cd.Swapped_Date),
                   t.Break_End_Time + (Cd.Change_Date - Cd.Swapped_Date),
                   t.Plan_Time,
                   t.Full_Time
              from Htt_Timesheets t
             where t.Company_Id = Cd.Company_Id
               and t.Filial_Id = Cd.Filial_Id
               and t.Staff_Id = Cd.Staff_Id
               and t.Timesheet_Date = Cd.Swapped_Date)
     where Cd.Company_Id = i_Company_Id
       and Cd.Filial_Id = i_Filial_Id
       and Cd.Staff_Id = i_Staff_Id
       and Cd.Swapped_Date between i_Begin_Date and i_End_Date
    returning Cd.Change_Date bulk collect into v_Dirty_Dates;
  
    Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Dates      => v_Dirty_Dates);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Delete(i_Timesheet Htt_Timesheets%rowtype) is
    r_Track Htt_Tracks%rowtype;
  
    v_Timesheet_Id number;
  
    v_Track_Ids     Array_Number;
    v_Timesheet_Ids Array_Number;
  
    f_Timesheet_Sets Fazo.Boolean_Id_Aat;
  begin
    delete Htt_Timesheet_Tracks q
     where q.Company_Id = i_Timesheet.Company_Id
       and q.Filial_Id = i_Timesheet.Filial_Id
       and q.Timesheet_Id = i_Timesheet.Timesheet_Id
    returning q.Track_Id bulk collect into v_Track_Ids;
  
    z_Htt_Timesheets.Delete_One(i_Company_Id   => i_Timesheet.Company_Id,
                                i_Filial_Id    => i_Timesheet.Filial_Id,
                                i_Timesheet_Id => i_Timesheet.Timesheet_Id);
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Take(i_Company_Id => i_Timesheet.Company_Id,
                                   i_Filial_Id  => i_Timesheet.Filial_Id,
                                   i_Track_Id   => v_Track_Ids(i));
    
      if r_Track.Is_Valid = 'Y' then
        v_Timesheet_Ids := Find_Track_Timesheets(i_Company_Id     => i_Timesheet.Company_Id,
                                                 i_Filial_Id      => i_Timesheet.Filial_Id,
                                                 i_Staff_Id       => i_Timesheet.Staff_Id,
                                                 i_Track_Datetime => r_Track.Track_Datetime);
      
        for j in 1 .. v_Timesheet_Ids.Count
        loop
          f_Timesheet_Sets(v_Timesheet_Ids(j)) := true;
        end loop;
      end if;
    end loop;
  
    v_Timesheet_Id := f_Timesheet_Sets.First;
  
    while v_Timesheet_Id is not null
    loop
      Make_Dirty_Timesheet(i_Company_Id   => i_Timesheet.Company_Id,
                           i_Filial_Id    => i_Timesheet.Filial_Id,
                           i_Timesheet_Id => v_Timesheet_Id);
    
      v_Timesheet_Id := f_Timesheet_Sets.Next(v_Timesheet_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Blocking_Timebook
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  ) return Hpr_Timebooks%rowtype is
    r_Locked_Date Hpr_Timesheet_Locks%rowtype;
  begin
    r_Locked_Date := z_Hpr_Timesheet_Locks.Load(i_Company_Id     => i_Company_Id,
                                                i_Filial_Id      => i_Filial_Id,
                                                i_Staff_Id       => i_Staff_Id,
                                                i_Timesheet_Date => i_Timesheet_Date);
  
    return z_Hpr_Timebooks.Load(i_Company_Id  => r_Locked_Date.Company_Id,
                                i_Filial_Id   => r_Locked_Date.Filial_Id,
                                i_Timebook_Id => r_Locked_Date.Timebook_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timesheet_Plan
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Schedule_Id    number,
    i_Calendar_Id    number,
    i_Timesheet_Date date,
    i_Track_Duration number,
    i_Schedule_Kind  varchar2,
    i_Count_Late     varchar2,
    i_Count_Early    varchar2,
    i_Count_Lack     varchar2,
    i_Count_Free     varchar2
  ) return Htt_Timesheets%rowtype is
    r_Schedule_Day       Htt_Schedule_Days%rowtype;
    r_Schedule           Htt_Schedules%rowtype;
    r_Staff_Schedule_Day Htt_Staff_Schedule_Days%rowtype;
    r_Robot_Schedule_Day Htt_Robot_Schedule_Days%rowtype;
    r_Schedule_Registry  Htt_Schedule_Registries%rowtype;
    r_Timebook           Hpr_Timebooks%rowtype;
    result               Htt_Timesheets%rowtype;
    v_Planned_Count      number;
  
    --------------------------------------------------
    Function Get_Robot_Schedule_Day
    (
      i_Company_Id        number,
      i_Filial_Id         number,
      i_Staff_Id          number,
      i_Robot_Schedule_Id number,
      i_Schedule_Date     date
    ) return Htt_Robot_Schedule_Days%rowtype is
      result Htt_Robot_Schedule_Days%rowtype;
    begin
      select p.*
        into result
        from Hpd_Agreements_Cache q
        join Htt_Robot_Schedule_Days p
          on p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Robot_Id = q.Robot_Id
         and p.Schedule_Date = i_Schedule_Date
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Schedule_Id = i_Robot_Schedule_Id
         and i_Schedule_Date between q.Begin_Date and q.End_Date;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if z_Htt_Timesheet_Locks.Exist(i_Company_Id     => i_Company_Id,
                                   i_Filial_Id      => i_Filial_Id,
                                   i_Staff_Id       => i_Staff_Id,
                                   i_Timesheet_Date => i_Timesheet_Date) then
      r_Timebook := Get_Blocking_Timebook(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Staff_Id       => i_Staff_Id,
                                          i_Timesheet_Date => i_Timesheet_Date);
    
      Htt_Error.Raise_001(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                          i_Timesheet_Date  => i_Timesheet_Date,
                          i_Timebook_Number => r_Timebook.Timebook_Number,
                          i_Timebook_Month  => r_Timebook.Month);
    end if;
  
    if i_Schedule_Id =
       Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule) then
      r_Staff_Schedule_Day := z_Htt_Staff_Schedule_Days.Take(i_Company_Id    => i_Company_Id,
                                                             i_Filial_Id     => i_Filial_Id,
                                                             i_Staff_Id      => i_Staff_Id,
                                                             i_Schedule_Date => i_Timesheet_Date);
    
      if r_Staff_Schedule_Day.Company_Id is null then
        return null;
      end if;
    
      r_Schedule_Registry := z_Htt_Schedule_Registries.Load(i_Company_Id  => r_Staff_Schedule_Day.Company_Id,
                                                            i_Filial_Id   => r_Staff_Schedule_Day.Filial_Id,
                                                            i_Registry_Id => r_Staff_Schedule_Day.Registry_Id);
    
      select count(*)
        into v_Planned_Count
        from Htt_Staff_Schedule_Day_Marks Dm
       where Dm.Company_Id = i_Company_Id
         and Dm.Filial_Id = i_Filial_Id
         and Dm.Staff_Id = i_Staff_Id
         and Dm.Schedule_Date = i_Timesheet_Date;
    
      z_Htt_Timesheets.Init(p_Row                 => result,
                            i_Company_Id          => i_Company_Id,
                            i_Filial_Id           => i_Filial_Id,
                            i_Timesheet_Date      => i_Timesheet_Date,
                            i_Staff_Id            => i_Staff_Id,
                            i_Schedule_Id         => i_Schedule_Id,
                            i_Calendar_Id         => i_Calendar_Id,
                            i_Day_Kind            => r_Staff_Schedule_Day.Day_Kind,
                            i_Begin_Time          => r_Staff_Schedule_Day.Begin_Time,
                            i_End_Time            => r_Staff_Schedule_Day.End_Time,
                            i_Shift_Begin_Time    => r_Staff_Schedule_Day.Shift_Begin_Time,
                            i_Shift_End_Time      => r_Staff_Schedule_Day.Shift_End_Time,
                            i_Input_Border        => r_Staff_Schedule_Day.Input_Border,
                            i_Output_Border       => r_Staff_Schedule_Day.Output_Border,
                            i_Break_Enabled       => r_Staff_Schedule_Day.Break_Enabled,
                            i_Break_Begin_Time    => r_Staff_Schedule_Day.Break_Begin_Time,
                            i_Break_End_Time      => r_Staff_Schedule_Day.Break_End_Time,
                            i_Full_Time           => r_Staff_Schedule_Day.Full_Time * 60,
                            i_Plan_Time           => r_Staff_Schedule_Day.Plan_Time * 60,
                            i_Track_Duration      => r_Schedule_Registry.Track_Duration * 60,
                            i_Schedule_Kind       => r_Schedule_Registry.Schedule_Kind,
                            i_Count_Late          => r_Schedule_Registry.Count_Late,
                            i_Count_Early         => r_Schedule_Registry.Count_Early,
                            i_Count_Lack          => r_Schedule_Registry.Count_Lack,
                            i_Count_Free          => r_Schedule_Registry.Count_Free,
                            i_Gps_Turnout_Enabled => r_Schedule_Registry.Gps_Turnout_Enabled,
                            i_Gps_Use_Location    => r_Schedule_Registry.Gps_Use_Location,
                            i_Gps_Max_Interval    => r_Schedule_Registry.Gps_Max_Interval,
                            i_Planned_Marks       => v_Planned_Count,
                            i_Done_Marks          => 0,
                            i_Allowed_Late_Time   => r_Schedule_Registry.Allowed_Late_Time * 60,
                            i_Allowed_Early_Time  => r_Schedule_Registry.Allowed_Early_Time * 60,
                            i_Begin_Late_Time     => r_Schedule_Registry.Begin_Late_Time * 60,
                            i_End_Early_Time      => r_Schedule_Registry.End_Early_Time * 60);
    elsif i_Schedule_Id =
          Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      r_Robot_Schedule_Day := Get_Robot_Schedule_Day(i_Company_Id        => i_Company_Id,
                                                     i_Filial_Id         => i_Filial_Id,
                                                     i_Staff_Id          => i_Staff_Id,
                                                     i_Robot_Schedule_Id => i_Schedule_Id,
                                                     i_Schedule_Date     => i_Timesheet_Date);
    
      if r_Robot_Schedule_Day.Company_Id is null then
        return null;
      end if;
    
      r_Schedule_Registry := z_Htt_Schedule_Registries.Load(i_Company_Id  => r_Robot_Schedule_Day.Company_Id,
                                                            i_Filial_Id   => r_Robot_Schedule_Day.Filial_Id,
                                                            i_Registry_Id => r_Robot_Schedule_Day.Registry_Id);
    
      select count(*)
        into v_Planned_Count
        from Htt_Robot_Schedule_Day_Marks Dm
       where Dm.Company_Id = i_Company_Id
         and Dm.Filial_Id = i_Filial_Id
         and Dm.Robot_Id = r_Robot_Schedule_Day.Robot_Id
         and Dm.Schedule_Date = i_Timesheet_Date;
    
      z_Htt_Timesheets.Init(p_Row                 => result,
                            i_Company_Id          => i_Company_Id,
                            i_Filial_Id           => i_Filial_Id,
                            i_Timesheet_Date      => i_Timesheet_Date,
                            i_Staff_Id            => i_Staff_Id,
                            i_Schedule_Id         => i_Schedule_Id,
                            i_Calendar_Id         => i_Calendar_Id,
                            i_Day_Kind            => r_Robot_Schedule_Day.Day_Kind,
                            i_Begin_Time          => r_Robot_Schedule_Day.Begin_Time,
                            i_End_Time            => r_Robot_Schedule_Day.End_Time,
                            i_Shift_Begin_Time    => r_Robot_Schedule_Day.Shift_Begin_Time,
                            i_Shift_End_Time      => r_Robot_Schedule_Day.Shift_End_Time,
                            i_Input_Border        => r_Robot_Schedule_Day.Input_Border,
                            i_Output_Border       => r_Robot_Schedule_Day.Output_Border,
                            i_Break_Enabled       => r_Robot_Schedule_Day.Break_Enabled,
                            i_Break_Begin_Time    => r_Robot_Schedule_Day.Break_Begin_Time,
                            i_Break_End_Time      => r_Robot_Schedule_Day.Break_End_Time,
                            i_Full_Time           => r_Robot_Schedule_Day.Full_Time * 60,
                            i_Plan_Time           => r_Robot_Schedule_Day.Plan_Time * 60,
                            i_Track_Duration      => r_Schedule_Registry.Track_Duration * 60,
                            i_Schedule_Kind       => r_Schedule_Registry.Schedule_Kind,
                            i_Count_Late          => r_Schedule_Registry.Count_Late,
                            i_Count_Early         => r_Schedule_Registry.Count_Early,
                            i_Count_Lack          => r_Schedule_Registry.Count_Lack,
                            i_Count_Free          => r_Schedule_Registry.Count_Free,
                            i_Gps_Turnout_Enabled => r_Schedule_Registry.Gps_Turnout_Enabled,
                            i_Gps_Use_Location    => r_Schedule_Registry.Gps_Use_Location,
                            i_Gps_Max_Interval    => r_Schedule_Registry.Gps_Max_Interval,
                            i_Planned_Marks       => v_Planned_Count,
                            i_Done_Marks          => 0,
                            i_Allowed_Late_Time   => r_Schedule_Registry.Allowed_Late_Time * 60,
                            i_Allowed_Early_Time  => r_Schedule_Registry.Allowed_Early_Time * 60,
                            i_Begin_Late_Time     => r_Schedule_Registry.Begin_Late_Time * 60,
                            i_End_Early_Time      => r_Schedule_Registry.End_Early_Time * 60);
    else
      r_Schedule := z_Htt_Schedules.Take(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Schedule_Id => i_Schedule_Id);
    
      r_Schedule_Day := z_Htt_Schedule_Days.Take(i_Company_Id    => i_Company_Id,
                                                 i_Filial_Id     => i_Filial_Id,
                                                 i_Schedule_Id   => i_Schedule_Id,
                                                 i_Schedule_Date => i_Timesheet_Date);
    
      if r_Schedule_Day.Company_Id is null then
        return null;
      end if;
    
      select count(*)
        into v_Planned_Count
        from Htt_Schedule_Day_Marks Dm
       where Dm.Company_Id = i_Company_Id
         and Dm.Filial_Id = i_Filial_Id
         and Dm.Schedule_Id = i_Schedule_Id
         and Dm.Schedule_Date = i_Timesheet_Date;
    
      z_Htt_Timesheets.Init(p_Row                 => result,
                            i_Company_Id          => i_Company_Id,
                            i_Filial_Id           => i_Filial_Id,
                            i_Timesheet_Date      => i_Timesheet_Date,
                            i_Staff_Id            => i_Staff_Id,
                            i_Schedule_Id         => i_Schedule_Id,
                            i_Calendar_Id         => i_Calendar_Id,
                            i_Day_Kind            => r_Schedule_Day.Day_Kind,
                            i_Begin_Time          => r_Schedule_Day.Begin_Time,
                            i_End_Time            => r_Schedule_Day.End_Time,
                            i_Shift_Begin_Time    => r_Schedule_Day.Shift_Begin_Time,
                            i_Shift_End_Time      => r_Schedule_Day.Shift_End_Time,
                            i_Input_Border        => r_Schedule_Day.Input_Border,
                            i_Output_Border       => r_Schedule_Day.Output_Border,
                            i_Break_Enabled       => r_Schedule_Day.Break_Enabled,
                            i_Break_Begin_Time    => r_Schedule_Day.Break_Begin_Time,
                            i_Break_End_Time      => r_Schedule_Day.Break_End_Time,
                            i_Full_Time           => r_Schedule_Day.Full_Time * 60,
                            i_Plan_Time           => r_Schedule_Day.Plan_Time * 60,
                            i_Track_Duration      => i_Track_Duration * 60,
                            i_Schedule_Kind       => i_Schedule_Kind,
                            i_Count_Late          => i_Count_Late,
                            i_Count_Early         => i_Count_Early,
                            i_Count_Lack          => i_Count_Lack,
                            i_Count_Free          => i_Count_Free,
                            i_Gps_Turnout_Enabled => r_Schedule.Gps_Turnout_Enabled,
                            i_Gps_Use_Location    => r_Schedule.Gps_Use_Location,
                            i_Gps_Max_Interval    => r_Schedule.Gps_Max_Interval,
                            i_Planned_Marks       => v_Planned_Count,
                            i_Done_Marks          => 0,
                            i_Allowed_Late_Time   => r_Schedule.Allowed_Late_Time * 60,
                            i_Allowed_Early_Time  => r_Schedule.Allowed_Early_Time * 60,
                            i_Begin_Late_Time     => r_Schedule.Begin_Late_Time * 60,
                            i_End_Early_Time      => r_Schedule.End_Early_Time * 60);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Timesheet_Lock
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
    r_Timebook    Hpr_Timebooks%rowtype;
    v_Locked_Date date;
  begin
    select Tl.Timesheet_Date
      into v_Locked_Date
      from Htt_Timesheet_Locks Tl
     where Tl.Company_Id = i_Company_Id
       and Tl.Filial_Id = i_Filial_Id
       and Tl.Staff_Id = i_Staff_Id
       and Tl.Timesheet_Date between i_Begin_Date and i_End_Date
       and Rownum = 1;
  
    r_Timebook := Get_Blocking_Timebook(i_Company_Id     => i_Company_Id,
                                        i_Filial_Id      => i_Filial_Id,
                                        i_Staff_Id       => i_Staff_Id,
                                        i_Timesheet_Date => v_Locked_Date);
  
    Htt_Error.Raise_002(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                  i_Filial_Id  => i_Filial_Id,
                                                                  i_Staff_Id   => i_Staff_Id),
                        i_Timesheet_Date  => v_Locked_Date,
                        i_Timebook_Number => r_Timebook.Timebook_Number,
                        i_Timebook_Month  => r_Timebook.Month);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Plan
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Schedule_Id    number,
    i_Calendar_Id    number,
    i_Timesheet_Date date,
    i_Track_Duration number,
    i_Schedule_Kind  varchar2,
    i_Count_Late     varchar2,
    i_Count_Early    varchar2,
    i_Count_Lack     varchar2,
    i_Count_Free     varchar2
  ) is
    r_Plan         Htt_Timesheets%rowtype;
    r_Timesheet    Htt_Timesheets%rowtype;
    r_Staff        Href_Staffs%rowtype;
    v_Change_Ids   Array_Number;
    v_Change_Dates Array_Date;
  
    -------------------------------------------------- 
    Function Exist_Plan_Swap
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Staff_Id     number,
      i_Swapped_Date date,
      o_Change_Ids   out Array_Number,
      o_Change_Dates out Array_Date
    ) return boolean is
    begin
      select Cd.Change_Id, Cd.Change_Date
        bulk collect
        into o_Change_Ids, o_Change_Dates
        from Htt_Change_Days Cd
       where Cd.Company_Id = i_Company_Id
         and Cd.Filial_Id = i_Filial_Id
         and Cd.Staff_Id = i_Staff_Id
         and Cd.Swapped_Date = i_Swapped_Date;
    
      return o_Change_Ids.Count > 0;
    end;
  begin
    z_Href_Staffs.Lock_Only(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => i_Staff_Id);
  
    r_Plan := Timesheet_Plan(i_Company_Id     => i_Company_Id,
                             i_Filial_Id      => i_Filial_Id,
                             i_Staff_Id       => i_Staff_Id,
                             i_Schedule_Id    => i_Schedule_Id,
                             i_Calendar_Id    => i_Calendar_Id,
                             i_Timesheet_Date => i_Timesheet_Date,
                             i_Track_Duration => i_Track_Duration,
                             i_Schedule_Kind  => i_Schedule_Kind,
                             i_Count_Late     => i_Count_Late,
                             i_Count_Early    => i_Count_Early,
                             i_Count_Lack     => i_Count_Lack,
                             i_Count_Free     => i_Count_Free);
  
    -- delete timesheet when timetable is not set
    if r_Plan.Company_Id is null then
      if Htt_Util.Exist_Timesheet(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Staff_Id       => i_Staff_Id,
                                  i_Timesheet_Date => i_Timesheet_Date,
                                  o_Timesheet      => r_Timesheet) then
      
        Timesheet_Delete(r_Timesheet);
      end if;
    
      return;
    end if;
  
    if Htt_Util.Exist_Timesheet(i_Company_Id     => i_Company_Id,
                                i_Filial_Id      => i_Filial_Id,
                                i_Staff_Id       => i_Staff_Id,
                                i_Timesheet_Date => i_Timesheet_Date,
                                o_Timesheet      => r_Timesheet) then
      r_Timesheet.Schedule_Id         := r_Plan.Schedule_Id;
      r_Timesheet.Calendar_Id         := r_Plan.Calendar_Id;
      r_Timesheet.Day_Kind            := r_Plan.Day_Kind;
      r_Timesheet.Shift_Begin_Time    := r_Plan.Shift_Begin_Time;
      r_Timesheet.Shift_End_Time      := r_Plan.Shift_End_Time;
      r_Timesheet.Input_Border        := r_Plan.Input_Border;
      r_Timesheet.Output_Border       := r_Plan.Output_Border;
      r_Timesheet.Begin_Time          := r_Plan.Begin_Time;
      r_Timesheet.End_Time            := r_Plan.End_Time;
      r_Timesheet.Break_Enabled       := r_Plan.Break_Enabled;
      r_Timesheet.Break_Begin_Time    := r_Plan.Break_Begin_Time;
      r_Timesheet.Break_End_Time      := r_Plan.Break_End_Time;
      r_Timesheet.Plan_Time           := r_Plan.Plan_Time;
      r_Timesheet.Full_Time           := r_Plan.Full_Time;
      r_Timesheet.Track_Duration      := r_Plan.Track_Duration;
      r_Timesheet.Schedule_Kind       := r_Plan.Schedule_Kind;
      r_Timesheet.Count_Late          := r_Plan.Count_Late;
      r_Timesheet.Count_Early         := r_Plan.Count_Early;
      r_Timesheet.Count_Lack          := r_Plan.Count_Lack;
      r_Timesheet.Count_Free          := r_Plan.Count_Free;
      r_Timesheet.Gps_Turnout_Enabled := r_Plan.Gps_Turnout_Enabled;
      r_Timesheet.Gps_Use_Location    := r_Plan.Gps_Use_Location;
      r_Timesheet.Gps_Max_Interval    := r_Plan.Gps_Max_Interval;
      r_Timesheet.Planned_Marks       := r_Plan.Planned_Marks;
      r_Timesheet.Done_Marks          := r_Plan.Done_Marks;
      r_Timesheet.Allowed_Late_Time   := r_Plan.Allowed_Late_Time;
      r_Timesheet.Allowed_Early_Time  := r_Plan.Allowed_Early_Time;
      r_Timesheet.Begin_Late_Time     := r_Plan.Begin_Late_Time;
      r_Timesheet.End_Early_Time      := r_Plan.End_Early_Time;
    
      z_Htt_Timesheets.Update_Row(r_Timesheet);
    
      Timesheet_Marks_Save(r_Timesheet);
      Timesheet_Weights_Save(r_Timesheet);
    
      Make_Dirty_Timesheet(i_Company_Id   => r_Timesheet.Company_Id,
                           i_Filial_Id    => r_Timesheet.Filial_Id,
                           i_Timesheet_Id => r_Timesheet.Timesheet_Id);
    
      if Exist_Plan_Swap(i_Company_Id   => i_Company_Id,
                         i_Filial_Id    => i_Filial_Id,
                         i_Staff_Id     => i_Staff_Id,
                         i_Swapped_Date => i_Timesheet_Date,
                         o_Change_Ids   => v_Change_Ids,
                         o_Change_Dates => v_Change_Dates) then
        for i in 1 .. v_Change_Ids.Count
        loop
          Update_Timesheet_Plan_Swap(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Staff_Id    => i_Staff_Id,
                                     i_Change_Date => v_Change_Dates(i),
                                     i_Change_Id   => v_Change_Ids(i),
                                     i_Timesheet   => r_Timesheet);
        end loop;
      end if;
    else
      r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id);
    
      r_Plan.Company_Id     := i_Company_Id;
      r_Plan.Filial_Id      := i_Filial_Id;
      r_Plan.Timesheet_Id   := Htt_Next.Timesheet_Id;
      r_Plan.Staff_Id       := i_Staff_Id;
      r_Plan.Employee_Id    := r_Staff.Employee_Id;
      r_Plan.Timesheet_Date := i_Timesheet_Date;
    
      z_Htt_Timesheets.Insert_Row(r_Plan);
    
      Timesheet_Marks_Save(i_Timesheet   => r_Plan, --
                           i_Only_Insert => true);
      Timesheet_Weights_Save(i_Timesheet   => r_Plan, --
                             i_Only_Insert => true);
    
      Make_Dirty_Timesheet(i_Company_Id   => r_Plan.Company_Id,
                           i_Filial_Id    => r_Plan.Filial_Id,
                           i_Timesheet_Id => r_Plan.Timesheet_Id);
    end if;
  
    Update_Border_Timesheet_Shifts(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Begin_Date => i_Timesheet_Date,
                                   i_End_Date   => i_Timesheet_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    r_Staff Href_Staffs%rowtype;
  begin
    Check_Timesheet_Lock(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Begin_Date => i_Begin_Date,
                         i_End_Date   => i_End_Date);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    delete Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and not exists (select *
              from Htt_Schedule_Days Sd
             where Sd.Company_Id = t.Company_Id
               and Sd.Filial_Id = t.Filial_Id
               and Sd.Schedule_Id = i_Schedule_Id
               and Sd.Schedule_Date = t.Timesheet_Date);
  
    merge into Htt_Timesheets t
    using (select Sd.*,
                  Sd.Plan_Time * 60 Plan_Time_Sec,
                  Sd.Full_Time * 60 Full_Time_Sec,
                  s.Calendar_Id,
                  s.Track_Duration * 60 Track_Duration_Sec,
                  s.Schedule_Kind,
                  s.Count_Late,
                  s.Count_Early,
                  s.Count_Lack,
                  s.Count_Free,
                  s.Gps_Turnout_Enabled,
                  s.Gps_Use_Location,
                  s.Gps_Max_Interval,
                  s.Allowed_Late_Time,
                  s.Allowed_Early_Time,
                  s.Begin_Late_Time,
                  s.End_Early_Time,
                  (select count(*)
                     from Htt_Schedule_Day_Marks Dm
                    where Dm.Company_Id = Sd.Company_Id
                      and Dm.Filial_Id = Sd.Filial_Id
                      and Dm.Schedule_Id = Sd.Schedule_Id
                      and Dm.Schedule_Date = Sd.Schedule_Date) Planned_Marks,
                  0 Done_Marks
             from Htt_Schedule_Days Sd
             join Htt_Schedules s
               on s.Company_Id = Sd.Company_Id
              and s.Filial_Id = Sd.Filial_Id
              and s.Schedule_Id = Sd.Schedule_Id
            where Sd.Company_Id = i_Company_Id
              and Sd.Filial_Id = i_Filial_Id
              and Sd.Schedule_Id = i_Schedule_Id
              and Sd.Schedule_Date between i_Begin_Date and i_End_Date) Src
    on (t.Company_Id = Src.Company_Id --
    and t.Filial_Id = Src.Filial_Id --
    and t.Staff_Id = i_Staff_Id --
    and t.Timesheet_Date = Src.Schedule_Date)
    when matched then
      update
         set t.Schedule_Id         = i_Schedule_Id,
             t.Calendar_Id         = Src.Calendar_Id,
             t.Day_Kind            = Src.Day_Kind,
             t.Begin_Time          = Src.Begin_Time,
             t.End_Time            = Src.End_Time,
             t.Break_Enabled       = Src.Break_Enabled,
             t.Break_Begin_Time    = Src.Break_Begin_Time,
             t.Break_End_Time      = Src.Break_End_Time,
             t.Plan_Time           = Src.Plan_Time_Sec,
             t.Full_Time           = Src.Full_Time_Sec,
             t.Input_Time          = null,
             t.Output_Time         = null,
             t.Track_Duration      = Src.Track_Duration_Sec,
             t.Schedule_Kind       = Src.Schedule_Kind,
             t.Count_Late          = Src.Count_Late,
             t.Count_Early         = Src.Count_Early,
             t.Count_Lack          = Src.Count_Lack,
             t.Count_Free          = Src.Count_Free,
             t.Gps_Turnout_Enabled = Src.Gps_Turnout_Enabled,
             t.Gps_Use_Location    = Src.Gps_Use_Location,
             t.Gps_Max_Interval    = Src.Gps_Max_Interval,
             t.Shift_Begin_Time    = Src.Shift_Begin_Time,
             t.Shift_End_Time      = Src.Shift_End_Time,
             t.Input_Border        = Src.Input_Border,
             t.Output_Border       = Src.Output_Border,
             t.Planned_Marks       = Src.Planned_Marks,
             t.Done_Marks          = Src.Done_Marks,
             t.Allowed_Late_Time   = Src.Allowed_Late_Time * 60,
             t.Allowed_Early_Time  = Src.Allowed_Early_Time * 60,
             t.Begin_Late_Time     = Src.Begin_Late_Time * 60,
             t.End_Early_Time      = Src.End_Early_Time * 60
    when not matched then
      insert
        (t.Company_Id,
         t.Filial_Id,
         t.Timesheet_Id,
         t.Timesheet_Date,
         t.Staff_Id,
         t.Employee_Id,
         t.Schedule_Id,
         t.Day_Kind,
         t.Begin_Time,
         t.End_Time,
         t.Break_Enabled,
         t.Break_Begin_Time,
         t.Break_End_Time,
         t.Plan_Time,
         t.Full_Time,
         t.Track_Duration,
         t.Schedule_Kind,
         t.Count_Late,
         t.Count_Early,
         t.Count_Lack,
         t.Count_Free,
         t.Gps_Turnout_Enabled,
         t.Gps_Use_Location,
         t.Gps_Max_Interval,
         t.Shift_Begin_Time,
         t.Shift_End_Time,
         t.Input_Border,
         t.Output_Border,
         t.Calendar_Id,
         t.Planned_Marks,
         t.Done_Marks,
         t.Allowed_Late_Time,
         t.Allowed_Early_Time,
         t.Begin_Late_Time,
         t.End_Early_Time)
      values
        (i_Company_Id,
         i_Filial_Id,
         Htt_Next.Timesheet_Id,
         Src.Schedule_Date,
         i_Staff_Id,
         r_Staff.Employee_Id,
         i_Schedule_Id,
         Src.Day_Kind,
         Src.Begin_Time,
         Src.End_Time,
         Src.Break_Enabled,
         Src.Break_Begin_Time,
         Src.Break_End_Time,
         Src.Plan_Time_Sec,
         Src.Full_Time_Sec,
         Src.Track_Duration_Sec,
         Src.Schedule_Kind,
         Src.Count_Late,
         Src.Count_Early,
         Src.Count_Lack,
         Src.Count_Free,
         Src.Gps_Turnout_Enabled,
         Src.Gps_Use_Location,
         Src.Gps_Max_Interval,
         Src.Shift_Begin_Time,
         Src.Shift_End_Time,
         Src.Input_Border,
         Src.Output_Border,
         Src.Calendar_Id,
         Src.Planned_Marks,
         Src.Done_Marks,
         Src.Allowed_Late_Time * 60,
         Src.Allowed_Early_Time * 60,
         Src.Begin_Late_Time * 60,
         Src.End_Early_Time * 60);
  
    Timesheet_Marks_Save(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Begin_Date => i_Begin_Date,
                         i_End_Date   => i_End_Date);
  
    Timesheet_Weights_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Staff_Id   => i_Staff_Id,
                           i_Begin_Date => i_Begin_Date,
                           i_End_Date   => i_End_Date);
  
    Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Begin_Date => i_Begin_Date,
                          i_End_Date   => i_End_Date);
  
    Update_Timesheet_Plan_Swaps(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Begin_Date => i_Begin_Date,
                                i_End_Date   => i_End_Date);
  
    Update_Border_Timesheet_Shifts(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Begin_Date => i_Begin_Date,
                                   i_End_Date   => i_End_Date);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Timesheet_Plan_Individual
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Robot_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    r_Staff Href_Staffs%rowtype;
  begin
    Check_Timesheet_Lock(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Begin_Date => i_Begin_Date,
                         i_End_Date   => i_End_Date);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    -- maybe just delete all timesheets 
    -- and insert them from source, removing merge statement
    -- need to check if unchanged timesheet_id is needed
  
    delete Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and not exists (select *
              from Htt_Robot_Schedule_Days Sd
             where Sd.Company_Id = t.Company_Id
               and Sd.Filial_Id = t.Filial_Id
               and Sd.Robot_Id = i_Robot_Id
               and Sd.Schedule_Date = t.Timesheet_Date);
  
    merge into Htt_Timesheets t
    using (select Sd.*,
                  Sd.Plan_Time * 60 Plan_Time_Sec,
                  Sd.Full_Time * 60 Full_Time_Sec,
                  s.Calendar_Id,
                  s.Track_Duration * 60 Track_Duration_Sec,
                  s.Schedule_Kind,
                  s.Count_Late,
                  s.Count_Early,
                  s.Count_Lack,
                  s.Count_Free,
                  s.Gps_Turnout_Enabled,
                  s.Gps_Use_Location,
                  s.Gps_Max_Interval,
                  s.Allowed_Late_Time,
                  s.Allowed_Early_Time,
                  s.Begin_Late_Time,
                  s.End_Early_Time,
                  (select count(*)
                     from Htt_Robot_Schedule_Day_Marks Dm
                    where Dm.Company_Id = Sd.Company_Id
                      and Dm.Filial_Id = Sd.Filial_Id
                      and Dm.Robot_Id = Sd.Robot_Id
                      and Dm.Schedule_Date = Sd.Schedule_Date) Planned_Marks,
                  0 Done_Marks
             from Htt_Robot_Schedule_Days Sd
             join Htt_Schedule_Registries s
               on s.Company_Id = Sd.Company_Id
              and s.Filial_Id = Sd.Filial_Id
              and s.Registry_Id = Sd.Registry_Id
            where Sd.Company_Id = i_Company_Id
              and Sd.Filial_Id = i_Filial_Id
              and Sd.Robot_Id = i_Robot_Id
              and Sd.Schedule_Date between i_Begin_Date and i_End_Date) Src
    on (t.Company_Id = Src.Company_Id --
    and t.Filial_Id = Src.Filial_Id --
    and t.Staff_Id = i_Staff_Id --
    and t.Timesheet_Date = Src.Schedule_Date)
    when matched then
      update
         set t.Schedule_Id         = i_Schedule_Id,
             t.Calendar_Id         = Src.Calendar_Id,
             t.Day_Kind            = Src.Day_Kind,
             t.Begin_Time          = Src.Begin_Time,
             t.End_Time            = Src.End_Time,
             t.Break_Enabled       = Src.Break_Enabled,
             t.Break_Begin_Time    = Src.Break_Begin_Time,
             t.Break_End_Time      = Src.Break_End_Time,
             t.Plan_Time           = Src.Plan_Time_Sec,
             t.Full_Time           = Src.Full_Time_Sec,
             t.Input_Time          = null,
             t.Output_Time         = null,
             t.Track_Duration      = Src.Track_Duration_Sec,
             t.Schedule_Kind       = Src.Schedule_Kind,
             t.Count_Late          = Src.Count_Late,
             t.Count_Early         = Src.Count_Early,
             t.Count_Lack          = Src.Count_Lack,
             t.Count_Free          = Src.Count_Free,
             t.Gps_Turnout_Enabled = Src.Gps_Turnout_Enabled,
             t.Gps_Use_Location    = Src.Gps_Use_Location,
             t.Gps_Max_Interval    = Src.Gps_Max_Interval,
             t.Shift_Begin_Time    = Src.Shift_Begin_Time,
             t.Shift_End_Time      = Src.Shift_End_Time,
             t.Input_Border        = Src.Input_Border,
             t.Output_Border       = Src.Output_Border,
             t.Planned_Marks       = Src.Planned_Marks,
             t.Done_Marks          = Src.Done_Marks,
             t.Allowed_Late_Time   = Src.Allowed_Late_Time * 60,
             t.Allowed_Early_Time  = Src.Allowed_Early_Time * 60,
             t.Begin_Late_Time     = Src.Begin_Late_Time * 60,
             t.End_Early_Time      = Src.End_Early_Time * 60
    when not matched then
      insert
        (t.Company_Id,
         t.Filial_Id,
         t.Timesheet_Id,
         t.Timesheet_Date,
         t.Staff_Id,
         t.Employee_Id,
         t.Schedule_Id,
         t.Day_Kind,
         t.Begin_Time,
         t.End_Time,
         t.Break_Enabled,
         t.Break_Begin_Time,
         t.Break_End_Time,
         t.Plan_Time,
         t.Full_Time,
         t.Track_Duration,
         t.Schedule_Kind,
         t.Count_Late,
         t.Count_Early,
         t.Count_Lack,
         t.Count_Free,
         t.Gps_Turnout_Enabled,
         t.Gps_Use_Location,
         t.Gps_Max_Interval,
         t.Shift_Begin_Time,
         t.Shift_End_Time,
         t.Input_Border,
         t.Output_Border,
         t.Calendar_Id,
         t.Planned_Marks,
         t.Done_Marks,
         t.Allowed_Late_Time,
         t.Allowed_Early_Time,
         t.Begin_Late_Time,
         t.End_Early_Time)
      values
        (i_Company_Id,
         i_Filial_Id,
         Htt_Next.Timesheet_Id,
         Src.Schedule_Date,
         i_Staff_Id,
         r_Staff.Employee_Id,
         i_Schedule_Id,
         Src.Day_Kind,
         Src.Begin_Time,
         Src.End_Time,
         Src.Break_Enabled,
         Src.Break_Begin_Time,
         Src.Break_End_Time,
         Src.Plan_Time_Sec,
         Src.Full_Time_Sec,
         Src.Track_Duration_Sec,
         Src.Schedule_Kind,
         Src.Count_Late,
         Src.Count_Early,
         Src.Count_Lack,
         Src.Count_Free,
         Src.Gps_Turnout_Enabled,
         Src.Gps_Use_Location,
         Src.Gps_Max_Interval,
         Src.Shift_Begin_Time,
         Src.Shift_End_Time,
         Src.Input_Border,
         Src.Output_Border,
         Src.Calendar_Id,
         Src.Planned_Marks,
         Src.Done_Marks,
         Src.Allowed_Late_Time * 60,
         Src.Allowed_Early_Time * 60,
         Src.Begin_Late_Time * 60,
         Src.End_Early_Time * 60);
  
    Timesheet_Marks_Save_Individual(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id,
                                    i_Robot_Id   => i_Robot_Id,
                                    i_Begin_Date => i_Begin_Date,
                                    i_End_Date   => i_End_Date);
  
    Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Begin_Date => i_Begin_Date,
                          i_End_Date   => i_End_Date);
  
    Update_Timesheet_Plan_Swaps(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Begin_Date => i_Begin_Date,
                                i_End_Date   => i_End_Date);
  
    Update_Border_Timesheet_Shifts(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Begin_Date => i_Begin_Date,
                                   i_End_Date   => i_End_Date);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Timesheet_Plan_Individual
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    r_Staff Href_Staffs%rowtype;
  begin
    Check_Timesheet_Lock(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Begin_Date => i_Begin_Date,
                         i_End_Date   => i_End_Date);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    delete Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date between i_Begin_Date and i_End_Date
       and not exists (select *
              from Htt_Staff_Schedule_Days Sd
             where Sd.Company_Id = t.Company_Id
               and Sd.Filial_Id = t.Filial_Id
               and Sd.Staff_Id = i_Staff_Id
               and Sd.Schedule_Date = t.Timesheet_Date);
  
    merge into Htt_Timesheets t
    using (select Sd.*,
                  Sd.Plan_Time * 60 Plan_Time_Sec,
                  Sd.Full_Time * 60 Full_Time_Sec,
                  s.Calendar_Id,
                  s.Track_Duration * 60 Track_Duration_Sec,
                  s.Schedule_Kind,
                  s.Count_Late,
                  s.Count_Early,
                  s.Count_Lack,
                  s.Count_Free,
                  s.Gps_Turnout_Enabled,
                  s.Gps_Use_Location,
                  s.Gps_Max_Interval,
                  s.Allowed_Late_Time,
                  s.Allowed_Early_Time,
                  s.Begin_Late_Time,
                  s.End_Early_Time,
                  (select count(*)
                     from Htt_Staff_Schedule_Day_Marks Dm
                    where Dm.Company_Id = Sd.Company_Id
                      and Dm.Filial_Id = Sd.Filial_Id
                      and Dm.Staff_Id = Sd.Staff_Id
                      and Dm.Schedule_Date = Sd.Schedule_Date) Planned_Marks,
                  0 Done_Marks
             from Htt_Staff_Schedule_Days Sd
             join Htt_Schedule_Registries s
               on s.Company_Id = Sd.Company_Id
              and s.Filial_Id = Sd.Filial_Id
              and s.Registry_Id = Sd.Registry_Id
            where Sd.Company_Id = i_Company_Id
              and Sd.Filial_Id = i_Filial_Id
              and Sd.Staff_Id = i_Staff_Id
              and Sd.Schedule_Date between i_Begin_Date and i_End_Date) Src
    on (t.Company_Id = Src.Company_Id --
    and t.Filial_Id = Src.Filial_Id --
    and t.Staff_Id = i_Staff_Id --
    and t.Timesheet_Date = Src.Schedule_Date)
    when matched then
      update
         set t.Schedule_Id         = i_Schedule_Id,
             t.Calendar_Id         = Src.Calendar_Id,
             t.Day_Kind            = Src.Day_Kind,
             t.Begin_Time          = Src.Begin_Time,
             t.End_Time            = Src.End_Time,
             t.Break_Enabled       = Src.Break_Enabled,
             t.Break_Begin_Time    = Src.Break_Begin_Time,
             t.Break_End_Time      = Src.Break_End_Time,
             t.Plan_Time           = Src.Plan_Time_Sec,
             t.Full_Time           = Src.Full_Time_Sec,
             t.Input_Time          = null,
             t.Output_Time         = null,
             t.Track_Duration      = Src.Track_Duration_Sec,
             t.Schedule_Kind       = Src.Schedule_Kind,
             t.Count_Late          = Src.Count_Late,
             t.Count_Early         = Src.Count_Early,
             t.Count_Lack          = Src.Count_Lack,
             t.Count_Free          = Src.Count_Free,
             t.Gps_Turnout_Enabled = Src.Gps_Turnout_Enabled,
             t.Gps_Use_Location    = Src.Gps_Use_Location,
             t.Gps_Max_Interval    = Src.Gps_Max_Interval,
             t.Shift_Begin_Time    = Src.Shift_Begin_Time,
             t.Shift_End_Time      = Src.Shift_End_Time,
             t.Input_Border        = Src.Input_Border,
             t.Output_Border       = Src.Output_Border,
             t.Planned_Marks       = Src.Planned_Marks,
             t.Done_Marks          = Src.Done_Marks,
             t.Allowed_Late_Time   = Src.Allowed_Late_Time * 60,
             t.Allowed_Early_Time  = Src.Allowed_Early_Time * 60,
             t.Begin_Late_Time     = Src.Begin_Late_Time * 60,
             t.End_Early_Time      = Src.End_Early_Time * 60
    when not matched then
      insert
        (t.Company_Id,
         t.Filial_Id,
         t.Timesheet_Id,
         t.Timesheet_Date,
         t.Staff_Id,
         t.Employee_Id,
         t.Schedule_Id,
         t.Day_Kind,
         t.Begin_Time,
         t.End_Time,
         t.Break_Enabled,
         t.Break_Begin_Time,
         t.Break_End_Time,
         t.Plan_Time,
         t.Full_Time,
         t.Track_Duration,
         t.Schedule_Kind,
         t.Count_Late,
         t.Count_Early,
         t.Count_Lack,
         t.Count_Free,
         t.Gps_Turnout_Enabled,
         t.Gps_Use_Location,
         t.Gps_Max_Interval,
         t.Shift_Begin_Time,
         t.Shift_End_Time,
         t.Input_Border,
         t.Output_Border,
         t.Calendar_Id,
         t.Planned_Marks,
         t.Done_Marks,
         t.Allowed_Late_Time,
         t.Allowed_Early_Time,
         t.Begin_Late_Time,
         t.End_Early_Time)
      values
        (i_Company_Id,
         i_Filial_Id,
         Htt_Next.Timesheet_Id,
         Src.Schedule_Date,
         i_Staff_Id,
         r_Staff.Employee_Id,
         i_Schedule_Id,
         Src.Day_Kind,
         Src.Begin_Time,
         Src.End_Time,
         Src.Break_Enabled,
         Src.Break_Begin_Time,
         Src.Break_End_Time,
         Src.Plan_Time_Sec,
         Src.Full_Time_Sec,
         Src.Track_Duration_Sec,
         Src.Schedule_Kind,
         Src.Count_Late,
         Src.Count_Early,
         Src.Count_Lack,
         Src.Count_Free,
         Src.Gps_Turnout_Enabled,
         Src.Gps_Use_Location,
         Src.Gps_Max_Interval,
         Src.Shift_Begin_Time,
         Src.Shift_End_Time,
         Src.Input_Border,
         Src.Output_Border,
         Src.Calendar_Id,
         Src.Planned_Marks,
         Src.Done_Marks,
         Src.Allowed_Late_Time * 60,
         Src.Allowed_Early_Time * 60,
         Src.Begin_Late_Time * 60,
         Src.End_Early_Time * 60);
  
    Timesheet_Marks_Save_Individual(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id,
                                    i_Begin_Date => i_Begin_Date,
                                    i_End_Date   => i_End_Date);
  
    Make_Dirty_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Begin_Date => i_Begin_Date,
                          i_End_Date   => i_End_Date);
  
    Update_Timesheet_Plan_Swaps(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Begin_Date => i_Begin_Date,
                                i_End_Date   => i_End_Date);
  
    Update_Border_Timesheet_Shifts(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Begin_Date => i_Begin_Date,
                                   i_End_Date   => i_End_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  -- calculate schedule change parts for every staff inside i_year
  -- determine schedule of staff inside every part
  -- if schedule is same as i_Schedule_Id
  -- generate timesheets for that part
  Procedure Gen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Year        number
  ) is
    r_Schedule   Htt_Schedules%rowtype;
    v_Year_Begin date;
    v_Year_End   date;
  begin
    r_Schedule := z_Htt_Schedules.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Schedule_Id => i_Schedule_Id);
  
    if Fazo.Equal(r_Schedule.Pcode, Htt_Pref.c_Pcode_Individual_Staff_Schedule) or
       Fazo.Equal(r_Schedule.Pcode, Htt_Pref.c_Pcode_Individual_Robot_Schedule) then
      b.Raise_Fatal('htt_core.gen_timesheet_plan: yearly generation schedule for only odinary schedules');
    end if;
  
    v_Year_Begin := Trunc(to_date(i_Year, 'yyyy'), 'y');
    v_Year_End   := Add_Months(v_Year_Begin, 12) - 1;
  
    -- make schedule change intervals 
    -- for every staff of given year
    -- filter out unnecessary schedules  
    for r in (select Qr.Period_Begin, Nvl(Qr.Period_End - 1, v_Year_End) Period_End, Qr.Staff_Id
                from (select Greatest(p.Period, v_Year_Begin) Period_Begin,
                             Lead(p.Period) --
                             Over(partition by p.Staff_Id order by p.Period) Period_End,
                             p.Trans_Id,
                             p.Staff_Id
                        from Hpd_Agreements p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
                         and (p.Period between v_Year_Begin and v_Year_End or
                             p.Period = (select max(Lp.Period)
                                            from Hpd_Agreements Lp
                                           where Lp.Company_Id = p.Company_Id
                                             and Lp.Filial_Id = p.Filial_Id
                                             and Lp.Staff_Id = p.Staff_Id
                                             and Lp.Trans_Type = p.Trans_Type
                                             and Lp.Period < v_Year_Begin))) Qr
                join Hpd_Trans_Schedules q
                  on q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Trans_Id = Qr.Trans_Id
                 and q.Schedule_Id = i_Schedule_Id
               order by Qr.Staff_Id, Qr.Period_Begin)
    loop
      Regenerate_Timesheets(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Staff_Id    => r.Staff_Id,
                            i_Schedule_Id => i_Schedule_Id,
                            i_Begin_Date  => r.Period_Begin,
                            i_End_Date    => r.Period_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Timesheet_Plan
  
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  ) is
    r_Schedule Htt_Schedules%rowtype;
  begin
    r_Schedule := z_Htt_Schedules.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Schedule_Id => i_Schedule_Id);
  
    for r in (select t.Staff_Id, t.Timesheet_Date, t.Schedule_Id
                from Htt_Timesheets t
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Schedule_Id = i_Schedule_Id
                 and t.Timesheet_Date member of i_Dates)
    loop
      Gen_Timesheet_Plan(i_Company_Id     => i_Company_Id,
                         i_Filial_Id      => i_Filial_Id,
                         i_Staff_Id       => r.Staff_Id,
                         i_Schedule_Id    => r.Schedule_Id,
                         i_Calendar_Id    => r_Schedule.Calendar_Id,
                         i_Timesheet_Date => r.Timesheet_Date,
                         i_Track_Duration => r_Schedule.Track_Duration,
                         i_Schedule_Kind  => r_Schedule.Schedule_Kind,
                         i_Count_Late     => r_Schedule.Count_Late,
                         i_Count_Early    => r_Schedule.Count_Early,
                         i_Count_Lack     => r_Schedule.Count_Lack,
                         i_Count_Free     => r_Schedule.Count_Free);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Requests
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Timesheet_Id           number,
    i_Timesheet_Date         date,
    i_Begin_Time             date,
    i_End_Time               date,
    i_Extra_Begin_Time       date,
    i_Extra_End_Time         date,
    i_Calendar_Id            number,
    o_Has_Fd_Request         out boolean,
    o_Fd_Rq_Time_Kind_Id     out number,
    o_Fd_Request_Unused_Time out varchar2,
    o_Rq_Request_Types       out Array_Varchar2,
    o_Rq_Begin_Dates         out Array_Date,
    o_Rq_End_Dates           out Array_Date,
    o_Rq_Time_Kind_Ids       out Array_Number,
    o_Rq_Parent_Ids          out Array_Number,
    o_Rq_Unused_Times        out Array_Varchar2,
    o_Extra_Rq_Begin_Dates   out Array_Date,
    o_Extra_Rq_End_Dates     out Array_Date
  ) is
    v_Official_Rest_Day varchar2(1) := 'N';
  begin
    if Htt_Util.Is_Official_Rest_Day(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Calendar_Id => i_Calendar_Id,
                                     i_Date        => i_Timesheet_Date) then
      v_Official_Rest_Day := 'Y';
    end if;
  
    o_Has_Fd_Request := false;
  
    select w.Request_Type, --
           w.Begin_Time,
           w.End_Time,
           k.Time_Kind_Id,
           Nvl(Tk.Parent_Id, Tk.Time_Kind_Id),
           k.Allow_Unused_Time
      bulk collect
      into o_Rq_Request_Types, --
           o_Rq_Begin_Dates,
           o_Rq_End_Dates,
           o_Rq_Time_Kind_Ids,
           o_Rq_Parent_Ids,
           o_Rq_Unused_Times
      from Htt_Timesheet_Requests q
      join Htt_Requests w
        on q.Company_Id = w.Company_Id
       and q.Filial_Id = w.Filial_Id
       and q.Request_Id = w.Request_Id
      join Htt_Request_Kinds k
        on k.Company_Id = w.Company_Id
       and k.Request_Kind_Id = w.Request_Kind_Id
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = k.Company_Id
       and Tk.Time_Kind_Id = k.Time_Kind_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Timesheet_Id = i_Timesheet_Id
       and (k.Day_Count_Type <> Htt_Pref.c_Day_Count_Type_Production_Days or
           k.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Production_Days and
           v_Official_Rest_Day = 'N')
     order by w.Begin_Time;
  
    o_Extra_Rq_Begin_Dates := Array_Date();
    o_Extra_Rq_End_Dates   := Array_Date();
    o_Extra_Rq_Begin_Dates.Extend(o_Rq_Begin_Dates.Count);
    o_Extra_Rq_End_Dates.Extend(o_Rq_Begin_Dates.Count);
  
    for i in 1 .. o_Rq_Request_Types.Count
    loop
      o_Extra_Rq_Begin_Dates(i) := Greatest(o_Rq_Begin_Dates(i), i_Extra_Begin_Time);
      o_Extra_Rq_End_Dates(i) := Least(o_Rq_End_Dates(i), i_Extra_End_Time);
      o_Rq_Begin_Dates(i) := Greatest(o_Rq_Begin_Dates(i), i_Begin_Time);
      o_Rq_End_Dates(i) := Least(o_Rq_End_Dates(i), i_End_Time);
    
      if o_Rq_Request_Types(i) != Htt_Pref.c_Request_Type_Part_Of_Day then
        o_Has_Fd_Request         := true;
        o_Fd_Rq_Time_Kind_Id     := o_Rq_Time_Kind_Ids(i);
        o_Fd_Request_Unused_Time := o_Rq_Unused_Times(i);
      
        o_Rq_Begin_Dates(i) := i_Begin_Time;
        o_Rq_End_Dates(i) := i_End_Time;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Insert_Timesheet_Overtime_Facts
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Timesheet_Id     number,
    i_Staff_Id         number,
    i_Timesheet_Date   date,
    i_Overtime_Seconds number
  ) is
    v_Free_Time             number;
    v_Free_Time_Kind_Id     number := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    v_Overtime_Time_Kind_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  begin
    v_Free_Time := Htt_Util.Get_Fact_Value(i_Company_Id     => i_Company_Id,
                                           i_Filial_Id      => i_Filial_Id,
                                           i_Staff_Id       => i_Staff_Id,
                                           i_Timesheet_Date => i_Timesheet_Date,
                                           i_Time_Kind_Id   => v_Free_Time_Kind_Id);
  
    if v_Free_Time is null or i_Overtime_Seconds > v_Free_Time then
      Htt_Error.Raise_003(i_Staff_Name           => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                         i_Filial_Id  => i_Filial_Id,
                                                                         i_Staff_Id   => i_Staff_Id),
                          i_Timesheet_Date       => i_Timesheet_Date,
                          i_Overtime_Exceed_Text => Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Overtime_Seconds -
                                                                                                    v_Free_Time,
                                                                                  i_Show_Minutes => true,
                                                                                  i_Show_Words   => true));
    end if;
  
    z_Htt_Timesheet_Facts.Insert_One(i_Company_Id   => i_Company_Id,
                                     i_Filial_Id    => i_Filial_Id,
                                     i_Timesheet_Id => i_Timesheet_Id,
                                     i_Time_Kind_Id => v_Overtime_Time_Kind_Id,
                                     i_Fact_Value   => i_Overtime_Seconds);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Push_Interval
  (
    p_Intervals      in out nocopy Htt_Pref.Timesheet_Interval_Nt,
    i_Timesheet      Htt_Timesheets%rowtype,
    i_Interval_Begin date,
    i_Interval_End   date
  ) is
    v_Interval Htt_Pref.Timesheet_Interval_Rt;
  begin
    v_Interval.Company_Id     := i_Timesheet.Company_Id;
    v_Interval.Filial_Id      := i_Timesheet.Filial_Id;
    v_Interval.Timesheet_Id   := i_Timesheet.Timesheet_Id;
    v_Interval.Interval_Begin := i_Interval_Begin;
    v_Interval.Interval_End   := i_Interval_End;
  
    if i_Timesheet.Break_Enabled = 'Y' and v_Interval.Interval_Begin < i_Timesheet.Break_Begin_Time and
       v_Interval.Interval_End > i_Timesheet.Break_End_Time then
      v_Interval.Interval_Id := Htt_Next.Timesheet_Interval_Id;
    
      v_Interval.Interval_End := i_Timesheet.Break_Begin_Time;
    
      p_Intervals.Extend;
      p_Intervals(p_Intervals.Count) := v_Interval;
    
      v_Interval.Interval_Begin := i_Timesheet.Break_End_Time;
      v_Interval.Interval_End   := i_Interval_End;
    elsif i_Timesheet.Break_Begin_Time <= v_Interval.Interval_Begin and
          i_Timesheet.Break_End_Time >= v_Interval.Interval_End then
      return;
    elsif i_Timesheet.Break_Enabled = 'Y' then
      if i_Timesheet.Break_Begin_Time between v_Interval.Interval_Begin and v_Interval.Interval_End then
        v_Interval.Interval_End := i_Timesheet.Break_Begin_Time;
      end if;
    
      if i_Timesheet.Break_End_Time between v_Interval.Interval_Begin and v_Interval.Interval_End then
        v_Interval.Interval_Begin := i_Timesheet.Break_End_Time;
      end if;
    end if;
  
    if v_Interval.Interval_Begin < v_Interval.Interval_End then
      v_Interval.Interval_Id := Htt_Next.Timesheet_Interval_Id;
    
      p_Intervals.Extend;
      p_Intervals(p_Intervals.Count) := v_Interval;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Push_Intersect_Intervals
  (
    p_Intervals       in out nocopy Htt_Pref.Timesheet_Interval_Nt,
    p_Interval_Begin  in out date,
    p_Interval_End    in out date,
    i_Timesheet       Htt_Timesheets%rowtype,
    i_Intersect_Begin date,
    i_Intersect_End   date
  ) is
  begin
    if p_Interval_Begin >= p_Interval_End then
      return;
    end if;
  
    if p_Interval_Begin < i_Intersect_Begin and p_Interval_End > i_Intersect_End then
      Push_Interval(p_Intervals      => p_Intervals,
                    i_Timesheet      => i_Timesheet,
                    i_Interval_Begin => p_Interval_Begin,
                    i_Interval_End   => i_Intersect_Begin);
    
      p_Interval_Begin := i_Intersect_End;
    elsif i_Intersect_Begin <= p_Interval_Begin and i_Intersect_End >= p_Interval_End then
      -- invalidate given interval
      p_Interval_End   := i_Intersect_End;
      p_Interval_Begin := p_Interval_End;
    else
      if i_Intersect_Begin between p_Interval_Begin and p_Interval_End then
        p_Interval_End := i_Intersect_Begin;
      end if;
    
      if i_Intersect_End between p_Interval_Begin and p_Interval_End then
        p_Interval_Begin := i_Intersect_End;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Rest_Day
  (
    p_Timesheet      in out nocopy Htt_Timesheets%rowtype,
    p_Facts          in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Time_Parts     Htt_Pref.Time_Part_Nt,
    i_Requests_Exist boolean
  ) is
    v_Input     date;
    v_Output    date;
    v_Free_Time number := 0;
  
    v_Has_Request            boolean := false;
    v_Rest_Time_Kind_Pcode   varchar2(20);
    v_Request_Day_Count_Type varchar2(1);
    v_Allow_Unused_Time      varchar2(1);
    v_Request_Time_Kind_Id   number(20);
  begin
    -- calc input output parts
    for i in 1 .. i_Time_Parts.Count
    loop
      v_Input  := i_Time_Parts(i).Input_Time;
      v_Output := i_Time_Parts(i).Output_Time;
    
      v_Free_Time := v_Free_Time + Htt_Util.Time_Diff(v_Output, v_Input);
    end loop;
  
    -- determine rest pcode
    case p_Timesheet.Day_Kind
      when Htt_Pref.c_Day_Kind_Holiday then
        v_Rest_Time_Kind_Pcode := Htt_Pref.c_Pcode_Time_Kind_Holiday;
      when Htt_Pref.c_Day_Kind_Additional_Rest then
        v_Rest_Time_Kind_Pcode := Htt_Pref.c_Pcode_Time_Kind_Additional_Rest;
      when Htt_Pref.c_Day_Kind_Nonworking then
        v_Rest_Time_Kind_Pcode := Htt_Pref.c_Pcode_Time_Kind_Nonworking;
      else
        v_Rest_Time_Kind_Pcode := Htt_Pref.c_Pcode_Time_Kind_Rest;
    end case;
  
    if i_Requests_Exist then
      -- load full day resuest
      begin
        select Rk.Day_Count_Type, Rk.Time_Kind_Id, Rk.Allow_Unused_Time
          into v_Request_Day_Count_Type, v_Request_Time_Kind_Id, v_Allow_Unused_Time
          from Htt_Timesheet_Requests t
          join Htt_Requests q
            on q.Company_Id = t.Company_Id
           and q.Filial_Id = t.Filial_Id
           and q.Request_Id = t.Request_Id
          join Htt_Request_Kinds Rk
            on Rk.Company_Id = q.Company_Id
           and Rk.Request_Kind_Id = q.Request_Kind_Id
         where t.Company_Id = p_Timesheet.Company_Id
           and t.Filial_Id = p_Timesheet.Filial_Id
           and t.Timesheet_Id = p_Timesheet.Timesheet_Id
           and q.Request_Type <> Htt_Pref.c_Request_Type_Part_Of_Day;
      exception
        when No_Data_Found then
          null;
      end;
    
      -- save request if its saveable
      if v_Request_Day_Count_Type = Htt_Pref.c_Day_Count_Type_Calendar_Days or
         v_Request_Day_Count_Type = Htt_Pref.c_Day_Count_Type_Production_Days and
         not Htt_Util.Is_Official_Rest_Day(i_Company_Id  => p_Timesheet.Company_Id,
                                           i_Filial_Id   => p_Timesheet.Filial_Id,
                                           i_Calendar_Id => p_Timesheet.Calendar_Id,
                                           i_Date        => p_Timesheet.Timesheet_Date) then
        Gen_Timesheet_Fact(p_Facts         => p_Facts,
                           i_Company_Id    => p_Timesheet.Company_Id,
                           i_Filial_Id     => p_Timesheet.Filial_Id,
                           i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                           i_Time_Kind_Id  => v_Request_Time_Kind_Id,
                           i_Fact_Value    => p_Timesheet.Plan_Time,
                           i_Schedule_Kind => p_Timesheet.Schedule_Kind);
      
        v_Has_Request := true;
      end if;
    end if;
  
    -- timesheet with full day request with disabled unused time
    -- will ignore any facts except request on this timesheet
    -- e.g.: 
    -- let current day have full day request,
    --                      input (09:00) and output (18:00) tracks
    -- then 
    -- any facts generated from tracks will not be recorded
    -- they will not be included even free time time_kind
    if v_Has_Request and v_Allow_Unused_Time = 'N' then
      v_Free_Time := 0;
    end if;
  
    if p_Timesheet.Count_Free = 'N' then
      v_Free_Time := 0;
    end if;
  
    -- save rest fact only if no request exists this day
    if v_Rest_Time_Kind_Pcode <> Htt_Pref.c_Pcode_Time_Kind_Rest or not v_Has_Request then
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                  i_Pcode      => v_Rest_Time_Kind_Pcode),
                         i_Fact_Value    => p_Timesheet.Plan_Time,
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    end if;
  
    -- save free time fact only when it exists
    if v_Free_Time > 0 then
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                  i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free),
                         i_Fact_Value    => v_Free_Time,
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Free_Day
  (
    p_Timesheet       in out nocopy Htt_Timesheets%rowtype,
    p_Facts           in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Time_Parts      Htt_Pref.Time_Part_Nt,
    i_Begin_Late_Time date,
    i_Late_Input      date,
    i_Requests_Exist  boolean
  ) is
    v_Input      date;
    v_Output     date;
    v_Late_Input date := i_Late_Input;
  
    v_Has_Fd_Request         boolean := false;
    v_Fd_Rq_Time_Kind_Id     number;
    v_Fd_Request_Unused_Time varchar2(1);
  
    v_Rq_Request_Types     Array_Varchar2 := Array_Varchar2();
    v_Rq_Begin_Dates       Array_Date := Array_Date();
    v_Rq_End_Dates         Array_Date := Array_Date();
    v_Rq_Time_Kind_Ids     Array_Number := Array_Number();
    v_Rq_Parent_Ids        Array_Number := Array_Number();
    v_Rq_Unused_Times      Array_Varchar2 := Array_Varchar2();
    v_Rq_Intimes           Array_Number := Array_Number();
    v_Extra_Rq_Begin_Dates Array_Date := Array_Date();
    v_Extra_Rq_End_Dates   Array_Date := Array_Date();
  
    v_Earliest_Turnout_Rq_Begin date;
  
    v_Late_Time         number := 0;
    v_Excused_Late_Time number := 0;
  
    v_Lack_Time    number := 0;
    v_Omitted_Time number := 0;
  
    v_Extra_Begin_Late_Time   date := i_Begin_Late_Time +
                                      Numtodsinterval(p_Timesheet.Begin_Late_Time, 'second');
    v_Extra_Late_Time         number := 0;
    v_Excused_Extra_Late_Time number := 0;
  
    v_Request_Time          number := 0;
    v_Turnout_Requests_Time number := 0;
  
    v_Free_Time  number := 0;
    v_In_Time    number := 0;
    v_Beforework number := 0;
    v_Afterwork  number := 0;
    v_Lunchtime  number := 0;
  
    v_Time_Kind_Parent_Id  number;
    v_Turnout_Time_Kind_Id number;
  
    v_Calc               Calc := Calc();
    v_Request_Times_Keys Array_Varchar2;
    v_Plan_Time          number;
  begin
    v_Extra_Begin_Late_Time := Greatest(v_Extra_Begin_Late_Time, p_Timesheet.Shift_Begin_Time);
  
    -- TEMPORARY
    v_Plan_Time := p_Timesheet.Plan_Time;
  
    if i_Requests_Exist then
      Timesheet_Requests(i_Company_Id             => p_Timesheet.Company_Id,
                         i_Filial_Id              => p_Timesheet.Filial_Id,
                         i_Timesheet_Id           => p_Timesheet.Timesheet_Id,
                         i_Timesheet_Date         => p_Timesheet.Timesheet_Date,
                         i_Begin_Time             => p_Timesheet.Begin_Time,
                         i_End_Time               => p_Timesheet.End_Time,
                         i_Extra_Begin_Time       => v_Extra_Begin_Late_Time,
                         i_Extra_End_Time         => p_Timesheet.End_Time,
                         i_Calendar_Id            => p_Timesheet.Calendar_Id,
                         o_Has_Fd_Request         => v_Has_Fd_Request,
                         o_Fd_Rq_Time_Kind_Id     => v_Fd_Rq_Time_Kind_Id,
                         o_Fd_Request_Unused_Time => v_Fd_Request_Unused_Time,
                         o_Rq_Request_Types       => v_Rq_Request_Types,
                         o_Rq_Begin_Dates         => v_Rq_Begin_Dates,
                         o_Rq_End_Dates           => v_Rq_End_Dates,
                         o_Rq_Time_Kind_Ids       => v_Rq_Time_Kind_Ids,
                         o_Rq_Parent_Ids          => v_Rq_Parent_Ids,
                         o_Rq_Unused_Times        => v_Rq_Unused_Times,
                         o_Extra_Rq_Begin_Dates   => v_Extra_Rq_Begin_Dates,
                         o_Extra_Rq_End_Dates     => v_Extra_Rq_End_Dates);
    end if;
  
    -- timesheet with full day request with disabled unused time
    -- will ignore any facts except request on this timesheet
    -- e.g.: 
    -- let current day have full day request,
    --                      input (09:00) and output (18:00) tracks
    -- then 
    -- any facts generated from tracks will not be recorded
    -- they will not be included even free time time_kind
    if v_Has_Fd_Request and v_Fd_Request_Unused_Time = 'N' then
      -- eval full day request
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => v_Fd_Rq_Time_Kind_Id,
                         i_Fact_Value    => p_Timesheet.Plan_Time,
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
      return;
    end if;
  
    v_Turnout_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Rq_Intimes.Extend(v_Rq_Request_Types.Count);
  
    for i in 1 .. v_Rq_Intimes.Count
    loop
      v_Rq_Intimes(i) := 0;
    end loop;
  
    --ignore late time with requests
    if not v_Has_Fd_Request and v_Late_Input is not null then
      for i in 1 .. v_Rq_Request_Types.Count
      loop
        if v_Rq_Begin_Dates(i) between p_Timesheet.Begin_Time and v_Extra_Begin_Late_Time then
          v_Late_Input := null;
          exit;
        end if;
      end loop;
    end if;
  
    for i in 1 .. i_Time_Parts.Count
    loop
      v_Input  := i_Time_Parts(i).Input_Time;
      v_Output := i_Time_Parts(i).Output_Time;
    
      v_Free_Time := v_Free_Time + Htt_Util.Time_Diff(v_Output, v_Input);
    
      v_Lunchtime := v_Lunchtime +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.Break_Begin_Time,
                                                    i_Fr_End   => p_Timesheet.Break_End_Time,
                                                    i_Sc_Begin => v_Input,
                                                    i_Sc_End   => v_Output);
    
      v_Beforework := v_Beforework +
                      Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.Shift_Begin_Time,
                                                     i_Fr_End   => p_Timesheet.Begin_Time,
                                                     i_Sc_Begin => v_Input,
                                                     i_Sc_End   => v_Output);
    
      v_Afterwork := v_Afterwork +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.End_Time,
                                                    i_Fr_End   => p_Timesheet.Shift_End_Time,
                                                    i_Sc_Begin => v_Input,
                                                    i_Sc_End   => v_Output);
    
      v_In_Time := v_In_Time + Htt_Util.Calc_Intime(i_Begin_Time       => p_Timesheet.Begin_Time,
                                                    i_End_Time         => p_Timesheet.End_Time,
                                                    i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                    i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                                    i_Input            => v_Input,
                                                    i_Output           => v_Output);
    
      if not v_Has_Fd_Request or v_Fd_Request_Unused_Time = 'Y' then
        for j in 1 .. v_Rq_Request_Types.Count
        loop
          v_Rq_Intimes(j) := v_Rq_Intimes(j) +
                             Htt_Util.Calc_Intime(i_Begin_Time       => v_Rq_Begin_Dates(j),
                                                  i_End_Time         => v_Rq_End_Dates(j),
                                                  i_Begin_Break_Time => Greatest(v_Rq_Begin_Dates(j),
                                                                                 p_Timesheet.Break_Begin_Time),
                                                  i_End_Break_Time   => Least(v_Rq_End_Dates(j),
                                                                              p_Timesheet.Break_End_Time),
                                                  i_Input            => v_Input,
                                                  i_Output           => v_Output);
        end loop;
      end if;
    end loop;
  
    v_Earliest_Turnout_Rq_Begin := p_Timesheet.Begin_Time + 1;
  
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Time_Kind_Parent_Id := v_Rq_Parent_Ids(i);
    
      if v_Time_Kind_Parent_Id = v_Turnout_Time_Kind_Id and
         v_Extra_Rq_Begin_Dates(i) between Least(v_Extra_Begin_Late_Time, p_Timesheet.Begin_Time) and
         p_Timesheet.Input_Time then
        v_Earliest_Turnout_Rq_Begin := Least(v_Earliest_Turnout_Rq_Begin, v_Extra_Rq_Begin_Dates(i));
        exit;
      end if;
    end loop;
  
    -- calculate late time
    if v_Late_Input is not null then
      p_Timesheet.Input_Time := v_Late_Input;
    
      if v_Late_Input > v_Earliest_Turnout_Rq_Begin then
        v_Late_Input := v_Earliest_Turnout_Rq_Begin;
      end if;
    
      v_Late_Time := Htt_Util.Calc_Intime(i_Begin_Time       => i_Begin_Late_Time,
                                          i_End_Time         => v_Late_Input,
                                          i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                          i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                      v_Late_Input),
                                          i_Input            => i_Begin_Late_Time,
                                          i_Output           => v_Late_Input);
    
      v_Extra_Late_Time := Htt_Util.Calc_Intime(i_Begin_Time       => v_Extra_Begin_Late_Time,
                                                i_End_Time         => Least(i_Begin_Late_Time,
                                                                            v_Late_Input),
                                                i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                            v_Late_Input),
                                                i_Input            => v_Extra_Begin_Late_Time,
                                                i_Output           => Least(i_Begin_Late_Time,
                                                                            v_Late_Input));
    
      for i in 1 .. v_Rq_Request_Types.Count
      loop
        v_Excused_Late_Time := v_Excused_Late_Time +
                               Htt_Util.Calc_Intime(i_Begin_Time       => i_Begin_Late_Time,
                                                    i_End_Time         => v_Late_Input,
                                                    i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                    i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                                v_Late_Input),
                                                    i_Input            => v_Rq_Begin_Dates(i),
                                                    i_Output           => v_Rq_End_Dates(i));
      
        v_Excused_Extra_Late_Time := v_Excused_Extra_Late_Time +
                                     Htt_Util.Calc_Intime(i_Begin_Time       => v_Extra_Begin_Late_Time,
                                                          i_End_Time         => Least(i_Begin_Late_Time,
                                                                                      v_Late_Input),
                                                          i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                          i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                                      v_Late_Input),
                                                          i_Input            => v_Extra_Rq_Begin_Dates(i),
                                                          i_Output           => v_Extra_Rq_End_Dates(i));
      end loop;
    else
      v_Late_Time := 0;
    end if;
  
    -- eval part day requests
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Request_Time := Htt_Util.Time_Diff(v_Rq_End_Dates(i), v_Rq_Begin_Dates(i)) -
                        Htt_Util.Timeline_Intersection(i_Fr_Begin => v_Rq_Begin_Dates(i),
                                                       i_Fr_End   => v_Rq_End_Dates(i),
                                                       i_Sc_Begin => p_Timesheet.Break_Begin_Time,
                                                       i_Sc_End   => p_Timesheet.Break_End_Time);
    
      v_Plan_Time := v_Plan_Time - v_Request_Time;
    
      if v_Rq_Unused_Times(i) = 'N' then
        v_In_Time := v_In_Time - v_Rq_Intimes(i);
      end if;
    
      -- Temporary solutions
      if v_Rq_Unused_Times(i) = 'Y' then
        v_Plan_Time := v_Plan_Time + v_Rq_Intimes(i);
      end if;
    end loop;
  
    -- TEMPORARRY  
    v_Plan_Time := Greatest(v_Plan_Time, 0);
    v_In_Time   := Least(v_In_Time, v_Plan_Time);
  
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Time_Kind_Parent_Id := v_Rq_Parent_Ids(i);
    
      if v_Time_Kind_Parent_Id = v_Turnout_Time_Kind_Id then
        v_Request_Time := Htt_Util.Time_Diff(v_Rq_End_Dates(i), v_Rq_Begin_Dates(i)) -
                          Htt_Util.Timeline_Intersection(i_Fr_Begin => v_Rq_Begin_Dates(i),
                                                         i_Fr_End   => v_Rq_End_Dates(i),
                                                         i_Sc_Begin => p_Timesheet.Break_Begin_Time,
                                                         i_Sc_End   => p_Timesheet.Break_End_Time);
      
        if v_Rq_Unused_Times(i) = 'Y' then
          v_Request_Time := v_Request_Time - v_Rq_Intimes(i);
        else
          v_Free_Time := v_Free_Time - v_Rq_Intimes(i);
        end if;
      
        v_Turnout_Requests_Time := v_Turnout_Requests_Time + v_Request_Time;
      
        v_Calc.Plus(v_Rq_Time_Kind_Ids(i), v_Request_Time);
      end if;
    end loop;
  
    v_In_Time := Least(v_In_Time, p_Timesheet.Plan_Time);
  
    if v_In_Time + v_Turnout_Requests_Time > p_Timesheet.Plan_Time then
      if v_Turnout_Requests_Time > p_Timesheet.Plan_Time then
        v_In_Time := 0;
      else
        v_In_Time := p_Timesheet.Plan_Time - v_Turnout_Requests_Time;
      end if;
    end if;
  
    v_Omitted_Time := Greatest(p_Timesheet.Plan_Time - v_In_Time - v_Turnout_Requests_Time, 0);
  
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Time_Kind_Parent_Id := v_Rq_Parent_Ids(i);
    
      if v_Time_Kind_Parent_Id <> v_Turnout_Time_Kind_Id then
        v_Request_Time := Htt_Util.Time_Diff(v_Rq_End_Dates(i), v_Rq_Begin_Dates(i)) -
                          Htt_Util.Timeline_Intersection(i_Fr_Begin => v_Rq_Begin_Dates(i),
                                                         i_Fr_End   => v_Rq_End_Dates(i),
                                                         i_Sc_Begin => p_Timesheet.Break_Begin_Time,
                                                         i_Sc_End   => p_Timesheet.Break_End_Time);
      
        if v_Rq_Unused_Times(i) = 'Y' then
          v_Request_Time := v_Request_Time - v_Rq_Intimes(i);
        end if;
      
        v_Request_Time := Least(v_Request_Time, v_Omitted_Time);
        v_Omitted_Time := v_Omitted_Time - v_Request_Time;
      
        v_Calc.Plus(v_Rq_Time_Kind_Ids(i), v_Request_Time);
      end if;
    end loop;
  
    v_Request_Times_Keys := v_Calc.Keyset;
  
    for i in 1 .. v_Request_Times_Keys.Count
    loop
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => v_Request_Times_Keys(i),
                         i_Fact_Value    => v_Calc.Get_Value(v_Request_Times_Keys(i)),
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    end loop;
  
    if p_Timesheet.Count_Lack = 'Y' then
      v_Lack_Time := v_Omitted_Time - (v_Late_Time - v_Excused_Late_Time);
    end if;
  
    v_Late_Time := v_Late_Time + v_Extra_Late_Time - v_Excused_Late_Time -
                   v_Excused_Extra_Late_Time;
    v_Free_Time := v_Free_Time - v_In_Time - v_Lunchtime - v_Beforework - v_Afterwork;
  
    if p_Timesheet.Count_Free = 'N' then
      v_Free_Time  := 0;
      v_Lunchtime  := 0;
      v_Beforework := 0;
      v_Afterwork  := 0;
    end if;
  
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => v_Turnout_Time_Kind_Id,
                       i_Fact_Value    => v_In_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early),
                       i_Fact_Value    => 0,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late),
                       i_Fact_Value    => v_Late_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack),
                       i_Fact_Value    => v_Lack_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free_Inside),
                       i_Fact_Value    => v_Free_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime),
                       i_Fact_Value    => v_Lunchtime,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work),
                       i_Fact_Value    => v_Beforework,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work),
                       i_Fact_Value    => v_Afterwork,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts_Work_Day
  (
    p_Timesheet      in out nocopy Htt_Timesheets%rowtype,
    p_Facts          in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    p_Intervals      in out nocopy Htt_Pref.Timesheet_Interval_Nt,
    i_Time_Parts     Htt_Pref.Time_Part_Nt,
    i_Late_Input     date,
    i_Early_Output   date,
    i_Requests_Exist boolean
  ) is
    v_Input        date;
    v_Output       date;
    v_Late_Input   date := i_Late_Input;
    v_Early_Output date := i_Early_Output;
  
    v_Has_Fd_Request         boolean := false;
    v_Fd_Rq_Time_Kind_Id     number;
    v_Fd_Request_Unused_Time varchar2(1);
  
    v_Rq_Request_Types     Array_Varchar2 := Array_Varchar2();
    v_Rq_Begin_Dates       Array_Date := Array_Date();
    v_Rq_End_Dates         Array_Date := Array_Date();
    v_Rq_Time_Kind_Ids     Array_Number := Array_Number();
    v_Rq_Parent_Ids        Array_Number := Array_Number();
    v_Rq_Unused_Times      Array_Varchar2 := Array_Varchar2();
    v_Rq_Intimes           Array_Number := Array_Number();
    v_Extra_Rq_Begin_Dates Array_Date := Array_Date();
    v_Extra_Rq_End_Dates   Array_Date := Array_Date();
  
    v_Earliest_Turnout_Rq_Begin date;
  
    v_Late_Time  number := 0;
    v_Early_Time number := 0;
    v_Lack_Time  number := 0;
  
    v_Extra_Late_Time          number := 0;
    v_Extra_Early_Time         number := 0;
    v_Excused_Extra_Late_Time  number := 0;
    v_Excused_Extra_Early_Time number := 0;
  
    v_Excused_Late_Time  number := 0;
    v_Excused_Early_Time number := 0;
    v_Excused_Lack_Time  number := 0;
  
    v_Begin_Late interval day to second := Numtodsinterval(p_Timesheet.Begin_Late_Time, 'second');
    v_End_Early  interval day to second := Numtodsinterval(p_Timesheet.End_Early_Time, 'second');
  
    v_Begin_Late_Time date := Greatest(p_Timesheet.Shift_Begin_Time,
                                       p_Timesheet.Begin_Time + v_Begin_Late);
    v_End_Early_Time  date := Least(p_Timesheet.Shift_End_Time, p_Timesheet.End_Time + v_End_Early);
  
    v_Time_Kind_Parent_Id  number;
    v_Turnout_Time_Kind_Id number;
  
    v_Request_Time      number := 0;
    v_Free_Time         number := 0;
    v_In_Time           number := 0;
    v_Beforework        number := 0;
    v_Afterwork         number := 0;
    v_Lunchtime         number := 0;
    v_Used_Request_Time number := 0;
  
    v_Interval_Begin    date;
    v_Interval_End      date;
    v_Rq_Interval_Begin Array_Date := Array_Date();
    v_Rq_Interval_End   Array_Date := Array_Date();
  
    v_Calc               Calc := Calc();
    v_Request_Times_Keys Array_Varchar2;
  begin
    if i_Requests_Exist then
      Timesheet_Requests(i_Company_Id             => p_Timesheet.Company_Id,
                         i_Filial_Id              => p_Timesheet.Filial_Id,
                         i_Timesheet_Id           => p_Timesheet.Timesheet_Id,
                         i_Timesheet_Date         => p_Timesheet.Timesheet_Date,
                         i_Begin_Time             => p_Timesheet.Begin_Time,
                         i_End_Time               => p_Timesheet.End_Time,
                         i_Extra_Begin_Time       => v_Begin_Late_Time,
                         i_Extra_End_Time         => v_End_Early_Time,
                         i_Calendar_Id            => p_Timesheet.Calendar_Id,
                         o_Has_Fd_Request         => v_Has_Fd_Request,
                         o_Fd_Request_Unused_Time => v_Fd_Request_Unused_Time,
                         o_Fd_Rq_Time_Kind_Id     => v_Fd_Rq_Time_Kind_Id,
                         o_Rq_Request_Types       => v_Rq_Request_Types,
                         o_Rq_Begin_Dates         => v_Rq_Begin_Dates,
                         o_Rq_End_Dates           => v_Rq_End_Dates,
                         o_Rq_Unused_Times        => v_Rq_Unused_Times,
                         o_Rq_Time_Kind_Ids       => v_Rq_Time_Kind_Ids,
                         o_Rq_Parent_Ids          => v_Rq_Parent_Ids,
                         o_Extra_Rq_Begin_Dates   => v_Extra_Rq_Begin_Dates,
                         o_Extra_Rq_End_Dates     => v_Extra_Rq_End_Dates);
    end if;
  
    -- timesheet with full day request with disabled unused time
    -- will ignore any facts except request on this timesheet
    -- e.g.: 
    -- let current day have full day request,
    --                      input (09:00) and output (18:00) tracks
    -- then 
    -- any facts generated from tracks will not be recorded
    -- they will not be included even free time time_kind
    if v_Has_Fd_Request and v_Fd_Request_Unused_Time = 'N' then
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => v_Fd_Rq_Time_Kind_Id,
                         i_Fact_Value    => p_Timesheet.Plan_Time,
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
      return;
    end if;
  
    v_Turnout_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Rq_Intimes.Extend(v_Rq_Request_Types.Count);
    v_Rq_Interval_Begin.Extend(v_Rq_Request_Types.Count);
    v_Rq_Interval_End.Extend(v_Rq_Request_Types.Count);
  
    for i in 1 .. v_Rq_Intimes.Count
    loop
      v_Rq_Intimes(i) := 0;
    
      v_Rq_Interval_Begin(i) := v_Rq_Begin_Dates(i);
      v_Rq_Interval_End(i) := v_Rq_End_Dates(i);
    end loop;
  
    for i in 1 .. i_Time_Parts.Count
    loop
      v_Input  := i_Time_Parts(i).Input_Time;
      v_Output := i_Time_Parts(i).Output_Time;
    
      v_Interval_Begin := Greatest(v_Input, p_Timesheet.Begin_Time);
      v_Interval_End   := Least(v_Output, p_Timesheet.End_Time);
    
      v_Free_Time := v_Free_Time + Htt_Util.Time_Diff(v_Output, v_Input);
    
      v_Lunchtime := v_Lunchtime +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.Break_Begin_Time,
                                                    i_Fr_End   => p_Timesheet.Break_End_Time,
                                                    i_Sc_Begin => v_Input,
                                                    i_Sc_End   => v_Output);
    
      v_Beforework := v_Beforework +
                      Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.Shift_Begin_Time,
                                                     i_Fr_End   => p_Timesheet.Begin_Time,
                                                     i_Sc_Begin => v_Input,
                                                     i_Sc_End   => v_Output);
    
      v_Afterwork := v_Afterwork +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => p_Timesheet.End_Time,
                                                    i_Fr_End   => p_Timesheet.Shift_End_Time,
                                                    i_Sc_Begin => v_Input,
                                                    i_Sc_End   => v_Output);
    
      v_In_Time := v_In_Time + Htt_Util.Calc_Intime(i_Begin_Time       => p_Timesheet.Begin_Time,
                                                    i_End_Time         => p_Timesheet.End_Time,
                                                    i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                    i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                                    i_Input            => v_Input,
                                                    i_Output           => v_Output);
    
      if not v_Has_Fd_Request or v_Fd_Request_Unused_Time = 'Y' then
        for j in 1 .. v_Rq_Request_Types.Count
        loop
          v_Rq_Intimes(j) := v_Rq_Intimes(j) +
                             Htt_Util.Calc_Intime(i_Begin_Time       => v_Rq_Begin_Dates(j),
                                                  i_End_Time         => v_Rq_End_Dates(j),
                                                  i_Begin_Break_Time => Greatest(v_Rq_Begin_Dates(j),
                                                                                 p_Timesheet.Break_Begin_Time),
                                                  i_End_Break_Time   => Least(v_Rq_End_Dates(j),
                                                                              p_Timesheet.Break_End_Time),
                                                  i_Input            => v_Input,
                                                  i_Output           => v_Output);
        
          if v_Rq_Unused_Times(j) = 'N' then
            Push_Intersect_Intervals(p_Intervals       => p_Intervals,
                                     p_Interval_Begin  => v_Interval_Begin,
                                     p_Interval_End    => v_Interval_End,
                                     i_Timesheet       => p_Timesheet,
                                     i_Intersect_Begin => v_Rq_Begin_Dates(j),
                                     i_Intersect_End   => v_Rq_End_Dates(j));
          elsif v_Rq_Parent_Ids(j) = v_Turnout_Time_Kind_Id then
            Push_Intersect_Intervals(p_Intervals       => p_Intervals,
                                     p_Interval_Begin  => v_Rq_Interval_Begin(j),
                                     p_Interval_End    => v_Rq_Interval_End(j),
                                     i_Timesheet       => p_Timesheet,
                                     i_Intersect_Begin => v_Input,
                                     i_Intersect_End   => v_Output);
          end if;
        end loop;
      end if;
    
      if v_Interval_Begin < v_Interval_End then
        Push_Interval(p_Intervals      => p_Intervals,
                      i_Timesheet      => p_Timesheet,
                      i_Interval_Begin => v_Interval_Begin,
                      i_Interval_End   => v_Interval_End);
      end if;
    end loop;
  
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      continue when v_Rq_Parent_Ids(i) <> v_Turnout_Time_Kind_Id;
      continue when v_Rq_Interval_Begin(i) >= v_Rq_Interval_End(i);
    
      Push_Interval(p_Intervals      => p_Intervals,
                    i_Timesheet      => p_Timesheet,
                    i_Interval_Begin => v_Rq_Interval_Begin(i),
                    i_Interval_End   => v_Rq_Interval_End(i));
    end loop;
  
    v_Earliest_Turnout_Rq_Begin := p_Timesheet.Begin_Time + 1;
  
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Time_Kind_Parent_Id := v_Rq_Parent_Ids(i);
    
      if v_Time_Kind_Parent_Id = v_Turnout_Time_Kind_Id and
         v_Extra_Rq_Begin_Dates(i) between v_Begin_Late_Time and p_Timesheet.Input_Time then
        v_Earliest_Turnout_Rq_Begin := Least(v_Earliest_Turnout_Rq_Begin, v_Extra_Rq_Begin_Dates(i));
        exit;
      end if;
    end loop;
  
    -- calculate late time
    if v_Late_Input is not null then
      p_Timesheet.Input_Time := v_Late_Input;
    
      if v_Late_Input > v_Earliest_Turnout_Rq_Begin then
        v_Late_Input := v_Earliest_Turnout_Rq_Begin;
      end if;
    
      v_Late_Time := Htt_Util.Calc_Intime(i_Begin_Time       => p_Timesheet.Begin_Time,
                                          i_End_Time         => v_Late_Input,
                                          i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                          i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                      v_Late_Input),
                                          i_Input            => p_Timesheet.Begin_Time,
                                          i_Output           => v_Late_Input);
    
      v_Extra_Late_Time := Htt_Util.Calc_Intime(i_Begin_Time       => v_Begin_Late_Time,
                                                i_End_Time         => Least(v_Late_Input,
                                                                            p_Timesheet.Begin_Time),
                                                i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                            Least(v_Late_Input,
                                                                                  p_Timesheet.Begin_Time)),
                                                i_Input            => v_Begin_Late_Time,
                                                i_Output           => Least(v_Late_Input,
                                                                            p_Timesheet.Begin_Time));
    
      for i in 1 .. v_Rq_Request_Types.Count
      loop
        v_Excused_Late_Time := v_Excused_Late_Time +
                               Htt_Util.Calc_Intime(i_Begin_Time       => p_Timesheet.Begin_Time,
                                                    i_End_Time         => v_Late_Input,
                                                    i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                    i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                                v_Late_Input),
                                                    i_Input            => v_Rq_Begin_Dates(i),
                                                    i_Output           => v_Rq_End_Dates(i));
      
        v_Excused_Extra_Late_Time := v_Excused_Extra_Late_Time +
                                     Htt_Util.Calc_Intime(i_Begin_Time       => v_Begin_Late_Time,
                                                          i_End_Time         => Least(v_Late_Input,
                                                                                      p_Timesheet.Begin_Time),
                                                          i_Begin_Break_Time => p_Timesheet.Break_Begin_Time,
                                                          i_End_Break_Time   => Least(p_Timesheet.Break_End_Time,
                                                                                      Least(v_Late_Input,
                                                                                            p_Timesheet.Begin_Time)),
                                                          i_Input            => v_Extra_Rq_Begin_Dates(i),
                                                          i_Output           => v_Extra_Rq_End_Dates(i));
      end loop;
    end if;
  
    -- calculate early time
    if v_Early_Output is not null then
      p_Timesheet.Output_Time := v_Early_Output;
    
      v_Early_Time := Htt_Util.Calc_Intime(i_Begin_Time       => v_Early_Output,
                                           i_End_Time         => p_Timesheet.End_Time,
                                           i_Begin_Break_Time => Greatest(p_Timesheet.Break_Begin_Time,
                                                                          v_Early_Output),
                                           i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                           i_Input            => v_Early_Output,
                                           i_Output           => p_Timesheet.End_Time);
    
      v_Extra_Early_Time := Htt_Util.Calc_Intime(i_Begin_Time       => Greatest(v_Early_Output,
                                                                                p_Timesheet.End_Time),
                                                 i_End_Time         => v_End_Early_Time,
                                                 i_Begin_Break_Time => Greatest(p_Timesheet.Break_Begin_Time,
                                                                                v_Early_Output),
                                                 i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                                 i_Input            => Greatest(v_Early_Output,
                                                                                p_Timesheet.End_Time),
                                                 i_Output           => v_End_Early_Time);
    
      for i in 1 .. v_Rq_Request_Types.Count
      loop
        v_Excused_Early_Time := v_Excused_Early_Time +
                                Htt_Util.Calc_Intime(i_Begin_Time       => v_Early_Output,
                                                     i_End_Time         => p_Timesheet.End_Time,
                                                     i_Begin_Break_Time => Greatest(p_Timesheet.Break_Begin_Time,
                                                                                    v_Early_Output),
                                                     i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                                     i_Input            => v_Rq_Begin_Dates(i),
                                                     i_Output           => v_Rq_End_Dates(i));
      
        v_Excused_Extra_Early_Time := v_Excused_Extra_Early_Time +
                                      Htt_Util.Calc_Intime(i_Begin_Time       => Greatest(v_Early_Output,
                                                                                          p_Timesheet.End_Time),
                                                           i_End_Time         => v_End_Early_Time,
                                                           i_Begin_Break_Time => Greatest(p_Timesheet.Break_Begin_Time,
                                                                                          Greatest(v_Early_Output,
                                                                                                   p_Timesheet.End_Time)),
                                                           i_End_Break_Time   => p_Timesheet.Break_End_Time,
                                                           i_Input            => v_Extra_Rq_Begin_Dates(i),
                                                           i_Output           => v_Extra_Rq_End_Dates(i));
      end loop;
    end if;
  
    -- eval part day requests
    for i in 1 .. v_Rq_Request_Types.Count
    loop
      v_Request_Time := Htt_Util.Time_Diff(v_Rq_End_Dates(i), v_Rq_Begin_Dates(i)) -
                        Htt_Util.Timeline_Intersection(i_Fr_Begin => v_Rq_Begin_Dates(i),
                                                       i_Fr_End   => v_Rq_End_Dates(i),
                                                       i_Sc_Begin => p_Timesheet.Break_Begin_Time,
                                                       i_Sc_End   => p_Timesheet.Break_End_Time);
    
      if v_Rq_Unused_Times(i) = 'Y' then
        v_Request_Time := v_Request_Time - v_Rq_Intimes(i);
      else
        v_In_Time := v_In_Time - v_Rq_Intimes(i);
      
        v_Time_Kind_Parent_Id := v_Rq_Parent_Ids(i);
      
        if v_Time_Kind_Parent_Id = v_Turnout_Time_Kind_Id then
          v_Free_Time := v_Free_Time - v_Rq_Intimes(i);
        end if;
      end if;
    
      v_Used_Request_Time := v_Used_Request_Time + v_Request_Time;
    
      v_Calc.Plus(v_Rq_Time_Kind_Ids(i), v_Request_Time);
    end loop;
  
    v_Request_Times_Keys := v_Calc.Keyset;
  
    for i in 1 .. v_Request_Times_Keys.Count
    loop
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => v_Request_Times_Keys(i),
                         i_Fact_Value    => v_Calc.Get_Value(v_Request_Times_Keys(i)),
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    end loop;
  
    -- calculate lack time
    if p_Timesheet.Count_Lack = 'Y' then
      v_Lack_Time         := p_Timesheet.Plan_Time - v_In_Time - v_Late_Time - v_Early_Time;
      v_Excused_Lack_Time := v_Used_Request_Time - v_Excused_Late_Time - v_Excused_Early_Time;
    end if;
  
    -- eval result
    v_Early_Time := v_Early_Time - v_Excused_Early_Time + v_Extra_Early_Time -
                    v_Excused_Extra_Early_Time;
    v_Late_Time  := v_Late_Time - v_Excused_Late_Time + v_Extra_Late_Time -
                    v_Excused_Extra_Late_Time;
    v_Lack_Time  := v_Lack_Time - v_Excused_Lack_Time;
    v_Free_Time  := v_Free_Time - v_In_Time - v_Lunchtime - v_Beforework - v_Afterwork;
  
    if p_Timesheet.Count_Free = 'N' then
      v_Free_Time  := 0;
      v_Lunchtime  := 0;
      v_Beforework := 0;
      v_Afterwork  := 0;
    end if;
  
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => v_Turnout_Time_Kind_Id,
                       i_Fact_Value    => v_In_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early),
                       i_Fact_Value    => v_Early_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late),
                       i_Fact_Value    => v_Late_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack),
                       i_Fact_Value    => v_Lack_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free),
                       i_Fact_Value    => v_Free_Time,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime),
                       i_Fact_Value    => v_Lunchtime,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work),
                       i_Fact_Value    => v_Beforework,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    Gen_Timesheet_Fact(p_Facts         => p_Facts,
                       i_Company_Id    => p_Timesheet.Company_Id,
                       i_Filial_Id     => p_Timesheet.Filial_Id,
                       i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                       i_Time_Kind_Id  => Htt_Util.Time_Kind_Id(i_Company_Id => p_Timesheet.Company_Id,
                                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work),
                       i_Fact_Value    => v_Afterwork,
                       i_Schedule_Kind => p_Timesheet.Schedule_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Fact
  (
    p_Facts         in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Timesheet_Id  number,
    i_Time_Kind_Id  number,
    i_Fact_Value    number,
    i_Schedule_Kind varchar2
  ) is
    r_Timesheet Htt_Timesheets%rowtype;
  begin
    if i_Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly and
       i_Time_Kind_Id <>
       Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free) and
       i_Fact_Value > 86400 then
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Timesheet_Id => i_Timesheet_Id);
    
      Htt_Error.Raise_004(i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => r_Timesheet.Company_Id,
                                                                   i_Filial_Id  => r_Timesheet.Filial_Id,
                                                                   i_Staff_Id   => r_Timesheet.Staff_Id),
                          i_Timesheet_Date => r_Timesheet.Timesheet_Date,
                          i_Time_Kind_Name => z_Htt_Time_Kinds.Load(i_Company_Id => i_Company_Id, --
                                              i_Time_Kind_Id => i_Time_Kind_Id).Name);
    end if;
  
    Htt_Util.Timesheet_Fact_Add(o_Facts        => p_Facts,
                                i_Company_Id   => i_Company_Id,
                                i_Filial_Id    => i_Filial_Id,
                                i_Timesheet_Id => i_Timesheet_Id,
                                i_Time_Kind_Id => i_Time_Kind_Id,
                                i_Fact_Value   => i_Fact_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Timesheet_Facts
  (
    p_Facts     in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    p_Intervals in out nocopy Htt_Pref.Timesheet_Interval_Nt
  ) is
  begin
    forall i in 1 .. p_Facts.Count
      insert into Htt_Timesheet_Facts
        (Company_Id, Filial_Id, Timesheet_Id, Time_Kind_Id, Fact_Value)
      values
        (p_Facts(i).Company_Id,
         p_Facts(i).Filial_Id,
         p_Facts(i).Timesheet_Id,
         p_Facts(i).Time_Kind_Id,
         p_Facts(i).Fact_Value);
  
    forall i in 1 .. p_Intervals.Count
      insert into Htt_Timesheet_Intervals
        (Company_Id, Filial_Id, Interval_Id, Timesheet_Id, Interval_Begin, Interval_End)
      values
        (p_Intervals(i).Company_Id,
         p_Intervals(i).Filial_Id,
         p_Intervals(i).Interval_Id,
         p_Intervals(i).Timesheet_Id,
         p_Intervals(i).Interval_Begin,
         p_Intervals(i).Interval_End);
  
    p_Facts     := Htt_Pref.Timesheet_Fact_Nt();
    p_Intervals := Htt_Pref.Timesheet_Interval_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  -- transforms check tracks to input/output/merger/potential output
  -- one track should be transformed only once

  -- merger transformation rules:
  -- <ul>
  --     <li>merger exists only with flexible schedules</li>
  --     <li>only two mergers per timesheet: input/output merger</li>
  --     <li>input merger exists only when previous day is working and ends within merger area</li>
  --     <li>output merger exists only when next day is working and starts within merger area</li>
  --     <li>input merger disabled when output exists in [shift_begin - merger_interval, shift_begin]</li>
  --     <li>input merger disabled when input exists in [shift_begin, shift_begin + merger_interval]</li>
  --     <li>output merger disabled when output exists in [shift_end - merger_interval, shift_end ]</li>
  --     <li>output merger disabled when input exists in [shift_end, shift_end + merger_interval]</li>
  --     <li>only first check that falls into merger area is transformed to merger</li>
  --     <li>these rules guarantee that merger will be last input and first output in merger area</li>
  -- </ul>

  -- input transformation rules:
  -- <ul>
  --     <li>input merger must be nonexistent</li>
  --     <li>must have trans_intput track setting set to (Y)es (taken from device at creation time)</li>
  --     <li>must be first track inside shift ([shift_begin, shift_end])</li>
  --     <li>must be check track</li>
  -- </ul>

  -- output transformation rules:
  -- <ul>
  --     <li>output merger must be nonexistent</li>
  --     <li>must have trans_output track setting set to (Y)es (taken from device at creation time)</li>
  --     <li>must be last track inside shift ([shift_begin, shift_end])</li>
  --     <li>must be check track</li>
  --     <li>must be different from track transformed to input</li>
  -- </ul>

  -- %example 1
  -- let begin_time := shift_begin := 01.01.2023 09:00;
  -- let end_time   := shift_end   := 02.01.2023 09:00;
  -- let input_border := 01.01.2023 08:45; #enabling input merger area since input_border <> shift_begin
  -- let output_border := 02.01.2023 09:15; #enabling output merger area since output_border <> shift_end
  -- let track_1 := 01.01.2023 08:50; #check track type
  -- let track_2 := 02.01.2023 09:10; #check track type
  -- then
  -- track_1_type transformed to merger
  -- track_2_type transformed to merger

  -- %example 2
  -- let begin_time := shift_begin := 01.01.2023 09:00;
  -- let end_time   := shift_end   := 02.01.2023 09:00;
  -- let input_border := 01.01.2023 08:45; #enabling input merger area since input_border <> shift_begin
  -- let output_border := 02.01.2023 09:15; #enabling output merger area since output_border <> shift_end
  -- let track_1 := 01.01.2023 08:50; #check track type
  -- then
  -- track_1_type transformed to merger

  -- %example 3
  -- let begin_time := shift_begin := 31.12.2023 09:00;
  -- let end_time   := shift_end   := 01.01.2023 09:00;
  -- let input_border := 31.12.2023 08:45; #enabling input merger area since input_border <> shift_begin
  -- let output_border := 01.01.2023 09:15; #enabling output merger area since output_border <> shift_end
  -- let track_1 := 01.01.2023 08:50; #check track type
  -- then
  -- track_1_type transformed to merger  

  -- %example 4
  -- let begin_time := shift_begin := 01.01.2023 09:00;
  -- let end_time   := shift_end   := 02.01.2023 09:00;
  -- let input_border := 01.01.2023 08:45; #enabling input merger area since input_border <> shift_begin
  -- let output_border := 02.01.2023 09:15; #enabling output merger area since output_border <> shift_end
  -- let track_1 := 01.01.2023 08:50; #check track type
  -- let track_2 := 01.01.2023 09:10; #input track type
  -- then
  -- track_1_type remains check
  -- track_2_type remains input

  -- %example 5
  -- let begin_time := shift_begin := 31.12.2022 09:00;
  -- let end_time   := shift_end   := 01.01.2023 09:00;
  -- let input_border := 31.12.2022 08:45; #enabling input merger area since input_border <> shift_begin
  -- let output_border := 01.01.2023 09:15; #enabling output merger area since output_border <> shift_end
  -- let track_1 := 01.01.2023 08:50; #check track type
  -- let track_2 := 01.01.2023 09:10; #input track type
  -- then
  -- track_1_type transformed to input
  -- track_2_type remains input

  Procedure Transform_Check_Tracks
  (
    p_Tracks       in out nocopy Htt_Pref.Timesheet_Track_Nt,
    p_Trans_Tracks in out nocopy Htt_Pref.Timesheet_Track_Nt,
    i_Timesheet    Htt_Timesheets%rowtype
  ) is
    v_Track             Htt_Pref.Timesheet_Track_Rt;
    v_Has_Input_Merger  boolean := false;
    v_Has_Output_Merger boolean := false;
    v_Allow_Trans_Input boolean := true;
    v_Input_Merger_Idx  number;
    v_Output_Merger_Idx number;
    v_Trans_Input_Idx   number;
    v_Trans_Output_Idx  number;
    v_Merger_Interval   interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                  'second');
    v_Check_Trans_Idxs  Array_Number := Array_Number();
    v_Check_Trans_Type  varchar2(1);
  
    v_Trans_Track_Output_Idx number;
  
    --------------------------------------------------
    Procedure Transform_To_Check(i_Allow_Potential boolean := false) is
      v_Trans_Track Htt_Pref.Timesheet_Track_Rt;
    begin
      if v_Check_Trans_Idxs.Count = 0 then
        return;
      end if;
    
      for i in 1 .. v_Check_Trans_Idxs.Count - 1
      loop
        v_Trans_Track := p_Tracks(v_Check_Trans_Idxs(i));
      
        v_Trans_Track.Track_Type := Htt_Pref.c_Track_Type_Check;
      
        p_Tracks(v_Check_Trans_Idxs(i)) := v_Trans_Track;
      
        p_Trans_Tracks.Extend;
        p_Trans_Tracks(p_Trans_Tracks.Count) := v_Trans_Track;
      end loop;
    
      if i_Allow_Potential then
        v_Trans_Track := p_Tracks(v_Check_Trans_Idxs(v_Check_Trans_Idxs.Count));
      
        if v_Trans_Track.Track_Type = Htt_Pref.c_Track_Type_Output and
           i_Timesheet.End_Time is not null and Greatest(v_Trans_Track.Track_Datetime,
                                                         Htt_Util.Get_Current_Date(i_Company_Id => i_Timesheet.Company_Id, --
                                                                                   i_Filial_Id  => i_Timesheet.Filial_Id)) <
           i_Timesheet.End_Time then
          v_Trans_Track.Track_Type := Htt_Pref.c_Track_Type_Potential_Output;
        
          p_Tracks(v_Check_Trans_Idxs(v_Check_Trans_Idxs.Count)) := v_Trans_Track;
        
          p_Trans_Tracks.Extend;
          p_Trans_Tracks(p_Trans_Tracks.Count) := v_Trans_Track;
        end if;
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Transform_Gps_Output is
      v_Transformable boolean := false;
    begin
      if i_Timesheet.Gps_Turnout_Enabled = 'N' or v_Output_Merger_Idx is not null then
        return;
      end if;
    
      v_Transformable := Htt_Util.Get_Current_Date(i_Company_Id => i_Timesheet.Company_Id,
                                                   i_Filial_Id  => i_Timesheet.Filial_Id) <
                         i_Timesheet.Output_Border;
    
      for i in 1 .. p_Tracks.Count
      loop
        v_Track := p_Tracks(i);
      
        continue when v_Track.Track_Datetime not between i_Timesheet.Shift_Begin_Time and i_Timesheet.Shift_End_Time;
      
        if v_Track.Track_Type = Htt_Pref.c_Track_Type_Output and v_Transformable then
          v_Track.Track_Type := Htt_Pref.c_Track_Type_Gps_Output;
        
          p_Tracks(i) := v_Track;
        
          if v_Trans_Output_Idx = i then
            p_Trans_Tracks(v_Trans_Track_Output_Idx) := v_Track;
          else
            p_Trans_Tracks.Extend;
            p_Trans_Tracks(p_Trans_Tracks.Count) := v_Track;
          end if;
        end if;
      end loop;
    end;
  
  begin
    if i_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
      return;
    end if;
  
    if i_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
      v_Has_Input_Merger  := i_Timesheet.Shift_Begin_Time <> i_Timesheet.Input_Border;
      v_Has_Output_Merger := i_Timesheet.Shift_End_Time <> i_Timesheet.Output_Border;
    end if;
  
    for i in 1 .. p_Tracks.Count
    loop
      v_Track := p_Tracks(i);
    
      if v_Has_Input_Merger and --
         v_Track.Track_Type = Htt_Pref.c_Track_Type_Check and v_Input_Merger_Idx is null and --
         v_Track.Track_Datetime between --
         i_Timesheet.Shift_Begin_Time - v_Merger_Interval and
         i_Timesheet.Shift_Begin_Time + v_Merger_Interval then
        v_Input_Merger_Idx := i;
      end if;
    
      if v_Has_Output_Merger and --
         v_Track.Track_Type = Htt_Pref.c_Track_Type_Check and Nvl(v_Input_Merger_Idx, -1) <> i and
         v_Output_Merger_Idx is null and --
         v_Track.Track_Datetime between --
         i_Timesheet.Shift_End_Time - v_Merger_Interval and
         i_Timesheet.Shift_End_Time + v_Merger_Interval then
        v_Output_Merger_Idx := i;
      end if;
    
      if v_Allow_Trans_Input and --
         v_Track.Track_Datetime between i_Timesheet.Shift_Begin_Time and i_Timesheet.Shift_End_Time then
        if v_Track.Track_Type = Htt_Pref.c_Track_Type_Check and v_Trans_Input_Idx is null and
           v_Track.Trans_Input = 'Y' then
          v_Trans_Input_Idx := i;
        else
          v_Allow_Trans_Input := false;
        end if;
      end if;
    
      if v_Track.Track_Datetime between i_Timesheet.Shift_Begin_Time and i_Timesheet.Shift_End_Time then
        v_Trans_Output_Idx := null;
      
        if v_Track.Track_Type = Htt_Pref.c_Track_Type_Check and --
           v_Track.Trans_Output = 'Y' then
          v_Trans_Output_Idx := i;
        end if;
      end if;
    
      if v_Check_Trans_Idxs.Count > 0 and
         (not Fazo.Equal(v_Check_Trans_Type, v_Track.Track_Type) or v_Track.Trans_Check = 'N') then
        Transform_To_Check;
      
        v_Check_Trans_Idxs := Array_Number();
        v_Check_Trans_Type := null;
      end if;
    
      if v_Track.Track_Datetime between i_Timesheet.Shift_Begin_Time and i_Timesheet.Shift_End_Time and
         v_Track.Track_Type in (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output) and
         v_Track.Trans_Check = 'Y' then
        v_Check_Trans_Type := v_Track.Track_Type;
        Fazo.Push(v_Check_Trans_Idxs, i);
      end if;
    end loop;
  
    Transform_To_Check(true);
  
    if v_Input_Merger_Idx is not null then
      v_Track := p_Tracks(v_Input_Merger_Idx);
    
      p_Tracks(v_Input_Merger_Idx) := p_Tracks(1);
    
      v_Track.Track_Datetime := i_Timesheet.Shift_Begin_Time;
      v_Track.Track_Type     := Htt_Pref.c_Track_Type_Merger;
    
      p_Tracks(1) := v_Track;
    
      p_Trans_Tracks.Extend;
      p_Trans_Tracks(p_Trans_Tracks.Count) := v_Track;
    
      v_Trans_Input_Idx := null;
    
      if v_Input_Merger_Idx = v_Trans_Output_Idx then
        v_Trans_Output_Idx := null;
      end if;
    end if;
  
    if v_Output_Merger_Idx is not null then
      v_Track := p_Tracks(v_Output_Merger_Idx);
    
      p_Tracks(v_Output_Merger_Idx) := p_Tracks(p_Tracks.Count);
    
      v_Track.Track_Datetime := i_Timesheet.Shift_End_Time;
      v_Track.Track_Type     := Htt_Pref.c_Track_Type_Merger;
    
      p_Tracks(p_Tracks.Count) := v_Track;
    
      p_Trans_Tracks.Extend;
      p_Trans_Tracks(p_Trans_Tracks.Count) := v_Track;
    
      v_Trans_Output_Idx := null;
    
      if v_Output_Merger_Idx = v_Trans_Input_Idx then
        v_Trans_Input_Idx := null;
      end if;
    end if;
  
    if v_Trans_Input_Idx is not null then
      v_Track := p_Tracks(v_Trans_Input_Idx);
    
      v_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
    
      p_Tracks(v_Trans_Input_Idx) := v_Track;
    
      p_Trans_Tracks.Extend;
      p_Trans_Tracks(p_Trans_Tracks.Count) := v_Track;
    
      if v_Trans_Output_Idx = v_Trans_Input_Idx then
        v_Trans_Output_Idx := null;
      end if;
    end if;
  
    if v_Trans_Output_Idx is not null then
      v_Track := p_Tracks(v_Trans_Output_Idx);
    
      if Greatest(v_Track.Track_Datetime,
                  Htt_Util.Get_Current_Date(i_Company_Id => i_Timesheet.Company_Id, --
                                            i_Filial_Id  => i_Timesheet.Filial_Id)) >
         i_Timesheet.End_Time or i_Timesheet.End_Time is null then
        v_Track.Track_Type := Htt_Pref.c_Track_Type_Output;
      else
        v_Track.Track_Type := Htt_Pref.c_Track_Type_Potential_Output;
      end if;
    
      p_Tracks(v_Trans_Output_Idx) := v_Track;
    
      p_Trans_Tracks.Extend;
      p_Trans_Tracks(p_Trans_Tracks.Count) := v_Track;
    
      v_Trans_Track_Output_Idx := p_Trans_Tracks.Count;
    end if;
  
    Transform_Gps_Output;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts
  (
    p_Timesheet      in out nocopy Htt_Timesheets%rowtype,
    p_Facts          in out nocopy Htt_Pref.Timesheet_Fact_Nt,
    p_Trans_Tracks   in out nocopy Htt_Pref.Timesheet_Track_Nt,
    p_Intervals      in out nocopy Htt_Pref.Timesheet_Interval_Nt,
    i_Tracks_Exist   boolean,
    i_Requests_Exist boolean,
    i_Timeoff_Tk_Id  number
  ) is
    v_Input          date;
    v_Time_Distance  number;
    v_Track_Duration number := p_Timesheet.Track_Duration;
  
    v_Begin_Late_Time  date := p_Timesheet.Begin_Time;
    v_Late_Input       date;
    v_Early_Output     date;
    v_First_Solo_Input date;
  
    v_Maybe_Late     boolean := p_Timesheet.Count_Late = 'Y';
    v_Maybe_Early    boolean := p_Timesheet.Count_Early = 'Y';
    v_End_Early_Time date := p_Timesheet.End_Time +
                             Numtodsinterval(p_Timesheet.End_Early_Time, 'second');
    v_Begin_Late     interval day to second := Numtodsinterval(p_Timesheet.Begin_Late_Time,
                                                               'second');
  
    v_Track  Htt_Pref.Timesheet_Track_Rt;
    v_Tracks Htt_Pref.Timesheet_Track_Nt;
  
    v_Inputs        Array_Date := Array_Date();
    v_Time_Parts    Htt_Pref.Time_Part_Nt := Htt_Pref.Time_Part_Nt();
    v_Gps_Intervals Htt_Pref.Time_Part_Nt;
  
    --------------------------------------------------
    Function Gather_Gps_Track_Intervals return Htt_Pref.Time_Part_Nt is
      v_Interval  Htt_Pref.Time_Part_Rt;
      v_Intervals Htt_Pref.Time_Part_Nt := Htt_Pref.Time_Part_Nt();
    
      --------------------------------------------------
      Function Is_In_Polygon(i_Track Htt_Pref.Gps_Track_Data_Rt) return boolean is
      begin
        if p_Timesheet.Gps_Use_Location = 'N' then
          return true;
        end if;
      
        for r in (select q.*
                    from Htt_Locations q
                   where q.Company_Id = p_Timesheet.Company_Id
                     and q.Location_Id in
                         (select Lp.Location_Id
                            from Htt_Location_Persons Lp
                           where Lp.Company_Id = p_Timesheet.Company_Id
                             and Lp.Filial_Id = p_Timesheet.Filial_Id
                             and Lp.Person_Id = p_Timesheet.Employee_Id)
                     and exists (select 1
                            from Htt_Location_Polygon_Vertices Pv
                           where Pv.Company_Id = q.Company_Id
                             and Pv.Location_Id = q.Location_Id))
        loop
          if Htt_Geo_Util.Is_Point_In_Polygon(i_Company_Id  => r.Company_Id,
                                              i_Location_Id => r.Location_Id,
                                              i_Point_Lat   => i_Track.Lat,
                                              i_Point_Lng   => i_Track.Lng) = 'Y' then
            return true;
          end if;
        end loop;
      
        return false;
      end;
    begin
      if p_Timesheet.Gps_Turnout_Enabled = 'N' then
        return Htt_Pref.Time_Part_Nt();
      end if;
    
      v_Interval.Input_Time  := p_Timesheet.Begin_Time;
      v_Interval.Output_Time := p_Timesheet.Begin_Time;
    
      for r in (select q.*
                  from Htt_Util.Gps_Track_Datas(i_Company_Id => p_Timesheet.Company_Id,
                                                i_Filial_Id  => p_Timesheet.Filial_Id,
                                                i_Person_Id  => p_Timesheet.Employee_Id,
                                                i_Begin_Date => Trunc(p_Timesheet.Shift_Begin_Time),
                                                i_End_Date   => p_Timesheet.End_Time,
                                                i_Only_Gps   => 'N') q
                 where q.Track_Time between p_Timesheet.Begin_Time and p_Timesheet.End_Time
                 order by q.Track_Time)
      loop
        if Htt_Util.Time_Diff(i_Time1 => r.Track_Time, i_Time2 => v_Interval.Output_Time) <
           p_Timesheet.Gps_Max_Interval and Is_In_Polygon(r) then
          v_Interval.Output_Time := r.Track_Time;
        else
          if v_Interval.Input_Time <> v_Interval.Output_Time then
            v_Intervals.Extend;
            v_Intervals(v_Intervals.Count) := v_Interval;
          end if;
        
          v_Interval.Input_Time  := r.Track_Time;
          v_Interval.Output_Time := r.Track_Time;
        end if;
      end loop;
    
      if Htt_Util.Time_Diff(i_Time1 => p_Timesheet.End_Time, i_Time2 => v_Interval.Output_Time) <
         p_Timesheet.Gps_Max_Interval then
        v_Interval.Output_Time := p_Timesheet.End_Time;
      end if;
    
      if v_Interval.Input_Time <> v_Interval.Output_Time then
        v_Intervals.Extend;
        v_Intervals(v_Intervals.Count) := v_Interval;
      end if;
    
      return v_Intervals;
    end;
  
    --------------------------------------------------
    Function Trim_Time_Parts_By_Gps(i_Intervals Htt_Pref.Time_Part_Nt) return Htt_Pref.Time_Part_Nt is
      v_Gps_Intervals Htt_Pref.Time_Part_Nt;
    
      v_Track_Interval Htt_Pref.Time_Part_Rt;
      v_Gps_Interval   Htt_Pref.Time_Part_Rt;
      v_Interval       Htt_Pref.Time_Part_Rt;
    
      result Htt_Pref.Time_Part_Nt;
    begin
      if p_Timesheet.Gps_Turnout_Enabled = 'N' then
        return i_Intervals;
      end if;
    
      if i_Intervals.Count = 0 then
        return i_Intervals;
      end if;
    
      result          := Htt_Pref.Time_Part_Nt();
      v_Gps_Intervals := Gather_Gps_Track_Intervals;
    
      for i in 1 .. i_Intervals.Count
      loop
        v_Track_Interval := i_Intervals(i);
      
        for j in 1 .. v_Gps_Intervals.Count
        loop
          v_Gps_Interval := v_Gps_Intervals(j);
        
          v_Interval.Input_Time  := Greatest(v_Gps_Interval.Input_Time, v_Track_Interval.Input_Time);
          v_Interval.Output_Time := Least(v_Gps_Interval.Output_Time, v_Track_Interval.Output_Time);
        
          if Htt_Util.Time_Diff(i_Time1 => v_Gps_Interval.Input_Time,
                                i_Time2 => v_Track_Interval.Input_Time) <
             p_Timesheet.Gps_Max_Interval and
             v_Track_Interval.Input_Time < v_Gps_Interval.Input_Time then
            v_Interval.Input_Time := v_Track_Interval.Input_Time;
          end if;
        
          if Htt_Util.Time_Diff(i_Time1 => v_Track_Interval.Output_Time,
                                i_Time2 => v_Gps_Interval.Output_Time) <
             p_Timesheet.Gps_Max_Interval and
             v_Gps_Interval.Output_Time < v_Track_Interval.Output_Time then
            v_Interval.Output_Time := v_Track_Interval.Output_Time;
          end if;
        
          if v_Interval.Input_Time < v_Interval.Output_Time then
            Result.Extend;
            result(Result.Count) := v_Interval;
          end if;
        end loop;
      end loop;
    
      return result;
    end;
  
  begin
    if p_Timesheet.Break_Enabled = 'N' then
      p_Timesheet.Break_Begin_Time := p_Timesheet.Begin_Time;
      p_Timesheet.Break_End_Time   := p_Timesheet.Begin_Time;
    end if;
  
    p_Timesheet.Input_Time  := null;
    p_Timesheet.Output_Time := null;
  
    if p_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly and
       p_Timesheet.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) then
      p_Timesheet.End_Time := p_Timesheet.Output_Border;
    end if;
  
    if i_Tracks_Exist then
      select Tt.Company_Id,
             Tt.Filial_Id,
             Tt.Timesheet_Id,
             Tt.Track_Id,
             Trunc(Tt.Track_Datetime, 'mi'),
             Tt.Track_Type,
             Tt.Trans_Input,
             Tt.Trans_Output,
             Tt.Trans_Check
        bulk collect
        into v_Tracks
        from Htt_Timesheet_Tracks Tt
       where Tt.Company_Id = p_Timesheet.Company_Id
         and Tt.Filial_Id = p_Timesheet.Filial_Id
         and Tt.Timesheet_Id = p_Timesheet.Timesheet_Id
       order by Tt.Track_Datetime,
                Decode(Tt.Track_Type,
                       Htt_Pref.c_Track_Type_Input,
                       1,
                       Htt_Pref.c_Track_Type_Output,
                       3,
                       2);
    
      if p_Timesheet.Plan_Time < p_Timesheet.Full_Time and
         p_Timesheet.Plan_Time <=
         Htt_Util.Time_Diff(p_Timesheet.End_Time, p_Timesheet.Break_End_Time) then
        v_Begin_Late_Time := p_Timesheet.End_Time -
                             Numtodsinterval(p_Timesheet.Plan_Time, 'second');
      else
        v_Begin_Late_Time := p_Timesheet.End_Time -
                             Numtodsinterval(p_Timesheet.Plan_Time +
                                             Htt_Util.Time_Diff(p_Timesheet.Break_End_Time,
                                                                p_Timesheet.Break_Begin_Time),
                                             'second');
      end if;
    
      v_Begin_Late_Time := v_Begin_Late_Time + v_Begin_Late;
    
      if p_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
        Transform_Check_Tracks(p_Tracks       => v_Tracks,
                               p_Trans_Tracks => p_Trans_Tracks,
                               i_Timesheet    => p_Timesheet);
      end if;
    
      for i in 1 .. v_Tracks.Count
      loop
        v_Track := v_Tracks(i);
      
        if (v_Track.Track_Type = Htt_Pref.c_Track_Type_Input or
           v_Track.Track_Type = Htt_Pref.c_Track_Type_Merger and i = 1) and
           v_Track.Track_Datetime >= p_Timesheet.Input_Border and
           v_Track.Track_Datetime < p_Timesheet.Shift_End_Time then
        
          if p_Timesheet.Day_Kind = Htt_Pref.c_Day_Kind_Work and
             p_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
            p_Timesheet.Input_Time := Nvl(p_Timesheet.Input_Time, v_Track.Track_Datetime);
            v_First_Solo_Input     := Nvl(v_First_Solo_Input, v_Track.Track_Datetime);
          elsif v_Track.Track_Datetime >= p_Timesheet.Shift_Begin_Time and
                v_Track.Track_Datetime < p_Timesheet.Shift_End_Time then
            p_Timesheet.Input_Time := Nvl(p_Timesheet.Input_Time, v_Track.Track_Datetime);
            v_First_Solo_Input     := Nvl(v_First_Solo_Input, v_Track.Track_Datetime);
          end if;
        
          -- ignore late time
          if v_Track.Track_Datetime between p_Timesheet.Begin_Time and v_Begin_Late_Time and
             v_Begin_Late_Time > p_Timesheet.Begin_Time then
            v_Maybe_Late := false;
            v_Late_Input := null;
          end if;
        
          -- eval late time
          if v_Maybe_Late and v_Track.Track_Datetime > v_Begin_Late_Time and
             v_Track.Track_Datetime < p_Timesheet.End_Time then
            v_Late_Input := Nvl(v_Late_Input, v_Track.Track_Datetime);
          end if;
        
          Fazo.Push(v_Inputs, v_Track.Track_Datetime);
        elsif (v_Track.Track_Type in
              (Htt_Pref.c_Track_Type_Output, Htt_Pref.c_Track_Type_Gps_Output) or
              v_Track.Track_Type = Htt_Pref.c_Track_Type_Merger and i = v_Tracks.Count) and
              v_Inputs.Count > 0 then
        
          if v_Track.Track_Datetime >= p_Timesheet.Input_Border and
             v_Track.Track_Datetime < p_Timesheet.Shift_Begin_Time then
            p_Timesheet.Input_Time := null;
          end if;
        
          if v_Track.Track_Datetime >= p_Timesheet.Shift_Begin_Time and
             v_Track.Track_Datetime <= p_Timesheet.Output_Border then
            for j in 1 .. v_Inputs.Count
            loop
              v_Input         := v_Inputs(j);
              v_Time_Distance := Htt_Util.Time_Diff(v_Track.Track_Datetime, v_Input);
              exit when v_Time_Distance <= v_Track_Duration;
            end loop;
          
            if p_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly and
               p_Timesheet.Input_Time between v_Input and v_Track.Track_Datetime then
              p_Timesheet.Input_Time := null;
            end if;
          
            if v_Time_Distance <= v_Track_Duration and
               (p_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly or
               v_Input >= p_Timesheet.Shift_Begin_Time and v_Input < p_Timesheet.Shift_End_Time) then
              -- eval early time
              if v_Maybe_Early and v_Track.Track_Datetime < v_End_Early_Time and
                 v_Track.Track_Datetime >= p_Timesheet.Begin_Time then
                v_Early_Output := v_Track.Track_Datetime;
              end if;
            
              p_Timesheet.Input_Time := Least(Nvl(p_Timesheet.Input_Time, v_Input), v_Input);
            
              if p_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly and
                 p_Timesheet.Output_Time is null then
                p_Timesheet.Input_Time := v_Input;
              end if;
            
              p_Timesheet.Output_Time := v_Track.Track_Datetime;
            
              -- TEMPORARY
              if p_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
                v_Input := Greatest(v_Input, p_Timesheet.Shift_Begin_Time);
              end if;
            
              -- ignore late time
              if Least(p_Timesheet.Begin_Time, v_Begin_Late_Time) between v_Input and
                 v_Track.Track_Datetime or
                 Htt_Util.Timeline_Intersection(i_Fr_Begin => Least(p_Timesheet.Begin_Time,
                                                                    p_Timesheet.Begin_Time +
                                                                    Numtodsinterval(p_Timesheet.Allowed_Late_Time,
                                                                                    'second')),
                                                i_Fr_End   => Greatest(p_Timesheet.Begin_Time,
                                                                       p_Timesheet.Begin_Time +
                                                                       Numtodsinterval(p_Timesheet.Allowed_Late_Time,
                                                                                       'second')),
                                                i_Sc_Begin => v_Input,
                                                i_Sc_End   => v_Track.Track_Datetime) > 0 then
                v_Maybe_Late := false;
                v_Late_Input := null;
              end if;
            
              -- ignore early time
              if v_Input < v_End_Early_Time and v_End_Early_Time <= v_Track.Track_Datetime or
                 Htt_Util.Timeline_Intersection(i_Fr_Begin => Least(p_Timesheet.End_Time,
                                                                    p_Timesheet.End_Time +
                                                                    Numtodsinterval(p_Timesheet.Allowed_Early_Time,
                                                                                    'second')),
                                                i_Fr_End   => Greatest(p_Timesheet.End_Time,
                                                                       p_Timesheet.End_Time +
                                                                       Numtodsinterval(p_Timesheet.Allowed_Early_Time,
                                                                                       'second')),
                                                i_Sc_Begin => v_Input,
                                                i_Sc_End   => v_Track.Track_Datetime) > 0 then
                v_Maybe_Early  := false;
                v_Early_Output := null;
              end if;
            
              /*
              -- TEMPORARY
              if p_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
                v_Input                := Least(Greatest(v_Input, p_Timesheet.Shift_Begin_Time),
                                                p_Timesheet.Shift_End_Time);
                v_Track.Track_Datetime := Least(Greatest(v_Track.Track_Datetime,
                                                         p_Timesheet.Shift_Begin_Time),
                                                p_Timesheet.Shift_End_Time);
              end if;
              */
            
              if v_Track.Track_Type <> Htt_Pref.c_Track_Type_Gps_Output then
                v_Time_Parts.Extend;
                v_Time_Parts(v_Time_Parts.Count) := Htt_Pref.Time_Part_Rt(v_Input,
                                                                          v_Track.Track_Datetime);
              end if;
            end if;
          end if;
        
          v_Inputs           := Array_Date();
          v_First_Solo_Input := null;
        end if;
      end loop;
    
      if v_First_Solo_Input <= v_Begin_Late_Time then
        v_Late_Input := null;
      end if;
    
      if p_Timesheet.Output_Time < v_Late_Input then
        p_Timesheet.Output_Time := null;
      end if;
    end if;
  
    v_Time_Parts := Trim_Time_Parts_By_Gps(v_Time_Parts);
  
    -- timeoff exists
    if i_Timeoff_Tk_Id is null then
      if p_Timesheet.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
        Gen_Timesheet_Facts_Rest_Day(p_Timesheet      => p_Timesheet,
                                     p_Facts          => p_Facts,
                                     i_Time_Parts     => v_Time_Parts,
                                     i_Requests_Exist => i_Requests_Exist);
      elsif p_Timesheet.Plan_Time < p_Timesheet.Full_Time and
            p_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
        Gen_Timesheet_Facts_Free_Day(p_Timesheet       => p_Timesheet,
                                     p_Facts           => p_Facts,
                                     i_Time_Parts      => v_Time_Parts,
                                     i_Begin_Late_Time => v_Begin_Late_Time - v_Begin_Late,
                                     i_Late_Input      => v_Late_Input,
                                     i_Requests_Exist  => i_Requests_Exist);
      else
        Gen_Timesheet_Facts_Work_Day(p_Timesheet      => p_Timesheet,
                                     p_Facts          => p_Facts,
                                     p_Intervals      => p_Intervals,
                                     i_Time_Parts     => v_Time_Parts,
                                     i_Late_Input     => v_Late_Input,
                                     i_Early_Output   => v_Early_Output,
                                     i_Requests_Exist => i_Requests_Exist);
      end if;
    else
      Gen_Timesheet_Fact(p_Facts         => p_Facts,
                         i_Company_Id    => p_Timesheet.Company_Id,
                         i_Filial_Id     => p_Timesheet.Filial_Id,
                         i_Timesheet_Id  => p_Timesheet.Timesheet_Id,
                         i_Time_Kind_Id  => i_Timeoff_Tk_Id,
                         i_Fact_Value    => p_Timesheet.Plan_Time,
                         i_Schedule_Kind => p_Timesheet.Schedule_Kind);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    i_Send_Notify  boolean := false
  ) is
    v_Tracks_Count    number;
    v_Requests_Count  number;
    v_Done_Mark_Count number;
  
    r_Timesheet      Htt_Timesheets%rowtype;
    r_Timesheet_Fact Htt_Timesheet_Facts%rowtype;
    r_Timeoff        Hpd_Timeoff_Days%rowtype;
    r_Overtime       Hpd_Overtime_Days%rowtype;
    v_Facts          Htt_Pref.Timesheet_Fact_Nt := Htt_Pref.Timesheet_Fact_Nt();
    v_Trans_Tracks   Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Intervals      Htt_Pref.Timesheet_Interval_Nt := Htt_Pref.Timesheet_Interval_Nt();
  
    v_Input_Time  date;
    v_Output_Time date;
  
    --------------------------------------------------
    Procedure Approve_Timesheet_Marks
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Timesheet_Id number
    ) is
    begin
      update Htt_Timesheet_Marks Tm
         set Tm.Done = 'N'
       where Tm.Company_Id = i_Company_Id
         and Tm.Filial_Id = i_Filial_Id
         and Tm.Timesheet_Id = i_Timesheet_Id;
    
      update Htt_Timesheet_Marks Tm
         set Tm.Done = 'Y'
       where Tm.Company_Id = i_Company_Id
         and Tm.Filial_Id = i_Filial_Id
         and Tm.Timesheet_Id = i_Timesheet_Id
         and exists (select *
                from Htt_Timesheet_Tracks Tt
               where Tt.Company_Id = Tm.Company_Id
                 and Tt.Filial_Id = Tm.Filial_Id
                 and Tt.Timesheet_Id = Tm.Timesheet_Id
                 and Tt.Track_Type = Htt_Pref.c_Track_Type_Check
                 and Tt.Track_Datetime between Tm.Begin_Time and Tm.End_Time);
    end;
  
    -------------------------------------------------- 
    Function Overtime_Posted
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Overtime_Id number
    ) return boolean is
      r_Overtime Hpd_Journal_Overtimes%rowtype;
      r_Journal  Hpd_Journals%rowtype;
    begin
      r_Overtime := z_Hpd_Journal_Overtimes.Load(i_Company_Id  => i_Company_Id,
                                                 i_Filial_Id   => i_Filial_Id,
                                                 i_Overtime_Id => i_Overtime_Id);
    
      r_Journal := z_Hpd_Journals.Load(i_Company_Id => r_Overtime.Company_Id,
                                       i_Filial_Id  => r_Overtime.Filial_Id,
                                       i_Journal_Id => r_Overtime.Journal_Id);
    
      return r_Journal.Posted = 'Y';
    end;
  begin
    r_Timesheet := z_Htt_Timesheets.Lock_Load(i_Company_Id   => i_Company_Id,
                                              i_Filial_Id    => i_Filial_Id,
                                              i_Timesheet_Id => i_Timesheet_Id);
  
    if z_Htt_Timesheet_Locks.Exist(i_Company_Id     => r_Timesheet.Company_Id,
                                   i_Filial_Id      => r_Timesheet.Filial_Id,
                                   i_Staff_Id       => r_Timesheet.Staff_Id,
                                   i_Timesheet_Date => r_Timesheet.Timesheet_Date) then
      z_Htt_Timesheet_Locks.Update_One(i_Company_Id     => r_Timesheet.Company_Id,
                                       i_Filial_Id      => r_Timesheet.Filial_Id,
                                       i_Staff_Id       => r_Timesheet.Staff_Id,
                                       i_Timesheet_Date => r_Timesheet.Timesheet_Date,
                                       i_Facts_Changed  => Option_Varchar2('Y'));
      return;
    end if;
  
    delete Htt_Timesheet_Facts Tf
     where Tf.Company_Id = r_Timesheet.Company_Id
       and Tf.Filial_Id = r_Timesheet.Filial_Id
       and Tf.Timesheet_Id = r_Timesheet.Timesheet_Id;
  
    delete Htt_Timesheet_Intervals Ti
     where Ti.Company_Id = r_Timesheet.Company_Id
       and Ti.Filial_Id = r_Timesheet.Filial_Id
       and Ti.Timesheet_Id = r_Timesheet.Timesheet_Id;
  
    select count(*)
      into v_Tracks_Count
      from Htt_Timesheet_Tracks Tt
     where Tt.Company_Id = i_Company_Id
       and Tt.Filial_Id = i_Filial_Id
       and Tt.Timesheet_Id = i_Timesheet_Id;
  
    select count(*)
      into v_Requests_Count
      from Htt_Timesheet_Requests Tr
     where Tr.Company_Id = i_Company_Id
       and Tr.Filial_Id = i_Filial_Id
       and Tr.Timesheet_Id = i_Timesheet_Id;
  
    if z_Hpd_Timeoff_Days.Exist_Lock(i_Company_Id   => r_Timesheet.Company_Id,
                                     i_Filial_Id    => r_Timesheet.Filial_Id,
                                     i_Staff_Id     => r_Timesheet.Staff_Id,
                                     i_Timeoff_Date => r_Timesheet.Timesheet_Date,
                                     o_Row          => r_Timeoff) then
      null;
    end if;
  
    v_Input_Time  := r_Timesheet.Input_Time;
    v_Output_Time := r_Timesheet.Output_Time;
  
    Gen_Timesheet_Facts(p_Timesheet      => r_Timesheet,
                        p_Facts          => v_Facts,
                        p_Trans_Tracks   => v_Trans_Tracks,
                        p_Intervals      => v_Intervals,
                        i_Tracks_Exist   => v_Tracks_Count > 0,
                        i_Requests_Exist => v_Requests_Count > 0,
                        i_Timeoff_Tk_Id  => r_Timeoff.Time_Kind_Id);
  
    Insert_Timesheet_Facts(p_Facts     => v_Facts, --
                           p_Intervals => v_Intervals);
  
    r_Overtime := z_Hpd_Overtime_Days.Take(i_Company_Id    => r_Timesheet.Company_Id,
                                           i_Filial_Id     => r_Timesheet.Filial_Id,
                                           i_Staff_Id      => r_Timesheet.Staff_Id,
                                           i_Overtime_Date => r_Timesheet.Timesheet_Date);
  
    if r_Overtime.Overtime_Seconds is not null then
      if Overtime_Posted(i_Company_Id  => r_Overtime.Company_Id,
                         i_Filial_Id   => r_Overtime.Filial_Id,
                         i_Overtime_Id => r_Overtime.Overtime_Id) then
        Insert_Timesheet_Overtime_Facts(i_Company_Id       => r_Timesheet.Company_Id,
                                        i_Filial_Id        => r_Timesheet.Filial_Id,
                                        i_Timesheet_Id     => r_Timesheet.Timesheet_Id,
                                        i_Staff_Id         => r_Timesheet.Staff_Id,
                                        i_Timesheet_Date   => r_Timesheet.Timesheet_Date,
                                        i_Overtime_Seconds => r_Overtime.Overtime_Seconds);
      end if;
    end if;
  
    -- timebook adjustment
    Save_Adjustment_Fact(i_Company_Id     => r_Timesheet.Company_Id,
                         i_Filial_Id      => r_Timesheet.Filial_Id,
                         i_Staff_Id       => r_Timesheet.Staff_Id,
                         i_Timesheet_Id   => r_Timesheet.Timesheet_Id,
                         i_Timesheet_Date => r_Timesheet.Timesheet_Date);
  
    Approve_Timesheet_Marks(i_Company_Id   => r_Timesheet.Company_Id,
                            i_Filial_Id    => r_Timesheet.Filial_Id,
                            i_Timesheet_Id => r_Timesheet.Timesheet_Id);
  
    select count(*)
      into v_Done_Mark_Count
      from Htt_Timesheet_Marks Tm
     where Tm.Company_Id = r_Timesheet.Company_Id
       and Tm.Filial_Id = r_Timesheet.Filial_Id
       and Tm.Timesheet_Id = r_Timesheet.Timesheet_Id
       and Tm.Done = 'Y';
  
    update Htt_Timesheet_Tracks Tt
       set Tt.Track_Used = 'Y'
     where Tt.Company_Id = r_Timesheet.Company_Id
       and Tt.Filial_Id = r_Timesheet.Filial_Id
       and Tt.Timesheet_Id = r_Timesheet.Timesheet_Id
       and Tt.Track_Used = 'N';
  
    forall i in 1 .. v_Trans_Tracks.Count
      update Htt_Timesheet_Tracks Tt
         set Tt.Track_Type = v_Trans_Tracks(i).Track_Type
       where Tt.Company_Id = r_Timesheet.Company_Id
         and Tt.Filial_Id = r_Timesheet.Filial_Id
         and Tt.Timesheet_Id = r_Timesheet.Timesheet_Id
         and Tt.Track_Id = v_Trans_Tracks(i).Track_Id;
  
    z_Htt_Timesheets.Update_One(i_Company_Id   => r_Timesheet.Company_Id,
                                i_Filial_Id    => r_Timesheet.Filial_Id,
                                i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                i_Input_Time   => Option_Date(r_Timesheet.Input_Time),
                                i_Output_Time  => Option_Date(r_Timesheet.Output_Time),
                                i_Done_Marks   => Option_Number(v_Done_Mark_Count));
  
    -- send notification
    if i_Send_Notify and
       r_Timesheet.Timesheet_Date =
       Trunc(Htt_Util.Get_Current_Date(i_Company_Id => r_Timesheet.Company_Id,
                                       i_Filial_Id  => r_Timesheet.Filial_Id)) then
      if v_Input_Time is null and
         z_Htt_Timesheet_Facts.Exist(i_Company_Id   => r_Timesheet.Company_Id,
                                     i_Filial_Id    => r_Timesheet.Filial_Id,
                                     i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                     i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => r_Timesheet.Company_Id,
                                                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late),
                                     o_Row          => r_Timesheet_Fact) and
         r_Timesheet_Fact.Fact_Value > 0 then
        Notify_Timesheet(i_Timesheet   => r_Timesheet,
                         i_Late_Time   => Trunc(r_Timesheet_Fact.Fact_Value / 60),
                         i_Notify_Type => Hes_Pref.c_Pref_Nt_Late_Time);
      end if;
    
      if not Fazo.Equal(r_Timesheet.Output_Time, v_Output_Time) and
         z_Htt_Timesheet_Facts.Exist(i_Company_Id   => r_Timesheet.Company_Id,
                                     i_Filial_Id    => r_Timesheet.Filial_Id,
                                     i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                     i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => r_Timesheet.Company_Id,
                                                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early),
                                     o_Row          => r_Timesheet_Fact) and
         r_Timesheet_Fact.Fact_Value > 0 then
        Notify_Timesheet(i_Timesheet   => r_Timesheet,
                         i_Early_Time  => Trunc(r_Timesheet_Fact.Fact_Value / 60),
                         i_Notify_Type => Hes_Pref.c_Pref_Nt_Early_Time);
      end if;
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Timesheet_Facts is
    r_Timesheet    Htt_Timesheets%rowtype;
    v_Facts        Htt_Pref.Timesheet_Fact_Nt := Htt_Pref.Timesheet_Fact_Nt();
    v_Timesheets   Htt_Pref.Timesheet_Nt := Htt_Pref.Timesheet_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Intervals    Htt_Pref.Timesheet_Interval_Nt := Htt_Pref.Timesheet_Interval_Nt();
  
    -------------------------------------------------- 
    Procedure Update_Timesheets
    (
      p_Timesheets   in out nocopy Htt_Pref.Timesheet_Nt,
      p_Trans_Tracks in out nocopy Htt_Pref.Timesheet_Track_Nt
    ) is
    begin
      forall i in 1 .. p_Timesheets.Count
        update Htt_Timesheets t
           set t.Input_Time  = p_Timesheets(i).Input_Time,
               t.Output_Time = p_Timesheets(i).Output_Time
         where t.Company_Id = p_Timesheets(i).Company_Id
           and t.Filial_Id = p_Timesheets(i).Filial_Id
           and t.Timesheet_Id = p_Timesheets(i).Timesheet_Id;
    
      forall i in 1 .. p_Trans_Tracks.Count
        update Htt_Timesheet_Tracks Tt
           set Tt.Track_Type = p_Trans_Tracks(i).Track_Type
         where Tt.Company_Id = p_Trans_Tracks(i).Company_Id
           and Tt.Filial_Id = p_Trans_Tracks(i).Filial_Id
           and Tt.Timesheet_Id = p_Trans_Tracks(i).Timesheet_Id
           and Tt.Track_Id = p_Trans_Tracks(i).Track_Id;
    
      p_Timesheets   := Htt_Pref.Timesheet_Nt();
      p_Trans_Tracks := Htt_Pref.Timesheet_Track_Nt();
    end;
  
    --------------------------------------------------
    Procedure Insert_Overtime_Days is
      v_Filial_Id      number;
      v_Staff_Id       number;
      v_Timesheet_Date date;
      v_Schedule_Id    number;
      v_Overtime       number;
      v_Free_Time      number;
    
      v_Company_Id            number;
      v_Company_Cnt           number;
      v_Free_Time_Kind_Id     number;
      v_Overtime_Time_Kind_Id number;
    begin
      select min(Qr.Company_Id), count(1)
        into v_Company_Id, v_Company_Cnt
        from (select t.Company_Id
                from Htt_Dirty_Timesheets t
               group by t.Company_Id) Qr;
    
      if v_Company_Cnt > 1 then
        Htt_Error.Raise_008;
      end if;
    
      if v_Company_Id is null then
        return;
      end if;
    
      v_Free_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                   i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    
      v_Overtime_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
    
      select p.Company_Id,
             p.Filial_Id,
             p.Staff_Id,
             p.Timesheet_Date,
             p.Schedule_Id,
             Od.Overtime_Seconds
        into v_Company_Id, v_Filial_Id, v_Staff_Id, v_Timesheet_Date, v_Schedule_Id, v_Overtime
        from Htt_Timesheets p
        join Hpd_Overtime_Days Od
          on Od.Company_Id = p.Company_Id
         and Od.Filial_Id = p.Filial_Id
         and Od.Staff_Id = p.Staff_Id
         and Od.Overtime_Date = p.Timesheet_Date
       where exists (select *
                from Hpd_Journal_Overtimes q
                join Hpd_Journals p
                  on p.Company_Id = q.Company_Id
                 and p.Filial_Id = q.Filial_Id
                 and p.Journal_Id = q.Journal_Id
                 and p.Posted = 'Y'
               where q.Company_Id = Od.Company_Id
                 and q.Filial_Id = Od.Filial_Id
                 and q.Overtime_Id = Od.Overtime_Id)
         and exists (select 1
                from Htt_Dirty_Timesheets q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Timesheet_Id = p.Timesheet_Id)
         and Nvl((select sum(Tf.Fact_Value)
                   from Htt_Timesheet_Facts Tf
                   join Htt_Time_Kinds Tk
                     on Tk.Company_Id = v_Company_Id
                    and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Time_Kind_Id
                    and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                  where Tf.Company_Id = p.Company_Id
                    and Tf.Filial_Id = p.Filial_Id
                    and Tf.Timesheet_Id = p.Timesheet_Id),
                 0) < Od.Overtime_Seconds
         and Rownum = 1;
    
      v_Free_Time := Htt_Util.Get_Fact_Value(i_Company_Id     => v_Company_Id,
                                             i_Filial_Id      => v_Filial_Id,
                                             i_Staff_Id       => v_Staff_Id,
                                             i_Timesheet_Date => v_Timesheet_Date,
                                             i_Time_Kind_Id   => v_Free_Time_Kind_Id);
    
      Htt_Error.Raise_005(i_Staff_Name           => Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_Staff_Id   => v_Staff_Id),
                          i_Timesheet_Date       => v_Timesheet_Date,
                          i_Schedule_Name        => z_Htt_Schedules.Load(i_Company_Id => v_Company_Id, --
                                                    i_Filial_Id => v_Filial_Id, --
                                                    i_Schedule_Id => v_Schedule_Id).Name,
                          i_Overtime_Exceed_Text => Htt_Util.To_Time_Seconds_Text(i_Seconds      => v_Overtime -
                                                                                                    v_Free_Time,
                                                                                  i_Show_Minutes => true,
                                                                                  i_Show_Words   => true));
    
    exception
      when No_Data_Found then
        insert into Htt_Timesheet_Facts
          (Company_Id, Filial_Id, Timesheet_Id, Time_Kind_Id, Fact_Value)
          (select t.Company_Id,
                  t.Filial_Id,
                  t.Timesheet_Id,
                  v_Overtime_Time_Kind_Id,
                  Od.Overtime_Seconds
             from Htt_Timesheets t
             join Hpd_Overtime_Days Od
               on Od.Company_Id = t.Company_Id
              and Od.Filial_Id = t.Filial_Id
              and Od.Staff_Id = t.Staff_Id
              and Od.Overtime_Date = t.Timesheet_Date
            where exists (select *
                     from Hpd_Journal_Overtimes q
                     join Hpd_Journals p
                       on p.Company_Id = q.Company_Id
                      and p.Filial_Id = q.Filial_Id
                      and p.Journal_Id = q.Journal_Id
                      and p.Posted = 'Y'
                    where q.Company_Id = Od.Company_Id
                      and q.Filial_Id = Od.Filial_Id
                      and q.Overtime_Id = Od.Overtime_Id)
              and exists (select 1
                     from Htt_Dirty_Timesheets w
                    where w.Company_Id = t.Company_Id
                      and w.Filial_Id = t.Filial_Id
                      and w.Timesheet_Id = t.Timesheet_Id));
    end;
  
    --------------------------------------------------
    Procedure Insert_Timebook_Adjustments is
      v_Company_Id          number;
      v_Company_Cnt         number;
      v_Turnout_Adjustment  number;
      v_Overtime_Adjustment number;
      v_Lack_Tk_Id          number;
    begin
      select min(Qr.Company_Id), count(1)
        into v_Company_Id, v_Company_Cnt
        from (select t.Company_Id
                from Htt_Dirty_Timesheets t
               group by t.Company_Id) Qr;
    
      if v_Company_Cnt > 1 then
        Htt_Error.Raise_008;
      end if;
    
      if v_Company_Id is null then
        return;
      end if;
    
      v_Turnout_Adjustment  := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout_Adjustment);
      v_Overtime_Adjustment := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime_Adjustment);
      v_Lack_Tk_Id          := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
    
      insert all --
      into Htt_Timesheet_Facts
        (Company_Id, Filial_Id, Timesheet_Id, Time_Kind_Id, Fact_Value)
      values
        (Company_Id, Filial_Id, Timesheet_Id, v_Turnout_Adjustment, Turnout_Time * 60) --
      into Htt_Timesheet_Facts
        (Company_Id, Filial_Id, Timesheet_Id, Time_Kind_Id, Fact_Value)
      values
        (Company_Id, Filial_Id, Timesheet_Id, v_Overtime_Adjustment, Overtime * 60)
        select q.Company_Id,
               q.Filial_Id,
               q.Timesheet_Id,
               (select a.Overtime
                  from Hpd_Page_Adjustments a
                 where a.Company_Id = La.Company_Id
                   and a.Filial_Id = La.Filial_Id
                   and a.Page_Id = La.Page_Id) as Overtime,
               (select a.Turnout_Time
                  from Hpd_Page_Adjustments a
                 where a.Company_Id = La.Company_Id
                   and a.Filial_Id = La.Filial_Id
                   and a.Page_Id = La.Page_Id) as Turnout_Time
          from Htt_Dirty_Timesheets Dt
          join Htt_Timesheets q
            on q.Company_Id = Dt.Company_Id
           and q.Filial_Id = Dt.Filial_Id
           and q.Timesheet_Id = Dt.Timesheet_Id
          join Hpd_Lock_Adjustments La
            on La.Company_Id = q.Company_Id
           and La.Filial_Id = q.Filial_Id
           and La.Staff_Id = q.Staff_Id
           and La.Adjustment_Date = q.Timesheet_Date;
    
      update (select Df.Fact_Value,
                     (select Tf.Fact_Value
                        from Htt_Timesheet_Facts Tf
                       where Tf.Company_Id = Dt.Company_Id
                         and Tf.Filial_Id = Dt.Filial_Id
                         and Tf.Timesheet_Id = Dt.Timesheet_Id
                         and Tf.Time_Kind_Id = v_Lack_Tk_Id) New_Value
                from Htt_Dirty_Timesheets Dt
                join Htt_Timesheets Tm
                  on Tm.Company_Id = Dt.Company_Id
                 and Tm.Filial_Id = Dt.Filial_Id
                 and Tm.Timesheet_Id = Dt.Timesheet_Id
                join Hpd_Adjustment_Deleted_Facts Df
                  on Df.Company_Id = Tm.Company_Id
                 and Df.Filial_Id = Tm.Filial_Id
                 and Df.Staff_Id = Tm.Staff_Id
                 and Df.Adjustment_Date = Tm.Timesheet_Date
                 and Df.Time_Kind_Id = v_Lack_Tk_Id) q
         set q.Fact_Value = Nvl(q.New_Value, 0);
    
      insert into Hpd_Adjustment_Deleted_Facts
        (Company_Id, Filial_Id, Staff_Id, Adjustment_Date, Time_Kind_Id, Fact_Value)
        select Tf.Company_Id,
               Tf.Filial_Id,
               Tm.Staff_Id,
               Tm.Timesheet_Date,
               Tf.Time_Kind_Id,
               Tf.Fact_Value
          from Htt_Dirty_Timesheets Dt
          join Htt_Timesheets Tm
            on Tm.Company_Id = Dt.Company_Id
           and Tm.Filial_Id = Dt.Filial_Id
           and Tm.Timesheet_Id = Dt.Timesheet_Id
          join Hpd_Lock_Adjustments La
            on La.Company_Id = Tm.Company_Id
           and La.Filial_Id = Tm.Filial_Id
           and La.Staff_Id = Tm.Staff_Id
           and La.Adjustment_Date = Tm.Timesheet_Date
           and La.Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete
          join Htt_Timesheet_Facts Tf
            on Tf.Company_Id = Dt.Company_Id
           and Tf.Filial_Id = Dt.Filial_Id
           and Tf.Timesheet_Id = Dt.Timesheet_Id
           and Tf.Time_Kind_Id = v_Lack_Tk_Id
         where not exists (select 1
                  from Hpd_Adjustment_Deleted_Facts p
                 where p.Company_Id = Tm.Company_Id
                   and p.Filial_Id = Tm.Filial_Id
                   and p.Staff_Id = Tm.Staff_Id
                   and p.Adjustment_Date = Tm.Timesheet_Date
                   and p.Time_Kind_Id = v_Lack_Tk_Id);
    
      update (select Tf.Fact_Value,
                     (select Pa.Turnout_Time * 60
                        from Hpd_Page_Adjustments Pa
                       where Pa.Company_Id = La.Company_Id
                         and Pa.Filial_Id = La.Filial_Id
                         and Pa.Page_Id = La.Page_Id) Turnout_Time
                from Htt_Dirty_Timesheets Dt
                join Htt_Timesheets Tm
                  on Tm.Company_Id = Dt.Company_Id
                 and Tm.Filial_Id = Dt.Filial_Id
                 and Tm.Timesheet_Id = Dt.Timesheet_Id
                join Hpd_Lock_Adjustments La
                  on La.Company_Id = Tm.Company_Id
                 and La.Filial_Id = Tm.Filial_Id
                 and La.Staff_Id = Tm.Staff_Id
                 and La.Adjustment_Date = Tm.Timesheet_Date
                 and La.Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete
                join Htt_Timesheet_Facts Tf
                  on Tf.Company_Id = Dt.Company_Id
                 and Tf.Filial_Id = Dt.Filial_Id
                 and Tf.Timesheet_Id = Dt.Timesheet_Id
                 and Tf.Time_Kind_Id = v_Lack_Tk_Id) q
         set q.Fact_Value = Greatest(q.Fact_Value - Nvl(q.Turnout_Time, 0), 0);
    end;
  begin
    delete Htt_Timesheet_Facts Tf
     where exists (select 1
              from Htt_Dirty_Timesheets t
             where Tf.Company_Id = t.Company_Id
               and Tf.Filial_Id = t.Filial_Id
               and Tf.Timesheet_Id = t.Timesheet_Id);
  
    delete Htt_Timesheet_Intervals Ti
     where exists (select 1
              from Htt_Dirty_Timesheets t
             where Ti.Company_Id = t.Company_Id
               and Ti.Filial_Id = t.Filial_Id
               and Ti.Timesheet_Id = t.Timesheet_Id);
  
    for r in (select t.*,
                     (select Td.Time_Kind_Id
                        from Hpd_Timeoff_Days Td
                       where Td.Company_Id = t.Company_Id
                         and Td.Filial_Id = t.Filial_Id
                         and Td.Staff_Id = t.Staff_Id
                         and Td.Timeoff_Date = t.Timesheet_Date) Timeoff_Tk_Id,
                     (select count(*)
                        from Htt_Timesheet_Tracks Tt
                       where Tt.Company_Id = t.Company_Id
                         and Tt.Filial_Id = t.Filial_Id
                         and Tt.Timesheet_Id = t.Timesheet_Id) Tracks_Count,
                     (select count(*)
                        from Htt_Timesheet_Requests Tr
                       where Tr.Company_Id = t.Company_Id
                         and Tr.Filial_Id = t.Filial_Id
                         and Tr.Timesheet_Id = t.Timesheet_Id) Requests_Count
                from Htt_Timesheets t
                join Htt_Dirty_Timesheets Dt
                  on t.Company_Id = Dt.Company_Id
                 and t.Filial_Id = Dt.Filial_Id
                 and t.Timesheet_Id = Dt.Timesheet_Id)
    loop
      z_Htt_Timesheets.Init(p_Row                 => r_Timesheet,
                            i_Company_Id          => r.Company_Id,
                            i_Filial_Id           => r.Filial_Id,
                            i_Timesheet_Id        => r.Timesheet_Id,
                            i_Timesheet_Date      => r.Timesheet_Date,
                            i_Staff_Id            => r.Staff_Id,
                            i_Employee_Id         => r.Employee_Id,
                            i_Schedule_Id         => r.Schedule_Id,
                            i_Day_Kind            => r.Day_Kind,
                            i_Begin_Time          => r.Begin_Time,
                            i_End_Time            => r.End_Time,
                            i_Break_Enabled       => r.Break_Enabled,
                            i_Break_Begin_Time    => r.Break_Begin_Time,
                            i_Break_End_Time      => r.Break_End_Time,
                            i_Plan_Time           => r.Plan_Time,
                            i_Full_Time           => r.Full_Time,
                            i_Input_Time          => null,
                            i_Output_Time         => null,
                            i_Track_Duration      => r.Track_Duration,
                            i_Schedule_Kind       => r.Schedule_Kind,
                            i_Count_Late          => r.Count_Late,
                            i_Count_Early         => r.Count_Early,
                            i_Count_Lack          => r.Count_Lack,
                            i_Count_Free          => r.Count_Free,
                            i_Gps_Turnout_Enabled => r.Gps_Turnout_Enabled,
                            i_Gps_Use_Location    => r.Gps_Use_Location,
                            i_Gps_Max_Interval    => r.Gps_Max_Interval,
                            i_Shift_Begin_Time    => r.Shift_Begin_Time,
                            i_Shift_End_Time      => r.Shift_End_Time,
                            i_Input_Border        => r.Input_Border,
                            i_Output_Border       => r.Output_Border,
                            i_Calendar_Id         => r.Calendar_Id,
                            i_Allowed_Late_Time   => r.Allowed_Late_Time,
                            i_Allowed_Early_Time  => r.Allowed_Early_Time,
                            i_Begin_Late_Time     => r.Begin_Late_Time,
                            i_End_Early_Time      => r.End_Early_Time);
    
      Gen_Timesheet_Facts(p_Timesheet      => r_Timesheet,
                          p_Facts          => v_Facts,
                          p_Trans_Tracks   => v_Trans_Tracks,
                          p_Intervals      => v_Intervals,
                          i_Tracks_Exist   => r.Tracks_Count > 0,
                          i_Requests_Exist => r.Requests_Count > 0,
                          i_Timeoff_Tk_Id  => r.Timeoff_Tk_Id);
    
      Htt_Util.Timesheet_Add(o_Timesheets   => v_Timesheets,
                             i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_Timesheet_Id => r.Timesheet_Id,
                             i_Input_Time   => r_Timesheet.Input_Time,
                             i_Output_Time  => r_Timesheet.Output_Time);
    
      if v_Facts.Count > 10000 then
        Insert_Timesheet_Facts(p_Facts     => v_Facts, --
                               p_Intervals => v_Intervals);
      end if;
    
      if v_Timesheets.Count > 10000 then
        Update_Timesheets(p_Timesheets   => v_Timesheets, --
                          p_Trans_Tracks => v_Trans_Tracks);
      end if;
    end loop;
  
    Insert_Timesheet_Facts(p_Facts     => v_Facts, --
                           p_Intervals => v_Intervals);
  
    Update_Timesheets(p_Timesheets   => v_Timesheets, --
                      p_Trans_Tracks => v_Trans_Tracks);
  
    Insert_Overtime_Days;
    Insert_Timebook_Adjustments;
  end;

  ----------------------------------------------------------------------------------------------------
  -- o'zgartirish kerak structurani
  -- adashib ketish ehtimolligi juda katta
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheet_Requests
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) is
    v_Begin_Date date;
    v_End_Date   date;
    v_Timesheet  Htt_Timesheets%rowtype;
  
    r_Request  Htt_Requests%rowtype;
    r_Timebook Hpr_Timebooks%rowtype;
  
    v_Timesheet_Ids Array_Number;
  
    f_Timesheet_Sets Fazo.Boolean_Code_Aat;
    --------------------------------------------------
    Procedure Put_Timesheet_Ids is
    begin
      for i in 1 .. v_Timesheet_Ids.Count
      loop
        f_Timesheet_Sets(v_Timesheet_Ids(i)) := true;
      end loop;
    end;
  
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    v_Begin_Date := Trunc(r_Request.Begin_Time);
    v_End_Date   := Trunc(r_Request.End_Time);
  
    while v_Begin_Date <= v_End_Date
    loop
      if z_Htt_Timesheet_Locks.Exist(i_Company_Id     => r_Request.Company_Id,
                                     i_Filial_Id      => r_Request.Filial_Id,
                                     i_Staff_Id       => r_Request.Staff_Id,
                                     i_Timesheet_Date => v_Begin_Date) then
        r_Timebook := Get_Blocking_Timebook(i_Company_Id     => r_Request.Company_Id,
                                            i_Filial_Id      => r_Request.Filial_Id,
                                            i_Staff_Id       => r_Request.Staff_Id,
                                            i_Timesheet_Date => v_Begin_Date);
      
        Htt_Error.Raise_006(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                                                      i_Filial_Id  => r_Request.Filial_Id,
                                                                      i_Staff_Id   => r_Request.Staff_Id),
                            i_Timesheet_Date  => v_Begin_Date,
                            i_Timebook_Number => r_Timebook.Timebook_Number,
                            i_Timebook_Month  => r_Timebook.Month);
      end if;
    
      v_Begin_Date := v_Begin_Date + 1;
    end loop;
  
    -- buni mexanizmni fix qilish kerak, hozir butun staff lock bo'lib qoladi, buni htt o'zi uchun qilish kerak
    z_Href_Staffs.Lock_Only(i_Company_Id => r_Request.Company_Id,
                            i_Filial_Id  => r_Request.Filial_Id,
                            i_Staff_Id   => r_Request.Staff_Id);
  
    delete Htt_Timesheet_Requests q
     where q.Company_Id = r_Request.Company_Id
       and q.Request_Id = r_Request.Request_Id
    returning q.Timesheet_Id bulk collect into v_Timesheet_Ids;
  
    Put_Timesheet_Ids;
  
    if r_Request.Status = Htt_Pref.c_Request_Status_Completed then
      if r_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Timesheet_Ids := Find_Request_Timesheets(i_Company_Id    => r_Request.Company_Id,
                                                   i_Filial_Id     => r_Request.Filial_Id,
                                                   i_Staff_Id      => r_Request.Staff_Id,
                                                   i_Request_Begin => r_Request.Begin_Time,
                                                   i_Request_End   => r_Request.End_Time);
      
      elsif r_Request.Request_Type = Htt_Pref.c_Request_Type_Full_Day then
        if Htt_Util.Exist_Timesheet(i_Company_Id     => r_Request.Company_Id,
                                    i_Filial_Id      => r_Request.Filial_Id,
                                    i_Staff_Id       => r_Request.Staff_Id,
                                    i_Timesheet_Date => Trunc(r_Request.Begin_Time),
                                    o_Timesheet      => v_Timesheet) then
          v_Timesheet_Ids := Array_Number(v_Timesheet.Timesheet_Id);
        end if;
      else
        v_Begin_Date := Trunc(r_Request.Begin_Time);
        v_End_Date   := Trunc(r_Request.End_Time);
      
        select q.Timesheet_Id
          bulk collect
          into v_Timesheet_Ids
          from Htt_Timesheets q
         where q.Company_Id = r_Request.Company_Id
           and q.Filial_Id = r_Request.Filial_Id
           and q.Staff_Id = r_Request.Staff_Id
           and q.Timesheet_Date between v_Begin_Date and v_End_Date;
      
      end if;
    
      for i in 1 .. v_Timesheet_Ids.Count
      loop
        z_Htt_Timesheet_Requests.Insert_Try(i_Company_Id   => r_Request.Company_Id,
                                            i_Filial_Id    => r_Request.Filial_Id,
                                            i_Timesheet_Id => v_Timesheet_Ids(i),
                                            i_Request_Id   => r_Request.Request_Id);
      end loop;
    
      Put_Timesheet_Ids;
    end if;
  
    v_Timesheet.Timesheet_Id := f_Timesheet_Sets.First;
  
    while v_Timesheet.Timesheet_Id is not null
    loop
      Gen_Timesheet_Facts(i_Company_Id   => r_Request.Company_Id, --
                          i_Filial_Id    => r_Request.Filial_Id,
                          i_Timesheet_Id => v_Timesheet.Timesheet_Id);
    
      v_Timesheet.Timesheet_Id := f_Timesheet_Sets.Next(v_Timesheet.Timesheet_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  -- facts generation triggered by timeoffs
  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Timeoff_Facts
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Timeoff_Id     number,
    i_Remove_Timeoff boolean := false
  ) is
    v_Turnout_Id   number;
    v_Lack_Id      number;
    v_Time_Kind_Id number;
    v_Turnout_Time number;
    v_Fact_Value   number;
    v_Turnout_Ids  Array_Number;
    v_Facts        Htt_Pref.Timesheet_Fact_Nt := Htt_Pref.Timesheet_Fact_Nt();
    v_Intervals    Htt_Pref.Timesheet_Interval_Nt := Htt_Pref.Timesheet_Interval_Nt();
  begin
    v_Lack_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    delete Htt_Timesheet_Facts Tf
     where Tf.Company_Id = i_Company_Id
       and Tf.Filial_Id = i_Filial_Id
       and (Tf.Time_Kind_Id not member of v_Turnout_Ids or Tf.Fact_Value = 0)
       and exists (select *
              from Hpd_Timeoff_Days Td
             where Td.Company_Id = i_Company_Id
               and Td.Filial_Id = i_Filial_Id
               and Td.Timeoff_Id = i_Timeoff_Id
               and exists (select *
                      from Htt_Timesheets t
                     where t.Company_Id = Td.Company_Id
                       and t.Filial_Id = Td.Filial_Id
                       and t.Staff_Id = Td.Staff_Id
                       and t.Timesheet_Date = Td.Timeoff_Date
                       and t.Timesheet_Id = Tf.Timesheet_Id));
  
    for r in (select t.Staff_Id,
                     t.Timesheet_Date,
                     t.Timesheet_Id,
                     t.Plan_Time,
                     t.Count_Lack,
                     Td.Time_Kind_Id,
                     t.Schedule_Kind,
                     Nvl((select 'Y'
                           from Htt_Timesheet_Locks Tl
                          where Tl.Company_Id = Td.Company_Id
                            and Tl.Filial_Id = Td.Filial_Id
                            and Tl.Staff_Id = Td.Staff_Id
                            and Tl.Timesheet_Date = Td.Timeoff_Date),
                         'N') Locked
                from Htt_Timesheets t
                join Hpd_Timeoff_Days Td
                  on Td.Company_Id = t.Company_Id
                 and Td.Filial_Id = t.Filial_Id
                 and Td.Staff_Id = t.Staff_Id
                 and Td.Timeoff_Date = t.Timesheet_Date
               where Td.Company_Id = i_Company_Id
                 and Td.Filial_Id = i_Filial_Id
                 and Td.Timeoff_Id = i_Timeoff_Id)
    loop
      if r.Locked = 'Y' then
        v_Turnout_Time := Htt_Util.Get_Fact_Value(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Staff_Id       => r.Staff_Id,
                                                  i_Timesheet_Date => r.Timesheet_Date,
                                                  i_Time_Kind_Id   => v_Turnout_Id);
      
        v_Fact_Value := r.Plan_Time - v_Turnout_Time;
      
        if i_Remove_Timeoff then
          v_Time_Kind_Id := v_Lack_Id;
        
          if r.Count_Lack = 'N' then
            v_Fact_Value := 0;
          end if;
        else
          v_Time_Kind_Id := r.Time_Kind_Id;
        end if;
      
        Gen_Timesheet_Fact(p_Facts         => v_Facts,
                           i_Company_Id    => i_Company_Id,
                           i_Filial_Id     => i_Filial_Id,
                           i_Timesheet_Id  => r.Timesheet_Id,
                           i_Time_Kind_Id  => v_Time_Kind_Id,
                           i_Fact_Value    => v_Fact_Value,
                           i_Schedule_Kind => r.Schedule_Kind);
      
        z_Htt_Timesheet_Locks.Update_One(i_Company_Id     => i_Company_Id,
                                         i_Filial_Id      => i_Filial_Id,
                                         i_Staff_Id       => r.Staff_Id,
                                         i_Timesheet_Date => r.Timesheet_Date,
                                         i_Facts_Changed  => Option_Varchar2('Y'));
      else
        Make_Dirty_Timesheet(i_Company_Id   => i_Company_Id,
                             i_Filial_Id    => i_Filial_Id,
                             i_Timesheet_Id => r.Timesheet_Id);
      end if;
    end loop;
  
    Insert_Timesheet_Facts(p_Facts     => v_Facts, --
                           p_Intervals => v_Intervals);
  end;

  ----------------------------------------------------------------------------------------------------        
  Procedure Insert_Overtime_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Overtime_Id number
  ) is
  begin
    for Od in (select d.*, t.Timesheet_Id
                 from Hpd_Overtime_Days d
                 join Htt_Timesheets t
                   on t.Company_Id = d.Company_Id
                  and t.Filial_Id = d.Filial_Id
                  and t.Timesheet_Date = d.Overtime_Date
                  and t.Staff_Id = d.Staff_Id
                where d.Company_Id = i_Company_Id
                  and d.Filial_Id = i_Filial_Id
                  and d.Overtime_Id = i_Overtime_Id)
    loop
      Insert_Timesheet_Overtime_Facts(i_Company_Id       => Od.Company_Id,
                                      i_Filial_Id        => Od.Filial_Id,
                                      i_Timesheet_Id     => Od.Timesheet_Id,
                                      i_Staff_Id         => Od.Staff_Id,
                                      i_Timesheet_Date   => Od.Overtime_Date,
                                      i_Overtime_Seconds => Od.Overtime_Seconds);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Remove_Overtime_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Overtime_Id number
  ) is
    v_Time_Kind_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  begin
    for Od in (select d.*, t.Timesheet_Id
                 from Hpd_Overtime_Days d
                 join Htt_Timesheets t
                   on t.Company_Id = d.Company_Id
                  and t.Filial_Id = d.Filial_Id
                  and t.Timesheet_Date = d.Overtime_Date
                  and t.Staff_Id = d.Staff_Id
                where d.Company_Id = i_Company_Id
                  and d.Filial_Id = i_Filial_Id
                  and d.Overtime_Id = i_Overtime_Id)
    loop
      z_Htt_Timesheet_Facts.Delete_One(i_Company_Id   => Od.Company_Id,
                                       i_Filial_Id    => Od.Filial_Id,
                                       i_Timesheet_Id => Od.Timesheet_Id,
                                       i_Time_Kind_Id => v_Time_Kind_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Adjustment_Fact
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Id   number,
    i_Timesheet_Date date
  ) is
    v_Turnout_Adjustment_Id  number;
    v_Overtime_Adjustment_Id number;
    v_Lack_Tk_Id             number;
    r_Fact                   Htt_Timesheet_Facts%rowtype;
  begin
    v_Turnout_Adjustment_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout_Adjustment);
    v_Overtime_Adjustment_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime_Adjustment);
    v_Lack_Tk_Id             := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    for r in (select (select a.Overtime
                        from Hpd_Page_Adjustments a
                       where a.Company_Id = i_Company_Id
                         and a.Filial_Id = i_Filial_Id
                         and a.Page_Id = q.Page_Id) as Overtime,
                     (select a.Turnout_Time
                        from Hpd_Page_Adjustments a
                       where a.Company_Id = i_Company_Id
                         and a.Filial_Id = i_Filial_Id
                         and a.Page_Id = q.Page_Id) as Turnout_Time,
                     q.Kind,
                     q.Staff_Id,
                     q.Adjustment_Date
                from Hpd_Lock_Adjustments q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Adjustment_Date = i_Timesheet_Date)
    loop
      continue when r.Overtime is null or r.Turnout_Time is null;
    
      z_Htt_Timesheet_Facts.Save_One(i_Company_Id   => i_Company_Id,
                                     i_Filial_Id    => i_Filial_Id,
                                     i_Timesheet_Id => i_Timesheet_Id,
                                     i_Time_Kind_Id => v_Overtime_Adjustment_Id,
                                     i_Fact_Value   => r.Overtime * 60);
    
      z_Htt_Timesheet_Facts.Save_One(i_Company_Id   => i_Company_Id,
                                     i_Filial_Id    => i_Filial_Id,
                                     i_Timesheet_Id => i_Timesheet_Id,
                                     i_Time_Kind_Id => v_Turnout_Adjustment_Id,
                                     i_Fact_Value   => r.Turnout_Time * 60);
    
      if r.Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete and r.Turnout_Time > 0 and
         z_Htt_Timesheet_Facts.Exist_Lock(i_Company_Id   => i_Company_Id,
                                          i_Filial_Id    => i_Filial_Id,
                                          i_Timesheet_Id => i_Timesheet_Id,
                                          i_Time_Kind_Id => v_Lack_Tk_Id,
                                          o_Row          => r_Fact) then
        z_Hpd_Adjustment_Deleted_Facts.Save_One(i_Company_Id      => i_Company_Id,
                                                i_Filial_Id       => i_Filial_Id,
                                                i_Staff_Id        => r.Staff_Id,
                                                i_Adjustment_Date => r.Adjustment_Date,
                                                i_Time_Kind_Id    => v_Lack_Tk_Id,
                                                i_Fact_Value      => Nvl(r_Fact.Fact_Value, 0));
      
        if r_Fact.Fact_Value > 0 then
          z_Htt_Timesheet_Facts.Update_One(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Timesheet_Id => i_Timesheet_Id,
                                           i_Time_Kind_Id => v_Lack_Tk_Id,
                                           i_Fact_Value   => Option_Number(Greatest(r_Fact.Fact_Value -
                                                                                    r.Turnout_Time * 60,
                                                                                    0)));
        end if;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Update_Status
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  ) is
    v_Used_Count   number;
    v_Tracks_Count number;
    v_Track_Status varchar2(1);
  begin
    select count(*)
      into v_Tracks_Count
      from Htt_Timesheet_Tracks Tt
     where Tt.Company_Id = i_Company_Id
       and Tt.Filial_Id = i_Filial_Id
       and Tt.Track_Id = i_Track_Id;
  
    select count(*)
      into v_Used_Count
      from Htt_Timesheet_Tracks Tt
     where Tt.Company_Id = i_Company_Id
       and Tt.Filial_Id = i_Filial_Id
       and Tt.Track_Id = i_Track_Id
       and Tt.Track_Used = 'Y';
  
    case
      when v_Tracks_Count = 0 then
        v_Track_Status := Htt_Pref.c_Track_Status_Draft;
      when v_Used_Count = 0 then
        v_Track_Status := Htt_Pref.c_Track_Status_Not_Used;
      when v_Used_Count < v_Tracks_Count then
        v_Track_Status := Htt_Pref.c_Track_Status_Partially_Used;
      else
        v_Track_Status := Htt_Pref.c_Track_Status_Used;
    end case;
  
    z_Htt_Tracks.Update_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Track_Id   => i_Track_Id,
                            i_Status     => Option_Varchar2(v_Track_Status));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Add
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Track_Id       number,
    i_Employee_Id    number,
    i_Track_Datetime date,
    i_Track_Type     varchar2,
    i_Trans_Input    varchar2,
    i_Trans_Output   varchar2,
    i_Trans_Check    varchar2
  ) is
    r_Track         Htt_Timesheet_Tracks%rowtype;
    v_Timesheet_Ids Array_Number := Array_Number();
    v_Track_Date    date := Trunc(i_Track_Datetime);
  begin
    if not z_Mhr_Employees.Exist_Lock(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Employee_Id => i_Employee_Id) then
      return;
    end if;
  
    r_Track.Company_Id     := i_Company_Id;
    r_Track.Filial_Id      := i_Filial_Id;
    r_Track.Track_Id       := i_Track_Id;
    r_Track.Track_Datetime := i_Track_Datetime;
    r_Track.Track_Type     := i_Track_Type;
    r_Track.Track_Used     := 'N';
    r_Track.Trans_Input    := i_Trans_Input;
    r_Track.Trans_Output   := i_Trans_Output;
    r_Track.Trans_Check    := i_Trans_Check;
  
    for r in (select *
                from Href_Staffs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Employee_Id = i_Employee_Id
                 and q.State = 'A'
                 and q.Hiring_Date <= v_Track_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Track_Date))
    loop
      v_Timesheet_Ids := v_Timesheet_Ids multiset union
                         Find_Track_Timesheets(i_Company_Id     => i_Company_Id,
                                               i_Filial_Id      => i_Filial_Id,
                                               i_Staff_Id       => r.Staff_Id,
                                               i_Track_Datetime => i_Track_Datetime);
    end loop;
  
    for i in 1 .. v_Timesheet_Ids.Count
    loop
      r_Track.Timesheet_Id := v_Timesheet_Ids(i);
    
      z_Htt_Timesheet_Tracks.Save_Row(r_Track);
    end loop;
  
    for i in 1 .. v_Timesheet_Ids.Count
    loop
      update Htt_Timesheet_Tracks Tt
         set Tt.Track_Type =
             (select t.Track_Type
                from Htt_Tracks t
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Track_Id = Tt.Track_Id)
       where Tt.Company_Id = i_Company_Id
         and Tt.Filial_Id = i_Filial_Id
         and Tt.Timesheet_Id = v_Timesheet_Ids(i);
    
      Gen_Timesheet_Facts(i_Company_Id   => i_Company_Id,
                          i_Filial_Id    => i_Filial_Id,
                          i_Timesheet_Id => v_Timesheet_Ids(i),
                          i_Send_Notify  => true);
    end loop;
  
    Track_Update_Status(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Track_Id   => i_Track_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Track_Id    number,
    i_Employee_Id number
  ) is
    r_Timesheet     Htt_Timesheets%rowtype;
    r_Timebook      Hpr_Timebooks%rowtype;
    v_Timesheet_Ids Array_Number;
  begin
    if not z_Mhr_Employees.Exist_Lock(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Employee_Id => i_Employee_Id) then
      return;
    end if;
  
    -- unused tracks are free for deletion
    delete from Htt_Timesheet_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Track_Id = i_Track_Id
       and q.Track_Used = 'N';
  
    delete from Htt_Timesheet_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Track_Id = i_Track_Id
    returning q.Timesheet_Id bulk collect into v_Timesheet_Ids;
  
    delete from Htt_Potential_Outputs Pt
     where Pt.Company_Id = i_Company_Id
       and Pt.Filial_Id = i_Filial_Id
       and Pt.Track_Id = i_Track_Id;
  
    for i in 1 .. v_Timesheet_Ids.Count
    loop
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Timesheet_Id => v_Timesheet_Ids(i));
    
      if z_Htt_Timesheet_Locks.Exist(i_Company_Id     => r_Timesheet.Company_Id,
                                     i_Filial_Id      => r_Timesheet.Filial_Id,
                                     i_Staff_Id       => r_Timesheet.Staff_Id,
                                     i_Timesheet_Date => r_Timesheet.Timesheet_Date) then
        r_Timebook := Get_Blocking_Timebook(i_Company_Id     => r_Timesheet.Company_Id,
                                            i_Filial_Id      => r_Timesheet.Filial_Id,
                                            i_Staff_Id       => r_Timesheet.Staff_Id,
                                            i_Timesheet_Date => r_Timesheet.Timesheet_Date);
      
        Htt_Error.Raise_007(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => r_Timesheet.Company_Id,
                                                                      i_Filial_Id  => r_Timesheet.Filial_Id,
                                                                      i_Staff_Id   => r_Timesheet.Staff_Id),
                            i_Timesheet_Date  => r_Timesheet.Timesheet_Date,
                            i_Timebook_Number => r_Timebook.Timebook_Number,
                            i_Timebook_Month  => r_Timebook.Month);
      end if;
    
      Make_Dirty_Timesheet(i_Company_Id   => i_Company_Id,
                           i_Filial_Id    => i_Filial_Id,
                           i_Timesheet_Id => v_Timesheet_Ids(i));
    end loop;
  
    z_Htt_Tracks.Update_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Track_Id   => i_Track_Id,
                            i_Status     => Option_Varchar2(Htt_Pref.c_Track_Status_Draft));
  end;

  ----------------------------------------------------------------------------------------------------
  -- temporarily disabled to allow migration of tracks between filials
  -- and due to the fact that trash tracks were mainly implemented as license cheat prevention
  -- since licenses don't work now, trash tracks are not needed
  Procedure Trash_Track_Insert(i_Track Htt_Tracks%rowtype) is
    r_Track Htt_Trash_Tracks%rowtype;
  begin
    return;
    z_Htt_Trash_Tracks.Init(p_Row            => r_Track,
                            i_Company_Id     => i_Track.Company_Id,
                            i_Filial_Id      => i_Track.Filial_Id,
                            i_Track_Id       => i_Track.Track_Id,
                            i_Track_Date     => i_Track.Track_Date,
                            i_Track_Time     => i_Track.Track_Time,
                            i_Track_Datetime => i_Track.Track_Datetime,
                            i_Person_Id      => i_Track.Person_Id,
                            i_Track_Type     => i_Track.Track_Type,
                            i_Mark_Type      => i_Track.Mark_Type,
                            i_Device_Id      => i_Track.Device_Id,
                            i_Location_Id    => i_Track.Location_Id,
                            i_Latlng         => i_Track.Latlng,
                            i_Accuracy       => i_Track.Accuracy,
                            i_Photo_Sha      => i_Track.Photo_Sha,
                            i_Note           => i_Track.Note,
                            i_Is_Valid       => i_Track.Is_Valid);
  
    z_Htt_Trash_Tracks.Insert_Row(r_Track);
  end;

  ----------------------------------------------------------------------------------------------------
  -- temporarily disabled to allow migration of tracks between filials
  -- and due to the fact that trash tracks were mainly implemented as license cheat prevention
  -- since licenses don't work now, trash tracks are not needed
  Procedure Make_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  ) is
    v_Periods Href_Pref.Period_Nt;
  
    --------------------------------------------------
    Procedure Move_Tracks_To_Trash
    (
      i_Begin_Date date,
      i_End_Date   date
    ) is
    begin
      for r in (select *
                  from Htt_Tracks Ht
                 where Ht.Company_Id = i_Company_Id
                   and Ht.Filial_Id = i_Filial_Id
                   and Ht.Person_Id = i_Person_Id
                   and Ht.Track_Date between i_Begin_Date and i_End_Date)
      loop
        Trash_Track_Insert(r);
      
        z_Htt_Tracks.Delete_One(i_Company_Id => r.Company_Id,
                                i_Filial_Id  => r.Filial_Id,
                                i_Track_Id   => r.Track_Id);
      end loop;
    end;
  begin
    return;
    v_Periods := Htt_Util.Track_Not_Accepted_Periods(i_Company_Id  => i_Company_Id,
                                                     i_Filial_Id   => i_Filial_Id,
                                                     i_Employee_Id => i_Person_Id);
  
    for i in 1 .. v_Periods.Count
    loop
      Move_Tracks_To_Trash(i_Begin_Date => v_Periods(i).Period_Begin,
                           i_End_Date   => v_Periods(i).Period_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Person
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Persistent boolean := false
  ) is
    v_Dummy varchar2(1);
  begin
    Hac_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id,
                               i_Person_Id  => i_Person_Id,
                               i_Persistent => i_Persistent);
  
    select 'x'
      into v_Dummy
      from Htt_Dirty_Persons q
     where q.Company_Id = i_Company_Id
       and q.Person_Id = i_Person_Id;
  exception
    when No_Data_Found then
      insert into Htt_Dirty_Persons
        (Company_Id, Person_Id)
      values
        (i_Company_Id, i_Person_Id);
    
      b.Add_Post_Callback('begin htt_core.notify_person_changes; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Person_Changes is
  begin
    for r in (select *
                from Htt_Dirty_Persons)
    loop
      Htt_Global.w_Person.Company_Id := r.Company_Id;
      Htt_Global.w_Person.Person_Id  := r.Person_Id;
    
      b.Notify_Watchers(i_Watching_Expr => 'htt_global.w_person',
                        i_Expr_Type     => 'htt_global.person_rt');
    end loop;
  
    delete Htt_Dirty_Persons;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Lock
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  ) is
  begin
    z_Htt_Timesheet_Locks.Insert_One(i_Company_Id     => i_Company_Id,
                                     i_Filial_Id      => i_Filial_Id,
                                     i_Staff_Id       => i_Staff_Id,
                                     i_Timesheet_Date => i_Timesheet_Date,
                                     i_Facts_Changed  => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timesheet_Unlock
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Timesheet_Date date
  ) is
    v_Facts_Changed    varchar2(1);
    v_Unused_Track_Ids Array_Number;
    r_Timesheet        Htt_Timesheets%rowtype;
  begin
    delete Htt_Timesheet_Locks Tl
     where Tl.Company_Id = i_Company_Id
       and Tl.Filial_Id = i_Filial_Id
       and Tl.Staff_Id = i_Staff_Id
       and Tl.Timesheet_Date = i_Timesheet_Date
    returning Tl.Facts_Changed into v_Facts_Changed;
  
    if v_Facts_Changed = 'Y' then
      r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => i_Company_Id,
                                        i_Filial_Id      => i_Filial_Id,
                                        i_Staff_Id       => i_Staff_Id,
                                        i_Timesheet_Date => i_Timesheet_Date);
    
      select Tt.Track_Id
        bulk collect
        into v_Unused_Track_Ids
        from Htt_Timesheet_Tracks Tt
       where Tt.Company_Id = r_Timesheet.Company_Id
         and Tt.Filial_Id = r_Timesheet.Filial_Id
         and Tt.Timesheet_Id = r_Timesheet.Timesheet_Id
         and Tt.Track_Used = 'N';
    
      -- regen facts
      Make_Dirty_Timesheet(i_Company_Id   => i_Company_Id,
                           i_Filial_Id    => i_Filial_Id,
                           i_Timesheet_Id => r_Timesheet.Timesheet_Id);
    
      -- change unused tracks status
      for i in 1 .. v_Unused_Track_Ids.Count
      loop
        Track_Update_Status(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Track_Id   => v_Unused_Track_Ids(i));
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Regenerate_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    v_Robot_Schedule_Id number := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    v_Staff_Schedule_Id number := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    v_Begin_Date        date := Trunc(i_Begin_Date);
    v_End_Date          date := Trunc(i_End_Date);
  begin
    if i_Schedule_Id = v_Robot_Schedule_Id then
      return;
    end if;
  
    if v_End_Date is null then
      -- user wants to regenerate all timesheets
      -- take max available schedule date for this schedule
      -- and delete all timesheets after this date
      if i_Schedule_Id = v_Staff_Schedule_Id then
        select max(d.Schedule_Date)
          into v_End_Date
          from Htt_Staff_Schedule_Days d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Staff_Id = i_Staff_Id
           and d.Schedule_Date >= v_Begin_Date;
      else
        select max(d.Schedule_Date)
          into v_End_Date
          from Htt_Schedule_Days d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Schedule_Id = i_Schedule_Id
           and d.Schedule_Date >= v_Begin_Date;
      end if;
    
      if v_End_Date is null then
        Delete_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Lower_Date => v_Begin_Date - 1);
      else
        Delete_Timesheets(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Lower_Date => v_End_Date);
      end if;
    
      v_End_Date := Nvl(v_End_Date, v_Begin_Date);
    end if;
  
    if i_Schedule_Id is null then
      delete Htt_Timesheets t
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Staff_Id = i_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and v_End_Date;
    end if;
  
    if i_Schedule_Id = v_Staff_Schedule_Id then
      Gen_Timesheet_Plan_Individual(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Staff_Id    => i_Staff_Id,
                                    i_Schedule_Id => i_Schedule_Id,
                                    i_Begin_Date  => i_Begin_Date,
                                    i_End_Date    => v_End_Date);
    else
      Gen_Timesheet_Plan(i_Company_Id  => i_Company_Id,
                         i_Filial_Id   => i_Filial_Id,
                         i_Staff_Id    => i_Staff_Id,
                         i_Schedule_Id => i_Schedule_Id,
                         i_Begin_Date  => i_Begin_Date,
                         i_End_Date    => v_End_Date);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Regenerate_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  ) is
    r_Schedule Htt_Schedules%rowtype;
  begin
    r_Schedule := z_Htt_Schedules.Take(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Schedule_Id => i_Schedule_Id);
  
    for i in 1 .. i_Dates.Count
    loop
      Gen_Timesheet_Plan(i_Company_Id     => i_Company_Id,
                         i_Filial_Id      => i_Filial_Id,
                         i_Staff_Id       => i_Staff_Id,
                         i_Schedule_Id    => i_Schedule_Id,
                         i_Calendar_Id    => r_Schedule.Calendar_Id,
                         i_Timesheet_Date => i_Dates(i),
                         i_Track_Duration => r_Schedule.Track_Duration,
                         i_Schedule_Kind  => r_Schedule.Schedule_Kind,
                         i_Count_Late     => r_Schedule.Count_Late,
                         i_Count_Early    => r_Schedule.Count_Early,
                         i_Count_Lack     => r_Schedule.Count_Lack,
                         i_Count_Free     => r_Schedule.Count_Free);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Timesheets
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Lower_Date date
  ) is
  begin
    delete Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date > i_Lower_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Command_Add
  (
    i_Company_Id   number,
    i_Device_Id    number,
    i_Command_Kind varchar2,
    i_Person_Id    number := null,
    i_Data         varchar2 := null
  ) is
  begin
    z_Htt_Acms_Commands.Insert_One(i_Company_Id       => i_Company_Id,
                                   i_Command_Id       => Htt_Next.Acms_Command_Id,
                                   i_Device_Id        => i_Device_Id,
                                   i_Command_Kind     => i_Command_Kind,
                                   i_Person_Id        => i_Person_Id,
                                   i_Data             => i_Data,
                                   i_Status           => Htt_Pref.c_Command_Status_New,
                                   i_State_Changed_On => sysdate);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Gps_Track_Distance is
    v_Total_Distance number;
  begin
    for Cmp in (select c.Company_Id,
                       (select i.User_System
                          from Md_Company_Infos i
                         where i.Company_Id = c.Company_Id) User_System,
                       (select i.Filial_Head
                          from Md_Company_Infos i
                         where i.Company_Id = c.Company_Id) Filial_Head
                  from Md_Companies c
                 where c.State = 'A'
                   and (exists (select 1
                                  from Md_Company_Projects Cp
                                 where Cp.Company_Id = c.Company_Id
                                   and Cp.Project_Code = Verifix.Project_Code) or
                        c.Company_Id = Md_Pref.c_Company_Head))
    loop
      for r in (select q.Company_Id, q.Filial_Id
                  from Md_Filials q
                 where q.Company_Id = Cmp.Company_Id
                   and q.Filial_Id <> Cmp.Filial_Head
                   and q.State = 'A')
      loop
        Biruni_Route.Context_Begin;
      
        Ui_Context.Init(i_User_Id      => Cmp.User_System,
                        i_Filial_Id    => r.Filial_Id,
                        i_Project_Code => Verifix.Project_Code);
      
        for Gt in (select q.Track_Id, q.Person_Id, q.Track_Date
                     from Htt_Gps_Tracks q
                    where q.Company_Id = r.Company_Id
                      and q.Filial_Id = r.Filial_Id
                      and q.Calculated = 'N')
        loop
          v_Total_Distance := Htt_Util.Calc_Gps_Track_Distance(i_Company_Id => r.Company_Id,
                                                               i_Filial_Id  => r.Filial_Id,
                                                               i_Person_Id  => Gt.Person_Id,
                                                               i_Track_Date => Gt.Track_Date);
        
          z_Htt_Gps_Tracks.Update_One(i_Company_Id     => r.Company_Id,
                                      i_Filial_Id      => r.Filial_Id,
                                      i_Track_Id       => Gt.Track_Id,
                                      i_Total_Distance => Option_Number(v_Total_Distance),
                                      i_Calculated     => Option_Varchar2('Y'));
        end loop;
      
        Biruni_Route.Context_End;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  ) is
    v_Person_Ids Array_Number;
    v_Date       date := Trunc(sysdate);
  begin
    select w.Employee_Id
      bulk collect
      into v_Person_Ids
      from Href_Staffs w
     where w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.State = 'A'
       and w.Hiring_Date <= v_Date
       and (w.Dismissal_Date is null or w.Dismissal_Date >= v_Date)
       and exists (select 1
              from Htt_Location_Divisions q
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Location_Id = i_Location_Id
               and w.Division_Id = q.Division_Id)
     group by w.Employee_Id;
  
    for i in 1 .. v_Person_Ids.Count
    loop
      Location_Add_Person(i_Company_Id  => i_Company_Id,
                          i_Filial_Id   => i_Filial_Id,
                          i_Location_Id => i_Location_Id,
                          i_Person_Id   => v_Person_Ids(i),
                          i_Attach_Type => Htt_Pref.c_Attach_Type_Auto);
    end loop;
  
    for r in (select *
                from Htt_Location_Persons q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Location_Id = i_Location_Id
                 and q.Attach_Type = Htt_Pref.c_Attach_Type_Auto
                 and q.Person_Id not in (select *
                                           from table(v_Person_Ids)))
    loop
      Location_Remove_Person(i_Company_Id  => r.Company_Id,
                             i_Filial_Id   => r.Filial_Id,
                             i_Location_Id => r.Location_Id,
                             i_Person_Id   => r.Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Person_Sync_Locations
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Persistent boolean := false
  ) is
    v_Location_Ids Array_Number;
    v_Date         date := Trunc(sysdate);
  
    --------------------------------------------------
    Function Exists_Location_Person return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Location_Persons p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Person_Id = i_Person_Id
         and p.Attach_Type = Htt_Pref.c_Attach_Type_Auto
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------
    Function Exists_Active_Staff(i_Date date) return boolean is
      v_Staff_Id number;
    begin
      v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_Company_Id,
                                                   i_Filial_Id   => i_Filial_Id,
                                                   i_Employee_Id => i_Person_Id,
                                                   i_Date        => i_Date);
    
      return v_Staff_Id is not null;
    end;
  begin
    if not Exists_Active_Staff(v_Date) and not Exists_Location_Person then
      return;
    end if;
  
    select q.Location_Id
      bulk collect
      into v_Location_Ids
      from Htt_Location_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and exists (select 1
              from Href_Staffs w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Division_Id = q.Division_Id
               and w.Employee_Id = i_Person_Id
               and w.Hiring_Date <= v_Date
               and (w.Dismissal_Date is null or w.Dismissal_Date >= v_Date)
               and w.State = 'A')
     group by q.Location_Id;
  
    for i in 1 .. v_Location_Ids.Count
    loop
      Location_Add_Person(i_Company_Id  => i_Company_Id,
                          i_Filial_Id   => i_Filial_Id,
                          i_Location_Id => v_Location_Ids(i),
                          i_Person_Id   => i_Person_Id,
                          i_Attach_Type => Htt_Pref.c_Attach_Type_Auto,
                          i_Persistent  => i_Persistent);
    end loop;
  
    for r in (select *
                from Htt_Location_Persons q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Person_Id = i_Person_Id
                 and q.Attach_Type = Htt_Pref.c_Attach_Type_Auto
                 and q.Location_Id not member of v_Location_Ids)
    loop
      Location_Remove_Person(i_Company_Id  => r.Company_Id,
                             i_Filial_Id   => r.Filial_Id,
                             i_Location_Id => r.Location_Id,
                             i_Person_Id   => r.Person_Id,
                             i_Persistent  => i_Persistent);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number,
    i_Attach_Type varchar2,
    i_Persistent  boolean := false
  ) is
    r_Location_Person Htt_Location_Persons%rowtype;
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
    v_Exists          boolean;
  begin
    v_Exists := z_Htt_Location_Persons.Exist_Lock(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Location_Id => i_Location_Id,
                                                  i_Person_Id   => i_Person_Id,
                                                  o_Row         => r_Location_Person);
  
    if not v_Exists or i_Attach_Type = Htt_Pref.c_Attach_Type_Manual or
       r_Location_Person.Attach_Type = Htt_Pref.c_Attach_Type_Global and
       i_Attach_Type = Htt_Pref.c_Attach_Type_Auto then
      z_Htt_Location_Persons.Save_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Location_Id => i_Location_Id,
                                      i_Person_Id   => i_Person_Id,
                                      i_Attach_Type => i_Attach_Type);
    
      if r_Location_Person.Company_Id is null then
        Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id,
                                   i_Person_Id  => i_Person_Id,
                                   i_Persistent => i_Persistent);
      end if;
    end if;
  
    if not v_Exists then
      v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
      v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
    
      for r in (select q.Device_Id
                  from Htt_Devices q
                 where q.Company_Id = i_Company_Id
                   and q.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                   and q.Location_Id = i_Location_Id
                   and q.State = 'A')
      loop
        Acms_Command_Add(i_Company_Id   => i_Company_Id,
                         i_Device_Id    => r.Device_Id,
                         i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Person,
                         i_Person_Id    => i_Person_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number,
    i_Persistent  boolean := false
  ) is
    r_Location_Persons Htt_Location_Persons%rowtype;
    v_Exists           boolean;
    v_Global_Exist     boolean;
    v_Date             date := Trunc(sysdate);
  
    --------------------------------------------------           
    Function Exist_In_Global return boolean is
      v_Setting        varchar2(1) := Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id,
                                                                         i_Filial_Id  => i_Filial_Id);
      v_Location_State varchar2(1) := z_Htt_Locations.Load(i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id).State;
      v_Person_State   varchar2(1) := z_Mhr_Employees.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Employee_Id => i_Person_Id).State;
    begin
      return v_Setting = 'Y' and v_Location_State = 'A' and Nvl(v_Person_State, 'P') = 'A';
    end;
  
    -------------------------------------------------- 
    Function Exists_Auto_Attach return boolean is
      v_Dummy varchar2(1);
    begin
      begin
        select 'x'
          into v_Dummy
          from Htt_Location_Divisions q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Location_Id = i_Location_Id
           and exists (select 1
                  from Href_Staffs w
                 where w.Company_Id = q.Company_Id
                   and w.Filial_Id = q.Filial_Id
                   and w.Employee_Id = i_Person_Id
                   and w.Division_Id = q.Division_Id
                   and w.State = 'A'
                   and w.Hiring_Date <= v_Date
                   and (w.Dismissal_Date is null or w.Dismissal_Date >= v_Date))
           and Rownum = 1;
      
        return true;
      exception
        when No_Data_Found then
          return false;
      end;
    end;
  begin
    v_Exists       := Exists_Auto_Attach;
    v_Global_Exist := Exist_In_Global;
  
    if z_Htt_Location_Persons.Exist_Lock(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Location_Id => i_Location_Id,
                                         i_Person_Id   => i_Person_Id,
                                         o_Row         => r_Location_Persons) then
      if v_Exists then
        z_Htt_Location_Persons.Update_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Location_Id => i_Location_Id,
                                          i_Person_Id   => i_Person_Id,
                                          i_Attach_Type => Option_Varchar2(Htt_Pref.c_Attach_Type_Auto));
      elsif v_Global_Exist then
        z_Htt_Location_Persons.Update_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Location_Id => i_Location_Id,
                                          i_Person_Id   => i_Person_Id,
                                          i_Attach_Type => Option_Varchar2(Htt_Pref.c_Attach_Type_Global));
      else
        z_Htt_Location_Persons.Delete_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Location_Id => i_Location_Id,
                                          i_Person_Id   => i_Person_Id);
      
        Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id,
                                   i_Person_Id  => i_Person_Id,
                                   i_Persistent => i_Persistent);
      
        declare
          v_Dt_Hikvision_Id number;
          v_Dt_Dahua_Id     number;
          v_Dummy           varchar2(1);
          v_Date            date := Trunc(sysdate);
        begin
          select 'X'
            into v_Dummy
            from Mr_Natural_Persons q
           where q.Company_Id = i_Company_Id
             and q.Person_Id = i_Person_Id
             and q.State = 'A'
             and exists (select 1
                    from Htt_Persons Hp
                   where Hp.Company_Id = i_Company_Id
                     and Hp.Person_Id = i_Person_Id)
             and exists
           (select 1
                    from Href_Staffs s
                   where s.Company_Id = i_Company_Id
                     and s.Filial_Id in (select Lp.Filial_Id
                                           from Htt_Location_Persons Lp
                                          where Lp.Company_Id = i_Company_Id
                                            and Lp.Location_Id = i_Location_Id
                                            and Lp.Person_Id = i_Person_Id)
                     and s.Employee_Id = i_Person_Id
                     and s.State = 'A'
                     and s.Hiring_Date <= v_Date
                     and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date));
        exception
          when No_Data_Found then
            v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
            v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
          
            for r in (select q.Device_Id
                        from Htt_Devices q
                       where q.Company_Id = i_Company_Id
                         and q.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                         and q.Location_Id = i_Location_Id
                         and q.State = 'A')
            loop
              Acms_Command_Add(i_Company_Id   => i_Company_Id,
                               i_Device_Id    => r.Device_Id,
                               i_Command_Kind => Htt_Pref.c_Command_Kind_Remove_Person,
                               i_Person_Id    => i_Person_Id);
            end loop;
        end;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Sync_Locations(i_Company_Id number) is
    v_Date        date := Trunc(sysdate);
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
                      i_Project_Code => Verifix.Project_Code);
    
      for St in (select q.Company_Id, q.Filial_Id, q.Employee_Id
                   from Href_Staffs q
                  where q.Company_Id = r.Company_Id
                    and q.Filial_Id = r.Filial_Id
                    and q.State = 'A'
                    and q.Hiring_Date <= v_Date
                    and (q.Dismissal_Date is null or q.Dismissal_Date + 1 >= v_Date)
                  group by q.Company_Id, q.Filial_Id, q.Employee_Id)
      loop
        Person_Sync_Locations(i_Company_Id => St.Company_Id,
                              i_Filial_Id  => St.Filial_Id,
                              i_Person_Id  => St.Employee_Id,
                              i_Persistent => true);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Global_Sync_Location_Persons
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Location_Ids Array_Number;
    v_Setting      varchar2(1) := Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id,
                                                                     i_Filial_Id  => i_Filial_Id);
  begin
    if v_Setting = 'Y' then
      select q.Location_Id
        bulk collect
        into v_Location_Ids
        from Htt_Locations q
       where q.Company_Id = i_Company_Id
         and exists (select 1
                from Htt_Location_Filials Lf
               where Lf.Company_Id = i_Company_Id
                 and Lf.Filial_Id = i_Filial_Id
                 and Lf.Location_Id = q.Location_Id);
    
      for i in 1 .. v_Location_Ids.Count
      loop
        Location_Global_Sync_All_Persons(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Location_Id => v_Location_Ids(i));
      end loop;
    else
      for r in (select *
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Attach_Type = Htt_Pref.c_Attach_Type_Global)
      loop
        Location_Remove_Person(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Location_Id => r.Location_Id,
                               i_Person_Id   => r.Person_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Global_Sync_All_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  ) is
    v_State        varchar2(1) := z_Htt_Locations.Load(i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id).State;
    v_Setting      varchar2(1) := Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id,
                                                                     i_Filial_Id  => i_Filial_Id);
    v_Employee_Ids Array_Number;
  begin
    if not z_Htt_Location_Filials.Exist(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Location_Id => i_Location_Id) or v_State = 'P' or
       v_Setting = 'N' then
      for r in (select q.Person_Id
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Location_Id = i_Location_Id
                   and q.Attach_Type = Htt_Pref.c_Attach_Type_Global)
      loop
        Location_Remove_Person(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Location_Id => i_Location_Id,
                               i_Person_Id   => r.Person_Id);
      end loop;
    else
      select q.Employee_Id
        bulk collect
        into v_Employee_Ids
        from Mhr_Employees q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.State = 'A';
    
      for i in 1 .. v_Employee_Ids.Count
      loop
        Location_Add_Person(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Location_Id => i_Location_Id,
                            i_Person_Id   => v_Employee_Ids(i),
                            i_Attach_Type => Htt_Pref.c_Attach_Type_Global);
      end loop;
    
      for r in (select q.Person_Id
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Location_Id = i_Location_Id
                   and q.Attach_Type = Htt_Pref.c_Attach_Type_Global
                   and q.Person_Id not member of v_Employee_Ids)
      loop
        Location_Remove_Person(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Location_Id => i_Location_Id,
                               i_Person_Id   => r.Person_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Global_Sync_All_Location
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  ) is
    v_State        varchar2(1) := z_Mhr_Employees.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Employee_Id => i_Person_Id).State;
    v_Setting      varchar2(1) := Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id,
                                                                     i_Filial_Id  => i_Filial_Id);
    v_Location_Ids Array_Number;
  begin
    if v_State = 'A' and v_Setting = 'Y' then
      select q.Location_Id
        bulk collect
        into v_Location_Ids
        from Htt_Locations q
       where q.Company_Id = i_Company_Id
         and q.State = 'A'
         and exists (select 1
                from Htt_Location_Filials Lf
               where Lf.Company_Id = i_Company_Id
                 and Lf.Filial_Id = i_Filial_Id
                 and Lf.Location_Id = q.Location_Id);
    
      for i in 1 .. v_Location_Ids.Count
      loop
        Location_Add_Person(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Location_Id => v_Location_Ids(i),
                            i_Person_Id   => i_Person_Id,
                            i_Attach_Type => Htt_Pref.c_Attach_Type_Global);
      end loop;
    
      for r in (select q.Location_Id
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Person_Id = i_Person_Id
                   and q.Attach_Type = Htt_Pref.c_Attach_Type_Global
                   and q.Location_Id not member of v_Location_Ids)
      loop
        Location_Remove_Person(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Location_Id => r.Location_Id,
                               i_Person_Id   => i_Person_Id);
      end loop;
    else
      for r in (select q.Location_Id
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Person_Id = i_Person_Id
                   and q.Attach_Type = Htt_Pref.c_Attach_Type_Global)
      loop
        Location_Remove_Person(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Location_Id => r.Location_Id,
                               i_Person_Id   => i_Person_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Qr_Codes is
    v_Date date := Trunc(sysdate) - 1;
  begin
    delete from Htt_Location_Qr_Codes q
     where q.Created_On < v_Date;
  
    commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Accrual_Evaluate
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Period          date
  ) is
    v_Period       date := Htt_Util.Year_Last_Day(Trunc(i_Period));
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    z_Htt_Request_Kind_Accruals.Delete_One(i_Company_Id      => i_Company_Id,
                                           i_Filial_Id       => i_Filial_Id,
                                           i_Staff_Id        => i_Staff_Id,
                                           i_Request_Kind_Id => i_Request_Kind_Id,
                                           i_Period          => v_Period,
                                           i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan);
  
    -- check that employee binded to request_kind
    if not z_Htt_Staff_Request_Kinds.Exist(i_Company_Id      => i_Company_Id,
                                           i_Filial_Id       => i_Filial_Id,
                                           i_Staff_Id        => i_Staff_Id,
                                           i_Request_Kind_Id => i_Request_Kind_Id) then
      return;
    end if;
  
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => i_Company_Id,
                                               i_Request_Kind_Id => i_Request_Kind_Id);
  
    if r_Request_Kind.Annually_Limited = 'N' then
      return;
    end if;
  
    z_Htt_Request_Kind_Accruals.Insert_One(i_Company_Id      => i_Company_Id,
                                           i_Filial_Id       => i_Filial_Id,
                                           i_Staff_Id        => i_Staff_Id,
                                           i_Request_Kind_Id => i_Request_Kind_Id,
                                           i_Period          => v_Period,
                                           i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan,
                                           i_Accrued_Days    => r_Request_Kind.Annual_Day_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Request_Kind_Accruals(i_Company_Id number) is
    v_Curr_Date       date := Trunc(sysdate);
    v_Curr_Year_Begin date := Trunc(v_Curr_Date, 'yyyy');
    v_Curr_Year_End   date := Htt_Util.Year_Last_Day(v_Curr_Date);
    v_Prev_Year_End   date := v_Curr_Year_Begin - 1;
    v_Filial_Head     number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System     number := Md_Pref.User_System(i_Company_Id);
  
    r_Accrual        Htt_Request_Kind_Accruals%rowtype;
    v_Carryover_Days number;
    v_Period         date;
  begin
    for Fl in (select q.Company_Id, q.Filial_Id
                 from Md_Filials q
                where q.Company_Id = i_Company_Id
                  and q.Filial_Id <> v_Filial_Head
                  and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => Fl.Filial_Id,
                      i_Project_Code => Verifix.Project_Code);
    
      for r in (select *
                  from Htt_Request_Kinds q
                 where q.Company_Id = i_Company_Id
                   and q.Annually_Limited = 'Y'
                   and q.State = 'A')
      loop
        for k in (select *
                    from Htt_Staff_Request_Kinds p
                   where p.Company_Id = i_Company_Id
                     and p.Filial_Id = Fl.Filial_Id
                     and p.Request_Kind_Id = r.Request_Kind_Id
                     and not exists
                   (select 1
                            from Htt_Request_Kind_Accruals Rk
                           where Rk.Company_Id = p.Company_Id
                             and Rk.Filial_Id = p.Filial_Id
                             and Rk.Staff_Id = p.Staff_Id
                             and Rk.Request_Kind_Id = p.Request_Kind_Id
                             and Rk.Period = v_Curr_Year_End
                             and Rk.Accrual_Kind = Htt_Pref.c_Accrual_Kind_Plan))
        loop
          Request_Kind_Accrual_Evaluate(i_Company_Id      => k.Company_Id,
                                        i_Filial_Id       => k.Filial_Id,
                                        i_Staff_Id        => k.Staff_Id,
                                        i_Request_Kind_Id => k.Request_Kind_Id,
                                        i_Period          => v_Curr_Year_End);
        
          -- when carryover policy is zero
          -- nothing should be carried over
          continue when r.Carryover_Policy = Htt_Pref.c_Carryover_Policy_Zero;
        
          r_Accrual := z_Htt_Request_Kind_Accruals.Take(i_Company_Id      => k.Company_Id,
                                                        i_Filial_Id       => k.Filial_Id,
                                                        i_Staff_Id        => k.Staff_Id,
                                                        i_Request_Kind_Id => k.Request_Kind_Id,
                                                        i_Period          => v_Prev_Year_End,
                                                        i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan);
        
          -- when previous year accrual does not exist
          -- there is nothing to carryover
          continue when r_Accrual.Company_Id is null;
        
          v_Carryover_Days := r.Annual_Day_Limit -
                              Htt_Util.Get_Request_Kind_Used_Days(i_Company_Id      => k.Company_Id,
                                                                  i_Filial_Id       => k.Filial_Id,
                                                                  i_Staff_Id        => k.Staff_Id,
                                                                  i_Request_Kind_Id => k.Request_Kind_Id,
                                                                  i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan,
                                                                  i_Period          => v_Prev_Year_End);
        
          -- when prevous year limit is used up 
          -- there is nothing to carryover
          continue when v_Carryover_Days = 0;
        
          if r.Carryover_Policy = Htt_Pref.c_Carryover_Policy_Cap then
            v_Carryover_Days := Least(v_Carryover_Days, r.Carryover_Cap_Days);
          end if;
        
          -- add least on expiry date
          v_Period := Least(v_Curr_Year_Begin + r.Carryover_Expires_Days, v_Curr_Year_End);
        
          z_Htt_Request_Kind_Accruals.Insert_One(i_Company_Id      => k.Company_Id,
                                                 i_Filial_Id       => k.Filial_Id,
                                                 i_Staff_Id        => k.Staff_Id,
                                                 i_Request_Kind_Id => k.Request_Kind_Id,
                                                 i_Period          => v_Period,
                                                 i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Carryover,
                                                 i_Accrued_Days    => v_Carryover_Days);
        end loop;
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Request_Kind_Accruals is
  begin
    for Cmp in (select q.Company_Id
                  from Md_Companies q
                 where q.State = 'A'
                   and (exists (select 1
                                  from Md_Company_Projects Cp
                                 where Cp.Company_Id = q.Company_Id
                                   and Cp.Project_Code = Verifix.Project_Code) or
                        q.Company_Id = Md_Pref.c_Company_Head))
    loop
      begin
        Gen_Request_Kind_Accruals(Cmp.Company_Id);
      
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Registry_Staffs
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    v_Format        varchar2(20) := 'yyyymmdd';
    v_Changed_Dates Fazo.Boolean_Code_Aat;
    v_Key           varchar2(20);
    v_Last_Date     date;
    v_Current_Date  date;
    v_Schedule_Id   number;
    --------------------------------------------------
    Procedure Put_Date(i_Date date) is
    begin
      v_Changed_Dates(to_char(i_Date, v_Format)) := true;
    end;
  
  begin
  
    Put_Date(i_Begin_Date);
    Put_Date(i_End_Date + 1);
  
    for r in (select q.Period
                from Hpd_Agreements q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
                 and q.Period between i_Begin_Date and i_End_Date)
    loop
      Put_Date(r.Period);
    end loop;
  
    v_Key       := v_Changed_Dates.First;
    v_Last_Date := null;
    while v_Key is not null
    loop
      v_Current_Date := to_date(v_Key, v_Format);
    
      if v_Last_Date is not null then
        v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id,
                                                          i_Staff_Id   => i_Staff_Id,
                                                          i_Period     => v_Last_Date);
      
        if v_Schedule_Id is null then
          delete Htt_Timesheets t
           where t.Company_Id = i_Company_Id
             and t.Filial_Id = i_Filial_Id
             and t.Staff_Id = i_Staff_Id
             and t.Timesheet_Date between v_Last_Date and v_Current_Date - 1;
        end if;
      
        if v_Schedule_Id = i_Schedule_Id then
          Gen_Timesheet_Plan_Individual(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Staff_Id    => i_Staff_Id,
                                        i_Schedule_Id => i_Schedule_Id,
                                        i_Begin_Date  => v_Last_Date,
                                        i_End_Date    => v_Current_Date - 1);
        end if;
      end if;
    
      v_Key       := v_Changed_Dates.Next(v_Key);
      v_Last_Date := v_Current_Date;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  -- %param i_Schedule_Id number individual robot schedule_id
  Procedure Gen_Registry_Robots
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Robot_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
  begin
    for r in (select p.Staff_Id,
                     Greatest(p.Begin_Date, i_Begin_Date) Begin_Date,
                     Least(p.End_Date, i_End_Date) End_Date
                from Hpd_Agreements_Cache p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Robot_Id = i_Robot_Id
                 and p.Begin_Date <= i_End_Date
                 and p.End_Date >= i_Begin_Date
                 and p.Schedule_Id = i_Schedule_Id)
    loop
      Gen_Timesheet_Plan_Individual(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Staff_Id    => r.Staff_Id,
                                    i_Robot_Id    => i_Robot_Id,
                                    i_Schedule_Id => i_Schedule_Id,
                                    i_Begin_Date  => r.Begin_Date,
                                    i_End_Date    => r.End_Date);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Gen_Individual_Dates
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  ) is
    r_Registry    Htt_Schedule_Registries%rowtype;
    v_Schedule_Id number;
  begin
    r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Registry_Id => i_Registry_Id);
  
    if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    elsif r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Robot then
      v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    else
      b.Raise_Not_Implemented;
    end if;
  
    for r in (select *
                from Htt_Registry_Units q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Registry_Id = i_Registry_Id)
    loop
      if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
        Gen_Registry_Staffs(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Schedule_Id => v_Schedule_Id,
                            i_Staff_Id    => r.Staff_Id,
                            i_Begin_Date  => Trunc(r_Registry.Month, 'MON'),
                            i_End_Date    => Last_Day(Trunc(r_Registry.Month)));
      else
        Gen_Registry_Robots(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Schedule_Id => v_Schedule_Id,
                            i_Robot_Id    => r.Robot_Id,
                            i_Begin_Date  => Trunc(r_Registry.Month, 'MON'),
                            i_End_Date    => Last_Day(Trunc(r_Registry.Month)));
      end if;
    end loop;
  end;

end Htt_Core;
/
