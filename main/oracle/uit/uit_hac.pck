create or replace package Uit_Hac is
  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Access_Levels
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Hik_Access_Level_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Doors
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Hik_Door_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Devices
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Hik_Device_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Organizations(p Hashmap) return Runtime_Service;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations_Response(i_Val Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Devices
  (
    p                    Hashmap,
    i_Responce_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Devices_Response
  (
    i_Data      Hashmap,
    i_Server_Id number
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Access_Groups
  (
    i_Responce_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Get_Access_Groups_Response
  (
    i_Data      Hashmap,
    i_Server_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Function Get_Departments(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Departments_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Person_Groups_Response(i_Data Hashmap);
end Uit_Hac;
/
create or replace package body Uit_Hac is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Access_Levels
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service is
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t;
  begin
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => i_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => i_Server_Id);
    v_Data.Put('type', Hac_Pref.c_Hik_Access_Level_Type_Access_Control);
    v_Data.Put('pageNo', p.r_Number('pageNo'));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Access_Levels,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => i_Response_Procedure);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hik_Access_Level_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap is
    v_Data              Gmap;
    v_Access_Level_List Glist;
    v_Access_Level      Gmap;
  begin
    v_Data              := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Access_Level_List := Nvl(v_Data.o_Glist('list'), Glist());
  
    for i in 0 .. v_Access_Level_List.Count - 1
    loop
      v_Access_Level := Gmap(Json_Object_t(v_Access_Level_List.Val.Get(i)));
    
      Hac_Api.Hik_Ex_Access_Level_Save(i_Server_Id         => i_Server_Id,
                                       i_Access_Level_Code => v_Access_Level.r_Varchar2('privilegeGroupId'),
                                       i_Access_Level_Name => v_Access_Level.r_Varchar2('privilegeGroupName'),
                                       i_Description       => v_Access_Level.r_Varchar2('description'));
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Access_Level_List.Count);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Doors
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service is
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t();
  begin
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => i_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => i_Server_Id);
    v_Data.Put('pageNo', p.r_Number('pageNo'));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Doors,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => i_Response_Procedure);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hik_Door_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap is
    v_Data      Gmap;
    v_Door_List Glist;
    v_Door      Gmap;
  begin
    v_Data      := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Door_List := Nvl(v_Data.o_Glist('list'), Glist());
  
    for i in 0 .. v_Door_List.Count - 1
    loop
      v_Door := Gmap(Json_Object_t(v_Door_List.Val.Get(i)));
    
      Hac_Api.Hik_Ex_Door_List_Save(i_Server_Id   => i_Server_Id,
                                    i_Door_Code   => v_Door.r_Varchar2('doorIndexCode'),
                                    i_Door_Name   => v_Door.r_Varchar2('doorName'),
                                    i_Door_No     => v_Door.o_Varchar2('doorNo'),
                                    i_Device_Code => v_Door.r_Varchar2('acsDevIndexCode'),
                                    i_Region_Code => v_Door.o_Varchar2('regionIndexCode'),
                                    i_Door_State  => v_Door.o_Varchar2('doorState'));
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Door_List.Count);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Hik_Get_Devices
  (
    p                    Hashmap,
    i_Response_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service is
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t();
  begin
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => i_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => i_Server_Id);
    v_Data.Put('pageNo', p.r_Number('pageNo'));
    v_Data.Put('pageSize', Hac_Pref.c_Default_Page_Size);
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Devices,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => i_Response_Procedure);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hik_Device_List_Response_Handler
  (
    i_Val       Array_Varchar2,
    i_Server_Id number
  ) return Hashmap is
    v_Data        Gmap;
    v_Device_List Glist;
    v_Device      Gmap;
  begin
    v_Data        := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Device_List := Nvl(v_Data.o_Glist('list'), Glist());
  
    for i in 0 .. v_Device_List.Count - 1
    loop
      v_Device := Gmap(Json_Object_t(v_Device_List.Val.Get(i)));
    
      Hac_Api.Hik_Ex_Device_List_Save(i_Server_Id     => i_Server_Id,
                                      i_Device_Code   => v_Device.r_Varchar2('acsDevIndexCode'),
                                      i_Device_Name   => v_Device.r_Varchar2('acsDevName'),
                                      i_Device_Ip     => v_Device.r_Varchar2('acsDevIp'),
                                      i_Device_Port   => v_Device.r_Varchar2('acsDevPort'),
                                      i_Treaty_Type   => v_Device.r_Varchar2('treatyType'),
                                      i_Serial_Number => v_Device.r_Varchar2('acsDevCode'),
                                      i_Status        => Nvl(v_Device.o_Varchar2('status'),
                                                             v_Device.o_Varchar2('status ')));
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Device_List.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Organizations(p Hashmap) return Runtime_Service is
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
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Organizations,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'uit_hac.get_organizations_response');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations_Response(i_Val Array_Varchar2) return Hashmap is
    v_Data              Gmap;
    v_Organization_List Glist;
    v_Organization      Gmap;
  begin
    v_Data              := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Organization_List := Nvl(v_Data.o_Glist('list'), Glist());
  
    for i in 0 .. v_Organization_List.Count - 1
    loop
      v_Organization := Gmap(Json_Object_t(v_Organization_List.Val.Get(i)));
    
      z_Hac_Hik_Ex_Organizations.Save_One(i_Server_Id         => g_Server_Id,
                                          i_Organization_Code => v_Organization.r_Varchar2('orgIndexCode'),
                                          i_Organization_Name => v_Organization.r_Varchar2('orgName'));
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Data.r_Number('total') / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Organization_List.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Devices
  (
    p                    Hashmap,
    i_Responce_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service is
    v_Query_Params Gmap := Gmap();
  begin
    v_Query_Params.Put('page', Nvl(p.o_Number('page_num'), Hac_Pref.c_Start_Page_Num));
    v_Query_Params.Put('pageSize', Hac_Pref.c_Default_Page_Size);
    v_Query_Params.Put('orderDirection', Hac_Pref.c_Descending_Order_Direction);
    v_Query_Params.Put('orgCode', p.o_Varchar2('org_code'));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => i_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Device_Uri ||
                                                                  Hac_Pref.c_Page_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => i_Responce_Procedure,
                                          i_Uri_Query_Params   => v_Query_Params);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Devices_Response
  (
    i_Data      Hashmap,
    i_Server_Id number
  ) return Hashmap is
    v_Total_Cnt number := i_Data.r_Number('totalCount');
    v_Devices   Arraylist := i_Data.r_Arraylist('pageData');
    v_Device    Hashmap;
  begin
    for i in 1 .. v_Devices.Count
    loop
      v_Device := Treat(v_Devices.r_Hashmap(i) as Hashmap);
    
      Hac_Api.Dss_Ex_Devices_Save(i_Server_Id       => i_Server_Id,
                                  i_Device_Code     => v_Device.r_Varchar2('deviceCode'),
                                  i_Department_Code => v_Device.o_Varchar2('orgCode'),
                                  i_Device_Name     => v_Device.o_Varchar2('deviceName'),
                                  i_Device_Ip       => v_Device.o_Varchar2('deviceIp'),
                                  i_Status          => v_Device.o_Varchar2('status'));
    end loop;
  
    return Fazo.Zip_Map('total_pages',
                        Ceil(v_Total_Cnt / Hac_Pref.c_Default_Page_Size),
                        'item_count',
                        v_Devices.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dss_Get_Access_Groups
  (
    i_Responce_Procedure varchar2,
    i_Server_Id          number
  ) return Runtime_Service is
  begin
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => i_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Access_Group_Uri ||
                                                                  Hac_Pref.c_List_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => i_Responce_Procedure,
                                          i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Get_Access_Groups_Response
  (
    i_Data      Hashmap,
    i_Server_Id number
  ) is
    v_Access_Groups Arraylist := i_Data.r_Arraylist('results');
    v_Access_Group  Hashmap;
  begin
    for i in 1 .. v_Access_Groups.Count
    loop
      v_Access_Group := Treat(v_Access_Groups.r_Hashmap(i) as Hashmap);
    
      Hac_Api.Dss_Ex_Access_Groups_Save(i_Server_Id         => i_Server_Id,
                                        i_Access_Group_Code => v_Access_Group.r_Varchar2('accessGroupId'),
                                        i_Access_Group_Name => v_Access_Group.r_Varchar2('accessGroupName'),
                                        i_Person_Count      => v_Access_Group.o_Number('personCount'),
                                        i_Extra_Info        => v_Access_Group.Json);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Departments(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => g_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Org_Tree_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => 'uit_hac.get_departments_response',
                                          i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Departments_Response(i_Data Hashmap) is
    v_Departments Arraylist := i_Data.r_Arraylist('departments');
    v_Department  Hashmap;
  begin
    for i in 1 .. v_Departments.Count
    loop
      v_Department := Treat(v_Departments.r_Hashmap(i) as Hashmap);
    
      z_Hac_Dss_Ex_Departments.Save_One(i_Server_Id       => g_Server_Id,
                                        i_Department_Code => v_Department.r_Varchar2('code'),
                                        i_Department_Name => v_Department.r_Varchar2('name'),
                                        i_Extra_Info      => v_Department.Json);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => g_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Person_Group_Uri ||
                                                                  Hac_Pref.c_List_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => 'uit_hac.get_person_groups_response',
                                          i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Person_Groups_Response(i_Data Hashmap) is
    v_Person_Groups Arraylist := i_Data.r_Arraylist('results');
    v_Person_Group  Hashmap;
  begin
    for i in 1 .. v_Person_Groups.Count
    loop
      v_Person_Group := Treat(v_Person_Groups.r_Hashmap(i) as Hashmap);
    
      z_Hac_Dss_Ex_Person_Groups.Save_One(i_Server_Id         => g_Server_Id,
                                          i_Person_Group_Code => v_Person_Group.r_Varchar2('orgCode'),
                                          i_Person_Group_Name => v_Person_Group.r_Varchar2('orgName'),
                                          i_Extra_Info        => v_Person_Group.Json);
    end loop;
  end;

end Uit_Hac;
/
