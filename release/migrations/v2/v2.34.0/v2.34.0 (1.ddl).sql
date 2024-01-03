prompt v2.34.0 1.ddl
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback
----------------------------------------------------------------------------------------------------
prompt add OLX integration tables 
----------------------------------------------------------------------------------------------------
create table hrec_olx_job_categories(
  category_code                   number(20)         not null,
  name                            varchar2(100 char) not null,
  constraint hrec_olx_job_categories_pk primary key (category_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_attributes(
  category_code                   number(20)    not null,                    
  attribute_code                  varchar2(50)  not null,
  label                           varchar2(200) not null,
  validation_type                 varchar2(50)  not null,
  is_require                      varchar2(1)   not null,
  is_number                       varchar2(1)   not null,
  min_value                       number(20),
  max_value                       number(20),
  is_allow_multiple_values        varchar2(1),
  constraint hrec_olx_attributes_pk primary key (category_code, attribute_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_attributes_f1 foreign key (category_code) references hrec_olx_job_categories(category_code) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_attribute_values(
  category_code                   number(20)    not null,
  attribute_code                  varchar2(50)  not null,
  code                            varchar2(50)  not null,
  label                           varchar2(100) not null, 
  constraint hrec_olx_attribute_values_pk primary key (category_code, attribute_code, code) using index tablespace GWS_INDEX,
  constraint hrec_olx_attribute_values_f1 foreign key (category_code, attribute_code) references hrec_olx_attributes(category_code, attribute_code) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_regions(
  region_code                     number(20)         not null,
  name                            varchar2(100 char) not null,
  constraint hrec_olx_regions_pk primary key (region_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_cities(
  city_code                       number(20)         not null,
  region_code                     number(20)         not null,  
  name                            varchar2(100 char) not null,
  constraint hrec_olx_cities_pk primary key (city_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_cities_f1 foreign key (region_code) references hrec_olx_regions(region_code) on delete cascade  
) tablespace GWS_DATA;

create index hrec_olx_cities_i1 on hrec_olx_cities(region_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_olx_districts(
  district_code                   number(20)         not null,
  city_code                       number(20)         not null,  
  name                            varchar2(100 char) not null,
  constraint hrec_olx_districts_pk primary key (district_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_districts_f1 foreign key (city_code) references hrec_olx_cities(city_code) on delete cascade
) tablespace GWS_DATA;

create index hrec_olx_districts_i1 on hrec_olx_districts(city_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_olx_integration_regions(
  company_id                      number(20) not null,
  region_id                       number(20) not null,
  city_code                       number(20) not null,
  district_code                   number(20),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_olx_integration_regions_pk primary key (company_id, region_id) using index tablespace GWS_INDEX,
  constraint hrec_olx_integration_regions_f1 foreign key (company_id, region_id) references md_regions(company_id, region_id) on delete cascade,
  constraint hrec_olx_integration_regions_f2 foreign key (city_code) references hrec_olx_cities(city_code) on delete cascade,
  constraint hrec_olx_integration_regions_f3 foreign key (district_code) references hrec_olx_districts(district_code) on delete cascade,
  constraint hrec_olx_integration_regions_f4 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade,
  constraint hrec_olx_integration_regions_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_olx_integration_regions_i1 on hrec_olx_integration_regions(city_code) tablespace GWS_INDEX;
create index hrec_olx_integration_regions_i2 on hrec_olx_integration_regions(district_code) tablespace GWS_INDEX;
create index hrec_olx_integration_regions_i3 on hrec_olx_integration_regions(company_id, created_by) tablespace GWS_INDEX;
create index hrec_olx_integration_regions_i4 on hrec_olx_integration_regions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_olx_published_vacancies(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  vacancy_id                      number(20)   not null,
  vacancy_code                    number(20)   not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_olx_published_vacancies_pk primary key (company_id, filial_id, vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_olx_published_vacancies_u1 unique (company_id, vacancy_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_published_vacancies_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_olx_published_vacancies_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_olx_published_vacancies_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id)  
) tablespace GWS_DATA;

create index hrec_olx_published_vacancies_i1 on hrec_olx_published_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_olx_published_vacancies_i2 on hrec_olx_published_vacancies(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_olx_published_vacancy_attributes(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  vacancy_id                      number(20)   not null,
  category_code                   number(20)   not null,  
  code                            varchar2(50) not null,
  value                           varchar2(50) not null,
  constraint hrec_olx_published_vacancy_attributes_pk primary key (company_id, filial_id, vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_olx_published_vacancy_attributes_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_olx_published_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_olx_published_vacancy_attributes_f2 foreign key (category_code, code) references hrec_olx_attributes(category_code, attribute_code),
  constraint hrec_olx_published_vacancy_attributes_f3 foreign key (category_code, code, value) references hrec_olx_attribute_values(category_code, attribute_code, code)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_vacancy_candidates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,  
  candidate_code                  number(20) not null,
  candidate_id                    number(20),
  constraint hrec_olx_vacancy_candidates_pk primary key (company_id, filial_id, vacancy_id, candidate_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_vacancy_candidates_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_olx_vacancy_candidates_f2 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete set null
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt add columns to hac_devices
----------------------------------------------------------------------------------------------------
alter table hac_devices add location varchar2(100 char);
alter table hac_devices add device_mac varchar2(100);
alter table hac_devices add login varchar2(50);
alter table hac_devices add password varchar2(100);

alter table hac_hik_devices drop constraint hac_hik_devices_u1;
alter table hac_hik_devices rename constraint hac_hik_devices_u2 to hac_hik_devices_u1;
alter index hac_hik_devices_u2 rename to hac_hik_devices_u1;
alter index hac_hik_devices_u3 rename to hac_hik_devices_u2;
alter index hac_hik_devices_u4 rename to hac_hik_devices_u3;
alter index hac_hik_devices_u5 rename to hac_hik_devices_u4;

alter table hac_hik_devices drop column isup_device_code;

---------------------------------------------------------------------------------------------------- 
prompt add status to htt_devices
----------------------------------------------------------------------------------------------------  
alter table htt_devices add status varchar2(1);
alter table htt_devices add constraint htt_devices_c13 check (status in ('O', 'F', 'U'));

comment on column htt_devices.status is '(O)nline, O(f)fline, (U)nknown';

---------------------------------------------------------------------------------------------------- 
prompt adding hface tables
----------------------------------------------------------------------------------------------------
create table hface_service_settings(
  code               varchar2(1)   not null,
  host               varchar2(150) not null,
  username           varchar2(150) not null,
  password           varchar2(150) not null,
  constraint hface_service_settings_pk primary key (code) using index tablespace GWS_INDEX,
  constraint hface_service_settings_c1 check (code='U')
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table hface_photo_vectors (
  photo_sha          varchar2(64) not null,
  photo_vector       clob         not null,
  constraint hface_photo_vectors_pk primary key (photo_sha) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hface_calculated_photos(
  company_id         number(20)   not null,
  photo_sha          varchar2(64) not null,
  photo_id           number(20)   not null,
  constraint hface_calculated_photos_pk primary key (company_id, photo_sha) using index tablespace GWS_INDEX,
  constraint hface_calculated_photos_u1 unique (company_id, photo_id) using index tablespace GWS_INDEX,
  constraint hface_calculated_photos_f1 foreign key (photo_sha) references biruni_files(sha) on delete cascade
) tablespace GWS_DATA;

comment on column hface_calculated_photos.photo_id is 'Used for join';

----------------------------------------------------------------------------------------------------
create table hface_matched_photos(
  company_id         number(20)   not null,
  photo_sha          varchar2(64) not null,
  matched_sha        varchar2(64) not null,
  match_score        number       not null,
  constraint hface_matched_photos_pk primary key (company_id, photo_sha, matched_sha) using index tablespace GWS_INDEX,
  constraint hface_matched_photos_f1 foreign key (company_id, photo_sha) references hface_calculated_photos(company_id, photo_sha) on delete cascade,
  constraint hface_matched_photos_f2 foreign key (company_id, matched_sha) references hface_calculated_photos(company_id, photo_sha) on delete cascade
) tablespace GWS_DATA;

create index hface_matched_photos_i1 on hface_matched_photos(company_id, matched_sha) tablespace GWS_INDEX;
create index hface_matched_photos_i2 on hface_matched_photos(company_id, match_score) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hface sequences
----------------------------------------------------------------------------------------------------
create sequence hface_calculated_photos_sq;

---------------------------------------------------------------------------------------------------- 
prompt add Global attach type
----------------------------------------------------------------------------------------------------
alter table htt_location_persons drop constraint htt_location_persons_c1;
alter table htt_location_persons add constraint htt_location_persons_c1 check (attach_type in ('M', 'A', 'G'));

comment on column htt_location_persons.attach_type is 'It must be (M)anual, (A)uto, (G)lobal. Person in which type is attached to the location, in this type can detach';

----------------------------------------------------------------------------------------------------
prompt changing timesheet begin/end time
---------------------------------------------------------------------------------------------------- 
-- htt_timesheets
----------------------------------------------------------------------------------------------------
alter table htt_timesheets add allowed_late_time number(6);
alter table htt_timesheets add allowed_early_time number(6);
alter table htt_timesheets add begin_late_time number(6);
alter table htt_timesheets add end_early_time number(6);

---------------------------------------------------------------------------------------------------- 
-- table checks
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets add constraint htt_timesheets_c25 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0)));  
alter table htt_timesheets add constraint htt_timesheets_c26 check (begin_late_time <= 0 and end_early_time >= 0);
alter table htt_timesheets add constraint htt_timesheets_c27 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0)));

----------------------------------------------------------------------------------------------------
-- htt_schedules
----------------------------------------------------------------------------------------------------
alter table htt_schedules add allowed_late_time number(6);
alter table htt_schedules add allowed_early_time number(6);
alter table htt_schedules add begin_late_time number(6);
alter table htt_schedules add end_early_time number(6);

---------------------------------------------------------------------------------------------------- 
-- table checks
---------------------------------------------------------------------------------------------------- 
alter table htt_schedules add constraint htt_schedules_c16 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0)));  
alter table htt_schedules add constraint htt_schedules_c17 check (begin_late_time <= 0 and end_early_time >= 0);
alter table htt_schedules add constraint htt_schedules_c18 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0)));

----------------------------------------------------------------------------------------------------
-- htt_schedule_registries
----------------------------------------------------------------------------------------------------
alter table htt_schedule_registries add allowed_late_time number(6);
alter table htt_schedule_registries add allowed_early_time number(6);
alter table htt_schedule_registries add begin_late_time number(6);
alter table htt_schedule_registries add end_early_time number(6);

---------------------------------------------------------------------------------------------------- 
-- table checks
---------------------------------------------------------------------------------------------------- 
alter table htt_schedule_registries add constraint htt_schedule_registries_c18 check (not ((allowed_late_time <> 0 or allowed_early_time <> 0) and (begin_late_time <> 0 or end_early_time <> 0)));  
alter table htt_schedule_registries add constraint htt_schedule_registries_c19 check (begin_late_time <= 0 and end_early_time >= 0);
alter table htt_schedule_registries add constraint htt_schedule_registries_c20 check (not (schedule_kind = 'H' and (allowed_late_time <> 0 or allowed_early_time <> 0 or begin_late_time <> 0 or end_early_time <> 0)));


