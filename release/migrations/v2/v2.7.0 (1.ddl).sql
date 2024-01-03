prompt migr from 23.09.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt adding cv contract tables
----------------------------------------------------------------------------------------------------
-- HPD
----------------------------------------------------------------------------------------------------
create table hpd_cv_contracts(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  contract_id                     number(20)  not null,
  contract_number                 varchar2(50),
  division_id                     number(20)  not null,
  person_id                       number(20)  not null,
  begin_date                      date        not null, 
  end_date                        date        not null,
  contract_kind                   varchar2(1) not null,
  access_to_add_item              varchar2(1) not null,
  posted                          varchar2(1) not null,
  early_closed_date               date,
  early_closed_note               varchar2(300 char),
  note                            varchar2(300 char),
  constraint hpd_cv_contracts_pk primary key (company_id, filial_id, contract_id) using index tablespace GWS_INDEX,
  constraint hpd_cv_contracts_u1 unique (contract_id) using index tablespace GWS_INDEX,
  constraint hpd_cv_contracts_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_cv_contracts_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint hpd_cv_contracts_c1 check (begin_date <= end_date),
  constraint hpd_cv_contracts_c2 check (begin_date <= early_closed_date and early_closed_date <= end_date),
  constraint hpd_cv_contracts_c3 check (contract_kind in ('S', 'C')),
  constraint hpd_cv_contracts_c4 check (access_to_add_item in ('Y', 'N')),
  constraint hpd_cv_contracts_c5 check (posted in ('Y', 'N'))
) tablespace GWS_DATA;

comment on column hpd_cv_contracts.contract_kind is '(S)imple, (C)yclical';
comment on table hpd_cv_contracts is 'Keeps civil contracts'; 

