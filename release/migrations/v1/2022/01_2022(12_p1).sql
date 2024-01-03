prompt migr from 12.01.2022
---------------------------------------------------------------------------------------------------- 
prompt htt_tracks indexes fix
---------------------------------------------------------------------------------------------------- 
drop index htt_tracks_i3;
drop index htt_tracks_i4;
drop index htt_tracks_i5;

create index htt_tracks_i3 on htt_tracks(company_id, filial_id, person_id, track_date, track_datetime) tablespace GWS_INDEX;
create index htt_tracks_i4 on htt_tracks(photo_sha) tablespace GWS_INDEX;
create index htt_tracks_i5 on htt_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_tracks_i6 on htt_tracks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt hper_plan_type_task_types index fix
----------------------------------------------------------------------------------------------------
drop index hper_plan_type_task_types_i1;
create index hper_plan_type_task_types_i1 on hper_plan_type_task_types(company_id, task_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt htt_request_kinds annual_day_limit constraint fix
----------------------------------------------------------------------------------------------------
alter table htt_request_kinds drop constraint htt_request_kinds_c8;
alter table htt_request_kinds add constraint htt_request_kinds_c8 check (annual_day_limit between 0 and 366);

----------------------------------------------------------------------------------------------------
prompt new table hpd_lock_intervals
----------------------------------------------------------------------------------------------------
create table hpd_lock_intervals(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  interval_id                     number(20)  not null,
  staff_id                        number(20)  not null,
  begin_date                      date        not null,
  end_date                        date        not null,
  kind                            varchar2(1) not null,
  constraint hpd_lock_intervals_pk primary key (company_id, filial_id, interval_id) using index tablespace GWS_INDEX,
  constraint hpd_lock_intervals_u1 unique (interval_id) using index tablespace GWS_INDEX,
  constraint hpd_lock_intervals_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_lock_intervals_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_lock_intervals_c2 check (trunc(end_date) = end_date),
  constraint hpd_lock_intervals_c3 check (begin_date <= end_date),
  constraint hpd_lock_intervals_c4 check (kind in ('T', 'O', 'P'))
) tablespace GWS_DATA;

comment on column hpd_lock_intervals.kind is '(T)imebook, Time(O)ff, (P)erformance';

create index hpd_lock_intervals_i1 on hpd_lock_intervals(company_id, filial_id, staff_id, kind) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_timeoff_intervals
----------------------------------------------------------------------------------------------------
create table hpd_timeoff_intervals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  interval_id                     number(20) not null,
  constraint hpd_timeoff_intervals_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_timeoff_intervals_u1 unique (company_id, filial_id, interval_id) using index tablespace GWS_INDEX,
  constraint hpd_timeoff_intervals_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id),
  constraint hpd_timeoff_intervals_f2 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id)
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
prompt changes in hpr_timebooks
----------------------------------------------------------------------------------------------------
alter table hpr_timebooks add posted varchar2(1);
alter table hpr_timebooks drop constraint hpr_timebooks_c3;
alter table hpr_timebooks add constraint hpr_timebooks_c3 check (posted in ('Y', 'N'));

update Hpr_Timebooks q
   set q.Posted = 'N';
update Hpr_Timebooks q
   set q.Posted = 'Y'
 where q.Status in ('C', 'S', 'A');
commit;

alter table hpr_timebooks modify posted not null;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_timebook_facts
----------------------------------------------------------------------------------------------------
alter table hpr_timebook_facts add filial_id number(20);
update Hpr_Timebook_Facts q
   set q.Filial_Id =
       (select w.Filial_Id
          from Hpr_Timebook_Staffs w
         where w.Company_Id = q.Company_Id
           and w.Timebook_Id = q.Timebook_Id
           and w.Staff_Id = q.Staff_Id);

alter table hpr_timebook_facts modify filial_id not null;

alter table hpr_timebook_facts drop constraint hpr_timebook_facts_f1;
alter table hpr_timebook_facts drop constraint hpr_timebook_facts_pk;

alter table hpr_timebook_facts add constraint hpr_timebook_facts_pk primary key (company_id, filial_id, timebook_id, staff_id, time_kind_id) using index tablespace GWS_INDEX;
alter table hpr_timebook_facts add constraint hpr_timebook_facts_f1 foreign key (company_id, filial_id, timebook_id, staff_id) references hpr_timebook_staffs(company_id, filial_id, timebook_id, staff_id) on delete cascade;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_timebook_parts
----------------------------------------------------------------------------------------------------
alter table hpr_timebook_parts drop constraint hpr_timebook_parts_f1;
alter table hpr_timebook_parts drop constraint hpr_timebook_parts_pk;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_timebook_staffs
----------------------------------------------------------------------------------------------------
alter table hpr_timebook_staffs drop constraint hpr_timebook_staffs_u1;

