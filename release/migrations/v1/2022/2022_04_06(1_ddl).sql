prompt migr from 06.04.2022
----------------------------------------------------------------------------------------------------
prompt new tables for attestation
----------------------------------------------------------------------------------------------------
create table hln_attestations(
  company_id                      number(20)   not null,
  attestation_id                  number(20)   not null,
  attestation_number              varchar2(50) not null,
  name                            varchar2(100 char),
  attestation_date                date         not null,
  begin_time                      date,
  examiner_id                     number(20)   not null,
  status                          varchar2(1)  not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint hln_attestations_pk primary key (company_id, attestation_id) using index tablespace GWS_INDEX,
  constraint hln_attestations_u1 unique (attestation_id) using index tablespace GWS_INDEX,
  constraint hln_attestations_f1 foreign key (company_id, examiner_id) references mr_natural_persons(company_id, person_id),
  constraint hln_attestations_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hln_attestations_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hln_attestations_c1 check (decode(trim(attestation_number), attestation_number, 1, 0) = 1),
  constraint hln_attestations_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint hln_attestations_c3 check (trunc(attestation_date) = attestation_date),
  constraint hln_attestations_c4 check (trunc(attestation_date) = trunc(begin_time)),
  constraint hln_attestations_c5 check (status in ('N', 'P', 'F'))
) tablespace GWS_DATA;

comment on column hln_attestations.status is '(N)ew, (P)rocessing, (F)inished';

