prompt migr 20.11.2021

prompt current tables structure change
---------------------------------------------------------------------------------------------------- 
-- calendar
---------------------------------------------------------------------------------------------------- 
alter table htt_calendar_days rename column day_type to day_kind;
----------------------------------------------------------------------------------------------------
-- schedule
----------------------------------------------------------------------------------------------------
rename htt_schedule_dates to htt_schedule_origin_days;
---------------------------------------------------------------------------------------------------- 
-- remove old contraints
---------------------------------------------------------------------------------------------------- 
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_pk;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_f1;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c1;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c2;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c3;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c4;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c5;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c6;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c7;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c8;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c9;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c10;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c11;
alter table htt_schedule_origin_days drop constraint htt_schedule_dates_c12;
---------------------------------------------------------------------------------------------------- 
-- add contraints new name
---------------------------------------------------------------------------------------------------- 
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_pk primary key (company_id, schedule_id, schedule_date) using index tablespace GWS_INDEX;
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_f1 foreign key (company_id, schedule_id) references htt_schedules(company_id, schedule_id) on delete cascade;
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c1 check (trunc(schedule_date) = schedule_date);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c2 check (day_kind in ('W', 'R'));
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c3 check (break_enabled in ('Y', 'N'));
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0));
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0));
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c7 check (trunc(begin_time) = schedule_date);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c8 check (begin_time < end_time);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c9 check (break_begin_time < break_end_time);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c10 check (begin_time <= break_begin_time and break_end_time <= end_time);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c11 check (shift_begin_time < shift_end_time);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time);

alter index htt_schedule_dates_i1 rename to htt_schedule_origin_days_i1;

----------------------------------------------------------------------------------------------------
-- tracks
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_tracks add track_used varchar2(1);
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c1 check (track_used in ('Y', 'N'));

comment on column htt_timesheet_tracks.track_used is '(Y)es, (N)o. (N)o only when new track is added to locked timesheet.';

----------------------------------------------------------------------------------------------------
alter table htt_tracks add status varchar2(1);
alter table htt_tracks add constraint htt_tracks_c5 check (status in ('D', 'N', 'P', 'U')); 

comment on column htt_tracks.status is '(D)raft, (N)ot used, (P)artially used, (U)sed';

---------------------------------------------------------------------------------------------------- 
-- timesheet
---------------------------------------------------------------------------------------------------- 
-- remove old contraints
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets drop constraint htt_timesheets_c1;
alter table htt_timesheets drop constraint htt_timesheets_c2;
alter table htt_timesheets drop constraint htt_timesheets_c3;
alter table htt_timesheets drop constraint htt_timesheets_c4;
alter table htt_timesheets drop constraint htt_timesheets_c5;
alter table htt_timesheets drop constraint htt_timesheets_c6;
alter table htt_timesheets drop constraint htt_timesheets_c7;
alter table htt_timesheets drop constraint htt_timesheets_c8;
---------------------------------------------------------------------------------------------------- 
-- add new contraints
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets add constraint htt_timesheets_c1 check (trunc(timesheet_date) = timesheet_date);
alter table htt_timesheets add constraint htt_timesheets_c2 check (day_kind in ('W', 'R', 'H', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c3 check (break_enabled in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) 
                                                                   or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0));
alter table htt_timesheets add constraint htt_timesheets_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0));
alter table htt_timesheets add constraint htt_timesheets_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440);
alter table htt_timesheets add constraint htt_timesheets_c7 check (trunc(begin_time) = timesheet_date);
alter table htt_timesheets add constraint htt_timesheets_c8 check (begin_time < end_time);
alter table htt_timesheets add constraint htt_timesheets_c9 check (break_begin_time < break_end_time);
alter table htt_timesheets add constraint htt_timesheets_c10 check (begin_time <= break_begin_time and break_end_time <= end_time);
alter table htt_timesheets add constraint htt_timesheets_c11 check (shift_begin_date < shift_end_date);


comment on column htt_timesheets.day_kind is '(W)ork, (R)est, (H)oliday, (N)onworking';

---------------------------------------------------------------------------------------------------- 
-- timebook
---------------------------------------------------------------------------------------------------- 
-- timebook constraints
----------------------------------------------------------------------------------------------------
alter table hpr_timebooks drop constraint hpr_timebooks_c3;
alter table hpr_timebooks add constraint hpr_timebooks_c3 check (status in ('N', 'C', 'S', 'A', 'R'));

comment on column hpr_timebooks.status is '(N)ew, (C)alculated, (S)ent, (A)ccepted, (R)eturned';
----------------------------------------------------------------------------------------------------
-- temporarily renaming table hpr_timebook_staffs to hpr_timebook_staffs_old
-- new table structure added
----------------------------------------------------------------------------------------------------  
rename hpr_timebook_staffs to hpr_timebook_staffs_old;
---------------------------------------------------------------------------------------------------- 
alter table hpr_timebook_staffs_old rename constraint hpr_timebook_staffs_pk to hpr_timebook_staffs_old_pk;
alter table hpr_timebook_staffs_old rename constraint hpr_timebook_staffs_u1 to hpr_timebook_staffs_old_u1;
alter table hpr_timebook_staffs_old rename constraint hpr_timebook_staffs_u2 to hpr_timebook_staffs_old_u2;
alter table hpr_timebook_staffs_old rename constraint hpr_timebook_staffs_f1 to hpr_timebook_staffs_old_f1;
alter table hpr_timebook_staffs_old rename constraint hpr_timebook_staffs_f2 to hpr_timebook_staffs_old_f2;

alter index hpr_timebook_staffs_pk rename to hpr_timebook_staffs_old_pk;
alter index hpr_timebook_staffs_u1 rename to hpr_timebook_staffs_old_u1;
alter index hpr_timebook_staffs_u2 rename to hpr_timebook_staffs_old_u2;
alter index hpr_timebook_staffs_i1 rename to hpr_timebook_staffs_old_i1;

