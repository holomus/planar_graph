create or replace package Hac_Util is
  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id(i_Pcode varchar2) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Primary_Company(i_Device_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Take_Server_By_Host_Url(i_Host_Url varchar2) return Hac_Servers%rowtype;
  ---------------------------------------------------------------------------------------------------- 
  Function Date_To_Unix_Ts
  (
    i_Date     in date,
    i_Timezone varchar2 := Sessiontimezone
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Unix_Ts_To_Date(i_Timestamp in number) return date;
  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Uuid return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Hik_External_Code return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Isup_Password return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Gen_Token return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Device_By_Name
  (
    i_Server_Id   number,
    i_Device_Name varchar2
  ) return Hac_Hik_Ex_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Door_Code_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Device_By_Door_Code
  (
    i_Server_Id number,
    i_Door_Code varchar2
  ) return Hac_Hik_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Access_Level_Code_By_Name
  (
    i_Server_Id         number,
    i_Access_Level_Name varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Name
  (
    i_Server_Id   number,
    i_Device_Name varchar2
  ) return Hac_Dss_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Dss_Device_By_Serial_Number(i_Serial_Number varchar2) return Hac_Dss_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Hik_Device_By_Serial_Number(i_Serial_Number varchar2) return Hac_Hik_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return Hac_Dss_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Hik_Device_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return Hac_Hik_Devices%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Person_Id_By_Code
  (
    i_Server_Id   number,
    i_Company_Id  number,
    i_Person_Code varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Take_Person_Id_By_External_Code
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_External_Code varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Extract_Device_Code(i_Channel_Id varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Take_Main_Photo
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Dss_Name(i_Real_Name varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_File(i_Sha varchar2) return blob;
  ----------------------------------------------------------------------------------------------------
  Function Is_Good_Event_Type
  (
    i_Device_Type_Id   number,
    i_Event_Type_Code  number,
    i_Major_Event_Type number := null
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status(i_Device_Status varchar2) return varchar2;
  Function Device_Statuses return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Map_Hik_Device_Status(i_Hik_Device_Status number) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Map_Dss_Device_Status(i_Dss_Device_Status number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State(i_Door_State varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Device_Attach_Kind(i_Attach_Kind varchar2) return varchar2;
  Function Device_Attach_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Combined_Event_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Combined_Event_Type
  (
    i_Event_Types_Codes Array_Varchar2,
    i_Event_Type_Names  Array_Varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Auth_Type(i_Auth_Type varchar2) return varchar2;
  Function Person_Auth_Types(i_Include_Person_Code boolean := false) return Matrix_Varchar2;
end Hac_Util;
/
create or replace package body Hac_Util is
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
    return b.Translate('HAC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Type_Id(i_Pcode varchar2) return number is
    result number;
  begin
    select q.Device_Type_Id
      into result
      from Hac_Device_Types q
     where q.Pcode = i_Pcode;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Primary_Company(i_Device_Id number) return number is
    result number;
  begin
    select Cd.Company_Id
      into result
      from Hac_Company_Devices Cd
     where Cd.Device_Id = i_Device_Id
       and Cd.Attach_Kind = Hac_Pref.c_Device_Attach_Primary;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Server_By_Host_Url(i_Host_Url varchar2) return Hac_Servers%rowtype is
    r_Server Hac_Servers%rowtype;
  begin
    select q.*
      into r_Server
      from Hac_Servers q
     where q.Host_Url = i_Host_Url;
  
    return r_Server;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Date_To_Unix_Ts
  (
    i_Date     in date,
    i_Timezone varchar2 := Sessiontimezone
  ) return number is
    v_Date date := Htt_Util.Timestamp_To_Date(i_Timestamp => Htt_Util.Convert_Timestamp(i_Date     => i_Date,
                                                                                        i_Timezone => i_Timezone),
                                              i_Timezone  => Hac_Pref.c_Utc_Timezone_Code);
  begin
    return Trunc((v_Date - to_date('01.01.1970', 'dd.mm.yyyy')) * 60 * 60 * 24);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Unix_Ts_To_Date(i_Timestamp in number) return date is
  begin
    return to_date('01.01.1970', 'dd.mm.yyyy') + Numtodsinterval(i_Timestamp, 'second');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Uuid return varchar2 is
  begin
    return Rawtohex(Sys_Guid());
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Hik_External_Code return varchar2 is
  begin
    return Substr(Rawtohex(Sys_Guid()), 1, 16);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Isup_Password return varchar2 is
  begin
    return Dbms_Random.String('x', 8);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Token return varchar2 is
    v_Src raw(256) := Dbms_Crypto.Randombytes(128);
  begin
    return Dbms_Crypto.Hash(Src => v_Src, Typ => Dbms_Crypto.Hash_Sh256);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Device_By_Name
  (
    i_Server_Id   number,
    i_Device_Name varchar2
  ) return Hac_Hik_Ex_Devices%rowtype is
    result Hac_Hik_Ex_Devices%rowtype;
  begin
    select *
      into result
      from Hac_Hik_Ex_Devices t
     where t.Server_Id = i_Server_Id
       and t.Device_Name = i_Device_Name;
  
    return result;
  exception
    when others then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Door_Code_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return varchar2 is
    result Hac_Hik_Ex_Doors.Door_Code%type;
  begin
    select t.Door_Code
      into result
      from Hac_Hik_Ex_Doors t
     where t.Server_Id = i_Server_Id
       and t.Device_Code = i_Device_Code;
  
    return result;
  exception
    when others then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Device_By_Door_Code
  (
    i_Server_Id number,
    i_Door_Code varchar2
  ) return Hac_Hik_Devices%rowtype is
    result Hac_Hik_Devices%rowtype;
  begin
    select t.*
      into result
      from Hac_Hik_Devices t
     where t.Server_Id = i_Server_Id
       and t.Door_Code = i_Door_Code;
  
    return result;
  exception
    when others then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hik_Access_Level_Code_By_Name
  (
    i_Server_Id         number,
    i_Access_Level_Name varchar2
  ) return varchar2 is
    result Hac_Hik_Ex_Access_Levels.Access_Level_Code%type;
  begin
    select t.Access_Level_Code
      into result
      from Hac_Hik_Ex_Access_Levels t
     where t.Server_Id = i_Server_Id
       and t.Access_Level_Name = i_Access_Level_Name;
  
    return result;
  exception
    when others then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Name
  (
    i_Server_Id   number,
    i_Device_Name varchar2
  ) return Hac_Dss_Devices%rowtype is
    r_Device Hac_Dss_Devices%rowtype;
  begin
    select p.*
      into r_Device
      from Hac_Devices q
      join Hac_Dss_Devices p
        on q.Server_Id = p.Server_Id
       and q.Device_Id = p.Device_Id
     where q.Server_Id = i_Server_Id
       and q.Device_Name = i_Device_Name;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Dss_Device_By_Serial_Number(i_Serial_Number varchar2) return Hac_Dss_Devices%rowtype is
    r_Device Hac_Dss_Devices%rowtype;
  begin
    select q.*
      into r_Device
      from Hac_Dss_Devices q
     where q.Serial_Number = i_Serial_Number;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Hik_Device_By_Serial_Number(i_Serial_Number varchar2) return Hac_Hik_Devices%rowtype is
    r_Device Hac_Hik_Devices%rowtype;
  begin
    select q.*
      into r_Device
      from Hac_Hik_Devices q
     where q.Serial_Number = i_Serial_Number;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Device_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return Hac_Dss_Devices%rowtype is
    r_Device Hac_Dss_Devices%rowtype;
  begin
    select q.*
      into r_Device
      from Hac_Dss_Devices q
     where q.Server_Id = i_Server_Id
       and q.Device_Code = i_Device_Code;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Hik_Device_By_Device_Code
  (
    i_Server_Id   number,
    i_Device_Code varchar2
  ) return Hac_Hik_Devices%rowtype is
    r_Device Hac_Hik_Devices%rowtype;
  begin
    select q.*
      into r_Device
      from Hac_Hik_Devices q
     where q.Server_Id = i_Server_Id
       and q.Device_Code = i_Device_Code;
  
    return r_Device;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Person_Id_By_Code
  (
    i_Server_Id   number,
    i_Company_Id  number,
    i_Person_Code varchar2
  ) return number is
    v_Person_Id number;
  begin
    select Sp.Person_Id
      into v_Person_Id
      from Hac_Server_Persons Sp
     where Sp.Company_Id = i_Company_Id
       and Sp.Server_Id = i_Server_Id
       and Sp.Person_Code = i_Person_Code;
  
    return v_Person_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Person_Id_By_External_Code
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_External_Code varchar2
  ) return number is
    v_Person_Id number;
  begin
    select Sp.Person_Id
      into v_Person_Id
      from Hac_Server_Persons Sp
     where Sp.Company_Id = i_Company_Id
       and Sp.Server_Id = i_Server_Id
       and Sp.External_Code = i_External_Code;
  
    return v_Person_Id;
  exception
    when No_Data_Found then
      return null;
    
  end;

  ----------------------------------------------------------------------------------------------------
  Function Extract_Device_Code(i_Channel_Id varchar2) return varchar2 is
    -- device channel_id consists of 4 elements
    -- and looks like: device_code$7$0$0
    -- 7 stands for "access control" channel type
    v_Parsed_Channel Array_Varchar2;
  begin
    v_Parsed_Channel := Fazo.Split(i_Channel_Id, '$');
  
    if v_Parsed_Channel.Count != 4 then
      b.Raise_Error('not a channel code');
    end if;
  
    return v_Parsed_Channel(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Any_Photo
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2 is
    result varchar2(64);
  begin
    select q.Photo_Sha
      into result
      from Htt_Person_Photos q
     where q.Company_Id = i_Company_Id
       and q.Person_Id = i_Person_Id
     order by q.Photo_Sha
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Main_Photo
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2 is
    result varchar2(64);
  begin
    select q.Photo_Sha
      into result
      from Htt_Person_Photos q
     where q.Company_Id = i_Company_Id
       and q.Person_Id = i_Person_Id
       and q.Is_Main = 'Y'
       and Rownum = 1;
  
    return result;
  exception
    when No_Data_Found then
      return Take_Any_Photo(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dss_Name(i_Real_Name varchar2) return varchar2 is
  begin
    return i_Real_Name || ':' || Hac_Next.Name_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_File(i_Sha varchar2) return blob is
    v_File blob;
  begin
    select q.File_Content
      into v_File
      from Biruni_Filespace q
     where q.Sha = i_Sha;
  
    return v_File;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Good_Event_Type
  (
    i_Device_Type_Id   number,
    i_Event_Type_Code  number,
    i_Major_Event_Type number := null
  ) return boolean is
    r_Event_Type Hac_Event_Types%rowtype;
  begin
    if i_Major_Event_Type is not null and
       i_Major_Event_Type <> Hac_Pref.c_Accepted_Major_Event_Type then
      return false;
    end if;
  
    r_Event_Type := z_Hac_Event_Types.Take(i_Device_Type_Id  => i_Device_Type_Id,
                                           i_Event_Type_Code => i_Event_Type_Code);
    return r_Event_Type.Access_Granted = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  -- device statuses
  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status_Offline return varchar2 is
  begin
    return t('device_status:offline');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status_Online return varchar2 is
  begin
    return t('device_status:online');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status_Unknown return varchar2 is
  begin
    return t('device_status:unknown');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Status(i_Device_Status varchar2) return varchar2 is
  begin
    return --
    case i_Device_Status --
    when Hac_Pref.c_Device_Status_Offline then t_Device_Status_Offline --
    when Hac_Pref.c_Device_Status_Online then t_Device_Status_Online --
    when Hac_Pref.c_Device_Status_Unknown then t_Device_Status_Unknown -- 
    end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- maps Hikvision device status to hac_devices.status
  ---------------------------------------------------------------------------------------------------- 
  Function Map_Hik_Device_Status(i_Hik_Device_Status number) return varchar2 is
  begin
    return --
    case i_Hik_Device_Status --
    when Hac_Pref.c_Hik_Device_Status_Offline then Hac_Pref.c_Device_Status_Offline --
    when Hac_Pref.c_Hik_Device_Status_Online then Hac_Pref.c_Device_Status_Online --
    when Hac_Pref.c_Hik_Device_Status_Unknown then Hac_Pref.c_Device_Status_Unknown -- 
    else Hac_Pref.c_Device_Status_Unknown --
    end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Map_Dss_Device_Status(i_Dss_Device_Status number) return varchar2 is
  begin
    return --
    case i_Dss_Device_Status --
    when Hac_Pref.c_Dss_Device_Status_Offline then Hac_Pref.c_Device_Status_Offline --
    when Hac_Pref.c_Dss_Device_Status_Online then Hac_Pref.c_Device_Status_Online --
    else Hac_Pref.c_Device_Status_Unknown --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Hikvision door states
  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State_Remain_Open return varchar2 is
  begin
    return t('hik_door_state:remain open');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State_Closed return varchar2 is
  begin
    return t('hik_door_state:closed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State_Open return varchar2 is
  begin
    return t('hik_door_state:open');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State_Remain_Closed return varchar2 is
  begin
    return t('hik_door_state:remain closed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State_Offline return varchar2 is
  begin
    return t('hik_door_state:offline');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hik_Door_State(i_Door_State varchar2) return varchar2 is
  begin
    return --
    case i_Door_State --
    when Hac_Pref.c_Hik_Door_State_Remain_Open then t_Hik_Door_State_Remain_Open --
    when Hac_Pref.c_Hik_Door_State_Closed then t_Hik_Door_State_Closed --
    when Hac_Pref.c_Hik_Door_State_Open then t_Hik_Door_State_Open -- 
    when Hac_Pref.c_Hik_Door_State_Remain_Closed then t_Hik_Door_State_Remain_Closed --
    when Hac_Pref.c_Hik_Door_State_Offline then t_Hik_Door_State_Offline -- 
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hac_Pref.c_Device_Status_Offline, --
                                          Hac_Pref.c_Device_Status_Online,
                                          Hac_Pref.c_Device_Status_Unknown),
                           Array_Varchar2(t_Device_Status_Offline, --
                                          t_Device_Status_Online,
                                          t_Device_Status_Unknown));
  end;

  ----------------------------------------------------------------------------------------------------
  -- device attach kinds
  ---------------------------------------------------------------------------------------------------- 
  Function t_Device_Attach_Primary return varchar2 is
  begin
    return t('device_attach:primary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Attach_Secondary return varchar2 is
  begin
    return t('device_attach:secondary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Device_Attach_Kind(i_Attach_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Attach_Kind --
    when Hac_Pref.c_Device_Attach_Primary then t_Device_Attach_Primary --
    when Hac_Pref.c_Device_Attach_Secondary then t_Device_Attach_Secondary --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Attach_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hac_Pref.c_Device_Attach_Primary, --
                                          Hac_Pref.c_Device_Attach_Secondary),
                           Array_Varchar2(t_Device_Attach_Primary, --
                                          t_Device_Attach_Secondary));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Combined_Event_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2('196893' || Hac_Pref.c_Event_Type_Delimiter || '198914',
                                          t('face or card')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Combined_Event_Type
  (
    i_Event_Types_Codes Array_Varchar2,
    i_Event_Type_Names  Array_Varchar2
  ) return varchar2 is
    v_Event_Type_Code varchar2(500) := Fazo.Gather(i_Event_Types_Codes,
                                                   Hac_Pref.c_Event_Type_Delimiter);
    v_Static_Types    Matrix_Varchar2 := Combined_Event_Types;
  begin
    if i_Event_Type_Names.Count = 1 then
      return i_Event_Type_Names(1);
    end if;
  
    for i in 1 .. v_Static_Types.Count
    loop
      if v_Event_Type_Code = v_Static_Types(i) (1) then
        return v_Static_Types(i)(2);
      end if;
    end loop;
  
    return Fazo.Gather(i_Event_Type_Names, ' / ');
  end;

  ----------------------------------------------------------------------------------------------------
  -- person auth types
  ---------------------------------------------------------------------------------------------------- 
  Function t_Person_Auth_Person_Code return varchar2 is
  begin
    return t('person_auth:person code');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Auth_External_Code return varchar2 is
  begin
    return t('person_auth:external code');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Auth_Pin return varchar2 is
  begin
    return t('person_auth:pin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Auth_Type(i_Auth_Type varchar2) return varchar2 is
  begin
    return --
    case i_Auth_Type --
    when Hac_Pref.c_Person_Auth_Type_Person_Code then t_Person_Auth_Person_Code --
    when Hac_Pref.c_Person_Auth_Type_External_Code then t_Person_Auth_External_Code --
    when Hac_Pref.c_Person_Auth_Type_Pin then t_Person_Auth_Pin --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Auth_Types(i_Include_Person_Code boolean := false) return Matrix_Varchar2 is
    v_Codes Array_Varchar2 := Array_Varchar2(Hac_Pref.c_Person_Auth_Type_External_Code, --
                                             Hac_Pref.c_Person_Auth_Type_Pin);
    v_Names Array_Varchar2 := Array_Varchar2(t_Person_Auth_External_Code, --
                                             t_Person_Auth_Pin);
  begin
    if i_Include_Person_Code then
      Fazo.Push(v_Codes, Hac_Pref.c_Person_Auth_Type_Person_Code);
      Fazo.Push(v_Names, t_Person_Auth_Person_Code);
    end if;
  
    return Matrix_Varchar2(v_Codes, v_Names);
  end;

end Hac_Util;
/
