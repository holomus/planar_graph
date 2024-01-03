prompt adding hpd_agreements_cache
----------------------------------------------------------------------------------------------------
create table hpd_agreements_cache(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  begin_date                      date       not null,
  end_date                        date       not null,
  robot_id                        number(20) not null,
  schedule_id                     number(20),
  constraint hpd_agreements_cache_pk primary key (company_id, filial_id, staff_id, begin_date) using index tablespace GWS_INDEX,
  constraint hpd_agreements_cache_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_agreements_cache_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_agreements_cache_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpd_agreements_cache_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_agreements_cache_c2 check (trunc(end_date) = end_date),
  constraint hpd_agreements_cache_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_agreements_cache_i1 on hpd_agreements_cache(company_id, filial_id, robot_id, begin_date) tablespace GWS_INDEX;
create index hpd_agreements_cache_i2 on hpd_agreements_cache(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
alter table hln_trainings modify address null;

exec fazo_z.run('hpd_agreements_cache');
exec fazo_z.run('hln_trainings');
