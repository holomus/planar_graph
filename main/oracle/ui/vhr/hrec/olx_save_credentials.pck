create or replace package Ui_Vhr631 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Auth_Credentials(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Auth_Credentials;
end Ui_Vhr631;
/
create or replace package body Ui_Vhr631 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Credentials Hes_Oauth2_Credentials%rowtype;
    result        Hashmap := Hashmap();
  begin
    -- credetials
    r_Credentials := z_Hes_Oauth2_Credentials.Take(i_Company_Id  => Ui.Company_Id,
                                                   i_Provider_Id => Hes_Pref.c_Provider_Olx_Id);
  
    Result.Put('client_id', r_Credentials.Client_Id);
    Result.Put('client_secret', r_Credentials.Client_Secret);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Auth_Credentials(p Hashmap) is
    r_Credentials Hes_Oauth2_Credentials%rowtype;
  begin
    r_Credentials.Company_Id    := Ui.Company_Id;
    r_Credentials.Provider_Id   := Hes_Pref.c_Provider_Olx_Id;
    r_Credentials.Client_Id     := p.r_Varchar2('client_id');
    r_Credentials.Client_Secret := p.r_Varchar2('client_secret');
  
    Hes_Api.Save_Oauth2_Credentials(r_Credentials);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Auth_Credentials is
  begin
    Hes_Api.Delete_Oauth2_Credentials(i_Company_Id  => Ui.Company_Id,
                                      i_Provider_Id => Hes_Pref.c_Provider_Olx_Id);
  end;

end Ui_Vhr631;
/
