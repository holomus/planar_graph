prompt htt_device constraint fix
alter table htt_devices drop constraint htt_devices_u2;
alter table htt_devices add constraint htt_devices_u2 unique (company_id, filial_id, device_type_id, serial_number) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_wages(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  wage_id                         number(20)   not null,
  job_id                          number(20)   not null,
  rank_id                         number(20),
  wage_begin                      number(20,6) not null,
  wage_end                        number(20,6) not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_wages_pk primary key (company_id, filial_id, wage_id) using index tablespace GWS_INDEX,
  constraint href_wages_u1 unique (wage_id) using index tablespace GWS_INDEX,
  constraint href_wages_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint href_wages_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint href_wages_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_wages_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_wages_c1 check (wage_begin > 0 and wage_end > 0 and wage_end >= wage_begin)
) tablespace GWS_DATA;

create unique index href_wages_u2 on href_wages(company_id, filial_id, job_id, rank_id) tablespace GWS_INDEX;

create index href_wages_i1 on href_wages(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index href_wages_i2 on href_wages(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index href_wages_i3 on href_wages(company_id, created_by) tablespace GWS_INDEX;
create index href_wages_i4 on href_wages(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_employment_sources(
  company_id                      number(20)         not null,
  source_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  kind                            varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_employment_sources_pk primary key (company_id, source_id) using index tablespace GWS_INDEX,
  constraint href_employment_sources_u1 unique (source_id) using index tablespace GWS_INDEX,
  constraint href_employment_sources_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_employment_sources_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_employment_sources_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_employment_sources_c2 check (kind in ('H', 'D', 'B')),
  constraint href_employment_sources_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_employment_sources.kind is '(H)iring, (D)ismissal, (B)oth';
comment on column href_employment_sources.state is '(A)ctive, (P)assive';

create index href_employment_sources_i1 on href_employment_sources(company_id, created_by) tablespace GWS_INDEX;
create index href_employment_sources_i2 on href_employment_sources(company_id, modified_by) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
-- sequence
----------------------------------------------------------------------------------------------------
create sequence href_wages_sq;
create sequence href_employment_sources_sq;
----------------------------------------------------------------------------------------------------
-- add employment source in hiring and dismissal
----------------------------------------------------------------------------------------------------
alter table hpd_hirings add employment_source_id number(20);
alter table hpd_hirings add constraint hpd_hirings_f2 foreign key (company_id, employment_source_id) references href_employment_sources(company_id, source_id);
create index hpd_hirings_i1 on hpd_hirings(company_id, employment_source_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpd_dismissals add employment_source_id number(20);
alter table hpd_dismissals add constraint hpd_dismissals_f3 foreign key (company_id, employment_source_id) references href_employment_sources(company_id, source_id);
create index hpd_dismissals_i2 on hpd_dismissals(company_id, employment_source_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- add key person column in href_person_details
----------------------------------------------------------------------------------------------------
alter table href_person_details add key_person varchar2(1);
alter table href_person_details add constraint href_person_details_c5 check (key_person in ('Y', 'N'));

update href_person_details q
   set q.key_person = 'N';
   
alter table href_person_details modify key_person not null;

exec fazo_z.run('h');
