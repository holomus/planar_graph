prompt making not null round_model_type
----------------------------------------------------------------------------------------------------
alter table hsc_job_norms modify round_model_type not null;

exec fazo_z.run('hsc_job_norms');
