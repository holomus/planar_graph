create or replace package Ui_Vhr512 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Devices(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Device_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
end Ui_Vhr512;
/
create or replace package body Ui_Vhr512 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hac_hik_ex_devices', Fazo.Zip_Map('server_id', p.r_Number('server_id')), true);
  
    q.Varchar2_Field('device_code',
                     'device_name',
                     'device_ip',
                     'device_port',
                     'treaty_type',
                     'serial_number',
                     'status');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('status_name',
                   'status',
                   Array_Varchar2(0, 1, 2),
                   Array_Varchar2(Hac_Util.t_Device_Status(Hac_Pref.c_Device_Status_Offline),
                                  Hac_Util.t_Device_Status(Hac_Pref.c_Device_Status_Online),
                                  Hac_Util.t_Device_Status(Hac_Pref.c_Device_Status_Unknown)));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id    number := p.r_Number('server_id');
    v_Device_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('device_code'));
  begin
    for i in 1 .. v_Device_Codes.Count
    loop
      z_Hac_Hik_Ex_Devices.Delete_One(i_Server_Id   => v_Server_Id,
                                      i_Device_Code => v_Device_Codes(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Devices(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Devices(p                    => p,
                                   i_Response_Procedure => 'Ui_Vhr512.Device_List_Response_Handler',
                                   i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Device_List_Response_Handler(i_Val => i_Val, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Ex_Devices
       set Server_Id     = null,
           Device_Code   = null,
           Device_Name   = null,
           Device_Ip     = null,
           Device_Port   = null,
           Treaty_Type   = null,
           Serial_Number = null,
           Status        = null,
           Created_On    = null,
           Modified_On   = null;
  end;

end Ui_Vhr512;
/
