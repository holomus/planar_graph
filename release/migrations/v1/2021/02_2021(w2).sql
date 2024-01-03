prompt Migr from 02.2021 2nd week

----------------------------------------------------------------------------------------------------
prompt htt module changes
----------------------------------------------------------------------------------------------------
create sequence htt_locations_sq;
create sequence htt_device_types_sq;
create sequence htt_devices_sq;
create sequence htt_tracks_sq;
create sequence htt_gps_tracks_sq;

----------------------------------------------------------------------------------------------------
create table htt_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  pin                             number(8),
  pin_code                        number(8),
  rfid_code                       number(10),
  qr_code                         varchar2(64),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_persons_pk primary key (company_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_persons_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_persons_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_persons_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_persons_c1 check (decode(trim(qr_code), qr_code, 1, 0) = 1)
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
  constraint htt_person_photos_pk primary key (company_id, person_id, photo_sha) using index tablespace GWS_INDEX,
  constraint htt_person_photos_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_person_photos_f2 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

comment on table htt_person_photos is 'For Person Face Recognition';

create index htt_person_photos_i1 on htt_person_photos(photo_sha) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_locations(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  location_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  timezone_code                   varchar2(64),
  region_id                       number(20),
  address                         varchar2(200 char),
  latlng                          varchar2(50)       not null,
  accuracy                        number(20)         not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_locations_pk primary key (company_id, filial_id, location_id) using index tablespace GWS_INDEX,
  constraint htt_locations_u1 unique (location_id) using index tablespace GWS_INDEX,
  constraint htt_locations_f1 foreign key (timezone_code) references md_timezones(timezone_code),
  constraint htt_locations_f2 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint htt_locations_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_locations_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_locations_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_locations_c3 check (state in ('A', 'P')),
  constraint htt_locations_c2 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column htt_locations.state is '(A)ctive, (P)assive';

create unique index htt_locations_u2 on htt_locations(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index htt_locations_i1 on htt_locations(timezone_code) tablespace GWS_INDEX;
create index htt_locations_i2 on htt_locations(company_id, region_id) tablespace GWS_INDEX;
create index htt_locations_i3 on htt_locations(company_id, created_by) tablespace GWS_INDEX;
create index htt_locations_i4 on htt_locations(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_location_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  location_id                     number(20) not null,
  division_id                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_divisions_pk primary key (company_id, filial_id, location_id, division_id) using index tablespace GWS_INDEX,
  constraint htt_location_divisions_f1 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id) on delete cascade,
  constraint htt_location_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint htt_location_divisions_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index htt_location_divisions_i1 on htt_location_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htt_location_divisions_i2 on htt_location_divisions(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_location_persons(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  location_id                     number(20) not null,
  person_id                       number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_persons_pk primary key (company_id, filial_id, location_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_location_persons_f1 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id) on delete cascade,
  constraint htt_location_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_location_persons_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index htt_location_persons_i1 on htt_location_persons(company_id, person_id) tablespace GWS_INDEX;
create index htt_location_persons_i2 on htt_location_persons(company_id, created_by) tablespace GWS_INDEX;

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
  constraint htt_device_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table htt_device_types is 'System device types';

comment on column htt_device_types.state is '(A)ctive, (P)assive';

----------------------------------------------------------------------------------------------------
create table htt_devices(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  device_id                       number(20)         not null,
  name                            varchar2(100 char),
  device_type_id                  number(20)         not null,
  serial_number                   varchar2(100 char) not null,
  location_id                     number(20),
  track_types                     varchar2(100),
  mark_types                      varchar2(100),
  last_seen_on                    date,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_devices_pk primary key (company_id, filial_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_devices_u1 unique (device_id) using index tablespace GWS_INDEX,
  constraint htt_devices_u2 unique (device_type_id, serial_number) using index tablespace GWS_INDEX,
  constraint htt_devices_f1 foreign key (device_type_id) references htt_device_types(device_type_id),
  constraint htt_devices_f2 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id),
  constraint htt_devices_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_devices_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_devices_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_devices_c2 check (decode(trim(serial_number), serial_number, 1, 0) = 1),
  constraint htt_devices_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column htt_devices.state is '(A)ctive, (P)assive';

create index htt_devices_i1 on htt_devices(company_id, filial_id, location_id) tablespace GWS_INDEX;
create index htt_devices_i2 on htt_devices(company_id, created_by) tablespace GWS_INDEX;
create index htt_devices_i3 on htt_devices(company_id, modified_by) tablespace GWS_INDEX;

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
  note                            varchar2(200 char),
  is_valid                        varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_tracks_u2 unique (company_id, filial_id, track_time, person_id, track_type) using index tablespace GWS_INDEX,
  constraint htt_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_tracks_f2 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id),
  constraint htt_tracks_f3 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_tracks_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_tracks_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_tracks_c2 check (mark_type in ('P', 'T', 'R', 'Q', 'F', 'M')),
  constraint htt_tracks_c3 check (decode(latlng, null, 1, 0) = decode(accuracy, null, 1, 0)),
  constraint htt_tracks_c4 check (is_valid in ('Y', 'N'))
) tablespace GWS_DATA;

comment on column htt_tracks.track_type is '(I)nput, (O)utput, (C)heck';
comment on column htt_tracks.mark_type is '(P)assword, (T)ouch, (R)fid card, (Q)R code, (F)ace, (M)anual';

create index htt_tracks_i1 on htt_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_tracks_i2 on htt_tracks(company_id, filial_id, location_id) tablespace GWS_INDEX;
create index htt_tracks_i3 on htt_tracks(photo_sha) tablespace GWS_INDEX;
create index htt_tracks_i4 on htt_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_tracks_i5 on htt_tracks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table htt_gps_tracks(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  track_id                        number(20)   not null,
  track_date                      date         not null,
  track_time                      timestamp with local time zone not null, 
  track_datetime                  date         not null,
  person_id                       number(20)   not null,
  latlng                          varchar2(50) not null,
  accuracy                        number(5)    not null,
  provider                        varchar2(1)  not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_gps_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u2 unique (company_id, filial_id, track_time, person_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_gps_tracks_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_c1 check (provider in ('G', 'N'))
) tablespace GWS_DATA;

comment on column htt_gps_tracks.provider is '(G)ps, (N)etwork';

create index htt_gps_tracks_i1 on htt_gps_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_gps_tracks_i2 on htt_gps_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_gps_tracks_i3 on htt_gps_tracks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table htt_dirty_persons( 
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint htt_dirty_persons_u1 unique (company_id, person_id),
  constraint htt_dirty_persons_c1 check (person_id is null) deferrable initially deferred
) on commit preserve rows;

----------------------------------------------------------------------------------------------------
prompt hzk module
----------------------------------------------------------------------------------------------------  
create sequence hzk_commands_sq;
create sequence hzk_migr_tracks_sq;
create sequence hzk_attlog_errors_sq;
create sequence hzk_migr_persons_sq;

----------------------------------------------------------------------------------------------------  
create table hzk_devices(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  device_id                       number(20) not null,
  check_sent_on                   date,
  check_received_on               date,
  user_number                     number(20),
  fingerprint_number              number(20),
  attendance_number               number(20),
  ip_address                      varchar2(30),
  stamp                           number(20),
  opstamp                         number(20),
  photostamp                      number(20),
  error_delay                     number(20),
  delay                           number(20),
  transtimes                      varchar2(100),
  transinterval                   number(20),
  realtime                        number(20),
  constraint hzk_devices_pk primary key (company_id, filial_id, device_id) using index tablespace GWS_INDEX,
  constraint hzk_devices_f1 foreign key (company_id, filial_id, device_id) references htt_devices(company_id, filial_id, device_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------  
create table hzk_person_fprints(
  company_id                      number(20)     not null,
  person_id                       number(20)     not null,
  finger_no                       number(20)     not null,
  tmp                             varchar2(4000) not null,
  constraint hzk_fprints_pk primary key (company_id, person_id, finger_no) using index tablespace GWS_INDEX,
  constraint hzk_fprints_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_device_persons(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  device_id                       number(20)  not null,
  person_id                       number(20)  not null,
  person_role                     varchar2(1) not null,
  constraint hzk_device_persons_pk primary key (company_id, filial_id, device_id, person_id) using index tablespace GWS_DATA,
  constraint hzk_device_persons_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id) on delete cascade,
  constraint hzk_device_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
) tablespace GWS_DATA;

comment on column hzk_device_persons.person_role is '(N)ormal user, (A)dmin';

create index hzk_device_persons_i1 on hzk_device_persons(company_id, person_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_device_fprints(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  device_id                       number(20) not null,
  person_id                       number(20) not null,
  finger_no                       number(20) not null,
  constraint hzk_device_fprints_pk primary key (company_id, filial_id, device_id, person_id, finger_no) using index tablespace GWS_INDEX,
  constraint hzk_device_fprints_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id) on delete cascade,
  constraint hzk_device_fprints_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hzk_device_fprints_f3 foreign key (company_id, person_id, finger_no) references hzk_person_fprints(company_id, person_id, finger_no)
) tablespace GWS_DATA;

create index hzk_device_fprints_i1 on hzk_device_fprints(company_id, person_id, finger_no) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_commands(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  command_id                      number(20)     not null,
  device_id                       number(20)     not null,
  command                         varchar2(4000) not null,
  state                           varchar2(1)    not null,
  state_changed_on                date           not null,
  constraint hzk_commands_pk primary key (company_id, filial_id, command_id) using index tablespace GWS_DATA,
  constraint hzk_commands_u1 unique (command_id) using index tablespace GWS_DATA,
  constraint hzk_commands_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id) on delete cascade,
  constraint hzk_commands_c1 check (state in ('N', 'S', 'C'))
) tablespace GWS_DATA;

comment on column hzk_commands.state is '(N)ew, (S)ent, (C)omplate';

create index hzk_commands_i1 on hzk_commands(company_id, filial_id, device_id) tablespace GWS_DATA;
       
----------------------------------------------------------------------------------------------------
create table hzk_errors(
  error                           varchar2(4000) not null,
  created_on                      date           not null
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table hzk_attlog_errors(
 company_id                       number(20)     not null,
 filial_id                        number(20)     not null,
 error_id                         number(20)     not null,
 device_id                        number(20)     not null,
 command                          varchar2(4000) not null,
 error                            varchar2(4000) not null,
 constraint hzk_attlog_errors_pk primary key (company_id, filial_id, error_id) using index tablespace GWS_DATA,
 constraint hzk_attlog_errors_u1 unique (error_id) using index tablespace GWS_DATA,
 constraint hzk_attlog_errors_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hzk_migr_persons(
  company_id                      number(20)         not null,
  migr_person_id                  number(20)         not null,
  filial_id                       number(20)         not null,  
  device_id                       number(20)         not null,
  pin                             number(20)         not null,
  person_name                     varchar2(250 char) not null,
  person_role                     varchar2(1)        not null,
  password                        varchar2(8),
  rfid_code                       varchar2(10),
  constraint hzk_migr_porsons_pk primary key (company_id, migr_person_id) using index  tablespace GWS_DATA,
  constraint hzk_migr_persons_u1 unique (migr_person_id) using index tablespace GWS_DATA,
  constraint hzk_migr_persons_u2 unique (company_id, filial_id, device_id, pin) using index tablespace GWS_DATA,
  constraint hzk_migr_persons_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id)
) tablespace GWS_DATA;

comment on column hzk_migr_persons.person_role is '(N)ormal user, (A)dmin';

----------------------------------------------------------------------------------------------------
create table hzk_migr_fprints(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  device_id                       number(20)     not null,
  pin                             number(20)     not null,
  finger_no                       number(20)     not null,
  tmp                             varchar2(4000) not null,
  constraint hzk_migr_fprints_pk primary key (company_id, filial_id, device_id, pin, finger_no) using index tablespace GWS_DATA
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hzk_migr_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  migr_track_id                   number(20)  not null,
  pin                             number(20)  not null,
  device_id                       number(20)  not null,
  location_id                     number(20)  not null,
  track_type                      varchar2(1) not null,
  track_time                      timestamp with local time zone not null,
  track_date                      date        not null,
  mark_type                       varchar2(1) not null,
  constraint hzk_migr_tracks_pk primary key (company_id, filial_id, migr_track_id) using  index tablespace GWS_DATA,
  constraint hzk_migr_tracks_u1 unique (migr_track_id) using index tablespace GWS_DATA,
  constraint hzk_migr_tracks_f1 foreign key (company_id, filial_id, device_id) references hzk_devices(company_id, filial_id, device_id),
  constraint hzk_migr_tracks_f2 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id),
  constraint hzk_migr_tracks_c1 check (track_type in ('I', 'O')),
  constraint hzk_migr_tracks_c2 check (mark_type in ('P', 'B', 'F', 'T'))
) tablespace GWS_DATA;

comment on column hzk_migr_tracks.track_type is '(I)nput, (O)utput';
comment on column hzk_migr_tracks.mark_type is '(P)assword, (B)arcode, (F)ace, (T)ouch';

create index hzk_migr_tracks_i1 on hzk_migr_tracks(company_id, filial_id, device_id) tablespace GWS_DATA;
create index hzk_migr_tracks_i2 on hzk_migr_tracks(company_id, filial_id, location_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt HREF module
----------------------------------------------------------------------------------------------------
drop sequence href_locations_sq;

drop table href_location_persons;
drop table href_location_divisions;
drop table href_locations;

prompt added created and modified columns in href_fixed_term_bases
alter table href_fixed_term_bases add created_by number(20);
alter table href_fixed_term_bases add created_on timestamp with local time zone;
alter table href_fixed_term_bases add modified_by number(20);
alter table href_fixed_term_bases add modified_on timestamp with local time zone;

alter table href_fixed_term_bases add constraint href_fixed_term_bases_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_fixed_term_bases add constraint href_fixed_term_bases_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_fixed_term_bases_i1 on href_fixed_term_bases(company_id, created_by) tablespace GWS_INDEX;
create index href_fixed_term_bases_i2 on href_fixed_term_bases(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Fixed_Term_Bases q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_fixed_term_bases modify created_by not null;
alter table href_fixed_term_bases modify created_on not null;
alter table href_fixed_term_bases modify modified_by not null;
alter table href_fixed_term_bases modify modified_on not null;

prompt added created and modified columns in href_edu_stages
alter table href_edu_stages add created_by number(20);
alter table href_edu_stages add created_on timestamp with local time zone;
alter table href_edu_stages add modified_by number(20);
alter table href_edu_stages add modified_on timestamp with local time zone;

alter table href_edu_stages add constraint href_edu_stages_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_edu_stages add constraint href_edu_stages_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_edu_stages_i2 on href_edu_stages(company_id, created_by) tablespace GWS_INDEX;
create index href_edu_stages_i3 on href_edu_stages(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Edu_Stages q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_edu_stages modify created_by not null;
alter table href_edu_stages modify created_on not null;
alter table href_edu_stages modify modified_by not null;
alter table href_edu_stages modify modified_on not null;

prompt added created and modified columns in href_science_branches
alter table href_science_branches add created_by number(20);
alter table href_science_branches add created_on timestamp with local time zone;
alter table href_science_branches add modified_by number(20);
alter table href_science_branches add modified_on timestamp with local time zone;

alter table href_science_branches add constraint href_science_branches_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_science_branches add constraint href_science_branches_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_science_branches_i1 on href_science_branches(company_id, created_by) tablespace GWS_INDEX;
create index href_science_branches_i2 on href_science_branches(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Science_Branches q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_science_branches modify created_by not null;
alter table href_science_branches modify created_on not null;
alter table href_science_branches modify modified_by not null;
alter table href_science_branches modify modified_on not null;

prompt added created and modified columns in href_acad_degrees
alter table href_acad_degrees add created_by number(20);
alter table href_acad_degrees add created_on timestamp with local time zone;
alter table href_acad_degrees add modified_by number(20);
alter table href_acad_degrees add modified_on timestamp with local time zone;

alter table href_acad_degrees add constraint href_acad_degrees_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_acad_degrees add constraint href_acad_degrees_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_acad_degrees_i3 on href_acad_degrees(company_id, created_by) tablespace GWS_INDEX;
create index href_acad_degrees_i4 on href_acad_degrees(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Acad_Degrees q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_acad_degrees modify created_by not null;
alter table href_acad_degrees modify created_on not null;
alter table href_acad_degrees modify modified_by not null;
alter table href_acad_degrees modify modified_on not null;

prompt added created and modified columns in href_acad_titles
alter table href_acad_titles add created_by number(20);
alter table href_acad_titles add created_on timestamp with local time zone;
alter table href_acad_titles add modified_by number(20);
alter table href_acad_titles add modified_on timestamp with local time zone;

alter table href_acad_titles add constraint href_acad_titles_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_acad_titles add constraint href_acad_titles_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_acad_titles_i1 on href_acad_titles(company_id, created_by) tablespace GWS_INDEX;
create index href_acad_titles_i2 on href_acad_titles(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Acad_Titles q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_acad_titles modify created_by not null;
alter table href_acad_titles modify created_on not null;
alter table href_acad_titles modify modified_by not null;
alter table href_acad_titles modify modified_on not null;

prompt added created and modified columns in href_institutions
alter table href_institutions add created_by number(20);
alter table href_institutions add created_on timestamp with local time zone;
alter table href_institutions add modified_by number(20);
alter table href_institutions add modified_on timestamp with local time zone;

alter table href_institutions add constraint href_institutions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_institutions add constraint href_institutions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_institutions_i1 on href_institutions(company_id, created_by) tablespace GWS_INDEX;
create index href_institutions_i2 on href_institutions(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Institutions q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_institutions modify created_by not null;
alter table href_institutions modify created_on not null;
alter table href_institutions modify modified_by not null;
alter table href_institutions modify modified_on not null;

prompt added created and modified columns in href_specialties
alter table href_specialties add created_by number(20);
alter table href_specialties add created_on timestamp with local time zone;
alter table href_specialties add modified_by number(20);
alter table href_specialties add modified_on timestamp with local time zone;

alter table href_specialties add constraint href_specialties_f2 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_specialties add constraint href_specialties_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_specialties_i2 on href_specialties(company_id, created_by) tablespace GWS_INDEX;
create index href_specialties_i3 on href_specialties(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Specialties q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_specialties modify created_by not null;
alter table href_specialties modify created_on not null;
alter table href_specialties modify modified_by not null;
alter table href_specialties modify modified_on not null;

prompt added created and modified columns in href_professions
alter table href_professions add created_by number(20);
alter table href_professions add created_on timestamp with local time zone;
alter table href_professions add modified_by number(20);
alter table href_professions add modified_on timestamp with local time zone;

alter table href_professions add constraint href_professions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_professions add constraint href_professions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_professions_i1 on href_professions(company_id, created_by) tablespace GWS_INDEX;
create index href_professions_i2 on href_professions(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Professions q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_professions modify created_by not null;
alter table href_professions modify created_on not null;
alter table href_professions modify modified_by not null;
alter table href_professions modify modified_on not null;

prompt added created and modified columns in href_langs
alter table href_langs add created_by number(20);
alter table href_langs add created_on timestamp with local time zone;
alter table href_langs add modified_by number(20);
alter table href_langs add modified_on timestamp with local time zone;

alter table href_langs add constraint href_langs_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_langs add constraint href_langs_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_langs_i1 on href_langs(company_id, created_by) tablespace GWS_INDEX;
create index href_langs_i2 on href_langs(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Langs q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_langs modify created_by not null;
alter table href_langs modify created_on not null;
alter table href_langs modify modified_by not null;
alter table href_langs modify modified_on not null;

prompt added created and modified columns in href_lang_levels
alter table href_lang_levels add created_by number(20);
alter table href_lang_levels add created_on timestamp with local time zone;
alter table href_lang_levels add modified_by number(20);
alter table href_lang_levels add modified_on timestamp with local time zone;

alter table href_lang_levels add constraint href_lang_levels_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_lang_levels add constraint href_lang_levels_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_lang_levels_i1 on href_lang_levels(company_id, created_by) tablespace GWS_INDEX;
create index href_lang_levels_i2 on href_lang_levels(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Lang_Levels q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_lang_levels modify created_by not null;
alter table href_lang_levels modify created_on not null;
alter table href_lang_levels modify modified_by not null;
alter table href_lang_levels modify modified_on not null;

prompt added created and modified columns in href_document_types
alter table href_document_types add created_by number(20);
alter table href_document_types add created_on timestamp with local time zone;
alter table href_document_types add modified_by number(20);
alter table href_document_types add modified_on timestamp with local time zone;

alter table href_document_types add constraint href_document_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_document_types add constraint href_document_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_document_types_i2 on href_document_types(company_id, created_by) tablespace GWS_INDEX;
create index href_document_types_i3 on href_document_types(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Document_Types q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_document_types modify created_by not null;
alter table href_document_types modify created_on not null;
alter table href_document_types modify modified_by not null;
alter table href_document_types modify modified_on not null;

prompt added created and modified columns in href_reference_types
alter table href_reference_types add created_by number(20);
alter table href_reference_types add created_on timestamp with local time zone;
alter table href_reference_types add modified_by number(20);
alter table href_reference_types add modified_on timestamp with local time zone;

alter table href_reference_types add constraint href_reference_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_reference_types add constraint href_reference_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_reference_types_i1 on href_reference_types(company_id, created_by) tablespace GWS_INDEX;
create index href_reference_types_i2 on href_reference_types(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Reference_Types q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_reference_types modify created_by not null;
alter table href_reference_types modify created_on not null;
alter table href_reference_types modify modified_by not null;
alter table href_reference_types modify modified_on not null;

prompt added created and modified columns in href_relation_degrees
alter table href_relation_degrees add created_by number(20);
alter table href_relation_degrees add created_on timestamp with local time zone;
alter table href_relation_degrees add modified_by number(20);
alter table href_relation_degrees add modified_on timestamp with local time zone;

alter table href_relation_degrees add constraint href_relation_degrees_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_relation_degrees add constraint href_relation_degrees_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_relation_degrees_i1 on href_relation_degrees(company_id, created_by) tablespace GWS_INDEX;
create index href_relation_degrees_i2 on href_relation_degrees(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Relation_Degrees q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_relation_degrees modify created_by not null;
alter table href_relation_degrees modify created_on not null;
alter table href_relation_degrees modify modified_by not null;
alter table href_relation_degrees modify modified_on not null;

prompt added created and modified columns in href_marital_statuses
alter table href_marital_statuses add created_by number(20);
alter table href_marital_statuses add created_on timestamp with local time zone;
alter table href_marital_statuses add modified_by number(20);
alter table href_marital_statuses add modified_on timestamp with local time zone;

alter table href_marital_statuses add constraint href_marital_statuses_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_marital_statuses add constraint href_marital_statuses_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_marital_statuses_i1 on href_marital_statuses(company_id, created_by) tablespace GWS_INDEX;
create index href_marital_statuses_i2 on href_marital_statuses(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Marital_Statuses q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_marital_statuses modify created_by not null;
alter table href_marital_statuses modify created_on not null;
alter table href_marital_statuses modify modified_by not null;
alter table href_marital_statuses modify modified_on not null;

prompt added created and modified columns in href_experience_types
alter table href_experience_types add created_by number(20);
alter table href_experience_types add created_on timestamp with local time zone;
alter table href_experience_types add modified_by number(20);
alter table href_experience_types add modified_on timestamp with local time zone;

alter table href_experience_types add constraint href_experience_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_experience_types add constraint href_experience_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_experience_types_i1 on href_experience_types(company_id, created_by) tablespace GWS_INDEX;
create index href_experience_types_i2 on href_experience_types(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Experience_Types q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_experience_types modify created_by not null;
alter table href_experience_types modify created_on not null;
alter table href_experience_types modify modified_by not null;
alter table href_experience_types modify modified_on not null;

prompt added created and modified columns in href_awards
alter table href_awards add created_by number(20);
alter table href_awards add created_on timestamp with local time zone;
alter table href_awards add modified_by number(20);
alter table href_awards add modified_on timestamp with local time zone;

alter table href_awards add constraint href_awards_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_awards add constraint href_awards_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_awards_i1 on href_awards(company_id, created_by) tablespace GWS_INDEX;
create index href_awards_i2 on href_awards(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Awards q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_awards modify created_by not null;
alter table href_awards modify created_on not null;
alter table href_awards modify modified_by not null;
alter table href_awards modify modified_on not null;

prompt added created and modified columns in href_person_edu_stages
alter table href_person_edu_stages add created_by number(20);
alter table href_person_edu_stages add created_on timestamp with local time zone;
alter table href_person_edu_stages add modified_by number(20);
alter table href_person_edu_stages add modified_on timestamp with local time zone;

alter table href_person_edu_stages add constraint href_person_edu_stages_f5 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_edu_stages add constraint href_person_edu_stages_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_edu_stages_i5 on href_person_edu_stages(company_id, created_by) tablespace GWS_INDEX;
create index href_person_edu_stages_i6 on href_person_edu_stages(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Edu_Stages q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_edu_stages modify created_by not null;
alter table href_person_edu_stages modify created_on not null;
alter table href_person_edu_stages modify modified_by not null;
alter table href_person_edu_stages modify modified_on not null;

prompt added created and modified columns in href_person_acad_degrees
alter table href_person_acad_degrees add created_by number(20);
alter table href_person_acad_degrees add created_on timestamp with local time zone;
alter table href_person_acad_degrees add modified_by number(20);
alter table href_person_acad_degrees add modified_on timestamp with local time zone;

alter table href_person_acad_degrees add constraint href_person_acad_degrees_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_acad_degrees add constraint href_person_acad_degrees_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_acad_degrees_i3 on href_person_acad_degrees(company_id, created_by) tablespace GWS_INDEX;
create index href_person_acad_degrees_i4 on href_person_acad_degrees(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Acad_Degrees q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_acad_degrees modify created_by not null;
alter table href_person_acad_degrees modify created_on not null;
alter table href_person_acad_degrees modify modified_by not null;
alter table href_person_acad_degrees modify modified_on not null;

prompt added created and modified columns in href_person_acad_titles
alter table href_person_acad_titles add created_by number(20);
alter table href_person_acad_titles add created_on timestamp with local time zone;
alter table href_person_acad_titles add modified_by number(20);
alter table href_person_acad_titles add modified_on timestamp with local time zone;

alter table href_person_acad_titles add constraint href_person_acad_titles_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_acad_titles add constraint href_person_acad_titles_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_acad_titles_i4 on href_person_acad_titles(company_id, created_by) tablespace GWS_INDEX;
create index href_person_acad_titles_i5 on href_person_acad_titles(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Acad_Titles q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_acad_titles modify created_by not null;
alter table href_person_acad_titles modify created_on not null;
alter table href_person_acad_titles modify modified_by not null;
alter table href_person_acad_titles modify modified_on not null;

prompt added created columns in href_person_professions
alter table href_person_professions add created_by number(20);
alter table href_person_professions add created_on timestamp with local time zone;

alter table href_person_professions add constraint href_person_professions_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);

create index href_person_professions_i2 on href_person_professions(company_id, created_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Professions q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_professions modify created_by not null;
alter table href_person_professions modify created_on not null;

prompt added created and modified columns in href_person_specialties
alter table href_person_specialties add created_by number(20);
alter table href_person_specialties add created_on timestamp with local time zone;
alter table href_person_specialties add modified_by number(20);
alter table href_person_specialties add modified_on timestamp with local time zone;

alter table href_person_specialties add constraint href_person_specialties_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_specialties add constraint href_person_specialties_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_specialties_i3 on href_person_specialties(company_id, created_by) tablespace GWS_INDEX;
create index href_person_specialties_i4 on href_person_specialties(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Specialties q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_specialties modify created_by not null;
alter table href_person_specialties modify created_on not null;
alter table href_person_specialties modify modified_by not null;
alter table href_person_specialties modify modified_on not null;

prompt added created and modified columns in href_person_langs
alter table href_person_langs add created_by number(20);
alter table href_person_langs add created_on timestamp with local time zone;
alter table href_person_langs add modified_by number(20);
alter table href_person_langs add modified_on timestamp with local time zone;

alter table href_person_langs add constraint href_person_langs_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_langs add constraint href_person_langs_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_langs_i3 on href_person_langs(company_id, created_by) tablespace GWS_INDEX;
create index href_person_langs_i4 on href_person_langs(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Langs q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_langs modify created_by not null;
alter table href_person_langs modify created_on not null;
alter table href_person_langs modify modified_by not null;
alter table href_person_langs modify modified_on not null;

prompt added created and modified columns in href_person_references
alter table href_person_references add created_by number(20);
alter table href_person_references add created_on timestamp with local time zone;
alter table href_person_references add modified_by number(20);
alter table href_person_references add modified_on timestamp with local time zone;

alter table href_person_references add constraint href_person_references_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_references add constraint href_person_references_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_references_i3 on href_person_references(company_id, created_by) tablespace GWS_INDEX;
create index href_person_references_i4 on href_person_references(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_References q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_references modify created_by not null;
alter table href_person_references modify created_on not null;
alter table href_person_references modify modified_by not null;
alter table href_person_references modify modified_on not null;

prompt added created and modified columns in href_person_family_members
alter table href_person_family_members add created_by number(20);
alter table href_person_family_members add created_on timestamp with local time zone;
alter table href_person_family_members add modified_by number(20);
alter table href_person_family_members add modified_on timestamp with local time zone;

alter table href_person_family_members add constraint href_person_family_members_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_family_members add constraint href_person_family_members_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_family_members_i3 on href_person_family_members(company_id, created_by) tablespace GWS_INDEX;
create index href_person_family_members_i4 on href_person_family_members(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Family_Members q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_family_members modify created_by not null;
alter table href_person_family_members modify created_on not null;
alter table href_person_family_members modify modified_by not null;
alter table href_person_family_members modify modified_on not null;

prompt added created and modified columns in href_person_marital_statuses
alter table href_person_marital_statuses add created_by number(20);
alter table href_person_marital_statuses add created_on timestamp with local time zone;
alter table href_person_marital_statuses add modified_by number(20);
alter table href_person_marital_statuses add modified_on timestamp with local time zone;

alter table href_person_marital_statuses add constraint href_person_marital_statuses_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_marital_statuses add constraint href_person_marital_statuses_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_marital_statuses_i2 on href_person_marital_statuses(company_id, created_by) tablespace GWS_INDEX;
create index href_person_marital_statuses_i3 on href_person_marital_statuses(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Marital_Statuses q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_marital_statuses modify created_by not null;
alter table href_person_marital_statuses modify created_on not null;
alter table href_person_marital_statuses modify modified_by not null;
alter table href_person_marital_statuses modify modified_on not null;

prompt added created and modified columns in href_person_experiences
alter table href_person_experiences add created_by number(20);
alter table href_person_experiences add created_on timestamp with local time zone;
alter table href_person_experiences add modified_by number(20);
alter table href_person_experiences add modified_on timestamp with local time zone;

alter table href_person_experiences add constraint href_person_experiences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_experiences add constraint href_person_experiences_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_experiences_i3 on href_person_experiences(company_id, created_by) tablespace GWS_INDEX;
create index href_person_experiences_i4 on href_person_experiences(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Experiences q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_experiences modify created_by not null;
alter table href_person_experiences modify created_on not null;
alter table href_person_experiences modify modified_by not null;
alter table href_person_experiences modify modified_on not null;

prompt added created and modified columns in href_person_awards
alter table href_person_awards add created_by number(20);
alter table href_person_awards add created_on timestamp with local time zone;
alter table href_person_awards add modified_by number(20);
alter table href_person_awards add modified_on timestamp with local time zone;

alter table href_person_awards add constraint href_person_awards_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_awards add constraint href_person_awards_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_awards_i3 on href_person_awards(company_id, created_by) tablespace GWS_INDEX;
create index href_person_awards_i4 on href_person_awards(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Awards q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_awards modify created_by not null;
alter table href_person_awards modify created_on not null;
alter table href_person_awards modify modified_by not null;
alter table href_person_awards modify modified_on not null;

prompt added created and modified columns in href_person_work_places
alter table href_person_work_places add created_by number(20);
alter table href_person_work_places add created_on timestamp with local time zone;
alter table href_person_work_places add modified_by number(20);
alter table href_person_work_places add modified_on timestamp with local time zone;

alter table href_person_work_places add constraint href_person_work_places_f2 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_person_work_places add constraint href_person_work_places_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_person_work_places_i2 on href_person_work_places(company_id, created_by) tablespace GWS_INDEX;
create index href_person_work_places_i3 on href_person_work_places(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Person_Work_Places q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_person_work_places modify created_by not null;
alter table href_person_work_places modify created_on not null;
alter table href_person_work_places modify modified_by not null;
alter table href_person_work_places modify modified_on not null;

prompt added created and modified columns in href_labor_functions
alter table href_labor_functions add created_by number(20);
alter table href_labor_functions add created_on timestamp with local time zone;
alter table href_labor_functions add modified_by number(20);
alter table href_labor_functions add modified_on timestamp with local time zone;

alter table href_labor_functions add constraint href_labor_functions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_labor_functions add constraint href_labor_functions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_labor_functions_i1 on href_labor_functions(company_id, created_by) tablespace GWS_INDEX;
create index href_labor_functions_i2 on href_labor_functions(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Labor_Functions q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_labor_functions modify created_by not null;
alter table href_labor_functions modify created_on not null;
alter table href_labor_functions modify modified_by not null;
alter table href_labor_functions modify modified_on not null;

prompt added created and modified columns in href_dismissal_reasons
alter table href_dismissal_reasons add created_by number(20);
alter table href_dismissal_reasons add created_on timestamp with local time zone;
alter table href_dismissal_reasons add modified_by number(20);
alter table href_dismissal_reasons add modified_on timestamp with local time zone;

alter table href_dismissal_reasons add constraint href_dismissal_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table href_dismissal_reasons add constraint href_dismissal_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index href_dismissal_reasons_i1 on href_dismissal_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_dismissal_reasons_i2 on href_dismissal_reasons(company_id, modified_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Href_Dismissal_Reasons q
       set q.Created_By  = Ui.User_Id,
           q.Created_On  = Current_Timestamp,
           q.Modified_By = Ui.User_Id,
           q.Modified_On = Current_Timestamp
     where q.Company_Id = r.Company_Id;
  end loop;

  commit;
end;
/

alter table href_dismissal_reasons modify created_by not null;
alter table href_dismissal_reasons modify created_on not null;
alter table href_dismissal_reasons modify modified_by not null;
alter table href_dismissal_reasons modify modified_on not null;
