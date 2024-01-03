prompt migr from 01.05.2023 v2.23.1 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt Verifix Access Control management systems integrations sequences
----------------------------------------------------------------------------------------------------
create sequence hac_device_types_sq;
create sequence hac_servers_sq;
create sequence hac_devices_sq;
create sequence hac_error_log_sq;
---------------------------------------------------------------------------------------------------- 
-- used to generate unique names for dss service
-- since we are not deleting any data from dss service right now
create sequence hac_dss_names_sq;

----------------------------------------------------------------------------------------------------
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
  device_name                 varchar2(100 char) not null,
  device_ip                   varchar2(100 char),
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

comment on column hac_dss_devices.register_code     is 'UID used in DSS service and Dahua device';
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
  extra_info                varchar2(4000),
  created_on                  timestamp with local time zone not null,
  modified_on                 timestamp with local time zone not null,
  constraint hac_dss_ex_persons_pk primary key (server_id, person_group_code, person_code) using index tablespace GWS_INDEX,
  constraint hac_dss_ex_persons_f1 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- HikCentral integration
----------------------------------------------------------------------------------------------------
create table hac_hik_servers(
  server_id                   number(20) not null,
  partner_key                 varchar2(300 char) not null,
  partner_secret              varchar2(300 char) not null,
  constraint hac_hik_servers_pk primary key (server_id) using index tablespace GWS_INDEX,
  constraint hac_hik_servers_f1 foreign key (server_id) references hac_servers(server_id) on delete cascade
) tablespace GWS_DATA;

comment on table hdh_dss_servers is 'Hikcentral service servers';

comment on column hac_hik_servers.partner_key    is 'Used to generate signature for api requests';
comment on column hac_hik_servers.partner_secret is 'Used to generate signature for api requests';

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
  server_id                   number(20)         not null,
  device_id                   number(20)         not null,
  isup_device_code            varchar2(300 char) not null,
  isup_password               varchar2(300 char) not null,
  serial_number               varchar2(100 char),
  device_code                 varchar2(300 char),
  door_code                   varchar2(300 char),
  access_level_code           varchar2(300 char),
  constraint hac_hik_devices_pk primary key (server_id, device_id) using index tablespace GWS_INDEX,
  constraint hac_hik_devices_u1 unique (server_id, isup_device_code) using index tablespace GWS_INDEX,
  constraint hac_hik_devices_u2 unique (serial_number) using index tablespace GWS_INDEX,
  constraint hac_hik_devices_f1 foreign key (server_id, device_id) references hac_devices(server_id, device_id) on delete cascade
) tablespace GWS_DATA;

comment on table hac_hik_devices is 'Hikvision devices available at Verifix';

comment on column hac_hik_devices.isup_device_code is 'Used by Hikcentral to authorize device';
comment on column hac_hik_devices.isup_password    is 'Used by Hikcentral to authorize device';

create unique index hac_hik_devices_u3 on hac_hik_devices(nvl2(device_code,       server_id, null), device_code) tablespace GWS_INDEX;
create unique index hac_hik_devices_u4 on hac_hik_devices(nvl2(door_code,         server_id, null), door_code) tablespace GWS_INDEX;
create unique index hac_hik_devices_u5 on hac_hik_devices(nvl2(access_level_code, server_id, null), access_level_code) tablespace GWS_INDEX;

create index hac_hik_devices_i1 on hac_hik_devices(server_id, device_code) tablespace GWS_INDEX;
create index hac_hik_devices_i2 on hac_hik_devices(server_id, door_code) tablespace GWS_INDEX;
create index hac_hik_devices_i3 on hac_hik_devices(server_id, access_level_code) tablespace GWS_INDEX;

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
  constraint hac_hik_ex_doors_u1 unique (server_id, door_name) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_hik_ex_doors is 'Keeps result of last get doors request';

create index hac_hik_ex_doors_i1 on hac_hik_ex_doors(server_id, device_code) tablespace GWS_INDEX;

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
-- ACMS PERSONS
----------------------------------------------------------------------------------------------------
create table hac_server_persons(
  server_id                   number(20)         not null,
  company_id                  number(20)         not null,
  person_id                   number(20)         not null,
  person_code                 varchar2(300 char),
  first_name                  varchar2(250 char),
  last_name                   varchar2(250 char),
  photo_sha                   varchar2(64),
  constraint hac_server_persons_pk primary key (server_id, company_id, person_id) using index tablespace GWS_INDEX,
  constraint hac_server_persons_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hac_server_persons_f2 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hac_server_persons_f3 foreign key (server_id) references hac_servers(server_id) on delete cascade,
  constraint hac_server_persons_f4 foreign key (photo_sha) references biruni_files(sha)
) tablespace GWS_DATA;

comment on table hac_server_persons is 'Persons uploaded to ACMS Server';