---------------------------------------------------------------------------------------------------- 
-- temporarily renaming table hpr_timebook_facts to hpr_timebook_facts_old
-- new table structure added
----------------------------------------------------------------------------------------------------  
rename hpr_timebook_facts to hpr_timebook_facts_old;
---------------------------------------------------------------------------------------------------- 
alter table hpr_timebook_facts_old drop constraint hpr_timebook_facts_pk;
alter table hpr_timebook_facts_old drop constraint hpr_timebook_facts_f1;
alter table hpr_timebook_facts_old drop constraint hpr_timebook_facts_f2;
alter table hpr_timebook_facts_old drop constraint hpr_timebook_facts_c1;

drop index hpr_timebook_facts_i1;

---------------------------------------------------------------------------------------------------- 
prompt adding new structures
---------------------------------------------------------------------------------------------------- 
create table htt_schedule_days(
  company_id                      number(20)  not null,
  schedule_id                     number(20)  not null,
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
  constraint htt_schedule_days_pk primary key (company_id, schedule_id, schedule_date) using index tablespace GWS_INDEX,
  constraint htt_schedule_days_f1 foreign key (company_id, schedule_id) references htt_schedules(company_id, schedule_id) on delete cascade,
  constraint htt_schedule_days_c1 check (trunc(schedule_date) = schedule_date),
  constraint htt_schedule_days_c2 check (day_kind in ('W', 'R', 'H', 'N')),
  constraint htt_schedule_days_c3 check (break_enabled in ('Y', 'N')),
  constraint htt_schedule_days_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0) 
                                         or day_kind = 'N' and nvl2(break_enabled, 2, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0)),
  constraint htt_schedule_days_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0)),
  constraint htt_schedule_days_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440),
  constraint htt_schedule_days_c7 check (trunc(begin_time) = schedule_date),
  constraint htt_schedule_days_c8 check (begin_time < end_time),
  constraint htt_schedule_days_c9 check (break_begin_time < break_end_time),
  constraint htt_schedule_days_c10 check (begin_time <= break_begin_time and break_end_time <= end_time),
  constraint htt_schedule_days_c11 check (shift_begin_time < shift_end_time),
  constraint htt_schedule_days_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time)
) tablespace GWS_DATA;

comment on table htt_schedule_days is 'Keeps daily schedule plans';

comment on column htt_schedule_days.day_kind      is '(W)orking day, (R)est day, (H)oliday, (N)onworking';
comment on column htt_schedule_days.break_enabled is '(Y)es, (N)o';
comment on column htt_schedule_days.full_time     is 'measured by minutes';
comment on column htt_schedule_days.plan_time     is 'measured by minutes';

