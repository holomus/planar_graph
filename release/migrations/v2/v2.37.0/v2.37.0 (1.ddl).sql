prompt adding timesheet intervals
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create sequence htt_timesheet_intervals_sq;
----------------------------------------------------------------------------------------------------
create table htt_timesheet_intervals (
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  interval_id                     number(20) not null,
  timesheet_id                    number(20) not null,
  interval_begin                  date       not null,
  interval_end                    date       not null,
  constraint htt_timesheet_intervals_pk primary key (company_id, filial_id, interval_Id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_intervals_u1 unique (interval_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_intervals_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_intervals_c1 check (interval_begin < interval_end)
) tablespace GWS_DATA;

comment on table htt_timesheet_intervals is 'Exact intervals used to calculate turnout timekind facts. (Includes tracks and requests)';

----------------------------------------------------------------------------------------------------
prompt adding time weights
----------------------------------------------------------------------------------------------------
alter table htt_schedules add use_weights varchar2(1);

---------------------------------------------------------------------------------------------------- 
create table htt_schedule_origin_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  constraint htt_schedule_origin_day_weights_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_origin_day_weights_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_origin_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_origin_day_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_schedule_origin_day_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_origin_day_weights is 'Weights to calculate weighted turnout';

----------------------------------------------------------------------------------------------------
create table htt_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_schedule_day_weights_pk primary key (company_id, filial_id, schedule_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_day_weights_f1 foreign key (company_id, filial_id, schedule_id, schedule_date) references htt_schedule_days(company_id, filial_id, schedule_id, schedule_date) on delete cascade,
  constraint htt_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_schedule_day_weights_c2 check (weight > 0),
  constraint htt_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_schedule_pattern_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  schedule_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  constraint htt_schedule_pattern_weights_pk primary key (company_id, filial_id, schedule_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_pattern_weights_f1 foreign key (company_id, filial_id, schedule_id, day_no) references htt_schedule_pattern_days(company_id, filial_id, schedule_id, day_no) on delete cascade,
  constraint htt_schedule_pattern_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_schedule_pattern_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

comment on table htt_schedule_pattern_weights is 'Weights to calculate weighted turnout';

----------------------------------------------------------------------------------------------------
create table htt_unit_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  unit_id                         number(20) not null,
  schedule_date                   date       not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_unit_schedule_day_weights_pk primary key (company_id, filial_id, unit_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_unit_schedule_day_weights_f1 foreign key (company_id, filial_id, unit_id, schedule_date) references htt_unit_schedule_days(company_id, filial_id, unit_id, schedule_date) on delete cascade,
  constraint htt_unit_schedule_day_weights_c1 check (begin_time < end_time and begin_time >= 0),
  constraint htt_unit_schedule_day_weights_c2 check (weight > 0),
  constraint htt_unit_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_unit_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_unit_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_staff_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_staff_schedule_day_weights_pk primary key (company_id, filial_id, staff_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_staff_schedule_day_weights_f1 foreign key (company_id, filial_id, staff_id, schedule_date) references htt_staff_schedule_days(company_id, filial_id, staff_id, schedule_date) on delete cascade,
  constraint htt_staff_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_staff_schedule_day_weights_c2 check (weight > 0),
  constraint htt_staff_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_staff_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_staff_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_robot_schedule_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  schedule_date                   date       not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_robot_schedule_day_weights_pk primary key (company_id, filial_id, robot_id, schedule_date, begin_time) using index tablespace GWS_INDEX,
  constraint htt_robot_schedule_day_weights_f1 foreign key (company_id, filial_id, robot_id, schedule_date) references htt_robot_schedule_days(company_id, filial_id, robot_id, schedule_date) on delete cascade,
  constraint htt_robot_schedule_day_weights_c1 check (begin_time < end_time),
  constraint htt_robot_schedule_day_weights_c2 check (weight > 0),
  constraint htt_robot_schedule_day_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_robot_schedule_day_weights is 'Weights to calculate weighted turnout';

comment on column htt_robot_schedule_day_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_timesheet_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  begin_time                      date       not null,
  end_time                        date       not null,
  weight                          number(20) not null,
  coef                            number     not null,
  constraint htt_timesheet_weights_pk primary key (company_id, filial_id, timesheet_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_timesheet_weights_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_weights_c1 check (begin_time < end_time),
  constraint htt_timesheet_weights_c2 check (weight > 0),
  constraint htt_timesheet_weights_c3 check (coef > 0)
) tablespace GWS_DATA;

comment on table htt_timesheet_weights is 'Weights to calculate weighted turnout';

comment on column htt_timesheet_weights.coef is 'Coef of given time part roughly equal weight/sum_of_weights_this_day';

----------------------------------------------------------------------------------------------------
create table htt_change_day_weights(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  change_id                       number(20) not null,
  change_date                     date       not null,
  begin_time                      number     not null,
  end_time                        number     not null,
  weight                          number(20) not null,
  constraint htt_change_day_weights_pk primary key (company_id, filial_id, staff_id, change_date, change_id, begin_time) using index tablespace GWS_INDEX,
  constraint htt_change_day_weights_f1 foreign key (company_id, filial_id, staff_id, change_date, change_id) references htt_change_days(company_id, filial_id, staff_id, change_date, change_id) on delete cascade,
  constraint htt_change_day_weights_c1 check (begin_time < end_time),
  constraint htt_change_day_weights_c2 check (weight > 0)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding nighttime policies
----------------------------------------------------------------------------------------------------
create sequence hpr_nighttime_policies_sq;
----------------------------------------------------------------------------------------------------
create table hpr_nighttime_policies(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  nighttime_policy_id             number(20)  not null,
  month                           date        not null,
  name                            varchar2(100 char),
  division_id                     number(20),
  state                           varchar2(1) not null,
  constraint hpr_nighttime_policies_pk primary key (company_id, filial_id, nighttime_policy_id) using index tablespace GWS_INDEX,
  constraint hpr_nighttime_policies_u1 unique (nighttime_policy_id) using index tablespace GWS_INDEX,
  constraint hpr_nighttime_policies_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_nighttime_policies_c1 check (month = trunc(month, 'mon')),
  constraint hpr_nighttime_policies_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpr_nighttime_policies_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hpr_nighttime_policies_u2 on hpr_nighttime_policies(company_id, filial_id, month, division_id) tablespace GWS_INDEX;

create index hpr_nighttime_policies_i1 on hpr_nighttime_policies(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_nighttime_rules(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  nighttime_policy_id             number(20)   not null,
  begin_time                      number(4)    not null,
  end_time                        number(4)    not null,
  nighttime_coef                  number(20,6) not null,
  constraint hpr_nighttime_rules_pk primary key (company_id, filial_id, nighttime_policy_id, begin_time) using index tablespace GWS_INDEX,
  constraint hpr_nighttime_rules_f1 foreign key (company_id, filial_id, nighttime_policy_id) references hpr_nighttime_policies(company_id, filial_id, nighttime_policy_id) on delete cascade,
  constraint hpr_nighttime_rules_c1 check (nighttime_coef > 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding nighttime column to hpr_sheet_parts
----------------------------------------------------------------------------------------------------
alter table hpr_sheet_parts add nighttime_amount number(20,6);

----------------------------------------------------------------------------------------------------
prompt add exam_id to hrec_vacancies
----------------------------------------------------------------------------------------------------  
alter table hrec_vacancies add exam_id number(20);
alter table hrec_vacancies rename constraint hrec_vacancies_f8 to hrec_vacancies_f9;
alter table hrec_vacancies rename constraint hrec_vacancies_f7 to hrec_vacancies_f8;
alter table hrec_vacancies add constraint hrec_vacancies_f7 foreign key (company_id, filial_id, exam_id) references hln_exams(company_id, filial_id, exam_id);

drop index hrec_vacancies_i7;
drop index hrec_vacancies_i8;

create index hrec_vacancies_i7 on hrec_vacancies(company_id, filial_id, exam_id) tablespace GWS_INDEX;
create index hrec_vacancies_i8 on hrec_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancies_i9 on hrec_vacancies(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------     
prompt add for_recruitment column for hln_exams
----------------------------------------------------------------------------------------------------     
alter table hln_exams add for_recruitment varchar2(1);

alter table hln_exams rename constraint hln_exams_c10 to hln_exams_c11;
alter table hln_exams rename constraint hln_exams_c9 to hln_exams_c10;
alter table hln_exams add constraint hln_exams_c9 check (for_recruitment in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt adding telegram candidates
----------------------------------------------------------------------------------------------------
create table hrec_telegram_candidates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null, 
  candidate_id                    number(20) not null,
  contact_code                      number(20) not null,
  constraint hrec_telegram_candidates_pk primary key (company_id, filial_id, candidate_id) using index tablespace GWS_INDEX,
  constraint hrec_telegram_candidates_u1 unique (company_id, filial_id, contact_code) using index tablespace GWS_INDEX,
  constraint hrec_telegram_candidates_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade
) tablespace GWS_DATA;

comment on table hrec_telegram_candidates is 'Candidates created from telegram bot';

comment on column hrec_telegram_candidates.contact_code is 'Telegram ID of candidate';

----------------------------------------------------------------------------------------------------
prompt adding modified_id to hrec_vacancies
----------------------------------------------------------------------------------------------------
alter table hrec_vacancies add modified_id number(20);

----------------------------------------------------------------------------------------------------
prompt add sign template tables 
----------------------------------------------------------------------------------------------------  
create table hpd_sign_templates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  template_id                     number(20) not null,
  journal_type_id                 number(20) not null,
  constraint hpd_sign_templates_pk primary key (company_id, filial_id, template_id) using index tablespace GWS_INDEX,
  constraint hpd_sign_templates_u1 unique (company_id, filial_id, journal_type_id) using index tablespace GWS_INDEX,
  constraint hpd_sign_templates_f1 foreign key (company_id, template_id) references mdf_sign_templates(company_id, template_id) on delete cascade,
  constraint hpd_sign_templates_f2 foreign key (company_id, journal_type_id) references hpd_journal_types(company_id, journal_type_id)
) tablespace GWS_DATA;

create index hpd_sign_templates_i1 on hpd_sign_templates(company_id, template_id) tablespace GWS_INDEX;
create index hpd_sign_templates_i2 on hpd_sign_templates(company_id, journal_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add sign document id for hpd_journals
----------------------------------------------------------------------------------------------------
alter table hpd_journals add sign_document_id number(20);

alter table hpd_journals rename constraint hpd_journals_f4 to hpd_journals_f5;
alter table hpd_journals rename constraint hpd_journals_f3 to hpd_journals_f4; 
alter table hpd_journals add constraint hpd_journals_f3 foreign key (company_id, sign_document_id) references mdf_sign_documents(company_id, document_id);

drop index hpd_journals_i2;
drop index hpd_journals_i3;
create index hpd_journals_i2 on hpd_journals(company_id, sign_document_id) tablespace GWS_INDEX;
create index hpd_journals_i3 on hpd_journals(company_id, created_by) tablespace GWS_INDEX;
create index hpd_journals_i4 on hpd_journals(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add some setting to hrm_settings
----------------------------------------------------------------------------------------------------  
alter table hrm_settings add keep_salary varchar2(1);
alter table hrm_settings add keep_vacation_limit varchar2(1);
alter table hrm_settings add keep_schedule varchar2(1);
alter table hrm_settings add keep_rank varchar2(1);

----------------------------------------------------------------------------------------------------   
prompt add currency to Robots
----------------------------------------------------------------------------------------------------  
alter table hrm_robots add currency_id number(20);

alter table hrm_robots rename constraint hrm_robots_f8 to hrm_robots_f9;
alter table hrm_robots rename constraint hrm_robots_f7 to hrm_robots_f8;
alter table hrm_robots add constraint hrm_robots_f7 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id);
                                     
drop index hrm_robots_i6;
drop index hrm_robots_i7;

create index hrm_robots_i6 on hrm_robots(company_id, currency_id) tablespace GWS_INDEX;
create index hrm_robots_i7 on hrm_robots(company_id, created_by) tablespace GWS_INDEX;
create index hrm_robots_i8 on hrm_robots(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding jor roles
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

