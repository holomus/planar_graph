prompt Recruiting module
prompt (c) 2023 Verifix HR

----------------------------------------------------------------------------------------------------
-- Vacancy Groups and Types
----------------------------------------------------------------------------------------------------
create table hrec_vacancy_groups(
  company_id                      number(20)         not null,
  vacancy_group_id                number(20)         not null, 
  name                            varchar2(100 char) not null,
  order_no                        number(6),
  is_required                     varchar2(1)        not null,
  multiple_select                 varchar2(1)        not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_vacancy_groups_pk primary key (company_id, vacancy_group_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_groups_u1 unique (vacancy_group_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_groups_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_groups_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_vacancy_groups_c2 check (is_required in ('Y', 'N')),
  constraint hrec_vacancy_groups_c3 check (multiple_select in ('Y', 'N')),
  constraint hrec_vacancy_groups_c4 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_vacancy_groups_c5 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint hrec_vacancy_groups_c6 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hrec_vacancy_groups_u2 on hrec_vacancy_groups(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_vacancy_groups_u3 on hrec_vacancy_groups(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_vacancy_groups_u4 on hrec_vacancy_groups(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_vacancy_groups_i1 on hrec_vacancy_groups(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancy_groups_i2 on hrec_vacancy_groups(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_types(
  company_id                      number(20)         not null,
  vacancy_type_id                 number(20)         not null,
  vacancy_group_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_vacancy_types_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_u1 unique (vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_u2 unique (company_id, vacancy_group_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_f1 foreign key (company_id, vacancy_group_id) references hrec_vacancy_groups(company_id, vacancy_group_id) on delete cascade,
  constraint hrec_vacancy_types_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_types_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_vacancy_types_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_vacancy_types_c3 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint hrec_vacancy_types_c4 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hrec_vacancy_types_u3 on hrec_vacancy_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_vacancy_types_u4 on hrec_vacancy_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_vacancy_types_u5 on hrec_vacancy_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_vacancy_types_i1 on hrec_vacancy_types(company_id, vacancy_group_id) tablespace GWS_INDEX;
create index hrec_vacancy_types_i2 on hrec_vacancy_types(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancy_types_i3 on hrec_vacancy_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Reference
----------------------------------------------------------------------------------------------------
create table hrec_stages(
  company_id                      number(20)         not null,
  stage_id                        number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  order_no                        number(6)          not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_stages_pk primary key (company_id, stage_id) using index tablespace GWS_INDEX,
  constraint hrec_stages_u1 unique (stage_id) using index tablespace GWS_INDEX,
  constraint hrec_stages_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_stages_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_stages_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_stages_c2 check (state in ('A', 'P')),
  constraint hrec_stages_c3 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_stages_c4 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index hrec_stages_u2 on hrec_stages(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_stages_u3 on hrec_stages(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_stages_u4 on hrec_stages(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_stages_i1 on hrec_stages(company_id, created_by) tablespace GWS_INDEX;
create index hrec_stages_i2 on hrec_stages(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_funnels(
  company_id                      number(20)         not null,
  funnel_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_funnels_pk primary key (company_id, funnel_id) using index tablespace GWS_INDEX,
  constraint hrec_funnels_u1 unique (funnel_id) using index tablespace GWS_INDEX,
  constraint hrec_funnels_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_funnels_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_funnels_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_funnels_c2 check (state in ('A', 'P')),
  constraint hrec_funnels_c3 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_funnels_c4 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index hrec_funnels_u2 on hrec_funnels(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_funnels_u3 on hrec_funnels(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_funnels_u4 on hrec_funnels(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_funnels_i1 on hrec_funnels(company_id, created_by) tablespace GWS_INDEX;
create index hrec_funnels_i2 on hrec_funnels(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_funnel_stages(
  company_id                      number(20) not null,
  funnel_id                       number(20) not null,
  stage_id                        number(20) not null,
  constraint hrec_funnel_stages_pk primary key (company_id, funnel_id, stage_id) using index tablespace GWS_INDEX,
  constraint hrec_funnel_stages_f1 foreign key (company_id, funnel_id) references hrec_funnels(company_id, funnel_id) on delete cascade,
  constraint hrec_funnel_stages_f2 foreign key (company_id, stage_id) references hrec_stages(company_id, stage_id)
) tablespace GWS_DATA;

create index hrec_funnel_stages_i1 on hrec_funnel_stages(company_id, stage_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_reject_reasons(
  company_id                      number(20)         not null,
  reject_reason_id                number(20)         not null,
  name                            varchar2(300 char) not null,
  state                           varchar2(1)        not null,
  order_no                        number(6),
  code                            varchar2(50),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_reject_reasons_pk primary key (company_id, reject_reason_id) using index tablespace GWS_INDEX,
  constraint hrec_reject_reasons_u1 unique (reject_reason_id) using index tablespace GWS_INDEX,
  constraint hrec_reject_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_reject_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_reject_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_reject_reasons_c2 check (state in ('A', 'P')),
  constraint hrec_reject_reasons_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index hrec_reject_reasons_u2 on hrec_reject_reasons(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_reject_reasons_u3 on hrec_reject_reasons(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index hrec_reject_reasons_i1 on hrec_reject_reasons(company_id, created_by) tablespace GWS_INDEX;
create index hrec_reject_reasons_i2 on hrec_reject_reasons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Application
----------------------------------------------------------------------------------------------------
create table hrec_applications(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  application_id                  number(20)        not null,
  application_number              varchar2(50 char) not null,
  division_id                     number(20)        not null,
  job_id                          number(20)        not null,
  quantity                        number(20)        not null,
  wage                            number(20,6),
  responsibilities                varchar2(4000),
  requirements                    varchar2(4000),
  status                          varchar2(1)       not null,
  note                            varchar2(300 char),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_applications_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hrec_applications_u1 unique (application_id) using index tablespace GWS_INDEX,
  constraint hrec_applications_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hrec_applications_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hrec_applications_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_applications_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_applications_c1 check (decode(trim(application_number), application_number, 1, 0) = 1),
  constraint hrec_applications_c2 check (quantity > 0),
  constraint hrec_applications_c3 check (wage > 0),
  constraint hrec_applications_c4 check (status in ('D', 'W', 'A', 'O', 'C'))
) tablespace GWS_DATA;

comment on column hrec_applications.status is '(D)raft, (W)aiting, (A)pproved, c(O)mpleted, (C)anceled';

create index hrec_applications_i1 on hrec_applications(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hrec_applications_i2 on hrec_applications(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrec_applications_i3 on hrec_applications(company_id, created_by) tablespace GWS_INDEX;
create index hrec_applications_i4 on hrec_applications(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Recruitment
----------------------------------------------------------------------------------------------------
create table hrec_vacancies(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  vacancy_id                      number(20)         not null,
  name                            varchar2(100 char) not null,
  opened_date                     date               not null,
  closed_date                     date,
  deadline                        date,
  application_id                  number(20),
  division_id                     number(20)         not null,
  job_id                          number(20)         not null,
  funnel_id                       number(20)         not null,
  quantity                        number(20)         not null,
  scope                           varchar2(1)        not null,
  urgent                          varchar2(1)        not null,
  wage_from                       number(20,6),
  wage_to                         number(20,6),
  region_id                       number(20),
  schedule_id                     number(20),
  exam_id                         number(20),
  status                          varchar2(1)        not null,
  description                     varchar2(4000),
  description_in_html             varchar2(4000),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint hrec_vacancies_pk primary key (company_id, filial_id, vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancies_u1 unique (vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancies_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancies_f1 foreign key (company_id, filial_id, application_id) references hrec_applications(company_id, filial_id, application_id),
  constraint hrec_vacancies_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hrec_vacancies_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hrec_vacancies_f4 foreign key (company_id, funnel_id) references hrec_funnels(company_id, funnel_id),
  constraint hrec_vacancies_f5 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint hrec_vacancies_f6 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hrec_vacancies_f7 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id),
  constraint hrec_vacancies_f8 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancies_f9 foreign key (company_id, modified_by) references md_users(company_id, user_id),  
  constraint hrec_vacancies_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_vacancies_c2 check (trunc(opened_date) = opened_date),
  constraint hrec_vacancies_c3 check (trunc(closed_date) = closed_date),
  constraint hrec_vacancies_c4 check (trunc(deadline) = deadline),
  constraint hrec_vacancies_c5 check (quantity > 0),
  constraint hrec_vacancies_c6 check (scope in ('A', 'E', 'N')),
  constraint hrec_vacancies_c7 check (urgent in ('Y', 'N')),  
  constraint hrec_vacancies_c8 check (wage_from > 0),
  constraint hrec_vacancies_c9 check (wage_to >= wage_from),  
  constraint hrec_vacancies_c10 check (status in ('O', 'C')),
  constraint hrec_vacancies_c11 check (status = 'O' or closed_date is not null)
) tablespace GWS_DATA;

comment on column hrec_vacancies.scope is '(A)ll, (E)mployees, (N)on-employees';
comment on column hrec_vacancies.urgent is '(Y)es, (N)o';
comment on column hrec_vacancies.status is '(O)pen, (C)losed';
comment on column hrec_vacancies.description is 'Description about this Vacancy';
comment on column hrec_vacancies.description_in_html is 'Description in Html format. We can use for publish to another server like Head Hunter';

create index hrec_vacancies_i1 on hrec_vacancies(company_id, filial_id, application_id) tablespace GWS_INDEX;
create index hrec_vacancies_i2 on hrec_vacancies(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hrec_vacancies_i3 on hrec_vacancies(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrec_vacancies_i4 on hrec_vacancies(company_id, funnel_id) tablespace GWS_INDEX;
create index hrec_vacancies_i5 on hrec_vacancies(company_id, region_id) tablespace GWS_INDEX;
create index hrec_vacancies_i6 on hrec_vacancies(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hrec_vacancies_i7 on hrec_vacancies(company_id, filial_id, exam_id) tablespace GWS_INDEX;
create index hrec_vacancies_i8 on hrec_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancies_i9 on hrec_vacancies(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_langs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  lang_id                         number(20) not null,
  lang_level_id                   number(20) not null,
  constraint hrec_vacancy_langs_pk primary key (company_id, filial_id, vacancy_id, lang_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_langs_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_langs_f2 foreign key (company_id, lang_id) references href_langs(company_id, lang_id),
  constraint hrec_vacancy_langs_f3 foreign key (company_id, lang_level_id) references href_lang_levels(company_id, lang_level_id)
) tablespace GWS_DATA;

create index hrec_vacancy_langs_i1 on hrec_vacancy_langs(company_id, lang_id) tablespace GWS_INDEX;
create index hrec_vacancy_langs_i2 on hrec_vacancy_langs(company_id, lang_level_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_recruiters(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  user_id                         number(20) not null,
  constraint hrec_vacancy_recruiters_pk primary key (company_id, filial_id, vacancy_id, user_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_recruiters_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_recruiters_f2 foreign key (company_id, user_id) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on column hrec_vacancy_recruiters.user_id is 'selected from users who has Recruiter role';

create index hrec_vacancy_recruiters_i1 on hrec_vacancy_recruiters(company_id, user_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_candidates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  candidate_id                    number(20) not null,
  stage_id                        number(20) not null,
  reject_reason_id                number(20),
  constraint hrec_vacancy_candidates_pk primary key (company_id, filial_id, vacancy_id, candidate_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_candidates_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_candidates_f2 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id),
  constraint hrec_vacancy_candidates_f3 foreign key (company_id, stage_id) references hrec_stages(company_id, stage_id),
  constraint hrec_vacancy_candidates_f4 foreign key (company_id, reject_reason_id) references hrec_reject_reasons(company_id, reject_reason_id)
) tablespace GWS_DATA;

create index hrec_vacancy_candidates_i1 on hrec_vacancy_candidates(company_id, filial_id, candidate_id) tablespace GWS_INDEX;
create index hrec_vacancy_candidates_i2 on hrec_vacancy_candidates(company_id, stage_id) tablespace GWS_INDEX;
create index hrec_vacancy_candidates_i3 on hrec_vacancy_candidates(company_id, reject_reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_type_binds(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  vacancy_group_id                number(20) not null,
  vacancy_type_id                 number(20) not null,
  constraint hrec_vacancy_type_binds_pk primary key (company_id, filial_id, vacancy_id, vacancy_group_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_type_binds_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_type_binds_f2 foreign key (company_id, vacancy_group_id) references hrec_vacancy_groups(company_id, vacancy_group_id),
  constraint hrec_vacancy_type_binds_f3 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id)
) tablespace GWS_DATA;

create index hrec_vacancy_type_binds_i1 on hrec_vacancy_type_binds(company_id, vacancy_group_id) tablespace GWS_INDEX;
create index hrec_vacancy_type_binds_i2 on hrec_vacancy_type_binds(company_id, vacancy_type_id) tablespace GWS_INDEX;

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
create table hrec_operations(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  operation_id                    number(20)  not null,
  operation_kind                  varchar2(1) not null,
  vacancy_id                      number(20)  not null,
  candidate_id                    number(20)  not null,
  from_stage_id                   number(20),
  to_stage_id                     number(20),
  reject_reason_id                number(20),
  note                            varchar2(2000),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_operations_pk primary key (company_id, filial_id, operation_id) using index tablespace GWS_INDEX,
  constraint hrec_operations_u1 unique (operation_id) using index tablespace GWS_INDEX,
  constraint hrec_operations_f1 foreign key (company_id, filial_id, vacancy_id, candidate_id) references hrec_vacancy_candidates(company_id, filial_id, vacancy_id, candidate_id) on delete cascade,
  constraint hrec_operations_f2 foreign key (company_id, from_stage_id) references hrec_stages(company_id, stage_id),
  constraint hrec_operations_f3 foreign key (company_id, to_stage_id) references hrec_stages(company_id, stage_id),
  constraint hrec_operations_f4 foreign key (company_id, reject_reason_id) references hrec_reject_reasons(company_id, reject_reason_id),
  constraint hrec_operations_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_operations_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_operations_c1 check (operation_kind in ('A', 'N')),
  constraint hrec_operations_c2 check (operation_kind = 'N' or to_stage_id is not null),
  constraint hrec_operations_c3 check (operation_kind = 'A' or note is not null)
) tablespace GWS_DATA;

comment on column hrec_operations.operation_kind is '(A)ction, (N)ote';

create index hrec_operations_i1 on hrec_operations(company_id, filial_id, vacancy_id, candidate_id) tablespace GWS_INDEX;
create index hrec_operations_i2 on hrec_operations(company_id, from_stage_id) tablespace GWS_INDEX;
create index hrec_operations_i3 on hrec_operations(company_id, to_stage_id) tablespace GWS_INDEX;
create index hrec_operations_i4 on hrec_operations(company_id, reject_reason_id) tablespace GWS_INDEX;
create index hrec_operations_i5 on hrec_operations(company_id, created_by) tablespace GWS_INDEX;
create index hrec_operations_i6 on hrec_operations(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
-- External Systems Data Mapping (Head Hunter)
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
create table hrec_hh_experiences(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_experiences_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_experiences is 'Keeps Experiences from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_employments(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_employments_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_employments is 'Keeps Employments from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_schedules(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_schedules_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_schedules is 'Keeps Schedules from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_driver_licences(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_driver_licences_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_driver_licences is 'Keeps Driver Licences from Head Hunter';

----------------------------------------------------------------------------------------------------                         
create table hrec_hh_langs(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_langs_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_langs is 'Keeps Langs from Head Hunter';

----------------------------------------------------------------------------------------------------                         
create table hrec_hh_lang_levels(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_lang_levels_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_lang_levels is 'Keeps Lang Levels from Head Hunter';

----------------------------------------------------------------------------------------------------                         
create table hrec_hh_key_skills(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_key_skills_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_jobs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  job_code                        number(20) not null,
  job_id                          number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_jobs_pk primary key (company_id, filial_id, job_code, job_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_jobs_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade,
  constraint hrec_hh_integration_jobs_f2 foreign key (company_id, job_code) references hrec_head_hunter_jobs(company_id, code) on delete cascade,
  constraint hrec_hh_integration_jobs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_jobs_i1 on hrec_hh_integration_jobs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrec_hh_integration_jobs_i2 on hrec_hh_integration_jobs(company_id, created_by) tablespace GWS_INDEX;

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
create table hrec_hh_integration_experiences(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  experience_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_experiences_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_experiences_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_experiences_f2 foreign key (company_id, experience_code) references hrec_hh_experiences(company_id, code) on delete cascade,
  constraint hrec_hh_integration_experiences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_experiences_i1 on hrec_hh_integration_experiences(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_employments(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  employment_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_employments_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_employments_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_employments_f2 foreign key (company_id, employment_code) references hrec_hh_employments(company_id, code) on delete cascade,
  constraint hrec_hh_integration_employments_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_employments_i1 on hrec_hh_integration_employments(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
create table hrec_hh_integration_schedules(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  schedule_id                     number(20)   not null,
  schedule_code                   varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_schedules_pk primary key (company_id, filial_id, schedule_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_schedules_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint hrec_hh_integration_schedules_f2 foreign key (company_id, schedule_code) references hrec_hh_schedules(company_id, code) on delete cascade,
  constraint hrec_hh_integration_schedules_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_schedules_i1 on hrec_hh_integration_schedules(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_langs(
  company_id                      number(20)   not null,
  lang_id                         number(20)   not null,
  lang_code                       varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_langs_pk primary key (company_id, lang_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_langs_f1 foreign key (company_id, lang_id) references href_langs(company_id, lang_id) on delete cascade,
  constraint hrec_hh_integration_langs_f2 foreign key (company_id, lang_code) references hrec_hh_langs(company_id, code) on delete cascade,
  constraint hrec_hh_integration_langs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_langs_i1 on hrec_hh_integration_langs(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_lang_levels(
  company_id                      number(20)   not null,
  lang_level_id                   number(20)   not null,
  lang_level_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_lang_levels_pk primary key (company_id, lang_level_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_lang_levels_f1 foreign key (company_id, lang_level_id) references href_lang_levels(company_id, lang_level_id) on delete cascade,
  constraint hrec_hh_integration_lang_levels_f2 foreign key (company_id, lang_level_code) references hrec_hh_lang_levels(company_id, code) on delete cascade,
  constraint hrec_hh_integration_lang_levels_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_lang_levels_i1 on hrec_hh_integration_lang_levels(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_driver_licences(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  licence_code                    varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_driver_licences_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_driver_licences_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_driver_licences_f2 foreign key (company_id, licence_code) references hrec_hh_driver_licences(company_id, code) on delete cascade,
  constraint hrec_hh_integration_driver_licences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_driver_licences_i1 on hrec_hh_integration_driver_licences(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_employer_ids(
  company_id                      number(20)         not null,
  employer_id                     varchar2(100 char) not null,
  constraint hrec_hh_employer_ids_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_employer_ids_u1 unique (employer_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

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
-- Integration With OLX
----------------------------------------------------------------------------------------------------
create table hrec_olx_job_categories(
  company_id                      number(20)         not null,
  category_code                   number(20)         not null,
  name                            varchar2(100 char) not null,
  constraint hrec_olx_job_categories_pk primary key (company_id, category_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_attributes(
  company_id                      number(20)    not null,
  category_code                   number(20)    not null,
  attribute_code                  varchar2(50)  not null,
  label                           varchar2(200) not null,
  validation_type                 varchar2(50)  not null,
  is_require                      varchar2(1)   not null,
  is_number                       varchar2(1)   not null,
  min_value                       number(20),
  max_value                       number(20),
  is_allow_multiple_values        varchar2(1),
  constraint hrec_olx_attributes_pk primary key (company_id, category_code, attribute_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_attributes_f1 foreign key (company_id, category_code) references hrec_olx_job_categories(company_id, category_code) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_attribute_values(
  company_id                      number(20)    not null,  
  category_code                   number(20)    not null,
  attribute_code                  varchar2(50)  not null,
  code                            varchar2(50)  not null,
  label                           varchar2(100) not null, 
  constraint hrec_olx_attribute_values_pk primary key (company_id, category_code, attribute_code, code) using index tablespace GWS_INDEX,
  constraint hrec_olx_attribute_values_f1 foreign key (company_id, category_code, attribute_code) references hrec_olx_attributes(company_id, category_code, attribute_code) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_regions(
  company_id                      number(20)         not null,
  region_code                     number(20)         not null,
  name                            varchar2(100 char) not null,
  constraint hrec_olx_regions_pk primary key (company_id, region_code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hrec_olx_cities(
  company_id                      number(20)         not null,
  city_code                       number(20)         not null,
  region_code                     number(20)         not null,  
  name                            varchar2(100 char) not null,
  constraint hrec_olx_cities_pk primary key (company_id, city_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_cities_f1 foreign key (company_id, region_code) references hrec_olx_regions(company_id, region_code) on delete cascade  
) tablespace GWS_DATA;

create index hrec_olx_cities_i1 on hrec_olx_cities(company_id, region_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_olx_districts(
  company_id                      number(20)         not null,
  district_code                   number(20)         not null,
  city_code                       number(20)         not null,  
  name                            varchar2(100 char) not null,
  constraint hrec_olx_districts_pk primary key (company_id, district_code) using index tablespace GWS_INDEX,
  constraint hrec_olx_districts_f1 foreign key (company_id, city_code) references hrec_olx_cities(company_id, city_code) on delete cascade
) tablespace GWS_DATA;

create index hrec_olx_districts_i1 on hrec_olx_districts(company_id, city_code) tablespace GWS_INDEX;

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
  constraint hrec_olx_integration_regions_f2 foreign key (company_id, city_code) references hrec_olx_cities(company_id, city_code) on delete cascade,
  constraint hrec_olx_integration_regions_f3 foreign key (company_id, district_code) references hrec_olx_districts(company_id, district_code) on delete cascade,
  constraint hrec_olx_integration_regions_f4 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade,
  constraint hrec_olx_integration_regions_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_olx_integration_regions_i1 on hrec_olx_integration_regions(company_id, city_code) tablespace GWS_INDEX;
create index hrec_olx_integration_regions_i2 on hrec_olx_integration_regions(company_id, district_code) tablespace GWS_INDEX;
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
  constraint hrec_olx_published_vacancy_attributes_f2 foreign key (company_id, category_code, code) references hrec_olx_attributes(company_id, category_code, attribute_code),
  constraint hrec_olx_published_vacancy_attributes_f3 foreign key (company_id, category_code, code, value) references hrec_olx_attribute_values(company_id, category_code, attribute_code, code)
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
create table hrec_telegram_candidates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null, 
  candidate_id                    number(20) not null,
  contact_code                      number(20) not null,
  constraint hrec_telegram_candidates_pk primary key (company_id, filial_id, candidate_id) using index tablespace GWS_INDEX,
  constraint hrec_telegram_candidates_u1 unique (company_id, filial_id, contact_code) using index tablespace GWS_INDEX,
  constraint hrec_telegram_candidates_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade
) tablespace GWS_DATA;

comment on table hrec_telegram_candidates is 'Candidates created from telegram bot';

comment on column hrec_telegram_candidates.contact_code is 'Telegram ID of candidate';
