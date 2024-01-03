create or replace package Ui_Vhr516 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr516;
/
create or replace package body Ui_Vhr516 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hac_hikcentral_servers_view');
  
    q.Number_Field('server_id', 'order_no');
    q.Varchar2_Field('name', 'host_url', 'partner_key', 'partner_secret');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Ids Array_Number := Fazo.Sort(p.r_Array_Number('server_id'));
  begin
    for i in 1 .. v_Server_Ids.Count
    loop
      Hac_Api.Hik_Server_Delete(i_Server_Id => v_Server_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hikcentral_Servers_View
       set Server_Id      = null,
           Order_No       = null,
           name           = null,
           Host_Url       = null,
           Partner_Key    = null,
           Partner_Secret = null;
  end;

end Ui_Vhr516;
/
