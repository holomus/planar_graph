prompt making bigger location name column
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table htt_locations modify name varchar2(300 char);

---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('htt_locations');
