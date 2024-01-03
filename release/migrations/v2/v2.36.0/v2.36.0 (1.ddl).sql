prompt migr from staff schedule days change constraint
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
-- staff schedule day
----------------------------------------------------------------------------------------------------
alter table htt_staff_schedule_days drop constraint htt_staff_schedule_days_c2;
alter table htt_staff_schedule_days add constraint htt_staff_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N'));
alter table htt_staff_schedule_days drop constraint htt_staff_schedule_days_c4;
alter table htt_staff_schedule_days add constraint htt_staff_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0));

----------------------------------------------------------------------------------------------------
-- robot schedule day
----------------------------------------------------------------------------------------------------
alter table htt_robot_schedule_days drop constraint htt_robot_schedule_days_c2;
alter table htt_robot_schedule_days add constraint htt_robot_schedule_days_c2 check (day_kind in ('W', 'R', 'A', 'H', 'N'));
alter table htt_robot_schedule_days drop constraint htt_robot_schedule_days_c4;
alter table htt_robot_schedule_days add constraint htt_robot_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0));

----------------------------------------------------------------------------------------------------  
prompt add htt_calendar_week_days table 
----------------------------------------------------------------------------------------------------  
-- calendar week days
---------------------------------------------------------------------------------------------------- 
create table htt_calendar_week_days(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  calendar_id                     number(20) not null,
  order_no                        number(1) not null,
  plan_time                       number(6) not null,
  preholiday_time                 number(6) not null,
  preweekend_time                 number(6) not null,
  constraint htt_calendar_week_days_pk primary key (company_id, filial_id, calendar_id, order_no),
  constraint htt_calendar_week_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_week_days_c1 check(order_no > 0 and order_no < 8)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------                         
prompt modify href_cached_contract_item_names.name column 
----------------------------------------------------------------------------------------------------
alter table href_cached_contract_item_names modify name varchar2(500 char);

----------------------------------------------------------------------------------------------------                         
prompt dismissal_date to hpd_hirings
----------------------------------------------------------------------------------------------------
alter table hpd_hirings add dismissal_date date;

alter table hpd_hirings drop constraint hpd_hirings_c2;

alter table hpd_hirings add constraint hpd_hirings_c2 check (trunc(dismissal_date) = dismissal_date);
alter table hpd_hirings add constraint hpd_hirings_c3 check (hiring_date <= dismissal_date);
alter table hpd_hirings add constraint hpd_hirings_c4 check (trial_period between 0 and 366);

----------------------------------------------------------------------------------------------------                         
prompt adding new employment_type
----------------------------------------------------------------------------------------------------  
alter table hpd_page_robots drop constraint hpd_page_robots_c1;
alter table hpd_page_robots add constraint hpd_page_robots_c1 check (employment_type in ('M', 'E', 'I', 'C'));

comment on column hpd_page_robots.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';

---------------------------------------------------------------------------------------------------- 
alter table hpd_trans_robots drop constraint hpd_trans_robots_c1;
alter table hpd_trans_robots add constraint hpd_trans_robots_c1 check (employment_type in ('M', 'E', 'I', 'C'));

comment on column hpd_trans_robots.employment_type  is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';

----------------------------------------------------------------------------------------------------
alter table href_staffs add employment_type varchar2(1);

alter table href_staffs add constraint href_staffs_c9 check (employment_type in ('M', 'E', 'I', 'C'));

comment on column href_staffs.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';

----------------------------------------------------------------------------------------------------
alter table hper_plans drop constraint hper_plans_c5;
alter table hper_plans add constraint hper_plans_c5 check (employment_type in ('M', 'E', 'I', 'C'));

comment on column hper_plans.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';

----------------------------------------------------------------------------------------------------
alter table hper_staff_plans drop constraint hper_staff_plans_c1;
alter table hper_staff_plans add constraint hper_staff_plans_c1 check (employment_type in ('M', 'E', 'I', 'C'));

comment on column hper_staff_plans.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';

----------------------------------------------------------------------------------------------------         
prompt adding position employment kind to hrm_robots
----------------------------------------------------------------------------------------------------
alter table hrm_robots add position_employment_kind varchar2(1);

alter table hrm_robots add constraint hrm_robots_c7 check (position_employment_kind in ('C', 'S'));

----------------------------------------------------------------------------------------------------         
prompt adding contract_employment_type to hpd_cv_contracts
----------------------------------------------------------------------------------------------------
alter table hpd_cv_contracts add contract_employment_kind varchar2(1);
alter table hpd_cv_contracts add page_id                  number(20);

alter table hpd_cv_contracts add constraint hpd_cv_contracts_f3 foreign key (company_id, filial_id, page_id) references hpd_hirings(company_id, filial_id, page_id) on delete cascade;
alter table hpd_cv_contracts add constraint hpd_cv_contracts_c6 check (contract_employment_kind in ('F', 'M'));
alter table hpd_cv_contracts add constraint hpd_cv_contracts_c7 check (contract_employment_kind = 'M' and page_id is not null or contract_employment_kind = 'F' and page_id is null);

create unique index hpd_cv_contracts_u2 on hpd_cv_contracts(nvl2(page_id, company_id, null), nvl2(page_id, filial_id, null), page_id) tablespace GWS_INDEX;

create index hpd_cv_contracts_i3 on hpd_cv_contracts(company_id, filial_id, page_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
prompt add vacancy langs table
----------------------------------------------------------------------------------------------------  
create table hrec_vacancy_langs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  lang_id                         number(20) not null,
  lang_level_id                   number(20) not null,
  constraint hrec_vacancy_langs_pk primary key (company_id, filial_id, vacancy_id, lang_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_langs_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_langs_f2 foreign key (company_id, lang_id) references href_langs(company_id, lang_id),
  constraint hrec_vacancy_langs_f3 foreign key (company_id, lang_level_id) references href_lang_levels(company_id, lang_level_id)
) tablespace GWS_DATA;

create index hrec_vacancy_langs_i1 on hrec_vacancy_langs(company_id, lang_id) tablespace GWS_INDEX;
create index hrec_vacancy_langs_i2 on hrec_vacancy_langs(company_id, lang_level_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add wage from wage to column to vacancies
----------------------------------------------------------------------------------------------------               
alter table hrec_vacancies rename column wage to wage_from;
alter table hrec_vacancies add wage_to number(20, 6);

alter table hrec_vacancies rename constraint hrec_vacancies_c10 to hrec_vacancies_c11;
alter table hrec_vacancies rename constraint hrec_vacancies_c9 to hrec_vacancies_c10;
alter table hrec_vacancies drop constraint hrec_vacancies_c8;
alter table hrec_vacancies add constraint hrec_vacancies_c8 check (wage_from > 0);
alter table hrec_vacancies add constraint hrec_vacancies_c9 check (wage_to >= wage_from); 

----------------------------------------------------------------------------------------------------
prompt add schedule_id column to vacancies
----------------------------------------------------------------------------------------------------  
alter table hrec_vacancies add schedule_id number(20);

alter table hrec_vacancies rename constraint hrec_vacancies_f7 to hrec_vacancies_f8;
alter table hrec_vacancies rename constraint hrec_vacancies_f6 to hrec_vacancies_f7;

alter table hrec_vacancies add constraint hrec_vacancies_f6 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id);

drop index hrec_vacancies_i6;
drop index hrec_vacancies_i7;

create index hrec_vacancies_i6 on hrec_vacancies(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hrec_vacancies_i7 on hrec_vacancies(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancies_i8 on hrec_vacancies(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------         
prompt add new column for hrec_vacancies, description and description_in_html
----------------------------------------------------------------------------------------------------
alter table hrec_vacancies add description varchar2(4000);
alter table hrec_vacancies add description_in_html varchar2(4000);

comment on column hrec_vacancies.description is 'Description about this Vacancy';
comment on column hrec_vacancies.description_in_html is 'Description in Html format. We can use for publish to another server like Head Hunter';

----------------------------------------------------------------------------------------------------  
prompt update hrec_hh_integration_jobs table
----------------------------------------------------------------------------------------------------              
drop table hrec_hh_integration_jobs;

create table hrec_hh_integration_jobs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  job_code                        number(20) not null,
  job_id                          number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_jobs_pk primary key (company_id, filial_id, job_code, job_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_jobs_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade,
  constraint hrec_hh_integration_jobs_f2 foreign key (company_id, job_code) references hrec_head_hunter_jobs(company_id, code) on delete cascade,
  constraint hrec_hh_integration_jobs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_jobs_i1 on hrec_hh_integration_jobs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hrec_hh_integration_jobs_i2 on hrec_hh_integration_jobs(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------  
prompt add new tables, Vacancy Groups and Vacancy Types
----------------------------------------------------------------------------------------------------  
create table hrec_vacancy_groups(
  company_id                      number(20)         not null,
  vacancy_group_id                number(20)         not null, 
  name                            varchar2(100 char) not null,
  order_no                        number(6),
  is_required                     varchar2(1)        not null,
  multiple_select                 varchar2(1)        not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_vacancy_groups_pk primary key (company_id, vacancy_group_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_groups_u1 unique (vacancy_group_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_groups_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_groups_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_vacancy_groups_c2 check (is_required in ('Y', 'N')),
  constraint hrec_vacancy_groups_c3 check (multiple_select in ('Y', 'N')),
  constraint hrec_vacancy_groups_c4 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_vacancy_groups_c5 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint hrec_vacancy_groups_c6 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hrec_vacancy_groups_u2 on hrec_vacancy_groups(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_vacancy_groups_u3 on hrec_vacancy_groups(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_vacancy_groups_u4 on hrec_vacancy_groups(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_vacancy_groups_i1 on hrec_vacancy_groups(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancy_groups_i2 on hrec_vacancy_groups(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_vacancy_types(
  company_id                      number(20)         not null,
  vacancy_type_id                 number(20)         not null,
  vacancy_group_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hrec_vacancy_types_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_u1 unique (vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_u2 unique (company_id, vacancy_group_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_types_f1 foreign key (company_id, vacancy_group_id) references hrec_vacancy_groups(company_id, vacancy_group_id) on delete cascade,
  constraint hrec_vacancy_types_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_types_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrec_vacancy_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hrec_vacancy_types_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint hrec_vacancy_types_c3 check (decode(trim(pcode), pcode, 1, 0) = 1),
  constraint hrec_vacancy_types_c4 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hrec_vacancy_types_u3 on hrec_vacancy_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index hrec_vacancy_types_u4 on hrec_vacancy_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index hrec_vacancy_types_u5 on hrec_vacancy_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index hrec_vacancy_types_i1 on hrec_vacancy_types(company_id, vacancy_group_id) tablespace GWS_INDEX;
create index hrec_vacancy_types_i2 on hrec_vacancy_types(company_id, created_by) tablespace GWS_INDEX;
create index hrec_vacancy_types_i3 on hrec_vacancy_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------         
create table hrec_vacancy_type_binds(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  vacancy_id                      number(20) not null,
  vacancy_group_id                number(20) not null,
  vacancy_type_id                 number(20) not null,
  constraint hrec_vacancy_type_binds_pk primary key (company_id, filial_id, vacancy_id, vacancy_group_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_vacancy_type_binds_f1 foreign key (company_id, filial_id, vacancy_id) references hrec_vacancies(company_id, filial_id, vacancy_id) on delete cascade,
  constraint hrec_vacancy_type_binds_f2 foreign key (company_id, vacancy_group_id) references hrec_vacancy_groups(company_id, vacancy_group_id),
  constraint hrec_vacancy_type_binds_f3 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id)
) tablespace GWS_DATA;

create index hrec_vacancy_type_binds_i1 on hrec_vacancy_type_binds(company_id, vacancy_group_id) tablespace GWS_INDEX;
create index hrec_vacancy_type_binds_i2 on hrec_vacancy_type_binds(company_id, vacancy_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
create table hrec_hh_experiences(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_experiences_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_experiences is 'Keeps Experiences from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_employments(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_employments_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_employments is 'Keeps Employments from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_schedules(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_schedules_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_schedules is 'Keeps Schedules from Head Hunter';

----------------------------------------------------------------------------------------------------
create table hrec_hh_driver_licences(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_driver_licences_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_driver_licences is 'Keeps Driver Licences from Head Hunter';

----------------------------------------------------------------------------------------------------       
create table hrec_hh_langs(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_langs_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_langs is 'Keeps Langs from Head Hunter';

----------------------------------------------------------------------------------------------------                         
create table hrec_hh_lang_levels(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_lang_levels_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hrec_hh_lang_levels is 'Keeps Lang Levels from Head Hunter';

----------------------------------------------------------------------------------------------------       
create table hrec_hh_integration_experiences(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  experience_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_experiences_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_experiences_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_experiences_f2 foreign key (company_id, experience_code) references hrec_hh_experiences(company_id, code) on delete cascade,
  constraint hrec_hh_integration_experiences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_experiences_i1 on hrec_hh_integration_experiences(company_id, created_by) tablespace GWS_INDEX;      

----------------------------------------------------------------------------------------------------       
create table hrec_hh_integration_employments(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  employment_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_employments_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_employments_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_employments_f2 foreign key (company_id, employment_code) references hrec_hh_employments(company_id, code) on delete cascade,
  constraint hrec_hh_integration_employments_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_employments_i1 on hrec_hh_integration_employments(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
create table hrec_hh_integration_schedules(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  schedule_id                     number(20)   not null,
  schedule_code                   varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_schedules_pk primary key (company_id, filial_id, schedule_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_schedules_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade,
  constraint hrec_hh_integration_schedules_f2 foreign key (company_id, schedule_code) references hrec_hh_schedules(company_id, code) on delete cascade,
  constraint hrec_hh_integration_schedules_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_schedules_i1 on hrec_hh_integration_schedules(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_langs(
  company_id                      number(20)   not null,
  lang_id                         number(20)   not null,
  lang_code                       varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_langs_pk primary key (company_id, lang_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_langs_f1 foreign key (company_id, lang_id) references href_langs(company_id, lang_id) on delete cascade,
  constraint hrec_hh_integration_langs_f2 foreign key (company_id, lang_code) references hrec_hh_langs(company_id, code) on delete cascade,
  constraint hrec_hh_integration_langs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_langs_i1 on hrec_hh_integration_langs(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_lang_levels(
  company_id                      number(20)   not null,
  lang_level_id                   number(20)   not null,
  lang_level_code                 varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_lang_levels_pk primary key (company_id, lang_level_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_lang_levels_f1 foreign key (company_id, lang_level_id) references href_lang_levels(company_id, lang_level_id) on delete cascade,
  constraint hrec_hh_integration_lang_levels_f2 foreign key (company_id, lang_level_code) references hrec_hh_lang_levels(company_id, code) on delete cascade,
  constraint hrec_hh_integration_lang_levels_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_lang_levels_i1 on hrec_hh_integration_lang_levels(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrec_hh_integration_driver_licences(
  company_id                      number(20)   not null,
  vacancy_type_id                 number(20)   not null,
  licence_code                    varchar2(50) not null, 
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hrec_hh_integration_driver_licences_pk primary key (company_id, vacancy_type_id) using index tablespace GWS_INDEX,
  constraint hrec_hh_integration_driver_licences_f1 foreign key (company_id, vacancy_type_id) references hrec_vacancy_types(company_id, vacancy_type_id) on delete cascade,
  constraint hrec_hh_integration_driver_licences_f2 foreign key (company_id, licence_code) references hrec_hh_driver_licences(company_id, code) on delete cascade,
  constraint hrec_hh_integration_driver_licences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id) on delete cascade
) tablespace GWS_DATA;

create index hrec_hh_integration_driver_licences_i1 on hrec_hh_integration_driver_licences(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add key skills  
----------------------------------------------------------------------------------------------------
create table hrec_hh_key_skills(
  company_id                      number(20)         not null,
  code                            varchar2(50)       not null,
  name                            varchar2(100 char) not null,
  constraint hrec_hh_key_skills_pk primary key (company_id, code) using index tablespace GWS_INDEX
) tablespace GWS_DATA;     

----------------------------------------------------------------------------------------------------    
prompt monthly and daily limit added
----------------------------------------------------------------------------------------------------
alter table htt_calendars add monthly_limit varchar2(1);
alter table htt_calendars add daily_limit varchar2(1);

----------------------------------------------------------------------------------------------------
create sequence hrec_vacancy_groups_sq;
create sequence hrec_vacancy_types_sq;
