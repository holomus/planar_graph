prompt changing potential outputs
----------------------------------------------------------------------------------------------------
alter table htt_potential_outputs drop constraint htt_potential_outputs_c1;
alter table htt_potential_outputs drop constraint htt_potential_outputs_f3;
alter table htt_potential_outputs drop constraint htt_potential_outputs_f2;
alter table htt_potential_outputs drop constraint htt_potential_outputs_f1;
alter table htt_potential_outputs drop constraint htt_potential_outputs_u1;
alter table htt_potential_outputs drop constraint htt_potential_outputs_pk;

alter table htt_potential_outputs drop column employee_id;
alter table htt_potential_outputs drop column track_date;
alter table htt_potential_outputs drop column track_datetime;
alter table htt_potential_outputs drop column device_id;

alter table htt_potential_outputs add constraint htt_potential_outputs_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX;
alter table htt_potential_outputs add constraint htt_potential_outputs_f1 foreign key (company_id, filial_id, track_id) references htt_tracks(company_id, filial_id, track_id) on delete cascade;

exec fazo_z.run('htt_potential_outputs');
