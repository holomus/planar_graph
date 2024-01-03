prompt Payroll module
prompt (c) 2020 Verifix HR

----------------------------------------------------------------------------------------------------
-- Timebook
----------------------------------------------------------------------------------------------------
create table hpr_timebooks(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  timebook_id                     number(20)        not null,
  timebook_number                 varchar2(50 char) not null,
  timebook_date                   date              not null,
  month                           as (trunc(period_begin, 'mon')),
  period_begin                    date              not null,
  period_end                      date              not null,
  period_kind                     varchar2(1)       not null,
  division_id                     number(20),
  posted                          varchar2(1)       not null,
  note                            varchar2(300 char),
  barcode                         varchar2(25)      not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)        not null,
  constraint hpr_timebooks_pk primary key (company_id, filial_id, timebook_id) using index tablespace GWS_INDEX,
  constraint hpr_timebooks_u1 unique (timebook_id) using index tablespace GWS_INDEX,
  constraint hpr_timebooks_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpr_timebooks_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_timebooks_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_timebooks_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_timebooks_c1 check (decode(trim(timebook_number), timebook_number, 1, 0) = 1),
  constraint hpr_timebooks_c2 check (trunc(timebook_date) = timebook_date),
  constraint hpr_timebooks_c3 check (posted in ('Y', 'N')),
  constraint hpr_timebooks_c4 check (trunc(period_begin) = period_begin and trunc(period_end) = period_end),
  constraint hpr_timebooks_c5 check (period_begin <= period_end and trunc(period_begin, 'mon') = trunc(period_end, 'mon')),
  constraint hpr_timebooks_c6 check (period_kind in ('M', 'F', 'S', 'C')),
  constraint hpr_timebooks_c7 check (decode(trim(barcode), barcode, 1, 0) = 1),
  constraint hpr_timebooks_c8 check (period_kind = 'M' and period_begin = trunc(period_begin, 'mon')
                                                       and period_end = last_day(period_begin) or
                                     period_kind = 'F' and period_begin = trunc(period_begin, 'mon')
                                                       and period_end = (period_begin + trunc((last_day(period_begin) - period_begin + 1) / 2) - 1) or
                                     period_kind = 'S' and period_end = last_day(period_begin)
                                                       and period_begin = (trunc(period_begin, 'mon') + trunc((last_day(period_begin) - trunc(period_begin, 'mon') + 1) / 2)) or
                                     period_kind = 'C')
) tablespace GWS_DATA;

comment on column hpr_timebooks.period_kind is 'Full (M)onth, (F)irst half, (S)econd half of month, (C)ustom period';

