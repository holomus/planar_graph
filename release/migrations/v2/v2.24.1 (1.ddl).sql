prompt adding trans_check
----------------------------------------------------------------------------------------------------
alter table htt_tracks add trans_check varchar2(1);
alter table htt_timesheet_tracks add trans_check varchar2(1);

alter table htt_tracks add constraint htt_tracks_c9 check (trans_check in ('Y', 'N'));
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c5 check (trans_check in ('Y', 'N'));

alter table htt_devices add only_last_restricted varchar2(1);
alter table htt_devices add constraint htt_devices_c9 check (only_last_restricted in ('Y', 'N'));
alter table htt_devices add constraint htt_devices_c10 check (only_last_restricted is null or restricted_type in ('I', 'O'));

comment on column htt_timesheet_tracks.trans_check  is '(Y)es, (N)o. Same as htt_tracks.trans_check';
comment on column htt_tracks.trans_check    is '(Y)es, (N)o. Transformable to check. (Y)es when device setting autogen_output was turned at track cretion time';
comment on column htt_devices.only_last_restricted is 'When enabled only last track from restricted types will remain as input/output';
