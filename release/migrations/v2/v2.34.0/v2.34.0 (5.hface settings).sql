prompt v2.34.0 4.hface settings
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback
----------------------------------------------------------------------------------------------------
prompt adding hface settings, enter valid url, login, password
----------------------------------------------------------------------------------------------------
insert into Hface_Service_Settings
  (Code, Host, Username, Password)
values
  ('U', 'http://94.130.206.99:5157', 'admin', 'admin');
commit;
