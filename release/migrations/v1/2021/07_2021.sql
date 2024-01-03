prompt migr 12.07.2021
set define off
set serveroutput on
----------------------------------------------------------------------------------------------------
-- htt_request
----------------------------------------------------------------------------------------------------
create table htt_leaves(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  request_id                      number(20)  not null,
  leave_type_id                   number(20)  not null,
  leave_kind                      varchar2(1) not null,
  timesheet_coef                  number(5,2) not null,
  allow_unused_time               varchar2(1) not null,
  begin_time                      date        not null,
  end_time                        date        not null,
  constraint htt_leaves_pk primary key (company_id, filial_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_leaves_f1 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id) on delete cascade,
  constraint htt_leaves_f2 foreign key (company_id, leave_type_id) references htt_leave_types(company_id, leave_type_id),
  constraint htt_leaves_c1 check (leave_kind in ('P', 'F', 'M')),
  constraint htt_leaves_c2 check (allow_unused_time in ('Y', 'N')),
  constraint htt_leaves_c3 check (begin_time <= end_time)
) tablespace GWS_DATA;

comment on column htt_leaves.leave_kind is '(P)art of day, (F)ull day, (M)ultiple days, used when leaving type is specified';

create index htt_leaves_i1 on htt_leaves(company_id, leave_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_changes(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  request_id                      number(20)  not null,
  change_kind                     varchar2(1) not null,
  constraint htt_changes_pk primary key (company_id, filial_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_changes_f1 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id) on delete cascade,
  constraint htt_changes_c1 check (change_kind in ('S', 'C'))
) tablespace GWS_DATA;

comment on column htt_changes.change_kind is '(S)wap, (C)hange day';

----------------------------------------------------------------------------------------------------
create table htt_change_times(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  request_id                      number(20)  not null,
  change_date                     date        not null,
  begin_time                      date,
  end_time                        date,
  day_kind                        varchar2(1) not null,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number      not null,
  constraint htt_change_times_pk primary key (company_id, filial_id, request_id, change_date) using index tablespace GWS_INDEX,
  constraint htt_change_times_f1 foreign key (company_id, filial_id, request_id) references htt_changes(company_id, filial_id, request_id) on delete cascade,
  constraint htt_change_times_c1 check (day_kind = 'W' and begin_time < end_time and break_enabled is not null or
                                        day_kind = 'R' and begin_time is null and end_time is null and break_enabled is null),
  constraint htt_change_times_c2 check (plan_time between 0 and 1440),
  constraint htt_change_times_c3 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_change_times_c4 check (break_begin_time < break_end_time),
  constraint htt_change_times_c5 check (begin_time <= break_begin_time and break_end_time <= end_time)
) tablespace GWS_DATA;

comment on column htt_change_times.day_kind      is '(W)orking, (R)est';
comment on column htt_change_times.break_enabled is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
declare
begin
  insert into Htt_Leaves
    (Company_Id,
     Filial_Id,
     Request_Id,
     Leave_Type_Id,
     Leave_Kind,
     Timesheet_Coef,
     Allow_Unused_Time,
     Begin_Time,
     End_Time)
    (select w.Company_Id,
            w.Filial_Id,
            w.Request_Id,
            w.Leave_Type_Id,
            w.Leave_Kind,
            w.Timesheet_Coef,
            w.Allow_Unused_Time,
            q.Begin_Time,
            q.End_Time
       from Htt_Requests w
       join Htt_Request_Times q
         on w.Company_Id = q.Company_Id
        and w.Filial_Id = q.Filial_Id
        and w.Request_Id = q.Request_Id
      where w.Leave_Type_Id is not null
        and w.Leave_Kind is not null);

  --------------------------------------------------    
  insert into Htt_Changes
    (Company_Id, Filial_Id, Request_Id, Change_Kind)
    (select w.Company_Id, w.Filial_Id, w.Request_Id, w.Change_Kind
       from Htt_Requests w
      where w.Leave_Type_Id is null
        and w.Leave_Kind is null);

  --------------------------------------------------    
  insert into Htt_Change_Times
    (Company_Id,
     Filial_Id,
     Request_Id,
     Change_Date,
     Begin_Time,
     End_Time,
     Day_Kind,
     Break_Enabled,
     Break_Begin_Time,
     Break_End_Time,
     Plan_Time)
    (select w.Company_Id,
            w.Filial_Id,
            w.Request_Id,
            q.Request_Date,
            q.Begin_Time,
            q.End_Time,
            q.Day_Kind,
            q.Break_Enabled,
            q.Break_Begin_Time,
            q.Break_End_Time,
            q.Plan_Time
       from Htt_Requests w
       join Htt_Request_Times q
         on w.Company_Id = q.Company_Id
        and w.Filial_Id = q.Filial_Id
        and w.Request_Id = q.Request_Id
      where w.Leave_Type_Id is null
        and w.Leave_Kind is null
        and w.Change_Kind is not null);
        
  commit;
end;
/

----------------------------------------------------------------------------------------------------
-- refactoring constraints
----------------------------------------------------------------------------------------------------  
alter table htt_requests drop constraint htt_requests_f2;
alter table htt_requests drop constraint htt_requests_f3;
alter table htt_requests drop constraint htt_requests_f4;
alter table htt_requests drop constraint htt_requests_f5;
alter table htt_requests drop constraint htt_requests_c1;
alter table htt_requests drop constraint htt_requests_c2;
alter table htt_requests drop constraint htt_requests_c3;
alter table htt_requests drop constraint htt_requests_c4;
alter table htt_requests drop constraint htt_requests_c5;

alter table htt_requests add constraint htt_requests_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade;
alter table htt_requests add constraint htt_requests_f3 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_requests add constraint htt_requests_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id);
alter table htt_requests add constraint htt_requests_c1 check (status in ('N', 'A', 'C', 'D'));

