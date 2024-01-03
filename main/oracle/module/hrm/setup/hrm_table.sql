prompt Resource management module
prompt (c) 2020 Verifix HR
----------------------------------------------------------------------------------------------------
-- Setting
----------------------------------------------------------------------------------------------------
create table hrm_settings(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  position_enable                 varchar2(1) not null,
  position_check                  varchar2(1) not null,
  keep_salary                     varchar2(1) not null,
  keep_vacation_limit             varchar2(1) not null,
  keep_schedule                   varchar2(1) not null,
  keep_rank                       varchar2(1) not null,
  position_booking                varchar2(1) not null,
  position_history                varchar2(1) not null,
  position_fixing                 varchar2(1) not null,
  parttime_enable                 varchar2(1) not null,
  rank_enable                     varchar2(1) not null,
  wage_scale_enable               varchar2(1) not null,
  notification_enable             varchar2(1) not null,
  autogen_staff_number            varchar2(1) not null,
  advanced_org_structure          varchar2(1) not null,
  constraint hrm_settings_pk  primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint hrm_settings_c1  check (position_enable in ('Y', 'N')),
  constraint hrm_settings_c2  check (position_check in ('Y', 'N')),
  constraint hrm_settings_c3  check (keep_salary in ('Y', 'N')),
  constraint hrm_settings_c4  check (keep_vacation_limit in ('Y', 'N')),
  constraint hrm_settings_c5  check (keep_schedule in ('Y', 'N')),
  constraint hrm_settings_c6  check (keep_rank in ('Y', 'N')),
  constraint hrm_settings_c7  check (position_booking in ('Y', 'N')), 
  constraint hrm_settings_c8  check (position_history in ('Y', 'N')),
  constraint hrm_settings_c9  check (parttime_enable in ('Y', 'N')),
  constraint hrm_settings_c10 check (rank_enable in ('Y', 'N')),
  constraint hrm_settings_c11 check (wage_scale_enable in ('Y', 'N')),
  constraint hrm_settings_c12 check (notification_enable in ('Y', 'N')),
  constraint hrm_settings_c13 check (autogen_staff_number in ('Y', 'N')),
  constraint hrm_settings_c14 check (position_fixing in ('Y', 'N')),
  constraint hrm_settings_c15 check (advanced_org_structure in ('Y', 'N')),
  constraint hrm_settings_c16 check (position_check = 'Y' or decode(position_check, 'N', 4, 0) = 
                                     decode(keep_rank, 'N', 1, 0) + decode(keep_salary, 'N', 1, 0) + --
                                     decode(keep_schedule, 'N', 1, 0) + decode(keep_vacation_limit, 'N', 1, 0))
) tablespace GWS_DATA;

comment on column hrm_settings.position_fixing     is 'Enabled means that division/job of position can change via special form';
comment on column hrm_settings.keep_salary         is 'If Yes, not access to change Salary when Hiring or Transfer Staff';
comment on column hrm_settings.keep_vacation_limit is 'If Yes, not access to change Vacation Limit when Hiring or Transfer Staff';
comment on column hrm_settings.keep_schedule       is 'If Yes, not access to change Schedule when Hiring or Transfer Staff';
comment on column hrm_settings.keep_rank           is 'If Yes, not access to change Rank when Hiring or Transfer Staff';

----------------------------------------------------------------------------------------------------
-- Divisions
----------------------------------------------------------------------------------------------------
create table hrm_divisions(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  division_id                     number(20)  not null,
  parent_department_id            number(20),
  is_department                   varchar2(1) not null,
  manager_status                  varchar2(1) not null,
  subfilial_id                    number(20),
  constraint hrm_divisions_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_divisions_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_divisions_f2 foreign key (company_id, filial_id, parent_department_id) references hrm_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_divisions_f3 foreign key (company_id, subfilial_id) references mrf_subfilials(company_id, subfilial_id) on delete set null,
  constraint hrm_divisions_c1 check (is_department in ('Y', 'N')),
  constraint hrm_divisions_c2 check (manager_status in ('M', 'A')),
  constraint hrm_divisions_c3 check (not (is_department = 'Y' and manager_status = 'A'))
) tablespace GWS_DATA;

comment on table hrm_divisions is 'Additional VERIFIX specific info about divisions';

comment on column hrm_divisions.is_department is '(Y)es, (N)o. Default value:(Y)es. When row in hrm_divisions does not exist, division is considered as department';
comment on column hrm_divisions.manager_status is '(A)uto, (M)anual';

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
-- division schedule 
----------------------------------------------------------------------------------------------------
create table hrm_division_schedules(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  division_id                     number(20) not null,
  schedule_id                     number(20) not null,
  constraint hrm_division_schedules_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_division_schedules_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_division_schedules_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade
) tablespace GWS_DATA;

