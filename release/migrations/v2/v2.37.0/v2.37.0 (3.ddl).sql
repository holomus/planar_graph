prompt adding nighttime column to hpr_sheet_parts
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hpr_sheet_parts modify nighttime_amount not null;
alter table hpr_sheet_parts modify accrual_amount as (wage_amount + overtime_amount + nighttime_amount);
alter table hpr_sheet_parts modify amount as (wage_amount + overtime_amount + nighttime_amount - 
                                             (late_amount + early_amount + lack_amount + day_skip_amount + mark_skip_amount));

alter table hpr_sheet_parts drop constraint hpr_sheet_parts_c2;
alter table hpr_sheet_parts add constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0
                                                                and wage_amount >= 0 and overtime_amount >= 0
                                                                and nighttime_amount >= 0 and late_amount >= 0 
                                                                and early_amount >= 0 and lack_amount >= 0 
                                                                and day_skip_amount >= 0 and mark_skip_amount >= 0);

----------------------------------------------------------------------------------------------------
prompt adding modified_id to hrec_vacancies
----------------------------------------------------------------------------------------------------
alter table hrec_vacancies modify modified_id not null;

alter table hrec_vacancies add constraint hrec_vacancies_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding exams to vacancies
----------------------------------------------------------------------------------------------------
alter table hln_exams modify for_recruitment varchar2(1) not null;

comment on column hln_exams.for_recruitment is 'If Yes it means this Exam for Recruitment Telegram bot';

----------------------------------------------------------------------------------------------------
prompt adding hrm_seetings columns
----------------------------------------------------------------------------------------------------
alter table hrm_settings modify keep_salary varchar2(1) not null;
alter table hrm_settings modify keep_vacation_limit varchar2(1) not null;
alter table hrm_settings modify keep_schedule varchar2(1) not null;
alter table hrm_settings modify keep_rank varchar2(1) not null;

alter table hrm_settings rename constraint hrm_settings_c11 to hrm_settings_c15;
alter table hrm_settings rename constraint hrm_settings_c10 to hrm_settings_c14;
alter table hrm_settings rename constraint hrm_settings_c9 to hrm_settings_c13;
alter table hrm_settings rename constraint hrm_settings_c8 to hrm_settings_c12;
alter table hrm_settings rename constraint hrm_settings_c7 to hrm_settings_c11;
alter table hrm_settings rename constraint hrm_settings_c6 to hrm_settings_c10;
alter table hrm_settings rename constraint hrm_settings_c5 to hrm_settings_c9;
alter table hrm_settings rename constraint hrm_settings_c4 to hrm_settings_c8;
alter table hrm_settings rename constraint hrm_settings_c3 to hrm_settings_c7;

alter table hrm_settings add constraint hrm_settings_c3 check (keep_salary in ('Y', 'N'));
alter table hrm_settings add constraint hrm_settings_c4 check (keep_vacation_limit in ('Y', 'N'));
alter table hrm_settings add constraint hrm_settings_c5 check (keep_schedule in ('Y', 'N'));
alter table hrm_settings add constraint hrm_settings_c6 check (keep_rank in ('Y', 'N'));
alter table hrm_settings add constraint hrm_settings_c16 check (position_check = 'Y' or decode(position_check, 'N', 4, 0) = 
                                                                decode(keep_rank, 'N', 1, 0) + decode(keep_salary, 'N', 1, 0) + --
                                                                decode(keep_schedule, 'N', 1, 0) + decode(keep_vacation_limit, 'N', 1, 0));
                                     
comment on column hrm_settings.keep_salary is 'If Yes, not access to change Salary when Hiring or Transfer Staff';
comment on column hrm_settings.keep_vacation_limit is 'If Yes, not access to change Vacation Limit when Hiring or Transfer Staff';
comment on column hrm_settings.keep_schedule is 'If Yes, not access to change Schedule when Hiring or Transfer Staff';
comment on column hrm_settings.keep_rank is 'If Yes, not access to change Rank when Hiring or Transfer Staff';

----------------------------------------------------------------------------------------------------
prompt adding weights to schedule
----------------------------------------------------------------------------------------------------
alter table htt_schedules modify use_weights not null;
alter table htt_schedules add constraint htt_schedules_c25 check (use_weights in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpr_sheet_parts');
exec fazo_z.run('hpr_nighttime_policies');
exec fazo_z.run('hpr_nighttime_rules');
exec fazo_z.run('hrec_vacancies');
exec fazo_z.run('hrec_telegram_candidates');
exec fazo_z.run('hln_exams');
exec fazo_z.run('hrec_vacancies');
exec fazo_z.run('hpd_sign_templates'); 
exec fazo_z.run('hpd_journals');
exec fazo_z.run('hrm_settings');
exec fazo_z.run('hrm_robots');
exec fazo_z.run('hrm_job_roles');
exec fazo_z.run('htt_schedules');
exec fazo_z.run('htt_change_day_weights');
exec fazo_z.run('htt_');
