prompt migr from 22.03.2022
----------------------------------------------------------------------------------------------------
prompt add new coulms in hln_testings
----------------------------------------------------------------------------------------------------
alter table hln_testings add examiner_id number(20);
alter table hln_testings add fact_begin_time date;
alter table hln_testings add fact_end_time date;

alter table hln_testings drop constraint hln_testings_u2;
alter table hln_testings drop constraint hln_testings_f3;
alter table hln_testings drop constraint hln_testings_f4;

alter table hln_testings drop constraint hln_testings_c1;
alter table hln_testings drop constraint hln_testings_c2;
alter table hln_testings drop constraint hln_testings_c3;
alter table hln_testings drop constraint hln_testings_c4;
alter table hln_testings drop constraint hln_testings_c5;
alter table hln_testings drop constraint hln_testings_c6;

drop index hln_testings_i3;
drop index hln_testings_i4;

alter table hln_testings add constraint hln_testings_f3 foreign key (company_id, examiner_id) references mr_natural_persons(company_id, person_id);
alter table hln_testings add constraint hln_testings_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table hln_testings add constraint hln_testings_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

alter table hln_testings add constraint hln_testings_c1 check (person_id <> examiner_id);
alter table hln_testings add constraint hln_testings_c2 check (trunc(begin_time) = trunc(testing_date));
alter table hln_testings add constraint hln_testings_c3 check (end_time > begin_time);
alter table hln_testings add constraint hln_testings_c4 check (fact_end_time > fact_begin_time);
alter table hln_testings add constraint hln_testings_c5 check (pause_time between begin_time and end_time);
alter table hln_testings add constraint hln_testings_c6 check (passed in ('Y', 'N', 'I'));
alter table hln_testings add constraint hln_testings_c7 check (status in ('N', 'E', 'P', 'C', 'F'));
alter table hln_testings add constraint hln_testings_c8 check (decode(status, 'F', 1, 0) = decode(passed, 'I', 0, 1));

create index hln_testings_i3 on hln_testings(company_id, examiner_id) tablespace GWS_INDEX;
create index hln_testings_i4 on hln_testings(company_id, created_by) tablespace GWS_INDEX;
create index hln_testings_i5 on hln_testings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hln_testing_questions table
----------------------------------------------------------------------------------------------------
drop index hln_testing_questions_u1;

alter table hln_testing_questions add constraint hln_testing_questions_u1 unique (company_id, testing_id, order_no) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hln_testing_question_options table
----------------------------------------------------------------------------------------------------
alter table hln_testing_question_options drop constraint hln_testing_question_options_u1;
alter table hln_testing_question_options add constraint hln_testing_question_options_u1 unique (company_id, testing_id, question_id, order_no) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hln_trainings table
----------------------------------------------------------------------------------------------------
alter table hln_trainings drop constraint hln_trainings_c1;

update hln_trainings q
   set q.training_number = trim(q.training_number);
commit;

alter table hln_trainings add constraint hln_trainings_c1 check (decode(trim(training_number), training_number, 1, 0) = 1);
alter table hln_trainings add constraint hln_trainings_c2 check (status in ('N', 'E', 'F'));

---------------------------------------------------------------------------------------------------- 
prompt new table hpd_timeoff_days
----------------------------------------------------------------------------------------------------
create table hpd_timeoff_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  timeoff_date                    date        not null,
  timeoff_id                      number(20)  not null,
  time_kind_id                    number(20)  not null,
  turnout_locked                  varchar2(1) not null,
  constraint hpd_timeoff_days_pk primary key (company_id, filial_id, staff_id, timeoff_date) using index tablespace GWS_INDEX,
  constraint hpd_timeoff_days_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_timeoff_days_f2 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id),
  constraint hpd_timeoff_days_f3 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpd_timeoff_days_c1 check (turnout_locked in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hpd_timeoff_days is 'Keeps days affected by posted timeoff';

comment on column hpd_timeoff_days.turnout_locked is '(Y)es, (N)o. (Y)es only when turnout fact was locked during timeoff post process.';
comment on column hpd_timeoff_days.time_kind_id is 'Keeps time kind related to timeoff. E.g.: Vacation time kind for vacation timeoff.';

create index hpd_timeoff_days_i1 on hpd_timeoff_days(company_id, filial_id, timeoff_id) tablespace GWS_INDEX;

