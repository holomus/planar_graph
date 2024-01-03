prompt adding multiple application transfers
----------------------------------------------------------------------------------------------------
create sequence hpd_application_units_sq;

alter table hpd_application_transfers drop constraint hpd_application_transfers_pk;
alter table hpd_application_transfers add application_unit_id number(20);

----------------------------------------------------------------------------------------------------
prompt adding division manager_status
----------------------------------------------------------------------------------------------------
alter table hrm_divisions add manager_status varchar2(1);
alter table hrm_divisions add constraint hrm_divisions_c2 check (manager_status in ('M', 'A'));
alter table hrm_divisions add constraint hrm_divisions_c3 check (not (is_department = 'Y' and manager_status = 'A'));

comment on column hrm_divisions.manager_status is '(A)uto, (M)anual';