create index hln_attestations_i1 on hln_attestations(company_id, examiner_id) tablespace GWS_INDEX;
create index hln_attestations_i2 on hln_attestations(company_id, created_by) tablespace GWS_INDEX;
create index hln_attestations_i3 on hln_attestations(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hln_attestation_testings(
  company_id                      number(20) not null,
  attestation_id                  number(20) not null,
  testing_id                      number(20) not null,
  constraint hln_attestation_testings_pk primary key (company_id, attestation_id, testing_id) using index tablespace GWS_INDEX,
  constraint hln_attestation_testings_f1 foreign key (company_id, attestation_id) references hln_attestations(company_id, attestation_id) on delete cascade,
  constraint hln_attestation_testings_f2 foreign key (company_id, testing_id) references hln_testings(company_id, testing_id)
) tablespace GWS_DATA;

create index hln_attestation_testings_i1 on hln_attestation_testings(company_id, testing_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hln_dirty_attestations(
  company_id                      number(20) not null,
  attestation_id                  number(20) not null,
  constraint hln_dirty_attestations_u1 unique (company_id, attestation_id),
  constraint hln_dirty_attestations_c1 check (attestation_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
prompt new sequence for attestation
----------------------------------------------------------------------------------------------------
create sequence hln_attestations_sq;

----------------------------------------------------------------------------------------------------
prompt change question characteristic tables
----------------------------------------------------------------------------------------------------

alter table hln_question_groups add filial_id number(20);

update Hln_Question_Groups q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_question_groups modify filial_id number(20) not null; 

alter table hln_question_types drop constraint hln_question_types_f1;
alter table hln_question_type_binds drop constraint hln_question_type_binds_f2;
alter table hln_pattern_question_types drop constraint hln_pattern_question_types_f2;

alter table hln_question_groups drop constraint hln_question_groups_pk;
alter table hln_question_groups add constraint hln_question_groups_pk primary key (company_id, filial_id, question_group_id) using index tablespace GWS_INDEX;

drop index hln_question_groups_u2;
drop index hln_question_groups_u3;

create unique index hln_question_groups_u2 on hln_question_groups(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_groups_u3 on hln_question_groups(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_question_types add filial_id number(20);

update Hln_Question_Types q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_question_types modify filial_id number(20) not null;

alter table hln_question_type_binds drop constraint hln_question_type_binds_f3;
alter table hln_pattern_question_types drop constraint hln_pattern_question_types_f3;

alter table hln_question_types drop constraint hln_question_types_pk;
alter table hln_question_types add constraint hln_question_types_pk primary key (company_id, filial_id, question_type_id) using index tablespace GWS_INDEX;
alter table hln_question_types add constraint hln_question_types_f1 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id) on delete cascade;

drop index hln_question_types_u2;
drop index hln_question_types_u3;
drop index hln_question_types_i1;

create unique index hln_question_types_u2 on hln_question_types(nvl2(code, company_id, null), nvl2(code, filial_id, null), nvl2(code, question_group_id, null), code) tablespace GWS_INDEX;
create unique index hln_question_types_u3 on hln_question_types(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;
create index hln_question_types_i1 on hln_question_types(company_id, filial_id, question_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt change questions

alter table hln_questions add filial_id number(20);

update Hln_Questions q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_questions modify filial_id number(20) not null;

alter table hln_question_type_binds drop constraint hln_question_type_binds_f1;
alter table hln_question_options drop constraint hln_question_options_f1;
alter table hln_question_files drop constraint hln_question_files_f1;
alter table hln_exam_manual_questions drop constraint hln_exam_manual_questions_f2;
alter table hln_testing_questions drop constraint hln_testing_questions_f2;

alter table hln_questions drop constraint hln_questions_pk;
alter table hln_questions add constraint hln_questions_pk primary key (company_id, filial_id, question_id) using index tablespace GWS_INDEX;

drop index hln_questions_u2;

create unique index hln_questions_u2 on hln_questions(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_question_type_binds add filial_id number(20);

update Hln_Question_Type_Binds q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_question_type_binds modify filial_id number(20) not null;

alter table hln_question_type_binds drop constraint hln_question_type_binds_pk;

alter table hln_question_type_binds add constraint hln_question_type_binds_pk primary key (company_id, filial_id, question_id, question_type_id) using index tablespace GWS_INDEX;
alter table hln_question_type_binds add constraint hln_question_type_binds_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade;
alter table hln_question_type_binds add constraint hln_question_type_binds_f2 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id);
alter table hln_question_type_binds add constraint hln_question_type_binds_f3 foreign key (company_id, filial_id, question_type_id) references hln_question_types(company_id, filial_id, question_type_id);
  
drop index hln_question_type_binds_i1;
drop index hln_question_type_binds_i2;

create index hln_question_type_binds_i1 on hln_question_type_binds(company_id, filial_id, question_group_id) tablespace GWS_INDEX;
create index hln_question_type_binds_i2 on hln_question_type_binds(company_id, filial_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_question_options add filial_id number(20);

update Hln_Question_Options q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_question_options modify filial_id number(20) not null;

alter table hln_testing_question_options drop constraint hln_testing_question_options_f2;
alter table hln_question_options drop constraint hln_question_options_pk;

alter table hln_question_options add constraint hln_question_options_pk primary key (company_id, filial_id, question_option_id) using index tablespace GWS_INDEX;
alter table hln_question_options add constraint hln_question_options_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade;

drop index hln_question_options_i1;

create index hln_question_options_i1 on hln_question_options(company_id, filial_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_question_files add filial_id number(20);

update Hln_Question_Files q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_question_files modify filial_id number(20) not null;

alter table hln_question_files drop constraint hln_question_files_pk;

alter table hln_question_files add constraint hln_question_files_pk primary key (company_id, filial_id, question_id, file_sha) using index tablespace GWS_DATA;
alter table hln_question_files add constraint hln_question_files_f1 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id) on delete cascade;

----------------------------------------------------------------------------------------------------
prompt change exams

alter table hln_exams add filial_id number(20);

update Hln_Exams q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_exams modify filial_id number(20) not null;

alter table hln_exam_manual_questions drop constraint hln_exam_manual_questions_f1;
alter table hln_exam_patterns drop constraint hln_exam_patterns_f1;
alter table hln_testings drop constraint hln_testings_f1;

alter table hln_exams drop constraint hln_exams_pk;
alter table hln_exams add constraint hln_exams_pk primary key (company_id, filial_id, exam_id) using index tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
alter table hln_exam_manual_questions add filial_id number(20);

update Hln_Exam_Manual_Questions q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_exam_manual_questions modify filial_id number(20) not null;

alter table hln_exam_manual_questions drop constraint hln_exam_manual_questions_pk;

alter table hln_exam_manual_questions add constraint hln_exam_manual_questions_pk primary key (company_id, filial_id, exam_id, question_id) using index tablespace GWS_DATA;
alter table hln_exam_manual_questions add constraint hln_exam_manual_questions_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id) on delete cascade;
alter table hln_exam_manual_questions add constraint hln_exam_manual_questions_f2 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id);

drop index hln_exam_manual_questions_i1;

create index hln_exam_manual_questions_i1 on hln_exam_manual_questions(company_id, filial_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_exam_patterns add filial_id number(20);

update Hln_Exam_Patterns q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_exam_patterns modify filial_id number(20) not null;

alter table hln_pattern_question_types drop constraint hln_pattern_question_types_f1;
alter table hln_exam_patterns drop constraint hln_exam_patterns_pk;

alter table hln_exam_patterns add constraint hln_exam_patterns_pk primary key (company_id, filial_id, pattern_id) using index tablespace GWS_DATA;
alter table hln_exam_patterns add constraint hln_exam_patterns_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id) on delete cascade;

drop index hln_exam_patterns_i1;

create index hln_exam_patterns_i1 on hln_exam_patterns(company_id, filial_id, exam_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_pattern_question_types add filial_id number(20);

update Hln_Pattern_Question_Types q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_pattern_question_types modify filial_id number(20) not null;

alter table hln_pattern_question_types drop constraint hln_pattern_question_types_pk;

alter table hln_pattern_question_types add constraint hln_pattern_question_types_pk primary key (company_id, filial_id, pattern_id, question_type_id) using index tablespace GWS_DATA;
alter table hln_pattern_question_types add constraint hln_pattern_question_types_f1 foreign key (company_id, filial_id, pattern_id) references hln_exam_patterns(company_id, filial_id, pattern_id) on delete cascade;
alter table hln_pattern_question_types add constraint hln_pattern_question_types_f2 foreign key (company_id, filial_id, question_group_id) references hln_question_groups(company_id, filial_id, question_group_id);
alter table hln_pattern_question_types add constraint hln_pattern_question_types_f3 foreign key (company_id, filial_id, question_type_id) references hln_question_types(company_id, filial_id, question_type_id);

drop index hln_pattern_question_types_i1;
drop index hln_pattern_question_types_i2;

create index hln_pattern_question_types_i1 on hln_pattern_question_types(company_id, filial_id, question_group_id) tablespace GWS_INDEX;
create index hln_pattern_question_types_i2 on hln_pattern_question_types(company_id, filial_id, question_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt change testings

alter table hln_testings add filial_id number(20);

update Hln_Testings q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_testings modify filial_id number(20) not null;

alter table hln_testing_questions drop constraint hln_testing_questions_f1;
alter table hln_attestation_testings drop constraint hln_attestation_testings_f2;

alter table hln_testings drop constraint hln_testings_pk;
alter table hln_testings add constraint hln_testings_pk primary key (company_id, filial_id, testing_id) using index tablespace GWS_INDEX;
alter table hln_testings add constraint hln_testings_f1 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id);

drop index hln_testings_i1;

create index hln_testings_i1 on hln_testings(company_id, filial_id, exam_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_testing_questions add filial_id number(20);

update Hln_Testing_Questions q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_testing_questions modify filial_id number(20) not null;

alter table hln_testing_question_options drop constraint hln_testing_question_options_f1;
alter table hln_testing_questions drop constraint hln_testing_questions_pk;
alter table hln_testing_questions add constraint hln_testing_questions_pk primary key (company_id, filial_id, testing_id, question_id) using index tablespace GWS_INDEX;

alter table hln_testing_questions drop constraint hln_testing_questions_u1;
alter table hln_testing_questions add constraint hln_testing_questions_u1 unique (company_id, filial_id, testing_id, order_no) using index tablespace GWS_INDEX;

alter table hln_testing_questions add constraint hln_testing_questions_f1 foreign key (company_id, filial_id, testing_id) references hln_testings(company_id, filial_id, testing_id) on delete cascade;
alter table hln_testing_questions add constraint hln_testing_questions_f2 foreign key (company_id, filial_id, question_id) references hln_questions(company_id, filial_id, question_id);

drop index hln_testing_questions_i1;

create index hln_testing_questions_i1 on hln_testing_questions(company_id, filial_id, question_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_testing_question_options add filial_id number(20);

update Hln_Testing_Question_Options q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_testing_question_options modify filial_id number(20) not null;

alter table hln_testing_question_options drop constraint hln_testing_question_options_pk;
alter table hln_testing_question_options add constraint hln_testing_question_options_pk primary key (company_id, filial_id, testing_id, question_id, question_option_id) using index tablespace GWS_INDEX;

alter table hln_testing_question_options drop constraint hln_testing_question_options_u1;
alter table hln_testing_question_options add constraint hln_testing_question_options_u1 unique (company_id, filial_id, testing_id, question_id, order_no) using index tablespace GWS_INDEX;

alter table hln_testing_question_options add constraint hln_testing_question_options_f1 foreign key (company_id, filial_id, testing_id, question_id) references hln_testing_questions(company_id, filial_id, testing_id, question_id) on delete cascade;
alter table hln_testing_question_options add constraint hln_testing_question_options_f2 foreign key (company_id, filial_id, question_option_id) references hln_question_options(company_id, filial_id, question_option_id);

drop index hln_testing_question_options_i1;

create index hln_testing_question_options_i1 on hln_testing_question_options(company_id, filial_id, question_option_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt change attestations

alter table hln_attestations add filial_id number(20);

update Hln_Attestations q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_attestations modify filial_id number(20) not null;

alter table hln_attestation_testings drop constraint hln_attestation_testings_f1;
alter table hln_attestations drop constraint hln_attestations_pk;
alter table hln_attestations add constraint hln_attestations_pk primary key (company_id, filial_id, attestation_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_attestation_testings add filial_id number(20);

update Hln_Attestation_Testings q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_attestation_testings modify filial_id number(20) not null;

alter table hln_attestation_testings drop constraint hln_attestation_testings_pk;

alter table hln_attestation_testings add constraint hln_attestation_testings_pk primary key (company_id, filial_id, attestation_id, testing_id) using index tablespace GWS_INDEX;
alter table hln_attestation_testings add constraint hln_attestation_testings_f1 foreign key (company_id, filial_id, attestation_id) references hln_attestations(company_id, filial_id, attestation_id) on delete cascade;
alter table hln_attestation_testings add constraint hln_attestation_testings_f2 foreign key (company_id, filial_id, testing_id) references hln_testings(company_id, filial_id, testing_id);

drop index hln_attestation_testings_i1;

create index hln_attestation_testings_i1 on hln_attestation_testings(company_id, filial_id, testing_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_dirty_attestations add filial_id number(20) not null;
alter table hln_dirty_attestations drop constraint hln_dirty_attestations_u1;
alter table hln_dirty_attestations add constraint hln_dirty_attestations_u1 unique (company_id, filial_id, attestation_id);

----------------------------------------------------------------------------------------------------
prompt change trainings

alter table hln_training_subjects add filial_id number(20);

update Hln_Training_Subjects q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_training_subjects modify filial_id number(20) not null;

alter table hln_trainings drop constraint hln_trainings_f2;
alter table hln_training_subjects drop constraint hln_training_subjects_pk;
alter table hln_training_subjects add constraint hln_training_subjects_pk primary key (company_id, filial_id, subject_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_trainings add filial_id number(20);

update Hln_Trainings q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_trainings modify filial_id number(20) not null;

alter table hln_training_persons drop constraint hln_training_persons_f1;

alter table hln_trainings drop constraint hln_trainings_pk;
alter table hln_trainings add constraint hln_trainings_pk primary key (company_id, filial_id, training_id) using index tablespace GWS_INDEX;
alter table hln_trainings add constraint hln_trainings_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id);

drop index hln_trainings_i2;

create index hln_trainings_i2 on hln_trainings(company_id, filial_id, subject_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hln_training_persons add filial_id number(20);

update Hln_Training_Persons q
   set q.Filial_Id =
       (select w.Filial_Id
          from Md_Filials w
         where w.Company_Id = q.Company_Id
           and w.State = 'A'
         order by w.Created_On Offset 1 row
         fetch first row only);
commit;

alter table hln_training_persons modify filial_id number(20) not null;

alter table hln_training_persons drop constraint hln_training_persons_pk;
alter table hln_training_persons add constraint hln_training_persons_pk primary key (company_id, filial_id, training_id, person_id) using index tablespace GWS_INDEX;
alter table hln_training_persons add constraint hln_training_persons_f1 foreign key (company_id, filial_id, training_id) references hln_trainings(company_id, filial_id, training_id) on delete cascade;

----------------------------------------------------------------------------------------------------
-- change md_sequences
declare
  v_Filial_Id number;
begin
  for r in (select *
              from Md_Companies)
  loop
    begin
      select Filial_Id
        into v_Filial_Id
        from Md_Filials
       where Company_Id = r.Company_Id
       order by Created_On Offset 1 row
       fetch first row only;
    
      update Md_Sequences
         set Filial_Id = v_Filial_Id
       where Company_Id = r.Company_Id
         and Upper(Code) like 'HLN_%';
    exception
      when No_Data_Found then
        null;
    end;
  end loop;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt type binds changed to group bind
----------------------------------------------------------------------------------------------------
alter table hln_question_type_binds rename to hln_question_group_binds;

alter table hln_question_group_binds drop constraint hln_question_type_binds_pk;
alter table hln_question_group_binds add constraint hln_question_group_binds_pk primary key (company_id, filial_id, question_id, question_group_id) using index tablespace GWS_INDEX;

alter index hln_question_types_u3 rename to hln_question_types_u4;
alter index hln_question_types_u2 rename to hln_question_types_u3;
alter table hln_question_types add constraint hln_question_types_u2 unique(company_id, filial_id, question_group_id, question_type_id) using index tablespace GWS_INDEX;

alter table hln_question_group_binds rename constraint hln_question_type_binds_f1 to hln_question_group_binds_f1;
alter table hln_question_group_binds rename constraint hln_question_type_binds_f2 to hln_question_group_binds_f2;
alter table hln_question_group_binds drop constraint hln_question_type_binds_f3;
alter table hln_question_group_binds add constraint hln_question_group_binds_f3 foreign key (company_id, filial_id, question_group_id, question_type_id) references hln_question_types(company_id, filial_id, question_group_id, question_type_id);

alter index hln_question_type_binds_i1 rename to hln_question_group_binds_i1;
drop index hln_question_type_binds_i2;

----------------------------------------------------------------------------------------------------
prompt note column added to attestation;
alter table hln_attestations add note varchar2(300 char);

----------------------------------------------------------------------------------------------------
prompt modify note columns size;
alter table hln_testings modify note varchar2(300 char);
alter table htt_tracks modify note varchar2(300 char);

----------------------------------------------------------------------------------------------------
prompt new structures for schedule marks
----------------------------------------------------------------------------------------------------
-- ddls
----------------------------------------------------------------------------------------------------
create table htt_schedule_origin_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_origin_day_marks_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_origin_day_marks_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_origin_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_origin_day_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_origin_day_marks is 'Keeps marks schedule for each schedule day';

create index htt_schedule_origin_day_marks_i1 on htt_schedule_origin_day_marks(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_schedule_day_marks_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_day_marks_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_schedule_day_marks is 'Keeps marks schedule for each schedule day';

create index htt_schedule_day_marks_i1 on htt_schedule_day_marks(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_schedule_pattern_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_pattern_marks_pk primary key (company_id, filial_id, schedule_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_pattern_marks_f1 foreign key (company_id, filial_id, schedule_id, day_no) references htt_schedule_pattern_days(company_id, filial_id, schedule_id, day_no) on delete cascade,
  constraint htt_schedule_pattern_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_pattern_marks is 'Keeps marks schedule for each pattern day';

comment on column htt_schedule_pattern_marks.begin_time is 'Shows minutes from 00:00';
comment on column htt_schedule_pattern_marks.end_time   is 'Shows minutes from 00:00';

----------------------------------------------------------------------------------------------------
create table htt_timesheet_marks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  begin_time                      date        not null,
  end_time                        date        not null,
  done                            varchar2(1) not null,
  constraint htt_timesheet_marks_pk primary key (company_id, filial_id, timesheet_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_timesheet_marks_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_marks_c1 check (begin_time < end_time),
  constraint htt_timesheet_marks_c2 check (done in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_timesheet_marks is 'Keeps marks for each timesheet day. Only (C)heck track types are used in marking';

comment on column htt_timesheet_marks.done is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
alter table htt_timesheets add planned_marks number(4);
alter table htt_timesheets add done_marks number(4);

alter table htt_timesheets add constraint htt_timesheets_c19 check (done_marks >= 0 and done_marks <= planned_marks);

comment on column htt_timesheets.planned_marks  is 'Count of planned marks for this timesheet day';
comment on column htt_timesheets.done_marks     is 'Count of done marks for this timesheet day';

----------------------------------------------------------------------------------------------------
create unique index htt_calendar_days_u2 on htt_calendar_days(company_id, filial_id, calendar_id, nvl(swapped_date, calendar_date));

----------------------------------------------------------------------------------------------------
declare
  v_Filial_Head number;
  v_User_System number;
begin
  for Cmp in (select q.Company_Id
                from Md_Companies q)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      update Htt_Timesheets t
         set t.Planned_Marks = 0,
             t.Done_Marks    = 0
       where t.Company_Id = Cmp.Company_Id
         and t.Filial_Id = Fil.Filial_Id;
    
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify planned_marks not null;
alter table htt_timesheets modify done_marks not null;

----------------------------------------------------------------------------------------------------
