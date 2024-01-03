prompt migr from 24.06.2022
----------------------------------------------------------------------------------------------------
drop table hpd_dirty_persons;

----------------------------------------------------------------------------------------------------
create global temporary table hpd_journal_page_cache(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  employee_id                     number(20) not null,
  constraint hpd_journal_staff_cache_pk primary key (company_id, filial_id, staff_id),
  constraint hpd_journal_staff_cache_c1 check (company_id is null) deferrable initially deferred
);
