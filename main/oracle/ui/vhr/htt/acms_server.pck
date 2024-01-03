create or replace package Ui_Vhr471 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr471;
/
create or replace package body Ui_Vhr471 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Htt_Acms_Servers%rowtype;
  begin
    Ui.Assert_Is_Company_Head;
  
    r_Data := z_Htt_Acms_Servers.Load(i_Server_Id => p.r_Number('server_id'));
  
    return z_Htt_Acms_Servers.To_Map(r_Data, z.Server_Id, z.Name, z.Url, z.Order_No);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Htt_Acms_Servers%rowtype;
  begin
    Ui.Assert_Is_Company_Head;
  
    r_Data := z_Htt_Acms_Servers.To_Row(p, z.Name, z.Url, z.Order_No);
  
    r_Data.Server_Id := Htt_Next.Server_Id;
  
    Htt_Api.Acms_Server_Save(r_Data);
  
    return z_Htt_Acms_Servers.To_Map(r_Data, z.Server_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Htt_Acms_Servers%rowtype;
  begin
    Ui.Assert_Is_Company_Head;
  
    r_Data := z_Htt_Acms_Servers.Lock_Load(i_Server_Id => p.r_Number('server_id'));
  
    z_Htt_Acms_Servers.To_Row(r_Data, p, z.Name, z.Url, z.Order_No);
  
    Htt_Api.Acms_Server_Save(r_Data);
  
    return z_Htt_Acms_Servers.To_Map(r_Data, z.Server_Id, z.Name);
  end;

end Ui_Vhr471;
/
