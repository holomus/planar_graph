prompt adding hrm_setting column
----------------------------------------------------------------------------------------------------
alter table hrm_settings modify position_fixing not null;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('hrm_settings')
---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('hrm_settings');
