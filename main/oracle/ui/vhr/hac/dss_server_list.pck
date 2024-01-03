create or replace package Ui_Vhr503 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Start_Notification return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Stop_Notification return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Get_Service_Tokens return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Service_Action_Response(i_Input Array_Varchar2) return Array_Varchar2;
end Ui_Vhr503;
/
create or replace package body Ui_Vhr503 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hac_dahua_servers_view');
  
    q.Number_Field('server_id', 'order_no');
    q.Varchar2_Field('name', 'host_url', 'username', 'password');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Ids Array_Number := Fazo.Sort(p.r_Array_Number('server_id'));
  begin
    for i in 1 .. v_Server_Ids.Count
    loop
      Hac_Api.Dss_Server_Delete(i_Server_Id => v_Server_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Servers
       set Server_Id = null,
           name      = null,
           Host_Url  = null,
           Order_No  = null;
  
    update Hac_Dss_Servers
       set Server_Id = null,
           Username  = null,
           Password  = null;
  
    update Hac_Dahua_Servers_View
       set Server_Id = null,
           name      = null,
           Host_Url  = null,
           Username  = null,
           Password  = null,
           Order_No  = null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Start_Notification return Runtime_Service is
    result Runtime_Service;
  begin
    result := Runtime_Service(Hac_Pref.c_Dahua_Api_Service_Name);
    Result.Set_Detail(Fazo.Zip_Map('dahua_service_action', 'start_notification'));
    Result.Set_Response_Procedure('UI_VHR503.Service_Action_Response');
    Result.Set_Data(Hashmap());
    Result.Action_Out := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    Result.Action_In  := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Stop_Notification return Runtime_Service is
    result Runtime_Service;
  begin
    result := Runtime_Service(Hac_Pref.c_Dahua_Api_Service_Name);
    Result.Set_Detail(Fazo.Zip_Map('dahua_service_action', 'stop_notification'));
    Result.Set_Response_Procedure('UI_VHR503.Service_Action_Response');
    Result.Set_Data(Hashmap());
    Result.Action_Out := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    Result.Action_In  := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Service_Tokens return Runtime_Service is
    result Runtime_Service;
  begin
    result := Runtime_Service(Hac_Pref.c_Dahua_Api_Service_Name);
    Result.Set_Detail(Fazo.Zip_Map('dahua_service_action', 'get_account_tokens'));
    Result.Set_Response_Procedure('UI_VHR503.Service_Action_Response');
    Result.Set_Data(Hashmap());
    Result.Action_Out := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    Result.Action_In  := Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2;
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Service_Action_Response(i_Input Array_Varchar2) return Array_Varchar2 is
  begin
    return i_Input;
  end;

end Ui_Vhr503;
/
