create or replace package Ui_Vhr506 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Devices(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks_Response(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Ex_Device_Codes(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Devices_Response(i_Data Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Devices(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Access_Groups_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Groups(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Device_Info_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Info(p Hashmap) return Runtime_Service;
end Ui_Vhr506;
/
create or replace package body Ui_Vhr506 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;
  g_Device_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals
  (
    i_Server_Id number := null,
    i_Device_Id number := null
  ) is
  begin
    g_Server_Id := i_Server_Id;
    g_Device_Id := i_Device_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select p.*, 
                            q.company_id,
                            dd.serial_number,
                            dd.device_code,
                            dd.access_group_code
                       from hac_devices p
                       join hac_company_devices q
                         on q.device_id = p.device_id
                        and q.attach_kind = :attach_kind
                       join hac_dss_devices dd
                         on dd.device_id = p.device_id
                        and dd.server_id = p.server_id
                      where p.server_id = :server_id',
                    Fazo.Zip_Map('attach_kind',
                                 Hac_Pref.c_Device_Attach_Primary,
                                 'server_id',
                                 p.r_Number('server_id')));
  
    q.Number_Field('device_id', 'company_id', 'server_id');
    q.Varchar2_Field('device_name',
                     'device_ip',
                     'device_mac',
                     'login',
                     'password',
                     'location',
                     'ready',
                     'status');
    q.Varchar2_Field('serial_number', 'device_code', 'access_group_code');
  
    v_Matrix := Hac_Util.Device_Statuses;
  
    q.Option_Field(i_Name  => 'status_name',
                   i_For   => 'status',
                   i_Codes => v_Matrix(1),
                   i_Names => v_Matrix(2));
  
    q.Option_Field(i_Name  => 'ready_name',
                   i_For   => 'ready',
                   i_Codes => Array_Varchar2('Y', 'N'),
                   i_Names => Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field(i_Name             => 'company_name',
                  i_For              => 'company_id',
                  i_Table_Name       => 'md_companies',
                  i_Code_Field       => 'company_id',
                  i_Name_Field       => 'name',
                  i_Table_For_Select => 'select q.*
                                           from md_companies q
                                           join hac_dss_company_servers p
                                             on p.company_id = q.company_id
                                            and p.server_id = :server_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id  number := p.r_Number('server_id');
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Hac_Api.Dss_Device_Delete(i_Server_Id => v_Server_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device
  (
    i_Server_Id number,
    i_Device_Id number
  ) is
    r_Device    Hac_Devices%rowtype := z_Hac_Devices.Load(i_Server_Id => i_Server_Id,
                                                          i_Device_Id => i_Device_Id);
    r_Ex_Device Hac_Dss_Ex_Devices%rowtype;
  
    v_Access_Group_Code varchar2(300 char);
    v_Status            varchar2(1);
    v_Ready             varchar2(1) := 'N';
  
    --------------------------------------------------
    Function Take_Ex_Device
    (
      i_Server_Id   number,
      i_Device_Name varchar2
    ) return Hac_Dss_Ex_Devices%rowtype is
      r_Ex_Device Hac_Dss_Ex_Devices%rowtype;
    begin
      select q.*
        into r_Ex_Device
        from Hac_Dss_Ex_Devices q
       where q.Server_Id = i_Server_Id
         and q.Device_Name = i_Device_Name;
    
      return r_Ex_Device;
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Function Get_Access_Group_Code
    (
      i_Server_Id   number,
      i_Device_Name varchar2
    ) return varchar2 is
      result Hac_Dss_Devices.Access_Group_Code%type;
    begin
      select q.Access_Group_Code
        into result
        from Hac_Dss_Ex_Access_Groups q
       where q.Server_Id = i_Server_Id
         and q.Access_Group_Name = i_Device_Name;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  
  begin
    r_Ex_Device := Take_Ex_Device(i_Server_Id => i_Server_Id, i_Device_Name => r_Device.Device_Name);
  
    if r_Ex_Device.Device_Code is null then
      return;
    end if;
  
    v_Access_Group_Code := Get_Access_Group_Code(i_Server_Id   => i_Server_Id,
                                                 i_Device_Name => r_Device.Device_Name);
  
    v_Status := case r_Ex_Device.Status
                  when 0 then
                   Hac_Pref.c_Device_Status_Offline
                  when 1 then
                   Hac_Pref.c_Device_Status_Online
                  else
                   Hac_Pref.c_Device_Status_Unknown
                end;
  
    if v_Access_Group_Code is not null and r_Ex_Device.Serial_Number is not null and
       r_Ex_Device.Device_Code is not null then
      v_Ready := 'Y';
    end if;
  
    Hac_Api.Dss_Device_Update(i_Server_Id         => i_Server_Id,
                              i_Device_Id         => i_Device_Id,
                              i_Device_Ip         => Option_Varchar2(r_Ex_Device.Device_Ip),
                              i_Ready             => Option_Varchar2(v_Ready),
                              i_Status            => Option_Varchar2(v_Status),
                              i_Serial_Number     => Option_Varchar2(r_Ex_Device.Serial_Number),
                              i_Device_Code       => Option_Varchar2(r_Ex_Device.Device_Code),
                              i_Access_Group_Code => Option_Varchar2(v_Access_Group_Code));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Devices(p Hashmap) is
    v_Server_Id  number := p.r_Number('server_id');
    v_Device_Ids Array_Number := Fazo.Sort(p.o_Array_Number('device_id'));
  begin
    if v_Device_Ids is null then
      select p.Device_Id
        bulk collect
        into v_Device_Ids
        from Hac_Devices p
       where p.Server_Id = v_Server_Id
         and p.Ready = 'N'
         and exists (select 1
                from Hac_Company_Devices q
               where q.Device_Id = p.Device_Id)
         and exists (select 1
                from Hac_Dss_Devices Dd
               where Dd.Device_Id = p.Device_Id
                 and Dd.Server_Id = p.Server_Id);
    end if;
  
    for i in 1 .. v_Device_Ids.Count
    loop
      Sync_Device(i_Server_Id => v_Server_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Device_Track
  (
    i_Server_Id   number,
    i_Person_Code varchar2,
    i_Track_Time  number,
    i_Photo_Sha   varchar2,
    i_Device      Htt_Devices%rowtype
  ) is
    v_Filial_Ids Array_Number;
    r_Track      Htt_Tracks%rowtype;
  begin
    r_Track.Company_Id  := i_Device.Company_Id;
    r_Track.Device_Id   := i_Device.Device_Id;
    r_Track.Location_Id := i_Device.Location_Id;
    r_Track.Person_Id   := Hac_Util.Take_Person_Id_By_Code(i_Server_Id   => i_Server_Id,
                                                           i_Company_Id  => i_Device.Company_Id,
                                                           i_Person_Code => i_Person_Code);
    r_Track.Track_Type  := Htt_Pref.c_Track_Type_Check;
    r_Track.Mark_Type   := Htt_Pref.c_Mark_Type_Face;
    r_Track.Track_Time  := Htt_Util.Convert_Timestamp(i_Date     => Hac_Util.Unix_Ts_To_Date(i_Track_Time),
                                                      i_Timezone => Hac_Pref.c_Utc_Timezone_Code);
    r_Track.Is_Valid    := 'Y';
    r_Track.Photo_Sha   := i_Photo_Sha;
  
    v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                            i_Location_Id => r_Track.Location_Id,
                                            i_Person_Id   => r_Track.Person_Id);
  
    for j in 1 .. v_Filial_Ids.Count
    loop
      Ui_Context.Init_Migr(i_Company_Id   => i_Device.Company_Id,
                           i_Filial_Id    => v_Filial_Ids(j),
                           i_User_Id      => Md_Pref.User_System(i_Device.Company_Id),
                           i_Project_Code => Verifix.Project_Code);
    
      r_Track.Filial_Id := v_Filial_Ids(j);
      r_Track.Track_Id  := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks_Response(p Hashmap) return Hashmap is
    v_Total_Cnt number := p.r_Number('totalCount');
    v_Tracks    Arraylist := p.r_Arraylist('pageData');
    v_Track     Hashmap;
  
    r_Server Hac_Servers%rowtype := z_Hac_Servers.Load(g_Server_Id);
    r_Device Hac_Dss_Devices%rowtype := z_Hac_Dss_Devices.Load(i_Server_Id => g_Server_Id,
                                                               i_Device_Id => g_Device_Id);
  
    r_Htt_Device     Htt_Devices%rowtype;
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    v_Hac_Device_Type_Id number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Dahua);
  
    v_Person_Code     varchar2(300 char);
    v_Photo_Url       varchar2(300 char);
    v_Photo_Sha       varchar2(64);
    v_Track_Time      number;
    v_Event_Type_Code number;
  
    --------------------------------------------------
    Procedure Save_Notification_Message
    (
      i_Host_Url    varchar2,
      i_Person_Code varchar2,
      i_Device_Code varchar2,
      i_Track_Time  number,
      i_Photo_Url   varchar2,
      i_Photo_Sha   varchar2,
      i_Event_Type  number,
      i_Extra_Info  varchar2
    ) is
      pragma autonomous_transaction;
    begin
      z_Hac_Dss_Tracks.Insert_Try(i_Host_Url        => i_Host_Url,
                                  i_Person_Code     => Nvl(i_Person_Code,
                                                           Hac_Pref.c_Unknown_Person_Code),
                                  i_Device_Code     => i_Device_Code,
                                  i_Track_Time      => i_Track_Time,
                                  i_Source_Type     => Hac_Pref.c_Dss_Track_Source_Manual,
                                  i_Photo_Url       => i_Photo_Url,
                                  i_Photo_Sha       => i_Photo_Sha,
                                  i_Event_Type_Code => i_Event_Type,
                                  i_Extra_Info      => i_Extra_Info);
      commit;
    end;
  begin
    for i in 1 .. v_Tracks.Count
    loop
      v_Track := Treat(v_Tracks.r_Hashmap(i) as Hashmap);
    
      v_Person_Code     := v_Track.r_Varchar2('personId');
      v_Track_Time      := v_Track.r_Number('alarmTime');
      v_Photo_Url       := v_Track.o_Varchar2('captureImageUrl');
      v_Photo_Sha       := v_Track.o_Varchar2('photo_sha');
      v_Event_Type_Code := v_Track.o_Number('alarmTypeId');
    
      Save_Notification_Message(i_Host_Url    => r_Server.Host_Url,
                                i_Person_Code => v_Person_Code,
                                i_Device_Code => r_Device.Device_Code,
                                i_Track_Time  => v_Track_Time,
                                i_Photo_Url   => v_Photo_Url,
                                i_Photo_Sha   => v_Photo_Sha,
                                i_Event_Type  => v_Event_Type_Code,
                                i_Extra_Info  => v_Track.Json);
    
      continue when not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id  => v_Hac_Device_Type_Id,
                                                    i_Event_Type_Code => v_Event_Type_Code);
    
      for r in (select *
                  from Hac_Company_Devices Cd
                 where Cd.Device_Id = r_Device.Device_Id)
      loop
        r_Htt_Device := Htt_Util.Take_Device_By_Serial_Number(i_Company_Id     => r.Company_Id,
                                                              i_Device_Type_Id => v_Device_Type_Id,
                                                              i_Serial_Number  => r_Device.Serial_Number);
      
        Save_Device_Track(i_Server_Id   => g_Server_Id,
                          i_Person_Code => v_Person_Code,
                          i_Track_Time  => v_Track_Time,
                          i_Photo_Sha   => v_Photo_Sha,
                          i_Device      => r_Htt_Device);
      end loop;
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Total_Cnt / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Tracks.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks(p Hashmap) return Runtime_Service is
    r_Device     Hac_Devices%rowtype := z_Hac_Devices.Load(i_Server_Id => p.r_Number('server_id'),
                                                           i_Device_Id => p.r_Number('device_id'));
    r_Dss_Device Hac_Dss_Devices%rowtype := z_Hac_Dss_Devices.Load(i_Server_Id => p.r_Number('server_id'),
                                                                   i_Device_Id => p.r_Number('device_id'));
    v_Data       Gmap := Gmap();
  begin
    if r_Device.Ready = 'N' then
      b.Raise_Error('device not ready');
    end if;
  
    Init_Globals(i_Server_Id => r_Device.Server_Id, i_Device_Id => r_Device.Device_Id);
  
    v_Data.Put('page', Nvl(p.o_Number('page_num'), Hac_Pref.c_Start_Page_Num));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
  
    v_Data.Put('channelIds',
               Array_Varchar2(r_Dss_Device.Device_Code || Hac_Pref.c_Default_Channel_Id_Tail));
    v_Data.Put('startTime',
               Hac_Util.Date_To_Unix_Ts(p.r_Date('start_time', Href_Pref.c_Date_Format_Minute)));
    v_Data.Put('endTime',
               Hac_Util.Date_To_Unix_Ts(p.r_Date('end_time', Href_Pref.c_Date_Format_Minute)));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => g_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Tracks_Fetch_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Post,
                                          i_Responce_Procedure => 'Ui_Vhr506.Load_Tracks_Response',
                                          i_Data               => v_Data);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Ex_Device_Codes(p Hashmap) return Hashmap is
    v_Server_Id    number := p.r_Number('server_id');
    v_Device_Codes Array_Varchar2;
    result         Hashmap := Hashmap();
  begin
    select q.Device_Code
      bulk collect
      into v_Device_Codes
      from Hac_Dss_Ex_Devices q
     where q.Server_Id = v_Server_Id;
  
    Result.Put('codes', v_Device_Codes);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Devices_Response(i_Data Hashmap) return Hashmap is
  begin
    Init_Globals(i_Server_Id => g_Server_Id);
  
    return Uit_Hac.Dss_Get_Devices_Response(i_Data => i_Data, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Devices(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Dss_Get_Devices(p                    => p,
                                   i_Responce_Procedure => 'Ui_Vhr506.Get_Devices_Response',
                                   i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Access_Groups_Response(i_Data Hashmap) is
  begin
    Uit_Hac.Dss_Get_Access_Groups_Response(i_Data => i_Data, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Groups(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Dss_Get_Access_Groups(i_Responce_Procedure => 'Ui_Vhr506.Get_Access_Groups_Response',
                                         i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Device_Info_Response(i_Data Hashmap) is
  begin
    z_Hac_Dss_Ex_Devices.Update_One(i_Server_Id     => g_Server_Id,
                                    i_Device_Code   => i_Data.r_Varchar2('deviceCode'),
                                    i_Register_Code => Option_Varchar2(i_Data.r_Varchar2('registerId')),
                                    i_Serial_Number => Option_Varchar2(i_Data.o_Varchar2('deviceSn')),
                                    i_Extra_Info    => Option_Varchar2(i_Data.Json));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Info(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => g_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Device_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => 'Ui_Vhr506.Get_Device_Info_Response',
                                          i_Object_Id          => p.r_Varchar2('device_code'),
                                          i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Devices
       set Device_Id   = null,
           Server_Id   = null,
           Device_Name = null,
           Location    = null,
           Device_Ip   = null,
           Device_Mac  = null,
           Login       = null,
           Password    = null,
           Ready       = null,
           Status      = null;
  
    update Hac_Company_Devices
       set Company_Id  = null,
           Device_Id   = null,
           Attach_Kind = null;
  
    update Md_Companies
       set Company_Id = null,
           State      = null;
  
    update Hac_Dss_Devices
       set Server_Id         = null,
           Device_Id         = null,
           Serial_Number     = null,
           Device_Code       = null,
           Access_Group_Code = null;
  end;

end Ui_Vhr506;
/