comment on column hac_server_persons.person_code is 'External Acms ID for person';
comment on column hac_server_persons.first_name  is 'First name that was send to acms server';
comment on column hac_server_persons.last_name   is 'Last name that was send to acms server';
comment on column hac_server_persons.photo_sha   is 'Photo sha that was send to acms server';

create unique index hac_server_persons_u1 on hac_server_persons(nvl2(person_code, server_id, null), nvl2(person_code, company_id, null), person_code) tablespace GWS_INDEX;

create index hac_server_persons_i1 on hac_server_persons(company_id, person_id) tablespace GWS_INDEX;
create index hac_server_persons_i2 on hac_server_persons(photo_sha) tablespace GWS_INDEX;
create index hac_server_persons_i3 on hac_server_persons(server_id, company_id, person_code) tablespace GWS_INDEX;

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
  extra_info                varchar2(4000 char),
  constraint hac_dss_tracks_pk primary key (host_url, person_code, device_code, track_time) using index tablespace GWS_INDEX,
  constraint hac_dss_tracks_c1 check(source_type in ('M', 'Q', 'J'))
) tablespace GWS_DATA;

comment on column hac_dss_tracks.source_type is '(M)essage, (Q)ueue, (J)ob';

comment on column hac_dss_tracks.track_time is 'Time is seconds in unix timestamp format';