create index hpd_cv_contracts_i1 on hpd_cv_contracts(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_cv_contracts_i2 on hpd_cv_contracts(company_id, person_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_cv_contract_items(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  contract_item_id                number(20)         not null,
  contract_id                     number(20)         not null,
  name                            varchar2(300 char) not null,
  quantity                        number(20,6)       not null,
  amount                          number(20,6)       not null,
  constraint hpd_cv_contract_items_pk primary key (company_id, filial_id, contract_item_id) using index tablespace GWS_INDEX,  
  constraint hpd_cv_contract_items_u1 unique (contract_item_id) using index tablespace GWS_INDEX,
  constraint hpd_cv_contract_items_f1 foreign key (company_id, filial_id, contract_id) references hpd_cv_contracts(company_id, filial_id, contract_id) on delete cascade,
  constraint hpd_cv_contract_items_c1 check (quantity > 0 and amount > 0),
  constraint hpd_cv_contract_items_c2 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table hpd_cv_contract_items is 'Keeps items of civil contracts';

create index hpd_cv_contract_items_i1 on hpd_cv_contract_items(company_id, filial_id, contract_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_cv_contract_files(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  contract_id                     number(20)   not null,
  file_sha                        varchar2(64) not null,
  note                            varchar2(300 char),
  constraint hpd_cv_contract_files_pk primary key (company_id, filial_id, contract_id, file_sha) using index tablespace GWS_INDEX,
  constraint hpd_cv_contract_files_f1 foreign key (company_id, filial_id, contract_id) references hpd_cv_contracts(company_id, filial_id, contract_id) on delete cascade,
  constraint hpd_cv_contract_files_f2 foreign key (file_sha) references biruni_files(sha)
) tablespace GWS_DATA;

comment on table hpd_cv_contract_files is 'Keeps files of civil contracts';

create index hpd_cv_contract_files_i1 on hpd_cv_contract_files(file_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                     
-- HPR
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
prompt adding cv contract sequences
----------------------------------------------------------------------------------------------------
create sequence hpd_cv_contracts_sq;
create sequence hpd_cv_contract_items_sq;

create sequence hpr_cv_contract_facts_sq;
create sequence hpr_cv_contract_fact_items_sq;

----------------------------------------------------------------------------------------------------
prompt new href_cached_contract_item_names table
----------------------------------------------------------------------------------------------------
create table href_cached_contract_item_names(
  company_id                      number(20)         not null,
  name                            varchar2(300 char) not null,
  constraint href_cached_contract_item_names_pk primary key (company_id, name) using index tablespace GWS_INDEX,
  constraint href_cached_contract_item_names_c1 check (name = lower(name))
) tablespace GWS_DATA;

comment on table href_cached_contract_item_names is 'Keeps service names. This table used only work with civil contracts.';

----------------------------------------------------------------------------------------------------
prompt new table htt_trash_tracks
----------------------------------------------------------------------------------------------------
create table htt_trash_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  track_id                        number(20)  not null,
  track_date                      date        not null,
  track_time                      timestamp with local time zone not null, 
  track_datetime                  date        not null, 
  person_id                       number(20)  not null,
  track_type                      varchar2(1) not null,
  mark_type                       varchar2(1) not null,
  device_id                       number(20), 
  location_id                     number(20),
  latlng                          varchar2(50),  
  accuracy                        number(20), 
  photo_sha                       varchar2(64),
  note                            varchar2(300 char),
  is_valid                        varchar2(1) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_trash_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_u2 unique (company_id, filial_id, track_time, person_id, track_type) using index tablespace GWS_INDEX,
  constraint htt_trash_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_trash_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id),
  constraint htt_trash_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id),
  constraint htt_trash_tracks_f4 foreign key (photo_sha) references biruni_files(sha),
  constraint htt_trash_tracks_c1 check (track_type in ('I', 'O', 'C')),
  constraint htt_trash_tracks_c2 check (mark_type in ('P', 'T', 'R', 'Q', 'F', 'M')),
  constraint htt_trash_tracks_c3 check (decode(latlng, null, 1, 0) = decode(accuracy, null, 1, 0)),
  constraint htt_trash_tracks_c4 check (is_valid in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_trash_tracks             is 'Keeps person''s non-working interval tracks';
comment on column htt_trash_tracks.track_type is '(I)nput, (O)utput, (C)heck';
comment on column htt_trash_tracks.mark_type  is '(P)assword, (T)ouch, (R)fid card, (Q)R code, (F)ace, (M)anual';

create index htt_trash_tracks_i1 on htt_trash_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i2 on htt_trash_tracks(company_id, location_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i3 on htt_trash_tracks(company_id, device_id) tablespace GWS_INDEX;
create index htt_trash_tracks_i4 on htt_trash_tracks(company_id, filial_id, person_id, track_date, track_datetime) tablespace GWS_INDEX;
create index htt_trash_tracks_i5 on htt_trash_tracks(photo_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hlic tables
----------------------------------------------------------------------------------------------------
create table hlic_required_intervals(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  interval_id                     number(20)  not null,
  staff_id                        number(20)  not null,
  employee_id                     number(20)  not null,
  start_date                      date        not null,
  finish_date                     date,
  status                          varchar2(1) not null,
  constraint hlic_required_intervals_pk primary key (company_id, interval_id) using index tablespace GWS_INDEX,
  constraint hlic_required_intervals_u1 unique (company_id, filial_id, staff_id) using index tablespace GWS_INDEX,
  constraint hlic_required_intervals_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hlic_required_intervals_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hlic_required_intervals_c1 check (start_date <= finish_date),
  constraint hlic_required_intervals_c2 check (status in ('C', 'S'))
) tablespace GWS_DATA;

comment on table hlic_required_intervals is 'employees whose licenses are required intervals';
comment on column hlic_required_intervals.status is '(C)ontinue to generate required dates, (S)top to generate';

create index hlic_required_intervals_i1 on hlic_required_intervals(company_id, status) tablespace GWS_INDEX;
create index hlic_required_intervals_i2 on hlic_required_intervals(company_id, filial_id, employee_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hlic_required_dates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  interval_id                     number(20) not null,  
  required_date                   date       not null,
  employee_id                     number(20) not null,
  staff_id                        number(20) not null,
  constraint hlic_required_dates_pk primary key (company_id, interval_id, required_date) using index tablespace GWS_INDEX,
  constraint hlic_required_dates_u1 unique (company_id, filial_id, employee_id, required_date) using index tablespace GWS_INDEX,
  constraint hlic_required_dates_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hlic_required_dates_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hlic_required_dates_c1 check (trunc(required_date) = required_date)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding hlic sequences
----------------------------------------------------------------------------------------------------
create sequence hlic_required_intervals_sq;

----------------------------------------------------------------------------------------------------
prompt hpr sheet changes
----------------------------------------------------------------------------------------------------
alter table hpr_sheet_parts
add day_skip_amount number(20,6);

update hpr_sheet_parts
set day_skip_amount = 0;

alter table hpr_sheet_parts
modify day_skip_amount not null;

alter table hpr_sheet_parts modify penalty_amount as (late_amount + early_amount + lack_amount + day_skip_amount);

alter table hpr_sheet_parts modify amount as (wage_amount + overtime_amount - (late_amount + early_amount + lack_amount + day_skip_amount));

alter table hpr_sheet_parts drop constraint hpr_sheet_parts_c2;

alter table hpr_sheet_parts add constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0
                                                                    and wage_amount >= 0 and overtime_amount >= 0
                                                                    and late_amount >= 0 and early_amount >= 0 and lack_amount >= 0 and day_skip_amount >= 0);

----------------------------------------------------------------------------------------------------
prompt hpr penalty changes
----------------------------------------------------------------------------------------------------
alter table hpr_penalty_policies
drop constraint hpr_penalty_policies_c1;

alter table hpr_penalty_policies
add constraint hpr_penalty_policies_c1 check (penalty_kind in ('L', 'E', 'C', 'S'));

comment on column hpr_penalty_policies.penalty_kind is '(L)ate time, (E)arly time, La(C)k time, Day (S)kip';

----------------------------------------------------------------------------------------------------
prompt add new table for locastion qr codes
----------------------------------------------------------------------------------------------------
create table htt_location_qr_codes(
  company_id                      number(20)   not null,
  unique_key                      varchar2(64) not null,
  location_id                     number(20)   not null,
  state                           varchar2(1)  not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_qr_codes_pk primary key(company_id, unique_key) using index tablespace GWS_INDEX,
  constraint htt_location_qr_codes_u1 unique (unique_key) using index tablespace GWS_INDEX,
  constraint htt_location_qr_codes_f1 foreign key (company_id, location_id) references htt_locations(company_id, location_id) on delete cascade,
  constraint htt_location_qr_codes_c1 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on table htt_location_qr_codes is 'Keeps items for generate qr code';

create index htt_location_qr_codes_i1 on htt_location_qr_codes(company_id, location_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create sequence htt_location_qr_codes_sq;

----------------------------------------------------------------------------------------------------
create table href_timepad_users(
  company_id                      number(20) not null,
  user_id                         number(20) not null,
  constraint href_timepad_users_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint href_timepad_users_f1 foreign key (company_id, user_id) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on table href_timepad_users is 'Keeps Virtual User Ids for timepad';

create index href_timepad_users_i1 on href_timepad_users(company_id, user_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table href_restricted_dismissal_reasons
----------------------------------------------------------------------------------------------------
create table href_restricted_dismissal_reasons(
  company_id                      number(20) not null,
  dismissal_reason_id             number(20) not null,
  constraint href_restricted_dismissal_reasons_pk primary key (company_id, dismissal_reason_id) using index tablespace GWS_INDEX,
  constraint href_restricted_dismissal_reasons_f1 foreign key (company_id, dismissal_reason_id) references href_dismissal_reasons(company_id, dismissal_reason_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt new tables for schedule templates
----------------------------------------------------------------------------------------------------
create table htt_schedule_templates(
  template_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  description                     varchar2(3000 char),
  schedule_kind                   varchar2(1)        not null,
  all_days_equal                  varchar2(1)        not null,
  count_days                      number(4),
  shift                           number(4)          not null,
  input_acceptance                number(4)          not null,
  output_acceptance               number(4)          not null,
  track_duration                  number(4)          not null,
  count_late                      varchar2(1)        not null,
  count_early                     varchar2(1)        not null,
  count_lack                      varchar2(1)        not null,
  take_holidays                   varchar2(1)        not null,
  take_nonworking                 varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  constraint htt_schedule_templates_pk primary key (template_id) using index tablespace GWS_INDEX,
  constraint htt_schedule_templates_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_schedule_templates_c2 check (schedule_kind in ('W', 'P')),
  constraint htt_schedule_templates_c3 check (all_days_equal in ('Y', 'N')),
  constraint htt_schedule_templates_c4 check (count_days > 0),
  constraint htt_schedule_templates_c5 check (shift between 0 and 1439),
  constraint htt_schedule_templates_c6 check (input_acceptance between 0 and 2160),
  constraint htt_schedule_templates_c7 check (output_acceptance between 0 and 2160),
  constraint htt_schedule_templates_c8 check (track_duration between 0 and 4320),
  constraint htt_schedule_templates_c9 check (count_late in ('Y', 'N')),
  constraint htt_schedule_templates_c10 check (count_early in ('Y', 'N')),
  constraint htt_schedule_templates_c11 check (count_lack in ('Y', 'N')),
  constraint htt_schedule_templates_c12 check (take_holidays in ('Y', 'N')),
  constraint htt_schedule_templates_c13 check (take_nonworking in ('Y', 'N')),
  constraint htt_schedule_templates_c14 check (state in ('A', 'P')),
  constraint htt_schedule_templates_c15 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_schedule_templates is 'Keeps templates for fast creating schedules';

----------------------------------------------------------------------------------------------------
create table htt_schedule_template_days(
  template_id                     number(20)  not null,
  day_no                          number(4)   not null,
  day_kind                        varchar2(1) not null,
  plan_time                       number(4)   not null,
  begin_time                      number(4),
  end_time                        number(4),
  break_enabled                   varchar2(1),
  break_begin_time                number(4),
  break_end_time                  number(4),
  constraint htt_schedule_template_days_pk primary key (template_id, day_no) using index tablespace GWS_INDEX,
  constraint htt_schedule_template_days_f1 foreign key (template_id) references htt_schedule_templates(template_id) on delete cascade,
  constraint htt_schedule_template_days_c1 check (day_no > 0),
  constraint htt_schedule_template_days_c2 check (day_kind in ('W', 'R')),
  constraint htt_schedule_template_days_c3 check (plan_time between 0 and 1440),
  constraint htt_schedule_template_days_c4 check (break_enabled in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table htt_schedule_template_days                is 'all time fields are measured in minutes';
comment on column htt_schedule_template_days.day_kind      is '(W)orking, (R)est';
comment on column htt_schedule_template_days.break_enabled is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table htt_schedule_template_marks(
  template_id                     number(20) not null,
  day_no                          number(4)  not null,
  begin_time                      number(4)  not null,
  end_time                        number(4)  not null,
  constraint htt_schedule_template_marks_pk primary key (template_id, day_no, begin_time) using index tablespace GWS_INDEX,
  constraint htt_schedule_template_marks_f1 foreign key (template_id, day_no) references htt_schedule_template_days(template_id, day_no) on delete cascade,
  constraint htt_schedule_template_marks_c1 check (begin_time < end_time and begin_time >= 0)
) tablespace GWS_DATA;

comment on table htt_schedule_template_marks is 'Keeps marks template for each pattern day';

comment on column htt_schedule_template_marks.begin_time is 'Shows minutes from 00:00';
comment on column htt_schedule_template_marks.end_time   is 'Shows minutes from 00:00';

----------------------------------------------------------------------------------------------------
prompt new table htt_unknown_devices
----------------------------------------------------------------------------------------------------
create table htt_unknown_devices(
  company_id                      number(20) not null,
  device_id                       number(20) not null,
  constraint htt_unknown_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_unknown_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_unknown_devices is 'Keeps unknown device ids';

----------------------------------------------------------------------------------------------------
prompt sequnce for schedule template
----------------------------------------------------------------------------------------------------
create sequence htt_schedule_templates_sq;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run; hpd_cv, hpr_cv, href_cached_contract_item_names
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_cv');
exec fazo_z.run('hpr_cv');
exec fazo_z.run('href_cached_contract_item_names');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('htt_trash_tracks');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_trash_tracks');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('hpr_sheet_parts'); fazo_z.run('hpr_penalty_policies');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpr_sheet_parts');
exec fazo_z.run('hpr_penalty_policies');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('hlic_required_intervals'); fazo_z.run('hlic_required_dates');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hlic_required_intervals');
exec fazo_z.run('hlic_required_dates');
----------------------------------------------------------------------------------------------------
prompt fazo_z.run('htt_devices');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_devices');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('htt_location_qr_codes'); fazo_z.run('href_timepad_users');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_location_qr_codes');
exec fazo_z.run('href_timepad_users');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('href_restricted_dismissal_reasons')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_restricted_dismissal_reasons');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('htt_schedule_template')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_schedule_template');

----------------------------------------------------------------------------------------------------
prompt fazo_z.run('htt_unknown_devices')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_unknown_devices');