----------------------------------------------------------------------------------------------------     
-- refactoring index
----------------------------------------------------------------------------------------------------     
drop index htt_requests_i1;
drop index htt_requests_i2;
drop index htt_requests_i3;
drop index htt_requests_i4;
drop index htt_requests_i5;

create index htt_requests_i1 on htt_requests(company_id, request_type_id) tablespace GWS_INDEX;
create index htt_requests_i2 on htt_requests(company_id, created_by) tablespace GWS_INDEX;
create index htt_requests_i3 on htt_requests(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- drop columns
---------------------------------------------------------------------------------------------------- 
alter table htt_requests drop column leave_type_id;
alter table htt_requests drop column leave_kind;
alter table htt_requests drop column timesheet_coef;
alter table htt_requests drop column allow_unused_time;
alter table htt_requests drop column change_kind;

----------------------------------------------------------------------------------------------------
-- drop table
----------------------------------------------------------------------------------------------------
drop table htt_request_times;
drop sequence htt_request_times_sq;

----------------------------------------------------------------------------------------------------
-- add hper module
----------------------------------------------------------------------------------------------------
create sequence hper_plan_groups_sq;
create sequence hper_plan_types_sq;
create sequence hper_plans_sq;
create sequence hper_staff_plans_sq;
create sequence hper_staff_plan_parts_sq;

----------------------------------------------------------------------------------------------------
create table hper_plan_groups(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  plan_group_id                   number(20)         not null,
  name                            varchar2(200 char) not null,
  state                           varchar2(1)        not null,
  order_no                        number(3),
  constraint hper_plan_groups_pk primary key (company_id, filial_id, plan_group_id) using index tablespace GWS_INDEX,
  constraint hper_plan_groups_u1 unique (plan_group_id) using index tablespace GWS_INDEX,
  constraint hper_plan_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hper_plan_groups_c2 check (state in ('A', 'P')) 
) tablespace GWS_DATA;

create unique index hper_plan_groups_u2 on hper_plan_groups(company_id, filial_id, lower(name)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plan_types(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  plan_type_id                    number(20)         not null,
  name                            varchar2(200 char) not null,
  plan_group_id                   number(20),
  calc_kind                       varchar2(1)        not null,
  with_part                       varchar2(1)        not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  order_no                        number(3),
  c_divisions_exist               varchar2(1)        not null,
  constraint hper_plan_types_pk primary key (company_id, filial_id, plan_type_id) using index tablespace GWS_INDEX,
  constraint hper_plan_types_u1 unique (plan_type_id) using index tablespace GWS_INDEX,
  constraint hper_plan_types_f1 foreign key (company_id, filial_id, plan_group_id) references hper_plan_groups(company_id, filial_id, plan_group_id) on delete cascade,
  constraint hper_plan_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hper_plan_types_c2 check (state in ('A', 'P')),
  constraint hper_plan_types_c3 check (calc_kind in ('M', 'T', 'A')),
  constraint hper_plan_types_c4 check (with_part in ('N', 'Y')),
  constraint hper_plan_types_c5 check (decode(trim(code), code, 1, 0) = 1) 
) tablespace GWS_DATA;

comment on column hper_plan_types.calc_kind is '(M)anual, (T)ask, (A)ttendance';

create unique index hper_plan_types_u2 on hper_plan_types(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create unique index hper_plan_types_u3 on hper_plan_types(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

create index hper_plan_types_i1 on hper_plan_types(company_id, filial_id, plan_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plan_type_task_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  plan_type_id                    number(20) not null,
  task_type_id                    number(20) not null,
  constraint hper_plan_type_task_types_pk primary key (company_id, filial_id, plan_type_id, task_type_id) using index tablespace GWS_INDEX,
  constraint hper_plan_type_task_types_f1 foreign key (company_id, filial_id, plan_type_id) references hper_plan_types(company_id, filial_id, plan_type_id) on delete cascade,
  constraint hper_plan_type_task_types_f2 foreign key (company_id, task_type_id) references ms_task_types(company_id, task_type_id)
) tablespace GWS_DATA;

create index hper_plan_type_task_types_i1 on hper_plan_type_task_types(company_id, filial_id, task_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plan_type_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  plan_type_id                    number(20) not null,
  division_id                     number(20) not null,
  constraint hper_plan_type_divisions_pk primary key (company_id, filial_id, plan_type_id, division_id) using index tablespace GWS_INDEX,
  constraint hper_plan_type_divisions_f1 foreign key (company_id, filial_id, plan_type_id) references hper_plan_types(company_id, filial_id, plan_type_id) on delete cascade,
  constraint hper_plan_type_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade
) tablespace GWS_DATA;

create index hper_plan_type_divisions_i1 on hper_plan_type_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plans(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  plan_id                         number(20)  not null,
  plan_date                       date        not null,
  plan_kind                       varchar2(1) not null,
  main_calc_type                  varchar2(1) not null,
  extra_calc_type                 varchar2(1) not null,
  journal_page_id                 number(20),
  division_id                     number(20),
  job_id                          number(20),
  rank_id                         number(20),
  employment_type                 varchar2(1),
  note                            varchar2(300 char),
  constraint hper_plans_pk primary key (company_id, filial_id, plan_id) using index tablespace GWS_INDEX,
  constraint hper_plans_u1 unique (plan_id) using index tablespace GWS_INDEX,
  constraint hper_plans_u2 unique (company_id, filial_id, plan_date, journal_page_id, division_id, job_id, rank_id) using index tablespace GWS_INDEX,
  constraint hper_plans_f1 foreign key (company_id, filial_id, journal_page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hper_plans_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hper_plans_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hper_plans_f4 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hper_plans_c1 check (plan_date = trunc(plan_date, 'MON')),
  constraint vx_pr_plans_c2 check (plan_kind = 'S' and journal_page_id is null and division_id is not null and job_id is not null and employment_type is not null or
                                   plan_kind = 'C' and journal_page_id is not null and division_id is null and job_id is null and employment_type is null),
  constraint hper_plans_c2 check (main_calc_type in ('W', 'U')),
  constraint hper_plans_c3 check (extra_calc_type in ('W', 'U')),
  constraint hper_plans_c4 check (employment_type in ('M', 'E', 'I'))
) tablespace GWS_DATA;

comment on column hper_plans.plan_kind is '(S)tandard, (C)ontract';
comment on column hper_plans.main_calc_type is 'Bonus amount (W)eight, amount per (U)nit';
comment on column hper_plans.extra_calc_type is 'Bonus amount (W)eight, amount per (U)nit';
comment on column hper_plans.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime';

create index hper_plans_i1 on hper_plans(company_id, filial_id, plan_kind) tablespace GWS_INDEX;
create index hper_plans_i2 on hper_plans(company_id, filial_id, journal_page_id) tablespace GWS_INDEX;
create index hper_plans_i3 on hper_plans(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hper_plans_i4 on hper_plans(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hper_plans_i5 on hper_plans(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plan_items(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  plan_id                         number(20)    not null,
  plan_type_id                    number(20)    not null,
  plan_type                       varchar2(1)   not null,
  plan_value                      number(20, 6) not null,
  plan_amount                     number(20, 6) not null,
  note                            varchar2(300 char),
  order_no                        number(3),
  constraint hper_plan_items_pk primary key(company_id, filial_id, plan_id, plan_type_id) using index tablespace GWS_INDEX,
  constraint hper_plan_items_f1 foreign key(company_id, filial_id, plan_id) references hper_plans(company_id, filial_id, plan_id) on delete cascade,
  constraint hper_plan_items_f2 foreign key(company_id, filial_id, plan_type_id) references hper_plan_types(company_id, filial_id, plan_type_id) on delete cascade,
  constraint hper_plan_items_c1 check (plan_type in ('M', 'E')),
  constraint hper_plan_items_c2 check (plan_value > 0),
  constraint hper_plan_items_c3 check (plan_amount > 0)
) tablespace GWS_DATA;

comment on column hper_plan_items.plan_type is '(M)ain plan, (E)xtra plan';
comment on column hper_plan_items.plan_amount is 'bonus amount weight or amount per unit';

create index hper_plan_items_i1 on hper_plan_items(company_id, filial_id, plan_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_plan_rules(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  plan_id                         number(20) not null,
  plan_type_id                    number(20) not null,
  from_percent                    number(3)  not null,
  to_percent                      number(3),
  fact_amount                     number(20,6),
  constraint hper_plan_rules_pk primary key (company_id, filial_id, plan_id, from_percent) using index tablespace GWS_INDEX,
  constraint hper_plan_rules_f1 foreign key (company_id, filial_id, plan_id, plan_type_id) references hper_plan_items(company_id, filial_id, plan_id, plan_type_id) on delete cascade,
  constraint hper_plan_rules_c1 check (from_percent <= to_percent),
  constraint hper_plan_rules_c2 check (from_percent >= 0),
  constraint hper_plan_rules_c3 check (fact_amount >= 0)
) tablespace GWS_DATA;

comment on column hper_plan_rules.fact_amount is 'fact percent or unit amount';

----------------------------------------------------------------------------------------------------
-- staff plans
----------------------------------------------------------------------------------------------------
create table hper_staff_plans(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  staff_plan_id                   number(20)   not null,
  staff_id                        number(20)   not null,
  plan_date                       date         not null,
  main_calc_type                  varchar2(1)  not null,
  extra_calc_type                 varchar2(1)  not null,  
  month_begin_date                date         not null,
  month_end_date                  date         not null,
  journal_page_id                 number(20)   not null,
  division_id                     number(20)   not null,
  job_id                          number(20)   not null,
  rank_id                         number(20),
  employment_type                 varchar2(1)  not null,
  begin_date                      date         not null,
  end_date                        date         not null,
  main_plan_amount                number(20,6) not null,
  extra_plan_amount               number(20,6) not null,
  main_fact_amount                number(20,6) not null,
  extra_fact_amount               number(20,6) not null,
  main_fact_percent               number(20,6) not null,
  extra_fact_percent              number(20,6) not null,
  c_main_fact_percent             number(20,6) not null,
  c_extra_fact_percent            number(20,6) not null,
  status                          varchar2(1)  not null,
  note                            varchar2(300 char),
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  constraint hper_staff_plans_pk primary key (company_id, filial_id, staff_plan_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plans_u1 unique (staff_plan_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plans_u2 unique (company_id, filial_id, journal_page_id, plan_date) using index tablespace GWS_INDEX,
  constraint hper_staff_plans_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint hper_staff_plans_f2 foreign key (company_id, filial_id, journal_page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hper_staff_plans_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hper_staff_plans_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hper_staff_plans_f5 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hper_staff_plans_c1 check (employment_type in ('M', 'E', 'I')),
  constraint hper_staff_plans_c2 check (plan_date = trunc(plan_date, 'MON')),
  constraint hper_staff_plans_c3 check (plan_date = trunc(month_end_date, 'MON')),
  constraint hper_staff_plans_c4 check (main_calc_type in ('W', 'U')),
  constraint hper_staff_plans_c5 check (extra_calc_type in ('W', 'U')),
  constraint hper_staff_plans_c6 check (month_begin_date <= month_end_date),
  constraint hper_staff_plans_c7 check (begin_date <= end_date),
  constraint hper_staff_plans_c8 check (main_plan_amount >= 0),
  constraint hper_staff_plans_c9 check (extra_plan_amount >= 0),
  constraint hper_staff_plans_c10 check (main_fact_amount >= 0),
  constraint hper_staff_plans_c11 check (extra_fact_amount >= 0),
  constraint hper_staff_plans_c12 check (main_fact_percent >= 0),
  constraint hper_staff_plans_c13 check (extra_fact_percent >= 0),
  constraint hper_staff_plans_c14 check (status in ('D', 'N', 'W', 'C'))
) tablespace GWS_DATA;

comment on column hper_staff_plans.main_calc_type is 'Bonus amount (W)eight, amount per (U)nit';
comment on column hper_staff_plans.extra_calc_type is 'Bonus amount (W)eight, amount per (U)nit';
comment on column hper_staff_plans.status is '(D)raft, (N)ew, (W)aiting, (C)ompleted';
comment on column hper_staff_plans.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime';

create index hper_staff_plans_i1 on hper_staff_plans(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hper_staff_plans_i2 on hper_staff_plans(company_id, filial_id, journal_page_id) tablespace GWS_INDEX;
create index hper_staff_plans_i3 on hper_staff_plans(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hper_staff_plans_i4 on hper_staff_plans(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hper_staff_plans_i5 on hper_staff_plans(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_staff_plan_items(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  staff_plan_id                   number(20)   not null,
  plan_type_id                    number(20)   not null,
  plan_type                       varchar2(1)  not null,
  plan_value                      number(20,6) not null,
  plan_amount                     number(20,6) not null,
  fact_value                      number(20,6),
  fact_percent                    number(20,6),
  fact_amount                     number(20,6),
  calc_kind                       varchar2(1)  not null,
  note                            varchar2(300 char),
  fact_note                       varchar2(300 char),
  constraint hper_staff_plan_items_pk primary key (company_id, filial_id, staff_plan_id, plan_type_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_items_f1 foreign key (company_id, filial_id, staff_plan_id) references hper_staff_plans(company_id, filial_id, staff_plan_id) on delete cascade,
  constraint hper_staff_plan_items_f2 foreign key (company_id, filial_id, plan_type_id) references hper_plan_types(company_id, filial_id, plan_type_id),
  constraint hper_staff_plan_items_c1 check (plan_type in ('M', 'E')),
  constraint hper_staff_plan_items_c2 check (plan_value > 0),
  constraint hper_staff_plan_items_c3 check (plan_amount > 0),
  constraint hper_staff_plan_items_c4 check (fact_value >= 0),
  constraint hper_staff_plan_items_c5 check (fact_percent >= 0),
  constraint hper_staff_plan_items_c6 check (fact_amount >= 0),
  constraint hper_staff_plan_items_c7 check (calc_kind in ('M', 'T', 'A'))
) tablespace GWS_DATA;

comment on column hper_staff_plan_items.plan_type is '(M)ain, (E)xtra';
comment on column hper_staff_plan_items.plan_amount is 'bonus amount weight or amount per unit';
comment on column hper_staff_plan_items.fact_amount is 'fact percent or unit amount affected by rules';
comment on column hper_staff_plan_items.calc_kind is '(M)anual, (T)ask execution, (A)ttendance estimation';

create index hper_staff_plan_items_i1 on hper_staff_plan_items(company_id, filial_id, plan_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_staff_plan_parts(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  part_id                         number(20)   not null,
  staff_plan_id                   number(20)   not null,
  plan_type_id                    number(20)   not null,
  part_date                       date         not null,
  amount                          number(20,6) not null,
  note                            varchar2(300),
  created_on                      timestamp with local time zone not null,
  created_by                      number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  constraint hper_staff_plan_parts_pk primary key (company_id, filial_id, part_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_parts_u1 unique (part_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_parts_f1 foreign key (company_id, filial_id, staff_plan_id, plan_type_id) references hper_staff_plan_items(company_id, filial_id, staff_plan_id, plan_type_id) on delete cascade,
  constraint hper_staff_plan_parts_c1 check (amount > 0) 
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hper_staff_plan_rules(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_plan_id                   number(20) not null,
  plan_type_id                    number(20) not null,
  from_percent                    number(3)  not null,
  to_percent                      number(3),
  fact_amount                     number(20,6),
  constraint hper_satff_plan_rules_pk primary key (company_id, filial_id, staff_plan_id, plan_type_id, from_percent) using index tablespace GWS_INDEX,
  constraint hper_satff_plan_rules_f1 foreign key (company_id, filial_id, staff_plan_id, plan_type_id) references hper_staff_plan_items(company_id, filial_id, staff_plan_id, plan_type_id) on delete cascade,
  constraint hper_satff_plan_rules_c1 check (from_percent <= to_percent),
  constraint hper_satff_plan_rules_c2 check (from_percent >= 0),
  constraint hper_satff_plan_rules_c3 check (fact_amount >= 0)
) tablespace GWS_DATA;

comment on column hper_staff_plan_rules.fact_amount is 'fact percent or unit amount';

----------------------------------------------------------------------------------------------------
create table hper_staff_plan_task_types(
  company_id                      number(20) not null, 
  filial_id                       number(20) not null,
  staff_plan_id                   number(20) not null,
  plan_type_id                    number(20) not null,
  task_type_id                    number(20) not null,
  constraint hrep_staff_plan_task_types_pk primary key (company_id, filial_id, staff_plan_id, plan_type_id, task_type_id) using index tablespace GWS_INDEX,
  constraint hrep_staff_plan_task_types_f1 foreign key (company_id, filial_id, staff_plan_id, plan_type_id) references hper_staff_plan_items(company_id, filial_id, staff_plan_id, plan_type_id) on delete cascade,
  constraint hrep_staff_plan_task_types_f2 foreign key (company_id, task_type_id) references ms_task_types(company_id, task_type_id)
) tablespace GWS_DATA;

create index hper_satff_plan_task_types_i1 on hper_staff_plan_task_types(company_id, filial_id, task_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hper_staff_plan_tasks(
  company_id                      number(20) not null, 
  filial_id                       number(20) not null,
  staff_plan_id                   number(20) not null,
  plan_type_id                    number(20) not null,
  task_id                         number(20) not null,
  constraint hper_staff_plan_tasks_pk primary key (company_id, filial_id, staff_plan_id, plan_type_id, task_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_tasks_f1 foreign key (company_id, filial_id, staff_plan_id, plan_type_id) references hper_staff_plan_items(company_id, filial_id, staff_plan_id, plan_type_id) on delete cascade,
  constraint hper_staff_plan_tasks_f2 foreign key (company_id, task_id) references ms_tasks(company_id, task_id)
) tablespace GWS_DATA;

create index hper_staff_plan_tasks_i1 on hper_staff_plan_tasks(company_id, filial_id, task_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hper_dirty_plan_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  plan_type_id                    number(20) not null,
  constraint hper_dirty_plan_types_u1 unique(company_id, filial_id, plan_type_id),
  constraint hper_dirty_plan_types_c1 check (plan_type_id is null) deferrable initially deferred             
) on commit delete rows;
