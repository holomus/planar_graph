prompt migr from 07.12.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt add comment for some tables

comment on table hln_question_groups is 'Keeps Question Groups';
comment on column hln_question_groups.is_required is 'It is should be (Y)es or (N)o, if it is (Y)es, in creating a question it is required to select the question type depends on this question group';
comment on column hln_question_groups.state is 'It is should be (A)ctive or (P)assive, if it is (P)assive this group can not view in create question';

comment on table hln_question_types is 'Keeps Question Types';
comment on column hln_question_types.state is 'It is must be (A)ctive or (P)assive, if it is (P)assive this type can''t select in create question';

comment on table hln_questions is 'Keeps Questions';
comment on column hln_questions.answer_type is 'It is must be (S)ingle, (M)ultiple or (W)riting. If answer type is (S)ingle, of correct answers is must be one.
                                                If (M)ultiple of correct answers should be more than one. If (W)riting answers are not be avialable';
comment on column hln_questions.state is 'It is must be (A)ctive or (P)assive, if it is (P)assive of question does not attend for generate exams';
comment on column hln_questions.writing_hint is 'If answer type is (W)riting, you can write hint for check answer';

comment on table hln_question_group_binds is 'It is helper table, helps us for to take question types and question groups depending on the question';

comment on table hln_question_options is 'Keeps Options of Questions';

comment on table hln_question_files is 'Keeps Files of Questions';

comment on table hln_exams is 'Keeps Exams';
comment on column hln_exams.pick_kind is 'It is must be (A)uto or (M)anual. If it is (A)uto the questions are generated automatic belong to given question types and groups. If it is (M)anual, the questions are selected from question list.';
comment on column hln_exams.duration is 'Measured in minutes'; 
comment on column hln_exams.passing_score is 'Minimum number of correct answers to pass exam';
comment on column hln_exams.randomize_questions is 'It is should be (Y)es or (N)o, if it is (Y)es, the questions are choosen random among this exam''s questions';
comment on column hln_exams.randomize_options is 'It is should be (Y)es or (N)o, if it is (Y)es, the options are chosen random among this question''s options';
comment on column hln_exams.state is 'It is must be (A)ctive or (P)assive, if it is (P)assive the exam don''t attend to create testings';

comment on table hln_exam_manual_questions is 'Keeps manual picked questions on exams';

comment on table hln_exam_patterns is 'Keeps patterns of exam';
comment on column hln_exam_patterns.has_writing_question is 'It is must be (Y)es or (N)o, if (Y)es, this exam has a writing question and the examiner must check it manually';

comment on table hln_testings is 'Keeps Testings';
comment on column hln_testings.person_id is 'Person who take the test';
comment on column hln_testings.examiner_id is 'Person who check the test';
comment on column hln_testings.testing_date is 'Date when take the test';
comment on column hln_testings.current_question_no is 'If there is an interruption during take testing, to continue from this question';

comment on table hln_testing_questions is 'Keeps testing''s questions';
comment on column hln_testing_questions.writing_answer is 'If the question type is a writing question, to save the written answer';

comment on table hln_testing_question_options is 'Keeps testing''s options';

comment on table hln_attestations is 'Keeps attestations';
comment on column hln_attestations.attestation_date is 'Date when take the attestation';
comment on column hln_attestations.examiner_id is 'Person who chack attestastation';

comment on table hln_attestation_testings is 'Keeps testings of attestation';

comment on table hln_training_subjects is 'Keeps training subjects. It will use to create training';
comment on column hln_training_subjects.state is 'It must be (A)ctive or (P)assive, if (P)assive user can''t select when creating the training';

comment on table hln_trainings is 'Keeps trainings';
comment on column hln_trainings.begin_date is 'Date when begin training';
comment on column hln_trainings.mentor_id is 'Person who mentor this training';
comment on column hln_trainings.subject_id is 'Subject taught';
comment on column hln_trainings.address is 'Addres of trainig';

comment on table hln_training_persons is 'Keeps persons of training';
comment on column hln_training_persons.person_id is 'Person who learn subject';

----------------------------------------------------------------------------------------------------
prompt hpd_journal_overtimes added modified_id
---------------------------------------------------------------------------------------------------- 
alter table hpd_journal_overtimes add modified_id number(20);

