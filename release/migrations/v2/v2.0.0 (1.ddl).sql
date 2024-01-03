prompt migr from 04.07.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt added new tables for division manager
----------------------------------------------------------------------------------------------------
-- Division Manager
----------------------------------------------------------------------------------------------------
create table hrm_division_managers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  division_id                     number(20) not null,
  employee_id                     number(20) not null,
  constraint hrm_division_managers_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_division_managers_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_division_managers_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade
) tablespace GWS_DATA;

comment on table hrm_division_managers is 'Keeps division managers when job index (positions) is disabled';

create index hrm_division_managers_i1 on hrm_division_managers(company_id, filial_id, employee_id);

----------------------------------------------------------------------------------------------------      
create table href_employee_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  employee_id                     number(20) not null,
  division_id                     number(20) not null,
  constraint href_employee_divisions_pk primary key (company_id, filial_id, employee_id, division_id) using index tablespace GWS_INDEX,
  constraint href_employee_divisions_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade,
  constraint href_employee_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade
) tablespace GWS_DATA;

comment on table href_employee_divisions is 'Keeps manual access of employee for divisions, when position is not enabled';

create index href_employee_divisions_i1 on href_employee_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add new constraint in hln_testings
----------------------------------------------------------------------------------------------------
alter table hln_testings drop constraint hln_testings_c2;
alter table hln_testings drop constraint hln_testings_c3;
alter table hln_testings drop constraint hln_testings_c4;
alter table hln_testings drop constraint hln_testings_c5;
alter table hln_testings drop constraint hln_testings_c6;
alter table hln_testings drop constraint hln_testings_c7;
alter table hln_testings drop constraint hln_testings_c8;

alter table hln_testings add constraint hln_testings_c2 check (decode(trim(testing_number), testing_number, 1, 0) = 1);
alter table hln_testings add constraint hln_testings_c3 check (trunc(begin_time) = trunc(testing_date));
alter table hln_testings add constraint hln_testings_c4 check (end_time > begin_time);
alter table hln_testings add constraint hln_testings_c5 check (fact_end_time > fact_begin_time);
alter table hln_testings add constraint hln_testings_c6 check (pause_time between begin_time and end_time);
alter table hln_testings add constraint hln_testings_c7 check (passed in ('Y', 'N', 'I'));
alter table hln_testings add constraint hln_testings_c8 check (status in ('N', 'E', 'P', 'C', 'F'));
alter table hln_testings add constraint hln_testings_c9 check (decode(status, 'F', 1, 0) = decode(passed, 'I', 0, 1));

----------------------------------------------------------------------------------------------------
prompt added new job templates sequence
----------------------------------------------------------------------------------------------------
create sequence hrm_job_templates_sq;

----------------------------------------------------------------------------------------------------
prompt added new job templates tables
----------------------------------------------------------------------------------------------------
create table hrm_job_templates(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  template_id                     number(20)    not null,
  division_id                     number(20)    not null,
  job_id                          number(20)    not null,
  rank_id                         number(20),
  schedule_id                     number(20),
  vacation_days_limit             number(3),
  wage_scale_id                   number(20),
  created_by                      number(20)    not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)    not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrm_job_templates_pk primary key (company_id, filial_id, template_id) using index tablespace GWS_INDEX,
  constraint hrm_job_templates_u1 unique(template_id) using index tablespace GWS_INDEX,
  constraint hrm_job_templates_u2 unique(company_id, filial_id, division_id, job_id, rank_id) using index tablespace GWS_INDEX,
  constraint hrm_job_templates_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hrm_job_templates_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hrm_job_tempaltes_f3 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hrm_job_templates_f4 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hrm_job_templates_f5 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hrm_job_templates_f6 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrm_job_templates_f7 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrm_job_tempaltes_c1 check (vacation_days_limit between 0 and 366)
) tablespace GWS_DATA;

create index hrm_job_templates_i1 on hrm_job_templates(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrm_job_templates_i2 on hrm_job_templates(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hrm_job_templates_i3 on hrm_job_templates(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hrm_job_templates_i4 on hrm_job_templates(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;
create index hrm_job_templates_i5 on hrm_job_templates(company_id, created_by) tablespace GWS_INDEX;
create index hrm_job_templates_i6 on hrm_job_templates(company_id, modified_by) tablespace GWS_INDEX;
  
----------------------------------------------------------------------------------------------------               
create table hrm_template_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  template_id                     number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hrm_template_oper_types_pk primary key (company_id, filial_id, template_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hrm_template_oper_types_f1 foreign key (company_id, filial_id, template_id) references hrm_job_templates(company_id, filial_id, template_id) on delete cascade,
  constraint hrm_template_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hrm_template_oper_types_i1 on hrm_template_oper_types(company_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_template_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  template_id                     number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hrm_template_indicators_pk primary key (company_id, filial_id, template_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_template_indicators_f1 foreign key (company_id, filial_id, template_id) references hrm_job_templates(company_id, filial_id, template_id) on delete cascade,
  constraint hrm_template_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hrm_template_indicators_i1 on hrm_template_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------               
create table hrm_temp_oper_type_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  template_id                     number(20) not null,
  oper_type_id                    number(20) not null,
  indicator_id                    number(20) not null,
  constraint hrm_temp_oper_type_indicators_pk primary key (company_id, filial_id, template_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_temp_oper_type_indicators_f1 foreign key (company_id, filial_id, template_id, oper_type_id) references hrm_template_oper_types(company_id, filial_id, template_id, oper_type_id) on delete cascade,
  constraint hrm_temp_oper_type_indicators_f2 foreign key (company_id, filial_id, template_id, indicator_id) references hrm_template_indicators(company_id, filial_id, template_id, indicator_id)
) tablespace GWS_DATA;

create index hrm_temp_oper_type_indicators_i1 on hrm_temp_oper_type_indicators(company_id, filial_id, template_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt hrm_settings added autogen_staff_number (Y, N)
----------------------------------------------------------------------------------------------------
alter table hrm_settings add autogen_staff_number varchar2(1);
alter table hrm_settings add constraint hrm_settings_c8 check (autogen_staff_number in ('Y', 'N'));

