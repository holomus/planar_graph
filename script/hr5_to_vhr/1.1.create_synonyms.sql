prompt create synonym procedure
----------------------------------------------------------------------------------------------------
create or replace procedure create_synonyms
(
  i_vhr_user  varchar2,
  i_hr5_user varchar2
) is
begin
  for r in (select 'create or replace synonym ' || i_vhr_user || '.hr5_' || t.table_name || ' for ' ||
                   i_hr5_user || '.' || t.table_name command
              from user_tables t)
  loop
    dbms_output.put_line(r.command);
    execute immediate r.command;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
set define on;
set serveroutput on;
undefine hr5_user
undefine vhr_user
define hr5_user=&hr5_user
define vhr_user=&vhr_user

prompt grant create_synonym to &vhr_user

prompt grant execute on create_synonyms to &vhr_user
grant execute on create_synonyms to &vhr_user;
prompt grant execute on md_pref to &vhr_user
grant execute on md_pref to &vhr_user;

prompt grant tables to &vhr_user
exec dbms_output.enable(null);
begin
  for r in (select lower('grant select on ' || t.table_name || ' to &vhr_user') command
              from user_tables t)
  loop
    dbms_output.put_line(r.command);
    execute immediate r.command;
  end loop;
end;
/
