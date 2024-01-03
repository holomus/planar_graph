prompt changing hsc
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create sequence hsc_job_rounds_sq;

---------------------------------------------------------------------------------------------------- 
drop table hsc_area_division_groups;
---------------------------------------------------------------------------------------------------- 
alter table hsc_areas drop column c_division_groups_exist;

alter table hsc_object_norms modify division_id null;

alter table hsc_job_norms modify division_id null;
alter table hsc_job_norms drop column round_model_type;
---------------------------------------------------------------------------------------------------- 
create table hsc_job_rounds(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  round_id                        number(20)  not null,
  object_id                       number(20)  not null,
  division_id                     number(20),
  job_id                          number(20)  not null,
  round_model_type                varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint hsc_job_rounds_pk primary key (company_id, filial_id, round_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_u1 unique (round_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_u2 unique (company_id, filial_id, object_id, division_id, job_id) using index tablespace GWS_INDEX,
  constraint hsc_job_rounds_f1 foreign key (company_id, filial_id, object_id) references hsc_objects(company_id, filial_id, object_id) on delete cascade,
  constraint hsc_job_rounds_f2 foreign key (company_id, filial_id, division_id, object_id) references mhr_parent_divisions(company_id, filial_id, division_id, parent_id),
  constraint hsc_job_rounds_f3 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hsc_job_rounds_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hsc_job_rounds_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hsc_job_rounds_c1 check (round_model_type in ('C', 'F', 'R'))
) tablespace GWS_DATA;

comment on column hsc_job_rounds.round_model_type is '(C)eil, (F)loor, (R)ound';

create index hsc_job_rounds_i1 on hsc_job_rounds(company_id, filial_id, division_id, object_id) tablespace GWS_INDEX;
create index hsc_job_rounds_i2 on hsc_job_rounds(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hsc_job_rounds_i3 on hsc_job_rounds(company_id, created_by) tablespace GWS_INDEX;
create index hsc_job_rounds_i4 on hsc_job_rounds(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('hsc_');
