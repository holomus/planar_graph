alter table htt_trash_tracks drop constraint htt_trash_tracks_u2;

alter table htt_trash_tracks add constraint htt_trash_tracks_u2 unique (company_id, filial_id, track_time, person_id, device_id, track_type) using index tablespace GWS_INDEX;

create index htt_trash_tracks_i6 on htt_trash_tracks(company_id, filial_id,  track_time, person_id, track_type) tablespace GWS_INDEX;

exec fazo_z.run('htt_trash_tracks');

exec fazo_z.Compile_Invalid_Objects;