----------------------------------------------------------------------------------------------------
create table hac_error_log(
  log_id                   number(20)     not null,
  request_params           varchar2(4000) not null,
  error_message            varchar2(4000) not null,
  created_on               timestamp with local time zone not null,
  constraint hac_error_log_pk primary key (log_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_error_log is 'Errors from requests to dahua and hikvision servers';

----------------------------------------------------------------------------------------------------
prompt Verifix Access Control management systems integrations views
----------------------------------------------------------------------------------------------------
create view hac_dahua_servers_view as
select q.server_id,
       q.host_url,
       q.name,
       q.order_no,
       p.username,
       p.password
  from Hac_Servers q
  join Hac_Dss_Servers p
    on p.Server_Id = q.Server_Id;
    
create view hac_hikcentral_servers_view as
select q.server_id,
       q.host_url,
       q.name,
       q.order_no,
       p.partner_key,
       p.partner_secret
  from Hac_Servers q
  join Hac_Hik_Servers p
    on p.Server_Id = q.Server_Id;

----------------------------------------------------------------------------------------------------
prompt hpd_application sequences
----------------------------------------------------------------------------------------------------
create sequence hpd_application_types_sq;
create sequence hpd_applications_sq;

----------------------------------------------------------------------------------------------------
-- Applications
----------------------------------------------------------------------------------------------------
create table hpd_application_types(
  company_id                      number(20)         not null,
  application_type_id             number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6)          not null,
  pcode                           varchar2(20)       not null,
  constraint hpd_application_types_pk primary key (company_id, application_type_id) using index tablespace GWS_INDEX,
  constraint hpd_application_types_u1 unique (application_type_id) using index tablespace GWS_INDEX,
  constraint hpd_application_types_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint hpd_application_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpd_application_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hpd_applications(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  application_id                  number(20)        not null,
  application_type_id             number(4)         not null,
  application_number              varchar2(50 char) not null,
  application_date                date              not null,
  status                          varchar2(1)       not null,
  closing_note                    varchar2(300 char),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_applications_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_applications_u1 unique (application_id) using index tablespace GWS_INDEX,
  constraint hpd_applications_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpd_applications_f2 foreign key (company_id, application_type_id) references hpd_application_types(company_id, application_type_id),
  constraint hpd_applications_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_applications_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_applications_c1 check (decode(trim(application_number), application_number, 1, 0) = 1),
  constraint hpd_applications_c2 check (trunc(application_date) = application_date),
  constraint hpd_applications_c3 check (status in ('N', 'W', 'A', 'P', 'O', 'C'))
) tablespace GWS_DATA;

comment on column hpd_applications.status is '(N)ew, (W)aiting, (A)pproved, in (P)rogress, c(O)mplete, (C)anceled';

create index hpd_applications_i1 on hpd_applications(company_id, application_type_id) tablespace GWS_INDEX;
create index hpd_applications_i2 on hpd_applications(company_id, created_by) tablespace GWS_INDEX;
create index hpd_applications_i3 on hpd_applications(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Creating Robots
----------------------------------------------------------------------------------------------------
create table hpd_application_create_robots(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  application_id                  number(20)         not null,
  name                            varchar2(200 char) not null,
  opened_date                     date               not null,
  division_id                     number(20)         not null,
  job_id                          number(20)         not null,
  quantity                        number(20)         not null,
  note                            varchar2(300 char),
  constraint hpd_application_create_robots_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_create_robots_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_create_robots_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_application_create_robots_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpd_application_create_robots_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpd_application_create_robots_c2 check (trunc(opened_date) = opened_date),
  constraint hpd_application_create_robots_c3 check (quantity > 0)
) tablespace GWS_DATA;

create index hpd_application_create_robots_i1 on hpd_application_create_robots(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_application_create_robots_i2 on hpd_application_create_robots(company_id, filial_id, job_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Hiring
----------------------------------------------------------------------------------------------------
create table hpd_application_hirings(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  application_id                  number(20)         not null,
  employee_id                     number(20),
  hiring_date                     date               not null,
  robot_id                        number(20)         not null,
  note                            varchar2(300 char),
  -- person info
  first_name                      varchar2(250 char) not null,
  last_name                       varchar2(250 char) not null,
  middle_name                     varchar2(250 char),
  birthday                        date,
  gender                          varchar2(1),
  phone                           varchar2(100 char),
  email                           varchar2(300),
  photo_sha                       varchar2(64),
  address                         varchar2(500 char),
  legal_address                   varchar2(300 char),
  region_id                       number(20),
  passport_series                 varchar2(50 char),
  passport_number                 varchar2(50 char),
  npin                            varchar2(14 char),
  iapa                            varchar2(20 char),
  employment_type                 varchar2(1)        not null,
  --
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_application_hirings_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_hirings_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_hirings_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_application_hirings_f3 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_application_hirings_f4 foreign key (photo_sha) references biruni_files(sha),
  constraint hpd_application_hirings_f5 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint hpd_application_hirings_f6 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_application_hirings_f7 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_application_hirings_c1 check (trunc(hiring_date) = hiring_date),
  constraint hpd_application_hirings_c2 check (decode(trim(first_name), first_name, 1, 0) = 1),
  constraint hpd_application_hirings_c3 check (decode(trim(last_name), last_name, 1, 0) = 1),
  constraint hpd_application_hirings_c4 check (decode(trim(middle_name), middle_name, 1, 0) = 1),
  constraint hpd_application_hirings_c5 check (gender in ('M', 'F')),
  constraint hpd_application_hirings_c6 check (decode(trim(npin), npin, 1, 0) = 1),
  constraint hpd_application_hirings_c7 check (decode(trim(iapa), iapa, 1, 0) = 1),
  constraint hpd_application_hirings_c8 check (employment_type in ('M', 'I'))
) tablespace GWS_DATA;

comment on column hpd_application_hirings.gender is '(M)ale, (F)emale';
comment on column hpd_application_hirings.employment_type is '(M)ain job, (I)nternal parttime';

create index hpd_application_hirings_i1 on hpd_application_hirings(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i2 on hpd_application_hirings(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i3 on hpd_application_hirings(photo_sha) tablespace GWS_INDEX;
create index hpd_application_hirings_i4 on hpd_application_hirings(company_id, region_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i5 on hpd_application_hirings(company_id, created_by) tablespace GWS_INDEX;
create index hpd_application_hirings_i6 on hpd_application_hirings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Transfer
----------------------------------------------------------------------------------------------------
create table hpd_application_transfers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  staff_id                        number(20) not null,
  transfer_begin                  date       not null,
  robot_id                        number(20) not null,
  note                            varchar2(300 char),
  constraint hpd_application_transfers_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_transfers_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_transfers_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_application_transfers_f3 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_application_transfers_c1 check (trunc(transfer_begin) = transfer_begin)
) tablespace GWS_DATA;

create index hpd_application_transfers_i1 on hpd_application_transfers(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_application_transfers_i2 on hpd_application_transfers(company_id, filial_id, robot_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Dismissal
----------------------------------------------------------------------------------------------------
create table hpd_application_dismissals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  staff_id                        number(20) not null,
  dismissal_date                  date       not null,
  note                            varchar2(300 char),
  constraint hpd_application_dismissals_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_dismissals_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_dismissals_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_application_dismissals_c1 check (trunc(dismissal_date) = dismissal_date)
) tablespace GWS_DATA;

create index hpd_application_dismissals_i1 on hpd_application_dismissals(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Created Robots
----------------------------------------------------------------------------------------------------
create table hpd_application_robots(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  robot_id                        number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hpd_application_robots_pk primary key (company_id, filial_id, application_id, robot_id) using index tablespace GWS_INDEX,
  constraint hpd_application_robots_u1 unique (company_id, filial_id, robot_id) using index tablespace GWS_INDEX,
  constraint hpd_application_robots_f1 foreign key (company_id, filial_id, application_id) references hpd_application_create_robots(company_id, filial_id, application_id),
  constraint hpd_application_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hpd_application_robots_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hpd_application_robots_i1 on hpd_application_robots(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_application_journals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  journal_id                      number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_application_journals_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_journals_u1 unique (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_application_journals_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id),
  constraint hpd_application_journals_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_application_journals_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_application_journals_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hpd_application_journals_i1 on hpd_application_journals(company_id, created_by) tablespace GWS_INDEX;
create index hpd_application_journals_i2 on hpd_application_journals(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt hpd_application tables

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('hac'), exec fazo_z.run('hpd_application')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hac');
exec fazo_z.run('hpd_application');
