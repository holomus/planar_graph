set define on;
set serveroutput on;
undefine dumpuser
undefine newuser
define dumpuser=&dumpuser
define newuser=&newuser

prompt create sequence procedure
create or replace procedure create_synonyms
(
  i_newuser  varchar2,
  i_dumpuser varchar2
) is
begin
  for r in (select 'create or replace synonym ' || i_newuser || '.old_' || t.table_name || ' for ' ||
                   i_dumpuser || '.' || t.table_name command
              from user_tables t)
  loop
    dbms_output.put_line(r.command);
    execute immediate r.command;
  end loop;
end;
/

prompt grant create_synonym to &newuser
grant execute on create_synonyms to &newuser;

prompt grant tables to &newuser
exec dbms_output.enable(null);
begin
  for r in (select lower('grant select on ' || t.table_name || ' to &newuser') command
              from user_tables t)
  loop
    dbms_output.put_line(r.command);
    execute immediate r.command;
  end loop;
end;
/
