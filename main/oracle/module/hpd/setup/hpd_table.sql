prompt Personal document module
prompt (c) 2020 Verifix HR

----------------------------------------------------------------------------------------------------
-- Journals
----------------------------------------------------------------------------------------------------
create table hpd_journal_types(
  company_id                      number(20)         not null,
  journal_type_id                 number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6)          not null,
  pcode                           varchar2(20)       not null,
  constraint hpd_journal_types_pk primary key (company_id, journal_type_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_types_u1 unique (journal_type_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_types_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint hpd_journal_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpd_journal_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hpd_journals(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  journal_id                      number(20)        not null,
  journal_type_id                 number(20)        not null,
  journal_number                  varchar2(50 char) not null,
  journal_date                    date              not null,
  journal_name                    varchar2(150 char),
  posted                          varchar2(1)       not null,
  posted_order_no                 number(20),
  source_table                    varchar2(100),
  source_id                       number(20),
  sign_document_id                number(20),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)        not null,
  constraint hpd_journals_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_journals_u1 unique (journal_id) using index tablespace GWS_INDEX,
  constraint hpd_journals_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpd_journals_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpd_journals_f2 foreign key (company_id, journal_type_id) references hpd_journal_types(company_id, journal_type_id),
  constraint hpd_journals_f3 foreign key (company_id, sign_document_id) references mdf_sign_documents(company_id, document_id),
  constraint hpd_journals_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_journals_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_journals_c1 check (decode(trim(journal_number), journal_number, 1, 0) = 1),
  constraint hpd_journals_c2 check (decode(trim(journal_name), journal_name, 1, 0) = 1),
  constraint hpd_journals_c3 check (posted in ('Y', 'N')),
  constraint hpd_journals_c4 check (nvl2(source_table, 1, 0) = nvl2(source_id, 1, 0))
) tablespace GWS_DATA;

comment on column hpd_journals.posted       is '(Y)es, (N)o';
comment on column hpd_journals.source_table is 'keeps table name which created this journal, null if this jounal created by journal forms';

create index hpd_journals_i1 on hpd_journals(company_id, journal_type_id) tablespace GWS_INDEX;
create index hpd_journals_i2 on hpd_journals(company_id, sign_document_id) tablespace GWS_INDEX;
create index hpd_journals_i3 on hpd_journals(company_id, created_by) tablespace GWS_INDEX;
create index hpd_journals_i4 on hpd_journals(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_journal_pages(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  journal_id                      number(20)  not null,
  page_id                         number(20)  not null,
  staff_id                        number(20)  not null,
  employee_id                     number(20)  not null,
  modified_id                     number(20)  not null,
  constraint hpd_journal_pages_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_pages_u1 unique (page_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_pages_u2 unique (company_id, filial_id, journal_id, staff_id) deferrable initially deferred using index tablespace GWS_INDEX,
  constraint hpd_journal_pages_u3 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_pages_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_pages_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_journal_pages_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id)
) tablespace GWS_DATA;

create index hpd_journal_pages_i1 on hpd_journal_pages(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_journal_pages_i2 on hpd_journal_pages(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_journal_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20) not null,
  constraint hpd_journal_divisions_pk primary key (company_id, filial_id, journal_id, division_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_divisions_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

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
create table hpd_journal_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  staff_id                        number(20) not null,
  constraint hpd_journal_staffs_pk primary key (company_id, filial_id, journal_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_staffs_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade
) tablespace GWS_DATA;

comment on table hpd_journal_staffs is 'Keeps distinct staffs in journal';

create index hpd_journal_staffs_i1 on hpd_journal_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hpd_auto_created_robots(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  robot_id                        number(20)  not null,
  journal_id                      number(20)  not null,
  page_id                         number(20)  not null,
  valid                           varchar2(1) not null,
  constraint hpd_auto_created_robots_pk primary key (company_id, filial_id, robot_id),
  constraint hpd_auto_created_robots_c1 check (valid in ('Y', 'N')),
  constraint hpd_auto_created_robots_c2 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create global temporary table hpd_auto_created_staffs(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  journal_id                      number(20)  not null,
  page_id                         number(20)  not null,
  valid                           varchar2(1) not null,
  constraint hpd_auto_created_staffs_pk primary key (company_id, filial_id, staff_id),
  constraint hpd_auto_created_staffs_c1 check (valid in ('Y', 'N')),
  constraint hpd_auto_created_staffs_c2 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
-- Hiring
----------------------------------------------------------------------------------------------------
create table hpd_hirings(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  page_id                         number(20)  not null,
  staff_id                        number(20)  not null,
  hiring_date                     date        not null,
  dismissal_date                  date,
  trial_period                    number(20)  not null,
  employment_source_id            number(20),
  constraint hpd_hirings_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_hirings_u1 unique (company_id, filial_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpd_hirings_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_hirings_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_hirings_f3 foreign key (company_id, employment_source_id) references href_employment_sources(company_id, source_id),
  constraint hpd_hirings_c1 check (trunc(hiring_date) = hiring_date),
  constraint hpd_hirings_c2 check (trunc(dismissal_date) = dismissal_date),
  constraint hpd_hirings_c3 check (hiring_date <= dismissal_date),
  constraint hpd_hirings_c4 check (trial_period between 0 and 366)
) tablespace GWS_DATA;

comment on column hpd_hirings.trial_period is 'measured by day';

create index hpd_hirings_i1 on hpd_hirings(company_id, employment_source_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Transfer
----------------------------------------------------------------------------------------------------
create table hpd_transfers(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  transfer_begin                  date         not null,
  transfer_end                    date,
  transfer_reason                 varchar2(300 char),
  transfer_base                   varchar2(300 char),
  constraint hpd_transfers_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_transfers_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_transfers_c1 check (trunc(transfer_begin) = transfer_begin),
  constraint hpd_transfers_c2 check (trunc(transfer_end) = transfer_end),
  constraint hpd_transfers_c3 check (transfer_begin <= transfer_end)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Dismissal
----------------------------------------------------------------------------------------------------
create table hpd_dismissals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  dismissal_date                  date       not null,
  dismissal_reason_id             number(20),
  employment_source_id            number(20),
  based_on_doc                    varchar2(300 char),
  note                            varchar2(300 char),
  constraint hpd_dismissals_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,  
  constraint hpd_dismissals_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_dismissals_f2 foreign key (company_id, dismissal_reason_id) references href_dismissal_reasons(company_id, dismissal_reason_id),
  constraint hpd_dismissals_f3 foreign key (company_id, employment_source_id) references href_employment_sources(company_id, source_id),
  constraint hpd_dismissals_c1 check (trunc(dismissal_date) = dismissal_date)
) tablespace GWS_DATA;

create index hpd_dismissals_i1 on hpd_dismissals(company_id, dismissal_reason_id) tablespace GWS_INDEX;
create index hpd_dismissals_i2 on hpd_dismissals(company_id, employment_source_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                       
-- Wage change
----------------------------------------------------------------------------------------------------                       
create table hpd_wage_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  change_date                     date       not null,
  constraint hpd_wage_changes_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,  
  constraint hpd_wage_changes_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_wage_changes_c1 check (trunc(change_date) = change_date)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------                       
-- Rank change
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

create index hpd_rank_changes_i1 on hpd_rank_changes(company_id, filial_id, rank_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Vacation limit change
----------------------------------------------------------------------------------------------------
create table hpd_vacation_limit_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  change_date                     date       not null,
  days_limit                      number(20) not null,
  constraint hpd_vacation_limit_changes_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_vacation_limit_changes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_vacation_limit_changes_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_vacation_limit_changes_c1 check (trunc(change_date) = change_date),
  constraint hpd_vacation_limit_changes_c2 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

create index hpd_vacation_limit_changes_i1 on hpd_vacation_limit_changes(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Schedule change
----------------------------------------------------------------------------------------------------        
create table hpd_schedule_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  begin_date                      date       not null,
  end_date                        date,
  constraint hpd_schedule_changes_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_schedule_changes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_schedule_changes_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_schedule_changes_c1 check (begin_date = trunc(begin_date)),
  constraint hpd_schedule_changes_c2 check (end_date = trunc(end_date)),
  constraint hpd_schedule_changes_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_schedule_changes_i1 on hpd_schedule_changes(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Page robots
----------------------------------------------------------------------------------------------------  
create table hpd_page_robots(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  robot_id                        number(20)   not null,
  division_id                     number(20)   not null,
  job_id                          number(20)   not null,
  rank_id                         number(20),
  allow_rank                      varchar2(1),
  employment_type                 varchar2(1)  not null,
  fte_id                          number(20),
  fte                             number(20,6),
  is_booked                       varchar2(1)  not null,
  constraint hpd_page_robots_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_robots_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_page_robots_f3 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint hpd_page_robots_f4 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_page_robots_f5 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpd_page_robots_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id),
  constraint hpd_page_robots_c1 check (employment_type in ('M', 'E', 'I', 'C')),
  constraint hpd_page_robots_c2 check (fte > 0 and fte <= 1),
  constraint hpd_page_robots_c3 check (fte_id is not null or fte_id is null and fte is not null),
  constraint hpd_page_robots_c4 check (is_booked in ('Y', 'N')),
  constraint hpd_page_robots_c5 check (allow_rank in ('Y', 'N')),
  constraint hpd_page_robots_c6 check (allow_rank = 'Y' or allow_rank = 'N' and rank_id is null)
) tablespace GWS_DATA;

comment on column hpd_page_robots.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';
comment on column hpd_page_robots.fte             is 'Full-time equivalent';
comment on column hpd_page_robots.allow_rank      is '(Y)es, (N)o';

create index hpd_page_robots_i1 on hpd_page_robots(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_page_robots_i2 on hpd_page_robots(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpd_page_robots_i3 on hpd_page_robots(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_page_robots_i4 on hpd_page_robots(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpd_page_robots_i5 on hpd_page_robots(company_id, fte_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- robot transaction pages
---------------------------------------------------------------------------------------------------- 
create table hpd_robot_trans_pages(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  page_id                         number(20)   not null,
  trans_id                        number(20)   not null,
  constraint hpd_robot_trans_pages_pk primary key (company_id, filial_id, page_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_robot_trans_pages_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_robot_trans_pages_f2 foreign key (company_id, filial_id, trans_id) references hrm_robot_transactions(company_id, filial_id, trans_id) on delete cascade
) tablespace GWS_DATA;

create index hpd_robot_trans_pages_i1 on hpd_robot_trans_pages(company_id, filial_id, trans_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- page vacation limits
----------------------------------------------------------------------------------------------------
create table hpd_page_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  days_limit                      number(20) not null,
  constraint hpd_page_vacation_limits_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_vacation_limits_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hpd_page_vacation_limits is 'Keeps days limit for vacations';

----------------------------------------------------------------------------------------------------
-- Contracts
----------------------------------------------------------------------------------------------------
create table hpd_page_contracts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  contract_number                 varchar2(50 char),
  contract_date                   date,
  fixed_term                      varchar2(1),
  expiry_date                     date,
  fixed_term_base_id              number(20),
  concluding_term                 varchar2(300 char),
  hiring_conditions               varchar2(300 char),
  other_conditions                varchar2(300 char),
  workplace_equipment             varchar2(300 char),
  representative_basis            varchar2(300 char),
  constraint hpd_page_contracts_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_contracts_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_contracts_f2 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id),
  constraint hpd_page_contracts_c1 check (fixed_term in ('Y', 'N')),
  constraint hpd_page_contracts_c2 check (decode(trim(contract_number), contract_number, 1, 0) = 1),
  constraint hpd_page_contracts_c3 check (trunc(contract_date) = contract_date),
  constraint hpd_page_contracts_c4 check (trunc(expiry_date) = expiry_date),
  constraint hpd_page_contracts_c5 check (expiry_date is null or fixed_term = 'Y'),
  constraint hpd_page_contracts_c6 check (fixed_term_base_id is null or fixed_term = 'Y'),
  constraint hpd_page_contracts_c7 check (concluding_term is null or fixed_term = 'Y')
) tablespace GWS_DATA;

comment on column hpd_page_contracts.fixed_term is '(Y)es, (N)o';

create index hpd_page_contracts_i1 on hpd_page_contracts(company_id, fixed_term_base_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table hpd_page_schedules(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,  
  schedule_id                     number(20) not null,
  constraint hpd_page_schedules_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_schedules_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_schedules_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id)
) tablespace GWS_DATA;

create index hpd_page_schedules_i1 on hpd_page_schedules(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_page_currencies(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  currency_id                     number(20) not null,
  constraint hpd_page_currencies_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_currencies_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_currencies_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id)
) tablespace GWS_DATA;

create index hpd_page_currencies_i1 on hpd_page_currencies(company_id, currency_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Operation types
----------------------------------------------------------------------------------------------------
create table hpd_page_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hpd_page_oper_types_pk primary key (company_id, filial_id, page_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpd_page_oper_types_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hpd_page_oper_types_i1 on hpd_page_oper_types(company_id, oper_type_id) tablespace GWS_INDEX;

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
-- Timeoffs
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
create table hpd_timeoff_days(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  timeoff_date                    date        not null,
  timeoff_id                      number(20)  not null,
  time_kind_id                    number(20)  not null,
  turnout_locked                  varchar2(1) not null,
  constraint hpd_timeoff_days_pk primary key (company_id, filial_id, staff_id, timeoff_date) using index tablespace GWS_INDEX,
  constraint hpd_timeoff_days_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_timeoff_days_f2 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id),
  constraint hpd_timeoff_days_f3 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpd_timeoff_days_c1 check (turnout_locked in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hpd_timeoff_days is 'Keeps days affected by posted timeoff';

comment on column hpd_timeoff_days.turnout_locked is '(Y)es, (N)o. (Y)es only when turnout fact was locked during timeoff post process.';
comment on column hpd_timeoff_days.time_kind_id is 'Keeps time kind related to timeoff. E.g.: Vacation time kind for vacation timeoff.';

create index hpd_timeoff_days_i1 on hpd_timeoff_days(company_id, filial_id, timeoff_id) tablespace GWS_INDEX;
create index hpd_timeoff_days_i2 on hpd_timeoff_days(company_id, time_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Sick leaves
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
-- Business Trips
----------------------------------------------------------------------------------------------------
create table hpd_business_trips(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  person_id                       number(20),
  reason_id                       number(20) not null,
  note                            varchar2(300 char),
  constraint hpd_business_trips_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_business_trips_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade,
  constraint hpd_business_trips_f2 foreign key (company_id, person_id) references mr_legal_persons(company_id, person_id),
  constraint hpd_business_trips_f3 foreign key (company_id, filial_id, reason_id) references href_business_trip_reasons(company_id, filial_id, reason_id)
) tablespace GWS_DATA;

comment on column hpd_business_trips.person_id is 'Destination organization';

create index hpd_business_trips_i1 on hpd_business_trips(company_id, person_id) tablespace GWS_INDEX;
create index hpd_business_trips_i2 on hpd_business_trips(company_id, filial_id, reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_business_trip_regions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_Id                      number(20) not null,
  region_id                       number(20) not null,
  order_no                        number(5)  not null,
  constraint hpd_business_trip_regions_pk primary key (company_id, filial_id, timeoff_id, region_id, order_no) using index tablespace GWS_INDEX,
  constraint hpd_business_trip_regions_f1 foreign key (company_id, filial_id, timeoff_Id) references hpd_business_trips(company_id, filial_id, timeoff_Id) on delete cascade,
  constraint hpd_business_trip_regions_f2 foreign key (company_id, region_id) references md_regions(company_id, region_id)
) tablespace GWS_DATA;

comment on column hpd_business_trip_regions.order_no is 'Order of regions on business trip';

create index hpd_business_trip_regions_i1 on hpd_business_trip_regions(company_id, region_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_vacations(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_id                      number(20) not null,
  time_kind_id                    number(20) not null,
  constraint hpd_vacations_pk primary key (company_id, filial_id, timeoff_id) using index tablespace GWS_INDEX,
  constraint hpd_vacations_f1 foreign key (company_id, filial_id, timeoff_id) references hpd_journal_timeoffs(company_id, filial_id, timeoff_id) on delete cascade,
  constraint hpd_vacations_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id)
) tablespace GWS_DATA;

create index hpd_vacations_i1 on hpd_vacations(company_id, time_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Overtime hours
----------------------------------------------------------------------------------------------------
create table hpd_journal_overtimes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  overtime_id                     number(20) not null,
  journal_id                      number(20) not null,
  employee_id                     number(20) not null,
  staff_id                        number(20) not null,
  begin_date                      date       not null,
  end_date                        date       not null,
  modified_id                     number(20) not null,
  constraint hpd_journal_overtimes_pk primary key (company_id, filial_id, overtime_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_overtimes_u1 unique (overtime_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_overtimes_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_overtimes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_overtimes_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_journal_overtimes_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_journal_overtimes_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_journal_overtimes_c2 check (trunc(end_date) = end_date),
  constraint hpd_journal_overtimes_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_journal_overtimes_i1 on hpd_journal_overtimes(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_journal_overtimes_i2 on hpd_journal_overtimes(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_journal_overtimes_i3 on hpd_journal_overtimes(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_overtime_days(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  overtime_date                   date       not null,
  overtime_seconds                number(20) not null,
  overtime_id                     number(20) not null,
  constraint hpd_overtime_days_pk primary key (company_id, filial_id, staff_id, overtime_date) using index tablespace GWS_INDEX,
  constraint hpd_overtime_days_f1 foreign key (company_id, filial_id, overtime_id) references hpd_journal_overtimes(company_id, filial_id, overtime_id) on delete cascade,
  constraint hpd_overtime_days_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_overtime_days_c1 check (trunc(overtime_date) = overtime_date),
  constraint hpd_overtime_days_c2 check (overtime_seconds between 0 and 86400)
) tablespace GWS_DATA;

create index hpd_overtime_days_i1 on hpd_overtime_days(company_id, filial_id, overtime_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_overtime_journal_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20) not null, 
  constraint hpd_overtime_journal_divisions_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_overtime_journal_divisions_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_overtime_journal_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id)
) tablespace GWS_DATA;

create index hpd_overtime_journal_divisions_i1 on hpd_overtime_journal_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Timebook adjustment
----------------------------------------------------------------------------------------------------
create table hpd_journal_timebook_adjustments(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  adjustment_date                 date       not null,
  constraint hpd_journal_timebook_adjustments_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_journal_timebook_adjustments_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_journal_timebook_adjustments_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_journal_timebook_adjustments_c1 check (trunc(adjustment_date) = adjustment_date)
) tablespace GWS_DATA;

create index hpd_journal_timebook_adjustments_i1 on hpd_journal_timebook_adjustments(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_page_adjustments(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  page_id                         number(20)  not null,
  kind                            varchar2(1) not null,
  free_time                       number(4)   not null,
  overtime                        number(4)   not null,
  turnout_time                    number(4)   not null,
  constraint hpd_page_adjustments_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_adjustments_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_adjustments_c1 check (kind in ('F', 'I')),
  constraint hpd_page_adjustments_c2 check (kind = 'I' and free_time = 0 or free_time > 0),
  constraint hpd_page_adjustments_c3 check (overtime >= 0),
  constraint hpd_page_adjustments_c4 check (turnout_time >= 0),
  constraint hpd_page_adjustments_c5 check (kind = 'I' or free_time >= turnout_time)
) tablespace GWS_DATA;

comment on column hpd_page_adjustments.kind         is '(F)ull, (I)ncomplete. (I)ncomplete works when employee has no attendance';
comment on column hpd_page_adjustments.free_time    is 'Measured in minutes';
comment on column hpd_page_adjustments.overtime     is 'Measured in minutes';
comment on column hpd_page_adjustments.turnout_time is 'Measured in minutes';

----------------------------------------------------------------------------------------------------
create table hpd_lock_adjustments(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  adjustment_date                 date        not null,
  kind                            varchar2(1) not null,
  journal_id                      number(20)  not null,
  page_id                         number(20)  not null,
  constraint hpd_lock_adjustments_pk primary key (company_id, filial_id, staff_id, adjustment_date) using index tablespace GWS_INDEX,
  constraint hpd_lock_adjustments_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_lock_adjustments_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint hpd_lock_adjustments_f3 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id),
  constraint hpd_lock_adjustments_c1 check (kind in ('F', 'I'))
) tablespace GWS_DATA;

comment on column hpd_lock_adjustments.kind is '(F)ull, (I)ncomplete. (I)ncomplete works when employee has no attendance';

create index hpd_lock_adjustments_i1 on hpd_lock_adjustments(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_lock_adjustments_i2 on hpd_lock_adjustments(company_id, filial_id, page_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_adjustment_deleted_facts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  adjustment_date                 date       not null,
  time_kind_id                    number(20) not null,
  fact_value                      number(6) not null,
  constraint hpd_adjustment_deleted_facts_pk primary key (company_id, filial_id, staff_id, adjustment_date, time_kind_id) using index tablespace GWS_INDEX,
  constraint hpd_adjustment_deleted_facts_f1 foreign key (company_id, filial_id, staff_id, adjustment_date) references hpd_lock_adjustments(company_id, filial_id, staff_id, adjustment_date) on delete cascade,
  constraint hpd_adjustment_deleted_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpd_adjustment_deleted_facts_c1 check (fact_value >= 0)
) tablespace GWS_DATA;

comment on table hpd_adjustment_deleted_facts is 'Backup copies from htt_timesheet_facts in case adjustment will be unposted';

comment on column hpd_adjustment_deleted_facts.fact_value is 'Exact same value of htt_timesheet_facts and the time when adjustment added its facts';

----------------------------------------------------------------------------------------------------
-- Lock intervals
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
  constraint hpd_lock_intervals_c4 check (kind in ('T', 'O', 'P', 'S', 'R', 'L'))
) tablespace GWS_DATA;

comment on column hpd_lock_intervals.kind is '(T)imebook, Time(O)ff, (P)erformance, Sales Bonus Per(S)onal Sales, Sales Bonus Depa(R)tment Sales, Sales Bonus Successful De(L)ivery';

create index hpd_lock_intervals_i1 on hpd_lock_intervals(company_id, filial_id, staff_id, kind) tablespace GWS_INDEX;

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
-- TRANSACTIONS
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
  event                           varchar2(1)   not null,
  constraint hpd_transactions_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_transactions_u1 unique (trans_id) using index tablespace GWS_INDEX,
  constraint hpd_transactions_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_transactions_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint hpd_transactions_f3 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) deferrable initially deferred,
  constraint hpd_transactions_c1 check (trans_type in ('B', 'O', 'S', 'R', 'L', 'C')),
  constraint hpd_transactions_c2 check (begin_date <= end_date),
  constraint hpd_transactions_c3 check (trunc(begin_date) = begin_date),
  constraint hpd_transactions_c4 check (trunc(end_date) = end_date),
  constraint hpd_transactions_c5 check (event in ('I', 'P', 'D')),
  constraint hpd_transactions_c6 check (event = 'P') deferrable initially deferred
) tablespace GWS_DATA;

comment on column hpd_transactions.trans_type is 'Ro(B)ot, (O)peration, (S)chedule, (R)ank, Vacation (L)imit, (C)urrency';
comment on column hpd_transactions.event      is 'to be (I)ntegrated, in (P)rogress, to be (D)eleted';

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
  division_id                     number(20)   not null,
  job_id                          number(20)   not null,
  employment_type                 varchar2(1)  not null,
  fte_id                          number(20),
  fte                             number(20,6) not null,
  contractual_wage                varchar2(1)  not null,
  wage_scale_id                   number(20),
  constraint hpd_trans_robots_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_robots_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_trans_robots_f3 foreign key (company_id, filial_id, wage_scale_id) references hrm_wage_scales(company_id, filial_id, wage_scale_id),
  constraint hpd_trans_robots_f4 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_trans_robots_f5 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpd_trans_robots_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id),
  constraint hpd_trans_robots_c1 check (employment_type in ('M', 'E', 'I', 'C')),
  constraint hpd_trans_robots_c2 check (contractual_wage in ('Y', 'N')),
  constraint hpd_trans_robots_c3 check (decode(contractual_wage, 'N', 1, 'Y', 0) = nvl2(wage_scale_id, 1, 0))
) tablespace GWS_DATA;

comment on column hpd_trans_robots.employment_type  is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';
comment on column hpd_trans_robots.fte              is 'Full-time equivalent';
comment on column hpd_trans_robots.contractual_wage is '(Y)es, (N)o';

create index hpd_trans_robots_i1 on hpd_trans_robots(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_trans_robots_i2 on hpd_trans_robots(company_id, filial_id, wage_scale_id) tablespace GWS_INDEX;
create index hpd_trans_robots_i3 on hpd_trans_robots(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_trans_robots_i4 on hpd_trans_robots(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpd_trans_robots_i5 on hpd_trans_robots(company_id, fte_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_trans_currencies(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  currency_id                     number(20)  not null,
  constraint hpd_trans_currencies_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_currencies_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_currencies_f2 foreign key (company_id, currency_id) references mk_currencies(company_id, currency_id)
) tablespace GWS_DATA;

create index hpd_trans_currencies_i1 on hpd_trans_currencies(company_id, currency_id) tablespace GWS_INDEX;

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
create table hpd_trans_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  trans_id                        number(20) not null,
  days_limit                      number(20) not null,
  constraint hpd_trans_vacation_limits_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_vacation_limits_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hpd_page_vacation_limits is 'Keeps days limit for vacations';

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
create table hpd_dismissal_transactions(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  trans_id                        number(20)  not null,
  staff_id                        number(20)  not null,
  dismissal_date                  date        not null,
  journal_id                      number(20)  not null,
  page_id                         number(20)  not null,
  event                           varchar2(1) not null,
  constraint hpd_dismissal_transactions_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_dismissal_transactions_u1 unique (trans_id) using index tablespace GWS_INDEX,
  constraint hpd_dismissal_transactions_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),  
  constraint hpd_dismissal_transactions_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id),
  constraint hpd_dismissal_transactions_f3 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) deferrable initially deferred,  
  constraint hpd_dismissal_transactions_c1 check (trunc(dismissal_date) = dismissal_date),
  constraint hpd_dismissal_transactions_c2 check (event in ('I', 'P', 'D')),
  constraint hpd_dismissal_transactions_c3 check (event = 'P') deferrable initially deferred
) tablespace GWS_DATA;

comment on column hpd_dismissal_transactions.event is 'to be (I)ntegrated, in (P)rogress, to be (D)eleted';

create index hpd_dismissal_transactions_i1 on hpd_dismissal_transactions(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_dismissal_transactions_i2 on hpd_dismissal_transactions(company_id, filial_id, journal_id) tablespace GWS_INDEX;
create index hpd_dismissal_transactions_i3 on hpd_dismissal_transactions(company_id, filial_id, page_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_agreements(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  trans_type                      varchar2(1) not null,
  period                          date        not null,
  trans_id                        number(20),
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
  trans_id                        number(20),
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
create table hpd_agreements_cache(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  begin_date                      date       not null,
  end_date                        date       not null,
  robot_id                        number(20) not null,
  schedule_id                     number(20),
  constraint hpd_agreements_cache_pk primary key (company_id, filial_id, staff_id, begin_date) using index tablespace GWS_INDEX,
  constraint hpd_agreements_cache_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_agreements_cache_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_agreements_cache_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpd_agreements_cache_c1 check (trunc(begin_date) = begin_date),
  constraint hpd_agreements_cache_c2 check (trunc(end_date) = end_date),
  constraint hpd_agreements_cache_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_agreements_cache_i1 on hpd_agreements_cache(company_id, filial_id, robot_id, begin_date) tablespace GWS_INDEX;
create index hpd_agreements_cache_i2 on hpd_agreements_cache(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpd_agreements_cache_i3 on hpd_agreements_cache(company_id, filial_id, begin_date, end_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table hpd_dirty_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  constraint hpd_dirty_staffs_pk primary key (company_id, filial_id, staff_id),
  constraint hpd_dirty_staffs_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create global temporary table hpd_journal_page_cache(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  employee_id                     number(20) not null,
  constraint hpd_journal_page_cache_pk primary key (company_id, filial_id, staff_id),
  constraint hpd_journal_page_cache_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
create table hpd_vacation_turnover(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  staff_id                        number(20)    not null,
  period                          date          not null,
  planned_days                    number(20, 6) not null, 
  used_days                       number(20, 6) not null,
  free_days                       as (planned_days - used_days),
  constraint hpd_vacation_turnover_pk primary key (company_id, filial_id, staff_id, period) using index tablespace GWS_INDEX,
  constraint hpd_vacation_turnover_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint hpd_vacation_turnover_c1 check (planned_days >= 0 and used_days >= 0),
  constraint hpd_vacation_turnover_c2 check (free_days >= 0) deferrable initially deferred
) tablespace GWS_DATA;

comment on table hpd_vacation_turnover is 'Keeps staff vacation days turnover';

----------------------------------------------------------------------------------------------------
-- CV Contracts
----------------------------------------------------------------------------------------------------
create table hpd_cv_contracts(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  contract_id                     number(20)  not null,
  contract_number                 varchar2(50),
  page_id                         number(20),
  division_id                     number(20)  not null,
  person_id                       number(20)  not null,
  begin_date                      date        not null, 
  end_date                        date        not null,
  contract_kind                   varchar2(1) not null,
  contract_employment_kind        varchar2(1) not null,
  access_to_add_item              varchar2(1) not null,
  posted                          varchar2(1) not null,
  early_closed_date               date,
  early_closed_note               varchar2(300 char),
  note                            varchar2(300 char),
  constraint hpd_cv_contracts_pk primary key (company_id, filial_id, contract_id) using index tablespace GWS_INDEX,
  constraint hpd_cv_contracts_u1 unique (contract_id) using index tablespace GWS_INDEX,
  constraint hpd_cv_contracts_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_cv_contracts_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint hpd_cv_contracts_f3 foreign key (company_id, filial_id, page_id) references hpd_hirings(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_cv_contracts_c1 check (begin_date <= end_date),
  constraint hpd_cv_contracts_c2 check (begin_date <= early_closed_date and early_closed_date <= end_date),
  constraint hpd_cv_contracts_c3 check (contract_kind in ('S', 'C')),
  constraint hpd_cv_contracts_c4 check (access_to_add_item in ('Y', 'N')),
  constraint hpd_cv_contracts_c5 check (posted in ('Y', 'N')),
  constraint hpd_cv_contracts_c6 check (contract_employment_kind in ('F', 'M')),
  constraint hpd_cv_contracts_c7 check (contract_employment_kind = 'M' and page_id is not null or contract_employment_kind = 'F' and page_id is null)
) tablespace GWS_DATA;

comment on table hpd_cv_contracts is 'Keeps civil contracts';

comment on column hpd_cv_contracts.contract_kind            is '(S)imple, (C)yclical';
comment on column hpd_cv_contracts.contract_employment_kind is '(F)reelancer, Staff (M)ember';

create unique index hpd_cv_contracts_u2 on hpd_cv_contracts(nvl2(page_id, company_id, null), nvl2(page_id, filial_id, null), page_id) tablespace GWS_INDEX;
 
create index hpd_cv_contracts_i1 on hpd_cv_contracts(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_cv_contracts_i2 on hpd_cv_contracts(company_id, person_id) tablespace GWS_INDEX;
create index hpd_cv_contracts_i3 on hpd_cv_contracts(company_id, filial_id, page_id) tablespace GWS_INDEX;

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
-- Applications
----------------------------------------------------------------------------------------------------
create table hpd_application_types(
  company_id                      number(20)         not null,
  application_type_id             number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6)          not null,
  pcode                           varchar2(20)       not null,
  constraint hpd_application_types_pk primary key (company_id, application_type_id) using index tablespace GWS_INDEX,
  constraint hpd_application_types_u1 unique (application_type_id) using index tablespace GWS_INDEX,
  constraint hpd_application_types_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint hpd_application_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpd_application_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hpd_applications(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  application_id                  number(20)        not null,
  application_type_id             number(4)         not null,
  application_number              varchar2(50 char) not null,
  application_date                date              not null,
  status                          varchar2(1)       not null,
  closing_note                    varchar2(300 char),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_applications_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_applications_u1 unique (application_id) using index tablespace GWS_INDEX,
  constraint hpd_applications_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hpd_applications_f2 foreign key (company_id, application_type_id) references hpd_application_types(company_id, application_type_id),
  constraint hpd_applications_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_applications_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_applications_c1 check (decode(trim(application_number), application_number, 1, 0) = 1),
  constraint hpd_applications_c2 check (trunc(application_date) = application_date),
  constraint hpd_applications_c3 check (status in ('N', 'W', 'A', 'P', 'O', 'C'))
) tablespace GWS_DATA;

comment on column hpd_applications.status is '(N)ew, (W)aiting, (A)pproved, in (P)rogress, c(O)mplete, (C)anceled';

create index hpd_applications_i1 on hpd_applications(company_id, application_type_id) tablespace GWS_INDEX;
create index hpd_applications_i2 on hpd_applications(company_id, created_by) tablespace GWS_INDEX;
create index hpd_applications_i3 on hpd_applications(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Creating Robots
----------------------------------------------------------------------------------------------------
create table hpd_application_create_robots(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  application_id                  number(20)         not null,
  name                            varchar2(200 char) not null,
  opened_date                     date               not null,
  division_id                     number(20)         not null,
  job_id                          number(20)         not null,
  quantity                        number(20)         not null,
  note                            varchar2(300 char),
  constraint hpd_application_create_robots_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_create_robots_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_create_robots_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_application_create_robots_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpd_application_create_robots_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpd_application_create_robots_c2 check (trunc(opened_date) = opened_date),
  constraint hpd_application_create_robots_c3 check (quantity > 0)
) tablespace GWS_DATA;

create index hpd_application_create_robots_i1 on hpd_application_create_robots(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_application_create_robots_i2 on hpd_application_create_robots(company_id, filial_id, job_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Hiring
----------------------------------------------------------------------------------------------------
create table hpd_application_hirings(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  application_id                  number(20)         not null,
  employee_id                     number(20),
  hiring_date                     date               not null,
  robot_id                        number(20)         not null,
  note                            varchar2(300 char),
  -- person info
  first_name                      varchar2(250 char) not null,
  last_name                       varchar2(250 char) not null,
  middle_name                     varchar2(250 char),
  birthday                        date,
  gender                          varchar2(1),
  phone                           varchar2(100 char),
  email                           varchar2(300),
  photo_sha                       varchar2(64),
  address                         varchar2(500 char),
  legal_address                   varchar2(300 char),
  region_id                       number(20),
  passport_series                 varchar2(50 char),
  passport_number                 varchar2(50 char),
  npin                            varchar2(14 char),
  iapa                            varchar2(20 char),
  employment_type                 varchar2(1)        not null,
  --
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_application_hirings_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_hirings_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_hirings_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_application_hirings_f3 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_application_hirings_f4 foreign key (photo_sha) references biruni_files(sha),
  constraint hpd_application_hirings_f5 foreign key (company_id, region_id) references md_regions(company_id, region_id),
  constraint hpd_application_hirings_f6 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_application_hirings_f7 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_application_hirings_c1 check (trunc(hiring_date) = hiring_date),
  constraint hpd_application_hirings_c2 check (decode(trim(first_name), first_name, 1, 0) = 1),
  constraint hpd_application_hirings_c3 check (decode(trim(last_name), last_name, 1, 0) = 1),
  constraint hpd_application_hirings_c4 check (decode(trim(middle_name), middle_name, 1, 0) = 1),
  constraint hpd_application_hirings_c5 check (gender in ('M', 'F')),
  constraint hpd_application_hirings_c6 check (decode(trim(npin), npin, 1, 0) = 1),
  constraint hpd_application_hirings_c7 check (decode(trim(iapa), iapa, 1, 0) = 1),
  constraint hpd_application_hirings_c8 check (employment_type in ('M', 'I'))
) tablespace GWS_DATA;

comment on column hpd_application_hirings.gender is '(M)ale, (F)emale';
comment on column hpd_application_hirings.employment_type is '(M)ain job, (I)nternal parttime';

create index hpd_application_hirings_i1 on hpd_application_hirings(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i2 on hpd_application_hirings(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i3 on hpd_application_hirings(photo_sha) tablespace GWS_INDEX;
create index hpd_application_hirings_i4 on hpd_application_hirings(company_id, region_id) tablespace GWS_INDEX;
create index hpd_application_hirings_i5 on hpd_application_hirings(company_id, created_by) tablespace GWS_INDEX;
create index hpd_application_hirings_i6 on hpd_application_hirings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Transfer
----------------------------------------------------------------------------------------------------
create table hpd_application_transfers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_unit_id             number(20) not null,
  application_id                  number(20) not null,
  staff_id                        number(20) not null,
  transfer_begin                  date       not null,
  robot_id                        number(20) not null,
  note                            varchar2(300 char),
  constraint hpd_application_transfers_pk primary key (company_id, filial_id, application_unit_id) using index tablespace GWS_INDEX,
  constraint hpd_application_transfers_u1 unique (application_unit_id) using index tablespace GWS_INDEX,
  constraint hpd_application_transfers_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_transfers_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_application_transfers_f3 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id),
  constraint hpd_application_transfers_c1 check (trunc(transfer_begin) = transfer_begin)
) tablespace GWS_DATA;

create index hpd_application_transfers_i1 on hpd_application_transfers(company_id, filial_id, application_id) tablespace GWS_INDEX;
create index hpd_application_transfers_i2 on hpd_application_transfers(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_application_transfers_i3 on hpd_application_transfers(company_id, filial_id, robot_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Dismissal
----------------------------------------------------------------------------------------------------
create table hpd_application_dismissals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  staff_id                        number(20) not null,
  dismissal_date                  date       not null,
  dismissal_reason_id             number(20),
  note                            varchar2(300 char),
  constraint hpd_application_dismissals_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_dismissals_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id) on delete cascade,
  constraint hpd_application_dismissals_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpd_application_dismissals_f3 foreign key (company_id, dismissal_reason_id) references href_dismissal_reasons(company_id, dismissal_reason_id),
  constraint hpd_application_dismissals_c1 check (trunc(dismissal_date) = dismissal_date)
) tablespace GWS_DATA;

create index hpd_application_dismissals_i1 on hpd_application_dismissals(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_application_dismissals_i2 on hpd_application_dismissals(company_id, dismissal_reason_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- Created Robots
----------------------------------------------------------------------------------------------------
create table hpd_application_robots(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  robot_id                        number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hpd_application_robots_pk primary key (company_id, filial_id, application_id, robot_id) using index tablespace GWS_INDEX,
  constraint hpd_application_robots_u1 unique (company_id, filial_id, robot_id) using index tablespace GWS_INDEX,
  constraint hpd_application_robots_f1 foreign key (company_id, filial_id, application_id) references hpd_application_create_robots(company_id, filial_id, application_id),
  constraint hpd_application_robots_f2 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hpd_application_robots_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hpd_application_robots_i1 on hpd_application_robots(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_application_journals(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  application_id                  number(20) not null,
  journal_id                      number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_application_journals_pk primary key (company_id, filial_id, application_id) using index tablespace GWS_INDEX,
  constraint hpd_application_journals_u1 unique (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_application_journals_f1 foreign key (company_id, filial_id, application_id) references hpd_applications(company_id, filial_id, application_id),
  constraint hpd_application_journals_f2 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_application_journals_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_application_journals_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hpd_application_journals_i1 on hpd_application_journals(company_id, created_by) tablespace GWS_INDEX;
create index hpd_application_journals_i2 on hpd_application_journals(company_id, modified_by) tablespace GWS_INDEX;

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
