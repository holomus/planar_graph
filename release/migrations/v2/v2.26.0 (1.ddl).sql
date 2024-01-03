prompt adding hpd_journal_divisions
----------------------------------------------------------------------------------------------------
create table hpd_journal_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20) not null,
  constraint hpd_journal_divisions_pk primary key (company_id, filial_id, journal_id, division_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_divisions_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt add Recruitment Module
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
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  vacancy_id                      number(20)  not null,
  opened_date                     date        not null,
  closed_date                     date,
  deadline                        date,
  application_id                  number(20),
  division_id                     number(20)  not null,
  job_id                          number(20)  not null,
  funnel_id                       number(20)  not null,
  quantity                        number(20)  not null,
  scope                           varchar2(1) not null,
  urgent                          varchar2(1) not null,
  wage                            number(20,6),
  responsibilities                varchar2(4000),
  requirements                    varchar2(4000),
  status                          varchar2(1) not null,
  note                            varchar2(300 char),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_vacancies_pk primary key (company_id, filial_id, vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancies_u1 unique (vacancy_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancies_f1 foreign key (company_id, filial_id, application_id) references hrec_applications(company_id, filial_id, application_id),
  constraint hrec_vacancies_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hrec_vacancies_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hrec_vacancies_f4 foreign key (company_id, funnel_id) references hrec_funnels(company_id, funnel_id),
  constraint hrec_vacancies_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancies_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_vacancies_c1 check (trunc(opened_date) = opened_date),
  constraint hrec_vacancies_c2 check (trunc(closed_date) = closed_date),
  constraint hrec_vacancies_c3 check (trunc(deadline) = deadline),
  constraint hrec_vacancies_c4 check (quantity > 0),
  constraint hrec_vacancies_c5 check (scope in ('A', 'E', 'N')),
  constraint hrec_vacancies_c6 check (urgent in ('Y', 'N')),
  constraint hrec_vacancies_c7 check (wage > 0),
  constraint hrec_vacancies_c8 check (status in ('O', 'C')),
  constraint hrec_vacancies_c9 check (status = 'O' or closed_date is not null)
) tablespace GWS_DATA;

comment on column hrec_vacancies.scope is '(A)ll, (E)mployees, (N)on-employees';
comment on column hrec_vacancies.urgent is '(Y)es, (N)o';
comment on column hrec_vacancies.status is '(O)pen, (C)losed';

create index hrec_vacancies_i1 on hrec_vacancies(company_id, filial_id, application_id) tablespace GWS_INDEX;
create index hrec_vacancies_i2 on hrec_vacancies(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hrec_vacancies_i3 on hrec_vacancies(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrec_vacancies_i4 on hrec_vacancies(company_id, funnel_id) tablespace GWS_INDEX;
create index hrec_vacancies_i5 on hrec_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancies_i6 on hrec_vacancies(company_id, modified_by) tablespace GWS_INDEX;

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
-- Sequences
----------------------------------------------------------------------------------------------------
create sequence hrec_stages_sq;
create sequence hrec_funnels_sq;
create sequence hrec_reject_reasons_sq;
create sequence hrec_applications_sq;
create sequence hrec_vacancies_sq;
create sequence hrec_operations_sq;
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hrec');
