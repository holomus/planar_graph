set define off
create or replace package Hac_Job is
  ----------------------------------------------------------------------------------------------------
  Procedure Dahua_Track_Load_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dahua_Tracks(i_Input Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Face_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Fingerprint_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Card_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Tracks(i_Input Array_Varchar2);
  ----------------------------------------------------------------------------------------------------  
  Procedure Dss_Device_Update_Response(i_Val Array_Varchar2);
  ----------------------------------------------------------------------------------------------------  
  Procedure Hik_Device_Update_Response(i_Val Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure All_Device_Status_Update_Request(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure All_Device_Status_Update_Response(i_Input Array_Varchar2);
end Hac_Job;
/
create or replace package body Hac_Job is
  c_Start_Time constant date := Trunc(sysdate) - 2;
  c_End_Time   constant date := sysdate;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Temp_Tables is
    pragma autonomous_transaction;
  begin
    delete from Hac_Temp_Ex_Hik_Device_Infos;
    delete from Hac_Temp_Ex_Dss_Device_Infos;
    delete from Hac_Temp_Device_Infos;
  
    commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dahua_Track_Load_Request_Procedure(o_Output out Array_Varchar2) is
    v_Detail_Map   Gmap;
    v_Data_Map     Gmap;
    v_Company_Data Gmap;
    v_Company_List Glist := Glist();
    result         Gmap := Gmap();
  
    --------------------------------------------------
    Function Prepare_Detail_Map
    (
      i_Host_Url varchar2,
      i_Username varchar2,
      i_Password varchar2
    ) return Gmap is
      v_Details      Gmap := Gmap();
      v_Auth_Details Gmap := Gmap();
    begin
      v_Details.Put('host_url', i_Host_Url);
      v_Details.Put('method', Href_Pref.c_Http_Method_Post);
      v_Details.Put('api_uri', Hac_Pref.c_Tracks_Fetch_Uri);
      v_Details.Put('object_id', '');
      v_Details.Put('query_params', '');
      v_Details.Put('face_picture_sha', '');
    
      v_Auth_Details.Put('username', i_Username);
      v_Auth_Details.Put('password', i_Password);
    
      v_Details.Put('auth_details', v_Auth_Details);
    
      return v_Details;
    end;
  
    --------------------------------------------------
    Function Prepare_Data_Map
    (
      i_Company_Id number,
      i_Server_Id  number,
      i_Start_Time date,
      i_End_Time   date
    ) return Gmap is
      v_Channel_Ids Array_Varchar2;
      v_Data        Gmap := Gmap();
    begin
      select p.Device_Code || Hac_Pref.c_Default_Channel_Id_Tail
        bulk collect
        into v_Channel_Ids
        from Hac_Company_Devices q
        join Hac_Dss_Devices p
          on p.Device_Id = q.Device_Id
       where q.Company_Id = i_Company_Id
         and p.Server_Id = i_Server_Id;
    
      v_Data.Val.Put('page', Hac_Pref.c_Start_Page_Num);
      v_Data.Val.Put('pageSize', Hac_Pref.c_Default_Page_Size);
    
      v_Data.Put('channelIds', v_Channel_Ids);
      v_Data.Put('startTime', Hac_Util.Date_To_Unix_Ts(i_Start_Time));
      v_Data.Put('endTime', Hac_Util.Date_To_Unix_Ts(i_End_Time));
    
      return v_Data;
    end;
  
  begin
    Clear_Temp_Tables;
  
    for Cmp in (select q.*,
                       Sv.Username,
                       Sv.Password,
                       (select Sr.Host_Url
                          from Hac_Servers Sr
                         where Sr.Server_Id = q.Server_Id) Host_Url
                  from Hac_Dss_Company_Servers q
                  join Hac_Dss_Servers Sv
                    on Sv.Server_Id = q.Server_Id
                 where exists (select 1
                          from Hac_Company_Devices p
                          join Hac_Dss_Devices Dv
                            on Dv.Device_Id = p.Device_Id
                         where p.Company_Id = q.Company_Id
                           and Dv.Server_Id = q.Server_Id))
    loop
      v_Company_Data := Gmap();
    
      v_Detail_Map := Prepare_Detail_Map(i_Host_Url => Cmp.Host_Url,
                                         i_Username => Cmp.Username,
                                         i_Password => Cmp.Password);
      v_Data_Map   := Prepare_Data_Map(i_Company_Id => Cmp.Company_Id,
                                       i_Server_Id  => Cmp.Server_Id,
                                       i_Start_Time => c_Start_Time,
                                       i_End_Time   => c_End_Time);
    
      v_Company_Data.Put('detail', v_Detail_Map);
      v_Company_Data.Put('request_data', v_Data_Map);
      v_Company_Data.Put('host_url', Cmp.Host_Url);
      v_Company_Data.Put('server_id', Cmp.Server_Id);
      v_Company_Data.Put('company_id', Cmp.Company_Id);
      v_Company_Data.Put('iterator_key', 'page');
      v_Company_Data.Put('tracks_key', 'pageData');
    
      v_Company_List.Push(v_Company_Data.Val);
    end loop;
  
    Result.Put('dahua', v_Company_List);
    Result.Put('dahua_procedure', 'HAC_JOB.SAVE_DAHUA_TRACKS');
  
    o_Output := Fazo.Read_Clob(Result.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dahua_Tracks(i_Input Array_Varchar2) is
    v_Company Gmap := Gmap(Json_Object_t.Parse(Fazo.Make_Clob(i_Input)));
  begin
    Hac_Core.Save_Dahua_Tracks(i_Host_Url    => v_Company.r_Varchar2('host_url'),
                               i_Source_Type => Hac_Pref.c_Dss_Track_Source_Job,
                               i_Tracks      => v_Company.r_Glist('tracks'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_Load_Request_Procedure
  (
    i_Event_Type number,
    o_Output     out Array_Varchar2
  ) is
    v_Detail_Map   Gmap;
    v_Data_Map     Gmap;
    v_Company_Data Gmap;
    v_Company_List Glist := Glist();
    result         Gmap := Gmap();
  
    -------------------------------------------------- 
    Function Format_Date(i_Date date) return varchar2 is
    begin
      return to_char(i_Date, 'YYYY-MM-DD"T"HH24:MI:SS') || Substr(Tz_Offset(Sessiontimezone), 1, 6);
    end;
  
    --------------------------------------------------
    Function Prepare_Detail_Map
    (
      i_Host_Url       varchar2,
      i_Partner_Key    varchar2,
      i_Partner_Secret varchar2
    ) return Gmap is
      v_Details Gmap := Gmap();
    begin
      v_Details.Put('partner_key', i_Partner_Key);
      v_Details.Put('partner_secret', i_Partner_Secret);
      v_Details.Put('host_url', i_Host_Url);
      v_Details.Put('request_path', Hac_Pref.c_Hik_Request_Path_Get_Events);
    
      return v_Details;
    end;
  
    --------------------------------------------------
    Function Prepare_Data_Map
    (
      i_Company_Id number,
      i_Server_Id  number,
      i_Event_Type number,
      i_Start_Time date,
      i_End_Time   date
    ) return Gmap is
      v_Door_Codes Array_Varchar2;
      v_Data       Gmap := Gmap();
    begin
      select p.Door_Code
        bulk collect
        into v_Door_Codes
        from Hac_Company_Devices q
        join Hac_Hik_Devices p
          on p.Device_Id = q.Device_Id
       where q.Company_Id = i_Company_Id
         and p.Server_Id = i_Server_Id;
    
      v_Data.Val.Put('pageNo', Hac_Pref.c_Start_Page_Num);
      v_Data.Val.Put('pageSize', Hac_Pref.c_Default_Page_Size);
    
      v_Data.Val.Put('eventType', i_Event_Type);
      v_Data.Put('doorIndexCodes', v_Door_Codes);
      v_Data.Put('startTime', Format_Date(i_Start_Time));
      v_Data.Put('endTime', Format_Date(i_End_Time));
    
      return v_Data;
    end;
  
  begin
    Clear_Temp_Tables;
  
    for Cmp in (select q.*,
                       Sv.Partner_Key,
                       Sv.Partner_Secret,
                       (select Sr.Host_Url
                          from Hac_Servers Sr
                         where Sr.Server_Id = q.Server_Id) Host_Url
                  from Hac_Hik_Company_Servers q
                  join Hac_Hik_Servers Sv
                    on Sv.Server_Id = q.Server_Id
                 where exists (select 1
                          from Hac_Company_Devices p
                          join Hac_Hik_Devices Dv
                            on Dv.Device_Id = p.Device_Id
                         where p.Company_Id = q.Company_Id
                           and Dv.Server_Id = q.Server_Id))
    loop
      v_Company_Data := Gmap();
    
      v_Detail_Map := Prepare_Detail_Map(i_Host_Url       => Cmp.Host_Url,
                                         i_Partner_Key    => Cmp.Partner_Key,
                                         i_Partner_Secret => Cmp.Partner_Secret);
      v_Data_Map   := Prepare_Data_Map(i_Company_Id => Cmp.Company_Id,
                                       i_Server_Id  => Cmp.Server_Id,
                                       i_Event_Type => i_Event_Type,
                                       i_Start_Time => c_Start_Time,
                                       i_End_Time   => c_End_Time);
    
      v_Company_Data.Put('detail', v_Detail_Map);
      v_Company_Data.Put('request_data', v_Data_Map);
      v_Company_Data.Put('host_url', Cmp.Host_Url);
      v_Company_Data.Put('server_id', Cmp.Server_Id);
      v_Company_Data.Put('company_id', Cmp.Company_Id);
      v_Company_Data.Put('iterator_key', 'pageNo');
      v_Company_Data.Put('tracks_key', 'list');
    
      v_Company_List.Push(v_Company_Data.Val);
    end loop;
  
    Result.Put('hik', v_Company_List);
    Result.Put('hik_procedure', 'HAC_JOB.SAVE_HIK_TRACKS');
  
    o_Output := Fazo.Read_Clob(Result.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Face_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Hik_Track_Load_Request_Procedure(i_Event_Type => Hac_Pref.c_Hik_Event_Code_By_Face,
                                     o_Output     => o_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Fingerprint_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Hik_Track_Load_Request_Procedure(i_Event_Type => Hac_Pref.c_Hik_Event_Code_By_Fingerprint,
                                     o_Output     => o_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Track_By_Card_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Hik_Track_Load_Request_Procedure(i_Event_Type => Hac_Pref.c_Hik_Event_Code_By_Card,
                                     o_Output     => o_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Tracks(i_Input Array_Varchar2) is
    v_Company Gmap := Gmap(Json_Object_t.Parse(Fazo.Make_Clob(i_Input)));
  begin
    Hac_Core.Save_Hik_Tracks(i_Server_Id   => v_Company.r_Number('server_id'),
                             i_Source_Type => Hac_Pref.c_Hik_Event_Type_Loaded_By_Job,
                             i_Tracks      => v_Company.r_Glist('tracks'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dss_Device_Update_Request return Gmap is
    v_Detail_Map   Gmap;
    v_Company_Data Gmap;
    v_Company_List Glist := Glist();
    result         Gmap := Gmap();
  
    --------------------------------------------------
    Function Gather_Query_Params return varchar2 is
      v_Param_Keys   Array_Varchar2;
      v_Delimiter    varchar2(1) := '&';
      v_Key          varchar2(100);
      v_Query_Params Gmap := Gmap();
      result         varchar2(4000);
    begin
      v_Query_Params.Put('page', Hac_Pref.c_Start_Page_Num);
      v_Query_Params.Put('pageSize', Hac_Pref.c_Default_Page_Size);
      v_Query_Params.Put('orderDirection', Hac_Pref.c_Descending_Order_Direction);
    
      v_Param_Keys := v_Query_Params.Keyset;
    
      for i in 1 .. v_Param_Keys.Count
      loop
        v_Key := v_Param_Keys(i);
      
        result := result || v_Key || '=' || v_Query_Params.r_Varchar2(v_Key);
        if i <> v_Param_Keys.Count then
          result := result || v_Delimiter;
        end if;
      end loop;
    
      return result;
    end;
  
    --------------------------------------------------
    Function Prepare_Detail_Map
    (
      i_Host_Url varchar2,
      i_Username varchar2,
      i_Password varchar2
    ) return Gmap is
      v_Details      Gmap := Gmap();
      v_Auth_Details Gmap := Gmap();
    begin
      v_Details.Put('host_url', i_Host_Url);
      v_Details.Put('method', Href_Pref.c_Http_Method_Get);
      v_Details.Put('api_uri', Hac_Pref.c_Device_Uri || Hac_Pref.c_Page_Uri);
      v_Details.Put('query_params', Gather_Query_Params);
    
      v_Auth_Details.Put('username', i_Username);
      v_Auth_Details.Put('password', i_Password);
    
      v_Details.Put('auth_details', v_Auth_Details);
    
      return v_Details;
    end;
  begin
    for Cmp in (select Sv.Server_Id,
                       Sv.Username,
                       Sv.Password,
                       (select Sr.Host_Url
                          from Hac_Servers Sr
                         where Sr.Server_Id = Sv.Server_Id) Host_Url
                  from Hac_Dss_Servers Sv
                 where exists (select 1
                          from Hac_Company_Devices p
                          join Hac_Dss_Devices Dv
                            on Dv.Device_Id = p.Device_Id
                         where Dv.Server_Id = Sv.Server_Id))
    loop
      v_Company_Data := Gmap();
    
      v_Detail_Map := Prepare_Detail_Map(i_Host_Url => Cmp.Host_Url,
                                         i_Username => Cmp.Username,
                                         i_Password => Cmp.Password);
    
      v_Company_Data.Put('detail', v_Detail_Map);
      v_Company_Data.Put('request_data', Gmap());
      v_Company_Data.Put('host_url', Cmp.Host_Url);
      v_Company_Data.Put('server_id', Cmp.Server_Id);
      v_Company_Data.Put('iterator_key', 'page');
      v_Company_Data.Put('device_key', 'pageData');
    
      v_Company_List.Push(v_Company_Data.Val);
    end loop;
  
    Result.Put('dahua', v_Company_List);
    Result.Put('dahua_procedure', 'HAC_JOB.DSS_DEVICE_UPDATE_RESPONSE');
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Dss_Device_Update_Response(i_Val Array_Varchar2) is
    v_Data        Gmap;
    v_Device_List Glist;
    v_Device      Gmap;
    v_Server_Id   varchar2(20);
    r_Device      Hac_Dss_Devices%rowtype;
  begin
    v_Data        := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Device_List := Nvl(v_Data.o_Glist('devices'), Glist());
    v_Server_Id   := v_Data.r_Varchar2('server_id');
  
    for i in 0 .. v_Device_List.Count - 1
    loop
      v_Device := Gmap(Json_Object_t(v_Device_List.Val.Get(i)));
    
      r_Device := Hac_Util.Take_Device_By_Device_Code(i_Server_Id   => v_Server_Id,
                                                      i_Device_Code => v_Device.r_Varchar2('deviceCode'));
    
      if r_Device.Device_Id is not null then
        z_Hac_Dss_Ex_Devices.Update_One(i_Server_Id   => v_Server_Id,
                                        i_Device_Code => v_Device.r_Varchar2('deviceCode'),
                                        i_Status      => Option_Varchar2(v_Device.r_Varchar2('status')));
        z_Hac_Temp_Ex_Dss_Device_Infos.Insert_Try(i_Device_Code => v_Device.r_Varchar2('deviceCode'),
                                                  i_Server_Id   => v_Server_Id);
      
        z_Hac_Devices.Update_One(i_Device_Id => r_Device.Device_Id,
                                 i_Server_Id => v_Server_Id,
                                 i_Status    => Option_Varchar2(Hac_Util.Map_Dss_Device_Status(v_Device.r_Varchar2('status'))));
        z_Hac_Temp_Device_Infos.Insert_Try(i_Device_Id => r_Device.Device_Id,
                                           i_Server_Id => v_Server_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Hik_Device_Update_Request return Gmap is
    v_Detail_Map   Gmap;
    v_Data_Map     Gmap;
    v_Company_Data Gmap;
    v_Company_List Glist := Glist();
    result         Gmap := Gmap();
  
    --------------------------------------------------
    Function Prepare_Detail_Map
    (
      i_Host_Url       varchar2,
      i_Partner_Key    varchar2,
      i_Partner_Secret varchar2
    ) return Gmap is
      v_Details Gmap := Gmap();
    begin
      v_Details.Put('partner_key', i_Partner_Key);
      v_Details.Put('partner_secret', i_Partner_Secret);
      v_Details.Put('host_url', i_Host_Url);
      v_Details.Put('request_path', Hac_Pref.c_Hik_Request_Path_Get_Devices);
    
      return v_Details;
    end;
  
    --------------------------------------------------
    Function Prepare_Data_Map return Gmap is
      v_Data Gmap := Gmap();
    begin
      v_Data.Val.Put('pageNo', Hac_Pref.c_Start_Page_Num);
      v_Data.Val.Put('pageSize', Hac_Pref.c_Default_Page_Size);
    
      return v_Data;
    end;
  begin
    for Cmp in (select Sv.Server_Id,
                       Sv.Partner_Key,
                       Sv.Partner_Secret,
                       (select Sr.Host_Url
                          from Hac_Servers Sr
                         where Sr.Server_Id = Sv.Server_Id) Host_Url
                  from Hac_Hik_Servers Sv
                 where exists (select 1
                          from Hac_Company_Devices p
                          join Hac_Hik_Devices Dv
                            on Dv.Device_Id = p.Device_Id
                         where Dv.Server_Id = Sv.Server_Id))
    loop
      v_Company_Data := Gmap();
    
      v_Detail_Map := Prepare_Detail_Map(i_Host_Url       => Cmp.Host_Url,
                                         i_Partner_Key    => Cmp.Partner_Key,
                                         i_Partner_Secret => Cmp.Partner_Secret);
      v_Data_Map   := Prepare_Data_Map;
    
      v_Company_Data.Put('detail', v_Detail_Map);
      v_Company_Data.Put('request_data', v_Data_Map);
      v_Company_Data.Put('host_url', Cmp.Host_Url);
      v_Company_Data.Put('server_id', Cmp.Server_Id);
      v_Company_Data.Put('iterator_key', 'pageNo');
      v_Company_Data.Put('device_key', 'list');
    
      v_Company_List.Push(v_Company_Data.Val);
    end loop;
  
    Result.Put('hik', v_Company_List);
    Result.Put('hik_procedure', 'HAC_JOB.HIK_DEVICE_UPDATE_RESPONSE');
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Hik_Device_Update_Response(i_Val Array_Varchar2) is
    v_Data        Gmap;
    v_Device_List Glist;
    v_Device      Gmap;
    v_Server_Id   varchar2(20);
    r_Device      Hac_Hik_Devices%rowtype;
  begin
    v_Data        := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Device_List := Nvl(v_Data.o_Glist('devices'), Glist());
    v_Server_Id   := v_Data.r_Varchar2('server_id');
  
    for i in 0 .. v_Device_List.Count - 1
    loop
      v_Device := Gmap(Json_Object_t(v_Device_List.Val.Get(i)));
    
      r_Device := Hac_Util.Take_Hik_Device_By_Device_Code(i_Server_Id   => v_Server_Id,
                                                          i_Device_Code => v_Device.r_Varchar2('acsDevIndexCode'));
    
      if r_Device.Device_Id is not null then
        z_Hac_Hik_Ex_Devices.Update_One(i_Device_Code => v_Device.r_Varchar2('acsDevIndexCode'),
                                        i_Server_Id   => v_Server_Id,
                                        i_Status      => Option_Varchar2(v_Device.r_Varchar2('status')));
        z_Hac_Temp_Ex_Hik_Device_Infos.Insert_Try(i_Device_Code => v_Device.r_Varchar2('acsDevIndexCode'),
                                                  i_Server_Id   => v_Server_Id);
      
        z_Hac_Devices.Update_One(i_Device_Id => r_Device.Device_Id,
                                 i_Server_Id => v_Server_Id,
                                 i_Status    => Option_Varchar2(Hac_Util.Map_Hik_Device_Status(v_Device.r_Varchar2('status'))));
        z_Hac_Temp_Device_Infos.Insert_Try(i_Device_Id => r_Device.Device_Id,
                                           i_Server_Id => v_Server_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure All_Device_Status_Update_Request(o_Output out Array_Varchar2) is
    v_Hik_Data Gmap := Hik_Device_Update_Request;
    v_Dss_Data Gmap := Dss_Device_Update_Request;
    result     Gmap := Gmap();
  begin
    Result.Put_All(v_Hik_Data);
    Result.Put_All(v_Dss_Data);
  
    o_Output := Fazo.Read_Clob(Result.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Status_Update
  (
    i_Company_Id        number,
    i_Hikvision_Type_Id number,
    i_Dahua_Type_Id     number,
    i_Terminal_Type_Id  number
  ) is
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for Hik in (select Dev.Company_Id, Dev.Device_Id, Dc.Status
                  from Htt_Devices Dev
                  join Hac_Hik_Devices Hd
                    on Hd.Serial_Number = Dev.Serial_Number
                  join Hac_Devices Dc
                    on Dc.Server_Id = Hd.Server_Id
                   and Dc.Device_Id = Hd.Device_Id
                 where Dev.Company_Id = i_Company_Id
                   and Dev.Device_Type_Id = i_Hikvision_Type_Id)
    loop
      z_Htt_Devices.Update_One(i_Company_Id => Hik.Company_Id,
                               i_Device_Id  => Hik.Device_Id,
                               i_Status     => Option_Varchar2(Hik.Status));
    end loop;
  
    for Hik in (select Dev.Company_Id, Dev.Device_Id
                  from Htt_Devices Dev
                 where Dev.Company_Id = i_Company_Id
                   and Dev.Device_Type_Id = i_Hikvision_Type_Id
                   and Dev.Status <> Htt_Pref.c_Device_Status_Unknown
                   and not exists
                 (select 1
                          from Hac_Hik_Devices Hd
                         where Hd.Serial_Number = Dev.Serial_Number
                           and exists (select 1
                                  from Hac_Company_Devices w
                                 where w.Company_Id = i_Company_Id
                                   and w.Device_Id = Hd.Device_Id)))
    loop
      z_Htt_Devices.Update_One(i_Company_Id => Hik.Company_Id,
                               i_Device_Id  => Hik.Device_Id,
                               i_Status     => Option_Varchar2(Htt_Pref.c_Device_Status_Unknown));
    end loop;
  
    for Dss in (select Dev.Company_Id, Dev.Device_Id, Dc.Status
                  from Htt_Devices Dev
                  join Hac_Dss_Devices Hd
                    on Hd.Serial_Number = Dev.Serial_Number
                  join Hac_Devices Dc
                    on Dc.Server_Id = Hd.Server_Id
                   and Dc.Device_Id = Hd.Device_Id
                 where Dev.Company_Id = i_Company_Id
                   and Dev.Device_Type_Id = i_Dahua_Type_Id)
    loop
      z_Htt_Devices.Update_One(i_Company_Id => Dss.Company_Id,
                               i_Device_Id  => Dss.Device_Id,
                               i_Status     => Option_Varchar2(Dss.Status));
    end loop;
  
    for Dss in (select Dev.Company_Id, Dev.Device_Id
                  from Htt_Devices Dev
                 where Dev.Company_Id = i_Company_Id
                   and Dev.Device_Type_Id = i_Dahua_Type_Id
                   and Dev.Status <> Htt_Pref.c_Device_Status_Unknown
                   and not exists
                 (select 1
                          from Hac_Dss_Devices Hd
                         where Hd.Serial_Number = Dev.Serial_Number
                           and exists (select 1
                                  from Hac_Company_Devices w
                                 where w.Company_Id = i_Company_Id
                                   and w.Device_Id = Hd.Device_Id)))
    loop
      z_Htt_Devices.Update_One(i_Company_Id => Dss.Company_Id,
                               i_Device_Id  => Dss.Device_Id,
                               i_Status     => Option_Varchar2(Htt_Pref.c_Device_Status_Unknown));
    end loop;
  
    for Ter in (select Dev.Company_Id,
                       Dev.Device_Id,
                       ((sysdate - Dev.Last_Seen_On) * 24 * 60) as Min_Diff
                  from Htt_Devices Dev
                 where Dev.Company_Id = i_Company_Id
                   and Dev.Device_Type_Id = i_Terminal_Type_Id)
    loop
      if Ter.Min_Diff > 2 then
        z_Htt_Devices.Update_One(i_Company_Id => Ter.Company_Id,
                                 i_Device_Id  => Ter.Device_Id,
                                 i_Status     => Option_Varchar2(Htt_Pref.c_Device_Status_Offline));
      else
        z_Htt_Devices.Update_One(i_Company_Id => Ter.Company_Id,
                                 i_Device_Id  => Ter.Device_Id,
                                 i_Status     => Option_Varchar2(Htt_Pref.c_Device_Status_Online));
      end if;
    end loop;
  
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure All_Device_Status_Update_Response(i_Input Array_Varchar2) is
    v_Company_Ids       Array_Number;
    v_Hikvision_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dahua_Type_Id     number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
    v_Terminal_Type_Id  number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
  begin
    select q.Company_Id
      bulk collect
      into v_Company_Ids
      from Htt_Devices q
     where exists
     (select 1
              from Md_Companies w
             where w.Company_Id = q.Company_Id
               and w.State = 'A')
       and q.Device_Type_Id in (v_Hikvision_Type_Id, v_Dahua_Type_Id, v_Terminal_Type_Id)
     group by q.Company_Id;
  
    for Dev in (select q.Server_Id, q.Device_Code
                  from Hac_Hik_Ex_Devices q
                 where not exists (select 1
                          from Hac_Temp_Ex_Hik_Device_Infos w
                         where w.Server_Id = q.Server_Id
                           and w.Device_Code = q.Device_Code))
    loop
      z_Hac_Hik_Ex_Devices.Update_One(i_Server_Id   => Dev.Server_Id,
                                      i_Device_Code => Dev.Device_Code,
                                      i_Status      => Option_Varchar2(Hac_Pref.c_Hik_Device_Status_Unknown));
    end loop;
  
    for Dev in (select q.Server_Id, q.Device_Code
                  from Hac_Dss_Ex_Devices q
                 where not exists (select 1
                          from Hac_Temp_Ex_Dss_Device_Infos w
                         where w.Device_Code = q.Device_Code
                           and w.Server_Id = q.Server_Id))
    loop
      z_Hac_Dss_Ex_Devices.Update_One(i_Device_Code => Dev.Device_Code,
                                      i_Server_Id   => Dev.Server_Id,
                                      i_Status      => Option_Varchar2(Hac_Pref.c_Dss_Device_Status_Unknown));
    
    end loop;
  
    for Dev in (select *
                  from Hac_Devices q
                 where not exists (select 1
                          from Hac_Temp_Device_Infos w
                         where w.Device_Id = q.Device_Id
                           and w.Server_Id = q.Server_Id))
    loop
      z_Hac_Devices.Update_One(i_Device_Id => Dev.Device_Id,
                               i_Server_Id => Dev.Server_Id,
                               i_Status    => Option_Varchar2(Hac_Pref.c_Device_Status_Unknown));
    end loop;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Device_Status_Update(i_Company_Id        => v_Company_Ids(i),
                           i_Hikvision_Type_Id => v_Hikvision_Type_Id,
                           i_Dahua_Type_Id     => v_Dahua_Type_Id,
                           i_Terminal_Type_Id  => v_Terminal_Type_Id);
    end loop;
  
    Clear_Temp_Tables;
  end;

end Hac_Job;
/

create or replace package Verifix_Settings is
  ----------------------------------------------------------------------------------------------------
  -- Project Code
  ----------------------------------------------------------------------------------------------------
  c_Pc_Verifix_Hr constant varchar2(10) := 'vhr';
  ----------------------------------------------------------------------------------------------------
  -- Project Version
  ----------------------------------------------------------------------------------------------------
  c_Pv_Verifix_Hr constant varchar2(10) := '3.0.1';
  ----------------------------------------------------------------------------------------------------
  -- Module error codes
  ----------------------------------------------------------------------------------------------------
  c_Href_Error_Code  constant varchar2(10) := 'A05-01';
  c_Hes_Error_Code   constant varchar2(10) := 'A05-02';
  c_Hlic_Error_Code  constant varchar2(10) := 'A05-03';
  c_Htt_Error_Code   constant varchar2(10) := 'A05-04';
  c_Hzk_Error_Code   constant varchar2(10) := 'A05-05';
  c_Hrm_Error_Code   constant varchar2(10) := 'A05-06';
  c_Hpd_Error_Code   constant varchar2(10) := 'A05-07';
  c_Hln_Error_Code   constant varchar2(10) := 'A05-08';
  c_Hper_Error_Code  constant varchar2(10) := 'A05-09';
  c_Hpr_Error_Code   constant varchar2(10) := 'A05-10';
  c_Hac_Error_Code   constant varchar2(10) := 'A05-11';
  c_Htm_Error_Code   constant varchar2(10) := 'A05-12';
  c_Hrec_Error_Code  constant varchar2(10) := 'A05-13';
  c_Hsc_Error_Code   constant varchar2(10) := 'A05-14';
  c_Hface_Error_Code constant varchar2(10) := 'A05-15';
  c_Hide_Error_Code  constant varchar2(10) := 'A05-16';
  c_Uit_Error_Code   constant varchar2(10) := 'A05-99';
end Verifix_Settings;
/
create or replace package body Verifix_Settings is
end Verifix_Settings;
/

