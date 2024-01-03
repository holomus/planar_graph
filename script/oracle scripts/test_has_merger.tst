PL/SQL Developer Test script 3.0
365
-- Created on 5/5/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i            integer;
  v_Company_Id number := 560;
  v_Filial_Id  number := 15689;
  v_User_Id    number := 39162;
  result       Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Date return date is
  begin
    return to_date('04.05.2023 23:52:00', 'dd.mm.yyyy hh24:mi:ss');
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Has_Merger
  (
    o_Merger_Begin out date,
    o_Merger_End   out date,
    i_Timesheet    Htt_Timesheets%rowtype,
    i_Current_Time date
  ) is
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  begin
    if i_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
      if i_Timesheet.Shift_Begin_Time <> i_Timesheet.Input_Border and
         i_Current_Time <= i_Timesheet.Shift_Begin_Time + v_Merger_Interval then
        o_Merger_Begin := i_Timesheet.Shift_Begin_Time - v_Merger_Interval;
        o_Merger_End   := i_Timesheet.Shift_Begin_Time + v_Merger_Interval;
      elsif i_Timesheet.Shift_End_Time <> i_Timesheet.Output_Border and
            i_Current_Time <= i_Timesheet.Shift_End_Time + v_Merger_Interval then
        o_Merger_Begin := i_Timesheet.Shift_End_Time - v_Merger_Interval;
        o_Merger_End   := i_Timesheet.Shift_End_Time + v_Merger_Interval;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Find_Timesheet
  (
    i_Staff_Id       number,
    i_Track_Datetime date
  ) return number is
    v_Interval_Date date := Trunc(i_Track_Datetime);
    result          number;
  begin
    select q.Timesheet_Id
      into result
      from Htt_Timesheet_Helpers q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Interval_Date = v_Interval_Date
       and i_Track_Datetime between q.Shift_Begin_Time and q.Shift_End_Time
     order by q.Shift_End_Time
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Find_Timesheets
  (
    i_Staff_Id       number,
    i_Track_Datetime date
  ) return Array_Number is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Interval_Date date := Trunc(i_Track_Datetime);
    result          Array_Number;
  begin
    select q.Timesheet_Id
      bulk collect
      into result
      from Htt_Timesheet_Helpers q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Interval_Date = v_Interval_Date
       and i_Track_Datetime >= q.Input_Border
       and i_Track_Datetime < q.Output_Border;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Last_Track_Type
  (
    i_Employee_Id number,
    i_Date        date
  ) return varchar2 is
    v_Staff_Id number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Employee_Id => i_Employee_Id,
                                                        i_Date        => Trunc(i_Date));
  
    v_Last_Track_Type varchar2(1);
    v_Current_Date    date := Trunc(Get_Current_Date);
  
    v_Timesheet_Ids        Array_Number;
    r_Timesheet            Htt_Timesheets%rowtype;
    v_Ignore_Invalid_Track varchar2(1);
    v_Shift_Begin          date;
    v_Shift_End            date;
  begin
    v_Timesheet_Ids := Find_Timesheets(i_Staff_Id       => v_Staff_Id, --
                                       i_Track_Datetime => i_Date);
  
    if v_Timesheet_Ids.Count = 1 then
      -- true when input/output borders differ from shift borders
      -- resulting in only one timesheet per timestamp
      -- takes last track between [shift_begin_time, shift_end_time]
    
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                           i_Filial_Id    => Ui.Filial_Id,
                                           i_Timesheet_Id => v_Timesheet_Ids(1));
    
      v_Shift_Begin := r_Timesheet.Shift_Begin_Time;
      v_Shift_End   := Least(r_Timesheet.Shift_End_Time, i_Date);
    
      v_Ignore_Invalid_Track := Hes_Util.Staff_Track_Settings(i_Company_Id => r_Timesheet.Company_Id, --
                                i_Filial_Id => r_Timesheet.Filial_Id, --
                                i_User_Id => i_Employee_Id).Ignore_Invalid_Track;
    
      select Qr.Track_Type
        into v_Last_Track_Type
        from (select p.Track_Datetime, p.Track_Type
                from Htt_Timesheet_Tracks p
               where p.Company_Id = r_Timesheet.Company_Id
                 and p.Filial_Id = r_Timesheet.Filial_Id
                 and p.Timesheet_Id = r_Timesheet.Timesheet_Id
                 and p.Track_Type not in
                     (Htt_Pref.c_Track_Type_Check, Htt_Pref.c_Track_Type_Potential_Output)
                 and p.Track_Datetime between v_Shift_Begin and v_Shift_End
              union all
              select q.Track_Datetime, q.Track_Type
                from Htt_Tracks q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Person_Id = Ui.User_Id
                 and q.Track_Type <> Htt_Pref.c_Track_Type_Check
                 and v_Ignore_Invalid_Track = 'N'
                 and q.Is_Valid = 'N'
                 and q.Track_Datetime between v_Shift_Begin and v_Shift_End) Qr
       order by Qr.Track_Datetime desc,
                Decode(Qr.Track_Type,
                       Htt_Pref.c_Track_Type_Input,
                       1,
                       Htt_Pref.c_Track_Type_Merger,
                       2,
                       3)
       fetch first row only;
    elsif v_Timesheet_Ids.Count = 0 then
      -- true when no schedule is set for employee
      -- takes last track in current date
    
      select q.Track_Type
        into v_Last_Track_Type
        from Htt_Tracks q
       where q.Company_Id = Ui.Company_Id
         and q.Person_Id = Ui.User_Id
         and q.Track_Date = v_Current_Date
         and q.Track_Type <> Htt_Pref.c_Track_Type_Check
         and (v_Ignore_Invalid_Track = 'N' or q.Is_Valid = 'Y')
       order by q.Track_Time desc
       fetch first row only;
    else
      -- true when input/output borders differ from shift borders
      -- resulting in possibly two or more timesheets per timestamp
      -- takes last track between [current_time - track_duraction; current_time]   
    
      r_Timesheet.Timesheet_Id := Find_Timesheet(i_Staff_Id       => v_Staff_Id,
                                                 i_Track_Datetime => i_Date);
    
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                           i_Filial_Id    => Ui.Filial_Id,
                                           i_Timesheet_Id => r_Timesheet.Timesheet_Id);
    
      if r_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
        v_Shift_Begin := r_Timesheet.Input_Border;
        v_Shift_End   := r_Timesheet.Output_Border;
      else
        v_Shift_Begin := i_Date - Numtodsinterval(r_Timesheet.Track_Duration, 'second');
        v_Shift_End   := i_Date;
      end if;
    
      v_Shift_End := Least(v_Shift_End, i_Date);
    
      select Qr.Track_Type
        into v_Last_Track_Type
        from (select s.Track_Datetime, s.Track_Type
                from Htt_Timesheet_Tracks s
               where s.Company_Id = Ui.Company_Id
                 and s.Filial_Id = Ui.Filial_Id
                 and s.Timesheet_Id member of
               v_Timesheet_Ids
                 and s.Track_Type not in
                     (Htt_Pref.c_Track_Type_Check, Htt_Pref.c_Track_Type_Potential_Output)
                 and s.Track_Datetime between v_Shift_Begin and v_Shift_End
              union all
              select q.Track_Datetime, q.Track_Type
                from Htt_Tracks q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Person_Id = Ui.User_Id
                 and q.Track_Type <> Htt_Pref.c_Track_Type_Check
                 and v_Ignore_Invalid_Track = 'N'
                 and q.Is_Valid = 'N'
                 and q.Track_Datetime between v_Shift_Begin and v_Shift_End) Qr
       order by Qr.Track_Datetime desc,
                Decode(Qr.Track_Type,
                       Htt_Pref.c_Track_Type_Input,
                       1,
                       Htt_Pref.c_Track_Type_Merger,
                       2,
                       3)
       fetch first row only;
    end if;
  
    return v_Last_Track_Type;
  exception
    when No_Data_Found then
      return Htt_Pref.c_Track_Type_Output;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Model return Hashmap is
    v_Items           Arraylist := Arraylist();
    v_Settings        Hes_Pref.Staff_Track_Settings_Rt;
    v_Track_Types     Array_Varchar2 := Array_Varchar2();
    v_Last_Track_Type varchar2(1);
    v_Current_Time    date := Get_Current_Date;
  
    result Hashmap := Hashmap();
  
    -------------------------------------------------- 
    Function Merger_Completed return varchar2 is
      v_Timesheet_Id     number;
      r_Timesheet        Htt_Timesheets%rowtype;
      v_Merger_Begin     date;
      v_Merger_End       date;
      v_Merger_Completed varchar2(1) := 'N';
    begin
      v_Timesheet_Id := Find_Timesheet(i_Staff_Id       => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                                                          i_Filial_Id   => v_Filial_Id,
                                                                                          i_Employee_Id => v_User_Id,
                                                                                          i_Date        => Trunc(v_Current_Time)),
                                       i_Track_Datetime => v_Current_Time);
    
      if v_Timesheet_Id is null then
        return 'N';
      end if;
    
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => v_Company_Id,
                                           i_Filial_Id    => v_Filial_Id,
                                           i_Timesheet_Id => v_Timesheet_Id);
    
      if r_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Flexible then
        return 'N';
      end if;
    
      Has_Merger(o_Merger_Begin => v_Merger_Begin,
                 o_Merger_End   => v_Merger_End,
                 i_Timesheet    => r_Timesheet,
                 i_Current_Time => v_Current_Time);
    
      if v_Merger_Begin is null or v_Merger_End is null then
        return 'N';
      end if;
    
      begin
        select 'Y'
          into v_Merger_Completed
          from Htt_Timesheet_Tracks Tt
         where Tt.Company_Id = v_Company_Id
           and Tt.Filial_Id = v_Filial_Id
           and Tt.Timesheet_Id = v_Timesheet_Id
           and Tt.Track_Type = Htt_Pref.c_Track_Type_Merger
           and Tt.Track_Datetime between v_Merger_Begin and v_Merger_End;
      exception
        when No_Data_Found then
          null;
      end;
    
      return v_Merger_Completed;
    end;
  begin
    v_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => v_Company_Id,
                                                i_Filial_Id  => v_Filial_Id,
                                                i_User_Id    => v_User_Id);
  
    -- locations
    for r in (select *
                from Htt_Locations q
               where q.Company_Id = v_Company_Id
                 and q.Prohibited = 'N'
                 and q.State = 'A'
                 and exists (select 1
                        from Htt_Location_Persons w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Location_Id = q.Location_Id
                         and w.Person_Id = v_User_Id)
               order by q.Name)
    loop
      v_Items.Push(z_Htt_Locations.To_Map(r, --
                                          z.Location_Id,
                                          z.Name,
                                          z.Latlng,
                                          z.Accuracy,
                                          z.Bssids));
    end loop;
  
    Result.Put('locations', v_Items);
  
    -- last track type
    v_Last_Track_Type := Last_Track_Type(i_Employee_Id => v_User_Id, --
                                         i_Date        => v_Current_Time);
  
    -- available track types
    v_Track_Types := Array_Varchar2();
    if v_Settings.Track_Type_Check = 'Y' then
      Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Check);
    end if;
  
    if v_Last_Track_Type = Htt_Pref.c_Track_Type_Output then
      if v_Settings.Track_Type_Input = 'Y' then
        Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Input);
      end if;
    elsif v_Settings.Track_Type_Output = 'Y' then
      Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Output);
    end if;
  
    Result.Put('track_types', v_Track_Types);
    Result.Put('merger_completed', Merger_Completed);
  
    -- available all track types
    v_Track_Types := Array_Varchar2();
    if v_Settings.Track_Type_Check = 'Y' then
      Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Check);
    end if;
  
    if v_Settings.Track_Type_Input = 'Y' then
      Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Input);
    end if;
  
    if v_Settings.Track_Type_Output = 'Y' then
      Fazo.Push(v_Track_Types, Htt_Pref.c_Track_Type_Output);
    end if;
  
    Result.Put('all_track_types', v_Track_Types);
  
    return result;
  end;
begin
  -- Test statements here
  result := Track_Model;

  :c := Result.Json;
end;
1
c
1
{"locations":[{"location_id":"35101","name":"Аптека 51/3","latlng":"41.364252303086445,69.33330595493318","accuracy":"200","bssids":""},{"location_id":"31941","name":"Офис","latlng":"41.353139,69.264256","accuracy":"200","bssids":""}],"track_types":["I"],"merger_completed":"N","all_track_types":["I","O"]}
5
0
