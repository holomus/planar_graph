prompt migr from 04.07.2022 3.ddl
----------------------------------------------------------------------------------------------------
prompt modifying hrm_settings, href_staffs
----------------------------------------------------------------------------------------------------
alter table hrm_settings modify autogen_staff_number not null;
alter table href_staffs modify staff_number null;
create unique index href_staffs_u2 on href_staffs(nvl2(staff_number,company_id, null), nvl2(staff_number, filial_id, null), upper(staff_number)) tablespace GWS_INDEX;
