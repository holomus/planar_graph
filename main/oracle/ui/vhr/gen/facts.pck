create or replace package Ui_Vhr232 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Devices return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Schedule(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Generate(p Hashmap);
end Ui_Vhr232;
/
create or replace package body Ui_Vhr232 is
  ---------------------------------------------------------------------------------------------------- 
  c_Generate_Tracks            constant varchar2(1) := 'T';
  c_Generate_Requests          constant varchar2(1) := 'R';
  c_Generate_Track_By_Schedule constant varchar2(1) := 'S';
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
    return b.Translate('UI-VHR232:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from Htt_Request_Kinds Rk
                      where Rk.Company_Id = :Company_Id
                        and Rk.State = :State
                        and exists (select *
                               from Htt_Time_Kinds Tk
                              where Tk.Company_Id = Rk.Company_Id
                                and Tk.Time_Kind_Id = Rk.Time_Kind_Id
                                and Tk.Plan_Load in (:Plan_Load_Part, :Plan_Load_Extra))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'state',
                                 'A',
                                 'plan_load_part',
                                 Htt_Pref.c_Plan_Load_Part,
                                 'plan_load_extra',
                                 Htt_Pref.c_Plan_Load_Extra));
  
    q.Number_Field('request_kind_id', 'time_kind_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_staffs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
    q.Number_Field('staff_id', 'employee_id', 'division_id', 'schedule_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select q.name 
                     from htt_schedules q 
                    where q.company_id = :company_id 
                      and q.filial_id = :filial_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Devices return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(32767);
    v_Params Hashmap;
  begin
    v_Query  := 'select *
                   from htt_devices q
                  where q.company_id = :company_id
                    and q.device_type_id <> :staff_device_type_id
                    and exists (select 1
                                 from htt_location_filials lf
                                where lf.company_id = :company_id
                                  and lf.filial_id = :filial_id
                                  and lf.location_id = q.location_id)';
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'staff_device_type_id',
                             Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff));
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('device_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Time_Kind_Ids Array_Varchar2;
    result          Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    select Tk.Time_Kind_Id
      bulk collect
      into v_Time_Kind_Ids
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = Ui.Company_Id
       and Tk.State = 'A'
       and Tk.Plan_Load in (Htt_Pref.c_Plan_Load_Part, Htt_Pref.c_Plan_Load_Extra);
  
    Result.Put('time_kind_ids', v_Time_Kind_Ids);
  
    Result.Put('generate_tracks', c_Generate_Tracks);
    Result.Put('generate_requests', c_Generate_Requests);
    Result.Put('generate_track_by_schedule', c_Generate_Track_By_Schedule);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Sysdate date;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    v_Sysdate := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                            i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id));
  
    v_Data := Fazo.Zip_Map('period_begin',
                           to_char(v_Sysdate, Href_Pref.c_Date_Format_Day),
                           'period_end',
                           to_char(v_Sysdate, Href_Pref.c_Date_Format_Day));
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Generate_Tracks(p Hashmap) is
    c_Company_Id  constant number := Ui.Company_Id;
    c_Filial_Id   constant number := Ui.Filial_Id;
    c_Random_Low  constant number := 0;
    c_Random_High constant number := 32767;
    c_Pass_Modulo constant number := 5;
  
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
  
    v_Input_Left   number;
    v_Input_Right  number;
    v_Output_Left  number;
    v_Output_Right number;
    v_Employee_Id  number;
    v_Is_Valid     varchar2(1);
    v_Skip_Inputs  boolean;
    v_Skip_Outputs boolean;
    v_Only_Check   boolean;
    v_Staffs       Arraylist := p.r_Arraylist('staffs');
    v_Staff        Hashmap;
    v_Device_Ids   Array_Number := p.o_Array_Number('device_ids');
  
    -------------------------------------------------- 
    Procedure Save_Track
    (
      i_Track_Time Htt_Tracks.Track_Time%type,
      i_Person_Id  number,
      i_Track_Type varchar2,
      i_Is_Valid   varchar2,
      i_Skip       boolean,
      i_Device_Id  number
    ) is
      r_Track Htt_Tracks%rowtype;
    begin
      if not (i_Skip and --
          Href_Util.Random_Integer(c_Random_Low, c_Random_High) mod c_Pass_Modulo = 0) then
        z_Htt_Tracks.Init(p_Row         => r_Track,
                          i_Company_Id  => c_Company_Id,
                          i_Filial_Id   => c_Filial_Id,
                          i_Track_Id    => Htt_Next.Track_Id,
                          i_Track_Date  => Trunc(i_Track_Time),
                          i_Track_Time  => i_Track_Time,
                          i_Person_Id   => i_Person_Id,
                          i_Track_Type  => i_Track_Type,
                          i_Mark_Type   => Htt_Pref.c_Mark_Type_Manual,
                          i_Device_Id   => i_Device_Id,
                          i_Location_Id => null,
                          i_Is_Valid    => i_Is_Valid,
                          i_Status      => Htt_Pref.c_Track_Status_Draft);
      
        Htt_Api.Track_Add(r_Track);
      end if;
    end;
  
  begin
    for i in 1 .. v_Staffs.Count
    loop
      v_Staff := Treat(v_Staffs.r_Hashmap(i) as Hashmap);
    
      v_Employee_Id  := v_Staff.r_Number('employee_id');
      v_Is_Valid     := v_Staff.r_Varchar2('is_valid');
      v_Skip_Inputs  := v_Staff.r_Varchar2('skip_inputs') = 'Y';
      v_Skip_Outputs := v_Staff.r_Varchar2('skip_outputs') = 'Y';
      v_Only_Check   := v_Staff.r_Varchar2('only_check') = 'Y';
    
      v_Input_Left   := v_Staff.r_Number('input_left') * 60; -- to seconds
      v_Input_Right  := v_Staff.r_Number('input_right') * 60; -- to seconds
      v_Output_Left  := v_Staff.r_Number('output_left') * 60; -- to seconds
      v_Output_Right := v_Staff.r_Number('output_right') * 60; -- to seconds
    
      if v_Input_Right <= v_Input_Left then
        v_Input_Right := v_Input_Right + 86400;
      end if;
    
      if v_Output_Right <= v_Output_Left then
        v_Output_Right := v_Output_Right + 86400;
      end if;
    
      for Tr in (select d.Curr_Date + --
                        Numtodsinterval(Href_Util.Random_Integer(v_Input_Left, v_Input_Right), --
                                        'second') Input_Time,
                        d.Curr_Date + --
                        Numtodsinterval(Href_Util.Random_Integer(v_Output_Left, v_Output_Right),
                                        'second') Output_Time
                   from (select v_Period_Begin + level - 1 Curr_Date
                           from Dual
                         connect by level <= (v_Period_End - v_Period_Begin) + 1) d)
      loop
        Save_Track(i_Track_Time => Tr.Input_Time,
                   i_Person_Id  => v_Employee_Id,
                   i_Track_Type => case
                                     when not v_Only_Check then
                                      Htt_Pref.c_Track_Type_Input
                                     else
                                      Htt_Pref.c_Track_Type_Check
                                   end,
                   i_Is_Valid   => v_Is_Valid,
                   i_Skip       => v_Skip_Inputs,
                   i_Device_Id  => v_Device_Ids(Href_Util.Random_Integer(1, v_Device_Ids.Count)));
      
        Save_Track(i_Track_Time => Tr.Output_Time,
                   i_Person_Id  => v_Employee_Id,
                   i_Track_Type => case
                                     when not v_Only_Check then
                                      Htt_Pref.c_Track_Type_Output
                                     else
                                      Htt_Pref.c_Track_Type_Check
                                   end,
                   i_Is_Valid   => v_Is_Valid,
                   i_Skip       => v_Skip_Outputs,
                   i_Device_Id  => v_Device_Ids(Href_Util.Random_Integer(1, v_Device_Ids.Count)));
      
      end loop;
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Generate_Requests(p Hashmap) is
    c_Company_Id      constant number := Ui.Company_Id;
    c_Filial_Id       constant number := Ui.Filial_Id;
    c_Random_Low      constant number := 0;
    c_Random_High     constant number := 32767;
    c_Approve_Modulo  constant number := 2;
    c_Deny_Modulo     constant number := 3;
    c_Complete_Modulo constant number := 2;
  
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
  
    v_Request_Left     number;
    v_Request_Right    number;
    v_Staff_Id         number;
    v_Random_Id        number;
    v_Request_Kind_Ids Array_Number;
    v_Staffs           Arraylist := p.r_Arraylist('staffs');
    v_Staff            Hashmap;
  
    -------------------------------------------------- 
    Procedure Save_Request
    (
      i_Request_Kind_Id number,
      i_Staff_Id        number,
      i_Begin_Time      date,
      i_End_Time        date
    ) is
      r_Request Htt_Requests%rowtype;
    begin
    
      z_Htt_Requests.Init(p_Row             => r_Request,
                          i_Company_Id      => c_Company_Id,
                          i_Filial_Id       => c_Filial_Id,
                          i_Request_Id      => Htt_Next.Request_Id,
                          i_Request_Kind_Id => i_Request_Kind_Id,
                          i_Staff_Id        => i_Staff_Id,
                          i_Begin_Time      => i_Begin_Time,
                          i_End_Time        => i_End_Time,
                          i_Request_Type    => Htt_Pref.c_Request_Type_Part_Of_Day,
                          i_Status          => Htt_Pref.c_Request_Status_New);
    
      Htt_Api.Request_Save(r_Request);
    
      if Href_Util.Random_Integer(c_Random_Low, c_Random_High) mod c_Deny_Modulo = 0 then
        Htt_Api.Request_Deny(i_Company_Id => r_Request.Company_Id,
                             i_Filial_Id  => r_Request.Filial_Id,
                             i_Request_Id => r_Request.Request_Id);
      else
        if Href_Util.Random_Integer(c_Random_Low, c_Random_High) mod c_Approve_Modulo = 0 then
          Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                                  i_Filial_Id    => r_Request.Filial_Id,
                                  i_Request_Id   => r_Request.Request_Id,
                                  i_Manager_Note => null,
                                  i_User_Id      => Ui.User_Id);
        
          if Href_Util.Random_Integer(c_Random_Low, c_Random_High) mod c_Complete_Modulo = 0 then
            Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                                     i_Filial_Id  => r_Request.Filial_Id,
                                     i_Request_Id => r_Request.Request_Id);
          end if;
        end if;
      end if;
    end;
  
  begin
    for i in 1 .. v_Staffs.Count
    loop
      v_Staff := Treat(v_Staffs.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id         := v_Staff.r_Number('staff_id');
      v_Request_Kind_Ids := v_Staff.r_Array_Number('request_kind_id');
    
      if v_Request_Kind_Ids.Count = 0 then
        b.Raise_Error(t('generate_requests: at least one request_kind should be selected'));
      end if;
    
      v_Request_Left  := v_Staff.r_Number('request_left') * 60; -- to seconds
      v_Request_Right := v_Staff.r_Number('request_right') * 60; -- to seconds
    
      if v_Request_Right <= v_Request_Left then
        b.Raise_Error(t('generate_requests: request left border is later that right border'));
      end if;
    
      for Rq in (select d.Curr_Date + --
                        Numtodsinterval(Rq_Begin_Second, --
                                        'second') Begin_Time,
                        d.Curr_Date + --
                        Numtodsinterval(Href_Util.Random_Integer(Rq_Begin_Second + 1,
                                                                 v_Request_Right),
                                        'second') End_Time
                   from (select v_Period_Begin + level - 1 Curr_Date,
                                Href_Util.Random_Integer(v_Request_Left, v_Request_Right - 1) Rq_Begin_Second
                           from Dual
                         connect by level <= (v_Period_End - v_Period_Begin) + 1) d)
      loop
        v_Random_Id := Href_Util.Random_Integer(1, v_Request_Kind_Ids.Count);
      
        Save_Request(i_Request_Kind_Id => v_Request_Kind_Ids(v_Random_Id),
                     i_Staff_Id        => v_Staff_Id,
                     i_Begin_Time      => Rq.Begin_Time,
                     i_End_Time        => Rq.End_Time);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Tack_By_Schedule(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Staff_Id     number;
    v_Type_Input   varchar2(1) := Htt_Pref.c_Track_Type_Input;
    v_Type_Output  varchar2(1) := Htt_Pref.c_Track_Type_Output;
    v_Put_Input    varchar2(1);
    v_Put_Output   varchar2(1);
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Staff        Hashmap;
    v_Staffs       Arraylist := p.r_Arraylist('staffs');
    v_Mark_Type    varchar2(1) := Htt_Pref.c_Mark_Type_Manual;
    r_Track        Htt_Tracks%rowtype;
  
    -------------------------------------------------- 
    Procedure Add_Tracks
    (
      i_Track_Time date,
      i_Track_Type varchar2
    ) is
    begin
      r_Track.Track_Time := i_Track_Time;
      r_Track.Track_Type := i_Track_Type;
      r_Track.Track_Id   := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end;
  begin
    for i in 1 .. v_Staffs.Count
    loop
      v_Staff      := Treat(v_Staffs.r_Hashmap(i) as Hashmap);
      v_Staff_Id   := v_Staff.r_Number('staff_id');
      v_Put_Input  := v_Staff.r_Varchar2('input');
      v_Put_Output := v_Staff.r_Varchar2('output');
    
      -- track
      r_Track.Company_Id := v_Company_Id;
      r_Track.Filial_Id  := v_Filial_Id;
      r_Track.Is_Valid   := 'Y';
      r_Track.Mark_Type  := v_Mark_Type;
      r_Track.Person_Id  := Href_Util.Get_Employee_Id(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_Staff_Id   => v_Staff_Id);
    
      for r in (select (case
                          when v_Put_Input = 'N' --
                               or q.Begin_Time is null --
                               or exists (select 1
                                  from Htt_Timesheet_Tracks w
                                 where w.Company_Id = q.Company_Id
                                   and w.Filial_Id = q.Filial_Id
                                   and w.Timesheet_Id = q.Timesheet_Id
                                   and w.Track_Type = v_Type_Input
                                   and w.Track_Datetime < q.End_Time) then
                           'Y'
                          else
                           'N'
                        end) Has_Input,
                       (case
                          when v_Put_Output = 'N' --
                               or q.End_Time is null -- 
                               or exists (select 1
                                  from Htt_Timesheet_Tracks w
                                 where w.Company_Id = q.Company_Id
                                   and w.Filial_Id = q.Filial_Id
                                   and w.Timesheet_Id = q.Timesheet_Id
                                   and w.Track_Type = v_Type_Output
                                   and w.Track_Datetime > q.Begin_Time) then
                           'Y'
                          else
                           'N'
                        end) Has_Output,
                       q.Begin_Time,
                       q.End_Time
                  from Htt_Timesheets q
                 where q.Company_Id = v_Company_Id
                   and q.Filial_Id = v_Filial_Id
                   and q.Staff_Id = v_Staff_Id
                   and q.Timesheet_Date >= v_Period_Begin
                   and q.Timesheet_Date <= v_Period_End
                 order by q.Timesheet_Date)
      loop
        if r.Has_Input = 'N' then
          Add_Tracks(i_Track_Time => r.Begin_Time, --
                     i_Track_Type => v_Type_Input);
        end if;
      
        if r.Has_Output = 'N' then
          Add_Tracks(i_Track_Time => r.End_Time, --
                     i_Track_Type => v_Type_Output);
        end if;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Schedule(p Hashmap) return Arraylist is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Staff_Ids      Array_Number := p.r_Array_Number('staff_id');
    v_Schedule_Names Arraylist := Arraylist();
    v_Schedule_Id    number;
  begin
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Schedule_Id := z_Href_Staffs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Staff_Id => v_Staff_Ids(i)).Schedule_Id;
    
      v_Schedule_Names.Push(z_Htt_Schedules.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Schedule_Id => v_Schedule_Id).Name);
    end loop;
  
    return v_Schedule_Names;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate(p Hashmap) is
    v_Generate_Kind varchar2(1) := p.r_Varchar2('generate_kind');
  begin
    if v_Generate_Kind = c_Generate_Tracks then
      Generate_Tracks(p);
    elsif v_Generate_Kind = c_Generate_Requests then
      Generate_Requests(p);
    else
      Generate_Tack_By_Schedule(p);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           name            = null,
           Time_Kind_Id    = null,
           State           = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           Plan_Load    = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Staff_Kind     = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Schedule_Id    = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Htt_Devices
       set Company_Id     = null,
           Device_Id      = null,
           name           = null,
           Device_Type_Id = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
  end;

end Ui_Vhr232;
/
