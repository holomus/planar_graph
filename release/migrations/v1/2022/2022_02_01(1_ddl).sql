prompt migr from 01.02.2022 ddl
----------------------------------------------------------------------------------------------------
prompt new table hpd_vacations
----------------------------------------------------------------------------------------------------
create table hpd_vacations(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  constraint hpd_vacations_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_vacations_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt changes in htt_schedule_origin_days
---------------------------------------------------------------------------------------------------- 
comment on column htt_schedule_origin_days.full_time is 'measured in minutes';
comment on column htt_schedule_origin_days.plan_time is 'measured in minutes';

comment on column htt_schedule_days.full_time is 'measured in minutes';
comment on column htt_schedule_days.plan_time is 'measured in minutes';

---------------------------------------------------------------------------------------------------- 
prompt changes in htt_timesheets
----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify plan_time number(5);
alter table htt_timesheets modify full_time number(5);
alter table htt_timesheets modify track_duration number(6);

alter table htt_timesheets drop constraint htt_timesheets_c6;
alter table htt_timesheets drop constraint htt_timesheets_c15;

alter table htt_timesheets add constraint htt_timesheets_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 86400);
alter table htt_timesheets add constraint htt_timesheets_c15 check (track_duration between 0 and 259200);

comment on column htt_timesheets.full_time      is 'Measured in seconds';
comment on column htt_timesheets.plan_time      is 'Measured in seconds';
comment on column htt_timesheets.track_duration is 'Measured in seconds';

---------------------------------------------------------------------------------------------------- 
prompt changes in htt_timesheet_facts
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_facts modify fact_value number(5);

comment on column htt_timesheet_facts.fact_value is 'Measured in seconds';

----------------------------------------------------------------------------------------------------
prompt new sequence htt_plan_change_sq
---------------------------------------------------------------------------------------------------- 
create sequence htt_plan_change_sq;

------------------------------------------------------------------------------------------------------
prompt new table htt_plan_changes
--------------------------------------------------------------------------------------------------
create table htt_plan_changes(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  change_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  change_kind                     varchar2(1) not null,
  manager_note                    varchar2(300 char),
  note                            varchar2(300 char),
  status                          varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_plan_changes_pk primary key (company_id, filial_id, change_id) using index tablespace GWS_INDEX,
  constraint htt_plan_changes_u1 unique (change_id) using index tablespace GWS_INDEX,
  constraint htt_plan_changes_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_plan_changes_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_plan_changes_c1 check (change_kind in ('S', 'C')),
  constraint htt_plan_changes_c2 check (status in ('N', 'A', 'C', 'D'))
) tablespace GWS_DATA;

comment on table htt_plan_changes is 'Keeps staff timesheet plan changes. Should have highest priority among all plan sources';

comment on column htt_plan_changes.change_kind is '(S)wap, (C)hange plan';
comment on column htt_plan_changes.status      is '(N)ew, (A)pproved, (C)ompleted, (D)enied';

create index htt_plan_changes_i1 on htt_plan_changes(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_plan_changes_i2 on htt_plan_changes(company_id, created_by) tablespace GWS_INDEX;
create index htt_plan_changes_i3 on htt_plan_changes(company_id, modified_by) tablespace GWS_INDEX;

------------------------------------------------------------------------------------------------------
prompt new table htt_change_days
----------------------------------------------------------------------------------------------------
create table htt_change_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  change_id                       number(20)  not null,
  change_date                     date        not null,
  swapped_date                    date,
  staff_id                        number(20)  not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number(5)   not null,
  full_time                       number(5)   not null,
  constraint htt_change_days_pk primary key (company_id, filial_id, change_id, change_date) using index tablespace GWS_INDEX,
  constraint htt_change_days_u1 unique (company_id, filial_id, staff_id, change_date) using index tablespace GWS_INDEX,
  constraint htt_change_days_f1 foreign key (company_id, filial_id, change_id) references htt_plan_changes(company_id, filial_id, change_id) on delete cascade,
  constraint htt_change_days_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_change_days_f3 foreign key (company_id, filial_id, staff_id, change_date) references htt_timesheets(company_id, filial_id, staff_id, timesheet_date),
  constraint htt_change_days_c1 check (trunc(change_date) = change_date),
  constraint htt_change_days_c2 check (trunc(swapped_date) = swapped_date),
  constraint htt_change_days_c3 check (day_kind in ('W', 'R') or day_kind in ('H', 'N') and swapped_date is not null),
  constraint htt_change_days_c4 check (break_enabled in ('Y', 'N')),
  constraint htt_change_days_c5 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)
                                        or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_change_days_c6 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_change_days_c7 check (plan_time <= full_time and 0 <= plan_time and full_time <= 86400),
  constraint htt_change_days_c8 check (begin_time < end_time),
  constraint htt_change_days_c9 check (break_begin_time < break_end_time),
  constraint htt_change_days_c10 check (begin_time < break_begin_time and break_end_time < end_time)
) tablespace GWS_DATA;

