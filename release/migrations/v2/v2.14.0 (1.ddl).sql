prompt migr from 23.12.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
alter table htt_change_days modify day_kind  null;
alter table htt_change_days modify plan_time null;
alter table htt_change_days modify full_time null;

alter table htt_change_days drop constraint htt_change_days_pk;
alter table htt_change_days drop constraint htt_change_days_u1;
alter table htt_change_days drop constraint htt_change_days_f3;
alter table htt_change_days drop constraint htt_change_days_c3;

alter table htt_change_days add constraint htt_change_days_pk primary key (company_id, filial_id, staff_id, change_date, change_id) using index tablespace GWS_INDEX;
alter table htt_change_days add constraint htt_change_days_c3 check (day_kind in ('W', 'R') or (day_kind in ('H', 'N') or day_kind is null) and swapped_date is not null);
alter table htt_change_days add constraint htt_change_days_c11 check (nvl2(day_kind, 1, 0) + nvl2(plan_time, 1, 0) + nvl2(full_time, 1, 0) in (0, 3));

create index htt_change_days_i2 on htt_change_days(company_id, filial_id, staff_id, change_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_change_days');

----------------------------------------------------------------------------------------------------
prompt new index for htt_time_kinds
----------------------------------------------------------------------------------------------------
drop index htt_time_kinds_i2;
drop index htt_time_kinds_i3;

create index htt_time_kinds_i2 on htt_time_kinds(company_id, pcode) tablespace GWS_INDEX;
create index htt_time_kinds_i3 on htt_time_kinds(company_id, created_by) tablespace GWS_INDEX;
create index htt_time_kinds_i4 on htt_time_kinds(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt change in htt_hikvision_tracks
----------------------------------------------------------------------------------------------------
alter table htt_hikvision_tracks drop constraint htt_hikvision_tracks_f1;
alter table htt_hikvision_tracks add constraint htt_hikvision_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade;

exec fazo_z.run('htt_hikvision_tracks');
 
----------------------------------------------------------------------------------------------------
prompt add comment for some tables
----------------------------------------------------------------------------------------------------
comment on table htt_location_types is 'Keeps properties of type of locations. It is used to separate on types';
comment on column htt_location_types.color is 'We can set color in each type. This column save color code which we want. We can view this color in map of GPS Tracking';
comment on column htt_location_types.state is 'It must be (A)ctive or (P)assive. If it will (P)assive this type can''t view in create location';

comment on table htt_locations                is 'Keeps properties of the location. Locations are used to mark location of the object';
comment on column htt_locations.timezone_code is 'Code of timezone. It is esed for set timezone for locations';
comment on column htt_locations.region_id     is 'Resgion''s ID. Which region the location belongs to';
comment on column htt_locations.latlng        is 'GPS Coordinates. Latitude and Longitude. Both latitude and longitude are measured in degrees, which are in turn divided into minutes and seconds';
comment on column htt_locations.accuracy      is 'Accuracy is measured in meter. All tracks must be within this accuracy';
comment on column htt_locations.state         is 'It must be (A)ctive or (P)assive. If it will (P)assive this location can''t use';

comment on table htt_location_filials   is 'Keeps the locations of filial';
comment on table htt_location_divisions is 'Keeps divisions of location';

comment on table htt_location_persons is 'Keeps persons of locations';
comment on column htt_location_persons.attach_type is 'It must be (M)anual, (A)uto. Person in which type is attached to the location, in this type can detach';

comment on column htt_location_qr_codes.state is 'It must be (A)ctive or (P)assive. If it will (P)assive this qr code can''t use';

comment on column htt_schedule_templates.schedule_kind     is 'It must be (W)eekly or (P)eriod. If it is Weekly days repeated as weekly, if it is Period days repeated as given days count';
comment on column htt_schedule_templates.shift             is 'Shift, Measured in minutes';
comment on column htt_schedule_templates.input_acceptance  is 'Controls input acceptance border. Measured in minutes';
comment on column htt_schedule_templates.output_acceptance is 'Controls output acceptance border. Measured in minutes';
comment on column htt_schedule_templates.track_duration    is 'Limits the duration of input-output time parts (it shall not exceed track_duration). Measured in minutes';
comment on column htt_schedule_templates.count_late        is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedule_templates.count_early       is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedule_templates.count_lack        is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';
comment on column htt_schedule_templates.take_holidays     is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedule_templates.take_nonworking   is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';
comment on column htt_schedule_templates.state             is '(A)ctive, (P)assive, When (P)assive can''t use';

comment on column htt_registry_units.monthly_minutes is 'Total working minutes per month';
comment on column htt_registry_units.monthly_days    is 'Total working days per month';

comment on table htt_devices       is 'Keeps properties of devices.';
comment on table htt_device_admins is 'Keeps admin ids of device.';
comment on table htt_tracks        is 'Keeps properties of tracks.';

comment on column htt_tracks.track_date     is 'Date the track is add';
comment on column htt_tracks.track_time     is 'Time the track is add';
comment on column htt_tracks.track_datetime is 'Time with timezone the track is add';
comment on column htt_tracks.track_type     is 'It must be (I)nput, (O)utput or (C)heck';
comment on column htt_tracks.mark_type      is 'It must be (P)assword, (T)ouch, (R)fid card, (Q)R code, (F)ace, (M)anual or (A)uto';
comment on column htt_tracks.device_id      is 'Device Id the track add from which device';
comment on column htt_tracks.location_id    is 'Location Id the track add from which location';
comment on column htt_tracks.latlng         is 'GPS Coordinates. Latitude and Longitude. Both latitude and longitude are measured in degrees.';
comment on column htt_tracks.accuracy       is 'Accuracy is measured in meter. All tracks should be within this accuracy';
comment on column htt_tracks.photo_sha      is 'Photo Sha. If mark type is (F)ace, photo sha should be for identify';
comment on column htt_tracks.original_type  is '(I)nput, (O)utput, (C)heck. Keeps original track types when its changed';
comment on column htt_tracks.is_valid       is 'It must be (Y)es or (N)o. If (N)o, this track not used for generate statistcs';
comment on column htt_tracks.status         is '(D)raft, (N)ot used, (P)artially used, (U)sed';

comment on table htt_trash_tracks    is 'Keeps person''s non-working interval tracks. All columns the same with htt_tracks table';
comment on table htt_gps_track_datas is 'Keeps datas of gps tracks.';
comment on table htt_time_kinds      is 'Keeps properties of time kinds. It used for create request kinds';

comment on column htt_time_kinds.letter_code    is 'Letter code use in generate timesheet reports for to express time kinds'; 
comment on column htt_time_kinds.plan_load      is 'It must be (F)ull, (P)art or (E)xtra';
comment on column htt_time_kinds.requestable    is 'It must be (Y)es, (N)o. It is must be (Y)es, if its added not by the system';
comment on column htt_time_kinds.timesheet_coef is 'The ratio of counting attendance';
comment on column htt_time_kinds.state          is 'It must be (A)ctive, (P)assive. If (P)assive, this kind can''t view in request kind';

comment on table htt_request_kinds is 'Keeps request kind. Reequest kind use for create requests';
comment on table htt_requests      is 'Keeps Staff Requests. Requests are used to register abseces and correctly generate reports.';
comment on table htt_timesheets    is 'Keeps Properties of Staff Timesheets. Timesheet used for keep all informations about daily schedule of staff.';

comment on column htt_timesheets.count_late     is 'It must be (Y)es or (N)o. If No will not count late time';
comment on column htt_timesheets.count_early    is 'It must be (Y)es or (N)o. If No will not count early output time';
comment on column htt_timesheets.count_lack     is 'It must be (Y)es or (N)o. If No will not count lack time';

comment on table htt_timesheet_facts    is 'Keeps fact values depends on in every time kind';
comment on table htt_timesheet_helpers  is 'Keeps Extra inforations about timesheet day';
comment on table htt_timesheet_tracks   is 'Keeps tracks depends on timesheet day';
comment on table htt_timesheet_requests is 'Keeps requests depends on timesheet day';
