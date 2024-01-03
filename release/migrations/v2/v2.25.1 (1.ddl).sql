prompt migr from 24.05.2023 v2.25.1 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt kind added to hpd_page_adjustments
----------------------------------------------------------------------------------------------------
alter table hpd_page_adjustments add kind varchar2(1);

update hpd_page_adjustments set kind = 'F';
commit;

alter table hpd_page_adjustments modify kind not null;

alter table hpd_page_adjustments drop constraint hpd_page_adjustments_pk;
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_c1;
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_c2;
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_c3;
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_c4;

alter table hpd_page_adjustments add constraint hpd_page_adjustments_pk primary key (company_id, filial_id, page_id, kind) using index tablespace GWS_INDEX;
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c1 check (kind in ('F', 'I'));
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c2 check (kind = 'I' and free_time = 0 or free_time > 0);
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c3 check (overtime >= 0);
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c4 check (turnout_time >= 0);
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c5 check (kind = 'I' or free_time >= overtime + turnout_time);

comment on column hpd_page_adjustments.kind is '(F)ull, (I)ncomplete';

----------------------------------------------------------------------------------------------------
prompt kind added to hpd_lock_adjustments
----------------------------------------------------------------------------------------------------
alter table hpd_lock_adjustments add kind varchar2(1);

update hpd_lock_adjustments set kind = 'F';
commit;

alter table hpd_lock_adjustments modify kind not null;

alter table hpd_lock_adjustments drop constraint hpd_lock_adjustments_pk;

alter table hpd_lock_adjustments add constraint hpd_lock_adjustments_pk primary key (company_id, filial_id, staff_id, adjustment_date, kind) using index tablespace GWS_INDEX;
alter table hpd_lock_adjustments add constraint hpd_lock_adjustments_c1 check (kind in ('F', 'I'));

comment on column hpd_lock_adjustments.kind is '(F)ull, (I)ncomplete';

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run()
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_page_adjustments');
exec fazo_z.run('hpd_lock_adjustments');
