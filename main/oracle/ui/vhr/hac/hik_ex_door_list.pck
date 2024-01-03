create or replace package Ui_Vhr513 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Doors(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Door_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
end Ui_Vhr513;
/
create or replace package body Ui_Vhr513 is
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
    q := Fazo_Query('hac_hik_ex_doors', Fazo.Zip_Map('server_id', p.r_Number('server_id')), true);
  
    q.Varchar2_Field('door_code',
                     'door_name',
                     'door_no',
                     'device_code',
                     'region_code',
                     'door_state');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('door_state_name',
                   'door_state',
                   Array_Varchar2(0, 1, 2, 3, 4),
                   Array_Varchar2(Hac_Util.t_Hik_Door_State(Hac_Pref.c_Hik_Door_State_Remain_Open),
                                  Hac_Util.t_Hik_Door_State(Hac_Pref.c_Hik_Door_State_Closed),
                                  Hac_Util.t_Hik_Door_State(Hac_Pref.c_Hik_Door_State_Open),
                                  Hac_Util.t_Hik_Door_State(Hac_Pref.c_Hik_Door_State_Remain_Closed),
                                  Hac_Util.t_Hik_Door_State(Hac_Pref.c_Hik_Door_State_Offline)));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id  number := p.r_Number('server_id');
    v_Door_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('door_code'));
  begin
    for i in 1 .. v_Door_Codes.Count
    loop
      z_Hac_Hik_Ex_Doors.Delete_One(i_Server_Id => v_Server_Id, i_Door_Code => v_Door_Codes(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Doors(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Doors(p                    => p,
                                 i_Response_Procedure => 'Ui_Vhr513.Door_List_Response_Handler',
                                 i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Door_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Door_List_Response_Handler(i_Val => i_Val, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Ex_Doors
       set Server_Id   = null,
           Door_Code   = null,
           Door_Name   = null,
           Door_No     = null,
           Device_Code = null,
           Region_Code = null,
           Door_State  = null,
           Created_On  = null,
           Modified_On = null;
  end;

end Ui_Vhr513;
/
