prompt migr from 14.11.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt drop table htt_robot_schedule_day_marks, htt_staff_schedule_day_marks
----------------------------------------------------------------------------------------------------
drop table htt_robot_schedule_day_marks;
drop table htt_staff_schedule_day_marks;
----------------------------------------------------------------------------------------------------
prompt adding individual schedule tables
----------------------------------------------------------------------------------------------------
create table htt_schedule_registries(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  registry_id                     number(20)        not null,
  registry_date                   date              not null,
  registry_number                 varchar2(50 char) not null,
  registry_kind                   varchar2(1)       not null,
  month                           date              not null,
  division_id                     number(20),
  note                            varchar2(300 char),
  posted                          varchar2(1)       not null,
  shift                           number(4)         not null,
  input_acceptance                number(4)         not null,
  output_acceptance               number(4)         not null,
  track_duration                  number(4)         not null,
  count_late                      varchar2(1)       not null,
  count_lack                      varchar2(1)       not null,
  count_early                     varchar2(1)       not null,
  calendar_id                     number(20),
  take_holidays                   varchar2(1)       not null,
  take_nonworking                 varchar2(1)       not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_schedule_registries_pk primary key (company_id, filial_id, registry_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_registries_u1 unique (registry_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_registries_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint htt_schedule_registries_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint htt_schedule_registries_f3 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id),  
  constraint htt_schedule_registries_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_schedule_registries_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_schedule_registries_c1 check (trunc(registry_date) = registry_date),
  constraint htt_schedule_registries_c2 check (decode(trim(registry_number), registry_number, 1, 0) = 1),
  constraint htt_schedule_registries_c3 check (registry_kind in ('S', 'R')),
  constraint htt_schedule_registries_c4 check (trunc(month, 'mon') = month),
  constraint htt_schedule_registries_c5 check (posted in ('Y', 'N')), 
  constraint htt_schedule_registries_c6 check (shift between 0 and 1439),
  constraint htt_schedule_registries_c7 check (input_acceptance between 0 and 2160),
  constraint htt_schedule_registries_c8 check (output_acceptance between 0 and 2160),
  constraint htt_schedule_registries_c9 check (track_duration between 0 and 4320),
  constraint htt_schedule_registries_c10 check (count_late in ('Y', 'N')),
  constraint htt_schedule_registries_c11 check (count_early in ('Y', 'N')),
  constraint htt_schedule_registries_c12 check (count_lack in ('Y', 'N')),
  constraint htt_schedule_registries_c13 check (take_holidays in ('Y', 'N')),
  constraint htt_schedule_registries_c14 check (take_nonworking in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_schedule_registries is 'Individual schedule registries';

comment on column htt_schedule_registries.registry_kind     is '(S)taff, (R)obot';
comment on column htt_schedule_registries.posted            is '(Y)es, (N)o';
comment on column htt_schedule_registries.shift             is 'Shifts schedule from default 00:00. Measured in minutes';
comment on column htt_schedule_registries.input_acceptance  is 'Controls input acceptance border. Measured in minutes';
comment on column htt_schedule_registries.output_acceptance is 'Controls output acceptance border. Measured in minutes';          
comment on column htt_schedule_registries.track_duration    is 'Limits the duration of input-output time parts. Measured in minutes';
comment on column htt_schedule_registries.count_late        is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedule_registries.count_early       is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedule_registries.count_lack        is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';
comment on column htt_schedule_registries.take_holidays     is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedule_registries.take_nonworking   is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';

create index htt_schedule_registries_i1 on htt_schedule_registries(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index htt_schedule_registries_i2 on htt_schedule_registries(company_id, filial_id, calendar_id) tablespace GWS_INDEX;
create index htt_schedule_registries_i3 on htt_schedule_registries(company_id, created_by) tablespace GWS_INDEX;
create index htt_schedule_registries_i4 on htt_schedule_registries(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_registry_units(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  registry_id                     number(20) not null,
  staff_id                        number(20),
  robot_id                        number(20),
  monthly_minutes                 number(20) not null,
  monthly_days                    number(20) not null,
  constraint htt_registry_units_pk primary key (company_id, filial_id, unit_id) using index tablespace GWS_INDEX,
  constraint htt_registry_units_u1 unique (unit_id) using index tablespace GWS_INDEX,
  constraint htt_registry_units_f1 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id) on delete cascade,
  constraint htt_registry_units_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_registry_units_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htt_registry_units_c1 check (nvl2(staff_id, 1, 0) + nvl2(robot_id, 1, 0) = 1),
  constraint htt_registry_units_c2 check (monthly_minutes >= 0 and monthly_days >= 0)
) tablespace GWS_DATA;

comment on table htt_registry_units is 'Individual schedule registry entries (staffs/robots)';

create unique index htt_registry_units_u2 on htt_registry_units(nvl2(staff_id,company_id, null), nvl2(staff_id, filial_id, null), nvl2(staff_id, registry_id, null), staff_id) tablespace GWS_INDEX;
create unique index htt_registry_units_u3 on htt_registry_units(nvl2(robot_id,company_id, null), nvl2(robot_id, filial_id, null), nvl2(robot_id, registry_id, null), robot_id) tablespace GWS_INDEX;

create index htt_registry_units_i1 on htt_registry_units(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_registry_units_i2 on htt_registry_units(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index htt_registry_units_i3 on htt_registry_units(company_id, filial_id, registry_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_unit_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  unit_id                         number(20)  not null,
  schedule_date                   date        not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date        not null,
  shift_end_time                  date        not null,
  input_border                    date        not null,
  output_border                   date        not null,
  constraint htt_unit_schedule_days_pk primary key (company_id, filial_id, unit_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_days_f1 foreign key (company_id, filial_id, unit_id) references htt_registry_units(company_id, filial_id, unit_id) on delete cascade,
  constraint htt_unit_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_unit_schedule_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_unit_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_unit_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)),
  constraint htt_unit_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_unit_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_unit_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_unit_schedule_days_c8 check (begin_time < end_time),
  constraint htt_unit_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_unit_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_unit_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_unit_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_unit_schedule_days_c13 check (input_border < output_border),
  constraint htt_unit_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_days is 'Individual schedule entries daily info';

comment on column htt_unit_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_unit_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_unit_schedule_days.full_time     is 'measured in minutes';
comment on column htt_unit_schedule_days.plan_time     is 'measured in minutes';

---------------------------------------------------------------------------------------------------- 
create table htt_unit_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_unit_schedule_day_marks_pk primary key (company_id, filial_id, unit_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_day_marks_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date) on delete cascade,
  constraint htt_unit_schedule_day_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
create table htt_staff_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  schedule_date                   date        not null,
  registry_id                     number(20)  not null,
  unit_id                         number(20)  not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date        not null,
  shift_end_time                  date        not null,
  input_border                    date        not null,
  output_border                   date        not null,
  constraint htt_staff_schedule_days_pk primary key (company_id, filial_id, staff_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_days_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date),
  constraint htt_staff_schedule_days_f2 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id),
  constraint htt_staff_schedule_days_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint htt_staff_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_staff_schedule_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_staff_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_staff_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)),
  constraint htt_staff_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_staff_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_staff_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_staff_schedule_days_c8 check (begin_time < end_time),
  constraint htt_staff_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_staff_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_staff_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_staff_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_staff_schedule_days_c13 check (input_border < output_border),
  constraint htt_staff_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_days is 'Individual schedule entries daily info';

comment on column htt_staff_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_staff_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_staff_schedule_days.full_time     is 'measured in minutes';
comment on column htt_staff_schedule_days.plan_time     is 'measured in minutes';

create index htt_staff_schedule_days_i1 on htt_staff_schedule_days(company_id, filial_id, registry_id) tablespace GWS_INDEX;
create index htt_staff_schedule_days_i2 on htt_staff_schedule_days(company_id, filial_id, staff_id, trunc(schedule_date, 'mon')) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_staff_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_staff_schedule_day_marks_pk primary key (company_id, filial_id, staff_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_day_marks_f1 foreign key (company_id, filial_id, staff_id, schedule_date) references htt_staff_schedule_days(company_id, filial_id, staff_id, schedule_date) on delete cascade,
  constraint htt_staff_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
create table htt_robot_schedule_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  schedule_date                   date        not null,
  registry_id                     number(20)  not null,
  unit_id                         number(20)  not null,
  day_kind                        varchar2(1) not null,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  full_time                       number(4)   not null,
  plan_time                       number(4)   not null,
  shift_begin_time                date        not null,
  shift_end_time                  date        not null,
  input_border                    date        not null,
  output_border                   date        not null,
  constraint htt_robot_schedule_days_pk primary key (company_id, filial_id, robot_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_days_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date),
  constraint htt_robot_schedule_days_f2 foreign key (company_id, filial_id, registry_id) references htt_schedule_registries(company_id, filial_id, registry_id),
  constraint htt_robot_schedule_days_f3 foreign key (company_id, filial_id, robot_id) references mrf_robots(company_id, filial_id, robot_id),
  constraint htt_robot_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_robot_schedule_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_robot_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_robot_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0)),
  constraint htt_robot_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_robot_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_robot_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_robot_schedule_days_c8 check (begin_time < end_time),
  constraint htt_robot_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_robot_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time),
  constraint htt_robot_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_robot_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time),
  constraint htt_robot_schedule_days_c13 check (input_border < output_border),
  constraint htt_robot_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_days is 'Individual schedule entries daily info';

