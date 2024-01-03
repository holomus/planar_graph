prompt vhr_user operations
----------------------------------------------------------------------------------------------------
set define on;
set serveroutput on;
undefine hr5_user
define hr5_user=&hr5_user

exec dbms_output.enable(null);

----------------------------------------------------------------------------------------------------
prompt create synonyms
----------------------------------------------------------------------------------------------------
exec &hr5_user..create_synonyms(user, '&hr5_user');

prompt create or replace synonym hr5_md_pref for &hr5_user.md_pref;
create or replace synonym hr5_md_pref for &hr5_user..md_pref;