create index hpr_timebooks_i1 on hpr_timebooks(company_id, filial_id, division_id, month) tablespace GWS_INDEX;
create index hpr_timebooks_i2 on hpr_timebooks(company_id, created_by) tablespace GWS_INDEX;
create index hpr_timebooks_i3 on hpr_timebooks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_staffs(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  timebook_id                     number(20)   not null,
  staff_id                        number(20)   not null,
  schedule_id                     number(20),
  job_id                          number(20)   not null,
  division_id                     number(20)   not null,
  plan_days                       number(2)    not null,
  plan_hours                      number(5, 2) not null,
  fact_days                       number(2)    not null,
  fact_hours                      number(5, 2) not null,
  constraint hpr_timebook_staffs_pk primary key (company_id, filial_id, timebook_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_f1 foreign key (company_id, filial_id, timebook_id) references hpr_timebooks(company_id, filial_id, timebook_id) on delete cascade,
  constraint hpr_timebook_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_timebook_staffs_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_timebook_staffs_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_timebook_staffs_f5 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_timebook_staffs_c1 check (plan_days >= 0 and plan_days <= 31),
  constraint hpr_timebook_staffs_c2 check (fact_days >= 0 and fact_days <= 31),
  constraint hpr_timebook_staffs_c3 check (plan_hours >= 0 and plan_hours <= 744),
  constraint hpr_timebook_staffs_c4 check (fact_hours >= 0 and fact_hours <= 744)
) tablespace GWS_DATA;

comment on table hpr_timebook_staffs is 'Keeps timebook staffs and additional info';

comment on column hpr_timebook_staffs.schedule_id is 'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.job_id      is 'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.division_id is 'For last day in timebook period, cached field';
comment on column hpr_timebook_staffs.plan_days   is 'Working and nonworking days for timebook period';
comment on column hpr_timebook_staffs.plan_hours  is 'Plan hours for timebook period';
comment on column hpr_timebook_staffs.fact_days   is 'Days with turnout for timebook period';
comment on column hpr_timebook_staffs.fact_hours  is 'Turnout time for timebook period';

create index hpr_timebook_staffs_i1 on hpr_timebook_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpr_timebook_staffs_i2 on hpr_timebook_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_timebook_staffs_i3 on hpr_timebook_staffs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_timebook_staffs_i4 on hpr_timebook_staffs(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_facts(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  timebook_id                     number(20)   not null,
  staff_id                        number(20)   not null,
  time_kind_id                    number(20)   not null,
  fact_hours                      number(5, 2) not null,
  constraint hpr_timebook_facts_pk primary key (company_id, filial_id, timebook_id, staff_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_facts_f1 foreign key (company_id, filial_id, timebook_id, staff_id) references hpr_timebook_staffs(company_id, filial_id, timebook_id, staff_id) on delete cascade,
  constraint hpr_timebook_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpr_timebook_facts_c1 check (fact_hours >= 0 and fact_hours <= 744)
) tablespace GWS_DATA;

comment on table hpr_timebook_facts is 'Keeps sum of facts for timebook period';

comment on column hpr_timebook_facts.time_kind_id is 'Only parent time kinds';

create index hpr_timebook_facts_i1 on hpr_timebook_facts(company_id, time_kind_id) tablespace GWS_INDEX;

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
-- Wage sheets
----------------------------------------------------------------------------------------------------
create table hpr_wage_sheets(
  company_id                  number(20)        not null,
  filial_id                   number(20)        not null,
  sheet_id                    number(20)        not null,
  sheet_number                varchar2(50 char) not null,
  sheet_date                  date              not null,
  month                       as (trunc(period_begin, 'mon')),
  round_value                 varchar2(5)       not null,
  period_begin                date              not null,
  period_end                  date              not null,
  period_kind                 varchar2(1)       not null,
  note                        varchar2(300 char),
  sheet_kind                  varchar2(1)       not null,
  posted                      varchar2(1)       not null,
  created_by                  number(20)        not null,
  created_on                  timestamp with local time zone not null,
  modified_by                 number(20)        not null,
  modified_on                 timestamp with local time zone not null,
  constraint hpr_wage_sheets_pk primary key (company_id, filial_id, sheet_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheets_u1 unique (sheet_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheets_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_wage_sheets_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_wage_sheets_c1 check (decode(trim(sheet_number), sheet_number, 1, 0) = 1),
  constraint hpr_wage_sheets_c2 check (trunc(sheet_date) = sheet_date),
  constraint hpr_wage_sheets_c3 check (trunc(period_begin) = period_begin and trunc(period_end) = period_end),
  constraint hpr_wage_sheets_c4 check (period_begin <= period_end and 
                                       ((extract(year from period_begin) = extract(year from period_end) and 
                                        extract(month from period_end) - extract(month from period_begin) <= 1)
                                        or 
                                        (extract(year from period_begin) <> extract(year from period_end) and 
                                        abs(extract(month from period_end) - extract(month from period_begin)) = 11))),
  constraint hpr_wage_sheets_c5 check (period_kind in ('M', 'F', 'S', 'C')),
  constraint hpr_wage_sheets_c6 check (posted in ('Y', 'N')),
  constraint hpr_wage_sheets_c7 check (sheet_kind in ('R', 'O')),
  constraint hpr_wage_sheets_c8 check (period_kind = 'M' and period_begin = trunc(period_begin, 'mon')
                                                         and period_end = last_day(period_begin) or
                                       period_kind = 'F' and period_begin = trunc(period_begin, 'mon')
                                                         and period_end = (period_begin + trunc((last_day(period_begin) - period_begin + 1) / 2) - 1) or
                                       period_kind = 'S' and period_end = last_day(period_begin)
                                                         and period_begin = (trunc(period_begin, 'mon') + trunc((last_day(period_begin) - trunc(period_begin, 'mon') + 1) / 2)) or
                                       period_kind = 'C')
) tablespace GWS_DATA;

comment on table hpr_wage_sheets is 'Keeps wage info when using Verifix Start';

comment on column hpr_wage_sheets.period_kind is 'Full (M)onth, (F)irst half, (S)econd half of month, (C)ustom period';
comment on column hpr_wage_sheets.posted      is '(Y)es, (N)o';
comment on column hpr_wage_sheets.sheet_kind  is '(R)egular, (O)ne-time';

create index hpr_wage_sheets_i1 on hpr_wage_sheets(company_id, created_by) tablespace GWS_INDEX;
create index hpr_wage_sheets_i2 on hpr_wage_sheets(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_wage_sheet_divisions(
  company_id                  number(20) not null,
  filial_id                   number(20) not null,
  sheet_id                    number(20) not null,
  division_id                 number(20) not null,
  constraint hpr_wage_sheet_divisions_pk primary key (company_id, filial_id, sheet_id, division_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheet_divisions_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_wage_sheet_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

create index hpr_wage_sheet_divisions_i1 on hpr_wage_sheet_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sheet_parts(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  part_id                         number(20)   not null,
  part_begin                      date         not null,
  part_end                        date         not null,
  staff_id                        number(20)   not null,
  sheet_id                        number(20)   not null,
  division_id                     number(20)   not null,
  job_id                          number(20)   not null,
  schedule_id                     number(20),
  fte_id                          number(20),
  monthly_amount                  number(20,6) not null,
  plan_amount                     number(20,6) not null,
  wage_amount                     number(20,6) not null,
  overtime_amount                 number(20,6) not null,
  nighttime_amount                number(20,6) not null,
  late_amount                     number(20,6) not null,
  early_amount                    number(20,6) not null,
  lack_amount                     number(20,6) not null,
  day_skip_amount                 number(20,6) not null,
  mark_skip_amount                number(20,6) not null,
  accrual_amount                  as (wage_amount + overtime_amount + nighttime_amount),
  penalty_amount                  as (late_amount + early_amount + lack_amount + day_skip_amount + mark_skip_amount),
  amount                          as (wage_amount + overtime_amount + nighttime_amount - (late_amount + early_amount + lack_amount + day_skip_amount + mark_skip_amount)),
  constraint hpr_sheet_parts_pk primary key (company_id, filial_id, part_id) using index tablespace GWS_INDEX,
  constraint hpr_sheet_parts_u1 unique (part_id) using index tablespace GWS_INDEX,
  constraint hpr_sheet_parts_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_sheet_parts_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_sheet_parts_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_sheet_parts_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_sheet_parts_f5 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_sheet_parts_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id),
  constraint hpr_sheet_parts_c1 check (part_begin <= part_end),
  constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0
                                   and wage_amount >= 0 and overtime_amount >= 0 and nighttime_amount >= 0 
                                   and late_amount >= 0 and early_amount >= 0 and lack_amount >= 0 and day_skip_amount >= 0 and mark_skip_amount >= 0)
) tablespace GWS_DATA;

comment on table hpr_sheet_parts is 'Keeps sheet staffs info';

comment on column hpr_sheet_parts.schedule_id is 'Value from part_end day';
comment on column hpr_sheet_parts.job_id      is 'Value from part_end day';
comment on column hpr_sheet_parts.division_id is 'Value from part_end day';
comment on column hpr_sheet_parts.fte_id      is 'Value from part_end day. When null show closest fte value';

create index hpr_sheet_parts_i1 on hpr_sheet_parts(company_id, filial_id, staff_id, part_begin, part_end) tablespace GWS_INDEX;
create index hpr_sheet_parts_i2 on hpr_sheet_parts(company_id, filial_id, sheet_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i3 on hpr_sheet_parts(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i4 on hpr_sheet_parts(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i5 on hpr_sheet_parts(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i6 on hpr_sheet_parts(company_id, fte_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_onetime_sheet_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  sheet_id                        number(20) not null,
  staff_id                        number(20) not null,
  month                           date       not null,
  division_id                     number(20) not null,
  job_id                          number(20) not null,
  schedule_id                     number(20),
  accrual_amount                  number(20) not null,
  penalty_amount                  number(20) not null,
  total_amount                    as (accrual_amount - penalty_amount),
  constraint hpr_onetime_sheet_staffs_pk primary key (company_id, filial_id, sheet_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_onetime_sheet_staffs_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_onetime_sheet_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_onetime_sheet_staffs_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_onetime_sheet_staffs_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_onetime_sheet_staffs_f5 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_onetime_sheet_staffs_c1 check (trunc(month, 'mon') = month),
  constraint hpr_onetime_sheet_staffs_c2 check (accrual_amount >= 0 and penalty_amount >= 0)
) tablespace GWS_DATA;

comment on table hpr_onetime_sheet_staffs is 'Keeps staffs bonuses and penalties for one-time wage_sheet';

comment on column hpr_onetime_sheet_staffs.schedule_id is 'Value from month day';
comment on column hpr_onetime_sheet_staffs.job_id      is 'Value from month day';
comment on column hpr_onetime_sheet_staffs.division_id is 'Value from month day';

create index hpr_onetime_sheet_staffs_i1 on hpr_onetime_sheet_staffs(company_id, filial_id, staff_id, month) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i2 on hpr_onetime_sheet_staffs(company_id, filial_id, sheet_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i3 on hpr_onetime_sheet_staffs(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i4 on hpr_onetime_sheet_staffs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i5 on hpr_onetime_sheet_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Charge
---------------------------------------------------------------------------------------------------- 
create table hpr_charge_documents(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  document_number                 varchar2(50 char) not null,
  document_date                   date              not null,
  document_name                   varchar2(150 char),
  month                           date              not null,
  posted                          varchar2(1)       not null,
  currency_id                     number(20)        not null,
  division_id                     number(20),
  oper_type_id                    number(20),
  document_kind                   varchar2(1)       not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_charge_documents_pk primary key (company_id, filial_id, document_id) using index tablespace GWS_INDEX,
  constraint hpr_charge_documents_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpr_charge_documents_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id),
  constraint hpr_charge_documents_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_charge_documents_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_charge_documents_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_charge_documents_c1 check (decode(trim(document_number), document_number, 1, 0) = 1),
  constraint hpr_charge_documents_c2 check (decode(trim(document_name), document_name, 1, 0) = 1),
  constraint hpr_charge_documents_c3 check (posted in ('Y', 'N')),
  constraint hpr_charge_documents_c4 check (document_kind in ('A', 'D'))
) tablespace GWS_DATA;

comment on column hpr_charge_documents.posted is '(Y)es, (N)o';
comment on column hpr_charge_documents.document_kind is '(A)ccrual, (D)eduction';

create index hpr_charge_documents_i1 on hpr_charge_documents(company_id, currency_id) tablespace GWS_INDEX;
create index hpr_charge_documents_i2 on hpr_charge_documents(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_charge_documents_i3 on hpr_charge_documents(company_id, created_by) tablespace GWS_INDEX;
create index hpr_charge_documents_i4 on hpr_charge_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_charge_document_operations(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  document_id                     number(20)        not null,
  operation_id                    number(20)        not null,
  staff_id                        number(20)        not null,
  amount                          number(20, 6)     not null,
  note                            varchar2(300 char),
  constraint hpr_charge_document_operations_pk primary key (company_id, filial_id, operation_id) using index tablespace GWS_INDEX,
  constraint hpr_charge_document_operations_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpr_charge_document_operations_f2 foreign key (company_id, filial_id, document_id) references hpr_charge_documents(company_id, filial_id, document_id) on delete cascade,
  constraint hpr_charge_document_operations_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id)
) tablespace GWS_DATA;

create index hpr_charge_document_operations_i1 on hpr_charge_document_operations(company_id, filial_id, document_id) tablespace GWS_INDEX;
create index hpr_charge_document_operations_i2 on hpr_charge_document_operations(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_charges(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  charge_id                       number(20)   not null,
  staff_id                        number(20)   not null,
  interval_id                     number(20),
  doc_oper_id                     number(20),
  begin_date                      date         not null,
  end_date                        date         not null,
  oper_type_id                    number(20)   not null,
  amount                          number(20,6) not null,
  division_id                     number(20)   not null,
  schedule_id                     number(20),
  job_id                          number(20)   not null,
  rank_id                         number(20),
  currency_id                     number(20),
  robot_id                        number(20)   not null,
  wage_scale_id                   number(20),
  status                          varchar2(1)  not null,
  constraint hpr_charges_pk primary key (company_id, filial_id, charge_id) using index tablespace GWS_INDEX,
  constraint hpr_charges_u1 unique (charge_id) using index tablespace GWS_INDEX,
  constraint hpr_charges_f1 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id) on delete cascade,
  constraint hpr_charges_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id),
  constraint hpr_charges_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_charges_f4 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_charges_f5 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_charges_f6 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hpr_charges_f7 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpr_charges_f8 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hpr_charges_f9 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id),
  constraint hpr_charges_f10 foreign key(company_id, filial_id, doc_oper_id) references hpr_charge_document_operations(company_id , filial_id , operation_id) on delete cascade,
  constraint hpr_charges_f11 foreign key(company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_charges_c1 check (trunc(begin_date) = begin_date),
  constraint hpr_charges_c2 check (trunc(end_date) = end_date),
  constraint hpr_charges_c3 check (begin_date <= end_date),
  constraint hpr_charges_c4 check (status in ('D', 'N', 'U', 'C')),
  constraint hpr_charges_c5 check (not (status = 'D' and doc_oper_id is null)),
  constraint hpr_charges_c6 check (nvl2(doc_oper_id, 1, 0) = nvl2(interval_id, 0, 1))
) tablespace GWS_DATA;

comment on table hpr_charges is 'Keeps staff''s schedule, job, schedule change parts in each month between interval''s begin_date and end_date';

comment on column hpr_charges.oper_type_id  is 'If Interval kind is Timebook, closest transation''s oper types. If Interval kind is Timeoff, system created oper type depends on journal type(sick leave)';
comment on column hpr_charges.division_id   is 'For filtering purpose';
comment on column hpr_charges.schedule_id   is 'Cache field';
comment on column hpr_charges.job_id        is 'Cache field';
comment on column hpr_charges.rank_id       is 'Cache field';
comment on column hpr_charges.robot_id      is 'Cache field';
comment on column hpr_charges.wage_scale_id is 'Cache field';
comment on column hpr_charges.status        is '(D)raft, (N)ew, (U)sed, (C)ompleted';

create unique index hpr_charges_u2 on hpr_charges(nvl2(doc_oper_id, company_id, null), nvl2(doc_oper_id, filial_id, null), doc_oper_id) tablespace GWS_INDEX;

create index hpr_charges_i1  on hpr_charges(company_id, filial_id, interval_id) tablespace GWS_INDEX;
create index hpr_charges_i2  on hpr_charges(company_id, oper_type_id) tablespace GWS_INDEX;
create index hpr_charges_i3  on hpr_charges(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_charges_i4  on hpr_charges(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_charges_i5  on hpr_charges(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_charges_i6  on hpr_charges(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpr_charges_i7  on hpr_charges(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpr_charges_i8  on hpr_charges(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;
create index hpr_charges_i9  on hpr_charges(company_id, currency_id) tablespace GWS_INDEX;
create index hpr_charges_i10 on hpr_charges(company_id, filial_id, doc_oper_id) tablespace GWS_INDEX;
create index hpr_charges_i11 on hpr_charges(company_id, filial_id, staff_id) tablespace GWS_INDEX;

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
-- Oper Type
----------------------------------------------------------------------------------------------------
create table hpr_oper_groups(
  company_id                      number(20)         not null,
  oper_group_id                   number(20)         not null,
  operation_kind                  varchar2(1)        not null,
  name                            varchar2(100 char) not null,
  estimation_type                 varchar2(1)        not null,
  estimation_formula              varchar2(300 char),
  pcode                           varchar2(20)       not null,
  modified_id                     number(20)         not null,
  constraint hpr_oper_groups_pk primary key (company_id, oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_groups_u1 unique (oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_groups_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpr_oper_groups_c2 check (operation_kind in ('A', 'D')),
  constraint hpr_oper_groups_c3 check (estimation_type in ('C', 'F', 'E')),
  constraint hpr_oper_groups_c4 check (decode(estimation_type, 'F', 1, 0) = nvl2(estimation_formula, 1, 0)),
  constraint hpr_oper_groups_c5 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column hpr_oper_groups.operation_kind is '(A)ccrual, (D)eduction';
comment on column hpr_oper_groups.estimation_type is 'The result is: (C)alculated, calculated by the (F)ormula, (E)ntered as a fixed amount';

create unique index hpr_oper_groups_u3 on hpr_oper_groups(company_id, pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_oper_types(
  company_id                      number(20) not null,
  oper_type_id                    number(20) not null,
  oper_group_id                   number(20),
  estimation_type                 varchar2(1),
  estimation_formula              varchar2(300 char),
  constraint hpr_oper_types_pk primary key (company_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_types_f1 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id),
  constraint hpr_oper_types_f2 foreign key (company_id, oper_group_id) references hpr_oper_groups(company_id, oper_group_id),
  constraint hpr_oper_types_c1 check (estimation_type in ('C', 'F', 'E')),
  constraint hpr_oper_types_c2 check (decode(estimation_type, 'F', 1, 0) = nvl2(estimation_formula, 1, 0))
) tablespace GWS_DATA;

comment on column hpr_oper_types.estimation_type is 'The result is: (C)alculated, calculated by the (F)ormula, (E)ntered as a fixed amount';

create index hpr_oper_types_i1 on hpr_oper_types(company_id, oper_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_oper_type_indicators(
  company_id                      number(20)        not null,
  oper_type_id                    number(20)        not null,
  indicator_id                    number(20)        not null,
  identifier                      varchar2(50 char) not null,
  constraint hpr_oper_type_indicators_pk primary key (company_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_type_indicators_f1 foreign key (company_id, oper_type_id) references hpr_oper_types(company_id, oper_type_id) on delete cascade,
  constraint hpr_oper_type_indicators_f2 foreign key (company_id, indicator_id) references href_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpr_oper_type_indicators_i1 on hpr_oper_type_indicators(company_id, indicator_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Book
----------------------------------------------------------------------------------------------------
create table hpr_book_types(
  company_id                      number(20)         not null,
  book_type_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6)          not null,
  pcode                           varchar2(20)       not null,
  constraint hpr_book_types_pk primary key (company_id, book_type_id) using index tablespace GWS_INDEX,
  constraint hpr_book_types_u1 unique (book_type_id) using index tablespace GWS_INDEX,
  constraint hpr_book_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpr_book_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index hpr_book_types_u2 on hpr_book_types(company_id, pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_book_type_binds(
  company_id                      number(20) not null,
  book_type_id                    number(20) not null,
  oper_group_id                   number(20) not null,
  constraint hpr_book_type_binds_pk primary key (company_id, book_type_id, oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_book_type_binds_f1 foreign key (company_id, book_type_id) references hpr_book_types(company_id, book_type_id) on delete cascade,
  constraint hpr_book_type_binds_f2 foreign key (company_id, oper_group_id) references hpr_oper_groups(company_id, oper_group_id)
) tablespace GWS_DATA;

create index hpr_book_type_binds_i1 on hpr_book_type_binds(company_id, oper_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_books(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  book_id                         number(20) not null,
  book_type_id                    number(20) not null,
  modified_id                     number(20) not null,
  constraint hpr_books_pk primary key (company_id, filial_id, book_id) using index tablespace GWS_INDEX,
  constraint hpr_books_u1 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpr_books_f1 foreign key (company_id, filial_id, book_id) references mpr_books(company_id, filial_id, book_id) on delete cascade,
  constraint hpr_books_f2 foreign key (company_id, book_type_id) references hpr_book_types(company_id, book_type_id)
) tablespace GWS_DATA;

create index hpr_books_i1 on hpr_books(company_id, book_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_book_operations(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  book_id                         number(20)   not null,
  operation_id                    number(20)   not null,
  staff_id                        number(20)   not null,
  charge_id                       number(20),
  autofilled                      varchar2(1)  not null,
  constraint hpr_book_operations_pk primary key (company_id, filial_id, book_id, operation_id) using index tablespace GWS_INDEX,
  constraint hpr_book_operations_f1 foreign key (company_id, filial_id, book_id) references mpr_books(company_id, filial_id, book_id),
  constraint hpr_book_operations_f2 foreign key (company_id, filial_id, book_id, operation_id) references mpr_book_operations(company_id, filial_id, book_id, operation_id) on delete cascade,
  constraint hpr_book_operations_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_book_operations_f4 foreign key (company_id, filial_id, charge_id) references hpr_charges(company_id, filial_id, charge_id),
  constraint hpr_book_operations_c1 check (autofilled in ('Y', 'N')),
  constraint hpr_book_operations_c2 check (decode(autofilled, 'Y', 1, 0) = nvl2(charge_id, 1, 0))
) tablespace GWS_DATA;

create index hpr_book_operations_i1 on hpr_book_operations(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpr_book_operations_i2 on hpr_book_operations(company_id, filial_id, charge_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_advance_settings(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  payment_id                      number(20)  not null,
  limit_kind                      varchar2(1) not null,
  days_limit                      number(3),
  constraint hpr_advance_settings_pk primary key (company_id, filial_id, payment_id) using index tablespace GWS_INDEX,
  constraint hpr_advance_settings_f1 foreign key (company_id, filial_id, payment_id) references mpr_payments(company_id, filial_id, payment_id) on delete cascade,
  constraint hpr_advance_settings_c1 check (limit_kind in ('T', 'C')),
  constraint hpr_advance_settings_c2 check (days_limit between 0 and 366),
  constraint hpr_advance_settings_c3 check (decode(limit_kind , 'T', 1, 0) <= nvl2(days_limit, 1, 0))
) tablespace GWS_DATA;

comment on table hpr_advance_settings is 'Keeps advance settings. Does not include payroll info';

comment on column hpr_advance_settings.limit_kind is '(T)urnout, (C)alendar days. On (T)urnout days_limit will count only turnout days';
comment on column hpr_advance_settings.days_limit is 'Employees that worked less than this number will not be given advance';

----------------------------------------------------------------------------------------------------
create table hpr_penalties(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  penalty_id                      number(20)  not null,
  month                           date        not null,
  name                            varchar2(100 char),
  division_id                     number(20),
  state                           varchar2(1) not null,
  constraint hpr_penalties_pk primary key (company_id, filial_id, penalty_id) using index tablespace GWS_INDEX,
  constraint hpr_penalties_u1 unique (penalty_id) using index tablespace GWS_INDEX,
  constraint hpr_penalties_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_penalties_c1 check (month = trunc(month, 'mon')),
  constraint hpr_penalties_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpr_penalties_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hpr_penalties_u2 on hpr_penalties(company_id, filial_id, month, division_id) tablespace GWS_INDEX;

create index hpr_penalties_i1 on hpr_penalties(company_id, filial_id, division_id);

----------------------------------------------------------------------------------------------------
create table hpr_penalty_policies(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  penalty_id                      number(20)  not null,
  penalty_kind                    varchar2(1) not null,
  from_day                        number(4)   not null,
  to_day                          number(4),
  from_time                       number(4)   not null,
  to_time                         number(4),
  penalty_coef                    number(20,6),
  penalty_per_time                number(4),
  penalty_amount                  number(20,6),
  penalty_time                    number(4),
  calc_after_from_time            varchar2(1),
  constraint hpr_penalty_policies_pk primary key (company_id, filial_id, penalty_id, penalty_kind, from_day, from_time) using index tablespace GWS_INDEX,
  constraint hpr_penalty_policies_f1 foreign key (company_id, filial_id, penalty_id) references hpr_penalties(company_id, filial_id, penalty_id) on delete cascade,
  constraint hpr_penalty_policies_c1 check (penalty_kind in ('L', 'E', 'C', 'S', 'M')),
  constraint hpr_penalty_policies_c2 check (from_day >= 0 and from_day <= 31),
  constraint hpr_penalty_policies_c3 check (from_day <= to_day),
  constraint hpr_penalty_policies_c4 check (to_day <= 31),
  constraint hpr_penalty_policies_c5 check (from_time >= 0 and (from_time <= 1440 or penalty_kind = 'M')),
  constraint hpr_penalty_policies_c6 check (from_time <= to_time),
  constraint hpr_penalty_policies_c7 check (to_time <= 1440),
  constraint hpr_penalty_policies_c8 check (penalty_coef is not null and penalty_coef >= 0 or
                                            penalty_time is not null and penalty_time >= 0 or
                                           (penalty_per_time is null or penalty_per_time > 0) and
                                            penalty_amount is not null and penalty_amount >= 0),
  constraint hpr_penalty_policies_c9 check (nvl2(penalty_coef, 1, 0) + nvl2(penalty_amount, 1, 0) + nvl2(penalty_time, 1, 0) = 1),
  constraint hpr_penalty_policies_c10 check (calc_after_from_time in ('Y', 'N')),
  constraint hpr_penalty_policies_c11 check (penalty_time is not null and calc_after_from_time is null or penalty_time is null)
) tablespace GWS_DATA;

comment on column hpr_penalty_policies.penalty_kind         is '(L)ate time, (E)arly time, La(C)k time, Day (S)kip, (M)ark skip';
comment on column hpr_penalty_policies.from_time            is 'measured in minutes or when penalty_kind is mark skip then times';
comment on column hpr_penalty_policies.to_time              is 'measured in minutes or when penalty_kind is mark skip then times';
comment on column hpr_penalty_policies.penalty_coef         is 'Coef that multiplies penalty time: late time is 5 min, with coef 2 it will be 10 min';
comment on column hpr_penalty_policies.penalty_amount       is 'Penalty amount that will be taken from employee. It shows monetary amount';
comment on column hpr_penalty_policies.penalty_per_time     is 'Penalty amount will be multiplied by number of periods from this column';
comment on column hpr_penalty_policies.penalty_time         is 'Penalty time will be set to this value: late time is 5 min, penalty time is 30 min then penalty late time is 30 min';
comment on column hpr_penalty_policies.calc_after_from_time is 'Calculate penalty after from time ?';

----------------------------------------------------------------------------------------------------
-- Nighttime Policies
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
-- Cv Contract facts
----------------------------------------------------------------------------------------------------
create table hpr_cv_contract_facts(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  fact_id                         number(20)  not null,
  contract_id                     number(20)  not null,
  month                           date        not null,
  total_amount                    number(20,6),
  status                          varchar2(1) not null,
  constraint hpr_cv_contract_facts_pk primary key (company_id, filial_id, fact_id) using index tablespace GWS_INDEX,
  constraint hpr_cv_contract_facts_u1 unique (fact_id) using index tablespace GWS_INDEX,
  constraint hpr_cv_contract_facts_u2 unique (company_id, filial_id, contract_id, month) using index tablespace GWS_INDEX,
  constraint hpr_cv_contract_facts_f1 foreign key (company_id, filial_id, contract_id) references hpd_cv_contracts(company_id, filial_id, contract_id) on delete cascade,
  constraint hpr_cv_contract_facts_c1 check (trunc(month, 'mon') = month),
  constraint hpr_cv_contract_facts_c2 check (status in ('N', 'C', 'A'))
) tablespace GWS_DATA;

comment on column hpr_cv_contract_facts.status is '(N)ew, (C)omplete, (A)ccept';
comment on table hpr_cv_contract_facts is 'Keeps facts of civil contracts. Data will record after civil contract posted.';

----------------------------------------------------------------------------------------------------
create table hpr_cv_contract_fact_items(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  fact_item_id                    number(20)         not null,
  fact_id                         number(20)         not null,
  contract_item_id                number(20),
  plan_quantity                   number(20,6),
  plan_amount                     number(20,6),
  fact_quantity                   number(20,6)       not null,
  fact_amount                     number(20,6)       not null,
  name                            varchar2(300 char) not null,
  constraint hpr_cv_contract_fact_items_pk primary key (company_id, filial_id, fact_item_id) using index tablespace GWS_INDEX,
  constraint hpr_cv_contract_fact_items_u1 unique (fact_item_id) using index tablespace GWS_INDEX,
  constraint hpr_cv_contract_fact_items_f1 foreign key (company_id, filial_id, fact_id) references hpr_cv_contract_facts(company_id, filial_id, fact_id) on delete cascade,
  constraint hpr_cv_contract_fact_items_f2 foreign key (company_id, filial_id, contract_item_id) references hpd_cv_contract_items(company_id, filial_id, contract_item_id)
) tablespace GWS_DATA;

comment on table hpr_cv_contract_fact_items is 'Keeps items of civil contract facts';

create index hpr_cv_contract_fact_items_i1 on hpr_cv_contract_fact_items(company_id, filial_id, fact_id) tablespace GWS_INDEX;
create index hpr_cv_contract_fact_items_i2 on hpr_cv_contract_fact_items(company_id, filial_id, contract_item_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sales_bonus_payments(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  payment_id                      number(20)        not null,
  payment_number                  varchar2(50 char) not null,
  payment_date                    date              not null,
  payment_name                    varchar2(200 char),
  begin_date                      date              not null,
  end_date                        date              not null,
  division_id                     number(20),
  job_id                          number(20),
  bonus_type                      varchar2(1),
  payment_type                    varchar2(1)       not null,
  cashbox_id                      number(20),
  bank_account_id                 number(20),
  amount                          number(20,6)      not null,
  posted                          varchar2(1)       not null,
  barcode                         varchar2(25)      not null,
  note                            varchar2(300 char),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_sales_bonus_payments_pk primary key (company_id, filial_id, payment_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payments_u1 unique (payment_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payments_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_sales_bonus_payments_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_sales_bonus_payments_f3 foreign key (company_id, cashbox_id) references mkcs_cashboxes(company_id, cashbox_id),
  constraint hpr_sales_bonus_payments_f4 foreign key (company_id, bank_account_id) references mkcs_bank_accounts(company_id, bank_account_id),
  constraint hpr_sales_bonus_payments_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_sales_bonus_payments_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_sales_bonus_payments_c1 check (decode(trim(payment_number), payment_number, 1, 0) = 1),
  constraint hpr_sales_bonus_payments_c2 check (trunc(payment_date) = payment_date),
  constraint hpr_sales_bonus_payments_c3 check (decode(trim(payment_name), payment_name, 1, 0) = 1),
  constraint hpr_sales_bonus_payments_c4 check (begin_date <= end_date),
  constraint hpr_sales_bonus_payments_c5 check (bonus_type in ('P', 'D', 'S')),
  constraint hpr_sales_bonus_payments_c6 check (payment_type in ('C', 'B')),
  constraint hpr_sales_bonus_payments_c7 check (payment_type = 'C' and cashbox_id is not null and bank_account_id is null
                                             or payment_type = 'B' and cashbox_id is null and bank_account_id is not null),
  constraint hpr_sales_bonus_payments_c8 check (posted in ('Y', 'N'))
) tablespace GWS_DATA;

comment on column hpr_sales_bonus_payments.bonus_type   is '(P)ersonal sales, (D)epartment sales, (S)uccessful delivery';
comment on column hpr_sales_bonus_payments.payment_type is '(C)ashbox, (B)ank account';

create unique index hpr_sales_bonus_payments_u2 on hpr_sales_bonus_payments(company_id, filial_id, lower(payment_number)) tablespace GWS_DATA;

create index hpr_sales_bonus_payments_i1 on hpr_sales_bonus_payments(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payments_i2 on hpr_sales_bonus_payments(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payments_i3 on hpr_sales_bonus_payments(company_id, cashbox_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payments_i4 on hpr_sales_bonus_payments(company_id, bank_account_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payments_i5 on hpr_sales_bonus_payments(company_id, created_by) tablespace GWS_INDEX;
create index hpr_sales_bonus_payments_i6 on hpr_sales_bonus_payments(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sales_bonus_payment_operations(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  operation_id                    number(20)   not null,
  payment_id                      number(20)   not null,
  staff_id                        number(20)   not null,
  bonus_type                      varchar2(1)  not null,
  period_begin                    date         not null,
  period_end                      date         not null,
  job_id                          number(20)   not null,
  sales_amount                    number(20,6) not null,
  percentage                      number(20,6) not null,
  amount                          number(20,6) not null,
  constraint hpr_sales_bonus_payment_operations_pk primary key (company_id, filial_id, operation_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_operations_u1 unique (operation_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_operations_u2 unique (company_id, filial_id, payment_id, staff_id, bonus_type, period_begin) deferrable initially deferred using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_operations_f1 foreign key (company_id, filial_id, payment_id) references hpr_sales_bonus_payments(company_id, filial_id, payment_id) on delete cascade,
  constraint hpr_sales_bonus_payment_operations_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_sales_bonus_payment_operations_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_sales_bonus_payment_operations_c1 check (period_begin = trunc(period_begin)),
  constraint hpr_sales_bonus_payment_operations_c2 check (period_end = trunc(period_end)),
  constraint hpr_sales_bonus_payment_operations_c3 check (period_begin <= period_end),
  constraint hpr_sales_bonus_payment_operations_c4 check (bonus_type in ('P', 'D', 'S')),
  constraint hpr_sales_bonus_payment_operations_c5 check (percentage > 0)
) tablespace GWS_DATA;

create index hpr_sales_bonus_payment_operations_i1 on hpr_sales_bonus_payment_operations(company_id, filial_id, payment_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payment_operations_i2 on hpr_sales_bonus_payment_operations(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payment_operations_i3 on hpr_sales_bonus_payment_operations(company_id, filial_id, job_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sales_bonus_payment_operation_periods(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  operation_id                    number(20)   not null,
  period                          date         not null,
  sales_amount                    number(20,6) not null,
  amount                          number(20,6) not null,
  c_staff_id                      number(20)   not null,
  c_bonus_type                    varchar2(1)  not null,
  constraint hpr_sales_bonus_payment_operation_periods_pk primary key (company_id, filial_id, operation_id, period) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_operation_periods_f1 foreign key (company_id, filial_id, operation_id) references hpr_sales_bonus_payment_operations(company_id, filial_id, operation_id) on delete cascade,
  constraint hpr_sales_bonus_payment_operation_periods_c1 check (period = trunc(period))
) tablespace GWS_DATA;

create index hpr_sales_bonus_payment_operation_periods_i1 on hpr_sales_bonus_payment_operation_periods(company_id, filial_id, c_staff_id, c_bonus_type, period) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sales_bonus_payment_intervals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  operation_id                    number(20) not null,
  interval_id                     number(20) not null,
  constraint hpr_sales_bonus_payment_intervals_pk primary key (company_id, filial_id, operation_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_intervals_u1 unique (company_id, filial_id, interval_id) using index tablespace GWS_INDEX,
  constraint hpr_sales_bonus_payment_intervals_f1 foreign key (company_id, filial_id, operation_id) references hpr_sales_bonus_payment_operations(company_id, filial_id, operation_id),
  constraint hpr_sales_bonus_payment_intervals_f2 foreign key (company_id, filial_id, interval_id) references hpd_lock_intervals(company_id, filial_id, interval_id)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------          
create table hpr_credits(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  credit_id                       number(20)        not null,
  credit_number                   varchar2(50 char) not null,
  credit_date                     date              not null, 
  booked_date                     date              not null, 
  employee_id                     number(20)        not null,  
  begin_month                     date              not null,
  end_month                       date              not null,
  credit_amount                   number(20, 6)     not null,
  currency_id                     number(20)        not null,  
  payment_type                    varchar2(1)       not null,
  cashbox_id                      number(20),  
  bank_account_id                 number(20),
  status                          varchar2(1)       not null,
  note                            varchar2(300 char),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_credits_pk primary key (company_id, filial_id, credit_id) using index tablespace GWS_INDEX,
  constraint hpr_credits_u1 unique (credit_id) using index tablespace GWS_INDEX,
  constraint hpr_credits_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpr_credits_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id),
  constraint hpr_credits_f3 foreign key (company_id, filial_id, cashbox_id) references mkcs_cashboxes(company_id, filial_id, cashbox_id),
  constraint hpr_credits_f4 foreign key (company_id, bank_account_id) references mkcs_bank_accounts(company_id, bank_account_id),
  constraint hpr_credits_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_credits_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_credits_c1 check (decode(trim(credit_number), credit_number, 1, 0) = 1),
  constraint hpr_credits_c2 check (booked_date = trunc(booked_date)),
  constraint hpr_credits_c3 check (credit_date = trunc(credit_date)),
  constraint hpr_credits_c4 check (booked_date <= credit_date),
  constraint hpr_credits_c5 check (begin_month = trunc(begin_month, 'mon')),
  constraint hpr_credits_c6 check (end_month = trunc(end_month, 'mon')),
  constraint hpr_credits_c7 check (begin_month <= end_month),
  constraint hpr_credits_c8 check (credit_amount >= 0),
  constraint hpr_credits_c9 check (payment_type in ('C', 'B')),
  constraint hpr_credits_c10 check (status in ('D', 'B', 'C', 'A')),
  constraint hpr_credits_c11 check (payment_type = 'C' and cashbox_id is not null and bank_account_id is null or 
                                    payment_type = 'B' and cashbox_id is null and bank_account_id is not null)
) tablespace GWS_DATA;
 
comment on column hpr_credits.status is '(D)raft, (B)ooked, (C)ompleted, (A)rchived';

create index hpr_credits_i1 on hpr_credits(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpr_credits_i2 on hpr_credits(company_id, currency_id) tablespace GWS_INDEX;
create index hpr_credits_i3 on hpr_credits(company_id, filial_id, cashbox_id) tablespace GWS_INDEX;
create index hpr_credits_i4 on hpr_credits(company_id, bank_account_id) tablespace GWS_INDEX;
create index hpr_credits_i5 on hpr_credits(company_id, created_by) tablespace GWS_INDEX;
create index hpr_credits_i6 on hpr_credits(company_id, modified_by) tablespace GWS_INDEX;
