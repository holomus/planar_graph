prompt migration migr from 10.01.2022
---------------------------------------------------------------------------------------------------- 
-- changing structure of migr_tables
-- !!! IMPORTANT !!!
-- change Md_Pref.c_Migr_Company_id before this migration

alter table migr_keys_store_two drop constraint migr_keys_store_two_f1;
alter table migr_keys_store_two drop constraint migr_keys_store_two_pk;

alter table migr_keys_store_one drop constraint migr_keys_store_one_f1;
alter table migr_keys_store_one drop constraint migr_keys_store_one_pk;

alter table migr_used_keys drop constraint migr_used_keys_pk;

alter table migr_used_keys      add company_id number(20);
alter table migr_keys_store_one add company_id number(20);
alter table migr_keys_store_two add company_id number(20);
alter table migr_errors         add company_id number(20);

declare
begin
  update Migr_Used_Keys Uk
     set Uk.Company_Id = Md_Pref.c_Migr_Company_Id;

  update Migr_Keys_Store_One Uk
     set Uk.Company_Id = Md_Pref.c_Migr_Company_Id;

  update Migr_Keys_Store_Two Uk
     set Uk.Company_Id = Md_Pref.c_Migr_Company_Id;

  update Migr_Errors Uk
     set Uk.Company_Id = Md_Pref.c_Migr_Company_Id;
  commit;
end;
/
   
alter table migr_used_keys      modify company_id not null;
alter table migr_keys_store_one modify company_id not null;
alter table migr_keys_store_two modify company_id not null;
alter table migr_errors         modify company_id not null;   

comment on column migr_used_keys.company_id      is 'New company id';
comment on column migr_keys_store_one.company_id is 'New company id';
comment on column migr_keys_store_two.company_id is 'New company id';
comment on column migr_errors.company_id         is 'New company id';

alter table migr_used_keys add constraint migr_used_keys_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX;

alter table migr_keys_store_one add constraint migr_keys_store_one_pk primary key(company_id, key_name, old_id) using index tablespace GWS_INDEX;
alter table migr_keys_store_one add constraint migr_keys_store_one_f1 foreign key(company_id, key_name, old_id) references migr_used_keys(company_id, key_name, old_id) on delete cascade;

alter table migr_keys_store_two add constraint migr_keys_store_two_pk primary key(company_id, key_name, old_id, filial_id) using index tablespace GWS_INDEX;
alter table migr_keys_store_two add constraint migr_keys_store_two_f1 foreign key(company_id, key_name, old_id) references migr_used_keys(company_id, key_name, old_id) on delete cascade;
