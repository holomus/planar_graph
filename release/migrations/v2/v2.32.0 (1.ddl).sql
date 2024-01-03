prompt changing testings
----------------------------------------------------------------------------------------------------
alter table hln_testings rename column begin_time to begin_time_period_begin;
alter table hln_testings add begin_time_period_end date;

alter table hln_testings rename constraint hln_testings_c9 to hln_testings_c11;
alter table hln_testings rename constraint hln_testings_c8 to hln_testings_c10;
alter table hln_testings rename constraint hln_testings_c7 to hln_testings_c9;
alter table hln_testings rename constraint hln_testings_c6 to hln_testings_c8;
alter table hln_testings rename constraint hln_testings_c5 to hln_testings_c7;

alter table hln_testings drop constraint hln_testings_c3;
alter table hln_testings drop constraint hln_testings_c4;

alter table hln_testings add constraint hln_testings_c3 check (trunc(begin_time_period_begin) = trunc(testing_date));
alter table hln_testings add constraint hln_testings_c4 check (trunc(begin_time_period_end) = trunc(testing_date));
alter table hln_testings add constraint hln_testings_c5 check (end_time > begin_time_period_begin);
alter table hln_testings add constraint hln_testings_c6 check (end_time > begin_time_period_end);

----------------------------------------------------------------------------------------------------
prompt changing attestations
----------------------------------------------------------------------------------------------------
alter table hln_attestations rename column begin_time to begin_time_period_begin;
alter table hln_attestations add begin_time_period_end date;

alter table hln_attestations rename constraint hln_attestations_c5 to hln_attestations_c6;
alter table hln_attestations drop constraint hln_attestations_c4;

alter table hln_attestations add constraint hln_attestations_c4 check (trunc(attestation_date) = trunc(begin_time_period_begin));
alter table hln_attestations add constraint hln_attestations_c5 check (trunc(attestation_date) = trunc(begin_time_period_end));

----------------------------------------------------------------------------------------------------
prompt adding manual charges
----------------------------------------------------------------------------------------------------
create table hpr_charge_documents(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  document_number                 varchar2(50 char) not null,
  document_date                   date              not null,
  document_name                   varchar2(150 char),
  month                           date              not null,
  posted                          varchar2(1)       not null,
  currency_id                     number(20)        not null,
  division_id                     number(20),
  oper_type_id                    number(20),
  document_kind                   varchar2(1)       not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_charge_documents_pk primary key (company_id, filial_id, document_id) using index tablespace GWS_INDEX,
  constraint hpr_charge_documents_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpr_charge_documents_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id),
  constraint hpr_charge_documents_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_charge_documents_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_charge_documents_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_charge_documents_c1 check (decode(trim(document_number), document_number, 1, 0) = 1),
  constraint hpr_charge_documents_c2 check (decode(trim(document_name), document_name, 1, 0) = 1),
  constraint hpr_charge_documents_c3 check (posted in ('Y', 'N')),
  constraint hpr_charge_documents_c4 check (document_kind in ('A', 'D'))
) tablespace GWS_DATA;

comment on column hpr_charge_documents.posted is '(Y)es, (N)o';
comment on column hpr_charge_documents.document_kind is '(A)ccrual, (D)eduction';

create index hpr_charge_documents_i1 on hpr_charge_documents(company_id, currency_id) tablespace GWS_INDEX;
create index hpr_charge_documents_i2 on hpr_charge_documents(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_charge_documents_i3 on hpr_charge_documents(company_id, created_by) tablespace GWS_INDEX;
create index hpr_charge_documents_i4 on hpr_charge_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_charge_document_operations(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  operation_id                    number(20)        not null,
  staff_id                        number(20)        not null,
  amount                          number(20, 6)     not null,
  note                            varchar2(300 char),
  constraint hpr_charge_document_operations_pk primary key (company_id, filial_id, operation_id) using index tablespace GWS_INDEX,
  constraint hpr_charge_document_operations_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpr_charge_document_operations_f2 foreign key (company_id, filial_id, document_id) references hpr_charge_documents(company_id, filial_id, document_id) on delete cascade,
  constraint hpr_charge_document_operations_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id)
) tablespace GWS_DATA;