comment on table hrm_division_schedules is 'Keeps division schedule info, for division schedule report';

create index hrm_division_schedules_i1 on hrm_division_schedules(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Wage Scales
----------------------------------------------------------------------------------------------------
create table hrm_wage_scales(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  wage_scale_id                   number(20)         not null,
  name                            varchar2(50 char)  not null,
  full_name                       varchar2(300 char) not null,
  state                           varchar2(1)        not null,
  last_changed_date               date,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrm_wage_scales_pk primary key (company_id, filial_id, wage_scale_id) using index tablespace GWS_INDEX,
  constraint hrm_wage_scales_u1 unique (wage_scale_id) using index tablespace GWS_INDEX,
  constraint hrm_wage_scales_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrm_wage_scales_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrm_wage_scales_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrm_wage_scales_c2 check (decode(trim(full_name), full_name, 1, 0) = 1),
  constraint hrm_wage_scales_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table hrm_wage_scales is 'Keeps wages scales. Wage scale values kept separately in scale registries';

create index hrm_wage_scales_i1 on hrm_wage_scales(company_id, created_by) tablespace GWS_INDEX;
create index hrm_wage_scales_i2 on hrm_wage_scales(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_wage_scale_registers(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  register_id                     number(20)   not null,
  register_date                   date         not null,
  register_number                 varchar2(50) not null,
  wage_scale_id                   number(20)   not null,
  round_model                     varchar2(5),
  base_wage                       number(20, 6),
  valid_from                      date         not null,
  posted                          varchar2(1)  not null,
  note                            varchar2(300 char),
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrm_wage_scale_registers_pk primary key (company_id, filial_id, register_id) using index tablespace GWS_INDEX,
  constraint hrm_wage_scale_registers_u1 unique (register_id) using index tablespace GWS_INDEX,
  constraint hrm_wage_scale_registers_f1 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hrm_wage_scale_registers_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrm_wage_scale_registers_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrm_wage_scale_registers_c1 check (decode(trim(register_number), register_number, 1, 0) = 1),
  constraint hrm_wage_scale_registers_c2 check (nvl2(round_model, 1, 0) = (nvl2(base_wage, 1, 0))),
  constraint hrm_wage_scale_registers_c3 check (base_wage >= 0), 
  constraint hrm_wage_scale_registers_c4 check (posted in ('Y', 'N'))
) tablespace GWS_DATA;

create unique index hrm_wage_scale_registers_u2 on hrm_wage_scale_registers(
  decode(posted, 'Y', company_id, null),
  decode(posted, 'Y', filial_id, null),
  decode(posted, 'Y', wage_scale_id, null),
  decode(posted, 'Y', valid_from, null)
) tablespace GWS_INDEX;

comment on table hrm_wage_scale_registers is 'Keeps wage scale changes and values';

create index hrm_wage_scale_registers_i1 on hrm_wage_scale_registers(company_id, filial_id, wage_scale_id, valid_from) tablespace GWS_INDEX;
create index hrm_wage_scale_registers_i2 on hrm_wage_scale_registers(company_id, created_by) tablespace GWS_INDEX;
create index hrm_wage_scale_registers_i3 on hrm_wage_scale_registers(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_register_ranks(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  register_id                     number(20)    not null,
  rank_id                         number(20)    not null,  
  order_no                        number(3)     not null,
  constraint hrm_register_ranks_pk primary key (company_id, filial_id, register_id, rank_id) using index tablespace GWS_INDEX,
  constraint hrm_register_ranks_f1 foreign key (company_id, filial_id, register_id) references hrm_wage_scale_registers(company_id, filial_id, register_id) on delete cascade,
  constraint hrm_register_ranks_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id)
) tablespace GWS_DATA;

create index hrm_register_ranks_i1 on hrm_register_ranks(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------             
create table hrm_register_rank_indicators(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  register_id                     number(20)    not null,
  rank_id                         number(20)    not null,
  indicator_id                    number(20)    not null,
  indicator_value                 number(20, 6) not null,
  coefficient                     number(20, 6),
  constraint hrm_register_rank_indicators_pk primary key (company_id, filial_id, register_id, rank_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_register_rank_indicators_f1 foreign key (company_id, filial_id, register_id, rank_id) references hrm_register_ranks(company_id, filial_id, register_id, rank_id) on delete cascade,
  constraint hrm_register_rank_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id),
  constraint hrm_register_rank_indicators_c1 check (indicator_value >= 0),
  constraint hrm_register_rank_indicators_c2 check (coefficient >= 0)
) tablespace GWS_DATA;

create index hrm_register_rank_indicators_i1 on hrm_register_rank_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_job_templates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  template_id                     number(20) not null,
  division_id                     number(20) not null,
  job_id                          number(20) not null,
  rank_id                         number(20),
  schedule_id                     number(20),
  vacation_days_limit             number(3),
  wage_scale_id                   number(20),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
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
create table hrm_job_roles(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  job_id                          number(20)   not null,
  role_id                         number(20)   not null,
  constraint hrm_job_roles_pk primary key (company_id, filial_id, job_id, role_id) using index tablespace GWS_INDEX,
  constraint hrm_job_roles_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade,
  constraint hrm_job_roles_f2 foreign key (company_id, role_id) references md_roles(company_id, role_id) on delete cascade
) tablespace GWS_DATA;

create index hrm_job_roles_i1 on hrm_job_roles(company_id, role_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Robots
----------------------------------------------------------------------------------------------------
create table hrm_robots(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  org_unit_id                     number(20)  not null,
  opened_date                     date        not null,
  closed_date                     date,
  schedule_id                     number(20),
  rank_id                         number(20),
  labor_function_id               number(20),
  description                     varchar2(300 char),
  hiring_condition                varchar2(300 char),
  contractual_wage                varchar2(1) not null,
  wage_scale_id                   number(20),
  access_hidden_salary            varchar2(1) not null,
  position_employment_kind        varchar2(1) not null,
  currency_id                     number(20),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrm_robots_pk primary key (company_id, filial_id, robot_id) using index tablespace GWS_INDEX,
  constraint hrm_robots_f1 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint hrm_robots_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hrm_robots_f3 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hrm_robots_f4 foreign key (company_id, labor_function_id) references href_labor_functions(company_id, labor_function_id),
  constraint hrm_robots_f5 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hrm_robots_f6 foreign key (company_id, filial_id, org_unit_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hrm_robots_f7 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id),
  constraint hrm_robots_f8 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrm_robots_f9 foreign key (company_id, modified_by) references md_users(company_id, user_id),  
  constraint hrm_robots_c1 check (trunc(opened_date) = opened_date),
  constraint hrm_robots_c2 check (trunc(closed_date) = closed_date),
  constraint hrm_robots_c3 check (opened_date <= closed_date),
  constraint hrm_robots_c4 check (contractual_wage in ('Y', 'N')),
  constraint hrm_robots_c5 check (decode(contractual_wage, 'N', 1, 'Y', 0) = nvl2(wage_scale_id, 1, 0)),
  constraint hrm_robots_c6 check (access_hidden_salary in ('Y', 'N')),
  constraint hrm_robots_c7 check (position_employment_kind in ('C', 'S'))
) tablespace GWS_DATA;

comment on column hrm_robots.description              is 'short description about robots';
comment on column hrm_robots.access_hidden_salary     is '(Y)es, (N)o. Has access to view hidden salary';
comment on column hrm_robots.position_employment_kind is '(C)ontractor, (S)taff. Contractor position can only house Contractor employment kind';

create index hrm_robots_i1 on hrm_robots(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hrm_robots_i2 on hrm_robots(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hrm_robots_i3 on hrm_robots(company_id, labor_function_id) tablespace GWS_INDEX;
create index hrm_robots_i4 on hrm_robots(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;
create index hrm_robots_i5 on hrm_robots(company_id, filial_id, org_unit_id) tablespace GWS_INDEX;
create index hrm_robots_i6 on hrm_robots(company_id, currency_id) tablespace GWS_INDEX;
create index hrm_robots_i7 on hrm_robots(company_id, created_by) tablespace GWS_INDEX;
create index hrm_robots_i8 on hrm_robots(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                       
create table hrm_robot_divisions(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  division_id                     number(20)  not null,
  access_type                     varchar2(1) not null,
  constraint hrm_robot_divisions_pk primary key(company_id, filial_id, robot_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_divisions_f1 foreign key(company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_divisions_f2 foreign key(company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_robot_divisions_c1 check (access_type in ('S', 'M'))
) tablespace GWS_DATA;

comment on table  hrm_robot_divisions             is 'Keeps robot accesses for divisions';
comment on column hrm_robot_divisions.access_type is '(S)tructural, (M)anual';

create index hrm_robot_divisions_i1 on hrm_robot_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------               
create table hrm_robot_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hrm_robot_oper_types_pk primary key (company_id, filial_id, robot_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_oper_types_f1 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hrm_robot_oper_types_i1 on hrm_robot_oper_types(company_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_robot_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  robot_id                        number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hrm_robot_indicators_pk primary key (company_id, filial_id, robot_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_indicators_f1 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hrm_robot_indicators_i1 on hrm_robot_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------               
create table hrm_oper_type_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  oper_type_id                    number(20) not null,
  indicator_id                    number(20) not null,
  constraint hrm_oper_type_indicators_pk primary key (company_id, filial_id, robot_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_oper_type_indicators_f1 foreign key (company_id, filial_id, robot_id, oper_type_id) references hrm_robot_oper_types(company_id, filial_id, robot_id, oper_type_id) on delete cascade,
  constraint hrm_oper_type_indicators_f2 foreign key (company_id, filial_id, robot_id, indicator_id) references hrm_robot_indicators(company_id, filial_id, robot_id, indicator_id)
) tablespace GWS_DATA;

create index hrm_oper_type_indicators_i1 on hrm_oper_type_indicators(company_id, filial_id, robot_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_robot_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  days_limit                      number(20) not null,
  constraint hrm_robot_vacation_limits_pk primary key (company_id, filial_id, robot_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_vacation_limits_f1 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hrm_robot_vacation_limits is 'Keeps days limit for robots';

----------------------------------------------------------------------------------------------------
-- robot transactions
----------------------------------------------------------------------------------------------------
create table hrm_robot_transactions(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  trans_id                        number(20)   not null,
  robot_id                        number(20)   not null,
  trans_date                      date         not null,
  fte_kind                        varchar2(1)  not null,  
  fte                             number(20,6) not null,  
  tag                             varchar2(150 char),
  constraint hrm_robot_transactions_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_transactions_u1 unique (trans_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_transactions_f1 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint hrm_robot_transactions_c1 check (trunc(trans_date) = trans_date),
  constraint hrm_robot_transactions_c2 check (fte_kind in ('P', 'B', 'O')),
  constraint hrm_robot_transactions_c3 check (fte between -1 and 1)
) tablespace GWS_DATA;

comment on column hrm_robot_transactions.fte_kind is '(P)laned, (B)ooked, (O)ccupied';

create index hrm_robot_transactions_i1 on hrm_robot_transactions(company_id, filial_id, robot_id, trans_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_robot_turnover(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  robot_id                        number(20)   not null,
  period                          date         not null,
  planed_fte                      number(20,6) not null,
  booked_fte                      number(20,6) not null,
  occupied_fte                    number(20,6) not null,
  fte                             as (planed_fte - booked_fte - occupied_fte),
  constraint hrm_robot_turnover_pk primary key (company_id, filial_id, robot_id, period) using index tablespace GWS_INDEX,
  constraint hrm_robot_turnover_c1 check (planed_fte between 0 and 1 and booked_fte between 0 and 1 and
                                          occupied_fte between 0 and 1 and fte between 0 and 1) deferrable initially deferred
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------    
create global temporary table hrm_dirty_robots(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  constraint hrm_dirty_robots_pk primary key (company_id, filial_id, robot_id),
  constraint hrm_dirty_robots_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
-- job bonus types
----------------------------------------------------------------------------------------------------
create table hrm_job_bonus_types(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  job_id                          number(20)   not null,
  bonus_type                      varchar2(1)  not null,
  percentage                      number(20,6) not null,
  constraint hrm_job_bonus_types_pk primary key (company_id, filial_id, job_id, bonus_type) using index tablespace GWS_INDEX,
  constraint hrm_job_bonus_types_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade,
  constraint hrm_job_bonus_types_c1 check (bonus_type in ('P', 'D', 'S')),
  constraint hrm_job_bonus_types_c2 check (percentage >= 0)
) tablespace GWS_DATA;

comment on column hrm_job_bonus_types.bonus_type is '(P)ersonal sales, (D)epartment sales, (S)uccessful delivery';

----------------------------------------------------------------------------------------------------
create table hrm_hidden_salary_job_groups(
  company_id                      number(20) not null,
  job_group_id                    number(20) not null,
  constraint hrm_hidden_salary_job_groups_pk primary key (company_id, job_group_id) using index tablespace GWS_INDEX,
  constraint hrm_hidden_salary_job_groups_f1 foreign key (company_id, job_group_id) references mhr_job_groups(company_id, job_group_id) on delete cascade
) tablespace GWS_DATA;

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
-- NEXT contraint is added to table from href module
-- it is added in hrm module because it references table from hrm module
---------------------------------------------------------------------------------------------------- 
alter table href_person_hidden_salary_job_groups add constraint href_person_hidden_salary_job_groups_f2 foreign key (company_id, job_group_id) references hrm_hidden_salary_job_groups(company_id, job_group_id) on delete cascade;
