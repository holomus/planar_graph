prompt migr from 03.02.2023 (ddl)
----------------------------------------------------------------------------------------------------
prompt fix htt_location_types
----------------------------------------------------------------------------------------------------
comment on table htt_location_types is 'Keeps properties of type of locations. It is used to separate on types';

drop index htt_locations_types_u2;
create unique index htt_location_types_u2 on htt_location_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt rename htt_hikvision_servers to htt_acms_servers
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
prompt rename htt_company_hikvision_servers to htt_company_acms_servers
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
prompt new table htt_acms_commands
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
  constraint htt_commands_acms_pk primary key (company_id, command_id) using index tablespace GWS_INDEX,
  constraint htt_commands_acms_u1 unique (command_id) using index tablespace GWS_INDEX,
  constraint htt_commands_acms_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_commands_acms_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint htt_commands_acms_c1 check (command_kind in ('U', 'A', 'P', 'D', 'R', 'T')),
  constraint htt_commands_acms_c2 check (command_kind in ('P', 'R') and person_id is not null or command_kind in ('U', 'A', 'D', 'T') and person_id is null),
  constraint htt_commands_acms_c3 check (data is json),
  constraint htt_commands_acms_c4 check (status in ('N', 'S', 'C', 'F'))
) tablespace GWS_DATA;

comment on column htt_acms_commands.command_kind is '(U)pdate device, Update (A)ll Device Persons, Update (P)erson, Remove (D)evice, (R)emove Person, Sync (T)racks';
comment on column htt_acms_commands.status       is '(N)ew, (S)ent, (C)ompleted, (F)ailed';

create index htt_acms_commands_i1 on htt_acms_commands(company_id, device_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt new table htt_acms_commands
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
prompt rename htt_hikvision_servers_sq to htt_acms_servers_sq;
----------------------------------------------------------------------------------------------------
rename htt_hikvision_servers_sq to htt_acms_servers_sq;

----------------------------------------------------------------------------------------------------
prompt htt_requests changes
----------------------------------------------------------------------------------------------------
alter table htt_requests add approved_by number(20);
alter table htt_requests add completed_by number(20);

alter table htt_requests rename constraint htt_requests_f3 to htt_requests_f5;
alter table htt_requests rename constraint htt_requests_f4 to htt_requests_f6;

alter table htt_requests add constraint htt_requests_f3 foreign key (company_id, approved_by) references md_users(company_id, user_id);
alter table htt_requests add constraint htt_requests_f4 foreign key (company_id, completed_by) references md_users(company_id, user_id);

alter index htt_requests_i3 rename to htt_requests_i5;
alter index htt_requests_i4 rename to htt_requests_i6;

create index htt_requests_i3 on htt_requests(company_id, approved_by) tablespace GWS_INDEX;
create index htt_requests_i4 on htt_requests(company_id, completed_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt htt_plan_changes changes
----------------------------------------------------------------------------------------------------
alter table htt_plan_changes add approved_by number(20);
alter table htt_plan_changes add completed_by number(20);

alter table htt_plan_changes rename constraint htt_plan_changes_f2 to htt_plan_changes_f4;
alter table htt_plan_changes rename constraint htt_plan_changes_f3 to htt_plan_changes_f5;

alter table htt_plan_changes add constraint htt_plan_changes_f2 foreign key (company_id, approved_by) references md_users(company_id, user_id);
alter table htt_plan_changes add constraint htt_plan_changes_f3 foreign key (company_id, completed_by) references md_users(company_id, user_id);

alter index htt_plan_changes_i2 rename to htt_plan_changes_i4;
alter index htt_plan_changes_i3 rename to htt_plan_changes_i5;

create index htt_plan_changes_i2 on htt_plan_changes(company_id, approved_by) tablespace GWS_INDEX;
create index htt_plan_changes_i3 on htt_plan_changes(company_id, completed_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new htt_acms_commands_sq sequence
----------------------------------------------------------------------------------------------------
create sequence htt_acms_commands_sq;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run()
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_location_types');
exec fazo_z.run('htt_acms_servers');
exec fazo_z.run('htt_company_acms_servers');
exec fazo_z.run('htt_acms_commands');
exec fazo_z.run('htt_acms_tracks');
exec fazo_z.Run('htt_requests');
exec fazo_z.Run('htt_plan_changes');
