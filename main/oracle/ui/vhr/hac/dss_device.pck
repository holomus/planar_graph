create or replace package Ui_Vhr507 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr507;
/
create or replace package body Ui_Vhr507 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Device_Id number := p.o_Number('device_id');
    v_Query     varchar2(4000);
    q           Fazo_Query;
  begin
    v_Query := 'select q.*
                  from md_companies q
                  join hac_dss_company_servers cs
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
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Device  Hac_Devices%rowtype;
    r_Company Md_Companies%rowtype;
    result    Hashmap;
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
  
    r_Company := z_Md_Companies.Load(Hac_Util.Load_Primary_Company(i_Device_Id => r_Device.Device_Id));
  
    Result.Put('status_name', Hac_Util.t_Device_Status(r_Device.Status));
    Result.Put('company_id', r_Company.Company_Id);
    Result.Put('company_name', r_Company.Name);
    Result.Put('company_code', r_Company.Code);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p           Hashmap,
    i_Device_Id number
  ) return Hashmap is
    v_Device Hac_Pref.Dss_Device_Rt;
    r_Device Hac_Devices%rowtype;
  begin
    r_Device := z_Hac_Devices.Take(i_Server_Id => p.r_Number('server_id'),
                                   i_Device_Id => i_Device_Id);
  
    r_Device.Server_Id      := Nvl(r_Device.Server_Id, p.r_Number('server_id'));
    r_Device.Device_Id      := Nvl(r_Device.Device_Id, i_Device_Id);
    r_Device.Device_Type_Id := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Dahua);
    r_Device.Location       := p.r_Varchar2('location');
    r_Device.Ready          := Nvl(r_Device.Ready, 'N');
    r_Device.Status         := Nvl(r_Device.Status, Hac_Pref.c_Device_Status_Unknown);
    r_Device.Device_Ip      := p.r_Varchar2('device_ip');
    r_Device.Device_Mac     := p.r_Varchar2('device_mac');
    r_Device.Login          := p.r_Varchar2('login');
    r_Device.Password       := p.r_Varchar2('password');
  
    v_Device.Company_Id := p.r_Number('company_id');
    v_Device.Acms       := r_Device;
  
    Hac_Api.Dss_Device_Save(v_Device);
  
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
  
    update Hac_Dss_Company_Servers
       set Company_Id = null;
  
    update Hac_Company_Devices
       set Company_Id  = null,
           Device_Id   = null,
           Attach_Kind = null;
  end;

end Ui_Vhr507;
/
