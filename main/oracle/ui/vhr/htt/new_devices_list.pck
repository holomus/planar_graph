create or replace package Ui_Vhr632 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
end Ui_Vhr632;
/
create or replace package body Ui_Vhr632 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    v_Hikvision_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dahua_Type_Id     number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
    q                   Fazo_Query;
  begin
    q := Fazo_Query('select dev.serial_number, 
                            dev.server_id, 
                            dev.device_id, 
                            dev.device_type_id
                       from (select q.serial_number,
                                    q.server_id,
                                    q.device_id,
                                    :hikvision_type_id as device_type_id
                               from hac_hik_devices q
                              where q.serial_number is not null
                                and exists (select 1
                                       from hac_company_devices cd
                                      where cd.company_id = :company_id
                                        and cd.device_id = q.device_id)
                             union
                             select w.serial_number,
                                    w.server_id,
                                    w.device_id,
                                    :dahua_type_id                                    
                               from hac_dss_devices w
                              where w.serial_number is not null
                                and exists (select 1
                                       from hac_company_devices cd
                                      where cd.company_id = :company_id
                                        and cd.device_id = w.device_id)) dev
                       where not exists (select 1 
                                    from htt_devices devs
                                   where devs.company_id = :company_id
                                     and devs.serial_number = dev.serial_number)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'hikvision_type_id',
                                 v_Hikvision_Type_Id,
                                 'dahua_type_id',
                                 v_Dahua_Type_Id));
  
    q.Varchar2_Field('serial_number');
    q.Number_Field('device_type_id', 'server_id', 'device_id');
  
    q.Refer_Field('device_type_name',
                  'device_type_id',
                  'htt_device_types',
                  'device_type_id',
                  'name',
                  'select * 
                     from htt_device_types');
  
    q.Map_Field('name',
                'select q.device_name 
                   from hac_devices q 
                  where q.device_id = $device_id 
                    and q.server_id = $server_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Htt_Devices
       set Company_Id    = null,
           Serial_Number = null;
    update Hac_Dss_Devices
       set Server_Id     = null,
           Device_Id     = null,
           Serial_Number = null;
    update Hac_Hik_Devices
       set Server_Id     = null,
           Device_Id     = null,
           Serial_Number = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
  end;

end Ui_Vhr632;
/
