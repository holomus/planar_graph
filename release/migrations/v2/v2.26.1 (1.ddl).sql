prompt change timebook adjustments
----------------------------------------------------------------------------------------------------
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_pk;
alter table hpd_page_adjustments add constraint hpd_page_adjustments_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX;

alter table hpd_lock_adjustments drop constraint hpd_lock_adjustments_pk;
alter table hpd_lock_adjustments add constraint hpd_lock_adjustments_pk primary key (company_id, filial_id, staff_id, adjustment_date) using index tablespace GWS_INDEX;

comment on column hpd_page_adjustments.kind is '(F)ull, (I)ncomplete. (I)ncomplete works when employee has no attendance';
comment on column hpd_lock_adjustments.kind is '(F)ull, (I)ncomplete. (I)ncomplete works when employee has no attendance';

----------------------------------------------------------------------------------------------------
create table hpd_adjustment_deleted_facts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  adjustment_date                 date       not null,
  time_kind_id                    number(20) not null,
  fact_value                      number(6) not null,
  constraint hpd_adjustment_deleted_facts_pk primary key (company_id, filial_id, staff_id, adjustment_date, time_kind_id) using index tablespace GWS_INDEX,
  constraint hpd_adjustment_deleted_facts_f1 foreign key (company_id, filial_id, staff_id, adjustment_date) references hpd_lock_adjustments(company_id, filial_id, staff_id, adjustment_date) on delete cascade,
  constraint hpd_adjustment_deleted_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpd_adjustment_deleted_facts_c1 check (fact_value >= 0)
) tablespace GWS_DATA;

comment on table hpd_adjustment_deleted_facts is 'Backup copies from htt_timesheet_facts in case adjustment will be unposted';

comment on column hpd_adjustment_deleted_facts.fact_value is 'Exact same value of htt_timesheet_facts and the time when adjustment added its facts';

exec fazo_z.run('hpd_adjustment_deleted_facts');
exec fazo_z.run('hpd_page_adjustments');
exec fazo_z.run('hpd_lock_adjustments');
