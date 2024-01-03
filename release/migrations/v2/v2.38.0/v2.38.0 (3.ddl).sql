prompt adding position booking
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hpd_page_robots modify is_booked not null;
alter table hpd_page_robots add constraint hpd_page_robots_c4 check (is_booked in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt dropping wage scale wage and coef
----------------------------------------------------------------------------------------------------
alter table Hrm_Register_Ranks drop column wage;
alter table Hrm_Register_Ranks drop column coefficient;

----------------------------------------------------------------------------------------------------
prompt adding modified_id to hpr_books
----------------------------------------------------------------------------------------------------
alter table hpr_books modify modified_id number(20) not null;
alter table hpr_books add constraint hpr_books_u1 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt making wage sheet division multiple
----------------------------------------------------------------------------------------------------
alter table hpr_wage_sheets drop constraint hpr_wage_sheets_f1; 
alter table hpr_wage_sheets drop column division_id; 

alter table hpr_wage_sheets rename constraint hpr_wage_sheets_f2 to hpr_wage_sheets_f1;
alter table hpr_wage_sheets rename constraint hpr_wage_sheets_f3 to hpr_wage_sheets_f2;

alter index hpr_wage_sheets_i2 rename to hpr_wage_sheets_i1;
alter index hpr_wage_sheets_i3 rename to hpr_wage_sheets_i2;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_robot_trans_pages');
exec fazo_z.run('hpd_page_robots');
exec fazo_z.run('hrm_register_rank_indicators');
exec fazo_z.run('hrm_register_ranks');
exec fazo_z.run('hpr_books');
exec fazo_z.run('hpr_wage_sheet_divisions');
exec fazo_z.run('hpr_wage_sheets');
exec fazo_z.run('hac_hik_listening_devices');
exec fazo_z.run('hac_hik_device_listener_events');
