prompt adding staff_id to hpr_charges
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hpr_charges add staff_id number(20);

alter table hpr_charges add constraint hpr_charges_f11 foreign key(company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);

create index hpr_charges_i11 on hpr_charges(company_id, filial_id, staff_id) tablespace GWS_INDEX;
