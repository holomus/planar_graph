prompt add Bank Account table
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create table href_bank_accounts(
  company_id                      number(20) not null,
  bank_account_id                 number(20) not null,
  card_number                     varchar2(20),
  constraint href_bank_accounts_pk primary key (company_id, bank_account_id) using index tablespace GWS_INDEX,
  constraint href_bank_accounts_f1 foreign key (company_id, bank_account_id) references mkcs_bank_accounts(company_id, bank_account_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_bank_accounts');
