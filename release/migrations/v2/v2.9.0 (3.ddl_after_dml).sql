prompt migr from 17.10.2022 (3.ddl_after_dml)
----------------------------------------------------------------------------------------------------
prompt changing wage sheets
----------------------------------------------------------------------------------------------------
alter table hpr_wage_sheets modify sheet_kind not null;
alter table hpr_wage_sheets modify posted     not null;

exec fazo_z.run('hpr_wage_sheets');
exec fazo_z.run('hpr_onetime_sheet_staffs');