----------------------------------------------------------------------------------------------------
prompt new table hpr_timebook_intervals
----------------------------------------------------------------------------------------------------
create table hpr_timebook_intervals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timebook_id                     number(20) not null,
  staff_id                        number(20) not null,
  interval_id                     number(20) not null,
  constraint hpr_timebook_intervals_pk primary key (company_id, filial_id, timebook_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_intervals_u1 unique (company_id, filial_id, interval_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_intervals_f1 foreign key (company_id, filial_id, timebook_id, staff_id) references hpr_timebook_staffs(company_id, filial_id, timebook_id, staff_id),
  constraint hpr_timebook_intervals_f2 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt new table hpr_charges
----------------------------------------------------------------------------------------------------
create table hpr_charges(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  charge_id                       number(20)   not null,
  interval_id                     number(20)   not null,
  begin_date                      date         not null,
  end_date                        date         not null,
  oper_type_id                    number(20)   not null,
  amount                          number(20,6) not null,
  division_id                     number(20)   not null,
  schedule_id                     number(20)   not null,
  job_id                          number(20)   not null,
  rank_id                         number(20),
  position_id                     number(20),
  status                          varchar2(1)  not null,
  constraint hpr_charges_pk primary key (company_id, filial_id, charge_id) using index tablespace GWS_INDEX,
  constraint hpr_charges_u1 unique (charge_id) using index tablespace GWS_INDEX,
  constraint hpr_charges_f1 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id) on delete cascade,
  constraint hpr_charges_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id),
  constraint hpr_charges_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_charges_f4 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_charges_f5 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_charges_f6 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hpr_charges_f7 foreign key (company_id, filial_id, position_id) references hrm_positions(company_id, filial_id, position_id),
  constraint hpr_charges_c1 check (trunc(begin_date) = begin_date),
  constraint hpr_charges_c2 check (trunc(end_date) = end_date),
  constraint hpr_charges_c3 check (begin_date <= end_date),
  constraint hpr_charges_c4 check (status in ('N', 'U', 'C'))
) tablespace GWS_DATA;

comment on table hpr_charges is 'Keeps staff''s schedule, job, schedule change parts in each month between interval''s begin_date and end_date';

comment on column hpr_charges.oper_type_id is 'If Interval kind is Timebook, closest transation''s oper types. If Interval kind is Timeoff, system created oper type depends on journal type(sick leave)';
comment on column hpr_charges.division_id  is 'For filtering purpose';
comment on column hpr_charges.schedule_id  is 'Cache field';
comment on column hpr_charges.job_id       is 'Cache field';
comment on column hpr_charges.rank_id      is 'Cache field';
comment on column hpr_charges.position_id  is 'Cache field';
comment on column hpr_charges.status       is '(N)ew, (U)sed, (C)ompleted';

