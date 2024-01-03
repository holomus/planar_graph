prompt constraint modified
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hpr_wage_sheets drop constraint hpr_wage_sheets_c4;
alter table hpr_wage_sheets add constraint hpr_wage_sheets_c4 check (period_begin <= period_end and 
                                                                     ((extract(year from period_begin) = extract(year from period_end) and 
                                                                      extract(month from period_end) - extract(month from period_begin) <= 1)
                                                                      or 
                                                                      (extract(year from period_begin) <> extract(year from period_end) and 
                                                                      abs(extract(month from period_end) - extract(month from period_begin)) = 11)));

---------------------------------------------------------------------------------------------------- 
prompt adding hac_sync_persons
----------------------------------------------------------------------------------------------------
create table hac_sync_persons(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  constraint hac_sync_persons_pk primary key (company_id, person_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hac_sync_persons is 'Persons that need to be synchronised with devices';

----------------------------------------------------------------------------------------------------
prompt adding person blocking
----------------------------------------------------------------------------------------------------
create table htt_blocked_person_tracking(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  employee_id                     number(20) not null,
  constraint htt_blocked_person_tracking_pk primary key (company_id, filial_id, employee_id) using index tablespace GWS_DATA,
  constraint htt_blocked_person_tracking_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt adding Credits
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

---------------------------------------------------------------------------------------------------- 
create sequence hpr_credits_sq;

---------------------------------------------------------------------------------------------------- 
prompt add index for timesheet tables
----------------------------------------------------------------------------------------------------
create index htt_timesheet_tracks_i2 on htt_timesheet_tracks(company_id, filial_id, timesheet_id, track_type, track_datetime) tablespace GWS_INDEX;
---------------------------------------------------------------------------------------------------- 
create index htt_timesheet_intervals_i1 on htt_timesheet_intervals(company_id, filial_id, timesheet_id) tablespace GWS_INDEX;
