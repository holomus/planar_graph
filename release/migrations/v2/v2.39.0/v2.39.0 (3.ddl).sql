prompt adding ignore tracks and images settings
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hac_hik_devices modify ignore_tracks not null;

comment on column hac_hik_devices.ignore_tracks is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
alter table htt_devices modify ignore_images not null;

comment on column htt_devices.ignore_images is '(Y)es, (N)o';

---------------------------------------------------------------------------------------------------- 
prompt adding allow_rank to robots
----------------------------------------------------------------------------------------------------
alter table hpd_page_robots modify allow_rank not null;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_devices');
exec fazo_z.run('hac_hik_devices');
exec fazo_z.run('hpd_page_robots');
