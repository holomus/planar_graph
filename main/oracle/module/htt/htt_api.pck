create or replace package Htt_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Staff_Request
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Request_Id  number,
    i_Notify_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Notify_Staff_Plan_Changes
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Change_Id   number,
    i_Notify_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Calendar_Save(i_Calendar Htt_Pref.Calendar_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Calendar_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Save(i_Schedule Htt_Pref.Schedule_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Save(i_Schedule_Template Htt_Pref.Schedule_Template_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Delete(i_Template_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Time_Kind_Save(i_Time_Kind Htt_Time_Kinds%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Time_Kind_Delete
  (
    i_Company_Id   number,
    i_Time_Kind_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Save(i_Person Htt_Pref.Person_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Photo_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Photo_Sha  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save_Photo
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Photo_Sha  varchar2,
    i_Is_Main    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Photo_Update
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Old_Photo_Sha varchar2,
    i_New_Photo_Sha varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Location_Type_Save(i_Location_Type Htt_Location_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Delete
  (
    i_Company_Id       number,
    i_Location_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Save
  (
    i_Location         Htt_Locations%rowtype,
    i_Polygon_Vertices Array_Varchar2 := Array_Varchar2()
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Delete
  (
    i_Company_Id  number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Filial
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Location_Remove_Filial
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  );
  ----------------------------------------------------------------------------------------------------       
  Procedure Global_Sync_Location_Persons
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Global_Sync_All_Location
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Division
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Division_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Division
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Division_Id number
  );
  ----------------------------------------------------------------------------------------------------      
  Procedure Location_Qr_Code_Deactivate
  (
    i_Company_Id number,
    i_Unique_Key varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Qr_Code_Delete
  (
    i_Company_Id number,
    i_Unique_Key varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Location_Qr_Code_Generate
  (
    i_Company_Id  number,
    i_Location_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Terminal_Model_Save(i_Terminal_Model Htt_Terminal_Models%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Add(i_Device Htt_Devices%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Update
  (
    i_Company_Id           number,
    i_Device_Id            number,
    i_Name                 Option_Varchar2 := null,
    i_Model_Id             Option_Number := null,
    i_Location_Id          Option_Number := null,
    i_Charge_Percentage    Option_Number := null,
    i_Track_Types          Option_Varchar2 := null,
    i_Mark_Types           Option_Varchar2 := null,
    i_Emotion_Types        Option_Varchar2 := null,
    i_Lang_Code            Option_Varchar2 := null,
    i_Use_Settings         Option_Varchar2 := null,
    i_Last_Seen_On         Option_Date := null,
    i_Autogen_Inputs       Option_Varchar2 := null,
    i_Autogen_Outputs      Option_Varchar2 := null,
    i_Ignore_Tracks        Option_Varchar2 := null,
    i_Ignore_Images        Option_Varchar2 := null,
    i_Restricted_Type      Option_Varchar2 := null,
    i_Only_Last_Restricted Option_Varchar2 := null,
    i_State                Option_Varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Save(i_Device Htt_Acms_Devices%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Add_Admin
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Remove_Admin
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Delete
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Unknown_Device_Add
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Reliable_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Unreliable_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Clear_Device_Tracks
  (
    i_Company_Id number,
    i_Device_Id  number
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
  Procedure Acms_Command_Complete
  (
    i_Company_Id number,
    i_Command_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Command_Fail
  (
    i_Company_Id number,
    i_Command_Id number,
    i_Error_Msg  varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Trim_Tracks_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Pin_Autogenerate_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Photo_As_Face_Rec_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Track_Add(i_Track Htt_Tracks%rowtype);
  ----------------------------------------------------------------------------------------------------    
  Procedure Change_Track_Type
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Track_Id       number,
    i_New_Track_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Track_Set_Valid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Track_Set_Invalid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Track_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Gps_Track_Add(i_Track Htt_Pref.Gps_Track_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Gps_Track_Add(i_Track Htt_Pref.Gps_Track_Data_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Save(i_Request_Kind Htt_Request_Kinds%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Delete
  (
    i_Company_Id      number,
    i_Request_Kind_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Attach_Request_Kind
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Detach_Request_Kind
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Request_Save(i_Request Htt_Requests%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Reset
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Manager_Note varchar2,
    i_User_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Manager_Note varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Save(i_Change Htt_Pref.Change_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number,
    i_Manager_Note varchar2 := null,
    i_User_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number,
    i_Manager_Note varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weights_Save(i_Change_Day_Weights Htt_Pref.Change_Day_Weights);
  ----------------------------------------------------------------------------------------------------  
  Procedure Regen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Gps_Track_Distances
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Registry_Save(i_Registry Htt_Pref.Schedule_Registry_Rt);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Registry_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number,
    i_Repost      boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Save(i_Server Htt_Acms_Servers%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Delete(i_Server_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Detach(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Track_Insert(i_Track Htt_Acms_Tracks%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Track_Integrate
  (
    i_Company_Id number,
    i_Track_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Copy_Tracks_To_Filial
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Person_Global_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  );
end Htt_Api;
/
create or replace package body Htt_Api is
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
  -- notifications
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Staff_Request
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Request_Id  number,
    i_Notify_Type varchar2
  ) is
    r_Person      Mr_Natural_Persons%rowtype;
    r_Request     Htt_Requests%rowtype;
    r_Staff       Href_Staffs%rowtype;
    v_User_Id     number;
    v_Manager_Id  number;
    v_Employee_Id number;
    result        Hashmap := Hashmap();
  begin
    r_Request    := z_Htt_Requests.Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Request_Id => i_Request_Id);
    r_Staff      := z_Href_Staffs.Load(i_Company_Id => r_Request.Company_Id,
                                       i_Filial_Id  => r_Request.Filial_Id,
                                       i_Staff_Id   => r_Request.Staff_Id);
    r_Person     := z_Mr_Natural_Persons.Load(i_Company_Id => r_Staff.Company_Id,
                                              i_Person_Id  => r_Staff.Employee_Id);
    v_User_Id    := r_Person.Person_Id;
    v_Manager_Id := Href_Util.Get_Manager_Id(i_Company_Id => r_Staff.Company_Id,
                                             i_Filial_Id  => r_Staff.Filial_Id,
                                             i_Robot_Id   => r_Staff.Robot_Id);
  
    if i_Notify_Type = Hes_Pref.c_Pref_Nt_Request then
      if v_Manager_Id is null then
        return;
      end if;
    
      v_User_Id := v_Manager_Id;
    end if;
  
    if not Hes_Util.Enabled_Notify(i_Company_Id   => i_Company_Id,
                                   i_User_Id      => v_User_Id,
                                   i_Setting_Code => i_Notify_Type) then
      return;
    end if;
  
    Result.Put('notify_type', i_Notify_Type);
    Result.Put('request_id', r_Request.Request_Id);
    Result.Put('status', r_Request.Status);
    Result.Put('status_name', Htt_Util.t_Request_Status(r_Request.Status));
    Result.Put('request_kind_name',
               z_Htt_Request_Kinds.Load(i_Company_Id => r_Request.Company_Id, i_Request_Kind_Id => r_Request.Request_Kind_Id).Name);
    Result.Put('request_type', r_Request.Request_Type);
    Result.Put('begin_time', to_char(r_Request.Begin_Time, Href_Pref.c_Date_Format_Second));
    Result.Put('end_time', to_char(r_Request.End_Time, Href_Pref.c_Date_Format_Second));
    Result.Put('employee_name', r_Person.Name);
  
    if i_Notify_Type = Hes_Pref.c_Pref_Nt_Request_Manager_Approval then
      Result.Put('manager_name',
                 z_Mr_Natural_Persons.Take(i_Company_Id => r_Person.Company_Id, i_Person_Id => v_Manager_Id).Name);
    end if;
  
    v_Employee_Id := z_Href_Staffs.Load(i_Company_Id => r_Request.Company_Id, i_Filial_Id => r_Request.Filial_Id, i_Staff_Id => r_Request.Staff_Id).Employee_Id;
  
    Href_Core.Send_Notification(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Title      => Htt_Util.t_Request_Notification_Title(i_Company_Id      => i_Company_Id,
                                                                                      i_User_Id         => v_Employee_Id,
                                                                                      i_Notify_Type     => i_Notify_Type,
                                                                                      t_Request_Kind_Id => r_Request.Request_Kind_Id),
                                i_Uri        => Htt_Pref.c_Form_Request_View,
                                i_Uri_Param  => Fazo.Zip_Map('request_id', r_Request.Request_Id),
                                i_User_Id    => r_Request.Modified_By);
  
    Mt_Fcm.Send(i_Company_Id => i_Company_Id, --
                i_User_Id    => v_User_Id,
                i_Data       => result);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Staff_Plan_Changes
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Change_Id   number,
    i_Notify_Type varchar2
  ) is
    r_Person       Mr_Natural_Persons%rowtype;
    r_Change       Htt_Plan_Changes%rowtype;
    r_Staff        Href_Staffs%rowtype;
    v_User_Id      number;
    v_Manager_Id   number;
    v_Change_Date  date;
    v_Swapped_Date date;
    v_Employee_Id  number;
    result         Hashmap := Hashmap();
  begin
    r_Change     := z_Htt_Plan_Changes.Load(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Change_Id  => i_Change_Id);
    r_Staff      := z_Href_Staffs.Load(i_Company_Id => r_Change.Company_Id,
                                       i_Filial_Id  => r_Change.Filial_Id,
                                       i_Staff_Id   => r_Change.Staff_Id);
    r_Person     := z_Mr_Natural_Persons.Load(i_Company_Id => r_Staff.Company_Id,
                                              i_Person_Id  => r_Staff.Employee_Id);
    v_User_Id    := r_Person.Person_Id;
    v_Manager_Id := Href_Util.Get_Manager_Id(i_Company_Id => r_Staff.Company_Id,
                                             i_Filial_Id  => r_Staff.Filial_Id,
                                             i_Robot_Id   => r_Staff.Robot_Id);
  
    if i_Notify_Type = Hes_Pref.c_Pref_Nt_Plan_Change then
      if v_Manager_Id is null then
        return;
      end if;
    
      v_User_Id := v_Manager_Id;
    end if;
  
    if not Hes_Util.Enabled_Notify(i_Company_Id   => i_Company_Id,
                                   i_User_Id      => v_User_Id,
                                   i_Setting_Code => i_Notify_Type) then
      return;
    end if;
  
    select q.Change_Date, q.Swapped_Date
      into v_Change_Date, v_Swapped_Date
      from Htt_Change_Days q
     where q.Company_Id = r_Change.Company_Id
       and q.Filial_Id = r_Change.Filial_Id
       and q.Change_Id = r_Change.Change_Id
       and Rownum = 1;
  
    Result.Put('notify_type', i_Notify_Type);
    Result.Put('change_id', r_Change.Change_Id);
    Result.Put('change_kind', r_Change.Change_Kind);
    Result.Put('change_kind_name', Htt_Util.t_Change_Kind(r_Change.Change_Kind));
    Result.Put('status', r_Change.Status);
    Result.Put('status_name', Htt_Util.t_Change_Status(r_Change.Status));
    Result.Put('employee_name', r_Person.Name);
    Result.Put('change_date', v_Change_Date);
    Result.Put('swapped_date', v_Swapped_Date);
  
    if i_Notify_Type = Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval then
      Result.Put('manager_name',
                 z_Mr_Natural_Persons.Take(i_Company_Id => r_Person.Company_Id, i_Person_Id => v_Manager_Id).Name);
    end if;
  
    v_Employee_Id := z_Href_Staffs.Load(i_Company_Id => r_Change.Company_Id, i_Filial_Id => r_Change.Filial_Id, i_Staff_Id => r_Change.Staff_Id).Employee_Id;
  
    Href_Core.Send_Notification(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Title      => Htt_Util.t_Change_Notification_Title(i_Company_Id  => i_Company_Id,
                                                                                     i_User_Id     => v_Employee_Id,
                                                                                     i_Notify_Type => i_Notify_Type,
                                                                                     i_Change_Kind => r_Change.Change_Kind),
                                i_Uri        => Htt_Pref.c_Form_Change_View,
                                i_Uri_Param  => Fazo.Zip_Map('change_id', r_Change.Change_Id),
                                i_User_Id    => r_Change.Modified_By);
  
    Mt_Fcm.Send(i_Company_Id => i_Company_Id, --
                i_User_Id    => v_User_Id,
                i_Data       => result);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_Save(i_Calendar Htt_Pref.Calendar_Rt) is
    r_Calendar           Htt_Calendars%rowtype;
    r_Week_Day           Htt_Calendar_Week_Days%rowtype;
    r_Old_Day            Htt_Calendar_Days%rowtype;
    r_New_Day            Htt_Calendar_Days%rowtype;
    r_Rest_Day           Htt_Calendar_Rest_Days%rowtype;
    v_Dates              Array_Date := Array_Date();
    v_Changed_Dates      Array_Date := Array_Date();
    v_Deleted_Dates      Array_Date;
    v_Swap_Changed_Dates Array_Date := Array_Date();
    v_Swap_Deleted_Dates Array_Date;
  begin
    if not z_Htt_Calendars.Exist_Lock(i_Company_Id  => i_Calendar.Company_Id,
                                      i_Filial_Id   => i_Calendar.Filial_Id,
                                      i_Calendar_Id => i_Calendar.Calendar_Id,
                                      o_Row         => r_Calendar) then
      r_Calendar.Company_Id  := i_Calendar.Company_Id;
      r_Calendar.Filial_Id   := i_Calendar.Filial_Id;
      r_Calendar.Calendar_Id := i_Calendar.Calendar_Id;
    end if;
  
    r_Calendar.Name          := i_Calendar.Name;
    r_Calendar.Code          := i_Calendar.Code;
    r_Calendar.Monthly_Limit := i_Calendar.Monthly_Limit;
    r_Calendar.Daily_Limit   := i_Calendar.Daily_Limit;
  
    z_Htt_Calendars.Save_Row(r_Calendar);
  
    r_New_Day.Company_Id  := i_Calendar.Company_Id;
    r_New_Day.Filial_Id   := i_Calendar.Filial_Id;
    r_New_Day.Calendar_Id := i_Calendar.Calendar_Id;
  
    for i in 1 .. i_Calendar.Days.Count
    loop
      r_Old_Day               := null;
      r_New_Day.Calendar_Date := i_Calendar.Days(i).Calendar_Date;
      r_New_Day.Name          := i_Calendar.Days(i).Name;
      r_New_Day.Day_Kind      := i_Calendar.Days(i).Day_Kind;
      r_New_Day.Swapped_Date  := i_Calendar.Days(i).Swapped_Date;
    
      if not z_Htt_Calendar_Days.Exist_Lock(i_Company_Id    => r_New_Day.Company_Id,
                                            i_Filial_Id     => r_New_Day.Filial_Id,
                                            i_Calendar_Id   => r_New_Day.Calendar_Id,
                                            i_Calendar_Date => r_New_Day.Calendar_Date,
                                            o_Row           => r_Old_Day) or
         r_New_Day.Day_Kind <> r_Old_Day.Day_Kind --
         or r_New_Day.Swapped_Date <> r_Old_Day.Swapped_Date then
        Fazo.Push(v_Changed_Dates, r_New_Day.Calendar_Date);
      
        if r_Old_Day.Swapped_Date is not null then
          Fazo.Push(v_Swap_Changed_Dates, r_Old_Day.Swapped_Date);
        end if;
      end if;
    
      if Extract(year from r_New_Day.Calendar_Date) <> i_Calendar.Year then
        Htt_Error.Raise_018(i_Chosen_Year   => i_Calendar.Year,
                            i_Calendar_Date => r_New_Day.Calendar_Date);
      end if;
    
      if r_New_Day.Calendar_Date member of v_Dates then
        Htt_Error.Raise_019(r_New_Day.Calendar_Date);
      end if;
    
      z_Htt_Calendar_Days.Save_Row(r_New_Day);
    
      Fazo.Push(v_Dates, r_New_Day.Calendar_Date);
    end loop;
  
    r_Week_Day.Company_Id  := i_Calendar.Company_Id;
    r_Week_Day.Filial_Id   := i_Calendar.Filial_Id;
    r_Week_Day.Calendar_Id := i_Calendar.Calendar_Id;
  
    for i in 1 .. i_Calendar.Week_Days.Count
    loop
      r_Week_Day.Order_No        := i_Calendar.Week_Days(i).Order_No;
      r_Week_Day.Plan_Time       := i_Calendar.Week_Days(i).Plan_Time;
      r_Week_Day.Preholiday_Time := i_Calendar.Week_Days(i).Preholiday_Hour;
      r_Week_Day.Preweekend_Time := i_Calendar.Week_Days(i).Preweekend_Hour;
    
      z_Htt_Calendar_Week_Days.Save_Row(r_Week_Day);
    end loop;
  
    delete Htt_Calendar_Days q
     where q.Company_Id = i_Calendar.Company_Id
       and q.Filial_Id = i_Calendar.Filial_Id
       and q.Calendar_Id = i_Calendar.Calendar_Id
       and Extract(year from q.Calendar_Date) = i_Calendar.Year
       and q.Calendar_Date not in (select *
                                     from table(v_Dates))
    returning q.Calendar_Date, Nvl(q.Swapped_Date, q.Calendar_Date) bulk collect into v_Deleted_Dates, v_Swap_Deleted_Dates;
  
    for i in 1 .. v_Changed_Dates.Count
    loop
      r_New_Day := z_Htt_Calendar_Days.Lock_Load(i_Company_Id    => r_New_Day.Company_Id,
                                                 i_Filial_Id     => r_New_Day.Filial_Id,
                                                 i_Calendar_Id   => r_New_Day.Calendar_Id,
                                                 i_Calendar_Date => v_Changed_Dates(i));
      begin
        select q.*
          into r_Old_Day
          from Htt_Calendar_Days q
         where q.Company_Id = r_New_Day.Company_Id
           and q.Filial_Id = r_New_Day.Filial_Id
           and q.Calendar_Id = r_New_Day.Calendar_Id
           and (q.Calendar_Date = r_New_Day.Swapped_Date --
               or q.Calendar_Date <> r_New_Day.Calendar_Date and
               q.Swapped_Date = r_New_Day.Swapped_Date or q.Swapped_Date = r_New_Day.Calendar_Date)
           and Rownum = 1;
      
        if r_New_Day.Calendar_Date = r_Old_Day.Calendar_Date or
           r_New_Day.Calendar_Date = r_Old_Day.Swapped_Date then
          Htt_Error.Raise_020(r_New_Day.Calendar_Date);
        else
          Htt_Error.Raise_020(r_New_Day.Swapped_Date);
        end if;
      exception
        when No_Data_Found then
          null;
      end;
    end loop;
  
    delete Htt_Calendar_Rest_Days q
     where q.Company_Id = i_Calendar.Company_Id
       and q.Filial_Id = i_Calendar.Filial_Id
       and q.Calendar_Id = i_Calendar.Calendar_Id;
  
    for i in 1 .. i_Calendar.Rest_Days.Count
    loop
      r_Rest_Day.Company_Id  := i_Calendar.Company_Id;
      r_Rest_Day.Filial_Id   := i_Calendar.Filial_Id;
      r_Rest_Day.Calendar_Id := i_Calendar.Calendar_Id;
      r_Rest_Day.Week_Day_No := i_Calendar.Rest_Days(i);
    
      z_Htt_Calendar_Rest_Days.Insert_Row(r_Rest_Day);
    end loop;
  
    v_Deleted_Dates := v_Deleted_Dates multiset union distinct v_Swap_Deleted_Dates;
  
    v_Deleted_Dates := v_Deleted_Dates multiset union v_Swap_Changed_Dates;
  
    Htt_Core.Regen_Schedule_Days(i_Company_Id  => i_Calendar.Company_Id,
                                 i_Filial_Id   => i_Calendar.Filial_Id,
                                 i_Calendar_Id => i_Calendar.Calendar_Id,
                                 i_Dates       => v_Changed_Dates);
  
    Htt_Core.Regen_Schedule_Days(i_Company_Id  => i_Calendar.Company_Id,
                                 i_Filial_Id   => i_Calendar.Filial_Id,
                                 i_Calendar_Id => i_Calendar.Calendar_Id,
                                 i_Dates       => v_Deleted_Dates);
  
    Htt_Core.Notify_Calendar_Day_Change(i_Company_Id  => i_Calendar.Company_Id,
                                        i_Filial_Id   => i_Calendar.Filial_Id,
                                        i_Calendar_Id => i_Calendar.Calendar_Id,
                                        i_Dates       => v_Changed_Dates);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calendar_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Calendar_Id number
  ) is
    r_Calendar Htt_Calendars%rowtype;
  begin
    r_Calendar := z_Htt_Calendars.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Calendar_Id => i_Calendar_Id);
  
    if r_Calendar.Pcode is not null then
      Htt_Error.Raise_021(i_Calendar_Id);
    end if;
  
    z_Htt_Calendars.Delete_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Calendar_Id => i_Calendar_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Save(i_Schedule Htt_Pref.Schedule_Rt) is
    r_Schedule                Htt_Schedules%rowtype;
    r_Day                     Htt_Schedule_Origin_Days%rowtype;
    r_Pattern                 Htt_Schedule_Patterns%rowtype;
    r_Pattern_Day             Htt_Schedule_Pattern_Days%rowtype;
    v_Pattern_Day             Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Mark                    Htt_Pref.Mark_Rt;
    v_Marks                   Htt_Pref.Mark_Nt;
    v_Marks_Day               Htt_Pref.Schedule_Day_Marks_Rt;
    v_Weight                  Htt_Pref.Time_Weight_Rt;
    v_Weights                 Htt_Pref.Time_Weight_Nt;
    v_Weights_Day             Htt_Pref.Schedule_Day_Weights_Rt;
    v_Schedule_Days           Htt_Pref.Schedule_Day_Nt := Htt_Pref.Schedule_Day_Nt();
    v_Dates                   Array_Date := Array_Date();
    v_Calendar_Dates          Array_Date := Array_Date();
    v_Mark_Dates              Array_Date := Array_Date();
    v_Weight_Dates            Array_Date := Array_Date();
    v_Old_Calendar_Id         number;
    v_Shift_Changed           boolean := false;
    v_Borders_Changed         boolean := false;
    v_Allowed_Late_Changed    boolean := false;
    v_Allowed_Early_Changed   boolean := false;
    v_Begin_Late_Changed      boolean := false;
    v_End_Early_Changed       boolean := false;
    v_Calendar_Changed        varchar2(1) := 'N';
    v_Holidays_Changed        varchar2(1) := 'N';
    v_Additional_Rest_Changes varchar2(1) := 'N';
    v_Nonworking_Changed      varchar2(1) := 'N';
    v_Schedule_Attached       varchar2(1) := 'N';
    v_Schedule_Kind           varchar2(1) := i_Schedule.Schedule_Kind;
  begin
    if z_Htt_Schedules.Exist_Lock(i_Company_Id  => i_Schedule.Company_Id,
                                  i_Filial_Id   => i_Schedule.Filial_Id,
                                  i_Schedule_Id => i_Schedule.Schedule_Id,
                                  o_Row         => r_Schedule) then
      v_Schedule_Kind := r_Schedule.Schedule_Kind;
    
      if r_Schedule.Pcode is not null then
        Htt_Error.Raise_101(r_Schedule.Name);
      end if;
    
      begin
        select 'Y'
          into v_Schedule_Attached
          from Htt_Timesheets t
         where t.Company_Id = i_Schedule.Company_Id
           and t.Filial_Id = i_Schedule.Filial_Id
           and t.Schedule_Id = i_Schedule.Schedule_Id
           and Rownum = 1;
      exception
        when No_Data_Found then
          v_Schedule_Attached := 'N';
      end;
    
      v_Shift_Changed         := r_Schedule.Shift <> i_Schedule.Shift;
      v_Borders_Changed       := (r_Schedule.Input_Acceptance <> i_Schedule.Input_Acceptance or
                                 r_Schedule.Output_Acceptance <> i_Schedule.Output_Acceptance);
      v_Allowed_Late_Changed  := r_Schedule.Allowed_Late_Time <> i_Schedule.Allowed_Late_Time;
      v_Allowed_Early_Changed := r_Schedule.Allowed_Early_Time <> i_Schedule.Allowed_Early_Time;
      v_Begin_Late_Changed    := r_Schedule.Begin_Late_Time <> i_Schedule.Begin_Late_Time;
      v_End_Early_Changed     := r_Schedule.End_Early_Time <> i_Schedule.End_Early_Time;
    
      if v_Shift_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_022;
      end if;
    
      if v_Borders_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_023;
      end if;
    
      if v_Allowed_Late_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_113;
      end if;
    
      if v_Allowed_Early_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_114;
      end if;
    
      if v_Begin_Late_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_115;
      end if;
    
      if v_End_Early_Changed and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_116;
      end if;
    
      if r_Schedule.Track_Duration <> i_Schedule.Track_Duration and v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_024;
      end if;
    
      if (r_Schedule.Count_Late <> i_Schedule.Count_Late or
         r_Schedule.Count_Early <> i_Schedule.Count_Early or
         r_Schedule.Count_Lack <> i_Schedule.Count_Lack or
         r_Schedule.Count_Free <> i_Schedule.Count_Free or
         Nvl(r_Schedule.Gps_Turnout_Enabled, 'N') <> Nvl(i_Schedule.Gps_Turnout_Enabled, 'N') or
         Nvl(r_Schedule.Gps_Use_Location, 'N') <> Nvl(i_Schedule.Gps_Use_Location, 'N') or
         Nvl(r_Schedule.Gps_Max_Interval, 0) <> Nvl(i_Schedule.Gps_Max_Interval, 0)) and
         v_Schedule_Attached = 'Y' then
        Htt_Error.Raise_025;
      end if;
    
      v_Old_Calendar_Id := r_Schedule.Calendar_Id;
    
      if not Fazo.Equal(v_Old_Calendar_Id, i_Schedule.Calendar_Id) then
        v_Calendar_Changed := 'Y';
      end if;
    
      if v_Calendar_Changed = 'Y' or v_Old_Calendar_Id = i_Schedule.Calendar_Id and
         r_Schedule.Take_Holidays <> i_Schedule.Take_Holidays then
        v_Holidays_Changed := 'Y';
      end if;
    
      if v_Calendar_Changed = 'Y' or
         v_Old_Calendar_Id = i_Schedule.Calendar_Id and
         r_Schedule.Take_Additional_Rest_Days <> i_Schedule.Take_Additional_Rest_Days then
        v_Additional_Rest_Changes := 'Y';
      end if;
    
      if v_Calendar_Changed = 'Y' or v_Old_Calendar_Id = i_Schedule.Calendar_Id and
         r_Schedule.Take_Nonworking <> i_Schedule.Take_Nonworking then
        v_Nonworking_Changed := 'Y';
      end if;
    else
      r_Schedule.Barcode := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Schedules,
                                                i_Id    => i_Schedule.Schedule_Id);
    end if;
  
    r_Schedule.Company_Id                := i_Schedule.Company_Id;
    r_Schedule.Filial_Id                 := i_Schedule.Filial_Id;
    r_Schedule.Schedule_Id               := i_Schedule.Schedule_Id;
    r_Schedule.Name                      := i_Schedule.Name;
    r_Schedule.Schedule_Kind             := v_Schedule_Kind;
    r_Schedule.Shift                     := i_Schedule.Shift;
    r_Schedule.Input_Acceptance          := i_Schedule.Input_Acceptance;
    r_Schedule.Output_Acceptance         := i_Schedule.Output_Acceptance;
    r_Schedule.Track_Duration            := i_Schedule.Track_Duration;
    r_Schedule.Count_Late                := i_Schedule.Count_Late;
    r_Schedule.Count_Early               := i_Schedule.Count_Early;
    r_Schedule.Count_Lack                := i_Schedule.Count_Lack;
    r_Schedule.Count_Free                := i_Schedule.Count_Free;
    r_Schedule.Use_Weights               := i_Schedule.Use_Weights;
    r_Schedule.Allowed_Late_Time         := i_Schedule.Allowed_Late_Time;
    r_Schedule.Allowed_Early_Time        := i_Schedule.Allowed_Early_Time;
    r_Schedule.Begin_Late_Time           := i_Schedule.Begin_Late_Time;
    r_Schedule.End_Early_Time            := i_Schedule.End_Early_Time;
    r_Schedule.Calendar_Id               := i_Schedule.Calendar_Id;
    r_Schedule.Take_Holidays             := i_Schedule.Take_Holidays;
    r_Schedule.Take_Nonworking           := i_Schedule.Take_Nonworking;
    r_Schedule.Take_Additional_Rest_Days := i_Schedule.Take_Additional_Rest_Days;
    r_Schedule.Gps_Turnout_Enabled       := i_Schedule.Gps_Turnout_Enabled;
    r_Schedule.Gps_Use_Location          := i_Schedule.Gps_Use_Location;
    r_Schedule.Gps_Max_Interval          := i_Schedule.Gps_Max_Interval;
    r_Schedule.State                     := i_Schedule.State;
    r_Schedule.Code                      := i_Schedule.Code;
  
    if r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
      if r_Schedule.Track_Duration * 60 > Htt_Pref.c_Max_Worktime_Length then
        Htt_Error.Raise_108;
      end if;
    
      if i_Schedule.Advanced_Setting = 'Y' then
        Htt_Error.Raise_117;
      end if;
    
      r_Schedule.Shift             := 0;
      r_Schedule.Input_Acceptance  := r_Schedule.Track_Duration;
      r_Schedule.Output_Acceptance := r_Schedule.Track_Duration;
    
      r_Schedule.Count_Late  := 'N';
      r_Schedule.Count_Early := 'N';
      r_Schedule.Count_Lack  := 'N';
      r_Schedule.Count_Free  := 'N';
    
      r_Schedule.Gps_Turnout_Enabled := 'N';
    elsif r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
      r_Schedule.Shift             := null;
      r_Schedule.Input_Acceptance  := null;
      r_Schedule.Output_Acceptance := null;
      r_Schedule.Track_Duration    := Htt_Pref.c_Max_Track_Duration / 60;
    
      r_Schedule.Gps_Turnout_Enabled := 'N';
    end if;
  
    if r_Schedule.Gps_Turnout_Enabled = 'N' then
      r_Schedule.Gps_Use_Location := 'N';
      r_Schedule.Gps_Max_Interval := null;
    end if;
  
    z_Htt_Schedules.Save_Row(r_Schedule);
  
    if (v_Shift_Changed or v_Borders_Changed or v_Allowed_Late_Changed or v_Allowed_Early_Changed or
       v_Begin_Late_Changed or v_End_Early_Changed) and v_Schedule_Attached = 'N' then
      v_Schedule_Days := i_Schedule.Days;
    else
      select Td.Schedule_Date,
             Td.Day_Kind,
             Td.Begin_Time,
             Td.End_Time,
             Decode(Td.Day_Kind, Htt_Pref.c_Day_Kind_Work, Td.Break_Enabled, null),
             Td.Break_Begin_Time,
             Td.Break_End_Time,
             Td.Plan_Time
        bulk collect
        into v_Schedule_Days
        from table(i_Schedule.Days) Td
      minus
      select Od.Schedule_Date,
             Od.Day_Kind,
             (Od.Begin_Time - Trunc(Od.Begin_Time)) * 1440,
             (Od.End_Time - Trunc(Od.End_Time)) * 1440,
             Od.Break_Enabled,
             (Od.Break_Begin_Time - Trunc(Od.Break_Begin_Time)) * 1440,
             (Od.Break_End_Time - Trunc(Od.Break_End_Time)) * 1440,
             Od.Plan_Time
        from Htt_Schedule_Origin_Days Od
       where Od.Company_Id = i_Schedule.Company_Id
         and Od.Filial_Id = i_Schedule.Filial_Id
         and Od.Schedule_Id = i_Schedule.Schedule_Id
         and Extract(year from Od.Schedule_Date) = i_Schedule.Year;
    end if;
  
    for i in 1 .. v_Schedule_Days.Count
    loop
      r_Day := null;
    
      if r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
        v_Schedule_Days(i).Begin_Time := 0;
        v_Schedule_Days(i).End_Time := 0;
        v_Schedule_Days(i).Break_Enabled := 'N';
      end if;
    
      r_Day.Company_Id    := i_Schedule.Company_Id;
      r_Day.Filial_Id     := i_Schedule.Filial_Id;
      r_Day.Schedule_Id   := i_Schedule.Schedule_Id;
      r_Day.Schedule_Date := v_Schedule_Days(i).Schedule_Date;
      r_Day.Day_Kind      := v_Schedule_Days(i).Day_Kind;
      r_Day.Break_Enabled := v_Schedule_Days(i).Break_Enabled;
    
      if Extract(year from r_Day.Schedule_Date) <> i_Schedule.Year then
        Htt_Error.Raise_026(i_Chosen_Year   => i_Schedule.Year,
                            i_Schedule_Date => r_Day.Schedule_Date);
      end if;
    
      if v_Schedule_Days(i).Day_Kind = Htt_Pref.c_Day_Kind_Work then
        r_Day.Begin_Time := r_Day.Schedule_Date +
                            Numtodsinterval(v_Schedule_Days(i).Begin_Time, 'minute');
        r_Day.End_Time   := r_Day.Schedule_Date +
                            Numtodsinterval(v_Schedule_Days(i).End_Time, 'minute');
      
        if r_Day.End_Time <= r_Day.Begin_Time then
          r_Day.End_Time := r_Day.End_Time + 1;
        end if;
      
        if v_Schedule_Days(i).Break_Enabled = 'Y' then
          r_Day.Break_Begin_Time := r_Day.Schedule_Date +
                                    Numtodsinterval(v_Schedule_Days(i).Break_Begin_Time, 'minute');
          r_Day.Break_End_Time   := r_Day.Schedule_Date +
                                    Numtodsinterval(v_Schedule_Days(i).Break_End_Time, 'minute');
        
          if r_Day.Break_Begin_Time <= r_Day.Begin_Time then
            r_Day.Break_Begin_Time := r_Day.Break_Begin_Time + 1;
          end if;
        
          if r_Day.Break_End_Time <= r_Day.Break_Begin_Time then
            r_Day.Break_End_Time := r_Day.Break_End_Time + 1;
          end if;
        end if;
      
        r_Day.Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => r_Day.Day_Kind,
                                                   i_Begin_Time       => r_Day.Begin_Time,
                                                   i_End_Time         => r_Day.End_Time,
                                                   i_Break_Begin_Time => r_Day.Break_Begin_Time,
                                                   i_Break_End_Time   => r_Day.Break_End_Time);
      
        r_Day.Plan_Time := v_Schedule_Days(i).Plan_Time;
      else
        r_Day.Full_Time     := 0;
        r_Day.Plan_Time     := 0;
        r_Day.Break_Enabled := null;
      end if;
    
      r_Day.Shift_Begin_Time := r_Day.Schedule_Date + Numtodsinterval(r_Schedule.Shift, 'minute');
      r_Day.Shift_End_Time   := r_Day.Shift_Begin_Time + Numtodsinterval(86400, 'second');
      r_Day.Input_Border     := r_Day.Shift_Begin_Time -
                                Numtodsinterval(r_Schedule.Input_Acceptance, 'minute');
      r_Day.Output_Border    := r_Day.Shift_End_Time +
                                Numtodsinterval(r_Schedule.Output_Acceptance, 'minute');
    
      z_Htt_Schedule_Origin_Days.Save_Row(r_Day);
    
      Fazo.Push(v_Dates, r_Day.Schedule_Date);
    end loop;
  
    r_Pattern.Company_Id     := i_Schedule.Company_Id;
    r_Pattern.Filial_Id      := i_Schedule.Filial_Id;
    r_Pattern.Schedule_Id    := i_Schedule.Schedule_Id;
    r_Pattern.Schedule_Kind  := i_Schedule.Pattern.Pattern_Kind;
    r_Pattern.All_Days_Equal := i_Schedule.Pattern.All_Days_Equal;
    r_Pattern.Count_Days     := i_Schedule.Pattern.Count_Days;
    r_Pattern.Begin_Date     := i_Schedule.Pattern.Begin_Date;
    r_Pattern.End_Date       := i_Schedule.Pattern.End_Date;
  
    z_Htt_Schedule_Patterns.Save_Row(r_Pattern);
  
    delete Htt_Schedule_Pattern_Days t
     where t.Company_Id = i_Schedule.Company_Id
       and t.Filial_Id = i_Schedule.Filial_Id
       and t.Schedule_Id = i_Schedule.Schedule_Id;
  
    for i in 1 .. i_Schedule.Pattern.Pattern_Day.Count
    loop
      r_Pattern_Day := null;
      v_Pattern_Day := i_Schedule.Pattern.Pattern_Day(i);
    
      r_Pattern_Day.Company_Id  := i_Schedule.Company_Id;
      r_Pattern_Day.Filial_Id   := i_Schedule.Filial_Id;
      r_Pattern_Day.Schedule_Id := i_Schedule.Schedule_Id;
      r_Pattern_Day.Day_No      := v_Pattern_Day.Day_No;
      r_Pattern_Day.Day_Kind    := v_Pattern_Day.Day_Kind;
      r_Pattern_Day.Plan_Time   := v_Pattern_Day.Plan_Time;
    
      if v_Pattern_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work then
        r_Pattern_Day.Begin_Time    := v_Pattern_Day.Begin_Time;
        r_Pattern_Day.End_Time      := v_Pattern_Day.End_Time;
        r_Pattern_Day.Break_Enabled := v_Pattern_Day.Break_Enabled;
      
        if r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
          r_Pattern_Day.Begin_Time    := 0;
          r_Pattern_Day.End_Time      := 0;
          r_Pattern_Day.Break_Enabled := 'N';
        end if;
      
        if v_Pattern_Day.Break_Enabled = 'Y' then
          r_Pattern_Day.Break_Begin_Time := v_Pattern_Day.Break_Begin_Time;
          r_Pattern_Day.Break_End_Time   := v_Pattern_Day.Break_End_Time;
        end if;
      else
        r_Pattern_Day.Plan_Time := 0;
      end if;
    
      z_Htt_Schedule_Pattern_Days.Save_Row(r_Pattern_Day);
    
      if v_Pattern_Day.End_Time <= v_Pattern_Day.Begin_Time then
        v_Pattern_Day.End_Time := v_Pattern_Day.End_Time + 1440;
      end if;
    
      for j in 1 .. v_Pattern_Day.Pattern_Marks.Count
      loop
        exit when r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly;
      
        v_Mark := v_Pattern_Day.Pattern_Marks(j);
      
        if v_Mark.Begin_Time < v_Pattern_Day.Begin_Time then
          v_Mark.Begin_Time := v_Mark.Begin_Time + 1440;
          v_Mark.End_Time   := v_Mark.End_Time + 1440;
        end if;
      
        if v_Mark.End_Time < v_Mark.Begin_Time then
          v_Mark.End_Time := v_Mark.End_Time + 1440;
        end if;
      
        if v_Mark.Begin_Time = v_Mark.End_Time then
          Htt_Error.Raise_027(v_Pattern_Day.Day_No);
        end if;
      
        if v_Mark.End_Time > v_Pattern_Day.End_Time then
          Htt_Error.Raise_028(i_Day_No          => v_Pattern_Day.Day_No,
                              i_Begin_Time_Text => Htt_Util.To_Time(mod(v_Pattern_Day.Begin_Time,
                                                                        1440)),
                              i_End_Time_Text   => Htt_Util.To_Time(mod(v_Pattern_Day.End_Time, 1440)));
        end if;
      
        if v_Pattern_Day.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
          Htt_Error.Raise_029(v_Pattern_Day.Day_No);
        end if;
      
        z_Htt_Schedule_Pattern_Marks.Insert_One(i_Company_Id  => i_Schedule.Company_Id,
                                                i_Filial_Id   => i_Schedule.Filial_Id,
                                                i_Schedule_Id => i_Schedule.Schedule_Id,
                                                i_Day_No      => v_Pattern_Day.Day_No,
                                                i_Begin_Time  => v_Mark.Begin_Time,
                                                i_End_Time    => v_Mark.End_Time);
      end loop;
    
      for j in 1 .. v_Pattern_Day.Pattern_Weights.Count
      loop
        exit when r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly;
        continue when v_Pattern_Day.Day_Kind <> Htt_Pref.c_Day_Kind_Work;
      
        v_Weight := v_Pattern_Day.Pattern_Weights(j);
      
        if v_Weight.Begin_Time < v_Pattern_Day.Begin_Time then
          v_Weight.Begin_Time := v_Weight.Begin_Time + 1440;
          v_Weight.End_Time   := v_Weight.End_Time + 1440;
        end if;
      
        if v_Weight.End_Time < v_Weight.Begin_Time then
          v_Weight.End_Time := v_Weight.End_Time + 1440;
        end if;
      
        if v_Weight.Begin_Time = v_Weight.End_Time then
          Htt_Error.Raise_124(v_Pattern_Day.Day_No);
        end if;
      
        if v_Weight.End_Time > v_Pattern_Day.End_Time then
          Htt_Error.Raise_125(i_Day_No          => v_Pattern_Day.Day_No,
                              i_Begin_Time_Text => Htt_Util.To_Time(mod(v_Pattern_Day.Begin_Time,
                                                                        1440)),
                              i_End_Time_Text   => Htt_Util.To_Time(mod(v_Pattern_Day.End_Time, 1440)));
        end if;
      
        z_Htt_Schedule_Pattern_Weights.Insert_One(i_Company_Id  => i_Schedule.Company_Id,
                                                  i_Filial_Id   => i_Schedule.Filial_Id,
                                                  i_Schedule_Id => i_Schedule.Schedule_Id,
                                                  i_Day_No      => v_Pattern_Day.Day_No,
                                                  i_Begin_Time  => v_Weight.Begin_Time,
                                                  i_End_Time    => v_Weight.End_Time,
                                                  i_Weight      => v_Weight.Weight);
      end loop;
    end loop;
  
    for i in 1 .. i_Schedule.Marks.Count
    loop
      exit when r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly;
    
      v_Marks_Day := i_Schedule.Marks(i);
    
      -- symmetric differrence
      with Old_Marks as
       (select mod(Dm.Begin_Time, 1440) Begin_Time, mod(Dm.End_Time, 1440) End_Time
          from Htt_Schedule_Origin_Day_Marks Dm
         where Dm.Company_Id = i_Schedule.Company_Id
           and Dm.Filial_Id = i_Schedule.Filial_Id
           and Dm.Schedule_Id = i_Schedule.Schedule_Id
           and Dm.Schedule_Date = v_Marks_Day.Schedule_Date),
      New_Marks as
       (select m.Begin_Time, m.End_Time
          from table(v_Marks_Day.Marks) m)
      select Begin_Time, End_Time
        bulk collect
        into v_Marks
        from (select Om.Begin_Time, Om.End_Time
                from Old_Marks Om
              union
              select Nm.Begin_Time, Nm.End_Time
                from New_Marks Nm)
      minus
      select Begin_Time, End_Time
        from (select Om.Begin_Time, Om.End_Time
                from Old_Marks Om
              intersect
              select Nm.Begin_Time, Nm.End_Time
                from New_Marks Nm);
    
      if v_Marks.Count > 0 then
        delete Htt_Schedule_Origin_Day_Marks Dm
         where Dm.Company_Id = i_Schedule.Company_Id
           and Dm.Filial_Id = i_Schedule.Filial_Id
           and Dm.Schedule_Id = i_Schedule.Schedule_Id
           and Dm.Schedule_Date = v_Marks_Day.Schedule_Date;
      
        if v_Marks_Day.End_Time <= v_Marks_Day.Begin_Time then
          v_Marks_Day.End_Time := v_Marks_Day.End_Time + 1440;
        end if;
      
        for j in 1 .. v_Marks_Day.Marks.Count
        loop
          v_Mark := v_Marks_Day.Marks(j);
        
          if v_Mark.Begin_Time < v_Marks_Day.Begin_Time then
            v_Mark.Begin_Time := v_Mark.Begin_Time + 1440;
            v_Mark.End_Time   := v_Mark.End_Time + 1440;
          end if;
        
          if v_Mark.End_Time < v_Mark.Begin_Time then
            v_Mark.End_Time := v_Mark.End_Time + 1440;
          end if;
        
          if v_Mark.Begin_Time = v_Mark.End_Time then
            Htt_Error.Raise_030(v_Marks_Day.Schedule_Date);
          end if;
        
          if v_Mark.End_Time > v_Marks_Day.End_Time then
            Htt_Error.Raise_031(i_Schedule_Date   => v_Marks_Day.Schedule_Date,
                                i_Begin_Time_Text => Htt_Util.To_Time(mod(v_Marks_Day.Begin_Time,
                                                                          1440)),
                                i_End_Time_Text   => Htt_Util.To_Time(mod(v_Marks_Day.End_Time, 1440)));
          end if;
        
          z_Htt_Schedule_Origin_Day_Marks.Insert_One(i_Company_Id    => i_Schedule.Company_Id,
                                                     i_Filial_Id     => i_Schedule.Filial_Id,
                                                     i_Schedule_Id   => i_Schedule.Schedule_Id,
                                                     i_Schedule_Date => v_Marks_Day.Schedule_Date,
                                                     i_Begin_Time    => v_Mark.Begin_Time,
                                                     i_End_Time      => v_Mark.End_Time);
        end loop;
      
        Fazo.Push(v_Mark_Dates, v_Marks_Day.Schedule_Date);
      end if;
    end loop;
  
    for i in 1 .. i_Schedule.Weights.Count
    loop
      exit when r_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly;
    
      v_Weights_Day := i_Schedule.Weights(i);
    
      -- symmetric differrence
      with Old_Weights as
       (select mod(Dm.Begin_Time, 1440) Begin_Time, mod(Dm.End_Time, 1440) End_Time, Dm.Weight
          from Htt_Schedule_Origin_Day_Weights Dm
         where Dm.Company_Id = i_Schedule.Company_Id
           and Dm.Filial_Id = i_Schedule.Filial_Id
           and Dm.Schedule_Id = i_Schedule.Schedule_Id
           and Dm.Schedule_Date = v_Weights_Day.Schedule_Date),
      New_Weights as
       (select m.Begin_Time, m.End_Time, m.Weight
          from table(v_Weights_Day.Weights) m)
      select Begin_Time, End_Time, Weight
        bulk collect
        into v_Weights
        from (select Om.Begin_Time, Om.End_Time, Om.Weight
                from Old_Weights Om
              union
              select Nm.Begin_Time, Nm.End_Time, Nm.Weight
                from New_Weights Nm)
      minus
      select Begin_Time, End_Time, Weight
        from (select Om.Begin_Time, Om.End_Time, Om.Weight
                from Old_Weights Om
              intersect
              select Nm.Begin_Time, Nm.End_Time, Nm.Weight
                from New_Weights Nm);
    
      if v_Weights.Count > 0 then
        delete Htt_Schedule_Origin_Day_Weights Dm
         where Dm.Company_Id = i_Schedule.Company_Id
           and Dm.Filial_Id = i_Schedule.Filial_Id
           and Dm.Schedule_Id = i_Schedule.Schedule_Id
           and Dm.Schedule_Date = v_Weights_Day.Schedule_Date;
      
        if v_Weights_Day.End_Time <= v_Weights_Day.Begin_Time then
          v_Weights_Day.End_Time := v_Weights_Day.End_Time + 1440;
        end if;
      
        for j in 1 .. v_Weights_Day.Weights.Count
        loop
          v_Weight := v_Weights_Day.Weights(j);
        
          if v_Weight.Begin_Time < v_Weights_Day.Begin_Time then
            v_Weight.Begin_Time := v_Weight.Begin_Time + 1440;
            v_Weight.End_Time   := v_Weight.End_Time + 1440;
          end if;
        
          if v_Weight.End_Time < v_Weight.Begin_Time then
            v_Weight.End_Time := v_Weight.End_Time + 1440;
          end if;
        
          if v_Weight.Begin_Time = v_Weight.End_Time then
            Htt_Error.Raise_126(v_Weights_Day.Schedule_Date);
          end if;
        
          if v_Weight.End_Time > v_Weights_Day.End_Time then
            Htt_Error.Raise_127(i_Schedule_Date   => v_Weights_Day.Schedule_Date,
                                i_Begin_Time_Text => Htt_Util.To_Time(mod(v_Weights_Day.Begin_Time,
                                                                          1440)),
                                i_End_Time_Text   => Htt_Util.To_Time(mod(v_Weights_Day.End_Time,
                                                                          1440)));
          end if;
        
          z_Htt_Schedule_Origin_Day_Weights.Insert_One(i_Company_Id    => i_Schedule.Company_Id,
                                                       i_Filial_Id     => i_Schedule.Filial_Id,
                                                       i_Schedule_Id   => i_Schedule.Schedule_Id,
                                                       i_Schedule_Date => v_Weights_Day.Schedule_Date,
                                                       i_Begin_Time    => v_Weight.Begin_Time,
                                                       i_End_Time      => v_Weight.End_Time,
                                                       i_Weight        => v_Weight.Weight);
        end loop;
      
        Fazo.Push(v_Weight_Dates, v_Weights_Day.Schedule_Date);
      end if;
    end loop;
  
    if Md_Pref.c_Migr_Company_Id != i_Schedule.Company_Id then
      Htt_Util.Assert_Schedule_Marks(i_Company_Id  => i_Schedule.Company_Id,
                                     i_Filial_Id   => i_Schedule.Filial_Id,
                                     i_Schedule_Id => i_Schedule.Schedule_Id,
                                     i_Dates       => v_Mark_Dates);
    
      Htt_Util.Assert_Schedule_Weights(i_Company_Id  => i_Schedule.Company_Id,
                                       i_Filial_Id   => i_Schedule.Filial_Id,
                                       i_Schedule_Id => i_Schedule.Schedule_Id,
                                       i_Dates       => v_Weight_Dates);
    end if;
  
    select Cd.Calendar_Date
      bulk collect
      into v_Calendar_Dates
      from Htt_Calendar_Days Cd
     where Cd.Company_Id = i_Schedule.Company_Id
       and Cd.Filial_Id = i_Schedule.Filial_Id
       and Cd.Calendar_Id in (v_Old_Calendar_Id, i_Schedule.Calendar_Id)
       and (Cd.Day_Kind = Htt_Pref.c_Day_Kind_Swapped and v_Calendar_Changed = 'Y' or
           Cd.Day_Kind = Htt_Pref.c_Day_Kind_Holiday and v_Holidays_Changed = 'Y' or
           Cd.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest and v_Additional_Rest_Changes = 'Y' or
           Cd.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking and v_Nonworking_Changed = 'Y');
  
    v_Dates := v_Dates multiset union v_Calendar_Dates;
    v_Dates := v_Dates multiset union v_Mark_Dates;
    v_Dates := v_Dates multiset union distinct v_Weight_Dates;
  
    Htt_Core.Regen_Schedule_Days(i_Company_Id  => i_Schedule.Company_Id,
                                 i_Filial_Id   => i_Schedule.Filial_Id,
                                 i_Schedule_Id => i_Schedule.Schedule_Id,
                                 i_Year        => i_Schedule.Year,
                                 i_Dates       => v_Dates);
  
    Htt_Util.Check_Schedule_By_Calendar(i_Company_Id  => i_Schedule.Company_Id,
                                        i_Filial_Id   => i_Schedule.Filial_Id,
                                        i_Schedule_Id => i_Schedule.Schedule_Id,
                                        i_Calendar_Id => i_Schedule.Calendar_Id,
                                        i_Year_Begin  => to_date('01.01.' || i_Schedule.Year,
                                                                 'DD.MM.YYYY'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number
  ) is
    r_Schedule Htt_Schedules%rowtype;
  begin
    if z_Htt_Schedules.Exist_Lock(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Schedule_Id => i_Schedule_Id,
                                  o_Row         => r_Schedule) then
      if r_Schedule.Pcode is not null then
        Htt_Error.Raise_102(r_Schedule.Name);
      end if;
    
      z_Htt_Schedules.Delete_One(i_Company_Id  => i_Company_Id,
                                 i_Filial_Id   => i_Filial_Id,
                                 i_Schedule_Id => i_Schedule_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Save(i_Schedule_Template Htt_Pref.Schedule_Template_Rt) is
    r_Schedule_Template Htt_Schedule_Templates%rowtype;
    r_Pattern_Day       Htt_Schedule_Template_Days%rowtype;
    v_Pattern_Day       Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Mark              Htt_Pref.Mark_Rt;
    v_Mark_Day_Numbers  Array_Number := Array_Number();
  begin
    r_Schedule_Template.Template_Id               := i_Schedule_Template.Template_Id;
    r_Schedule_Template.Name                      := i_Schedule_Template.Name;
    r_Schedule_Template.Shift                     := i_Schedule_Template.Shift;
    r_Schedule_Template.Description               := i_Schedule_Template.Description;
    r_Schedule_Template.Schedule_Kind             := i_Schedule_Template.Schedule_Kind;
    r_Schedule_Template.All_Days_Equal            := i_Schedule_Template.All_Days_Equal;
    r_Schedule_Template.Count_Days                := i_Schedule_Template.Count_Days;
    r_Schedule_Template.Input_Acceptance          := i_Schedule_Template.Input_Acceptance;
    r_Schedule_Template.Output_Acceptance         := i_Schedule_Template.Output_Acceptance;
    r_Schedule_Template.Track_Duration            := i_Schedule_Template.Track_Duration;
    r_Schedule_Template.Count_Late                := i_Schedule_Template.Count_Late;
    r_Schedule_Template.Count_Early               := i_Schedule_Template.Count_Early;
    r_Schedule_Template.Count_Lack                := i_Schedule_Template.Count_Lack;
    r_Schedule_Template.Take_Holidays             := i_Schedule_Template.Take_Holidays;
    r_Schedule_Template.Take_Nonworking           := i_Schedule_Template.Take_Nonworking;
    r_Schedule_Template.Take_Additional_Rest_Days := i_Schedule_Template.Take_Additional_Rest_Days;
    r_Schedule_Template.Order_No                  := i_Schedule_Template.Order_No;
    r_Schedule_Template.State                     := i_Schedule_Template.State;
    r_Schedule_Template.Code                      := i_Schedule_Template.Code;
  
    z_Htt_Schedule_Templates.Save_Row(r_Schedule_Template);
  
    for i in 1 .. i_Schedule_Template.Pattern_Days.Count
    loop
      r_Pattern_Day := null;
      v_Pattern_Day := i_Schedule_Template.Pattern_Days(i);
    
      r_Pattern_Day.Template_Id := i_Schedule_Template.Template_Id;
      r_Pattern_Day.Day_No      := v_Pattern_Day.Day_No;
      r_Pattern_Day.Day_Kind    := v_Pattern_Day.Day_Kind;
      r_Pattern_Day.Plan_Time   := v_Pattern_Day.Plan_Time;
    
      if v_Pattern_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work then
        r_Pattern_Day.Begin_Time    := v_Pattern_Day.Begin_Time;
        r_Pattern_Day.End_Time      := v_Pattern_Day.End_Time;
        r_Pattern_Day.Break_Enabled := v_Pattern_Day.Break_Enabled;
      
        if v_Pattern_Day.Break_Enabled = 'Y' then
          r_Pattern_Day.Break_Begin_Time := v_Pattern_Day.Break_Begin_Time;
          r_Pattern_Day.Break_End_Time   := v_Pattern_Day.Break_End_Time;
        end if;
      else
        r_Pattern_Day.Plan_Time := 0;
      end if;
    
      z_Htt_Schedule_Template_Days.Save_Row(r_Pattern_Day);
    
      for j in 1 .. v_Pattern_Day.Pattern_Marks.Count
      loop
        v_Mark := v_Pattern_Day.Pattern_Marks(j);
      
        if v_Mark.Begin_Time < i_Schedule_Template.Shift then
          v_Mark.Begin_Time := v_Mark.Begin_Time + 1440;
        end if;
      
        if v_Mark.End_Time < v_Mark.Begin_Time then
          v_Mark.End_Time := v_Mark.End_Time + 1440;
        end if;
      
        if v_Mark.Begin_Time = v_Mark.End_Time then
          Htt_Error.Raise_032(v_Pattern_Day.Day_No);
        end if;
      
        if v_Mark.End_Time > i_Schedule_Template.Shift + 1440 then
          Htt_Error.Raise_033(i_Day_No     => v_Pattern_Day.Day_No,
                              i_Shift_Text => Htt_Util.To_Time_Text(i_Minutes      => i_Schedule_Template.Shift,
                                                                    i_Show_Minutes => true,
                                                                    i_Show_Words   => false));
        end if;
      
        if v_Pattern_Day.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
          Htt_Error.Raise_034(v_Pattern_Day.Day_No);
        end if;
      
        z_Htt_Schedule_Template_Marks.Save_One(i_Template_Id => i_Schedule_Template.Template_Id,
                                               i_Day_No      => v_Pattern_Day.Day_No,
                                               i_Begin_Time  => v_Mark.Begin_Time,
                                               i_End_Time    => v_Mark.End_Time);
      
        Fazo.Push(v_Mark_Day_Numbers, v_Pattern_Day.Day_No);
      end loop;
    end loop;
  
    Htt_Util.Assert_Schedule_Template_Marks(i_Template_Id => i_Schedule_Template.Template_Id,
                                            i_Day_Numbers => v_Mark_Day_Numbers);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Template_Delete(i_Template_Id number) is
  begin
    z_Htt_Schedule_Templates.Delete_One(i_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Save(i_Time_Kind Htt_Time_Kinds%rowtype) is
    r_Time_Kind   Htt_Time_Kinds%rowtype;
    r_Parent      Htt_Time_Kinds%rowtype;
    v_Pcode       Htt_Time_Kinds.Pcode%type;
    v_Requestable Htt_Time_Kinds.Requestable%type := 'Y';
  begin
    if z_Htt_Time_Kinds.Exist_Lock(i_Company_Id   => i_Time_Kind.Company_Id,
                                   i_Time_Kind_Id => i_Time_Kind.Time_Kind_Id,
                                   o_Row          => r_Time_Kind) then
    
      if r_Time_Kind.Parent_Id <> i_Time_Kind.Parent_Id or
         (r_Time_Kind.Parent_Id is not null and i_Time_Kind.Parent_Id is null) then
        Htt_Error.Raise_035(z_Htt_Time_Kinds.Load(i_Company_Id => r_Time_Kind.Company_Id, --
                            i_Time_Kind_Id => r_Time_Kind.Parent_Id).Name);
      end if;
    
      v_Pcode       := r_Time_Kind.Pcode;
      v_Requestable := r_Time_Kind.Requestable;
    
      if v_Pcode is not null then
        if i_Time_Kind.Parent_Id is not null and r_Time_Kind.Parent_Id is null then
          Htt_Error.Raise_036;
        end if;
      
        if r_Time_Kind.Plan_Load <> i_Time_Kind.Plan_Load then
          Htt_Error.Raise_037(Htt_Util.t_Plan_Load(r_Time_Kind.Plan_Load));
        end if;
      
        if r_Time_Kind.Requestable <> i_Time_Kind.Requestable then
          Htt_Error.Raise_038;
        end if;
      end if;
    end if;
  
    if v_Pcode is null then
      if i_Time_Kind.Parent_Id is null then
        Htt_Error.Raise_039;
      end if;
    
      if i_Time_Kind.Requestable = 'N' then
        Htt_Error.Raise_040;
      end if;
    
      r_Parent := z_Htt_Time_Kinds.Take(i_Company_Id   => i_Time_Kind.Company_Id,
                                        i_Time_Kind_Id => i_Time_Kind.Parent_Id);
    
      if r_Parent.Pcode is null then
        Htt_Error.Raise_041;
      end if;
    
      if r_Parent.Parent_Id is not null then
        Htt_Error.Raise_042;
      end if;
    end if;
  
    if i_Time_Kind.Plan_Load <> r_Parent.Plan_Load then
      Htt_Error.Raise_043(Htt_Util.t_Plan_Load(r_Parent.Plan_Load));
    end if;
  
    r_Time_Kind             := i_Time_Kind;
    r_Time_Kind.Pcode       := v_Pcode;
    r_Time_Kind.Requestable := v_Requestable;
  
    z_Htt_Time_Kinds.Save_Row(r_Time_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Delete
  (
    i_Company_Id   number,
    i_Time_Kind_Id number
  ) is
    r_Time_Kind Htt_Time_Kinds%rowtype;
  begin
    r_Time_Kind := z_Htt_Time_Kinds.Lock_Load(i_Company_Id   => i_Company_Id,
                                              i_Time_Kind_Id => i_Time_Kind_Id);
  
    if r_Time_Kind.Pcode is not null then
      Htt_Error.Raise_044(i_Time_Kind_Id);
    end if;
  
    z_Htt_Time_Kinds.Delete_One(i_Company_Id   => i_Company_Id, --
                                i_Time_Kind_Id => i_Time_Kind_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save(i_Person Htt_Pref.Person_Rt) is
    r_Person_Old Htt_Persons%rowtype;
    r_Person_New Htt_Persons%rowtype;
    v_Photo_Shas Array_Varchar2 := Array_Varchar2();
    v_Count      number;
  begin
    if z_Htt_Persons.Exist_Lock(i_Company_Id => i_Person.Company_Id,
                                i_Person_Id  => i_Person.Person_Id,
                                o_Row        => r_Person_Old) then
      null;
    end if;
  
    r_Person_New.Company_Id := i_Person.Company_Id;
    r_Person_New.Person_Id  := i_Person.Person_Id;
    r_Person_New.Pin        := i_Person.Pin;
    r_Person_New.Pin_Code   := i_Person.Pin_Code;
    r_Person_New.Rfid_Code  := i_Person.Rfid_Code;
    r_Person_New.Qr_Code    := i_Person.Qr_Code;
  
    z_Htt_Persons.Save_Row(r_Person_New);
  
    v_Photo_Shas.Extend(i_Person.Photos.Count);
  
    for i in 1 .. i_Person.Photos.Count
    loop
      v_Photo_Shas(i) := i_Person.Photos(i).Photo_Sha;
    
      Person_Save_Photo(i_Company_Id => i_Person.Company_Id,
                        i_Person_Id  => i_Person.Person_Id,
                        i_Photo_Sha  => i_Person.Photos(i).Photo_Sha,
                        i_Is_Main    => i_Person.Photos(i).Is_Main);
    end loop;
  
    for r in (select *
                from Htt_Person_Photos q
               where q.Company_Id = i_Person.Company_Id
                 and q.Person_Id = i_Person.Person_Id
                 and q.Photo_Sha not member of v_Photo_Shas)
    loop
      z_Htt_Person_Photos.Delete_One(i_Company_Id => r.Company_Id,
                                     i_Person_Id  => r.Person_Id,
                                     i_Photo_Sha  => r.Photo_Sha);
    end loop;
  
    select count(*)
      into v_Count
      from Htt_Person_Photos q
     where q.Company_Id = i_Person.Company_Id
       and q.Person_Id = i_Person.Person_Id
       and q.Is_Main = 'Y';
  
    if v_Count > 1 then
      Htt_Error.Raise_045(i_Main_Photo_Cnt => v_Count,
                          i_Person_Name    => z_Mr_Natural_Persons.Load(i_Company_Id => i_Person.Company_Id, --
                                              i_Person_Id => i_Person.Person_Id).Name);
    end if;
  
    if not (Fazo.Equal(r_Person_New.Pin, r_Person_Old.Pin) and
        Fazo.Equal(r_Person_New.Pin_Code, r_Person_Old.Pin_Code) and
        Fazo.Equal(r_Person_New.Rfid_Code, r_Person_Old.Rfid_Code) and
        Fazo.Equal(r_Person_New.Qr_Code, r_Person_Old.Qr_Code)) then
      Htt_Core.Make_Dirty_Person(i_Company_Id => i_Person.Company_Id,
                                 i_Person_Id  => i_Person.Person_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Photo_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Photo_Sha  varchar2
  ) is
  begin
    if z_Htt_Person_Photos.Exist_Lock(i_Company_Id => i_Company_Id,
                                      i_Person_Id  => i_Person_Id,
                                      i_Photo_Sha  => i_Photo_Sha) then
      z_Htt_Person_Photos.Delete_One(i_Company_Id => i_Company_Id,
                                     i_Person_Id  => i_Person_Id,
                                     i_Photo_Sha  => i_Photo_Sha);
    
      Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save_Photo
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Photo_Sha  varchar2,
    i_Is_Main    varchar2
  ) is
    r_Person_Photo Htt_Person_Photos%rowtype;
  begin
    if z_Htt_Person_Photos.Exist_Lock(i_Company_Id => i_Company_Id,
                                      i_Person_Id  => i_Person_Id,
                                      i_Photo_Sha  => i_Photo_Sha,
                                      o_Row        => r_Person_Photo) then
      z_Htt_Person_Photos.Update_One(i_Company_Id => i_Company_Id,
                                     i_Person_Id  => i_Person_Id,
                                     i_Photo_Sha  => i_Photo_Sha,
                                     i_Is_Main    => Option_Varchar2(i_Is_Main));
    else
      z_Htt_Person_Photos.Insert_One(i_Company_Id => i_Company_Id,
                                     i_Person_Id  => i_Person_Id,
                                     i_Photo_Sha  => i_Photo_Sha,
                                     i_Is_Main    => i_Is_Main);
    end if;
  
    if r_Person_Photo.Company_Id is null or r_Person_Photo.Is_Main <> i_Is_Main then
      Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Photo_Update
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Old_Photo_Sha varchar2,
    i_New_Photo_Sha varchar2
  ) is
    v_Is_Main varchar2(1);
  
    --------------------------------------------------
    Function Photo_Exists return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Person_Photos Pp
       where Pp.Company_Id = i_Company_Id
         and Pp.Person_Id = i_Person_Id
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    v_Is_Main := z_Htt_Person_Photos.Take(i_Company_Id => i_Company_Id, --
                 i_Person_Id => i_Person_Id, --
                 i_Photo_Sha => i_Old_Photo_Sha).Is_Main;
  
    Person_Photo_Delete(i_Company_Id => i_Company_Id,
                        i_Person_Id  => i_Person_Id,
                        i_Photo_Sha  => i_Old_Photo_Sha);
  
    if not Photo_Exists then
      v_Is_Main := 'Y';
    end if;
  
    if i_New_Photo_Sha is not null then
      Person_Save_Photo(i_Company_Id => i_Company_Id,
                        i_Person_Id  => i_Person_Id,
                        i_Photo_Sha  => i_New_Photo_Sha,
                        i_Is_Main    => Nvl(v_Is_Main, 'N'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    z_Htt_Persons.Delete_One(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Save(i_Location_Type Htt_Location_Types%rowtype) is
  begin
    z_Htt_Location_Types.Save_Row(i_Location_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Delete
  (
    i_Company_Id       number,
    i_Location_Type_Id number
  ) is
  begin
    z_Htt_Location_Types.Delete_One(i_Company_Id       => i_Company_Id,
                                    i_Location_Type_Id => i_Location_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Polygon_Save
  (
    i_Company_Id       number,
    i_Location_Id      number,
    i_Polygon_Vertices Array_Varchar2
  ) is
    v_Order_No         number := 0;
    v_Polygon_Vertices Array_Varchar2 := i_Polygon_Vertices;
  begin
    delete from Htt_Location_Polygon_Vertices t
     where t.Company_Id = i_Company_Id
       and t.Location_Id = i_Location_Id;
  
    if v_Polygon_Vertices.Count > 0 and
       v_Polygon_Vertices(v_Polygon_Vertices.Count) <> v_Polygon_Vertices(1) then
      v_Polygon_Vertices.Extend;
      v_Polygon_Vertices(v_Polygon_Vertices.Count) := v_Polygon_Vertices(1);
    end if;
  
    for i in 1 .. v_Polygon_Vertices.Count
    loop
      v_Order_No := v_Order_No + 1;
    
      z_Htt_Location_Polygon_Vertices.Insert_One(i_Company_Id  => i_Company_Id,
                                                 i_Location_Id => i_Location_Id,
                                                 i_Order_No    => v_Order_No,
                                                 i_Latlng      => v_Polygon_Vertices(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Save
  (
    i_Location         Htt_Locations%rowtype,
    i_Polygon_Vertices Array_Varchar2 := Array_Varchar2()
  ) is
    r_Row             Htt_Locations%rowtype;
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
  begin
    if z_Htt_Locations.Exist_Lock(i_Company_Id  => i_Location.Company_Id,
                                  i_Location_Id => i_Location.Location_Id,
                                  o_Row         => r_Row) then
      z_Htt_Locations.Update_Row(i_Location);
    
      if not Fazo.Equal(r_Row.Timezone_Code, i_Location.Timezone_Code) then
        v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
        v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
      
        for r in (select q.Device_Id
                    from Htt_Devices q
                   where q.Company_Id = i_Location.Company_Id
                     and q.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                     and q.Location_Id = i_Location.Location_Id
                     and q.State = 'A')
        loop
          Htt_Api.Acms_Command_Add(i_Company_Id   => i_Location.Company_Id,
                                   i_Device_Id    => r.Device_Id,
                                   i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Device);
        end loop;
      end if;
    else
      z_Htt_Locations.Insert_Row(i_Location);
    end if;
  
    Location_Polygon_Save(i_Company_Id       => i_Location.Company_Id,
                          i_Location_Id      => i_Location.Location_Id,
                          i_Polygon_Vertices => i_Polygon_Vertices);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Delete
  (
    i_Company_Id  number,
    i_Location_Id number
  ) is
  begin
    z_Htt_Locations.Delete_One(i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Filial
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  ) is
  begin
    z_Htt_Location_Filials.Insert_Try(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Location_Id => i_Location_Id);
  
    if Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id) = 'Y' then
      Htt_Core.Location_Global_Sync_All_Persons(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Location_Id => i_Location_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Location_Remove_Filial
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  ) is
  begin
    z_Htt_Location_Filials.Delete_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Location_Id => i_Location_Id);
  
    for r in (select q.Company_Id, q.Device_Id
                from Htt_Devices q
               where q.Company_Id = i_Company_Id
                 and q.Location_Id = i_Location_Id
                 and exists (select 1
                        from Hzk_Devices Dv
                       where Dv.Company_Id = q.Company_Id
                         and Dv.Device_Id = q.Device_Id))
    loop
      Hzk_Api.Device_Sync(i_Company_Id => r.Company_Id, i_Device_Id => r.Device_Id);
    end loop;
  
    if Htt_Util.Location_Sync_Global_Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id) = 'Y' then
      Htt_Core.Location_Global_Sync_All_Persons(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Location_Id => i_Location_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  ) is
  begin
    Htt_Core.Location_Add_Person(i_Company_Id  => i_Company_Id,
                                 i_Filial_Id   => i_Filial_Id,
                                 i_Location_Id => i_Location_Id,
                                 i_Person_Id   => i_Person_Id,
                                 i_Attach_Type => Htt_Pref.c_Attach_Type_Manual);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Person_Id   number
  ) is
  begin
    Htt_Core.Location_Remove_Person(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Location_Id => i_Location_Id,
                                    i_Person_Id   => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Persons
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number
  ) is
  begin
    Htt_Core.Location_Sync_Persons(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Location_Id => i_Location_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Global_Sync_Location_Persons
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    Htt_Core.Global_Sync_Location_Persons(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Global_Sync_All_Location
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  ) is
  begin
    Htt_Core.Person_Global_Sync_All_Location(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Person_Id  => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Add_Division
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Division_Id number
  ) is
  begin
    z_Htt_Location_Divisions.Insert_Try(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Location_Id => i_Location_Id,
                                        i_Division_Id => i_Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Remove_Division
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Location_Id number,
    i_Division_Id number
  ) is
  begin
    z_Htt_Location_Divisions.Delete_One(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Location_Id => i_Location_Id,
                                        i_Division_Id => i_Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Location_Qr_Code_Deactivate
  (
    i_Company_Id number,
    i_Unique_Key varchar2
  ) is
    r_Qrcode Htt_Location_Qr_Codes%rowtype;
  begin
    r_Qrcode := z_Htt_Location_Qr_Codes.Lock_Load(i_Company_Id => i_Company_Id,
                                                  i_Unique_Key => i_Unique_Key);
  
    if r_Qrcode.State = 'P' then
      Htt_Error.Raise_082(i_Location_Id   => r_Qrcode.Location_Id,
                          i_Location_Name => z_Htt_Locations.Load(i_Company_Id => r_Qrcode.Company_Id, --
                                             i_Location_Id => r_Qrcode.Location_Id).Name,
                          i_Created_On    => r_Qrcode.Created_On);
    end if;
  
    r_Qrcode.State := 'P';
  
    z_Htt_Location_Qr_Codes.Update_Row(r_Qrcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Qr_Code_Delete
  (
    i_Company_Id number,
    i_Unique_Key varchar2
  ) is
  begin
    z_Htt_Location_Qr_Codes.Delete_One(i_Company_Id => i_Company_Id, i_Unique_Key => i_Unique_Key);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Location_Qr_Code_Generate
  (
    i_Company_Id  number,
    i_Location_Id number
  ) return varchar2 is
    v_Random_Key varchar2(32) := to_char(Dbms_Crypto.Randombytes(16));
    v_Unique_Key varchar2(64);
  begin
    v_Unique_Key := Fazo.Hash_Sha1(i_Location_Id || ':' || Htt_Next.Qr_Code_Id || v_Random_Key);
  
    z_Htt_Location_Qr_Codes.Insert_One(i_Company_Id  => i_Company_Id,
                                       i_Unique_Key  => v_Unique_Key,
                                       i_Location_Id => i_Location_Id,
                                       i_State       => 'A');
  
    return v_Unique_Key;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Terminal_Model_Save(i_Terminal_Model Htt_Terminal_Models%rowtype) is
    r_Terminal_Model Htt_Terminal_Models%rowtype;
  begin
    r_Terminal_Model := z_Htt_Terminal_Models.Lock_Load(i_Terminal_Model.Model_Id);
  
    if r_Terminal_Model.Pcode <> i_Terminal_Model.Pcode then
      Htt_Error.Raise_046(i_Old_Pcode => r_Terminal_Model.Pcode,
                          i_Model_Id  => i_Terminal_Model.Model_Id);
    end if;
  
    z_Htt_Terminal_Models.Update_Row(i_Terminal_Model);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Add(i_Device Htt_Devices%rowtype) is
    r_Device          Htt_Devices%rowtype := i_Device;
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
  begin
    r_Device.Use_Settings := Nvl(r_Device.Use_Settings, 'N');
  
    if r_Device.Model_Id is null and --
       r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
      Htt_Error.Raise_047;
    end if;
  
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    if r_Device.Location_Id is null and --
       r_Device.Device_Type_Id in (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal),
                                   Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad),
                                   v_Dt_Hikvision_Id,
                                   v_Dt_Dahua_Id) then
      Htt_Error.Raise_048;
    end if;
  
    if r_Device.Use_Settings = 'Y' then
      r_Device.Track_Types   := null;
      r_Device.Mark_Types    := null;
      r_Device.Emotion_Types := null;
      r_Device.Lang_Code     := null;
    elsif r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad) and
          r_Device.Lang_Code is null then
      Htt_Error.Raise_050;
    end if;
  
    if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff) then
      r_Device.Autogen_Inputs       := 'N';
      r_Device.Autogen_Outputs      := 'N';
      r_Device.Ignore_Tracks        := 'N';
      r_Device.Ignore_Images        := 'N';
      r_Device.Restricted_Type      := null;
      r_Device.Only_Last_Restricted := null;
    else
      r_Device.Autogen_Inputs  := Nvl(r_Device.Autogen_Inputs, 'N');
      r_Device.Autogen_Outputs := Nvl(r_Device.Autogen_Outputs, 'N');
    
      if r_Device.Restricted_Type not in
         (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output) then
        r_Device.Only_Last_Restricted := null;
      end if;
    end if;
  
    r_Device.Status        := Nvl(r_Device.Status, Htt_Pref.c_Device_Status_Unknown);
    r_Device.Ignore_Tracks := Nvl(r_Device.Ignore_Tracks, 'N');
    r_Device.Ignore_Images := Nvl(r_Device.Ignore_Images, 'N');
  
    z_Htt_Devices.Insert_Row(r_Device);
  
    if r_Device.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id) then
      Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                       i_Device_Id    => r_Device.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Device);
    
      Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                       i_Device_Id    => r_Device.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Update_All_Device_Persons);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Update
  (
    i_Company_Id           number,
    i_Device_Id            number,
    i_Name                 Option_Varchar2 := null,
    i_Model_Id             Option_Number := null,
    i_Location_Id          Option_Number := null,
    i_Charge_Percentage    Option_Number := null,
    i_Track_Types          Option_Varchar2 := null,
    i_Mark_Types           Option_Varchar2 := null,
    i_Emotion_Types        Option_Varchar2 := null,
    i_Lang_Code            Option_Varchar2 := null,
    i_Use_Settings         Option_Varchar2 := null,
    i_Last_Seen_On         Option_Date := null,
    i_Autogen_Inputs       Option_Varchar2 := null,
    i_Autogen_Outputs      Option_Varchar2 := null,
    i_Ignore_Tracks        Option_Varchar2 := null,
    i_Ignore_Images        Option_Varchar2 := null,
    i_Restricted_Type      Option_Varchar2 := null,
    i_Only_Last_Restricted Option_Varchar2 := null,
    i_State                Option_Varchar2 := null
  ) is
    r_Device               Htt_Devices%rowtype;
    v_Track_Types          Option_Varchar2 := i_Track_Types;
    v_Mark_Types           Option_Varchar2 := i_Mark_Types;
    v_Emotion_Types        Option_Varchar2 := i_Emotion_Types;
    v_Lang_Code            Option_Varchar2 := i_Lang_Code;
    v_Autogen_Inputs       Option_Varchar2 := i_Autogen_Inputs;
    v_Autogen_Outputs      Option_Varchar2 := i_Autogen_Outputs;
    v_Ignore_Tracks        Option_Varchar2 := i_Ignore_Tracks;
    v_Ignore_Images        Option_Varchar2 := i_Ignore_Images;
    v_Restricted_Type      Option_Varchar2 := i_Restricted_Type;
    v_Only_Last_Restricted Option_Varchar2 := i_Only_Last_Restricted;
    v_Charge_Percentage    Option_Number := i_Charge_Percentage;
    v_Dt_Hikvision_Id      number;
    v_Dt_Dahua_Id          number;
  begin
    r_Device := z_Htt_Devices.Lock_Load(i_Company_Id => i_Company_Id, --
                                        i_Device_Id  => i_Device_Id);
  
    if i_Model_Id is not null and --
       i_Model_Id.Val is null and
       r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
      Htt_Error.Raise_051;
    end if;
  
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    if i_Location_Id is not null and --
       i_Location_Id.Val is null and
       r_Device.Device_Type_Id in (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal),
                                   Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad),
                                   v_Dt_Hikvision_Id,
                                   v_Dt_Dahua_Id) then
      Htt_Error.Raise_052;
    end if;
  
    if i_Use_Settings is not null and --
       i_Use_Settings.Val = 'Y' then
      v_Track_Types   := Option_Varchar2(null);
      v_Mark_Types    := Option_Varchar2(null);
      v_Emotion_Types := Option_Varchar2(null);
      v_Lang_Code     := Option_Varchar2(null);
    elsif r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad) and
          v_Lang_Code is not null and v_Lang_Code.Val is null then
      Htt_Error.Raise_054;
    end if;
  
    if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff) then
      v_Autogen_Inputs       := null;
      v_Autogen_Outputs      := null;
      v_Restricted_Type      := null;
      v_Only_Last_Restricted := null;
      v_Ignore_Tracks        := null;
      v_Ignore_Images        := null;
    elsif v_Restricted_Type.Val not in (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output) then
      v_Only_Last_Restricted := Option_Varchar2(null);
    end if;
  
    if v_Charge_Percentage is not null and v_Charge_Percentage.Val is null then
      v_Charge_Percentage := null;
    end if;
  
    z_Htt_Devices.Update_One(i_Company_Id           => i_Company_Id,
                             i_Device_Id            => i_Device_Id,
                             i_Name                 => i_Name,
                             i_Model_Id             => i_Model_Id,
                             i_Location_Id          => i_Location_Id,
                             i_Charge_Percentage    => v_Charge_Percentage,
                             i_Track_Types          => v_Track_Types,
                             i_Mark_Types           => v_Mark_Types,
                             i_Emotion_Types        => v_Emotion_Types,
                             i_Lang_Code            => v_Lang_Code,
                             i_Use_Settings         => i_Use_Settings,
                             i_Autogen_Inputs       => v_Autogen_Inputs,
                             i_Autogen_Outputs      => v_Autogen_Outputs,
                             i_Ignore_Tracks        => v_Ignore_Tracks,
                             i_Ignore_Images        => v_Ignore_Images,
                             i_Restricted_Type      => v_Restricted_Type,
                             i_Only_Last_Restricted => v_Only_Last_Restricted,
                             i_Last_Seen_On         => i_Last_Seen_On,
                             i_State                => i_State);
  
    if r_Device.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id) and i_Location_Id is not null and
       i_Location_Id.Val <> r_Device.Location_Id then
      Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                       i_Device_Id    => r_Device.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Update_All_Device_Persons);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Save(i_Device Htt_Acms_Devices%rowtype) is
    r_Device Htt_Acms_Devices%rowtype;
  begin
    if not z_Htt_Acms_Devices.Exist_Lock(i_Company_Id => i_Device.Company_Id,
                                         i_Device_Id  => i_Device.Device_Id,
                                         o_Row        => r_Device) then
      r_Device.Company_Id := i_Device.Company_Id;
      r_Device.Device_Id  := i_Device.Device_Id;
    
      -- dynamic ip solution currently disabled
      -- see hac module integration instead 
      r_Device.Dynamic_Ip := 'N';
      r_Device.Ip_Address := null;
      r_Device.Port       := null;
      r_Device.Protocol   := null;
      r_Device.Host       := Nvl(i_Device.Host, i_Device.Login);
    else
      if not Fazo.Equal(r_Device.Dynamic_Ip, i_Device.Dynamic_Ip) or --
         not Fazo.Equal(r_Device.Ip_Address, i_Device.Ip_Address) or --
         not Fazo.Equal(r_Device.Port, i_Device.Port) or --
         not Fazo.Equal(r_Device.Protocol, i_Device.Protocol) or --
         not Fazo.Equal(r_Device.Host, i_Device.Host) or --
         not Fazo.Equal(r_Device.Login, i_Device.Login) or --
         not Fazo.Equal(r_Device.Password, i_Device.Password) then
        Acms_Command_Add(i_Company_Id   => r_Device.Company_Id,
                         i_Device_Id    => r_Device.Device_Id,
                         i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Device);
      end if;
    end if;
  
    r_Device.Dynamic_Ip := i_Device.Dynamic_Ip;
    r_Device.Login      := i_Device.Login;
    r_Device.Password   := Nvl(i_Device.Password, r_Device.Password);
  
    if r_Device.Dynamic_Ip = 'Y' then
      r_Device.Ip_Address := i_Device.Ip_Address;
      r_Device.Port       := i_Device.Port;
      r_Device.Protocol   := i_Device.Protocol;
      r_Device.Host       := null;
    else
      r_Device.Ip_Address := null;
      r_Device.Port       := null;
      r_Device.Protocol   := null;
      r_Device.Host       := i_Device.Host;
    end if;
  
    z_Htt_Acms_Devices.Save_Row(r_Device);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Add_Admin
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  ) is
    v_Filial_Ids Array_Number;
    r_Device     Htt_Devices%rowtype;
  begin
    r_Device := z_Htt_Devices.Lock_Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    z_Htt_Device_Admins.Insert_Try(i_Company_Id => i_Company_Id,
                                   i_Device_Id  => i_Device_Id,
                                   i_Person_Id  => i_Person_Id);
  
    if r_Device.Location_Id is not null then
      v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Device.Company_Id,
                                              i_Location_Id => r_Device.Location_Id,
                                              i_Person_Id   => i_Person_Id);
    
      for i in 1 .. v_Filial_Ids.Count
      loop
        Htt_Core.Location_Add_Person(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => v_Filial_Ids(i),
                                     i_Location_Id => r_Device.Location_Id,
                                     i_Person_Id   => i_Person_Id,
                                     i_Attach_Type => Htt_Pref.c_Attach_Type_Manual);
      end loop;
    end if;
  
    Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Remove_Admin
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  ) is
  begin
    z_Htt_Device_Admins.Delete_One(i_Company_Id => i_Company_Id,
                                   i_Device_Id  => i_Device_Id,
                                   i_Person_Id  => i_Person_Id);
  
    Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Delete
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Htt_Devices.Delete_One(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unknown_Device_Add
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Htt_Unknown_Devices.Insert_One(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reliable_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Htt_Unknown_Devices.Delete_One(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unreliable_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    Device_Update(i_Company_Id => i_Company_Id,
                  i_Device_Id  => i_Device_Id,
                  i_State      => Option_Varchar2('P'));
  
    z_Htt_Unknown_Devices.Delete_One(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Device_Tracks
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    for r in (select q.Filial_Id, q.Track_Id
                from Htt_Tracks q
               where q.Company_Id = i_Company_Id
                 and q.Device_Id = i_Device_Id)
    loop
      Track_Delete(i_Company_Id => i_Company_Id,
                   i_Filial_Id  => r.Filial_Id,
                   i_Track_Id   => r.Track_Id);
    end loop;
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
    Htt_Core.Acms_Command_Add(i_Company_Id   => i_Company_Id,
                              i_Device_Id    => i_Device_Id,
                              i_Command_Kind => i_Command_Kind,
                              i_Person_Id    => i_Person_Id,
                              i_Data         => i_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Command_Complete
  (
    i_Company_Id number,
    i_Command_Id number
  ) is
    r_Command Htt_Acms_Commands%rowtype;
  begin
    r_Command := z_Htt_Acms_Commands.Lock_Load(i_Company_Id => i_Company_Id,
                                               i_Command_Id => i_Command_Id);
  
    if r_Command.Status <> Htt_Pref.c_Command_Status_Sent then
      b.Raise_Fatal('HTT: acms_command_complete: command status must be sent, command_id=$1',
                    i_Command_Id);
    end if;
  
    z_Htt_Acms_Commands.Update_One(i_Company_Id       => i_Company_Id,
                                   i_Command_Id       => i_Command_Id,
                                   i_Status           => Option_Varchar2(Htt_Pref.c_Command_Status_Complited),
                                   i_State_Changed_On => Option_Date(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Command_Fail
  (
    i_Company_Id number,
    i_Command_Id number,
    i_Error_Msg  varchar2 := null
  ) is
    r_Command Htt_Acms_Commands%rowtype;
  begin
    r_Command := z_Htt_Acms_Commands.Lock_Load(i_Company_Id => i_Company_Id,
                                               i_Command_Id => i_Command_Id);
  
    if r_Command.Status <> Htt_Pref.c_Command_Status_Sent then
      b.Raise_Fatal('HTT: acms_command_fail: command status must be sent, command_id=$1',
                    i_Command_Id);
    end if;
  
    z_Htt_Acms_Commands.Update_One(i_Company_Id       => i_Company_Id,
                                   i_Command_Id       => i_Command_Id,
                                   i_Status           => Option_Varchar2(Htt_Pref.c_Command_Status_Failed),
                                   i_State_Changed_On => Option_Date(sysdate),
                                   i_Error_Msg        => Option_Varchar2(i_Error_Msg));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Trim_Tracks_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  ) is
    v_Value varchar2(1);
  begin
    if i_Value not in ('Y', 'N') then
      v_Value := 'N';
    else
      v_Value := i_Value;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Htt_Pref.c_Schedule_Trimmed_Tracks,
                           i_Value      => Nvl(v_Value, 'N'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Pin_Autogenerate_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Htt_Error.Raise_079;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Htt_Pref.c_Pin_Autogenerate,
                           i_Value      => Nvl(i_Value, 'Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Photo_As_Face_Rec_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Htt_Error.Raise_080;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Htt_Pref.c_Photo_As_Face_Rec,
                           i_Value      => Nvl(i_Value, 'Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Invalid_Auto_Checkout_Enable
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  ) return boolean is
    r_Setting Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
  begin
    r_Setting := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_User_Id    => i_User_Id);
  
    return r_Setting.Auto_Output_Enabled = 'Y' and r_Setting.Disable_Auto_Checkout = 'Y';
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Notify_Timesheet
  (
    i_Track       Htt_Tracks%rowtype,
    i_Notify_Type varchar2
  ) is
    r_Staff         Href_Staffs%rowtype;
    r_Timesheet     Htt_Timesheets%rowtype;
    v_Manager_Id    number;
    v_Staff_Id      number;
    v_Timesheet_Ids Array_Number;
    result          Hashmap := Hashmap();
  begin
    if not (i_Track.Track_Type = Htt_Pref.c_Track_Type_Output and
        i_Track.Mark_Type = Htt_Pref.c_Mark_Type_Auto and i_Track.Is_Valid = 'N' and
        Invalid_Auto_Checkout_Enable(i_Company_Id => i_Track.Company_Id,
                                         i_Filial_Id  => i_Track.Filial_Id,
                                         i_User_Id    => i_Track.Person_Id)) then
      return;
    end if;
  
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_Track.Company_Id,
                                                 i_Filial_Id   => i_Track.Filial_Id,
                                                 i_Employee_Id => i_Track.Person_Id,
                                                 i_Date        => i_Track.Track_Datetime);
  
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Track.Company_Id,
                                  i_Filial_Id  => i_Track.Filial_Id,
                                  i_Staff_Id   => v_Staff_Id);
  
    v_Manager_Id := Href_Util.Get_Manager_Id(i_Company_Id => i_Track.Company_Id,
                                             i_Filial_Id  => i_Track.Filial_Id,
                                             i_Robot_Id   => r_Staff.Robot_Id);
  
    if not Hes_Util.Enabled_Notify(i_Company_Id   => i_Track.Company_Id,
                                   i_User_Id      => v_Manager_Id,
                                   i_Setting_Code => i_Notify_Type) then
      return;
    end if;
  
    v_Timesheet_Ids := Htt_Core.Find_Track_Timesheets(i_Company_Id     => i_Track.Company_Id,
                                                      i_Filial_Id      => i_Track.Filial_Id,
                                                      i_Staff_Id       => v_Staff_Id,
                                                      i_Track_Datetime => i_Track.Track_Datetime);
  
    for i in 1 .. v_Timesheet_Ids.Count
    loop
      r_Timesheet := z_Htt_Timesheets.Load(i_Company_Id   => i_Track.Company_Id,
                                           i_Filial_Id    => i_Track.Filial_Id,
                                           i_Timesheet_Id => v_Timesheet_Ids(i));
    
      if r_Timesheet.Count_Early = 'Y' and r_Timesheet.Input_Time is not null and
         r_Timesheet.Output_Time is null and i_Track.Track_Datetime between r_Timesheet.Begin_Time and
         r_Timesheet.End_Time then
        Result.Put('notify_type', i_Notify_Type);
        Result.Put('timesheet_id', r_Timesheet.Timesheet_Id);
        Result.Put('timesheet_date', r_Timesheet.Timesheet_Date);
        Result.Put('employee_name',
                   z_Mr_Natural_Persons.Take(i_Company_Id => i_Track.Company_Id, i_Person_Id => i_Track.Person_Id).Name);
        Result.Put('begin_time', to_char(r_Timesheet.Begin_Time, Href_Pref.c_Time_Format_Minute));
        Result.Put('end_time', to_char(r_Timesheet.End_Time, Href_Pref.c_Time_Format_Minute));
        Result.Put('input_time', to_char(r_Timesheet.Input_Time, Href_Pref.c_Time_Format_Minute));
        Result.Put('output_time', to_char(i_Track.Track_Datetime, Href_Pref.c_Time_Format_Minute));
        Result.Put('early_time',
                   Trunc(Htt_Util.Time_Diff(r_Timesheet.End_Time, i_Track.Track_Datetime) / 60));
      
        Mt_Fcm.Send(i_Company_Id => r_Timesheet.Company_Id, --
                    i_User_Id    => v_Manager_Id,
                    i_Data       => result);
      
        return;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Convert_Datetime
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Track_Time timestamp with time zone
  ) return date is
    v_Timezone Md_Timezones.Timezone_Code%type;
  begin
    v_Timezone := z_Md_Users.Take(i_Company_Id => i_Company_Id, i_User_Id => i_Person_Id).Timezone_Code;
  
    if v_Timezone is null then
      v_Timezone := Htt_Util.Load_Timezone(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    end if;
  
    return Htt_Util.Timestamp_To_Date(i_Timestamp => i_Track_Time, i_Timezone => v_Timezone);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Add(i_Track Htt_Tracks%rowtype) is
    r_Track          Htt_Tracks%rowtype := i_Track;
    r_Location       Htt_Locations%rowtype;
    r_Device         Htt_Devices%rowtype;
    r_Timesheet      Htt_Timesheets%rowtype;
    v_Device_Type_Id number;
    --------------------------------------------------
    Function Track_Exists return boolean is
      v_Dummy varchar2(1);
    begin
      if r_Track.Device_Id is not null then
        select 'x'
          into v_Dummy
          from Htt_Tracks q
         where q.Company_Id = r_Track.Company_Id
           and q.Filial_Id = r_Track.Filial_Id
           and q.Track_Time = r_Track.Track_Time
           and q.Person_Id = r_Track.Person_Id
           and q.Device_Id = r_Track.Device_Id
           and q.Original_Type = r_Track.Original_Type;
      else
        select 'x'
          into v_Dummy
          from Htt_Tracks q
         where q.Company_Id = r_Track.Company_Id
           and q.Filial_Id = r_Track.Filial_Id
           and q.Track_Time = r_Track.Track_Time
           and q.Person_Id = r_Track.Person_Id
           and q.Original_Type = r_Track.Original_Type;
      end if;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    if r_Track.Location_Id is not null then
      r_Location := z_Htt_Locations.Load(i_Company_Id  => r_Track.Company_Id,
                                         i_Location_Id => r_Track.Location_Id);
    
      if r_Track.Latlng is null then
        r_Track.Latlng   := r_Location.Latlng;
        r_Track.Accuracy := r_Location.Accuracy;
      end if;
    else
      if r_Track.Latlng is null then
        r_Track.Accuracy := null;
      end if;
    end if;
  
    if z_Htt_Blocked_Person_Tracking.Exist(i_Company_Id  => r_Track.Company_Id,
                                           i_Filial_Id   => r_Track.Filial_Id,
                                           i_Employee_Id => r_Track.Person_Id) then
      Htt_Error.Raise_136(i_Employee_Name => z_Mr_Natural_Persons.Load(i_Company_Id => r_Track.Company_Id, --
                                             i_Person_Id => r_Track.Person_Id).Name);
    end if;
  
    v_Device_Type_Id := Htt_Util.Device_Type_Id(i_Pcode => Htt_Pref.c_Pcode_Device_Type_Staff);
  
    if r_Track.Device_Id is not null then
      r_Device := z_Htt_Devices.Load(i_Company_Id => r_Track.Company_Id,
                                     i_Device_Id  => r_Track.Device_Id);
    
      r_Track.Track_Type := Nvl(r_Device.Restricted_Type, r_Track.Track_Type);
    end if;
  
    if r_Device.Ignore_Tracks = 'Y' then
      return;
    end if;
  
    if r_Device.Ignore_Images = 'Y' then
      r_Track.Photo_Sha := null;
    end if;
  
    r_Track.Track_Datetime := Convert_Datetime(i_Company_Id => r_Track.Company_Id,
                                               i_Filial_Id  => r_Track.Filial_Id,
                                               i_Person_Id  => r_Track.Person_Id,
                                               i_Track_Time => r_Track.Track_Time);
  
    r_Track.Track_Date    := Trunc(r_Track.Track_Datetime);
    r_Track.Is_Valid      := Nvl(r_Track.Is_Valid, 'Y');
    r_Track.Status        := Htt_Pref.c_Track_Status_Draft;
    r_Track.Original_Type := r_Track.Track_Type;
  
    if v_Device_Type_Id = r_Device.Device_Type_Id then
      if Hes_Util.Staff_Track_Settings(i_Company_Id => r_Track.Company_Id, --
       i_Filial_Id => r_Track.Filial_Id, --
       i_User_Id => r_Track.Person_Id).Track_Potential = 'Y' then
        r_Track.Trans_Output := 'Y';
      else
        r_Track.Trans_Output := 'N';
      end if;
    else
      r_Track.Trans_Output := Nvl(r_Device.Autogen_Outputs, 'N');
    end if;
  
    r_Track.Trans_Input := Nvl(r_Device.Autogen_Inputs, 'N');
    r_Track.Trans_Check := case
                             when r_Device.Only_Last_Restricted = 'Y' and
                                  r_Device.Restricted_Type in
                                  (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output) then
                              'Y'
                             else
                              'N'
                           end;
  
    if Htt_Util.Schedule_Trim_Tracks(i_Company_Id => r_Track.Company_Id,
                                     i_Filial_Id  => r_Track.Filial_Id) = 'Y' then
      r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => r_Track.Company_Id,
                                        i_Filial_Id      => r_Track.Filial_Id,
                                        i_Staff_Id       => Href_Util.Get_Primary_Staff_Id(i_Company_Id   => r_Track.Company_Id,
                                                                                           i_Filial_Id    => r_Track.Filial_Id,
                                                                                           i_Employee_Id  => r_Track.Person_Id,
                                                                                           i_Period_Begin => r_Track.Track_Date,
                                                                                           i_Period_End   => r_Track.Track_Date),
                                        i_Timesheet_Date => r_Track.Track_Date);
    
      if r_Timesheet.Day_Kind <> Htt_Pref.c_Day_Kind_Work or r_Timesheet.Company_Id is null then
        return;
      end if;
    
      if r_Timesheet.Schedule_Kind <> Htt_Pref.c_Schedule_Kind_Hourly then
        r_Track.Track_Datetime := Greatest(Least(r_Track.Track_Datetime, r_Timesheet.End_Time),
                                           r_Timesheet.Begin_Time);
        r_Track.Track_Date     := Trunc(r_Track.Track_Date);
        r_Track.Track_Time     := cast(r_Track.Track_Datetime as timestamp with local time zone);
      end if;
    end if;
  
    if r_Track.Mark_Type = Htt_Pref.c_Mark_Type_Auto and
       Invalid_Auto_Checkout_Enable(i_Company_Id => r_Track.Company_Id,
                                    i_Filial_Id  => r_Track.Filial_Id,
                                    i_User_Id    => r_Track.Person_Id) then
      r_Track.Is_Valid := 'N';
    end if;
  
    if Track_Exists then
      return;
    end if;
  
    -- check if prohibited location
    if r_Track.Is_Valid = 'Y' and r_Track.Latlng is not null and
       r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff) and
       Htt_Util.Is_Prohibited(i_Company_Id => r_Track.Company_Id,
                              i_Filial_Id  => r_Track.Filial_Id,
                              i_Person_Id  => r_Track.Person_Id,
                              i_Latlng     => r_Track.Latlng) or r_Location.Prohibited = 'Y' then
      r_Track.Is_Valid := 'N';
    end if;
  
    if true or Htt_Util.Is_Track_Accepted_Period(i_Company_Id  => r_Track.Company_Id,
                                                 i_Filial_Id   => r_Track.Filial_Id,
                                                 i_Employee_Id => r_Track.Person_Id,
                                                 i_Period      => r_Track.Track_Date) = 'Y' then
      z_Htt_Tracks.Insert_Row(r_Track);
    
      if Md_Pref.c_Migr_Company_Id != i_Track.Company_Id then
        if r_Track.Is_Valid = 'Y' then
          Htt_Core.Track_Add(i_Company_Id     => r_Track.Company_Id,
                             i_Filial_Id      => r_Track.Filial_Id,
                             i_Track_Id       => r_Track.Track_Id,
                             i_Employee_Id    => r_Track.Person_Id,
                             i_Track_Datetime => r_Track.Track_Datetime,
                             i_Track_Type     => r_Track.Track_Type,
                             i_Trans_Input    => r_Track.Trans_Input,
                             i_Trans_Output   => r_Track.Trans_Output,
                             i_Trans_Check    => r_Track.Trans_Check);
        elsif r_Track.Mark_Type = Htt_Pref.c_Mark_Type_Auto and
              Invalid_Auto_Checkout_Enable(i_Company_Id => r_Track.Company_Id,
                                           i_Filial_Id  => r_Track.Filial_Id,
                                           i_User_Id    => r_Track.Person_Id) then
          Notify_Timesheet(i_Track => r_Track, i_Notify_Type => Hes_Pref.c_Pref_Nt_Early_Time);
        end if;
      
      end if;
    else
      Htt_Core.Trash_Track_Insert(r_Track);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Change_Track_Type
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Track_Id       number,
    i_New_Track_Type varchar2
  ) is
    r_Track Htt_Tracks%rowtype;
  begin
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Track_Id   => i_Track_Id);
  
    if r_Track.Track_Type not in
       (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output, Htt_Pref.c_Track_Type_Check) then
      Htt_Error.Raise_134(Htt_Util.t_Track_Type(r_Track.Track_Type));
    end if;
  
    if i_New_Track_Type not in
       (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output, Htt_Pref.c_Track_Type_Check) then
      Htt_Error.Raise_135(Htt_Util.t_Track_Type(i_New_Track_Type));
    end if;
  
    if r_Track.Track_Type = i_New_Track_Type then
      return;
    end if;
  
    z_Htt_Tracks.Update_One(i_Company_Id => r_Track.Company_Id,
                            i_Filial_Id  => r_Track.Filial_Id,
                            i_Track_Id   => r_Track.Track_Id,
                            i_Track_Type => Option_Varchar2(i_New_Track_Type));
  
    Htt_Core.Track_Delete(i_Company_Id  => r_Track.Company_Id,
                          i_Filial_Id   => r_Track.Filial_Id,
                          i_Track_Id    => r_Track.Track_Id,
                          i_Employee_Id => r_Track.Person_Id);
  
    Htt_Core.Track_Add(i_Company_Id     => r_Track.Company_Id,
                       i_Filial_Id      => r_Track.Filial_Id,
                       i_Track_Id       => r_Track.Track_Id,
                       i_Employee_Id    => r_Track.Person_Id,
                       i_Track_Datetime => r_Track.Track_Datetime,
                       i_Track_Type     => i_New_Track_Type,
                       i_Trans_Input    => r_Track.Trans_Input,
                       i_Trans_Output   => r_Track.Trans_Output,
                       i_Trans_Check    => r_Track.Trans_Check);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Set_Valid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  ) is
    r_Track Htt_Tracks%rowtype;
  begin
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Track_Id   => i_Track_Id);
  
    if r_Track.Is_Valid = 'Y' then
      Htt_Error.Raise_055(i_Track_Id);
    end if;
  
    r_Track.Track_Datetime := Convert_Datetime(i_Company_Id => r_Track.Company_Id,
                                               i_Filial_Id  => r_Track.Filial_Id,
                                               i_Person_Id  => r_Track.Person_Id,
                                               i_Track_Time => r_Track.Track_Time);
  
    r_Track.Track_Date := Trunc(r_Track.Track_Datetime);
  
    z_Htt_Tracks.Update_One(i_Company_Id     => i_Company_Id,
                            i_Filial_Id      => i_Filial_Id,
                            i_Track_Id       => i_Track_Id,
                            i_Track_Datetime => Option_Date(r_Track.Track_Datetime),
                            i_Track_Date     => Option_Date(r_Track.Track_Date),
                            i_Is_Valid       => Option_Varchar2('Y'));
  
    Htt_Core.Track_Add(i_Company_Id     => r_Track.Company_Id,
                       i_Filial_Id      => r_Track.Filial_Id,
                       i_Track_Id       => r_Track.Track_Id,
                       i_Employee_Id    => r_Track.Person_Id,
                       i_Track_Datetime => r_Track.Track_Datetime,
                       i_Track_Type     => r_Track.Track_Type,
                       i_Trans_Input    => r_Track.Trans_Input,
                       i_Trans_Output   => r_Track.Trans_Output,
                       i_Trans_Check    => r_Track.Trans_Check);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Set_Invalid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  ) is
    r_Track Htt_Tracks%rowtype;
  begin
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Track_Id   => i_Track_Id);
  
    if r_Track.Is_Valid = 'N' then
      Htt_Error.Raise_056(i_Track_Id);
    end if;
  
    z_Htt_Tracks.Update_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Track_Id   => i_Track_Id,
                            i_Is_Valid   => Option_Varchar2('N'));
  
    Htt_Core.Track_Delete(i_Company_Id  => r_Track.Company_Id,
                          i_Filial_Id   => r_Track.Filial_Id,
                          i_Track_Id    => r_Track.Track_Id,
                          i_Employee_Id => r_Track.Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number
  ) is
    r_Track Htt_Tracks%rowtype;
  begin
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Track_Id   => i_Track_Id);
  
    Htt_Core.Track_Delete(i_Company_Id  => r_Track.Company_Id,
                          i_Filial_Id   => r_Track.Filial_Id,
                          i_Track_Id    => r_Track.Track_Id,
                          i_Employee_Id => r_Track.Person_Id);
  
    z_Htt_Tracks.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Track_Id   => i_Track_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number
  ) is
  begin
    Htt_Core.Make_Trash_Tracks(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Person_Id  => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gps_Track_Add(i_Track Htt_Pref.Gps_Track_Rt) is
    v_Track_Id number;
    v_Exists   varchar2(1) := 'Y';
  begin
    v_Track_Id := Htt_Util.Gps_Track_Id(i_Company_Id => i_Track.Company_Id,
                                        i_Filial_Id  => i_Track.Filial_Id,
                                        i_Person_Id  => i_Track.Person_Id,
                                        i_Track_Date => i_Track.Track_Date);
  
    if z_Htt_Gps_Track_Batches.Exist_Lock(i_Company_Id => i_Track.Company_Id,
                                          i_Filial_Id  => i_Track.Filial_Id,
                                          i_Track_Id   => v_Track_Id,
                                          i_Batch_Id   => i_Track.Batch_Id) then
      -- if batch saved then no need to resave it
      return;
    end if;
  
    if v_Track_Id is null then
      v_Track_Id := Htt_Next.Gps_Track_Id;
      v_Exists   := 'N';
    end if;
  
    if v_Exists = 'Y' then
      z_Htt_Gps_Tracks.Update_One(i_Company_Id => i_Track.Company_Id,
                                  i_Filial_Id  => i_Track.Filial_Id,
                                  i_Track_Id   => v_Track_Id,
                                  i_Calculated => Option_Varchar2('N'));
    
      for r in (select *
                  from Htt_Gps_Track_Datas q
                 where q.Company_Id = i_Track.Company_Id
                   and q.Filial_Id = i_Track.Filial_Id
                   and q.Track_Id = v_Track_Id
                   for update)
      loop
        Dbms_Lob.Append(r.Data, i_Track.Data);
      end loop;
    else
      z_Htt_Gps_Tracks.Insert_One(i_Company_Id => i_Track.Company_Id,
                                  i_Filial_Id  => i_Track.Filial_Id,
                                  i_Track_Id   => v_Track_Id,
                                  i_Person_Id  => i_Track.Person_Id,
                                  i_Track_Date => i_Track.Track_Date,
                                  i_Calculated => 'N');
    
      insert into Htt_Gps_Track_Datas
        (Company_Id, Filial_Id, Track_Id, Data)
      values
        (i_Track.Company_Id, i_Track.Filial_Id, v_Track_Id, i_Track.Data);
    end if;
  
    -- gps track batches
    z_Htt_Gps_Track_Batches.Insert_One(i_Company_Id => i_Track.Company_Id,
                                       i_Filial_Id  => i_Track.Filial_Id,
                                       i_Track_Id   => v_Track_Id,
                                       i_Batch_Id   => i_Track.Batch_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gps_Track_Add(i_Track Htt_Pref.Gps_Track_Data_Rt) is
    v_Data blob;
    v_Text varchar2(4000);
  
    --------------------------------------------------
    Procedure Text_Append(i_Text varchar2) is
    begin
      v_Text := v_Text || i_Text || Htt_Pref.c_Gps_Track_Column_Delimiter;
    end;
  begin
    Text_Append(to_char(i_Track.Track_Time, 'hh24:mi:ss'));
    Text_Append(i_Track.Lat);
    Text_Append(i_Track.Lng);
    Text_Append(i_Track.Accuracy);
    Text_Append(i_Track.Provider);
  
    Dbms_Lob.Createtemporary(v_Data, false);
    Dbms_Lob.Open(v_Data, Dbms_Lob.Lob_Readwrite);
    Dbms_Lob.Writeappend(v_Data,
                         Length(v_Text) + 1,
                         Utl_Raw.Cast_To_Raw(v_Text || Htt_Pref.c_Gps_Track_Row_Delimiter));
  
    if z_Htt_Gps_Tracks.Exist_Lock(i_Company_Id => i_Track.Company_Id,
                                   i_Filial_Id  => i_Track.Filial_Id,
                                   i_Track_Id   => i_Track.Track_Id) then
      z_Htt_Gps_Tracks.Update_One(i_Company_Id => i_Track.Company_Id,
                                  i_Filial_Id  => i_Track.Filial_Id,
                                  i_Track_Id   => i_Track.Track_Id,
                                  i_Calculated => Option_Varchar2('N'));
    
      for r in (select *
                  from Htt_Gps_Track_Datas q
                 where q.Company_Id = i_Track.Company_Id
                   and q.Filial_Id = i_Track.Filial_Id
                   and q.Track_Id = i_Track.Track_Id
                   for update)
      loop
        Dbms_Lob.Append(r.Data, v_Data);
      end loop;
    else
      z_Htt_Gps_Tracks.Insert_One(i_Company_Id => i_Track.Company_Id,
                                  i_Filial_Id  => i_Track.Filial_Id,
                                  i_Track_Id   => i_Track.Track_Id,
                                  i_Person_Id  => i_Track.Person_Id,
                                  i_Track_Date => i_Track.Track_Date,
                                  i_Calculated => 'N');
    
      insert into Htt_Gps_Track_Datas
        (Company_Id, Filial_Id, Track_Id, Data)
      values
        (i_Track.Company_Id, i_Track.Filial_Id, i_Track.Track_Id, v_Data);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
  begin
    z_Htt_Blocked_Person_Tracking.Insert_Try(i_Company_Id  => i_Company_Id,
                                             i_Filial_Id   => i_Filial_Id,
                                             i_Employee_Id => i_Employee_Id);
  
    Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
  begin
    z_Htt_Blocked_Person_Tracking.Delete_One(i_Company_Id  => i_Company_Id,
                                             i_Filial_Id   => i_Filial_Id,
                                             i_Employee_Id => i_Employee_Id);
  
    Htt_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Save(i_Request_Kind Htt_Request_Kinds%rowtype) is
    r_Request_Kind Htt_Request_Kinds%rowtype;
    r_Time_Kind    Htt_Time_Kinds%rowtype;
  
    v_Pcode  Htt_Request_Kinds.Pcode%type;
    v_Date   date := sysdate;
    v_Exists boolean := false;
  begin
    -- TODO add restriction on time_kind_id change
    -- make time_kind_id unchangeable
    -- or allow change to time kind with same plan_load
    -- maybe add timsheets regen after request_kind edit
    -- TODO: add calendar of production days
  
    if z_Htt_Request_Kinds.Exist_Lock(i_Company_Id      => i_Request_Kind.Company_Id,
                                      i_Request_Kind_Id => i_Request_Kind.Request_Kind_Id,
                                      o_Row             => r_Request_Kind) then
      if r_Request_Kind.Pcode is not null then
        v_Pcode := r_Request_Kind.Pcode;
      
        if r_Request_Kind.Time_Kind_Id <> i_Request_Kind.Time_Kind_Id then
          Htt_Error.Raise_057(z_Htt_Time_Kinds.Load(i_Company_Id => r_Request_Kind.Company_Id, --
                              i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id).Name);
        end if;
      end if;
    
      v_Exists := true;
    end if;
  
    r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Request_Kind.Company_Id,
                                         i_Time_Kind_Id => i_Request_Kind.Time_Kind_Id);
  
    if r_Time_Kind.Requestable = 'N' then
      Htt_Error.Raise_058(r_Time_Kind.Name);
    end if;
  
    z_Htt_Request_Kinds.Init(p_Row                      => r_Request_Kind,
                             i_Company_Id               => i_Request_Kind.Company_Id,
                             i_Request_Kind_Id          => i_Request_Kind.Request_Kind_Id,
                             i_Name                     => i_Request_Kind.Name,
                             i_Time_Kind_Id             => i_Request_Kind.Time_Kind_Id,
                             i_Annually_Limited         => i_Request_Kind.Annually_Limited,
                             i_Day_Count_Type           => i_Request_Kind.Day_Count_Type,
                             i_User_Permitted           => i_Request_Kind.User_Permitted,
                             i_Allow_Unused_Time        => i_Request_Kind.Allow_Unused_Time,
                             i_Request_Restriction_Days => i_Request_Kind.Request_Restriction_Days,
                             i_State                    => i_Request_Kind.State,
                             i_Pcode                    => v_Pcode);
  
    if r_Request_Kind.Annually_Limited = 'Y' then
      r_Request_Kind.Annual_Day_Limit := i_Request_Kind.Annual_Day_Limit;
      r_Request_Kind.Carryover_Policy := i_Request_Kind.Carryover_Policy;
    
      if r_Request_Kind.Carryover_Policy <> Htt_Pref.c_Carryover_Policy_Zero then
        if r_Request_Kind.Carryover_Policy = Htt_Pref.c_Carryover_Policy_Cap then
          r_Request_Kind.Carryover_Cap_Days := i_Request_Kind.Carryover_Cap_Days;
        end if;
      
        r_Request_Kind.Carryover_Expires_Days := i_Request_Kind.Carryover_Expires_Days;
      end if;
    end if;
  
    z_Htt_Request_Kinds.Save_Row(r_Request_Kind);
  
    -- fix request kind accruals
    if v_Exists then
      for r in (select *
                  from Htt_Staff_Request_Kinds q
                 where q.Company_Id = i_Request_Kind.Company_Id
                   and q.Request_Kind_Id = i_Request_Kind.Request_Kind_Id)
      loop
        Htt_Core.Request_Kind_Accrual_Evaluate(i_Company_Id      => r.Company_Id,
                                               i_Filial_Id       => r.Filial_Id,
                                               i_Staff_Id        => r.Staff_Id,
                                               i_Request_Kind_Id => r.Request_Kind_Id,
                                               i_Period          => v_Date);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Delete
  (
    i_Company_Id      number,
    i_Request_Kind_Id number
  ) is
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    if z_Htt_Request_Kinds.Exist_Lock(i_Company_Id      => i_Company_Id,
                                      i_Request_Kind_Id => i_Request_Kind_Id,
                                      o_Row             => r_Request_Kind) and
       r_Request_Kind.Pcode is not null then
      Htt_Error.Raise_059(r_Request_Kind.Name);
    end if;
  
    z_Htt_Request_Kinds.Delete_One(i_Company_Id      => i_Company_Id,
                                   i_Request_Kind_Id => i_Request_Kind_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Attach_Request_Kind
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number
  ) is
  begin
    z_Htt_Staff_Request_Kinds.Insert_Try(i_Company_Id      => i_Company_Id,
                                         i_Filial_Id       => i_Filial_Id,
                                         i_Staff_Id        => i_Staff_Id,
                                         i_Request_Kind_Id => i_Request_Kind_Id);
  
    Htt_Core.Request_Kind_Accrual_Evaluate(i_Company_Id      => i_Company_Id,
                                           i_Filial_Id       => i_Filial_Id,
                                           i_Staff_Id        => i_Staff_Id,
                                           i_Request_Kind_Id => i_Request_Kind_Id,
                                           i_Period          => sysdate);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Detach_Request_Kind
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Request_Kind_Id number
  ) is
  begin
    z_Htt_Staff_Request_Kinds.Delete_One(i_Company_Id      => i_Company_Id,
                                         i_Filial_Id       => i_Filial_Id,
                                         i_Staff_Id        => i_Staff_Id,
                                         i_Request_Kind_Id => i_Request_Kind_Id);
  
    Htt_Core.Request_Kind_Accrual_Evaluate(i_Company_Id      => i_Company_Id,
                                           i_Filial_Id       => i_Filial_Id,
                                           i_Staff_Id        => i_Staff_Id,
                                           i_Request_Kind_Id => i_Request_Kind_Id,
                                           i_Period          => sysdate);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Helper_Save
  (
    i_Request     Htt_Requests%rowtype,
    i_Staff_Id    number,
    i_Only_Insert boolean := false
  ) is
    v_Begin date;
    v_End   date;
  begin
    v_Begin := Trunc(i_Request.Begin_Time);
    v_End   := Trunc(i_Request.End_Time);
  
    if not i_Only_Insert then
      delete Htt_Request_Helpers q
       where q.Company_Id = i_Request.Company_Id
         and q.Filial_Id = i_Request.Filial_Id
         and q.Request_Id = i_Request.Request_Id;
    end if;
  
    while v_Begin <= v_End
    loop
      z_Htt_Request_Helpers.Insert_One(i_Company_Id    => i_Request.Company_Id,
                                       i_Filial_Id     => i_Request.Filial_Id,
                                       i_Staff_Id      => i_Staff_Id,
                                       i_Interval_Date => v_Begin,
                                       i_Request_Id    => i_Request.Request_Id);
      v_Begin := v_Begin + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Save(i_Request Htt_Requests%rowtype) is
    r_Request      Htt_Requests%rowtype;
    r_Request_Kind Htt_Request_Kinds%rowtype;
    v_Exists       boolean;
    v_Diff_Days    number;
    v_Plan_Load    varchar(1);
    v_Min_Length   number;
  begin
    if z_Htt_Requests.Exist_Lock(i_Company_Id => i_Request.Company_Id,
                                 i_Filial_Id  => i_Request.Filial_Id,
                                 i_Request_Id => i_Request.Request_Id,
                                 o_Row        => r_Request) then
      if r_Request.Status <> Htt_Pref.c_Request_Status_New then
        Htt_Error.Raise_060(i_Request_Status   => r_Request.Status,
                            i_Request_Kind_New => Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_New));
      end if;
    
      if r_Request.Staff_Id <> i_Request.Staff_Id then
        Htt_Error.Raise_061(Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                                 i_Filial_Id  => r_Request.Filial_Id,
                                                 i_Staff_Id   => r_Request.Staff_Id));
      end if;
    
      v_Exists := true;
    else
      r_Request.Company_Id := i_Request.Company_Id;
      r_Request.Filial_Id  := i_Request.Filial_Id;
      r_Request.Request_Id := i_Request.Request_Id;
      r_Request.Staff_Id   := i_Request.Staff_Id;
      r_Request.Status     := Htt_Pref.c_Request_Status_New;
      r_Request.Created_On := Current_Timestamp;
    
      v_Exists := false;
    end if;
  
    if Md_Pref.Load(i_Company_Id => i_Request.Company_Id,
                    i_Filial_Id  => Md_Pref.Filial_Head(i_Request.Company_Id),
                    i_Code       => Href_Pref.c_Pref_Crs_Request_Note) = 'Y' then
      v_Min_Length := Md_Pref.Load(i_Company_Id => i_Request.Company_Id,
                                   i_Filial_Id  => Md_Pref.Filial_Head(i_Request.Company_Id),
                                   i_Code       => Href_Pref.c_Pref_Crs_Request_Note_Limit);
    
      if v_Min_Length > Length(i_Request.Note) then
        Htt_Error.Raise_110(v_Min_Length);
      end if;
    end if;
  
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => i_Request.Company_Id,
                                               i_Request_Kind_Id => i_Request.Request_Kind_Id);
  
    v_Plan_Load := z_Htt_Time_Kinds.Load(i_Company_Id => i_Request.Company_Id, i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id).Plan_Load;
  
    if v_Plan_Load = Htt_Pref.c_Plan_Load_Extra then
      Htt_Error.Raise_081;
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Request.Company_Id then
      if v_Plan_Load = Htt_Pref.c_Plan_Load_Full and
         i_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
        Htt_Error.Raise_062(Array_Varchar2(Htt_Util.t_Request_Type(Htt_Pref.c_Request_Type_Full_Day),
                                           Htt_Util.t_Request_Type(Htt_Pref.c_Request_Type_Multiple_Days)));
      end if;
    end if;
  
    v_Diff_Days := i_Request.End_Time - i_Request.Begin_Time;
  
    if Md_Pref.c_Migr_Company_Id != i_Request.Company_Id then
      if not (i_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day and v_Diff_Days > 0 and
          v_Diff_Days < 1 or
          i_Request.Request_Type = Htt_Pref.c_Request_Type_Full_Day and v_Diff_Days = 0 or
          i_Request.Request_Type = Htt_Pref.c_Request_Type_Multiple_Days and v_Diff_Days >= 1) then
        Htt_Error.Raise_063(i_Request_Type      => i_Request.Request_Type,
                            i_Request_Type_Name => Htt_Util.t_Request_Type(i_Request.Request_Type));
      end if;
    end if;
  
    r_Request.Request_Kind_Id := i_Request.Request_Kind_Id;
    r_Request.Request_Type    := i_Request.Request_Type;
    r_Request.Begin_Time      := i_Request.Begin_Time;
    r_Request.End_Time        := i_Request.End_Time;
    r_Request.Note            := i_Request.Note;
  
    if r_Request_Kind.Annually_Limited = 'Y' then
      r_Request.Accrual_Kind := Nvl(i_Request.Accrual_Kind, Htt_Pref.c_Accrual_Kind_Plan);
    else
      r_Request.Accrual_Kind := null;
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Request.Company_Id then
      if r_Request_Kind.Request_Restriction_Days is not null then
        if Trunc(r_Request.Begin_Time) - Trunc(r_Request.Created_On) <
           r_Request_Kind.Request_Restriction_Days then
          Htt_Error.Raise_064(i_Restriction_Days => r_Request_Kind.Request_Restriction_Days,
                              i_Request_Begin    => Trunc(r_Request.Begin_Time),
                              i_Created_On       => Trunc(r_Request.Created_On));
        end if;
      end if;
    end if;
  
    Htt_Util.Assert_Has_Intersection_Request(i_Company_Id   => r_Request.Company_Id,
                                             i_Filial_Id    => r_Request.Filial_Id,
                                             i_Request_Id   => r_Request.Request_Id,
                                             i_Staff_Id     => r_Request.Staff_Id,
                                             i_Begin_Time   => r_Request.Begin_Time,
                                             i_End_Time     => r_Request.End_Time,
                                             i_Request_Type => r_Request.Request_Type);
  
    if Md_Pref.c_Migr_Company_Id != i_Request.Company_Id then
      Htt_Util.Assert_Request_Has_Available_Days(i_Company_Id         => r_Request.Company_Id,
                                                 i_Filial_Id          => r_Request.Filial_Id,
                                                 i_Staff_Id           => r_Request.Staff_Id,
                                                 i_Request_Id         => r_Request.Request_Id,
                                                 i_Request_Kind_Id    => r_Request.Request_Kind_Id,
                                                 i_Request_Begin_Time => r_Request.Begin_Time,
                                                 i_Request_End_Time   => r_Request.End_Time,
                                                 i_Accrual_Kind       => r_Request.Accrual_Kind);
    end if;
  
    if v_Exists then
      z_Htt_Requests.Update_Row(r_Request);
      Request_Helper_Save(r_Request, i_Staff_Id => r_Request.Staff_Id);
    else
      r_Request.Barcode := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                               i_Id    => r_Request.Request_Id);
    
      z_Htt_Requests.Insert_Row(r_Request);
    
      Request_Helper_Save(r_Request, --
                          i_Staff_Id    => r_Request.Staff_Id,
                          i_Only_Insert => true);
    
      Notify_Staff_Request(i_Company_Id  => r_Request.Company_Id,
                           i_Filial_Id   => r_Request.Filial_Id,
                           i_Request_Id  => r_Request.Request_Id,
                           i_Notify_Type => Hes_Pref.c_Pref_Nt_Request);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Timesheet
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) is
  begin
    Htt_Core.Gen_Timesheet_Requests(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Request_Id => i_Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Timesheet_Plan
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
  begin
    Htt_Core.Change_Timesheet_Plans(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Change_Id  => i_Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Reset
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    if r_Request.Status = Htt_Pref.c_Request_Status_New then
      Htt_Error.Raise_065(i_Request_Id       => i_Request_Id,
                          i_Request_Status   => r_Request.Status,
                          i_Request_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_Approved),
                                                               Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_Completed),
                                                               Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_Denied)));
    end if;
  
    z_Htt_Requests.Update_One(i_Company_Id   => i_Company_Id,
                              i_Filial_Id    => i_Filial_Id,
                              i_Request_Id   => i_Request_Id,
                              i_Status       => Option_Varchar2(Htt_Pref.c_Request_Status_New),
                              i_Approved_By  => Option_Number(null),
                              i_Completed_By => Option_Number(null));
  
    Fix_Timesheet(i_Company_Id => i_Company_Id,
                  i_Filial_Id  => i_Filial_Id,
                  i_Request_Id => i_Request_Id);
  
    Notify_Staff_Request(i_Company_Id  => r_Request.Company_Id,
                         i_Filial_Id   => r_Request.Filial_Id,
                         i_Request_Id  => r_Request.Request_Id,
                         i_Notify_Type => Hes_Pref.c_Pref_Nt_Request_Change_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Manager_Note varchar2,
    i_User_Id      number
  ) is
    r_Request          Htt_Requests%rowtype;
    v_Request_Settings Hes_Pref.Staff_Request_Manager_Approval_Rt := Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => i_Company_Id,
                                                                                                                      i_Filial_Id  => i_Filial_Id,
                                                                                                                      i_User_Id    => i_User_Id);
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    if r_Request.Status <> Htt_Pref.c_Request_Status_New then
      Htt_Error.Raise_066(i_Request_Id       => i_Request_Id,
                          i_Request_Status   => r_Request.Status,
                          i_Request_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_New)));
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Company_Id then
      Htt_Util.Assert_Has_Intersection_Request(i_Company_Id   => r_Request.Company_Id,
                                               i_Filial_Id    => r_Request.Filial_Id,
                                               i_Request_Id   => r_Request.Request_Id,
                                               i_Staff_Id     => r_Request.Staff_Id,
                                               i_Begin_Time   => r_Request.Begin_Time,
                                               i_End_Time     => r_Request.End_Time,
                                               i_Request_Type => r_Request.Request_Type);
    
      Htt_Util.Assert_Request_Has_Available_Days(i_Company_Id         => r_Request.Company_Id,
                                                 i_Filial_Id          => r_Request.Filial_Id,
                                                 i_Staff_Id           => r_Request.Staff_Id,
                                                 i_Request_Id         => r_Request.Request_Id,
                                                 i_Request_Kind_Id    => r_Request.Request_Kind_Id,
                                                 i_Request_Begin_Time => r_Request.Begin_Time,
                                                 i_Request_End_Time   => r_Request.End_Time,
                                                 i_Accrual_Kind       => r_Request.Accrual_Kind);
    end if;
  
    z_Htt_Requests.Update_One(i_Company_Id   => i_Company_Id,
                              i_Filial_Id    => i_Filial_Id,
                              i_Request_Id   => i_Request_Id,
                              i_Manager_Note => Option_Varchar2(i_Manager_Note),
                              i_Status       => Option_Varchar2(Htt_Pref.c_Request_Status_Approved),
                              i_Approved_By  => Option_Number(Md_Env.User_Id));
  
    if v_Request_Settings.Request_Settings = 'Y' then
      Request_Complete(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Request_Id => i_Request_Id);
    else
      Notify_Staff_Request(i_Company_Id  => r_Request.Company_Id,
                           i_Filial_Id   => r_Request.Filial_Id,
                           i_Request_Id  => r_Request.Request_Id,
                           i_Notify_Type => Hes_Pref.c_Pref_Nt_Request_Manager_Approval);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    if r_Request.Status not in (Htt_Pref.c_Request_Status_New, Htt_Pref.c_Request_Status_Approved) then
      Htt_Error.Raise_067(i_Request_Id       => i_Request_Id,
                          i_Request_Status   => r_Request.Status,
                          i_Request_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_New),
                                                               Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_Approved)));
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Company_Id then
      Htt_Util.Assert_Has_Intersection_Request(i_Company_Id   => r_Request.Company_Id,
                                               i_Filial_Id    => r_Request.Filial_Id,
                                               i_Request_Id   => r_Request.Request_Id,
                                               i_Staff_Id     => r_Request.Staff_Id,
                                               i_Begin_Time   => r_Request.Begin_Time,
                                               i_End_Time     => r_Request.End_Time,
                                               i_Request_Type => r_Request.Request_Type);
    
      Htt_Util.Assert_Request_Has_Available_Days(i_Company_Id         => r_Request.Company_Id,
                                                 i_Filial_Id          => r_Request.Filial_Id,
                                                 i_Staff_Id           => r_Request.Staff_Id,
                                                 i_Request_Id         => r_Request.Request_Id,
                                                 i_Request_Kind_Id    => r_Request.Request_Kind_Id,
                                                 i_Request_Begin_Time => r_Request.Begin_Time,
                                                 i_Request_End_Time   => r_Request.End_Time,
                                                 i_Accrual_Kind       => r_Request.Accrual_Kind);
    end if;
  
    z_Htt_Requests.Update_One(i_Company_Id   => i_Company_Id,
                              i_Filial_Id    => i_Filial_Id,
                              i_Request_Id   => i_Request_Id,
                              i_Status       => Option_Varchar2(Htt_Pref.c_Request_Status_Completed),
                              i_Completed_By => Option_Number(Md_Env.User_Id));
  
    if Md_Pref.c_Migr_Company_Id != i_Company_Id then
      Fix_Timesheet(i_Company_Id => i_Company_Id,
                    i_Filial_Id  => i_Filial_Id,
                    i_Request_Id => i_Request_Id);
    end if;
  
    Notify_Staff_Request(i_Company_Id  => r_Request.Company_Id,
                         i_Filial_Id   => r_Request.Filial_Id,
                         i_Request_Id  => r_Request.Request_Id,
                         i_Notify_Type => Hes_Pref.c_Pref_Nt_Request_Change_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Request_Id   number,
    i_Manager_Note varchar2 := null
  ) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    if r_Request.Status not in (Htt_Pref.c_Request_Status_New, Htt_Pref.c_Request_Status_Approved) then
      Htt_Error.Raise_068(i_Request_Id       => i_Request_Id,
                          i_Request_Status   => r_Request.Status,
                          i_Request_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_New),
                                                               Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_Approved)));
    end if;
  
    z_Htt_Requests.Update_One(i_Company_Id   => i_Company_Id,
                              i_Filial_Id    => i_Filial_Id,
                              i_Request_Id   => i_Request_Id,
                              i_Manager_Note => Option_Varchar2(i_Manager_Note),
                              i_Status       => Option_Varchar2(Htt_Pref.c_Request_Status_Denied),
                              i_Approved_By  => Option_Number(null));
  
    Notify_Staff_Request(i_Company_Id  => r_Request.Company_Id,
                         i_Filial_Id   => r_Request.Filial_Id,
                         i_Request_Id  => r_Request.Request_Id,
                         i_Notify_Type => Hes_Pref.c_Pref_Nt_Request_Change_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Request_Id number
  ) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Request_Id => i_Request_Id);
  
    if r_Request.Status <> Htt_Pref.c_Request_Status_New then
      Htt_Error.Raise_069(i_Request_Id       => i_Request_Id,
                          i_Request_Status   => r_Request.Status,
                          i_Request_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Request_Status_New)));
    end if;
  
    z_Htt_Requests.Delete_One(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Request_Id => i_Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Change_Days_By_Calendar
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    v_Plan_Time_Limit number;
  begin
    for r in (select q.Staff_Id,
                     q.Change_Date,
                     q.Swapped_Date,
                     q.Plan_Time,
                     q.Day_Kind,
                     w.Preholiday_Time,
                     w.Preweekend_Time,
                     c.Monthly_Limit,
                     c.Daily_Limit,
                     w.Plan_Time       Plan_Time_Limit,
                     s.Name            Schedule_Name,
                     c.Name            Calendar_Name,
                     t.Schedule_Id,
                     Ch.Change_Kind
                from Htt_Change_Days q
                join Htt_Plan_Changes Ch
                  on Ch.Company_Id = q.Company_Id
                 and Ch.Filial_Id = q.Filial_Id
                 and Ch.Change_Id = q.Change_Id
                join Htt_Timesheets t
                  on t.Company_Id = q.Company_Id
                 and t.Filial_Id = q.Filial_Id
                 and t.Staff_Id = q.Staff_Id
                 and t.Timesheet_Date = q.Change_Date
                join Htt_Schedules s
                  on s.Company_Id = t.Company_Id
                 and s.Filial_Id = t.Filial_Id
                 and s.Schedule_Id = t.Schedule_Id
                join Htt_Calendars c
                  on c.Company_Id = t.Company_Id
                 and c.Filial_Id = t.Filial_Id
                 and c.Calendar_Id = t.Calendar_Id
                join Htt_Calendar_Week_Days w
                  on w.Company_Id = c.Company_Id
                 and w.Filial_Id = c.Filial_Id
                 and w.Calendar_Id = c.Calendar_Id
                 and w.Order_No = Htt_Util.Iso_Week_Day_No(t.Timesheet_Date)
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Change_Id = i_Change_Id)
    loop
      if r.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
        if r.Monthly_Limit = 'Y' and Trunc(r.Change_Date, 'mon') <> Trunc(r.Swapped_Date, 'mon') then
          Htt_Error.Raise_119(i_Change_Date   => r.Change_Date,
                              i_Swapped_Date  => r.Swapped_Date,
                              i_Calendar_Name => r.Calendar_Name,
                              i_Schedule_Name => r.Schedule_Name);
        end if;
      end if;
    
      v_Plan_Time_Limit := Htt_Util.Get_Plan_Time(i_Company_Id      => i_Company_Id,
                                                  i_Filial_Id       => i_Filial_Id,
                                                  i_Staff_Id        => r.Staff_Id,
                                                  i_Date            => r.Change_Date,
                                                  i_Plan_Time       => r.Plan_Time_Limit,
                                                  i_Preholiday_Time => r.Preholiday_Time,
                                                  i_Preweekend_Time => r.Preweekend_Time);
    
      if r.Daily_Limit = 'Y' and r.Plan_Time / 60 > v_Plan_Time_Limit then
        Htt_Error.Raise_120(i_Change_Date   => r.Change_Date,
                            i_Calendar_Name => r.Calendar_Name,
                            i_Schedule_Name => r.Schedule_Name);
      end if;
    
      if r.Monthly_Limit = 'Y' and r.Change_Kind = Htt_Pref.c_Change_Kind_Change_Plan and
         not Fazo.Equal(r.Day_Kind,
                        Htt_Util.Schedule_Day_Kind(i_Company_Id    => i_Company_Id,
                                                   i_Filial_Id     => i_Filial_Id,
                                                   i_Staff_Id      => r.Staff_Id,
                                                   i_Schedule_Id   => r.Schedule_Id,
                                                   i_Schedule_Date => r.Change_Date)) then
        Htt_Error.Raise_121(i_Change_Date   => r.Change_Date,
                            i_Calendar_Name => r.Calendar_Name,
                            i_Schedule_Name => r.Schedule_Name);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Change_Monthly_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    r_Change           Htt_Plan_Changes%rowtype;
    v_Change_Day_Limit Hes_Pref.Change_Day_Limit_Rt;
    v_Employee_Id      number;
    v_Change_Count     number;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Staff_Id   => r_Change.Staff_Id);
  
    v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => i_Company_Id,
                                                                   i_Filial_Id  => i_Filial_Id,
                                                                   i_User_Id    => v_Employee_Id);
  
    if v_Change_Day_Limit.Change_With_Monthly_Limit = 'Y' then
      for r in (select distinct Trunc(q.Change_Date, 'mon') Change_Month
                  from Htt_Plan_Changes t
                  join Htt_Change_Days q
                    on q.Company_Id = t.Company_Id
                   and q.Filial_Id = t.Filial_Id
                   and q.Change_Id = t.Change_Id
                 where t.Company_Id = i_Company_Id
                   and t.Filial_Id = i_Filial_Id
                   and t.Change_Id = i_Change_Id
                 order by 1)
      loop
        v_Change_Count := Htt_Util.Get_Staff_Change_Monthly_Count(i_Company_Id => i_Company_Id,
                                                                  i_Filial_Id  => i_Filial_Id,
                                                                  i_Change_Id  => i_Change_Id,
                                                                  i_Month      => r.Change_Month);
      
        if v_Change_Day_Limit.Change_Monthly_Limit < v_Change_Count then
          Htt_Error.Raise_133(z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, i_Person_Id => v_Employee_Id).Name,
                              r.Change_Month,
                              v_Change_Day_Limit.Change_Monthly_Limit,
                              v_Change_Count);
        end if;
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Save(i_Change Htt_Pref.Change_Rt) is
    r_Change           Htt_Plan_Changes%rowtype;
    r_Change_Day       Htt_Change_Days%rowtype;
    v_Change_Dates     Array_Date := Array_Date();
    v_Change_Day       Htt_Pref.Change_Day_Rt;
    v_Swapped_Date     date;
    v_Exists           boolean;
    v_Min_Length       number;
    v_Employee_Id      number;
    v_Change_Day_Limit Hes_Pref.Change_Day_Limit_Rt;
  
    -------------------------------------------------- 
    Procedure Prepare_Change_Day(p_Change_Date in out nocopy Htt_Change_Days%rowtype) is
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
  begin
    if i_Change.Change_Days.Count = 0 then
      Htt_Error.Raise_070;
    end if;
  
    if Md_Pref.Load(i_Company_Id => i_Change.Company_Id,
                    i_Filial_Id  => Md_Pref.Filial_Head(i_Change.Company_Id),
                    i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note) = 'Y' then
      v_Min_Length := Md_Pref.Load(i_Company_Id => i_Change.Company_Id,
                                   i_Filial_Id  => Md_Pref.Filial_Head(i_Change.Company_Id),
                                   i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit);
    
      if v_Min_Length > Length(i_Change.Note) then
        Htt_Error.Raise_109(v_Min_Length);
      end if;
    end if;
  
    if z_Htt_Plan_Changes.Exist_Lock(i_Company_Id => i_Change.Company_Id,
                                     i_Filial_Id  => i_Change.Filial_Id,
                                     i_Change_Id  => i_Change.Change_Id,
                                     o_Row        => r_Change) then
      if r_Change.Status <> Htt_Pref.c_Change_Status_New then
        Htt_Error.Raise_071(i_Change_Status   => r_Change.Status,
                            i_Change_Statuses => Array_Varchar2(Htt_Util.t_Change_Status(Htt_Pref.c_Change_Status_New)));
      end if;
    
      if r_Change.Staff_Id <> i_Change.Staff_Id then
        Htt_Error.Raise_072(Href_Util.Staff_Name(i_Company_Id => r_Change.Company_Id,
                                                 i_Filial_Id  => r_Change.Filial_Id,
                                                 i_Staff_Id   => r_Change.Staff_Id));
      end if;
    
      v_Exists := true;
    else
      r_Change.Company_Id := i_Change.Company_Id;
      r_Change.Filial_Id  := i_Change.Filial_Id;
      r_Change.Change_Id  := i_Change.Change_Id;
      r_Change.Staff_Id   := i_Change.Staff_Id;
      r_Change.Status     := Htt_Pref.c_Change_Status_New;
      r_Change.Created_On := Current_Timestamp;
    
      v_Exists := false;
    end if;
  
    if i_Change.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
      if mod(i_Change.Change_Days.Count, 2) = 1 then
        Htt_Error.Raise_073;
      end if;
    end if;
  
    r_Change.Change_Kind := i_Change.Change_Kind;
    r_Change.Note        := i_Change.Note;
  
    if v_Exists then
      z_Htt_Plan_Changes.Update_Row(r_Change);
    else
      z_Htt_Plan_Changes.Insert_Row(r_Change);
    end if;
  
    v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => i_Change.Company_Id,
                                               i_Filial_Id  => i_Change.Filial_Id,
                                               i_Staff_Id   => i_Change.Staff_Id);
  
    v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => i_Change.Company_Id,
                                                                   i_Filial_Id  => i_Change.Filial_Id,
                                                                   i_User_Id    => v_Employee_Id);
  
    v_Change_Dates.Extend(i_Change.Change_Days.Count);
  
    for i in 1 .. i_Change.Change_Days.Count
    loop
      v_Change_Day := i_Change.Change_Days(i);
      v_Change_Dates(i) := v_Change_Day.Change_Date;
    
      v_Swapped_Date := null;
      if r_Change.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
        v_Swapped_Date := v_Change_Day.Swapped_Date;
      end if;
    
      if v_Change_Day_Limit.Change_With_Restriction_Days = 'Y' then
        if Trunc(Least(v_Change_Dates(i), Nvl(v_Swapped_Date, v_Change_Dates(i)))) -
           Trunc(r_Change.Created_On) < v_Change_Day_Limit.Change_Restriction_Days then
          Htt_Error.Raise_112(i_Restriction_Days => v_Change_Day_Limit.Change_Restriction_Days,
                              i_Change_Day       => Trunc(Least(v_Change_Dates(i),
                                                                Nvl(v_Swapped_Date, v_Change_Dates(i)))),
                              i_Created_On       => Trunc(r_Change.Created_On));
        end if;
      end if;
    
      r_Change_Day.Company_Id       := r_Change.Company_Id;
      r_Change_Day.Filial_Id        := r_Change.Filial_Id;
      r_Change_Day.Change_Id        := r_Change.Change_Id;
      r_Change_Day.Change_Date      := v_Change_Day.Change_Date;
      r_Change_Day.Swapped_Date     := v_Swapped_Date;
      r_Change_Day.Staff_Id         := r_Change.Staff_Id;
      r_Change_Day.Day_Kind         := v_Change_Day.Day_Kind;
      r_Change_Day.Begin_Time       := v_Change_Day.Begin_Time;
      r_Change_Day.End_Time         := v_Change_Day.End_Time;
      r_Change_Day.Break_Enabled    := v_Change_Day.Break_Enabled;
      r_Change_Day.Break_Begin_Time := v_Change_Day.Break_Begin_Time;
      r_Change_Day.Break_End_Time   := v_Change_Day.Break_End_Time;
      r_Change_Day.Plan_Time        := v_Change_Day.Plan_Time;
    
      Prepare_Change_Day(r_Change_Day);
    
      r_Change_Day.Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => r_Change_Day.Day_Kind,
                                                        i_Begin_Time       => r_Change_Day.Begin_Time,
                                                        i_End_Time         => r_Change_Day.End_Time,
                                                        i_Break_Begin_Time => r_Change_Day.Break_Begin_Time,
                                                        i_Break_End_Time   => r_Change_Day.Break_End_Time);
      -- full time in seconds
      r_Change_Day.Full_Time := r_Change_Day.Full_Time * 60;
    
      z_Htt_Change_Days.Save_Row(r_Change_Day);
    end loop;
  
    Check_Change_Days_By_Calendar(i_Company_Id => r_Change.Company_Id,
                                  i_Filial_Id  => r_Change.Filial_Id,
                                  i_Change_Id  => r_Change.Change_Id);
  
    if v_Exists then
      delete from Htt_Change_Days Cd
       where Cd.Company_Id = r_Change.Company_Id
         and Cd.Filial_Id = r_Change.Filial_Id
         and Cd.Change_Id = r_Change.Change_Id
         and Cd.Change_Date not member of v_Change_Dates;
    end if;
  
    -- checking for monthly limit
    if v_Change_Day_Limit.Change_With_Monthly_Limit = 'Y' then
      Check_Change_Monthly_Limit(i_Company_Id => i_Change.Company_Id,
                                 i_Filial_Id  => i_Change.Filial_Id,
                                 i_Change_Id  => i_Change.Change_Id);
    end if;
  
    Htt_Util.Assert_Has_Approved_Plan_Change(i_Company_Id => r_Change.Company_Id,
                                             i_Filial_Id  => r_Change.Filial_Id,
                                             i_Staff_Id   => r_Change.Staff_Id,
                                             i_Change_Id  => r_Change.Change_Id);
  
    if not v_Exists then
      Notify_Staff_Plan_Changes(i_Company_Id  => r_Change.Company_Id,
                                i_Filial_Id   => r_Change.Filial_Id,
                                i_Change_Id   => r_Change.Change_Id,
                                i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    if r_Change.Status <> Htt_Pref.c_Change_Status_New then
      Htt_Error.Raise_074(i_Change_Id       => i_Change_Id,
                          i_Change_Status   => r_Change.Status,
                          i_Change_Statuses => Array_Varchar2(Htt_Util.t_Change_Status(Htt_Pref.c_Change_Status_New)));
    end if;
  
    z_Htt_Plan_Changes.Delete_One(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Change_Id  => i_Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    if r_Change.Status = Htt_Pref.c_Change_Status_New then
      Htt_Error.Raise_075(i_Change_Id       => i_Change_Id,
                          i_Change_Status   => r_Change.Status,
                          i_Change_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_Approved),
                                                              Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_Completed),
                                                              Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_Denied)));
    end if;
  
    z_Htt_Plan_Changes.Update_One(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Change_Id    => i_Change_Id,
                                  i_Status       => Option_Varchar2(Htt_Pref.c_Change_Status_New),
                                  i_Approved_By  => Option_Number(null),
                                  i_Completed_By => Option_Number(null));
  
    if r_Change.Status = Htt_Pref.c_Change_Status_Completed then
      Fix_Timesheet_Plan(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Change_Id  => i_Change_Id);
    end if;
  
    Notify_Staff_Plan_Changes(i_Company_Id  => r_Change.Company_Id,
                              i_Filial_Id   => r_Change.Filial_Id,
                              i_Change_Id   => r_Change.Change_Id,
                              i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number,
    i_Manager_Note varchar2 := null,
    i_User_Id      number
  ) is
    r_Change          Htt_Plan_Changes%rowtype;
    v_Change_Settings Hes_Pref.Staff_Change_Manager_Approval_Rt := Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => i_Company_Id,
                                                                                                                   i_Filial_Id  => i_Filial_Id,
                                                                                                                   i_User_Id    => i_User_Id);
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    if r_Change.Status <> Htt_Pref.c_Change_Status_New then
      Htt_Error.Raise_076(i_Change_Id       => i_Change_Id,
                          i_Change_Status   => r_Change.Status,
                          i_Change_Statuses => Array_Varchar2(Htt_Util.t_Change_Status(Htt_Pref.c_Change_Status_New)));
    end if;
  
    Htt_Util.Assert_Has_Approved_Plan_Change(i_Company_Id => r_Change.Company_Id,
                                             i_Filial_Id  => r_Change.Filial_Id,
                                             i_Staff_Id   => r_Change.Staff_Id,
                                             i_Change_Id  => r_Change.Change_Id);
  
    Check_Change_Days_By_Calendar(i_Company_Id => r_Change.Company_Id,
                                  i_Filial_Id  => r_Change.Filial_Id,
                                  i_Change_Id  => r_Change.Change_Id);
  
    z_Htt_Plan_Changes.Update_One(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Change_Id    => i_Change_Id,
                                  i_Manager_Note => Option_Varchar2(i_Manager_Note),
                                  i_Status       => Option_Varchar2(Htt_Pref.c_Change_Status_Approved),
                                  i_Approved_By  => Option_Number(Md_Env.User_Id));
  
    if v_Change_Settings.Change_Settings = 'Y' then
      Change_Complete(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Change_Id  => i_Change_Id);
    else
      Notify_Staff_Plan_Changes(i_Company_Id  => r_Change.Company_Id,
                                i_Filial_Id   => r_Change.Filial_Id,
                                i_Change_Id   => r_Change.Change_Id,
                                i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change_Manager_Approval);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number
  ) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    if r_Change.Status not in (Htt_Pref.c_Change_Status_New, Htt_Pref.c_Change_Status_Approved) then
      Htt_Error.Raise_077(i_Change_Id       => i_Change_Id,
                          i_Change_Status   => r_Change.Status,
                          i_Change_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_New),
                                                              Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_Approved)));
    end if;
  
    Htt_Util.Assert_Has_Approved_Plan_Change(i_Company_Id => r_Change.Company_Id,
                                             i_Filial_Id  => r_Change.Filial_Id,
                                             i_Staff_Id   => r_Change.Staff_Id,
                                             i_Change_Id  => r_Change.Change_Id);
  
    -- checking for monthly limit
    Check_Change_Monthly_Limit(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Change_Id  => i_Change_Id);
  
    Check_Change_Days_By_Calendar(i_Company_Id => r_Change.Company_Id,
                                  i_Filial_Id  => r_Change.Filial_Id,
                                  i_Change_Id  => r_Change.Change_Id);
  
    z_Htt_Plan_Changes.Update_One(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Change_Id    => i_Change_Id,
                                  i_Status       => Option_Varchar2(Htt_Pref.c_Change_Status_Completed),
                                  i_Completed_By => Option_Number(Md_Env.User_Id));
  
    Fix_Timesheet_Plan(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Change_Id  => i_Change_Id);
  
    Notify_Staff_Plan_Changes(i_Company_Id  => r_Change.Company_Id,
                              i_Filial_Id   => r_Change.Filial_Id,
                              i_Change_Id   => r_Change.Change_Id,
                              i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number,
    i_Manager_Note varchar2 := null
  ) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Change_Id  => i_Change_Id);
  
    if r_Change.Status not in (Htt_Pref.c_Change_Status_New, Htt_Pref.c_Change_Status_Approved) then
      Htt_Error.Raise_078(i_Change_Id       => i_Change_Id,
                          i_Change_Status   => r_Change.Status,
                          i_Change_Statuses => Array_Varchar2(Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_New),
                                                              Htt_Util.t_Request_Status(Htt_Pref.c_Change_Status_Approved)));
    end if;
  
    z_Htt_Plan_Changes.Update_One(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Change_Id    => i_Change_Id,
                                  i_Manager_Note => Option_Varchar2(i_Manager_Note),
                                  i_Status       => Option_Varchar2(Htt_Pref.c_Change_Status_Denied),
                                  i_Approved_By  => Option_Number(null));
  
    Notify_Staff_Plan_Changes(i_Company_Id  => r_Change.Company_Id,
                              i_Filial_Id   => r_Change.Filial_Id,
                              i_Change_Id   => r_Change.Change_Id,
                              i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change_Status_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Day_Weights_Save(i_Change_Day_Weights Htt_Pref.Change_Day_Weights) is
    r_Change       Htt_Plan_Changes%rowtype;
    r_Change_Day   Htt_Change_Days%rowtype;
    v_Weight       Htt_Pref.Time_Weight_Rt;
    v_Begin_Minute number;
    v_End_Minute   number;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => i_Change_Day_Weights.Company_Id,
                                             i_Filial_Id  => i_Change_Day_Weights.Filial_Id,
                                             i_Change_Id  => i_Change_Day_Weights.Change_Id);
  
    if r_Change.Status = Htt_Pref.c_Change_Status_Completed then
      Htt_Error.Raise_132(r_Change.Change_Id);
    end if;
  
    r_Change_Day := z_Htt_Change_Days.Load(i_Company_Id  => i_Change_Day_Weights.Company_Id,
                                           i_Filial_Id   => i_Change_Day_Weights.Filial_Id,
                                           i_Staff_Id    => i_Change_Day_Weights.Staff_Id,
                                           i_Change_Date => i_Change_Day_Weights.Change_Date,
                                           i_Change_Id   => i_Change_Day_Weights.Change_Id);
  
    if r_Change_Day.Day_Kind <> Htt_Pref.c_Day_Kind_Work or r_Change_Day.Swapped_Date is not null then
      return;
    end if;
  
    -- delete old weight
    delete Htt_Change_Day_Weights q
     where q.Company_Id = i_Change_Day_Weights.Company_Id
       and q.Filial_Id = i_Change_Day_Weights.Filial_Id
       and q.Staff_Id = i_Change_Day_Weights.Staff_Id
       and q.Change_Date = i_Change_Day_Weights.Change_Date
       and q.Change_Id = i_Change_Day_Weights.Change_Id;
  
    v_Begin_Minute := (r_Change_Day.Begin_Time - Trunc(r_Change_Day.Change_Date)) * 1440;
    v_End_Minute   := (r_Change_Day.End_Time - Trunc(r_Change_Day.Change_Date)) * 1440;
  
    for i in 1 .. i_Change_Day_Weights.Weights.Count
    loop
      v_Weight := i_Change_Day_Weights.Weights(i);
    
      if v_Weight.Begin_Time < v_Begin_Minute then
        v_Weight.Begin_Time := v_Weight.Begin_Time + 1440;
        v_Weight.End_Time   := v_Weight.End_Time + 1440;
      end if;
    
      if v_Weight.End_Time < v_Weight.Begin_Time then
        v_Weight.End_Time := v_Weight.End_Time + 1440;
      end if;
    
      if v_Weight.Begin_Time = v_Weight.End_Time then
        Htt_Error.Raise_129(i_Part_No => i);
      end if;
    
      if v_Weight.End_Time > v_End_Minute then
        Htt_Error.Raise_130(i_Part_No         => i,
                            i_Begin_Time_Text => Htt_Util.To_Time(mod(v_Begin_Minute, 1440)),
                            i_End_Time_Text   => Htt_Util.To_Time(mod(v_End_Minute, 1440)));
      end if;
    
      z_Htt_Change_Day_Weights.Insert_One(i_Company_Id  => i_Change_Day_Weights.Company_Id,
                                          i_Filial_Id   => i_Change_Day_Weights.Filial_Id,
                                          i_Staff_Id    => i_Change_Day_Weights.Staff_Id,
                                          i_Change_Id   => i_Change_Day_Weights.Change_Id,
                                          i_Change_Date => i_Change_Day_Weights.Change_Date,
                                          i_Begin_Time  => v_Weight.Begin_Time,
                                          i_End_Time    => v_Weight.End_Time,
                                          i_Weight      => v_Weight.Weight);
    end loop;
  
    Htt_Util.Assert_Change_Day_Weights(i_Company_Id  => i_Change_Day_Weights.Company_Id,
                                       i_Filial_Id   => i_Change_Day_Weights.Filial_Id,
                                       i_Staff_Id    => i_Change_Day_Weights.Staff_Id,
                                       i_Change_Date => i_Change_Day_Weights.Change_Date,
                                       i_Change_Id   => i_Change_Day_Weights.Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Timesheet_Plan
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number,
    i_Dates       Array_Date
  ) is
  begin
    Htt_Core.Regen_Timesheet_Plan(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Schedule_Id => i_Schedule_Id,
                                  i_Dates       => i_Dates);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Gps_Track_Distances
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Total_Distance number;
  begin
    for Gt in (select q.Track_Id, q.Person_Id, q.Track_Date
                 from Htt_Gps_Tracks q
                where q.Company_Id = i_Company_Id
                  and q.Filial_Id = i_Filial_Id
                  and q.Calculated = 'N')
    loop
      v_Total_Distance := Htt_Util.Calc_Gps_Track_Distance(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id,
                                                           i_Person_Id  => Gt.Person_Id,
                                                           i_Track_Date => Gt.Track_Date);
    
      z_Htt_Gps_Tracks.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Track_Id       => Gt.Track_Id,
                                  i_Total_Distance => Option_Number(v_Total_Distance),
                                  i_Calculated     => Option_Varchar2('Y'));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Registry_Save(i_Registry Htt_Pref.Schedule_Registry_Rt) is
    r_Registry      Htt_Schedule_Registries%rowtype;
    r_Day           Htt_Unit_Schedule_Days%rowtype;
    v_Unit          Htt_Pref.Registry_Unit_Rt;
    v_Unit_Day      Htt_Pref.Schedule_Day_Rt;
    v_Used_Unit_Ids Array_Number := Array_Number();
  
    v_Old_Calendar_Id    number;
    v_Calendar_Changed   varchar2(1) := 'N';
    v_Holidays_Changed   varchar2(1) := 'N';
    v_Nonworking_Changed varchar2(1) := 'N';
  
    v_Company_Id number := i_Registry.Company_Id;
    v_Filial_Id  number := i_Registry.Filial_Id;
  
    v_Staff_Name varchar2(500 char);
    v_Robot_Name varchar2(500 char);
  
    --------------------------------------------------
    Procedure Save_Registry is
      v_Exists boolean;
    begin
      if z_Htt_Schedule_Registries.Exist_Lock(i_Company_Id  => i_Registry.Company_Id,
                                              i_Filial_Id   => i_Registry.Filial_Id,
                                              i_Registry_Id => i_Registry.Registry_Id,
                                              o_Row         => r_Registry) then
        if r_Registry.Posted = 'Y' then
          Htt_Error.Raise_083;
        end if;
      
        if r_Registry.Registry_Kind <> i_Registry.Registry_Kind then
          Htt_Error.Raise_084;
        end if;
      
        v_Old_Calendar_Id := r_Registry.Calendar_Id;
      
        if not Fazo.Equal(v_Old_Calendar_Id, i_Registry.Calendar_Id) then
          v_Calendar_Changed := 'Y';
        end if;
      
        if v_Calendar_Changed = 'Y' or v_Old_Calendar_Id = i_Registry.Calendar_Id and
           r_Registry.Take_Holidays <> i_Registry.Take_Holidays then
          v_Holidays_Changed := 'Y';
        end if;
      
        if v_Calendar_Changed = 'Y' or v_Old_Calendar_Id = i_Registry.Calendar_Id and
           r_Registry.Take_Nonworking <> i_Registry.Take_Nonworking then
          v_Nonworking_Changed := 'Y';
        end if;
      
        v_Exists := true;
      else
        r_Registry.Company_Id    := i_Registry.Company_Id;
        r_Registry.Filial_Id     := i_Registry.Filial_Id;
        r_Registry.Registry_Id   := i_Registry.Registry_Id;
        r_Registry.Registry_Kind := i_Registry.Registry_Kind;
        r_Registry.Schedule_Kind := i_Registry.Schedule_Kind;
      
        v_Exists := false;
      end if;
    
      r_Registry.Registry_Date             := i_Registry.Registry_Date;
      r_Registry.Registry_Number           := i_Registry.Registry_Number;
      r_Registry.Month                     := i_Registry.Month;
      r_Registry.Division_Id               := i_Registry.Division_Id;
      r_Registry.Note                      := i_Registry.Note;
      r_Registry.Posted                    := 'N';
      r_Registry.Shift                     := i_Registry.Shift;
      r_Registry.Input_Acceptance          := i_Registry.Input_Acceptance;
      r_Registry.Output_Acceptance         := i_Registry.Output_Acceptance;
      r_Registry.Track_Duration            := i_Registry.Track_Duration;
      r_Registry.Count_Late                := i_Registry.Count_Late;
      r_Registry.Count_Lack                := i_Registry.Count_Lack;
      r_Registry.Count_Early               := i_Registry.Count_Early;
      r_Registry.Count_Free                := i_Registry.Count_Free;
      r_Registry.Allowed_Late_Time         := i_Registry.Allowed_Late_Time;
      r_Registry.Allowed_Early_Time        := i_Registry.Allowed_Early_Time;
      r_Registry.Begin_Late_Time           := i_Registry.Begin_Late_Time;
      r_Registry.End_Early_Time            := i_Registry.End_Early_Time;
      r_Registry.Calendar_Id               := i_Registry.Calendar_Id;
      r_Registry.Take_Holidays             := i_Registry.Take_Holidays;
      r_Registry.Take_Nonworking           := i_Registry.Take_Nonworking;
      r_Registry.Take_Additional_Rest_Days := i_Registry.Take_Additional_Rest_Days;
      r_Registry.Gps_Turnout_Enabled       := Nvl(i_Registry.Gps_Turnout_Enabled, 'N');
      r_Registry.Gps_Use_Location          := Nvl(i_Registry.Gps_Use_Location, 'N');
      r_Registry.Gps_Max_Interval          := i_Registry.Gps_Max_Interval;
    
      if r_Registry.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
        if r_Registry.Track_Duration * 60 > Htt_Pref.c_Max_Worktime_Length then
          Htt_Error.Raise_108;
        end if;
      
        if i_Registry.Advanced_Setting = 'Y' then
          Htt_Error.Raise_117;
        end if;
      
        r_Registry.Shift             := 0;
        r_Registry.Input_Acceptance  := r_Registry.Track_Duration;
        r_Registry.Output_Acceptance := r_Registry.Track_Duration;
      
        r_Registry.Count_Late  := 'N';
        r_Registry.Count_Early := 'N';
        r_Registry.Count_Lack  := 'N';
        r_Registry.Count_Free  := 'N';
      
        r_Registry.Gps_Turnout_Enabled := 'N';
      elsif r_Registry.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible then
        r_Registry.Shift             := null;
        r_Registry.Input_Acceptance  := null;
        r_Registry.Output_Acceptance := null;
        r_Registry.Track_Duration    := Htt_Pref.c_Max_Track_Duration / 60;
      
        r_Registry.Gps_Turnout_Enabled := 'N';
      end if;
    
      if r_Registry.Gps_Turnout_Enabled = 'N' then
        r_Registry.Gps_Use_Location := 'N';
        r_Registry.Gps_Max_Interval := null;
      end if;
    
      if v_Exists then
        z_Htt_Schedule_Registries.Update_Row(r_Registry);
      else
        if r_Registry.Registry_Number is null then
          r_Registry.Registry_Number := Md_Core.Gen_Number(i_Company_Id => r_Registry.Company_Id,
                                                           i_Filial_Id  => r_Registry.Filial_Id,
                                                           i_Table      => Zt.Htt_Schedule_Registries,
                                                           i_Column     => z.Registry_Number);
        end if;
      
        z_Htt_Schedule_Registries.Insert_Row(r_Registry);
      end if;
    end;
  
  begin
    -- save registry start
    Save_Registry;
  
    for i in 1 .. i_Registry.Units.Count
    loop
      v_Unit := i_Registry.Units(i);
    
      if i_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff and
         (v_Unit.Robot_Id is not null or v_Unit.Staff_Id is null) then
        -- todo: error message shows rownum
        Htt_Error.Raise_086;
      end if;
    
      if i_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Robot and
         (v_Unit.Staff_Id is not null or v_Unit.Robot_Id is null) then
        -- todo: error message shows rownum
        Htt_Error.Raise_087;
      end if;
    
      z_Htt_Registry_Units.Save_One(i_Company_Id      => i_Registry.Company_Id,
                                    i_Filial_Id       => i_Registry.Filial_Id,
                                    i_Unit_Id         => v_Unit.Unit_Id,
                                    i_Registry_Id     => i_Registry.Registry_Id,
                                    i_Staff_Id        => v_Unit.Staff_Id,
                                    i_Robot_Id        => v_Unit.Robot_Id,
                                    i_Monthly_Minutes => v_Unit.Monthly_Minutes,
                                    i_Monthly_Days    => v_Unit.Monthly_Days);
    
      -- todo: assert v_unit.unit_days must be full month
    
      for k in 1 .. v_Unit.Unit_Days.Count
      loop
        v_Unit_Day := v_Unit.Unit_Days(k);
      
        if r_Registry.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
          v_Unit_Day.Begin_Time    := 0;
          v_Unit_Day.End_Time      := 0;
          v_Unit_Day.Break_Enabled := 'N';
        end if;
      
        -- todo: comment
        -- check month
        if Trunc(v_Unit_Day.Schedule_Date, 'mon') <> i_Registry.Month then
          if i_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
            v_Staff_Name := z_Md_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => z_Href_Staffs.Load( --
                            i_Company_Id => v_Company_Id, --
                            i_Filial_Id => v_Filial_Id, --
                            i_Staff_Id => v_Unit.Staff_Id).Employee_Id).Name;
          
            Htt_Error.Raise_085(i_Chosen_Month  => i_Registry.Month,
                                i_Schedule_Date => v_Unit_Day.Schedule_Date,
                                i_Staff_Name    => v_Staff_Name);
          else
            v_Robot_Name := z_Mrf_Robots.Load(i_Company_Id => v_Company_Id, --
                            i_Filial_Id => v_Filial_Id, --
                            i_Robot_Id => v_Unit.Robot_Id).Name;
            Htt_Error.Raise_099(i_Chosen_Month  => i_Registry.Month,
                                i_Schedule_Date => v_Unit_Day.Schedule_Date,
                                i_Robot_Name    => v_Robot_Name);
          end if;
        end if;
      
        r_Day := null;
      
        r_Day.Company_Id    := i_Registry.Company_Id;
        r_Day.Filial_Id     := i_Registry.Filial_Id;
        r_Day.Unit_Id       := v_Unit.Unit_Id;
        r_Day.Schedule_Date := v_Unit_Day.Schedule_Date;
        r_Day.Day_Kind      := v_Unit_Day.Day_Kind;
      
        if v_Unit_Day.Day_Kind = Htt_Pref.c_Day_Kind_Work then
          r_Day.Begin_Time := r_Day.Schedule_Date +
                              Numtodsinterval(v_Unit_Day.Begin_Time, 'minute');
          r_Day.End_Time   := r_Day.Schedule_Date + --
                              Numtodsinterval(v_Unit_Day.End_Time, 'minute');
        
          if r_Day.End_Time <= r_Day.Begin_Time then
            r_Day.End_Time := r_Day.End_Time + 1;
          end if;
        
          r_Day.Break_Enabled := v_Unit_Day.Break_Enabled;
        
          if v_Unit_Day.Break_Enabled = 'Y' then
            r_Day.Break_Begin_Time := r_Day.Schedule_Date +
                                      Numtodsinterval(v_Unit_Day.Break_Begin_Time, 'minute');
            r_Day.Break_End_Time   := r_Day.Schedule_Date +
                                      Numtodsinterval(v_Unit_Day.Break_End_Time, 'minute');
          
            if r_Day.Break_Begin_Time <= r_Day.Begin_Time then
              r_Day.Break_Begin_Time := r_Day.Break_Begin_Time + 1;
            end if;
          
            if r_Day.Break_End_Time <= r_Day.Break_Begin_Time then
              r_Day.Break_End_Time := r_Day.Break_End_Time + 1;
            end if;
          end if;
        
          r_Day.Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => r_Day.Day_Kind,
                                                     i_Begin_Time       => r_Day.Begin_Time,
                                                     i_End_Time         => r_Day.End_Time,
                                                     i_Break_Begin_Time => r_Day.Break_Begin_Time,
                                                     i_Break_End_Time   => r_Day.Break_End_Time);
        
          r_Day.Plan_Time := v_Unit_Day.Plan_Time;
        else
          r_Day.Full_Time := 0;
          r_Day.Plan_Time := 0;
        end if;
      
        r_Day.Shift_Begin_Time := r_Day.Schedule_Date + Numtodsinterval(r_Registry.Shift, 'minute');
        r_Day.Shift_End_Time   := r_Day.Shift_Begin_Time + Numtodsinterval(86400, 'second');
        r_Day.Input_Border     := r_Day.Shift_Begin_Time -
                                  Numtodsinterval(r_Registry.Input_Acceptance, 'minute');
        r_Day.Output_Border    := r_Day.Shift_End_Time +
                                  Numtodsinterval(r_Registry.Output_Acceptance, 'minute');
      
        z_Htt_Unit_Schedule_Days.Save_Row(r_Day);
      end loop;
    
      Fazo.Push(v_Used_Unit_Ids, v_Unit.Unit_Id);
    end loop;
  
    -- delete unnecessary rows
    delete Htt_Registry_Units p
     where p.Company_Id = i_Registry.Company_Id
       and p.Filial_Id = i_Registry.Filial_Id
       and p.Registry_Id = i_Registry.Registry_Id
       and p.Unit_Id not member of v_Used_Unit_Ids;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  ) is
    r_Registry Htt_Schedule_Registries%rowtype;
  begin
    r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Registry_Id => i_Registry_Id);
    if r_Registry.Posted = 'Y' then
      -- todo: error message fix
      Htt_Error.Raise_088;
    end if;
  
    z_Htt_Schedule_Registries.Delete_One(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Registry_Id => i_Registry_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Schedule_Registry_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number
  ) is
    r_Registry    Htt_Schedule_Registries%rowtype;
    v_Schedule_Id number;
    -------------------------------------------------- 
    Procedure Check_Same_Date
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Registry_Id number
    ) is
      v_Staff_Id number;
      v_Robot_Id number;
    begin
      -- todo: optimize query
      select q.Staff_Id, q.Robot_Id
        into v_Staff_Id, v_Robot_Id
        from Htt_Registry_Units q
        join Htt_Schedule_Registries d
          on d.Company_Id = q.Company_Id
         and d.Filial_Id = q.Filial_Id
         and d.Registry_Id = q.Registry_Id
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Registry_Id <> i_Registry_Id
         and d.Posted = 'Y'
         and exists (select 1
                from Htt_Registry_Units r
                join Htt_Schedule_Registries s
                  on s.Company_Id = r.Company_Id
                 and s.Filial_Id = r.Filial_Id
                 and s.Registry_Id = r.Registry_Id
               where r.Company_Id = q.Company_Id
                 and r.Filial_Id = q.Filial_Id
                 and s.Month = d.Month
                 and (r.Staff_Id = q.Staff_Id or r.Robot_Id = q.Robot_Id)
                 and r.Registry_Id = i_Registry_Id)
         and Rownum = 1;
    
      if v_Staff_Id is not null then
        Htt_Error.Raise_096(Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id,
                                                 i_Staff_Id   => v_Staff_Id));
      end if;
      if v_Robot_Id is not null then
        Htt_Error.Raise_097(z_Mrf_Robots.Take( --
                            i_Company_Id => i_Company_Id, --
                            i_Filial_Id => i_Filial_Id, --
                            i_Robot_Id => v_Robot_Id).Name);
      end if;
    exception
      when No_Data_Found then
        null;
    end;
  
    --------------------------------------------------
    Procedure Swap_Staff_Schedule_Day
    (
      p_Rest_Day in out nocopy Htt_Staff_Schedule_Days%rowtype,
      p_Work_Day in out nocopy Htt_Staff_Schedule_Days%rowtype
    ) is
      r_Day           Htt_Staff_Schedule_Days%rowtype := p_Rest_Day;
      v_Swap_Distance number;
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
  
    --------------------------------------------------
    Procedure Swap_Robot_Schedule_Day
    (
      p_Rest_Day in out nocopy Htt_Robot_Schedule_Days%rowtype,
      p_Work_Day in out nocopy Htt_Robot_Schedule_Days%rowtype
    ) is
      r_Day           Htt_Robot_Schedule_Days%rowtype := p_Rest_Day;
      v_Swap_Distance number;
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
  
    --------------------------------------------------
    Procedure Load_Calendar_Days is
      v_Unit_Ids                   Array_Number;
      v_Swappable                  boolean := false;
      r_Staff_Schedule_Date        Htt_Staff_Schedule_Days%rowtype;
      r_Staff_Schedule_Swaped_Date Htt_Staff_Schedule_Days%rowtype;
      r_Robot_Schedule_Date        Htt_Robot_Schedule_Days%rowtype;
      r_Robot_Schedule_Swaped_Date Htt_Robot_Schedule_Days%rowtype;
    begin
      select q.Unit_Id
        bulk collect
        into v_Unit_Ids
        from Htt_Registry_Units q
       where q.Company_Id = r_Registry.Company_Id
         and q.Filial_Id = r_Registry.Filial_Id
         and q.Registry_Id = r_Registry.Registry_Id;
    
      for r in (select *
                  from Htt_Calendar_Days q
                 where q.Company_Id = r_Registry.Company_Id
                   and q.Filial_Id = r_Registry.Filial_Id
                   and q.Calendar_Id = r_Registry.Calendar_Id
                   and Trunc(q.Calendar_Date, 'mon') = r_Registry.Month
                   and (q.Swapped_Date is null or --
                       Trunc(q.Swapped_Date, 'mon') = r_Registry.Month))
      loop
        for i in 1 .. v_Unit_Ids.Count
        loop
          if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
            r_Staff_Schedule_Date := Htt_Util.Get_Staff_Schedule_Day(i_Company_Id => r_Registry.Company_Id,
                                                                     i_Filial_Id  => r_Registry.Filial_Id,
                                                                     i_Unit_Id    => v_Unit_Ids(i),
                                                                     i_Date       => r.Calendar_Date);
          
            if r_Registry.Take_Holidays = 'Y' and r.Day_Kind = Htt_Pref.c_Day_Kind_Holiday or
               r_Registry.Take_Additional_Rest_Days = 'Y' and
               r.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
              r_Staff_Schedule_Date.Begin_Time       := null;
              r_Staff_Schedule_Date.End_Time         := null;
              r_Staff_Schedule_Date.Break_Enabled    := null;
              r_Staff_Schedule_Date.Break_Begin_Time := null;
              r_Staff_Schedule_Date.Break_End_Time   := null;
              r_Staff_Schedule_Date.Full_Time        := 0;
              r_Staff_Schedule_Date.Plan_Time        := 0;
              r_Staff_Schedule_Date.Day_Kind         := r.Day_Kind;
            elsif r_Registry.Take_Nonworking = 'Y' and r.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
              r_Staff_Schedule_Date.Day_Kind := r.Day_Kind;
            elsif r.Day_Kind = Htt_Pref.c_Day_Kind_Swapped then
              r_Staff_Schedule_Swaped_Date := Htt_Util.Get_Staff_Schedule_Day(i_Company_Id => r_Registry.Company_Id,
                                                                              i_Filial_Id  => r_Registry.Filial_Id,
                                                                              i_Unit_Id    => v_Unit_Ids(i),
                                                                              i_Date       => r.Swapped_Date);
            
              v_Swappable := r_Staff_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest and
                             r_Staff_Schedule_Date.Day_Kind = Htt_Pref.c_Day_Kind_Work or
                             r_Staff_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Work and
                             r_Staff_Schedule_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest;
            
              if v_Swappable then
                if r_Staff_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                  Swap_Staff_Schedule_Day(p_Rest_Day => r_Staff_Schedule_Swaped_Date,
                                          p_Work_Day => r_Staff_Schedule_Date);
                else
                  Swap_Staff_Schedule_Day(p_Rest_Day => r_Staff_Schedule_Date,
                                          p_Work_Day => r_Staff_Schedule_Swaped_Date);
                end if;
              
                z_Htt_Staff_Schedule_Days.Save_Row(r_Staff_Schedule_Swaped_Date);
              end if;
            end if;
          
            z_Htt_Staff_Schedule_Days.Save_Row(r_Staff_Schedule_Date);
          else
            r_Robot_Schedule_Date := Htt_Util.Get_Robot_Schedule_Day(i_Company_Id => r_Registry.Company_Id,
                                                                     i_Filial_Id  => r_Registry.Filial_Id,
                                                                     i_Unit_Id    => v_Unit_Ids(i),
                                                                     i_Date       => r.Calendar_Date);
          
            if r_Registry.Take_Holidays = 'Y' and r.Day_Kind = Htt_Pref.c_Day_Kind_Holiday or
               r_Registry.Take_Additional_Rest_Days = 'Y' and
               r.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
              r_Robot_Schedule_Date.Begin_Time       := null;
              r_Robot_Schedule_Date.End_Time         := null;
              r_Robot_Schedule_Date.Break_Enabled    := null;
              r_Robot_Schedule_Date.Break_Begin_Time := null;
              r_Robot_Schedule_Date.Break_End_Time   := null;
              r_Robot_Schedule_Date.Full_Time        := 0;
              r_Robot_Schedule_Date.Plan_Time        := 0;
              r_Robot_Schedule_Date.Day_Kind         := r.Day_Kind;
            elsif r_Registry.Take_Nonworking = 'Y' and r.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
              r_Robot_Schedule_Date.Day_Kind := r.Day_Kind;
            elsif r.Day_Kind = Htt_Pref.c_Day_Kind_Swapped then
              r_Robot_Schedule_Swaped_Date := Htt_Util.Get_Robot_Schedule_Day(i_Company_Id => r_Registry.Company_Id,
                                                                              i_Filial_Id  => r_Registry.Filial_Id,
                                                                              i_Unit_Id    => v_Unit_Ids(i),
                                                                              i_Date       => r.Swapped_Date);
            
              v_Swappable := r_Robot_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest and
                             r_Robot_Schedule_Date.Day_Kind = Htt_Pref.c_Day_Kind_Work or
                             r_Robot_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Work and
                             r_Robot_Schedule_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest;
            
              if v_Swappable then
                if r_Robot_Schedule_Swaped_Date.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                  Swap_Robot_Schedule_Day(p_Rest_Day => r_Robot_Schedule_Swaped_Date,
                                          p_Work_Day => r_Robot_Schedule_Date);
                else
                  Swap_Robot_Schedule_Day(p_Rest_Day => r_Robot_Schedule_Date,
                                          p_Work_Day => r_Robot_Schedule_Swaped_Date);
                end if;
              
                z_Htt_Robot_Schedule_Days.Save_Row(r_Robot_Schedule_Swaped_Date);
              end if;
            end if;
          
            z_Htt_Robot_Schedule_Days.Save_Row(r_Robot_Schedule_Date);
          end if;
        end loop;
      end loop;
    end;
  begin
    r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Registry_Id => i_Registry_Id);
  
    if r_Registry.Posted = 'Y' then
      -- todo: error message fix
      Htt_Error.Raise_093;
    end if;
  
    Check_Same_Date(i_Company_Id  => i_Company_Id,
                    i_Filial_Id   => i_Filial_Id,
                    i_Registry_Id => r_Registry.Registry_Id);
  
    r_Registry.Posted := 'Y';
  
    z_Htt_Schedule_Registries.Update_Row(r_Registry);
  
    if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      insert into Htt_Staff_Schedule_Days Sd
        (Sd.Company_Id,
         Sd.Filial_Id,
         Sd.Staff_Id,
         Sd.Schedule_Date,
         Sd.Registry_Id,
         Sd.Unit_Id,
         Sd.Day_Kind,
         Sd.Begin_Time,
         Sd.End_Time,
         Sd.Break_Enabled,
         Sd.Break_Begin_Time,
         Sd.Break_End_Time,
         Sd.Full_Time,
         Sd.Plan_Time,
         Sd.Shift_Begin_Time,
         Sd.Shift_End_Time,
         Sd.Input_Border,
         Sd.Output_Border)
        select g.Company_Id,
               g.Filial_Id,
               t.Staff_Id,
               g.Schedule_Date,
               t.Registry_Id,
               g.Unit_Id,
               g.Day_Kind,
               g.Begin_Time,
               g.End_Time,
               g.Break_Enabled,
               g.Break_Begin_Time,
               g.Break_End_Time,
               g.Full_Time,
               g.Plan_Time,
               g.Shift_Begin_Time,
               g.Shift_End_Time,
               g.Input_Border,
               g.Output_Border
          from Htt_Registry_Units t
          join Htt_Unit_Schedule_Days g
            on g.Company_Id = t.Company_Id
           and g.Filial_Id = t.Filial_Id
           and g.Unit_Id = t.Unit_Id
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Registry_Id = r_Registry.Registry_Id;
    elsif r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Robot then
      insert into Htt_Robot_Schedule_Days Sd
        (Sd.Company_Id,
         Sd.Filial_Id,
         Sd.Robot_Id,
         Sd.Schedule_Date,
         Sd.Registry_Id,
         Sd.Unit_Id,
         Sd.Day_Kind,
         Sd.Begin_Time,
         Sd.End_Time,
         Sd.Break_Enabled,
         Sd.Break_Begin_Time,
         Sd.Break_End_Time,
         Sd.Full_Time,
         Sd.Plan_Time,
         Sd.Shift_Begin_Time,
         Sd.Shift_End_Time,
         Sd.Input_Border,
         Sd.Output_Border)
        select g.Company_Id,
               g.Filial_Id,
               t.Robot_Id,
               g.Schedule_Date,
               t.Registry_Id,
               g.Unit_Id,
               g.Day_Kind,
               g.Begin_Time,
               g.End_Time,
               g.Break_Enabled,
               g.Break_Begin_Time,
               g.Break_End_Time,
               g.Full_Time,
               g.Plan_Time,
               g.Shift_Begin_Time,
               g.Shift_End_Time,
               g.Input_Border,
               g.Output_Border
          from Htt_Registry_Units t
          join Htt_Unit_Schedule_Days g
            on g.Company_Id = t.Company_Id
           and g.Filial_Id = t.Filial_Id
           and g.Unit_Id = t.Unit_Id
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Registry_Id = r_Registry.Registry_Id;
    else
      b.Raise_Not_Implemented;
    end if;
  
    if r_Registry.Calendar_Id is not null then
      Load_Calendar_Days;
    end if;
  
    if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => r_Registry.Company_Id,
                                            i_Filial_Id  => r_Registry.Filial_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    else
      v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => r_Registry.Company_Id,
                                            i_Filial_Id  => r_Registry.Filial_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    end if;
  
    Htt_Core.Gen_Individual_Dates(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Registry_Id => i_Registry_Id);
  
    Htt_Util.Check_Schedule_By_Calendar(i_Company_Id  => r_Registry.Company_Id,
                                        i_Filial_Id   => r_Registry.Filial_Id,
                                        i_Schedule_Id => v_Schedule_Id,
                                        i_Calendar_Id => r_Registry.Calendar_Id,
                                        i_Year_Begin  => Trunc(r_Registry.Month, 'year'),
                                        i_Registry_Id => r_Registry.Registry_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Registry_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Registry_Id number,
    i_Repost      boolean
  ) is
    r_Registry Htt_Schedule_Registries%rowtype;
  begin
    r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Registry_Id => i_Registry_Id);
  
    r_Registry.Posted := 'N';
  
    z_Htt_Schedule_Registries.Update_Row(r_Registry);
  
    if r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      delete Htt_Staff_Schedule_Days q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Registry_Id = i_Registry_Id;
    elsif r_Registry.Registry_Kind = Htt_Pref.c_Registry_Kind_Robot then
      delete Htt_Robot_Schedule_Days q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Registry_Id = i_Registry_Id;
    else
      b.Raise_Not_Implemented;
    end if;
  
    -- when repost this function runs into post function
    if not i_Repost then
      Htt_Core.Gen_Individual_Dates(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Registry_Id => i_Registry_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Save(i_Server Htt_Acms_Servers%rowtype) is
    r_Server      Htt_Acms_Servers%rowtype;
    v_Secret_Code varchar2(4000);
  begin
    if not z_Htt_Acms_Servers.Exist_Lock(i_Server_Id => i_Server.Server_Id, --
                                         o_Row       => r_Server) then
    
      v_Secret_Code := i_Server.Url || Sys_Guid() || i_Server.Server_Id;
    
      r_Server.Server_Id   := i_Server.Server_Id;
      r_Server.Secret_Code := Fazo.Hash_Sha1(v_Secret_Code);
    end if;
  
    r_Server.Name     := i_Server.Name;
    r_Server.Url      := i_Server.Url;
    r_Server.Order_No := i_Server.Order_No;
  
    z_Htt_Acms_Servers.Save_Row(r_Server);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Delete(i_Server_Id number) is
    v_Cnt number;
  begin
    select count(1)
      into v_Cnt
      from Htt_Company_Acms_Servers q
     where q.Server_Id = i_Server_Id;
  
    if v_Cnt > 0 then
      b.Raise_Error(t('some companies attached this server, initially you must detach companies. cnt: $1',
                      v_Cnt));
    end if;
  
    z_Htt_Acms_Servers.Delete_One(i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  ) is
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
  begin
    z_Htt_Company_Acms_Servers.Save_One(i_Company_Id => i_Company_Id, i_Server_Id => i_Server_Id);
  
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    for r in (select q.Device_Id
                from Htt_Devices q
               where q.Company_Id = i_Company_Id
                 and q.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                 and q.State = 'A')
    loop
      Acms_Command_Add(i_Company_Id   => i_Company_Id,
                       i_Device_Id    => r.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Update_Device);
    
      Acms_Command_Add(i_Company_Id   => i_Company_Id,
                       i_Device_Id    => r.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Update_All_Device_Persons);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Detach(i_Company_Id number) is
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
  begin
    z_Htt_Company_Acms_Servers.Delete_One(i_Company_Id => i_Company_Id);
  
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    for r in (select q.Device_Id
                from Htt_Devices q
               where q.Company_Id = i_Company_Id
                 and q.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id))
    loop
      Acms_Command_Add(i_Company_Id   => i_Company_Id,
                       i_Device_Id    => r.Device_Id,
                       i_Command_Kind => Htt_Pref.c_Command_Kind_Remove_Device);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Track_Insert(i_Track Htt_Acms_Tracks%rowtype) is
  begin
    z_Htt_Acms_Tracks.Insert_Row(i_Track);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Track_Integrate
  (
    i_Company_Id number,
    i_Track_Id   number
  ) is
    r_Hik_Track  Htt_Acms_Tracks%rowtype;
    r_Track      Htt_Tracks%rowtype;
    r_Device     Htt_Devices%rowtype;
    v_Filial_Ids Array_Number;
  begin
    r_Hik_Track := z_Htt_Acms_Tracks.Lock_Load(i_Company_Id => i_Company_Id,
                                               i_Track_Id   => i_Track_Id);
  
    if r_Hik_Track.Status = Htt_Pref.c_Acms_Track_Status_Completed then
      b.Raise_Error(t('acms track was already integrate, track_id=$1', i_Track_Id));
    end if;
  
    r_Device := z_Htt_Devices.Load(i_Company_Id => r_Hik_Track.Company_Id,
                                   i_Device_Id  => r_Hik_Track.Device_Id);
  
    r_Track.Company_Id  := r_Hik_Track.Company_Id;
    r_Track.Track_Time  := Htt_Util.Convert_Timestamp(i_Date     => r_Hik_Track.Track_Datetime,
                                                      i_Timezone => Htt_Util.Load_Timezone(i_Company_Id  => r_Device.Company_Id,
                                                                                           i_Location_Id => r_Device.Location_Id));
    r_Track.Track_Type  := r_Hik_Track.Track_Type;
    r_Track.Person_Id   := r_Hik_Track.Person_Id;
    r_Track.Mark_Type   := r_Hik_Track.Mark_Type;
    r_Track.Device_Id   := r_Hik_Track.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    r_Track.Is_Valid    := 'Y';
  
    v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                            i_Location_Id => r_Track.Location_Id,
                                            i_Person_Id   => r_Track.Person_Id);
  
    if v_Filial_Ids.Count = 0 then
      Htt_Error.Raise_105(i_Company_Id  => r_Track.Company_Id,
                          i_Filial_Id   => r_Track.Filial_Id,
                          i_Location_Id => r_Track.Location_Id,
                          i_Person_Id   => r_Track.Person_Id);
    end if;
  
    for i in 1 .. v_Filial_Ids.Count
    loop
      r_Track.Filial_Id := v_Filial_Ids(i);
      r_Track.Track_Id  := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  
    r_Hik_Track.Status     := Htt_Pref.c_Acms_Track_Status_Completed;
    r_Hik_Track.Error_Text := null;
  
    z_Htt_Acms_Tracks.Save_Row(r_Hik_Track);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Copies tracks from other filials to given filial
  -- Tracks are copied from hiring date in given filial
  -- First migrated employees temporary employees is filled
  -- Then tracks are migrated with attention to attached locations
  Procedure Copy_Tracks_To_Filial
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Ids Array_Number
  ) is
    r_Track Htt_Tracks%rowtype;
  
    --------------------------------------------------
    Procedure Fill_Migrated_Employees
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Employee_Ids Array_Number
    ) is
      v_Date  date := Trunc(sysdate);
      v_Count number := i_Employee_Ids.Count;
    begin
      insert into Htt_Migrated_Employees
        (Company_Id, Filial_Id, Employee_Id, Period_Begin)
        select i_Company_Id, p.Filial_Id, Qr.Employee_Id, Qr.Hiring_Date
          from (select q.Employee_Id, q.Hiring_Date
                  from Href_Staffs q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and (v_Count = 0 or q.Employee_Id member of i_Employee_Ids)
                   and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                   and q.State = 'A'
                   and q.Hiring_Date <= v_Date
                   and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)) Qr
          join Md_Filials p
            on p.Company_Id = i_Company_Id
           and p.Filial_Id <> i_Filial_Id
           and p.State = 'A';
    end;
  begin
    Fill_Migrated_Employees(i_Company_Id   => i_Company_Id,
                            i_Filial_Id    => i_Filial_Id,
                            i_Employee_Ids => i_Employee_Ids);
  
    for r in (select *
                from Htt_Tracks p
               where (p.Company_Id, p.Filial_Id, p.Person_Id) in
                     (select q.Company_Id, q.Filial_Id, q.Employee_Id
                        from Htt_Migrated_Employees q)
                 and p.Track_Date >= (select q.Period_Begin
                                        from Htt_Migrated_Employees q
                                       where q.Company_Id = p.Company_Id
                                         and q.Filial_Id = p.Filial_Id
                                         and q.Employee_Id = p.Person_Id)
                 and exists (select 1
                        from Htt_Location_Persons Lp
                       where Lp.Company_Id = i_Company_Id
                         and Lp.Filial_Id = i_Filial_Id
                         and Lp.Location_Id = p.Location_Id
                         and Lp.Person_Id = p.Person_Id)
                 and not exists (select 1
                        from Htt_Tracks T1
                       where T1.Company_Id = i_Company_Id
                         and T1.Filial_Id = i_Filial_Id
                         and T1.Track_Time = p.Track_Time
                         and T1.Person_Id = p.Person_Id
                         and Nvl(T1.Device_Id, -1) = Nvl(p.Device_Id, -1)
                         and T1.Original_Type = p.Original_Type))
    loop
      r_Track := r;
    
      r_Track.Filial_Id  := i_Filial_Id;
      r_Track.Track_Type := r.Original_Type;
      r_Track.Track_Id   := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  
    -- cleanup
    delete Htt_Migrated_Employees p
     where p.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Sync_Person_Global_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Htt_Error.Raise_080;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Htt_Pref.c_Location_Sync_Person_Global,
                           i_Value      => i_Value);
  
    Htt_Core.Global_Sync_Location_Persons(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  end;

end Htt_Api;
/
