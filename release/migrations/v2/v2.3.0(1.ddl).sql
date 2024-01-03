prompt migr from 29.07.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt new candidate tables
----------------------------------------------------------------------------------------------------
create table href_candidate_ref_settings(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  region                        varchar(1) not null,
  address                       varchar(1) not null,
  experience                    varchar(1) not null,
  source                        varchar(1) not null,
  recommendation                varchar(1) not null,
  cv                            varchar(1) not null,
  constraint href_candidate_ref_settings_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint href_candidate_ref_settings_c1 check (region in ('Y', 'N')),
  constraint href_candidate_ref_settings_c2 check (address in ('Y', 'N')),
  constraint href_candidate_ref_settings_c3 check (experience in ('Y', 'N')),
  constraint href_candidate_ref_settings_c4 check (source in ('Y', 'N')),
  constraint href_candidate_ref_settings_c5 check (recommendation in ('Y', 'N')),
  constraint href_candidate_ref_settings_c6 check (cv in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table href_candidate_ref_settings                      is  'settings for candidate form';
comment on column href_candidate_ref_settings.region              is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.address             is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.experience          is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.source              is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.recommendation      is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.cv                  is  '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table href_candidate_langs(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  lang_id                       number(20) not null,
  order_no                      number(6),
  constraint href_candidate_langs_pk primary key (company_id, filial_id, lang_id) using index tablespace GWS_INDEX,
  constraint href_candidate_langs_f1 foreign key (company_id, lang_id) references href_langs(company_id, lang_id)
) tablespace GWS_DATA;

create index href_candidate_langs_i1 on href_candidate_langs(company_id, lang_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_candidate_edu_stages(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  edu_stage_id                  number(20) not null,
  order_no                      number(6),
  constraint href_candidate_edu_stages_pk primary key (company_id, filial_id, edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_candidate_edu_stages_f1 foreign key (company_id, edu_stage_id) references href_edu_stages(company_id, edu_stage_id)
) tablespace GWS_DATA;

create index href_candidate_edu_stages_i1 on href_candidate_edu_stages(company_id, edu_stage_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_candidate_types(
  company_id                      number(20)         not null,
  candidate_type_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_candidate_types_pk primary key (company_id, candidate_type_id) using index tablespace GWS_INDEX,
  constraint href_candidate_types_u1 unique (candidate_type_id) using index tablespace GWS_INDEX,
  constraint href_candidate_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_candidate_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_candidate_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_candidate_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_candidate_types.state is '(A)ctive, (P)assive';

create index href_candidate_types_i1 on href_candidate_types(company_id, created_by) tablespace GWS_INDEX;
create index href_candidate_types_i2 on href_candidate_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_candidates(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  candidate_id                    number(20)  not null,
  candidate_type_id               number(20),
  candidate_kind                  varchar2(1) not null,
  source_id                       number(20),
  wage_expectation                number(9),
  cv_sha                          varchar2(64),
  note                            varchar2(300 char),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_candidates_pk primary key (company_id, filial_id, candidate_id) using index tablespace GWS_INDEX,
  constraint href_candidates_f1 foreign key (company_id, candidate_id) references mr_natural_persons(company_id, person_id),
  constraint href_candidates_f2 foreign key (company_id, candidate_type_id) references href_candidate_types(company_id, candidate_type_id),
  constraint href_candidates_f3 foreign key (company_id, source_id) references href_employment_sources(company_id, source_id),
  constraint href_candidates_f4 foreign key (cv_sha) references biruni_files(sha),
  constraint href_candidates_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_candidates_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_candidates_c1 check (candidate_kind in ('N', 'F'))
) tablespace GWS_DATA;

comment on column href_candidates.candidate_kind is '(N)ew, (F)ormal';

create index href_candidates_i1 on href_candidates(company_id, candidate_type_id) tablespace GWS_INDEX;
create index href_candidates_i2 on href_candidates(company_id, source_id) tablespace GWS_INDEX;
create index href_candidates_i3 on href_candidates(cv_sha) tablespace GWS_INDEX;
create index href_candidates_i4 on href_candidates(company_id, created_by) tablespace GWS_INDEX;
create index href_candidates_i5 on href_candidates(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------  
create table href_candidate_recoms(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  candidate_id                    number(20)         not null,
  recommendation_id               number(20)         not null,
  sender_name                     varchar2(300 char) not null,
  sender_phone_number             varchar2(30 char),
  sender_email                    varchar2(320 char),
  file_sha                        varchar2(64),
  order_no                        number(6),
  feedback                        varchar2(300 char),
  note                            varchar2(300 char),
  constraint href_candidate_recoms_pk primary key (company_id, filial_id, recommendation_id) using index tablespace GWS_INDEX,
  constraint href_candidate_recoms_u1 unique (recommendation_id) using index tablespace GWS_INDEX,
  constraint href_candidate_recoms_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade,
  constraint href_candidate_recoms_f2 foreign key (file_sha) references biruni_files(sha),
  constraint href_candidate_recoms_c1 check (decode(trim(sender_name), sender_name, 1, 0) = 1)
) tablespace GWS_DATA;

create index href_candidate_recoms_i1 on href_candidate_recoms(company_id, filial_id, candidate_id) tablespace GWS_INDEX;
create index href_candidate_recoms_i2 on href_candidate_recoms(file_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table href_candidate_jobs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  candidate_id                    number(20) not null,
  job_id                          number(20) not null,
  constraint href_candidate_jobs_pk primary key (company_id, filial_id, candidate_id, job_id) using index tablespace GWS_INDEX,
  constraint href_candidate_jobs_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade,
  constraint href_candidate_jobs_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade
) tablespace GWS_DATA;

create index href_candidate_jobs_i1 on href_candidate_jobs(company_id, filial_id, job_id) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
prompt new candidate sequences
----------------------------------------------------------------------------------------------------
create sequence href_candidate_recoms_sq;
create sequence href_candidate_types_sq;

----------------------------------------------------------------------------------------------------
prompt hrm_division_schedules
---------------------------------------------------------------------------------------------------- 
create table hrm_division_schedules(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  division_id                     number(20) not null,
  schedule_id                     number(20) not null,
  constraint hrm_division_schedules_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_division_schedules_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_division_schedules_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade
) tablespace GWS_DATA;

comment on table hrm_division_schedules is 'Keeps division schedule info, for division schedule report';

create index hrm_division_schedules_i1 on hrm_division_schedules(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 

exec fazo_z.run('href_candidate');
exec fazo_z.run('hrm_division_schedules');
