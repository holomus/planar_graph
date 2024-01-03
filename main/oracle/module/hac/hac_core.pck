create or replace package Hac_Core is
  ---------------------------------------------------------------------------------------------------- 
  Function Build_Hik_Runtime_Service
  (
    i_Host_Url           varchar2,
    i_Partner_Key        varchar2,
    i_Partner_Secret     varchar2,
    i_Request_Path       varchar2,
    i_Data               Json_Object_t := null,
    i_Response_Procedure varchar2,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ---------------------------------------------------------------------------------------------------- 
  Function Dahua_Runtime_Service
  (
    i_Server_Id          number,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Host_Url           varchar2 := null,
    i_Uri_Query_Params   Gmap := null,
    i_Object_Id          varchar2 := null,
    i_Data               Gmap := Gmap(),
    i_Face_Picture_Sha   varchar2 := null,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Save(i_Server Hac_Servers%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Delete(i_Server_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Attach
  (
    i_Company_Id  number,
    i_Device_Id   number,
    i_Attach_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Detach
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Save
  (
    i_Company_Id  number,
    i_Device      Hac_Devices%rowtype,
    i_Event_Types Array_Number := Array_Number()
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Person_Info
  (
    i_Company_Id number,
    i_Person_Ids Array_Varchar2,
    o_Data       out Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Attachment_Info
  (
    i_Company_Id number,
    i_Person_Ids Array_Varchar2,
    o_Data       out Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Persons_Attach
  (
    i_Server_Id  number,
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Ids Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Persons_Detach
  (
    i_Server_Id  number,
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Ids Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Person_Info
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_External_Code varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Person_Info
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_External_Code varchar2,
    i_First_Name    varchar2,
    i_Last_Name     varchar2,
    i_Photo_Sha     varchar2,
    i_Rfid_Code     varchar2,
    i_Person_Code   varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Error_Log
  (
    i_Request_Params varchar2,
    i_Error_Message  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Person
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Persistent boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Acms_Devices;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Device_Track
  (
    i_Server_Id        number,
    i_Device           Htt_Devices%rowtype,
    i_Person_Code      varchar2,
    i_Track_Time       timestamp with local time zone,
    i_Photo_Sha        varchar2 := null,
    i_Track_Type       varchar2 := Htt_Pref.c_Track_Type_Check,
    i_Person_Auth_Type varchar2 := Hac_Pref.c_Person_Auth_Type_Person_Code
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dss_Track
  (
    i_Host_Url       varchar2,
    i_Person_Code    varchar2,
    i_Dss_Channel_Id varchar2,
    i_Track_Time     varchar2,
    i_Photo_Url      varchar2,
    i_Photo_Sha      varchar2,
    i_Source_Type    varchar2,
    i_Event_Type     varchar2,
    i_Extra_Info     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Ex_Event
  (
    i_Server_Id             number,
    i_Door_Code             varchar2,
    i_Person_Code           varchar2,
    i_Event_Time            varchar2,
    i_Event_Type            varchar2,
    i_Event_Code            varchar2,
    i_Check_In_And_Out_Type number,
    i_Event_Type_Code       number,
    i_Door_Name             varchar2,
    i_Src_Type              varchar2 := null,
    i_Status                number := null,
    i_Card_No               varchar2,
    i_Person_Name           varchar2 := null,
    i_Person_Type           varchar2 := null,
    i_Pic_Uri               varchar2,
    i_Pic_Sha               varchar2,
    i_Device_Time           varchar2 := null,
    i_Reader_Code           varchar2,
    i_Reader_Name           varchar2,
    i_Extra_Info            varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Track
  (
    i_Server_Id   number,
    i_Person_Code varchar2,
    i_Door_Code   varchar2,
    i_Track_Time  varchar2,
    i_Photo_Sha   varchar2,
    i_Track_Type  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dahua_Tracks
  (
    i_Host_Url    varchar2,
    i_Source_Type varchar2,
    i_Tracks      Glist
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Tracks
  (
    i_Server_Id   number,
    i_Source_Type varchar2,
    i_Tracks      Glist
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Authenticate_Hik_Servlet
  (
    i_Token          varchar2,
    o_Server_Id      out number,
    o_Host_Url       out varchar2,
    o_Partner_Key    out varchar2,
    o_Partner_Secret out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Device_Settings
  (
    i_Server_Id      varchar2,
    i_Door_Code      varchar2,
    o_Device_Exists  out varchar2,
    o_Tracks_Ignored out varchar2,
    o_Image_Ignored  out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Dahua_Device_Settings
  (
    i_Host_Url       varchar2,
    i_Dss_Channel_Id varchar2,
    o_Device_Exists  out varchar2,
    o_Image_Ignored  out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Listening_Device_Settings
  (
    i_Device_Token  varchar2,
    o_Device_Exists out varchar2,
    o_Image_Ignored out varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Event(i_Val Array_Varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Hik_Device_Listener_Event
  (
    i_Token   varchar2,
    i_Pic_Sha varchar2,
    i_Val     Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dahua_Mq_Notification
  (
    i_Host_Url       varchar2,
    i_Person_Code    varchar2,
    i_Dss_Channel_Id varchar2,
    i_Track_Time     varchar2,
    i_Photo_Url      varchar2,
    i_Photo_Sha      varchar2,
    i_Event_Type     varchar2,
    i_Extra_Info     varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Acms_Device_Update
  (
    i_Server_Id number,
    i_Device_Id number,
    i_Device_Ip Option_Varchar2 := null,
    i_Ready     Option_Varchar2 := null,
    i_Status    Option_Varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_File
  (
    i_Sha          varchar2,
    i_File_Size    varchar2,
    i_File_Name    varchar2,
    i_Content_Type varchar2,
    i_Store_Kind   varchar2
  );
end Hac_Core;
/
create or replace package body Hac_Core is
  ---------------------------------------------------------------------------------------------------- 
  Function Build_Hik_Runtime_Service
  (
    i_Host_Url           varchar2,
    i_Partner_Key        varchar2,
    i_Partner_Secret     varchar2,
    i_Request_Path       varchar2,
    i_Data               Json_Object_t := null,
    i_Response_Procedure varchar2,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  begin
    v_Details.Put('partner_key', i_Partner_Key);
    v_Details.Put('partner_secret', i_Partner_Secret);
    v_Details.Put('host_url', i_Host_Url);
    v_Details.Put('request_path', i_Request_Path);
  
    v_Service := Runtime_Service(Hac_Pref.c_Hik_Api_Service_Name);
  
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(Nvl(i_Data, Json_Object_t).To_Clob));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Response_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Dahua_Runtime_Service
  (
    i_Server_Id          number,
    i_Api_Uri            varchar2,
    i_Api_Method         varchar2,
    i_Responce_Procedure varchar2,
    i_Host_Url           varchar2 := null,
    i_Uri_Query_Params   Gmap := null,
    i_Object_Id          varchar2 := null,
    i_Data               Gmap := Gmap(),
    i_Face_Picture_Sha   varchar2 := null,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    r_Server     Hac_Servers%rowtype := z_Hac_Servers.Load(i_Server_Id);
    r_Dss_Server Hac_Dss_Servers%rowtype := z_Hac_Dss_Servers.Load(i_Server_Id);
    v_Service    Runtime_Service;
    v_Details    Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Gather_Query_Params return varchar2 is
      v_Param_Keys Array_Varchar2;
      v_Delimiter  varchar2(1) := '&';
      v_Key        varchar2(100);
      result       varchar2(4000);
    begin
      if i_Uri_Query_Params is null then
        return result;
      end if;
    
      v_Param_Keys := i_Uri_Query_Params.Keyset;
    
      for i in 1 .. v_Param_Keys.Count
      loop
        v_Key := v_Param_Keys(i);
      
        result := result || v_Key || '=' || i_Uri_Query_Params.r_Varchar2(v_Key);
        if i <> v_Param_Keys.Count then
          result := result || v_Delimiter;
        end if;
      end loop;
    
      return result;
    end;
  begin
    v_Details.Put('host_url', Nvl(i_Host_Url, r_Server.Host_Url));
    v_Details.Put('method', i_Api_Method);
    v_Details.Put('api_uri', i_Api_Uri);
    v_Details.Put('object_id', i_Object_Id);
    v_Details.Put('query_params', Gather_Query_Params);
    v_Details.Put('auth_details',
                  Fazo.Zip_Map('username', r_Dss_Server.Username, 'password', r_Dss_Server.Password));
    v_Details.Put('face_picture_sha', i_Face_Picture_Sha);
  
    v_Service := Runtime_Service(Hac_Pref.c_Dahua_Api_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Responce_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Save(i_Server Hac_Servers%rowtype) is
  begin
    z_Hac_Servers.Save_Row(i_Server);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Server_Delete(i_Server_Id number) is
  begin
    z_Hac_Servers.Delete_One(i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Attach
  (
    i_Company_Id  number,
    i_Device_Id   number,
    i_Attach_Kind varchar2
  ) is
    -------------------------------------------------- 
    Procedure Assert_Singular_Primary_Attachment is
      v_Dummy varchar2(1);
    begin
      if i_Attach_Kind <> Hac_Pref.c_Device_Attach_Primary then
        return;
      end if;
    
      select 'x'
        into v_Dummy
        from Hac_Company_Devices p
       where p.Device_Id = i_Device_Id
         and p.Attach_Kind = Hac_Pref.c_Device_Attach_Primary
         and p.Company_Id <> i_Company_Id;
    
      Hac_Error.Raise_001;
    exception
      when No_Data_Found then
        null;
    end;
  begin
    Assert_Singular_Primary_Attachment;
  
    z_Hac_Company_Devices.Insert_Try(i_Company_Id  => i_Company_Id,
                                     i_Device_Id   => i_Device_Id,
                                     i_Attach_Kind => i_Attach_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Detach
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Hac_Company_Devices.Delete_One(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Save
  (
    i_Company_Id  number,
    i_Device      Hac_Devices%rowtype,
    i_Event_Types Array_Number := Array_Number()
  ) is
    v_Old_Company_Id number;
  begin
    if z_Hac_Devices.Exist_Lock(i_Server_Id => i_Device.Server_Id,
                                i_Device_Id => i_Device.Device_Id) then
      v_Old_Company_Id := Hac_Util.Load_Primary_Company(i_Device.Device_Id);
    end if;
  
    z_Hac_Devices.Save_Row(i_Device);
  
    if i_Company_Id is null then
      Hac_Error.Raise_002;
    end if;
  
    if v_Old_Company_Id <> i_Company_Id then
      Device_Detach(i_Company_Id => v_Old_Company_Id, i_Device_Id => i_Device.Device_Id);
    end if;
  
    Device_Attach(i_Company_Id  => i_Company_Id,
                  i_Device_Id   => i_Device.Device_Id,
                  i_Attach_Kind => Hac_Pref.c_Device_Attach_Primary);
  
    for i in 1 .. i_Event_Types.Count
    loop
      z_Hac_Device_Event_Types.Insert_Try(i_Server_Id       => i_Device.Server_Id,
                                          i_Device_Id       => i_Device.Device_Id,
                                          i_Device_Type_Id  => i_Device.Device_Type_Id,
                                          i_Event_Type_Code => i_Event_Types(i));
    end loop;
  
    delete Hac_Device_Event_Types q
     where q.Server_Id = i_Device.Server_Id
       and q.Device_Id = i_Device.Device_Id
       and q.Device_Type_Id = i_Device.Device_Type_Id
       and q.Event_Type_Code not member of i_Event_Types;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  ) is
  begin
    z_Hac_Devices.Delete_One(i_Server_Id => i_Server_Id, i_Device_Id => i_Device_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Analyze_Server_Person_Info
  (
    i_Server_Id      number,
    i_Person         Mr_Natural_Persons%rowtype,
    i_Photo_Sha      varchar2,
    i_Device_Type_Id number,
    i_Rfid_Code      varchar2 := null,
    o_Person_Data    out Gmap
  ) is
    c_Out_Action_Create constant varchar2(1) := 'C';
    c_Out_Action_Update constant varchar2(1) := 'U';
  
    v_Out_Action varchar2(1);
  
    r_Server_Person Hac_Server_Persons%rowtype;
  
    v_Response_Data Gmap;
  
    --------------------------------------------------
    Function Attached_To_Device
    (
      i_Company_Id     number,
      i_Device_Type_Id number,
      i_Person_Id      number
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Location_Persons Lp
       where Lp.Company_Id = i_Company_Id
         and Lp.Person_Id = i_Person_Id
         and exists (select 1
                from Htt_Devices q
               where q.Company_Id = i_Company_Id
                 and q.Location_Id = Lp.Location_Id
                 and q.Device_Type_Id = i_Device_Type_Id)
         and not exists (select *
                from Htt_Blocked_Person_Tracking w
               where w.Company_Id = Lp.Company_Id
                 and w.Filial_Id = Lp.Filial_Id
                 and w.Employee_Id = Lp.Person_Id)
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    if i_Server_Id is null then
      return;
    end if;
  
    if z_Hac_Server_Persons.Exist(i_Server_Id  => i_Server_Id,
                                  i_Company_Id => i_Person.Company_Id,
                                  i_Person_Id  => i_Person.Person_Id,
                                  o_Row        => r_Server_Person) then
      if r_Server_Person.Person_Code is null or
         not Fazo.Equal(r_Server_Person.First_Name, i_Person.First_Name) or
         not Fazo.Equal(r_Server_Person.Last_Name, i_Person.Last_Name) or
         not Fazo.Equal(r_Server_Person.Photo_Sha, i_Photo_Sha) or
         not Fazo.Equal(r_Server_Person.Rfid_Code, i_Rfid_Code) then
        v_Out_Action := c_Out_Action_Update;
      end if;
    else
      if Attached_To_Device(i_Company_Id     => i_Person.Company_Id,
                            i_Device_Type_Id => i_Device_Type_Id,
                            i_Person_Id      => i_Person.Person_Id) then
        v_Out_Action := c_Out_Action_Create;
      end if;
    end if;
  
    if v_Out_Action in (c_Out_Action_Create, c_Out_Action_Update) then
      o_Person_Data := Gmap();
    
      o_Person_Data.Put('person_code', Nvl(r_Server_Person.Person_Code, ''));
      o_Person_Data.Put('external_code',
                        Nvl(r_Server_Person.External_Code, Hac_Util.Gen_Hik_External_Code));
      o_Person_Data.Put('first_name', i_Person.First_Name);
      o_Person_Data.Put('last_name', Nvl(i_Person.Last_Name, ''));
      o_Person_Data.Put('photo_sha', Nvl(i_Photo_Sha, ''));
      o_Person_Data.Put('rfid_code', Nvl(i_Rfid_Code, ''));
    
      v_Response_Data := Gmap();
    
      v_Response_Data.Put('server_id', i_Server_Id);
      v_Response_Data.Put('company_id', i_Person.Company_Id);
      v_Response_Data.Put('person_id', i_Person.Person_Id);
    
      o_Person_Data.Put('response_data', v_Response_Data);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Dahua_Person_Info
  (
    i_Company   Hac_Dss_Company_Servers%rowtype,
    i_Person    Mr_Natural_Persons%rowtype,
    i_Photo_Sha varchar2,
    i_Rfid_Code varchar2,
    o_Data      out Gmap
  ) is
    v_Dahua_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    v_Access_Groups Array_Varchar2;
  
    v_Person_Data Gmap;
  
    --------------------------------------------------
    Function Person_Code
    (
      i_Company_Id number,
      i_Person_Id  number
    ) return varchar2 is
    begin
      return z_Md_Companies.Load(i_Company_Id).Code || i_Person_Id;
    end;
  begin
    Analyze_Server_Person_Info(i_Server_Id      => i_Company.Server_Id,
                               i_Person         => i_Person,
                               i_Photo_Sha      => i_Photo_Sha,
                               i_Device_Type_Id => v_Dahua_Type_Id,
                               i_Rfid_Code      => i_Rfid_Code,
                               o_Person_Data    => v_Person_Data);
  
    if v_Person_Data is not null and i_Company.Person_Group_Code is not null then
      v_Person_Data.Put('person_group_code', i_Company.Person_Group_Code);
      v_Person_Data.Put('start_time', Hac_Pref.c_Auth_Start_Time);
      v_Person_Data.Put('end_time', Hac_Pref.c_Auth_End_Time);
    
      v_Person_Data.Put('person_id',
                        Coalesce(v_Person_Data.o_Varchar2('person_code'),
                                 Person_Code(i_Company_Id => i_Person.Company_Id,
                                             i_Person_Id  => i_Person.Person_Id)));
    
      select q.Access_Group_Code
        bulk collect
        into v_Access_Groups
        from Hac_Device_Persons Dp
        join Hac_Dss_Devices q
          on q.Server_Id = i_Company.Server_Id
         and q.Device_Id = Dp.Device_Id
       where Dp.Server_Id = i_Company.Server_Id
         and Dp.Company_Id = i_Person.Company_Id
         and Dp.Person_Id = i_Person.Person_Id
       group by q.Access_Group_Code;
    
      v_Person_Data.Put('access_groups', v_Access_Groups);
    
      o_Data := v_Person_Data;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Hikvision_Person_Info
  (
    i_Company   Hac_Hik_Company_Servers%rowtype,
    i_Person    Mr_Natural_Persons%rowtype,
    i_Photo_Sha varchar2,
    i_Rfid_Code varchar2,
    o_Data      out Gmap
  ) is
    v_Hikvision_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    v_Person_Data Gmap;
  begin
    Analyze_Server_Person_Info(i_Server_Id      => i_Company.Server_Id,
                               i_Person         => i_Person,
                               i_Photo_Sha      => i_Photo_Sha,
                               i_Device_Type_Id => v_Hikvision_Type_Id,
                               i_Rfid_Code      => i_Rfid_Code,
                               o_Person_Data    => v_Person_Data);
  
    if v_Person_Data is not null and i_Company.Organization_Code is not null then
      v_Person_Data.Put('organization_code', i_Company.Organization_Code);
      v_Person_Data.Put('begin_time', Hac_Pref.c_Hik_Begin_Time);
      v_Person_Data.Put('end_time', Hac_Pref.c_Hik_End_Time);
    
      o_Data := v_Person_Data;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Person_Info
  (
    i_Company_Id number,
    i_Person_Ids Array_Varchar2,
    o_Data       out Array_Varchar2
  ) is
    r_Dss_Company Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Take(i_Company_Id);
    r_Hik_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Take(i_Company_Id);
  
    v_Dss_Host_Url Hac_Servers.Host_Url%type;
    v_Hik_Host_Url Hac_Servers.Host_Url%type;
  
    r_Dss_Server Hac_Dss_Servers%rowtype;
    r_Hik_Server Hac_Hik_Servers%rowtype;
  
    v_Photo_Sha  varchar2(64);
    r_Person     Mr_Natural_Persons%rowtype;
    r_Htt_Person Htt_Persons%rowtype;
  
    v_Dss_Data      Gmap;
    v_Dss_Info_List Glist := Glist();
  
    v_Hik_Data      Gmap;
    v_Hik_Info_List Glist := Glist();
  
    v_Dss_Server Gmap := Gmap();
    v_Hik_Server Gmap := Gmap();
  
    result Gmap := Gmap();
  begin
    o_Data := Array_Varchar2();
  
    r_Dss_Server   := z_Hac_Dss_Servers.Take(r_Dss_Company.Server_Id);
    v_Dss_Host_Url := z_Hac_Servers.Take(r_Dss_Company.Server_Id).Host_Url;
  
    r_Hik_Server   := z_Hac_Hik_Servers.Take(r_Hik_Company.Server_Id);
    v_Hik_Host_Url := z_Hac_Servers.Take(r_Hik_Company.Server_Id).Host_Url;
  
    for i in 1 .. i_Person_Ids.Count
    loop
      r_Person     := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id,
                                                i_Person_Id  => i_Person_Ids(i));
      r_Htt_Person := z_Htt_Persons.Take(i_Company_Id => i_Company_Id,
                                         i_Person_Id  => i_Person_Ids(i));
      v_Photo_Sha  := Hac_Util.Take_Main_Photo(i_Company_Id => i_Company_Id,
                                               i_Person_Id  => i_Person_Ids(i));
    
      Analyze_Dahua_Person_Info(i_Company   => r_Dss_Company,
                                i_Person    => r_Person,
                                i_Photo_Sha => v_Photo_Sha,
                                i_Rfid_Code => r_Htt_Person.Rfid_Code,
                                o_Data      => v_Dss_Data);
    
      Analyze_Hikvision_Person_Info(i_Company   => r_Hik_Company,
                                    i_Person    => r_Person,
                                    i_Photo_Sha => v_Photo_Sha,
                                    i_Rfid_Code => r_Htt_Person.Rfid_Code,
                                    o_Data      => v_Hik_Data);
    
      if v_Dss_Data is not null then
        v_Dss_Info_List.Push(v_Dss_Data.Val);
      end if;
    
      if v_Hik_Data is not null then
        v_Hik_Info_List.Push(v_Hik_Data.Val);
      end if;
    end loop;
  
    if r_Dss_Server.Server_Id is not null then
      v_Dss_Server.Put('host_url', v_Dss_Host_Url);
      v_Dss_Server.Put('username', r_Dss_Server.Username);
      v_Dss_Server.Put('password', r_Dss_Server.Password);
    
      v_Dss_Server.Put('persons', v_Dss_Info_List);
    
      Result.Put('dahua_data', v_Dss_Server);
    end if;
  
    if r_Hik_Server.Server_Id is not null then
      v_Hik_Server.Put('host_url', v_Hik_Host_Url);
      v_Hik_Server.Put('partner_key', r_Hik_Server.Partner_Key);
      v_Hik_Server.Put('partner_secret', r_Hik_Server.Partner_Secret);
    
      v_Hik_Server.Put('persons', v_Hik_Info_List);
    
      Result.Put('hikvision_data', v_Hik_Server);
    end if;
  
    o_Data := Fazo.Read_Clob(Result.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Dahua_Person_Attachment
  (
    i_Company_Id number,
    i_Server_Id  number,
    i_Person_Ids Array_Number,
    o_Data       out Glist
  ) is
    v_Dahua_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    v_Access_Data   Gmap := Gmap();
    v_Response_Data Gmap;
  begin
    o_Data := Glist();
  
    for r in (select q.Device_Id,
                     q.Access_Group_Code,
                     cast(collect(Sp.Person_Code) as Array_Varchar2) Person_Codes,
                     cast(collect(to_number(to_char(Sp.Person_Id))) as Array_Number) Person_Ids
                from Hac_Dss_Devices q
                join Htt_Devices p
                  on p.Company_Id = i_Company_Id
                 and p.Device_Type_Id = v_Dahua_Type_Id
                 and p.Serial_Number = q.Serial_Number
                join Htt_Location_Persons Lp
                  on Lp.Company_Id = i_Company_Id
                 and Lp.Location_Id = p.Location_Id
                 and Lp.Person_Id member of i_Person_Ids
                 and not exists (select *
                        from Htt_Blocked_Person_Tracking w
                       where w.Company_Id = Lp.Company_Id
                         and w.Filial_Id = Lp.Filial_Id
                         and w.Employee_Id = Lp.Person_Id)
                join Hac_Server_Persons Sp
                  on Sp.Server_Id = i_Server_Id
                 and Sp.Company_Id = i_Company_Id
                 and Sp.Person_Id = Lp.Person_Id
               where q.Server_Id = i_Server_Id
                 and q.Access_Group_Code is not null
                 and not exists (select 1
                        from Hac_Device_Persons Dp
                       where Dp.Server_Id = i_Server_Id
                         and Dp.Company_Id = i_Company_Id
                         and Dp.Device_Id = q.Device_Id
                         and Dp.Person_Id = Lp.Person_Id)
               group by q.Device_Id, q.Access_Group_Code
               order by q.Device_Id)
    loop
      if r.Person_Codes.Count > 0 then
        v_Access_Data.Put('access_group_code', r.Access_Group_Code);
        v_Access_Data.Put('person_codes', r.Person_Codes);
      
        v_Response_Data := Gmap();
      
        v_Response_Data.Put('server_id', i_Server_Id);
        v_Response_Data.Put('company_id', i_Company_Id);
        v_Response_Data.Put('device_id', r.Device_Id);
        v_Response_Data.Put('person_ids', r.Person_Ids);
      
        v_Access_Data.Put('response_data', v_Response_Data);
      
        o_Data.Push(v_Access_Data.Val);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Hikvision_Person_Attachment
  (
    i_Company_Id number,
    i_Server_Id  number,
    i_Person_Ids Array_Number,
    o_Data       out Glist
  ) is
    v_Hikvision_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    v_Access_Data   Gmap := Gmap();
    v_Response_Data Gmap;
  begin
    o_Data := Glist();
  
    for r in (select q.Device_Id,
                     q.Access_Level_Code,
                     cast(collect(Sp.Person_Code) as Array_Varchar2) Person_Codes,
                     cast(collect(to_number(to_char(Sp.Person_Id))) as Array_Number) Person_Ids
                from Hac_Hik_Devices q
                join Htt_Devices p
                  on p.Company_Id = i_Company_Id
                 and p.Device_Type_Id = v_Hikvision_Type_Id
                 and p.Serial_Number = q.Serial_Number
                join Htt_Location_Persons Lp
                  on Lp.Company_Id = i_Company_Id
                 and Lp.Location_Id = p.Location_Id
                 and Lp.Person_Id member of i_Person_Ids
                 and not exists (select *
                        from Htt_Blocked_Person_Tracking w
                       where w.Company_Id = Lp.Company_Id
                         and w.Filial_Id = Lp.Filial_Id
                         and w.Employee_Id = Lp.Person_Id)
                join Hac_Server_Persons Sp
                  on Sp.Server_Id = i_Server_Id
                 and Sp.Company_Id = i_Company_Id
                 and Sp.Person_Id = Lp.Person_Id
               where q.Server_Id = i_Server_Id
                 and q.Access_Level_Code is not null
                 and not exists (select 1
                        from Hac_Device_Persons Dp
                       where Dp.Server_Id = i_Server_Id
                         and Dp.Company_Id = i_Company_Id
                         and Dp.Device_Id = q.Device_Id
                         and Dp.Person_Id = Lp.Person_Id)
               group by q.Device_Id, q.Access_Level_Code
               order by q.Device_Id)
    loop
      if r.Person_Codes.Count > 0 then
        v_Access_Data.Put('access_level_code', r.Access_Level_Code);
        v_Access_Data.Put('person_codes', r.Person_Codes);
      
        v_Response_Data := Gmap();
      
        v_Response_Data.Put('server_id', i_Server_Id);
        v_Response_Data.Put('company_id', i_Company_Id);
        v_Response_Data.Put('device_id', r.Device_Id);
        v_Response_Data.Put('person_ids', r.Person_Ids);
      
        v_Access_Data.Put('response_data', v_Response_Data);
      
        o_Data.Push(v_Access_Data.Val);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Dahua_Person_Detachment
  (
    i_Company_Id number,
    i_Server_Id  number,
    i_Person_Ids Array_Number,
    o_Data       out Glist
  ) is
    v_Dahua_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    v_Access_Data   Gmap := Gmap();
    v_Response_Data Gmap;
  begin
    o_Data := Glist();
  
    for r in (select q.Device_Id,
                     q.Access_Group_Code,
                     cast(collect(Sp.Person_Code) as Array_Varchar2) Person_Codes,
                     cast(collect(to_number(to_char(Sp.Person_Id))) as Array_Number) Person_Ids
                from Hac_Dss_Devices q
                join Htt_Devices p
                  on p.Company_Id = i_Company_Id
                 and p.Device_Type_Id = v_Dahua_Type_Id
                 and p.Serial_Number = q.Serial_Number
                join Hac_Device_Persons Dp
                  on Dp.Server_Id = i_Server_Id
                 and Dp.Company_Id = i_Company_Id
                 and Dp.Device_Id = q.Device_Id
                 and Dp.Person_Id member of i_Person_Ids
                join Hac_Server_Persons Sp
                  on Sp.Server_Id = i_Server_Id
                 and Sp.Company_Id = i_Company_Id
                 and Sp.Person_Id = Dp.Person_Id
               where q.Server_Id = i_Server_Id
                 and q.Access_Group_Code is not null
                 and not exists
               (select 1
                        from Htt_Location_Persons Lp
                       where Lp.Company_Id = i_Company_Id
                         and Lp.Location_Id = p.Location_Id
                         and Lp.Person_Id = Dp.Person_Id
                         and not exists (select *
                                from Htt_Blocked_Person_Tracking w
                               where w.Company_Id = Lp.Company_Id
                                 and w.Filial_Id = Lp.Filial_Id
                                 and w.Employee_Id = Lp.Person_Id))
               group by q.Device_Id, q.Access_Group_Code
               order by q.Device_Id)
    loop
      if r.Person_Codes.Count > 0 then
        v_Access_Data.Put('access_group_code', r.Access_Group_Code);
        v_Access_Data.Put('person_codes', r.Person_Codes);
      
        v_Response_Data := Gmap();
      
        v_Response_Data.Put('server_id', i_Server_Id);
        v_Response_Data.Put('company_id', i_Company_Id);
        v_Response_Data.Put('device_id', r.Device_Id);
        v_Response_Data.Put('person_ids', r.Person_Ids);
      
        v_Access_Data.Put('response_data', v_Response_Data);
      
        o_Data.Push(v_Access_Data.Val);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Hikvision_Person_Detachment
  (
    i_Company_Id number,
    i_Server_Id  number,
    i_Person_Ids Array_Number,
    o_Data       out Glist
  ) is
    v_Hikvision_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    v_Access_Data   Gmap := Gmap();
    v_Response_Data Gmap;
  begin
    o_Data := Glist();
  
    for r in (select q.Device_Id,
                     q.Access_Level_Code,
                     cast(collect(Sp.Person_Code) as Array_Varchar2) Person_Codes,
                     cast(collect(to_number(to_char(Sp.Person_Id))) as Array_Number) Person_Ids
                from Hac_Hik_Devices q
                join Htt_Devices p
                  on p.Company_Id = i_Company_Id
                 and p.Device_Type_Id = v_Hikvision_Type_Id
                 and p.Serial_Number = q.Serial_Number
                join Hac_Device_Persons Dp
                  on Dp.Server_Id = i_Server_Id
                 and Dp.Company_Id = i_Company_Id
                 and Dp.Device_Id = q.Device_Id
                 and Dp.Person_Id member of i_Person_Ids
                join Hac_Server_Persons Sp
                  on Sp.Server_Id = i_Server_Id
                 and Sp.Company_Id = i_Company_Id
                 and Sp.Person_Id = Dp.Person_Id
               where q.Server_Id = i_Server_Id
                 and q.Access_Level_Code is not null
                 and not exists
               (select 1
                        from Htt_Location_Persons Lp
                       where Lp.Company_Id = i_Company_Id
                         and Lp.Location_Id = p.Location_Id
                         and Lp.Person_Id = Dp.Person_Id
                         and not exists (select *
                                from Htt_Blocked_Person_Tracking w
                               where w.Company_Id = Lp.Company_Id
                                 and w.Filial_Id = Lp.Filial_Id
                                 and w.Employee_Id = Lp.Person_Id))
               group by q.Device_Id, q.Access_Level_Code
               order by q.Device_Id)
    loop
      if r.Person_Codes.Count > 0 then
        v_Access_Data.Put('access_level_code', r.Access_Level_Code);
        v_Access_Data.Put('person_codes', r.Person_Codes);
      
        v_Response_Data := Gmap();
      
        v_Response_Data.Put('server_id', i_Server_Id);
        v_Response_Data.Put('company_id', i_Company_Id);
        v_Response_Data.Put('device_id', r.Device_Id);
        v_Response_Data.Put('person_ids', r.Person_Ids);
      
        v_Access_Data.Put('response_data', v_Response_Data);
      
        o_Data.Push(v_Access_Data.Val);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Analyze_Attachment_Info
  (
    i_Company_Id number,
    i_Person_Ids Array_Varchar2,
    o_Data       out Array_Varchar2
  ) is
    r_Dss_Company Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Take(i_Company_Id);
    r_Hik_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Take(i_Company_Id);
  
    r_Dss_Server Hac_Dss_Servers%rowtype;
    r_Hik_Server Hac_Hik_Servers%rowtype;
  
    v_Dss_Host_Url Hac_Servers.Host_Url%type;
    v_Hik_Host_Url Hac_Servers.Host_Url%type;
  
    v_Dss_List Glist;
    v_Hik_List Glist;
  
    v_Dss_Data Gmap := Gmap();
    v_Hik_Data Gmap := Gmap();
  
    v_Person_Ids Array_Number := Fazo.Sort(Fazo.To_Array_Number(i_Person_Ids));
  
    v_Result Gmap := Gmap();
  begin
    r_Dss_Server   := z_Hac_Dss_Servers.Take(r_Dss_Company.Server_Id);
    v_Dss_Host_Url := z_Hac_Servers.Take(r_Dss_Company.Server_Id).Host_Url;
  
    r_Hik_Server   := z_Hac_Hik_Servers.Take(r_Hik_Company.Server_Id);
    v_Hik_Host_Url := z_Hac_Servers.Take(r_Hik_Company.Server_Id).Host_Url;
  
    v_Dss_Data.Put('host_url', Nvl(v_Dss_Host_Url, ''));
    v_Dss_Data.Put('username', Nvl(r_Dss_Server.Username, ''));
    v_Dss_Data.Put('password', Nvl(r_Dss_Server.Password, ''));
  
    v_Hik_Data.Put('host_url', Nvl(v_Hik_Host_Url, ''));
    v_Hik_Data.Put('partner_key', Nvl(r_Hik_Server.Partner_Key, ''));
    v_Hik_Data.Put('partner_secret', Nvl(r_Hik_Server.Partner_Secret, ''));
  
    if r_Dss_Company.Server_Id is not null then
      Analyze_Dahua_Person_Attachment(i_Company_Id => i_Company_Id,
                                      i_Server_Id  => r_Dss_Company.Server_Id,
                                      i_Person_Ids => v_Person_Ids,
                                      o_Data       => v_Dss_List);
      v_Dss_Data.Put('attachment_info', v_Dss_List);
    
      Analyze_Dahua_Person_Detachment(i_Company_Id => i_Company_Id,
                                      i_Server_Id  => r_Dss_Company.Server_Id,
                                      i_Person_Ids => v_Person_Ids,
                                      o_Data       => v_Dss_List);
      v_Dss_Data.Put('detachment_info', v_Dss_List);
    end if;
  
    if r_Hik_Company.Server_Id is not null then
      Analyze_Hikvision_Person_Attachment(i_Company_Id => i_Company_Id,
                                          i_Server_Id  => r_Hik_Company.Server_Id,
                                          i_Person_Ids => v_Person_Ids,
                                          o_Data       => v_Hik_List);
      v_Hik_Data.Put('attachment_info', v_Hik_List);
    
      Analyze_Hikvision_Person_Detachment(i_Company_Id => i_Company_Id,
                                          i_Server_Id  => r_Hik_Company.Server_Id,
                                          i_Person_Ids => v_Person_Ids,
                                          o_Data       => v_Hik_List);
      v_Hik_Data.Put('detachment_info', v_Hik_List);
    end if;
  
    v_Result.Put('dahua_data', v_Dss_Data);
    v_Result.Put('hikvision_data', v_Hik_Data);
  
    o_Data := Fazo.Read_Clob(v_Result.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Persons_Attach
  (
    i_Server_Id  number,
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Ids Array_Varchar2
  ) is
  begin
    -- TODO FIX, TEZROQ To'g'rilash kerak
    for i in 1 .. i_Person_Ids.Count
    loop
      z_Hac_Device_Persons.Insert_Try(i_Server_Id  => i_Server_Id,
                                      i_Company_Id => i_Company_Id,
                                      i_Device_Id  => i_Device_Id,
                                      i_Person_Id  => i_Person_Ids(i));
    end loop;
    /*insert into Hac_Device_Persons
      (Server_Id, Company_Id, Device_Id, Person_Id)
    values
      (i_Server_Id, i_Company_Id, i_Device_Id, to_number(i_Person_Ids(i)));*/
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Persons_Detach
  (
    i_Server_Id  number,
    i_Company_Id number,
    i_Device_Id  number,
    
    i_Person_Ids Array_Varchar2
  ) is
  begin
    forall i in 1 .. i_Person_Ids.Count
      delete from Hac_Device_Persons q
       where q.Server_Id = i_Server_Id
         and q.Company_Id = i_Company_Id
         and q.Device_Id = i_Device_Id
         and q.Person_Id = to_number(i_Person_Ids(i));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Person_Info
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_External_Code varchar2
  ) is
  begin
    if not z_Hac_Server_Persons.Exist_Lock(i_Server_Id  => i_Server_Id,
                                           i_Company_Id => i_Company_Id,
                                           i_Person_Id  => i_Person_Id) then
      z_Hac_Server_Persons.Insert_One(i_Server_Id     => i_Server_Id,
                                      i_Company_Id    => i_Company_Id,
                                      i_Person_Id     => i_Person_Id,
                                      i_External_Code => i_External_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Person_Info
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_External_Code varchar2,
    i_First_Name    varchar2,
    i_Last_Name     varchar2,
    i_Photo_Sha     varchar2,
    i_Rfid_Code     varchar2,
    i_Person_Code   varchar2 := null
  ) is
    v_Person_Code Option_Varchar2 := case
                                       when i_Person_Code is not null then
                                        Option_Varchar2(i_Person_Code)
                                       else
                                        null
                                     end;
  begin
    z_Hac_Server_Persons.Update_One(i_Server_Id     => i_Server_Id,
                                    i_Company_Id    => i_Company_Id,
                                    i_Person_Id     => i_Person_Id,
                                    i_First_Name    => Option_Varchar2(i_First_Name),
                                    i_Last_Name     => Option_Varchar2(i_Last_Name),
                                    i_Photo_Sha     => Option_Varchar2(i_Photo_Sha),
                                    i_Rfid_Code     => Option_Varchar2(i_Rfid_Code),
                                    i_Person_Code   => v_Person_Code,
                                    i_External_Code => Option_Varchar2(i_External_Code));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Error_Log
  (
    i_Request_Params varchar2,
    i_Error_Message  varchar2
  ) is
    pragma autonomous_transaction;
  begin
    z_Hac_Error_Log.Save_One(i_Log_Id         => Hac_Error_Log_Sq.Nextval,
                             i_Request_Params => i_Request_Params,
                             i_Error_Message  => i_Error_Message);
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Person
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Persistent boolean := false
  ) is
    v_Dummy varchar2(1);
  begin
    if i_Persistent then
      z_Hac_Sync_Persons.Insert_Try(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
      return;
    end if;
  
    select 'x'
      into v_Dummy
      from Hac_Dirty_Persons q
     where q.Company_Id = i_Company_Id
       and q.Person_Id = i_Person_Id;
  exception
    when No_Data_Found then
      insert into Hac_Dirty_Persons
        (Company_Id, Person_Id)
      values
        (i_Company_Id, i_Person_Id);
    
      b.Add_Post_Callback('begin hac_core.notify_acms_devices; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Notify_Acms_Devices is
    v_Company Hashmap;
    v_Data    Arraylist := Arraylist();
  begin
    for r in (select Dt.Company_Id,
                     cast(collect(to_number(to_char(Dt.Person_Id))) as Array_Number) Person_Ids
                from Hac_Dirty_Persons Dt
               group by Dt.Company_Id)
    loop
      v_Company := Fazo.Zip_Map('company_id', r.Company_Id);
      v_Company.Put('person_ids', r.Person_Ids);
    
      v_Data.Push(v_Company);
    end loop;
  
    b.Add_Final_Service(i_Class_Name => Hac_Pref.c_Acms_Final_Service_Name, i_Data => v_Data);
  
    delete Hac_Dirty_Persons;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Device_Track
  (
    i_Server_Id        number,
    i_Device           Htt_Devices%rowtype,
    i_Person_Code      varchar2,
    i_Track_Time       timestamp with local time zone,
    i_Photo_Sha        varchar2 := null,
    i_Track_Type       varchar2 := Htt_Pref.c_Track_Type_Check,
    i_Person_Auth_Type varchar2 := Hac_Pref.c_Person_Auth_Type_Person_Code
  ) is
    v_Filial_Ids Array_Number;
    r_Track      Htt_Tracks%rowtype;
  begin
    r_Track.Company_Id  := i_Device.Company_Id;
    r_Track.Device_Id   := i_Device.Device_Id;
    r_Track.Location_Id := i_Device.Location_Id;
  
    if i_Person_Auth_Type = Hac_Pref.c_Person_Auth_Type_External_Code then
      r_Track.Person_Id := Hac_Util.Take_Person_Id_By_External_Code(i_Server_Id     => i_Server_Id,
                                                                    i_Company_Id    => i_Device.Company_Id,
                                                                    i_External_Code => i_Person_Code);
    elsif i_Person_Auth_Type = Hac_Pref.c_Person_Auth_Type_Pin then
      r_Track.Person_Id := Htt_Util.Person_Id(i_Company_Id => i_Device.Company_Id, --
                                              i_Pin        => i_Person_Code);
    else
      r_Track.Person_Id := Hac_Util.Take_Person_Id_By_Code(i_Server_Id   => i_Server_Id,
                                                           i_Company_Id  => i_Device.Company_Id,
                                                           i_Person_Code => i_Person_Code);
    end if;
  
    r_Track.Track_Type := i_Track_Type;
    r_Track.Mark_Type  := Htt_Pref.c_Mark_Type_Face;
    r_Track.Track_Time := i_Track_Time;
    r_Track.Is_Valid   := 'Y';
    r_Track.Photo_Sha  := i_Photo_Sha;
  
    v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                            i_Location_Id => r_Track.Location_Id,
                                            i_Person_Id   => r_Track.Person_Id);
  
    for j in 1 .. v_Filial_Ids.Count
    loop
      Ui_Context.Init_Migr(i_Company_Id   => i_Device.Company_Id,
                           i_User_Id      => Md_Pref.User_System(i_Device.Company_Id),
                           i_Project_Code => Verifix.Project_Code,
                           i_Filial_Id    => v_Filial_Ids(j));
    
      r_Track.Filial_Id := v_Filial_Ids(j);
      r_Track.Track_Id  := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dss_Track
  (
    i_Host_Url       varchar2,
    i_Person_Code    varchar2,
    i_Dss_Channel_Id varchar2,
    i_Track_Time     varchar2,
    i_Photo_Url      varchar2,
    i_Photo_Sha      varchar2,
    i_Source_Type    varchar2,
    i_Event_Type     varchar2,
    i_Extra_Info     varchar2
  ) is
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
    r_Server         Hac_Servers%rowtype;
    r_Device         Hac_Dss_Devices%rowtype;
    r_Htt_Device     Htt_Devices%rowtype;
    p_Error_Data     Hashmap;
  
    --------------------------------------------------
    Procedure Save_Notification_Message is
      pragma autonomous_transaction;
    begin
      z_Hac_Dss_Tracks.Insert_Try(i_Host_Url        => i_Host_Url,
                                  i_Person_Code     => Nvl(i_Person_Code,
                                                           Hac_Pref.c_Unknown_Person_Code),
                                  i_Device_Code     => Hac_Util.Extract_Device_Code(i_Dss_Channel_Id),
                                  i_Track_Time      => i_Track_Time,
                                  i_Source_Type     => i_Source_Type,
                                  i_Photo_Url       => i_Photo_Url,
                                  i_Photo_Sha       => i_Photo_Sha,
                                  i_Event_Type_Code => i_Event_Type,
                                  i_Extra_Info      => i_Extra_Info);
      commit;
    
    exception
      when others then
        insert into Hac_Error_Log
          (Log_Id, Request_Params, Error_Message, Created_On)
        values
          (Hac_Error_Log_Sq.Nextval,
           i_Extra_Info,
           Dbms_Utility.Format_Error_Stack || Chr(13) || Chr(10) ||
           Dbms_Utility.Format_Error_Backtrace,
           Current_Timestamp);
      
        commit;
    end;
  begin
    Save_Notification_Message;
  
    if not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id  => Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Dahua),
                                       i_Event_Type_Code => i_Event_Type) then
      return;
    end if;
  
    r_Server := Hac_Util.Take_Server_By_Host_Url(i_Host_Url);
    r_Device := Hac_Util.Take_Device_By_Device_Code(i_Server_Id   => r_Server.Server_Id,
                                                    i_Device_Code => Hac_Util.Extract_Device_Code(i_Dss_Channel_Id));
  
    for r in (select *
                from Hac_Company_Devices Cd
               where Cd.Device_Id = r_Device.Device_Id)
    loop
      r_Htt_Device := Htt_Util.Take_Device_By_Serial_Number(i_Company_Id     => r.Company_Id,
                                                            i_Device_Type_Id => v_Device_Type_Id,
                                                            i_Serial_Number  => r_Device.Serial_Number);
    
      Biruni_Route.Context_Begin;
    
      Save_Device_Track(i_Server_Id   => r_Server.Server_Id, --
                        i_Device      => r_Htt_Device,
                        i_Person_Code => i_Person_Code,
                        i_Track_Time  => Htt_Util.Convert_Timestamp(i_Date     => Hac_Util.Unix_Ts_To_Date(i_Track_Time),
                                                                    i_Timezone => Hac_Pref.c_Utc_Timezone_Code),
                        i_Photo_Sha   => i_Photo_Sha);
    
      Biruni_Route.Context_End;
    end loop;
    commit;
  exception
    when others then
      rollback;
      p_Error_Data := Fazo.Zip_Map('source',
                                   'dahua',
                                   'host_url',
                                   i_Host_Url,
                                   'person_code',
                                   i_Person_Code,
                                   'dss_channel_id',
                                   i_Dss_Channel_Id,
                                   'track_time',
                                   i_Track_Time);
    
      Save_Error_Log(i_Request_Params => p_Error_Data.Json,
                     i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) || Chr(10) ||
                                         Dbms_Utility.Format_Error_Backtrace);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Ex_Event
  (
    i_Server_Id             number,
    i_Door_Code             varchar2,
    i_Person_Code           varchar2,
    i_Event_Time            varchar2,
    i_Event_Type            varchar2,
    i_Event_Code            varchar2,
    i_Check_In_And_Out_Type number,
    i_Event_Type_Code       number,
    i_Door_Name             varchar2,
    i_Src_Type              varchar2 := null,
    i_Status                number := null,
    i_Card_No               varchar2,
    i_Person_Name           varchar2 := null,
    i_Person_Type           varchar2 := null,
    i_Pic_Uri               varchar2,
    i_Pic_Sha               varchar2,
    i_Device_Time           varchar2 := null,
    i_Reader_Code           varchar2,
    i_Reader_Name           varchar2,
    i_Extra_Info            varchar2
  ) is
    pragma autonomous_transaction;
    c_Timestamp_Format varchar2(50) := 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM';
  
    --------------------------------------------------
    Function Event_Exists
    (
      i_Server_Id   number,
      i_Door_Code   varchar2,
      i_Person_Code varchar2,
      i_Event_Time  timestamp with local time zone
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hac_Hik_Ex_Events q
       where q.Server_Id = i_Server_Id
         and q.Door_Code = i_Door_Code
         and q.Person_Code = i_Person_Code
         and q.Event_Time = i_Event_Time;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
  begin
    if Event_Exists(i_Server_Id   => i_Server_Id,
                    i_Door_Code   => i_Door_Code,
                    i_Person_Code => i_Person_Code,
                    i_Event_Time  => To_Timestamp_Tz(i_Event_Time, c_Timestamp_Format)) then
      return;
    end if;
  
    insert into Hac_Hik_Ex_Events
      (Server_Id,
       Door_Code,
       Person_Code,
       Event_Time,
       Event_Type,
       Event_Code,
       Check_In_And_Out_Type,
       Event_Type_Code,
       Door_Name,
       Src_Type,
       Status,
       Card_No,
       Person_Name,
       Person_Type,
       Pic_Uri,
       Pic_Sha,
       Device_Time,
       Reader_Code,
       Reader_Name,
       Extra_Info,
       Created_On)
    values
      (i_Server_Id,
       i_Door_Code,
       i_Person_Code,
       To_Timestamp_Tz(i_Event_Time, c_Timestamp_Format),
       i_Event_Type,
       i_Event_Code,
       i_Check_In_And_Out_Type,
       i_Event_Type_Code,
       i_Door_Name,
       i_Src_Type,
       i_Status,
       i_Card_No,
       i_Person_Name,
       i_Person_Type,
       i_Pic_Uri,
       i_Pic_Sha,
       i_Device_Time,
       i_Reader_Code,
       i_Reader_Name,
       i_Extra_Info,
       Current_Timestamp);
    commit;
  
  exception
    when others then
      insert into Hac_Error_Log
        (Log_Id, Request_Params, Error_Message, Created_On)
      values
        (Hac_Error_Log_Sq.Nextval,
         i_Extra_Info,
         Dbms_Utility.Format_Error_Stack || Chr(13) || Chr(10) ||
         Dbms_Utility.Format_Error_Backtrace,
         Current_Timestamp);
    
      commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Track
  (
    i_Server_Id   number,
    i_Person_Code varchar2,
    i_Door_Code   varchar2,
    i_Track_Time  varchar2,
    i_Photo_Sha   varchar2,
    i_Track_Type  number
  ) is
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    r_Device         Hac_Hik_Devices%rowtype;
    r_Htt_Device     Htt_Devices%rowtype;
  begin
    r_Device := Hac_Util.Get_Hik_Device_By_Door_Code(i_Server_Id => i_Server_Id,
                                                     i_Door_Code => i_Door_Code);
  
    for r in (select *
                from Hac_Company_Devices Cd
               where Cd.Device_Id = r_Device.Device_Id)
    loop
      r_Htt_Device := Htt_Util.Take_Device_By_Serial_Number(i_Company_Id     => r.Company_Id,
                                                            i_Device_Type_Id => v_Device_Type_Id,
                                                            i_Serial_Number  => r_Device.Serial_Number);
    
      Save_Device_Track(i_Server_Id   => i_Server_Id,
                        i_Device      => r_Htt_Device,
                        i_Person_Code => i_Person_Code,
                        i_Track_Time  => To_Timestamp_Tz(i_Track_Time,
                                                         'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM'),
                        i_Photo_Sha   => i_Photo_Sha,
                        i_Track_Type  => case i_Track_Type
                                           when Hac_Pref.c_Hik_Track_Type_Input then
                                            Htt_Pref.c_Track_Type_Input
                                           when Hac_Pref.c_Hik_Track_Type_Output then
                                            Htt_Pref.c_Track_Type_Output
                                           else
                                            Htt_Pref.c_Track_Type_Check
                                         end);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dahua_Tracks
  (
    i_Host_Url    varchar2,
    i_Source_Type varchar2,
    i_Tracks      Glist
  ) is
    v_Track Gmap;
  
    v_Person_Code varchar2(300);
    v_Photo_Url   varchar2(300);
    v_Channel_Id  varchar2(350);
    v_Photo_Sha   varchar2(64);
    v_Track_Time  number;
  begin
    for j in 1 .. i_Tracks.Count
    loop
      v_Track := Gmap(i_Tracks.r_Gmap(j));
    
      v_Channel_Id  := v_Track.r_Varchar2('channelId');
      v_Person_Code := v_Track.r_Varchar2('personId');
      v_Track_Time  := v_Track.r_Number('alarmTime');
      v_Photo_Url   := v_Track.o_Varchar2('captureImageUrl');
      v_Photo_Sha   := v_Track.o_Varchar2('photo_sha');
    
      Hac_Core.Save_Dss_Track(i_Host_Url       => i_Host_Url,
                              i_Person_Code    => v_Person_Code,
                              i_Dss_Channel_Id => v_Channel_Id,
                              i_Track_Time     => v_Track_Time,
                              i_Photo_Url      => v_Photo_Url,
                              i_Photo_Sha      => v_Photo_Sha,
                              i_Source_Type    => i_Source_Type,
                              i_Event_Type     => v_Track.o_Varchar2('alarmTypeId'),
                              i_Extra_Info     => v_Track.Json);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hik_Tracks
  (
    i_Server_Id   number,
    i_Source_Type varchar2,
    i_Tracks      Glist
  ) is
    v_Track Gmap;
  
    v_Door_Code       varchar2(1000 char);
    v_Event_Time      varchar2(100 char);
    v_Person_Code     varchar2(1000 char);
    v_Event_Type_Code number;
    v_Hik_Track_Type  number;
  
    v_Hac_Device_Type_Id number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
  begin
    for j in 1 .. i_Tracks.Count
    loop
      v_Track := Gmap(i_Tracks.r_Gmap(j));
    
      begin
        v_Person_Code     := v_Track.r_Varchar2('personId');
        v_Door_Code       := v_Track.r_Varchar2('doorIndexCode');
        v_Event_Time      := v_Track.r_Varchar2('eventTime');
        v_Hik_Track_Type  := v_Track.r_Number('checkInAndOutType');
        v_Event_Type_Code := v_Track.r_Number('eventType');
      
        Hac_Core.Save_Hik_Ex_Event(i_Server_Id             => i_Server_Id,
                                   i_Door_Code             => v_Door_Code,
                                   i_Person_Code           => v_Person_Code,
                                   i_Event_Time            => v_Event_Time,
                                   i_Event_Type            => i_Source_Type,
                                   i_Event_Code            => v_Track.r_Varchar2('eventId'),
                                   i_Check_In_And_Out_Type => v_Hik_Track_Type,
                                   i_Event_Type_Code       => v_Event_Type_Code,
                                   i_Door_Name             => v_Track.o_Varchar2('doorName'),
                                   i_Card_No               => v_Track.o_Varchar2('cardNo'),
                                   i_Person_Name           => v_Track.o_Varchar2('personName'),
                                   i_Person_Type           => v_Track.o_Varchar2('personType'),
                                   i_Pic_Uri               => v_Track.o_Varchar2('picUri'),
                                   i_Pic_Sha               => v_Track.o_Varchar2('photo_sha'),
                                   i_Device_Time           => v_Track.o_Varchar2('deviceTime'),
                                   i_Reader_Code           => v_Track.o_Varchar2('readerIndexCode'),
                                   i_Reader_Name           => v_Track.o_Varchar2('readerName'),
                                   i_Extra_Info            => v_Track.Json);
      
        continue when not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id  => v_Hac_Device_Type_Id,
                                                      i_Event_Type_Code => v_Event_Type_Code);
      
        Hac_Core.Save_Hik_Track(i_Server_Id   => i_Server_Id,
                                i_Person_Code => v_Person_Code,
                                i_Track_Time  => v_Event_Time,
                                i_Door_Code   => v_Door_Code,
                                i_Photo_Sha   => v_Track.o_Varchar2('photo_sha'),
                                i_Track_Type  => v_Hik_Track_Type);
      exception
        when others then
          Hac_Core.Save_Error_Log(i_Request_Params => v_Track.Json,
                                  i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) ||
                                                      Chr(10) || Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Authenticate_Hik_Servlet
  (
    i_Token          varchar2,
    o_Server_Id      out number,
    o_Host_Url       out varchar2,
    o_Partner_Key    out varchar2,
    o_Partner_Secret out varchar2
  ) is
  begin
    select k.Server_Id, t.Host_Url, k.Partner_Key, k.Partner_Secret
      into o_Server_Id, o_Host_Url, o_Partner_Key, o_Partner_Secret
      from Hac_Hik_Servers k
      join Hac_Servers t
        on t.Server_Id = k.Server_Id
     where k.Token = i_Token;
  exception
    when No_Data_Found then
      Hac_Error.Raise_006(i_Token);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Image_Ignored
  (
    i_Device_Id      number,
    i_Device_Type_Id number,
    i_Serial_Number  varchar2
  ) return varchar2 Result_Cache is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hac_Company_Devices Cd
      join Htt_Devices q
        on q.Company_Id = Cd.Company_Id
       and q.Device_Type_Id = i_Device_Type_Id
       and q.Serial_Number = i_Serial_Number
     where Cd.Device_Id = i_Device_Id
       and q.Ignore_Images = 'N'
       and Rownum = 1;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Device_Settings
  (
    i_Server_Id      varchar2,
    i_Door_Code      varchar2,
    o_Device_Exists  out varchar2,
    o_Tracks_Ignored out varchar2,
    o_Image_Ignored  out varchar2
  ) is
    r_Device         Hac_Hik_Devices%rowtype;
    v_Device_Type_Id number;
  begin
    r_Device := Hac_Util.Get_Hik_Device_By_Door_Code(i_Server_Id => i_Server_Id,
                                                     i_Door_Code => i_Door_Code);
  
    if r_Device.Serial_Number is null then
      o_Device_Exists  := 'N';
      o_Tracks_Ignored := 'Y';
      o_Image_Ignored  := 'Y';
    
      return;
    end if;
  
    v_Device_Type_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    o_Device_Exists  := 'Y';
    o_Tracks_Ignored := r_Device.Ignore_Tracks;
    o_Image_Ignored  := Image_Ignored(i_Device_Id      => r_Device.Device_Id,
                                      i_Device_Type_Id => v_Device_Type_Id,
                                      i_Serial_Number  => r_Device.Serial_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Dahua_Device_Settings
  (
    i_Host_Url       varchar2,
    i_Dss_Channel_Id varchar2,
    o_Device_Exists  out varchar2,
    o_Image_Ignored  out varchar2
  ) is
    v_Device_Type_Id number;
    r_Server         Hac_Servers%rowtype;
    r_Device         Hac_Dss_Devices%rowtype;
  
  begin
    r_Server := Hac_Util.Take_Server_By_Host_Url(i_Host_Url);
    r_Device := Hac_Util.Take_Device_By_Device_Code(i_Server_Id   => r_Server.Server_Id,
                                                    i_Device_Code => Hac_Util.Extract_Device_Code(i_Dss_Channel_Id));
  
    if r_Device.Serial_Number is null then
      o_Device_Exists := 'N';
      o_Image_Ignored := 'Y';
    
      return;
    end if;
  
    v_Device_Type_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    o_Device_Exists := 'Y';
    o_Image_Ignored := Image_Ignored(i_Device_Id      => r_Device.Device_Id,
                                     i_Device_Type_Id => v_Device_Type_Id,
                                     i_Serial_Number  => r_Device.Serial_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Listening_Device_Settings
  (
    i_Device_Token  varchar2,
    o_Device_Exists out varchar2,
    o_Image_Ignored out varchar2
  ) is
    r_Device         Hac_Hik_Listening_Devices%rowtype;
    r_Htt_Device     Htt_Devices%rowtype;
    v_Device_Type_Id number;
  begin
    r_Device := z_Hac_Hik_Listening_Devices.Take(i_Device_Token);
  
    if r_Device.Serial_Number is null then
      o_Device_Exists := 'N';
      o_Image_Ignored := 'Y';
    
      return;
    end if;
  
    o_Device_Exists := 'Y';
  
    v_Device_Type_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    r_Htt_Device := Htt_Util.Take_Device_By_Serial_Number(i_Company_Id     => r_Device.Company_Id,
                                                          i_Device_Type_Id => v_Device_Type_Id,
                                                          i_Serial_Number  => r_Device.Serial_Number);
  
    o_Image_Ignored := r_Htt_Device.Ignore_Images;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Event(i_Val Array_Varchar2) is
    v_Event_Data  Gmap;
    v_Person_Data Gmap;
    ---------- 
    v_Door_Code       varchar2(1000 char);
    v_Happen_Time     varchar2(100 char);
    v_Person_Code     varchar2(1000 char);
    v_Event_Type_Code number;
    v_Hik_Track_Type  number;
    ---------- 
    v_Host_Name  varchar2(1024 char);
    v_Server_Id  number;
    p_Error_Data Hashmap;
  begin
  
    v_Event_Data  := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
    v_Server_Id   := to_number(v_Event_Data.r_Varchar2('serverId'));
    v_Person_Data := v_Event_Data.r_Gmap('data');
    ---------- 
    v_Person_Code     := v_Person_Data.r_Varchar2('personId');
    v_Happen_Time     := v_Event_Data.r_Varchar2('happenTime');
    v_Door_Code       := v_Event_Data.r_Varchar2('srcIndex');
    v_Event_Type_Code := v_Event_Data.r_Number('eventType');
  
    v_Hik_Track_Type := v_Person_Data.r_Number('checkInAndOutType');
  
    Hac_Core.Save_Hik_Ex_Event(i_Server_Id             => v_Server_Id,
                               i_Door_Code             => v_Door_Code,
                               i_Person_Code           => v_Person_Code,
                               i_Event_Time            => v_Happen_Time,
                               i_Event_Type            => Hac_Pref.c_Hik_Event_Type_From_Notifications,
                               i_Event_Code            => v_Event_Data.r_Varchar2('eventId'),
                               i_Check_In_And_Out_Type => v_Hik_Track_Type,
                               i_Event_Type_Code       => v_Event_Type_Code,
                               i_Door_Name             => v_Event_Data.o_Varchar2('srcName'),
                               i_Src_Type              => v_Event_Data.o_Varchar2('srcType'),
                               i_Status                => v_Event_Data.o_Number('status'),
                               i_Card_No               => v_Person_Data.o_Varchar2('cardNo'),
                               i_Pic_Uri               => v_Person_Data.o_Varchar2('picUri'),
                               i_Pic_Sha               => v_Person_Data.o_Varchar2('picSha'),
                               i_Reader_Code           => v_Person_Data.o_Varchar2('readerIndexCode'),
                               i_Reader_Name           => v_Person_Data.o_Varchar2('readerName'),
                               i_Extra_Info            => v_Event_Data.Json);
  
    if not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id  => Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision),
                                       i_Event_Type_Code => v_Event_Type_Code) then
      return;
    end if;
  
    Hac_Core.Save_Hik_Track(i_Server_Id   => v_Server_Id,
                            i_Person_Code => v_Person_Code,
                            i_Track_Time  => v_Happen_Time,
                            i_Door_Code   => v_Door_Code,
                            i_Photo_Sha   => v_Person_Data.o_Varchar2('picSha'),
                            i_Track_Type  => v_Hik_Track_Type);
  exception
    when others then
      p_Error_Data := Fazo.Zip_Map('source',
                                   'hikvision',
                                   'host_name',
                                   v_Host_Name,
                                   'person_code',
                                   v_Person_Code,
                                   'door_code',
                                   v_Door_Code,
                                   'track_time',
                                   v_Happen_Time);
    
      Hac_Core.Save_Error_Log(i_Request_Params => p_Error_Data.Json,
                              i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) ||
                                                  Chr(10) || Dbms_Utility.Format_Error_Backtrace);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Hik_Device_Listener_Event
  (
    i_Token   varchar2,
    i_Pic_Sha varchar2,
    i_Val     Array_Varchar2
  ) is
    v_Data       Gmap;
    v_Event_Data Gmap;
  
    v_Event_Type        varchar2(300 char);
    v_Event_Time        timestamp with local time zone;
    v_Person_Code       varchar2(300 char);
    v_Attendance_Status varchar2(300 char);
    v_Major_Event_Type  number;
    v_Sub_Event_Type    number;
  
    r_Device Hac_Hik_Listening_Devices%rowtype;
  
    p_Error_Data Hashmap;
  
    c_Timestamp_Format varchar2(50) := 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM';
  
    -------------------------------------------------- 
    Procedure Save_Hik_Device_Listener_Event
    (
      i_Device_Token      varchar2,
      i_Device_Code       varchar2,
      i_Mac_Address       varchar2,
      i_Event_Time        timestamp with local time zone,
      i_Person_Code       varchar2,
      i_Event_Type        varchar2,
      i_Major_Event_Type  varchar2,
      i_Sub_Event_Type    varchar2,
      i_Attendance_Status varchar2,
      i_Pic_Sha           varchar2,
      i_Extra_Info        varchar2
    ) is
      pragma autonomous_transaction;
    begin
      insert into Hac_Hik_Device_Listener_Events
        (Event_Id,
         Device_Token,
         Device_Code,
         Mac_Address,
         Event_Time,
         Person_Code,
         Event_Type,
         Major_Event_Type,
         Sub_Event_Type,
         Attendance_Status,
         Pic_Sha,
         Extra_Info,
         Created_On)
      values
        (Hac_Hik_Device_Events_Sq.Nextval,
         i_Device_Token,
         i_Device_Code,
         i_Mac_Address,
         i_Event_Time,
         i_Person_Code,
         i_Event_Type,
         i_Major_Event_Type,
         i_Sub_Event_Type,
         i_Attendance_Status,
         i_Pic_Sha,
         i_Extra_Info,
         Current_Timestamp);
      commit;
    
    exception
      when others then
        insert into Hac_Error_Log
          (Log_Id, Request_Params, Error_Message, Created_On)
        values
          (Hac_Error_Log_Sq.Nextval,
           i_Extra_Info,
           Dbms_Utility.Format_Error_Stack || Chr(13) || Chr(10) ||
           Dbms_Utility.Format_Error_Backtrace,
           Current_Timestamp);
      
        commit;
    end;
  
    --------------------------------------------------
    Procedure Save_Hik_Listener_Tracks
    (
      i_Device            Hac_Hik_Listening_Devices%rowtype,
      i_Event_Time        timestamp with local time zone,
      i_Person_Code       varchar2,
      i_Attendance_Status varchar2,
      i_Pic_Sha           varchar2
    ) is
      v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
      r_Device         Hac_Hik_Devices%rowtype;
      r_Htt_Device     Htt_Devices%rowtype;
    begin
      r_Device := Hac_Util.Take_Hik_Device_By_Serial_Number(i_Device.Serial_Number);
    
      r_Htt_Device := Htt_Util.Take_Device_By_Serial_Number(i_Company_Id     => i_Device.Company_Id,
                                                            i_Device_Type_Id => v_Device_Type_Id,
                                                            i_Serial_Number  => i_Device.Serial_Number);
    
      Save_Device_Track(i_Server_Id        => r_Device.Server_Id,
                        i_Device           => r_Htt_Device,
                        i_Person_Code      => i_Person_Code,
                        i_Track_Time       => i_Event_Time,
                        i_Photo_Sha        => i_Pic_Sha,
                        i_Person_Auth_Type => i_Device.Person_Auth_Type,
                        i_Track_Type       => case i_Attendance_Status
                                                when Hac_Pref.c_Attendance_Status_Input then
                                                 Htt_Pref.c_Track_Type_Input
                                                when Hac_Pref.c_Attendance_Status_Output then
                                                 Htt_Pref.c_Track_Type_Output
                                                else
                                                 Htt_Pref.c_Track_Type_Check
                                              end);
    end;
  
  begin
    r_Device := z_Hac_Hik_Listening_Devices.Load(i_Device_Token => i_Token);
  
    v_Data := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
  
    v_Event_Type := v_Data.r_Varchar2('eventType');
    v_Event_Time := To_Timestamp_Tz(v_Data.r_Varchar2('dateTime'), c_Timestamp_Format);
  
    v_Event_Data := Nvl(v_Data.o_Gmap(v_Event_Type), Gmap());
  
    v_Person_Code       := v_Event_Data.o_Varchar2('employeeNoString');
    v_Major_Event_Type  := v_Event_Data.o_Number('majorEventType');
    v_Sub_Event_Type    := v_Event_Data.o_Number('subEventType');
    v_Attendance_Status := v_Event_Data.o_Varchar2('attendanceStatus');
  
    Save_Hik_Device_Listener_Event(i_Device_Token      => r_Device.Device_Token,
                                   i_Device_Code       => v_Data.o_Varchar2('deviceID'),
                                   i_Mac_Address       => v_Data.o_Varchar2('macAddress'),
                                   i_Event_Time        => v_Event_Time,
                                   i_Person_Code       => v_Person_Code,
                                   i_Event_Type        => v_Event_Type,
                                   i_Major_Event_Type  => v_Major_Event_Type,
                                   i_Sub_Event_Type    => v_Sub_Event_Type,
                                   i_Attendance_Status => v_Attendance_Status,
                                   i_Pic_Sha           => i_Pic_Sha,
                                   i_Extra_Info        => v_Data.Json);
  
    if not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id   => Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision),
                                       i_Event_Type_Code  => v_Sub_Event_Type,
                                       i_Major_Event_Type => v_Major_Event_Type) then
      return;
    end if;
  
    Save_Hik_Listener_Tracks(i_Device            => r_Device,
                             i_Event_Time        => v_Event_Time,
                             i_Person_Code       => v_Person_Code,
                             i_Attendance_Status => v_Attendance_Status,
                             i_Pic_Sha           => i_Pic_Sha);
  exception
    when others then
      p_Error_Data := Fazo.Zip_Map('source',
                                   'hikvision_device',
                                   'device_token',
                                   i_Token,
                                   'person_code',
                                   v_Person_Code,
                                   'track_time',
                                   v_Event_Time);
    
      Hac_Core.Save_Error_Log(i_Request_Params => p_Error_Data.Json,
                              i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) ||
                                                  Chr(10) || Dbms_Utility.Format_Error_Backtrace);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Execute by Application servers
  -- Don't remove this procedure
  ----------------------------------------------------------------------------------------------------
  Procedure Dahua_Mq_Notification
  (
    i_Host_Url       varchar2,
    i_Person_Code    varchar2,
    i_Dss_Channel_Id varchar2,
    i_Track_Time     varchar2,
    i_Photo_Url      varchar2,
    i_Photo_Sha      varchar2,
    i_Event_Type     varchar2,
    i_Extra_Info     varchar2
  ) is
  begin
    Dbms_Session.Reset_Package;
    Save_Dss_Track(i_Host_Url       => i_Host_Url,
                   i_Person_Code    => i_Person_Code,
                   i_Dss_Channel_Id => i_Dss_Channel_Id,
                   i_Track_Time     => i_Track_Time,
                   i_Photo_Url      => i_Photo_Url,
                   i_Photo_Sha      => i_Photo_Sha,
                   i_Source_Type    => Hac_Pref.c_Dss_Track_Source_Queue,
                   i_Event_Type     => i_Event_Type,
                   i_Extra_Info     => i_Extra_Info);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Acms_Device_Update
  (
    i_Server_Id number,
    i_Device_Id number,
    i_Device_Ip Option_Varchar2 := null,
    i_Ready     Option_Varchar2 := null,
    i_Status    Option_Varchar2 := null
  ) is
  begin
    z_Hac_Devices.Update_One(i_Server_Id => i_Server_Id,
                             i_Device_Id => i_Device_Id,
                             i_Device_Ip => i_Device_Ip,
                             i_Ready     => i_Ready,
                             i_Status    => i_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_File
  (
    i_Sha          varchar2,
    i_File_Size    varchar2,
    i_File_Name    varchar2,
    i_Content_Type varchar2,
    i_Store_Kind   varchar2
  ) is
  begin
    z_Biruni_Files.Insert_Try(i_Sha          => i_Sha,
                              i_File_Size    => i_File_Size,
                              i_Store_Kind   => i_Store_Kind,
                              i_File_Name    => i_File_Name,
                              i_Content_Type => i_Content_Type);
  end;

end Hac_Core;
/
