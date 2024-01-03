create or replace package Ui_Vhr517 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Gen_Token return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr517;
/
create or replace package body Ui_Vhr517 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('token', Gen_Token);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Server     Hac_Servers%rowtype;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    result       Hashmap;
  begin
    r_Server     := z_Hac_Servers.Load(i_Server_Id => p.r_Number('server_id'));
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => p.r_Number('server_id'));
  
    result := z_Hac_Servers.To_Map(r_Server, z.Server_Id, z.Name, z.Host_Url, z.Order_No);
  
    Result.Put_All(z_Hac_Hik_Servers.To_Map(r_Hik_Server, z.Partner_Key, z.Partner_Secret, z.Token));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Token return varchar2 is
  begin
    return Hac_Util.Gen_Token;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p           Hashmap,
    i_Server_Id number
  ) return Hashmap is
    r_Server Hac_Servers%rowtype;
    v_Server Hac_Pref.Hik_Server_Rt;
  begin
    r_Server           := z_Hac_Servers.To_Row(p, z.Name, z.Host_Url, z.Order_No);
    r_Server.Server_Id := i_Server_Id;
  
    v_Server.Acms           := r_Server;
    v_Server.Partner_Key    := p.r_Varchar2('partner_key');
    v_Server.Partner_Secret := p.r_Varchar2('partner_secret');
    v_Server.Token          := p.r_Varchar2('token');
  
    Hac_Api.Hik_Server_Save(v_Server);
  
    return z_Hac_Servers.To_Map(r_Server, z.Server_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, i_Server_Id => Hac_Next.Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
  begin
    return save(p, i_Server_Id => p.r_Number('server_id'));
  end;

end Ui_Vhr517;
/
