prompt add take additional rest days column and ignore free time settings
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
---------------------------------------------------------------------------------------------------- 
alter table htt_schedules modify take_additional_rest_days varchar2(1) not null;
alter table htt_schedules modify count_free not null;
alter table htt_schedules modify gps_turnout_enabled not null;
alter table htt_schedules modify gps_use_location not null;

----------------------------------------------------------------------------------------------------
alter table htt_schedule_templates modify take_additional_rest_days varchar2(1) not null;

----------------------------------------------------------------------------------------------------
alter table htt_schedule_registries modify take_additional_rest_days varchar2(1) not null;
alter table htt_schedule_registries modify count_free not null;
alter table htt_schedule_registries modify gps_turnout_enabled not null;
alter table htt_schedule_registries modify gps_use_location not null;

----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify count_free not null;
alter table htt_timesheets modify gps_turnout_enabled not null;
alter table htt_timesheets modify gps_use_location not null;

----------------------------------------------------------------------------------------------------
prompt exec fazo.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_schedules');
exec fazo_z.run('htt_schedule_templates');
exec fazo_z.run('htt_schedule_registries');
exec fazo_z.run('htt_location_polygon_vertices');
exec fazo_z.run('hac_device_event_types');
exec fazo_z.run('hac_event_types');
exec fazo_z.run('hac_dss_tracks');
exec fazo_z.run('htt_timesheets');
exec fazo_z.run('htt_timesheet_tracks');
exec fazo_z.run('hrm_divisions');

