create or replace package Ui_Vhr94 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Device_Persons(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Device_Tracks(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Tracks(p Hashmap);
end Ui_Vhr94;
/
create or replace package body Ui_Vhr94 is
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
    return b.Translate('UI-VHR94:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Data        Htt_Devices%rowtype;
    r_Device_Type Htt_Device_Types%rowtype;
    r_Acms        Htt_Acms_Devices%rowtype;
    result        Hashmap;
  begin
    r_Data := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                 i_Device_Id  => p.r_Number('device_id'));
  
    result := z_Htt_Devices.To_Map(r_Data,
                                   z.Device_Id,
                                   z.Name,
                                   z.Serial_Number,
                                   z.Location_Id,
                                   z.Charge_Percentage,
                                   z.Track_Types,
                                   z.Mark_Type,
                                   z.Lang_Code,
                                   z.Last_Seen_On,
                                   z.Restricted_Type,
                                   z.Ignore_Tracks,
                                   z.Only_Last_Restricted,
                                   z.State,
                                   z.Created_On,
                                   z.Modified_On);
  
    r_Device_Type := z_Htt_Device_Types.Load(i_Device_Type_Id => r_Data.Device_Type_Id);
  
    Result.Put('device_type_name', r_Device_Type.Name);
    Result.Put('location_name',
               z_Htt_Locations.Load(i_Company_Id => r_Data.Company_Id, i_Location_Id => r_Data.Location_Id).Name);
    Result.Put('lang_name', z_Md_Langs.Take(r_Data.Lang_Code).Name);
    Result.Put('autogen_inputs',
               Md_Util.Decode(r_Data.Autogen_Inputs, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('autogen_outputs',
               Md_Util.Decode(r_Data.Autogen_Outputs, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('ignore_tracks_name',
               Md_Util.Decode(r_Data.Ignore_Tracks, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('ignore_images_name',
               Md_Util.Decode(r_Data.Ignore_Images, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('use_settings', Md_Util.Decode(r_Data.Use_Settings, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('state_name', Md_Util.Decode(r_Data.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
    Result.Put('restricted_type_name',
               case --
               when r_Data.Restricted_Type is not null then
               Htt_Util.t_Track_Type(r_Data.Restricted_Type) --
               else null --
               end);
    Result.Put('only_last_restricted_name',
               case --
               when r_Data.Only_Last_Restricted = 'Y' then Ui.t_Yes --
               else Ui.t_No --
               end);
  
    if r_Device_Type.Pcode != Htt_Pref.c_Pcode_Device_Type_Timepad then
      Result.Put('device_type_id', r_Data.Device_Type_Id);
    
      if r_Device_Type.Pcode in
         (Htt_Pref.c_Pcode_Device_Type_Hikvision, Htt_Pref.c_Pcode_Device_Type_Dahua) and
         z_Htt_Acms_Devices.Exist(i_Company_Id => r_Data.Company_Id,
                                  i_Device_Id  => r_Data.Device_Id,
                                  o_Row        => r_Acms) then
        Result.Put_All(z_Htt_Acms_Devices.To_Map(r_Acms,
                                                 z.Dynamic_Ip,
                                                 z.Ip_Address,
                                                 z.Port,
                                                 z.Host,
                                                 z.Login));
      
        Result.Put('dynamic_ip_name',
                   Md_Util.Decode(r_Acms.Dynamic_Ip, 'Y', Ui.t_Yes, 'N', Ui.t_No));
        Result.Put('protocol_name', Htt_Util.t_Protocol(r_Acms.Protocol));
        Result.Put('integrate_by_service', 'Y');
      end if;
    end if;
  
    Result.Put('references',
               Fazo.Zip_Map('terminal',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal),
                            'hikvision',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
                            'dahua',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua),
                            'tk_check',
                            Htt_Pref.c_Track_Type_Check));
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Persons(p Hashmap) return Fazo_Query is
    r_Device Htt_Devices%rowtype;
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id, --
                                   i_Device_Id  => p.r_Number('device_id'));
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'device_id',
                             r_Device.Device_Id,
                             'location_id',
                             r_Device.Location_Id,
                             'pr_admin',
                             Htt_Pref.c_Person_Role_Admin,
                             'pr_normal',
                             Htt_Pref.c_Person_Role_Normal);
    v_Query  := 'select q.company_id,
                        q.person_id,
                        q.pin_code,
                        q.rfid_code,
                        q.qr_code,
                        q.created_by,
                        q.created_on,
                        q.modified_by,
                        q.modified_on,';
  
    if r_Device.Device_Type_Id =
       Htt_Util.Device_Type_Id(i_Pcode => Htt_Pref.c_Pcode_Device_Type_Hikvision) then
      v_Query := v_Query || '(select w.External_Code
                               from Hac_Hik_Company_Servers h
                               join Hac_Server_Persons w
                                 on h.Company_Id = w.Company_Id
                                and h.Server_Id = w.Server_Id
                               where h.Company_Id = :company_id
                                 and w.Person_Id = q.person_id)';
    else
      v_Query := v_Query || 'q.pin';
    end if;
  
    v_Query := v_Query || ' as pin,
                        nvl2((select 1
                               from htt_device_admins k
                              where k.company_id = :company_id
                                and k.device_id = :device_id
                                and k.person_id = q.person_id),
                             :pr_admin,
                             :pr_normal) person_role,
                        nvl2((select 1
                               from hzk_device_persons k
                              where k.company_id = :company_id
                                and k.device_id = :device_id
                                and k.person_id = q.person_id),
                             ''Y'',
                             ''N'') synchronized
                   from htt_persons q
                  where q.company_id = :company_id
                    and (exists (select 1
                                   from htt_device_admins k
                                  where k.company_id = :company_id
                                    and k.device_id = :device_id
                                    and k.person_id = q.person_id)
                     or exists (select 1 
                                  from htt_location_persons s
                                 where s.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and s.filial_id = :filial_id';
    end if;
  
    v_Query := v_Query || --
               ' and s.location_id = :location_id
                 and s.person_id = q.person_id
                 and not exists (select 1
                            from htt_blocked_person_tracking w
                           where w.company_id = s.company_id
                             and w.filial_id = s.filial_id
                             and w.employee_id = s.person_id)))';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id');
    q.Varchar2_Field('synchronized', 'person_role', 'pin');
  
    v_Matrix := Htt_Util.Person_Roles;
  
    q.Option_Field('person_role_name', 'person_role', v_Matrix(1), v_Matrix(2));
    q.Option_Field('synchronized_name',
                   'synchronized',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Map_Field('name', 'select p.name from mr_natural_persons p where p.person_id = $person_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Device_Tracks(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'device_id', p.r_Number('device_id'));
    v_Query  := 'select *
                   from htt_tracks q
                  where q.company_Id = :company_id
                    and q.device_Id = :device_id';
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and q.filial_id = :filial_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('track_id', 'person_id', 'location_id', 'accuracy', 'created_by', 'modified_by');
    q.Varchar2_Field('track_type', 'mark_type', 'note', 'is_valid');
    q.Date_Field('track_date', 'track_time', 'track_datetime', 'created_on', 'modified_on');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Mark_Types;
  
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('is_valid_name',
                   'is_valid',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Query := 'select *
                  from mr_natural_persons w
                 where w.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from mhr_employees f
                         where f.company_id = :company_id
                           and f.filial_id = :filial_id
                           and f.employee_id = w.person_id)';
    end if;
  
    q.Refer_Field('person_name', 'person_id', 'mr_natural_persons', 'person_id', 'name', v_Query);
  
    v_Query := 'select *
                  from htt_locations w
                 where w.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = w.location_id)';
    end if;
  
    q.Refer_Field('location_name', 'location_id', 'htt_locations', 'location_id', 'name', v_Query);
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users r 
                    where r.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users r 
                    where r.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(p Hashmap) is
  begin
    Uit_Htt.Sync_Device(p.r_Number('device_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Device_Id  number := p.r_Number('device_id');
    v_Person_Ids Array_Number := p.r_Array_Number('person_id');
  begin
    for r in (select Column_Value as Person_Id
                from table(v_Person_Ids)
               where Column_Value not in
                     (select q.Person_Id
                        from Htt_Location_Persons q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and q.Location_Id = (select d.Location_Id
                                                from Htt_Devices d
                                               where d.Company_Id = v_Company_Id
                                                 and d.Device_Id = v_Device_Id))
                 and Rownum = 1)
    loop
      b.Raise_Error(t('sync_person: selected person is not attached to this device, person_id=$1',
                      r.Person_Id));
    end loop;
  
    Uit_Htt.Sync_Persons(i_Device_Id => v_Device_Id, i_Person_Ids => v_Person_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Tracks(p Hashmap) is
    v_Device_Id  number := p.r_Number('device_id');
    v_Begin_Date date;
    v_End_Date   date;
    v_Data       Hashmap;
  begin
    if z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id, i_Device_Id => v_Device_Id).Device_Type_Id not in
        (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
         Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Begin_Date := p.r_Date('begin_date');
    v_End_Date   := p.r_Date('end_date');
  
    if v_End_Date - v_Begin_Date > 31 then
      b.Raise_Error(t('sync_tracks: interval between begin date and end date cannot be longer than 31 days'));
    end if;
  
    v_Data := Fazo.Zip_Map('begin_date',
                           to_char(v_Begin_Date, Href_Pref.c_Date_Format_Day),
                           'end_date',
                           to_char(v_End_Date, Href_Pref.c_Date_Format_Day));
  
    Htt_Api.Acms_Command_Add(i_Company_Id   => Ui.Company_Id,
                             i_Device_Id    => v_Device_Id,
                             i_Command_Kind => Htt_Pref.c_Command_Kind_Sync_Tracks,
                             i_Data         => v_Data.Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Persons
       set Company_Id = null,
           Person_Id  = null,
           Pin        = null;
    update Htt_Device_Admins
       set Company_Id = null,
           Device_Id  = null,
           Person_Id  = null;
    update Hzk_Device_Persons
       set Company_Id = null,
           Device_Id  = null,
           Person_Id  = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Htt_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Track_Id       = null,
           Track_Date     = null,
           Track_Time     = null,
           Track_Datetime = null,
           Person_Id      = null,
           Track_Type     = null,
           Mark_Type      = null,
           Device_Id      = null,
           Location_Id    = null,
           Accuracy       = null,
           Note           = null,
           Is_Valid       = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr94;
/
