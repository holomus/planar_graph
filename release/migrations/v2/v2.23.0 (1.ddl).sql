prompt migr from 25.04.2023 v2.23.0 (1.ddl)
----------------------------------------------------------------------------------------------------
comment on column htm_experience_periods.period  is 'Measured in days';
comment on column htm_experience_periods.nearest is 'Measured in days';

----------------------------------------------------------------------------------------------------
prompt new table htm_experience_job_ranks
----------------------------------------------------------------------------------------------------
create table htm_experience_job_ranks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  job_id                          number(20) not null,
  from_rank_id                    number(20) not null,
  to_rank_id                      number(20) not null,
  period                          number(6)  not null,
  nearest                         number(3)  not null,
  experience_id                   number(20) not null,
  constraint htm_experience_job_ranks_pk primary key (company_id, filial_id, job_id, from_rank_id) using index tablespace GWS_INDEX,
  constraint htm_experience_job_ranks_f1 foreign key (company_id, filial_id, experience_id, job_id) references htm_experience_jobs(company_id, filial_id, experience_id, job_id) on delete cascade,
  constraint htm_experience_job_ranks_f2 foreign key (company_id, filial_id, experience_id, from_rank_id) references htm_experience_periods(company_id, filial_id, experience_id, from_rank_id) on delete cascade
) tablespace GWS_DATA;

comment on table htm_experience_job_ranks is 'cache table for experience job and rank';

create index htm_experience_job_ranks_i1 on htm_experience_job_ranks(company_id, filial_id, experience_id, job_id) tablespace GWS_INDEX;
create index htm_experience_job_ranks_i2 on htm_experience_job_ranks(company_id, filial_id, experience_id, from_rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table htm_recommended_rank_documents
----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_documents(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  document_number                 varchar2(50 char) not null,
  document_date                   date              not null,
  division_id                     number(20),
  note                            varchar2(300 char),
  posted                          varchar2(1)       not null,
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
  constraint htm_recommended_rank_documents_c3 check (posted in ('Y', 'N')),
  constraint htm_recommended_rank_documents_c4 check (decode(posted, 'Y', 1, 'N', 0) = nvl2(journal_id, 1, 0)) deferrable initially deferred
) tablespace GWS_DATA;

comment on column htm_recommended_rank_documents.posted is '(Y)es, (N)o';

create index htm_recommended_rank_documents_i1 on htm_recommended_rank_documents(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i2 on htm_recommended_rank_documents(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i3 on htm_recommended_rank_documents(company_id, created_by) tablespace GWS_INDEX;
create index htm_recommended_rank_documents_i4 on htm_recommended_rank_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table htm_recommended_rank_staffs
----------------------------------------------------------------------------------------------------
create table htm_recommended_rank_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  document_id                     number(20) not null,
  staff_id                        number(20) not null,
  robot_id                        number(20) not null,
  from_rank_id                    number(20) not null,
  last_change_date                date       not null,
  to_rank_id                      number(20) not null,
  new_change_date                 date       not null,
  period                          number(6)  not null,
  nearest                         number(3)  not null,
  constraint htm_recommended_rank_staffs_pk primary key (company_id, filial_id, document_id, staff_id) using index tablespace GWS_INDEX,
  constraint htm_recommended_rank_staffs_f1 foreign key (company_id, filial_id, document_id) references htm_recommended_rank_documents(company_id, filial_id, document_id) on delete cascade,
  constraint htm_recommended_rank_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htm_recommended_rank_staffs_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htm_recommended_rank_staffs_f4 foreign key (company_id, filial_id, from_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_recommended_rank_staffs_f5 foreign key (company_id, filial_id, to_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_recommended_rank_staffs_c1 check (trunc(last_change_date) = last_change_date),
  constraint htm_recommended_rank_staffs_c2 check (trunc(new_change_date) = new_change_date)
) tablespace GWS_DATA;

comment on column htm_recommended_rank_staffs.period  is 'Measured in days';
comment on column htm_recommended_rank_staffs.nearest is 'Measured in days';

create index htm_recommended_rank_staffs_i1 on htm_recommended_rank_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i2 on htm_recommended_rank_staffs(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i3 on htm_recommended_rank_staffs(company_id, filial_id, from_rank_id) tablespace GWS_INDEX;
create index htm_recommended_rank_staffs_i4 on htm_recommended_rank_staffs(company_id, filial_id, to_rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new sequence htm_recommended_rank_documents_sq
----------------------------------------------------------------------------------------------------
create sequence htm_recommended_rank_documents_sq;

----------------------------------------------------------------------------------------------------
prompt hpd_journals changes
----------------------------------------------------------------------------------------------------
alter table hpd_journals add source_table varchar2(100);
alter table hpd_journals add source_id number(20);
alter table hpd_journals add constraint hpd_journals_c4 check (nvl2(source_table, 1, 0) = nvl2(source_id, 1, 0));

comment on column hpd_journals.source_table is 'keeps table name which created this journal, null if this jounal created by journal forms';

----------------------------------------------------------------------------------------------------
prompt add begin and end dates to schedule patterns
----------------------------------------------------------------------------------------------------
alter table htt_schedule_patterns add (begin_date date, end_date date);

alter table htt_schedule_patterns add constraint htt_schedule_patterns_c4 check (trunc(begin_date) = begin_date);
alter table htt_schedule_patterns add constraint htt_schedule_patterns_c5 check (trunc(end_date) = end_date);
alter table htt_schedule_patterns add constraint htt_schedule_patterns_c6 check (begin_date <= end_date); 

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htm_experience_job_ranks');
exec fazo_z.run('htm_recommended_rank');
exec fazo_z.run('hpd_journals');
exec fazo_z.run('htt_schedule_patterns');
