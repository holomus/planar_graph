create or replace package Ui_Vhr615 is
  ----------------------------------------------------------------------------------------------------
  Function Auth_Hh return Hashmap;
end Ui_Vhr615;
/
create or replace package body Ui_Vhr615 is
  ----------------------------------------------------------------------------------------------------
  Function Auth_Hh return Hashmap is
  begin
    return Fazo.Zip_Map('auth_url', Uit_Hes.Prepare_Oauth2_Auth_Url(Hes_Pref.c_Provider_Hh_Id));
  end;

end Ui_Vhr615;
/
