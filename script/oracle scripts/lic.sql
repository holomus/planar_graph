----------------------------------------------------------------------------------------------------
create table kl_ownership_ctrls(
  code                            varchar2(10)  not null,
  name_fn                         varchar2(120) not null,
  description_fn                  varchar2(120) not null,
  filter_fn                       varchar2(120),
  constraint kl_ownership_ctrls_pk primary key (code) using index tablespace GWS_INDEX,
  constraint kl_ownership_ctrls_c1 check (decode(trim(name_fn), name_fn, 1, 0) = 1),
  constraint kl_ownership_ctrls_c2 check (decode(trim(description_fn), description_fn, 1, 0) = 1),
  constraint kl_ownership_ctrls_c3 check (decode(trim(filter_fn), filter_fn, 1, 0) = 1)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table kl_license_ownerships(
  company_id                      number(20)   not null,
  person_id                       number(20)   not null,
  license_code                    varchar2(50) not null,
  ctrl_code                       varchar2(10) not null,
  private_ownership               varchar2(1)  not null,
  constraint kl_license_ownerships_pk primary key (company_id, person_id, license_code) using index tablespace GWS_INDEX,
  constraint kl_license_ownerships_f1 foreign key (company_id, person_id) references md_persons(company_id, person_id),
  constraint kl_license_ownerships_f2 foreign key (license_code) references md_licenses(license_code),
  constraint kl_license_ownerships_f3 foreign key (ctrl_code) references kl_ownership_ctrls(code),
  constraint kl_license_ownerships_c1 check (private_ownership in ('Y', 'N'))
) tablespace GWS_DATA;

create index kl_license_ownerships_i1 on kl_license_ownerships(company_id, ctrl_code, license_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table kl_license_lock_holders(
  company_id                      number(20) not null,
  holder_id                       number(20) not null,
  constraint kl_license_lock_holders_pk primary key (company_id, holder_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table kl_license_balances(
  company_id                      number(20)   not null,
  license_code                    varchar2(50) not null,
  balance_date                    date         not null,
  available_amount                number(20)   not null,
  used_amount                     number(20)   not null,
  required_amount                 number(20)   not null,
  constraint kl_license_balances_pk primary key (company_id, license_code, balance_date) using index tablespace GWS_INDEX,
  constraint kl_license_balances_c1 check (trunc(balance_date) = balance_date),
  constraint kl_license_balances_c2 check (available_amount >= 0 and used_amount >= 0 and required_amount >= 0),
  constraint kl_license_balances_c3 check (available_amount >= used_amount)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table kl_license_holders(
  company_id                      number(20)   not null,
  license_code                    varchar2(50) not null,
  hold_date                       date         not null,
  holder_id                       number(20)   not null,
  licensed                        varchar2(1)  not null,
  constraint kl_license_holders_pk primary key (company_id, license_code, hold_date, holder_id) using index tablespace GWS_INDEX,
  constraint kl_license_holders_f1 foreign key (company_id, holder_id) references md_persons(company_id, person_id),
  constraint kl_license_holders_c1 check (licensed in ('Y', 'N'))
) tablespace GWS_DATA;

create index kl_license_holders_i1 on kl_license_holders(company_id, license_code, hold_date, licensed) tablespace GWS_INDEX;
create index kl_license_holders_i2 on kl_license_holders(company_id, holder_id, hold_date) tablespace GWS_INDEX;
