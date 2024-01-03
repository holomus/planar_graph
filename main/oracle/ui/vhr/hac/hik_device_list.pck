create or replace package Ui_Vhr523 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Sync(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Events(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Get_Events_Response(i_Input Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Access_Level_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Levels(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Door_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Doors(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Device_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Devices(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr523;
/
create or replace package body Ui_Vhr523 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap := Hashmap();
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select p.*,
                       q.company_id,
                       hd.isup_password,
                       hd.serial_number,
                       hd.device_code,
                       hd.door_code,
                       hd.access_level_code,
                       hd.ignore_tracks
                  from hac_devices p
                  join hac_company_devices q
                    on q.device_id = p.device_id
                   and q.attach_kind = :attach_kind
                  join hac_hik_devices hd
                    on hd.device_id = p.device_id
                   and hd.server_id = p.server_id';
  
    v_Params.Put('attach_kind', Hac_Pref.c_Device_Attach_Primary);
    v_Params.Put('hik_type_id', Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision));
    v_Params.Put('event_type_column', z.Event_Type_Name);
    v_Params.Put('event_type_table', Zt.Hac_Event_Types.Name);
    v_Params.Put('lang_code', Ui_Context.Lang_Code);
  
    if p.Has('server_id') then
      v_Query := v_Query || ' where p.server_id = :server_id';
      v_Params.Put('server_id', p.r_Number('server_id'));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('device_id', 'company_id', 'server_id');
    q.Varchar2_Field('isup_password',
                     'location',
                     'device_name',
                     'device_ip',
                     'device_mac',
                     'login',
                     'password',
                     'ready',
                     'status');
    q.Varchar2_Field('serial_number',
                     'device_code',
                     'door_code',
                     'access_level_code',
                     'ignore_tracks');
  
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
                                           join hac_hik_company_servers p
                                             on p.company_id = q.company_id
                                            and p.server_id = :server_id');
  
    q.Multi_Number_Field(i_Name        => 'event_type_codes',
                         i_Table_Name  => 'select q.*
                                             from hac_device_event_types q
                                            where q.server_id = :server_id
                                              and q.device_type_id = :hik_type_id',
                         i_Join_Clause => '@device_id = $device_id',
                         i_For         => 'event_type_code');
  
    q.Refer_Field(i_Name       => 'event_type_names',
                  i_For        => 'event_type_codes',
                  i_Table_Name => 'select q.event_type_code, nvl(p.val, q.event_type_name) event_type_name
                                     from hac_event_types q
                                     left join md_table_record_translates p
                                       on p.table_name = :event_type_table
                                      and p.pcode = q.event_type_name
                                      and p.column_name = :event_type_column
                                    where q.device_type_id = :hik_type_id
                                      and q.access_granted = ''Y''',
                  i_Code_Field => 'event_type_code',
                  i_Name_Field => 'event_type_name');
  
    q.Option_Field('ignore_tracks_name',
                   'ignore_tracks',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync(p Hashmap) is
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
               where q.Device_Id = p.Device_Id
                 and q.Attach_Kind = Hac_Pref.c_Device_Attach_Primary)
         and exists (select 1
                from Hac_Hik_Devices Hd
               where Hd.Device_Id = p.Device_Id
                 and Hd.Server_Id = p.Server_Id);
    end if;
  
    for i in 1 .. v_Device_Ids.Count
    loop
      Hac_Api.Hik_Device_Sync(i_Server_Id => v_Server_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Events(p Hashmap) return Runtime_Service is
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t();
    v_Door_Codes Json_Array_t := Json_Array_t();
  
    -------------------------------------------------- 
    Function Format_Date(i_Date varchar2) return varchar2 is
    begin
      return to_char(to_date(i_Date, Href_Pref.c_Date_Format_Minute), 'YYYY-MM-DD"T"HH24:MI:SS') || to_char(Current_Timestamp,
                                                                                                            'TZH:TZM');
    end;
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => g_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => g_Server_Id);
    v_Data.Put('pageNo', p.r_Number('pageNo'));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
    v_Data.Put('startTime', Format_Date(p.r_Varchar2('start_time')));
    v_Data.Put('endTime', Format_Date(p.r_Varchar2('end_time')));
    v_Data.Put('eventType', p.r_Number('event_type'));
    v_Door_Codes.Append(p.r_Varchar2('door_code'));
    v_Data.Put('doorIndexCodes', v_Door_Codes);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Events,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'ui_vhr523.get_events_response');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Events_Response(i_Input Array_Varchar2) return Hashmap is
    v_Data   Gmap := Gmap(Json_Object_t(Fazo.Make_Clob(i_Input)));
    v_Tracks Glist;
  begin
    v_Tracks := Nvl(v_Data.o_Glist('list'), Glist());
  
    Hac_Core.Save_Hik_Tracks(i_Server_Id   => g_Server_Id,
                             i_Source_Type => Hac_Pref.c_Hik_Event_Type_Manually_Retrieved,
                             i_Tracks      => v_Tracks);
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Tracks.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Level_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Access_Level_List_Response_Handler(i_Val       => i_Val,
                                                          i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Levels(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Access_Levels(p                    => p,
                                         i_Response_Procedure => 'Ui_Vhr523.Access_Level_List_Response_Handler',
                                         i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Door_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Door_List_Response_Handler(i_Val => i_Val, i_Server_Id => g_Server_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Doors(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Doors(p                    => p,
                                 i_Response_Procedure => 'Ui_Vhr523.Door_List_Response_Handler',
                                 i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Device_List_Response_Handler(i_Val => i_Val, i_Server_Id => g_Server_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Devices(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Devices(p                    => p,
                                   i_Response_Procedure => 'Ui_Vhr523.Device_List_Response_Handler',
                                   i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id  number := p.r_Number('server_id');
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Hac_Api.Hik_Device_Delete(i_Server_Id => v_Server_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Devices
       set Device_Id   = null,
           Server_Id   = null,
           Device_Name = null,
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
  
    update Hac_Hik_Company_Servers
       set Company_Id = null,
           Server_Id  = null;
  
    update Hac_Hik_Devices
       set Server_Id         = null,
           Device_Id         = null,
           Isup_Password     = null,
           Serial_Number     = null,
           Device_Code       = null,
           Door_Code         = null,
           Access_Level_Code = null,
           Ignore_Tracks     = null;
  
    update Hac_Device_Event_Types
       set Server_Id       = null,
           Device_Id       = null,
           Device_Type_Id  = null,
           Event_Type_Code = null;
  
    update Hac_Event_Types
       set Device_Type_Id  = null,
           Event_Type_Code = null,
           Event_Type_Name = null;
  end;

end Ui_Vhr523;
/
