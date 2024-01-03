create or replace package Ui_Vhr473 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr473;
/
create or replace package body Ui_Vhr473 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    Ui.Assert_Is_Company_Head;
  
    q := Fazo_Query('htt_acms_servers');
  
    q.Number_Field('server_id', 'order_no');
    q.Varchar2_Field('secret_code', 'name', 'url');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Ids Array_Number := Fazo.Sort(p.r_Array_Number('server_id'));
  begin
    Ui.Assert_Is_Company_Head;
  
    for i in 1 .. v_Server_Ids.Count
    loop
      Htt_Api.Acms_Server_Delete(i_Server_Id => v_Server_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Acms_Servers
       set Server_Id   = null,
           Secret_Code = null,
           name        = null,
           Url         = null,
           Order_No    = null;
  end;

end Ui_Vhr473;
/
