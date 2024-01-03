prompt adding notification settings
----------------------------------------------------------------------------------------------------
alter table Hrm_Settings rename constraint hrm_settings_c8 to hrm_settings_c9;
alter table Hrm_Settings modify notification_enable varchar2(1) not null constraint hrm_settings_c8 check (notification_enable in ('Y', 'N')); 

exec fazo_z.run('htt_tracks');
exec fazo_z.Run('htt_locations');
exec fazo_z.Run('htt_trash_tracks');
exec fazo_z.Run('hrm_settings');
exec fazo_z.Run('href_person_details');