comment on column htt_robot_schedule_days.day_kind      is '(W)orking day, (R)est day';
comment on column htt_robot_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_robot_schedule_days.full_time     is 'measured in minutes';
comment on column htt_robot_schedule_days.plan_time     is 'measured in minutes';

create index htt_robot_schedule_days_i1 on htt_robot_schedule_days(company_id, filial_id, registry_id) tablespace GWS_INDEX;
create index htt_robot_schedule_days_i2 on htt_robot_schedule_days(company_id, filial_id, robot_id, trunc(schedule_date, 'mon')) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_robot_schedule_day_marks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  constraint htt_robot_schedule_day_marks_pk primary key (company_id, filial_id, robot_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_day_marks_f1 foreign key (company_id, filial_id, robot_id, schedule_date) references htt_robot_schedule_days(company_id, filial_id, robot_id, schedule_date) on delete cascade,
  constraint htt_robot_schedule_day_marks_c1 check (begin_time < end_time)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_day_marks is 'Individual schedule entries daily marks';

----------------------------------------------------------------------------------------------------
prompt migr for Badge templates
----------------------------------------------------------------------------------------------------
create table href_badge_templates (
  badge_template_id               number(20)          not null,
  name                            varchar2(100 char)  not null,
  html_value                      varchar2(4000 char) not null,
  state                           varchar2(1)         not null,
  constraint href_badge_templates_pk primary key (badge_template_id) using index tablespace GWS_INDEX,
  constraint href_badge_templates_u1 unique (name) using index tablespace GWS_INDEX,
  constraint href_badge_templates_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_badge_templates_c2 check (decode(trim(html_value), html_value, 1, 0) = 1),
  constraint href_badge_templates_c3 check (state in ('A', 'P'))  
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt htt_time_kinds added timesheet_coef
----------------------------------------------------------------------------------------------------
alter table htt_time_kinds drop constraint htt_time_kinds_c7;

alter table htt_time_kinds add timesheet_coef number(3,2);
alter table htt_time_kinds add constraint htt_time_kinds_c7 check (timesheet_coef between 0 and 1);
alter table htt_time_kinds add constraint htt_time_kinds_c8 check (state in ('A', 'P'));

comment on column htt_time_kinds.timesheet_coef is 'The ratio of counting attendance';
----------------------------------------------------------------------------------------------------
prompt add pcode for schedule 
alter table htt_schedules add pcode varchar2(10);
alter table htt_schedules add constraint htt_schedules_c12 check (decode(trim(pcode), pcode, 1, 0) = 1);
create unique index htt_schedules_u5 on htt_schedules(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt Workplace added to Family member infos
alter table href_person_family_members add workplace varchar2(200 char);

----------------------------------------------------------------------------------------------------      
prompt add order no for book types
alter table hpr_book_types add order_no number(6);

----------------------------------------------------------------------------------------------------
prompt cretae sequences
----------------------------------------------------------------------------------------------------
create sequence href_badge_templates_sq;
create sequence htt_schedule_registries_sq;
create sequence htt_registry_units_sq;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_badge_templates');
exec fazo_z.run('hpr_book_types');
exec fazo_z.run('href_person_family_members');
exec fazo_z.run('htt_schedules');
exec fazo_z.run('htt_time_kinds');
exec fazo_z.run('htt_schedule_registries');
exec fazo_z.run('htt_registry_units');
exec fazo_z.run('htt_unit_schedule_days');
exec fazo_z.run('htt_unit_schedule_day_marks');
exec fazo_z.run('htt_staff_schedule_days');
exec fazo_z.run('htt_staff_schedule_day_marks');
exec fazo_z.run('htt_robot_schedule_days');
exec fazo_z.run('htt_robot_schedule_day_marks');
