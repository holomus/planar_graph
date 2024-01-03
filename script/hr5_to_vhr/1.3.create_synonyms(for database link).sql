set define on;
set serveroutput on;
exec dbms_output.enable(null);
declare
  v_Vhr_User All_Users.Username%type := '&vhr_user';
  v_Link     varchar2(100) := '&hr5_user_database_link';
  v_Query    varchar2(4000);
  v_Command  varchar2(4000);
  v_Cursor   sys_refcursor;
begin
  v_Query := 'select ''create or replace synonym ' || v_Vhr_User || '.hr5_'' || t.table_name || ' ||
             ''' for '' || t.table_name || ''@' || v_Link || ''' as command ' || --
             'from user_tables@' || v_Link || ' t';

  open v_Cursor for v_Query;

  fetch v_Cursor
    into v_Command;

  while v_Cursor%found
  loop
    Dbms_Output.Put_Line(v_Command);
  
    execute immediate v_Command;
  
    fetch v_Cursor
      into v_Command;
  end loop;
end;
/

-- temporary solution for old md_pref.c_Filial_Head
create or replace package Hr5_Md_Pref is
  ----------------------------------------------------------------------------------------------------
  c_Filial_Head  constant number := 0;
end Hr5_Md_Pref;
/
