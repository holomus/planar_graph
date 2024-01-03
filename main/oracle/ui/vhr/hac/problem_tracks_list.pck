create or replace package Ui_Vhr636 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks return Fazo_Query;
end Ui_Vhr636;
/
create or replace package body Ui_Vhr636 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Tracks return Fazo_Query is
    v_Query       varchar2(32767);
    v_Params      Hashmap;
    v_Matrix      Matrix_Varchar2;
    r_Hik_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Take(Ui.Company_Id);
    r_Dss_Company Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Take(Ui.Company_Id);
  
    q Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('hik_server_id',
                             r_Hik_Company.Server_Id,
                             'dss_server_id',
                             r_Dss_Company.Server_Id,
                             'company_id',
                             Ui.Company_Id,
                             'unknown_person_code',
                             '-1',
                             'hik_type_id',
                             Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision),
                             'dss_type_id',
                             Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Dahua));
  
    v_Params.Put('hik_track_input', Hac_Pref.c_Hik_Track_Type_Input);
    v_Params.Put('hik_track_output', Hac_Pref.c_Hik_Track_Type_Output);
    v_Params.Put('track_input', Htt_Pref.c_Track_Type_Input);
    v_Params.Put('track_output', Htt_Pref.c_Track_Type_Output);
    v_Params.Put('track_check', Htt_Pref.c_Track_Type_Check);
    v_Params.Put('timezone', Hac_Pref.c_Utc_Timezone_Code);
    v_Params.Put('event_type_column', z.Event_Type_Name);
    v_Params.Put('event_type_table', Zt.Hac_Event_Types.Name);
    v_Params.Put('lang_code', Ui_Context.Lang_Code);
  
    v_Query := 'select q.event_type_code,
                       :hik_type_id device_type_id,
                       hd.device_id,
                       nvl((select sp.person_id
                              from hac_server_persons sp
                             where sp.server_id = :hik_server_id
                               and sp.company_id = :company_id
                               and sp.person_code = q.person_code), 
                          -1) person_id,
                       q.pic_sha photo_sha,
                       q.event_time track_time,
                       case q.check_in_and_out_type 
                         when :hik_track_input then :track_input
                         when :hik_track_output then :track_output
                         else :track_check
                       end track_type
                  from hac_hik_ex_events q
                  join hac_hik_devices hd
                    on hd.server_id = :hik_server_id
                   and hd.door_code = q.door_code
                   and hd.device_id in (select cd.device_id
                                          from hac_company_devices cd
                                         where cd.company_id = :company_id)
                 where q.server_id = :hik_server_id
                   and (q.person_code = :unknown_person_code
                    or q.event_type_code in (select et.event_type_code
                                               from hac_event_types et
                                              where et.device_type_id = :hik_type_id 
                                                and et.access_granted = ''N''))
                 union all
                select tr.event_type_code,
                       :dss_type_id device_type_id,
                       ds.device_id,
                       (select sp.person_id
                          from hac_server_persons sp
                         where sp.server_id = :dss_server_id
                           and sp.company_id = :company_id
                           and sp.person_code = tr.person_code) person_id,
                       tr.photo_sha,
                       cast(from_tz(cast(to_date(''01.01.1970'', ''dd.mm.yyyy'') +
                            numtodsinterval(tr.track_time, ''second'') as timestamp),
                       :timezone) at local as date) track_time,
                       :track_check track_type
                  from hac_dss_tracks tr
                  join hac_dss_devices ds
                    on ds.device_code = tr.device_code
                 where ds.server_id = :dss_server_id
                   and (tr.person_code = :unknown_person_code or
                       tr.event_type_code in (select et.event_type_code
                                                from hac_event_types et
                                               where et.device_type_id = :dss_type_id
                                                 and et.access_granted = ''N''))';
  
    v_Query := 'select qr.*, 
                       nvl2(qr.photo_sha, ''Y'', ''N'') photo_exists 
                  from (' || v_Query ||
               ') qr
                 where qr.device_id in 
                       (select dv.device_id
                          from hac_company_devices dv
                         where dv.company_id = :company_id)';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('event_type_code', 'device_type_id', 'person_id');
    q.Varchar2_Field('device_id', 'track_type', 'photo_sha', 'photo_exists');
    q.Date_Field('track_time');
  
    q.Refer_Field(i_Name             => 'person_name',
                  i_For              => 'person_id',
                  i_Table_Name       => 'select np.name,
                                                np.person_id
                                           from mr_natural_persons np
                                          where np.company_id = :company_id',
                  i_Code_Field       => 'person_id',
                  i_Name_Field       => 'name',
                  i_Table_For_Select => 'select np.*
                                           from mr_natural_persons np
                                          where np.company_id = :company_id
                                            and exists (select 1
                                                          from hac_server_persons sp
                                                         where sp.company_id = np.company_id
                                                           and sp.person_id = np.person_id)');
  
    q.Refer_Field(i_Name       => 'event_type_name',
                  i_For        => 'event_type_code',
                  i_Table_Name => 'select q.event_type_code, nvl(p.val, q.event_type_name) event_type_name
                                     from hac_event_types q
                                     left join md_table_record_translates p
                                       on p.table_name = :event_type_table
                                      and p.pcode = q.event_type_name
                                      and p.column_name = :event_type_column
                                      and p.lang_code = :lang_code',
                  i_Code_Field => 'event_type_code',
                  i_Name_Field => 'event_type_name');
  
    q.Refer_Field(i_Name       => 'device_type_name',
                  i_For        => 'device_type_id',
                  i_Table_Name => 'hac_device_types',
                  i_Code_Field => 'device_type_id',
                  i_Name_Field => 'name');
  
    q.Refer_Field(i_Name             => 'device_name',
                  i_For              => 'device_id',
                  i_Table_Name       => 'hac_devices',
                  i_Code_Field       => 'device_id',
                  i_Name_Field       => 'device_name',
                  i_Table_For_Select => 'select dv.*
                                           from hac_devices dv
                                          where dv.device_id in (select cd.device_id
                                                                   from hac_company_devices cd
                                                                  where cd.company_id = :company_id)');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field(i_Name  => 'track_type_name',
                   i_For   => 'track_type',
                   i_Codes => v_Matrix(1),
                   i_Names => v_Matrix(2));
  
    q.Option_Field('photo_exists_name',
                   'photo_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Ex_Events
       set Server_Id             = null,
           Door_Code             = null,
           Person_Code           = null,
           Event_Time            = null,
           Event_Type            = null,
           Event_Code            = null,
           Check_In_And_Out_Type = null,
           Event_Type_Code       = null,
           Pic_Sha               = null;
  
    update Hac_Event_Types
       set Device_Type_Id  = null,
           Event_Type_Code = null,
           Event_Type_Name = null,
           Access_Granted  = null;
  
    update Hac_Hik_Devices
       set Server_Id = null,
           Device_Id = null,
           Door_Code = null;
  
    update Hac_Company_Devices
       set Company_Id = null,
           Device_Id  = null;
  
    update Hac_Server_Persons
       set Server_Id   = null,
           Company_Id  = null,
           Person_Id   = null,
           Person_Code = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    update Hac_Dss_Tracks
       set Person_Code     = null,
           Device_Code     = null,
           Track_Time      = null,
           Event_Type_Code = null,
           Photo_Sha       = null;
  
    update Hac_Dss_Devices
       set Server_Id   = null,
           Device_Id   = null,
           Device_Code = null;
  
    update Hac_Device_Types
       set Device_Type_Id = null,
           name           = null,
           Pcode          = null;
  
    update Hac_Devices
       set Device_Id   = null,
           Server_Id   = null,
           Device_Name = null;
  
    update Md_Table_Record_Translates
       set Table_Name  = null,
           Pcode       = null,
           Column_Name = null,
           Lang_Code   = null,
           Val         = null;
  end;

end Ui_Vhr636;
/
