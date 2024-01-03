prompt updating round model type
----------------------------------------------------------------------------------------------------
update hsc_job_norms q
   set q.round_model_type = 'R';
commit;
