prompt migr from 01.12.2022 (2.last_ddl)
----------------------------------------------------------------------------------------------------
alter table hpr_oper_types drop column pcode;

exec fazo_z.run('hpr_oper_types');
