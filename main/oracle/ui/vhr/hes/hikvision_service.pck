create or replace package Ui_Vhr470 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Data(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Offline_Tracks(i_Input Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Ip_Address(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Commands(p Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Commands(p Json_Object_t);
end Ui_Vhr470;
/
create or replace package body Ui_Vhr470 is
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
    return b.Translate('UI-VHR470:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Server_Id_By_Secret_Code(i_Secret_Code varchar2) return number is
    result number;
  begin
    select q.Server_Id
      into result
      from Htt_Acms_Servers q
     where q.Secret_Code = i_Secret_Code;
  
    return result;
  
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Data(p Hashmap) return Arraylist is
    v_Server_Id  number;
    v_Company_Id number;
  
    v_Device            Hashmap;
    v_Persons           Arraylist;
    v_Person            Hashmap;
    v_Photo_Shas        Array_Varchar2;
    v_Hikvision_Type_Id number;
    v_Dahua_Type_Id     number;
    v_Date              date := Trunc(sysdate);
    result              Arraylist := Arraylist();
  begin
    Ui.Assert_Is_Company_Head;
  
    v_Server_Id := Load_Server_Id_By_Secret_Code(p.r_Varchar2('secret_code'));
  
    v_Hikvision_Type_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dahua_Type_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    for r in (select w.*,
                     d.Location_Id,
                     Htt_Util.Device_Type_Pcode(d.Device_Type_Id) Pcode,
                     (select Ld.Device_Token
                        from Hac_Hik_Listening_Devices Ld
                       where Ld.Serial_Number = d.Serial_Number
                         and Ld.Company_Id = d.Company_Id
                         and Ld.Person_Auth_Type = Hac_Pref.c_Person_Auth_Type_Pin) Device_Token
                from Htt_Devices d
                join Htt_Acms_Devices w
                  on d.Company_Id = w.Company_Id
                 and d.Device_Id = w.Device_Id
               where d.Device_Type_Id in (v_Hikvision_Type_Id, v_Dahua_Type_Id)
                 and d.State = 'A'
                 and exists (select 1
                        from Htt_Company_Acms_Servers w
                       where w.Server_Id = v_Server_Id
                         and w.Company_Id = d.Company_Id))
    loop
      v_Device := Fazo.Zip_Map('device_id',
                               r.Device_Id,
                               'host',
                               r.Host,
                               'login',
                               r.Login,
                               'password',
                               r.Password);
    
      v_Device.Put('dynamic_ip', r.Dynamic_Ip);
      v_Device.Put('ip_address', r.Ip_Address);
      v_Device.Put('port', r.Port);
      v_Device.Put('protocol', r.Protocol);
      v_Device.Put('pcode', r.Pcode);
      v_Device.Put('device_token', r.Device_Token);
      /*v_Device.Put('timezone_code',
      Htt_Util.Load_Timezone(i_Company_Id  => r.Company_Id,
                             i_Location_Id => r.Location_Id));*/
    
      v_Persons    := Arraylist();
      v_Company_Id := r.Company_Id;
    
      for r_Person in (select p.Person_Id, p.Name, Hp.Pin
                         from Mr_Natural_Persons p
                         join Htt_Persons Hp
                           on Hp.Company_Id = v_Company_Id
                          and Hp.Person_Id = p.Person_Id
                        where p.Company_Id = v_Company_Id
                          and p.State = 'A'
                          and Hp.Pin is not null
                          and exists
                        (select *
                                 from Htt_Location_Persons Lp
                                where Lp.Company_Id = v_Company_Id
                                  and Lp.Location_Id = r.Location_Id
                                  and Lp.Person_Id = p.Person_Id
                                  and exists
                                (select 1
                                         from Href_Staffs s
                                        where s.Company_Id = v_Company_Id
                                          and s.Filial_Id = Lp.Filial_Id
                                          and s.Employee_Id = Lp.Person_Id
                                          and s.Hiring_Date <= v_Date
                                          and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date)
                                          and s.State = 'A')
                                  and not exists (select *
                                         from Htt_Blocked_Person_Tracking w
                                        where w.Company_Id = Lp.Company_Id
                                          and w.Filial_Id = Lp.Filial_Id
                                          and w.Employee_Id = Lp.Person_Id)))
      loop
        v_Person := Fazo.Zip_Map('person_id',
                                 r_Person.Person_Id,
                                 'name',
                                 r_Person.Name,
                                 'pin',
                                 r_Person.Pin);
      
        select Photo_Sha
          bulk collect
          into v_Photo_Shas
          from Htt_Person_Photos
         where Company_Id = v_Company_Id
           and Person_Id = r_Person.Person_Id;
      
        v_Person.Put('photo_shas', v_Photo_Shas);
      
        v_Persons.Push(v_Person);
      end loop;
    
      v_Device.Put('persons', v_Persons);
    
      Result.Push(v_Device);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Device
  (
    i_Secret_Code varchar2,
    i_Device_Id   number
  ) return Htt_Devices%rowtype is
    v_Server_Id number;
    result      Htt_Devices%rowtype;
  begin
    v_Server_Id := Load_Server_Id_By_Secret_Code(i_Secret_Code);
  
    select *
      into result
      from Htt_Devices q
     where q.Device_Id = i_Device_Id
       and exists (select 1
              from Htt_Company_Acms_Servers w
             where w.Company_Id = q.Company_Id
               and w.Server_Id = v_Server_Id);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap is
    r_Device        Htt_Devices%rowtype;
    r_Track         Htt_Tracks%rowtype;
    v_Track         Hashmap;
    v_Tracks        Arraylist;
    v_Statuses      Matrix_Varchar2;
    v_Filial_Ids    Array_Number;
    v_Sysdate       date := Trunc(sysdate);
    v_Track_Type    varchar2(1);
    v_Dummy         varchar2(1);
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
    result          Hashmap := Hashmap();
  begin
    r_Device := Load_Device(i_Secret_Code => p.r_Varchar2('secret_code'), --
                            i_Device_Id   => p.r_Number('device_id'));
  
    v_Tracks   := p.r_Arraylist('tracks');
    v_Statuses := Matrix_Varchar2();
  
    r_Track.Company_Id  := r_Device.Company_Id;
    r_Track.Device_Id   := r_Device.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    v_Timezone_Code     := Htt_Util.Load_Timezone(i_Company_Id  => r_Track.Company_Id,
                                                  i_Location_Id => r_Track.Location_Id);
  
    for i in 1 .. v_Tracks.Count
    loop
      begin
        v_Track := Treat(v_Tracks.r_Hashmap(i) as Hashmap);
      
        z_Htt_Tracks.To_Row(r_Track, --
                            v_Track,
                            z.Person_Id,
                            z.Track_Type,
                            z.Mark_Type,
                            z.Photo_Sha);
      
        r_Track.Track_Time := Htt_Util.Convert_Timestamp(i_Date     => v_Track.r_Date('track_time',
                                                                                      Href_Pref.c_Date_Format_Second),
                                                         i_Timezone => v_Timezone_Code);
        r_Track.Is_Valid   := 'Y';
        v_Track_Type       := r_Track.Track_Type;
      
        v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                                i_Location_Id => r_Track.Location_Id,
                                                i_Person_Id   => r_Track.Person_Id);
      
        if v_Filial_Ids.Count = 0 then
          b.Raise_Error(t('the person is not attached to the location where the device is installed, filial_id=$2, location_id=$1, person_id=$3',
                          r_Track.Filial_Id,
                          r_Track.Location_Id,
                          r_Track.Person_Id));
        end if;
      
        for j in 1 .. v_Filial_Ids.Count
        loop
          r_Track.Filial_Id := v_Filial_Ids(j);
          r_Track.Track_Id  := Htt_Next.Track_Id;
          v_Dummy           := null;
        
          if v_Track_Type is null then
            begin
              select Decode(Last_Track_Type,
                            Htt_Pref.c_Track_Type_Input,
                            Htt_Pref.c_Track_Type_Output,
                            Htt_Pref.c_Track_Type_Input)
                into r_Track.Track_Type
                from (select t.Track_Type as Last_Track_Type
                        from Htt_Tracks t
                       where t.Company_Id = r_Track.Company_Id
                         and t.Filial_Id = r_Track.Filial_Id
                         and t.Person_Id = r_Track.Person_Id
                         and t.Track_Date = v_Sysdate
                         and t.Track_Type <> Htt_Pref.c_Track_Type_Check
                       order by t.Track_Time desc)
               where Rownum = 1;
            exception
              when No_Data_Found then
                r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
            end;
          end if;
        
          begin
            select 'x'
              into v_Dummy
              from Htt_Tracks q
             where q.Company_Id = r_Track.Company_Id
               and q.Filial_Id = r_Track.Filial_Id
               and q.Person_Id = r_Track.Person_Id
               and q.Track_Time = r_Track.Track_Time
               and q.Original_Type = v_Track_Type;
          exception
            when No_Data_Found then
              Htt_Api.Track_Add(r_Track);
          end;
        end loop;
      
        Fazo.Push(v_Statuses, i, 'success');
      exception
        when others then
          Fazo.Push(v_Statuses, i, 'error', b.Trim_Ora_Error(sqlerrm));
      end;
    end loop;
  
    Result.Put('statuses', Fazo.Zip_Matrix(v_Statuses));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Split
  (
    i_Input     Array_Varchar2,
    i_Delimiter varchar2
  ) return Array_Varchar2 is
    v_Buff   varchar2(4000);
    v_Tokens Array_Varchar2;
    result   Array_Varchar2 := Array_Varchar2();
  begin
    for i in 1 .. i_Input.Count
    loop
      v_Tokens := Fazo.Split(v_Buff || i_Input(i), i_Delimiter);
    
      for j in 1 .. v_Tokens.Count - 1
      loop
        if v_Tokens(j) is not null then
          Fazo.Push(result, v_Tokens(j));
        end if;
      end loop;
    
      v_Buff := v_Tokens(v_Tokens.Count);
    end loop;
  
    if v_Buff is not null then
      Fazo.Push(result, v_Buff);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Offline_Tracks(i_Input Array_Varchar2) is
    v_Server_Id       number;
    f_Cache_Companies Fazo.Number_Id_Aat;
  
    v_Lines Array_Varchar2;
    v_Meta  Hashmap;
    v_Arr   Arraylist;
  
    r_Track Htt_Acms_Tracks%rowtype;
  
    --------------------------------------------------    
    Function Get_Company_Id
    (
      i_Server_Id number,
      i_Device_Id number
    ) return number is
      result number;
    begin
      if f_Cache_Companies.Exists(i_Device_Id) then
        return f_Cache_Companies(i_Device_Id);
      end if;
    
      select q.Company_Id
        into result
        from Htt_Devices q
       where q.Device_Id = i_Device_Id
         and q.State = 'A'
         and exists (select *
                from Htt_Company_Acms_Servers w
               where w.Company_Id = q.Company_Id
                 and w.Server_Id = i_Server_Id);
    
      f_Cache_Companies(i_Device_Id) := result;
      return result;
    exception
      when No_Data_Found then
      
        f_Cache_Companies(i_Device_Id) := null;
        return null;
    end;
  
  begin
    Ui.Assert_Is_Company_Head;
  
    v_Lines := Split(i_Input, Chr(10));
  
    if v_Lines.Count = 0 then
      b.Raise_Fatal('metadata structure is not true');
    end if;
  
    v_Meta      := Fazo.Parse_Map(v_Lines(1));
    v_Server_Id := Load_Server_Id_By_Secret_Code(v_Meta.r_Varchar2('secret_code'));
  
    if v_Server_Id is null then
      b.Raise_Fatal('acms server is not found by secret_code');
    end if;
  
    for i in 2 .. v_Lines.Count
    loop
      v_Arr := Fazo.Parse_Array(v_Lines(i));
    
      r_Track.Device_Id := v_Arr.r_Number(1);
    
      r_Track.Company_Id := Get_Company_Id(i_Server_Id => v_Server_Id,
                                           i_Device_Id => r_Track.Device_Id);
    
      if r_Track.Company_Id is null then
        b.Raise_Fatal('acms servers not supported this device');
      end if;
    
      r_Track.Track_Id       := Htt_Next.Acms_Track_Id;
      r_Track.Person_Id      := v_Arr.r_Number(2);
      r_Track.Track_Type     := v_Arr.r_Varchar2(3);
      r_Track.Track_Datetime := to_date(v_Arr.r_Varchar2(4), 'dd.mm.yyyy hh24:mi:ss');
      r_Track.Mark_Type      := v_Arr.r_Varchar2(5);
      r_Track.Status         := Htt_Pref.c_Acms_Track_Status_New;
    
      Htt_Api.Acms_Track_Insert(r_Track);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Ip_Address(p Hashmap) is
    r_Device    Htt_Devices%rowtype;
    r_Hikvision Htt_Acms_Devices%rowtype;
  begin
    r_Device := Load_Device(i_Secret_Code => p.r_Varchar2('secret_code'),
                            i_Device_Id   => p.r_Number('device_id'));
  
    r_Hikvision := z_Htt_Acms_Devices.Lock_Load(i_Company_Id => r_Device.Company_Id,
                                                i_Device_Id  => r_Device.Device_Id);
    if r_Hikvision.Dynamic_Ip = 'Y' then
      r_Hikvision.Ip_Address := p.r_Varchar2('ip_address');
    
      Htt_Api.Acms_Device_Save(r_Hikvision);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Commands(p Json_Object_t) return Json_Array_t is
    r_Command         Htt_Acms_Commands%rowtype;
    v_Server_Id       number;
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
    v_Date            date;
    v_Command_Kind    varchar2(100);
    v_Command_Ids     Array_Number := Array_Number();
    v_Command         Json_Object_t;
    result            Json_Array_t := Json_Array_t;
  
    f_Cache_Locations Fazo.Number_Id_Aat;
  
    --------------------------------------------------
    Function Location_Id return number is
      result number;
    begin
      if f_Cache_Locations.Exists(r_Command.Device_Id) then
        return f_Cache_Locations(r_Command.Device_Id);
      end if;
    
      result := z_Htt_Devices.Load(i_Company_Id => r_Command.Company_Id, i_Device_Id => r_Command.Device_Id).Location_Id;
    
      f_Cache_Locations(r_Command.Device_Id) := result;
    
      return result;
    end;
  
    --------------------------------------------------
    Procedure Update_Device is
      r_Device Htt_Acms_Devices%rowtype;
      v_Device Json_Object_t := Json_Object_t;
    begin
      v_Command_Kind := 'update_device';
      r_Device       := z_Htt_Acms_Devices.Load(i_Company_Id => r_Command.Company_Id,
                                                i_Device_Id  => r_Command.Device_Id);
    
      v_Device.Put('dynamic_ip', r_Device.Dynamic_Ip);
      v_Device.Put('ip_address', r_Device.Ip_Address);
      v_Device.Put('port', r_Device.Port);
      v_Device.Put('protocol', r_Device.Protocol);
      v_Device.Put('host', r_Device.Host);
      v_Device.Put('login', r_Device.Login);
      v_Device.Put('password', r_Device.Password);
      v_Device.Put('timezone_code',
                   Htt_Util.Load_Timezone(i_Company_Id  => r_Device.Company_Id,
                                          i_Location_Id => z_Htt_Devices.Load(i_Company_Id => r_Command.Company_Id, --
                                                           i_Device_Id => r_Command.Device_Id).Location_Id));
    
      v_Command.Put('device', v_Device);
    end;
  
    --------------------------------------------------
    Procedure Update_All_Device_Persons is
      v_Person      Json_Object_t;
      v_Photo_Shas  Json_Array_t;
      v_Persons     Json_Array_t := Json_Array_t;
      v_Location_Id number;
    begin
      v_Command_Kind := 'update_all_device_persons';
      v_Location_Id  := Location_Id;
      v_Date         := Trunc(sysdate);
    
      for r in (select p.Person_Id, p.Name
                  from Mr_Natural_Persons p
                 where p.Company_Id = r_Command.Company_Id
                   and p.State = 'A'
                   and exists (select 1
                          from Htt_Persons Hp
                         where Hp.Company_Id = r_Command.Company_Id
                           and Hp.Person_Id = p.Person_Id)
                   and exists
                 (select *
                          from Htt_Location_Persons Lp
                         where Lp.Company_Id = r_Command.Company_Id
                           and Lp.Location_Id = v_Location_Id
                           and Lp.Person_Id = p.Person_Id
                           and exists
                         (select 1
                                  from Href_Staffs s
                                 where s.Company_Id = r_Command.Company_Id
                                   and s.Filial_Id = Lp.Filial_Id
                                   and s.Employee_Id = Lp.Person_Id
                                   and s.Hiring_Date <= v_Date
                                   and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date)
                                   and s.State = 'A')
                           and not exists (select *
                                  from Htt_Blocked_Person_Tracking w
                                 where w.Company_Id = Lp.Company_Id
                                   and w.Filial_Id = Lp.Filial_Id
                                   and w.Employee_Id = Lp.Person_Id)))
      loop
        v_Person     := Json_Object_t;
        v_Photo_Shas := Json_Array_t;
      
        for Ph in (select Photo_Sha
                     from Htt_Person_Photos
                    where Company_Id = r_Command.Company_Id
                      and Person_Id = r.Person_Id)
        loop
          v_Photo_Shas.Append(Ph.Photo_Sha);
        end loop;
      
        v_Person.Put('person_id', r.Person_Id);
        v_Person.Put('name', r.Name);
        v_Person.Put('photo_shas', v_Photo_Shas);
      
        v_Persons.Append(v_Person);
      end loop;
    
      v_Command.Put('persons', v_Persons);
    end;
  
    --------------------------------------------------
    Procedure Update_Person is
      v_Person     Json_Object_t;
      v_Photo_Shas Json_Array_t;
    begin
      v_Command_Kind := 'update_person';
      v_Person       := Json_Object_t;
      v_Photo_Shas   := Json_Array_t;
    
      for Ph in (select Photo_Sha
                   from Htt_Person_Photos
                  where Company_Id = r_Command.Company_Id
                    and Person_Id = r_Command.Person_Id)
      loop
        v_Photo_Shas.Append(Ph.Photo_Sha);
      end loop;
    
      v_Person.Put('person_id', r_Command.Person_Id);
      v_Person.Put('name',
                   z_Mr_Natural_Persons.Load(i_Company_Id => r_Command.Company_Id, i_Person_Id => r_Command.Person_Id).Name);
      v_Person.Put('photo_shas', v_Photo_Shas);
    
      v_Command.Put('person', v_Person);
    end;
  
    --------------------------------------------------
    Procedure Remove_Device is
    begin
      v_Command_Kind := 'remove_device';
    end;
  
    --------------------------------------------------
    Procedure Remove_Person is
    begin
      v_Command_Kind := 'remove_person';
    
      v_Command.Put('person_id', r_Command.Person_Id);
    end;
  
    --------------------------------------------------
    Procedure Sync_Tracks is
    begin
      v_Command_Kind := 'sync_tracks';
    
      v_Command := Json_Object_t(r_Command.Data);
    end;
  begin
    Ui.Assert_Is_Company_Head;
  
    v_Server_Id := Load_Server_Id_By_Secret_Code(p.Get_String('secret_code'));
  
    if v_Server_Id is null then
      return result;
    end if;
  
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    for r in (select *
                from Htt_Acms_Commands q
               where q.Device_Id in (select d.Device_Id
                                       from Htt_Devices d
                                      where d.Device_Type_Id in (v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                                        and d.State = 'A'
                                        and exists (select 1
                                               from Htt_Acms_Devices Ad
                                              where Ad.Company_Id = d.Company_Id
                                                and Ad.Device_Id = d.Device_Id)
                                        and exists (select 1
                                               from Htt_Company_Acms_Servers w
                                              where w.Server_Id = v_Server_Id
                                                and w.Company_Id = d.Company_Id))
                 and q.Status = Htt_Pref.c_Command_Status_New
               order by q.Command_Id)
    loop
      r_Command := r;
      v_Command := Json_Object_t;
    
      case r.Command_Kind
        when Htt_Pref.c_Command_Kind_Update_Device then
          Update_Device;
        when Htt_Pref.c_Command_Kind_Update_All_Device_Persons then
          Update_All_Device_Persons;
        when Htt_Pref.c_Command_Kind_Update_Person then
          Update_Person;
        when Htt_Pref.c_Command_Kind_Remove_Device then
          Remove_Device;
        when Htt_Pref.c_Command_Kind_Remove_Person then
          Remove_Person;
        when Htt_Pref.c_Command_Kind_Sync_Tracks then
          Sync_Tracks; -- overrides v_Command
      end case;
    
      v_Command.Put('command_id', r.Command_Id);
      v_Command.Put('command_kind', v_Command_Kind);
      v_Command.Put('device_id', r.Device_Id);
    
      Result.Append(v_Command);
      Fazo.Push(v_Command_Ids, r.Command_Id);
    end loop;
  
    v_Date := sysdate;
  
    forall i in 1 .. v_Command_Ids.Count
      update Htt_Acms_Commands c
         set c.Status           = Htt_Pref.c_Command_Status_Sent,
             c.State_Changed_On = v_Date
       where c.Command_Id = v_Command_Ids(i);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Commands(p Json_Object_t) is
    v_Server_Id  number;
    v_Count      number;
    v_Command_Id number;
    v_Company_Id number;
    v_Command    Json_Object_t;
    v_Commands   Json_Array_t;
  
    --------------------------------------------------
    Procedure Company_Id is
    begin
      select q.Company_Id
        into v_Company_Id
        from Htt_Acms_Commands q
       where q.Command_Id = v_Command_Id;
    exception
      when No_Data_Found then
        v_Company_Id := null;
    end;
  begin
    Ui.Assert_Is_Company_Head;
  
    v_Server_Id := Load_Server_Id_By_Secret_Code(p.Get_String('secret_code'));
  
    if v_Server_Id is null then
      return;
    end if;
  
    v_Commands := p.Get_Array('commands');
    v_Count    := v_Commands.Get_Size - 1;
  
    for i in 0 .. v_Count
    loop
      v_Command    := Treat(v_Commands.Get(i) as Json_Object_t);
      v_Command_Id := v_Command.Get_Number('command_id');
    
      Company_Id;
    
      case v_Command.Get_String('success')
        when 'Y' then
          Htt_Api.Acms_Command_Complete(i_Company_Id => v_Company_Id, i_Command_Id => v_Command_Id);
        when 'N' then
          Htt_Api.Acms_Command_Fail(i_Company_Id => v_Company_Id,
                                    i_Command_Id => v_Command_Id,
                                    i_Error_Msg  => v_Command.Get_String('error_msg'));
      end case;
    end loop;
  end;

end Ui_Vhr470;
/
