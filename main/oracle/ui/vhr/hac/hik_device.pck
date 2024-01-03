create or replace package Ui_Vhr524 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Event_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Gen_Isup_Password return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr524;
/
create or replace package body Ui_Vhr524 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Device_Id number := p.o_Number('device_id');
    v_Query     varchar2(4000);
    q           Fazo_Query;
  begin
    v_Query := 'select q.*
                  from md_companies q
                  join hac_hik_company_servers cs
                    on cs.company_id = q.company_id
                   and cs.server_id = :server_id';
  
    if v_Device_Id is not null then
      v_Query := v_Query || ' where not exists (select 1
                               from hac_company_devices w
                              where w.device_id = :device_id
                                and w.company_id = q.company_id
                                and w.attach_kind = :attach_kind)';
    end if;
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('device_id',
                                 v_Device_Id,
                                 'server_id',
                                 p.r_Number('server_id'),
                                 'attach_kind',
                                 Hac_Pref.c_Device_Attach_Secondary));
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Event_Types return Fazo_Query is
    v_Query        varchar2(32767);
    v_Params       Hashmap;
    q              Fazo_Query;
    v_Static_Types Matrix_Varchar2 := Hac_Util.Combined_Event_Types;
    v_Hik_Type_Id  number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
  begin
    v_Query := 'select to_char(q.event_type_code) event_type_code, 
                       nvl(p.val, q.event_type_name) event_type_name
                  from hac_event_types q
                  left join md_table_record_translates p
                    on p.table_name = :event_type_table
                   and p.pcode = q.event_type_name
                   and p.column_name = :event_type_column
                   and p.lang_code = :lang_code
                 where q.device_type_id = :hik_type_id
                   and q.access_granted = :access_granted
                   and q.currently_shown = :currently_shown';
  
    v_Params := Fazo.Zip_Map('access_granted',
                             'Y',
                             'currently_shown',
                             'Y',
                             'hik_type_id',
                             v_Hik_Type_Id);
  
    v_Params.Put('event_type_column', z.Event_Type_Name);
    v_Params.Put('event_type_table', Zt.Hac_Event_Types.Name);
    v_Params.Put('lang_code', Ui_Context.Lang_Code);
  
    for i in 1 .. v_Static_Types.Count
    loop
      v_Query := v_Query || ' union all select ''' || v_Static_Types(i)
                 (1) || ''' , ''' || v_Static_Types(i) (2) || ''' from dual ';
    end loop;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Varchar2_Field('event_type_code', 'event_type_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Isup_Password return Hashmap is
  begin
    return Fazo.Zip_Map('isup_password', Hac_Util.Gen_Isup_Password);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('isup_password', Hac_Util.Gen_Isup_Password, 'ignore_tracks', 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Device           Hac_Devices%rowtype;
    r_Hik_Device       Hac_Hik_Devices%rowtype;
    r_Company          Md_Companies%rowtype;
    v_Event_Type_Codes Array_Varchar2;
    v_Event_Type_Names Array_Varchar2;
    v_Hik_Type_Id      number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
    result             Hashmap;
  begin
    r_Device := z_Hac_Devices.Load(i_Server_Id => p.r_Number('server_id'),
                                   i_Device_Id => p.r_Number('device_id'));
  
    result := z_Hac_Devices.To_Map(r_Device,
                                   z.Device_Id,
                                   z.Location,
                                   z.Device_Name,
                                   z.Device_Ip,
                                   z.Device_Mac,
                                   z.Login,
                                   z.Password,
                                   z.Status);
  
    r_Company    := z_Md_Companies.Load(Hac_Util.Load_Primary_Company(i_Device_Id => r_Device.Device_Id));
    r_Hik_Device := z_Hac_Hik_Devices.Load(i_Server_Id => p.r_Number('server_id'),
                                           i_Device_Id => p.r_Number('device_id'));
  
    Result.Put_All(z_Hac_Hik_Devices.To_Map(r_Hik_Device, z.Isup_Password, z.Ignore_Tracks));
  
    Result.Put('status_name', Hac_Util.t_Device_Status(r_Device.Status));
    Result.Put('company_id', r_Company.Company_Id);
    Result.Put('company_name', r_Company.Name);
    Result.Put('company_code', r_Company.Code);
  
    select q.Event_Type_Code, t.Event_Type_Name
      bulk collect
      into v_Event_Type_Codes, v_Event_Type_Names
      from Hac_Device_Event_Types q
      join Hac_Event_Types t
        on t.Device_Type_Id = v_Hik_Type_Id
       and t.Event_Type_Code = q.Event_Type_Code
     where q.Server_Id = r_Device.Server_Id
       and q.Device_Id = r_Device.Device_Id
     order by q.Event_Type_Code;
  
    Result.Put('event_type_code', Fazo.Gather(v_Event_Type_Codes, Hac_Pref.c_Event_Type_Delimiter));
    Result.Put('event_type_name',
               Hac_Util.t_Combined_Event_Type(i_Event_Types_Codes => v_Event_Type_Codes,
                                              i_Event_Type_Names  => v_Event_Type_Names));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p           Hashmap,
    i_Device_Id number
  ) return Hashmap is
    v_Device Hac_Pref.Hik_Device_Rt;
    r_Device Hac_Devices%rowtype;
  begin
    r_Device := z_Hac_Devices.Take(i_Server_Id => p.r_Number('server_id'),
                                   i_Device_Id => i_Device_Id);
  
    r_Device.Server_Id      := Nvl(r_Device.Server_Id, p.r_Number('server_id'));
    r_Device.Device_Id      := Nvl(r_Device.Device_Id, i_Device_Id);
    r_Device.Location       := p.r_Varchar2('location');
    r_Device.Device_Type_Id := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
    r_Device.Ready          := Nvl(r_Device.Ready, 'N');
    r_Device.Status         := Nvl(r_Device.Status, Hac_Pref.c_Device_Status_Unknown);
    r_Device.Device_Mac     := p.r_Varchar2('device_mac');
    r_Device.Device_Ip      := p.r_Varchar2('device_ip');
    r_Device.Login          := p.r_Varchar2('login');
    r_Device.Password       := p.r_Varchar2('password');
  
    v_Device.Company_Id    := p.r_Number('company_id');
    v_Device.Acms          := r_Device;
    v_Device.Isup_Password := p.r_Varchar2('isup_password');
    v_Device.Ignore_Tracks := p.r_Varchar2('ignore_tracks');
  
    v_Device.Event_Types := Fazo.To_Array_Number(Fazo.Split(p.r_Varchar2('event_type_code'),
                                                            Hac_Pref.c_Event_Type_Delimiter));
  
    Hac_Api.Hik_Device_Save(v_Device);
  
    return z_Hac_Devices.To_Map(r_Device, z.Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, i_Device_Id => Hac_Next.Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
  begin
    return save(p, i_Device_Id => p.r_Number('device_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null;
    update Hac_Hik_Company_Servers
       set Company_Id = null,
           Server_Id  = null;
    update Hac_Company_Devices
       set Company_Id  = null,
           Device_Id   = null,
           Attach_Kind = null;
    update Hac_Event_Types
       set Event_Type_Code = null,
           Event_Type_Name = null,
           Access_Granted  = null,
           Currently_Shown = null;
  end;

end Ui_Vhr524;
/
