prompt fixing unique index 
----------------------------------------------------------------------------------------------------
drop index hac_server_persons_u2;
create unique index hac_server_persons_u2 on hac_server_persons(nvl2(external_code, server_id, null), nvl2(external_code, company_id, null), external_code) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
prompt adding hac_server_changes
----------------------------------------------------------------------------------------------------
alter table hac_server_persons add rfid_code varchar2(20);
comment on column hac_server_persons.rfid_code is 'Rfid card No that was send to acms server';

----------------------------------------------------------------------------------------------------
prompt adding htt_devices settings
----------------------------------------------------------------------------------------------------
alter table htt_devices add has_rfid varchar2(1);
alter table htt_devices add has_photo_recognition varchar2(1);

comment on column htt_devices.has_rfid is '(Y)es, (N)o. Currently works only with hikvision/dahua';
comment on column htt_devices.has_photo_recognition is '(Y)es, (N)o. Currently works only with hikvision/dahua';

----------------------------------------------------------------------------------------------------
prompt changing htt_persons
----------------------------------------------------------------------------------------------------
drop index htt_persons_u3;

alter table htt_persons rename column rfid_code to rfid_code_old;
alter table htt_persons add rfid_code varchar2(20);

---------------------------------------------------------------------------------------------------- 
prompt adding rfid_code to hac_dss_ex_persons
----------------------------------------------------------------------------------------------------
alter table hac_dss_ex_persons add rfid_code varchar2(20);

----------------------------------------------------------------------------------------------------
prompt adding hac_hik_ex_persons
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
