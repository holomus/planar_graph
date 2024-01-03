create or replace package Ui_Vhr508 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr508;
/
create or replace package body Ui_Vhr508 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap := Fazo.Zip_Map('device_id',
                                     p.r_Number('device_id'),
                                     'server_id',
                                     p.r_Number('server_id'),
                                     'attach_kind',
                                     Hac_Pref.c_Device_Attach_Secondary);
    q        Fazo_Query;
  begin
    v_Query := 'select q.*
                  from md_companies q
                 where exists (select 1
                          from hac_dss_company_servers cs
                         where cs.company_id = q.company_id
                           and cs.server_id = :server_id)
                   and ';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || ' not';
    end if;
  
    v_Query := v_Query || ' exists (select 1
                               from hac_company_devices w
                              where ';
  
    if p.o_Varchar2('mode') <> 'detach' then
      v_Query := v_Query || ' w.attach_kind = :attach_kind and ';
    end if;
  
    v_Query := v_Query || ' w.device_id = :device_id
                        and w.company_id = q.company_id)';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
    v_Device_Id   number := p.r_Number('device_id');
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Device_Attach(i_Company_Id => v_Company_Ids(i), i_Device_Id => v_Device_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
    v_Device_Id   number := p.r_Number('device_id');
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Device_Detach(i_Company_Id => v_Company_Ids(i), i_Device_Id => v_Device_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id number;
    r_Device     Hac_Devices%rowtype;
    result       Hashmap;
  begin
    r_Device := z_Hac_Devices.Load(i_Server_Id => p.r_Number('server_id'),
                                   i_Device_Id => p.r_Number('device_id'));
  
    result := z_Hac_Devices.To_Map(r_Device,
                                   z.Device_Id,
                                   z.Server_Id,
                                   z.Location,
                                   z.Device_Name,
                                   z.Device_Ip,
                                   z.Device_Mac,
                                   z.Login,
                                   z.Password,
                                   z.Status);
  
    v_Company_Id := Hac_Util.Load_Primary_Company(i_Device_Id => r_Device.Device_Id);
  
    Result.Put('status_name', Hac_Util.t_Device_Status(r_Device.Status));
    Result.Put('company_id', v_Company_Id);
    Result.Put('company_name', z_Md_Companies.Load(v_Company_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null;
  
    update Hac_Dss_Company_Servers
       set Company_Id = null,
           Server_Id  = null;
  
    update Hac_Company_Devices
       set Company_Id = null,
           Device_Id  = null;
  end;

end Ui_Vhr508;
/
