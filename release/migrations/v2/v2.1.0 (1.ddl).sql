prompt migr from 06.07.2022
----------------------------------------------------------------------------------------------------
prompt add journal overtimes table
----------------------------------------------------------------------------------------------------
create table hpd_journal_overtimes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  overtime_id                     number(20) not null,
  journal_id                      number(20) not null,
  employee_id                     number(20) not null,
  staff_id                        number(20) not null,
  begin_date                      date       not null,
  end_date                        date       not null,
  constraint hpd_journal_overtimes_pk primary key (company_id, filial_id, overtime_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_overtimes_u1 unique (overtime_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_overtimes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_overtimes_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_journal_overtimes_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_journal_overtimes_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_journal_overtimes_c2 check (trunc(end_date) = end_date),
  constraint hpd_journal_overtimes_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_journal_overtimes_i1 on hpd_journal_overtimes(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_journal_overtimes_i2 on hpd_journal_overtimes(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_journal_overtimes_i3 on hpd_journal_overtimes(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create sequence hpd_journal_overtimes_sq;

----------------------------------------------------------------------------------------------------
create table hpd_overtime_days(
  company_id                       number(20) not null,
  filial_id                        number(20) not null,
  staff_id                         number(20) not null,
  overtime_date                    date       not null,
  overtime_seconds                 number(20) not null,
  overtime_id                      number(20) not null,
  constraint hpd_overtime_days_pk primary key (company_id, filial_id, staff_id, overtime_date) using index tablespace GWS_INDEX,
  constraint hpd_overtime_days_f1 foreign key (company_id, filial_id, overtime_id) references hpd_journal_overtimes(company_id, filial_id, overtime_id) on delete cascade,
  constraint hpd_overtime_days_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_overtime_days_c1 check (trunc(overtime_date) = overtime_date),
  constraint hpd_overtime_days_c2 check (overtime_seconds between 0 and 86400)
) tablespace GWS_DATA;

create index hpd_overtime_days_i1 on hpd_overtime_days(company_id, filial_id, overtime_id) tablespace GWS_INDEX;