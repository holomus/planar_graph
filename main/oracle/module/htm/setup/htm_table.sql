prompt Talent Management
prompt (c) 2023 Verifix HR
----------------------------------------------------------------------------------------------------
-- Experience
----------------------------------------------------------------------------------------------------
create table htm_experiences(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  experience_id                   number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htm_experiences_pk primary key (company_id, filial_id, experience_id) using index tablespace GWS_INDEX,
  constraint htm_experiences_u1 unique (experience_id) using index tablespace GWS_INDEX,
  constraint htm_experiences_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htm_experiences_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htm_experiences_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htm_experiences_c2 check (state in ('A', 'P')),
  constraint htm_experiences_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column htm_experiences.state is '(A)ctive, (P)assive';

create index htm_experiences_i1 on htm_experiences(company_id, created_by) tablespace GWS_INDEX;
create index htm_experiences_i2 on htm_experiences(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htm_experience_periods(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  experience_id                   number(20) not null,
  from_rank_id                    number(20) not null,
  to_rank_id                      number(20) not null,
  order_no                        number(2),
  constraint htm_experience_periods_pk primary key (company_id, filial_id, experience_id, from_rank_id) using index tablespace GWS_INDEX,
  constraint htm_experience_periods_f1 foreign key (company_id, filial_id, experience_id) references htm_experiences(company_id, filial_id, experience_id) on delete cascade,
  constraint htm_experience_periods_f2 foreign key (company_id, filial_id, from_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_experience_periods_f3 foreign key (company_id, filial_id, to_rank_id) references mhr_ranks(company_id, filial_id, rank_id)
) tablespace GWS_DATA;

create index htm_experience_periods_i1 on htm_experience_periods(company_id, filial_id, from_rank_id) tablespace GWS_INDEX;
create index htm_experience_periods_i2 on htm_experience_periods(company_id, filial_id, to_rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htm_experience_period_attempts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  experience_id                   number(20) not null,
  from_rank_id                    number(20) not null,
  attempt_no                      number(20) not null,
  period                          number(6)  not null,
  nearest                         number(3)  not null,
  penalty_period                  number(6),
  exam_id                         number(20),
  success_score                   number(20, 6),
  ignore_score                    number(20, 6),
  recommend_failure               varchar2(1),
  constraint htm_experience_period_attempts_pk primary key (company_id, filial_id, experience_id, from_rank_id, attempt_no) using index tablespace GWS_INDEX,
  constraint htm_experience_period_attempts_f1 foreign key (company_id, filial_id, experience_id, from_rank_id) references htm_experience_periods(company_id, filial_id, experience_id, from_rank_id) on delete cascade,
  constraint htm_experience_period_attempts_f4 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id), 
  constraint htm_experience_period_attempts_c1 check (nearest >= 0),
  constraint htm_experience_period_attempts_c2 check (period > nearest),
  constraint htm_experience_period_attempts_c3 check (penalty_period > 0),
  constraint htm_experience_period_attempts_c4 check (success_score > ignore_score),
  constraint htm_experience_period_attempts_c5 check (recommend_failure in ('Y', 'N')),
  constraint htm_experience_period_attempts_c6 check (attempt_no > 0)
) tablespace GWS_DATA;

comment on column htm_experience_period_attempts.period            is 'Measured in days';
comment on column htm_experience_period_attempts.nearest           is 'Measured in days';
comment on column htm_experience_period_attempts.recommend_failure is '(Y)es, (N)o. Null also means (N)o';

----------------------------------------------------------------------------------------------------
create table htm_experience_period_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  experience_id                   number(20) not null,
  from_rank_id                    number(20) not null,
  attempt_no                      number(20) not null,
  indicator_id                    number(20) not null,
  constraint htm_experience_period_indicators_pk primary key (company_id, filial_id, experience_id, from_rank_id, attempt_no, indicator_id) using index tablespace GWS_INDEX,
  constraint htm_experience_period_indicators_f1 foreign key (company_id, filial_id, experience_id, from_rank_id, attempt_no) references htm_experience_period_attempts(company_id, filial_id, experience_id, from_rank_id, attempt_no) on delete cascade,
  constraint htm_experience_period_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htm_experience_training_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  experience_id                   number(20) not null,
  from_rank_id                    number(20) not null,
  attempt_no                      number(20) not null,
  subject_id                      number(20) not null,
  constraint htm_experience_training_subjects_pk primary key (company_id, filial_id, experience_id, from_rank_id, attempt_no, subject_id) using index tablespace GWS_INDEX,
  constraint htm_experience_training_subjects_f1 foreign key (company_id, filial_id, experience_id, from_rank_id, attempt_no) references htm_experience_period_attempts(company_id, filial_id, experience_id, from_rank_id, attempt_no) on delete cascade,
  constraint htm_experience_training_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htm_experience_jobs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  experience_id                   number(20) not null,
  job_id                          number(20) not null,
  constraint htm_experience_jobs_pk primary key (company_id, filial_id, experience_id, job_id) using index tablespace GWS_INDEX,
  constraint htm_experience_jobs_u1 unique (company_id, filial_id, job_id) using index tablespace GWS_INDEX,
  constraint htm_experience_jobs_f1 foreign key (company_id, filial_id, experience_id) references htm_experiences(company_id, filial_id, experience_id) on delete cascade,
  constraint htm_experience_jobs_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htm_experience_job_ranks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  job_id                          number(20) not null,
  from_rank_id                    number(20) not null,
  to_rank_id                      number(20) not null,
  experience_id                   number(20) not null,
  constraint htm_experience_job_ranks_pk primary key (company_id, filial_id, job_id, from_rank_id) using index tablespace GWS_INDEX,
  constraint htm_experience_job_ranks_f1 foreign key (company_id, filial_id, experience_id, job_id) references htm_experience_jobs(company_id, filial_id, experience_id, job_id) on delete cascade,
  constraint htm_experience_job_ranks_f2 foreign key (company_id, filial_id, experience_id, from_rank_id) references htm_experience_periods(company_id, filial_id, experience_id, from_rank_id) on delete cascade
) tablespace GWS_DATA;

comment on table htm_experience_job_ranks is 'cache table for experience job and rank';

create index htm_experience_job_ranks_i1 on htm_experience_job_ranks(company_id, filial_id, experience_id, job_id) tablespace GWS_INDEX;
create index htm_experience_job_ranks_i2 on htm_experience_job_ranks(company_id, filial_id, experience_id, from_rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Recommended Rank Document
----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_documents(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  document_number                 varchar2(50 char) not null,
  document_date                   date              not null,
  division_id                     number(20),
  note                            varchar2(300 char),
  status                          varchar2(1)       not null,
  journal_id                      number(20),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint htm_recommended_rank_documents_pk primary key (company_id, filial_id, document_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_documents_u1 unique (document_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_documents_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint htm_recommended_rank_documents_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint htm_recommended_rank_documents_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htm_recommended_rank_documents_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htm_recommended_rank_documents_c1 check (decode(trim(document_number), document_number, 1, 0) = 1),
  constraint htm_recommended_rank_documents_c2 check (trunc(document_date)= document_date),
  constraint htm_recommended_rank_documents_c3 check (status in ('N', 'S', 'T',  'W', 'A')),
  constraint htm_recommended_rank_documents_c4 check (status <> 'A' and journal_id is null or journal_id is not null) deferrable initially deferred
) tablespace GWS_DATA;

comment on column htm_recommended_rank_documents.status is '(N)ew, (S)et Training, (T)raining, (W)aiting, (A)pproved';

create index htm_recommended_rank_documents_i1 on htm_recommended_rank_documents(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i2 on htm_recommended_rank_documents(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i3 on htm_recommended_rank_documents(company_id, created_by) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i4 on htm_recommended_rank_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_staffs(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  document_id                     number(20)  not null,
  staff_id                        number(20)  not null,
  robot_id                        number(20)  not null,
  from_rank_id                    number(20)  not null,
  last_change_date                date        not null,
  to_rank_id                      number(20)  not null,
  new_change_date                 date        not null,
  period                          number(6)   not null,
  nearest                         number(3)   not null,
  attempt_no                      number(20)  not null,
  increment_status                varchar2(1) not null,
  old_penalty_period              number(6),
  penalty_period                  number(6),
  exam_id                         number(20),
  success_score                   number(20, 6),
  ignore_score                    number(20, 6),
  recommend_failure               varchar2(1),
  note                            varchar2(300 char),
  constraint htm_recommended_rank_staffs_pk primary key (company_id, filial_id, document_id, staff_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_staffs_f1 foreign key (company_id, filial_id, document_id) references htm_recommended_rank_documents(company_id, filial_id, document_id) on delete cascade,
  constraint htm_recommended_rank_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htm_recommended_rank_staffs_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htm_recommended_rank_staffs_f4 foreign key (company_id, filial_id, from_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_recommended_rank_staffs_f5 foreign key (company_id, filial_id, to_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_recommended_rank_staffs_f6 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id),
  constraint htm_recommended_rank_staffs_c1 check (trunc(last_change_date) = last_change_date),
  constraint htm_recommended_rank_staffs_c2 check (trunc(new_change_date) = new_change_date),
  constraint htm_recommended_rank_staffs_c3 check (increment_status in ('S', 'F', 'I'))
) tablespace GWS_DATA;

comment on column htm_recommended_rank_staffs.period  is 'Measured in days';
comment on column htm_recommended_rank_staffs.nearest is 'Measured in days';

comment on column htm_recommended_rank_staffs.increment_status is '(S)uccess, (F)ailure, (I)gnored';

create index htm_recommended_rank_staffs_i1 on htm_recommended_rank_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i2 on htm_recommended_rank_staffs(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i3 on htm_recommended_rank_staffs(company_id, filial_id, from_rank_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i4 on htm_recommended_rank_staffs(company_id, filial_id, to_rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_staff_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  document_id                     number(20) not null,
  staff_id                        number(20) not null,
  indicator_id                    number(20) not null,
  indicator_value                 number(20, 6),
  constraint htm_recommended_rank_staff_indicators_pk primary key (company_id, filial_id, document_id, staff_id, indicator_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_staff_indicators_f1 foreign key (company_id, filial_id, document_id, staff_id) references htm_recommended_rank_staffs(company_id, filial_id, document_id, staff_id) on delete cascade,
  constraint htm_recommended_rank_staff_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id),
  constraint htm_recommended_rank_staff_indicators_c1 check (indicator_value >= 0)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_staff_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  document_id                     number(20) not null,
  staff_id                        number(20) not null,
  subject_id                      number(20) not null,
  constraint htm_recommended_rank_staff_subjects_pk primary key (company_id, filial_id, document_id, staff_id, subject_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_staff_subjects_f1 foreign key (company_id, filial_id, document_id, staff_id) references htm_recommended_rank_staffs(company_id, filial_id, document_id, staff_id) on delete cascade,
  constraint htm_recommended_rank_staff_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id)
) tablespace GWS_DATA;
