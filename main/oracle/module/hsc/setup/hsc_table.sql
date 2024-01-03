prompt Staffing Calculator module
prompt (c) 2023 Verifix HRM

----------------------------------------------------------------------------------------------------
-- Processes
----------------------------------------------------------------------------------------------------
create table hsc_processes(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  process_id                      number(20)         not null,
  name                            varchar2(200 char) not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_processes_pk primary key (company_id, filial_id, process_id) using index tablespace GWS_INDEX,
  constraint hsc_processes_u1 unique (process_id) using index tablespace GWS_INDEX,
  constraint hsc_processes_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_processes_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_processes_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hsc_processes_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hsc_processes_u2 on hsc_processes(company_id, filial_id, lower(name)) tablespace GWS_INDEX;

create index hsc_processes_i1 on hsc_processes(company_id, created_by) tablespace GWS_INDEX;
create index hsc_processes_i2 on hsc_processes(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Process actions
----------------------------------------------------------------------------------------------------
create table hsc_process_actions(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  action_id                       number(20)         not null,
  process_id                      number(20)         not null,
  name                            varchar2(200 char) not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_process_actions_pk primary key (company_id, filial_id, action_id) using index tablespace GWS_INDEX,
  constraint hsc_process_actions_u1 unique (action_id) using index tablespace GWS_INDEX,
  constraint hsc_process_actions_f1 foreign key (company_id, filial_id, process_id) references hsc_processes(company_id, filial_id, process_id) on delete cascade,
  constraint hsc_process_actions_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_process_actions_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_process_actions_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hsc_process_actions_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hsc_process_actions_u2 on hsc_process_actions(company_id, filial_id, process_id, lower(name)) tablespace GWS_INDEX;

create index hsc_process_actions_i1 on hsc_process_actions(company_id, filial_id, process_id) tablespace GWS_INDEX;
create index hsc_process_actions_i2 on hsc_process_actions(company_id, created_by) tablespace GWS_INDEX;
create index hsc_process_actions_i3 on hsc_process_actions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Drivers
----------------------------------------------------------------------------------------------------
create table hsc_drivers(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  driver_id                       number(20)         not null,
  name                            varchar2(200 char) not null,
  measure_id                      number(20)         not null,
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_drivers_pk primary key (company_id, filial_id, driver_id) using index tablespace GWS_INDEX,
  constraint hsc_drivers_u1 unique (driver_id) using index tablespace GWS_INDEX,
  constraint hsc_drivers_f1 foreign key (company_id, measure_id) references mr_measures(company_id, measure_id),
  constraint hsc_drivers_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_drivers_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_drivers_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hsc_drivers_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hsc_drivers_u2 on hsc_drivers(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create unique index hsc_drivers_u3 on hsc_drivers(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;

create index hsc_drivers_i1 on hsc_drivers(company_id, measure_id) tablespace GWS_INDEX;
create index hsc_drivers_i2 on hsc_drivers(company_id, created_by) tablespace GWS_INDEX;
create index hsc_drivers_i3 on hsc_drivers(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Areas
----------------------------------------------------------------------------------------------------
create table hsc_areas(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  area_id                         number(20)         not null,
  name                            varchar2(200 char) not null,
  state                           varchar2(1)        not null,
  c_division_groups_exist         varchar2(1)        not null,
  c_drivers_exist                 varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_areas_pk primary key (company_id, filial_id, area_id) using index tablespace GWS_INDEX,
  constraint hsc_areas_u1 unique (area_id) using index tablespace GWS_INDEX,
  constraint hsc_areas_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_areas_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_areas_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hsc_areas_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hsc_areas_u2 on hsc_areas(company_id, filial_id, lower(name)) tablespace GWS_INDEX;

create index hsc_areas_i1 on hsc_areas(company_id, created_by) tablespace GWS_INDEX;
create index hsc_areas_i2 on hsc_areas(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hsc_area_drivers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  area_id                         number(20) not null,
  driver_id                       number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hsc_area_drivers_pk primary key (company_id, filial_id, area_id, driver_id) using index tablespace GWS_INDEX,
  constraint hsc_area_drivers_f1 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id) on delete cascade,
  constraint hsc_area_drivers_f2 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id) on delete cascade,
  constraint hsc_area_drivers_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hsc_area_drivers_i1 on hsc_area_drivers(company_id, filial_id, driver_id) tablespace GWS_INDEX;
create index hsc_area_drivers_i2 on hsc_area_drivers(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Object groups
----------------------------------------------------------------------------------------------------
create table hsc_object_groups(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  division_group_id               number(20) not null,
  constraint hsc_object_groups_pk primary key (company_id, filial_id, division_group_id) using index tablespace GWS_INDEX,
  constraint hsc_object_groups_f1 foreign key (company_id, division_group_id) references mhr_division_groups(company_id, division_group_id)
) tablespace GWS_DATA;

create index hsc_object_groups_i1 on hsc_object_groups(company_id, division_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Objects
----------------------------------------------------------------------------------------------------
create table hsc_objects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  object_id                       number(20) not null,
  note                            varchar2(300 char),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_objects_pk primary key (company_id, filial_id, object_id) using index tablespace GWS_INDEX,
  constraint hsc_objects_f1 foreign key (company_id, filial_id, object_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hsc_objects_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_objects_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_objects_c1 check (decode(trim(note), note, 1, 1) = 1)
) tablespace GWS_DATA;

create index hsc_objects_i1 on hsc_objects(company_id, created_by) tablespace GWS_INDEX;
create index hsc_objects_i2 on hsc_objects(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Object norms
----------------------------------------------------------------------------------------------------
create table hsc_object_norms(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  norm_id                         number(20) not null,
  object_id                       number(20) not null,
  process_id                      number(20) not null,
  action_id                       number(20) not null,
  driver_id                       number(20) not null,
  area_id                         number(20) not null,
  division_id                     number(20),
  job_id                          number(20) not null,
  time_value                      number(5)  not null,
  action_period                   varchar2(1),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_object_norms_pk primary key (company_id, filial_id, norm_id) using index tablespace GWS_INDEX,
  constraint hsc_object_norms_u1 unique (norm_id) using index tablespace GWS_INDEX,
  constraint hsc_object_norms_u2 unique (company_id, filial_id, object_id, area_id, process_id, action_id, driver_id, division_id, job_id) using index tablespace GWS_INDEX,
  constraint hsc_object_norms_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_object_norms_f2 foreign key (company_id, filial_id, process_id) references hsc_processes(company_id, filial_id, process_id),
  constraint hsc_object_norms_f3 foreign key (company_id, filial_id, action_id) references hsc_process_actions(company_id, filial_id, action_id),
  constraint hsc_object_norms_f4 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id),
  constraint hsc_object_norms_f5 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id),
  constraint hsc_object_norms_f6 foreign key (company_id, filial_id, division_id, object_id) references mhr_parent_divisions(company_id, filial_id, division_id, parent_id),
  constraint hsc_object_norms_f7 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hsc_object_norms_f8 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_object_norms_f9 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_object_norms_c1 check (time_value > 0),
  constraint hsc_object_norms_c2 check (action_period in ('W', 'M'))
) tablespace GWS_DATA;

create index hsc_object_norms_i1 on hsc_object_norms(company_id, filial_id, process_id) tablespace GWS_INDEX;
create index hsc_object_norms_i2 on hsc_object_norms(company_id, filial_id, action_id) tablespace GWS_INDEX;
create index hsc_object_norms_i3 on hsc_object_norms(company_id, filial_id, driver_id) tablespace GWS_INDEX;
create index hsc_object_norms_i4 on hsc_object_norms(company_id, filial_id, area_id) tablespace GWS_INDEX;
create index hsc_object_norms_i5 on hsc_object_norms(company_id, filial_id, division_id, object_id) tablespace GWS_INDEX;
create index hsc_object_norms_i6 on hsc_object_norms(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hsc_object_norms_i7 on hsc_object_norms(company_id, created_by) tablespace GWS_INDEX;
create index hsc_object_norms_i8 on hsc_object_norms(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hsc_object_norm_actions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  norm_id                         number(20) not null,
  day_no                          number(2)  not null,
  frequency                       number(20) not null,
  constraint hsc_object_norm_actions_pk primary key (company_id, filial_id, norm_id, day_no) using index tablespace GWS_INDEX,
  constraint hsc_object_norm_actions_f1 foreign key (company_id, filial_id, norm_id) references hsc_object_norms(company_id, filial_id, norm_id) on delete cascade,
  constraint hsc_object_norm_actions_c1 check (day_no > 0),
  constraint hsc_object_norm_actions_c2 check (frequency > 0)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Job norms
----------------------------------------------------------------------------------------------------
create table hsc_job_norms(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  norm_id                         number(20)  not null,
  object_id                       number(20)  not null,
  division_id                     number(20),
  job_id                          number(20)  not null,
  month                           date        not null,
  monthly_hours                   number(8,2) not null,
  monthly_days                    number(6)   not null,
  idle_margin                     number(8,2) not null,
  absense_margin                  number(8,2) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_job_norms_pk primary key (company_id, filial_id, norm_id) using index tablespace GWS_INDEX,
  constraint hsc_job_norms_u1 unique (norm_id) using index tablespace GWS_INDEX,
  constraint hsc_job_norms_u2 unique (company_id, filial_id, object_id, division_id, job_id, month) using index tablespace GWS_INDEX,
  constraint hsc_job_norms_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_job_norms_f2 foreign key (company_id, filial_id, division_id, object_id) references mhr_parent_divisions(company_id, filial_id, division_id, parent_id),
  constraint hsc_job_norms_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hsc_job_norms_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_job_norms_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_job_norms_c1 check (trunc(month, 'mon') = month),
  constraint hsc_job_norms_c2 check (monthly_hours > 0),
  constraint hsc_job_norms_c3 check (monthly_days > 0),
  constraint hsc_job_norms_c4 check (idle_margin > 0),
  constraint hsc_job_norms_c5 check (absense_margin > 0),
  constraint hsc_job_norms_c6 check (ceil(monthly_hours/24) <= monthly_days)
) tablespace GWS_DATA;

comment on column hsc_job_norms.idle_margin      is 'Value in percent';
comment on column hsc_job_norms.absense_margin   is 'Value in percent';

create index hsc_job_norms_i1 on hsc_job_norms(company_id, filial_id, division_id, object_id) tablespace GWS_INDEX;
create index hsc_job_norms_i2 on hsc_job_norms(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hsc_job_norms_i3 on hsc_job_norms(company_id, created_by) tablespace GWS_INDEX;
create index hsc_job_norms_i4 on hsc_job_norms(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Job rounds
----------------------------------------------------------------------------------------------------
create table hsc_job_rounds(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  round_id                        number(20)  not null,
  object_id                       number(20)  not null,
  division_id                     number(20),
  job_id                          number(20)  not null,
  round_model_type                varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_job_rounds_pk primary key (company_id, filial_id, round_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_u1 unique (round_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_u2 unique (company_id, filial_id, object_id, division_id, job_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_job_rounds_f2 foreign key (company_id, filial_id, division_id, object_id) references mhr_parent_divisions(company_id, filial_id, division_id, parent_id),
  constraint hsc_job_rounds_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hsc_job_rounds_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_job_rounds_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_job_rounds_c1 check (round_model_type in ('C', 'F', 'R'))
) tablespace GWS_DATA;

comment on column hsc_job_rounds.round_model_type is '(C)eil, (F)loor, (R)ound';

create index hsc_job_rounds_i1 on hsc_job_rounds(company_id, filial_id, division_id, object_id) tablespace GWS_INDEX;
create index hsc_job_rounds_i2 on hsc_job_rounds(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hsc_job_rounds_i3 on hsc_job_rounds(company_id, created_by) tablespace GWS_INDEX;
create index hsc_job_rounds_i4 on hsc_job_rounds(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
-- Driver facts
----------------------------------------------------------------------------------------------------
create table hsc_driver_facts(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  fact_id                         number(20)     not null,
  object_id                       number(20)     not null,
  area_id                         number(20)     not null,
  driver_id                       number(20)     not null,
  fact_type                       varchar(1)     not null,
  fact_date                       date           not null,
  fact_value                      number(20, 10) not null,
  priority                        number(20)     not null,
  constraint hsc_driver_facts_pk primary key (company_id, filial_id, fact_id) using index tablespace GWS_INDEX,
  constraint hsc_driver_facts_u1 unique (fact_id) using index tablespace GWS_INDEX,
  constraint hsc_driver_facts_u2 unique (company_id, filial_id, object_id, area_id, driver_id, fact_date, fact_type) using index tablespace GWS_INDEX,
  constraint hsc_driver_facts_u3 unique (company_id, filial_id, object_id, area_id, driver_id, fact_date, priority) using index tablespace GWS_INDEX,
  constraint hsc_driver_facts_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_driver_facts_f2 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id) on delete cascade,
  constraint hsc_driver_facts_f3 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id) on delete cascade,
  constraint hsc_driver_facts_c1 check (trunc(fact_date) = fact_date),
  constraint hsc_driver_facts_c2 check (fact_type in ('W', 'M', 'Q', 'Y', 'A')),
  constraint hsc_driver_facts_c3 check (priority >= 0),
  constraint hsc_driver_facts_c4 check (priority = 0 or fact_type <> 'A')
) tablespace GWS_DATA;

comment on column hsc_driver_facts.fact_type is '(W)eekly, (M)onthly, (Q)uarterly, (Y)early prediction, (A)ctual value';
comment on column hsc_driver_facts.priority  is 'When priority=1, shows most accurate available prediction';

----------------------------------------------------------------------------------------------------
-- Driver fact import infos
----------------------------------------------------------------------------------------------------
create table hsc_driver_fact_import_infos(
  company_id                     number(20)         not null,
  filial_id                      number(20)         not null,
  column_index                   number(20)         not null,
  title                          varchar2(200 char) not null,
  constraint hsc_driver_fact_import_infos_pk primary key (company_id, filial_id, column_index) using index tablespace GWS_INDEX,
  constraint hsc_driver_fact_import_infos_c1 check (column_index > 0),
  constraint hsc_driver_fact_import_infos_c2 check (decode(trim(title), title, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Driver fact import settings
----------------------------------------------------------------------------------------------------
create table hsc_driver_fact_import_settings(
  company_id                     number(20) not null,
  filial_id                      number(20) not null,
  object_id                      number(20) not null,
  area_id                        number(20) not null,
  driver_id                      number(20) not null,
  column_index                   number(20) not null,
  constraint hsc_driver_fact_import_settings_pk primary key (company_id, filial_id, object_id, area_id, driver_id, column_index) using index tablespace GWS_INDEX,
  constraint hsc_driver_fact_import_settings_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_f2 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_f3 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_c1 check (column_index > 0)
) tablespace GWS_DATA;

create index hsc_driver_fact_import_settings_i1 on hsc_driver_fact_import_settings(company_id, filial_id, area_id) tablespace GWS_INDEX;
create index hsc_driver_fact_import_settings_i2 on hsc_driver_fact_import_settings(company_id, filial_id, driver_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hsc_dirty_areas(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  area_id                         number(20) not null,
  constraint hsc_dirty_areas_u1 unique (company_id, filial_id, area_id),
  constraint hsc_dirty_areas_c1 check (area_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create table hsc_server_settings(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  ftp_server_url                  varchar2(300) not null,
  ftp_username                    varchar2(300) not null,
  ftp_password                    varchar2(300) not null,
  predict_server_url              varchar2(300) not null,
  last_ftp_file_date              date,
  constraint hsc_server_settings_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint hsc_server_settings_c1 check(trunc(last_ftp_file_date) = last_ftp_file_date)
) tablespace GWS_DATA;

comment on column hsc_server_settings.predict_server_url is 'DEFAULT: http://127.0.0.1:5000';

----------------------------------------------------------------------------------------------------
create table hsc_job_error_log(
  log_id                          number(20) not null,
  company_id                      number(20),
  filial_id                       number(20),
  error_log                       varchar2(4000),
  created_on                      timestamp with local time zone not null,
  constraint hsc_job_error_log_pk primary key (log_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;
