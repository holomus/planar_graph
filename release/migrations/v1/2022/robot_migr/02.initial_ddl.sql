prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt hrm changes
----------------------------------------------------------------------------------------------------
prompt delete position_rank from hrm_settings
----------------------------------------------------------------------------------------------------
alter table hrm_settings drop constraint hrm_settings_c5;
alter table hrm_settings drop constraint hrm_settings_c6;
alter table hrm_settings drop column position_rank;

alter table hrm_settings add constraint hrm_settings_c5 check (parttime_enable in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt hrm new tables
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
  wage                            number(20, 6) not null,
  coefficient                     number(20, 6),
  order_no                        number(3)     not null,
  constraint hrm_register_ranks_pk primary key (company_id, filial_id, register_id, rank_id) using index tablespace GWS_INDEX,
  constraint hrm_register_ranks_f1 foreign key (company_id, filial_id, register_id) references hrm_wage_scale_registers(company_id, filial_id, register_id) on delete cascade,
  constraint hrm_register_ranks_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hrm_register_ranks_c1 check (wage >= 0), 
  constraint hrm_register_ranks_c2 check (coefficient >= 0)
) tablespace GWS_DATA;

create index hrm_register_ranks_i1 on hrm_register_ranks(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Robots
----------------------------------------------------------------------------------------------------
create table hrm_robots(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  opened_date                     date        not null,
  closed_date                     date,
  schedule_id                     number(20),
  rank_id                         number(20),
  labor_function_id               number(20),
  description                     varchar2(300 char),
  hiring_condition                varchar2(300 char),
  contractual_wage                varchar2(1) not null,
  wage_scale_id                   number(20),
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
  constraint hrm_robots_f6 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hrm_robots_f7 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hrm_robots_c1 check (trunc(opened_date) = opened_date),
  constraint hrm_robots_c2 check (trunc(closed_date) = closed_date),
  constraint hrm_robots_c3 check (opened_date <= closed_date),
  constraint hrm_robots_c4 check (contractual_wage in ('Y', 'N')),
  constraint hrm_robots_c5 check (decode(contractual_wage, 'N', 1, 'Y', 0) = nvl2(wage_scale_id, 1, 0))
) tablespace GWS_DATA;

comment on column hrm_robots.description is 'short description about robots';

create index hrm_robots_i1 on hrm_robots(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hrm_robots_i2 on hrm_robots(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hrm_robots_i3 on hrm_robots(company_id, labor_function_id) tablespace GWS_INDEX;
create index hrm_robots_i4 on hrm_robots(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;
create index hrm_robots_i5 on hrm_robots(company_id, created_by) tablespace GWS_INDEX;
create index hrm_robots_i6 on hrm_robots(company_id, modified_by) tablespace GWS_INDEX;

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
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  robot_id                        number(20)         not null,
  oper_type_id                    number(20)         not null,
  indicator_id                    number(20)         not null,
  constraint hrm_oper_type_indicators_pk primary key (company_id, filial_id, robot_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hrm_oper_type_indicators_f1 foreign key (company_id, filial_id, robot_id, oper_type_id) references hrm_robot_oper_types(company_id, filial_id, robot_id, oper_type_id) on delete cascade,
  constraint hrm_oper_type_indicators_f2 foreign key (company_id, filial_id, robot_id, indicator_id) references hrm_robot_indicators(company_id, filial_id, robot_id, indicator_id)
) tablespace GWS_DATA;

create index hrm_oper_type_indicators_i1 on hrm_oper_type_indicators(company_id, filial_id, robot_id, indicator_id) tablespace GWS_INDEX;

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

create index hrm_robot_transactions_i1 on hrm_robot_transactions(company_id, filial_id, robot_id) tablespace GWS_INDEX;

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
  company_id number(20) not null,
  filial_id  number(20) not null,
  robot_id   number(20) not null,
  constraint hrm_dirty_robots_pk primary key (company_id, filial_id, robot_id),
  constraint hrm_dirty_robots_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
prompt hpd new tables
----------------------------------------------------------------------------------------------------
-- journal pages
----------------------------------------------------------------------------------------------------
create table hpd_page_robots(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  robot_id                        number(20)   not null,
  rank_id                         number(20),
  employment_type                 varchar2(1)  not null,
  fte                             number(20,6) not null,
  constraint hpd_page_robots_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_robots_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_page_robots_f3 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hpd_page_robots_c1 check (employment_type in ('M', 'E', 'I')),
  constraint hpd_page_robots_c2 check (fte > 0 and fte <= 1)
) tablespace GWS_DATA;

comment on column hpd_page_robots.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime';
comment on column hpd_page_robots.fte             is 'Full-time equivalent';

create index hpd_page_robots_i1 on hpd_page_robots(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_page_robots_i2 on hpd_page_robots(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- transactions
----------------------------------------------------------------------------------------------------
create table hpd_transactions(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  trans_id                        number(20)    not null,  
  staff_id                        number(20)    not null,
  trans_type                      varchar2(1)   not null,
  begin_date                      date          not null,
  end_date                        date,
  order_no                        number(20)    not null,
  journal_id                      number(20)    not null,
  page_id                         number(20)    not null,
  tag                             varchar2(120) not null,
  action                          varchar2(1)   not null,
  event                           varchar2(1)   not null,
  constraint hpd_transactions_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_transactions_u1 unique (trans_id) using index tablespace GWS_INDEX,
  constraint hpd_transactions_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_transactions_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint hpd_transactions_f3 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id),
  constraint hpd_transactions_c1 check (trans_type in ('B', 'O', 'S', 'R', 'L')),
  constraint hpd_transactions_c2 check (begin_date <= end_date),
  constraint hpd_transactions_c3 check (trunc(begin_date) = begin_date),
  constraint hpd_transactions_c4 check (trunc(end_date) = end_date),
  constraint hpd_transactions_c5 check (action = 'C' or action = 'S' and end_date is null),
  constraint hpd_transactions_c6 check (event in ('I', 'P', 'D')),
  constraint hpd_transactions_c7 check (event = 'P') deferrable initially deferred
) tablespace GWS_DATA;

comment on column hpd_transactions.trans_type is 'Ro(B)ot, (O)peration, (S)chedule, (R)ank, (L)eave';
comment on column hpd_transactions.action is '(C)ontinue, (S)top';
comment on column hpd_transactions.event is 'to be (I)ntegrated, in (P)rogress, to be (D)eleted';

create index hpd_transactions_i1 on hpd_transactions(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_transactions_i2 on hpd_transactions(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_transactions_i3 on hpd_transactions(company_id, filial_id, page_id) tablespace GWS_INDEX;
create index hpd_transactions_i4 on hpd_transactions(company_id, filial_id, staff_id, trans_type, event, begin_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------  
create table hpd_trans_robots(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  trans_id                        number(20)   not null,
  robot_id                        number(20)   not null,
  employment_type                 varchar2(1)  not null,
  fte                             number(20,6) not null,
  contractual_wage                varchar2(1)  not null,
  wage_scale_id                   number(20),
  constraint hpd_trans_robots_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_robots_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_trans_robots_f3 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hpd_trans_robots_c1 check (employment_type in ('M', 'E', 'I')),
  constraint hpd_trans_robots_c2 check (contractual_wage in ('Y', 'N')),
  constraint hpd_trans_robots_c3 check (decode(contractual_wage, 'N', 1, 'Y', 0) = nvl2(wage_scale_id, 1, 0))
) tablespace GWS_DATA;

comment on column hpd_trans_robots.employment_type  is '(M)ain job, (E)xternal parttime, (I)nternal parttime';
comment on column hpd_trans_robots.fte              is 'Full-time equivalent';
comment on column hpd_trans_robots.contractual_wage is '(Y)es, (N)o';

create index hpd_trans_robots_i1 on hpd_trans_robots(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_trans_robots_i2 on hpd_trans_robots(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_trans_schedules(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  schedule_id                     number(20)  not null,
  constraint hpd_trans_schedules_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_schedules_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_schedules_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id)
) tablespace GWS_DATA;

create index hpd_trans_schedules_i1 on hpd_trans_schedules(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_trans_ranks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  rank_id                         number(20)  not null,
  constraint hpd_trans_ranks_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_ranks_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_ranks_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id)
) tablespace GWS_DATA;

create index hpd_trans_ranks_i1 on hpd_trans_ranks(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
create table hpd_trans_oper_types(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  oper_type_id                    number(20)  not null,
  constraint hpd_trans_oper_types_pk primary key (company_id, filial_id, trans_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_oper_types_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hpd_trans_oper_types_i1 on hpd_trans_oper_types(company_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------      
create table hpd_trans_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  trans_id                        number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hpd_trans_indicators_pk primary key (company_id, filial_id, trans_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_indicators_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_trans_indicators_i1 on hpd_trans_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------               
create table hpd_trans_oper_type_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  trans_id                        number(20) not null,
  oper_type_id                    number(20) not null,
  indicator_id                    number(20) not null,
  constraint hpd_trans_oper_type_indicators_pk primary key (company_id, filial_id, trans_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_oper_type_indicators_f1 foreign key (company_id, filial_id, trans_id, oper_type_id) references hpd_trans_oper_types(company_id, filial_id, trans_id, oper_type_id) on delete cascade,
  constraint hpd_trans_oper_type_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_trans_oper_type_indicators_i1 on hpd_trans_oper_type_indicators(company_id, indicator_id) tablespace GWS_INDEX;


----------------------------------------------------------------------------------------------------
create table hpd_robot_trans_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_trans_id                  number(20) not null,
  staff_id                        number(20) not null,
  constraint hpd_robot_trans_staffs_pk primary key (company_id, filial_id, robot_trans_id) using index tablespace GWS_INDEX,
  constraint hpd_robot_trans_staffs_f1 foreign key (company_id, filial_id, robot_trans_id) references hrm_robot_transactions(company_id, filial_id, trans_id),
  constraint hpd_robot_trans_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id)
) tablespace GWS_DATA;

create index hpd_robot_trans_staffs_i1 on hpd_robot_trans_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_agreements(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  trans_type                      varchar2(1) not null,
  period                          date        not null,
  trans_id                        number(20)  not null,
  action                          varchar2(1) not null,
  constraint hpd_agreements_pk primary key (company_id, filial_id, staff_id, trans_type, period) using index tablespace GWS_INDEX,
  constraint hpd_agreements_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_agreements_f2 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id),
  constraint hpd_agreements_c1 check (trunc(period) = period),
  constraint hpd_agreements_c2 check (action in ('C', 'S'))
) tablespace GWS_DATA;

comment on column hpd_agreements.action is '(C)ontinue, (S)top';

create index hpd_agreements_i1 on hpd_agreements(company_id, filial_id, trans_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hpd_cloned_agreements(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  staff_id                        number(20)     not null,
  trans_type                      varchar2(1)    not null,
  period                          date           not null,
  trans_id                        number(20)     not null,
  action                          varchar2(1)    not null,
  constraint hpd_cloned_agreements_pk primary key (company_id, filial_id, staff_id, trans_type, period),
  constraint hpd_cloned_agreements_c1 check (company_id is null) deferrable initially deferred
);

create index hpd_cloned_agreements_i1 on hpd_cloned_agreements(company_id, filial_id, trans_id);

----------------------------------------------------------------------------------------------------
create global temporary table hpd_dirty_agreements(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  trans_type                      varchar2(1) not null,
  constraint hpd_dirty_agreements_pk primary key (company_id, filial_id, staff_id, trans_type),
  constraint hpd_dirty_agreements_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create global temporary table hpd_dirty_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  constraint hpd_dirty_staffs_pk primary key (company_id, filial_id, staff_id),
  constraint hpd_dirty_staffs_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
prompt new table hpd_rank_changes
----------------------------------------------------------------------------------------------------                       
create table hpd_rank_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  change_date                     date       not null,
  rank_id                         number(20) not null,
  constraint hpd_rank_changes_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,  
  constraint hpd_rank_changes_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_rank_changes_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hpd_rank_changes_c1 check (trunc(change_date) = change_date)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding "valid" column to journal pages
----------------------------------------------------------------------------------------------------
alter table hpd_journal_pages add valid varchar2(1);
----------------------------------------------------------------------------------------------------
-- update pages
----------------------------------------------------------------------------------------------------
update hpd_journal_pages p
   set p.valid = 'Y';
commit;

----------------------------------------------------------------------------------------------------
alter table hpd_journal_pages drop constraint hpd_journal_pages_f2;
alter table hpd_journal_pages drop constraint hpd_journal_pages_f3;

alter table hpd_journal_pages add constraint hpd_journal_pages_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);
alter table hpd_journal_pages add constraint hpd_journal_pages_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id);

alter table hpd_journal_pages add constraint hpd_journal_pages_c1 check (valid in ('Y', 'N'));
alter table hpd_journal_pages add constraint hpd_journal_pages_c2 check (valid = 'Y') deferrable initially deferred;

alter table hpd_journal_pages modify valid not null;

----------------------------------------------------------------------------------------------------
prompt adding "staff_id" column to hpd_hirings
----------------------------------------------------------------------------------------------------
alter table hpd_hirings add staff_id number(20);

update Hpd_Hirings p
   set p.Staff_Id =
       (select q.Staff_Id
          from Hpd_Journal_Pages q
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
           and q.Page_Id = p.Page_Id);
commit;

---------------------------------------------------------------------------------------------------- 
alter table hpd_hirings modify staff_id not null;
alter table hpd_hirings drop constraint hpd_hirings_f2;

alter table hpd_hirings add constraint hpd_hirings_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);
alter table hpd_hirings add constraint hpd_hirings_f3 foreign key (company_id, employment_source_id) references href_employment_sources(company_id, source_id);

create unique index hpd_hirings_u1 on hpd_hirings(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_charges
----------------------------------------------------------------------------------------------------
drop index hpr_charges_i7;
alter table hpr_charges drop constraint hpr_charges_f7;
alter table hpr_charges drop column position_id;


alter table hpr_charges add robot_id number(20); 
alter table hpr_charges add wage_scale_id number(20);

alter table hpr_charges add constraint hpr_charges_f7 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id);
alter table hpr_charges add constraint hpr_charges_f8 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id);

comment on column hpr_charges.robot_id      is 'Cache field';
comment on column hpr_charges.wage_scale_id is 'Cache field';

create index hpr_charges_i7 on hpr_charges(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpr_charges_i8 on hpr_charges(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;

prompt href_staffs changes
----------------------------------------------------------------------------------------------------  
alter table href_staffs add robot_id number(20);
alter table href_staffs add staff_kind varchar2(1);
alter table href_staffs add state varchar2(1);
alter table href_staffs add parent_id number(20);

alter table href_staffs rename column quantity to fte;

comment on column href_staffs.staff_kind is '(P)rimary, (S)econdary';
comment on column href_staffs.state      is '(A)ctive, (P)assive';

---------------------------------------------------------------------------------------------------- 
prompt new sequences
----------------------------------------------------------------------------------------------------
-- new sequences
----------------------------------------------------------------------------------------------------
create sequence hrm_robot_transactions_sq;
create sequence hrm_wage_scales_sq;
create sequence hrm_wage_scale_registers_sq;
create sequence hpd_transactions_sq;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('h')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('h');
exec fazo_z.Compile_Invalid_Objects;
