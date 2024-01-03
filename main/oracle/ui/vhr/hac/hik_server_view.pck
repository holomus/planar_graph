create or replace package Ui_Vhr518 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Subscribe_To_Tracks(p Hashmap) return Runtime_Service;
  ---------------------------------------------------------------------------------------------------- 
  Function Subscribe_To_Tracks_Response_Handler(i_Val Array_Varchar2) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Unsubscribe_From_Tracks(p Hashmap) return Runtime_Service;
  ---------------------------------------------------------------------------------------------------- 
  Function Unsubscribe_From_Tracks_Response_Handler(i_Val Array_Varchar2) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function List_Subscriptions(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function List_Subscriptions_Response(i_Data Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Gen_Token(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Companies(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Persons_Response(i_Val Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Persons(p Hashmap) return Runtime_Service;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations(p Hashmap) return Runtime_Service;
end Ui_Vhr518;
/
create or replace package body Ui_Vhr518 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap := Fazo.Zip_Map('server_id', p.r_Number('server_id'));
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                       w.organization_code
                  from md_companies q
                  left join hac_hik_company_servers w
                    on w.server_id = :server_id
                   and w.company_id = q.company_id
                 where ';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || ' q.state = ''A'' and not';
    end if;
  
    v_Query := v_Query || ' exists (select 1
                               from hac_hik_company_servers w
                              where ';
  
    if p.o_Varchar2('mode') <> 'detach' then
      v_Query := v_Query || ' w.server_id = :server_id and ';
    end if;
  
    v_Query := v_Query || ' w.company_id = q.company_id)';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code', 'organization_code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
    v_Server_Id   number := p.r_Number('server_id');
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Hik_Server_Attach(i_Company_Id => v_Company_Ids(i), i_Server_Id => v_Server_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Hik_Server_Detach(i_Company_Id => v_Company_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Server_Id  number := p.r_Number('server_id');
    r_Server     Hac_Servers%rowtype;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    result       Hashmap;
  begin
    r_Server     := z_Hac_Servers.Load(v_Server_Id);
    r_Hik_Server := z_Hac_Hik_Servers.Load(v_Server_Id);
  
    result := z_Hac_Servers.To_Map(r_Server, z.Server_Id, z.Name, z.Host_Url, z.Order_No);
  
    Result.Put_All(z_Hac_Hik_Servers.To_Map(r_Hik_Server, z.Partner_Key, z.Partner_Secret, z.Token));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Subscribe_To_Tracks(p Hashmap) return Runtime_Service is
    v_Receiver_Host_Url varchar2(1000 char) := p.r_Varchar2('receiver_host_url');
    v_Server_Id         number := p.r_Number('server_id');
    r_Server            Hac_Servers%rowtype;
    r_Hik_Server        Hac_Hik_Servers%rowtype;
    v_Data              Json_Object_t := Json_Object_t();
    v_Event_Types       Json_Array_t := Json_Array_t;
    v_Chosen_Types      Array_Number;
  
    --------------------------------------------------
    Function Event_Types(i_All_Types varchar2) return Array_Number is
      v_Hik_Type_Id number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
      result        Array_Number;
    begin
      select q.Event_Type_Code
        bulk collect
        into result
        from Hac_Event_Types q
       where q.Device_Type_Id = v_Hik_Type_Id
         and (i_All_Types = 'Y' or q.Access_Granted = 'Y' and q.Currently_Shown = 'Y')
         and q.Event_Type_Code > 999;
    
      return result;
    end;
  
  begin
    r_Server     := z_Hac_Servers.Load(v_Server_Id);
    r_Hik_Server := z_Hac_Hik_Servers.Load(v_Server_Id);
  
    v_Chosen_Types := Event_Types(Nvl(p.o_Varchar2('all_types'), 'N'));
  
    for i in 1 .. v_Chosen_Types.Count
    loop
      v_Event_Types.Append(v_Chosen_Types(i));
    end loop;
  
    v_Data.Put('eventTypes', v_Event_Types);
  
    v_Data.Put('eventDest', v_Receiver_Host_Url || Hac_Pref.c_Hik_Event_Receiver_Route_Uri);
    v_Data.Put('token', r_Hik_Server.Token);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => r_Server.Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Subscribe_To_Tracks,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'ui_vhr518.Subscribe_To_Tracks_Response_Handler');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Subscribe_To_Tracks_Response_Handler(i_Val Array_Varchar2) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('res', i_Val);
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Unsubscribe_From_Tracks(p Hashmap) return Runtime_Service is
    v_Server_Id    number := p.r_Number('server_id');
    r_Server       Hac_Servers%rowtype;
    r_Hik_Server   Hac_Hik_Servers%rowtype;
    v_Data         Json_Object_t := Json_Object_t();
    v_Event_Types  Json_Array_t := Json_Array_t;
    v_Chosen_Types Array_Number := p.r_Array_Number('subscribed_types');
  begin
    r_Server     := z_Hac_Servers.Load(v_Server_Id);
    r_Hik_Server := z_Hac_Hik_Servers.Load(v_Server_Id);
  
    for i in 1 .. v_Chosen_Types.Count
    loop
      v_Event_Types.Append(v_Chosen_Types(i));
    end loop;
  
    v_Data.Put('eventTypes', v_Event_Types);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => r_Server.Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Unsubscribe_From_Tracks,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'ui_vhr518.unsubscribe_from_tracks_response_handler');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Unsubscribe_From_Tracks_Response_Handler(i_Val Array_Varchar2) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('res', i_Val);
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function List_Subscriptions(p Hashmap) return Runtime_Service is
    v_Server_Id  number := p.r_Number('server_id');
    r_Server     Hac_Servers%rowtype;
    r_Hik_Server Hac_Hik_Servers%rowtype;
  begin
    r_Server     := z_Hac_Servers.Load(v_Server_Id);
    r_Hik_Server := z_Hac_Hik_Servers.Load(v_Server_Id);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => r_Server.Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Subscriptions_List,
                                              i_Response_Procedure => 'ui_vhr518.list_subscriptions_response',
                                              i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Hashmap);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function List_Subscriptions_Response(i_Data Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data', i_Data.r_Arraylist('detail'));
    Result.Put('events_route', Hac_Pref.c_Hik_Event_Receiver_Route_Uri);
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Token(p Hashmap) return varchar2 is
    v_Server_Id number := p.r_Number('server_id');
    v_Token     varchar2(64 char) := Hac_Util.Gen_Token;
    r_Acms      Hac_Servers%rowtype;
    r_Server    Hac_Hik_Servers%rowtype;
    v_Server    Hac_Pref.Hik_Server_Rt;
  begin
    r_Acms   := z_Hac_Servers.Load(v_Server_Id);
    r_Server := z_Hac_Hik_Servers.Load(v_Server_Id);
  
    v_Server.Acms           := r_Acms;
    v_Server.Partner_Key    := r_Server.Partner_Key;
    v_Server.Partner_Secret := r_Server.Partner_Secret;
    v_Server.Token          := v_Token;
  
    Hac_Api.Hik_Server_Save(v_Server);
  
    return v_Token;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Company
  (
    i_Server_Id  number,
    i_Company_Id number
  ) is
    v_Company_Code Md_Companies.Code%type := z_Md_Companies.Load(i_Company_Id).Code;
    r_Company      Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(i_Company_Id);
  
    --------------------------------------------------
    Function Get_Organization_Code
    (
      i_Server_Id    number,
      i_Company_Code varchar2
    ) return Option_Varchar2 is
      result Hac_Hik_Company_Servers.Organization_Code%type;
    begin
      select q.Organization_Code
        into result
        from Hac_Hik_Ex_Organizations q
       where q.Server_Id = i_Server_Id
         and q.Organization_Name = i_Company_Code;
    
      return Option_Varchar2(result);
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if r_Company.Server_Id <> i_Server_Id then
      Hac_Error.Raise_004;
    end if;
  
    Hac_Api.Hik_Company_Server_Update(i_Company_Id        => i_Company_Id,
                                      i_Organization_Code => Get_Organization_Code(i_Server_Id    => i_Server_Id,
                                                                                   i_Company_Code => v_Company_Code));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Companies(p Hashmap) is
    v_Server_Id   number := p.r_Number('server_id');
    v_Company_Ids Array_Number := p.o_Array_Number('company_id');
  begin
    if v_Company_Ids is null then
      select q.Company_Id
        bulk collect
        into v_Company_Ids
        from Hac_Hik_Company_Servers q
       where q.Server_Id = v_Server_Id
         and q.Organization_Code is null;
    end if;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Sync_Company(i_Server_Id => v_Server_Id, i_Company_Id => v_Company_Ids(i));
    end loop;
  end;

  --------------------------------------------------------------------------------------------------
  Function Get_Persons_Response(i_Val Array_Varchar2) return Hashmap is
    v_Data        Gmap;
    v_Person_List Glist;
    v_Person      Gmap;
    v_Photo       Gmap;
    v_Cards       Glist;
    v_Card        Gmap;
  
    v_Organization_Code varchar2(300);
    v_Person_Code       varchar2(300);
  
    v_Continue_Pagination varchar2(1) := 'Y';
  begin
    v_Data        := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Person_List := Nvl(v_Data.o_Glist('list'), Glist());
  
    for i in 0 .. v_Person_List.Count - 1
    loop
      v_Person := Gmap(Json_Object_t(v_Person_List.Val.Get(i)));
    
      v_Photo := Nvl(v_Person.o_Gmap('personPhoto'), Gmap());
      v_Cards := Nvl(v_Person.o_Glist('cards'), Glist());
    
      if v_Cards.Count > 0 then
        v_Card := Gmap(Json_Object_t(v_Cards.Val.Get(0)));
      else
        v_Card := Gmap();
      end if;
    
      v_Organization_Code := v_Person.r_Varchar2('orgIndexCode');
      v_Person_Code       := v_Person.r_Varchar2('personId');
    
      if z_Hac_Hik_Ex_Persons.Exist(i_Server_Id         => g_Server_Id,
                                    i_Organization_Code => v_Organization_Code,
                                    i_Person_Code       => v_Person_Code) then
        v_Continue_Pagination := 'N';
      else
        z_Hac_Hik_Ex_Persons.Insert_One(i_Server_Id         => g_Server_Id,
                                        i_Organization_Code => v_Organization_Code,
                                        i_Person_Code       => v_Person_Code,
                                        i_External_Code     => v_Person.r_Varchar2('personCode'),
                                        i_First_Name        => v_Person.o_Varchar2('personGivenName'),
                                        i_Last_Name         => v_Person.o_Varchar2('personFamilyName'),
                                        i_Photo_Url         => v_Photo.o_Varchar2('picUri'),
                                        i_Rfid_Code         => v_Card.o_Varchar2('cardNo'),
                                        i_Extra_Info        => v_Person.Json);
      end if;
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Person_List.Count,
                        'continue_pagination',
                        v_Continue_Pagination);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Persons(p Hashmap) return Runtime_Service is
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t();
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => g_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => g_Server_Id);
  
    v_Data.Put('pageNo', p.r_Number('pageNo'));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Persons,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'ui_vhr518.get_persons_response');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hac.Get_Organizations(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null,
           State      = null;
  
    update Hac_Hik_Company_Servers
       set Company_Id        = null,
           Server_Id         = null,
           Organization_Code = null;
  end;

end Ui_Vhr518;
/
