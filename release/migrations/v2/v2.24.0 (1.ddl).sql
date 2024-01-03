prompt migr from 05.05.2023 v2.24.0 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt edit add token to hac_hik_servers

drop table hac_hik_company_servers;
drop table hac_hik_servers;
drop table hac_hik_devices;

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
  isup_device_code            varchar2(32 char) not null,
  isup_password               varchar2(32 char) not null,
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
create table hac_hik_ex_events(
  server_id                   number(20)          not null,
  door_code                   varchar2(300 char)  not null,
  person_code                 varchar2(300 char)  not null,
  event_time                  varchar2(100 char)  not null,
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
  device_time                 varchar2(1000 char),
  temperature_data            varchar2(1000 char),
  temperature_status          number,
  wear_mask_status            number,
  reader_code                 varchar2(1000 char),
  reader_name                 varchar2(1000 char),
  created_on                  timestamp with local time zone not null,
  constraint hac_hik_ex_events_pk primary key (server_id, door_code, person_code, event_time) using index tablespace GWS_INDEX,
  constraint hac_hik_ex_events_c1 check(event_type in ('N', 'M'))
) tablespace GWS_DATA;

comment on column hac_hik_ex_events.event_time is 'Comes with key "happenTime" in notifications and with key "eventTime" in manual retrieval';
comment on column hac_hik_ex_events.src_type is 'Comes in notifications only';
comment on column hac_hik_ex_events.door_name is 'Comes with key "src_name" in notifications and with key "doorName" in manual retrieval';
comment on column hac_hik_ex_events.status is 'Comes in notifications only';
comment on column hac_hik_ex_events.person_name is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.person_type is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.device_time is 'Comes in manual retrieval only';
comment on column hac_hik_ex_events.event_type is 'N - received from (N)otifications, M - (M)anually retrieved';
comment on table hac_hik_ex_events is 'Keeps raw event data from Hikvision';

----------------------------------------------------------------------------------------------------
alter table hac_server_persons add external_code varchar2(16 char);
create unique index hac_server_persons_u2 on hac_server_persons(nvl2(external_code, server_id, null), nvl2(external_code, company_id, null), external_code) tablespace GWS_INDEX;
create index hac_server_persons_i4 on hac_server_persons(server_id, company_id, external_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hac changes
----------------------------------------------------------------------------------------------------
alter table hac_dss_tracks add photo_url varchar2(300 char);
alter table hac_dss_tracks add photo_sha varchar2(64);
  
alter table hac_dss_tracks add constraint hac_dss_tracks_f1 foreign key (photo_sha) references biruni_files(sha);

create index hac_dss_tracks_i1 on hac_dss_tracks(photo_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt create new table hrm_hidden_salary_job_groups
----------------------------------------------------------------------------------------------------
create table hrm_hidden_salary_job_groups(
  company_id                      number(20) not null,
  job_group_id                    number(20) not null,
  constraint hrm_hidden_salary_job_groups_pk primary key (company_id, job_group_id) using index tablespace GWS_INDEX,
  constraint hrm_hidden_salary_job_groups_f1 foreign key (company_id, job_group_id) references mhr_job_groups(company_id, job_group_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------                
prompt add accec column to person detail
----------------------------------------------------------------------------------------------------                
alter table href_person_details add access_hidden_salary varchar2(1);

comment on column href_person_details.access_hidden_salary is '(Y)es, (N)o. Has access to view hidden salary';

alter table href_person_details add constraint href_person_details_c5 check (access_hidden_salary in ('Y', 'N'));

update href_person_details set access_hidden_salary = 'N';
commit;

alter table href_person_details modify access_hidden_salary not null;

prompt adding hac_dirty_persons
-----------------------------------------------------------------------------------------------------
create global temporary table hac_dirty_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint hac_dirty_persons_u1 unique (company_id, person_id),
  constraint hac_dirty_persons_c1 check (person_id is null) deferrable initially deferred
);

prompt adding currencies
----------------------------------------------------------------------------------------------------
create table hpd_page_currencies(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  currency_id                     number(20) not null,
  constraint hpd_page_currencies_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_currencies_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_currencies_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id)
) tablespace GWS_DATA;

create index hpd_page_currencies_i1 on hpd_page_currencies(company_id, currency_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_trans_currencies(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  currency_id                     number(20)  not null,
  constraint hpd_trans_currencies_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_currencies_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_currencies_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id)
) tablespace GWS_DATA;

create index hpd_trans_currencies_i1 on hpd_trans_currencies(company_id, currency_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
alter table hpd_transactions drop constraint hpd_transactions_c1;
alter table hpd_transactions add constraint hpd_transactions_c1 check (trans_type in ('B', 'O', 'S', 'R', 'L', 'C'));

comment on column hpd_transactions.trans_type is 'Ro(B)ot, (O)peration, (S)chedule, (R)ank, Vacation (L)imit, (C)urrency';

----------------------------------------------------------------------------------------------------
alter table hpr_charges add currency_id number(20);
alter table hpr_charges add constraint hpr_charges_f9 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id);

create index hpr_charges_i9 on hpr_charges(company_id, currency_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run()
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hac');
exec fazo_z.run('href_person_details');
exec fazo_z.run('hrm_hidden_salary_job_groups');
exec fazo_z.run('hpd_page_currencies');
exec fazo_z.run('hpd_trans_currencies');
exec fazo_z.run('hpd_transactions');
exec fazo_z.run('hpr_charges');
