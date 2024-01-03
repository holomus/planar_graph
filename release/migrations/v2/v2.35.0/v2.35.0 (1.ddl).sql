prompt add take additional rest days column
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table htt_schedule_templates add take_additional_rest_days varchar2(1);

alter table htt_schedule_templates rename constraint htt_schedule_templates_c15 to htt_schedule_templates_c16;
alter table htt_schedule_templates rename constraint htt_schedule_templates_c14 to htt_schedule_templates_c15;
alter table htt_schedule_templates add constraint htt_schedule_templates_c14 check (take_additional_rest_days in ('Y', 'N'));

comment on column htt_schedule_templates.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';

----------------------------------------------------------------------------------------------------
alter table htt_calendar_days drop constraint htt_calendar_days_c3;
alter table htt_calendar_days add constraint htt_calendar_days_c3 check (day_kind in ('A', 'H', 'N', 'S'));

comment on column htt_calendar_days.day_kind is '(A)dditional Rest Day, (H)oliday, (N)onworking, Rest (S)wapped day';

----------------------------------------------------------------------------------------------------
alter table htt_schedule_days drop constraint htt_schedule_days_c2;
alter table htt_schedule_days add constraint htt_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N'));

comment on column htt_schedule_days.day_kind is '(W)orking day, (R)est day, (A)dditional Rest day, (H)oliday, (N)onworking';

----------------------------------------------------------------------------------------------------
alter table htt_change_days drop constraint htt_change_days_c3;
alter table htt_change_days add constraint htt_change_days_c3 check (day_kind in ('W', 'R') or (day_kind in ('H', 'A', 'N') or day_kind is null) and swapped_date is not null);

comment on column htt_change_days.day_kind is '(W)ork, (R)est, (A)dditional Rest, (H)oliday, (N)onworking';