---------------------------------------------------------------------------------------------------- 
update hpd_journal_overtimes
       set modified_id = Biruni_Modified_Sq.Nextval;
commit;
----------------------------------------------------------------------------------------------------
alter table hpd_journal_overtimes add constraint hpd_journal_overtimes_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;
       
----------------------------------------------------------------------------------------------------
alter table hpd_journal_overtimes modify modified_id not null;


----------------------------------------------------------------------------------------------------
prompt add modified id for calendar
----------------------------------------------------------------------------------------------------

alter table htt_calendars add modified_id number(20);

update htt_calendars
   set Modified_id = Biruni_Modified_Sq.Nextval;
commit;

alter index htt_calendars_u4 rename to htt_calendars_u5;
alter index htt_calendars_u3 rename to htt_calendars_u4;
alter index htt_calendars_u2 rename to htt_calendars_u3;

alter table htt_calendars add constraint htt_calendars_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter table htt_calendars modify modified_id number(20) not null;

---------------------------------------------------------------------------------------------------- 
prompt add fte_id to href_staffs
---------------------------------------------------------------------------------------------------- 
alter table href_staffs add fte_id number(20);

drop index href_staffs_i5;
drop index href_staffs_i6;
drop index href_staffs_i7;
drop index href_staffs_i8;
drop index href_staffs_i9;

create index href_staffs_i5 on href_staffs(company_id, filial_id, fte_id) tablespace GWS_INDEX;
create index href_staffs_i6 on href_staffs(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index href_staffs_i7 on href_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index href_staffs_i8 on href_staffs(company_id, filial_id, parent_id) tablespace GWS_INDEX;
create index href_staffs_i9 on href_staffs(company_id, created_by) tablespace GWS_INDEX;
create index href_staffs_i10 on href_staffs(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add table inventory types and person inventories
----------------------------------------------------------------------------------------------------
create table href_inventory_types(
  company_id                      number(20)         not null,
  inventory_type_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_inventory_types_pk primary key (company_id, inventory_type_id) using index tablespace GWS_INDEX,
  constraint href_inventory_types_u1 unique (inventory_type_id) using index tablespace GWS_INDEX,
  constraint href_inventory_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_inventory_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_inventory_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_inventory_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index href_inventory_types_u2 on href_inventory_types(company_id, lower(name)) tablespace GWS_INDEX;

create index href_inventory_types_i1 on href_inventory_types(company_id, created_by) tablespace GWS_INDEX;
create index href_inventory_types_i2 on href_inventory_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_inventories (
  company_id                      number(20) not null,
  person_inventory_id             number(20) not null,
  person_id                       number(20) not null,
  inventory_type_id               number(20) not null,
  date_assigned                   date       not null,
  date_returned                   date,
  note                            varchar2(300 char),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_inventories_pk primary key (company_id, person_inventory_id) using index tablespace GWS_INDEX,
  constraint href_person_inventories_u1 unique (person_inventory_id) using index tablespace GWS_INDEX,
  constraint href_person_inventories_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_inventories_f2 foreign key (company_id, inventory_type_id) references href_inventory_types(company_id, inventory_type_id),
  constraint href_person_inventories_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_inventories_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_inventories_c1 check (trunc(date_assigned) = date_assigned),
  constraint href_person_inventories_c2 check (trunc(date_returned) = date_returned),
  constraint href_person_inventories_c3 check (date_assigned <= date_returned)
) tablespace GWS_DATA;

create index href_person_inventories_i1 on href_person_inventories(company_id, person_id) tablespace GWS_INDEX;
create index href_person_inventories_i2 on href_person_inventories(company_id, inventory_type_id) tablespace GWS_INDEX;
create index href_person_inventories_i3 on href_person_inventories(company_id, created_by) tablespace GWS_INDEX;
create index href_person_inventories_i4 on href_person_inventories(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------         
create sequence href_inventory_types_sq;
create sequence href_person_inventories_sq;

---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('hpd_journal_overtimes');
exec fazo_z.run('htt_calendars');
exec fazo_z.run('href_staffs');
exec fazo_z.run('href_inventory_types');
exec fazo_z.run('href_person_inventories');
