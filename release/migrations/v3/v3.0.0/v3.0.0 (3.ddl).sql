prompt adding experience attempts
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_staffs drop column increment_permit;

alter table htm_experience_job_ranks drop column period;
alter table htm_experience_job_ranks drop column nearest;

alter table htm_experience_periods drop constraint htm_experience_periods_c1;
alter table htm_experience_periods drop constraint htm_experience_periods_c2;

alter table htm_experience_periods drop column period;
alter table htm_experience_periods drop column nearest;

----------------------------------------------------------------------------------------------------
alter table href_indicators modify indicator_group_id not null;

alter table href_indicators add constraint href_indicators_f3 foreign key (company_id, indicator_group_id) references href_indicator_groups(company_id, indicator_group_id);


---------------------------------------------------------------------------------------------------- 
prompt fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_indicators');
exec fazo_z.run('href_indicator_groups');
exec fazo_z.run('hln_training_person_subjects');
exec fazo_z.run('hln_training_subject_groups');
exec fazo_z.run('hln_training_subject_group_subjects');
exec fazo_z.run('hln_trainings');
exec fazo_z.run('hac_temp_');
exec fazo_z.run('htm_')