create index hpr_charge_document_operations_i1 on hpr_charge_document_operations(company_id, filial_id, document_id) tablespace GWS_INDEX;
create index hpr_charge_document_operations_i2 on hpr_charge_document_operations(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpr_charges drop constraint hpr_charges_c4;

alter table hpr_charges add doc_oper_id number(20);

alter table hpr_charges add constraint hpr_charges_c4 check (status in ('D', 'N', 'U', 'C'));
alter table hpr_charges add constraint hpr_charges_c5 check (not (status = 'D' and doc_oper_id is null));
alter table hpr_charges add constraint hpr_charges_c6 check (nvl2(doc_oper_id, 1, 0) = nvl2(interval_id, 0, 1));

comment on column hpr_charges.status is '(D)raft, (N)ew, (U)sed, (C)ompleted';

alter table hpr_charges modify schedule_id null;
alter table hpr_charges modify interval_id null;

alter table hpr_charges add constraint hpr_charges_f10 foreign key(company_id, filial_id, doc_oper_id) 
                        references hpr_charge_document_operations(company_id , filial_id , operation_id) on delete cascade;
                        
create index hpr_charges_i10 on hpr_charges(company_id, filial_id, doc_oper_id) tablespace GWS_INDEX;

create unique index hpr_charges_u2 on hpr_charges(nvl2(doc_oper_id, company_id, null), nvl2(doc_oper_id, filial_id, null), doc_oper_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
prompt adding oauth2 tables
----------------------------------------------------------------------------------------------------
create table hes_oauth2_providers(
  provider_id                     number(20)    not null,
  token_url                       varchar2(250) not null,
  auth_url                        varchar2(250) not null,
  provider_name                   varchar2(250) not null,
  redirect_uri                    varchar2(250) not null,
  content_type                    varchar2(250) not null,
  scope                           varchar2(250),
  constraint hes_oauth2_providers_pk primary key (provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_providers_u1 unique (redirect_uri) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on column hes_oauth2_providers.content_type is 'Content type of get access token request to provider. (application/json or application/x-www-form-urlencoded)';

----------------------------------------------------------------------------------------------------
create table hes_oauth2_credentials(
  company_id                      number(20)    not null,
  provider_id                     number(20)    not null,
  client_id                       varchar2(128) not null,
  client_secret                   varchar2(128) not null,
  constraint hes_oauth2_credentials_pk primary key (company_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_credentials_f2 foreign key (company_id) references md_companies(company_id) on delete cascade,
  constraint hes_oauth2_credentials_f1 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_credentials_i1 on hes_oauth2_credentials(provider_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hes_oauth2_session_states(
  company_id                      number(20)    not null,
  session_id                      number(20)    not null,
  provider_id                     number(20)    not null,
  state_token                     varchar2(128) not null,
  constraint hes_oauth2_session_states_pk primary key (company_id, session_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_session_states_u1 unique (state_token) using index tablespace GWS_INDEX,
  constraint hes_oauth2_session_states_f1 foreign key (company_id, session_id) references kauth_sessions(company_id, session_id) on delete cascade,
  constraint hes_oauth2_session_states_f2 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_session_states_i1 on hes_oauth2_session_states(provider_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hes_oauth2_tokens(
  company_id                      number(20)    not null,
  user_id                         number(20)    not null,
  provider_id                     number(20)    not null,
  access_token                    varchar2(128) not null,
  refresh_token                   varchar2(128),
  expires_on                      timestamp with local time zone,
  constraint hes_oauth2_tokens_pk primary key (company_id, user_id, provider_id) using index tablespace GWS_INDEX,
  constraint hes_oauth2_tokens_f1 foreign key (company_id, user_id) references md_users(company_id, user_id) on delete cascade,
  constraint hes_oauth2_tokens_f2 foreign key (provider_id) references hes_oauth2_providers(provider_id) on delete cascade
) tablespace GWS_DATA;

create index hes_oauth2_tokens_i1 on hes_oauth2_tokens(provider_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hh integration
----------------------------------------------------------------------------------------------------
prompt add tables for data mapping
----------------------------------------------------------------------------------------------------  
create table hrec_head_hunter_jobs(
  company_id                      number(20)         not null,
  code                            number(20)         not null,
  name                            varchar2(100 char) not null,
  constraint hrec_head_hunter_jobs_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_head_hunter_jobs is 'Keeps Jobs from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_head_hunter_regions(
  company_id                      number(20)         not null,
  code                            number(20)         not null,
  name                            varchar2(100 char) not null,
  parent_id                       number(20),
  constraint hrec_head_hunter_regions_pk primary key (company_id, code) using index tablespace GWS_INDEX,
  constraint hrec_head_hunter_regions_f1 foreign key (company_id, parent_id) references hrec_head_hunter_regions(company_id, code) on delete cascade
) tablespace GWS_DATA;

comment on table hrec_head_hunter_regions is 'Keeps Regions from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_head_hunter_stages(
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_head_hunter_stages_pk primary key (code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_head_hunter_stages is 'Keeps Static Stages';

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_jobs(
  company_id                      number(20) not null,
  job_group_id                    number(20) not null,
  job_group_code                  number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_hh_integration_jobs_pk primary key (company_id, job_group_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_jobs_f1 foreign key (company_id, job_group_id) references mhr_job_groups(company_id, job_group_id) on delete cascade,
  constraint hrec_hh_integration_jobs_f2 foreign key (company_id, job_group_code) references hrec_head_hunter_jobs(company_id, code) on delete cascade,
  constraint hrec_hh_integration_jobs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade,
  constraint hrec_hh_integration_jobs_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_jobs_i1 on hrec_hh_integration_jobs(company_id, job_group_code) tablespace GWS_INDEX;
create index hrec_hh_integration_jobs_i2 on hrec_hh_integration_jobs(company_id, created_by) tablespace GWS_INDEX;
create index hrec_hh_integration_jobs_i3 on hrec_hh_integration_jobs(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_regions(
  company_id                      number(20) not null,
  region_id                       number(20) not null,
  region_code                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_hh_integration_regions_pk primary key (company_id, region_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_regions_f1 foreign key (company_id, region_id) references md_regions(company_id, region_id) on delete cascade,
  constraint hrec_hh_integration_regions_f2 foreign key (company_id, region_code) references hrec_head_hunter_regions(company_id, code) on delete cascade,
  constraint hrec_hh_integration_regions_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade,
  constraint hrec_hh_integration_regions_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_regions_i1 on hrec_hh_integration_regions(company_id, region_code) tablespace GWS_INDEX;
create index hrec_hh_integration_regions_i2 on hrec_hh_integration_regions(company_id, created_by) tablespace GWS_INDEX;
create index hrec_hh_integration_regions_i3 on hrec_hh_integration_regions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------    
create table hrec_hh_integration_stages(
  company_id                      number(20)        not null,
  stage_id                        number(20)        not null,
  stage_code                      varchar2(50 char) not null,
  constraint hrec_hh_integration_stages_pk primary key (company_id, stage_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_stages_f1 foreign key (stage_code) references hrec_head_hunter_stages(code) on delete cascade,
  constraint hrec_hh_integration_stages_f2 foreign key (company_id, stage_id) references hrec_stages(company_id, stage_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_stages_i1 on hrec_hh_integration_stages(company_id, stage_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------    
create table hrec_hh_employer_ids(
  company_id                      number(20)         not null,
  employer_id                     varchar2(100 char) not null,
  constraint hrec_hh_employer_ids_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_employer_ids_u1 unique (employer_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
prompt new table for publis vacancies
---------------------------------------------------------------------------------------------------- 
create table hrec_hh_published_vacancies(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  vacancy_id                      number(20)         not null,  
  vacancy_code                    varchar2(250 char) not null,
  billing_type                    varchar2(50 char)  not null,
  vacancy_type                    varchar2(50 char)  not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_hh_published_vacancies_pk primary key (company_id, filial_id, vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_published_vacancies_u1 unique (company_id, filial_id, vacancy_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_published_vacancies_u2 unique (company_id, vacancy_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_published_vacancies_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_hh_published_vacancies_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_hh_published_vacancies_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on column hrec_hh_published_vacancies.vacancy_code is 'Keep returned ID from Head Hunter';

create index hrec_hh_published_vacancies_i1 on hrec_hh_published_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_hh_published_vacancies_i2 on hrec_hh_published_vacancies(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table hrec_hh_subscriptions(
  company_id                      number(20)         not null,
  subscription_code               varchar2(100 char) not null,
  created_by                      number(20)         not null,
  constraint hrec_hh_subscriptions_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_subscriptions_u1 unique (subscription_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_subscriptions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hrec_hh_subscriptions_i1 on hrec_hh_subscriptions(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_events(
  company_id                      number(20)         not null,
  event_code                      varchar2(100 char) not null,
  subscription_code               varchar2(100 char) not null,
  event_type                      varchar2(100 char) not null,
  user_code                       varchar2(100 char) not null,
  constraint hrec_hh_events_pk primary key (company_id, event_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Filial Level Integration (Head Hunter)
----------------------------------------------------------------------------------------------------
create table hrec_hh_resumes(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  resume_code                     varchar2(100 char) not null,
  candidate_id                    number(20)         not null,
  first_name                      varchar2(100 char),
  last_name                       varchar2(100 char),
  middle_name                     varchar2(100 char),
  gender_code                     varchar2(100 char),
  date_of_birth                   date,
  extra_data                      varchar2(4000),
  constraint hrec_hh_resumes_pk primary key (company_id, filial_id, resume_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_resumes_u1 unique (company_id, filial_id, candidate_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_resumes_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_hh_negotiations(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  topic_code                      varchar2(100 char) not null,
  event_code                      varchar2(100 char),
  negotiation_date                timestamp with local time zone,
  vacancy_code                    varchar2(100 char) not null,
  resume_code                     varchar2(100 char) not null,
  constraint hrec_hh_negotiations_pk primary key (company_id, filial_id, topic_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_negotiations_u1 unique (company_id, topic_code) using index tablespace GWS_INDEX,
  constraint hrec_hh_negotiations_f1 foreign key (company_id, event_code) references hrec_hh_events(company_id, event_code) on delete cascade,
  constraint hrec_hh_negotiations_f2 foreign key (company_id, filial_id, vacancy_code) references hrec_hh_published_vacancies(company_id, filial_id, vacancy_code) on delete cascade,
  constraint hrec_hh_negotiations_f3 foreign key (company_id, filial_id, resume_code) references hrec_hh_resumes(company_id, filial_id, resume_code) on delete cascade deferrable initially deferred
) tablespace GWS_DATA;

create unique index hrec_hh_negotiations_u2 on hrec_hh_negotiations(nvl2(event_code, company_id, null), event_code) tablespace GWS_INDEX;
create unique index hrec_hh_negotiations_u3 on hrec_hh_negotiations(company_id, filial_id, vacancy_code, resume_code) tablespace GWS_INDEX;

create index hrec_hh_negotiations_i1 on hrec_hh_negotiations(company_id, filial_id, vacancy_code) tablespace GWS_INDEX;
create index hrec_hh_negotiations_i2 on hrec_hh_negotiations(company_id, filial_id, resume_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add name column for vacancies
----------------------------------------------------------------------------------------------------        
alter table Hrec_Vacancies add name varchar2(100 char);
alter table Hrec_Vacancies add region_id number(20);

alter table hrec_vacancies rename constraint hrec_vacancies_f6 to hrec_vacancies_f7;
alter table hrec_vacancies rename constraint hrec_vacancies_f5 to hrec_vacancies_f6;

alter table hrec_vacancies add constraint hrec_vacancies_f5 foreign key (company_id, region_id) references md_regions(company_id, region_id);

alter index hrec_vacancies_i6 rename to hrec_vacancies_i7;
alter index hrec_vacancies_i5 rename to hrec_vacancies_i6;
create index hrec_vacancies_i5 on hrec_vacancies(company_id, region_id) tablespace GWS_INDEX;

alter table hrec_vacancies rename constraint hrec_vacancies_c9 to hrec_vacancies_c10;
alter table hrec_vacancies rename constraint hrec_vacancies_c8 to hrec_vacancies_c9;
alter table hrec_vacancies rename constraint hrec_vacancies_c7 to hrec_vacancies_c8;
alter table hrec_vacancies rename constraint hrec_vacancies_c6 to hrec_vacancies_c7;
alter table hrec_vacancies rename constraint hrec_vacancies_c5 to hrec_vacancies_c6;
alter table hrec_vacancies rename constraint hrec_vacancies_c4 to hrec_vacancies_c5;
alter table hrec_vacancies rename constraint hrec_vacancies_c3 to hrec_vacancies_c4;
alter table hrec_vacancies rename constraint hrec_vacancies_c2 to hrec_vacancies_c3;
alter table hrec_vacancies rename constraint hrec_vacancies_c1 to hrec_vacancies_c2;
alter table hrec_vacancies add constraint hrec_vacancies_c1 check (decode(trim(name), name, 1, 0) = 1);

----------------------------------------------------------------------------------------------------
prompt adding charge document sequences
----------------------------------------------------------------------------------------------------
create sequence hpr_charge_documents_sq;
create sequence hpr_charge_document_operations_sq;

