prompt Time tracking module
prompt (c) 2020 Verifix HR

----------------------------------------------------------------------------------------------------
create table htt_pin_locks(
  company_id                      number(20) not null,
  constraint htt_pin_locks_pk primary key (company_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htt_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  pin                             varchar2(15),
  pin_code                        number(8),
  rfid_code                       varchar2(20),
  qr_code                         varchar2(64),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_persons_pk primary key (company_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_persons_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_persons_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_persons_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_persons_c1 check (decode(trim(qr_code), qr_code, 1, 0) = 1),
  constraint htt_persons_c2 check (regexp_like(pin, '^\d+$'))
) tablespace GWS_DATA;

comment on table htt_persons is 'For Person Identification';

create unique index htt_persons_u1 on htt_persons(nvl2(pin, company_id, null), pin) tablespace GWS_INDEX;
create unique index htt_persons_u2 on htt_persons(nvl2(pin_code, company_id, null), pin_code) tablespace GWS_INDEX;
create unique index htt_persons_u3 on htt_persons(nvl2(rfid_code, company_id, null), rfid_code) tablespace GWS_INDEX;
create unique index htt_persons_u4 on htt_persons(nvl2(qr_code, company_id, null), qr_code) tablespace GWS_INDEX;

create index htt_persons_i1 on htt_persons(company_id, pin) tablespace GWS_INDEX;
create index htt_persons_i2 on htt_persons(company_id, pin_code) tablespace GWS_INDEX;
create index htt_persons_i3 on htt_persons(company_id, rfid_code) tablespace GWS_INDEX;
create index htt_persons_i4 on htt_persons(company_id, qr_code) tablespace GWS_INDEX;
create index htt_persons_i5 on htt_persons(company_id, created_by) tablespace GWS_INDEX;
create index htt_persons_i6 on htt_persons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_person_photos(
  company_id                      number(20)   not null,
  person_id                       number(20)   not null,
  photo_sha                       varchar2(64) not null,
  is_main                         varchar2(1)  not null,
  constraint htt_person_photos_pk primary key (company_id, person_id, photo_sha) using index tablespace GWS_INDEX,
  constraint htt_person_photos_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_person_photos_f2 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_person_photos_c1 check (is_main in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_person_photos is 'For Person Face Recognition';

create index htt_person_photos_i1 on htt_person_photos(photo_sha) tablespace GWS_INDEX;

-----------------------------------------------------------------------------------------------------
create global temporary table htt_dirty_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint htt_dirty_persons_u1 unique (company_id, person_id),
  constraint htt_dirty_persons_c1 check (person_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create table htt_location_types(
  company_id                      number(20)         not null,
  location_type_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  color                           varchar2(100),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_location_types_pk primary key (company_id, location_type_id) using index tablespace GWS_INDEX,
  constraint htt_location_types_u1 unique (location_type_id) using index tablespace GWS_INDEX,
  constraint htt_location_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_location_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_location_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_location_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table htt_location_types is 'Keeps properties of type of locations. It is used to separate on types';

comment on column htt_location_types.color is 'We can set color in each type. This column save color code which we want. We can view this color in map of GPS Tracking';
comment on column htt_location_types.state is 'It must be (A)ctive or (P)assive. If it will (P)assive this type can''t view in create location';

create unique index htt_location_types_u2 on htt_location_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index htt_location_types_i1 on htt_location_types(company_id, created_by) tablespace GWS_INDEX;
create index htt_location_types_i2 on htt_location_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_locations(
  company_id                      number(20)         not null,
  location_id                     number(20)         not null,
  name                            varchar2(300 char) not null,
  location_type_id                number(20),
  timezone_code                   varchar2(64),
  region_id                       number(20),
  address                         varchar2(200 char),
  latlng                          varchar2(50)       not null,
  accuracy                        number(20)         not null,
  bssids                          varchar2(2000 char),
  prohibited                      varchar2(1)        not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint htt_locations_pk primary key (company_id, location_id) using index tablespace GWS_INDEX,
  constraint htt_locations_u1 unique (location_id) using index tablespace GWS_INDEX,
  constraint htt_locations_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_locations_f1 foreign key (company_id, location_type_id) references htt_location_types(company_id, location_type_id),
  constraint htt_locations_f2 foreign key (timezone_code) references md_timezones(timezone_code),
  constraint htt_locations_f3 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint htt_locations_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_locations_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_locations_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_locations_c2 check (prohibited in ('Y', 'N')),
  constraint htt_locations_c3 check (state in ('A', 'P')),
  constraint htt_locations_c4 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_locations is 'Keeps properties of the location. Locations are used to mark location of the object';

comment on column htt_locations.timezone_code is 'Code of timezone. It is esed for set timezone for locations';
comment on column htt_locations.region_id     is 'Resgion''s ID. Which region the location belongs to';
comment on column htt_locations.latlng        is 'GPS Coordinates. Latitude and Longitude. Both latitude and longitude are measured in degrees, which are in turn divided into minutes and seconds';
comment on column htt_locations.accuracy      is 'Accuracy is measured in meter. All tracks must be within this accuracy';
comment on column htt_locations.bssids        is 'BSSID stands for Basic Service Set Identifier, and it’s  wireless router that is used to connect to the WiFi';
comment on column htt_locations.prohibited    is '(Y)es, (N)o';
comment on column htt_locations.state         is 'It must be (A)ctive or (P)assive. If it will (P)assive this location can''t use';

create unique index htt_locations_u3 on htt_locations(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index htt_locations_i1 on htt_locations(company_id, location_type_id) tablespace GWS_INDEX;
create index htt_locations_i2 on htt_locations(timezone_code) tablespace GWS_INDEX;
create index htt_locations_i3 on htt_locations(company_id, region_id) tablespace GWS_INDEX;
create index htt_locations_i4 on htt_locations(company_id, created_by) tablespace GWS_INDEX;
create index htt_locations_i5 on htt_locations(company_id, modified_by) tablespace GWS_INDEX;

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
create table htt_location_filials(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  location_id                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_filials_pk primary key (company_id, filial_id, location_id) using index tablespace GWS_INDEX,
  constraint htt_location_filials_f1 foreign key (company_id, location_id) references htt_locations(company_id, location_id) on delete cascade,
  constraint htt_location_filials_f2 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on table htt_location_filials is 'Keeps locations of filial';

create index htt_location_filials_i1 on htt_location_filials(company_id, created_by) tablespace GWS_INDEX;
create index htt_location_filials_i2 on htt_location_filials(company_id, location_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_location_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  location_id                     number(20) not null,
  division_id                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_divisions_pk primary key (company_id, filial_id, location_id, division_id) using index tablespace GWS_INDEX,
  constraint htt_location_divisions_f1 foreign key (company_id, filial_id, location_id) references htt_location_filials(company_id, filial_id, location_id) on delete cascade,
  constraint htt_location_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint htt_location_divisions_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on table htt_location_divisions is 'Keeps divisions of location';

create index htt_location_divisions_i1 on htt_location_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htt_location_divisions_i2 on htt_location_divisions(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_location_persons(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  location_id                     number(20)  not null,
  person_id                       number(20)  not null,
  attach_type                     varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_persons_pk primary key (company_id, filial_id, location_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_location_persons_f1 foreign key (company_id, filial_id, location_id) references htt_location_filials(company_id, filial_id, location_id) on delete cascade,
  constraint htt_location_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_location_persons_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_location_persons_c1 check (attach_type in ('M', 'A', 'G'))
) tablespace GWS_DATA;

comment on table htt_location_persons is 'Keeps persons of locations';
comment on column htt_location_persons.attach_type is 'It must be (M)anual, (A)uto, (G)lobal. Person in which type is attached to the location, in this type can detach';

create index htt_location_persons_i1 on htt_location_persons(company_id, person_id) tablespace GWS_INDEX;
create index htt_location_persons_i2 on htt_location_persons(company_id, created_by) tablespace GWS_INDEX;
create index htt_location_persons_i3 on htt_location_persons(company_id, location_id, person_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_location_qr_codes(
  company_id                      number(20)   not null,
  unique_key                      varchar2(64) not null,
  location_id                     number(20)   not null,
  state                           varchar2(1)  not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_qr_codes_pk primary key(company_id, unique_key) using index tablespace GWS_INDEX,
  constraint htt_location_qr_codes_u1 unique (unique_key) using index tablespace GWS_INDEX,
  constraint htt_location_qr_codes_f1 foreign key (company_id, location_id) references htt_locations(company_id, location_id) on delete cascade,
  constraint htt_location_qr_codes_c1 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table htt_location_qr_codes is 'Keeps items for generate qr code';

comment on column htt_location_qr_codes.state is 'It must be (A)ctive or (P)assive. If it will (P)assive this qr code can''t use';

create index htt_location_qr_codes_i1 on htt_location_qr_codes(company_id, location_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_calendars(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  calendar_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  monthly_limit                   varchar2(1)        not null,
  daily_limit                     varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint htt_calendars_pk primary key (company_id, filial_id, calendar_id) using index tablespace GWS_INDEX,
  constraint htt_calendars_u1 unique (calendar_id) using index tablespace GWS_INDEX,
  constraint htt_calendars_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_calendars_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_calendars_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_calendars_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_calendars_c2 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint htt_calendars_c3 check (monthly_limit in ('Y', 'N')),
  constraint htt_calendars_c4 check (daily_limit in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_calendars is 'Keeps business calendars (Производственный календарь)';

create unique index htt_calendars_u3 on htt_calendars(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_calendars_u4 on htt_calendars(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;
create unique index htt_calendars_u5 on htt_calendars(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;
create index htt_calendars_i1 on htt_calendars(company_id, created_by) tablespace GWS_INDEX;
create index htt_calendars_i2 on htt_calendars(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_calendar_rest_days(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  calendar_id                     number(20) not null,
  week_day_no                     number(1)  not null,
  constraint htt_calendar_rest_days_pk primary key (company_id, filial_id, calendar_id, week_day_no) using index tablespace GWS_INDEX,
  constraint htt_calendar_rest_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_rest_days_c1 check (week_day_no between 1 and 7)
) tablespace GWS_DATA;

comment on table htt_calendar_rest_days is 'Keeps official rest week days in calendar';

comment on column htt_calendar_rest_days.week_day_no is 'ISO week day number (1 - Monday, 7 - Sunday)';

---------------------------------------------------------------------------------------------------- 
create table htt_calendar_week_days(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  calendar_id                     number(20) not null,
  order_no                        number(1) not null,
  plan_time                       number(6) not null,
  preholiday_time                 number(6) not null,
  preweekend_time                 number(6) not null,
  constraint htt_calendar_week_days_pk primary key (company_id, filial_id, calendar_id, order_no),
  constraint htt_calendar_week_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_week_days_c1 check(order_no > 0 and order_no < 8)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htt_calendar_days(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  calendar_id                     number(20)         not null,
  calendar_date                   date               not null,
  name                            varchar2(100 char) not null,
  day_kind                        varchar2(1)        not null,
  swapped_date                    date,
  constraint htt_calendar_days_pk primary key (company_id, filial_id, calendar_id, calendar_date) using index tablespace GWS_INDEX,
  constraint htt_calendar_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_days_c1 check (trunc(calendar_date) = calendar_date),
  constraint htt_calendar_days_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_calendar_days_c3 check (day_kind in ('A', 'H', 'N', 'S')),
  constraint htt_calendar_days_c4 check (decode(day_kind, 'S', 1, 0) = nvl2(swapped_date, 1, 0)),
  constraint htt_calendar_days_c5 check (calendar_date <> swapped_date),
  constraint htt_calendar_days_c6 check (trunc(swapped_date) = swapped_date)
) tablespace GWS_DATA;

comment on table htt_calendar_days is 'Keeps only special days in calendar';

comment on column htt_calendar_days.day_kind     is '(A)dditional Rest Day, (H)oliday, (N)onworking, Rest (S)wapped day';
comment on column htt_calendar_days.swapped_date is 'Works only for day type Rest (S)wapped day, only when calendar day is rest and swapped is work day';

create unique index htt_calendar_days_u1 on htt_calendar_days(nvl2(swapped_date, company_id, null),
                                                              nvl2(swapped_date, filial_id, null),
                                                              nvl2(swapped_date, calendar_id, null),
                                                              swapped_date) tablespace GWS_INDEX;
create unique index htt_calendar_days_u2 on htt_calendar_days(company_id, filial_id, calendar_id, nvl(swapped_date, calendar_date));
create index htt_calendar_days_i1 on htt_calendar_days(company_id, filial_id, calendar_id, extract(year from calendar_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedules(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  schedule_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  schedule_kind                   varchar2(1)        not null,
  shift                           number(4),
  input_acceptance                number(4),
  output_acceptance               number(4),
  track_duration                  number(4)          not null,
  count_late                      varchar2(1)        not null,
  count_early                     varchar2(1)        not null,
  count_lack                      varchar2(1)        not null,
  use_weights                     varchar2(1)        not null,
  count_free                      varchar2(1)        not null,
  allowed_late_time               number(6)          not null,
  allowed_early_time              number(6)          not null,
  begin_late_time                 number(6)          not null,
  end_early_time                  number(6)          not null,
  calendar_id                     number(20),
  take_holidays                   varchar2(1)        not null,
  take_nonworking                 varchar2(1)        not null,
  take_additional_rest_days       varchar2(1)        not null,
  gps_turnout_enabled             varchar2(1)        not null,                     
  gps_use_location                varchar2(1)        not null,
  gps_max_interval                number(20),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  barcode                         varchar2(25),
  pcode                           varchar2(10),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint htt_schedules_pk primary key (company_id, filial_id, schedule_id) using index tablespace GWS_INDEX,
  constraint htt_schedules_u1 unique (schedule_id) using index tablespace GWS_INDEX,
  constraint htt_schedules_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_schedules_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id),
  constraint htt_schedules_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_schedules_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_schedules_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_schedules_c2 check (shift between 0 and 1439),
  constraint htt_schedules_c3 check (input_acceptance between 0 and 2160),
  constraint htt_schedules_c4 check (output_acceptance between 0 and 2160),
  constraint htt_schedules_c5 check (track_duration between 0 and 4320),
  constraint htt_schedules_c6 check (count_late in ('Y', 'N')),
  constraint htt_schedules_c7 check (count_early in ('Y', 'N')),
  constraint htt_schedules_c8 check (count_lack in ('Y', 'N')),
  constraint htt_schedules_c9 check (count_free in ('Y', 'N')),
  constraint htt_schedules_c10 check (take_holidays in ('Y', 'N')),
  constraint htt_schedules_c11 check (take_nonworking in ('Y', 'N')),
  constraint htt_schedules_c12 check (take_additional_rest_days in ('Y', 'N')),
  constraint htt_schedules_c13 check (state in ('A', 'P')),
  constraint htt_schedules_c14 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint htt_schedules_c15 check (schedule_kind in ('C', 'F', 'H')),
  constraint htt_schedules_c16 check (decode(schedule_kind, 'F', 0, 3) = nvl2(shift, 1, 0) + nvl2(input_acceptance, 1, 0) + nvl2(output_acceptance, 1, 0)),
  constraint htt_schedules_c17 check (decode(schedule_kind, 'H', 0, 3) >= decode(count_late, 'Y', 1, 0) + decode(count_early, 'Y', 1, 0) + decode(count_lack, 'Y', 1, 0)),
  constraint htt_schedules_c18 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_schedules_c19 check (begin_late_time <= 0 and end_early_time >= 0),
  constraint htt_schedules_c20 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_schedules_c21 check (gps_turnout_enabled in ('Y', 'N')),
  constraint htt_schedules_c22 check (gps_use_location in ('Y', 'N')),
  constraint htt_schedules_c23 check (gps_max_interval > 0),
  constraint htt_schedules_c24 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                   or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null),
  constraint htt_schedules_c25 check (use_weights in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_schedules is 'Keeps staff schedules. Some fields are unchangeable while any staff is attached to schedule';

comment on column htt_schedules.schedule_kind             is '(C)ustom, (F)lexible, (H)ourly. When (F)lexible cannot set shift, input/output acceptance. When (H)ourly will calculate only turnout from input to output';
comment on column htt_schedules.shift                     is 'Shifts schedule from default 00:00. Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.input_acceptance          is 'Controls input acceptance border. Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.output_acceptance         is 'Controls output acceptance border. Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.track_duration            is 'Limits the duration of input-output time parts (it shall not exceed track_duration). Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.count_late                is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedules.count_early               is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedules.count_lack                is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';
comment on column htt_schedules.count_free                is '(Y)es, (N)o. When (N)o attached timesheets will not count free time';
comment on column htt_schedules.take_holidays             is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedules.take_nonworking           is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';
comment on column htt_schedules.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';
comment on column htt_schedules.gps_turnout_enabled       is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_schedules.gps_use_location          is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_schedules.gps_max_interval          is 'Max time interval between two gps tracks';
comment on column htt_schedules.state                     is '(A)ctive, (P)assive';

create unique index htt_schedules_u3 on htt_schedules(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_schedules_u4 on htt_schedules(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;
create unique index htt_schedules_u5 on htt_schedules(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;
create index htt_schedules_i1 on htt_schedules(company_id, filial_id, calendar_id) tablespace GWS_INDEX;
create index htt_schedules_i2 on htt_schedules(company_id, created_by) tablespace GWS_INDEX;
create index htt_schedules_i3 on htt_schedules(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_origin_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  schedule_id                     number(20)  not null,
  schedule_date                   date        not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  constraint htt_schedule_origin_days_pk primary key (company_id, filial_id, schedule_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_schedule_origin_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint htt_schedule_origin_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_schedule_origin_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_schedule_origin_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_schedule_origin_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)),
  constraint htt_schedule_origin_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_schedule_origin_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_schedule_origin_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_schedule_origin_days_c8 check (begin_time < end_time),
  constraint htt_schedule_origin_days_c9 check (break_begin_time < break_end_time),
  constraint htt_schedule_origin_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_schedule_origin_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_schedule_origin_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_schedule_origin_days_c13 check (input_border < output_border),
  constraint htt_schedule_origin_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_schedule_origin_days is 'Keeps original data for schedule days (changes in calendar days don''t influence this table)';

comment on column htt_schedule_origin_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_schedule_origin_days.break_enabled is '(Y)es, (N)o';
comment on column htt_schedule_origin_days.full_time     is 'measured in minutes';
comment on column htt_schedule_origin_days.plan_time     is 'measured in minutes';

create index htt_schedule_origin_days_i1 on htt_schedule_origin_days(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_origin_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_origin_day_marks_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_origin_day_marks_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_origin_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_origin_day_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_origin_day_marks is 'Keeps marks schedule for each schedule day';

create index htt_schedule_origin_day_marks_i1 on htt_schedule_origin_day_marks(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_origin_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  constraint htt_schedule_origin_day_weights_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_origin_day_weights_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_origin_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_origin_day_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_schedule_origin_day_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_origin_day_weights is 'Weights to calculate weighted turnout';

----------------------------------------------------------------------------------------------------
create table htt_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  schedule_id                     number(20)  not null,
  schedule_date                   date        not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  constraint htt_schedule_days_pk primary key (company_id, filial_id, schedule_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_schedule_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint htt_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N')),
  constraint htt_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)
                                         or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_schedule_days_c8 check (begin_time < end_time),
  constraint htt_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_schedule_days_c13 check (input_border < output_border),
  constraint htt_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_schedule_days is 'Keeps daily schedule plans';

comment on column htt_schedule_days.day_kind      is '(W)orking day, (R)est day, (A)dditional Rest day, (H)oliday, (N)onworking';
comment on column htt_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_schedule_days.full_time     is 'measured in minutes';
comment on column htt_schedule_days.plan_time     is 'measured in minutes';

create index htt_schedule_days_i1 on htt_schedule_days(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_schedule_day_marks_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_day_marks_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_schedule_day_marks is 'Keeps marks schedule for each schedule day';

create index htt_schedule_day_marks_i1 on htt_schedule_day_marks(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_schedule_day_weights_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_day_weights_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_schedule_day_weights_c2 check (weight > 0),
  constraint htt_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_schedule_patterns(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  schedule_id                     number(20)  not null,
  schedule_kind                   varchar2(1) not null,
  all_days_equal                  varchar2(1) not null,
  count_days                      number(4),
  begin_date                      date,
  end_date                        date,
  constraint htt_schedule_patterns_pk primary key (company_id, filial_id, schedule_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_patterns_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint htt_schedule_patterns_c1 check (schedule_kind in ('W', 'P')),
  constraint htt_schedule_patterns_c2 check (all_days_equal in ('Y', 'N')),
  constraint htt_schedule_patterns_c3 check (count_days > 0),
  constraint htt_schedule_patterns_c4 check (trunc(begin_date) = begin_date),
  constraint htt_schedule_patterns_c5 check (trunc(end_date) = end_date),
  constraint htt_schedule_patterns_c6 check (begin_date <= end_date)
) tablespace GWS_DATA;

comment on column htt_schedule_patterns.schedule_kind  is '(W)eekly, (P)eriodic';
comment on column htt_schedule_patterns.all_days_equal is '(Y)es, (N)o';
comment on column htt_schedule_patterns.count_days     is 'cached field: count of schedule days';

----------------------------------------------------------------------------------------------------
create table htt_schedule_pattern_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  schedule_id                     number(20)  not null,
  day_no                          number(4)   not null,
  day_kind                        varchar2(1) not null,
  plan_time                       number(4)   not null,
  begin_time                      number(4),
  end_time                        number(4),
  break_enabled                   varchar2(1),
  break_begin_time                number(4),
  break_end_time                  number(4),
  constraint htt_schedule_pattern_days_pk primary key (company_id, filial_id, schedule_id, day_no) using index tablespace GWS_INDEX,
  constraint htt_schedule_pattern_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint htt_schedule_pattern_days_c1 check (day_no > 0),
  constraint htt_schedule_pattern_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_schedule_pattern_days_c3 check (plan_time between 0 and 1440),
  constraint htt_schedule_pattern_days_c4 check (break_enabled in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_schedule_pattern_days                is 'all time fields are measured in minutes';
comment on column htt_schedule_pattern_days.day_kind      is '(W)orking, (R)est';
comment on column htt_schedule_pattern_days.break_enabled is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table htt_schedule_pattern_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_pattern_marks_pk primary key (company_id, filial_id, schedule_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_pattern_marks_f1 foreign key (company_id, filial_id, schedule_id, day_no) references htt_schedule_pattern_days(company_id, filial_id, schedule_id, day_no) on delete cascade,
  constraint htt_schedule_pattern_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_pattern_marks is 'Keeps marks schedule for each pattern day';

comment on column htt_schedule_pattern_marks.begin_time is 'Shows minutes from 00:00';
comment on column htt_schedule_pattern_marks.end_time   is 'Shows minutes from 00:00';

----------------------------------------------------------------------------------------------------
create table htt_schedule_pattern_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  constraint htt_schedule_pattern_weights_pk primary key (company_id, filial_id, schedule_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_pattern_weights_f1 foreign key (company_id, filial_id, schedule_id, day_no) references htt_schedule_pattern_days(company_id, filial_id, schedule_id, day_no) on delete cascade,
  constraint htt_schedule_pattern_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_schedule_pattern_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_pattern_weights is 'Weights to calculate weighted turnout';

----------------------------------------------------------------------------------------------------
create table htt_schedule_templates(
  template_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  description                     varchar2(3000 char),
  schedule_kind                   varchar2(1)        not null,
  all_days_equal                  varchar2(1)        not null,
  count_days                      number(4),
  shift                           number(4)          not null,
  input_acceptance                number(4)          not null,
  output_acceptance               number(4)          not null,
  track_duration                  number(4)          not null,
  count_late                      varchar2(1)        not null,
  count_early                     varchar2(1)        not null,
  count_lack                      varchar2(1)        not null,
  take_holidays                   varchar2(1)        not null,
  take_nonworking                 varchar2(1)        not null,
  take_additional_rest_days       varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  constraint htt_schedule_templates_pk primary key (template_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_templates_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_schedule_templates_c2 check (schedule_kind in ('W', 'P')),
  constraint htt_schedule_templates_c3 check (all_days_equal in ('Y', 'N')),
  constraint htt_schedule_templates_c4 check (count_days > 0),
  constraint htt_schedule_templates_c5 check (shift between 0 and 1439),
  constraint htt_schedule_templates_c6 check (input_acceptance between 0 and 2160),
  constraint htt_schedule_templates_c7 check (output_acceptance between 0 and 2160),
  constraint htt_schedule_templates_c8 check (track_duration between 0 and 4320),
  constraint htt_schedule_templates_c9 check (count_late in ('Y', 'N')),
  constraint htt_schedule_templates_c10 check (count_early in ('Y', 'N')),
  constraint htt_schedule_templates_c11 check (count_lack in ('Y', 'N')),
  constraint htt_schedule_templates_c12 check (take_holidays in ('Y', 'N')),
  constraint htt_schedule_templates_c13 check (take_nonworking in ('Y', 'N')),  
  constraint htt_schedule_templates_c14 check (take_additional_rest_days in ('Y', 'N')),  
  constraint htt_schedule_templates_c15 check (state in ('A', 'P')),
  constraint htt_schedule_templates_c16 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_schedule_templates is 'Keeps templates for fast creating schedules';

comment on column htt_schedule_templates.schedule_kind             is 'It must be (W)eekly or (P)eriod. If it is Weekly days repeated as weekly, if it is Period days repeated as given days count';
comment on column htt_schedule_templates.shift                     is 'Shift, Measured in minutes';
comment on column htt_schedule_templates.input_acceptance          is 'Controls input acceptance border. Measured in minutes';
comment on column htt_schedule_templates.output_acceptance         is 'Controls output acceptance border. Measured in minutes';
comment on column htt_schedule_templates.track_duration            is 'Limits the duration of input-output time parts (it shall not exceed track_duration). Measured in minutes';
comment on column htt_schedule_templates.count_late                is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedule_templates.count_early               is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedule_templates.count_lack                is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';
comment on column htt_schedule_templates.take_holidays             is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedule_templates.take_nonworking           is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';
comment on column htt_schedule_templates.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';
comment on column htt_schedule_templates.state                     is '(A)ctive, (P)assive, When (P)assive can''t use';

----------------------------------------------------------------------------------------------------
create table htt_schedule_template_days(
  template_id                     number(20)  not null,
  day_no                          number(4)   not null,
  day_kind                        varchar2(1) not null,
  plan_time                       number(4)   not null,
  begin_time                      number(4),
  end_time                        number(4),
  break_enabled                   varchar2(1),
  break_begin_time                number(4),
  break_end_time                  number(4),
  constraint htt_schedule_template_days_pk primary key (template_id, day_no) using index tablespace GWS_INDEX,
  constraint htt_schedule_template_days_f1 foreign key (template_id) references htt_schedule_templates(template_id) on delete cascade,
  constraint htt_schedule_template_days_c1 check (day_no > 0),
  constraint htt_schedule_template_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_schedule_template_days_c3 check (plan_time between 0 and 1440),
  constraint htt_schedule_template_days_c4 check (break_enabled in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_schedule_template_days is 'all time fields are measured in minutes';

comment on column htt_schedule_template_days.day_kind      is '(W)orking, (R)est';
comment on column htt_schedule_template_days.break_enabled is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table htt_schedule_template_marks(
  template_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_template_marks_pk primary key (template_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_template_marks_f1 foreign key (template_id, day_no) references htt_schedule_template_days(template_id, day_no) on delete cascade,
  constraint htt_schedule_template_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_template_marks is 'Keeps marks template for each pattern day';

comment on column htt_schedule_template_marks.begin_time is 'Shows minutes from 00:00';
comment on column htt_schedule_template_marks.end_time   is 'Shows minutes from 00:00';

----------------------------------------------------------------------------------------------------
create table htt_schedule_registries(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  registry_id                     number(20)        not null,
  registry_date                   date              not null,
  registry_number                 varchar2(50 char) not null,
  registry_kind                   varchar2(1)       not null,
  month                           date              not null,
  division_id                     number(20),
  note                            varchar2(300 char),
  posted                          varchar2(1)       not null,
  schedule_kind                   varchar2(1)       not null,
  shift                           number(4),
  input_acceptance                number(4),
  output_acceptance               number(4),
  track_duration                  number(4)         not null,
  count_late                      varchar2(1)       not null,
  count_lack                      varchar2(1)       not null,
  count_early                     varchar2(1)       not null,
  count_free                      varchar2(1)       not null,
  allowed_late_time               number(6)         not null,
  allowed_early_time              number(6)         not null,
  begin_late_time                 number(6)         not null,
  end_early_time                  number(6)         not null,
  calendar_id                     number(20),
  take_holidays                   varchar2(1)       not null,
  take_nonworking                 varchar2(1)       not null,
  take_additional_rest_days       varchar2(1)       not null,
  gps_turnout_enabled             varchar2(1)        not null,                     
  gps_use_location                varchar2(1)        not null,
  gps_max_interval                number(20),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_schedule_registries_pk primary key (company_id, filial_id, registry_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_registries_u1 unique (registry_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_registries_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint htt_schedule_registries_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint htt_schedule_registries_f3 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id),
  constraint htt_schedule_registries_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_schedule_registries_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_schedule_registries_c1 check (trunc(registry_date) = registry_date),
  constraint htt_schedule_registries_c2 check (decode(trim(registry_number), registry_number, 1, 0) = 1),
  constraint htt_schedule_registries_c3 check (registry_kind in ('S', 'R')),
  constraint htt_schedule_registries_c4 check (trunc(month, 'mon') = month),
  constraint htt_schedule_registries_c5 check (posted in ('Y', 'N')),
  constraint htt_schedule_registries_c6 check (shift between 0 and 1439),
  constraint htt_schedule_registries_c7 check (input_acceptance between 0 and 2160),
  constraint htt_schedule_registries_c8 check (output_acceptance between 0 and 2160),
  constraint htt_schedule_registries_c9 check (track_duration between 0 and 4320),
  constraint htt_schedule_registries_c10 check (count_late in ('Y', 'N')),
  constraint htt_schedule_registries_c11 check (count_early in ('Y', 'N')),
  constraint htt_schedule_registries_c12 check (count_lack in ('Y', 'N')),
  constraint htt_schedule_registries_c13 check (count_free in ('Y', 'N')),
  constraint htt_schedule_registries_c14 check (take_holidays in ('Y', 'N')),
  constraint htt_schedule_registries_c15 check (take_nonworking in ('Y', 'N')),
  constraint htt_schedule_registries_c16 check (take_additional_rest_days in ('Y', 'N')),
  constraint htt_schedule_registries_c17 check (schedule_kind in ('C', 'F', 'H')),
  constraint htt_schedule_registries_c18 check (decode(schedule_kind, 'F', 0, 3) = nvl2(shift, 1, 0) + nvl2(input_acceptance, 1, 0) + nvl2(output_acceptance, 1, 0)),
  constraint htt_schedule_registries_c19 check (decode(schedule_kind, 'H', 0, 3) >= decode(count_late, 'Y', 1, 0) + decode(count_early, 'Y', 1, 0) + decode(count_lack, 'Y', 1, 0)),
  constraint htt_schedule_registries_c20 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_schedule_registries_c21 check (begin_late_time <= 0 and end_early_time >= 0),
  constraint htt_schedule_registries_c22 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_schedule_registries_c23 check (gps_turnout_enabled in ('Y', 'N')),
  constraint htt_schedule_registries_c24 check (gps_use_location in ('Y', 'N')),
  constraint htt_schedule_registries_c25 check (gps_max_interval > 0),
  constraint htt_schedule_registries_c26 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                             or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null)
) tablespace GWS_DATA;

comment on table htt_schedule_registries is 'Individual schedule registries';

comment on column htt_schedule_registries.schedule_kind             is '(C)ustom, (F)lexible, (H)ourly. When (F)lexible cannot set shift, input/output acceptance. When (H)ourly will calculate only turnout from input to output';
comment on column htt_schedule_registries.registry_kind             is '(S)taff, (R)obot';
comment on column htt_schedule_registries.posted                    is '(Y)es, (N)o';
comment on column htt_schedule_registries.shift                     is 'Shifts schedule from default 00:00. Measured in minutes';
comment on column htt_schedule_registries.input_acceptance          is 'Controls input acceptance border. Measured in minutes';
comment on column htt_schedule_registries.output_acceptance         is 'Controls output acceptance border. Measured in minutes';
comment on column htt_schedule_registries.track_duration            is 'Limits the duration of input-output time parts. Measured in minutes';
comment on column htt_schedule_registries.count_late                is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedule_registries.count_early               is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedule_registries.count_lack                is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';
comment on column htt_schedule_registries.count_free                is '(Y)es, (N)o. When (N)o attached timesheets will not count free time';
comment on column htt_schedule_registries.take_holidays             is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedule_registries.take_nonworking           is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';
comment on column htt_schedule_registries.take_additional_rest_days is '(Y)es, (N)o, when yes and calendar is given takes additional rest days from calendar';
comment on column htt_schedule_registries.gps_turnout_enabled       is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_schedule_registries.gps_use_location          is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_schedule_registries.gps_max_interval          is 'Max time interval between two gps tracks';

create index htt_schedule_registries_i1 on htt_schedule_registries(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htt_schedule_registries_i2 on htt_schedule_registries(company_id, filial_id, calendar_id) tablespace GWS_INDEX;
create index htt_schedule_registries_i3 on htt_schedule_registries(company_id, created_by) tablespace GWS_INDEX;
create index htt_schedule_registries_i4 on htt_schedule_registries(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_registry_units(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  registry_id                     number(20) not null,
  staff_id                        number(20),
  robot_id                        number(20),
  monthly_minutes                 number(20) not null,
  monthly_days                    number(20) not null,
  constraint htt_registry_units_pk primary key (company_id, filial_id, unit_id) using index tablespace GWS_INDEX,
  constraint htt_registry_units_u1 unique (unit_id) using index tablespace GWS_INDEX,
  constraint htt_registry_units_f1 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id) on delete cascade,
  constraint htt_registry_units_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_registry_units_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htt_registry_units_c1 check (nvl2(staff_id, 1, 0) + nvl2(robot_id, 1, 0) = 1),
  constraint htt_registry_units_c2 check (monthly_minutes >= 0 and monthly_days >= 0)
) tablespace GWS_DATA;

comment on table htt_registry_units is 'Individual schedule registry entries (staffs/robots)';

comment on column htt_registry_units.monthly_minutes is 'Total working minutes per month';
comment on column htt_registry_units.monthly_days    is 'Total working days per month';

create unique index htt_registry_units_u2 on htt_registry_units(nvl2(staff_id,company_id, null), nvl2(staff_id, filial_id, null), nvl2(staff_id, registry_id, null), staff_id) tablespace GWS_INDEX;
create unique index htt_registry_units_u3 on htt_registry_units(nvl2(robot_id,company_id, null), nvl2(robot_id, filial_id, null), nvl2(robot_id, registry_id, null), robot_id) tablespace GWS_INDEX;

create index htt_registry_units_i1 on htt_registry_units(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_registry_units_i2 on htt_registry_units(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index htt_registry_units_i3 on htt_registry_units(company_id, filial_id, registry_id) tablespace GWS_INDEX;


----------------------------------------------------------------------------------------------------
create table htt_unit_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  unit_id                         number(20)  not null,
  schedule_date                   date        not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  constraint htt_unit_schedule_days_pk primary key (company_id, filial_id, unit_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_days_f1 foreign key (company_id, filial_id, unit_id) references htt_registry_units(company_id, filial_id, unit_id) on delete cascade,
  constraint htt_unit_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_unit_schedule_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_unit_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_unit_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)),
  constraint htt_unit_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_unit_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_unit_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_unit_schedule_days_c8 check (begin_time < end_time),
  constraint htt_unit_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_unit_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_unit_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_unit_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_unit_schedule_days_c13 check (input_border < output_border),
  constraint htt_unit_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_days is 'Individual schedule entries daily info';

comment on column htt_unit_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_unit_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_unit_schedule_days.full_time     is 'measured in minutes';
comment on column htt_unit_schedule_days.plan_time     is 'measured in minutes';

----------------------------------------------------------------------------------------------------
create table htt_unit_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_unit_schedule_day_marks_pk primary key (company_id, filial_id, unit_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_day_marks_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date) on delete cascade,
  constraint htt_unit_schedule_day_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
create table htt_unit_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_unit_schedule_day_weights_pk primary key (company_id, filial_id, unit_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_day_weights_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date) on delete cascade,
  constraint htt_unit_schedule_day_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_unit_schedule_day_weights_c2 check (weight > 0),
  constraint htt_unit_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_unit_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_staff_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  schedule_date                   date        not null,
  registry_id                     number(20)  not null,
  unit_id                         number(20)  not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  constraint htt_staff_schedule_days_pk primary key (company_id, filial_id, staff_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_days_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date),
  constraint htt_staff_schedule_days_f2 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id),
  constraint htt_staff_schedule_days_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_staff_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_staff_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N')),
  constraint htt_staff_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_staff_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) or 
                                               day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_staff_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_staff_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_staff_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_staff_schedule_days_c8 check (begin_time < end_time),
  constraint htt_staff_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_staff_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_staff_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_staff_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_staff_schedule_days_c13 check (input_border < output_border),
  constraint htt_staff_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_days is 'Individual schedule entries daily info';

comment on column htt_staff_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_staff_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_staff_schedule_days.full_time     is 'measured in minutes';
comment on column htt_staff_schedule_days.plan_time     is 'measured in minutes';

create index htt_staff_schedule_days_i1 on htt_staff_schedule_days(company_id, filial_id, registry_id) tablespace GWS_INDEX;
create index htt_staff_schedule_days_i2 on htt_staff_schedule_days(company_id, filial_id, staff_id, trunc(schedule_date, 'mon')) tablespace GWS_INDEX;
create index htt_staff_schedule_days_i3 on htt_staff_schedule_days(company_id, filial_id, unit_id, schedule_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_staff_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_staff_schedule_day_marks_pk primary key (company_id, filial_id, staff_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_day_marks_f1 foreign key (company_id, filial_id, staff_id, schedule_date) references htt_staff_schedule_days(company_id, filial_id, staff_id, schedule_date) on delete cascade,
  constraint htt_staff_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
create table htt_staff_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_staff_schedule_day_weights_pk primary key (company_id, filial_id, staff_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_day_weights_f1 foreign key (company_id, filial_id, staff_id, schedule_date) references htt_staff_schedule_days(company_id, filial_id, staff_id, schedule_date) on delete cascade,
  constraint htt_staff_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_staff_schedule_day_weights_c2 check (weight > 0),
  constraint htt_staff_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_staff_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_robot_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  schedule_date                   date        not null,
  registry_id                     number(20)  not null,
  unit_id                         number(20)  not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  constraint htt_robot_schedule_days_pk primary key (company_id, filial_id, robot_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_days_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date),
  constraint htt_robot_schedule_days_f2 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id),
  constraint htt_robot_schedule_days_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htt_robot_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_robot_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N')),
  constraint htt_robot_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_robot_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) or 
                                               day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_robot_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_robot_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_robot_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_robot_schedule_days_c8 check (begin_time < end_time),
  constraint htt_robot_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_robot_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_robot_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_robot_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_robot_schedule_days_c13 check (input_border < output_border),
  constraint htt_robot_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_days is 'Individual schedule entries daily info';

comment on column htt_robot_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_robot_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_robot_schedule_days.full_time     is 'measured in minutes';
comment on column htt_robot_schedule_days.plan_time     is 'measured in minutes';

create index htt_robot_schedule_days_i1 on htt_robot_schedule_days(company_id, filial_id, registry_id) tablespace GWS_INDEX;
create index htt_robot_schedule_days_i2 on htt_robot_schedule_days(company_id, filial_id, robot_id, trunc(schedule_date, 'mon')) tablespace GWS_INDEX;
create index htt_robot_schedule_days_i3 on htt_robot_schedule_days(company_id, filial_id, unit_id, schedule_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_robot_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_robot_schedule_day_marks_pk primary key (company_id, filial_id, robot_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_day_marks_f1 foreign key (company_id, filial_id, robot_id, schedule_date) references htt_robot_schedule_days(company_id, filial_id, robot_id, schedule_date) on delete cascade,
  constraint htt_robot_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
create table htt_robot_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_robot_schedule_day_weights_pk primary key (company_id, filial_id, robot_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_day_weights_f1 foreign key (company_id, filial_id, robot_id, schedule_date) references htt_robot_schedule_days(company_id, filial_id, robot_id, schedule_date) on delete cascade,
  constraint htt_robot_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_robot_schedule_day_weights_c2 check (weight > 0),
  constraint htt_robot_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_robot_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_acms_servers(
  server_id                       number(20)         not null,
  secret_code                     varchar2(120)      not null,
  name                            varchar2(150 char) not null,
  url                             varchar2(300 char),
  order_no                        number(6),
  constraint htt_acms_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint htt_acms_servers_u1 unique (secret_code) using index tablespace GWS_INDEX,
  constraint htt_acms_servers_c1 check (decode(trim(secret_code), secret_code, 1, 0) = 1),
  constraint htt_acms_servers_c2 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_acms_servers is 'Initially external access control and management system(ACMS) servers will register application, this table stored this structure';

----------------------------------------------------------------------------------------------------
create table htt_company_acms_servers(
  company_id                      number(20) not null,
  server_id                       number(20) not null,
  constraint htt_company_acms_servers_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint htt_company_acms_servers_f1 foreign key (server_id) references htt_acms_servers(server_id)
) tablespace GWS_DATA;

comment on table htt_company_acms_servers is 'Company use registered servers for syncing acms devices, this table stored a company uses some servers';

create index htt_company_acms_servers_i1 on htt_company_acms_servers(server_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_device_types(
  device_type_id                  number(20)         not null,
  name                            varchar2(100 char) not null,
  track_types                     varchar2(100),
  mark_types                      varchar2(100),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20)       not null,
  constraint htt_device_types_pk primary key (device_type_id) using index tablespace GWS_INDEX,
  constraint htt_device_types_u1 unique (pcode) using index tablespace GWS_INDEX,
  constraint htt_device_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_device_types_c2 check (state in ('A', 'P')),
  constraint htt_device_types_c3 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_device_types is 'System device types';

comment on column htt_device_types.state is '(A)ctive, (P)assive';

----------------------------------------------------------------------------------------------------
create table htt_terminal_models(
  model_id                        number(20)         not null,
  name                            varchar2(100 char) not null,
  photo_sha                       varchar2(64),
  support_face_recognation        varchar2(1)        not null,
  support_fprint                  varchar2(1)        not null,
  support_rfid_card               varchar2(1)        not null,
  state                           varchar2(1)        not null,
  pcode                           varchar2(20)       not null,
  constraint htt_terminal_models_pk primary key (model_id) using index tablespace GWS_INDEX,
  constraint htt_terminal_models_u1 unique (pcode) using index tablespace GWS_INDEX,
  constraint htt_terminal_models_f1 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_terminal_models_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_terminal_models_c2 check (support_face_recognation in ('Y', 'N')),
  constraint htt_terminal_models_c3 check (support_fprint in ('Y', 'N')),
  constraint htt_terminal_models_c4 check (support_rfid_card in ('Y', 'N')),
  constraint htt_terminal_models_c5 check (state in ('A', 'P')),
  constraint htt_terminal_models_c6 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_terminal_models is 'System terminal models';

comment on column htt_terminal_models.state is '(A)ctive, (P)assive';

create index htt_terminal_models_i1 on htt_terminal_models(photo_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_devices(
  company_id                      number(20)         not null,
  device_id                       number(20)         not null,
  name                            varchar2(100 char),
  device_type_id                  number(20)         not null,
  serial_number                   varchar2(100 char) not null,
  model_id                        number(20),
  location_id                     number(20),
  charge_percentage               number(3),
  track_types                     varchar2(100),
  mark_types                      varchar2(100),
  emotion_types                   varchar2(100),
  lang_code                       varchar2(10),
  use_settings                    varchar2(1)        not null,
  autogen_inputs                  varchar2(1)        not null,
  autogen_outputs                 varchar2(1)        not null,
  restricted_type                 varchar2(1),
  only_last_restricted            varchar2(1),
  ignore_tracks                   varchar2(1)        not null,
  ignore_images                   varchar2(1)        not null,
  last_seen_on                    date,
  state                           varchar2(1)        not null,
  status                          varchar2(1),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_devices_u1 unique (device_id) using index tablespace GWS_INDEX,
  constraint htt_devices_u2 unique (company_id, device_type_id, serial_number) using index tablespace GWS_INDEX,
  constraint htt_devices_f1 foreign key (device_type_id) references htt_device_types(device_type_id),
  constraint htt_devices_f2 foreign key (model_id) references htt_terminal_models(model_id),
  constraint htt_devices_f3 foreign key (company_id, location_id) references htt_locations(company_id, location_id),
  constraint htt_devices_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_devices_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_devices_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_devices_c2 check (decode(trim(serial_number), serial_number, 1, 0) = 1),
  constraint htt_devices_c3 check (state in ('A', 'P')),
  constraint htt_devices_c4 check (use_settings in ('Y', 'N')),
  constraint htt_devices_c5 check (autogen_inputs in ('Y', 'N')),
  constraint htt_devices_c6 check (autogen_outputs in ('Y', 'N')),
  constraint htt_devices_c7 check (restricted_type in ('I', 'O', 'C')),
  constraint htt_devices_c8 check (charge_percentage between 0 and 100),
  constraint htt_devices_c9 check (only_last_restricted in ('Y', 'N')),
  constraint htt_devices_c10 check (only_last_restricted is null or restricted_type in ('I', 'O')),
  constraint htt_devices_c11 check (status in ('O', 'F', 'U')),
  constraint htt_devices_c12 check (ignore_tracks in ('Y', 'N')),
  constraint htt_devices_c13 check (ignore_images in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_devices is 'Keeps properties of devices.';

comment on column htt_devices.state is '(A)ctive, (P)assive';
comment on column htt_devices.restricted_type is 'When not null system will accept all tracks from this device as of chosen track type';
comment on column htt_devices.only_last_restricted is 'When enabled only last track from restricted types will remain as input/output';
comment on column htt_devices.status is '(O)nline, O(f)fline, (U)nknown';
comment on column htt_devices.ignore_tracks is '(Y)es, (N)o. When yes rejects all tracks from this device';
comment on column htt_devices.ignore_images is '(Y)es, (N)o';

create index htt_devices_i1 on htt_devices(model_id) tablespace GWS_INDEX;
create index htt_devices_i2 on htt_devices(company_id, location_id) tablespace GWS_INDEX;
create index htt_devices_i3 on htt_devices(company_id, created_by) tablespace GWS_INDEX;
create index htt_devices_i4 on htt_devices(company_id, modified_by) tablespace GWS_INDEX;
create index htt_devices_i5 on htt_devices(device_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_acms_devices(
  company_id                      number(20)         not null,
  device_id                       number(20)         not null,
  dynamic_ip                      varchar2(1)        not null,
  ip_address                      varchar2(30),
  port                            varchar2(10),
  protocol                        varchar2(1),
  host                            varchar2(100),
  login                           varchar2(100 char) not null,
  password                        varchar2(100 char) not null,
  constraint htt_acms_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_acms_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_acms_devices_c1 check (dynamic_ip in ('Y', 'N')),
  constraint htt_acms_devices_c2 check (decode(trim(ip_address), ip_address, 1, 0) = 1),
  constraint htt_acms_devices_c3 check (decode(trim(port), port, 1, 0) = 1),
  constraint htt_acms_devices_c4 check (protocol in ('H', 'S')),
  constraint htt_acms_devices_c5 check (decode(trim(host), host, 1, 0) = 1),
  constraint htt_acms_devices_c6 check (dynamic_ip = 'Y' and ip_address is not null and port is not null and protocol is not null or
                                             dynamic_ip = 'N' and host is not null),
  constraint htt_acms_devices_c7 check (decode(trim(login), login, 1, 0) = 1),
  constraint htt_acms_devices_c8 check (decode(trim(password), password, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column htt_acms_devices.dynamic_ip is '(Y)es, (N)o';
comment on column htt_acms_devices.protocol is '(H)ttp, Http(S)';

----------------------------------------------------------------------------------------------------
create table htt_unknown_devices(
  company_id                      number(20) not null,
  device_id                       number(20) not null,
  constraint htt_unknown_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_unknown_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_unknown_devices is 'Keeps unknown device ids';

----------------------------------------------------------------------------------------------------
create table htt_device_admins(
  company_id                      number(20) not null,
  device_id                       number(20) not null,
  person_id                       number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_device_admins_pk primary key (company_id, device_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_device_admins_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_device_admins_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_device_admins_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on table htt_device_admins is 'Keeps admin ids of device.';

create index htt_device_admins_i1 on htt_device_admins(company_id, person_id) tablespace GWS_INDEX;
create index htt_device_admins_i2 on htt_device_admins(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table htt_acms_commands(
  company_id                      number(20)  not null,
  command_id                      number(20)  not null,
  device_id                       number(20)  not null,
  command_kind                    varchar2(1) not null,
  person_id                       number(20),
  data                            clob,
  status                          varchar2(1) not null,
  state_changed_on                date        not null,
  error_msg                       varchar2(4000 char),
  constraint htt_acms_commands_pk primary key (company_id, command_id) using index tablespace GWS_INDEX,
  constraint htt_acms_commands_u1 unique (command_id) using index tablespace GWS_INDEX,
  constraint htt_acms_commands_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_acms_commands_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_acms_commands_c1 check (command_kind in ('U', 'A', 'P', 'D', 'R', 'T')),
  constraint htt_acms_commands_c2 check (command_kind in ('P', 'R') and person_id is not null or command_kind in ('U', 'A', 'D', 'T') and person_id is null),
  constraint htt_acms_commands_c3 check (data is json),
  constraint htt_acms_commands_c4 check (status in ('N', 'S', 'C', 'F'))
) tablespace GWS_DATA;

comment on column htt_acms_commands.command_kind is '(U)pdate device, Update (A)ll Device Persons, Update (P)erson, Remove (D)evice, (R)emove Person, Sync (T)racks';
comment on column htt_acms_commands.status       is '(N)ew, (S)ent, (C)ompleted, (F)ailed';

create index htt_acms_commands_i1 on htt_acms_commands(company_id, device_id) tablespace GWS_DATA;
create index htt_acms_commands_i2 on htt_acms_commands(company_id, person_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htt_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  track_id                        number(20)  not null,
  track_date                      date        not null,
  track_time                      timestamp with local time zone not null,
  track_datetime                  date        not null,
  person_id                       number(20)  not null,
  track_type                      varchar2(1) not null,
  mark_type                       varchar2(1) not null,
  device_id                       number(20),
  location_id                     number(20),
  latlng                          varchar2(50),
  accuracy                        number(20),
  photo_sha                       varchar2(64),
  bssid                           varchar2(100),
  note                            varchar2(300 char),
  original_type                   varchar2(1) not null,
  trans_input                     varchar2(1) not null,
  trans_output                    varchar2(1) not null,
  trans_check                     varchar2(1) not null,
  is_valid                        varchar2(1) not null,
  status                          varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20) not null,
  constraint htt_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_tracks_u2 unique (company_id, filial_id, track_time, person_id, device_id, original_type) using index tablespace GWS_INDEX,
  constraint htt_tracks_u3 unique (company_id, filial_Id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id),
  constraint htt_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id),
  constraint htt_tracks_f4 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_tracks_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_tracks_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_tracks_c2 check (mark_type in ('P', 'T', 'R', 'Q', 'F', 'M', 'A')),
  constraint htt_tracks_c3 check (decode(latlng, null, 1, 0) = decode(accuracy, null, 1, 0)),
  constraint htt_tracks_c4 check (is_valid in ('Y', 'N')),
  constraint htt_tracks_c5 check (status in ('D', 'N', 'P', 'U')),
  constraint htt_tracks_c6 check (original_type in ('I', 'O', 'C')),
  constraint htt_tracks_c7 check (trans_input in ('Y', 'N')),
  constraint htt_tracks_c8 check (trans_output in ('Y', 'N')),
  constraint htt_tracks_c9 check (trans_check in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_tracks is 'Keeps properties of tracks.';

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
comment on column htt_tracks.bssid          is 'BSSID. If device can not find location, then send bssid';
comment on column htt_tracks.original_type  is '(I)nput, (O)utput, (C)heck. Keeps original track types when its changed';
comment on column htt_tracks.trans_input    is '(Y)es, (N)o. Transformable to input. (Y)es when device setting autogen_input was turned at track cretion time';
comment on column htt_tracks.trans_output   is '(Y)es, (N)o. Transformable to output. (Y)es when device setting autogen_output was turned at track cretion time';
comment on column htt_tracks.trans_check    is '(Y)es, (N)o. Transformable to check. (Y)es when device setting autogen_output was turned at track cretion time';
comment on column htt_tracks.is_valid       is 'It must be (Y)es or (N)o. If (N)o, this track not used for generate statistcs';
comment on column htt_tracks.status         is '(D)raft, (N)ot used, (P)artially used, (U)sed';

create index htt_tracks_i1 on htt_tracks(company_id, person_id, track_date) tablespace GWS_INDEX;
create index htt_tracks_i2 on htt_tracks(company_id, location_id) tablespace GWS_INDEX;
create index htt_tracks_i3 on htt_tracks(company_id, device_id) tablespace GWS_INDEX;
create index htt_tracks_i4 on htt_tracks(company_id, filial_id, person_id, track_date, track_datetime) tablespace GWS_INDEX;
create index htt_tracks_i5 on htt_tracks(photo_sha) tablespace GWS_INDEX;
create index htt_tracks_i6 on htt_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_tracks_i7 on htt_tracks(company_id, modified_by) tablespace GWS_INDEX;
create index htt_tracks_i8 on htt_tracks(company_id, filial_id, track_time, person_id, original_type) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_trash_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  track_id                        number(20)  not null,
  track_date                      date        not null,
  track_time                      timestamp with local time zone not null,
  track_datetime                  date        not null,
  person_id                       number(20)  not null,
  track_type                      varchar2(1) not null,
  mark_type                       varchar2(1) not null,
  device_id                       number(20),
  location_id                     number(20),
  latlng                          varchar2(50),
  accuracy                        number(20),
  photo_sha                       varchar2(64),
  bssid                           varchar2(100),
  note                            varchar2(300 char),
  is_valid                        varchar2(1) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_trash_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_u2 unique (company_id, filial_id, track_time, person_id, device_id, track_type) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_trash_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id),
  constraint htt_trash_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id),
  constraint htt_trash_tracks_f4 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_trash_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_trash_tracks_c2 check (mark_type in ('P', 'T', 'R', 'Q', 'F', 'M')),
  constraint htt_trash_tracks_c3 check (decode(latlng, null, 1, 0) = decode(accuracy, null, 1, 0)),
  constraint htt_trash_tracks_c4 check (is_valid in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_trash_tracks             is 'Keeps person''s non-working interval tracks. All columns the same with htt_tracks table';
comment on column htt_trash_tracks.track_type is '(I)nput, (O)utput, (C)heck';
comment on column htt_trash_tracks.mark_type  is '(P)assword, (T)ouch, (R)fid card, (Q)R code, (F)ace, (M)anual';

create index htt_trash_tracks_i1 on htt_trash_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i2 on htt_trash_tracks(company_id, location_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i3 on htt_trash_tracks(company_id, device_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i4 on htt_trash_tracks(company_id, filial_id, person_id, track_date, track_datetime) tablespace GWS_INDEX;
create index htt_trash_tracks_i5 on htt_trash_tracks(photo_sha) tablespace GWS_INDEX;
create index htt_trash_tracks_i6 on htt_trash_tracks(company_id, filial_id,  track_time, person_id, track_type) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_blocked_person_tracking(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  employee_id                     number(20) not null,
  constraint htt_blocked_person_tracking_pk primary key (company_id, filial_id, employee_id) using index tablespace GWS_DATA,
  constraint htt_blocked_person_tracking_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htt_potential_outputs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  track_id                        number(20) not null,
  constraint htt_potential_outputs_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_potential_outputs_f1 foreign key (company_id, filial_id, track_id) references htt_tracks(company_id, filial_id, track_id) on delete cascade
) tablespace GWS_INDEX;

comment on table htt_potential_outputs is 'Keeps check tracks that potentially will be converted to output tracks';

----------------------------------------------------------------------------------------------------
create table htt_gps_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  track_id                        number(20)  not null,
  person_id                       number(20)  not null,
  track_date                      date        not null,
  total_distance                  number(20),
  calculated                      varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_gps_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u2 unique (company_id, filial_id, person_id, track_date) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_gps_tracks_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_c1 check (total_distance >= 0),
  constraint htt_gps_tracks_c2 check (calculated in ('Y', 'N')),
  constraint htt_gps_tracks_c3 check (calculated = 'N' or calculated = 'Y' and total_distance is not null)
) tablespace GWS_DATA;

comment on table htt_gps_tracks is 'stores person''s gps daily unit';
comment on column htt_gps_tracks.total_distance is 'total distance on track date, in meter(m)';
comment on column htt_gps_tracks.calculated     is '(Y)es, (N)o - track data changed but the total distance has not yet been calculated';

create index htt_gps_tracks_i1 on htt_gps_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_gps_tracks_i2 on htt_gps_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_gps_tracks_i3 on htt_gps_tracks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_gps_track_datas(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  track_id                        number(20) not null,
  data                            blob       not null,
  constraint htt_gps_track_datas_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_track_datas_f1 foreign key (company_id, filial_id, track_id) references htt_gps_tracks(company_id, filial_id, track_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_gps_track_datas       is 'Keeps datas of gps tracks.';
comment on column htt_gps_track_datas.data is 'stores track datas separated by the tab(\t) with enter(\n), track data - track_time, lat, lng, accuracy, provider("G"ps, "N"etwork));
example: "09:00:00\t43.21245663\t45.215466985\t50\tG\n..."';

----------------------------------------------------------------------------------------------------
create table htt_gps_track_batches(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  track_id                        number(20) not null,
  batch_id                        number(20) not null,
  constraint htt_gps_track_batches_pk primary key (company_id, filial_id, track_id, batch_id) using index tablespace GWS_INDEX,
  constraint htt_gps_track_batches_f1 foreign key (company_id, filial_id, track_id) references htt_gps_tracks(company_id, filial_id, track_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_gps_track_batches is 'stores batch id sent by mobile in each request and saved data to database succesfully';

----------------------------------------------------------------------------------------------------
-- Employee time off information
----------------------------------------------------------------------------------------------------
create table htt_time_kinds(
  company_id                      number(20)         not null,
  time_kind_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  letter_code                     varchar2(50 char)  not null,
  digital_code                    varchar2(50),
  parent_id                       number(20),
  plan_load                       varchar2(1)        not null,
  requestable                     varchar2(1)        not null,
  bg_color                        varchar2(7),
  color                           varchar2(7),
  timesheet_coef                  number(3,2),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint htt_time_kinds_pk primary key (company_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_time_kinds_u1 unique (time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_time_kinds_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_time_kinds_f1 foreign key (company_id, parent_id) references htt_time_kinds(company_id, time_kind_id) on delete cascade,
  constraint htt_time_kinds_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_time_kinds_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_time_kinds_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_time_kinds_c2 check (decode(trim(letter_code), letter_code, 1, 0) = 1),
  constraint htt_time_kinds_c3 check (decode(trim(digital_code), digital_code, 1, 0) = 1),
  constraint htt_time_kinds_c5 check (plan_load in ('F', 'P', 'E')),
  constraint htt_time_kinds_c6 check (requestable in ('Y', 'N')),
  constraint htt_time_kinds_c7 check (timesheet_coef between 0 and 1),
  constraint htt_time_kinds_c8 check (state in ('A', 'P')),
  constraint htt_time_kinds_c9 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_time_kinds is 'Keeps properties of time kinds. It used for create request kinds';

comment on column htt_time_kinds.letter_code    is 'Letter code use in generate timesheet reports for to express time kinds';
comment on column htt_time_kinds.plan_load      is 'It must be (F)ull, (P)art or (E)xtra';
comment on column htt_time_kinds.requestable    is 'It must be (Y)es, (N)o. It is must be (Y)es, if its added not by the system';
comment on column htt_time_kinds.timesheet_coef is 'The ratio of counting attendance';
comment on column htt_time_kinds.state          is 'It must be (A)ctive, (P)assive. If (P)assive, this kind can''t view in request kind';

create unique index htt_time_kinds_u3 on htt_time_kinds(company_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_time_kinds_u4 on htt_time_kinds(company_id, lower(letter_code)) tablespace GWS_INDEX;
create unique index htt_time_kinds_u5 on htt_time_kinds(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index htt_time_kinds_i1 on htt_time_kinds(company_id, parent_id) tablespace GWS_INDEX;
create index htt_time_kinds_i2 on htt_time_kinds(company_id, pcode) tablespace GWS_INDEX;
create index htt_time_kinds_i3 on htt_time_kinds(company_id, created_by) tablespace GWS_INDEX;
create index htt_time_kinds_i4 on htt_time_kinds(company_id, modified_by) tablespace GWS_INDEX;

create index htt_time_kinds_i5 on htt_time_kinds(company_id, nvl(parent_id, time_kind_id)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_request_kinds(
  company_id                      number(20)         not null,
  request_kind_id                 number(20)         not null,
  name                            varchar2(100 char) not null,
  time_kind_id                    number(20)         not null,
  annually_limited                varchar2(1)        not null,
  day_count_type                  varchar2(1)        not null,
  annual_day_limit                number(3),
  user_permitted                  varchar2(1)        not null,
  allow_unused_time               varchar2(1)        not null,
  request_restriction_days        number(3),
  carryover_policy                varchar2(1),
  carryover_cap_days              number(3),
  carryover_expires_days          number(3),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint htt_request_kinds_pk primary key (company_id, request_kind_id) using index tablespace GWS_INDEX,
  constraint htt_request_kinds_u1 unique (request_kind_id) using index tablespace GWS_INDEX,
  constraint htt_request_kinds_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_request_kinds_f1 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint htt_request_kinds_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_request_kinds_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_request_kinds_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_request_kinds_c2 check (annually_limited in ('Y', 'N')),
  constraint htt_request_kinds_c3 check (day_count_type in ('C', 'W', 'P')),
  constraint htt_request_kinds_c4 check (annually_limited = 'Y' or annual_day_limit is null),
  constraint htt_request_kinds_c5 check (annual_day_limit between 0 and 366),
  constraint htt_request_kinds_c6 check (user_permitted in ('Y', 'N')),
  constraint htt_request_kinds_c7 check (allow_unused_time in ('Y', 'N')),
  constraint htt_request_kinds_c8 check (carryover_policy in ('A', 'Z', 'C') and annually_limited = 'Y' or carryover_policy is null and annually_limited = 'N'),
  constraint htt_request_kinds_c9 check (carryover_cap_days > 0 and carryover_policy = 'C' or carryover_cap_days is null and carryover_policy != 'C'),
  constraint htt_request_kinds_c10 check (carryover_expires_days > 0 and carryover_policy != 'Z' or carryover_expires_days is null and carryover_policy = 'Z'),
  constraint htt_request_kinds_c11 check (state in ('A', 'P')),
  constraint htt_request_kinds_c12 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_request_kinds is 'Keeps request kind. Reequest kind use for create requests';

comment on column htt_request_kinds.annually_limited         is '(Y)es, (N)o. Sets annual limit to number of times this request_type can be requested';
comment on column htt_request_kinds.day_count_type           is '(C)alendar, (W)ork days, (P)roduction days. Days of this request_type will count only on calendar/work/production days';
comment on column htt_request_kinds.annual_day_limit         is 'If annually_limited is set to (Y)es, this attribute keeps limit to number of times this request_type can be requested';
comment on column htt_request_kinds.user_permitted           is 'Employees can request this type of time off or it can be entered only by administrators and managers';
comment on column htt_request_kinds.allow_unused_time        is '(Y)es, (N)o. When set to yes unused request time goes to another time kind';
comment on column htt_request_kinds.request_restriction_days is 'Days before the request begin date is necessary to request it. A negative value allows you to request request retroactively.';
comment on column htt_request_kinds.carryover_policy         is 'What happens to annually accrued leave time when the Year End Date is reached each year: carryover (A)ll, reset to (Z)ero, set a (C)ap on how much time can be accrued';
comment on column htt_request_kinds.carryover_cap_days       is 'How much time can be accrued';
comment on column htt_request_kinds.carryover_expires_days   is 'The number of days after which the carryover will expire';
comment on column htt_request_kinds.state                    is '(A)ctive, (P)assive. Used to filter when attached to an employee';

create unique index htt_request_kinds_u3 on htt_request_kinds(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index htt_request_kinds_i1 on htt_request_kinds(company_id, time_kind_id) tablespace GWS_INDEX;
create index htt_request_kinds_i2 on htt_request_kinds(company_id, created_by) tablespace GWS_INDEX;
create index htt_request_kinds_i3 on htt_request_kinds(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_request_kind_accruals(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  staff_id                        number(20)   not null,
  request_kind_id                 number(20)   not null,
  period                          date         not null,
  accrual_kind                    varchar2(1)  not null,
  accrued_days                    number(20,6) not null,
  constraint htt_request_kind_accruals_pk primary key (company_id, filial_id, staff_id, request_kind_id, period, accrual_kind) using index tablespace GWS_INDEX,
  constraint htt_request_kind_accruals_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_request_kind_accruals_f2 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id) on delete cascade,
  constraint htt_request_kind_acrruals_c1 check (trunc(period) = period),
  constraint htt_request_kind_accruals_c2 check (accrual_kind in ('C', 'P')),
  constraint htt_request_kind_accruals_c3 check (accrued_days >= 0)
) tablespace GWS_DATA;

comment on table htt_request_kind_accruals is 'Yearly accrual plans';

comment on column htt_request_kind_accruals.period       is 'Is last day in accrual period. Period starts with new year (01.01)';
comment on column htt_request_kind_accruals.accrual_kind is '(C)arryover, (P)lan';

create index htt_request_kind_accruals_i1 on htt_request_kind_accruals(company_id, request_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_staff_request_kinds(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  request_kind_id                 number(20) not null,
  constraint htt_staff_request_kinds_pk primary key (company_id, filial_id, staff_id, request_kind_id) using index tablespace GWS_INDEX,
  constraint htt_staff_request_kinds_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_staff_request_kinds_f2 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id)
) tablespace GWS_DATA;

create index htt_staff_request_kinds_i1 on htt_staff_request_kinds(company_id, request_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_requests(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  request_id                      number(20)   not null,
  request_kind_id                 number(20)   not null,
  staff_id                        number(20)   not null,
  begin_time                      date         not null,
  end_time                        date         not null,
  request_type                    varchar2(1)  not null,
  manager_note                    varchar2(300 char),
  note                            varchar2(300 char),
  accrual_kind                    varchar2(1),
  status                          varchar2(1)  not null,
  barcode                         varchar2(25) not null,
  approved_by                     number(20),
  completed_by                    number(20),
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)   not null,
  constraint htt_requests_pk primary key (company_id, filial_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_requests_u1 unique (request_id) using index tablespace GWS_INDEX,
  constraint htt_requests_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_requests_f1 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id),
  constraint htt_requests_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_requests_f3 foreign key (company_id, approved_by) references md_users(company_id, user_id),
  constraint htt_requests_f4 foreign key (company_id, completed_by) references md_users(company_id, user_id),
  constraint htt_requests_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_requests_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_requests_c1 check (status in ('N', 'A', 'C', 'D')),
  constraint htt_requests_c2 check (begin_time <= end_time),
  constraint htt_requests_c3 check (request_type in ('P', 'F', 'M')),
  constraint htt_requests_c4 check (accrual_kind in ('C', 'P'))
) tablespace GWS_DATA;

comment on table htt_requests is 'Keeps Staff Requests. Requests are used to register abseces and correctly generate reports.';

comment on column htt_requests.request_type is '(P)art of day, (F)ull day, (M)ultiple days';
comment on column htt_requests.status       is '(N)ew, (A)pproved, (C)ompleted, (D)enied';
comment on column htt_requests.accrual_kind is '(C)arryover, (P)lan';

create index htt_requests_i1 on htt_requests(company_id, request_kind_id) tablespace GWS_INDEX;
create index htt_requests_i2 on htt_requests(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_requests_i3 on htt_requests(company_id, approved_by) tablespace GWS_INDEX;
create index htt_requests_i4 on htt_requests(company_id, completed_by) tablespace GWS_INDEX;
create index htt_requests_i5 on htt_requests(company_id, created_by) tablespace GWS_INDEX;
create index htt_requests_i6 on htt_requests(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_request_helpers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  interval_date                   date       not null,
  request_id                      number(20) not null,
  constraint htt_request_helpers_pk primary key (company_id, filial_id, staff_id, interval_date, request_id) using index tablespace GWS_INDEX,
  constraint htt_request_helpers_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_request_helpers_f2 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id) on delete cascade
) tablespace GWS_DATA;

create index htt_request_helpers_i1 on htt_request_helpers(company_id, filial_id, request_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheets(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  timesheet_date                  date        not null,
  staff_id                        number(20)  not null,
  employee_id                     number(20)  not null,
  schedule_id                     number(20)  not null,
  calendar_id                     number(20),
  day_kind                        varchar2(1) not null,
  track_duration                  number(6)   not null,
  schedule_kind                   varchar2(1) not null,
  count_late                      varchar2(1) not null,
  count_early                     varchar2(1) not null,
  count_lack                      varchar2(1) not null,
  count_free                      varchar2(1) not null,
  gps_turnout_enabled             varchar2(1) not null,                     
  gps_use_location                varchar2(1) not null,
  gps_max_interval                number(20),
  allowed_late_time               number(6)   not null,
  allowed_early_time              number(6)   not null,
  begin_late_time                 number(6)   not null,
  end_early_time                  number(6)   not null,
  shift_begin_time                date,
  shift_end_time                  date,
  input_border                    date,
  output_border                   date,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number(5)    not null,
  full_time                       number(5)    not null,
  input_time                      date,
  output_time                     date,
  planned_marks                   number(4)    not null,
  done_marks                      number(4)    not null,
  constraint htt_timesheets_pk primary key (company_id, filial_id, timesheet_id) using index tablespace GWS_INDEX,
  constraint htt_timesheets_u1 unique (timesheet_id) using index tablespace GWS_INDEX,
  constraint htt_timesheets_u2 unique (company_id, filial_id, staff_id, timesheet_date) using index tablespace GWS_INDEX,
  constraint htt_timesheets_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_timesheets_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade,
  constraint htt_timesheets_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint htt_timesheets_f4 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id),
  constraint htt_timesheets_c1 check (trunc(timesheet_date) = timesheet_date),
  constraint htt_timesheets_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N')),
  constraint htt_timesheets_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_timesheets_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)
                                      or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_timesheets_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_timesheets_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 86400),
  constraint htt_timesheets_c7 check (trunc(begin_time) = timesheet_date),
  constraint htt_timesheets_c8 check (begin_time < end_time),
  constraint htt_timesheets_c9 check (break_begin_time < break_end_time),
  constraint htt_timesheets_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_timesheets_c11 check (shift_begin_time < shift_end_time),
  constraint htt_timesheets_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_timesheets_c13 check (input_border < output_border),
  constraint htt_timesheets_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border),
  constraint htt_timesheets_c15 check (track_duration between 0 and 259200),
  constraint htt_timesheets_c16 check (count_late in ('Y', 'N')),
  constraint htt_timesheets_c17 check (count_early in ('Y', 'N')),
  constraint htt_timesheets_c18 check (count_lack in ('Y', 'N')),
  constraint htt_timesheets_c19 check (count_free in ('Y', 'N')),  
  constraint htt_timesheets_c20 check (done_marks >= 0 and done_marks <= planned_marks),
  constraint htt_timesheets_c21 check(shift_begin_time is not null) deferrable initially deferred,
  constraint htt_timesheets_c22 check(shift_end_time   is not null) deferrable initially deferred,
  constraint htt_timesheets_c23 check(input_border     is not null) deferrable initially deferred,
  constraint htt_timesheets_c24 check(output_border    is not null) deferrable initially deferred,
  constraint htt_timesheets_c25 check(schedule_kind in ('C', 'F', 'H')),
  constraint htt_timesheets_c26 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_timesheets_c27 check (begin_late_time <= 0 and end_early_time >= 0),
  constraint htt_timesheets_c28 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0))),
  constraint htt_timesheets_c29 check (gps_turnout_enabled in ('Y', 'N')),
  constraint htt_timesheets_c30 check (gps_use_location in ('Y', 'N')),
  constraint htt_timesheets_c31 check (gps_max_interval > 0),
  constraint htt_timesheets_c32 check (gps_turnout_enabled = 'Y' and gps_max_interval is not null 
                                    or gps_turnout_enabled = 'N' and gps_use_location = 'N' and gps_max_interval is null)
) tablespace GWS_DATA;

comment on table htt_timesheets is 'Keeps Properties of Staff Timesheets. Timesheet used for keep all informations about daily schedule of staff.';

comment on column htt_timesheets.day_kind            is '(W)ork, (R)est, (A)dditional Rest, (H)oliday, (N)onworking';
comment on column htt_timesheets.count_late          is 'It must be (Y)es or (N)o. If No will not count late time';
comment on column htt_timesheets.count_early         is 'It must be (Y)es or (N)o. If No will not count early output time';
comment on column htt_timesheets.count_lack          is 'It must be (Y)es or (N)o. If No will not count lack time';
comment on column htt_timesheets.count_free          is 'It must be (Y)es or (N)o. If No will not count free time';
comment on column htt_timesheets.break_enabled       is '(Y)es, (N)o';
comment on column htt_timesheets.input_time          is 'cached field from tracks';
comment on column htt_timesheets.output_time         is 'cached field from tracks';
comment on column htt_timesheets.full_time           is 'Measured in seconds';
comment on column htt_timesheets.plan_time           is 'Measured in seconds';
comment on column htt_timesheets.track_duration      is 'Measured in seconds';
comment on column htt_timesheets.planned_marks       is 'Count of planned marks for this timesheet day';
comment on column htt_timesheets.done_marks          is 'Count of done marks for this timesheet day';
comment on column htt_timesheets.schedule_kind       is '(C)ustom, (F)lexible, (H)ourly';
comment on column htt_timesheets.gps_turnout_enabled is '(Y)es, (N)o. When yes turnout is affected by presense of gps tracks';
comment on column htt_timesheets.gps_use_location    is '(Y)es, (N)o. When yes takes only gps tracks from location polygons';
comment on column htt_timesheets.gps_max_interval    is 'Max time interval between two gps tracks';

create index htt_timesheets_i1 on htt_timesheets(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index htt_timesheets_i2 on htt_timesheets(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index htt_timesheets_i3 on htt_timesheets(company_id, filial_id, calendar_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- maybe add cached requestable field to htt_timesheet_facts? speeds up some queries
create table htt_timesheet_facts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  time_kind_id                    number(20) not null,
  fact_value                      number(6)  not null,
  constraint htt_timesheet_facts_pk primary key (company_id, filial_id, timesheet_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_facts_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint htt_timesheet_facts_c1 check (fact_value >= 0)
) tablespace GWS_DATA;

comment on table htt_timesheet_facts is 'Keeps fact values depends on in every time kind';

comment on column htt_timesheet_facts.fact_value   is 'Measured in seconds';
comment on column htt_timesheet_facts.time_kind_id is 'Only one time_kind with plan_load FULL can be entered in one day';

create index htt_timesheet_facts_i1 on htt_timesheet_facts(company_id, time_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_helpers(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  interval_date                   date        not null,
  timesheet_id                    number(20)  not null,
  day_kind                        varchar2(1) not null,
  shift_begin_time                date        not null,
  shift_end_time                  date        not null,
  input_border                    date        not null,
  output_border                   date        not null,
  constraint htt_timesheet_helpers_pk primary key (company_id, filial_id, staff_id, interval_date, timesheet_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_helpers_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_timesheet_helpers_f2 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_timesheet_helpers is 'Keeps extra information about timesheet day';

create index htt_timesheet_helpers_i1 on htt_timesheet_helpers(company_id, filial_id, timesheet_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  track_id                        number(20)  not null,
  track_datetime                  date        not null,
  track_type                      varchar2(1) not null,
  track_used                      varchar2(1) not null,
  trans_input                     varchar2(1) not null,
  trans_output                    varchar2(1) not null,
  trans_check                     varchar2(1) not null,
  constraint htt_timesheet_tracks_pk primary key (company_id, filial_id, timesheet_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_tracks_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_tracks_f2 foreign key (company_id, filial_id, track_id) references htt_tracks(company_id, filial_id, track_id),
  constraint htt_timesheet_tracks_c1 check (track_used in ('Y', 'N')),
  constraint htt_timesheet_tracks_c2 check (track_type in ('I', 'O', 'C', 'M', 'P', 'G')),
  constraint htt_timesheet_tracks_c3 check (trans_input in ('Y', 'N')),
  constraint htt_timesheet_tracks_c4 check (trans_output in ('Y', 'N')),
  constraint htt_timesheet_tracks_c5 check (trans_check in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_timesheet_tracks is 'Keeps tracks depends on timesheet day';

comment on column htt_timesheet_tracks.track_used   is '(Y)es, (N)o. (N)o only when new track is added to locked timesheet.';
comment on column htt_timesheet_tracks.track_type   is '(I)nput, (O)utput, (C)heck, (M)erger, (P)otential output, (G)ps Output. (M)erger tracks appear only after fact calculation. (C)heck tracks can be transformed to other types';
comment on column htt_timesheet_tracks.trans_input  is '(Y)es, (N)o. Same as htt_tracks.trans_input';
comment on column htt_timesheet_tracks.trans_output is '(Y)es, (N)o. Same as htt_tracks.trans_output';
comment on column htt_timesheet_tracks.trans_check  is '(Y)es, (N)o. Same as htt_tracks.trans_check';

create index htt_timesheet_tracks_i1 on htt_timesheet_tracks(company_id, filial_id, track_id) tablespace GWS_INDEX;
create index htt_timesheet_tracks_i2 on htt_timesheet_tracks(company_id, filial_id, timesheet_id, track_type, track_datetime) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_requests(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  request_id                      number(20) not null,
  constraint htt_timesheet_requests_pk primary key (company_id, filial_id, timesheet_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_requests_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_requests_f2 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id)
) tablespace GWS_DATA;

comment on table htt_timesheet_requests is 'Keeps requests depends on timesheet day';

create index htt_timesheet_requests_i1 on htt_timesheet_requests(company_id, filial_id, request_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_marks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  begin_time                      date        not null,
  end_time                        date        not null,
  done                            varchar2(1) not null,
  constraint htt_timesheet_marks_pk primary key (company_id, filial_id, timesheet_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_timesheet_marks_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_marks_c1 check (begin_time < end_time),
  constraint htt_timesheet_marks_c2 check (done in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_timesheet_marks is 'Keeps marks for each timesheet day. Only (C)heck track types are used in marking';

comment on column htt_timesheet_marks.done is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table htt_timesheet_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_timesheet_weights_pk primary key (company_id, filial_id, timesheet_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_timesheet_weights_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_weights_c1 check (begin_time < end_time),
  constraint htt_timesheet_weights_c2 check (weight > 0),
  constraint htt_timesheet_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_timesheet_weights is 'Weights to calculate weighted turnout';

comment on column htt_timesheet_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_timesheet_intervals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  interval_id                     number(20) not null,
  timesheet_id                    number(20) not null,
  interval_begin                  date       not null,
  interval_end                    date       not null,
  constraint htt_timesheet_intervals_pk primary key (company_id, filial_id, interval_Id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_intervals_u1 unique (interval_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_intervals_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_intervals_c1 check (interval_begin < interval_end)
) tablespace GWS_DATA;

comment on table htt_timesheet_intervals is 'Exact intervals used to calculate turnout timekind facts. (Includes tracks and requests)';

create index htt_timesheet_intervals_i1 on htt_timesheet_intervals(company_id, filial_id, timesheet_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_locks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  timesheet_date                  date        not null,
  facts_changed                   varchar2(1) not null,
  constraint htt_timesheet_locks_pk primary key (company_id, filial_id, staff_id, timesheet_date) using index tablespace GWS_INDEX,
  constraint htt_timesheet_locks_f1 foreign key (company_id, filial_id, staff_id, timesheet_date) references htt_timesheets(company_id, filial_id, staff_id, timesheet_date),
  constraint htt_timesheet_locks_c1 check (facts_changed in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_timesheet_locks is 'Timesheet locks. Locked timesheet cannot be changed without removing lock';

----------------------------------------------------------------------------------------------------
create global temporary table htt_dirty_timesheets(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  locked                          varchar2(1) not null,
  constraint htt_dirty_timesheets_pk primary key (company_id, filial_id, timesheet_id),
  constraint htt_dirty_timesheets_c1 check (timesheet_id is null) deferrable initially deferred,
  constraint htt_dirty_timesheets_c2 check (locked in ('Y', 'N'))
);

comment on column htt_dirty_timesheets.locked is '(Y)es, (N)o. Locked (Y)es when exists corresponding row in htt_timesheet_locks';

----------------------------------------------------------------------------------------------------
create table htt_plan_changes(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  change_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  change_kind                     varchar2(1) not null,
  manager_note                    varchar2(300 char),
  note                            varchar2(300 char),
  status                          varchar2(1) not null,
  approved_by                     number(20),
  completed_by                    number(20),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)  not null,
  constraint htt_plan_changes_pk primary key (company_id, filial_id, change_id) using index tablespace GWS_INDEX,
  constraint htt_plan_changes_u1 unique (change_id) using index tablespace GWS_INDEX,
  constraint htt_plan_changes_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint htt_plan_changes_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_plan_changes_f2 foreign key (company_id, approved_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_f3 foreign key (company_id, completed_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_c1 check (change_kind in ('S', 'C')),
  constraint htt_plan_changes_c2 check (status in ('N', 'A', 'C', 'D'))
) tablespace GWS_DATA;

comment on table htt_plan_changes is 'Keeps staff timesheet plan changes. Should have highest priority among all plan sources';

comment on column htt_plan_changes.change_kind is '(S)wap, (C)hange plan';
comment on column htt_plan_changes.status      is '(N)ew, (A)pproved, (C)ompleted, (D)enied';

create index htt_plan_changes_i1 on htt_plan_changes(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_plan_changes_i2 on htt_plan_changes(company_id, approved_by) tablespace GWS_INDEX;
create index htt_plan_changes_i3 on htt_plan_changes(company_id, completed_by) tablespace GWS_INDEX;
create index htt_plan_changes_i4 on htt_plan_changes(company_id, created_by) tablespace GWS_INDEX;
create index htt_plan_changes_i5 on htt_plan_changes(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_change_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  change_date                     date        not null,
  change_id                       number(20)  not null,
  swapped_date                    date,
  day_kind                        varchar2(1),
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number(5),
  full_time                       number(5),
  constraint htt_change_days_pk primary key (company_id, filial_id, staff_id, change_date, change_id) using index tablespace GWS_INDEX,
  constraint htt_change_days_f1 foreign key (company_id, filial_id, change_id) references htt_plan_changes(company_id, filial_id, change_id) on delete cascade,
  constraint htt_change_days_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_change_days_c1 check (trunc(change_date) = change_date),
  constraint htt_change_days_c2 check (trunc(swapped_date) = swapped_date),
  constraint htt_change_days_c3 check (day_kind in ('W', 'R') or (day_kind in ('H', 'A', 'N') or day_kind is null) and swapped_date is not null),
  constraint htt_change_days_c4 check (break_enabled in ('Y', 'N')),
  constraint htt_change_days_c5 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)
                                        or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_change_days_c6 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_change_days_c7 check (plan_time <= full_time and 0 <= plan_time and full_time <= 86400),
  constraint htt_change_days_c8 check (begin_time < end_time),
  constraint htt_change_days_c9 check (break_begin_time < break_end_time),
  constraint htt_change_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_change_days_c11 check (nvl2(day_kind, 1, 0) + nvl2(plan_time, 1, 0) + nvl2(full_time, 1, 0) in (0, 3)),
  constraint htt_change_days_c12 check (change_date != swapped_date) 
) tablespace GWS_DATA;

comment on table htt_change_days is 'Keeps timesheet plan changes. Swaps are updated each time affected timesheets are changed';

comment on column htt_change_days.swapped_date  is 'swapped data source';
comment on column htt_change_days.day_kind      is '(W)ork, (R)est, (A)dditional Rest, (H)oliday, (N)onworking';
comment on column htt_change_days.break_enabled is '(Y)es, (N)o';
comment on column htt_change_days.plan_time     is 'Measured in seconds';
comment on column htt_change_days.full_time     is 'Measured in seconds';

create index htt_change_days_i1 on htt_change_days(company_id, filial_id, staff_id, swapped_date) tablespace GWS_INDEX;
create index htt_change_days_i2 on htt_change_days(company_id, filial_id, staff_id, change_date) tablespace GWS_INDEX;
create index htt_change_days_i3 on htt_change_days(company_id, filial_id, change_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_change_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  change_id                       number(20) not null,
  change_date                     date       not null,
  begin_time                      number     not null,
  end_time                        number     not null,
  weight                          number(20) not null,
  constraint htt_change_day_weights_pk primary key (company_id, filial_id, staff_id, change_date, change_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_change_day_weights_f1 foreign key (company_id, filial_id, staff_id, change_date, change_id) references htt_change_days(company_id, filial_id, staff_id, change_date, change_id) on delete cascade,
  constraint htt_change_day_weights_c1 check (begin_time < end_time),
  constraint htt_change_day_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htt_acms_tracks(
  company_id                      number(20)  not null,
  track_id                        number(20)  not null,
  device_id                       number(20)  not null,
  person_id                       number(20)  not null,
  track_type                      varchar2(1) not null,
  track_datetime                  date        not null,
  mark_type                       varchar2(1) not null,
  status                          varchar2(1) not null,
  error_text                      varchar2(200 char),
  constraint htt_acms_tracks_pk primary key (company_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_acms_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_acms_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_acms_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_acms_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_acms_tracks_c2 check (mark_type in ('T', 'F')),
  constraint htt_acms_tracks_c3 check (status in ('N', 'C', 'F'))
) tablespace GWS_DATA;

comment on column htt_acms_tracks.track_type is '(I)nput, (O)utput, (C)heck';
comment on column htt_acms_tracks.mark_type  is '(T)ouch, (F)ace';
comment on column htt_acms_tracks.status     is '(N)ew, (C)ompleted, (F)ailed';

create index htt_acms_tracks_i1 on htt_acms_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_acms_tracks_i2 on htt_acms_tracks(company_id, device_id, person_id, track_type, track_datetime) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table htt_migrated_employees(
  company_id                       number(20) not null,
  filial_id                        number(20) not null,
  employee_id                      number(20) not null,
  period_begin                     date       not null,
  constraint htt_migrated_employees_pk primary key (company_id, filial_id, employee_id),
  constraint htt_migrated_employees_c1 check (company_id is null) deferrable initially deferred
);

comment on table htt_migrated_employees is 'Employees that will have tracks migrated to other filial';
