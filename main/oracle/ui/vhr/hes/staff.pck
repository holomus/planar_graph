create or replace package Ui_Vhr95 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Direct_Employee varchar2,
    i_Check_Date      date := null
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Find_Timesheet
  (
    i_Staff_Id       number,
    i_Track_Datetime date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Last_Track_Type
  (
    i_Employee_Id number,
    i_Date        date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Gps_Track_Settings return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Settings return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Notify_Settings return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Setting_Save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Subordinates(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Details(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save_Photo(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheets(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Track_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Track_Save(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Track_Offline_Save(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Gps_Tracks(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Save(i_Val Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Data_Save(i_Val Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Attendance(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Marks(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Requests return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests_By_Param(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Notifications return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Request_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Changes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes_By_Param(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Change_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Save(p Arraylist);
  ----------------------------------------------------------------------------------------------------
  Function Load_Dashboard_Plans(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Plans(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Info(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Edit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Birthdays(i_Direct_Employee varchar2) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Accessible_Action_Keys return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Payroll(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Documents(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Task_Statuses return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Users return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Monthly_Attendance(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Download_Person_Document_Files(p Hashmap) return Fazo_File;
  ----------------------------------------------------------------------------------------------------
  Function Get_Divisions return Arraylist;
end Ui_Vhr95;
/
create or replace package body Ui_Vhr95 is
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
    return b.Translate('UI-VHR95:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Date return date is
  begin
    return Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                      i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id));
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Transaction
  (
    i_Transaction_Id varchar2,
    i_Time           varchar2
  ) is
    r_Host   Mt_Hosts%rowtype;
    r_Device Mt_Devices%rowtype;
  begin
    r_Host   := z_Mt_Hosts.Load(i_Company_Id => Ui.Company_Id, i_Host_Id => Ui.Host_Id);
    r_Device := z_Mt_Devices.Load(i_Company_Id => r_Host.Company_Id,
                                  i_Device_Id  => r_Host.Device_Id);
  
    if not
        Fazo.Equal(Hcr_Timeuuid(i_Time => i_Time, i_Sp1 => Ui.User_Id, i_Sp2 => r_Device.Device_Code),
                   i_Transaction_Id) then
      b.Raise_Error(t('transaction is invalid'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Id return number is
    r_Device         Htt_Devices%rowtype;
    v_Serial_Number  Htt_Devices.Serial_Number%type;
    v_Token          Kauth_Tokens.Token%type := Ui_Context.Token;
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff);
    result           number;
  begin
    select d.Device_Code
      into v_Serial_Number
      from Mt_Devices d
     where d.Company_Id = Ui.Company_Id
       and exists (select 1
              from Mt_Hosts h
             where h.Company_Id = d.Company_Id
               and h.Device_Id = d.Device_Id
               and h.User_Id = Ui.User_Id
               and exists (select 1
                      from Kauth_Tokens Kt
                     where Kt.Company_Id = h.Company_Id
                       and Kt.Token_Id = h.Token_Id
                       and Kt.Token = v_Token));
  
    v_Serial_Number := Htt_Util.Manager_Device_Sn(v_Serial_Number);
  
    begin
      select k.Device_Id
        into result
        from Htt_Devices k
       where k.Company_Id = Ui.Company_Id
         and k.Device_Type_Id = v_Device_Type_Id
         and k.Serial_Number = v_Serial_Number;
    
      return result;
    exception
      when No_Data_Found then
        -- register device
        z_Htt_Devices.Init(p_Row            => r_Device,
                           i_Company_Id     => Ui.Company_Id,
                           i_Device_Id      => Htt_Next.Device_Id,
                           i_Device_Type_Id => v_Device_Type_Id,
                           i_Serial_Number  => v_Serial_Number,
                           i_Name           => v_Serial_Number,
                           i_State          => 'A');
      
        Htt_Api.Device_Add(r_Device);
      
        return r_Device.Device_Id;
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Direct_Employee varchar2,
    i_Check_Date      date := null
  ) return Array_Number is
    v_Check_Date date := Nvl(i_Check_Date, Trunc(Get_Current_Date));
  
    v_Division_Ids         Array_Number;
    v_Subordinate_Chiefs   Array_Number;
    v_Access_All_Employees varchar2(1);
  
    result Array_Number := Array_Number();
  begin
    if i_Direct_Employee is null or i_Direct_Employee <> 'Y' and i_Direct_Employee <> 'N' then
      b.Raise_Fatal('hes: get_subordinates: direct employee is wrong');
    end if;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
    v_Division_Ids         := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                 i_Direct             => true,
                                                                 i_Indirect           => i_Direct_Employee = 'N',
                                                                 i_Manual             => i_Direct_Employee = 'N',
                                                                 i_Gather_Chiefs      => true);
  
    select s.Staff_Id
      bulk collect
      into result
      from Href_Staffs s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Employee_Id <> Ui.User_Id
       and s.State = 'A'
       and v_Check_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
       and ((v_Access_All_Employees = 'Y' and i_Direct_Employee = 'N') --
           or s.Org_Unit_Id member of v_Division_Ids --
            or s.Employee_Id member of v_Subordinate_Chiefs);
  
    return result;
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
      -- takes last track between [input_border, output_border]
    
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                           i_Filial_Id    => Ui.Filial_Id,
                                           i_Timesheet_Id => v_Timesheet_Ids(1));
    
      v_Shift_Begin := r_Timesheet.Input_Border;
      v_Shift_End   := Least(r_Timesheet.Output_Border, i_Date);
    
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
  
    if v_Last_Track_Type = Htt_Pref.c_Track_Type_Gps_Output then
      v_Last_Track_Type := Htt_Pref.c_Track_Type_Output;
    end if;
  
    return v_Last_Track_Type;
  exception
    when No_Data_Found then
      return Htt_Pref.c_Track_Type_Output;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Gps_Track_Settings return Hashmap is
    v_Gps_Tracking_Settings Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Working_Days          Arraylist;
    v_Staff_Id              number;
    v_Date                  date;
    result                  Hashmap := Hashmap();
  begin
    v_Gps_Tracking_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => Ui.Company_Id,
                                                                    i_Filial_Id  => Ui.Filial_Id,
                                                                    i_User_Id    => Ui.User_Id);
  
    Result.Put('gps_setting_enabled', v_Gps_Tracking_Settings.Enabled);
    Result.Put('gps_track_collect_enabled', v_Gps_Tracking_Settings.Gps_Track_Collect_Enabled);
    Result.Put('auto_output_enabled', v_Gps_Tracking_Settings.Auto_Output_Enabled);
  
    if v_Gps_Tracking_Settings.Enabled = 'Y' then
      v_Date         := Get_Current_Date;
      v_Staff_Id     := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                       i_Filial_Id   => Ui.Filial_Id,
                                                       i_Employee_Id => Ui.User_Id,
                                                       i_Date        => Trunc(v_Date));
      v_Working_Days := Arraylist();
    
      for r in (select q.Timesheet_Date, q.Begin_Time, q.End_Time
                  from Htt_Timesheets q
                 where q.Company_Id = Ui.Company_Id
                   and q.Filial_Id = Ui.Filial_Id
                   and q.Staff_Id = v_Staff_Id
                   and q.Day_Kind = Htt_Pref.c_Day_Kind_Work
                   and q.End_Time >= v_Date
                 order by q.Timesheet_Date
                 fetch first 7 Rows only)
      loop
        v_Working_Days.Push(Fazo.Zip_Map('timesheet_date',
                                         r.Timesheet_Date,
                                         'begin_time',
                                         to_char(r.Begin_Time, Href_Pref.c_Date_Format_Second),
                                         'end_time',
                                         to_char(r.End_Time, Href_Pref.c_Date_Format_Second)));
      end loop;
    
      Result.Put('distance', v_Gps_Tracking_Settings.Distance); -- distance radius in meter
      Result.Put('interval_time', v_Gps_Tracking_Settings.Interval); -- interval time in second
      Result.Put('working_days', v_Working_Days);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Settings return Hashmap is
    v_Settings               Hes_Pref.Staff_Track_Settings_Rt;
    v_Face_Register_Settings Hes_Pref.Staff_Face_Register_Rt;
    v_Cv_Photos              Array_Varchar2;
    v_Has_Day_Statistics     varchar2(1) := 'N';
    v_Hide_Salary            varchar2(1) := 'N';
    r_User                   Md_Users%rowtype;
    r_Company                Md_Companies%rowtype;
    result                   Hashmap := Hashmap();
  begin
    v_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_User_Id    => Ui.User_Id);
  
    v_Face_Register_Settings := Hes_Util.Staff_Face_Register_Settings(i_Company_Id => Ui.Company_Id,
                                                                      i_Filial_Id  => Ui.Filial_Id,
                                                                      i_User_Id    => Ui.User_Id);
  
    Result.Put('gps_determination', v_Settings.Gps_Determination);
    Result.Put('check_location', v_Settings.Track_Check_Location);
    Result.Put('face_recognation', v_Settings.Face_Recognition);
    Result.Put('emotion_wink', v_Settings.Emotion_Wink);
    Result.Put('emotion_smile', v_Settings.Emotion_Smile);
    Result.Put('face_register', v_Face_Register_Settings.Face_Register);
    Result.Put('allow_gallery', v_Face_Register_Settings.Allow_Gallery);
    Result.Put('photo_sha',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => Ui.User_Id).Photo_Sha);
    Result.Put('biometric_recognition_enabled',
               Hes_Util.Biometric_Recognition_Enabled(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => Ui.Filial_Id));
    Result.Put('use_task_manager', Hes_Util.Load_Use_Task_Manager(Ui.Company_Id));
  
    if Ui.Grant_Has('day_statistics') then
      v_Has_Day_Statistics := 'Y';
    end if;
  
    if Ui.Grant_Has('hide_salary') then
      v_Hide_Salary := 'Y';
    end if;
  
    Result.Put('has_day_statistics', v_Has_Day_Statistics);
    Result.Put('hide_salary', v_Hide_Salary);
  
    if v_Settings.Track_By_Qr_Code = 'Y' then
      Result.Put('qr_code',
                 z_Htt_Persons.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => Ui.User_Id).Qr_Code);
    end if;
  
    select t.Photo_Sha
      bulk collect
      into v_Cv_Photos
      from Htt_Person_Photos t
     where t.Company_Id = Ui.Company_Id
       and t.Person_Id = Ui.User_Id;
  
    Result.Put('photos', v_Cv_Photos);
    Result.Put('subordinates_exists', Uit_Href.Exist_Subordinate);
    Result.Put('direct_subordinates_exists', Uit_Href.Exist_Direct_Employee);
    Result.Put('gps_track_settings', Load_Gps_Track_Settings);
    Result.Put('timestamp', to_char(Current_Timestamp, 'dd.mm.yyyy hh24:mi:ss'));
    Result.Put('terminated', Uit_Hlic.Is_Terminated);
  
    r_User    := z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => Ui.User_Id);
    r_Company := z_Md_Companies.Load(i_Company_Id => Ui.Company_Id);
  
    Result.Put('chatbot_info', Md_Chatbot.Info(i_Company => r_Company, i_User => r_User));
    Result.Put('user_name', r_User.Name);
    Result.Put('company_code', r_Company.Code);
    Result.Put('company_name', r_Company.Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Notify_Settings return Hashmap is
    v_Setting Hes_Pref.Staff_Notify_Settings_Rt;
    result    Hashmap := Hashmap();
  begin
    v_Setting := Hes_Util.Staff_Notify_Settings(i_Company_Id => Ui.Company_Id,
                                                i_User_Id    => Ui.User_Id);
  
    Result.Put(Hes_Pref.c_Pref_Nt_Calendar_Day_Change, v_Setting.Calendar_Day_Change);
    Result.Put(Hes_Pref.c_Pref_Nt_Late_Time, v_Setting.Late_Time);
    Result.Put(Hes_Pref.c_Pref_Nt_Early_Time, v_Setting.Early_Time);
    Result.Put(Hes_Pref.c_Pref_Nt_Request, v_Setting.Request);
    Result.Put(Hes_Pref.c_Pref_Nt_Request_Change_Status, v_Setting.Request_Change_Status);
    Result.Put(Hes_Pref.c_Pref_Nt_Request_Manager_Approval, v_Setting.Request_Manager_Approval);
    Result.Put(Hes_Pref.c_Pref_Nt_Plan_Change, v_Setting.Plan_Change);
    Result.Put(Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change, v_Setting.Plan_Change_Status_Change);
    Result.Put(Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval,
               v_Setting.Plan_Change_Manager_Approval);
    Result.Put(Hes_Pref.c_Pref_Nt_Gps_Tracking_Change, v_Setting.Gps_Tracking_Change);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Setting_Save(p Hashmap) is
    v_Setting_Code varchar2(50);
  begin
    v_Setting_Code := p.r_Varchar2('code');
  
    if v_Setting_Code in (Hes_Pref.c_Pref_Nt_Calendar_Day_Change,
                          Hes_Pref.c_Pref_Nt_Late_Time,
                          Hes_Pref.c_Pref_Nt_Early_Time,
                          Hes_Pref.c_Pref_Nt_Request,
                          Hes_Pref.c_Pref_Nt_Request_Change_Status,
                          Hes_Pref.c_Pref_Nt_Request_Manager_Approval,
                          Hes_Pref.c_Pref_Nt_Plan_Change,
                          Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change,
                          Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval,
                          Hes_Pref.c_Pref_Nt_Gps_Tracking_Change) then
    
      Md_Api.User_Setting_Save(i_Company_Id    => Ui.Company_Id,
                               i_User_Id       => Ui.User_Id,
                               i_Filial_Id     => Ui.Filial_Head,
                               i_Setting_Code  => v_Setting_Code,
                               i_Setting_Value => p.r_Varchar2('value'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Param  Hashmap;
    v_Query  varchar2(32767);
    q        Fazo_Query;
  begin
    v_Query := 'select q.company_id,
                       q.filial_id,
                       q.track_id,
                       q.track_date,
                       q.track_time,
                       q.track_datetime,
                       q.person_id,
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
                       s.name,
                       (select f.name
                          from htt_device_types f
                         where f.device_type_id = s.device_type_id) device_type_name,
                       (select k.region_id
                          from htt_locations k
                         where k.company_id = q.company_id
                           and k.location_id = q.location_id) region_id,
                       to_char(q.track_time, :format) track_time_hh24_mi,
                       nvl2(q.latlng, ''Y'', ''N'') latlng_exists,
                       nvl2(q.photo_sha, ''Y'', ''N'') photo_exists,
                       nvl((select listagg(tps.track_type, '','')
                            within group
                            (order by decode(tps.track_type,
                                             :input_track, 1,
                                             :output_track, 2,
                                             :merger_track, 3,
                                             :potential_output, 4,
                                             5))
                       from (select tt.track_type
                               from htt_timesheet_tracks tt
                              where tt.company_id = q.company_id
                                and tt.filial_id = q.filial_id
                                and tt.track_id = q.track_id
                              group by tt.track_type) tps),
                        q.original_type) track_types,
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
                       end as is_potential_output
                  from htt_tracks q
                  left join htt_devices s
                    on q.company_id = s.company_id
                   and q.device_id = s.device_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Query := 'select qr.*,
                       substr(qr.track_types, 1, 1) track_type
                  from (' || v_Query || ' ) qr';
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'filial_id',
                            Ui.Filial_Id,
                            'format',
                            Href_Pref.c_Time_Format_Minute);
  
    v_Param.Put('input_track', Htt_Pref.c_Track_Type_Input);
    v_Param.Put('output_track', Htt_Pref.c_Track_Type_Output);
    v_Param.Put('merger_track', Htt_Pref.c_Track_Type_Merger);
    v_Param.Put('check_track', Htt_Pref.c_Track_Type_Check);
    v_Param.Put('potential_output', Htt_Pref.c_Track_Type_Potential_Output);
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('track_id',
                   'person_id',
                   'location_id',
                   'region_id',
                   'device_id',
                   'device_type_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('track_type',
                     'mark_type',
                     'photo_sha',
                     'latlng',
                     'accuracy',
                     'note',
                     'is_valid',
                     'track_time_hh24_mi',
                     'device_type_name');
    q.Varchar2_Field('latlng_exists', 'photo_exists', 'is_potential_output', 'track_types');
    q.Date_Field('track_time', 'created_on', 'modified_on');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Mark_Types;
  
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
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
    q.Option_Field('is_potential_output_name',
                   'is_potential_output',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons s
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees f
                            where f.company_id = s.company_id
                              and f.filial_id = :filial_id
                              and f.employee_id = s.person_id)');
    q.Refer_Field('location_name',
                  'location_id',
                  'htt_locations',
                  'location_id',
                  'name',
                  'select *
                     from htt_locations s
                    where s.company_id = :company_id
                      and s.prohibited = ''N''
                      and exists (select 1
                             from htt_location_filials lf
                            where lf.company_id = :company_id
                              and lf.filial_id = :filial_id
                              and lf.location_id = s.location_id)');
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
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Subordinates(p Hashmap) return Fazo_Query is
    v_Matrix          Matrix_Varchar2;
    v_Direct_Employee varchar2(1) := 'N';
    q                 Fazo_Query;
    v_Query           varchar2(4000);
    v_Params          Hashmap;
  begin
    if p is not null and p.Has('direct_employee') then
      v_Direct_Employee := p.r_Varchar2('direct_employee');
    end if;
  
    v_Query := 'select q.person_id,
                       q.name,
                       q.first_name,
                       q.last_name,
                       q.middle_name,
                       q.gender,
                       q.birthday,
                       q.code,
                       k.photo_sha,
                       k.email,
                       w.tin,
                       w.region_id,
                       w.main_phone,
                       w.address, 
                       s.division_id
                  from mr_natural_persons q
                  join md_persons k
                    on k.company_id = q.company_id
                   and k.person_id = q.person_id
                  join mr_person_details w
                    on w.company_id = q.company_id
                   and w.person_id = q.person_id
                  join href_staffs s
                    on s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.employee_id = q.person_id
                   and s.staff_kind = :sk_primary
                   and s.hiring_date <= :current_date
                   and (s.dismissal_date is null or s.dismissal_date >= :current_date)
                   and s.state = ''A''
                   and s.staff_id member of :subordinates
                 where q.company_id = :company_id
                   and q.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = :filial_id
                           and e.employee_id = q.person_id
                           and e.state = ''A'')';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'current_date',
                             Trunc(Get_Current_Date),
                             'sk_primary',
                             Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('subordinates', Get_Subordinates(v_Direct_Employee));
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id', 'region_id', 'division_id');
    q.Varchar2_Field('name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'code',
                     'photo_sha',
                     'email',
                     'tin',
                     'main_phone');
    q.Varchar2_Field('address');
    q.Date_Field('birthday');
  
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions
                    where company_id = :company_id');
  
    v_Matrix := Md_Util.Person_Genders;
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('subordinates_exists',
                'select case
                          when exists (select 1
                                  from hrm_robot_divisions rd
                                  join mrf_robots r
                                    on r.company_id = :company_id
                                   and r.filial_id = :filial_id
                                   and r.robot_id = rd.robot_id
                                   and r.person_id = $person_id
                                 where rd.company_id = :company_id
                                   and rd.filial_id = :filial_id) then
                           ''Y''
                          else
                           ''N''
                        end
                   from dual');
    q.Map_Field('job_name',
                'select j.name
                   from mhr_jobs j
                  where j.company_id = :company_id
                    and j.filial_id = :filial_id
                    and j.state = ''A''
                    and exists (select 1
                           from mhr_employees e
                          where e.company_id = j.company_id
                            and e.filial_id = j.filial_id
                            and e.employee_id = $person_id
                            and e.job_id = j.job_id
                            and e.state = ''A'')');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Details(p Hashmap) return Hashmap is
    r_Person           Md_Persons%rowtype;
    r_Employee         Mhr_Employees%rowtype;
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    r_Person_Detail    Href_Person_Details%rowtype;
    v_Photos           Array_Varchar2;
    result             Hashmap;
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => p.r_Number('employee_id'));
  
    result := z_Md_Persons.To_Map(r_Person, z.Name, z.Photo_Sha, z.Email);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person,
                                               z.First_Name,
                                               z.Last_Name,
                                               z.Middle_Name,
                                               z.Gender,
                                               z.Birthday));
  
    Result.Put('responsible_person_name',
               Href_Util.Get_Manager_Name(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Employee_Id => r_Person.Person_Id));
  
    r_Mr_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Person_Details.To_Map(r_Mr_Person_Detail,
                                              z.Tin,
                                              z.Main_Phone,
                                              z.Address,
                                              z.Legal_Address));
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => r_Mr_Person_Detail.Company_Id, i_Region_Id => r_Mr_Person_Detail.Region_Id).Name);
  
    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Href_Person_Details.To_Map(r_Person_Detail, z.Iapa, z.Npin));
  
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Employee_Id => r_Person.Person_Id);
  
    Result.Put('employee_number', r_Employee.Employee_Number);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, --
               i_Division_Id => r_Employee.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, --
               i_Job_Id => r_Employee.Job_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, --
               i_Rank_Id => r_Employee.Rank_Id).Name);
  
    select q.Photo_Sha
      bulk collect
      into v_Photos
      from Htt_Person_Photos q
     where q.Company_Id = r_Person.Company_Id
       and q.Person_Id = r_Person.Person_Id;
  
    Result.Put('photos', v_Photos);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save_Photo(p Hashmap) is
    v_Person_Id number := p.r_Number('person_id');
    v_Photos    Array_Varchar2 := p.r_Array_Varchar2('photo_shas');
    r_Person    Md_Persons%rowtype;
  begin
    -- This is temporary solutions
    -- This action need to do as photo upload in Employee add form
    r_Person := z_Md_Persons.Lock_Load(i_Company_Id => Ui.Company_Id, i_Person_Id => v_Person_Id);
  
    for i in 1 .. v_Photos.Count
    loop
      Htt_Api.Person_Save_Photo(i_Company_Id => Ui.Company_Id,
                                i_Person_Id  => v_Person_Id,
                                i_Photo_Sha  => v_Photos(i),
                                i_Is_Main    => 'N');
    
      if r_Person.Photo_Sha is null then
        r_Person.Photo_Sha := v_Photos(i);
        Md_Api.Person_Update(i_Company_Id => Ui.Company_Id,
                             i_Person_Id  => v_Person_Id,
                             i_Photo_Sha  => Option_Varchar2(r_Person.Photo_Sha));
      end if;
    end loop;
  
    for r in (select *
                from Htt_Person_Photos q
               where q.Company_Id = Ui.Company_Id
                 and q.Person_Id = v_Person_Id
                 and q.Photo_Sha not member of v_Photos)
    loop
      Htt_Api.Person_Photo_Delete(i_Company_Id => r.Company_Id,
                                  i_Person_Id  => r.Person_Id,
                                  i_Photo_Sha  => r.Photo_Sha);
    end loop;
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
  Function Load_Timesheet
  (
    i_Staff_Id       number,
    i_Timesheet_Date date,
    i_With_Tracks    boolean := false
  ) return Hashmap is
    r_Timesheet     Htt_Timesheets%rowtype;
    r_Time_Kind     Htt_Time_Kinds%rowtype;
    r_Facts         Htt_Pref.Timesheet_Aggregated_Fact_Nt;
    r_Fact          Htt_Pref.Timesheet_Aggregated_Fact_Rt;
    v_Facts         Arraylist;
    v_Item          Hashmap;
    v_Items         Arraylist;
    v_Timesheet     Hashmap;
    v_Fact_Time     number := 0;
    v_Has_Leaves    varchar2(1);
    v_Merger_Begin  date;
    v_Merger_End    date;
    v_Current_Time  date := Get_Current_Date;
    v_Free_Tk_Id    number;
    v_Turnout_Tk_Id number;
    v_Hourly_Input  date;
    v_Hourly_Output date;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      p_Map        in out nocopy Hashmap,
      i_Keyname    varchar2,
      i_Time_Value date
    ) is
    begin
      p_Map.Put(i_Keyname, to_char(i_Time_Value, Href_Pref.c_Date_Format_Second));
    end;
  
    ----------------------------------------------------------------------------------------------------
    Procedure Put_Hourly_Input_Output(i_Timesheet Htt_Timesheets%rowtype) is
      v_Time_Distance number;
      v_Input         date;
      v_Timezone_Code Md_Timezones.Timezone_Code%type := Htt_Util.Load_Timezone(i_Company_Id => i_Timesheet.Company_Id,
                                                                                i_Filial_Id  => i_Timesheet.Filial_Id);
      v_Current_Time  date := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                                         i_Timezone  => v_Timezone_Code);
      v_Inputs        Array_Date := Array_Date();
    begin
      if Trunc(v_Current_Time) <> i_Timesheet.Timesheet_Date then
        return;
      end if;
    
      for r in (select w.*
                  from Htt_Timesheet_Tracks w
                 where w.Company_Id = i_Timesheet.Company_Id
                   and w.Filial_Id = i_Timesheet.Filial_Id
                   and w.Timesheet_Id = i_Timesheet.Timesheet_Id
                 order by w.Track_Datetime)
      loop
        if r.Track_Type = Htt_Pref.c_Track_Type_Input and
           r.Track_Datetime >= i_Timesheet.Input_Border and
           r.Track_Datetime < i_Timesheet.Shift_End_Time then
          Fazo.Push(v_Inputs, r.Track_Datetime);
        elsif r.Track_Type = Htt_Pref.c_Track_Type_Output and v_Inputs.Count > 0 then
          if r.Track_Datetime >= i_Timesheet.Shift_Begin_Time and
             r.Track_Datetime <= i_Timesheet.Output_Border then
            for j in 1 .. v_Inputs.Count
            loop
              v_Input         := v_Inputs(j);
              v_Time_Distance := Htt_Util.Time_Diff(r.Track_Datetime, v_Input);
              exit when v_Time_Distance <= i_Timesheet.Track_Duration;
            end loop;
          
            if v_Time_Distance <= i_Timesheet.Track_Duration and
               v_Input < i_Timesheet.Shift_End_Time then
              v_Hourly_Input  := v_Input;
              v_Hourly_Output := r.Track_Datetime;
            end if;
          end if;
        
          v_Inputs := Array_Date();
        end if;
      end loop;
    
      for i in 1 .. v_Inputs.Count
      loop
        v_Input         := v_Inputs(i);
        v_Time_Distance := Htt_Util.Time_Diff(v_Current_Time, v_Input);
        if v_Time_Distance <= i_Timesheet.Track_Duration and v_Input < i_Timesheet.Shift_End_Time then
          v_Hourly_Input  := v_Input;
          v_Hourly_Output := null;
          exit;
        end if;
      end loop;
    
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'hourly_input_time',
               i_Time_Value => v_Hourly_Input);
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'hourly_output_time',
               i_Time_Value => v_Hourly_Output);
    end;
  
    --------------------------------------------------
    Function Get_Holiday_Name return varchar2 is
      r_Calendar_Day Htt_Calendar_Days%rowtype;
    begin
      r_Calendar_Day := z_Htt_Calendar_Days.Take(i_Company_Id    => r_Timesheet.Company_Id,
                                                 i_Filial_Id     => r_Timesheet.Filial_Id,
                                                 i_Calendar_Id   => r_Timesheet.Calendar_Id,
                                                 i_Calendar_Date => r_Timesheet.Timesheet_Date);
    
      return r_Calendar_Day.Name;
    end;
  begin
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => i_Staff_Id,
                                      i_Timesheet_Date => i_Timesheet_Date);
  
    v_Timesheet := z_Htt_Timesheets.To_Map(r_Timesheet, z.Schedule_Kind, z.Break_Enabled);
  
    Put_Time(p_Map        => v_Timesheet,
             i_Keyname    => 'begin_time',
             i_Time_Value => r_Timesheet.Begin_Time);
    Put_Time(p_Map => v_Timesheet, i_Keyname => 'end_time', i_Time_Value => r_Timesheet.End_Time);
    Put_Time(p_Map        => v_Timesheet,
             i_Keyname    => 'break_begin_time',
             i_Time_Value => r_Timesheet.Break_Begin_Time);
    Put_Time(p_Map        => v_Timesheet,
             i_Keyname    => 'break_end_time',
             i_Time_Value => r_Timesheet.Break_End_Time);
    Put_Time(p_Map        => v_Timesheet,
             i_Keyname    => 'input_time',
             i_Time_Value => r_Timesheet.Input_Time);
    Put_Time(p_Map        => v_Timesheet,
             i_Keyname    => 'output_time',
             i_Time_Value => r_Timesheet.Output_Time);
  
    v_Timesheet.Put('timesheet_date', Nvl(r_Timesheet.Timesheet_Date, i_Timesheet_Date));
    v_Timesheet.Put('day_kind', Nvl(r_Timesheet.Day_Kind, Htt_Pref.c_Day_Kind_Rest));
  
    if r_Timesheet.Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
      v_Timesheet.Put('holiday_name', Get_Holiday_Name);
    end if;
  
    if r_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'shift_begin_date',
               i_Time_Value => r_Timesheet.Input_Border);
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'shift_end_date',
               i_Time_Value => r_Timesheet.Output_Border);
    elsif r_Timesheet.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'shift_begin_date',
               i_Time_Value => case
                                 when v_Current_Time > r_Timesheet.Shift_End_Time then
                                  r_Timesheet.Shift_Begin_Time
                                 else
                                  v_Current_Time - Numtodsinterval(r_Timesheet.Track_Duration, 'second')
                               end);
      Put_Time(p_Map        => v_Timesheet,
               i_Keyname    => 'shift_end_date',
               i_Time_Value => r_Timesheet.Output_Border);
    
      Put_Hourly_Input_Output(i_Timesheet => r_Timesheet);
    else
      if v_Current_Time >= r_Timesheet.Shift_Begin_Time and
         v_Current_Time < r_Timesheet.Shift_End_Time and
         (r_Timesheet.Input_Border <> r_Timesheet.Shift_Begin_Time or
         r_Timesheet.Output_Border <> r_Timesheet.Shift_End_Time) then
        -- interval [current_time - track_duraction, shift_end_time]
        -- used to find tracks that define last_track_type
        -- even if they dont affect current timesheet
      
        -- used only by current day timesheet
        -- used only when input/output borders differ from shift borders
        Put_Time(p_Map        => v_Timesheet,
                 i_Keyname    => 'shift_begin_date',
                 i_Time_Value => Least(r_Timesheet.Shift_Begin_Time,
                                       v_Current_Time -
                                       Numtodsinterval(r_Timesheet.Track_Duration, 'second')));
        Put_Time(p_Map        => v_Timesheet,
                 i_Keyname    => 'shift_end_date',
                 i_Time_Value => r_Timesheet.Shift_End_Time);
      else
        Put_Time(p_Map        => v_Timesheet,
                 i_Keyname    => 'shift_begin_date',
                 i_Time_Value => r_Timesheet.Shift_Begin_Time);
        Put_Time(p_Map        => v_Timesheet,
                 i_Keyname    => 'shift_end_date',
                 i_Time_Value => r_Timesheet.Shift_End_Time);
      end if;
    end if;
  
    v_Timesheet.Put('plan_time', Round(r_Timesheet.Plan_Time / 60, 2));
    v_Timesheet.Put('full_time', Round(r_Timesheet.Full_Time / 60, 2));
  
    Has_Merger(o_Merger_Begin => v_Merger_Begin,
               o_Merger_End   => v_Merger_End,
               i_Timesheet    => r_Timesheet,
               i_Current_Time => v_Current_Time);
  
    Put_Time(p_Map => v_Timesheet, i_Keyname => 'merger_begin', i_Time_Value => v_Merger_Begin);
    Put_Time(p_Map => v_Timesheet, i_Keyname => 'merger_end', i_Time_Value => v_Merger_End);
  
    v_Facts := Arraylist();
  
    r_Facts := Htt_Util.Get_Full_Facts(i_Company_Id   => r_Timesheet.Company_Id,
                                       i_Filial_Id    => r_Timesheet.Filial_Id,
                                       i_Timesheet_Id => r_Timesheet.Timesheet_Id);
  
    v_Turnout_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
    v_Free_Tk_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    for i in 1 .. r_Facts.Count
    loop
      r_Fact      := r_Facts(i);
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => Ui.Company_Id,
                                           i_Time_Kind_Id => r_Fact.Time_Kind_Id);
    
      if r_Time_Kind.Parent_Id is null and r_Fact.Fact_Value > 0 then
        v_Facts.Push(Fazo.Zip_Map('time_kind_name',
                                  r_Time_Kind.Name,
                                  'fact_value',
                                  Round(r_Fact.Fact_Value / 60)));
      end if;
    
      if Nvl(r_Time_Kind.Parent_Id, r_Time_Kind.Time_Kind_Id) in (v_Turnout_Tk_Id, v_Free_Tk_Id) then
        v_Fact_Time := v_Fact_Time + r_Fact.Fact_Value;
      end if;
    end loop;
  
    v_Facts.Push(Fazo.Zip_Map('time_kind_name',
                              t('fact_time'),
                              'fact_value',
                              Round(v_Fact_Time / 60)));
    v_Timesheet.Put('facts', v_Facts);
  
    if i_With_Tracks then
      v_Items := Arraylist();
    
      for r in (select w.*
                  from Htt_Timesheet_Tracks q
                  join Htt_Tracks w
                    on w.Company_Id = q.Company_Id
                   and w.Track_Id = q.Track_Id
                 where q.Company_Id = r_Timesheet.Company_Id
                   and q.Timesheet_Id = r_Timesheet.Timesheet_Id)
      loop
        v_Item := z_Htt_Tracks.To_Map(r,
                                      z.Track_Date,
                                      z.Track_Time,
                                      z.Track_Datetime,
                                      z.Track_Type,
                                      z.Mark_Type,
                                      z.Device_Id,
                                      z.Location_Id,
                                      z.Latlng,
                                      z.Accuracy,
                                      z.Photo_Sha,
                                      z.Note,
                                      z.Is_Valid);
      
        v_Item.Put('track_type_name', Htt_Util.t_Track_Type(r.Track_Type));
        v_Item.Put('mark_type_name', Htt_Util.t_Mark_Type(r.Mark_Type));
        v_Item.Put('device_name',
                   z_Htt_Devices.Take(i_Company_Id => r.Company_Id, --
                   i_Device_Id => r.Device_Id).Name);
        v_Item.Put('location_name',
                   z_Htt_Locations.Take(i_Company_Id => r.Company_Id, --
                   i_Location_Id => r.Location_Id).Name);
      
        v_Items.Push(v_Item);
      end loop;
    
      v_Timesheet.Put('tracks', v_Items);
    end if;
  
    begin
      select 'Y'
        into v_Has_Leaves
        from Htt_Timesheet_Requests q
       where q.Company_Id = r_Timesheet.Company_Id
         and q.Filial_Id = r_Timesheet.Filial_Id
         and q.Timesheet_Id = r_Timesheet.Timesheet_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Has_Leaves := 'N';
    end;
  
    v_Timesheet.Put('has_leaves', v_Has_Leaves);
  
    return v_Timesheet;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheets(p Hashmap) return Arraylist is
    r_Timesheet   Htt_Timesheets%rowtype;
    v_Begin_Date  date := p.o_Date('begin_date');
    v_End_Date    date := p.o_Date('end_date');
    v_Employee_Id number := p.r_Number('employee_id');
    v_With_Tracks boolean := p.r_Varchar2('with_tracks') = 'Y';
    v_Staff_Id    number;
    result        Arraylist := Arraylist();
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => v_Employee_Id,
                                                 i_Date        => Trunc(Get_Current_Date));
  
    if v_Begin_Date is null or v_End_Date is null then
      r_Timesheet.Timesheet_Id := Find_Timesheet(i_Staff_Id       => v_Staff_Id,
                                                 i_Track_Datetime => Get_Current_Date);
      if r_Timesheet.Timesheet_Id is null then
        v_Begin_Date := Trunc(Get_Current_Date);
      else
        r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                             i_Filial_Id    => Ui.Filial_Id,
                                             i_Timesheet_Id => r_Timesheet.Timesheet_Id);
      
        v_Begin_Date := r_Timesheet.Timesheet_Date;
      end if;
      v_End_Date := v_Begin_Date;
    end if;
  
    -- temporary, remove when mobile no longer sends 'begin_date' and 'end_date'
    -- to find current timesheet
    -- 'if' clause above actually sets correct 'v_begin_date'
    if Trunc(Get_Current_Date) = v_Begin_Date then
      r_Timesheet.Timesheet_Id := Find_Timesheet(i_Staff_Id       => v_Staff_Id,
                                                 i_Track_Datetime => Get_Current_Date);
    
      if r_Timesheet.Timesheet_Id is not null then
        r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                             i_Filial_Id    => Ui.Filial_Id,
                                             i_Timesheet_Id => r_Timesheet.Timesheet_Id);
      
        v_Begin_Date := r_Timesheet.Timesheet_Date;
      end if;
    end if;
  
    for i in 0 .. v_End_Date - v_Begin_Date
    loop
      Result.Push(Load_Timesheet(i_Staff_Id       => v_Staff_Id,
                                 i_Timesheet_Date => v_Begin_Date + i,
                                 i_With_Tracks    => v_With_Tracks));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Model return Hashmap is
    v_Items           Arraylist := Arraylist();
    v_Settings        Hes_Pref.Staff_Track_Settings_Rt;
    v_Track_Types     Array_Varchar2 := Array_Varchar2();
    v_Last_Track_Type varchar2(1);
    v_Current_Time    date := Get_Current_Date;
    v_Set_Valid       varchar2(1) := 'N';
    v_Set_Invalid     varchar2(1) := 'N';
    result            Hashmap := Hashmap();
    --------------------------------------------------
    Function Location_Available return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Location_Persons q
        join Htt_Locations w
          on q.Company_Id = w.Company_Id
         and q.Location_Id = w.Location_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Person_Id = Ui.User_Id
         and w.Prohibited = 'Y'
         and w.State = 'A'
         and Rownum = 1;
    
      return false;
    exception
      when No_Data_Found then
        return true;
    end;
  
    --------------------------------------------------
    Function Merger_Completed return varchar2 is
      v_Timesheet_Id     number;
      r_Timesheet        Htt_Timesheets%rowtype;
      v_Merger_Begin     date;
      v_Merger_End       date;
      v_Merger_Completed varchar2(1) := 'N';
    begin
      v_Timesheet_Id := Find_Timesheet(i_Staff_Id       => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                                                          i_Filial_Id   => Ui.Filial_Id,
                                                                                          i_Employee_Id => Ui.User_Id,
                                                                                          i_Date        => Trunc(v_Current_Time)),
                                       i_Track_Datetime => v_Current_Time);
    
      if v_Timesheet_Id is null then
        return 'N';
      end if;
    
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => Ui.Company_Id,
                                           i_Filial_Id    => Ui.Filial_Id,
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
         where Tt.Company_Id = Ui.Company_Id
           and Tt.Filial_Id = Ui.Filial_Id
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
    v_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_User_Id    => Ui.User_Id);
  
    -- locations  
    if Location_Available then
      for r in (select *
                  from Htt_Locations q
                 where q.Company_Id = Ui.Company_Id
                   and q.Prohibited = 'N'
                   and q.State = 'A'
                   and exists (select 1
                          from Htt_Location_Persons w
                         where w.Company_Id = Ui.Company_Id
                           and w.Filial_Id = Ui.Filial_Id
                           and w.Location_Id = q.Location_Id
                           and w.Person_Id = Ui.User_Id)
                 order by q.Name)
      loop
        v_Items.Push(z_Htt_Locations.To_Map(r, --
                                            z.Location_Id,
                                            z.Name,
                                            z.Latlng,
                                            z.Accuracy,
                                            z.Bssids));
      end loop;
    end if;
  
    Result.Put('locations', v_Items);
  
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
  
    -- available track types
    if v_Settings.Last_Track_Type = 'Y' then
      -- last track type
      v_Last_Track_Type := Last_Track_Type(i_Employee_Id => Ui.User_Id, --
                                           i_Date        => v_Current_Time);
    
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
    end if;
  
    Result.Put('track_types', v_Track_Types);
    Result.Put('merger_completed', Merger_Completed);
  
    if Ui.Grant_Has('set_valid') then
      v_Set_Valid := 'Y';
    end if;
  
    if Ui.Grant_Has('set_invalid') then
      v_Set_Invalid := 'Y';
    end if;
  
    Result.Put('set_valid', v_Set_Valid);
    Result.Put('set_invalid', v_Set_Invalid);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Save(p Hashmap) return varchar2 is
    r_Track           Htt_Tracks%rowtype;
    v_Settings        Hes_Pref.Staff_Track_Settings_Rt;
    v_Photo_Sha       varchar2(64) := p.o_Varchar2('photo_sha');
    v_Track_Type      varchar2(1) := p.r_Varchar2('track_type');
    v_Mark_Type       varchar2(1) := p.r_Varchar2('mark_type');
    v_Last_Track_Type varchar2(1);
  
    --------------------------------------------------
    Function Check_Track_Time(i_Device_Time date) return boolean is
    begin
      return Abs(Trunc((Htt_Util.Timestamp_To_Date(Current_Timestamp, null) - i_Device_Time) * 1440)) <= 5;
    end;
  begin
    v_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_User_Id    => Ui.User_Id);
  
    if v_Settings.Last_Track_Type = 'Y' then
      v_Last_Track_Type := Last_Track_Type(i_Employee_Id => Ui.User_Id, --
                                           i_Date        => Get_Current_Date);
    end if;
  
    if v_Photo_Sha is null and v_Settings.Face_Recognition = 'Y' then
      b.Raise_Error(t('when face recognition is on there must be photo of staff'));
    end if;
  
    if v_Settings.Gps_Determination = 'N' and v_Settings.Face_Recognition = 'N' then
      b.Raise_Error(t('you do not have access to send track'));
    end if;
  
    -- track_type
    case v_Track_Type
    -- temporary removed
    --      when Htt_Pref.c_Track_Type_Check then
    --        if v_Settings.Track_Type_Check = 'N' then
    --          b.Raise_Error(t('you do not have access to track'));
    --        end if;
    
      when Htt_Pref.c_Track_Type_Input then
        if v_Settings.Track_Type_Input = 'N' then
          b.Raise_Error(t('you do not have access to input'));
        end if;
      
        if v_Settings.Last_Track_Type = 'Y' and v_Last_Track_Type = Htt_Pref.c_Track_Type_Input then
          b.Raise_Error(t('you can not send input track'));
        end if;
      
      when Htt_Pref.c_Track_Type_Output then
        if v_Settings.Track_Type_Output = 'N' then
          b.Raise_Error(t('you do not have access to output'));
        end if;
      
        if v_Settings.Last_Track_Type = 'Y' and v_Last_Track_Type = Htt_Pref.c_Track_Type_Output then
          b.Raise_Error(t('you can not send output track'));
        end if;
      else
        null;
    end case;
  
    -- mark_type
    if v_Mark_Type = Htt_Pref.c_Mark_Type_Face then
      if v_Settings.Face_Recognition = 'N' then
        b.Raise_Error(t('user cannot send track with face recognition'));
      end if;
    elsif v_Mark_Type not in (Htt_Pref.c_Mark_Type_Manual, Htt_Pref.c_Mark_Type_Auto) then
      b.Raise_Error(t('user cannot send track with mark_types other than $1, $2 and $3',
                      Htt_Util.t_Track_Type(Htt_Pref.c_Mark_Type_Manual),
                      Htt_Util.t_Track_Type(Htt_Pref.c_Mark_Type_Face),
                      Htt_Util.t_Track_Type(Htt_Pref.c_Mark_Type_Auto)));
    end if;
  
    -- check device time and server time
    if p.Has('track_time') and not Check_Track_Time(p.r_Date('track_time')) then
      b.Raise_Error(t('time on your phone is wrong! please fix it!'));
    end if;
  
    z_Htt_Tracks.Init(p_Row         => r_Track,
                      i_Company_Id  => Ui.Company_Id,
                      i_Filial_Id   => Ui.Filial_Id,
                      i_Track_Id    => Htt_Next.Track_Id,
                      i_Track_Time  => Current_Timestamp,
                      i_Person_Id   => Ui.User_Id,
                      i_Track_Type  => v_Track_Type,
                      i_Mark_Type   => v_Mark_Type,
                      i_Device_Id   => Get_Device_Id,
                      i_Location_Id => p.o_Number('location_id'),
                      i_Latlng      => p.o_Varchar2('latlng'),
                      i_Accuracy    => p.o_Number('accuracy'),
                      i_Photo_Sha   => v_Photo_Sha,
                      i_Bssid       => p.o_Varchar2('bssid'),
                      i_Note        => p.o_Varchar2('note'),
                      i_Is_Valid    => p.o_Varchar2('valid'));
  
    if r_Track.Location_Id is not null and
       not z_Htt_Location_Persons.Exist(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Location_Id => r_Track.Location_Id,
                                        i_Person_Id   => Ui.User_Id) then
      b.Raise_Error(t('you do not have access to location, location_id=$1', r_Track.Location_Id));
    end if;
  
    r_Track.Track_Date := Trunc(r_Track.Track_Time);
  
    Htt_Api.Track_Add(r_Track);
  
    return to_char(Current_Timestamp, 'dd.mm.yyyy hh24:mi:ss');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap) is
    r_Track     Htt_Tracks%rowtype;
    v_Track_Ids Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    if not Ui.Grant_Has('set_valid') then
      return;
    end if;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Track_Id   => v_Track_Ids(i));
    
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Track.Person_Id, i_Self => false);
    
      Htt_Api.Track_Set_Valid(i_Company_Id => r_Track.Company_Id,
                              i_Filial_Id  => r_Track.Filial_Id,
                              i_Track_Id   => r_Track.Track_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap) is
    r_Track     Htt_Tracks%rowtype;
    v_Track_Ids Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    if not Ui.Grant_Has('set_invalid') then
      return;
    end if;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Track_Id   => v_Track_Ids(i));
    
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Track.Person_Id, i_Self => false);
    
      Htt_Api.Track_Set_Invalid(i_Company_Id => r_Track.Company_Id,
                                i_Filial_Id  => r_Track.Filial_Id,
                                i_Track_Id   => r_Track.Track_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Track_Offline_Save(p Hashmap) return varchar2 is
    r_Track Htt_Tracks%rowtype;
  begin
    Check_Transaction(p.r_Varchar2('transaction_id'), p.r_Varchar2('track_time'));
  
    z_Htt_Tracks.Init(p_Row         => r_Track,
                      i_Company_Id  => Ui.Company_Id,
                      i_Filial_Id   => Ui.Filial_Id,
                      i_Track_Id    => Htt_Next.Track_Id,
                      i_Track_Time  => p.r_Timestamp('track_time'),
                      i_Person_Id   => Ui.User_Id,
                      i_Track_Type  => p.r_Varchar2('track_type'),
                      i_Mark_Type   => p.r_Varchar2('mark_type'),
                      i_Device_Id   => Get_Device_Id,
                      i_Location_Id => p.o_Number('location_id'),
                      i_Latlng      => p.o_Varchar2('latlng'),
                      i_Accuracy    => p.o_Number('accuracy'),
                      i_Photo_Sha   => p.o_Varchar2('photo_sha'),
                      i_Note        => p.o_Varchar2('note'),
                      i_Is_Valid    => p.o_Varchar2('valid'));
  
    r_Track.Track_Date := Trunc(r_Track.Track_Time);
  
    Htt_Api.Track_Add(r_Track);
  
    return to_char(Current_Timestamp, 'dd.mm.yyyy hh24:mi:ss');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Gps_Tracks(p Hashmap) return Json_Object_t is
    v_Track_Date date := p.r_Date('track_date');
    v_Data       blob;
    result       Json_Object_t := Json_Object_t;
  begin
    begin
      select (select w.Data
                from Htt_Gps_Track_Datas w
               where w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Track_Id = q.Track_Id)
        into v_Data
        from Htt_Gps_Tracks q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Person_Id = Ui.User_Id
         and q.Track_Date = v_Track_Date;
    
      Result.Put('data', v_Data);
    exception
      when No_Data_Found then
        Result.Put('data', '');
    end;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Save(i_Val Array_Varchar2) return Hashmap is
    v_Track   Htt_Pref.Gps_Track_Data_Rt;
    v_Arr     Json_Array_t;
    v_Map     Json_Object_t;
    v_Latlngs Array_Varchar2;
  begin
    v_Arr := Json_Array_t(Fazo.Make_Clob(i_Val));
  
    v_Track.Company_Id := Ui.Company_Id;
    v_Track.Filial_Id  := Ui.Filial_Id;
    v_Track.Person_Id  := Ui.User_Id;
  
    for i in 1 .. v_Arr.Get_Size
    loop
      v_Map := Treat(v_Arr.Get(i - 1) as Json_Object_t);
    
      exit when not v_Map.Has('track_time');
    
      v_Latlngs := Fazo.Split(v_Map.Get_String('latlng'), ',');
    
      v_Track.Track_Time := to_date(v_Map.Get_String('track_time'), Href_Pref.c_Date_Format_Second);
      v_Track.Track_Date := Trunc(v_Track.Track_Time);
      v_Track.Lat        := v_Latlngs(1);
      v_Track.Lng        := v_Latlngs(2);
      v_Track.Accuracy   := v_Map.Get_Number('accuracy');
      v_Track.Provider   := v_Map.Get_String('provider');
      v_Track.Track_Id   := Htt_Util.Gps_Track_Id(i_Company_Id => v_Track.Company_Id,
                                                  i_Filial_Id  => v_Track.Filial_Id,
                                                  i_Person_Id  => v_Track.Person_Id,
                                                  i_Track_Date => v_Track.Track_Date);
    
      if v_Track.Track_Id is null then
        v_Track.Track_Id := Htt_Next.Gps_Track_Id;
      end if;
    
      Htt_Api.Gps_Track_Add(v_Track);
    end loop;
  
    return Load_Gps_Track_Settings;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gps_Track_Data_Save(i_Val Array_Varchar2) return Hashmap is
    v_Track Htt_Pref.Gps_Track_Rt;
    v_Arr   Json_Array_t;
    v_Map   Json_Object_t;
  begin
    v_Arr := Json_Array_t(Fazo.Make_Clob(i_Val));
  
    v_Track.Company_Id := Ui.Company_Id;
    v_Track.Filial_Id  := Ui.Filial_Id;
    v_Track.Person_Id  := Ui.User_Id;
  
    for i in 1 .. v_Arr.Get_Size
    loop
      v_Map := Treat(v_Arr.Get(i - 1) as Json_Object_t);
    
      exit when not v_Map.Has('track_date');
    
      v_Track.Track_Date := to_date(v_Map.Get_String('track_date'), Href_Pref.c_Date_Format_Day);
      v_Track.Data       := v_Map.Get_Blob('data');
      v_Track.Batch_Id   := v_Map.Get_Number('batch_id');
    
      Htt_Api.Gps_Track_Add(v_Track);
    end loop;
  
    return Load_Gps_Track_Settings;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Attendance(p Hashmap) return Arraylist is
    v_Timesheet_Date  date := p.r_Date('date');
    v_With_Track      varchar2(1) := Nvl(p.o_Varchar2('with_track'), 'N');
    v_Direct_Employee varchar2(1) := 'N';
  
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Current_Time date := Get_Current_Date;
    v_Late_Id      number;
    v_Absence_Ids  Array_Number;
    v_Turnout_Ids  Array_Number;
    v_Subordinates Array_Number;
    v_Item         Hashmap;
  
    result Arraylist := Arraylist();
  begin
    if p is not null and p.Has('direct_employee') then
      v_Direct_Employee := p.r_Varchar2('direct_employee');
    end if;
  
    v_Subordinates := Get_Subordinates(i_Direct_Employee => v_Direct_Employee,
                                       i_Check_Date      => v_Timesheet_Date);
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Absence_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Vacation));
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    for r in (select q.Employee_Id,
                     k.Timesheet_Id,
                     k.Input_Time,
                     k.Output_Time,
                     m.Name,
                     m.Gender,
                     (select f.Photo_Sha
                        from Md_Persons f
                       where f.Company_Id = v_Company_Id
                         and f.Person_Id = q.Employee_Id
                         and f.Photo_Sha is not null) Photo_Sha,
                     (select s.Job_Id
                        from Mhr_Employees s
                       where s.Company_Id = v_Company_Id
                         and s.Filial_Id = v_Filial_Id
                         and s.Employee_Id = q.Employee_Id) Job_Id,
                     case
                        when k.Staff_Id is null then --
                         Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set
                        when k.Licensed = 'N' then --
                         Htt_Pref.c_Dashboard_Not_Licensed_Day -- not licensed day
                        when k.Day_Kind = Htt_Pref.c_Day_Kind_Work then
                         case
                           when v_Current_Time < k.Begin_Time and k.Input_Time is null then
                            Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                           when Nvl((select sum(t.Fact_Value)
                                      from Htt_Timesheet_Facts t
                                     where t.Company_Id = v_Company_Id
                                       and t.Filial_Id = v_Filial_Id
                                       and t.Timesheet_Id = k.Timesheet_Id
                                       and t.Time_Kind_Id member of v_Absence_Ids),
                                    -1) >= k.Plan_Time then
                            Htt_Pref.c_Dashboard_Leave_Exists -- leave time
                           when Nvl((select t.Fact_Value
                                      from Htt_Timesheet_Facts t
                                     where t.Company_Id = v_Company_Id
                                       and t.Filial_Id = v_Filial_Id
                                       and t.Timesheet_Id = k.Timesheet_Id
                                       and t.Time_Kind_Id = v_Late_Id),
                                    -1) > 0 then
                            Htt_Pref.c_Dashboard_Staff_Late -- late
                           when k.Input_Time is not null and k.Input_Time < k.End_Time --
                                or Nvl((select sum(t.Fact_Value)
                                         from Htt_Timesheet_Facts t
                                        where t.Company_Id = v_Company_Id
                                          and t.Filial_Id = v_Filial_Id
                                          and t.Timesheet_Id = k.Timesheet_Id
                                          and t.Time_Kind_Id member of v_Turnout_Ids),
                                       -1) > 0 then
                            Htt_Pref.c_Dashboard_Staff_Intime -- intime
                           when k.Count_Lack = 'N' and v_Current_Time <= k.End_Time then
                            Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                           else
                            Htt_Pref.c_Dashboard_Staff_Not_Come -- not come
                         end
                        when k.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                         Htt_Pref.c_Dashboard_Rest_Day -- rest day
                        when k.Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
                         Htt_Pref.c_Dashboard_Holiday -- holiday
                        when k.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
                         Htt_Pref.c_Dashboard_Rest_Day -- additional rest day   -- TODO temporary, need change to Htt_Pref.c_Dashboard_Additional_Rest_Day
                        when k.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
                         Htt_Pref.c_Dashboard_Nonworking_Day -- nonworking day
                        else
                         Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set
                      end Kind
                from Href_Staffs q
                join Mr_Natural_Persons m
                  on m.Company_Id = v_Company_Id
                 and m.Person_Id = q.Employee_Id
                left join (select Nvl2(Le.Employee_Id, null, k.Timesheet_Id) as Timesheet_Id,
                                 k.Staff_Id,
                                 k.Day_Kind,
                                 k.Count_Lack,
                                 k.Begin_Time,
                                 k.End_Time,
                                 Nvl2(Le.Employee_Id, null, k.Input_Time) as Input_Time,
                                 Nvl2(Le.Employee_Id, null, k.Output_Time) as Output_Time,
                                 k.Plan_Time,
                                 Nvl2(Le.Employee_Id, 'N', 'Y') as Licensed
                            from Htt_Timesheets k
                            left join Hlic_Unlicensed_Employees Le
                              on Le.Company_Id = v_Company_Id
                             and Le.Employee_Id = k.Employee_Id
                             and Le.Licensed_Date = v_Timesheet_Date
                           where k.Company_Id = v_Company_Id
                             and k.Filial_Id = v_Filial_Id
                             and k.Timesheet_Date = v_Timesheet_Date) k
                  on k.Staff_Id = q.Staff_Id
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.Hiring_Date <= v_Timesheet_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Timesheet_Date)
                 and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and q.State = 'A'
                 and q.Staff_Id member of v_Subordinates
                 and exists (select 1
                        from Mhr_Employees e
                       where e.Company_Id = Ui.Company_Id
                         and e.Filial_Id = Ui.Filial_Id
                         and e.Employee_Id = q.Employee_Id
                         and e.State = 'A'))
    loop
      v_Item := Hashmap();
      v_Item.Put('user_id', r.Employee_Id);
      v_Item.Put('name', r.Name);
      v_Item.Put('photo_sha', r.Photo_Sha);
      v_Item.Put('kind', r.Kind);
      v_Item.Put('job_name',
                 z_Mhr_Jobs.Take(i_Company_Id => v_Company_Id, --
                 i_Filial_Id => v_Filial_Id, --
                 i_Job_Id => r.Job_Id).Name);
    
      if v_With_Track = 'Y' then
        v_Item.Put('input_time', r.Input_Time);
        v_Item.Put('output_time', r.Output_Time);
      end if;
    
      Result.Push(v_Item);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Marks(p Hashmap) return Arraylist is
    v_Staff_Id       number;
    v_Timesheet_Date date := p.r_Date('timesheet_date');
    result           Matrix_Varchar2;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => v_Timesheet_Date);
  
    select Array_Varchar2(to_char(Tm.Begin_Time, Href_Pref.c_Date_Format_Second),
                          to_char(Tm.End_Time, Href_Pref.c_Date_Format_Second))
      bulk collect
      into result
      from Htt_Timesheet_Marks Tm
      join Htt_Timesheets t
        on t.Company_Id = Tm.Company_Id
       and t.Filial_Id = Tm.Filial_Id
       and t.Timesheet_Id = Tm.Timesheet_Id
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Staff_Id = v_Staff_Id
       and t.Timesheet_Date = v_Timesheet_Date
     order by Tm.Begin_Time;
  
    return Fazo.Zip_Matrix(result);
  exception
    when No_Data_Found then
      return Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Requests
  (
    p             Hashmap := Hashmap,
    i_Is_Personal boolean := false
  ) return Fazo_Query is
    v_Query     varchar2(32767);
    v_Params    Hashmap;
    v_Staff_Id  number;
    v_Staff_Ids Array_Number := Array_Number();
    v_Matrix    Matrix_Varchar2;
    q           Fazo_Query;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => Trunc(Get_Current_Date));
  
    if v_Staff_Id is null and i_Is_Personal = true then
      b.Raise_Not_Implemented;
    end if;
  
    v_Query := 'select q.*,
                       q.begin_time as request_date,
                       case q.status
                         when :status_new then 1
                         when :status_approved then 2
                         when :status_completed then 3
                         else 4
                       end as status_order,
                       case q.request_type
                         when :rt_part_of_day then 1
                         when :rt_full_day then 2
                         else 3
                       end as request_type_order,
                       w.employee_id,
                       w.division_id
                  from htt_requests q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'status_new',
                             Htt_Pref.c_Request_Status_New,
                             'status_approved',
                             Htt_Pref.c_Request_Status_Approved,
                             'status_completed',
                             Htt_Pref.c_Request_Status_Completed);
  
    v_Params.Put('rt_full_day', Htt_Pref.c_Request_Type_Full_Day);
    v_Params.Put('rt_part_of_day', Htt_Pref.c_Request_Type_Part_Of_Day);
  
    if i_Is_Personal then
      v_Query := v_Query || ' and q.staff_id = :staff_id';
      v_Params.Put('staff_id', v_Staff_Id);
    elsif v_Staff_Id is not null then
      v_Staff_Ids := Get_Subordinates(i_Direct_Employee => Nvl(p.o_Varchar2('direct_employee'), 'Y'));
    
      v_Query := v_Query || ' and q.staff_id in (select column_value from table(:staff_ids))';
      v_Params.Put('staff_ids', v_Staff_Ids);
    end if;
  
    v_Query := v_Query || --
               ' order by status_order, request_date desc, request_type_order';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('request_id',
                   'request_kind_id',
                   'staff_id',
                   'employee_id',
                   'status_order',
                   'request_type_order',
                   'created_by',
                   'modified_by',
                   'division_id');
    q.Varchar2_Field('request_type', 'manager_note', 'note', 'accrual_kind', 'status', 'barcode');
    q.Date_Field('begin_time', 'end_time', 'created_on', 'modified_on', 'request_date');
  
    q.Refer_Field('request_kind_name',
                  'request_kind_id',
                  'htt_request_kinds',
                  'request_kind_id',
                  'name',
                  'select *
                     from htt_request_kinds
                    where company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    v_Matrix := Htt_Util.Request_Types;
    q.Option_Field('request_type_name', 'request_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Accrual_Kinds;
    q.Option_Field('accrual_kind_name', 'accrual_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Request_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('request_time',
                'htt_util.request_time(i_request_type => $request_type,
                                       i_begin_time   => $begin_time,
                                       i_end_time     => $end_time)');
    q.Map_Field('staff_photo_sha',
                'select photo_sha
                   from md_persons
                  where person_id = $employee_id');
  
    q.Map_Field('staff_name',
                'select p.name
                   from mr_natural_persons p
                  where p.company_id = $company_id
                    and p.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Requests return Fazo_Query is
  begin
    return Query_Requests(i_Is_Personal => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests return Fazo_Query is
  begin
    return Query_Requests;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests_By_Param(p Hashmap) return Fazo_Query is
  begin
    return Query_Requests(p => p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Notifications return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            hes_util.get_notification_uri_key(q.uri) uri_key 
                       from ms_notifications q 
                      where q.company_id = :company_id 
                        and q.person_id = :user_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'user_id', Ui.User_Id));
  
    q.Number_Field('notification_id');
    q.Varchar2_Field('notification_kind',
                     'viewed',
                     'title',
                     'note',
                     'uri_key',
                     'uri_param',
                     'source_code');
    q.Date_Field('created_on');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Reset(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := p.r_Array_Number('request_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Request_Reset);
  
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Reset(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Request_Id => v_Request_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap) is
    r_Request      Htt_Requests%rowtype;
    v_Request_Ids  Array_Number := p.r_Array_Number('request_id');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Request_Approve);
  
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Approve(i_Company_Id   => Ui.Company_Id,
                              i_Filial_Id    => Ui.Filial_Id,
                              i_Request_Id   => v_Request_Ids(i),
                              i_Manager_Note => v_Manager_Note,
                              i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := p.r_Array_Number('request_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Request_Complete);
  
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Complete(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Request_Id => v_Request_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap) is
    r_Request      Htt_Requests%rowtype;
    v_Request_Ids  Array_Number := p.r_Array_Number('request_id');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Request_Deny);
  
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Deny(i_Company_Id   => Ui.Company_Id,
                           i_Filial_Id    => Ui.Filial_Id,
                           i_Request_Id   => v_Request_Ids(i),
                           i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := p.r_Array_Number('request_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Request_Delete);
  
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id, i_Undirect => false);
    
      Htt_Api.Request_Delete(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Request_Id => v_Request_Ids(i));
    
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Model(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    r_Request          Htt_Requests%rowtype;
    v_Item             Hashmap;
    v_Items            Arraylist;
    v_Data             Hashmap;
    v_Date             date;
    v_Staff_Id         number;
    v_Note_Is_Required varchar2(1) := Href_Util.Request_Note_Is_Required(Ui.Company_Id);
    result             Hashmap := Hashmap();
  begin
    if z_Htt_Requests.Exist(i_Company_Id => v_Company_Id,
                            i_Filial_Id  => v_Filial_Id,
                            i_Request_Id => p.o_Number('request_id'),
                            o_Row        => r_Request) then
      v_Data := z_Htt_Requests.To_Map(r_Request,
                                      z.Staff_Id,
                                      z.Request_Kind_Id,
                                      z.Request_Type,
                                      z.Begin_Time,
                                      z.End_Time,
                                      z.Manager_Note,
                                      z.Note,
                                      z.Accrual_Kind,
                                      z.Status,
                                      z.Created_By,
                                      z.Created_On);
    
      v_Data.Put('request_kind_name',
                 z_Htt_Request_Kinds.Load(i_Company_Id => r_Request.Company_Id, --
                 i_Request_Kind_Id => r_Request.Request_Kind_Id).Name);
      v_Data.Put('staff_name',
                 Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                      i_Filial_Id  => r_Request.Filial_Id,
                                      i_Staff_Id   => r_Request.Staff_Id));
      v_Data.Put('status_name', Htt_Util.t_Request_Status(r_Request.Status));
    
      Result.Put('data', v_Data);
    end if;
  
    v_Date     := Trunc(Get_Current_Date);
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                 i_Filial_Id   => v_Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => v_Date);
  
    -- request kinds
    v_Items := Arraylist();
  
    for r in (select *
                from Htt_Request_Kinds q
               where q.Company_Id = v_Company_Id
                 and q.User_Permitted = 'Y'
                 and q.State = 'A'
                 and ((select count(*)
                         from Htt_Staff_Request_Kinds w
                        where w.Company_Id = v_Company_Id
                          and w.Filial_Id = v_Filial_Id
                          and w.Request_Kind_Id = q.Request_Kind_Id
                          and exists (select 1
                                 from Href_Staffs s
                                where s.Company_Id = v_Company_Id
                                  and s.Filial_Id = v_Filial_Id
                                  and s.Staff_Id = w.Staff_Id
                                  and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                                  and s.State = 'A'
                                  and s.Hiring_Date <= v_Date
                                  and Nvl(s.Dismissal_Date, v_Date) >= v_Date)) = 0 or exists
                      (select 1
                         from Htt_Staff_Request_Kinds w
                        where w.Company_Id = v_Company_Id
                          and w.Filial_Id = v_Filial_Id
                          and w.Staff_Id = v_Staff_Id
                          and w.Request_Kind_Id = q.Request_Kind_Id))
               order by q.Name)
    loop
      v_Item := z_Htt_Request_Kinds.To_Map(r, --
                                           z.Request_Kind_Id,
                                           z.Name,
                                           z.Annually_Limited);
      v_Item.Put('plan_load',
                 z_Htt_Time_Kinds.Load(i_Company_Id => r.Company_Id, i_Time_Kind_Id => r.Time_Kind_Id).Plan_Load);
    
      v_Items.Push(v_Item);
    end loop;
  
    Result.Put('request_kinds', v_Items);
    Result.Put('note_is_required', v_Note_Is_Required);
    Result.Put('accrual_kinds', Fazo.Zip_Matrix_Transposed(Htt_Util.Accrual_Kinds));
    Result.Put('enable_request',
               Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_User_Id => Ui.User_Id).Enable_Request);
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Request_Note_Limit(v_Company_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Save(p Hashmap) is
    v_Begin_Time date;
    v_End_Time   date;
    r_Request    Htt_Requests%rowtype;
  begin
    if Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id, --
     i_Filial_Id => Ui.Filial_Id, --
     i_User_Id => Ui.User_Id).Enable_Request = 'N' then
      Hes_Error.Raise_009;
    end if;
  
    if not z_Htt_Requests.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Request_Id => p.o_Number('request_id'),
                                     o_Row        => r_Request) then
      r_Request.Company_Id := Ui.Company_Id;
      r_Request.Filial_Id  := Ui.Filial_Id;
      r_Request.Request_Id := Htt_Next.Request_Id;
      r_Request.Staff_Id   := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                             i_Filial_Id   => Ui.Filial_Id,
                                                             i_Employee_Id => Ui.User_Id,
                                                             i_Date        => Trunc(Get_Current_Date));
    end if;
  
    z_Htt_Requests.To_Row(r_Request, p, z.Request_Kind_Id, z.Request_Type, z.Note, z.Accrual_Kind);
  
    case p.r_Varchar2('request_type')
      when Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Begin_Time := to_date(p.r_Varchar2('begin_time'), Href_Pref.c_Date_Format_Second);
        v_End_Time   := to_date(p.r_Varchar2('end_time'), Href_Pref.c_Date_Format_Second);
      
        if v_End_Time < v_Begin_Time then
          v_End_Time := v_End_Time + 1;
        end if;
      when Htt_Pref.c_Request_Type_Full_Day then
        v_Begin_Time := Trunc(p.r_Date('begin_time'));
        v_End_Time   := v_Begin_Time;
      else
        v_Begin_Time := Trunc(p.r_Date('begin_time'));
        v_End_Time   := Trunc(p.r_Date('end_time'));
    end case;
  
    r_Request.Company_Id := Ui.Company_Id;
    r_Request.Filial_Id  := Ui.Filial_Id;
    r_Request.Request_Id := r_Request.Request_Id;
    r_Request.Begin_Time := v_Begin_Time;
    r_Request.End_Time   := v_End_Time;
  
    Htt_Api.Request_Save(r_Request);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits(p Hashmap) return Arraylist is
  begin
    return Uit_Htt.Load_Request_Limits(i_Staff_Id        => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                                                           i_Filial_Id   => Ui.Filial_Id,
                                                                                           i_Employee_Id => Ui.User_Id,
                                                                                           i_Date        => Trunc(Get_Current_Date)),
                                       i_Request_Kind_Id => p.r_Number('request_kind_id'),
                                       i_Period_Begin    => p.r_Date('begin_date'),
                                       i_Period_End      => p.r_Date('end_date'),
                                       i_Request_Id      => p.o_Number('request_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Changes
  (
    p             Hashmap := Hashmap(),
    i_Is_Personal boolean := false
  ) return Fazo_Query is
    v_Query     varchar2(32767);
    v_Params    Hashmap;
    v_Staff_Id  number;
    v_Staff_Ids Array_Number := Array_Number();
    v_Matrix    Matrix_Varchar2;
    q           Fazo_Query;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => Trunc(Get_Current_Date));
  
    if v_Staff_Id is null and i_Is_Personal = true then
      b.Raise_Not_Implemented;
    end if;
  
    v_Query := 'select q.*,
                       (select /*+ INDEX(d HTT_CHANGE_DAYS_I3)*/
                               min(d.change_date)
                          from htt_change_days d
                         where d.company_id = q.company_id
                           and d.filial_id = q.filial_id
                           and d.change_id = q.change_id) as change_date,
                       case q.status
                         when :status_new then 1
                         when :status_approved then 2
                         when :status_completed then 3
                         else 4
                       end as status_order,
                       case q.change_kind
                         when :change_plan then 1
                         else 2
                       end as change_kind_order,
                       w.employee_id,
                       w.division_id
                  from htt_plan_changes q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'status_new',
                             Htt_Pref.c_Request_Status_New,
                             'status_approved',
                             Htt_Pref.c_Request_Status_Approved,
                             'status_completed',
                             Htt_Pref.c_Request_Status_Completed,
                             'change_plan',
                             Htt_Pref.c_Change_Kind_Change_Plan);
  
    v_Params.Put('nls_language', Htt_Util.Get_Nls_Language);
  
    if i_Is_Personal then
      v_Query := v_Query || ' and q.staff_id = :staff_id';
      v_Params.Put('staff_id', v_Staff_Id);
    elsif v_Staff_Id is not null then
      v_Staff_Ids := Get_Subordinates(i_Direct_Employee => Nvl(p.o_Varchar2('direct_employee'), 'Y'));
    
      v_Query := v_Query || ' and q.staff_id in (select column_value from table(:staff_ids))';
      v_Params.Put('staff_ids', v_Staff_Ids);
    end if;
  
    v_Query := v_Query || --
               ' order by status_order, change_date desc, change_kind_order';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('change_id',
                   'staff_id',
                   'employee_id',
                   'division_id',
                   'status_order',
                   'change_kind_order',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('change_kind', 'manager_note', 'note', 'status');
    q.Date_Field('created_on', 'modified_on', 'change_date');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    v_Matrix := Htt_Util.Change_Kinds;
    q.Option_Field('change_kind_name', 'change_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Change_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('change_dates',
                'select  /*+ INDEX(q HTT_CHANGE_DAYS_I3)*/ listagg(to_char(q.change_date, ''fmdd mon. yyyy'', :nls_language), '', '') ' || --
                '       within group(order by q.change_date) ' || --
                '  from htt_change_days q ' || --
                ' where q.company_id = $company_id ' || --
                '   and q.filial_id = $filial_id ' || --
                '   and q.change_id = $change_id');
  
    q.Map_Field('staff_photo_sha',
                'select p.photo_sha
                   from md_persons p
                  where p.company_id = $company_id
                    and p.person_id = $employee_id');
  
    q.Map_Field('staff_name',
                'select p.name
                   from mr_natural_persons p
                  where p.company_id = $company_id
                    and p.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Changes return Fazo_Query is
  begin
    return Query_Changes(i_Is_Personal => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes return Fazo_Query is
  begin
    return Query_Changes;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes_By_Param(p Hashmap) return Fazo_Query is
  begin
    return Query_Changes(p => p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := p.r_Array_Number('change_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Change_Reset);
  
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Reset(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Change_Id  => v_Change_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap) is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Ids   Array_Number := p.r_Array_Number('change_id');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Change_Approve);
  
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Approve(i_Company_Id   => Ui.Company_Id,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_Change_Id    => v_Change_Ids(i),
                             i_Manager_Note => v_Manager_Note,
                             i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := p.r_Array_Number('change_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Change_Complete);
  
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Complete(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Change_Id  => v_Change_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap) is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Ids   Array_Number := p.r_Array_Number('change_id');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Change_Deny);
  
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Deny(i_Company_Id   => Ui.Company_Id,
                          i_Filial_Id    => Ui.Filial_Id,
                          i_Change_Id    => v_Change_Ids(i),
                          i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := p.r_Array_Number('change_id');
  begin
    Ui.Grant_Check(Uit_Hes.c_Action_Key_Change_Delete);
  
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id, i_Undirect => false);
    
      Htt_Api.Change_Delete(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Change_Id  => v_Change_Ids(i));
    
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Model(p Hashmap) return Hashmap is
    r_Change                      Htt_Plan_Changes%rowtype;
    v_Days                        Htt_Pref.Change_Day_Nt;
    v_Day                         Htt_Pref.Change_Day_Rt;
    v_Change_Days                 Arraylist := Arraylist();
    v_Change_Day                  Hashmap;
    v_Data                        Hashmap;
    v_Is_Personal_Change          varchar2(1) := 'Y';
    v_Change_Save_For_Subordinate varchar2(1) := 'N';
    v_Note_Is_Required            varchar2(1) := Href_Util.Plan_Change_Note_Is_Required(Ui.Company_Id);
    result                        Hashmap := Hashmap();
  begin
    if z_Htt_Plan_Changes.Exist(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Change_Id  => p.o_Number('change_id'),
                                o_Row        => r_Change) then
      v_Data := z_Htt_Plan_Changes.To_Map(r_Change, --
                                          z.Staff_Id,
                                          z.Change_Kind,
                                          z.Note,
                                          z.Status,
                                          z.Created_By,
                                          z.Created_On);
    
      if Href_Util.Get_Employee_Id(i_Company_Id => r_Change.Company_Id,
                                   i_Filial_Id  => r_Change.Filial_Id,
                                   i_Staff_Id   => r_Change.Staff_Id) <> Ui.User_Id then
        v_Is_Personal_Change := 'N';
      end if;
    
      v_Data.Put('is_personal_change', v_Is_Personal_Change);
    
      v_Data.Put('staff_name',
                 Href_Util.Staff_Name(i_Company_Id => r_Change.Company_Id,
                                      i_Filial_Id  => r_Change.Filial_Id,
                                      i_Staff_Id   => r_Change.Staff_Id));
      v_Data.Put('change_kind_name', Htt_Util.t_Change_Kind(r_Change.Change_Kind));
      v_Data.Put('status_name', Htt_Util.t_Change_Status(r_Change.Status));
    
      select Cd.Change_Date,
             Cd.Swapped_Date,
             Cd.Day_Kind,
             Cd.Begin_Time,
             Cd.End_Time,
             Cd.Break_Enabled,
             Cd.Break_Begin_Time,
             Cd.Break_End_Time,
             Round(Cd.Plan_Time / 60, 2)
        bulk collect
        into v_Days
        from Htt_Change_Days Cd
       where Cd.Company_Id = r_Change.Company_Id
         and Cd.Filial_Id = r_Change.Filial_Id
         and Cd.Change_Id = r_Change.Change_Id;
    
      for i in 1 .. v_Days.Count
      loop
        v_Day := v_Days(i);
      
        v_Change_Day := Fazo.Zip_Map('change_date',
                                     v_Day.Change_Date,
                                     'swapped_date',
                                     v_Day.Swapped_Date,
                                     'day_kind',
                                     v_Day.Day_Kind,
                                     'break_enabled',
                                     v_Day.Break_Enabled,
                                     'plan_time',
                                     v_Day.Plan_Time);
      
        v_Change_Day.Put('begin_time', to_char(v_Day.Begin_Time, Href_Pref.c_Date_Format_Minute));
        v_Change_Day.Put('end_time', to_char(v_Day.End_Time, Href_Pref.c_Date_Format_Minute));
        v_Change_Day.Put('break_begin_time',
                         to_char(v_Day.Break_Begin_Time, Href_Pref.c_Date_Format_Minute));
        v_Change_Day.Put('break_end_time',
                         to_char(v_Day.Break_End_Time, Href_Pref.c_Date_Format_Minute));
      
        v_Change_Days.Push(v_Change_Day);
      end loop;
    
      v_Data.Put('change_days', v_Change_Days);
    
      Result.Put('data', v_Data);
    end if;
  
    if Ui.Grant_Has(Uit_Hes.c_Change_Save_For_Subordinate) then
      v_Change_Save_For_Subordinate := 'Y';
    end if;
  
    Result.Put('has_change_access', v_Change_Save_For_Subordinate);
  
    Result.Put('note_is_required', v_Note_Is_Required);
    Result.Put('enable_schedule_change',
               Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_User_Id => Ui.User_Id).Enable_Schedule_Change);
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Plan_Change_Note_Limit(Ui.Company_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Save(p Arraylist) is
    v_Item        Hashmap;
    r_Change      Htt_Plan_Changes%rowtype;
    v_Change_Days Arraylist;
    v_Change_Day  Hashmap;
    v_Employee_Id number;
    v_Change      Htt_Pref.Change_Rt;
    v_Changed_Day Htt_Pref.Change_Day_Rt;
  
    --------------------------------------------------
    Procedure Prepare_Change_Day(p_Change_Date in out nocopy Htt_Pref.Change_Day_Rt) is
    begin
      if p_Change_Date.Day_Kind in (Htt_Pref.c_Day_Kind_Rest,
                                    Htt_Pref.c_Day_Kind_Holiday,
                                    Htt_Pref.c_Day_Kind_Additional_Rest) or
         p_Change_Date.Day_Kind is null then
        p_Change_Date.Begin_Time       := null;
        p_Change_Date.End_Time         := null;
        p_Change_Date.Break_Enabled    := null;
        p_Change_Date.Break_Begin_Time := null;
        p_Change_Date.Break_End_Time   := null;
        p_Change_Date.Plan_Time        := null;
      
        if p_Change_Date.Day_Kind is not null then
          p_Change_Date.Plan_Time := 0;
        end if;
      else
        p_Change_Date.Break_Enabled := Nvl(p_Change_Date.Break_Enabled, 'N');
      
        if p_Change_Date.End_Time <= p_Change_Date.Begin_Time then
          p_Change_Date.End_Time := p_Change_Date.End_Time + 1;
        end if;
      
        if p_Change_Date.Break_Enabled = 'Y' then
          if p_Change_Date.Break_Begin_Time <= p_Change_Date.Begin_Time then
            p_Change_Date.Break_Begin_Time := p_Change_Date.Break_Begin_Time + 1;
          end if;
        
          if p_Change_Date.Break_End_Time <= p_Change_Date.Break_Begin_Time then
            p_Change_Date.Break_End_Time := p_Change_Date.Break_End_Time + 1;
          end if;
        else
          p_Change_Date.Break_Begin_Time := null;
          p_Change_Date.Break_End_Time   := null;
        end if;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Swap_Days
    (
      p_Change       in out nocopy Htt_Pref.Change_Rt,
      i_Changed_Date date,
      i_Swapped_Date date
    ) is
      v_Days Htt_Pref.Change_Day_Nt;
    
      v_Day           Htt_Pref.Change_Day_Rt;
      v_Changed_Day   Htt_Pref.Change_Day_Rt := Htt_Pref.Change_Day_Rt();
      v_Swapped_Day   Htt_Pref.Change_Day_Rt := Htt_Pref.Change_Day_Rt();
      v_Swap_Distance number;
    begin
      select t.Timesheet_Date,
             null,
             t.Day_Kind,
             t.Begin_Time,
             t.End_Time,
             t.Break_Enabled,
             t.Break_Begin_Time,
             t.Break_End_Time,
             t.Plan_Time
        bulk collect
        into v_Days
        from Htt_Timesheets t
       where t.Company_Id = p_Change.Company_Id
         and t.Filial_Id = p_Change.Filial_Id
         and t.Staff_Id = p_Change.Staff_Id
         and t.Timesheet_Date in (i_Changed_Date, i_Swapped_Date);
    
      if v_Days.Count = 2 then
        v_Changed_Day := v_Days(1);
        v_Swapped_Day := v_Days(2);
      else
        v_Changed_Day.Change_Date := i_Changed_Date;
        v_Swapped_Day.Change_Date := i_Swapped_Date;
      
        if v_Days.Count = 1 then
          if v_Changed_Day.Change_Date = v_Days(1).Change_Date then
            v_Changed_Day := v_Days(1);
          else
            v_Swapped_Day := v_Days(1);
          end if;
        end if;
      end if;
    
      v_Swap_Distance := v_Swapped_Day.Change_Date - v_Changed_Day.Change_Date;
    
      v_Day := v_Swapped_Day;
    
      v_Swapped_Day                  := v_Changed_Day;
      v_Swapped_Day.Change_Date      := v_Day.Change_Date;
      v_Swapped_Day.Swapped_Date     := v_Changed_Day.Change_Date;
      v_Swapped_Day.Begin_Time       := v_Swapped_Day.Begin_Time + v_Swap_Distance;
      v_Swapped_Day.End_Time         := v_Swapped_Day.End_Time + v_Swap_Distance;
      v_Swapped_Day.Break_Begin_Time := v_Swapped_Day.Break_Begin_Time + v_Swap_Distance;
      v_Swapped_Day.Break_End_Time   := v_Swapped_Day.Break_End_Time + v_Swap_Distance;
    
      v_Changed_Day                  := v_Day;
      v_Changed_Day.Change_Date      := v_Swapped_Day.Swapped_Date;
      v_Changed_Day.Swapped_Date     := v_Swapped_Day.Change_Date;
      v_Changed_Day.Begin_Time       := v_Changed_Day.Begin_Time - v_Swap_Distance;
      v_Changed_Day.End_Time         := v_Changed_Day.End_Time - v_Swap_Distance;
      v_Changed_Day.Break_Begin_Time := v_Changed_Day.Break_Begin_Time - v_Swap_Distance;
      v_Changed_Day.Break_End_Time   := v_Changed_Day.Break_End_Time - v_Swap_Distance;
    
      p_Change.Change_Days := Htt_Pref.Change_Day_Nt(v_Changed_Day, v_Swapped_Day);
    end;
  begin
    for i in 1 .. p.Count
    loop
      v_Item        := Treat(p.r_Hashmap(i) as Hashmap);
      v_Change_Days := v_Item.r_Arraylist('change_days');
    
      v_Employee_Id := v_Item.o_Number('employee_id');
    
      if v_Employee_Id is not null then
        Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id, i_Undirect => false);
      else
        v_Employee_Id := Ui.User_Id;
      
        if Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id, --
         i_Filial_Id => Ui.Filial_Id, --
         i_User_Id => v_Employee_Id).Enable_Schedule_Change = 'N' then
          Hes_Error.Raise_010;
        end if;
      end if;
    
      if not z_Htt_Plan_Changes.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Change_Id  => v_Item.o_Number('change_id'),
                                           o_Row        => r_Change) then
        r_Change.Company_Id := Ui.Company_Id;
        r_Change.Filial_Id  := Ui.Filial_Id;
        r_Change.Change_Id  := Htt_Next.Change_Id;
        r_Change.Staff_Id   := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                              i_Filial_Id   => Ui.Filial_Id,
                                                              i_Employee_Id => v_Employee_Id,
                                                              i_Date        => Trunc(Get_Current_Date));
      end if;
    
      z_Htt_Plan_Changes.To_Row(r_Change, v_Item, z.Change_Kind, z.Note);
    
      Htt_Util.Change_New(o_Change      => v_Change,
                          i_Company_Id  => r_Change.Company_Id,
                          i_Filial_Id   => r_Change.Filial_Id,
                          i_Change_Id   => r_Change.Change_Id,
                          i_Staff_Id    => r_Change.Staff_Id,
                          i_Change_Kind => r_Change.Change_Kind,
                          i_Note        => r_Change.Note);
    
      for i in 1 .. v_Change_Days.Count
      loop
        v_Change_Day := Treat(v_Change_Days.r_Hashmap(i) as Hashmap);
      
        v_Changed_Day.Day_Kind         := v_Change_Day.o_Varchar2('day_kind');
        v_Changed_Day.Begin_Time       := v_Change_Day.o_Date('begin_time');
        v_Changed_Day.End_Time         := v_Change_Day.o_Date('end_time');
        v_Changed_Day.Break_Enabled    := v_Change_Day.o_Varchar2('break_enabled');
        v_Changed_Day.Break_Begin_Time := v_Change_Day.o_Date('break_begin_time');
        v_Changed_Day.Break_End_Time   := v_Change_Day.o_Date('break_end_time');
        v_Changed_Day.Plan_Time        := v_Change_Day.o_Number('plan_time');
      
        -- temporary solution
        -- TODO: remove after mobile fixed plan_time
        Prepare_Change_Day(v_Changed_Day);
      
        if v_Change.Change_Kind = Htt_Pref.c_Change_Kind_Change_Plan and
           v_Changed_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work and v_Changed_Day.Plan_Time = 0 then
          v_Changed_Day.Plan_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => v_Changed_Day.Day_Kind,
                                                             i_Begin_Time       => v_Changed_Day.Begin_Time,
                                                             i_End_Time         => v_Changed_Day.End_Time,
                                                             i_Break_Begin_Time => v_Changed_Day.Break_Begin_Time,
                                                             i_Break_End_Time   => v_Changed_Day.Break_End_Time);
        end if;
      
        Htt_Util.Change_Day_Add(o_Change           => v_Change,
                                i_Change_Date      => v_Change_Day.r_Date('change_date'),
                                i_Swapped_Date     => v_Change_Day.o_Date('swapped_date'),
                                i_Begin_Time       => v_Changed_Day.Begin_Time,
                                i_End_Time         => v_Changed_Day.End_Time,
                                i_Day_Kind         => v_Changed_Day.Day_Kind,
                                i_Break_Enabled    => v_Changed_Day.Break_Enabled,
                                i_Break_Begin_Time => v_Changed_Day.Break_Begin_Time,
                                i_Break_End_Time   => v_Changed_Day.Break_End_Time,
                                i_Plan_Time        => v_Changed_Day.Plan_Time * 60);
      
      end loop;
    
      if v_Change.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
        Swap_Days(v_Change,
                  v_Change.Change_Days(1).Change_Date,
                  v_Change.Change_Days(2).Change_Date);
      end if;
    
      Htt_Api.Change_Save(v_Change);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Parts
  (
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  ) return Arraylist is
    v_Part Hashmap;
    result Arraylist := Arraylist();
  begin
    for r in (select t.Part_Id,
                     t.Amount,
                     to_char(t.Part_Date, Href_Pref.c_Date_Format_Second) as Part_Date,
                     (select c.Name
                        from Md_Users c
                       where c.Company_Id = t.Company_Id
                         and c.User_Id = t.Created_By) as Created_Name,
                     t.Note,
                     t.Created_By
                from Hper_Staff_Plan_Parts t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.Staff_Plan_Id = i_Staff_Plan_Id
                 and t.Plan_Type_Id = i_Plan_Type_Id
               order by t.Part_Date desc)
    loop
      v_Part := Hashmap();
      v_Part.Put('part_id', r.Part_Id);
      v_Part.Put('amount', r.Amount);
      v_Part.Put('part_date', r.Part_Date);
      v_Part.Put('created_by', r.Created_By);
      v_Part.Put('created_name', r.Created_Name);
      v_Part.Put('note', r.Note);
      Result.Push(v_Part);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Tasks
  (
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  ) return Arraylist is
    v_Finished_Status number := Ms_Pref.Task_Status_Id(i_Company_Id => Ui.Company_Id,
                                                       i_Pcode      => Ms_Pref.c_Pc_Status_Finished);
    v_Task            Hashmap;
    result            Arraylist := Arraylist();
  begin
    for r in (select q.Task_Id,
                     q.Title,
                     to_char(q.Begin_Time, Href_Pref.c_Date_Format_Minute) as Begin_Time,
                     to_char(q.End_Time, Href_Pref.c_Date_Format_Minute) as End_Time,
                     q.Grade,
                     (select 'Y'
                        from Hper_Staff_Plan_Tasks t
                       where t.Company_Id = q.Company_Id
                         and t.Filial_Id = Ui.Filial_Id
                         and t.Staff_Plan_Id = i_Staff_Plan_Id
                         and t.Plan_Type_Id = i_Plan_Type_Id
                         and t.Task_Id = q.Task_Id) as Added_To_Plan
                from Ms_Tasks q
               where q.Company_Id = Ui.Company_Id
                 and q.Task_Id in
                     (select Column_Value
                        from table(Hper_Util.Plan_Tasks(i_Company_Id    => q.Company_Id,
                                                        i_Filial_Id     => Ui.Filial_Id,
                                                        i_Staff_Plan_Id => i_Staff_Plan_Id,
                                                        i_Plan_Type_Id  => i_Plan_Type_Id)))
                 and q.Status_Id = v_Finished_Status)
    loop
      v_Task := Hashmap();
      v_Task.Put('task_id', r.Task_Id);
      v_Task.Put('title', r.Title);
      v_Task.Put('begin_time', r.Begin_Time);
      v_Task.Put('end_time', r.End_Time);
      v_Task.Put('grade', r.Grade);
      v_Task.Put('added_to_plan', Nvl(r.Added_To_Plan, 'N'));
      Result.Push(v_Task);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Dashboard_Plans(p Hashmap) return Hashmap is
    v_Direct_Employee varchar2(1) := 'N';
    v_Current_Date    date := Trunc(Get_Current_Date);
    v_Plan_Date       date := Trunc(Get_Current_Date, 'MONTH'); --TODO optimizatsiya qilish kerak, turli filiallarda turlicha date qaytarishi mumkin
    v_Plan_Status     Array_Varchar2 := Array_Varchar2(Hper_Pref.c_Staff_Plan_Status_New,
                                                       Hper_Pref.c_Staff_Plan_Status_Waiting,
                                                       Hper_Pref.c_Staff_Plan_Status_Completed);
    v_Staff_Id        number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                               i_Filial_Id   => Ui.Filial_Id,
                                                               i_Employee_Id => Ui.User_Id,
                                                               i_Date        => v_Current_Date);
    v_Staff_Ids       Array_Number := Array_Number();
    v_Subordinates    Array_Number;
    v_Plan_Avg        number(20, 6);
    v_Round_Model     Round_Model := Round_Model(Md_Pref.Round_Model(Ui.Company_Id));
    result            Hashmap := Hashmap();
  
    -----------------------------------------------
    Function Has_Employee_Plan return boolean is
      v_Plan_Count number;
    begin
      select count(1)
        into v_Plan_Count
        from Hper_Staff_Plans q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and Months_Between(v_Plan_Date, q.Plan_Date) between 0 and 12
         and q.Status member of v_Plan_Status
         and exists (select 1
                from table(v_Staff_Ids) k
               where k.Column_Value = q.Staff_Id);
      return v_Plan_Count > 0;
    end;
  
    -----------------------------------------------
    Function Has_Plan(i_Plan_Type varchar2) return boolean is
      v_Plan_Count number;
    begin
      select count(1)
        into v_Plan_Count
        from Hper_Staff_Plans q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Staff_Id = v_Staff_Id
         and Months_Between(v_Plan_Date, q.Plan_Date) between 0 and 12
         and q.Status member of v_Plan_Status
         and exists (select 1
                from Hper_Staff_Plan_Items k
               where k.Company_Id = q.Company_Id
                 and k.Filial_Id = q.Filial_Id
                 and k.Staff_Plan_Id = q.Staff_Plan_Id
                 and k.Plan_Type = i_Plan_Type);
      return v_Plan_Count > 0;
    end;
  
  begin
    if p is not null and p.Has('direct_employee') then
      v_Direct_Employee := p.r_Varchar2('direct_employee');
    end if;
  
    v_Subordinates := Get_Subordinates(i_Direct_Employee => v_Direct_Employee);
  
    Fazo.Push(v_Staff_Ids, Ui.User_Id);
  
    select s.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Hiring_Date <= v_Current_Date
       and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Current_Date)
       and s.State = 'A'
       and s.Staff_Id member of v_Subordinates;
  
    if v_Staff_Ids.Count > 0 and Has_Employee_Plan then
      select avg(Fact_Percent)
        into v_Plan_Avg
        from (select sum(Nvl(q.c_Main_Fact_Percent, 0)) Fact_Percent
                from Hper_Staff_Plans q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Plan_Date = v_Plan_Date
                 and q.Status member of v_Plan_Status
                 and exists (select 1
                        from table(v_Staff_Ids) k
                       where k.Column_Value = q.Staff_Id)
               group by q.Staff_Id);
    
      Result.Put('staff_plan_avg', v_Round_Model.Eval(Nvl(v_Plan_Avg, 0)));
    end if;
  
    if Has_Plan(Hper_Pref.c_Plan_Type_Main) then
      select sum(Nvl(q.c_Main_Fact_Percent, 0))
        into v_Plan_Avg
        from Hper_Staff_Plans q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Staff_Id = v_Staff_Id
         and q.Plan_Date = v_Plan_Date
         and q.Status member of v_Plan_Status
         and exists (select 1
                from Hper_Staff_Plan_Items k
               where k.Company_Id = q.Company_Id
                 and k.Filial_Id = q.Filial_Id
                 and k.Staff_Plan_Id = q.Staff_Plan_Id
                 and k.Plan_Type = Hper_Pref.c_Plan_Type_Main);
    
      Result.Put('own_plan_avg', v_Round_Model.Eval(Nvl(v_Plan_Avg, 0)));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Plans(p Hashmap) return Arraylist is
    v_Direct_Employee varchar2(1) := 'N';
    v_Current_Date    date := Trunc(Get_Current_Date);
    v_Plan_Date       date := Nvl(p.o_Date('month'), Trunc(Get_Current_Date, 'month'));
    v_Plan_Status     Array_Varchar2 := Array_Varchar2(Hper_Pref.c_Staff_Plan_Status_New,
                                                       Hper_Pref.c_Staff_Plan_Status_Waiting,
                                                       Hper_Pref.c_Staff_Plan_Status_Completed);
    v_Item            Hashmap;
    v_Subordinates    Array_Number;
    result            Arraylist := Arraylist();
  begin
    if p is not null and p.Has('direct_employee') then
      v_Direct_Employee := p.r_Varchar2('direct_employee');
    end if;
  
    v_Subordinates := Get_Subordinates(i_Direct_Employee => v_Direct_Employee);
  
    for r in (select q.Employee_Id,
                     m.Name,
                     (select s.Job_Id
                        from Mhr_Employees s
                       where s.Company_Id = q.Company_Id
                         and s.Filial_Id = q.Filial_Id
                         and s.Employee_Id = q.Employee_Id) Job_Id,
                     (select sum(k.c_Main_Fact_Percent)
                        from Hper_Staff_Plans k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Staff_Id = q.Staff_Id
                         and k.Plan_Date = v_Plan_Date
                         and k.Status member of v_Plan_Status) as Fact_Percent
                from Href_Staffs q
                join Mr_Natural_Persons m
                  on m.Company_Id = q.Company_Id
                 and m.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Hiring_Date <= v_Current_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Current_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Hper_Staff_Plans k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Staff_Id = q.Staff_Id
                         and k.Plan_Date = v_Plan_Date
                         and k.Status member of v_Plan_Status)
                 and q.Staff_Id member of v_Subordinates
               order by m.Name)
    loop
      v_Item := Hashmap();
      v_Item.Put('user_id', r.Employee_Id);
      v_Item.Put('name', r.Name);
      v_Item.Put('photo_sha',
                 z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r.Employee_Id).Photo_Sha);
      v_Item.Put('job_name',
                 z_Mhr_Jobs.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r.Job_Id).Name);
      v_Item.Put('fact_percent', Nvl(r.Fact_Percent, 0));
    
      Result.Push(v_Item);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Info(p Hashmap) return Arraylist is
    v_Staff_Id    number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                           i_Filial_Id   => Ui.Filial_Id,
                                                           i_Employee_Id => p.r_Varchar2('person_id'),
                                                           i_Date        => Trunc(Get_Current_Date));
    v_Month       date := Nvl(p.o_Date('month'), Trunc(Get_Current_Date, 'month'));
    v_Plan_Status Array_Varchar2 := Array_Varchar2(Hper_Pref.c_Staff_Plan_Status_New,
                                                   Hper_Pref.c_Staff_Plan_Status_Waiting,
                                                   Hper_Pref.c_Staff_Plan_Status_Completed);
    v_Plan        Hashmap;
    result        Arraylist := Arraylist();
  begin
    for r in (select g.Staff_Plan_Id,
                     Hper_Util.t_Plan_Calc_Type(k.Main_Calc_Type) as Main_Calc_Type,
                     Hper_Util.t_Plan_Calc_Type(k.Extra_Calc_Type) as Extra_Calc_Type,
                     g.Plan_Type_Id,
                     d.Name as Plan_Type_Name,
                     g.Plan_Type,
                     g.Calc_Kind,
                     Hper_Util.t_Calc_Kind(g.Calc_Kind) as Calc_Kind_Name,
                     (select f.Name
                        from Hper_Plan_Groups f
                       where f.Company_Id = g.Company_Id
                         and f.Filial_Id = g.Filial_Id
                         and f.Plan_Group_Id = d.Plan_Group_Id) as Group_Name,
                     g.Plan_Value,
                     g.Plan_Amount,
                     g.Fact_Value,
                     g.Fact_Percent,
                     g.Fact_Note,
                     d.With_Part,
                     k.c_Main_Fact_Percent,
                     k.c_Extra_Fact_Percent,
                     k.Status
                from Hper_Staff_Plan_Items g
                join Hper_Staff_Plans k
                  on k.Company_Id = g.Company_Id
                 and k.Filial_Id = g.Filial_Id
                 and k.Staff_Plan_Id = g.Staff_Plan_Id
                join Hper_Plan_Types d
                  on d.Company_Id = g.Company_Id
                 and d.Filial_Id = g.Filial_Id
                 and d.Plan_Type_Id = g.Plan_Type_Id
               where g.Company_Id = Ui.Company_Id
                 and g.Filial_Id = Ui.Filial_Id
                 and k.Staff_Id = v_Staff_Id
                 and k.Status member of v_Plan_Status
                 and k.Plan_Date = v_Month)
    loop
      v_Plan := Hashmap();
      v_Plan.Put('staff_plan_id', r.Staff_Plan_Id);
      v_Plan.Put('main_calc_type', r.Main_Calc_Type);
      v_Plan.Put('main_fact_percent', r.c_Main_Fact_Percent);
      v_Plan.Put('extra_calc_type', r.Extra_Calc_Type);
      v_Plan.Put('extra_fact_percent', r.c_Extra_Fact_Percent);
      v_Plan.Put('plan_type_id', r.Plan_Type_Id);
      v_Plan.Put('plan_type_name', r.Plan_Type_Name);
      v_Plan.Put('plan_type', r.Plan_Type);
      v_Plan.Put('calc_kind', r.Calc_Kind);
      v_Plan.Put('calc_kind_name', r.Calc_Kind_Name);
      v_Plan.Put('group_name', r.Group_Name);
      v_Plan.Put('plan_value', r.Plan_Value);
      v_Plan.Put('plan_amount', r.Plan_Amount);
      v_Plan.Put('fact_value', r.Fact_Value);
      v_Plan.Put('fact_percent', r.Fact_Percent);
      v_Plan.Put('fact_note', r.Fact_Note);
      v_Plan.Put('with_part', r.With_Part);
      v_Plan.Put('status', r.Status);
      v_Plan.Put('status_name', Hper_Util.t_Staff_Plan_Status(r.Status));
      v_Plan.Put('parts', Load_Plan_Parts(r.Staff_Plan_Id, r.Plan_Type_Id));
    
      if r.Calc_Kind = Hper_Pref.c_Calc_Kind_Task then
        v_Plan.Put('tasks', Load_Plan_Tasks(r.Staff_Plan_Id, r.Plan_Type_Id));
      end if;
    
      Result.Push(v_Plan);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Edit(p Hashmap) return Hashmap is
    v_Staff_Plan_Id number := p.r_Number('staff_plan_id');
    v_Plan_Type_Id  number := p.r_Number('plan_type_id');
    v_Fact_Value    number := p.o_Number('fact_value');
    v_Fact_Note     Hper_Staff_Plan_Items.Fact_Note%type := p.o_Varchar2('fact_note');
    v_Edit_Parts    Arraylist := p.o_Arraylist('edit_parts');
    v_Remove_Parts  Array_Number := p.o_Array_Number('remove_parts');
    v_Task_Ids      Array_Number := p.o_Array_Number('task_ids');
    v_Plan_Item     Hper_Staff_Plan_Items%rowtype;
    result          Hashmap := Hashmap();
  
    --------------------------------------------------------
    Procedure Edit_Plan_Part(i_Part Hashmap) is
      v_Part Hper_Staff_Plan_Parts%rowtype;
    begin
      if i_Part.Has('part_id') then
        v_Part := z_Hper_Staff_Plan_Parts.Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Part_Id    => i_Part.r_Number('part_id'));
      else
        v_Part.Company_Id    := Ui.Company_Id;
        v_Part.Filial_Id     := Ui.Filial_Id;
        v_Part.Part_Id       := Hper_Next.Part_Id;
        v_Part.Staff_Plan_Id := v_Staff_Plan_Id;
        v_Part.Plan_Type_Id  := v_Plan_Type_Id;
      end if;
    
      v_Part.Amount := i_Part.r_Number('amount');
      v_Part.Note   := i_Part.o_Varchar2('note');
    
      Hper_Api.Staff_Plan_Part_Save(i_Plan_Part => v_Part);
    end;
  
    --------------------------------------------------------
    Procedure Plan_Update is
      v_Values Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(v_Plan_Type_Id),
                                                  Array_Varchar2(v_Fact_Value),
                                                  Array_Varchar2(v_Fact_Note));
    begin
      Hper_Api.Staff_Plan_Update(i_Company_Id    => Ui.Company_Id,
                                 i_Filial_Id     => Ui.Filial_Id,
                                 i_Staff_Plan_Id => v_Staff_Plan_Id,
                                 i_Values        => Fazo.Transpose(v_Values));
    end;
  begin
  
    if v_Fact_Value is not null then
      Plan_Update;
    end if;
  
    if v_Edit_Parts is not null then
      for i in 1 .. v_Edit_Parts.Count
      loop
        Edit_Plan_Part(Treat(v_Edit_Parts.r_Hashmap(i) as Hashmap));
      end loop;
    end if;
  
    if v_Remove_Parts is not null then
      for i in 1 .. v_Remove_Parts.Count
      loop
        Hper_Api.Staff_Plan_Part_Delete(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Part_Id    => v_Remove_Parts(i));
      end loop;
    end if;
  
    if v_Task_Ids is not null then
      Hper_Api.Staff_Plan_Save_Tasks(i_Company_Id    => Ui.Company_Id,
                                     i_Filial_Id     => Ui.Filial_Id,
                                     i_Staff_Plan_Id => v_Staff_Plan_Id,
                                     i_Plan_Type_Id  => v_Plan_Type_Id,
                                     i_Task_Ids      => v_Task_Ids,
                                     i_Fact_Note     => v_Fact_Note);
    end if;
  
    v_Plan_Item := z_Hper_Staff_Plan_Items.Load(i_Company_Id    => Ui.Company_Id,
                                                i_Filial_Id     => Ui.Filial_Id,
                                                i_Staff_Plan_Id => v_Staff_Plan_Id,
                                                i_Plan_Type_Id  => v_Plan_Type_Id);
  
    Result.Put('plan_value', v_Plan_Item.Plan_Value);
    Result.Put('plan_amount', v_Plan_Item.Plan_Amount);
    Result.Put('fact_value', v_Plan_Item.Fact_Value);
    Result.Put('fact_percent', v_Plan_Item.Fact_Percent);
    Result.Put('fact_note', v_Plan_Item.Fact_Note);
    Result.Put('parts', Load_Plan_Parts(v_Staff_Plan_Id, v_Plan_Type_Id));
  
    if v_Plan_Item.Calc_Kind = Hper_Pref.c_Calc_Kind_Task then
      Result.Put('tasks', Load_Plan_Tasks(v_Staff_Plan_Id, v_Plan_Type_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Birthdays(i_Direct_Employee varchar2) return Arraylist is
    v_Date                 varchar2(8) := to_char(sysdate, 'yyyymmdd');
    v_Date_Add_Month       varchar2(8) := to_char(Add_Months(sysdate, 1), 'yyyymmdd');
    v_Year                 varchar2(4) := to_char(sysdate, Href_Pref.c_Date_Format_Year);
    v_Year_Inc             varchar2(4) := to_number(to_char(sysdate, Href_Pref.c_Date_Format_Year)) + 1;
    v_Division_Ids         Array_Number;
    v_Subordinate_Chiefs   Array_Number;
    v_Access_All_Employees varchar2(1);
    v_Data                 Hashmap;
    result                 Arraylist := Arraylist();
  begin
    if i_Direct_Employee is null or i_Direct_Employee <> 'Y' and i_Direct_Employee <> 'N' then
      b.Raise_Fatal('hes: get_subordinates: direct employee is wrong');
    end if;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
    v_Division_Ids         := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                 i_Direct             => true,
                                                                 i_Indirect           => i_Direct_Employee = 'N',
                                                                 i_Manual             => i_Direct_Employee = 'N',
                                                                 i_Gather_Chiefs      => true);
  
    for r in (with Birthdays as
                 (select q.Employee_Id,
                        w.Name,
                        (select s.Name
                           from Mhr_Jobs s
                          where s.Company_Id = q.Company_Id
                            and s.Filial_Id = q.Filial_Id
                            and s.Job_Id = q.Job_Id) Job_Name,
                        w.Birthday,
                        case
                           when v_Year || to_char(w.Birthday, 'mmdd') >= v_Date then
                            v_Year || to_char(w.Birthday, 'mmdd')
                           else
                            v_Year_Inc || to_char(w.Birthday, 'mmdd')
                         end c_Birthday,
                        (select f.Photo_Sha
                           from Md_Persons f
                          where f.Company_Id = Ui.Company_Id
                            and f.Person_Id = q.Employee_Id
                            and f.Photo_Sha is not null) Photo_Sha,
                        w.Gender,
                        d.Division_Id
                   from Mhr_Employees q
                   join Mr_Natural_Persons w
                     on w.Company_Id = q.Company_Id
                    and w.Person_Id = q.Employee_Id
                    and w.Birthday is not null
                   join Href_Staffs d
                     on d.Company_Id = q.Company_Id
                    and d.Filial_Id = q.Filial_Id
                    and d.Employee_Id = q.Employee_Id
                    and d.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                    and d.Hiring_Date <= Trunc(sysdate)
                    and (d.Dismissal_Date is null or d.Dismissal_Date >= Trunc(sysdate))
                    and (v_Access_All_Employees = 'Y' --
                        or d.Org_Unit_Id member of v_Division_Ids --
                         or d.Employee_Id member of v_Subordinate_Chiefs)
                    and d.State = 'A'
                  where q.Company_Id = Ui.Company_Id
                    and q.Filial_Id = Ui.Filial_Id
                    and q.Employee_Id <> Ui.User_Id
                    and q.State = 'A'),
                Employees as
                 (select c.Employee_Id,
                        c.Name,
                        c.Job_Name,
                        c.Birthday,
                        c.Photo_Sha,
                        c.Gender,
                        c.Division_Id
                   from Birthdays c
                  where c.c_Birthday <= v_Date_Add_Month
                  order by c.c_Birthday)
                select h.Employee_Id,
                       h.Name,
                       h.Job_Name,
                       h.Birthday,
                       h.Photo_Sha,
                       h.Gender,
                       h.Division_Id
                  from Employees h)
    loop
      v_Data := Hashmap();
      v_Data.Put('employee_id', r.Employee_Id);
      v_Data.Put('name', r.Name);
      v_Data.Put('job_name', r.Job_Name);
      v_Data.Put('birthday', r.Birthday);
      v_Data.Put('photo_sha', r.Photo_Sha);
      v_Data.Put('gender', r.Gender);
      v_Data.Put('division_id', r.Division_Id);
    
      Result.Push(v_Data);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Accessible_Action_Keys return varchar2 is
    v_Keys        Array_Varchar2 := Array_Varchar2(Uit_Hes.c_Action_Key_Request_Deny,
                                                   Uit_Hes.c_Action_Key_Request_Complete,
                                                   Uit_Hes.c_Action_Key_Request_Delete,
                                                   Uit_Hes.c_Action_Key_Request_Approve,
                                                   Uit_Hes.c_Action_Key_Request_Reset,
                                                   Uit_Hes.c_Action_Key_Change_Deny,
                                                   Uit_Hes.c_Action_Key_Change_Complete,
                                                   Uit_Hes.c_Action_Key_Change_Delete,
                                                   Uit_Hes.c_Action_Key_Change_Approve,
                                                   Uit_Hes.c_Action_Key_Change_Reset);
    v_Action_Keys Array_Varchar2 := Array_Varchar2();
  begin
    for i in 1 .. v_Keys.Count
    loop
      if Ui.Grant_Has(v_Keys(i)) then
        v_Action_Keys.Extend();
        v_Action_Keys(v_Action_Keys.Count) := v_Keys(i);
      end if;
    end loop;
  
    return Fazo.Gather(v_Action_Keys, ',');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Calculation_Pro
  (
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Hashmap is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Total_Accrual        number;
    v_Income_Tax           number;
    v_Total_Deduction      number;
    v_Payment              number;
    v_Credit               number;
    v_Worked_Days          number;
    v_Worked_Hours         number;
    v_Accrual_Oper_Types   Arraylist := Arraylist();
    v_Deduction_Oper_Types Arraylist := Arraylist();
    v_Acc_Oper_Types       Matrix_Varchar2;
    v_Deduct_Oper_Types    Matrix_Varchar2;
    r_Staff                Href_Staffs%rowtype;
    result                 Hashmap := Hashmap();
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    Result.Put('is_approximately',
               Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => i_Staff_Id,
                                             i_Dismissal_Date => r_Staff.Dismissal_Date,
                                             i_Hiring_Date    => r_Staff.Hiring_Date,
                                             i_Begin_Date     => i_Begin_Date,
                                             i_End_Date       => i_End_Date,
                                             i_Is_Pro         => true));
  
    Uit_Hpr.Wage_Calculation_Pro(i_Staff_Id             => r_Staff.Staff_Id,
                                 i_Begin_Date           => i_Begin_Date,
                                 i_End_Date             => i_End_Date,
                                 o_Total_Accrual        => v_Total_Accrual,
                                 o_Total_Deduction      => v_Total_Deduction,
                                 o_Income_Tax           => v_Income_Tax,
                                 o_Worked_Hours         => v_Worked_Hours,
                                 o_Worked_Days          => v_Worked_Days,
                                 o_Accrual_Oper_Types   => v_Acc_Oper_Types,
                                 o_Deduction_Oper_Types => v_Deduct_Oper_Types,
                                 o_Payment              => v_Payment,
                                 o_Credit               => v_Credit);
  
    Result.Put('worked_hours', v_Worked_Hours);
    Result.Put('worked_days', v_Worked_Days);
  
    v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name',
                                             t('personal income tax'),
                                             'amount',
                                             v_Income_Tax));
  
    for i in 1 .. v_Acc_Oper_Types.Count
    loop
      v_Accrual_Oper_Types.Push(Fazo.Zip_Map('name',
                                             v_Acc_Oper_Types(i) (1),
                                             'amount',
                                             v_Acc_Oper_Types(i) (2)));
    end loop;
  
    for i in 1 .. v_Deduct_Oper_Types.Count
    loop
      v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name',
                                               v_Deduct_Oper_Types(i) (1),
                                               'amount',
                                               v_Deduct_Oper_Types(i) (2)));
    end loop;
  
    if v_Credit > 0 then
      v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name', t('credit'), 'amount', v_Credit));
    end if;
  
    Result.Put('total_accrual', v_Total_Accrual);
    Result.Put('total_deduction', v_Total_Deduction);
    Result.Put('accrual_oper_types', v_Accrual_Oper_Types);
    Result.Put('deduction_oper_types', v_Deduction_Oper_Types);
    Result.Put('payoff', v_Total_Accrual - v_Total_Deduction);
    Result.Put('payment', v_Payment);
    Result.Put('left_amount', v_Total_Accrual - v_Total_Deduction - v_Payment);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Calculation_Start
  (
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Hashmap is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Total_Accrual        number;
    v_Total_Deduction      number;
    v_Worked_Days          number;
    v_Worked_Hours         number;
    v_Payment              number;
    v_Wage_Amount          number;
    v_Overtime_Amount      number;
    v_Late_Amount          number;
    v_Early_Amount         number;
    v_Lack_Amount          number;
    v_Day_Skip_Amount      number;
    v_Mark_Skip_Amount     number;
    v_Onetime_Accrual      number;
    v_Onetime_Penalty      number;
    v_Accrual_Oper_Types   Arraylist := Arraylist();
    v_Deduction_Oper_Types Arraylist := Arraylist();
    r_Staff                Href_Staffs%rowtype;
    result                 Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Push_Oper_Type
    (
      i_Name           varchar2,
      i_Amount         number,
      i_Operation_Kind varchar := Mpr_Pref.c_Ok_Deduction
    ) is
    begin
      if i_Operation_Kind = Mpr_Pref.c_Ok_Accrual then
        v_Accrual_Oper_Types.Push(Fazo.Zip_Map('name', i_Name, 'amount', i_Amount));
      else
        v_Deduction_Oper_Types.Push(Fazo.Zip_Map('name', i_Name, 'amount', i_Amount));
      end if;
    end;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    Result.Put('is_approximately',
               Uit_Hpr.Is_Approximately_Wage(i_Staff_Id       => r_Staff.Staff_Id,
                                             i_Dismissal_Date => r_Staff.Dismissal_Date,
                                             i_Hiring_Date    => r_Staff.Hiring_Date,
                                             i_Begin_Date     => i_Begin_Date,
                                             i_End_Date       => i_End_Date,
                                             i_Is_Pro         => false));
  
    Uit_Hpr.Wage_Calculation_Start(i_Staff_Id         => r_Staff.Staff_Id,
                                   i_Begin_Date       => i_Begin_Date,
                                   i_End_Date         => i_End_Date,
                                   o_Worked_Hours     => v_Worked_Hours,
                                   o_Worked_Days      => v_Worked_Days,
                                   o_Wage_Amount      => v_Wage_Amount,
                                   o_Overtime_Amount  => v_Overtime_Amount,
                                   o_Onetime_Accrual  => v_Onetime_Accrual,
                                   o_Late_Amount      => v_Late_Amount,
                                   o_Early_Amount     => v_Early_Amount,
                                   o_Lack_Amount      => v_Lack_Amount,
                                   o_Day_Skip_Amount  => v_Day_Skip_Amount,
                                   o_Mark_Skip_Amount => v_Mark_Skip_Amount,
                                   o_Onetime_Penalty  => v_Onetime_Penalty,
                                   o_Total_Accrual    => v_Total_Accrual,
                                   o_Total_Deduction  => v_Total_Deduction,
                                   o_Payment          => v_Payment);
  
    Push_Oper_Type(t('wage amount'), v_Wage_Amount, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('overtime amount'), v_Overtime_Amount, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('onetime accrual'), v_Onetime_Accrual, Mpr_Pref.c_Ok_Accrual);
    Push_Oper_Type(t('late amount'), v_Late_Amount);
    Push_Oper_Type(t('early amount'), v_Early_Amount);
    Push_Oper_Type(t('lack amount'), v_Lack_Amount);
    Push_Oper_Type(t('day skip amount'), v_Day_Skip_Amount);
    Push_Oper_Type(t('mark skip amount'), v_Mark_Skip_Amount);
    Push_Oper_Type(t('onetime penalty'), v_Onetime_Penalty);
  
    Result.Put('worked_hours', v_Worked_Hours);
    Result.Put('worked_days', v_Worked_Days);
    Result.Put('total_accrual', v_Total_Accrual);
    Result.Put('total_deduction', v_Total_Deduction);
    Result.Put('accrual_oper_types', v_Accrual_Oper_Types);
    Result.Put('deduction_oper_types', v_Deduction_Oper_Types);
    Result.Put('payoff', v_Total_Accrual - v_Total_Deduction);
    Result.Put('payment', v_Payment);
    Result.Put('left_amount', v_Total_Accrual - v_Total_Deduction - v_Payment);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Payroll(p Hashmap) return Hashmap is
    r_Staff                       Href_Staffs%rowtype;
    r_Currency                    Mk_Currencies%rowtype;
    v_Job_Id                      number;
    v_Rank_Id                     number;
    v_Begin_Date                  date := Trunc(Nvl(p.o_Date('month'), sysdate), 'mon');
    v_End_Date                    date := Last_Day(v_Begin_Date);
    v_Desired_Date                date;
    v_Employee_Id                 number := p.o_Number('employee_id');
    v_Access_To_Hidden_Salary_Job varchar2(1) := 'Y';
    result                        Hashmap := Hashmap();
  begin
    if v_Employee_Id is not null then
      Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
    else
      v_Employee_Id := Ui.User_Id;
    end if;
  
    r_Staff := Uit_Href.Get_Primary_Staff(i_Employee_Id => v_Employee_Id, i_Date => v_End_Date);
  
    if r_Staff.Company_Id is null then
      Result.Put('has_data', 'N');
    
      return result;
    end if;
  
    Result.Put('has_data', 'Y');
  
    Result.Put('person_name',
               z_Md_Persons.Load(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Name);
    Result.Put('tin',
               z_Mr_Person_Details.Take(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Tin);
  
    v_Desired_Date := Least(v_End_Date, Nvl(r_Staff.Dismissal_Date, v_End_Date));
  
    v_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Staff.Company_Id,
                                            i_Filial_Id  => r_Staff.Filial_Id,
                                            i_Staff_Id   => r_Staff.Staff_Id,
                                            i_Period     => v_Desired_Date);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Job_Id => v_Job_Id).Name);
  
    v_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Staff.Company_Id,
                                              i_Filial_Id  => r_Staff.Filial_Id,
                                              i_Staff_Id   => r_Staff.Staff_Id,
                                              i_Period     => v_Desired_Date);
  
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Rank_Id => v_Rank_Id).Name);
  
    v_Access_To_Hidden_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => v_Job_Id,
                                                                         i_Employee_Id => v_Employee_Id);
  
    Result.Put('access_to_hidden_salary_job', v_Access_To_Hidden_Salary_Job);
  
    if v_Access_To_Hidden_Salary_Job = 'Y' then
      r_Currency := z_Mk_Currencies.Load(i_Company_Id  => r_Staff.Company_Id,
                                         i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => r_Staff.Company_Id,
                                                                                i_Filial_Id  => r_Staff.Filial_Id));
    
      Result.Put('currency', r_Currency.Decimal_Name);
    
      if Uit_Href.Is_Pro(r_Staff.Company_Id) then
        Result.Put_All(Wage_Calculation_Pro(i_Staff_Id   => r_Staff.Staff_Id,
                                            i_Begin_Date => v_Begin_Date,
                                            i_End_Date   => v_End_Date));
      else
        Result.Put_All(Wage_Calculation_Start(i_Staff_Id   => r_Staff.Staff_Id,
                                              i_Begin_Date => v_Begin_Date,
                                              i_End_Date   => v_End_Date));
      end if;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Documents(p Hashmap) return Arraylist is
    v_Person_Id number := p.r_Number('person_id');
    v_Row       Hashmap;
    v_Files     Arraylist;
    result      Arraylist := Arraylist();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    for r in (select q.Document_Id,
                     q.Doc_Type_Id,
                     (select w.Name
                        from Href_Document_Types w
                       where w.Company_Id = q.Company_Id
                         and w.Doc_Type_Id = q.Doc_Type_Id) Doc_Type_Name,
                     q.Doc_Series,
                     q.Doc_Number,
                     q.Issued_By,
                     q.Issued_Date,
                     q.Begin_Date,
                     q.Expiry_Date,
                     q.Note,
                     Nvl2((select Df.Sha
                            from Href_Person_Document_Files Df
                           where Df.Company_Id = Ui.Company_Id
                             and Df.Document_Id = q.Document_Id
                             and Rownum = 1),
                          'Y',
                          'N') Has_File_Sha
                from Href_Person_Documents q
               where q.Company_Id = Ui.Company_Id
                 and q.Person_Id = v_Person_Id)
    loop
      v_Row := Fazo.Zip_Map('document_id',
                            r.Document_Id,
                            'doc_type_id',
                            r.Doc_Type_Id,
                            'doc_type_name',
                            r.Doc_Type_Name,
                            'doc_series',
                            r.Doc_Series,
                            'doc_number',
                            r.Doc_Number,
                            'issued_by',
                            r.Issued_By);
    
      v_Row.Put('issued_date', r.Issued_Date);
      v_Row.Put('begin_date', r.Begin_Date);
      v_Row.Put('expiry_date', r.Expiry_Date);
      v_Row.Put('note', r.Note);
      v_Row.Put('has_file_sha', r.Has_File_Sha);
    
      -- documents
      v_Files := Arraylist();
    
      for k in (select q.Document_Id,
                       q.Sha,
                       (select w.File_Name
                          from Biruni_Files w
                         where w.Sha = q.Sha) File_Name
                  from Href_Person_Document_Files q
                 where q.Company_Id = Ui.Company_Id
                   and q.Document_Id = r.Document_Id)
      loop
        v_Files.Push(Fazo.Zip_Map('sha', k.Sha, 'file_name', k.File_Name));
      end loop;
    
      v_Row.Put('files', v_Files);
      Result.Push(v_Row);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Download_Person_Document_Files(p Hashmap) return Fazo_File is
    r_Doc       Href_Person_Documents%rowtype;
    v_File_Shas Array_Varchar2;
  begin
    r_Doc := z_Href_Person_Documents.Load(i_Company_Id  => Ui.Company_Id, --
                                          i_Document_Id => p.r_Number('document_id'));
  
    Uit_Href.Assert_Access_To_Employee(r_Doc.Person_Id);
  
    select w.Sha
      bulk collect
      into v_File_Shas
      from Href_Person_Document_Files w
     where w.Company_Id = r_Doc.Company_Id
       and w.Document_Id = r_Doc.Document_Id;
  
    return Ui_Kernel.Download_Files(i_Shas            => v_File_Shas, --
                                    i_Attachment_Name => t('person documents, document_type=$1',
                                                           z_Href_Document_Types.Load(i_Company_Id => Ui.Company_Id, --
                                                           i_Doc_Type_Id => r_Doc.Doc_Type_Id).Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Task_Statuses return Arraylist is
    v_Statuses Arraylist := Arraylist();
    v_Data     Hashmap;
  begin
    for r in (select *
                from Ms_Task_Statuses q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A')
    loop
      v_Data := Hashmap();
      v_Data.Put('status_id', r.Status_Id);
      v_Data.Put('name', r.Name);
      v_Data.Put('color', r.Color);
      v_Data.Put('text_color', r.Text_Color);
      v_Data.Put('order_no', r.Order_No);
      v_Data.Put('pcode', r.Pcode);
    
      v_Statuses.Push(v_Data);
    end loop;
  
    return v_Statuses;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Users return Arraylist is
    v_Users        Arraylist := Arraylist();
    v_Current_Date date := Trunc(sysdate);
    v_Data         Hashmap;
  begin
    for r in (select t.User_Id,
                     t.Name,
                     St.Division_Id,
                     (select d.Name
                        from Mhr_Divisions d
                       where d.Company_Id = St.Company_Id
                         and d.Filial_Id = St.Filial_Id
                         and d.Division_Id = St.Division_Id) Division_Name,
                     (select w.Photo_Sha
                        from Md_Persons w
                       where w.Company_Id = t.Company_Id
                         and w.Person_Id = t.User_Id) as Photo_Sha
                from Md_Users t
                left join Href_Staffs St
                  on St.Company_Id = t.Company_Id
                 and St.Filial_Id = Ui.Filial_Id
                 and St.Employee_Id = t.User_Id
                 and St.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and St.State = 'A'
                 and St.Hiring_Date <= v_Current_Date
                 and (St.Dismissal_Date is null or St.Dismissal_Date >= v_Current_Date)
               where t.Company_Id = Ui.Company_Id
                 and t.State = 'A'
                 and t.User_Kind = Md_Pref.c_Uk_Normal
                 and exists (select 1
                        from Md_User_Filials q
                       where q.Company_Id = Ui.Company_Id
                         and q.Filial_Id = Ui.Filial_Id
                         and q.User_Id = t.User_Id))
    loop
      v_Data := Hashmap();
      v_Data.Put('person_id', r.User_Id);
      v_Data.Put('name', r.Name);
      v_Data.Put('photo_sha', r.Photo_Sha);
      v_Data.Put('division_id', r.Division_Id);
      v_Data.Put('division_name', r.Division_Name);
    
      v_Users.Push(v_Data);
    end loop;
  
    return v_Users;
  end;

  ----------------------------------------------------------------------------------------------------               
  Function Check_Timesheet_Exists
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return boolean is
    v_Dummy number;
  begin
    select 1
      into v_Dummy
      from Htt_Timesheets q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Timesheet_Date between i_Begin_Date and i_End_Date
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Monthly_Attendance(p Hashmap) return Hashmap is
    v_Company_Id        number := Ui.Company_Id;
    v_Filial_Id         number := Ui.Filial_Id;
    v_Staff_Id          number;
    v_Begin_Date        date := Trunc(Nvl(p.o_Date('month'), sysdate), 'mon');
    v_End_Date          date := Least(Trunc(sysdate), Last_Day(v_Begin_Date));
    v_Current_Date      date := Trunc(sysdate);
    v_Days_Count        number;
    v_Dummy             number;
    v_Late_Id           number;
    v_Lack_Id           number;
    v_Turnout_Ids       Array_Number;
    v_Absence_Ids       Array_Number;
    v_Intime_Count      number;
    v_Late_Time_Count   number;
    v_Absence_Count     number;
    v_Absence_Req_Count number;
    v_All_Days_Count    number;
    v_Left_Days_Count   number;
    result              Hashmap := Fazo.Zip_Map('has_timesheet', 'Y');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => p.r_Number('employee_id'));
  
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => p.r_Number('employee_id'),
                                                 i_Date        => v_End_Date);
  
    if not Check_Timesheet_Exists(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Staff_Id   => v_Staff_Id,
                                  i_Begin_Date => v_Begin_Date,
                                  i_End_Date   => Last_Day(v_Begin_Date)) then
      return Fazo.Zip_Map('has_timesheet', 'N');
    end if;
  
    v_Late_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
    v_Lack_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
    v_Absence_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Vacation));
  
    v_All_Days_Count := Htt_Util.Calc_Working_Days(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => v_Filial_Id,
                                                   i_Staff_Id   => v_Staff_Id,
                                                   i_Begin_Date => v_Begin_Date,
                                                   i_End_Date   => Last_Day(v_Begin_Date));
  
    Result.Put('all_days_count', v_All_Days_Count);
  
    if Trunc(sysdate, 'mon') = v_Begin_Date then
      v_Left_Days_Count := Htt_Util.Calc_Working_Days(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_Staff_Id   => v_Staff_Id,
                                                      i_Begin_Date => Trunc(sysdate) + 1,
                                                      i_End_Date   => Last_Day(v_Begin_Date));
    elsif Trunc(sysdate, 'mon') > v_Begin_Date then
      v_Left_Days_Count := 0;
    else
      v_Left_Days_Count := v_All_Days_Count;
    end if;
  
    Result.Put('left_days_count', v_Left_Days_Count);
  
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Dummy,
                                  o_Fact_Days    => v_Days_Count,
                                  i_Company_Id   => v_Company_Id,
                                  i_Filial_Id    => v_Filial_Id,
                                  i_Staff_Id     => v_Staff_Id,
                                  i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout),
                                  i_Begin_Date   => v_Begin_Date,
                                  i_End_Date     => v_End_Date);
  
    Result.Put('worked_days_count', v_Days_Count);
  
    select sum(Decode(q.Kind, 'L', 1, 0)),
           sum(Decode(q.Kind, 'I', 1, 0)),
           sum(Decode(q.Kind, 'E', 1, 0)),
           sum(Decode(q.Kind, 'O', 1, 0))
      into v_Late_Time_Count, v_Intime_Count, v_Absence_Req_Count, v_Absence_Count
      from (select case
                      when Nvl((select t.Fact_Value
                                 from Htt_Timesheet_Facts t
                                where t.Company_Id = v_Company_Id
                                  and t.Filial_Id = v_Filial_Id
                                  and t.Timesheet_Id = q.Timesheet_Id
                                  and t.Time_Kind_Id = v_Late_Id),
                               -1) > 0 then
                       'L'
                      when q.Input_Time <= q.Begin_Time and q.Timesheet_Date = v_Current_Date or
                           Nvl((select sum(t.Fact_Value)
                                 from Htt_Timesheet_Facts t
                                where t.Company_Id = v_Company_Id
                                  and t.Filial_Id = v_Filial_Id
                                  and t.Timesheet_Id = q.Timesheet_Id
                                  and t.Time_Kind_Id member of v_Turnout_Ids),
                               -1) > 0 then
                       'I'
                      when Nvl((select sum(t.Fact_Value)
                                 from Htt_Timesheet_Facts t
                                where t.Company_Id = v_Company_Id
                                  and t.Filial_Id = v_Filial_Id
                                  and t.Timesheet_Id = q.Timesheet_Id
                                  and t.Time_Kind_Id member of v_Absence_Ids),
                               -1) >= q.Plan_Time then
                       'E'
                      when Nvl((select t.Fact_Value
                                 from Htt_Timesheet_Facts t
                                where t.Company_Id = v_Company_Id
                                  and t.Filial_Id = v_Filial_Id
                                  and t.Timesheet_Id = q.Timesheet_Id
                                  and t.Time_Kind_Id = v_Lack_Id),
                               -1) > 0 then
                       'O'
                      else
                       'E'
                    end Kind
              from Htt_Timesheets q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Staff_Id = v_Staff_Id
               and q.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
               and q.Timesheet_Date between v_Begin_Date and v_End_Date) q;
  
    Result.Put('intime_count', v_Intime_Count);
    Result.Put('late_count', v_Late_Time_Count);
    Result.Put('absence_count', v_Absence_Count);
    Result.Put('absence_request_count', v_Absence_Req_Count);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Divisions return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Divisions Arraylist := Arraylist();
  begin
    v_Matrix := Uit_Hrm.Divisions;
  
    for i in 1 .. v_Matrix.Count
    loop
      v_Divisions.Push(Fazo.Zip_Map('division_id',
                                    v_Matrix(i) (1),
                                    'division_name',
                                    v_Matrix(i) (2),
                                    'parent_id',
                                    v_Matrix(i) (3)));
    end loop;
  
    return v_Divisions;
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
           Is_Valid       = null,
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
           name        = null,
           Region_Id   = null,
           Prohibited  = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Htt_Devices
       set Company_Id = null,
           Device_Id  = null,
           name       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null,
           Email      = null;
    update Mr_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Tin        = null,
           Main_Phone = null,
           Address    = null,
           Region_Id  = null;
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           name        = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           Code        = null,
           State       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Job_Id      = null,
           State       = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Htt_Requests
       set Company_Id      = null,
           Filial_Id       = null,
           Request_Id      = null,
           Request_Kind_Id = null,
           Staff_Id        = null,
           Begin_Time      = null,
           End_Time        = null,
           Request_Type    = null,
           Manager_Note    = null,
           Note            = null,
           Status          = null,
           Barcode         = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Htt_Plan_Changes
       set Company_Id   = null,
           Filial_Id    = null,
           Change_Id    = null,
           Staff_Id     = null,
           Change_Kind  = null,
           Manager_Note = null,
           Note         = null,
           Status       = null,
           Created_By   = null,
           Created_On   = null,
           Modified_By  = null,
           Modified_On  = null;
    update Htt_Change_Days
       set Company_Id  = null,
           Filial_Id   = null,
           Change_Id   = null,
           Change_Date = null;
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           name            = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null,
           Division_Id    = null,
           Staff_Kind     = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Ms_Notifications
       set Company_Id        = null,
           Notification_Id   = null,
           Person_Id         = null,
           Filial_Id         = null,
           Notification_Kind = null,
           Viewed            = null,
           Title             = null,
           Note              = null,
           Uri               = null,
           Uri_Param         = null,
           Source_Code       = null,
           Created_On        = null;
  
    Uie.x(Htt_Util.Request_Time(i_Request_Type => null, i_Begin_Time => null, i_End_Time => null));
  end;

end Ui_Vhr95;
/
