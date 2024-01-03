prompt Zktime module
prompt (c) 2021 Verifix HR

----------------------------------------------------------------------------------------------------  
create table hzk_devices(
  company_id                      number(20) not null,
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
  constraint hzk_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint hzk_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------  
create table hzk_person_fprints(
  company_id                      number(20)     not null,
  person_id                       number(20)     not null,
  finger_no                       number(20)     not null,
  tmp                             varchar2(4000) not null,
  constraint hzk_person_fprints_pk primary key (company_id, person_id, finger_no) using index tablespace GWS_INDEX,
  constraint hzk_person_fprints_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_device_persons(
  company_id                      number(20) not null,
  device_id                       number(20) not null,
  person_id                       number(20) not null,
  constraint hzk_device_persons_pk primary key (company_id, device_id, person_id) using index tablespace GWS_INDEX,
  constraint hzk_device_persons_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade,
  constraint hzk_device_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
) tablespace GWS_DATA;

create index hzk_device_persons_i1 on hzk_device_persons(company_id, person_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_device_fprints(
  company_id                      number(20) not null,
  device_id                       number(20) not null,
  person_id                       number(20) not null,
  finger_no                       number(20) not null,
  constraint hzk_device_fprints_pk primary key (company_id, device_id, person_id, finger_no) using index tablespace GWS_INDEX,
  constraint hzk_device_fprints_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade,
  constraint hzk_device_fprints_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hzk_device_fprints_f3 foreign key (company_id, person_id, finger_no) references hzk_person_fprints(company_id, person_id, finger_no)
) tablespace GWS_DATA;

create index hzk_device_fprints_i1 on hzk_device_fprints(company_id, person_id, finger_no) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------     
create table hzk_commands(
  company_id                      number(20)     not null,
  command_id                      number(20)     not null,
  device_id                       number(20)     not null,
  command                         varchar2(4000),
  command_clob                    clob,
  state                           varchar2(1)    not null,
  state_changed_on                date           not null,
  constraint hzk_commands_pk primary key (company_id, command_id) using index tablespace GWS_INDEX,
  constraint hzk_commands_u1 unique (command_id) using index tablespace GWS_INDEX,
  constraint hzk_commands_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade,
  constraint hzk_commands_c1 check (nvl2(command, 1, 0) = nvl2(command_clob, 0, 1)),
  constraint hzk_commands_c2 check (state in ('N', 'S', 'C'))
) tablespace GWS_DATA;

comment on column hzk_commands.state is '(N)ew, (S)ent, (C)omplate';

create index hzk_commands_i1 on hzk_commands(company_id, device_id) tablespace GWS_DATA;
       
----------------------------------------------------------------------------------------------------
create table hzk_errors(
  error                           varchar2(4000) not null,
  created_on                      date           not null
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table hzk_attlog_errors(
 company_id                       number(20)     not null,
 error_id                         number(20)     not null,
 device_id                        number(20)     not null,
 command                          varchar2(4000) not null,
 error                            varchar2(4000) not null,
 status                           varchar2(1)    not null,
 constraint hzk_attlog_errors_pk primary key (company_id, error_id) using index tablespace GWS_INDEX,
 constraint hzk_attlog_errors_u1 unique (error_id) using index tablespace GWS_INDEX,
 constraint hzk_attlog_errors_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id),
 constraint hzk_attlog_errors_c1 check (status in ('N', 'D'))
) tablespace GWS_DATA;

comment on column hzk_attlog_errors.status is '(N)ew, (D)one';

create index hzk_attlog_errors_i1 on hzk_attlog_errors(company_id, device_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hzk_migr_persons(
  company_id                      number(20)         not null,
  migr_person_id                  number(20)         not null, 
  device_id                       number(20)         not null,
  pin                             varchar2(20)       not null,
  person_name                     varchar2(250 char) not null,
  person_role                     varchar2(1)        not null,
  password                        varchar2(8),
  rfid_code                       varchar2(10),
  constraint hzk_migr_persons_pk primary key (company_id, migr_person_id) using index tablespace GWS_INDEX,
  constraint hzk_migr_persons_u1 unique (migr_person_id) using index tablespace GWS_INDEX,
  constraint hzk_migr_persons_u2 unique (company_id, device_id, pin) using index tablespace GWS_INDEX,
  constraint hzk_migr_persons_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id),
  constraint hzk_migr_persons_c1 check (regexp_like(pin, '^\d+$'))
) tablespace GWS_DATA;

comment on column hzk_migr_persons.person_role is '(N)ormal user, (A)dmin';

----------------------------------------------------------------------------------------------------
create table hzk_migr_fprints(
  company_id                      number(20)     not null,
  device_id                       number(20)     not null,
  pin                             varchar2(20)   not null,
  finger_no                       number(20)     not null,
  tmp                             varchar2(4000) not null,
  constraint hzk_migr_fprints_pk primary key (company_id, device_id, pin, finger_no) using index tablespace GWS_INDEX,
  constraint hzk_migr_fprints_c1 check (regexp_like(pin, '^\d+$'))
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hzk_migr_tracks(
  company_id                      number(20)   not null,
  migr_track_id                   number(20)   not null,
  pin                             varchar2(20) not null,
  device_id                       number(20)   not null,
  location_id                     number(20)   not null,
  track_type                      varchar2(1)  not null,
  track_time                      timestamp with local time zone not null,
  track_date                      date         not null,
  mark_type                       varchar2(1)  not null,
  constraint hzk_migr_tracks_pk primary key (company_id, migr_track_id) using  index tablespace GWS_INDEX,
  constraint hzk_migr_tracks_u1 unique (migr_track_id) using index tablespace GWS_INDEX,
  constraint hzk_migr_tracks_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id),
  constraint hzk_migr_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id),
  constraint hzk_migr_tracks_c1 check (track_type in ('I', 'O')),
  constraint hzk_migr_tracks_c2 check (mark_type in ('P', 'B', 'F', 'T')),
  constraint hzk_migr_tracks_c3 check (regexp_like(pin, '^\d+$'))
) tablespace GWS_DATA;

comment on column hzk_migr_tracks.track_type is '(I)nput, (O)utput';
comment on column hzk_migr_tracks.mark_type is '(P)assword, (B)arcode, (F)ace, (T)ouch';

create index hzk_migr_tracks_i1 on hzk_migr_tracks(company_id, device_id) tablespace GWS_DATA;
create index hzk_migr_tracks_i2 on hzk_migr_tracks(company_id, location_id) tablespace GWS_DATA;
