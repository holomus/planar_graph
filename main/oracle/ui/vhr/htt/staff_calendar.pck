create or replace package Ui_Vhr219 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Daily_Track(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheets(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Track_Type(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr219;
/
create or replace package body Ui_Vhr219 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks(p Hashmap) return Fazo_Query is
    v_Filial_Id   number;
    v_Matrix      Matrix_Varchar2;
    v_Query       varchar2(32767);
    v_Param       Hashmap;
    v_Employee_Id number := p.r_Number('person_id');
    q             Fazo_Query;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id, i_Manual => false);
  
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    else
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    v_Query := 'select q.company_id,
                       q.filial_id,
                       q.track_id,
                       q.track_date,
                       q.track_time,
                       q.track_datetime,
                       q.person_id,
                       q.track_type as modified_track_type, 
                       q.mark_type,
                       q.device_id,
                       q.location_id,
                       q.latlng,
                       q.accuracy,
                       q.photo_sha,
                       q.note,
                       q.original_type,
                       q.is_valid,
                       q.status,
                       q.created_by,
                       q.created_on,
                       q.modified_by,
                       q.modified_on,
                       q.modified_id,
                       (select k.location_type_id
                          from htt_locations k
                         where k.company_id = q.company_id
                           and k.location_id = q.location_id) location_type_id,
                       (select k.region_id
                          from htt_locations k
                         where k.company_id = q.company_id
                           and k.location_id = q.location_id) region_id,
                       to_char(q.track_time, :format) track_time_hh24_mi,
                       nvl2(q.latlng, ''Y'', ''N'') latlng_exists,
                       nvl2(q.photo_sha, ''Y'', ''N'') photo_exists,
                       case 
                         when exists (select 1
                                 from htt_timesheet_tracks f
                                where f.company_id = q.company_id
                                  and f.filial_id = q.filial_id
                                  and f.track_id = q.track_id
                                  and f.track_type = :potential_output) then
                           ''Y''
                         else
                           ''N''
                       end as is_potential_output,
                       (select s.device_type_id
                          from htt_devices s
                         where q.company_id = s.company_id
                           and q.device_id = s.device_id) as device_type_id 
                  from htt_tracks q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.person_id = :person_id';
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'filial_id',
                            v_Filial_Id,
                            'format',
                            Href_Pref.c_Time_Format_Minute,
                            'person_id',
                            v_Employee_Id,
                            'device_type_id',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff));
  
    v_Param.Put('potential_output', Htt_Pref.c_Track_Type_Potential_Output);
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('track_id',
                   'location_id',
                   'location_type_id',
                   'region_id',
                   'device_id',
                   'device_type_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('mark_type',
                     'photo_sha',
                     'latlng',
                     'accuracy',
                     'note',
                     'original_type',
                     'is_valid',
                     'track_time_hh24_mi',
                     'device_type_name');
    q.Varchar2_Field('status',
                     'latlng_exists',
                     'photo_exists',
                     'is_potential_output',
                     'access_level',
                     'modified_track_type');
    q.Date_Field('track_date', 'track_time', 'created_on', 'modified_on');
  
    q.Multi_Varchar2_Field(i_Name        => 'track_type',
                           i_Table_Name  => 'htt_timesheet_tracks',
                           i_Join_Clause => '     @company_id = $company_id ' ||
                                            ' and @filial_id = $filial_id ' ||
                                            ' and @track_id = $track_id',
                           i_For         => 'track_type');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('original_type_name', 'original_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('modified_track_type_name', 'modified_track_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Mark_Types;
  
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Track_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('is_valid_name',
                   'is_valid',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('latlng_exists_name',
                   'latlng_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('photo_exists_name',
                   'photo_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('track_changed_name',
                   'track_changed',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_potential_output_name',
                   'is_potential_output',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('location_name',
                  'location_id',
                  'htt_locations',
                  'location_id',
                  'name',
                  'select *
                     from htt_locations s
                    where s.company_id = :company_id
                      and exists (select 1
                             from htt_location_filials lf
                            where lf.company_id = :company_id
                              and lf.filial_id = :filial_id
                              and lf.location_id = s.location_id)');
    q.Refer_Field('location_type_name',
                  'location_type_id',
                  'htt_location_types',
                  'location_type_id',
                  'name',
                  'select *
                     from htt_location_types s
                    where s.company_id = :company_id');
    q.Refer_Field('device_type_name',
                  'device_type_id',
                  'htt_device_types',
                  'device_type_id',
                  'name');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select * 
                     from md_regions s
                    where s.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users s 
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('device_name',
                  'device_id',
                  'htt_devices',
                  'device_id',
                  'name',
                  'select * 
                     from htt_devices q 
                    where q.company_id = :company_id
                      and q.device_type_id <> :device_type_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Daily_Track(p Hashmap) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number;
    v_Timesheet_Id number := p.r_Number('timesheet_id');
  
    v_Time_Distance number;
    v_Input_Idx     number;
    v_Input         date;
    v_Inputs        Array_Date := Array_Date();
    v_Input_Values  Matrix_Varchar2 := Matrix_Varchar2();
    v_Matrix        Matrix_Varchar2 := Matrix_Varchar2();
    r_Timesheet     Htt_Timesheets%rowtype;
  
    result Hashmap := Hashmap();
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    else
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => v_Company_Id,
                                         i_Filial_Id    => v_Filial_Id,
                                         i_Timesheet_Id => v_Timesheet_Id);
  
    if r_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
      select Array_Varchar2(w.Track_Id,
                            (select to_char(q.Track_Time, Href_Pref.c_Time_Format_Minute)
                               from Htt_Tracks q
                              where q.Company_Id = v_Company_Id
                                and q.Filial_Id = v_Filial_Id
                                and q.Track_Id = w.Track_Id),
                            w.Track_Type,
                            Htt_Util.t_Track_Type(w.Track_Type))
        bulk collect
        into v_Matrix
        from Htt_Timesheet_Tracks w
       where w.Company_Id = v_Company_Id
         and w.Filial_Id = v_Filial_Id
         and w.Timesheet_Id = v_Timesheet_Id
       order by w.Track_Datetime;
    else
      for r in (select w.Track_Id,
                       w.Track_Datetime,
                       (select to_char(q.Track_Time, Href_Pref.c_Time_Format_Minute)
                          from Htt_Tracks q
                         where q.Company_Id = v_Company_Id
                           and q.Filial_Id = v_Filial_Id
                           and q.Track_Id = w.Track_Id) Track_Time,
                       w.Track_Type
                  from Htt_Timesheet_Tracks w
                 where w.Company_Id = v_Company_Id
                   and w.Filial_Id = v_Filial_Id
                   and w.Timesheet_Id = v_Timesheet_Id
                 order by w.Track_Datetime)
      loop
        if r.Track_Type = Htt_Pref.c_Track_Type_Input and
           r.Track_Datetime >= r_Timesheet.Input_Border and
           r.Track_Datetime < r_Timesheet.Shift_End_Time then
          Fazo.Push(v_Inputs, r.Track_Datetime);
        
          Fazo.Push(v_Input_Values,
                    Array_Varchar2(r.Track_Id,
                                   r.Track_Time,
                                   r.Track_Type,
                                   Htt_Util.t_Track_Type(r.Track_Type)));
        elsif r.Track_Type = Htt_Pref.c_Track_Type_Output and v_Inputs.Count > 0 then
          if r.Track_Datetime >= r_Timesheet.Shift_Begin_Time and
             r.Track_Datetime <= r_Timesheet.Output_Border then
            for j in 1 .. v_Inputs.Count
            loop
              v_Input_Idx     := j;
              v_Input         := v_Inputs(j);
              v_Time_Distance := Htt_Util.Time_Diff(r.Track_Datetime, v_Input);
              exit when v_Time_Distance <= r_Timesheet.Track_Duration;
            end loop;
          
            if v_Time_Distance <= r_Timesheet.Track_Duration and
               v_Input >= r_Timesheet.Shift_Begin_Time and v_Input < r_Timesheet.Shift_End_Time then
              for k in v_Input_Idx .. v_Inputs.Count
              loop
                Fazo.Push(v_Matrix, v_Input_Values(k));
              end loop;
            
              Fazo.Push(v_Matrix,
                        Array_Varchar2(r.Track_Id,
                                       r.Track_Time,
                                       r.Track_Type,
                                       Htt_Util.t_Track_Type(r.Track_Type)));
            end if;
          end if;
        
          v_Input_Values := Matrix_Varchar2();
          v_Inputs       := Array_Date();
        end if;
      end loop;
    
      for i in 1 .. v_Inputs.Count
      loop
        if v_Inputs(i) between r_Timesheet.Shift_Begin_Time and r_Timesheet.Shift_End_Time then
          Fazo.Push(v_Matrix, v_Input_Values(i));
        end if;
      end loop;
    end if;
  
    Result.Put('daily_tracks', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheets(p Hashmap) return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Employee_Id number := p.r_Number('employee_id');
    v_First_Date  date := Trunc(p.r_Date('month'), 'MON');
    v_Last_Date   date := Last_Day(v_First_Date);
    v_Staff_Ids   Array_Number;
    v_Dates       Matrix_Varchar2;
    v_Facts       Matrix_Varchar2;
    v_Changes     Matrix_Varchar2;
    v_Marks       Matrix_Varchar2;
    result        Hashmap := Hashmap();
  
    -------------------------------------------------- 
    Procedure Load_Staff_Ids is
    begin
      select q.Staff_Id
        bulk collect
        into v_Staff_Ids
        from Href_Staffs q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Employee_Id = v_Employee_Id
         and q.Hiring_Date <= v_Last_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_First_Date)
         and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and q.State = 'A';
    end;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    Load_Staff_Ids;
  
    select Array_Varchar2(t.Timesheet_Id,
                          t.Timesheet_Date,
                          t.Day_Kind,
                          t.Schedule_Kind,
                          to_char(t.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(t.End_Time, Href_Pref.c_Time_Format_Minute),
                          t.Break_Enabled,
                          to_char(t.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(t.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          Round(t.Plan_Time / 60),
                          Round(t.Full_Time / 60),
                          to_char(t.Input_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(t.Output_Time, Href_Pref.c_Time_Format_Minute),
                          t.Planned_Marks,
                          t.Done_Marks,
                          (select Rq.Request_Kind_Id
                             from Htt_Timesheet_Requests Tr
                             join Htt_Requests Rq
                               on Rq.Company_Id = Tr.Company_Id
                              and Rq.Filial_Id = Tr.Filial_Id
                              and Rq.Request_Id = Tr.Request_Id
                            where Tr.Company_Id = t.Company_Id
                              and Tr.Filial_Id = t.Filial_Id
                              and Tr.Timesheet_Id = t.Timesheet_Id
                              and Rownum = 1),
                          (select Td.Time_Kind_Id
                             from Hpd_Timeoff_Days Td
                            where Td.Company_Id = t.Company_Id
                              and Td.Filial_Id = t.Filial_Id
                              and Td.Staff_Id = t.Staff_Id
                              and Td.Timeoff_Date = t.Timesheet_Date))
      bulk collect
      into v_Dates
      from Htt_Timesheets t
     where t.Company_Id = v_Company_Id
       and t.Filial_Id = v_Filial_Id
       and t.Staff_Id member of v_Staff_Ids
       and t.Timesheet_Date between v_First_Date and v_Last_Date;
  
    select Array_Varchar2(Tf.Timesheet_Id,
                          Nvl(Tk.Parent_Id, Tk.Time_Kind_Id),
                          Round(sum(Tf.Fact_Value) / 60, 2))
      bulk collect
      into v_Facts
      from Htt_Timesheets t
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = t.Company_Id
       and Tf.Filial_Id = t.Filial_Id
       and Tf.Timesheet_Id = t.Timesheet_Id
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Tf.Company_Id
       and Tk.Time_Kind_Id = Tf.Time_Kind_Id
     where t.Company_Id = v_Company_Id
       and t.Filial_Id = v_Filial_Id
       and t.Staff_Id member of v_Staff_Ids
       and t.Timesheet_Date between v_First_Date and v_Last_Date
     group by Tf.Timesheet_Id, Nvl(Tk.Parent_Id, Tk.Time_Kind_Id);
  
    select Array_Varchar2(Cd.Change_Date)
      bulk collect
      into v_Changes
      from Htt_Change_Days Cd
     where Cd.Company_Id = v_Company_Id
       and Cd.Filial_Id = v_Filial_Id
       and Cd.Staff_Id member of v_Staff_Ids
       and Cd.Change_Date between v_First_Date and v_Last_Date
       and exists (select *
              from Htt_Plan_Changes Pc
             where Pc.Company_Id = Cd.Company_Id
               and Pc.Filial_Id = Cd.Filial_Id
               and Pc.Change_Id = Cd.Change_Id
               and Pc.Status = Htt_Pref.c_Change_Status_Completed);
  
    select Array_Varchar2(t.Timesheet_Date,
                          to_char(Tm.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(Tm.End_Time, Href_Pref.c_Time_Format_Minute),
                          Tm.Done)
      bulk collect
      into v_Marks
      from Htt_Timesheet_Marks Tm
      join Htt_Timesheets t
        on Tm.Company_Id = t.Company_Id
       and Tm.Filial_Id = t.Filial_Id
       and Tm.Timesheet_Id = t.Timesheet_Id
     where t.Company_Id = v_Company_Id
       and t.Filial_Id = v_Filial_Id
       and t.Staff_Id member of v_Staff_Ids
       and t.Timesheet_Date between v_First_Date and v_Last_Date;
  
    Result.Put('dates', Fazo.Zip_Matrix(v_Dates));
    Result.Put('facts', Fazo.Zip_Matrix(v_Facts));
    Result.Put('changes', Fazo.Zip_Matrix(v_Changes));
    Result.Put('marks', Fazo.Zip_Matrix(v_Marks));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Employee_Id number) return Hashmap is
    v_Matrix              Matrix_Varchar2;
    v_Company_Id          number := Ui.Company_Id;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                Hashmap := Hashmap;
  begin
    select Array_Varchar2(Tk.Time_Kind_Id, Tk.Name, Tk.Bg_Color, Tk.Color)
      bulk collect
      into v_Matrix
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = v_Company_Id;
  
    Result.Put('time_kinds', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(Rk.Request_Kind_Id, Rk.Name, Tk.Bg_Color, Tk.Color)
      bulk collect
      into v_Matrix
      from Htt_Request_Kinds Rk
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Rk.Company_Id
       and Tk.Time_Kind_Id = Rk.Time_Kind_Id
     where Rk.Company_Id = v_Company_Id;
  
    Result.Put('request_kinds', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('turnout_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout));
    Result.Put('free_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free));
    Result.Put('lack_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack));
    Result.Put('late_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late));
    Result.Put('early_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early));
    Result.Put('overtime_id',
               Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime));
    Result.Put('access_all_employee', v_Access_All_Employee);
  
    if v_Access_All_Employee = 'Y' or
       Uit_Href.User_Access_Level_For_Person(i_Employee_Id) not in
       (Href_Pref.c_User_Access_Level_Personal, Href_Pref.c_User_Access_Level_Other) then
      Result.Put('has_access', 'Y');
    else
      Result.Put('has_access', 'N');
    end if;
  
    Result.Put('tt_input', Htt_Pref.c_Track_Type_Input);
    Result.Put('tt_output', Htt_Pref.c_Track_Type_Output);
    Result.Put('tt_merger', Htt_Pref.c_Track_Type_Merger);
    Result.Put('tt_check', Htt_Pref.c_Track_Type_Check);
    Result.Put('tt_potential', Htt_Pref.c_Track_Type_Potential_Output);
    Result.Put('tt_gps', Htt_Pref.c_Track_Type_Gps_Output);
    Result.Put('sk_hourly', Htt_Pref.c_Schedule_Kind_Hourly);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Employee_Id number := p.r_Number('person_id');
    r_Person      Mr_Natural_Persons%rowtype;
    result        Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Company_Id, --
                                          i_Person_Id  => v_Employee_Id);
  
    result := z_Mr_Natural_Persons.To_Map(r_Person,
                                          z.Person_Id,
                                          z.Name,
                                          z.Gender,
                                          i_Person_Id => 'employee_id',
                                          i_Name      => 'person_name');
  
    Result.Put('references', References(v_Employee_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap) is
    r_Track       Htt_Tracks%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
    v_Track_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id, i_Self => false);
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Track_Id   => v_Track_Ids(i));
    
      if v_Employee_Id <> r_Track.Person_Id then
        b.Raise_Unauthorized;
      end if;
    
      Htt_Api.Track_Set_Valid(i_Company_Id => r_Track.Company_Id,
                              i_Filial_Id  => r_Track.Filial_Id,
                              i_Track_Id   => r_Track.Track_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap) is
    r_Track       Htt_Tracks%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
    v_Track_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id, i_Self => false);
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Track_Id   => v_Track_Ids(i));
    
      if v_Employee_Id <> r_Track.Person_Id then
        b.Raise_Unauthorized;
      end if;
    
      Htt_Api.Track_Set_Invalid(i_Company_Id => r_Track.Company_Id,
                                i_Filial_Id  => r_Track.Filial_Id,
                                i_Track_Id   => r_Track.Track_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Track_Type(p Hashmap) is
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    Htt_Api.Change_Track_Type(i_Company_Id     => Ui.Company_Id,
                              i_Filial_Id      => Ui.Filial_Id,
                              i_Track_Id       => p.r_Number('track_id'),
                              i_New_Track_Type => p.r_Varchar2('track_type'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    r_Track       Htt_Tracks%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
    v_Track_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Track_Id   => v_Track_Ids(i));
    
      if v_Employee_Id <> r_Track.Person_Id then
        b.Raise_Unauthorized;
      end if;
    
      Htt_Api.Track_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Track_Id   => v_Track_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Validation is
  begin
    update Htt_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Track_Id       = null,
           Track_Time     = null,
           Track_Datetime = null,
           Person_Id      = null,
           Track_Type     = null,
           Mark_Type      = null,
           Device_Id      = null,
           Location_Id    = null,
           Latlng         = null,
           Accuracy       = null,
           Photo_Sha      = null,
           Note           = null,
           Original_Type  = null,
           Is_Valid       = null,
           Status         = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
    update Htt_Timesheet_Tracks
       set Company_Id = null,
           Filial_Id  = null,
           Track_Id   = null,
           Track_Type = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           Region_Id   = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Htt_Devices
       set Company_Id     = null,
           Device_Id      = null,
           Device_Type_Id = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr219;
/
