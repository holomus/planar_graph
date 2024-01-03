prompt adding round_model_type
----------------------------------------------------------------------------------------------------
alter table hsc_job_norms add round_model_type varchar2(1);

alter table hsc_job_norms add constraint hsc_job_norms_c7 check (round_model_type in ('C', 'F', 'R'));

comment on column hsc_job_norms.round_model_type is '(C)eil, (F)loor, (R)ound';
