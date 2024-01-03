prompt adding position booking
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create table hpd_robot_trans_pages(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  trans_id                        number(20)   not null,
  constraint hpd_robot_trans_pages_pk primary key (company_id, filial_id, page_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_robot_trans_pages_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_robot_trans_pages_f2 foreign key (company_id, filial_id, trans_id) references hrm_robot_transactions(company_id, filial_id, trans_id) on delete cascade
) tablespace GWS_DATA;

create index hpd_robot_trans_pages_i1 on hpd_robot_trans_pages(company_id, filial_id, trans_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpd_page_robots add is_booked varchar2(1);

---------------------------------------------------------------------------------------------------- 
prompt add hrm_register_rank_indicators table 
----------------------------------------------------------------------------------------------------
create table hrm_register_rank_indicators(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  register_id                     number(20)    not null,
  rank_id                         number(20)    not null,
  indicator_id                    number(20)    not null,
  indicator_value                 number(20, 6) not null,
  coefficient                     number(20, 6),
  constraint hrm_register_rank_indicators_pk primary key (company_id, filial_id, register_id, rank_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_register_rank_indicators_f1 foreign key (company_id, filial_id, register_id, rank_id) references hrm_register_ranks(company_id, filial_id, register_id, rank_id) on delete cascade,
  constraint hrm_register_rank_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id),
  constraint hrm_register_rank_indicators_c1 check (indicator_value >= 0),
  constraint hrm_register_rank_indicators_c2 check (coefficient >= 0)
) tablespace GWS_DATA;

create index hrm_register_rank_indicators_i1 on hrm_register_rank_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt making wage sheet division multiple
----------------------------------------------------------------------------------------------------
create table hpr_wage_sheet_divisions(
  company_id                  number(20) not null,
  filial_id                   number(20) not null,
  sheet_id                    number(20) not null,
  division_id                 number(20) not null,
  constraint hpr_wage_sheet_divisions_pk primary key (company_id, filial_id, sheet_id, division_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheet_divisions_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_wage_sheet_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

create index hpr_wage_sheet_divisions_i1 on hpr_wage_sheet_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add modified_id to hpr_books 
----------------------------------------------------------------------------------------------------  
alter table hpr_books add modified_id number(20);

----------------------------------------------------------------------------------------------------
prompt adding hik listening devices
---------------------------------------------------------------------------------------------------- 
create sequence hac_hik_device_events_sq;

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
