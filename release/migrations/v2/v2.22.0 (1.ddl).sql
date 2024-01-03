prompt migr from 07.04.2023 v2.22.0 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt charge_percentage added to htt_devices table
---------------------------------------------------------------------------------------------------- 
alter table htt_devices add charge_percentage number(3);
alter table htt_devices add constraint htt_devices_c8 check(charge_percentage between 0 and 100);

----------------------------------------------------------------------------------------------------
prompt passing_percentage added to hln_exams table
----------------------------------------------------------------------------------------------------
alter table hln_exams add passing_percentage number(3);
alter table hln_exams add constraint hln_exams_c10 check (passing_percentage between 1 and 100);
  
exec fazo_z.run('htt_devices');
exec fazo_z.run('hln_exams');

prompt add HTM Module, add Tables
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
  period                          number(6)  not null,
  nearest                         number(3)  not null,
  order_no                        number(2),
  constraint htm_experience_periods_pk primary key (company_id, filial_id, experience_id, from_rank_id) using index tablespace GWS_INDEX,
  constraint htm_experience_periods_f1 foreign key (company_id, filial_id, experience_id) references htm_experiences(company_id, filial_id, experience_id) on delete cascade,
  constraint htm_experience_periods_f2 foreign key (company_id, filial_id, from_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_experience_periods_f3 foreign key (company_id, filial_id, to_rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint htm_experience_periods_c1 check (nearest >= 0),
  constraint htm_experience_periods_c2 check (period > nearest)  
) tablespace GWS_DATA;

comment on column htm_experience_periods.period  is 'Measured is day';
comment on column htm_experience_periods.nearest is 'Measured is day';

create index htm_experience_periods_i1 on htm_experience_periods(company_id, filial_id, from_rank_id) tablespace GWS_INDEX;
create index htm_experience_periods_i2 on htm_experience_periods(company_id, filial_id, to_rank_id) tablespace GWS_INDEX;

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
create sequence htm_experiences_sq;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('htm_');

drop table href_restricted_dismissal_reasons;

