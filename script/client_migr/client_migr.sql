---------------------------------------------------------------------------------------------------- 
create table migr_used_keys (
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  constraint migr_used_keys_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on column migr_used_keys.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table migr_keys_store_one(
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  new_id     number        not null,
  constraint migr_keys_store_one_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX,
  constraint migr_keys_store_one_f1 foreign key(company_id, key_name, old_id) references migr_used_keys(company_id, key_name, old_id) on delete cascade
) tablespace GWS_DATA;

comment on column migr_keys_store_one.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table migr_keys_store_two(
  company_id number(20)    not null,
  key_name   varchar2(100) not null,
  old_id     number        not null,
  filial_id  number        not null,
  new_id     number        not null,
  constraint migr_keys_store_two_pk primary key(company_id, key_name, old_id, filial_id) using index tablespace GWS_INDEX,
  constraint migr_keys_store_two_f1 foreign key(company_id, key_name, old_id) references migr_used_keys(company_id, key_name, old_id) on delete cascade
) tablespace GWS_DATA;

comment on column migr_keys_store_two.company_id is 'New company id';

---------------------------------------------------------------------------------------------------- 
create table migr_errors(
  company_id    number(20)     not null,
  table_name    varchar2(100)  not null,
  key_id        number         not null,
  error_message varchar2(4000) not null
) tablespace GWS_DATA;

comment on column migr_errors.company_id is 'New company id';

----------------------------------------------------------------------------------------------------
create table migr_changed_staffs(
  company_id        number(20) not null,
  filial_id         number(20) not null,
  staff_id          number(20) not null,
  old_division_id   number(20) not null,
  new_division_id   number(20) not null,
  constraint migr_changed_staffs_pk primary key (company_id, filial_id, staff_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;
