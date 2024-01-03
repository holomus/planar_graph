prompt adding max exam question count
----------------------------------------------------------------------------------------------------
alter table hln_exam_patterns add max_cnt_writing_question number(6);
alter table hln_exam_patterns add constraint hln_exam_patterns_c3 check (has_writing_question = 'Y' or max_cnt_writing_question is null);

comment on column hln_exam_patterns.max_cnt_writing_question is 'The maximum possible number of written questions in the generated questions';

---------------------------------------------------------------------------------------------------- 
prompt adding note to hpr_book_operations
----------------------------------------------------------------------------------------------------
alter table hpr_book_operations add note varchar2(300 char);

----------------------------------------------------------------------------------------------------
prompt add new overtime journal divisions table
----------------------------------------------------------------------------------------------------  
create table hpd_overtime_journal_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20) not null, 
  constraint hpd_overtime_journal_divisions_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_overtime_journal_divisions_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_overtime_journal_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

create index hpd_overtime_journal_divisions_i1 on hpd_overtime_journal_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpr_book_operations');
exec fazo_z.run('hpd_overtime_journal_divisions');
exec fazo_z.run('hln_exam_patterns');
