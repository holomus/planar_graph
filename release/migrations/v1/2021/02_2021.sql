-- href
----------------------------------------------------------------------------------------------------
create table href_fixed_term_bases(
  company_id                      number(20)         not null,
  fixed_term_base_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  text                            varchar2(300 char),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  constraint href_fixed_term_bases_pk primary key (company_id, fixed_term_base_id) using index tablespace GWS_INDEX,
  constraint href_fixed_term_bases_u1 unique (fixed_term_base_id) using index tablespace GWS_INDEX,
  constraint href_fixed_term_bases_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_fixed_term_bases_c2 check (state in ('A', 'P')),
  constraint href_fixed_term_bases_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_fixed_term_bases.state is '(A)ctive, (P)assive';

create unique index href_fixed_term_bases_u2 on href_fixed_term_bases(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_fixed_term_bases_u3 on href_fixed_term_bases(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_edu_stages_i1 on href_edu_stages(company_id, code) tablespace GWS_INDEX;

create sequence href_fixed_term_basies_sq;

-- htt
----------------------------------------------------------------------------------------------------              
create table htt_time_types(
  company_id                      number(20)         not null,
  time_type_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  letter_code                     varchar2(50 char)  not null,
  digital_code                    varchar2(50),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_time_types_pk primary key (company_id, time_type_id) using index tablespace GWS_INDEX,
  constraint htt_time_types_u1 unique (time_type_id) using index tablespace GWS_INDEX,
  constraint htt_time_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_time_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_time_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_time_types_c2 check (decode(trim(letter_code), letter_code, 1, 0) = 1),
  constraint htt_time_types_c3 check (decode(trim(digital_code), digital_code, 1, 0) = 1),
  constraint htt_time_types_c4 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column htt_time_types.state is '(A)ctive, (P)assive';

create unique index htt_time_types_u2 on htt_time_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_time_types_u3 on htt_time_types(company_id, lower(letter_code)) tablespace GWS_INDEX;

create index htt_time_types_i1 on htt_time_types(company_id, created_by) tablespace GWS_INDEX;
create index htt_time_types_i2 on htt_time_types(company_id, modified_by) tablespace GWS_INDEX;

create sequence htt_time_types_sq;

-- hpr
alter table hpr_documents add (document_name varchar2(150 char), note varchar2(300 char));
alter table hpr_documents drop constraint hpr_documents_c3;
alter table hpr_documents drop constraint hpr_documents_c4;
alter table hpr_documents add constraint hpr_documents_c3 check (decode(trim(document_name), document_name, 1, 0) = 1);
alter table hpr_documents add constraint hpr_documents_c4 check (trunc(month, 'mon') = month);
alter table hpr_documents add constraint hpr_documents_c5 check (posted in ('Y', 'N'));

alter table hpr_doc_operations add net_amount number(20,6);

update hpr_doc_operations
   set net_amount = amount - nvl(income_tax_amount, 0);
   
alter table hpr_doc_operations modify net_amount not null;

alter table hpr_doc_operations drop constraint hpr_doc_operations_c2;
alter table hpr_doc_operations drop constraint hpr_doc_operations_c3;
alter table hpr_doc_operations drop constraint hpr_doc_operations_c4;
alter table hpr_doc_operations add constraint hpr_doc_operations_c2 check (net_amount = amount - nvl(income_tax_amount, 0));
alter table hpr_doc_operations add constraint hpr_doc_operations_c3 check (income_tax_amount > 0);
alter table hpr_doc_operations add constraint hpr_doc_operations_c4 check (pension_payment_amount > 0 and pension_payment_amount <= income_tax_amount);
alter table hpr_doc_operations add constraint hpr_doc_operations_c5 check (social_payment_amount > 0);

----------------------------------------------------------------------------------------------------                 
create table hpr_timesheets(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  timesheet_id                    number(20)        not null,
  timesheet_number                varchar2(50 char) not null, 
  timesheet_date                  date              not null,
  posted                          varchar2(1)       not null,
  division_id                     number(20),
  month                           date              not null,
  month_period                    varchar2(1)       not null,
  begin_date                      date,
  end_date                        date,
  note                            varchar2(300 char),
  barcode                         varchar2(25),
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_timesheets_pk primary key (company_id, filial_id, timesheet_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheets_u1 unique (timesheet_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheets_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_timesheets_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_timesheets_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_timesheets_c1 check (decode(trim(timesheet_number), timesheet_number, 1, 0) = 1),
  constraint hpr_timesheets_c2 check (trunc(timesheet_date) = timesheet_date),
  constraint hpr_timesheets_c3 check (posted in ('Y', 'N')),
  constraint hpr_timesheets_c4 check (trunc(month, 'MON') = month),
  constraint hpr_timesheets_c5 check (month_period in ('W', 'F', 'S', 'A')),
  constraint hpr_timesheets_c7 check (trunc(begin_date) = begin_date),
  constraint hpr_timesheets_c8 check (trunc(begin_date, 'MON') = month),
  constraint hpr_timesheets_c9 check (trunc(end_date) = end_date),
  constraint hpr_timesheets_c10 check (trunc(end_date, 'MON') = month),
  constraint hpr_timesheets_c11 check (begin_date <= end_date)
) tablespace GWS_DATA;

comment on column hpr_timesheets.month_period is '(W)hole, (F)irst half, (S)econd half, (A)rbitrary';

create index hpr_timesheets_i1 on hpr_timesheets(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_timesheets_i2 on hpr_timesheets(company_id, created_by) tablespace GWS_INDEX;
create index hpr_timesheets_i3 on hpr_timesheets(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                 
create table hpr_timesheet_employees(
  company_id                      number(20) not null,
  employee_unit_id                number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  employee_id                     number(20) not null,
  constraint hpr_timesheet_employees_pk primary key (company_id, employee_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_employees_u1 unique (employee_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_employees_u2 unique (company_id, filial_id, timesheet_id, employee_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_employees_f1 foreign key (company_id, filial_id, timesheet_id) references hpr_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint hpr_timesheet_employees_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id)  
) tablespace GWS_DATA;

create index hpr_timesheet_employees_i1 on hpr_timesheet_employees(company_id, filial_id, employee_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                 
create table hpr_timesheet_dates(
  company_id                      number(20) not null,
  date_unit_id                    number(20) not null,
  employee_unit_id                number(20) not null,
  date_value                      date       not null,
  constraint hpr_timesheet_dates_pk primary key (company_id, date_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_dates_u1 unique (date_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_dates_f1 foreign key (company_id, employee_unit_id) references hpr_timesheet_employees(company_id, employee_unit_id) on delete cascade,
  constraint hpr_timesheet_dates_c1 check (trunc(date_value) = date_value)
) tablespace GWS_DATA;

create index hpr_timesheet_dates_i1 on hpr_timesheet_dates(company_id, employee_unit_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timesheet_facts(
  company_id                      number(20) not null,
  fact_unit_id                    number(20) not null,
  date_unit_id                    number(20) not null,
  time_type_id                    number(20) not null,
  fact_value                      number(20) not null,
  constraint hpr_timesheet_facts_pk primary key (company_id, fact_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_facts_u1 unique (fact_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timesheet_facts_f1 foreign key (company_id, date_unit_id) references hpr_timesheet_dates(company_id, date_unit_id) on delete cascade,
  constraint hpr_timesheet_facts_c1 check (fact_value >= 0)
) tablespace GWS_DATA;

create index hpr_timesheet_facts_i1 on hpr_timesheet_facts(company_id, date_unit_id) tablespace GWS_INDEX;

create sequence hpr_timesheets_sq;
create sequence hpr_timesheet_employees_sq;
create sequence hpr_timesheet_dates_sq;
create sequence hpr_timesheet_facts_sq;

--hpd
----------------------------------------------------------------------------------------------------         
create table hpd_contracts(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  contract_id                     number(20)        not null,
  employee_id                     number(20)        not null,
  contract_number                 varchar2(50 char) not null,
  contract_date                   date              not null,
  fixed_term                      varchar2(1)       not null,
  expiry_date                     date,
  fixed_term_base_id              number(20),
  concluding_term                 varchar2(300 char),
  hiring_conditions               varchar2(300 char),
  other_conditions                varchar2(300 char),
  workplace_equipment             varchar2(300 char),
  representative_basis            varchar2(300 char),
  barcode                         varchar2(23)      not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpd_contracts_pk primary key (company_id, filial_id, contract_id) using index tablespace GWS_INDEX,
  constraint hpd_contracts_u1 unique (contract_id) using index tablespace GWS_INDEX,
  constraint hpd_contracts_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hpd_contracts_f2 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id),
  constraint hpd_contracts_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpd_contracts_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpd_contracts_c1 check (decode(trim(contract_number), contract_number, 1, 0) = 1),
  constraint hpd_contracts_c2 check (trunc(contract_date) = contract_date),
  constraint hpd_contracts_c3 check (fixed_term in ('Y', 'N')),
  constraint hpd_contracts_c4 check (trunc(expiry_date) = expiry_date),
  constraint hpd_contracts_c5 check (expiry_date is null or fixed_term = 'Y'),
  constraint hpd_contracts_c6 check (fixed_term_base_id is null or fixed_term = 'Y'),
  constraint hpd_contracts_c7 check (concluding_term is null or fixed_term = 'Y')
) tablespace GWS_DATA;

comment on column hpd_contracts.fixed_term is '(Y)es, (N)o';

create index hpd_contracts_i1 on hpd_contracts(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_contracts_i2 on hpd_contracts(company_id, filial_id, fixed_term_base_id) tablespace GWS_INDEX;
create index hpd_contracts_i3 on hpd_contracts(company_id, created_by) tablespace GWS_INDEX;
create index hpd_contracts_i4 on hpd_contracts(company_id, modified_by) tablespace GWS_INDEX;

create sequence hpd_contracts_sq;

alter table hpd_hirings drop column hiring_condition;
alter table hpd_hirings add (
  contract_number                 varchar2(50 char),
  contract_date                   date,
  fixed_term                      varchar2(1),
  expiry_date                     date,
  fixed_term_base_id              number(20),
  concluding_term                 varchar2(300 char),
  hiring_conditions               varchar2(300 char),
  other_conditions                varchar2(300 char),
  workplace_equipment             varchar2(300 char),
  representative_basis            varchar2(300 char));
  
update hpd_hirings set fixed_term = 'N';

alter table hpd_hirings modify fixed_term not null;
alter table hpd_hirings add constraint hpd_hirings_f9 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id);
alter table hpd_hirings drop constraint hpd_hirings_c2;
alter table hpd_hirings drop constraint hpd_hirings_c3;
alter table hpd_hirings add constraint hpd_hirings_c2 check (fixed_term in ('Y', 'N'));
alter table hpd_hirings add constraint hpd_hirings_c3 check (quantity > 0 and quantity <= 1);
alter table hpd_hirings add constraint hpd_hirings_c4 check (trial_period between 0 and 366);
alter table hpd_hirings add constraint hpd_hirings_c5 check (decode(trim(contract_number), contract_number, 1, 0) = 1);
alter table hpd_hirings add constraint hpd_hirings_c6 check (trunc(contract_date) = contract_date);
alter table hpd_hirings add constraint hpd_hirings_c7 check (trunc(expiry_date) = expiry_date);
alter table hpd_hirings add constraint hpd_hirings_c8 check (expiry_date is null or fixed_term = 'Y');
alter table hpd_hirings add constraint hpd_hirings_c9 check (fixed_term_base_id is null or fixed_term = 'Y');
alter table hpd_hirings add constraint hpd_hirings_c10 check (concluding_term is null or fixed_term = 'Y');

comment on column hpd_hirings.fixed_term is '(Y)es, (N)o';

create index hpd_hirings_i9 on hpd_hirings(company_id, fixed_term_base_id) tablespace GWS_INDEX;

alter table hpd_transfers add (
  contract_number                 varchar2(50 char),
  contract_date                   date,
  fixed_term                      varchar2(1),
  expiry_date                     date,
  fixed_term_base_id              number(20),
  concluding_term                 varchar2(300 char),
  hiring_conditions               varchar2(300 char),
  other_conditions                varchar2(300 char),
  workplace_equipment             varchar2(300 char),
  representative_basis            varchar2(300 char));
  
update hpd_transfers set fixed_term = 'N';

alter table hpd_transfers modify fixed_term not null;

alter table hpd_transfers add constraint hpd_transfers_f9 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id);
alter table hpd_transfers drop constraint hpd_transfers_c2;
alter table hpd_transfers add constraint hpd_transfers_c2 check (fixed_term in ('Y', 'N'));
alter table hpd_transfers add constraint hpd_transfers_c3 check (quantity > 0 and quantity <= 1);
alter table hpd_transfers add constraint hpd_transfers_c4 check (decode(trim(contract_number), contract_number, 1, 0) = 1);
alter table hpd_transfers add constraint hpd_transfers_c5 check (trunc(contract_date) = contract_date);
alter table hpd_transfers add constraint hpd_transfers_c6 check (trunc(expiry_date) = expiry_date);
alter table hpd_transfers add constraint hpd_transfers_c7 check (expiry_date is null or fixed_term = 'Y');
alter table hpd_transfers add constraint hpd_transfers_c8 check (fixed_term_base_id is null or fixed_term = 'Y');
alter table hpd_transfers add constraint hpd_transfers_c9 check (concluding_term is null or fixed_term = 'Y');

comment on column hpd_transfers.fixed_term is '(Y)es, (N)o';

create index hpd_transfers_i9 on hpd_transfers(company_id, fixed_term_base_id) tablespace GWS_INDEX;
