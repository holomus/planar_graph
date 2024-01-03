PL/SQL Developer Test script 3.0
18
-- Created on 3/6/2023 by ADHAM.TOSHKANOV 
declare
  i      integer;
  v_Buff varchar2(2000);
begin
  -- GET SQL EXECUTION PLAN
  --select * from table(dbms_xplan.display_awr('sql_id'));
  -- GET FROM ADDRESS AND HASH VALUE FROM SQLAREA

  select (Address || ',' || Hash_Value) --, Inst_Id, Users_Executing, Sql_Text
    into v_Buff
    from Gv$sqlarea
   where Sql_Id = '3j02bfm48zurg';

  -- PURGE FROM SHARED POOL: ADDRESS,HASH_VALUE
  Dbms_Shared_Pool.Purge(v_Buff, 'c');
  --  Dbms_Shared_Pool.Purge('00000000AFE88478,617355215', 'c');
end;
0
0
