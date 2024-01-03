prompt adding schedule flex to individual schedules
----------------------------------------------------------------------------------------------------
alter table htt_schedule_registries modify schedule_kind not null;

prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_schedule_registries');
exec fazo_z.run('htt_unit_schedule_days');
exec fazo_z.run('htt_staff_schedule_days');
exec fazo_z.run('htt_robot_schedule_days');
