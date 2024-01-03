create or replace package Ui_Vhr504 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr504;
/
create or replace package body Ui_Vhr504 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Server     Hac_Servers%rowtype;
    r_Dss_Server Hac_Dss_Servers%rowtype;
    result       Hashmap;
  begin
    r_Server     := z_Hac_Servers.Load(i_Server_Id => p.r_Number('server_id'));
    r_Dss_Server := z_Hac_Dss_Servers.Load(i_Server_Id => p.r_Number('server_id'));
  
    result := z_Hac_Servers.To_Map(r_Server, z.Server_Id, z.Name, z.Host_Url, z.Order_No);
  
    Result.Put_All(z_Hac_Dss_Servers.To_Map(r_Dss_Server, z.Username, z.Password));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p           Hashmap,
    i_Server_Id number
  ) return Hashmap is
    r_Server Hac_Servers%rowtype;
    v_Server Hac_Pref.Dss_Server_Rt;
  begin
    r_Server := z_Hac_Servers.To_Row(p, z.Name, z.Host_Url, z.Order_No);
  
    r_Server.Server_Id := i_Server_Id;
  
    v_Server.Acms     := r_Server;
    v_Server.Username := p.r_Varchar2('username');
    v_Server.Password := p.r_Varchar2('password');
  
    Hac_Api.Dss_Server_Save(v_Server);
  
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

end Ui_Vhr504;
/
