prompt changing hpd_vacations
----------------------------------------------------------------------------------------------------
alter table hpd_vacations add time_kind_id number(20);

prompt adding restricted type to devices
----------------------------------------------------------------------------------------------------
alter table htt_devices add restricted_type varchar2(1);
alter table htt_devices add constraint htt_devices_c7 check (restricted_type in ('I', 'O', 'C'));

comment on column htt_devices.restricted_type is 'When not null system will accept all tracks from this device as of chosen track type';