----------------------------------------------------------------------------------------------------
prompt adding location polygon 
----------------------------------------------------------------------------------------------------
create table htt_location_polygon_vertices(
  company_id                      number(20)   not null,
  location_id                     number(20)   not null,
  order_no                        number(6)    not null,
  latlng                          varchar2(50) not null,
  constraint htt_location_polygon_vertices_pk primary key (company_id, location_id, order_no) using index tablespace GWS_INDEX,
  constraint htt_location_polygon_vertices_f1 foreign key (company_id, location_id) references htt_locations(company_id, location_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_location_polygon_vertices is 'Keeps each vertices of location polygon in appropriate sequential order';

---------------------------------------------------------------------------------------------------- 
prompt adding pic sha to events table
----------------------------------------------------------------------------------------------------
alter table hac_hik_ex_events add pic_sha varchar2(64);

----------------------------------------------------------------------------------------------------
prompt adding event types
----------------------------------------------------------------------------------------------------
create table hac_event_types(
  device_type_id              number(20)    not null,
  event_type_code             number(20)    not null,
  event_type_name             varchar2(250) not null,
  access_granted              varchar2(1)   not null,
  currently_shown             varchar2(1)   not null,
  constraint hac_event_types_pk primary key (device_type_id, event_type_code) using index tablespace GWS_INDEX,
  constraint hac_event_types_f1 foreign key (device_type_id) references hac_device_types(device_type_id) on delete cascade,
  constraint hac_event_types_c1 check (access_granted in ('Y', 'N')),
  constraint hac_event_types_c2 check (currently_shown in ('Y', 'N'))
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hac_device_event_types(
  server_id                   number(20) not null,
  device_id                   number(20) not null,
  device_type_id              number(20) not null,
  event_type_code             number(20) not null,
  constraint hac_device_event_types_pk primary key (server_id, device_id, device_type_id, event_type_code) using index tablespace GWS_DATA,
  constraint hac_device_event_types_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade,
  constraint hac_device_event_types_f2 foreign key (device_type_id, event_type_code) references hac_event_types(device_type_id, event_type_code) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
alter table hac_dss_tracks add event_type_code number(20);

----------------------------------------------------------------------------------------------------
alter table htt_devices drop column has_rfid;
alter table htt_devices drop column has_photo_recognition;

alter table htt_devices drop constraint htt_devices_c13;
alter table htt_devices add constraint htt_devices_c11 check (status in ('O', 'F', 'U'));
alter table htt_devices rename constraint htt_devices_c14 to htt_devices_c12;

---------------------------------------------------------------------------------------------------- 
prompt adding ignore free time settings
----------------------------------------------------------------------------------------------------
alter table htt_schedules add count_free                varchar2(1);
alter table htt_schedules add take_additional_rest_days varchar2(1);
alter table htt_schedules add gps_turnout_enabled       varchar2(1);
alter table htt_schedules add gps_use_location          varchar2(1);
alter table htt_schedules add gps_max_interval          number;

alter table htt_schedules rename constraint htt_schedules_c18 to htt_schedules_c20;
alter table htt_schedules rename constraint htt_schedules_c17 to htt_schedules_c19;
alter table htt_schedules rename constraint htt_schedules_c16 to htt_schedules_c18;
alter table htt_schedules rename constraint htt_schedules_c15 to htt_schedules_c17;
alter table htt_schedules rename constraint htt_schedules_c14 to htt_schedules_c16;
alter table htt_schedules rename constraint htt_schedules_c13 to htt_schedules_c15;
alter table htt_schedules rename constraint htt_schedules_c12 to htt_schedules_c14;
alter table htt_schedules rename constraint htt_schedules_c11 to htt_schedules_c13;

alter table htt_schedules rename constraint htt_schedules_c10 to htt_schedules_c11;
alter table htt_schedules rename constraint htt_schedules_c9 to htt_schedules_c10;

alter table htt_schedules add constraint htt_schedules_c9 check (count_free in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c12 check (take_additional_rest_days in ('Y', 'N'));

alter table htt_schedules add constraint htt_schedules_c21 check (gps_turnout_enabled in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c22 check (gps_use_location in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c23 check (gps_max_interval > 0);
alter table htt_schedules add constraint htt_schedules_c24 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                                               or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null);
 
comment on column htt_schedules.count_free                is '(Y)es, (N)o. When (N)o attached timesheets will not count free time';
comment on column htt_schedules.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';
comment on column htt_schedules.gps_turnout_enabled       is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_schedules.gps_use_location          is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_schedules.gps_max_interval          is 'Max time interval between two gps tracks';

----------------------------------------------------------------------------------------------------
alter table htt_schedule_registries add count_free                varchar2(1);
alter table htt_schedule_registries add take_additional_rest_days varchar2(1);
alter table htt_schedule_registries add gps_turnout_enabled       varchar2(1);
alter table htt_schedule_registries add gps_use_location          varchar2(1);
alter table htt_schedule_registries add gps_max_interval          number;

alter table htt_schedule_registries rename constraint htt_schedule_registries_c20 to htt_schedule_registries_c22;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c19 to htt_schedule_registries_c21;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c18 to htt_schedule_registries_c20;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c17 to htt_schedule_registries_c19;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c16 to htt_schedule_registries_c18;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c15 to htt_schedule_registries_c17;

alter table htt_schedule_registries rename constraint htt_schedule_registries_c14 to htt_schedule_registries_c15;
alter table htt_schedule_registries rename constraint htt_schedule_registries_c13 to htt_schedule_registries_c14;

alter table htt_schedule_registries add constraint htt_schedule_registries_c13 check (count_free in ('Y', 'N'));
alter table htt_schedule_registries add constraint htt_schedule_registries_c16 check (take_additional_rest_days in ('Y', 'N'));

alter table htt_schedule_registries add constraint htt_schedule_registries_c23 check (gps_turnout_enabled in ('Y', 'N'));
alter table htt_schedule_registries add constraint htt_schedule_registries_c24 check (gps_use_location in ('Y', 'N'));
alter table htt_schedule_registries add constraint htt_schedule_registries_c25 check (gps_max_interval > 0);
alter table htt_schedule_registries add constraint htt_schedule_registries_c26 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                                                                   or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null);

comment on column htt_schedule_registries.count_free                is '(Y)es, (N)o. When (N)o attached timesheets will not count free time';
comment on column htt_schedule_registries.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';
comment on column htt_schedule_registries.gps_turnout_enabled       is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_schedule_registries.gps_use_location          is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_schedule_registries.gps_max_interval          is 'Max time interval between two gps tracks';

----------------------------------------------------------------------------------------------------
alter table htt_timesheets add count_free          varchar2(1);
alter table htt_timesheets add gps_turnout_enabled varchar2(1);
alter table htt_timesheets add gps_use_location    varchar2(1);
alter table htt_timesheets add gps_max_interval    number;

alter table htt_timesheets rename constraint htt_timesheets_c27 to htt_timesheets_c28;
alter table htt_timesheets rename constraint htt_timesheets_c26 to htt_timesheets_c27;
alter table htt_timesheets rename constraint htt_timesheets_c25 to htt_timesheets_c26;
alter table htt_timesheets rename constraint htt_timesheets_c24 to htt_timesheets_c25;
alter table htt_timesheets rename constraint htt_timesheets_c23 to htt_timesheets_c24;
alter table htt_timesheets rename constraint htt_timesheets_c22 to htt_timesheets_c23;
alter table htt_timesheets rename constraint htt_timesheets_c21 to htt_timesheets_c22;
alter table htt_timesheets rename constraint htt_timesheets_c20 to htt_timesheets_c21;
alter table htt_timesheets rename constraint htt_timesheets_c19 to htt_timesheets_c20;

alter table htt_timesheets add constraint htt_timesheets_c19 check (count_free in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c29 check (gps_turnout_enabled in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c30 check (gps_use_location in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c31 check (gps_max_interval > 0);
alter table htt_timesheets add constraint htt_timesheets_c32 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                                                 or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null);

alter table htt_timesheets drop constraint htt_timesheets_c2;
alter table htt_timesheets add constraint htt_timesheets_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N'));

comment on column htt_timesheets.count_free          is 'It must be (Y)es or (N)o. If No will not count free time';
comment on column htt_timesheets.gps_turnout_enabled is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_timesheets.gps_use_location    is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_timesheets.gps_max_interval    is 'Max time interval between two gps tracks';
comment on column htt_timesheets.day_kind            is '(W)ork, (R)est, (A)dditional Rest, (H)oliday, (N)onworking';

----------------------------------------------------------------------------------------------------
prompt adding gps turnout
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheet_tracks drop constraint htt_timesheet_tracks_c2;
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c2 check (track_type in ('I', 'O', 'C', 'M', 'P', 'G'));

comment on column htt_timesheet_tracks.track_type   is '(I)nput, (O)utput, (C)heck, (M)erger, (P)otential output, (G)ps Output. (M)erger tracks appear only after fact calculation. (C)heck tracks can be transformed to other types';

----------------------------------------------------------------------------------------------------
prompt adding subfilial to divisions
---------------------------------------------------------------------------------------------------- 
alter table hrm_divisions add subfilial_id number(20);
alter table hrm_divisions add constraint hrm_divisions_f3 foreign key (company_id, subfilial_id) references mrf_subfilials(company_id, subfilial_id) on delete set null;
