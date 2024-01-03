prompt migr from 03.03.2023 v2.20.0 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt changes in hper_plan_types
----------------------------------------------------------------------------------------------------
alter table hper_plan_types drop constraint hper_plan_types_c2;
alter table hper_plan_types drop constraint hper_plan_types_c3;
alter table hper_plan_types drop constraint hper_plan_types_c4;
alter table hper_plan_types drop constraint hper_plan_types_c5;

alter table hper_plan_types add extra_amount_enabled varchar2(1);
alter table hper_plan_types add sale_kind            varchar2(1);

alter table hper_plan_types add constraint hper_plan_types_c2 check (calc_kind in ('M', 'T', 'A', 'E'));
alter table hper_plan_types add constraint hper_plan_types_c3 check (with_part in ('Y', 'N'));
alter table hper_plan_types add constraint hper_plan_types_c4 check (extra_amount_enabled in ('N', 'Y'));
alter table hper_plan_types add constraint hper_plan_types_c5 check (sale_kind in ('P', 'D'));
alter table hper_plan_types add constraint hper_plan_types_c6 check (state in ('A', 'P'));
alter table hper_plan_types add constraint hper_plan_types_c7 check (decode(trim(code), code, 1, 0) = 1);
comment on column hper_plan_types.calc_kind            is '(M)anual, (T)ask, (A)ttendance, (E)xternal';
comment on column hper_plan_types.extra_amount_enabled is 'If yes, then extra value(the percentage of plan according to plan type rules) will be added to fact amount';
comment on column hper_plan_types.sale_kind            is '(P)ersonal, (D)epartment, when calc kind is external then this in use';

update hper_plan_types
   set extra_amount_enabled = 'N',
       sale_kind = 'P';
commit;

alter table hper_plan_types modify extra_amount_enabled not null;
alter table hper_plan_types modify sale_kind            not null;

----------------------------------------------------------------------------------------------------
prompt new table hes_routes
----------------------------------------------------------------------------------------------------
create table hper_plan_type_rules(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  plan_type_id                    number(20)   not null,
  from_percent                    number(3)    not null,
  to_percent                      number(3),
  plan_percent                    number(20,6) not null,
  constraint hper_plan_type_rules_pk primary key (company_id, filial_id, plan_type_id, from_percent) using index tablespace GWS_INDEX,
  constraint hper_plan_type_rules_f1 foreign key (company_id, filial_id, plan_type_id) references hper_plan_types(company_id, filial_id, plan_type_id) on delete cascade,
  constraint hper_plan_type_rules_c1 check (from_percent <= to_percent),
  constraint hper_plan_type_rules_c2 check (from_percent >= 0)
) tablespace GWS_DATA;

comment on column hper_plan_type_rules.plan_percent is 'plan percent to be added to the fact';

----------------------------------------------------------------------------------------------------
prompt changes in hper_staff_plans
----------------------------------------------------------------------------------------------------
alter table hper_staff_plans drop constraint hper_staff_plans_c10;
alter table hper_staff_plans drop constraint hper_staff_plans_c11;
alter table hper_staff_plans drop constraint hper_staff_plans_c12;
alter table hper_staff_plans drop constraint hper_staff_plans_c13;
alter table hper_staff_plans drop constraint hper_staff_plans_c14;

alter table hper_staff_plans add constraint hper_staff_plans_c10 check (main_fact_percent >= 0);
alter table hper_staff_plans add constraint hper_staff_plans_c11 check (extra_fact_percent >= 0);
alter table hper_staff_plans add constraint hper_staff_plans_c12 check (status in ('D', 'N', 'W', 'C'));

----------------------------------------------------------------------------------------------------
prompt changes in hper_staff_plan_items
----------------------------------------------------------------------------------------------------
alter table hper_staff_plan_items drop constraint hper_staff_plan_items_c7;

alter table hper_staff_plan_items add extra_amount_enabled varchar2(1);
alter table hper_staff_plan_items add sale_kind            varchar2(1);
alter table hper_staff_plan_items add extra_amount         number(20,6);

