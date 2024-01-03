prompt migr from 20.05.2023 v2.25.0 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt mark skip penalty_kind added to hpr_penalty_policies
----------------------------------------------------------------------------------------------------
alter table hpr_penalty_policies drop constraint hpr_penalty_policies_c1;
alter table hpr_penalty_policies drop constraint hpr_penalty_policies_c5;

alter table hpr_penalty_policies add constraint hpr_penalty_policies_c1 check (penalty_kind in ('L', 'E', 'C', 'S', 'M'));
alter table hpr_penalty_policies add constraint hpr_penalty_policies_c5 check (from_time >= 0 and (from_time <= 1440 or penalty_kind = 'M'));

comment on column hpr_penalty_policies.penalty_kind is '(L)ate time, (E)arly time, La(C)k time, Day (S)kip, (M)ark skip';
comment on column hpr_penalty_policies.from_time    is 'measured in minutes or when penalty_kind is mark skip then times';
comment on column hpr_penalty_policies.to_time      is 'measured in minutes or when penalty_kind is mark skip then times';

----------------------------------------------------------------------------------------------------
prompt mark_skip_amount added to hpr_sheet_parts
----------------------------------------------------------------------------------------------------
alter table hpr_sheet_parts add mark_skip_amount number(20,6);

update hpr_sheet_parts set mark_skip_amount = 0;
commit;

alter table hpr_sheet_parts modify mark_skip_amount not null;
alter table hpr_sheet_parts modify penalty_amount as (late_amount + early_amount + lack_amount + day_skip_amount + mark_skip_amount);
alter table hpr_sheet_parts modify amount as (wage_amount + overtime_amount - (late_amount + early_amount + lack_amount + day_skip_amount + mark_skip_amount));

alter table hpr_sheet_parts drop constraint hpr_sheet_parts_c2;
alter table hpr_sheet_parts add constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0
                                                                 and wage_amount >= 0 and overtime_amount >= 0
                                                                 and late_amount >= 0 and early_amount >= 0 and lack_amount >= 0 and day_skip_amount >= 0 and mark_skip_amount >= 0);
                                                                 
----------------------------------------------------------------------------------------------------   
prompt add new table person hidden salary job groups
----------------------------------------------------------------------------------------------------
create table href_person_hidden_salary_job_groups (
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  job_group_id                    number(20) not null,
  constraint href_person_hidden_salary_job_groups_pk primary key (company_id, person_id, job_group_id) using index tablespace GWS_INDEX,
  constraint href_person_hidden_salary_job_groups_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_hidden_salary_job_groups_f2 foreign key (company_id, job_group_id) references hrm_hidden_salary_job_groups(company_id, job_group_id) on delete cascade
) tablespace GWS_DATA;

create index href_person_hidden_salary_job_groups_i1 on href_person_hidden_salary_job_groups(company_id, job_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_journal_staffs
----------------------------------------------------------------------------------------------------
create table hpd_journal_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  staff_id                        number(20) not null,
  constraint hpd_journal_staffs_pk primary key (company_id, filial_id, journal_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_staffs_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade
) tablespace GWS_DATA;

comment on table hpd_journal_staffs is 'Keeps distinct staffs in journal';

create index hpd_journal_staffs_i1 on hpd_journal_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_robot_hidden_salary_job_groups(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  job_group_id                    number(20) not null,
  constraint hrm_robot_hidden_salary_job_groups_pk primary key (company_id, filial_id, robot_id, job_group_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_hidden_salary_job_groups_f1 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_hidden_salary_job_groups_f2 foreign key (company_id, job_group_id) references hrm_hidden_salary_job_groups(company_id, job_group_id) on delete cascade
) tablespace GWS_DATA;

create index hrm_robot_hidden_salary_job_groups_i1 on hrm_robot_hidden_salary_job_groups(company_id, job_group_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
alter table hrm_robots add access_hidden_salary varchar2(1);

update hrm_robots
 set access_hidden_salary = 'N';
commit;
 
alter table hrm_robots modify access_hidden_salary not null;
alter table hrm_robots add constraint hrm_robots_c6 check (access_hidden_salary in ('Y', 'N'));

comment on column hrm_robots.access_hidden_salary is '(Y)es, (N)o. Has access to view hidden salary';

----------------------------------------------------------------------------------------------------
alter table hpd_application_dismissals add dismissal_reason_id number(20);
alter table hpd_application_dismissals add constraint hpd_application_dismissals_f3 foreign key (company_id, dismissal_reason_id) references href_dismissal_reasons(company_id, dismissal_reason_id);

create index hpd_application_dismissals_i2 on hpd_application_dismissals(company_id, dismissal_reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Driver fact import infos
----------------------------------------------------------------------------------------------------
create table hsc_driver_fact_import_infos(
  company_id                     number(20)         not null,
  filial_id                      number(20)         not null,
  column_index                   number(20)         not null,
  title                          varchar2(200 char) not null,
  constraint hsc_driver_fact_import_infos_pk primary key (company_id, filial_id, column_index) using index tablespace GWS_INDEX,
  constraint hsc_driver_fact_import_infos_c1 check (column_index > 0),
  constraint hsc_driver_fact_import_infos_c2 check (decode(trim(title), title, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Driver fact import settings
----------------------------------------------------------------------------------------------------
create table hsc_driver_fact_import_settings(
  company_id                     number(20) not null,
  filial_id                      number(20) not null,
  object_id                      number(20) not null,
  area_id                        number(20) not null,
  driver_id                      number(20) not null,
  column_index                   number(20) not null,
  constraint hsc_driver_fact_import_settings_pk primary key (company_id, filial_id, object_id, area_id, driver_id, column_index) using index tablespace GWS_INDEX,
  constraint hsc_driver_fact_import_settings_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_f2 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_f3 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id) on delete cascade,
  constraint hsc_driver_fact_import_settings_c1 check (column_index > 0)
) tablespace GWS_DATA;

create index hsc_driver_fact_import_settings_i1 on hsc_driver_fact_import_settings(company_id, filial_id, area_id) tablespace GWS_INDEX;
create index hsc_driver_fact_import_settings_i2 on hsc_driver_fact_import_settings(company_id, filial_id, driver_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
exec fazo_z.run('hpr_penalty_policies');
exec fazo_z.run('href_person_hidden_salary_job_groups');
exec fazo_z.run('hpd_journal_staffs');
exec fazo_z.run('hpr_sheet_parts');
exec fazo_z.Run('hrm_robots'); 
exec fazo_z.Run('hrm_robot_hidden_salary_job_groups');
exec Fazo_z.Run('hpd_application_dismissals');
exec Fazo_z.Run('hsc_driver_fact_import_infos');
exec Fazo_z.Run('hsc_driver_fact_import_settings');
