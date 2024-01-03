prompt changing hpd_vacations
----------------------------------------------------------------------------------------------------
alter table hpd_vacations modify time_kind_id not null;
alter table hpd_vacations add constraint hpd_vacations_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id);

create index hpd_vacations_i1 on hpd_vacations(company_id, time_kind_id) tablespace GWS_INDEX;

create index htt_time_kinds_i5 on htt_time_kinds(company_id, nvl(parent_id, time_kind_id)) tablespace GWS_INDEX;

exec fazo_z.run('hpd_vacations');
exec fazo_z.run('htt_devices');
