prompt migr from 16.12.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt add comment for some tables

comment on table hln_question_groups   is 'Keeps properties about the question group. Question groups are used to separate questions into groups';
comment on table hln_question_types    is 'Keeps properties about the question type. Question types are used to separate questions into types';
comment on table hln_questions         is 'Keeps properties about the question. Questions to use for generate Exams';
comment on table hln_question_options  is 'Keeps properties about the options of question';
comment on table hln_exams             is 'Keeps properties about the exam. Exams are used to create testings';
comment on table hln_testings          is 'Keeps properties about the testing.';
comment on table hln_attestations      is 'Keeps properties about the attestation. Attestations are used to pass the test of a group of persons';
comment on table hln_training_subjects is 'Keeps properties about the training subject. Subjects are used to create training';
comment on table hln_trainings         is 'Keeps properties about the training. Trainins are used to pass the training of a group of persons';

----------------------------------------------------------------------------------------------------
prompt change GWS_DATA to GWS_INDEX in some table 

alter index hln_question_files_pk rebuild tablespace GWS_INDEX;
alter index hln_exams_pk rebuild tablespace GWS_INDEX;
alter index hln_exam_manual_questions_pk rebuild tablespace GWS_INDEX;
alter index hln_exam_patterns_pk rebuild tablespace GWS_INDEX;
alter index hln_pattern_question_types_pk rebuild tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
comment on column htt_gps_tracks.total_distance is 'total distance on track date, in meter(m)';

----------------------------------------------------------------------------------------------------
create table htt_hikvision_servers(
  server_id                       number(20)         not null,
  secret_code                     varchar2(120)      not null,
  name                            varchar2(150 char) not null,
  url                             varchar2(300 char),
  order_no                        number(6),
  constraint htt_hikvision_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint htt_hikvision_servers_u1 unique (secret_code) using index tablespace GWS_INDEX,
  constraint htt_hikvision_servers_c1 check (decode(trim(secret_code), secret_code, 1, 0) = 1),
  constraint htt_hikvision_servers_c2 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_hikvision_servers is 'Initially external hikvision servers will register application, this table stored this structure';

----------------------------------------------------------------------------------------------------
create table htt_company_hikvision_servers(
  company_id                      number(20) not null,
  server_id                       number(20) not null,
  constraint htt_company_hikvision_servers_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint htt_company_hikvision_servers_f1 foreign key (server_id) references htt_hikvision_servers(server_id)
) tablespace GWS_DATA;

comment on table htt_company_hikvision_servers is 'Company use registered servers for syncing hikvision devices, this table stored a company uses some servers';

create index htt_company_hikvision_servers_i1 on htt_company_hikvision_servers(server_id) tablespace GWS_INDEX;

create sequence htt_hikvision_servers_sq;

----------------------------------------------------------------------------------------------------
create table htt_hikvision_devices(
  company_id                      number(20)         not null,
  device_id                       number(20)         not null,
  dynamic_ip                      varchar2(1)        not null,
  ip_address                      varchar2(30),
  port                            varchar2(10),
  protocol                        varchar2(1),
  host                            varchar2(100),
  login                           varchar2(100 char) not null,
  password                        varchar2(100 char) not null,
  constraint htt_hikvision_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_hikvision_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_hikvision_devices_c1 check (dynamic_ip in ('Y', 'N')),
  constraint htt_hikvision_devices_c2 check (decode(trim(ip_address), ip_address, 1, 0) = 1),
  constraint htt_hikvision_devices_c3 check (decode(trim(port), port, 1, 0) = 1),
  constraint htt_hikvision_devices_c4 check (protocol in ('H', 'S')),
  constraint htt_hikvision_devices_c5 check (decode(trim(host), host, 1, 0) = 1),
  constraint htt_hikvision_devices_c6 check (dynamic_ip = 'Y' and ip_address is not null and port is not null and protocol is not null or
                                             dynamic_ip = 'N' and host is not null),
  constraint htt_hikvision_devices_c7 check (decode(trim(login), login, 1, 0) = 1),
  constraint htt_hikvision_devices_c8 check (decode(trim(password), password, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column htt_hikvision_devices.dynamic_ip is '(Y)es, (N)o';
comment on column htt_hikvision_devices.protocol is '(H)ttp, Http(S)';


---------------------------------------------------------------------------------------------------- 
create table htt_hikvision_tracks(
  company_id                      number(20)  not null,  
  track_id                        number(20)  not null,
  device_id                       number(20)  not null,
  person_id                       number(20)  not null,
  track_type                      varchar2(1) not null,
  track_datetime                  date        not null,
  mark_type                       varchar2(1) not null,
  status                          varchar2(1) not null,
  error_text                      varchar2(200 char),
  constraint htt_hikvision_tracks_pk primary key (company_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_hikvision_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_hikvision_tracks_u2 unique (company_id, device_id, person_id, track_type, track_datetime) using index tablespace GWS_INDEX,
  constraint htt_hikvision_tracks_f1 foreign key (company_id, person_id) references md_persons(company_id, person_id) on delete cascade,
  constraint htt_hikvision_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_hikvision_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_hikvision_tracks_c2 check (mark_type in ('T', 'F')),
  constraint htt_hikvision_tracks_c3 check (status in ('N',  'C', 'E'))
) tablespace GWS_DATA;

comment on column htt_hikvision_tracks.track_type    is '(I)nput, (O)utput, (C)heck';
comment on column htt_hikvision_tracks.mark_type     is '(T)ouch, (F)ace';
comment on column htt_hikvision_tracks.status        is '(N)ew, (C)omplete, (E)rror';

create index htt_hikvision_tracks_i1 on htt_hikvision_tracks(company_id, person_id) tablespace GWS_INDEX;

exec fazo_z.run('htt_hikvision_servers');
exec fazo_z.run('htt_company_hikvision_servers');
exec fazo_z.run('htt_hikvision_devices');
exec fazo_z.run('htt_hikvision_tracks');