alter table hper_staff_plan_items add constraint hper_staff_plan_items_c7 check (calc_kind in ('M', 'T', 'A', 'E'));
alter table hper_staff_plan_items add constraint hper_staff_plan_items_c8 check (extra_amount_enabled in ('N', 'Y'));
alter table hper_staff_plan_items add constraint hper_staff_plan_items_c9 check (sale_kind in ('P', 'D'));

comment on column hper_staff_plan_items.calc_kind is '(M)anual, (T)ask execution, (A)ttendance estimation, (E)xternal';
comment on column hper_staff_plan_items.sale_kind is '(P)ersonal, (D)epartment, when calc kind is external then this in use';

update hper_staff_plan_items
   set extra_amount_enabled = 'N',
       sale_kind = 'P';
commit;

alter table hper_staff_plan_items modify extra_amount_enabled not null;
alter table hper_staff_plan_items modify sale_kind            not null;

----------------------------------------------------------------------------------------------------
prompt new table hper_staff_plan_type_rules
----------------------------------------------------------------------------------------------------
create table hper_staff_plan_type_rules(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  staff_plan_id                   number(20)   not null,
  plan_type_id                    number(20)   not null,
  from_percent                    number(3)    not null,
  to_percent                      number(3),
  plan_percent                    number(20,6) not null,
  constraint hper_staff_plan_type_rules_pk primary key (company_id, filial_id, staff_plan_id, plan_type_id, from_percent) using index tablespace GWS_INDEX,
  constraint hper_staff_plan_type_rules_f1 foreign key (company_id, filial_id, staff_plan_id, plan_type_id) references hper_staff_plan_items(company_id, filial_id, staff_plan_id, plan_type_id) on delete cascade,
  constraint hper_staff_plan_type_rules_c1 check (from_percent <= to_percent),
  constraint hper_staff_plan_type_rules_c2 check (from_percent >= 0)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt hes billz tables
----------------------------------------------------------------------------------------------------
create table hes_billz_credentials(
  company_id                      number(20)     not null,
  filial_id                       number(20)     not null,
  subject_name                    varchar2(4000) not null,
  secret_key                      varchar2(4000) not null,
  constraint hes_billz_credentials_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_credentials is 'credentials to access Billz API';

----------------------------------------------------------------------------------------------------
create table hes_billz_consolidated_sales(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  sale_id                         number(20)    not null,
  billz_office_id                 number(20)    not null,
  billz_seller_name               varchar2(500) not null,
  sale_date                       date          not null,
  sale_amount                     number(20, 6),
  constraint hes_billz_consolidated_sales_pk primary key (company_id, filial_id, sale_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_consolidated_sales is 'consolidated daily sales amount for each user from Billz';

----------------------------------------------------------------------------------------------------    
create global temporary table hes_billz_raw_sales(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  billz_office_id                 number(20)    not null,
  billz_seller_name               varchar2(500) not null,
  sale_date                       date          not null,
  sale_amount                     number(20, 6)
);

comment on table hes_billz_raw_sales is 'raw Billz sales data';

----------------------------------------------------------------------------------------------------
create table hes_billz_sale_dates(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  sale_date                       date          not null,
  constraint hes_billz_sale_dates_pk primary key (company_id, filial_id, sale_date) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_sale_dates is 'service table used for locking sale data by dates';

----------------------------------------------------------------------------------------------------
prompt create sequence hes_billz_consolidated_sales_sq
----------------------------------------------------------------------------------------------------
create sequence hes_billz_consolidated_sales_sq;

----------------------------------------------------------------------------------------------------
prompt new table hrm_job_bonus_types
----------------------------------------------------------------------------------------------------
create table hrm_job_bonus_types(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  job_id                          number(20)   not null,
  bonus_type                      varchar2(1)  not null,
  percentage                      number(20,6) not null,
  constraint hrm_job_bonus_types_pk primary key (company_id, filial_id, job_id, bonus_type) using index tablespace GWS_INDEX,
  constraint hrm_job_bonus_types_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade,
  constraint hrm_job_bonus_types_c1 check (bonus_type in ('P', 'D', 'S')),
  constraint hrm_job_bonus_types_c2 check (percentage >= 0)
) tablespace GWS_DATA;

comment on column hrm_job_bonus_types.bonus_type is '(P)ersonal sales, (D)epartment sales, (S)uccessful delivery';

----------------------------------------------------------------------------------------------------
prompt new table hpr_sales_bonus_payments
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
prompt new table hpr_sales_bonus_payment_operations
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
  constraint hpr_sales_bonus_payment_operations_c5 check (sales_amount > 0) deferrable initially deferred,
  constraint hpr_sales_bonus_payment_operations_c6 check (percentage > 0),
  constraint hpr_sales_bonus_payment_operations_c7 check (amount > 0) deferrable initially deferred
) tablespace GWS_DATA;

create index hpr_sales_bonus_payment_operations_i1 on hpr_sales_bonus_payment_operations(company_id, filial_id, payment_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payment_operations_i2 on hpr_sales_bonus_payment_operations(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpr_sales_bonus_payment_operations_i3 on hpr_sales_bonus_payment_operations(company_id, filial_id, job_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpr_sales_bonus_payment_operation_periods
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
  constraint hpr_sales_bonus_payment_operation_periods_c1 check (period = trunc(period)),
  constraint hpr_sales_bonus_payment_operation_periods_c2 check (sales_amount >= 0),
  constraint hpr_sales_bonus_payment_operation_periods_c3 check (amount >= 0)
) tablespace GWS_DATA;

create index hpr_sales_bonus_payment_operation_periods_i1 on hpr_sales_bonus_payment_operation_periods(company_id, filial_id, c_staff_id, c_bonus_type, period) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new table hpr_sales_bonus_payment_intervals
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
prompt hpd_lock_intervals changes
----------------------------------------------------------------------------------------------------
alter table hpd_lock_intervals drop constraint hpd_lock_intervals_c4;

alter table hpd_lock_intervals add constraint hpd_lock_intervals_c4 check (kind in ('T', 'O', 'P', 'S', 'R', 'L'));
comment on column hpd_lock_intervals.kind is '(T)imebook, Time(O)ff, (P)erformance, Sales Bonus Per(S)onal Sales, Sales Bonus Depa(R)tment Sales, Sales Bonus Successful De(L)ivery';

----------------------------------------------------------------------------------------------------
prompt new sequences hpr_sales_bonus_payments_sq, hpr_sales_bonus_payment_operations_sq
----------------------------------------------------------------------------------------------------
create sequence hpr_sales_bonus_payments_sq;
create sequence hpr_sales_bonus_payment_operations_sq;

----------------------------------------------------------------------------------------------------
prompt new indexes
----------------------------------------------------------------------------------------------------
create index hlic_required_dates_i1 on hlic_required_dates(company_id, filial_id, staff_id) tablespace GWS_INDEX;

drop index hln_question_group_binds_i1;
drop index hln_training_persons_i1;
create index hln_question_group_binds_i1 on hln_question_group_binds(company_id, filial_id, question_group_id, question_type_id) tablespace GWS_INDEX;
create index hln_training_persons_i1 on hln_training_persons(company_id, person_id) tablespace GWS_INDEX;

create index hpd_business_trips_i3 on hpd_business_trips(company_id, region_id) tablespace GWS_INDEX;
create index hpd_rank_changes_i1 on hpd_rank_changes(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpd_timeoff_days_i2 on hpd_timeoff_days(company_id, time_kind_id) tablespace GWS_INDEX;

create index hper_plan_rules_i1 on hper_plan_rules(company_id, filial_id, plan_id, plan_type_id) tablespace GWS_INDEX;
create index hper_staff_plans_i6 on hper_staff_plans(company_id, created_by) tablespace GWS_INDEX;
create index hper_staff_plan_parts_i1 on hper_staff_plan_parts(company_id, filial_id, staff_plan_id, plan_type_id) tablespace GWS_INDEX;
create index hper_staff_plan_parts_i2 on hper_staff_plan_parts(company_id, created_by) tablespace GWS_INDEX;
create index hper_staff_plan_parts_i3 on hper_staff_plan_parts(company_id, modified_by) tablespace GWS_INDEX;

drop index hper_staff_plan_tasks_i1;
drop index hper_satff_plan_task_types_i1;
create index hper_staff_plan_tasks_i1 on hper_staff_plan_tasks(company_id, task_id) tablespace GWS_INDEX;
create index hper_staff_plan_task_types_i1 on hper_staff_plan_task_types(company_id, task_type_id) tablespace GWS_INDEX;

create index hpr_timebook_staffs_i2 on hpr_timebook_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_timebook_staffs_i3 on hpr_timebook_staffs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_timebook_staffs_i4 on hpr_timebook_staffs(company_id, filial_id, division_id) tablespace GWS_INDEX;

create index href_candidates_i5 on href_candidates(company_id, candidate_id) tablespace GWS_INDEX;
create index href_person_details_i1 on href_person_details(company_id, nationality_id) tablespace GWS_INDEX;

create index htt_devices_i5 on htt_devices(device_type_id) tablespace GWS_INDEX;
create index htt_location_filials_i2 on htt_location_filials(company_id, location_id) tablespace GWS_INDEX;
create index htt_robot_schedule_days_i3 on htt_robot_schedule_days(company_id, filial_id, unit_id, schedule_date) tablespace GWS_INDEX;
create index htt_staff_schedule_days_i3 on htt_staff_schedule_days(company_id, filial_id, unit_id, schedule_date) tablespace GWS_INDEX;
create index htt_acms_commands_i2 on htt_acms_commands(company_id, person_id) tablespace GWS_DATA;

create index hzk_attlog_errors_i1 on hzk_attlog_errors(company_id, device_id) tablespace GWS_DATA;

----------
alter table htt_acms_commands rename constraint htt_commands_acms_pk to htt_acms_commands_pk;
alter table htt_acms_commands rename constraint htt_commands_acms_u1 to htt_acms_commands_u1;
alter table htt_acms_commands rename constraint htt_commands_acms_f1 to htt_acms_commands_f1;
alter table htt_acms_commands rename constraint htt_commands_acms_f2 to htt_acms_commands_f2;
alter table htt_acms_commands rename constraint htt_commands_acms_c1 to htt_acms_commands_c1;
alter table htt_acms_commands rename constraint htt_commands_acms_c2 to htt_acms_commands_c2;
alter table htt_acms_commands rename constraint htt_commands_acms_c3 to htt_acms_commands_c3;
alter table htt_acms_commands rename constraint htt_commands_acms_c4 to htt_acms_commands_c4;

----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from User_Objects s
             where Lower(s.Object_Name) = 'htt_change_days_i3')
  loop
    execute immediate 'drop index htt_change_days_i3';
  end loop;
end;
/
create index htt_change_days_i3 on htt_change_days(company_id, filial_id, change_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt add new column for penalty policies
----------------------------------------------------------------------------------------------------
alter table hpr_penalty_policies add calc_after_from_time varchar2(1);

alter table hpr_penalty_policies add constraint hpr_penalty_policies_c10 check (calc_after_from_time in ('Y', 'N'));
alter table hpr_penalty_policies add constraint hpr_penalty_policies_c11 check (penalty_time is not null and calc_after_from_time is null or penalty_time is null);

comment on column hpr_penalty_policies.calc_after_from_time is 'Calculate penalty after from time ?';

----------------------------------------------------------------------------------------------------
prompt sequences renamed
----------------------------------------------------------------------------------------------------
rename href_fixed_term_basies_sq to href_fixed_term_bases_sq;
rename hpr_wage_sheet_sq to hpr_wage_sheets_sq;
rename htt_plan_change_sq to htt_plan_changes_sq;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run();
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hes');
exec fazo_z.run('hper_plan_types');
exec fazo_z.run('hper_plan_type_rules');
exec fazo_z.run('hper_staff_plans');
exec fazo_z.run('hper_staff_plan_items');
exec fazo_z.run('hper_staff_plan_type_rules');
exec fazo_z.run('hrm_job_bonus_types');
exec fazo_z.run('hpr_sales_bonus_payments');
exec fazo_z.run('hpr_sales_bonus_payment_operations');
exec fazo_z.run('hpr_sales_bonus_payment_operation_periods');
exec fazo_z.run('hpr_sales_bonus_payment_intervals');
exec fazo_z.run('hpd_lock_intervals');
exec fazo_z.run('hpr_penalty_policies');
