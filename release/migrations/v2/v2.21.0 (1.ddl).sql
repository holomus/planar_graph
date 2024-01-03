prompt migr from 25.03.2023 v2.21.0 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt new table hpd_journal_timebook_adjustments
----------------------------------------------------------------------------------------------------
create table hpd_journal_timebook_adjustments(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  adjustment_date                 date       not null,
  constraint hpd_journal_timebook_adjustments_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_timebook_adjustments_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_timebook_adjustments_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_journal_timebook_adjustments_c1 check (trunc(adjustment_date) = adjustment_date)
) tablespace GWS_DATA;

create index hpd_journal_timebook_adjustments_i1 on hpd_journal_timebook_adjustments(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_page_adjustments
----------------------------------------------------------------------------------------------------
create table hpd_page_adjustments(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  free_time                       number(4)  not null,
  overtime                        number(4)  not null,
  turnout_time                    number(4)  not null,
  constraint hpd_page_adjustments_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_adjustments_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_adjustments_c1 check (free_time > 0 ),
  constraint hpd_page_adjustments_c2 check (overtime >= 0),
  constraint hpd_page_adjustments_c3 check (turnout_time >= 0),
  constraint hpd_page_adjustments_c4 check (free_time >= overtime + turnout_time)
) tablespace GWS_DATA;

comment on column hpd_page_adjustments.free_time    is 'Measured in minutes';
comment on column hpd_page_adjustments.overtime     is 'Measured in minutes';
comment on column hpd_page_adjustments.turnout_time is 'Measured in minutes';

----------------------------------------------------------------------------------------------------
prompt new table hpd_lock_adjustments
----------------------------------------------------------------------------------------------------
create table hpd_lock_adjustments(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  adjustment_date                 date       not null,
  journal_id                      number(20) not null,
  page_id                         number(20) not null,
  constraint hpd_lock_adjustments_pk primary key (company_id, filial_id, staff_id, adjustment_date) using index tablespace GWS_INDEX,
  constraint hpd_lock_adjustments_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_lock_adjustments_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint hpd_lock_adjustments_f3 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id)
) tablespace GWS_DATA;

create index hpd_lock_adjustments_i1 on hpd_lock_adjustments(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_lock_adjustments_i2 on hpd_lock_adjustments(company_id, filial_id, page_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt operations on htt_locations
----------------------------------------------------------------------------------------------------
alter table htt_locations drop constraint htt_locations_c2;
alter table htt_locations drop constraint htt_locations_c3;

alter table htt_locations add prohibited varchar2(1);
alter table htt_locations add constraint htt_locations_c2 check (prohibited in ('Y', 'N'));
alter table htt_locations add constraint htt_locations_c3 check (state in ('A', 'P'));
alter table htt_locations add constraint htt_locations_c4 check (decode(trim(code), code, 1, 0) = 1);

comment on column htt_locations.prohibited is '(Y)es, (N)o';
comment on column htt_locations.state      is 'It must be (A)ctive or (P)assive. If it will (P)assive this location can''t use';

----------------------------------------------------------------------------------------------------
prompt set htt_locations.prohibited to 'N'
---------------------------------------------------------------------------------------------------- 
update htt_locations set prohibited = 'N';
commit;

----------------------------------------------------------------------------------------------------
prompt make htt_locations.prohibited not null
----------------------------------------------------------------------------------------------------
alter table htt_locations modify prohibited not null;

----------------------------------------------------------------------------------------------------
prompt create unique index href_person_documents_u2 on doc_series and doc_number
---------------------------------------------------------------------------------------------------- 
create unique index href_person_documents_u2 on href_person_documents(nvl2(doc_series || doc_number, company_id, null), nvl2(doc_series || doc_number, doc_type_id, null), doc_series || doc_number) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding temporary table htt_migrated_employees
----------------------------------------------------------------------------------------------------
create global temporary table htt_migrated_employees(
  company_id                       number(20) not null,
  filial_id                        number(20) not null,
  employee_id                      number(20) not null,
  period_begin                     date       not null,
  constraint htt_migrated_employees_pk primary key (company_id, filial_id, employee_id),
  constraint htt_migrated_employees_c1 check (company_id is null) deferrable initially deferred
);

comment on table htt_migrated_employees is 'Employees that will have tracks migrated to other filial';

----------------------------------------------------------------------------------------------------
prompt adding track_date to htt_tracks_i1 index
----------------------------------------------------------------------------------------------------
drop index htt_tracks_i1;
create index htt_tracks_i1 on htt_tracks(company_id, person_id, track_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run();
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_journal_timebook_adjustments');
exec fazo_z.run('hpd_page_adjustments');
exec fazo_z.run('hpd_lock_adjustments');
exec fazo_z.run('htt_locations');
