prompt adding ignore tracks setting
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
---------------------------------------------------------------------------------------------------- 
alter table htt_devices add ignore_tracks varchar2(1);
alter table htt_devices add constraint htt_devices_c14 check (ignore_tracks in ('Y', 'N'));

comment on column htt_devices.ignore_tracks is '(Y)es, (N)o. When yes rejects all tracks from this device';
