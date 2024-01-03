prompt v2.34.0 4.after start dml
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback
----------------------------------------------------------------------------------------------------
prompt add OLX provider Info
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Add_Oauth2_Provider
  (
    i_Provider_Id   number,
    i_Provider_Name varchar2,
    i_Auth_Url      varchar2,
    i_Token_Url     varchar2,
    i_Redirect_Uri  varchar2,
    i_Content_Type  varchar2,
    i_Scope         varchar2
  ) is
  begin
    z_Hes_Oauth2_Providers.Save_One(i_Provider_Id   => i_Provider_Id,
                                    i_Provider_Name => i_Provider_Name,
                                    i_Auth_Url      => i_Auth_Url,
                                    i_Token_Url     => i_Token_Url,
                                    i_Redirect_Uri  => i_Redirect_Uri,
                                    i_Content_Type  => i_Content_Type,
                                    i_Scope         => i_Scope);
  end;

begin
  Add_Oauth2_Provider(Hes_Pref.c_Provider_Olx_Id,
                      'olx.uz',
                      'https://www.olx.uz/oauth/authorize/',
                      'https://www.olx.uz/api/open/oauth/token',
                      '/receive/oauth2/olx',
                      'application/json',
                      'v2 read write');

  commit;
end;
/