create index htt_schedule_days_i1 on htt_schedule_days(company_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_timesheet_locks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  timesheet_date                  date        not null,
  facts_changed                  varchar2(1) not null,
  constraint htt_timesheet_locks_pk primary key (company_id, filial_id, staff_id, timesheet_date) using index tablespace GWS_INDEX,
  constraint htt_timesheet_locks_f1 foreign key (company_id, filial_id, staff_id, timesheet_date) references htt_timesheets(company_id, filial_id, staff_id, timesheet_date),
  constraint htt_timesheet_locks_c1 check (facts_changed in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_timesheet_locks is 'Timesheet locks. Locked timesheet cannot be changed without removing lock';

----------------------------------------------------------------------------------------------------
create table hpr_timebook_staffs(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  timebook_id                     number(20)   not null,
  staff_id                        number(20)   not null,
  schedule_id                     number(20)   not null,
  job_id                          number(20)   not null,
  division_id                     number(20)   not null,
  plan_days                       number(2)    not null,
  plan_hours                      number(5, 2) not null,
  fact_days                       number(2)    not null,
  fact_hours                      number(5, 2) not null,
  constraint hpr_timebook_staffs_pk primary key (company_id, filial_id, timebook_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_u1 unique (company_id, timebook_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_f1 foreign key (company_id, filial_id, timebook_id) references hpr_timebooks(company_id, filial_id, timebook_id) on delete cascade,
  constraint hpr_timebook_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_timebook_staffs_c1 check (plan_days >= 0 and plan_days <= 31),
  constraint hpr_timebook_staffs_c2 check (fact_days >= 0 and fact_days <= 31),
  constraint hpr_timebook_staffs_c3 check (plan_hours >= 0 and plan_hours <= 744),
  constraint hpr_timebook_staffs_c4 check (fact_hours >= 0 and fact_hours <= 744)
) tablespace GWS_DATA;

comment on table hpr_timebook_staffs is 'Keeps timebook staffs and additional info';

comment on column hpr_timebook_staffs.schedule_id is 'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.job_id is      'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.division_id is 'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.plan_days is   'Working and nonworking days for timebook period';
comment on column hpr_timebook_staffs.plan_hours is  'Plan hours for timebook period';
comment on column hpr_timebook_staffs.fact_days is   'Days with turnout for timebook period';
comment on column hpr_timebook_staffs.fact_hours is  'Turnout time for timebook period';

create index hpr_timebook_staffs_i1 on hpr_timebook_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_facts(
  company_id                      number(20)   not null,
  timebook_id                     number(20)   not null,
  staff_id                        number(20)   not null,
  time_kind_id                    number(20)   not null,
  fact_hours                      number(5, 2) not null,
  constraint hpr_timebook_facts_pk primary key (company_id, timebook_id, staff_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_facts_f1 foreign key (company_id, timebook_id, staff_id) references hpr_timebook_staffs(company_id, timebook_id, staff_id) on delete cascade,
  constraint hpr_timebook_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpr_timebook_facts_c1 check (fact_hours >= 0 and fact_hours <= 744)
) tablespace GWS_DATA;

comment on table hpr_timebook_facts is 'Keeps sum of facts for timebook period';

comment on column hpr_timebook_facts.time_kind_id is 'Only parent time kinds';

create index hpr_timebook_facts_i1 on hpr_timebook_facts(company_id, time_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_parts(
  company_id                      number(20)   not null,
  timebook_id                     number(20)   not null,
  staff_id                        number(20)   not null,
  part_begin                      date         not null,
  part_end                        date         not null,
  plan_days                       number(2)    not null,
  plan_hours                      number(5, 2) not null,
  fact_days                       number(2)    not null,
  fact_hours                      number(5, 2) not null, 
  constraint hpr_timebook_parts_pk primary key (company_id, timebook_id, staff_id, part_begin) using index tablespace GWS_INDEX,
  constraint hpr_timebook_parts_f1 foreign key (company_id, timebook_id, staff_id) references hpr_timebook_staffs(company_id, timebook_id, staff_id)  on delete cascade,
  constraint hpr_timebook_parts_c1 check (plan_days >= 0 and plan_days <= 31),
  constraint hpr_timebook_parts_c2 check (fact_days >= 0 and fact_days <= 31),
  constraint hpr_timebook_parts_c3 check (plan_hours >= 0 and plan_hours <= 744),
  constraint hpr_timebook_parts_c4 check (fact_hours >= 0 and fact_hours <= 744)
) tablespace GWS_DATA;

comment on table hpr_timebook_parts is 'Keeps schedule change parts for timebook period';

comment on column hpr_timebook_parts.plan_days is  'Monthly plan days for particular schedule';
comment on column hpr_timebook_parts.plan_hours is 'Monthly plan hours for particular schedule';
comment on column hpr_timebook_parts.fact_days is  'Days with turnout between part_begin and part_end';
comment on column hpr_timebook_parts.fact_hours is 'Turnout time between part_begin and part_end';

----------------------------------------------------------------------------------------------------
create table hpr_timesheet_locks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  timesheet_date                  date       not null,
  timebook_id                     number(20) not null,
  constraint hpr_timesheet_locks_pk primary key (company_id, filial_id, staff_id, timesheet_date) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_locks_f1 foreign key (company_id, filial_id, staff_id, timesheet_date) references htt_timesheet_locks(company_id, filial_id, staff_id, timesheet_date),
  constraint hpr_timesheet_locks_f2 foreign key (company_id, filial_id, timebook_id) references hpr_timebooks(company_id, filial_id, timebook_id)
) tablespace GWS_DATA;

comment on table hpr_timesheet_locks is 'Extends htt_timesheet_locks table, keeps timesheet locks held by timebooks';

create index hpr_timesheet_locks_i1 on hpr_timesheet_locks(company_id, filial_id, timebook_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt tracks update
---------------------------------------------------------------------------------------------------- 
update Htt_Timesheet_Tracks
   set Track_Used = 'Y';
   
update Htt_Tracks t
   set t.Status = 'D'
 where t.Is_Valid = 'N'
    or not exists (select *
          from Htt_Timesheet_Tracks Tt
         where Tt.Company_Id = t.Company_Id
           and Tt.Filial_Id = t.Filial_Id
           and Tt.Track_Id = t.Track_Id);
           
update Htt_Tracks t
   set t.Status = 'U'
 where t.Status is null;
commit;

prompt set not null tracks fields
---------------------------------------------------------------------------------------------------- 
alter table htt_tracks modify status not null;
alter table htt_timesheet_tracks modify track_used not null;

----------------------------------------------------------------------------------------------------
prompt new table hpd_journal_timeoffs
----------------------------------------------------------------------------------------------------
create table hpd_journal_timeoffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  journal_id                      number(20) not null,
  employee_id                     number(20) not null,
  staff_id                        number(20) not null,
  begin_date                      date       not null,
  end_date                        date       not null,
  constraint hpd_journal_timeoffs_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_timeoffs_u1 unique (timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_timeoffs_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_timeoffs_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_journal_timeoffs_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_journal_timeoffs_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_journal_timeoffs_c2 check (trunc(end_date) = end_date),
  constraint hpd_journal_timeoffs_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_journal_timeoffs_i1 on hpd_journal_timeoffs(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_journal_timeoffs_i2 on hpd_journal_timeoffs(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_journal_timeoffs_i3 on hpd_journal_timeoffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_journal_employees
----------------------------------------------------------------------------------------------------
create table hpd_journal_employees(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  employee_id                     number(20) not null,
  constraint hpd_journal_employees_pk primary key (company_id, filial_id, journal_id, employee_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_employees_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_employees_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id)
) tablespace GWS_DATA;

comment on table hpd_journal_employees is 'Keeps distinct employees in journal';

create index hpd_journal_employees_i1 on hpd_journal_employees(company_id, filial_id, employee_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_timeoff_files
----------------------------------------------------------------------------------------------------
create table hpd_timeoff_files(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  timeoff_id                      number(20)   not null,
  sha                             varchar2(64) not null,
  constraint hpd_timeoff_files_pk primary key (company_id, filial_id, timeoff_id, sha) using index tablespace GWS_INDEX,
  constraint hpd_timeoff_files_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade,
  constraint hpd_timeoff_files_f2 foreign key (sha) references biruni_files(sha)
) tablespace GWS_DATA;

create index hpd_timeoff_files_i1 on hpd_timeoff_files(sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_sick_leaves
----------------------------------------------------------------------------------------------------
create table hpd_sick_leaves(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  timeoff_id                      number(20)         not null,
  reason_id                       number(20)         not null,
  coefficient                     number(7,6)        not null,
  sick_leave_number               varchar2(100 char) not null,
  constraint hpd_sick_leaves_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_sick_leaves_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade,
  constraint hpd_sick_leaves_f2 foreign key (company_id, filial_id, reason_id) references href_sick_leave_reasons(company_id, filial_id, reason_id),
  constraint hpd_sick_leaves_c1 check (decode(trim(sick_leave_number), sick_leave_number, 1, 0) = 1)
) tablespace GWS_DATA;

create index hpd_sick_leaves_i1 on hpd_sick_leaves(company_id, filial_id, reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create sequence hpd_journal_timeoffs_sq;
----------------------------------------------------------------------------------------------------
prompt inserting distinct employeees into Hpd_Journal_Employees
----------------------------------------------------------------------------------------------------
insert all into Hpd_Journal_Employees
  (Company_Id, Filial_Id, Journal_Id, Employee_Id)
values
  (Company_Id, Filial_Id, Journal_Id, Employee_Id)
  select distinct Company_Id, Filial_Id, Journal_Id, Employee_Id
    from Hpd_Journal_Pages;
commit;

----------------------------------------------------------------------------------------------------
declare
  v_Company_Id number;
  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => v_Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Journal types ====');
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;

    Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Id);

    Journal_Type('Больничный лист', 9, Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
  end loop;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt reworking schedules structure
---------------------------------------------------------------------------------------------------- 
-- schedule origin days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_origin_days add filial_id     number(20);
alter table htt_schedule_origin_days add input_border  date;
alter table htt_schedule_origin_days add output_border date;

----------------------------------------------------------------------------------------------------
alter table htt_schedule_origin_days drop constraint htt_schedule_origin_days_c10;

---------------------------------------------------------------------------------------------------- 
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c10 check (begin_time < break_begin_time and break_end_time < end_time);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c13 check (input_border < output_border);
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border);

----------------------------------------------------------------------------------------------------
-- schedule days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_days add filial_id     number(20);
alter table htt_schedule_days add input_border  date;
alter table htt_schedule_days add output_border date;

----------------------------------------------------------------------------------------------------
alter table htt_schedule_days drop constraint htt_schedule_days_c10; 

----------------------------------------------------------------------------------------------------
alter table htt_schedule_days add constraint htt_schedule_days_c10 check (begin_time < break_begin_time and break_end_time < end_time);
alter table htt_schedule_days add constraint htt_schedule_days_c13 check (input_border < output_border);
alter table htt_schedule_days add constraint htt_schedule_days_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border);

----------------------------------------------------------------------------------------------------
-- schedule patterns
----------------------------------------------------------------------------------------------------
alter table htt_schedule_patterns add filial_id number(20);

----------------------------------------------------------------------------------------------------
-- schedule pattern days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_pattern_days add filial_id number(20);

----------------------------------------------------------------------------------------------------
-- schedule
----------------------------------------------------------------------------------------------------
alter table htt_schedules add shift             number(4);
alter table htt_schedules add input_acceptance  number(4);
alter table htt_schedules add output_acceptance number(4);
alter table htt_schedules add track_duration    number(4);
alter table htt_schedules add count_late        varchar2(1);
alter table htt_schedules add count_early       varchar2(1);
alter table htt_schedules add count_lack        varchar2(1);

----------------------------------------------------------------------------------------------------
alter table htt_schedules drop constraint htt_schedules_c2;
alter table htt_schedules drop constraint htt_schedules_c3;
alter table htt_schedules drop constraint htt_schedules_c4;
alter table htt_schedules drop constraint htt_schedules_c5;
alter table htt_schedules drop constraint htt_schedules_c6;
alter table htt_schedules drop constraint htt_schedules_c7;
alter table htt_schedules drop constraint htt_schedules_c8;

----------------------------------------------------------------------------------------------------
alter table htt_schedules add constraint htt_schedules_c2 check (shift between 0 and 1439);
alter table htt_schedules add constraint htt_schedules_c3 check (input_acceptance between 0 and 2160);
alter table htt_schedules add constraint htt_schedules_c4 check (output_acceptance between 0 and 2160);
alter table htt_schedules add constraint htt_schedules_c5 check (track_duration between 0 and 4320);
alter table htt_schedules add constraint htt_schedules_c6 check (count_late in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c7 check (count_early in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c8 check (count_lack in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c9 check (take_holidays in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c10 check (take_nonworking in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c11 check (nvl2(calendar_id, 2, 0) = nvl2(take_holidays, 1, 0) + nvl2(take_nonworking, 1, 0));
alter table htt_schedules add constraint htt_schedules_c12 check (state in ('A', 'P'));

----------------------------------------------------------------------------------------------------
comment on table htt_schedules is 'Keeps staff schedules. Some fields are unchangeable while any staff is attached to schedule';

comment on column htt_schedules.shift             is 'Shifts schedule from default 00:00. Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.input_acceptance  is 'Expands input acceptance border to the left from shift_begin_date. Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.output_acceptance is 'Expands output acceptance border to the right from shift_end_date. Measured in minutes. Unchangeable while any staff attached';          
comment on column htt_schedules.track_duration    is 'Limits the duration of input-output time parts (it shall not exceed track_duration). Measured in minutes. Unchangeable while any staff attached';
comment on column htt_schedules.count_late        is '(Y)es, (N)o. When (N)o attached timesheets will not count late time';
comment on column htt_schedules.count_early       is '(Y)es, (N)o. When (N)o attached timesheets will not count early time';
comment on column htt_schedules.count_lack        is '(Y)es, (N)o. When (N)o attached timesheets will not count lack time';

----------------------------------------------------------------------------------------------------
prompt reworking timesheets structure
----------------------------------------------------------------------------------------------------
-- timesheets
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets add calendar_id      number(20);
alter table htt_timesheets add track_duration   number(4);
alter table htt_timesheets add count_late       varchar2(1);
alter table htt_timesheets add count_early      varchar2(1);
alter table htt_timesheets add count_lack       varchar2(1);
alter table htt_timesheets add shift_begin_time date;
alter table htt_timesheets add shift_end_time   date;
alter table htt_timesheets add input_border     date;
alter table htt_timesheets add output_border    date;

---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets drop constraint htt_timesheets_c7;
alter table htt_timesheets drop constraint htt_timesheets_c10;
alter table htt_timesheets drop constraint htt_timesheets_c11;

----------------------------------------------------------------------------------------------------
alter table htt_timesheets add constraint htt_timesheets_c7 check (trunc(shift_begin_time) = timesheet_date);
alter table htt_timesheets add constraint htt_timesheets_c10 check (begin_time < break_begin_time and break_end_time < end_time);
alter table htt_timesheets add constraint htt_timesheets_c11 check (shift_begin_time < shift_end_time);
alter table htt_timesheets add constraint htt_timesheets_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time);
alter table htt_timesheets add constraint htt_timesheets_c13 check (input_border < output_border);
alter table htt_timesheets add constraint htt_timesheets_c14 check (input_border <= shift_begin_time and shift_end_time <= output_border);
alter table htt_timesheets add constraint htt_timesheets_c15 check (track_duration between 0 and 4320);
alter table htt_timesheets add constraint htt_timesheets_c16 check (count_late in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c17 check (count_early in ('Y', 'N'));
alter table htt_timesheets add constraint htt_timesheets_c18 check (count_lack in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
-- timesheet helpers
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_helpers add shift_begin_time date;
alter table htt_timesheet_helpers add shift_end_time   date;
alter table htt_timesheet_helpers add input_border     date;
alter table htt_timesheet_helpers add output_border    date;


prompt dropping primary and foreign keys of tables connected to schedule
---------------------------------------------------------------------------------------------------- 
-- schedule origin days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_origin_days drop constraint htt_schedule_origin_days_pk;
alter table htt_schedule_origin_days drop constraint htt_schedule_origin_days_f1;

----------------------------------------------------------------------------------------------------
drop index htt_schedule_origin_days_i1;

----------------------------------------------------------------------------------------------------
-- schedule days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_days drop constraint htt_schedule_days_pk;
alter table htt_schedule_days drop constraint htt_schedule_days_f1;

----------------------------------------------------------------------------------------------------
drop index htt_schedule_days_i1;

----------------------------------------------------------------------------------------------------
-- schedule patterns
----------------------------------------------------------------------------------------------------
alter table htt_schedule_patterns drop constraint htt_schedule_patterns_pk;
alter table htt_schedule_patterns drop constraint htt_schedule_patterns_f1;

----------------------------------------------------------------------------------------------------
-- schedule pattern days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_pattern_days drop constraint htt_schedule_pattern_days_pk;
alter table htt_schedule_pattern_days drop constraint htt_schedule_pattern_days_f1;

----------------------------------------------------------------------------------------------------
-- schedule
----------------------------------------------------------------------------------------------------
alter table htt_schedules drop constraint htt_schedules_u2;

----------------------------------------------------------------------------------------------------
update Htt_Schedules s
   set s.Shift             = Nvl(s.Daily_Shift_Time, 0),
       s.Input_Acceptance  = 0,
       s.Output_Acceptance = 0,
       s.Track_Duration    = 1440,
       s.Count_Late        = 'Y',
       s.Count_Early       = 'Y',
       s.Count_Lack        = 'Y'
 where s.Shift_Kind <> 'L';

update Htt_Schedules s
   set (s.Shift, --
        s.Input_Acceptance,
        s.Output_Acceptance,
        s.Track_Duration) =
       (select min(Pd.Begin_Time),
               s.Before_Begin_Time + min(Pd.Begin_Time),
               Greatest(s.After_End_Time - min(Pd.Begin_Time), 0),
               1440 + s.Before_Begin_Time + s.After_End_Time
          from Htt_Schedule_Pattern_Days Pd
         where Pd.Schedule_Id = s.Schedule_Id),
       s.Count_Late = 'Y',
       s.Count_Early = 'Y',
       s.Count_Lack = 'Y'
 where s.Shift_Kind = 'L';

update Htt_Schedule_Origin_Days Od
   set Od.End_Time =
       (select Od.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute')
          from Htt_Schedules s
         where s.Schedule_Id = Od.Schedule_Id
           and Od.End_Time > Od.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'))
 where exists
 (select *
          from Htt_Schedules s
         where s.Schedule_Id = Od.Schedule_Id
           and Od.End_Time > Od.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'));

update Htt_Schedule_Days d
   set d.End_Time =
       (select d.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute')
          from Htt_Schedules s
         where s.Schedule_Id = d.Schedule_Id
           and d.End_Time > d.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'))
 where exists
 (select *
          from Htt_Schedules s
         where s.Schedule_Id = d.Schedule_Id
           and d.End_Time > d.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'));

update Htt_Timesheets t
   set t.End_Time =
       (select t.Timesheet_Date + Numtodsinterval(s.Shift + 1439, 'minute')
          from Htt_Schedules s
         where s.Schedule_Id = t.Schedule_Id
           and t.End_Time > t.Timesheet_Date + Numtodsinterval(s.Shift + 1439, 'minute'))
 where exists
 (select *
          from Htt_Schedules s
         where s.Schedule_Id = t.Schedule_Id
           and t.End_Time > t.Timesheet_Date + Numtodsinterval(s.Shift + 1439, 'minute'));

update Htt_Schedule_Origin_Days Od
   set (Od.Filial_Id, --
        Od.Shift_Begin_Time,
        Od.Shift_End_Time,
        Od.Input_Border,
        Od.Output_Border) =
       (select s.Filial_Id, --
               Od.Schedule_Date + Numtodsinterval(s.Shift, 'minute'),
               Od.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'),
               Od.Schedule_Date + Numtodsinterval(s.Shift - s.Input_Acceptance, 'minute'),
               Od.Schedule_Date + Numtodsinterval(s.Shift + 1439 + s.Output_Acceptance, 'minute')
          from Htt_Schedules s
         where s.Schedule_Id = Od.Schedule_Id);

update Htt_Schedule_Days d
   set (d.Filial_Id, --
        d.Shift_Begin_Time,
        d.Shift_End_Time,
        d.Input_Border,
        d.Output_Border) =
       (select s.Filial_Id, --
               d.Schedule_Date + Numtodsinterval(s.Shift, 'minute'),
               d.Schedule_Date + Numtodsinterval(s.Shift + 1439, 'minute'),
               d.Schedule_Date + Numtodsinterval(s.Shift - s.Input_Acceptance, 'minute'),
               d.Schedule_Date + Numtodsinterval(s.Shift + 1439 + s.Output_Acceptance, 'minute')
          from Htt_Schedules s
         where s.Schedule_Id = d.Schedule_Id);

update Htt_Schedule_Patterns p
   set p.Filial_Id =
       (select s.Filial_Id
          from Htt_Schedules s
         where s.Schedule_Id = p.Schedule_Id);

update Htt_Schedule_Pattern_Days Pd
   set Pd.Filial_Id =
       (select s.Filial_Id
          from Htt_Schedules s
         where s.Schedule_Id = Pd.Schedule_Id);

update Htt_Timesheets t
   set (t.Calendar_Id, --
        t.Track_Duration,
        t.Count_Late,
        t.Count_Early,
        t.Count_Lack) =
       (select s.Calendar_Id, --
               s.Track_Duration,
               s.Count_Late,
               s.Count_Early,
               s.Count_Lack
          from Htt_Schedules s
         where s.Company_Id = t.Company_Id
           and s.Filial_Id = t.Filial_Id
           and s.Schedule_Id = t.Schedule_Id),
       (t.Shift_Begin_Time, --
        t.Shift_End_Time,
        t.Input_Border,
        t.Output_Border) =
       (select d.Shift_Begin_Time, --
               d.Shift_End_Time,
               d.Input_Border,
               d.Output_Border
          from Htt_Schedule_Origin_Days d
         where d.Company_Id = t.Company_Id
           and d.Filial_Id = t.Filial_Id
           and d.Schedule_Id = t.Schedule_Id
           and d.Schedule_Date = t.Timesheet_Date);

update Htt_Timesheet_Helpers Th
   set (Th.Shift_Begin_Time, --
        Th.Shift_End_Time,
        Th.Input_Border,
        Th.Output_Border) =
       (select t.Shift_Begin_Time, --
               t.Shift_End_Time,
               t.Input_Border,
               t.Output_Border
          from Htt_Timesheets t
         where t.Company_Id = Th.Company_Id
           and t.Filial_Id = Th.Filial_Id
           and t.Timesheet_Id = Th.Timesheet_Id);
commit;

----------------------------------------------------------------------------------------------------
prompt adding primary and foreign keys of tables connected to schedule 
----------------------------------------------------------------------------------------------------
-- schedule origin days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_pk primary key (company_id, filial_id, schedule_id, schedule_date) using index tablespace GWS_INDEX;
alter table htt_schedule_origin_days add constraint htt_schedule_origin_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade;

----------------------------------------------------------------------------------------------------
create index htt_schedule_origin_days_i1 on htt_schedule_origin_days(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- schedule days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_days add constraint htt_schedule_days_pk primary key (company_id, filial_id, schedule_id, schedule_date) using index tablespace GWS_INDEX;
alter table htt_schedule_days add constraint htt_schedule_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade;

----------------------------------------------------------------------------------------------------
create index htt_schedule_days_i1 on htt_schedule_days(company_id, filial_id, schedule_id, extract(year from schedule_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- schedule patterns
----------------------------------------------------------------------------------------------------
alter table htt_schedule_patterns add constraint htt_schedule_patterns_pk primary key (company_id, filial_id, schedule_id) using index tablespace GWS_INDEX;
alter table htt_schedule_patterns add constraint htt_schedule_patterns_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade;

----------------------------------------------------------------------------------------------------
-- schedule pattern days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_pattern_days add constraint htt_schedule_pattern_days_pk primary key (company_id, filial_id, schedule_id, day_no) using index tablespace GWS_INDEX;
alter table htt_schedule_pattern_days add constraint htt_schedule_pattern_days_f1 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id) on delete cascade;

---------------------------------------------------------------------------------------------------- 
-- timesheets
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets add constraint htt_timesheets_f4 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id);

---------------------------------------------------------------------------------------------------- 
create index htt_timesheets_i3 on htt_timesheets(company_id, filial_id, calendar_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
prompt renaming schedule unique indexes
----------------------------------------------------------------------------------------------------
alter index htt_schedules_u3 rename to htt_schedules_u2;
alter index htt_schedules_u4 rename to htt_schedules_u3;

---------------------------------------------------------------------------------------------------- 
prompt set not null to new columns
---------------------------------------------------------------------------------------------------- 
-- schedule origin days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_origin_days modify filial_id     not null;
alter table htt_schedule_origin_days modify input_border  not null;
alter table htt_schedule_origin_days modify output_border not null;

----------------------------------------------------------------------------------------------------
-- schedule days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_days modify filial_id     not null;
alter table htt_schedule_days modify input_border  not null;
alter table htt_schedule_days modify output_border not null;

----------------------------------------------------------------------------------------------------
-- schedule patterns
----------------------------------------------------------------------------------------------------
alter table htt_schedule_patterns modify filial_id not null;

----------------------------------------------------------------------------------------------------
-- schedule pattern days
----------------------------------------------------------------------------------------------------
alter table htt_schedule_pattern_days modify filial_id not null;

----------------------------------------------------------------------------------------------------
-- schedule
----------------------------------------------------------------------------------------------------
alter table htt_schedules modify shift             not null;
alter table htt_schedules modify input_acceptance  not null;
alter table htt_schedules modify output_acceptance not null;
alter table htt_schedules modify track_duration    not null;
alter table htt_schedules modify count_late        not null;
alter table htt_schedules modify count_early       not null;
alter table htt_schedules modify count_lack        not null;

----------------------------------------------------------------------------------------------------
-- timesheets
----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify track_duration   not null;
alter table htt_timesheets modify count_late       not null;
alter table htt_timesheets modify count_early      not null;
alter table htt_timesheets modify count_lack       not null;
alter table htt_timesheets modify shift_begin_time not null;
alter table htt_timesheets modify shift_end_time   not null;
alter table htt_timesheets modify input_border     not null;
alter table htt_timesheets modify output_border    not null;

----------------------------------------------------------------------------------------------------
-- timesheet helpers
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_helpers modify shift_begin_time not null;
alter table htt_timesheet_helpers modify shift_end_time   not null;
alter table htt_timesheet_helpers modify input_border     not null;
alter table htt_timesheet_helpers modify output_border    not null;

----------------------------------------------------------------------------------------------------
prompt dropping unused columns
----------------------------------------------------------------------------------------------------
-- schedule
----------------------------------------------------------------------------------------------------
alter table htt_schedules drop column shift_kind;
alter table htt_schedules drop column daily_shift_time;
alter table htt_schedules drop column before_begin_time;
alter table htt_schedules drop column after_end_time;

----------------------------------------------------------------------------------------------------
-- timesheets
---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets drop column shift_begin_date;
alter table htt_timesheets drop column shift_end_date;

----------------------------------------------------------------------------------------------------
-- timesheet helpers
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_helpers drop column shift_begin_date;
alter table htt_timesheet_helpers drop column shift_end_date;

---------------------------------------------------------------------------------------------------- 
prompt adding changes to indicators
----------------------------------------------------------------------------------------------------
alter table hpr_indicators drop constraint hpr_indicators_c4;

update Hpr_Indicators p
   set p.Used = 'A'
 where p.Used is null;
 
insert into Hpd_Page_Indicators
  select p.Company_Id, --
         p.Filial_Id,
         p.Page_Id,
         p.Oper_Type_Id,
         Op.Indicator_Id,
         1
    from Hpr_Oper_Type_Indicators Op
    join Hpr_Indicators q
      on q.Company_Id = Op.Company_Id
     and q.Indicator_Id = Op.Indicator_Id
     and q.Used = 'O'
    join Hpd_Page_Indicators p
      on p.Company_Id = Op.Company_Id
     and p.Oper_Type_Id = Op.Oper_Type_Id;

insert into Hpd_Line_Trans_Indicators
  select p.Company_Id, --
         p.Filial_Id,
         p.Line_Trans_Id,
         p.Oper_Type_Id,
         Op.Indicator_Id,
         1
    from Hpr_Oper_Type_Indicators Op
    join Hpr_Indicators q
      on q.Company_Id = Op.Company_Id
     and q.Indicator_Id = Op.Indicator_Id
     and q.Used = 'O'
    join Hpd_Line_Trans_Indicators p
      on p.Company_Id = Op.Company_Id
     and p.Oper_Type_Id = Op.Oper_Type_Id;

insert into Hrm_Pos_Indicators
  select p.Company_Id, --
         p.Filial_Id,
         p.Position_Id,
         p.Oper_Type_Id,
         Op.Indicator_Id,
         1
    from Hpr_Oper_Type_Indicators Op
    join Hpr_Indicators q
      on q.Company_Id = Op.Company_Id
     and q.Indicator_Id = Op.Indicator_Id
     and q.Used = 'O'
    join Hrm_Pos_Indicators p
      on p.Company_Id = Op.Company_Id
     and p.Oper_Type_Id = Op.Oper_Type_Id;

insert into Hrm_Staff_Indicators
  select p.Company_Id, --
         p.Filial_Id,
         p.Staff_Position_Id,
         p.Oper_Type_Id,
         Op.Indicator_Id,
         1
    from Hpr_Oper_Type_Indicators Op
    join Hpr_Indicators q
      on q.Company_Id = Op.Company_Id
     and q.Indicator_Id = Op.Indicator_Id
     and q.Used = 'O'
    join Hrm_Staff_Indicators p
      on p.Company_Id = Op.Company_Id
     and p.Oper_Type_Id = Op.Oper_Type_Id;
 
update Hpr_Indicators p
   set p.Used = 'C'
 where p.Used = 'O';
 
update Md_Table_Record_Translate_Settings Ts
   set Ts.Table_Name = 'HREF_INDICATORS'
 where Ts.Table_Name = 'HPR_INDICATORS';
commit;

alter table hpr_indicators modify used not null;
alter table hpr_indicators add constraint hpr_indicators_c4 check (used in ('C', 'A'));

comment on column hpr_indicators.used is '(C)onstantly, (A)utomatically';

----------------------------------------------------------------------------------------------------
prompt moving indicators table to href module
----------------------------------------------------------------------------------------------------
rename hpr_indicators to href_indicators;

---------------------------------------------------------------------------------------------------- 
alter table href_indicators rename constraint hpr_indicators_pk to href_indicators_pk;
alter table href_indicators rename constraint hpr_indicators_u1 to href_indicators_u1;
alter table href_indicators rename constraint hpr_indicators_f1 to href_indicators_f1;
alter table href_indicators rename constraint hpr_indicators_f2 to href_indicators_f2;
alter table href_indicators rename constraint hpr_indicators_c1 to href_indicators_c1;
alter table href_indicators rename constraint hpr_indicators_c2 to href_indicators_c2;
alter table href_indicators rename constraint hpr_indicators_c3 to href_indicators_c3;
alter table href_indicators rename constraint hpr_indicators_c4 to href_indicators_c4;
alter table href_indicators rename constraint hpr_indicators_c5 to href_indicators_c5;

----------------------------------------------------------------------------------------------------
alter index hpr_indicators_pk rename to href_indicators_pk;
alter index hpr_indicators_u1 rename to href_indicators_u1;
alter index hpr_indicators_u2 rename to href_indicators_u2;
alter index hpr_indicators_i1 rename to href_indicators_i1;
alter index hpr_indicators_i2 rename to href_indicators_i2;
alter index hpr_indicators_i3 rename to href_indicators_i3;

----------------------------------------------------------------------------------------------------
rename hpr_indicators_sq to href_indicators_sq;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt');
exec fazo_z.run('hpr');

exec fazo_z.compile_invalid_objects;
---------------------------------------------------------------------------------------------------- 

prompt generate schedule dates and timesheets
---------------------------------------------------------------------------------------------------- 
declare
  v_Dates            Array_Date;
  r_Closest_Schedule Hpd_Line_Trans_Schedules%rowtype;
begin
  Biruni_Route.Context_Begin;

  for r in (select t.*
              from Htt_Schedules t)
  loop
    select Od.Schedule_Date
      bulk collect
      into v_Dates
      from Htt_Schedule_Origin_Days Od
     where Od.Company_Id = r.Company_Id
       and Od.Filial_Id = r.Filial_Id
       and Od.Schedule_Id = r.Schedule_Id;
  
    Htt_Core.Gen_Schedule_Days(i_Company_Id  => r.Company_Id,
                               i_Filial_Id   => r.Filial_Id,
                               i_Schedule_Id => r.Schedule_Id,
                               p_Dates       => v_Dates);
  end loop;

  -- parts are taken same way as in htt_core.gen_timesheet_plan_function
  for r in (with Parts as
               (select t.*
                 from Hpd_Staff_Line_Transactions t
                where t.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
                  and t.Valid_Trans = 'Y'
                  and (t.End_Date is null or t.End_Date >= sysdate))
              select Ap.Company_Id,
                     Ap.Filial_Id,
                     Ap.Staff_Id,
                     Ap.Start_Date Part_Begin,
                     Lead(Ap.Start_Date) --
                     Over(partition by Ap.Staff_Id order by Ap.Start_Date) - 1 Part_End
                from (select q.Company_Id,
                             q.Filial_Id,
                             q.Staff_Id,
                             Greatest(q.Begin_Date, sysdate) Start_Date
                        from Parts q
                      union
                      select p.Company_Id, p.Filial_Id, p.Staff_Id, p.End_Date + 1
                        from Parts p
                       where p.End_Date is not null) Ap)
  loop
    r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => r.Company_Id,
                                                    i_Filial_Id  => r.Filial_Id,
                                                    i_Staff_Id   => r.Staff_Id,
                                                    i_Period     => r.Part_Begin);
  
    Htt_Core.Regenerate_Timesheets(i_Company_Id  => r.Company_Id,
                                   i_Filial_Id   => r.Filial_Id,
                                   i_Staff_Id    => r.Staff_Id,
                                   i_Schedule_Id => r_Closest_Schedule.Schedule_Id,
                                   i_Begin_Date  => r.Part_Begin,
                                   i_End_Date    => r.Part_End);
  end loop;

  Biruni_Route.Context_End;
  commit;
end;
/

prompt generate timebooks data
---------------------------------------------------------------------------------------------------- 
declare
begin
  for r in (select *
              from Hpr_Timebooks t)
  loop
    for St in (select So.Staff_Id
                 from Hpr_Timebook_Staffs_Old So
                where So.Company_Id = r.Company_Id
                  and So.Filial_Id = r.Filial_Id
                  and So.Timebook_Id = r.Timebook_Id)
    loop
      Hpr_Core.Timebook_Staff_Insert(i_Company_Id  => r.Company_Id,
                                     i_Filial_Id   => r.Filial_Id,
                                     i_Timebook_Id => r.Timebook_Id,
                                     i_Division_Id => r.Division_Id,
                                     i_Staff_Id    => St.Staff_Id,
                                     i_Month       => r.Month);
    end loop;
  
    if r.Status in (Hpr_Pref.c_Timebook_Status_Sent, Hpr_Pref.c_Timebook_Status_Accepted) then
      Hpr_Core.Lock_Timesheets(i_Company_Id  => r.Company_Id,
                               i_Filial_Id   => r.Filial_Id,
                               i_Timebook_Id => r.Timebook_Id,
                               i_Month       => r.Month);
    
    end if;
  end loop;

  commit;
end;
/

prompt remove timesheet gen job
---------------------------------------------------------------------------------------------------- 
delete from Biruni_Job_Daily_Procedures t
 where Regexp_Like(t.Procedure_Name, '^(htt_core)\.', 'i');
commit;

prompt drop hpr tables
---------------------------------------------------------------------------------------------------- 
drop table hpr_timebook_facts_old;
drop table hpr_timebook_dates;
drop table hpr_timebook_schedules;
drop table hpr_timebook_staffs_old;

drop table hpr_timebook_locks;

prompt drop hpr sequences
----------------------------------------------------------------------------------------------------
drop sequence hpr_timebook_staffs_sq;
drop sequence hpr_timebook_schedules_sq;
drop sequence hpr_timebook_dates_sq;