comment on table htt_change_days is 'Keeps timesheet plan changes. Swaps are updated each time affected timesheets are changed';

comment on column htt_change_days.swapped_date  is 'swapped data source';
comment on column htt_change_days.day_kind      is '(W)ork, (R)est, (H)oliday, (N)onworking';
comment on column htt_change_days.break_enabled is '(Y)es, (N)o';
comment on column htt_change_days.plan_time     is 'Measured in seconds';
comment on column htt_change_days.full_time     is 'Measured in seconds';

create index htt_change_days_i1 on htt_change_days(company_id, filial_id, staff_id, swapped_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new module hln
----------------------------------------------------------------------------------------------------
prompt Learn module
prompt (c) 2022 Verifix HR

-- question characteristics
----------------------------------------------------------------------------------------------------
create table hln_question_groups(
  company_id                      number(20)         not null,
  question_group_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  is_multiple                     varchar2(1)        not null,
  is_required                     varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  constraint hln_question_groups_pk primary key (company_id, question_group_id) using index tablespace GWS_INDEX,
  constraint hln_question_groups_u1 unique (question_group_id) using index tablespace GWS_INDEX,
  constraint hln_question_groups_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_question_groups_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_question_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_groups_c2 check (is_multiple in ('Y', 'N')),
  constraint hln_question_groups_c3 check (is_required in ('Y', 'N')),
  constraint hln_question_groups_c4 check (state in ('A', 'P')),
  constraint hln_question_groups_c5 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index hln_question_groups_u2 on hln_question_groups(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_groups_u3 on hln_question_groups(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hln_question_groups_i1 on hln_question_groups(company_id, created_by) tablespace GWS_INDEX;
create index hln_question_groups_i2 on hln_question_groups(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_types(
  company_id                      number(20)         not null,
  question_group_id               number(20)         not null,
  question_type_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50 char),
  order_no                        number(6),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  constraint hln_question_types_pk primary key (company_id, question_type_id) using index tablespace GWS_INDEX,
  constraint hln_question_types_u1 unique (question_type_id) using index tablespace GWS_INDEX,
  constraint hln_question_types_f1 foreign key (company_id, question_group_id) references hln_question_groups(company_id, question_group_id) on delete cascade,
  constraint hln_question_types_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_question_types_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_question_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_types_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint hln_question_types_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hln_question_types_u2 on hln_question_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_types_u3 on hln_question_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hln_question_types_i1 on hln_question_types(company_id, question_group_id) tablespace GWS_INDEX;
create index hln_question_types_i2 on hln_question_types(company_id, created_by) tablespace GWS_INDEX;
create index hln_question_types_i3 on hln_question_types(company_id, modified_by) tablespace GWS_INDEX;

-- questions
----------------------------------------------------------------------------------------------------
create table hln_questions(
  company_id                      number(20)         not null,
  question_id                     number(20)         not null,
  name                            varchar2(500 char) not null,
  answer_type                     varchar2(1)        not null,
  code                            varchar2(50 char),
  state                           varchar2(1)        not null,
  writing_hint                    varchar2(500 char),
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  constraint hln_questions_pk primary key (company_id, question_id) using index tablespace GWS_INDEX,
  constraint hln_questions_u1 unique (question_id) using index tablespace GWS_INDEX,
  constraint hln_questions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_questions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_questions_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_questions_c2 check (answer_type in ('S', 'M', 'W')),
  constraint hln_questions_c3 check (decode(trim(code), code, 1, 0) = 1),
  constraint hln_questions_c4 check (state in ('A', 'P')),
  constraint hln_questions_c5 check (decode(trim(writing_hint), writing_hint, 1, 0) = 1),
  constraint hln_questions_c6 check (writing_hint is null or answer_type = 'W')
) tablespace GWS_DATA;

comment on column hln_questions.answer_type is '(S)ingle, (M)ultiple, (W)riting';
 
create unique index hln_questions_u2 on hln_questions(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index hln_questions_i1 on hln_questions(company_id, created_by) tablespace GWS_INDEX;
create index hln_questions_i2 on hln_questions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_type_binds(
  company_id                      number(20) not null,
  question_type_id                number(20) not null,
  question_id                     number(20) not null, 
  question_group_id               number(20) not null,
  constraint hln_question_type_binds_pk primary key (company_id, question_id, question_type_id) using index tablespace GWS_INDEX, 
  constraint hln_question_type_binds_f1 foreign key (company_id, question_id) references hln_questions(company_id, question_id) on delete cascade,
  constraint hln_question_type_binds_f2 foreign key (company_id, question_group_id) references hln_question_groups(company_id, question_group_id),
  constraint hln_question_type_binds_f3 foreign key (company_id, question_type_id) references hln_question_types(company_id, question_type_id)
) tablespace GWS_DATA;

create index hln_question_type_binds_i1 on hln_question_type_binds(company_id, question_group_id) tablespace GWS_INDEX;
create index hln_question_type_binds_i2 on hln_question_type_binds(company_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_options(
  company_id                      number(20)         not null,
  question_option_id              number(20)         not null,
  name                            varchar2(300 char) not null,
  file_sha                        varchar2(64),
  question_id                     number(20)         not null,
  is_correct                      varchar2(1)        not null,
  order_no                        number(2)          not null,
  constraint hln_question_options_pk primary key (company_id, question_option_id) using index tablespace GWS_INDEX,
  constraint hln_question_options_u1 unique (question_option_id) using index tablespace GWS_INDEX,
  constraint hln_question_options_f1 foreign key (company_id, question_id) references hln_questions(company_id, question_id) on delete cascade,
  constraint hln_question_options_f2 foreign key (file_sha) references biruni_files(sha),
  constraint hln_question_options_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_options_c2 check (is_correct in ('Y', 'N'))
) tablespace GWS_DATA;

create index hln_question_options_i1 on hln_question_options(company_id, question_id) tablespace GWS_INDEX;
create index hln_question_options_i2 on hln_question_options(file_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_files(
  company_id                      number(20)         not null,
  question_id                     number(20)         not null,
  file_sha                        varchar2(300 char) not null,
  constraint hln_question_files_pk primary key (company_id, question_id, file_sha) using index tablespace GWS_DATA,
  constraint hln_question_files_f1 foreign key (company_id, question_id) references hln_questions(company_id, question_id) on delete cascade,
  constraint hln_question_files_f2 foreign key (file_sha) references biruni_files(sha)
) tablespace GWS_DATA;

create index hln_question_files_i1 on hln_question_files(file_sha) tablespace GWS_INDEX;

-- exam
----------------------------------------------------------------------------------------------------
create table hln_exams (
  company_id                      number(20)         not null,
  exam_id                         number(20)         not null,
  name                            varchar2(100 char) not null,
  pick_kind                       varchar2(1)        not null,
  duration                        number(5),
  passing_score                   number(4)          not null,
  question_count                  number(4)          not null,
  randomize_questions             varchar2(1),
  randomize_options               varchar2(1)        not null,
  state                           varchar2(1)        not null,
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  constraint hln_exams_pk primary key (company_id, exam_id) using index tablespace GWS_DATA,
  constraint hln_exams_u1 unique (exam_id) using index tablespace GWS_INDEX,
  constraint hln_exams_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_exams_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_exams_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_exams_c2 check (pick_kind in ('A', 'M')),
  constraint hln_exams_c3 check (duration > 0),
  constraint hln_exams_c4 check (question_count > 0),
  constraint hln_exams_c5 check (passing_score between 1 and question_count),
  constraint hln_exams_c6 check (pick_kind = 'M' and randomize_questions is not null or pick_kind = 'A' and randomize_questions is null),
  constraint hln_exams_c7 check (randomize_questions in ('Y', 'N')),
  constraint hln_exams_c8 check (randomize_options in ('Y', 'N')),
  constraint hln_exams_c9 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column hln_exams.pick_kind is '(A)uto, (M)anual';
comment on column hln_exams.duration is 'in minutes';
comment on column hln_exams.passing_score is 'minimum number of correct answers to pass exam';

create index hln_exams_i1 on hln_exams(company_id, created_by) tablespace GWS_INDEX;
create index hln_exams_i2 on hln_exams(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_exam_manual_questions (
  company_id                      number(20)         not null,
  exam_id                         number(20)         not null,
  question_id                     number(20)         not null,
  order_no                        number(6)          not null,
  constraint hln_exam_manual_questions_pk primary key (company_id, exam_id, question_id) using index tablespace GWS_DATA,
  constraint hln_exam_manual_questions_f1 foreign key (company_id, exam_id) references hln_exams(company_id, exam_id) on delete cascade,
  constraint hln_exam_manual_questions_f2 foreign key (company_id, question_id) references hln_questions(company_id, question_id)
) tablespace GWS_DATA;

comment on table hln_exam_manual_questions is 'Keeps manual picked questions on exams';

create index hln_exam_manual_questions_i1 on hln_exam_manual_questions(company_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_exam_patterns (
  company_id                      number(20)         not null,
  pattern_id                      number(20)         not null,
  exam_id                         number(20)         not null,
  quantity                        number(6)          not null,
  order_no                        number(6),
  constraint hln_exam_patterns_pk primary key (company_id, pattern_id) using index tablespace GWS_DATA,
  constraint hln_exam_patterns_u1 unique (pattern_id) using index tablespace GWS_INDEX,
  constraint hln_exam_patterns_f1 foreign key (company_id, exam_id) references hln_exams(company_id, exam_id) on delete cascade,
  constraint hln_exam_patterns_c1 check (quantity > 0)
) tablespace GWS_DATA;

comment on column hln_exam_patterns.pattern_id is 'pattern is combination of question types to autopick questions on exams';

create index hln_exam_patterns_i1 on hln_exam_patterns(company_id, exam_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_pattern_question_types (
  company_id                      number(20)         not null,
  pattern_id                      number(20)         not null,
  question_type_id                number(20)         not null,
  question_group_id               number(20)         not null,
  constraint hln_pattern_question_types_pk primary key (company_id, pattern_id, question_type_id) using index tablespace GWS_DATA,
  constraint hln_pattern_question_types_f1 foreign key (company_id, pattern_id) references hln_exam_patterns(company_id, pattern_id) on delete cascade,
  constraint hln_pattern_question_types_f2 foreign key (company_id, question_group_id) references hln_question_groups(company_id, question_group_id),
  constraint hln_pattern_question_types_f3 foreign key (company_id, question_type_id) references hln_question_types(company_id, question_type_id)
) tablespace GWS_DATA;

create index hln_pattern_question_types_i1 on hln_pattern_question_types(company_id, question_group_id) tablespace GWS_INDEX;
create index hln_pattern_question_types_i2 on hln_pattern_question_types(company_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table hln_testings (
  company_id                      number(20)   not null,
  testing_id                      number(20)   not null,
  exam_id                         number(20)   not null,
  person_id                       number(20)   not null,
  testing_number                  varchar2(50) not null,
  testing_date                    date         not null,
  begin_time                      date,
  end_time                        date,
  pause_time                      date,
  passed                          varchar2(1),
  current_question_no             number(6),
  correct_questions_count         number(4),
  status                          varchar2(1)  not null,
  note                            varchar2(200 char),
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  constraint hln_testings_pk primary key (company_id, testing_id) using index tablespace GWS_INDEX,
  constraint hln_testings_u1 unique (testing_id) using index tablespace GWS_INDEX,
  constraint hln_testings_u2 unique (company_id, testing_id, exam_id, person_id) using index tablespace GWS_INDEX,
  constraint hln_testings_f1 foreign key (company_id, exam_id) references hln_exams(company_id, exam_id),
  constraint hln_testings_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hln_testings_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_testings_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_testings_c1 check (trunc(begin_time) = trunc(testing_date)),
  constraint hln_testings_c2 check (end_time > begin_time),
  constraint hln_testings_c3 check (pause_time between begin_time and end_time),
  constraint hln_testings_c4 check (passed in ('Y', 'N')),
  constraint hln_testings_c5 check (status in ('N', 'E', 'P', 'C', 'F')),
  constraint hln_testings_c6 check (decode(status, 'F', 1, 0) = nvl2(passed, 1, 0))
) tablespace GWS_DATA;

comment on column hln_testings.passed is '(Y)es, (N)o, indicates whether the examinee passed the exam or not';
comment on column hln_testings.status is '(N)ew, (E)xecuted, (P)aused, (C)hecked, (F)inished';

create index hln_testings_i1 on hln_testings(company_id, exam_id) tablespace GWS_INDEX;
create index hln_testings_i2 on hln_testings(company_id, person_id) tablespace GWS_INDEX;
create index hln_testings_i3 on hln_testings(company_id, created_by) tablespace GWS_INDEX;
create index hln_testings_i4 on hln_testings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------        
create table hln_testing_questions (
  company_id                      number(20) not null,
  testing_id                      number(20) not null,
  question_id                     number(20) not null,
  order_no                        number(6)  not null,
  writing_answer                  varchar2(500 char),
  marked                          varchar2(1),
  correct                         varchar2(1),
  constraint hln_testing_questions_pk primary key (company_id, testing_id, question_id) using index tablespace GWS_INDEX,
  constraint hln_testing_questions_f1 foreign key (company_id, testing_id) references hln_testings(company_id, testing_id) on delete cascade,
  constraint hln_testing_questions_f2 foreign key (company_id, question_id) references hln_questions(company_id, question_id),
  constraint hln_testing_questions_c1 check (marked in ('Y', 'N')),
  constraint hln_testing_questions_c2 check (correct in ('Y', 'N'))
) tablespace GWS_DATA;

comment on column hln_testing_questions.marked  is '(Y)es, (N)o, indicated whether the question is marked or not';
comment on column hln_testing_questions.correct is '(Y)es, (N)o, indicates whether the answer for this question is marked correctly or not';

create unique index hln_testing_questions_u1 on hln_testing_questions(company_id, testing_id, order_no) tablespace GWS_INDEX;

create index hln_testing_questions_i1 on hln_testing_questions(company_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------           
create table hln_testing_question_options (
  company_id                      number(20) not null,
  testing_id                      number(20) not null,
  question_id                     number(20) not null,
  question_option_id              number(20) not null,
  order_no                        number(6)  not null,
  chosen                          varchar2(1),
  constraint hln_testing_question_options_pk primary key (company_id, testing_id, question_id, question_option_id) using index tablespace GWS_INDEX,
  constraint hln_testing_question_options_u1 unique (testing_id, question_id, question_option_id) using index tablespace GWS_INDEX,
  constraint hln_testing_question_options_f1 foreign key (company_id, testing_id, question_id) references hln_testing_questions(company_id, testing_id, question_id) on delete cascade,
  constraint hln_testing_question_options_f2 foreign key (company_id, question_option_id) references hln_question_options(company_id, question_option_id),
  constraint hln_testing_question_options_c1 check (chosen in ('Y','N'))
) tablespace GWS_DATA;

comment on column  hln_testing_question_options.chosen is '(Y)es, (N)o, indicates whether the option for the question is chosen or not';

create index hln_testing_question_options_i1 on hln_testing_question_options(company_id, question_option_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_oper_types
----------------------------------------------------------------------------------------------------
alter table hpr_oper_types drop constraint hpr_oper_types_f1;
alter table hpr_oper_types add constraint hpr_oper_types_f1 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id);

----------------------------------------------------------------------------------------------------
prompt new hln sequences
----------------------------------------------------------------------------------------------------
create sequence hln_question_groups_sq;
create sequence hln_question_types_sq;
create sequence hln_questions_sq;
create sequence hln_question_options_sq;
create sequence hln_exams_sq;
create sequence hln_exam_patterns_sq;

----------------------------------------------------------------------------------------------------
prompt new table htt_terminal_models
----------------------------------------------------------------------------------------------------
create table htt_terminal_models(
  model_id                        number(20)         not null,
  name                            varchar2(100 char) not null,
  photo_sha                       varchar2(64),
  support_face_recognation        varchar2(1)        not null,
  support_fprint                  varchar2(1)        not null,
  support_rfid_card               varchar2(1)        not null,
  state                           varchar2(1)        not null,
  pcode                           varchar2(20)       not null,
  constraint htt_terminal_models_pk primary key (model_id) using index tablespace GWS_INDEX,
  constraint htt_terminal_models_u1 unique (pcode) using index tablespace GWS_INDEX,
  constraint htt_terminal_models_f1 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_terminal_models_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_terminal_models_c2 check (support_face_recognation in ('Y', 'N')),
  constraint htt_terminal_models_c3 check (support_fprint in ('Y', 'N')),
  constraint htt_terminal_models_c4 check (support_rfid_card in ('Y', 'N')),
  constraint htt_terminal_models_c5 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table htt_terminal_models is 'System terminal models';

comment on column htt_terminal_models.state is '(A)ctive, (P)assive';

create index htt_terminal_models_i1 on htt_terminal_models(photo_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt htt_devices changes
----------------------------------------------------------------------------------------------------
alter table htt_devices drop constraint htt_devices_f2;
alter table htt_devices drop constraint htt_devices_f3;
alter table htt_devices drop constraint htt_devices_f4;

drop index htt_devices_i1;
drop index htt_devices_i2;
drop index htt_devices_i3;

alter table htt_devices add model_id number(20);
alter table htt_devices add constraint htt_devices_f2 foreign key (model_id) references htt_terminal_models(model_id);
alter table htt_devices add constraint htt_devices_f3 foreign key (company_id, filial_id, location_id) references htt_locations(company_id, filial_id, location_id);
alter table htt_devices add constraint htt_devices_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_devices add constraint htt_devices_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index htt_devices_i1 on htt_devices(model_id) tablespace GWS_INDEX;
create index htt_devices_i2 on htt_devices(company_id, filial_id, location_id) tablespace GWS_INDEX;
create index htt_devices_i3 on htt_devices(company_id, created_by) tablespace GWS_INDEX;
create index htt_devices_i4 on htt_devices(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt htt_persons table changes
----------------------------------------------------------------------------------------------------
alter table htt_persons drop constraint htt_persons_f2;
alter table htt_persons drop constraint htt_persons_f3;

drop index htt_persons_i5;
drop index htt_persons_i6;

alter table htt_persons add biophoto_sha varchar2(64);
alter table htt_persons add constraint htt_persons_f2 foreign key (biophoto_sha) references biruni_files(sha);
alter table htt_persons add constraint htt_persons_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_persons add constraint htt_persons_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index htt_persons_i5 on htt_persons(biophoto_sha) tablespace GWS_INDEX;
create index htt_persons_i6 on htt_persons(company_id, created_by) tablespace GWS_INDEX;
create index htt_persons_i7 on htt_persons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hzk_person_userpics
----------------------------------------------------------------------------------------------------
create table hzk_person_userpics(
  company_id                      number(20)     not null,
  person_id                       number(20)     not null,
  userpic                         clob,
  constraint hzk_person_userpics_pk primary key (company_id, person_id) using index tablespace GWS_INDEX,
  constraint hzk_person_userpics_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt changes in hzk_commands
----------------------------------------------------------------------------------------------------
alter table hzk_commands add command_clob clob;
alter table hzk_commands modify command null;

alter table hzk_commands drop constraint hzk_commands_c1;
alter table hzk_commands add constraint hzk_commands_c1 check (nvl2(command, 1, 0) = nvl2(command_clob, 0, 1));
alter table hzk_commands add constraint hzk_commands_c2 check (state in ('N', 'S', 'C'));

----------------------------------------------------------------------------------------------------
prompt new sequence htt_terminal_models_sq
----------------------------------------------------------------------------------------------------
create sequence htt_terminal_models_sq;
