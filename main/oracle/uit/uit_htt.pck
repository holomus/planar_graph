create or replace package Uit_Htt is
  ----------------------------------------------------------------------------------------------------
  c_Status_Normal       constant varchar2(1) := 'N';
  c_Status_Unnormal     constant varchar2(1) := 'U';
  c_Status_No_Timesheet constant varchar2(1) := 'T';
  c_Status_Rest_Day     constant varchar2(1) := 'R';
  c_Status_Not_Begin    constant varchar2(1) := 'B';
  ----------------------------------------------------------------------------------------------------
  c_Open_Status_Late       constant varchar2(1) := 'L';
  c_Open_Status_Normal     constant varchar2(1) := 'N';
  c_Open_Status_Not_Opened constant varchar2(1) := 'O';
  ----------------------------------------------------------------------------------------------------
  c_Close_Status_Early      constant varchar2(1) := 'E';
  c_Close_Status_Normal     constant varchar2(1) := 'N';
  c_Close_Status_Not_Closed constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------
  Procedure Enable_Division_Cache
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  type Division_Info_Rt is record(
    Company_Id      number(20),
    Filial_Id       number(20),
    Division_Id     number(20),
    Period          date,
    Status          varchar2(1), -- (N)ormal, (U)nnormal, No (T)imesheet, (R)est day, Not (B)egin
    Open_Status     varchar2(1), -- Late, Normal, Not Open
    Close_Status    varchar2(1), -- Early, Normal, Not Closed
    Opened_Date     date,
    Closed_Date     date,
    Plan_Time       number,
    Intime          number,
    Fact_Time       number,
    Late_Time       number,
    Early_Time      number,
    Lack_Time       number,
    Not_Closed_Time number);
  type Division_Info_Nt is table of Division_Info_Rt;
  ----------------------------------------------------------------------------------------------------
  -- types used for timesheet with transfers report
  type Timesheet_Data_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Employee_Id      number,
    Timesheet_Id     number,
    Timesheet_Date   date,
    Schedule_Id      number,
    Calendar_Id      number,
    Day_Kind         varchar2(1),
    Track_Duration   number,
    Count_Late       varchar2(1),
    Count_Early      varchar2(1),
    Count_Lack       varchar2(1),
    Shift_Begin_Time date,
    Shift_End_Time   date,
    Input_Border     date,
    Output_Border    date,
    Begin_Time       date,
    End_Time         date,
    Break_Enabled    varchar2(1),
    Break_Begin_Time date,
    Break_End_Time   date,
    Plan_Time        number,
    Full_Time        number,
    Input_Time       date,
    Output_Time      date,
    Planned_Marks    number,
    Done_Marks       number,
    Timeoff_Tk_Id    number,
    Timeoff_Exists   varchar2(1),
    Licensed         varchar2(1),
    Date_Value       date);
  type Timesheet_Data_Nt is table of Timesheet_Data_Rt;
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Part_Rt is record(
    Begin_Date date,
    End_Date   date);
  type Timesheet_Part_Nt is table of Timesheet_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  type Staff_Robot_Part_Rt is record(
    Robot_Id    number,
    Division_Id number,
    Job_Id      number,
    Parts       Timesheet_Part_Nt);
  type Staff_Robot_Part_Nt is table of Staff_Robot_Part_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Get_Omitted_Parts
  (
    i_Schedule_Day Htt_Schedule_Days%rowtype,
    i_Time_Parts   Htt_Pref.Time_Part_Nt
  ) return Htt_Pref.Time_Part_Nt;
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Time_Parts
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Division_Id        number,
    i_Period             date,
    i_Merge_Datetime     date,
    i_Schedule_Day       Htt_Schedule_Days%rowtype,
    o_Late_Input         out date,
    o_Early_Output       out date,
    o_Input_Date         out date,
    o_Output_Date        out date,
    o_Last_Input         out date,
    o_Fact_Time_Parts    out Htt_Pref.Time_Part_Nt,
    o_Ommited_Time_Parts out Htt_Pref.Time_Part_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Time_Infos
  (
    i_Schedule_Day    Htt_Schedule_Days%rowtype,
    i_Late_Input      date,
    i_Early_Output    date,
    i_Last_Input      date,
    i_Fact_Times      Htt_Pref.Time_Part_Nt,
    i_Ommited_Times   Htt_Pref.Time_Part_Nt,
    o_Plan_Time       out number,
    o_Intime          out number,
    o_Fact_Time       out number,
    o_Late_Time       out number,
    o_Lack_Time       out number,
    o_Early_Time      out number,
    o_Not_Closed_Time out number
  );
  ----------------------------------------------------------------------------------------------------
  Function Division_Info
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_Period         date,
    i_Merge_Datetime date := null
  ) return Division_Info_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Division_Infos
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Period         date,
    i_Merge_Datetime date := null
  ) return Division_Info_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Division_Infos
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Division_Info_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Division_Ommited_Times
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_Period         date,
    i_Merge_Datetime date := null
  ) return Htt_Pref.Time_Part_Nt;
  ----------------------------------------------------------------------------------------------------
  Function To_Time_Seconds_Text
  (
    i_Seconds      number,
    i_Show_Minutes varchar2 := 'Y',
    i_Show_Words   varchar2 := 'Y'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits
  (
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Period_Begin    date,
    i_Period_End      date,
    i_Request_Id      number := null
  ) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Registry_Kind return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_Registry_Kind(i_Registry_Kind varchar2);
  ----------------------------------------------------------------------------------------------------
  Function Get_Location_Count_Of_Employee(i_Person_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(i_Device_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Persons
  (
    i_Device_Id  number,
    i_Person_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Schedule_Kind
  (
    i_Schedule_Kind varchar2,
    i_Form          varchar2 := null
  );
end Uit_Htt;
/
create or replace package body Uit_Htt is
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Rt is record(
    Timesheet_Id   number,
    Track_Duration number);
  type Timesheet_Nt is table of Timesheet_Rt;
  ----------------------------------------------------------------------------------------------------
  g_Division_Cache_Enabled boolean := false;

  ----------------------------------------------------------------------------------------------------
  Procedure Enable_Division_Cache
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    g_Division_Cache_Enabled := true;
  
    insert into Uit_Htt_Staff_Divisions
      (Company_Id, Filial_Id, Staff_Id, Division_Id, Period_Begin, Period_End)
      select Qr.Company_Id,
             Qr.Filial_Id,
             Qr.Staff_Id,
             (select q.Division_Id
                from Hpd_Trans_Robots q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Trans_Id = Qr.Trans_Id) Division_Id,
             Qr.Period Period_Begin,
             Nvl(Lead(Qr.Period) Over(partition by Qr.Staff_Id order by Qr.Period) - 1,
                 i_Period_End) Period_End
        from (select p.Company_Id, p.Filial_Id, p.Staff_Id, p.Period, p.Trans_Id
                from Hpd_Agreements p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and p.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and p.Period > i_Period_Begin
                 and p.Period <= i_Period_End
              union
              select p.Company_Id,
                     p.Filial_Id,
                     p.Staff_Id,
                     Greatest(max(p.Period), i_Period_Begin),
                     max(p.Trans_Id) Keep(Dense_Rank last order by p.Period) Trans_Id
                from Hpd_Agreements p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and p.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and p.Period <= i_Period_Begin
               group by p.Company_Id, p.Filial_Id, p.Staff_Id, p.Trans_Type) Qr
       where Qr.Staff_Id in
             (select s.Staff_Id
                from Href_Staffs s
               where s.Company_Id = i_Company_Id
                 and s.Filial_Id = i_Filial_Id
                 and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and s.Hiring_Date <= i_Period_End
                 and (s.Dismissal_Date is null or i_Period_Begin <= s.Dismissal_Date));
  end;
  ----------------------------------------------------------------------------------------------------
  Function Get_Omitted_Parts
  (
    i_Schedule_Day Htt_Schedule_Days%rowtype,
    i_Time_Parts   Htt_Pref.Time_Part_Nt
  ) return Htt_Pref.Time_Part_Nt is
    v_Begin_Date date;
    v_Part       Htt_Pref.Time_Part_Rt;
  
    v_Omitted_Part Htt_Pref.Time_Part_Rt;
    result         Htt_Pref.Time_Part_Nt := Htt_Pref.Time_Part_Nt();
  begin
    v_Begin_Date := i_Schedule_Day.Shift_Begin_Time;
  
    for i in 1 .. i_Time_Parts.Count
    loop
      v_Part := i_Time_Parts(i);
    
      continue when v_Begin_Date > v_Part.Output_Time or v_Part.Input_Time > i_Schedule_Day.Shift_End_Time;
    
      if v_Begin_Date not between v_Part.Input_Time and v_Part.Output_Time then
        v_Omitted_Part.Input_Time  := v_Begin_Date;
        v_Omitted_Part.Output_Time := v_Part.Input_Time;
      
        Result.Extend;
        result(Result.Count) := v_Omitted_Part;
      end if;
    
      v_Begin_Date := v_Part.Output_Time;
    end loop;
  
    if v_Begin_Date <= i_Schedule_Day.Shift_End_Time then
      v_Omitted_Part.Input_Time  := v_Begin_Date;
      v_Omitted_Part.Output_Time := i_Schedule_Day.Shift_End_Time;
    
      Result.Extend;
      result(Result.Count) := v_Omitted_Part;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Time_Parts
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Division_Id        number,
    i_Period             date,
    i_Merge_Datetime     date,
    i_Schedule_Day       Htt_Schedule_Days%rowtype,
    o_Late_Input         out date,
    o_Early_Output       out date,
    o_Input_Date         out date,
    o_Output_Date        out date,
    o_Last_Input         out date,
    o_Fact_Time_Parts    out Htt_Pref.Time_Part_Nt,
    o_Ommited_Time_Parts out Htt_Pref.Time_Part_Nt
  ) is
    v_Format varchar2(20) := 'yyyymmddhh24miss';
  
    v_Key    varchar2(20);
    v_Tracks Fazo.Date_Code_Aat;
  
    v_Track_Type  varchar2(2);
    v_Track_Types Array_Varchar2;
  
    v_Track_Time  date;
    v_Track_Times Array_Date;
  
    v_Input  date;
    v_Inputs Array_Date := Array_Date();
  
    v_Maybe_Late  boolean := true;
    v_Maybe_Early boolean := true;
  
    v_Input_Date  date;
    v_Output_Date date;
    v_Last_Input  date;
  
    v_Part       Htt_Pref.Time_Part_Rt;
    v_Timesheet  Timesheet_Rt;
    v_Timesheets Timesheet_Nt;
  begin
    o_Fact_Time_Parts    := Htt_Pref.Time_Part_Nt();
    o_Ommited_Time_Parts := Htt_Pref.Time_Part_Nt();
  
    if g_Division_Cache_Enabled then
      select Ht.Timesheet_Id, Ht.Track_Duration
        bulk collect
        into v_Timesheets
        from Htt_Timesheets Ht
       where Ht.Company_Id = i_Company_Id
         and Ht.Filial_Id = i_Filial_Id
         and exists (select q.Staff_Id
                from Uit_Htt_Staff_Divisions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Division_Id = i_Division_Id
                 and Ht.Staff_Id = q.Staff_Id
                 and i_Period between q.Period_Begin and q.Period_End)
         and Ht.Timesheet_Date = i_Period;
    else
      select Ht.Timesheet_Id, Ht.Track_Duration
        bulk collect
        into v_Timesheets
        from Href_Staffs s
        join Htt_Timesheets Ht
          on Ht.Company_Id = i_Company_Id
         and Ht.Filial_Id = i_Filial_Id
         and Ht.Staff_Id = s.Staff_Id
         and Ht.Timesheet_Date = i_Period
       where s.Company_Id = i_Company_Id
         and s.Filial_Id = i_Filial_Id
         and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and s.Hiring_Date <= i_Period
         and (s.Dismissal_Date is null or i_Period <= s.Dismissal_Date)
         and exists
       (select 1
                from Hpd_Agreements q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = s.Staff_Id
                 and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and q.Period = (select max(w.Period)
                                   from Hpd_Agreements w
                                  where w.Company_Id = i_Company_Id
                                    and w.Filial_Id = i_Filial_Id
                                    and w.Staff_Id = s.Staff_Id
                                    and w.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                    and w.Action = Hpd_Pref.c_Transaction_Action_Continue
                                    and w.Period <= i_Period)
                 and exists (select *
                        from Hpd_Trans_Robots k
                       where k.Company_Id = i_Company_Id
                         and k.Filial_Id = i_Filial_Id
                         and k.Trans_Id = q.Trans_Id
                         and k.Division_Id = i_Division_Id));
    end if;
  
    for i in 1 .. v_Timesheets.Count
    loop
      v_Timesheet := v_Timesheets(i);
    
      v_Inputs := Array_Date();
    
      select q.Track_Type, Trunc(q.Track_Datetime, 'mi')
        bulk collect
        into v_Track_Types, v_Track_Times
        from Htt_Timesheet_Tracks q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Timesheet_Id = v_Timesheet.Timesheet_Id
         and (i_Merge_Datetime is null or q.Track_Datetime <= i_Merge_Datetime)
       order by q.Track_Datetime, Decode(q.Track_Type, Htt_Pref.c_Track_Type_Input, 0, 1);
    
      if i_Merge_Datetime is not null then
        Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Output);
        Fazo.Push(v_Track_Times, i_Merge_Datetime);
      end if;
    
      v_Input_Date  := null;
      v_Output_Date := null;
      v_Last_Input  := null;
    
      for i in 1 .. v_Track_Types.Count
      loop
        v_Track_Type := v_Track_Types(i);
        v_Track_Time := v_Track_Times(i);
      
        if v_Track_Type = Htt_Pref.c_Track_Type_Input then
          if v_Track_Time <= i_Schedule_Day.End_Time then
            Fazo.Push(v_Inputs, v_Track_Time);
          
            v_Input_Date := Nvl(v_Input_Date, v_Track_Time);
            v_Input_Date := Least(v_Input_Date, v_Track_Time);
          
            v_Last_Input := Nvl(v_Last_Input, v_Track_Time);
            v_Last_Input := Greatest(v_Last_Input, v_Track_Time);
          end if;
        
          -- eval late time
          if v_Maybe_Late and v_Track_Time > i_Schedule_Day.Begin_Time and
             v_Track_Time < i_Schedule_Day.End_Time then
            o_Late_Input := Nvl(o_Late_Input, v_Track_Time);
            o_Late_Input := Least(o_Late_Input, v_Track_Time);
          end if;
        elsif v_Inputs.Count > 0 and v_Track_Type = Htt_Pref.c_Track_Type_Output then
          -- eval early time
          if v_Maybe_Early and v_Track_Time < i_Schedule_Day.End_Time and
             v_Track_Time >= i_Schedule_Day.Begin_Time then
            o_Early_Output := Nvl(o_Early_Output, v_Track_Time);
            o_Early_Output := Greatest(o_Early_Output, v_Track_Time);
          end if;
        
          -- Not checked shift and borders
          -- if thats need than we should add
        
          v_Input := null;
        
          for j in 1 .. v_Inputs.Count
          loop
            if Htt_Util.Time_Diff(v_Track_Time, v_Inputs(j)) <= v_Timesheet.Track_Duration then
              v_Input := v_Inputs(j);
              exit;
            end if;
          end loop;
        
          -- ignore late time
          if i_Schedule_Day.Begin_Time between v_Input and v_Track_Time then
            v_Maybe_Late := false;
            o_Late_Input := null;
          end if;
        
          -- ignore early time
          if v_Input < i_Schedule_Day.End_Time and i_Schedule_Day.End_Time <= v_Track_Time then
            v_Maybe_Early  := false;
            o_Early_Output := null;
          end if;
        
          if v_Input is not null then
            v_Key := to_char(v_Input, v_Format);
          
            if v_Tracks.Exists(v_Key) then
              v_Tracks(v_Key) := Greatest(v_Tracks(v_Key), v_Track_Time);
            else
              v_Tracks(v_Key) := v_Track_Time;
            end if;
          
            if v_Track_Time >= i_Schedule_Day.Begin_Time then
              v_Output_Date := Nvl(v_Output_Date, v_Track_Time);
              v_Output_Date := Greatest(v_Output_Date, v_Track_Time);
            elsif v_Input_Date is not null then
              v_Input_Date := null;
            end if;
          end if;
        
          v_Last_Input := null;
          v_Inputs     := Array_Date();
        end if;
      end loop;
    
      o_Input_Date := Nvl(o_Input_Date, v_Input_Date);
      o_Input_Date := Least(o_Input_Date, Nvl(v_Input_Date, o_Input_Date));
    
      o_Output_Date := Nvl(o_Output_Date, v_Output_Date);
      o_Output_Date := Greatest(o_Output_Date, Nvl(v_Output_Date, o_Output_Date));
    
      if v_Last_Input is not null then
        v_Key := to_char(v_Last_Input, v_Format);
      
        if not v_Tracks.Exists(v_Key) then
          v_Tracks(v_Key) := v_Last_Input;
        end if;
      end if;
    end loop;
  
    if o_Output_Date is null and o_Input_Date <= i_Schedule_Day.Begin_Time then
      o_Late_Input := null;
    end if;
  
    if i_Merge_Datetime = o_Output_Date then
      o_Output_Date := null;
    end if;
  
    v_Key := v_Tracks.First;
    while v_Key is not null
    loop
      if v_Part.Input_Time is null then
        v_Part.Input_Time  := to_date(v_Key, v_Format);
        v_Part.Output_Time := v_Tracks(v_Key);
      else
        if to_date(v_Key, v_Format) between v_Part.Input_Time and v_Part.Output_Time then
          v_Part.Output_Time := Greatest(v_Part.Output_Time, v_Tracks(v_Key));
        else
          if v_Part.Input_Time <= i_Schedule_Day.Shift_End_Time and
             v_Part.Output_Time >= i_Schedule_Day.Shift_Begin_Time then
            -- get intersected interval by shift
            v_Part.Input_Time  := Greatest(v_Part.Input_Time, i_Schedule_Day.Shift_Begin_Time);
            v_Part.Output_Time := Least(v_Part.Output_Time, i_Schedule_Day.Shift_End_Time);
          
            if v_Part.Input_Time <> v_Part.Output_Time then
              o_Last_Input := null;
            
              o_Fact_Time_Parts.Extend;
              o_Fact_Time_Parts(o_Fact_Time_Parts.Count) := v_Part;
            else
              o_Last_Input := Nvl(o_Last_Input, v_Part.Input_Time);
              o_Last_Input := Least(o_Last_Input, v_Part.Input_Time);
            end if;
          end if;
        
          v_Part.Input_Time  := to_date(v_Key, v_Format);
          v_Part.Output_Time := v_Tracks(v_Key);
        end if;
      end if;
    
      v_Key := v_Tracks.Next(v_Key);
    end loop;
  
    if v_Part.Input_Time is not null and --
       v_Part.Input_Time <= i_Schedule_Day.Shift_End_Time and
       v_Part.Output_Time >= i_Schedule_Day.Shift_Begin_Time then
      -- get intersected interval by shift
      v_Part.Input_Time  := Greatest(v_Part.Input_Time, i_Schedule_Day.Shift_Begin_Time);
      v_Part.Output_Time := Least(v_Part.Output_Time, i_Schedule_Day.Shift_End_Time);
    
      if v_Part.Input_Time <> v_Part.Output_Time then
        o_Last_Input := null;
      
        o_Fact_Time_Parts.Extend;
        o_Fact_Time_Parts(o_Fact_Time_Parts.Count) := v_Part;
      else
        o_Last_Input := Nvl(o_Last_Input, v_Part.Input_Time);
        o_Last_Input := Least(o_Last_Input, v_Part.Input_Time);
      end if;
    end if;
  
    o_Ommited_Time_Parts := Get_Omitted_Parts(i_Schedule_Day => i_Schedule_Day,
                                              i_Time_Parts   => o_Fact_Time_Parts);
  
    if o_Last_Input is not null then
      o_Output_Date := null;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Time_Infos
  (
    i_Schedule_Day    Htt_Schedule_Days%rowtype,
    i_Late_Input      date,
    i_Early_Output    date,
    i_Last_Input      date,
    i_Fact_Times      Htt_Pref.Time_Part_Nt,
    i_Ommited_Times   Htt_Pref.Time_Part_Nt,
    o_Plan_Time       out number,
    o_Intime          out number,
    o_Fact_Time       out number,
    o_Late_Time       out number,
    o_Lack_Time       out number,
    o_Early_Time      out number,
    o_Not_Closed_Time out number
  ) is
    v_Part Htt_Pref.Time_Part_Rt;
  begin
    o_Plan_Time       := Htt_Util.Time_Diff(i_Schedule_Day.End_Time, i_Schedule_Day.Begin_Time);
    o_Intime          := 0;
    o_Fact_Time       := 0;
    o_Late_Time       := 0;
    o_Lack_Time       := 0;
    o_Early_Time      := 0;
    o_Not_Closed_Time := 0;
  
    for i in 1 .. i_Fact_Times.Count
    loop
      v_Part := i_Fact_Times(i);
    
      o_Intime := o_Intime +
                  Htt_Util.Timeline_Intersection(i_Fr_Begin => i_Schedule_Day.Begin_Time,
                                                 i_Fr_End   => i_Schedule_Day.End_Time,
                                                 i_Sc_Begin => v_Part.Input_Time,
                                                 i_Sc_End   => v_Part.Output_Time);
    
      o_Fact_Time := o_Fact_Time +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => i_Schedule_Day.Shift_Begin_Time,
                                                    i_Fr_End   => i_Schedule_Day.Shift_End_Time,
                                                    i_Sc_Begin => v_Part.Input_Time,
                                                    i_Sc_End   => v_Part.Output_Time);
    end loop;
  
    for i in 1 .. i_Ommited_Times.Count
    loop
      v_Part := i_Ommited_Times(i);
    
      o_Lack_Time := o_Lack_Time +
                     Htt_Util.Timeline_Intersection(i_Fr_Begin => i_Schedule_Day.Begin_Time,
                                                    i_Fr_End   => i_Schedule_Day.End_Time,
                                                    i_Sc_Begin => v_Part.Input_Time,
                                                    i_Sc_End   => v_Part.Output_Time);
    end loop;
  
    -- there is check for day-and-night schedule
    if i_Schedule_Day.Plan_Time < 1440 then
      if i_Late_Input is not null then
        o_Late_Time := Htt_Util.Time_Diff(i_Late_Input, i_Schedule_Day.Begin_Time);
      end if;
    
      if i_Early_Output is not null and i_Last_Input is null then
        o_Early_Time := Htt_Util.Time_Diff(i_Schedule_Day.End_Time, i_Early_Output);
      end if;
    
      if i_Last_Input is not null then
        o_Not_Closed_Time := Htt_Util.Time_Diff(i_Schedule_Day.End_Time,
                                                Greatest(i_Last_Input, i_Schedule_Day.Begin_Time));
      end if;
    
      o_Lack_Time := o_Lack_Time - o_Late_Time - o_Early_Time - o_Not_Closed_Time;
    else
      o_Late_Time       := 0;
      o_Early_Time      := 0;
      o_Not_Closed_Time := 0;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Division_Info
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_Period         date,
    i_Merge_Datetime date
  ) return Division_Info_Rt is
    r_Division     Hrm_Division_Schedules%rowtype;
    r_Schedule_Day Htt_Schedule_Days%rowtype;
  
    v_Late_Input   date;
    v_Early_Output date;
    v_Last_Input   date;
  
    v_Fact_Time_Parts    Htt_Pref.Time_Part_Nt;
    v_Ommited_Time_Parts Htt_Pref.Time_Part_Nt;
  
    result Division_Info_Rt;
  begin
    r_Division := z_Hrm_Division_Schedules.Take(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => i_Division_Id);
  
    Result.Company_Id      := i_Company_Id;
    Result.Filial_Id       := i_Filial_Id;
    Result.Division_Id     := i_Division_Id;
    Result.Period          := i_Period;
    Result.Status          := c_Status_Unnormal;
    Result.Open_Status     := null;
    Result.Close_Status    := null;
    Result.Late_Time       := 0;
    Result.Early_Time      := 0;
    Result.Lack_Time       := 0;
    Result.Not_Closed_Time := 0;
  
    if r_Division.Schedule_Id is null then
      Result.Status := c_Status_No_Timesheet;
    
      return result;
    end if;
  
    r_Schedule_Day := z_Htt_Schedule_Days.Take(i_Company_Id    => i_Company_Id,
                                               i_Filial_Id     => i_Filial_Id,
                                               i_Schedule_Id   => r_Division.Schedule_Id,
                                               i_Schedule_Date => i_Period);
  
    if r_Schedule_Day.Company_Id is null then
      Result.Status := c_Status_No_Timesheet;
    
      return result;
    end if;
  
    if r_Schedule_Day.Day_Kind != Htt_Pref.c_Day_Kind_Work then
      Result.Status := c_Status_Rest_Day;
      return result;
    end if;
  
    if i_Merge_Datetime is not null then
      if i_Merge_Datetime < r_Schedule_Day.Begin_Time then
        Result.Status := c_Status_Not_Begin;
        return result;
      end if;
    
      r_Schedule_Day.Shift_End_Time := Least(r_Schedule_Day.Shift_End_Time, i_Merge_Datetime);
      r_Schedule_Day.End_Time       := Least(r_Schedule_Day.End_Time, r_Schedule_Day.Shift_End_Time);
    end if;
  
    Eval_Time_Parts(i_Company_Id         => i_Company_Id,
                    i_Filial_Id          => i_Filial_Id,
                    i_Division_Id        => i_Division_Id,
                    i_Period             => i_Period,
                    i_Merge_Datetime     => i_Merge_Datetime,
                    i_Schedule_Day       => r_Schedule_Day,
                    o_Late_Input         => v_Late_Input,
                    o_Early_Output       => v_Early_Output,
                    o_Input_Date         => Result.Opened_Date,
                    o_Output_Date        => Result.Closed_Date,
                    o_Last_Input         => v_Last_Input,
                    o_Fact_Time_Parts    => v_Fact_Time_Parts,
                    o_Ommited_Time_Parts => v_Ommited_Time_Parts);
  
    Eval_Time_Infos(i_Schedule_Day    => r_Schedule_Day,
                    i_Late_Input      => v_Late_Input,
                    i_Early_Output    => v_Early_Output,
                    i_Last_Input      => v_Last_Input,
                    i_Fact_Times      => v_Fact_Time_Parts,
                    i_Ommited_Times   => v_Ommited_Time_Parts,
                    o_Plan_Time       => Result.Plan_Time,
                    o_Intime          => Result.Intime,
                    o_Fact_Time       => Result.Fact_Time,
                    o_Late_Time       => Result.Late_Time,
                    o_Lack_Time       => Result.Lack_Time,
                    o_Early_Time      => Result.Early_Time,
                    o_Not_Closed_Time => Result.Not_Closed_Time);
  
    if Result.Intime = Result.Plan_Time then
      Result.Status := c_Status_Normal;
    end if;
  
    Result.Open_Status := c_Open_Status_Normal;
    if Result.Late_Time > 0 then
      Result.Open_Status := c_Open_Status_Late;
    elsif Result.Intime = 0 and Result.Opened_Date is null then
      Result.Open_Status := c_Open_Status_Not_Opened;
    end if;
  
    if Result.Open_Status = c_Open_Status_Not_Opened then
      Result.Lack_Time    := 0;
      Result.Close_Status := null;
    else
      Result.Close_Status := c_Close_Status_Normal;
      if Result.Early_Time > 0 then
        Result.Close_Status := c_Close_Status_Early;
      elsif Result.Not_Closed_Time > 0 then
        Result.Close_Status := c_Close_Status_Not_Closed;
      end if;
    end if;
  
    if r_Schedule_Day.Plan_Time >= 1440 then
      Result.Lack_Time := 0;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Division_Infos
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Period         date,
    i_Merge_Datetime date
  ) return Division_Info_Nt
    pipelined is
  begin
    for r in (select q.Division_Id
                from Mhr_Divisions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id)
    loop
      pipe row(Division_Info(i_Company_Id     => i_Company_Id,
                             i_Filial_Id      => i_Filial_Id,
                             i_Division_Id    => r.Division_Id,
                             i_Period         => i_Period,
                             i_Merge_Datetime => i_Merge_Datetime));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Division_Infos
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Division_Info_Nt
    pipelined is
    v_Date date := sysdate;
  begin
    for r in (select q.Division_Id,
                     w.Period,
                     case
                        when Trunc(v_Date) = w.Period then
                         v_Date
                        else
                         null
                      end as Merge_Datetime
                from Mhr_Divisions q
               cross join (select (i_Period_Begin + level - 1) as Period
                            from Dual
                          connect by level <= (i_Period_End - i_Period_Begin + 1)) w
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id)
    loop
      pipe row(Division_Info(i_Company_Id     => i_Company_Id,
                             i_Filial_Id      => i_Filial_Id,
                             i_Division_Id    => r.Division_Id,
                             i_Period         => r.Period,
                             i_Merge_Datetime => r.Merge_Datetime));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Division_Ommited_Times
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_Period         date,
    i_Merge_Datetime date
  ) return Htt_Pref.Time_Part_Nt is
    r_Division     Hrm_Division_Schedules%rowtype;
    r_Schedule_Day Htt_Schedule_Days%rowtype;
  
    v_Late_Input   date;
    v_Early_Output date;
    v_Last_Input   date;
    v_Input_Date   date;
    v_Output_Date  date;
  
    v_Fact_Time_Parts    Htt_Pref.Time_Part_Nt;
    v_Ommited_Time_Parts Htt_Pref.Time_Part_Nt;
  
    v_Part Htt_Pref.Time_Part_Rt;
    result Htt_Pref.Time_Part_Nt := Htt_Pref.Time_Part_Nt();
  begin
    r_Division := z_Hrm_Division_Schedules.Take(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => i_Division_Id);
  
    if r_Division.Schedule_Id is null then
      return Htt_Pref.Time_Part_Nt();
    end if;
  
    r_Schedule_Day := z_Htt_Schedule_Days.Take(i_Company_Id    => i_Company_Id,
                                               i_Filial_Id     => i_Filial_Id,
                                               i_Schedule_Id   => r_Division.Schedule_Id,
                                               i_Schedule_Date => i_Period);
  
    if r_Schedule_Day.Company_Id is null then
      return Htt_Pref.Time_Part_Nt();
    end if;
  
    if r_Schedule_Day.Day_Kind != Htt_Pref.c_Day_Kind_Work then
      return Htt_Pref.Time_Part_Nt();
    end if;
  
    if i_Merge_Datetime is not null then
      if i_Merge_Datetime < r_Schedule_Day.Begin_Time then
        return Htt_Pref.Time_Part_Nt();
      end if;
    
      r_Schedule_Day.Shift_End_Time := Least(r_Schedule_Day.Shift_End_Time, i_Merge_Datetime);
      r_Schedule_Day.End_Time       := Least(r_Schedule_Day.End_Time, r_Schedule_Day.Shift_End_Time);
    end if;
  
    Eval_Time_Parts(i_Company_Id         => i_Company_Id,
                    i_Filial_Id          => i_Filial_Id,
                    i_Division_Id        => i_Division_Id,
                    i_Period             => i_Period,
                    i_Merge_Datetime     => i_Merge_Datetime,
                    i_Schedule_Day       => r_Schedule_Day,
                    o_Late_Input         => v_Late_Input,
                    o_Early_Output       => v_Early_Output,
                    o_Last_Input         => v_Last_Input,
                    o_Input_Date         => v_Input_Date,
                    o_Output_Date        => v_Output_Date,
                    o_Fact_Time_Parts    => v_Fact_Time_Parts,
                    o_Ommited_Time_Parts => v_Ommited_Time_Parts);
  
    for i in 1 .. v_Ommited_Time_Parts.Count
    loop
      v_Part := v_Ommited_Time_Parts(i);
    
      v_Part.Input_Time  := Greatest(v_Part.Input_Time, r_Schedule_Day.Begin_Time);
      v_Part.Output_Time := Least(v_Part.Output_Time, r_Schedule_Day.End_Time);
      continue when Htt_Util.Time_Diff(Trunc(v_Part.Output_Time, 'mi'),
                                       Trunc(v_Part.Input_Time, 'mi')) = 0;
      if v_Part.Input_Time <= v_Part.Output_Time then
        Result.Extend;
        result(Result.Count) := v_Part;
      end if;
    end loop;
  
    --    return v_Ommited_Time_Parts;
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Time_Seconds_Text
  (
    i_Seconds      number,
    i_Show_Minutes varchar2 := 'Y',
    i_Show_Words   varchar2 := 'Y'
  ) return varchar2 is
  begin
    return Htt_Util.To_Time_Seconds_Text(i_Seconds      => i_Seconds,
                                         i_Show_Minutes => i_Show_Minutes = 'Y',
                                         i_Show_Words   => i_Show_Words = 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits
  (
    i_Staff_Id        number,
    i_Request_Kind_Id number,
    i_Period_Begin    date,
    i_Period_End      date,
    i_Request_Id      number := null
  ) return Arraylist is
    r_Request_Kind Htt_Request_Kinds%rowtype;
    v_Period_Begin date := Trunc(i_Period_Begin);
    v_Period_End   date := Trunc(i_Period_End);
    v_Begin_Date   date := Htt_Util.Year_Last_Day(v_Period_Begin);
    v_End_Date     date := Htt_Util.Year_Last_Day(v_Period_End);
  
    result Arraylist := Arraylist();
  
    --------------------------------------------------
    Procedure Push_Accruals
    (
      i_Year_Begin date,
      i_Year_End   date
    ) is
      r_Accrual   Htt_Request_Kind_Accruals%rowtype;
      v_Used_Days number;
    
      v_Begin_Time date := Greatest(v_Period_Begin, i_Year_Begin);
      v_End_Time   date := Least(v_Period_End, i_Year_End);
    
      v_Accrual Hashmap := Hashmap();
    begin
      -- plan days
      begin
        r_Accrual := Htt_Util.Load_Request_Kind_Accrual(i_Company_Id      => Ui.Company_Id,
                                                        i_Filial_Id       => Ui.Filial_Id,
                                                        i_Staff_Id        => i_Staff_Id,
                                                        i_Request_Kind_Id => r_Request_Kind.Request_Kind_Id,
                                                        i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan,
                                                        i_Period_Begin    => v_Begin_Time,
                                                        i_Period_End      => v_End_Time);
      
        r_Accrual.Accrued_Days := Nvl(r_Accrual.Accrued_Days, 0);
      
        v_Used_Days := Htt_Util.Get_Request_Kind_Used_Days(i_Company_Id      => Ui.Company_Id,
                                                           i_Filial_Id       => Ui.Filial_Id,
                                                           i_Staff_Id        => i_Staff_Id,
                                                           i_Request_Kind_Id => r_Request_Kind.Request_Kind_Id,
                                                           i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Plan,
                                                           i_Period          => v_End_Time,
                                                           i_Request_Id      => i_Request_Id);
      
        r_Accrual.Period := Nvl(r_Accrual.Period, Trunc(v_End_Time));
      
        v_Accrual.Put('plan_begin_date', Trunc(r_Accrual.Period, 'yyyy'));
        v_Accrual.Put('plan_end_date', r_Accrual.Period);
        v_Accrual.Put('plan_accrued_days', r_Accrual.Accrued_Days);
        v_Accrual.Put('plan_used_days', v_Used_Days);
        v_Accrual.Put('plan_left_days', r_Accrual.Accrued_Days - v_Used_Days);
      exception
        when No_Data_Found then
          null;
      end;
    
      -- carryover days
      begin
        r_Accrual := Htt_Util.Load_Request_Kind_Accrual(i_Company_Id      => Ui.Company_Id,
                                                        i_Filial_Id       => Ui.Filial_Id,
                                                        i_Staff_Id        => i_Staff_Id,
                                                        i_Request_Kind_Id => r_Request_Kind.Request_Kind_Id,
                                                        i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Carryover,
                                                        i_Period_Begin    => v_Begin_Time,
                                                        i_Period_End      => v_End_Time);
      
        r_Accrual.Accrued_Days := Nvl(r_Accrual.Accrued_Days, 0);
      
        v_Used_Days := Htt_Util.Get_Request_Kind_Used_Days(i_Company_Id      => Ui.Company_Id,
                                                           i_Filial_Id       => Ui.Filial_Id,
                                                           i_Staff_Id        => i_Staff_Id,
                                                           i_Request_Kind_Id => r_Request_Kind.Request_Kind_Id,
                                                           i_Accrual_Kind    => Htt_Pref.c_Accrual_Kind_Carryover,
                                                           i_Period          => v_End_Time,
                                                           i_Request_Id      => i_Request_Id);
      
        v_Accrual.Put('carryover_begin_date', Nvl(Trunc(r_Accrual.Period, 'yyyy'), v_Begin_Time));
        v_Accrual.Put('carryover_end_date', Nvl(r_Accrual.Period, v_End_Time));
        v_Accrual.Put('carryover_accrued_days', r_Accrual.Accrued_Days);
        v_Accrual.Put('carryover_used_days', v_Used_Days);
        v_Accrual.Put('carryover_left_days', r_Accrual.Accrued_Days - v_Used_Days);
      exception
        when No_Data_Found then
          null;
      end;
    
      Result.Push(v_Accrual);
    end;
  begin
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => Ui.Company_Id,
                                               i_Request_Kind_Id => i_Request_Kind_Id);
  
    if r_Request_Kind.Annually_Limited = 'N' then
      return result;
    end if;
  
    while v_Begin_Date <= v_End_Date
    loop
      v_Begin_Date := Htt_Util.Year_Last_Day(v_Begin_Date);
    
      Push_Accruals(i_Year_Begin => Trunc(v_Begin_Date, 'yyyy'), i_Year_End => v_Begin_Date);
    
      v_Begin_Date := v_Begin_Date + 1;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Registry_Kind return varchar2 is
  begin
    if Ui.Request_Mode like '%staff%' then
      return Htt_Pref.c_Registry_Kind_Staff;
    elsif Ui.Request_Mode like '%robot%' then
      return Htt_Pref.c_Registry_Kind_Robot;
    else
      b.Raise_Not_Implemented;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_Registry_Kind(i_Registry_Kind varchar2) is
  begin
    if Get_Registry_Kind <> i_Registry_Kind then
      b.Raise_Not_Implemented;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Location_Count_Of_Employee(i_Person_Id number) return number is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Htt_Location_Persons Lp
     where Lp.Company_Id = Ui.Company_Id
       and Lp.Filial_Id = Ui.Filial_Id
       and Lp.Person_Id = i_Person_Id
       and not exists (select 1
              from Htt_Blocked_Person_Tracking Bp
             where Bp.Company_Id = Lp.Company_Id
               and Bp.Filial_Id = Lp.Filial_Id
               and Bp.Employee_Id = Lp.Person_Id);
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(i_Device_Id number) is
    r_Device Htt_Devices%rowtype;
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id, i_Device_Id => i_Device_Id);
  
    if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
      Hzk_Api.Device_Sync(i_Company_Id => r_Device.Company_Id, i_Device_Id => r_Device.Device_Id);
    elsif r_Device.Device_Type_Id in
          (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
           Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) then
      Htt_Api.Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                               i_Device_Id    => r_Device.Device_Id,
                               i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Device);
    
      Htt_Api.Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                               i_Device_Id    => r_Device.Device_Id,
                               i_Command_Kind => Htt_Pref.c_Command_Kind_Update_All_Device_Persons);
    
      Hac_Api.Sync_Device(i_Company_Id => r_Device.Company_Id, i_Device_Id => r_Device.Device_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Persons
  (
    i_Device_Id  number,
    i_Person_Ids Array_Number
  ) is
    r_Device Htt_Devices%rowtype;
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id, i_Device_Id => i_Device_Id);
  
    if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
      for i in 1 .. i_Person_Ids.Count
      loop
        Hzk_External.Sync_Person(i_Company_Id => r_Device.Company_Id,
                                 i_Device_Id  => r_Device.Device_Id,
                                 i_Person_Id  => i_Person_Ids(i));
      end loop;
    elsif r_Device.Device_Type_Id in
          (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
           Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) then
      for i in 1 .. i_Person_Ids.Count
      loop
        Htt_Api.Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                                 i_Device_Id    => r_Device.Device_Id,
                                 i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Person,
                                 i_Person_Id    => i_Person_Ids(i));
      
        Hac_Api.Force_Sync_Person(i_Company_Id => r_Device.Company_Id,
                                  i_Person_Id  => i_Person_Ids(i));
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Schedule_Kind
  (
    i_Schedule_Kind varchar2,
    i_Form          varchar2 := null
  ) is
    v_Has_Access boolean := false;
    v_Action_Key varchar2(30);
  begin
    case i_Schedule_Kind
      when Htt_Pref.c_Schedule_Kind_Custom then
        v_Action_Key := 'custom';
      when Htt_Pref.c_Schedule_Kind_Flexible then
        v_Action_Key := 'flexible';
      when Htt_Pref.c_Schedule_Kind_Hourly then
        v_Action_Key := 'hourly';
    end case;
  
    if i_Form is not null then
      v_Has_Access := Md_Util.Grant_Has(i_Company_Id   => Ui.Company_Id,
                                        i_Project_Code => Verifix.Project_Code,
                                        i_Filial_Id    => Ui.Filial_Id,
                                        i_User_Id      => Ui.User_Id,
                                        i_Form         => i_Form,
                                        i_Action_Key   => v_Action_Key);
    else
      v_Has_Access := Ui.Grant_Has(v_Action_Key);
    end if;
  
    if not v_Has_Access then
      Htt_Error.Raise_111(i_Schedule_Kind => Htt_Util.t_Schedule_Kind(i_Schedule_Kind));
    end if;
  end;

end Uit_Htt;
/
