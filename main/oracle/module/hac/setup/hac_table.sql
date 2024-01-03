prompt Verifix Access Control management systems integrations
---------------------------------------------------------------------------------------------------- 
create table hac_device_types(
  device_type_id                  number(20)         not null,
  name                            varchar2(100 char) not null,
  pcode                           varchar2(20)       not null,
  constraint hac_device_types_pk primary key (device_type_id) using index tablespace GWS_INDEX,
  constraint hac_device_types_u1 unique (pcode) using index tablespace GWS_INDEX,
  constraint hac_device_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hac_device_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table hac_device_types is 'ACMS device types. Dahua, Hikvision, etc.';

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
create table hac_servers(
  server_id                   number(20)         not null,
  host_url                    varchar2(300 char) not null,
  name                        varchar2(300 char) not null,
  order_no                    number(20),
  constraint hac_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint hac_servers_u1 unique (host_url) using index tablespace GWS_INDEX,
  constraint hac_servers_c1 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table hac_servers is 'ACMS service servers. Dahua, Hikvision, etc.';

---------------------------------------------------------------------------------------------------- 
create table hac_devices(
  device_id                   number(20)         not null,
  server_id                   number(20)         not null,
  device_type_id              number(20)         not null,
  location                    varchar2(100 char),
  device_name                 varchar2(100 char) not null,
  device_ip                   varchar2(100 char),
  device_mac                  varchar2(100),
  login                       varchar2(50),
  password                    varchar2(100),
  ready                       varchar2(1)        not null,
  status                      varchar2(1)        not null,
  constraint hac_devices_pk primary key (server_id, device_id) using index tablespace GWS_INDEX,
  constraint hac_devices_u1 unique (device_id) using index tablespace GWS_INDEX,
  constraint hac_devices_u2 unique (server_id, device_name) using index tablespace GWS_INDEX,
  constraint hac_devices_f1 foreign key (server_id) references hac_servers(server_id),
  constraint hac_devices_f2 foreign key (device_type_id) references hac_device_types(device_type_id),
  constraint hac_devices_c1 check (status in ('F', 'O', 'U')),
  constraint hac_devices_c2 check (ready in ('Y', 'N'))
) tablespace GWS_DATA; 

comment on table hac_devices is 'Acms devices available in Verifix';

comment on column hac_devices.status is 'O(F)fline, (O)nline, (U)nknown';
comment on column hac_devices.ready  is 'Ready for use? (Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table hac_device_event_types(
  server_id                   number(20)  not null,
  device_id                   number(20)  not null,
  device_type_id              number(20)  not null,
  event_type_code             number(20)  not null,
  constraint hac_device_event_types_pk primary key (server_id, device_id, device_type_id, event_type_code) using index tablespace GWS_DATA,
  constraint hac_device_event_types_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade,
  constraint hac_device_event_types_f2 foreign key (device_type_id, event_type_code) references hac_event_types(device_type_id, event_type_code) on delete cascade
) tablespace GWS_DATA; 

---------------------------------------------------------------------------------------------------- 
create table hac_company_devices(
  company_id                  number(20)  not null,
  device_id                   number(20)  not null,
  attach_kind                 varchar2(1) not null,
  constraint hac_company_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint hac_company_devices_f1 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_company_devices_f2 foreign key (device_id) references hac_devices(device_id) on delete cascade,
  constraint hac_company_devices_c1 check (attach_kind in ('P', 'S'))
) tablespace GWS_DATA;

comment on column hac_company_devices.attach_kind is '(P)rimary, (S)econdary';

create index hac_company_devices_i1 on hac_company_devices(device_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- DAHUA SECURITY SYSTEM (DSS) integration
----------------------------------------------------------------------------------------------------
create table hac_dss_servers(
  server_id                   number(20)         not null,
  username                    varchar2(300 char) not null,
  password                    varchar2(300 char) not null,
  constraint hac_dss_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint hac_dss_servers_f1 foreign key (server_id) references hac_servers(server_id) on delete cascade
) tablespace GWS_DATA;

comment on table hac_dss_servers is 'Dahua Security System (DSS) service servers';

comment on column hac_dss_servers.username is 'username used for logon at DSS';
comment on column hac_dss_servers.password is 'password used for logon at DSS';

----------------------------------------------------------------------------------------------------
create table hac_dss_company_servers(
  company_id                  number(20) not null,
  server_id                   number(20) not null,
  department_code             varchar2(300 char),
  person_group_code           varchar2(300 char),
  constraint hac_dss_company_servers_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint hac_dss_company_servers_f1 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_dss_company_servers_f2 foreign key (server_id) references hac_dss_servers(server_id)
) tablespace GWS_DATA;

comment on table hac_dss_company_servers is 'Verifix companies binded to DSS server';

comment on column hac_dss_company_servers.department_code   is 'ID of organization accotiated with this company at DSS. Shown as "orgCode" in some routes';
comment on column hac_dss_company_servers.person_group_code is 'ID of person group accotiated with this company at DSS. Shown as "orgCode" in some routes';

create unique index hac_dss_company_server_u1 on hac_dss_company_servers(nvl2(person_group_code, server_id, null), person_group_code) tablespace GWS_INDEX;
create unique index hac_dss_company_server_u2 on hac_dss_company_servers(nvl2(department_code, server_id, null), department_code) tablespace GWS_INDEX;

create index hac_dss_company_server_i1 on hac_dss_company_servers(server_id) tablespace GWS_INDEX;
create index hac_dss_company_server_i2 on hac_dss_company_servers(server_id, person_group_code) tablespace GWS_INDEX;
create index hac_dss_company_server_i3 on hac_dss_company_servers(server_id, department_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_dss_devices(
  server_id                   number(20)         not null,
  device_id                   number(20)         not null,
  serial_number               varchar2(100 char),
  device_code                 varchar2(300 char),
  access_group_code           varchar2(300 char),
  constraint hac_dss_devices_pk primary key (server_id, device_id) using index tablespace GWS_INDEX,
  constraint hac_dss_devices_u1 unique (serial_number) using index tablespace GWS_INDEX,
  constraint hac_dss_devices_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade
) tablespace GWS_DATA;

comment on table hac_dss_devices is 'Dahua devices available in Verifix';

comment on column hac_dss_devices.access_group_code is 'ID for access_permission_group generated by DSS service';

create unique index hac_dss_devices_u3 on hac_dss_devices(nvl2(device_code,       server_id, null), device_code) tablespace GWS_INDEX;
create unique index hac_dss_devices_u4 on hac_dss_devices(nvl2(access_group_code, server_id, null), access_group_code) tablespace GWS_INDEX;

create index hac_dss_devices_i1 on hac_dss_devices(server_id, device_code) tablespace GWS_INDEX;
create index hac_dss_devices_i2 on hac_dss_devices(server_id, access_group_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_dss_ex_devices(
  server_id                   number(20) not null,
  device_code                 varchar2(300 char) not null,
  register_code               varchar2(300 char),
  department_code             varchar2(300 char),
  device_name                 varchar2(300 char),
  device_ip                   varchar2(300 char),
  serial_number               varchar2(300 char),
  extra_info                  varchar2(4000 char),
  status                      varchar2(1),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_dss_ex_devices_pk primary key (server_id, device_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_dss_ex_devices is 'Keeps result of last get device request';

create unique index hac_dss_ex_devices_u1 on hac_dss_ex_devices(nvl2(register_code, server_id, null), register_code) tablespace GWS_INDEX;

create index hac_dss_ex_devices_i1 on hac_dss_ex_devices(server_id, register_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_dss_ex_access_groups(
  server_id                   number(20)         not null,
  access_group_code           varchar2(300 char) not null,
  access_group_name           varchar2(300 char) not null,
  person_count                number(20),
  extra_info                  varchar2(4000 char),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_dss_ex_access_groups_pk primary key (server_id, access_group_code) using index tablespace GWS_INDEX,
  constraint hac_dss_ex_access_groups_u1 unique (server_id, access_group_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_dss_ex_access_groups is 'Keeps result of last get access group request';

----------------------------------------------------------------------------------------------------
create table hac_dss_ex_departments(
  server_id                   number(20)         not null,
  department_code             varchar2(300 char) not null,
  department_name             varchar2(300 char) not null,
  extra_info                  varchar2(4000 char),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_dss_ex_departments_pk primary key (server_id, department_code) using index tablespace GWS_INDEX,
  constraint hac_dss_ex_departments_u1 unique (server_id, department_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_dss_ex_departments is 'Keeps result of last get department request';

----------------------------------------------------------------------------------------------------
create table hac_dss_ex_person_groups(
  server_id                   number(20)         not null,
  person_group_code           varchar2(300 char) not null,
  person_group_name           varchar2(300 char) not null,
  extra_info                  varchar2(4000 char),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_dss_ex_person_groups_pk primary key (server_id, person_group_code) using index tablespace GWS_INDEX,
  constraint hac_dss_ex_person_groups_u1 unique (server_id, person_group_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_dss_ex_access_groups is 'Keeps result of last get person group request';

----------------------------------------------------------------------------------------------------
create table hac_dss_ex_persons(
  server_id                 number(20)         not null,
  person_group_code         varchar2(300 char) not null,
  person_code               varchar2(300 char) not null,
  first_name                varchar2(300 char),
  last_name                 varchar2(300 char),
  photo_url                 varchar2(300 char),
  photo_sha                 varchar2(64),
  rfid_code                 varchar2(20),
  extra_info                varchar2(4000),
  created_on                timestamp with local time zone not null,
  modified_on               timestamp with local time zone not null,
  constraint hac_dss_ex_persons_pk primary key (server_id, person_group_code, person_code) using index tablespace GWS_INDEX,
  constraint hac_dss_ex_persons_f1 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- HikCentral integration
----------------------------------------------------------------------------------------------------
create table hac_hik_servers(
  server_id                   number(20)         not null,
  partner_key                 varchar2(300 char) not null,
  partner_secret              varchar2(300 char) not null,
  token                       varchar2(64 char)  not null,
  constraint hac_hik_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint hac_hik_servers_u1 unique (token) using index tablespace GWS_INDEX,
  constraint hac_hik_servers_f1 foreign key (server_id) references hac_servers(server_id) on delete cascade
) tablespace GWS_DATA;

comment on table hac_hik_servers is 'Hikcentral service servers';

comment on column hac_hik_servers.partner_key    is 'Used to generate signature for api requests';
comment on column hac_hik_servers.partner_secret is 'Used to generate signature for api requests';
comment on column hac_hik_servers.token          is 'Used to authenticate event notifications';

----------------------------------------------------------------------------------------------------
create table hac_hik_company_servers(
  company_id                  number(20) not null,
  server_id                   number(20) not null,
  organization_code           varchar2(300 char),
  constraint hac_hik_company_servers_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint hac_hik_company_servers_f1 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_hik_company_servers_f2 foreign key (server_id) references hac_hik_servers(server_id)
) tablespace GWS_DATA;

comment on table hac_hik_company_servers is 'Verifix companies binded to Hikcentral server';

comment on column hac_hik_company_servers.organization_code is 'ID of organization accotiated with this company at Hikcentral';

create index hac_hik_company_servers_i1 on hac_hik_company_servers(server_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_hik_devices(
  server_id                   number(20)        not null,
  device_id                   number(20)        not null,
  isup_password               varchar2(32 char) not null,
  ignore_tracks               varchar2(1)       not null,
  serial_number               varchar2(100 char),
  device_code                 varchar2(300 char),
  door_code                   varchar2(300 char),
  access_level_code           varchar2(300 char),
  constraint hac_hik_devices_pk primary key (server_id, device_id) using index tablespace GWS_INDEX,
  constraint hac_hik_devices_u1 unique (serial_number) using index tablespace GWS_INDEX,
  constraint hac_hik_devices_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade,
  constraint hac_hik_devices_c1 check (ignore_tracks in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hac_hik_devices is 'Hikvision devices available at Verifix';

comment on column hac_hik_devices.isup_password is 'Used by Hikcentral to authorize device';
comment on column hac_hik_devices.ignore_tracks is '(Y)es, (N)o';

create unique index hac_hik_devices_u2 on hac_hik_devices(nvl2(device_code,       server_id, null), device_code) tablespace GWS_INDEX;
create unique index hac_hik_devices_u3 on hac_hik_devices(nvl2(door_code,         server_id, null), door_code) tablespace GWS_INDEX;
create unique index hac_hik_devices_u4 on hac_hik_devices(nvl2(access_level_code, server_id, null), access_level_code) tablespace GWS_INDEX;

create index hac_hik_devices_i1 on hac_hik_devices(server_id, device_code) tablespace GWS_INDEX;
create index hac_hik_devices_i2 on hac_hik_devices(server_id, door_code) tablespace GWS_INDEX;
create index hac_hik_devices_i3 on hac_hik_devices(server_id, access_level_code) tablespace GWS_INDEX; 

---------------------------------------------------------------------------------------------------- 
create table hac_hik_listening_devices(
  device_token                varchar2(128)      not null,
  serial_number               varchar2(100 char) not null,
  company_id                  number(20)         not null,
  person_auth_type            varchar2(1)        not null,
  constraint hac_hik_listening_devices_pk primary key (device_token) using index tablespace GWS_INDEX,
  constraint hac_hik_listening_devices_u2 unique (serial_number) using index tablespace GWS_INDEX,
  constraint hac_hik_listening_devices_f1 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_hik_listening_devices_c1 check (person_auth_type in ('E', 'P'))
) tablespace GWS_DATA;

comment on table hac_hik_listening_devices is 'Hikvision devices using Verifix Hik listening service';

create index hac_hik_listening_devices_i1 on hac_hik_listening_devices(company_id);

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_devices(
  server_id                   number(20)         not null,
  device_code                 varchar2(300 char) not null,
  device_name                 varchar2(300 char) not null,
  device_ip                   varchar2(100 char),
  device_port                 varchar2(100 char),
  treaty_type                 varchar2(100 char),
  serial_number               varchar2(100 char),
  status                      varchar2(1),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,  
  constraint hac_hik_ex_devices_pk primary key (server_id, device_code) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_devices_u1 unique (server_id, device_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_ex_devices is 'Keeps result of last get devices request';

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_doors(
  server_id                   number(20)         not null,
  door_code                   varchar2(300 char) not null,
  door_name                   varchar2(300 char) not null,
  door_no                     varchar2(10),
  device_code                 varchar2(300 char) not null,
  region_code                 varchar2(300 char),
  door_state                  varchar2(1),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_hik_ex_doors_pk primary key (server_id, door_code) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_doors_u1 unique (server_id, device_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_ex_doors is 'Keeps result of last get doors request';

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_access_levels(
  server_id                   number(20)         not null,
  access_level_code           varchar2(300 char) not null,
  access_level_name           varchar2(300 char) not null,
  description                 varchar2(300 char),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_hik_ex_access_levels_pk primary key (server_id, access_level_code) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_access_levels_u1 unique (server_id, access_level_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_ex_access_levels is 'Keeps result of last get access levels request';

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_organizations(
  server_id                   number(20)         not null,
  organization_code           varchar2(300 char) not null,
  organization_name           varchar2(300 char) not null,
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_hik_ex_organizations_pk primary key (server_id, organization_code) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_organizations_u1 unique (server_id, organization_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_ex_organizations is 'Keeps result of last get organizations request';

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_events(
  server_id                   number(20)          not null,
  door_code                   varchar2(300 char)  not null,
  person_code                 varchar2(300 char)  not null,
  event_time                  timestamp with local time zone not null,
  event_type                  varchar2(1)         not null,
  event_code                  varchar2(300 char)  not null,
  check_in_and_out_type       number              not null,
  event_type_code             number              not null,
  door_name                   varchar2(1000 char),
  src_type                    varchar2(1000 char),
  status                      number,
  card_no                     varchar2(1000 char),
  person_name                 varchar2(1000 char),
  person_type                 varchar2(1000 char),
  pic_uri                     varchar2(1000 char),
  pic_sha                     varchar2(64),
  device_time                 varchar2(1000 char),
  reader_code                 varchar2(1000 char),
  reader_name                 varchar2(1000 char),
  extra_info                  varchar2(4000),
  created_on                  timestamp with local time zone not null,
  constraint hac_hik_ex_events_pk primary key (server_id, door_code, person_code, event_time) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_events_c1 check(event_type in ('N', 'M', 'J'))
) tablespace GWS_DATA;

comment on table hac_hik_ex_events is 'Keeps raw event data from Hikvision';

comment on column hac_hik_ex_events.event_time  is 'Comes with key "happenTime" in notifications and with key "eventTime" in manual retrieval';
comment on column hac_hik_ex_events.src_type    is 'Comes in notifications only';
comment on column hac_hik_ex_events.door_name   is 'Comes with key "src_name" in notifications and with key "doorName" in manual retrieval';
comment on column hac_hik_ex_events.status      is 'Comes in notifications only';
comment on column hac_hik_ex_events.person_name is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.person_type is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.device_time is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.event_type  is 'N - received from (N)otifications, M - (M)anually retrieved, J - loaded by (J)ob';

----------------------------------------------------------------------------------------------------
create table hac_hik_device_listener_events(
  event_id                    number(20) not null,
  device_token                varchar2(300 char),
  device_code                 varchar2(300 char),
  mac_address                 varchar2(300 char),
  event_time                  timestamp with local time zone,
  person_code                 varchar2(300 char),
  event_type                  varchar2(300 char),
  major_event_type            varchar2(300 char),
  sub_event_type              varchar2(300 char),
  attendance_status           varchar2(300 char),
  pic_sha                     varchar2(300 char), 
  extra_info                  varchar2(4000),
  created_on                  timestamp with local time zone not null,
  constraint hac_hik_device_listener_events_pk primary key (event_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_device_listener_events is 'Keeps raw event data from Hikvision Device Listener';

----------------------------------------------------------------------------------------------------
create table hac_hik_ex_persons(
  server_id                 number(20)         not null,
  organization_code         varchar2(300 char) not null,
  person_code               varchar2(300 char) not null,
  external_code             varchar2(300 char) not null,
  first_name                varchar2(300 char),
  last_name                 varchar2(300 char),
  photo_url                 varchar2(300 char),
  photo_sha                 varchar2(64),
  rfid_code                 varchar2(20),
  extra_info                varchar2(4000),
  created_on                timestamp with local time zone not null,
  modified_on               timestamp with local time zone not null,
  constraint hac_hik_ex_persons_pk primary key (server_id, organization_code, person_code) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_persons_f1 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- ACMS PERSONS
----------------------------------------------------------------------------------------------------
create table hac_server_persons(
  server_id                   number(20)         not null,
  company_id                  number(20)         not null,
  person_id                   number(20)         not null,
  person_code                 varchar2(300 char),
  external_code               varchar2(16 char),
  first_name                  varchar2(250 char),
  last_name                   varchar2(250 char),
  photo_sha                   varchar2(64),
  rfid_code                   varchar2(20),
  constraint hac_server_persons_pk primary key (server_id, company_id, person_id) using index tablespace GWS_INDEX,
  constraint hac_server_persons_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hac_server_persons_f2 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_server_persons_f3 foreign key (server_id) references hac_servers(server_id) on delete cascade,
  constraint hac_server_persons_f4 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

comment on table hac_server_persons is 'Persons uploaded to ACMS Server';

comment on column hac_server_persons.person_code   is 'External Acms ID for person';
comment on column hac_server_persons.external_code is 'External Acms Code for person (in Hikvision)';
comment on column hac_server_persons.first_name    is 'First name that was send to acms server';
comment on column hac_server_persons.last_name     is 'Last name that was send to acms server';
comment on column hac_server_persons.photo_sha     is 'Photo sha that was send to acms server';
comment on column hac_server_persons.rfid_code     is 'Rfid card No that was send to acms server';

create unique index hac_server_persons_u1 on hac_server_persons(nvl2(person_code, server_id, null), nvl2(person_code, company_id, null), person_code) tablespace GWS_INDEX;
create unique index hac_server_persons_u2 on hac_server_persons(nvl2(external_code, server_id, null), nvl2(external_code, company_id, null), external_code) tablespace GWS_INDEX;

create index hac_server_persons_i1 on hac_server_persons(company_id, person_id) tablespace GWS_INDEX;
create index hac_server_persons_i2 on hac_server_persons(photo_sha) tablespace GWS_INDEX;
create index hac_server_persons_i3 on hac_server_persons(server_id, company_id, person_code) tablespace GWS_INDEX;
create index hac_server_persons_i4 on hac_server_persons(server_id, company_id, external_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_device_persons(
  server_id                    number(20) not null,
  company_id                   number(20) not null,
  device_id                    number(20) not null,
  person_id                    number(20) not null,
  constraint hac_device_persons_pk primary key (server_id, company_id, device_id, person_id) using index tablespace GWS_INDEX,
  constraint hac_device_persons_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade,
  constraint hac_device_persons_f2 foreign key (server_id, company_id, person_id) references hac_server_persons(server_id, company_id, person_id) on delete cascade
) tablespace GWS_DATA;

comment on table hac_device_persons is 'Persons attached to ACMS device on Some server';

create index hac_device_persons_i1 on hac_device_persons(server_id, device_id) tablespace GWS_INDEX;
create index hac_device_persons_i2 on hac_device_persons(server_id, company_id, person_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_dss_tracks(
  host_url                  varchar2(300 char)  not null,
  person_code               varchar2(300 char)  not null,
  device_code               varchar2(300 char)  not null,
  track_time                varchar2(300 char)  not null,
  source_type               varchar2(1)         not null,
  photo_url                 varchar2(300 char),
  photo_sha                 varchar2(64),
  event_type_code           number(20),                
  extra_info                varchar2(4000 char),
  constraint hac_dss_tracks_pk primary key (host_url, person_code, device_code, track_time) using index tablespace GWS_INDEX,
  constraint hac_dss_tracks_f1 foreign key (photo_sha) references biruni_files(sha),
  constraint hac_dss_tracks_c1 check(source_type in ('M', 'Q', 'J'))
) tablespace GWS_DATA;

comment on column hac_dss_tracks.source_type is '(M)essage, (Q)ueue, (J)ob';

comment on column hac_dss_tracks.track_time is 'Time is seconds in unix timestamp format';

create index hac_dss_tracks_i1 on hac_dss_tracks(photo_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hac_error_log(
  log_id                   number(20)     not null,
  request_params           varchar2(4000) not null,
  error_message            varchar2(4000) not null,
  created_on               timestamp with local time zone not null,
  constraint hac_error_log_pk primary key (log_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_error_log is 'Errors from requests to dahua and hikvision servers';

-----------------------------------------------------------------------------------------------------
create table hac_sync_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint hac_sync_persons_pk primary key (company_id, person_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_sync_persons is 'Persons that need to be synchronised with devices';

-----------------------------------------------------------------------------------------------------
create global temporary table hac_dirty_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint hac_dirty_persons_u1 unique (company_id, person_id),
  constraint hac_dirty_persons_c1 check (person_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------    
-- These 3 table use for Update Status Devices. These tables Temporary Keeps Currenct Device Infos 
--------------------------------------------------    
create table hac_temp_ex_hik_device_infos( 
  device_code      varchar2(300 char),
  server_id        number(20),
  constraint hac_temp_ex_hik_device_infos_pk primary key (device_code, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

--------------------------------------------------     
create table hac_temp_ex_dss_device_infos(
  device_code      varchar2(300 char),
  server_id        number(20),
  constraint hac_temp_ex_dss_device_infos_pk primary key (device_code, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

--------------------------------------------------    
create table hac_temp_device_infos(
  device_id        number(20),
  server_id        number(20),
  constraint hac_temp_device_infos_pk primary key (device_id, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;