create index hpr_charges_i1 on hpr_charges(company_id, filial_id, interval_id) tablespace GWS_INDEX;
create index hpr_charges_i2 on hpr_charges(company_id, oper_type_id) tablespace GWS_INDEX;
create index hpr_charges_i3 on hpr_charges(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_charges_i4 on hpr_charges(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_charges_i5 on hpr_charges(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_charges_i6 on hpr_charges(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpr_charges_i7 on hpr_charges(company_id, filial_id, position_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpr_charge_indicators
----------------------------------------------------------------------------------------------------
create table hpr_charge_indicators(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  charge_id                       number(20)    not null,
  indicator_id                    number(20)    not null,
  indicator_value                 number(20, 6) not null,
  constraint hpr_charge_indicators_pk primary key (company_id, filial_id, charge_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpr_charge_indicators_f1 foreign key (company_id, filial_id, charge_id) references hpr_charges(company_id, filial_id, charge_id) on delete cascade,
  constraint hpr_charge_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpr_charge_indicators_i1 on hpr_charge_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt oper type changes
----------------------------------------------------------------------------------------------------
drop index hpr_oper_groups_i1;
create unique index hpr_oper_groups_u2 on hpr_oper_groups(company_id, pcode) tablespace GWS_INDEX;

alter table hpr_oper_types add pcode varchar2(20);
create unique index hpr_oper_types_u1 on hpr_oper_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_book_types
----------------------------------------------------------------------------------------------------
drop index hpr_book_types_i1;
create unique index hpr_book_types_u2 on hpr_book_types(company_id, pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in hpr_book_operations
----------------------------------------------------------------------------------------------------
alter table hpr_book_operations drop constraint hpr_book_operations_f2;
alter table hpr_book_operations drop constraint hpr_book_operations_f3;

alter table hpr_book_operations add charge_id number(20);
alter table hpr_book_operations add constraint hpr_book_operations_f2 foreign key (company_id, filial_id, book_id, operation_id) references mpr_book_operations(company_id, filial_id, book_id, operation_id) on delete cascade;
alter table hpr_book_operations add constraint hpr_book_operations_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);
alter table hpr_book_operations add constraint hpr_book_operations_f4 foreign key (company_id, filial_id, charge_id) references hpr_charges(company_id, filial_id, charge_id);

create index hpr_book_operations_i2 on hpr_book_operations(company_id, filial_id, charge_id) tablespace GWS_INDEX;

alter table hpr_book_operations modify part_begin null;
alter table hpr_book_operations modify part_end null;

----------------------------------------------------------------------------------------------------
prompt renaming hpd_page_indicators to hpd_page_indicators_old
----------------------------------------------------------------------------------------------------
rename hpd_page_indicators to hpd_page_indicators_old;

alter table hpd_page_indicators_old rename constraint hpd_page_indicators_pk to hpd_page_indicators_pk_old;
alter table hpd_page_indicators_old rename constraint hpd_page_indicators_f1 to hpd_page_indicators_f1_old;
alter table hpd_page_indicators_old rename constraint hpd_page_indicators_f2 to hpd_page_indicators_f2_old;

alter index hpd_page_indicators_i1 rename to hpd_page_indicators_i1_old;
alter index hpd_page_indicators_pk rename to hpd_page_indicators_pk_old;

----------------------------------------------------------------------------------------------------
prompt renaming hpd_line_trans_indicators to hpd_line_trans_indicators_old
----------------------------------------------------------------------------------------------------
rename hpd_line_trans_indicators to hpd_line_trans_indicators_old;

alter table hpd_line_trans_indicators_old rename constraint hpd_line_trans_indicators_pk to hpd_line_trans_indicators_pk_old;
alter table hpd_line_trans_indicators_old rename constraint hpd_line_trans_indicators_f1 to hpd_line_trans_indicators_f1_old;
alter table hpd_line_trans_indicators_old rename constraint hpd_line_trans_indicators_f2 to hpd_line_trans_indicators_f2_old;

alter index hpd_line_trans_indicators_i1 rename to hpd_line_trans_indicators_i1_old;
alter index hpd_line_trans_indicators_pk rename to hpd_line_trans_indicators_pk_old;

----------------------------------------------------------------------------------------------------
prompt new table hpd_page_indicators
----------------------------------------------------------------------------------------------------
create table hpd_page_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hpd_page_indicators_pk primary key (company_id, filial_id, page_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_page_indicators_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_page_indicators_i1 on hpd_page_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_page_indicators
----------------------------------------------------------------------------------------------------
create table hpd_oper_type_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  oper_type_id                    number(20) not null,
  indicator_id                    number(20) not null,
  constraint hpd_oper_type_indicators_pk primary key (company_id, filial_id, page_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_oper_type_indicators_f1 foreign key (company_id, filial_id, page_id, oper_type_id) references hpd_page_oper_types(company_id, filial_id, page_id, oper_type_id) on delete cascade,
  constraint hpd_oper_type_indicators_f2 foreign key (company_id, filial_id, page_id, indicator_id) references hpd_page_indicators(company_id, filial_id, page_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_oper_type_indicators_i1 on hpd_oper_type_indicators(company_id, filial_id, page_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_line_trans_indicators
----------------------------------------------------------------------------------------------------
create table hpd_line_trans_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  line_trans_id                   number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hpd_line_trans_indicators_pk primary key (company_id, filial_id, line_trans_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_line_trans_indicators_f1 foreign key (company_id, filial_id, line_trans_id) references hpd_staff_line_transactions(company_id, filial_id, line_trans_id),
  constraint hpd_line_trans_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_line_trans_indicators_i1 on hpd_line_trans_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_line_oper_type_indicators
----------------------------------------------------------------------------------------------------
create table hpd_line_oper_type_indicators(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  line_trans_id                   number(20) not null,
  oper_type_id                    number(20) not null,
  indicator_id                    number(20) not null,
  constraint hpd_line_oper_type_indicators_pk primary key (company_id, filial_id, line_trans_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpd_line_oper_type_indicators_f1 foreign key (company_id, filial_id, line_trans_id, oper_type_id) references hpd_line_trans_oper_types(company_id, filial_id, line_trans_id, oper_type_id),
  constraint hpd_line_oper_type_indicators_f2 foreign key (company_id, filial_id, line_trans_id, indicator_id) references hpd_line_trans_indicators(company_id, filial_id, line_trans_id, indicator_id)
) tablespace GWS_DATA;

create index hpd_line_oper_type_indicators_i1 on hpd_line_oper_type_indicators(company_id, filial_id, line_trans_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt inserting old data
----------------------------------------------------------------------------------------------------
insert into Hpd_Page_Indicators
  (Company_Id, Filial_Id, Page_Id, Indicator_Id, Indicator_Value)
  select distinct q.Company_Id, q.Filial_Id, q.Page_Id, q.Indicator_Id, q.Indicator_Value
    from (select q.Company_Id,
                 q.Filial_Id,
                 q.Page_Id,
                 q.Indicator_Id,
                 (select w.Indicator_Value
                    from Hpd_Page_Indicators_Old w
                   where w.Company_Id = q.Company_Id
                     and w.Filial_Id = q.Filial_Id
                     and w.Page_Id = q.Page_Id
                     and w.Indicator_Id = q.Indicator_Id
                   order by q.Indicator_Value desc
                   fetch first row only) as Indicator_Value
            from Hpd_Page_Indicators_Old q) q;

insert into Hpd_Oper_Type_Indicators
  (Company_Id, Filial_Id, Page_Id, Oper_Type_Id, Indicator_Id)
  select q.Company_Id, q.Filial_Id, q.Page_Id, q.Oper_Type_Id, q.Indicator_Id
    from Hpd_Page_Indicators_Old q;

insert into Hpd_Line_Trans_Indicators
  (Company_Id, Filial_Id, Line_Trans_Id, Indicator_Id, Indicator_Value)
  select distinct q.Company_Id, q.Filial_Id, q.Line_Trans_Id, q.Indicator_Id, q.Indicator_Value
    from (select q.Company_Id,
                 q.Filial_Id,
                 q.Line_Trans_Id,
                 q.Indicator_Id,
                 (select w.Indicator_Value
                    from Hpd_Line_Trans_Indicators_Old w
                   where w.Company_Id = q.Company_Id
                     and w.Filial_Id = q.Filial_Id
                     and w.Line_Trans_Id = q.Line_Trans_Id
                     and w.Indicator_Id = q.Indicator_Id
                   order by q.Indicator_Value desc
                   fetch first row only) as Indicator_Value
            from Hpd_Line_Trans_Indicators_Old q) q;

insert into Hpd_Line_Oper_Type_Indicators
  (Company_Id, Filial_Id, Line_Trans_Id, Oper_Type_Id, Indicator_Id)
  select q.Company_Id, q.Filial_Id, q.Line_Trans_Id, q.Oper_Type_Id, q.Indicator_Id
    from Hpd_Line_Trans_Indicators_Old q;
commit;

----------------------------------------------------------------------------------------------------
prompt new table hper_staff_plan_intervals
----------------------------------------------------------------------------------------------------
create table hper_staff_plan_intervals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_plan_id                   number(20) not null,
  interval_id                     number(20) not null,
  constraint hper_staff_plan_intervals_pk primary key (company_id, filial_id, staff_plan_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_intervals_u1 unique (company_id, filial_id, interval_id) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_intervals_f1 foreign key (company_id, filial_id, staff_plan_id) references hper_staff_plans(company_id, filial_id, staff_plan_id),
  constraint hper_staff_plan_intervals_f2 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt href_sick_leave_reasons structural changes
----------------------------------------------------------------------------------------------------
drop index href_sick_leave_reasons_u2;
create unique index href_sick_leave_reasons_u2 on href_sick_leave_reasons(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

alter table href_sick_leave_reasons drop constraint href_sick_leave_reasons_c4;
alter table href_sick_leave_reasons drop constraint href_sick_leave_reasons_c6;

alter table href_sick_leave_reasons add constraint href_sick_leave_reasons_c3 check (coefficient between 0 and 1);
alter table href_sick_leave_reasons add constraint href_sick_leave_reasons_c4 check (state in ('A', 'P'));

----------------------------------------------------------------------------------------------------
prompt new table href_business_trip_reasons
----------------------------------------------------------------------------------------------------
create table href_business_trip_reasons(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  reason_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_business_trip_reasons_pk primary key (company_id, filial_id, reason_id) using index tablespace GWS_INDEX,
  constraint href_business_trip_reasons_u1 unique (reason_id) using index tablespace GWS_INDEX,
  constraint href_business_trip_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_business_trip_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_business_trip_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_business_trip_reasons_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_business_trip_reasons_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_business_trip_reasons.state is '(A)ctive, (P)assive';

create unique index href_business_trip_reasons_u2 on href_business_trip_reasons(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

create index href_business_trip_reasons_i1 on href_business_trip_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_business_trip_reasons_i2 on href_business_trip_reasons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpd_business_trips
----------------------------------------------------------------------------------------------------
create table hpd_business_trips(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  region_id                       number(20) not null,
  person_id                       number(20) not null,
  reason_id                       number(20) not null,
  note                            varchar2(300 char),
  constraint hpd_business_trips_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_business_trips_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade,
  constraint hpd_business_trips_f2 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint hpd_business_trips_f3 foreign key (company_id, person_id) references mr_legal_persons(company_id, person_id),
  constraint hpd_business_trips_f4 foreign key (company_id, filial_id, reason_id) references href_business_trip_reasons(company_id, filial_id, reason_id)
) tablespace GWS_DATA;

comment on column hpd_business_trips.region_id is 'Destination region';
comment on column hpd_business_trips.person_id is 'Destination organization';

create index hpd_business_trips_i1 on hpd_business_trips(company_id, person_id) tablespace GWS_INDEX;
create index hpd_business_trips_i2 on hpd_business_trips(company_id, filial_id, reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new sequences
----------------------------------------------------------------------------------------------------
create sequence hpd_lock_intervals_sq;
create sequence hpr_charges_sq;
create sequence href_business_trip_reasons_sq;

----------------------------------------------------------------------------------------------------
prompt Fazo_z.Run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd');
exec fazo_z.run('hpr');
exec fazo_z.run('hper_staff_plan_intervals');
exec fazo_z.run('href_business_trip_reasons');
exec fazo_z.Compile_Invalid_Objects;

----------------------------------------------------------------------------------------------------
prompt adding business trip journal type
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
    Journal_Type('Командировка', 10, Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
  end loop;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt add default task groups
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select q.Company_Id
              from Md_Companies q
             where q.State = 'A'
               and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    z_Ms_Task_Groups.Insert_One(i_Company_Id    => r.Company_Id,
                                i_Task_Group_Id => Ms_Next.Task_Group_Id,
                                i_Name          => 'План',
                                i_State         => 'A',
                                i_Pcode         => Hper_Pref.c_Pcode_Task_Group_Plan);
  end loop;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt new sick leave settings
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id         number;
  v_Estimation_Formula varchar2(300 char);
  v_Identifier         Href_Indicators.Identifier%type;

  --------------------------------------------------
  Procedure Indicator
  (
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    v_Indicator_Id number;
  begin
    begin
      select Indicator_Id
        into v_Indicator_Id
        from Href_Indicators
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Href_Next.Indicator_Id;
    end;
   
    z_Href_Indicators.Save_One(i_Company_Id   => v_Company_Id,
                               i_Indicator_Id => v_Indicator_Id,
                               i_Name         => i_Name,
                               i_Short_Name   => i_Short_Name,
                               i_Identifier   => i_Identifier,
                               i_Used         => i_Used,
                               i_State        => 'A',
                               i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Operation_Group
  (
    i_Operation_Kind     varchar2,
    i_Name               varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Pcode              varchar2
  ) is
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Group_Id
        into v_Oper_Group_Id
        from Hpr_Oper_Groups
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => v_Company_Id,
                               i_Oper_Group_Id      => v_Oper_Group_Id,
                               i_Operation_Kind     => i_Operation_Kind,
                               i_Name               => i_Name,
                               i_Estimation_Type    => i_Estimation_Type,
                               i_Estimation_Formula => i_Estimation_Formula,
                               i_Pcode              => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Oper_Type
  (
    i_Name               varchar2,
    i_Short_Name         varchar2,
    i_Oper_Group_Pcode   varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Operation_Kind     varchar2,
    i_Oper_Type_Pcode    varchar2
  ) is
    v_Oper_Type     Hpr_Pref.Oper_Type_Rt;
    v_Oper_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Type_Id
        into v_Oper_Type_Id
        from Hpr_Oper_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Oper_Type_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    end;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => v_Company_Id,
                           i_Oper_Type_Id           => v_Oper_Type_Id,
                           i_Oper_Group_Id          => v_Oper_Group_Id,
                           i_Estimation_Type        => i_Estimation_Type,
                           i_Estimation_Formula     => i_Estimation_Formula,
                           i_Operation_Kind         => i_Operation_Kind,
                           i_Name                   => i_Name,
                           i_Short_Name             => i_Short_Name,
                           i_Accounting_Type        => Mpr_Pref.c_At_Employee,
                           i_Corr_Coa_Id            => null,
                           i_Corr_Ref_Set           => null,
                           i_Income_Tax_Exists      => 'N',
                           i_Income_Tax_Rate        => null,
                           i_Pension_Payment_Exists => 'N',
                           i_Pension_Payment_Rate   => null,
                           i_Social_Payment_Exists  => 'N',
                           i_Social_Payment_Rate    => null,
                           i_Note                   => null,
                           i_State                  => 'A',
                           i_Code                   => null);
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    update Hpr_Oper_Types q
       set q.Pcode = i_Oper_Type_Pcode
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Procedure Book_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Book_Type_Id number;
  begin
    begin
      select Book_Type_Id
        into v_Book_Type_Id
        from Hpr_Book_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Book_Type_Id := Hpr_Next.Book_Type_Id;
    end;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => v_Company_Id,
                              i_Book_Type_Id => v_Book_Type_Id,
                              i_Name         => i_Name,
                              i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = v_Company_Id
       and Pcode = i_Book_Type_Pcode;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => v_Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;

  --------------------------------------------------
  Function Identifier(i_Pcode varchar2) return varchar2 is
    result Href_Indicators.Identifier%type;
  begin
    select Identifier
      into result
      from Href_Indicators
     where Company_Id = v_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;
begin
  Dbms_Output.Put_Line('==== Indicators, Operation groups, Oper types, Book types, Book type binds, ====');
  ----------------------------------------------------------------------------------------------------
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- indicator
    Indicator('Рабочее время в днях',
              'Рабочие дни',
              'РабочиеДни',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Working_Days);
    Indicator('Рабочее время в часах',
              'Рабочее время',
              'РабочееВремя',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Working_Hours);
    Indicator('Коэффициент больничных листов',
              'Коэффициент (Больничный лист)',
              'КоэффициентБольничныхЛистов',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Sick_Leave_Coefficient);
    Indicator('Количество командировочных дней',
              'Кол-во ком. дней',
              'КоличествоДней',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Business_Trip_Days);
  
    -- Estimation Formula
    -- '(Оклад / НормаДней) * РабочиеДни * КоэффициентБольничныхЛистов'
    v_Estimation_Formula := '(' || Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Plan_Days) || ') * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Working_Days) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Sick_Leave_Coefficient);
  
    -- Operation group
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Больничный',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    v_Estimation_Formula,
                    Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave);
  
    -- Oper type
    Oper_Type('Больничный (Sick Leave)',
              'Больничный (Sick Leave)',
              Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Sick_Leave);
              
    -- Estimation Formula
    -- '(Оклад / НормаДней) * КоличествоДней'
    v_Estimation_Formula := '(' || Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Plan_Days) || ') * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Business_Trip_Days);
  
    -- Operation group
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Командировка',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    v_Estimation_Formula,
                    Hpr_Pref.c_Pcode_Operation_Group_Business_Trip);
  
    -- Oper type
    Oper_Type('Командировка',
              'Командировка',
              Hpr_Pref.c_Pcode_Operation_Group_Business_Trip,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Business_Trip);
  
    -- Book type
    Book_Type('Начисление больничный лист',
              Hpr_Pref.c_Pcode_Book_Type_Sick_Leave);
    Book_Type('Начисление командировка',
              Hpr_Pref.c_Pcode_Book_Type_Business_Trip);
  
    -- Book type bind
    Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Sick_Leave,
                   Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave);
    Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Business_Trip,
                   Hpr_Pref.c_Pcode_Operation_Group_Business_Trip);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
-- create error table
---------------------------------------------------------------------------------------------------- 
create table lock_interval_error_logs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  primary_id                      number(20) not null,
  kind                            varchar2(100 char),
  message                         clob
);

comment on column lock_interval_error_logs.kind is 'timebook, timeoff, performance';

----------------------------------------------------------------------------------------------------
prompt generate timebooks data
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Insert_Error
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Primary_Id number,
    i_Message    clob
  ) is
    pragma autonomous_transaction;
  begin
    insert into Lock_Interval_Error_Logs
      (Company_Id, Filial_Id, Primary_Id, Kind, Message)
    values
      (i_Company_Id, i_Filial_Id, i_Primary_Id, 'timebook', i_Message);
  
    commit;
  exception
    when others then
      rollback;
  end;
begin
  for Cm in (select *
               from Md_Companies q
              where q.State = 'A'
                and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    Ui_Auth.Logon_As_System(Cm.Company_Id);
  
    for r in (select t.Company_Id,
                     t.Filial_Id,
                     t.Timebook_Id,
                     w.Staff_Id,
                     t.Month Begin_Date,
                     Last_Day(t.Month) End_Date
                from Hpr_Timebooks t
                join Hpr_Timebook_Staffs w
                  on w.Company_Id = t.Company_Id
                 and w.Filial_Id = t.Filial_Id
                 and w.Timebook_Id = t.Timebook_Id
               where t.Company_Id = Cm.Company_Id
                 and t.Posted = 'Y')
    loop
      savepoint Before_Timebook_Interval;
      begin
        Hpd_Api.Timebook_Lock_Interval_Insert(i_Company_Id  => r.Company_Id,
                                              i_Filial_Id   => r.Filial_Id,
                                              i_Timebook_Id => r.Timebook_Id,
                                              i_Staff_Id    => r.Staff_Id,
                                              i_Begin_Date  => r.Begin_Date,
                                              i_End_Date    => r.End_Date);
      exception
        when others then
          rollback to Before_Timebook_Interval;
          Insert_Error(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Primary_Id => r.Timebook_Id,
                       i_Message    => Fazo.Trimmed_Sqlerrm);
      end;
    end loop;
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt generation timeoff data
----------------------------------------------------------------------------------------------------
declare
  v_Journal_Type_Id number;
  v_Dummy           varchar2(1);

  --------------------------------------------------
  Procedure Insert_Error
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Primary_Id number,
    i_Message    clob
  ) is
    pragma autonomous_transaction;
  begin
    insert into Lock_Interval_Error_Logs
      (Company_Id, Filial_Id, Primary_Id, Kind, Message)
    values
      (i_Company_Id, i_Filial_Id, i_Primary_Id, 'timeoff', i_Message);
  
    commit;
  exception
    when others then
      rollback;
  end;
begin
  for Cm in (select *
               from Md_Companies q
              where q.State = 'A'
                and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    Ui_Auth.Logon_As_System(Cm.Company_Id);
  
    v_Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Cm.Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
  
    for r in (select w.*
                from Hpd_Journals q
                join Hpd_Journal_Timeoffs w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Journal_Id = q.Journal_Id
               where q.Company_Id = Cm.Company_Id
                 and q.Journal_Type_Id = v_Journal_Type_Id
                 and q.Posted = 'Y'
               order by w.Begin_Date, q.Posted_Order_No desc)
    loop
      begin
        select 'X'
          into v_Dummy
          from Hpd_Lock_Intervals Li
         where Li.Company_Id = r.Company_Id
           and Li.Filial_Id = r.Filial_Id
           and Li.Staff_Id = r.Staff_Id
           and Li.Kind = Hpd_Pref.c_Lock_Interval_Kind_Timeoff
           and (Li.Begin_Date between r.Begin_Date and r.End_Date or
               Li.End_Date between r.Begin_Date and r.End_Date or
               r.Begin_Date between Li.Begin_Date and Li.End_Date or
               r.End_Date between Li.Begin_Date and Li.End_Date)
           and Rownum = 1;
        continue;
      exception
        when No_Data_Found then
          null;
      end;
    
      savepoint Before_Timeoff_Interval;
      begin
        Hpd_Core.Timeoff_Lock_Interval_Insert(i_Company_Id      => r.Company_Id,
                                              i_Filial_Id       => r.Filial_Id,
                                              i_Journal_Type_Id => v_Journal_Type_Id,
                                              i_Timeoff_Id      => r.Timeoff_Id,
                                              i_Staff_Id        => r.Staff_Id,
                                              i_Begin_Date      => r.Begin_Date,
                                              i_End_Date        => r.End_Date);
      exception
        when others then
          rollback to Before_Timeoff_Interval;
          Insert_Error(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Primary_Id => r.Timeoff_Id,
                       i_Message    => Fazo.Trimmed_Sqlerrm);
      end;
    end loop;
  
    for r in (select q.*
                from Hpd_Journals q
               where q.Company_Id = Cm.Company_Id
                 and q.Journal_Type_Id = v_Journal_Type_Id
                 and q.Posted = 'Y'
                 and exists
               (select 1
                        from Hpd_Journal_Timeoffs w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Journal_Id = q.Journal_Id
                         and not exists (select 1
                                from Hpd_Timeoff_Intervals Ti
                               where Ti.Company_Id = w.Company_Id
                                 and Ti.Filial_Id = w.Filial_Id
                                 and Ti.Timeoff_Id = w.Timeoff_Id)))
    loop
      z_Hpd_Journals.Update_One(i_Company_Id => r.Company_Id,
                                i_Filial_Id  => r.Filial_Id,
                                i_Journal_Id => r.Journal_Id,
                                i_Posted     => Option_Varchar2('N'));
    end loop;
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt generation performance(KPI) data
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Insert_Error
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Primary_Id number,
    i_Message    clob
  ) is
    pragma autonomous_transaction;
  begin
    insert into Lock_Interval_Error_Logs
      (Company_Id, Filial_Id, Primary_Id, Kind, Message)
    values
      (i_Company_Id, i_Filial_Id, i_Primary_Id, 'performance', i_Message);
  
    commit;
  exception
    when others then
      rollback;
  end;
begin
  for Cm in (select *
               from Md_Companies q
              where q.State = 'A'
                and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    Ui_Auth.Logon_As_System(Cm.Company_Id);
  
    for r in (select *
                from Hper_Staff_Plans t
               where t.Company_Id = Cm.Company_Id
                 and t.Status = Hper_Pref.c_Staff_Plan_Status_Completed)
    loop
      savepoint Before_Performance_Interval;
      begin
        Hpd_Api.Perf_Lock_Interval_Insert(i_Company_Id    => r.Company_Id,
                                          i_Filial_Id     => r.Filial_Id,
                                          i_Staff_Plan_Id => r.Staff_Plan_Id,
                                          i_Staff_Id      => r.Staff_Id,
                                          i_Begin_Date    => r.Begin_Date,
                                          i_End_Date      => r.End_Date);
      exception
        when others then
          rollback to Before_Performance_Interval;
          Insert_Error(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Primary_Id => r.Staff_Plan_Id,
                       i_Message    => Fazo.Trimmed_Sqlerrm);
      end;
    end loop;
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt insert data from hpr_book_oper_locks
----------------------------------------------------------------------------------------------------
-- this DML statements must be tested
-- Fix KPI book operations
update Hpr_Book_Operations q
   set q.Charge_Id =
       (select w.Charge_Id
          from Hpr_Charges w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and Greatest(q.Part_Begin, w.Begin_Date) <= Least(q.Part_End, w.End_Date)
           and exists (select 1
                  from Hpd_Lock_Intervals k
                 where k.Company_Id = w.Company_Id
                   and k.Filial_Id = w.Filial_Id
                   and k.Interval_Id = w.Interval_Id
                   and k.Staff_Id = q.Staff_Id)
           and exists (select 1
                  from Mpr_Book_Operations t
                 where t.Company_Id = q.Company_Id
                   and t.Filial_Id = q.Filial_Id
                   and t.Book_Id = q.Book_Id
                   and t.Operation_Id = q.Operation_Id
                   and t.Oper_Type_Id = w.Oper_Type_Id)
           and exists (select 1
                  from Hper_Staff_Plans Sp
                 where Sp.Company_Id = q.Company_Id
                   and Sp.Filial_Id = q.Filial_Id
                   and Sp.Staff_Id = q.Staff_Id
                   and Sp.Journal_Page_Id =
                       (select Slt.Page_Id
                          from Hpd_Staff_Line_Transactions Slt
                         where Slt.Company_Id = q.Company_Id
                           and Slt.Filial_Id = q.Filial_Id
                           and Slt.Staff_Id = q.Staff_Id
                           and Slt.Trans_Type = 'O'
                           and Slt.Valid_Trans = 'Y'
                           and Slt.Begin_Date =
                               (select max(Slt.Begin_Date)
                                  from Hpd_Staff_Line_Transactions Slt
                                 where Slt.Company_Id = q.Company_Id
                                   and Slt.Filial_Id = q.Filial_Id
                                   and Slt.Staff_Id = q.Staff_Id
                                   and Slt.Trans_Type = 'O'
                                   and Slt.Valid_Trans = 'Y'
                                   and Slt.Begin_Date <= q.Part_End
                                   and (Slt.End_Date is null or Slt.End_Date >= q.Part_End))
                           and (Slt.End_Date is null or Slt.End_Date >= q.Part_End)
                         order by Slt.Order_No
                         fetch first row only)
                   and exists (select 1
                          from Hper_Staff_Plan_Intervals Spi
                         where Spi.Company_Id = Sp.Company_Id
                           and Spi.Filial_Id = Sp.Filial_Id
                           and Spi.Staff_Plan_Id = Sp.Staff_Plan_Id
                           and Spi.Interval_Id = w.Interval_Id))
           and Rownum = 1)
 where q.Autofilled = 'Y';
 
-- Fix other book operations
update Hpr_Book_Operations q
   set q.Charge_Id =
       (select w.Charge_Id
          from Hpr_Charges w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and Greatest(q.Part_Begin, w.Begin_Date) <= Least(q.Part_End, w.End_Date)
           and exists (select 1
                  from Hpd_Lock_Intervals k
                 where k.Company_Id = w.Company_Id
                   and k.Filial_Id = w.Filial_Id
                   and k.Interval_Id = w.Interval_Id
                   and k.Staff_Id = q.Staff_Id)
           and exists (select 1
                  from Mpr_Book_Operations t
                 where t.Company_Id = q.Company_Id
                   and t.Filial_Id = q.Filial_Id
                   and t.Book_Id = q.Book_Id
                   and t.Operation_Id = q.Operation_Id
                   and t.Oper_Type_Id = w.Oper_Type_Id)
           and Rownum = 1)
 where q.Autofilled = 'Y'
   and q.Charge_Id is null;
commit;

update Hpr_Charges q
   set q.Status = 'U'
 where exists (select 1
          from Hpr_Book_Operations w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Charge_Id = q.Charge_Id);

update Hpr_Charges q
   set q.Status = 'C'
 where exists (select *
          from Hpr_Book_Operations w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Charge_Id = q.Charge_Id
           and exists (select 1
                  from Mpr_Books k
                 where k.Company_Id = w.Company_Id
                   and k.Filial_Id = w.Filial_Id
                   and k.Book_Id = w.Book_Id
                   and k.Posted = 'Y'));
commit;

alter table hpr_book_operations drop constraint hpr_book_operations_c1;
alter table hpr_book_operations drop constraint hpr_book_operations_c2;
alter table hpr_book_operations drop constraint hpr_book_operations_c3;

alter table hpr_book_operations add constraint hpr_book_operations_c1 check (autofilled in ('Y', 'N'));
alter table hpr_book_operations add constraint hpr_book_operations_c2 check (decode(autofilled, 'Y', 1, 0) = nvl2(charge_id, 1, 0));
