create or replace package Ui_Vhr519 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Devices(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Devices_Response(i_Data Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Devices(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Device_Info_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Info(p Hashmap) return Runtime_Service;
end Ui_Vhr519;
/
create or replace package body Ui_Vhr519 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Devices(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hac_dss_ex_devices q
                      where q.server_id = :server_id',
                    Fazo.Zip_Map('server_id', p.r_Number('server_id')));
  
    q.Number_Field('server_id');
    q.Varchar2_Field('register_code',
                     'device_code',
                     'device_name',
                     'department_code',
                     'serial_number',
                     'device_ip',
                     'extra_info',
                     'status');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('status_name',
                   'status',
                   Array_Varchar2(0, 1),
                   Array_Varchar2(Hac_Util.t_Device_Status(Hac_Pref.c_Device_Status_Offline),
                                  Hac_Util.t_Device_Status(Hac_Pref.c_Device_Status_Online)));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id    number := p.r_Number('server_id');
    v_Device_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('device_code'));
  begin
    for i in 1 .. v_Device_Codes.Count
    loop
      z_Hac_Dss_Ex_Devices.Delete_One(i_Server_Id   => v_Server_Id,
                                      i_Device_Code => v_Device_Codes(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Devices_Response(i_Data Hashmap) return Hashmap is
  begin
    return Uit_Hac.Dss_Get_Devices_Response(i_Data => i_Data, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Devices(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Dss_Get_Devices(p                    => p,
                                   i_Responce_Procedure => 'Ui_Vhr519.Get_Devices_Response',
                                   i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Device_Info_Response(i_Data Hashmap) is
  begin
    z_Hac_Dss_Ex_Devices.Update_One(i_Server_Id     => g_Server_Id,
                                    i_Device_Code   => i_Data.r_Varchar2('deviceCode'),
                                    i_Register_Code => Option_Varchar2(i_Data.r_Varchar2('registerId')),
                                    i_Serial_Number => Option_Varchar2(i_Data.o_Varchar2('deviceSn')),
                                    i_Extra_Info    => Option_Varchar2(i_Data.Json));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Device_Info(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Hac_Core.Dahua_Runtime_Service(i_Server_Id          => g_Server_Id,
                                          i_Api_Uri            => Hac_Pref.c_Device_Uri,
                                          i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                          i_Responce_Procedure => 'Ui_Vhr519.Get_Device_Info_Response',
                                          i_Object_Id          => p.r_Varchar2('device_code'),
                                          i_Action_Out         => null);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hac_Dss_Ex_Devices
       set Server_Id       = null,
           Register_Code   = null,
           Device_Code     = null,
           Device_Name     = null,
           Department_Code = null,
           Device_Ip       = null,
           Serial_Number   = null,
           Extra_Info      = null,
           Status          = null,
           Created_On      = null,
           Modified_On     = null;
  end;
end Ui_Vhr519;
/
