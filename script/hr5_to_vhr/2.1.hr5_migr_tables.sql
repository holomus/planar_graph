prompt hr5 migr tables
---------------------------------------------------------------------------------------------------- 
create table hr5_migr_used_keys (
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  constraint hr5_migr_used_keys_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on column hr5_migr_used_keys.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table hr5_migr_keys_store_one(
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  new_id     number        not null,
  constraint hr5_migr_keys_store_one_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX,
  constraint hr5_migr_keys_store_one_f1 foreign key(company_id, key_name, old_id) references hr5_migr_used_keys(company_id, key_name, old_id) on delete cascade
) tablespace GWS_DATA;

comment on column hr5_migr_keys_store_one.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table hr5_migr_keys_store_two(
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  filial_id  number        not null,
  new_id     number        not null,
  constraint hr5_migr_keys_store_two_pk primary key(company_id, key_name, old_id, filial_id) using index tablespace GWS_INDEX,
  constraint hr5_migr_keys_store_two_f1 foreign key(company_id, key_name, old_id) references hr5_migr_used_keys(company_id, key_name, old_id) on delete cascade
) tablespace GWS_DATA;

comment on column hr5_migr_keys_store_two.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table hr5_migr_errors(
  company_id    number(20)     not null,
  table_name    varchar2(100)  not null,
  key_id        number         not null,
  error_message varchar2(4000) not null,
  error_date    date
) tablespace GWS_DATA;

comment on column hr5_migr_errors.company_id is 'New company id';

----------------------------------------------------------------------------------------------------
-- schedule registry tables
----------------------------------------------------------------------------------------------------
create table hr5_migr_hr_timesheets_src(
  timesheet_id                    number(20) not null,
  robot_id                        number(20),
  timesheet_date                  date,
  plan_hours                      number,
  constraint hr5_migr_hr_timesheets_src_pk primary key(timesheet_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hr5_migr_hr_timesheets_src2(
  robot_id                        number(20) not null,
  timesheet_date                  date       not null,
  input_time                      number,
  output_time                     number,
  lunch_begin                     number,
  lunch_end                       number,
  plan_time                       number,
  day_kind                        varchar2(1),
  constraint hr5_migr_hr_timesheets_src2_pk primary key(robot_id, timesheet_date) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

create index hr5_migr_hr_timesheets_src2_i1 on hr5_migr_hr_timesheets_src2(robot_id, trunc(timesheet_date, 'mon')) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hr5_migr_hr_timesheets(
  robot_id                        number(20) not null,
  timesheet_date                  date       not null,
  input_time                      number,
  output_time                     number,
  lunch_begin                     number,
  lunch_end                       number,
  plan_time                       number,
  day_kind                        varchar2(1),
  max_output_time                 number,
  max_lunch_end                   number,
  full_time                       number,
  constraint hr5_migr_hr_timesheets_pk primary key(robot_id, timesheet_date) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hr5_migr_schreg_robots_src(
  robot_id                        number(20) not null,
  month                           date       not null,
  new_robot_id                    number(20),
  department_id                   number,
  input_time                      number,
  output_time                     number,
  max_output_time                 number,
  constraint hr5_migr_schreg_robots_src_pk primary key(robot_id, month) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

create index hr5_migr_schreg_robots_src_i1 on hr5_migr_schreg_robots_src(department_id, month, max_output_time) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hr5_migr_schreg_departments_src(
  department_id                   number(20) not null,
  month                           date       not null,
  shift_one                       number,
  shift_two                       number,
  constraint hr5_migr_schreg_departments_src_pk primary key(department_id, month) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hr5_migr_schreg_departments(
  department_id                   number(20) not null,
  month                           date       not null,
  new_division_id                 number,
  shift_one                       number,
  shift_two                       number,
  shift_three                     number,
  constraint hr5_migr_schreg_departments_pk primary key(department_id, month) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hr5_migr_job_log(
  period                          date           not null,
  error_message                   varchar2(4000) not null
) tablespace GWS_DATA;
