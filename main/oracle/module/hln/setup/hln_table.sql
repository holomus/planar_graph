prompt Learn module
prompt (c) 2022 Verifix HR

-- question characteristics
----------------------------------------------------------------------------------------------------
create table hln_question_groups(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  question_group_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  is_required                     varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_question_groups_pk primary key (company_id, filial_id, question_group_id) using index tablespace GWS_INDEX,
  constraint hln_question_groups_u1 unique (question_group_id) using index tablespace GWS_INDEX,
  constraint hln_question_groups_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_question_groups_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_question_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_groups_c2 check (is_required in ('Y', 'N')),
  constraint hln_question_groups_c3 check (state in ('A', 'P')),
  constraint hln_question_groups_c4 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table hln_question_groups is 'Keeps properties about the question group. Question groups are used to separate questions into groups';

comment on column hln_question_groups.is_required is 'It is must be (Y)es or (N)o, if it is (Y)es, in creating a question it is required to select the question type depends on this question group';
comment on column hln_question_groups.state       is 'It is must be (A)ctive or (P)assive, if it is (P)assive this group can not view in create question';

create unique index hln_question_groups_u2 on hln_question_groups(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_groups_u3 on hln_question_groups(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;

create index hln_question_groups_i1 on hln_question_groups(company_id, created_by) tablespace GWS_INDEX;
create index hln_question_groups_i2 on hln_question_groups(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_types(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  question_type_id                number(20)         not null,
  question_group_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50 char),
  order_no                        number(6),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_question_types_pk primary key (company_id, filial_id, question_type_id) using index tablespace GWS_INDEX,
  constraint hln_question_types_u1 unique (question_type_id) using index tablespace GWS_INDEX,
  constraint hln_question_types_u2 unique (company_id, filial_id, question_group_id, question_type_id) using index tablespace GWS_INDEX,
  constraint hln_question_types_f1 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id) on delete cascade,
  constraint hln_question_types_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_question_types_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_question_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_types_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint hln_question_types_c3 check (state in ('A', 'P')),
  constraint hln_question_types_c4 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table hln_question_types is 'Keeps properties about the question type. Question types are used to separate questions into types';

comment on column hln_question_types.state is 'It is must be (A)ctive or (P)assive, if it is (P)assive this type can''t select in create question';

create unique index hln_question_types_u3 on hln_question_types(nvl2(code, company_id, null), nvl2(code, filial_id, null), nvl2(code, question_group_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_types_u4 on hln_question_types(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;

create index hln_question_types_i1 on hln_question_types(company_id, filial_id, question_group_id) tablespace GWS_INDEX;
create index hln_question_types_i2 on hln_question_types(company_id, created_by) tablespace GWS_INDEX;
create index hln_question_types_i3 on hln_question_types(company_id, modified_by) tablespace GWS_INDEX;

-- questions
----------------------------------------------------------------------------------------------------
create table hln_questions(
  company_id                      number(20)          not null,
  filial_id                       number(20)          not null,
  question_id                     number(20)          not null,
  name                            varchar2(2000 char) not null,
  answer_type                     varchar2(1)         not null,
  code                            varchar2(50 char),
  state                           varchar2(1)         not null,
  writing_hint                    varchar2(500 char),
  created_by                      number(20)          not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)          not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_questions_pk primary key (company_id, filial_id, question_id) using index tablespace GWS_INDEX,
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

comment on table hln_questions is 'Keeps properties about the question. Questions to use for generate Exams';

comment on column hln_questions.answer_type  is 'It is must be (S)ingle, (M)ultiple or (W)riting. If answer type is (S)ingle, of correct answers is must be one.
                                                 If (M)ultiple of correct answers should be more than one. If (W)riting answers are not be avialable';
comment on column hln_questions.state        is 'It is must be (A)ctive or (P)assive, if it is (P)assive of question does not attend for generate exams';
comment on column hln_questions.writing_hint is 'If answer type is (W)riting, you can write hint for check answer';
 
create unique index hln_questions_u2 on hln_questions(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

create index hln_questions_i1 on hln_questions(company_id, created_by) tablespace GWS_INDEX;
create index hln_questions_i2 on hln_questions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_group_binds(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  question_id                     number(20) not null,
  question_group_id               number(20) not null,
  question_type_id                number(20) not null,
  constraint hln_question_group_binds_pk primary key (company_id, filial_id, question_id, question_group_id) using index tablespace GWS_INDEX, 
  constraint hln_question_group_binds_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade,
  constraint hln_question_group_binds_f2 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id),
  constraint hln_question_group_binds_f3 foreign key (company_id, filial_id, question_group_id, question_type_id) references hln_question_types(company_id, filial_id, question_group_id, question_type_id)
) tablespace GWS_DATA;

comment on table hln_question_group_binds is 'It is helper table, helps us for to take question types and question groups depending on the question';

create index hln_question_group_binds_i1 on hln_question_group_binds(company_id, filial_id, question_group_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_options(
  company_id                      number(20)          not null,
  filial_id                       number(20)          not null,
  question_option_id              number(20)          not null,
  name                            varchar2(1000 char) not null,
  file_sha                        varchar2(64),
  question_id                     number(20)          not null,
  is_correct                      varchar2(1)         not null,
  order_no                        number(2)           not null,
  constraint hln_question_options_pk primary key (company_id, filial_id, question_option_id) using index tablespace GWS_INDEX,
  constraint hln_question_options_u1 unique (question_option_id) using index tablespace GWS_INDEX,
  constraint hln_question_options_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade,
  constraint hln_question_options_f2 foreign key (file_sha) references biruni_files(sha),
  constraint hln_question_options_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_question_options_c2 check (is_correct in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hln_question_options is 'Keeps properties about the options of question';

comment on column hln_question_options.is_correct is '(Y)es, (N)o';

create index hln_question_options_i1 on hln_question_options(company_id, filial_id, question_id) tablespace GWS_INDEX;
create index hln_question_options_i2 on hln_question_options(file_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_question_files(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  question_id                     number(20)         not null,
  file_sha                        varchar2(300 char) not null,
  order_no                        number(2),
  constraint hln_question_files_pk primary key (company_id, filial_id, question_id, file_sha) using index tablespace GWS_INDEX,
  constraint hln_question_files_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade,
  constraint hln_question_files_f2 foreign key (file_sha) references biruni_files(sha)
) tablespace GWS_DATA;

comment on table hln_question_files is 'Keeps Files of Questions';

create index hln_question_files_i1 on hln_question_files(file_sha) tablespace GWS_INDEX;

-- exam
----------------------------------------------------------------------------------------------------
create table hln_exams(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  exam_id                         number(20)         not null,
  name                            varchar2(100 char) not null,
  pick_kind                       varchar2(1)        not null,
  duration                        number(5),
  passing_score                   number(4)          not null,
  passing_percentage              number(3),
  question_count                  number(4)          not null,
  randomize_questions             varchar2(1),
  randomize_options               varchar2(1)        not null,
  for_recruitment                 varchar2(1)        not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_exams_pk primary key (company_id, filial_id, exam_id) using index tablespace GWS_INDEX,
  constraint hln_exams_u1 unique (exam_id) using index tablespace GWS_INDEX,
  constraint hln_exams_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_exams_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_exams_c1 check  (decode(trim(name), name, 1, 0) = 1),
  constraint hln_exams_c2 check  (pick_kind in ('A', 'M')),
  constraint hln_exams_c3 check  (duration > 0),
  constraint hln_exams_c4 check  (question_count > 0),
  constraint hln_exams_c5 check  (passing_score between 1 and question_count),
  constraint hln_exams_c6 check  (pick_kind = 'M' and randomize_questions is not null or pick_kind = 'A' and randomize_questions is null),
  constraint hln_exams_c7 check  (randomize_questions in ('Y', 'N')),
  constraint hln_exams_c8 check  (randomize_options in ('Y', 'N')),  
  constraint hln_exams_c9 check  (for_recruitment in ('Y', 'N')),  
  constraint hln_exams_c10 check (state in ('A', 'P')),
  constraint hln_exams_c11 check (passing_percentage between 1 and 100)
) tablespace GWS_DATA;

comment on table hln_exams is 'Keeps properties about the exam. Exams are used to create testings';

comment on column hln_exams.pick_kind           is 'It is must be (A)uto or (M)anual. If it is Auto the questions are generated automatic belong to given question types and groups. If it is Manual, the questions are selected from question list.';
comment on column hln_exams.duration            is 'Measured in minutes'; 
comment on column hln_exams.passing_score       is 'Minimum number of correct answers to pass exam';
comment on column hln_exams.randomize_questions is 'It is should be (Y)es or (N)o, if it is (Y)es, the questions are choosen random among this exam''s questions';
comment on column hln_exams.randomize_options   is 'It is should be (Y)es or (N)o, if it is (Y)es, the options are chosen random among this question''s options';
comment on column hln_exams.for_recruitment     is 'If Yes it means this Exam for Recruitment Telegram bot';
comment on column hln_exams.state               is 'It is must be (A)ctive or (P)assive, if it is (P)assive the exam don''t attend to create testings';

create index hln_exams_i1 on hln_exams(company_id, created_by) tablespace GWS_INDEX;
create index hln_exams_i2 on hln_exams(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_exam_manual_questions(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  exam_id                         number(20)         not null,
  question_id                     number(20)         not null,
  order_no                        number(6)          not null,
  constraint hln_exam_manual_questions_pk primary key (company_id, filial_id, exam_id, question_id) using index tablespace GWS_INDEX,
  constraint hln_exam_manual_questions_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id) on delete cascade,
  constraint hln_exam_manual_questions_f2 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id)
) tablespace GWS_DATA;

comment on table hln_exam_manual_questions is 'Keeps manual picked questions on exams';

create index hln_exam_manual_questions_i1 on hln_exam_manual_questions(company_id, filial_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_exam_patterns(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  pattern_id                      number(20)         not null,
  exam_id                         number(20)         not null,
  quantity                        number(6)          not null,
  has_writing_question            varchar2(1)        not null,
  max_cnt_writing_question        number(6),
  order_no                        number(6),
  constraint hln_exam_patterns_pk primary key (company_id, filial_id, pattern_id) using index tablespace GWS_INDEX,
  constraint hln_exam_patterns_u1 unique (pattern_id) using index tablespace GWS_INDEX,
  constraint hln_exam_patterns_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id) on delete cascade,
  constraint hln_exam_patterns_c1 check (quantity > 0),
  constraint hln_exam_patterns_c2 check (has_writing_question in ('Y', 'N')),
  constraint hln_exam_patterns_c3 check (has_writing_question = 'Y' or max_cnt_writing_question is null)
) tablespace GWS_DATA;

comment on table hln_exam_patterns is 'Keeps patterns of exam';

comment on column hln_exam_patterns.pattern_id           is 'Pattern is combination of question types to autopick questions on exams';
comment on column hln_exam_patterns.has_writing_question is 'It is must be (Y)es or (N)o, if (Y)es, this exam has a writing question and the examiner must check it manually';
comment on column hln_exam_patterns.max_cnt_writing_question is 'The maximum possible number of written questions in the generated questions';

create index hln_exam_patterns_i1 on hln_exam_patterns(company_id, filial_id, exam_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_pattern_question_types(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  pattern_id                      number(20)         not null,
  question_type_id                number(20)         not null,
  question_group_id               number(20)         not null,
  constraint hln_pattern_question_types_pk primary key (company_id, filial_id, pattern_id, question_type_id) using index tablespace GWS_INDEX,
  constraint hln_pattern_question_types_f1 foreign key (company_id, filial_id, pattern_id) references hln_exam_patterns(company_id, filial_id, pattern_id) on delete cascade,
  constraint hln_pattern_question_types_f2 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id),
  constraint hln_pattern_question_types_f3 foreign key (company_id, filial_id, question_type_id) references hln_question_types(company_id, filial_id, question_type_id)
) tablespace GWS_DATA;

create index hln_pattern_question_types_i1 on hln_pattern_question_types(company_id, filial_id, question_group_id) tablespace GWS_INDEX;
create index hln_pattern_question_types_i2 on hln_pattern_question_types(company_id, filial_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table hln_testings(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  testing_id                      number(20)   not null,
  exam_id                         number(20)   not null,
  person_id                       number(20)   not null,
  examiner_id                     number(20),
  testing_number                  varchar2(50) not null,
  testing_date                    date         not null,
  begin_time_period_begin         date,
  begin_time_period_end           date,
  end_time                        date,
  fact_begin_time                 date,
  fact_end_time                   date,
  pause_time                      date,
  passed                          varchar2(1)  not null,
  current_question_no             number(6),
  correct_questions_count         number(4),
  note                            varchar2(300 char),
  status                          varchar2(1)  not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_testings_pk primary key (company_id, filial_id, testing_id) using index tablespace GWS_INDEX,
  constraint hln_testings_u1 unique (testing_id) using index tablespace GWS_INDEX,
  constraint hln_testings_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id),
  constraint hln_testings_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint hln_testings_f3 foreign key (company_id, examiner_id) references mr_natural_persons(company_id, person_id),
  constraint hln_testings_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_testings_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_testings_c1 check (person_id <> examiner_id),
  constraint hln_testings_c2 check (decode(trim(testing_number), testing_number, 1, 0) = 1),  
  constraint hln_testings_c3 check (trunc(begin_time_period_begin) = trunc(testing_date)),
  constraint hln_testings_c4 check (trunc(begin_time_period_end) = trunc(testing_date)),
  constraint hln_testings_c5 check (end_time > begin_time_period_begin),
  constraint hln_testings_c6 check (end_time > begin_time_period_end),
  constraint hln_testings_c7 check (fact_end_time > fact_begin_time),
  constraint hln_testings_c8 check (pause_time between begin_time_period_begin and end_time),
  constraint hln_testings_c9 check (passed in ('Y', 'N', 'I')),
  constraint hln_testings_c10 check (status in ('N', 'E', 'P', 'C', 'F')),
  constraint hln_testings_c11 check (decode(status, 'F', 1, 0) = decode(passed, 'I', 0, 1))
) tablespace GWS_DATA;

comment on table hln_testings is 'Keeps properties about the Testing';

comment on column hln_testings.person_id           is 'Person who take the test';
comment on column hln_testings.examiner_id         is 'Person who check the test';
comment on column hln_testings.testing_date        is 'Date when take the test';
comment on column hln_testings.passed              is '(Y)es, (N)o, (I)ndeterminate, indicates whether the examinee passed the exam or not or indeterminate';
comment on column hln_testings.current_question_no is 'If there is an interruption during take testing, to continue from this question';
comment on column hln_testings.status              is '(N)ew, (E)xecuted, (P)aused, (C)hecking, (F)inished';

create index hln_testings_i1 on hln_testings(company_id, filial_id, exam_id) tablespace GWS_INDEX;
create index hln_testings_i2 on hln_testings(company_id, person_id) tablespace GWS_INDEX;
create index hln_testings_i3 on hln_testings(company_id, examiner_id) tablespace GWS_INDEX;
create index hln_testings_i4 on hln_testings(company_id, created_by) tablespace GWS_INDEX;
create index hln_testings_i5 on hln_testings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------        
create table hln_testing_questions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  testing_id                      number(20) not null,
  question_id                     number(20) not null,
  order_no                        number(6)  not null,
  writing_answer                  varchar2(500 char),
  marked                          varchar2(1),
  correct                         varchar2(1),
  constraint hln_testing_questions_pk primary key (company_id, filial_id, testing_id, question_id) using index tablespace GWS_INDEX,
  constraint hln_testing_questions_u1 unique (company_id, filial_id, testing_id, order_no) using index tablespace GWS_INDEX,
  constraint hln_testing_questions_f1 foreign key (company_id, filial_id, testing_id) references hln_testings(company_id, filial_id, testing_id) on delete cascade,
  constraint hln_testing_questions_f2 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id),
  constraint hln_testing_questions_c1 check (marked in ('Y', 'N')),
  constraint hln_testing_questions_c2 check (correct in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hln_testing_questions is 'Keeps testing''s questions';

comment on column hln_testing_questions.writing_answer is 'If the question type is a writing question, to save the written answer';
comment on column hln_testing_questions.marked         is '(Y)es, (N)o, indicated whether the question is marked or not';
comment on column hln_testing_questions.correct        is '(Y)es, (N)o, indicates whether the answer for this question is marked correctly or not';

create index hln_testing_questions_i1 on hln_testing_questions(company_id, filial_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------           
create table hln_testing_question_options(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  testing_id                      number(20) not null,
  question_id                     number(20) not null,
  question_option_id              number(20) not null,
  order_no                        number(6)  not null,
  chosen                          varchar2(1),
  constraint hln_testing_question_options_pk primary key (company_id, filial_id, testing_id, question_id, question_option_id) using index tablespace GWS_INDEX,
  constraint hln_testing_question_options_u1 unique (company_id, filial_id, testing_id, question_id, order_no) using index tablespace GWS_INDEX,
  constraint hln_testing_question_options_f1 foreign key (company_id, filial_id, testing_id, question_id) references hln_testing_questions(company_id, filial_id, testing_id, question_id) on delete cascade,
  constraint hln_testing_question_options_f2 foreign key (company_id, filial_id, question_option_id) references hln_question_options(company_id, filial_id, question_option_id),
  constraint hln_testing_question_options_c1 check (chosen in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hln_testing_question_options is 'Keeps testing''s options';

comment on column  hln_testing_question_options.chosen is '(Y)es, (N)o, indicates whether the option for the question is chosen or not';

create index hln_testing_question_options_i1 on hln_testing_question_options(company_id, filial_id, question_option_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_attestations(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  attestation_id                  number(20)   not null,
  attestation_number              varchar2(50) not null,
  name                            varchar2(100 char),
  attestation_date                date         not null,
  begin_time_period_begin         date,
  begin_time_period_end           date,
  examiner_id                     number(20)   not null,
  note                            varchar2(300 char),
  status                          varchar2(1)  not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_attestations_pk primary key (company_id, filial_id, attestation_id) using index tablespace GWS_INDEX,
  constraint hln_attestations_u1 unique (attestation_id) using index tablespace GWS_INDEX,
  constraint hln_attestations_f1 foreign key (company_id, examiner_id) references mr_natural_persons(company_id, person_id),
  constraint hln_attestations_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_attestations_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_attestations_c1 check (decode(trim(attestation_number), attestation_number, 1, 0) = 1),
  constraint hln_attestations_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_attestations_c3 check (trunc(attestation_date) = attestation_date),  
  constraint hln_attestations_c4 check (trunc(attestation_date) = trunc(begin_time_period_begin)),
  constraint hln_attestations_c5 check (trunc(attestation_date) = trunc(begin_time_period_end)),  
  constraint hln_attestations_c6 check (status in ('N', 'P', 'F'))
) tablespace GWS_DATA;

comment on table hln_attestations is 'Keeps properties about the attestation. Attestations are used to pass the test of a group of persons';

comment on column hln_attestations.attestation_date is 'Date when take the attestation';
comment on column hln_attestations.examiner_id      is 'Person who chack attestastation';
comment on column hln_attestations.status           is '(N)ew, (P)rocessing, (F)inished';

create index hln_attestations_i1 on hln_attestations(company_id, examiner_id) tablespace GWS_INDEX;
create index hln_attestations_i2 on hln_attestations(company_id, created_by) tablespace GWS_INDEX;
create index hln_attestations_i3 on hln_attestations(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_attestation_testings(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  attestation_id                  number(20) not null,
  testing_id                      number(20) not null,
  constraint hln_attestation_testings_pk primary key (company_id, filial_id, attestation_id, testing_id) using index tablespace GWS_INDEX,
  constraint hln_attestation_testings_f1 foreign key (company_id, filial_id, attestation_id) references hln_attestations(company_id, filial_id, attestation_id) on delete cascade,
  constraint hln_attestation_testings_f2 foreign key (company_id, filial_id, testing_id) references hln_testings(company_id, filial_id, testing_id)
) tablespace GWS_DATA;

comment on table hln_attestation_testings is 'Keeps testings of attestation';

create index hln_attestation_testings_i1 on hln_attestation_testings(company_id, filial_id, testing_id) tablespace GWS_INDEX;

-----------------------------------------------------------------------------------------------------
create global temporary table hln_dirty_attestations(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  attestation_id                  number(20) not null,
  constraint hln_dirty_attestations_u1 unique (company_id, filial_id, attestation_id),
  constraint hln_dirty_attestations_c1 check (attestation_id is null) deferrable initially deferred
);

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
create table hln_training_subjects(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  subject_id                      number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_training_subjects_pk primary key (company_id, filial_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_subjects_u1 unique (subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_subjects_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_training_subjects_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_training_subjects_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_training_subjects_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table hln_training_subjects is 'Keeps properties about the training subject. Subjects are used to create training';

comment on column hln_training_subjects.state is 'It must be (A)ctive or (P)assive, if (P)assive user can''t select when creating the training';

create index hln_training_subjects_i1 on hln_training_subjects(company_id, created_by) tablespace GWS_INDEX;
create index hln_training_subjects_i2 on hln_training_subjects(company_id, modified_by) tablespace GWS_INDEX;

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
create table hln_trainings(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  training_id                     number(20)         not null,
  training_number                 varchar2(50)       not null,
  begin_date                      date               not null,
  mentor_id                       number(20)         not null,
  subject_group_id                number(20),
  address                         varchar2(300 char),
  status                          varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_trainings_pk primary key (company_id, filial_id, training_id) using index tablespace GWS_INDEX,
  constraint hln_trainings_u1 unique (training_id) using index tablespace GWS_INDEX,
  constraint hln_trainings_f1 foreign key (company_id, mentor_id) references mr_natural_persons(company_id, person_id),
  constraint hln_trainings_f2 foreign key (company_id, filial_id, subject_group_id) references hln_training_subject_groups(company_id, filial_id, subject_group_id),
  constraint hln_trainings_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_trainings_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_trainings_c1 check (decode(trim(training_number), training_number, 1, 0) = 1),
  constraint hln_trainings_c2 check (status in ('N', 'E', 'F'))
) tablespace GWS_DATA;

comment on table hln_trainings is 'Keeps properties about the training. Trainins are used to pass the training of a group of persons';

comment on column hln_trainings.begin_date is 'Date when begin training';
comment on column hln_trainings.mentor_id  is 'Person who mentor this training';
comment on column hln_trainings.address    is 'Addres of trainig';
comment on column hln_trainings.status     is '(N)ew, (E)xecuted, (F)inished';

create index hln_trainings_i1 on hln_trainings(company_id, mentor_id) tablespace GWS_INDEX;
create index hln_trainings_i2 on hln_trainings(company_id, filial_id, subject_group_id) tablespace GWS_INDEX;
create index hln_trainings_i3 on hln_trainings(company_id, created_by) tablespace GWS_INDEX;
create index hln_trainings_i4 on hln_trainings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_training_current_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  training_id                     number(20) not null,
  subject_id                      number(20) not null,
  constraint hln_training_current_subjects_pk primary key (company_id, filial_id, training_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_current_subjects_f1 foreign key (company_id, filial_id, training_id) references hln_trainings(company_id, filial_id, training_id) on delete cascade,
  constraint hln_training_current_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id)
) tablespace GWS_DATA;

create index hln_training_current_subjects_i1 on hln_training_current_subjects(company_id, filial_id, subject_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_training_persons(
  company_id                 number(20)  not null,
  filial_id                  number(20)  not null,
  training_id                number(20)  not null,
  person_id                  number(20)  not null,
  passed                     varchar2(1) not null,
  constraint hln_training_persons_pk primary key (company_id, filial_id, training_id, person_id) using index tablespace GWS_INDEX,
  constraint hln_training_persons_f1 foreign key (company_id, filial_id, training_id) references hln_trainings(company_id, filial_id, training_id) on delete cascade,
  constraint hln_training_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint hln_training_persons_c1 check (passed in ('Y', 'N', 'I'))
) tablespace GWS_DATA;

comment on table hln_training_persons is 'Keeps persons of training';

comment on column hln_training_persons.person_id is 'Person who learn subject';
comment on column hln_training_persons.passed    is '(Y)es, (N)o, (I)ndeterminate, indicates whether the examinee passed the exam or not or indeterminate';

create index hln_training_persons_i1 on hln_training_persons(company_id, person_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table hln_training_person_subjects(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  training_id                     number(20)  not null,
  person_id                       number(20)  not null,
  subject_id                      number(20)  not null,
  passed                          varchar2(1) not null,
  constraint hln_training_person_subjects_pk primary key (company_id, filial_id, training_id, person_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_person_subjects_f1 foreign key (company_id, filial_id, training_id, person_id) references hln_training_persons(company_id, filial_id, training_id, person_id) on delete cascade,
  constraint hln_training_person_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id),
  constraint hln_training_person_subjects_c1 check (passed in ('Y', 'N', 'I'))
) tablespace GWS_DATA;

comment on table hln_training_person_subjects is 'Keeps Subject of Training Persons';

create index hln_training_person_subjects_i1 on hln_training_person_subjects(company_id, filial_id, subject_id) tablespace GWS_INDEX;
create index hln_training_person_subjects_i2 on hln_training_person_subjects(company_id, filial_id, person_id, subject_id) tablespace GWS_INDEX;
