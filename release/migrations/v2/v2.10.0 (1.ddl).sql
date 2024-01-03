prompt migr from 28.10.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt new table hpd_schedule_multiples
----------------------------------------------------------------------------------------------------
create table hpd_schedule_multiples(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  begin_date                      date       not null,
  end_date                        date,
  constraint hpd_schedule_multiples_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_schedule_multiples_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_schedule_multiples_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_schedule_multiples_c1 check (begin_date = trunc(begin_date)),
  constraint hpd_schedule_multiples_c2 check (end_date = trunc(end_date)),  
  constraint hpd_schedule_multiples_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_schedule_multiples_i1 on hpd_schedule_multiples(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_nationalities(
  company_id                      number(20)         not null,
  nationality_id                  number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,  
  constraint href_nationalities_pk primary key (company_id, nationality_id) using index tablespace GWS_INDEX,
  constraint href_nationalities_u1 unique (nationality_id) using index tablespace GWS_INDEX,
  constraint href_nationalities_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_nationalities_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_nationalities_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_nationalities_c2 check (state in ('A', 'P')),
  constraint href_nationalities_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_nationalities.state is '(A)ctive, (P)assive';

create unique index href_nationalities_u2 on href_nationalities(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_nationalities_u3 on href_nationalities(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_nationalities_i1 on href_nationalities(company_id, created_by) tablespace GWS_INDEX;
create index href_nationalities_i2 on href_nationalities(company_id, modified_by) tablespace GWS_INDEX;

create sequence href_nationalities_sq;

----------------------------------------------------------------------------------------------------
alter table href_person_details add nationality_id number(20);

alter table href_person_details add constraint href_person_details_f2 foreign key (company_id, nationality_id) references href_nationalities(company_id, nationality_id);

prompt migr from 26.10.2022
----------------------------------------------------------------------------------------------------
alter table htt_request_kinds drop constraint htt_request_kinds_c4;
alter table htt_request_kinds drop constraint htt_request_kinds_c5;
alter table htt_request_kinds drop constraint htt_request_kinds_c6;
alter table htt_request_kinds drop constraint htt_request_kinds_c7;
alter table htt_request_kinds drop constraint htt_request_kinds_c8;

alter table htt_request_kinds add carryover_policy       varchar2(1);
alter table htt_request_kinds add carryover_cap_days     number(3);
alter table htt_request_kinds add carryover_expires_days number(3);

comment on column htt_request_kinds.carryover_policy         is 'What happens to annually accrued leave time when the Year End Date is reached each year: carryover (A)ll, reset to (Z)ero, set a (C)ap on how much time can be accrued';
comment on column htt_request_kinds.carryover_cap_days       is 'How much time can be accrued';
comment on column htt_request_kinds.carryover_expires_days   is 'The number of days after which the carryover will expire';

alter table htt_requests add accrual_kind varchar2(1);
alter table htt_requests add constraint htt_requests_c4 check (accrual_kind in ('C', 'P'));

comment on column htt_requests.accrual_kind is '(C)arryover, (P)lan';


----------------------------------------------------------------------------------------------------
create table htt_request_kind_accruals(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  staff_id                        number(20)   not null,
  request_kind_id                 number(20)   not null,
  period                          date         not null,
  accrual_kind                    varchar2(1)  not null,
  accrued_days                    number(20,6) not null,
  constraint htt_request_kind_accruals_pk primary key (company_id, filial_id, staff_id, request_kind_id, period, accrual_kind) using index tablespace GWS_INDEX,
  constraint htt_request_kind_accruals_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_request_kind_accruals_f2 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id) on delete cascade,
  constraint htt_request_kind_acrruals_c1 check (trunc(period) = period),
  constraint htt_request_kind_accruals_c2 check (accrual_kind in ('C', 'P')),
  constraint htt_request_kind_accruals_c3 check (accrued_days >= 0)
) tablespace GWS_DATA;

comment on table htt_request_kind_accruals is 'Yearly accrual plans';

comment on column htt_request_kind_accruals.period       is 'Is last day in accrual period. Period starts with new year (01.01)';
comment on column htt_request_kind_accruals.accrual_kind is '(C)arryover, (P)lan';

create index htt_request_kind_accruals_i1 on htt_request_kind_accruals(company_id, request_kind_id) tablespace GWS_INDEX; 

----------------------------------------------------------------------------------------------------
create table htt_staff_request_kinds(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  request_kind_id                 number(20) not null,
  constraint htt_staff_request_kinds_pk primary key (company_id, filial_id, staff_id, request_kind_id) using index tablespace GWS_INDEX,
  constraint htt_staff_request_kinds_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_staff_request_kinds_f2 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id)
) tablespace GWS_DATA;

create index htt_staff_request_kinds_i1 on htt_staff_request_kinds(company_id, request_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_schedule_multiples');
exec fazo_z.run('href_nationalities');
exec fazo_z.run('href_person_details');
exec fazo_z.run('htt_request_kind_accruals');
exec fazo_z.run('htt_requests');
exec fazo_z.run('htt_staff_request_kinds');

