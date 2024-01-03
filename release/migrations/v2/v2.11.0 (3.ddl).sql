prompt migr from 14.11.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt set not null in order_no
alter table hpr_book_types modify order_no number(6) not null;

----------------------------------------------------------------------------------------------------
prompt drop schedule_id from hpd_schedule_changes

drop index hpd_schedule_changes_i2;
alter table hpd_schedule_changes drop constraint hpd_schedule_changes_f3;
alter table hpd_schedule_changes drop column schedule_id;

----------------------------------------------------------------------------------------------------
prompt drop table hpd_schedule_multiples
drop table hpd_schedule_multiples;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpd_schedule_changes');
exec fazo_z.run('hpr_book_types');
