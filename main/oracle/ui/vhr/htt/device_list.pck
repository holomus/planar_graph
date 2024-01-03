create or replace package Ui_Vhr80 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks_Response(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr80;
/
create or replace package body Ui_Vhr80 is
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
    v_Data       Hashmap;
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
  
    if Ui.Is_Filial_Head then
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
    else
      Ui_Context.Init_Migr(i_Company_Id   => i_Device.Company_Id,
                           i_Filial_Id    => Ui.Filial_Id,
                           i_User_Id      => Md_Pref.User_System(i_Device.Company_Id),
                           i_Project_Code => Verifix.Project_Code);
    
      r_Track.Filial_Id := Ui.Filial_Id;
      r_Track.Track_Id  := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end if;
  
  exception
    when others then
      v_Data := z_Htt_Tracks.To_Map(r_Track,
                                    z.Company_Id,
                                    z.Filial_Id,
                                    z.Device_Id,
                                    z.Location_Id,
                                    z.Person_Id,
                                    z.Track_Type,
                                    z.Mark_Type,
                                    z.Track_Time);
      v_Data.Put('person_code', i_Person_Code);
    
      Hac_Core.Save_Error_Log(i_Request_Params => v_Data.Json,
                              i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) ||
                                                  Chr(10) || Dbms_Utility.Format_Error_Backtrace);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks_Response(p Hashmap) return Hashmap is
    v_Total_Cnt number := p.r_Number('totalCount');
    v_Tracks    Arraylist := p.r_Arraylist('pageData');
    v_Track     Hashmap;
  
    r_Server Hac_Servers%rowtype := z_Hac_Servers.Load(g_Server_Id);
    r_Device Hac_Dss_Devices%rowtype := z_Hac_Dss_Devices.Load(i_Server_Id => g_Server_Id,
                                                               i_Device_Id => g_Device_Id);
  
    r_Htt_Device         Htt_Devices%rowtype;
    v_Device_Type_Id     number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
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
      return null;
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
                                          i_Responce_Procedure => 'Ui_Vhr80.Load_Tracks_Response',
                                          i_Data               => v_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Location_Id    number := p.o_Number('location_id');
    v_Is_Filial_Head varchar2(1) := 'N';
    v_Count          number;
    result           Hashmap := Hashmap();
  begin
    if Ui.Is_Filial_Head then
      v_Is_Filial_Head := 'Y';
    end if;
  
    select count(*)
      into v_Count
      from Htt_Devices q
     where q.Company_Id = Ui.Company_Id
       and (v_Location_Id is null or q.Location_Id = v_Location_Id)
       and q.State = 'A'
       and exists (select 1
              from Htt_Unknown_Devices w
             where w.Company_Id = q.Company_Id
               and w.Device_Id = q.Device_Id)
       and (v_Is_Filial_Head = 'Y' or exists
            (select 1
               from Htt_Location_Filials Lf
              where Lf.Company_Id = Ui.Company_Id
                and Lf.Filial_Id = Ui.Filial_Id
                and Lf.Location_Id = q.Location_Id));
  
    Result.Put('terminal_device_type_id',
               Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal));
    Result.Put('hikvision_device_type_id',
               Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision));
    Result.Put('dahua_device_type_id', Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua));
    Result.Put('unknowns_count', v_Count);
    Result.Put('begin_date', Trunc(sysdate, 'mon'));
    Result.Put('end_date', sysdate);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'staff_device_type_id',
                             Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff));
    v_Query  := 'select q.*,
                        hd.ready,
                        hd.server_id,
                        hd.device_id as hac_device_id
                   from htt_devices q
                   left join hac_dss_devices dd
                     on dd.serial_number = q.serial_number
                   left join hac_devices hd
                     on hd.device_id = dd.device_id
                    and hd.server_id = dd.server_id
                    and exists (select 1
                           from hac_company_devices cd
                          where cd.company_id = :company_id
                            and cd.device_id = hd.device_id)
                  where q.company_id = :company_id
                    and q.device_type_id <> :staff_device_type_id';
  
    if p.Has('location_id') then
      v_Params.Put('location_id', p.r_Number('location_id'));
    
      v_Query := v_Query || --
                 ' and q.location_id = :location_id';
    end if;
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('device_id',
                   'device_type_id',
                   'location_id',
                   'charge_percentage',
                   'server_id',
                   'hac_device_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name',
                     'serial_number',
                     'lang_code',
                     'autogen_inputs',
                     'autogen_outputs',
                     'use_settings',
                     'restricted_type',
                     'only_last_restricted',
                     'state',
                     'status');
  
    q.Varchar2_Field('ignore_tracks', 'ignore_images', 'ready');
    q.Date_Field('last_seen_on', 'created_on', 'modified_on');
  
    q.Refer_Field('device_type_name',
                  'device_type_id',
                  'htt_device_types',
                  'device_type_id',
                  'name');
  
    v_Query := 'select s.*
                  from htt_locations s
                 where s.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = s.location_id)';
    end if;
  
    q.Refer_Field('location_name', 'location_id', 'htt_locations', 'location_id', 'name', v_Query);
    q.Option_Field('ready_name',
                   'ready',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Refer_Field('timezone_code',
                  'location_id',
                  'htt_locations',
                  'location_id',
                  'timezone_code',
                  v_Query);
    q.Refer_Field('lang_name',
                  'lang_code',
                  'md_langs',
                  'lang_code',
                  'name',
                  'select * 
                     from md_langs s 
                    where s.state = ''A''');
  
    q.Option_Field('autogen_inputs_name',
                   'autogen_inputs',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('autogen_outputs_name',
                   'autogen_outputs',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('ignore_tracks_name',
                   'ignore_tracks',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('ignore_images_name',
                   'ignore_images',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('only_last_restricted_name',
                   'only_last_restricted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('use_settings_name',
                   'use_settings',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    v_Matrix := Htt_Util.Track_Types;
    q.Option_Field('restricted_type_name', 'restricted_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Device_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Htt_Api.Device_Delete(i_Company_Id => Ui.Company_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Devices
       set Company_Id           = null,
           Device_Id            = null,
           name                 = null,
           Device_Type_Id       = null,
           Serial_Number        = null,
           Location_Id          = null,
           Charge_Percentage    = null,
           Lang_Code            = null,
           Use_Settings         = null,
           Last_Seen_On         = null,
           Autogen_Inputs       = null,
           Autogen_Outputs      = null,
           Ignore_Tracks        = null,
           Ignore_Images        = null,
           Restricted_Type      = null,
           Only_Last_Restricted = null,
           State                = null,
           Status               = null,
           Created_By           = null,
           Created_On           = null,
           Modified_By          = null,
           Modified_On          = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Md_Langs
       set Lang_Code = null,
           name      = null,
           State     = null;
    update Hac_Dss_Devices
       set Server_Id     = null,
           Device_Id     = null,
           Serial_Number = null;
    update Hac_Company_Devices
       set Company_Id  = null,
           Device_Id   = null,
           Attach_Kind = null;
  end;

end Ui_Vhr80;
/
