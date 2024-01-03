prompt adding training subject tables
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create sequence hln_training_subject_groups_sq;

----------------------------------------------------------------------------------------------------  
create table hln_training_person_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  training_id                     number(20) not null,
  person_id                       number(20) not null,
  subject_id                      number(20) not null,
  passed                          varchar2(1) not null,
  constraint hln_training_person_subjects_pk primary key (company_id, filial_id, training_id, person_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_person_subjects_f1 foreign key (company_id, filial_id, training_id, person_id) references hln_training_persons(company_id, filial_id, training_id, person_id) on delete cascade,
  constraint hln_training_person_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id),
  constraint hln_training_person_subjects_c1 check (passed in ('Y', 'N', 'I'))
) tablespace GWS_DATA;

comment on table hln_training_person_subjects is 'Keeps Subject of Training Persons';

create index hln_training_person_subjects_i1 on hln_training_person_subjects(company_id, filial_id, subject_id) tablespace GWS_INDEX;
create index hln_training_person_subjects_i2 on hln_training_person_subjects(company_id, filial_id, person_id, subject_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
prompt add training subject group table 
----------------------------------------------------------------------------------------------------            
create table hln_training_subject_groups(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  subject_group_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_training_subject_groups_pk primary key (company_id, filial_id, subject_group_id) using index tablespace GWS_INDEX,
  constraint hln_training_subject_groups_u1 unique (subject_group_id) using index tablespace GWS_INDEX,
  constraint hln_training_subject_groups_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_training_subject_groups_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_training_subject_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_training_subject_groups_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hln_training_subject_groups_u2 on hln_training_subject_groups(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create index hln_training_subject_groups_i1 on hln_training_subject_groups(company_id, created_by) tablespace GWS_INDEX;
create index hln_training_subject_groups_i2 on hln_training_subject_groups(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add new table for keep subject group subjects
---------------------------------------------------------------------------------------------------- 
create table hln_training_subject_group_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  subject_group_id                number(20) not null,
  subject_id                      number(20) not null,
  constraint hln_training_subject_group_subjects_pk primary key (company_id, filial_id, subject_group_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_subject_group_subjects_f1 foreign key (company_id, filial_id, subject_group_id) references hln_training_subject_groups(company_id, filial_id, subject_group_id) on delete cascade,
  constraint hln_training_subject_group_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id) on delete cascade
) tablespace GWS_DATA;

create index hln_training_subject_group_subjects_i1 on hln_training_subject_group_subjects(company_id, filial_id, subject_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_trainings add subject_group_id number(20);

alter table hln_trainings rename constraint hln_trainings_f3 to hln_trainings_f4;
alter table hln_trainings rename constraint hln_trainings_f2 to hln_trainings_f3;
alter table hln_trainings add constraint hln_trainings_f2 foreign key (company_id, filial_id, subject_group_id) 
      references hln_training_subject_groups(company_id, filial_id, subject_group_id);

alter index hln_trainings_i3 rename to hln_trainings_i4;
alter index hln_trainings_i2 rename to hln_trainings_i3;
create index hln_trainings_i2 on hln_trainings(company_id, filial_id, subject_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding device update tables
----------------------------------------------------------------------------------------------------
create table hac_temp_ex_hik_device_infos( 
  device_code      varchar2(300 char),
  server_id        number(20),
  constraint hac_temp_ex_hik_device_infos_pk primary key (device_code, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

--------------------------------------------------     
create table hac_temp_ex_dss_device_infos(
  device_code      varchar2(300 char),
  server_id        number(20),
  constraint hac_temp_ex_dss_device_infos_pk primary key (device_code, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

--------------------------------------------------    
create table hac_temp_device_infos(
  device_id        number(20),
  server_id        number(20),
  constraint hac_temp_device_infos_pk primary key (device_id, server_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding experience attempts
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

--------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_staffs add attempt_no number(20);
alter table htm_recommended_rank_staffs add increment_status varchar2(1);
alter table htm_recommended_rank_staffs add penalty_period number(6);
alter table htm_recommended_rank_staffs add old_penalty_period number(6);
alter table htm_recommended_rank_staffs add exam_id number(20);
alter table htm_recommended_rank_staffs add success_score number(20, 6);
alter table htm_recommended_rank_staffs add ignore_score number(20, 6);
alter table htm_recommended_rank_staffs add recommend_failure varchar2(1);

alter table htm_recommended_rank_staffs add constraint htm_recommended_rank_staffs_f6 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id);

alter table htm_recommended_rank_staffs drop constraint htm_recommended_rank_staffs_c3;
alter table htm_recommended_rank_staffs add constraint htm_recommended_rank_staffs_c3 check (increment_status in ('S', 'F', 'I'));

comment on column htm_recommended_rank_staffs.increment_status is '(S)uccess, (F)ailure, (I)gnored';

----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_documents drop constraint htm_recommended_rank_documents_c3;
alter table htm_recommended_rank_documents add constraint htm_recommended_rank_documents_c3 check (status in ('N', 'S', 'T',  'W', 'A'));

comment on column htm_recommended_rank_documents.status is '(N)ew, (S)et Training, (T)raining, (W)aiting, (A)pproved';

--------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------
prompt indicators grouping and new indicators
----------------------------------------------------------------------------------------------------
create sequence href_indicator_groups_sq;

----------------------------------------------------------------------------------------------------
create table href_indicator_groups(
  company_id                      number(20)         not null,
  indicator_group_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  pcode                           varchar2(20)       not null,
  constraint href_indicator_groups_pk primary key (company_id, indicator_group_id) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_u1 unique (indicator_group_id) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_indicator_groups_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table href_indicator_groups is 'Grouping for href_indicators';

----------------------------------------------------------------------------------------------------
alter table href_indicators add indicator_group_id number(20);
