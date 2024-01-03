prompt v2.34.0 3.ddl
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback
----------------------------------------------------------------------------------------------------
prompt changing timesheet begin/end time
----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify allowed_late_time not null;
alter table htt_timesheets modify allowed_early_time not null;
alter table htt_timesheets modify begin_late_time not null;
alter table htt_timesheets modify end_early_time not null;

alter table htt_schedules modify allowed_late_time not null;
alter table htt_schedules modify allowed_early_time not null;
alter table htt_schedules modify begin_late_time not null;
alter table htt_schedules modify end_early_time not null;

alter table htt_schedule_registries modify allowed_late_time not null;
alter table htt_schedule_registries modify allowed_early_time not null;
alter table htt_schedule_registries modify begin_late_time not null;
alter table htt_schedule_registries modify end_early_time not null;

----------------------------------------------------------------------------------------------------
prompt fazo_z.run
---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('htt_devices');
exec fazo_z.run('hac_devices');
exec fazo_z.run('hac_hik_devices');
exec fazo_z.run('hrec_olx_');
exec fazo_z.run('htt_schedules');
exec fazo_z.run('htt_timesheets'); 
exec fazo_z.run('htt_schedule_registries');
exec fazo_z.run('hface_');
exec fazo_z.run('htt_location_persons');
