prompt migr from 07.03.2022
prompt DDL
----------------------------------------------------------------------------------------------------
prompt new table htt_pin_locks
----------------------------------------------------------------------------------------------------
create table htt_pin_locks(
  company_id                      number(20) not null,
  constraint htt_pin_locks_pk primary key (company_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt new tables in training module
----------------------------------------------------------------------------------------------------
create table hln_training_subjects (
  company_id                      number(20)         not null,
  subject_id                      number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_training_subjects_pk primary key (company_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_subjects_u1 unique (subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_subjects_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_training_subjects_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_training_subjects_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_training_subjects_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create index hln_training_subjects_i1 on hln_training_subjects(company_id, created_by) tablespace GWS_INDEX;
create index hln_training_subjects_i2 on hln_training_subjects(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_trainings (
  company_id                      number(20)         not null,
  training_id                     number(20)         not null,
  training_number                 varchar2(50)       not null,
  begin_date                      date               not null,
  mentor_id                       number(20)         not null,
  subject_id                      number(20)         not null,
  address                         varchar2(300 char) not null,
  status                          varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_trainings_pk primary key (company_id, training_id) using index tablespace GWS_INDEX,
  constraint hln_trainings_u1 unique (training_id) using index tablespace GWS_INDEX,
  constraint hln_trainings_f1 foreign key (company_id, mentor_id) references mr_natural_persons(company_id, person_id),
  constraint hln_trainings_f2 foreign key (company_id, subject_id) references hln_training_subjects(company_id, subject_id),
  constraint hln_trainings_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_trainings_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_trainings_c1 check (status in ('N', 'E', 'F'))
) tablespace GWS_DATA;

comment on column  hln_trainings.status is '(N)ew, (E)xecuted, (F)inished';

create index hln_trainings_i1 on hln_trainings(company_id, mentor_id) tablespace GWS_INDEX;
create index hln_trainings_i2 on hln_trainings(company_id, subject_id) tablespace GWS_INDEX;
create index hln_trainings_i3 on hln_trainings(company_id, created_by) tablespace GWS_INDEX;
create index hln_trainings_i4 on hln_trainings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_training_persons (
  company_id                 number(20)  not null,
  training_id                number(20)  not null,
  person_id                  number(20)  not null,
  passed                     varchar2(1) not null,
  constraint hln_training_persons_pk primary key (company_id, training_id, person_id) using index tablespace GWS_INDEX,
  constraint hln_training_persons_f1 foreign key (company_id, training_id) references hln_trainings(company_id, training_id) on delete cascade,
  constraint hln_training_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint hln_training_persons_c1 check (passed in ('Y', 'N', 'I'))
) tablespace GWS_DATA;

create index hln_training_persons_i1 on hln_training_persons(company_id, person_id) tablespace GWS_INDEX;

comment on column hln_training_persons.passed is '(Y)es, (N)o, (I)ndeterminate, indicates whether the examinee passed the exam or not or indeterminate';

----------------------------------------------------------------------------------------------------
prompt new sequences
----------------------------------------------------------------------------------------------------
create sequence hln_training_subjects_sq;
create sequence hln_trainings_sq;

----------------------------------------------------------------------------------------------------
prompt changes in hln_testings table
----------------------------------------------------------------------------------------------------
alter table hln_testings modify passed not null;

alter table hln_testings drop constraint hln_testings_c4;
alter table hln_testings add constraint hln_testings_c4 check (passed in ('Y', 'N', 'I'));

alter table hln_testings drop constraint hln_testings_c6;
alter table hln_testings add constraint hln_testings_c6 check (decode(status, 'F', 1,  0) = decode(passed, 'I', 0, 1));

comment on column hln_testings.passed is '(Y)es, (N)o, (I)ndeterminate, indicates whether the examinee passed the exam or not or indeterminate';

drop index hln_question_types_u2;
create unique index hln_question_types_u2 on hln_question_types(nvl2(code, company_id, null), nvl2(code, question_group_id, null), code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new column in table hln_question_files
----------------------------------------------------------------------------------------------------
alter table hln_question_files add order_no number(2);
alter table hln_exam_patterns add has_writing_question varchar2(1);
alter table hln_exam_patterns add constraint hln_exam_patterns_c2 check (has_writing_question in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt new column in table htt_devices
----------------------------------------------------------------------------------------------------
alter table htt_devices add lang_code varchar2(10);
alter table htt_devices add use_settings varchar2(1);
alter table htt_devices add constraint htt_devices_c4 check (use_settings in ('Y', 'N'));

exec fazo_z.Run;
exec fazo_z.Compile_Invalid_Objects;
