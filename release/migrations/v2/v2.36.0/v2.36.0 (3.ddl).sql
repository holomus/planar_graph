prompt make not null staff employment type
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------  
alter table href_staffs modify employment_type not null;

----------------------------------------------------------------------------------------------------  
prompt make not null hrm_robots.position_employment_kind  
----------------------------------------------------------------------------------------------------  
alter table hrm_robots modify position_employment_kind not null;

----------------------------------------------------------------------------------------------------  
prompt make not null hpd_cv_contracts.contract_employment_kind  
----------------------------------------------------------------------------------------------------  
alter table hpd_cv_contracts modify contract_employment_kind not null;

----------------------------------------------------------------------------------------------------
prompt columns maked not null and added checks
---------------------------------------------------------------------------------------------------- 
alter table htt_calendars modify monthly_limit varchar2(1) not null;
alter table htt_calendars modify daily_limit varchar2(1) not null;

alter table htt_calendars add constraint htt_calendars_c3 check(monthly_limit in ('Y', 'N'));
alter table htt_calendars add constraint htt_calendars_c4 check(daily_limit in ('Y', 'N'));

----------------------------------------------------------------------------------------------------  
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------  
exec fazo_z.run('href_staffs');
exec fazo_z.run('hpd_page_robots');
exec fazo_z.run('hpd_trans_robots');
exec fazo_z.run('hper_plans');
exec fazo_z.run('hper_staff_plans');
exec fazo_z.run('hrm_robots');
exec fazo_z.run('hpd_cv_contracts');
exec fazo_z.run('htt_calendars'); 
exec fazo_z.run('htt_calendar_week_days');
exec fazo_z.run('hpd_hirings');
exec fazo_z.run('htt_staff_schedule_days');
exec fazo_z.run('htt_robot_schedule_days');
exec fazo_z.run('hrec_');
