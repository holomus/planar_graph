prompt migr from 05.10.2022 (1.dml)
----------------------------------------------------------------------------------------------------
prompt adding modified_id
----------------------------------------------------------------------------------------------------
alter table href_ftes                  modify modified_id not null;
alter table href_dismissal_reasons     modify modified_id not null;
alter table href_indicators            modify modified_id not null;
alter table href_employment_sources    modify modified_id not null;
alter table href_fixed_term_bases      modify modified_id not null;
alter table href_sick_leave_reasons    modify modified_id not null;
alter table href_business_trip_reasons modify modified_id not null;

alter table htt_locations  modify modified_id not null;
alter table htt_schedules  modify modified_id not null;
alter table htt_time_kinds modify modified_id not null;

alter table hpd_journals      modify modified_id not null;
alter table hpd_journal_pages modify modified_id not null;

alter table hpr_timebooks   modify modified_id not null;
alter table hpr_oper_groups modify modified_id not null;

alter table htt_tracks modify modified_id not null;

----------------------------------------------------------------------------------------------------
alter table href_dismissal_reasons add constraint href_dismissal_reasons_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter index href_ftes_u3 rename to href_ftes_u4;
alter index href_ftes_u2 rename to href_ftes_u3;

alter table href_ftes add constraint href_ftes_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter index href_indicators_u2 rename to href_indicators_u3;

alter table href_indicators add constraint href_indicators_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter table href_employment_sources add constraint href_employment_sources_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter index href_fixed_term_bases_u3 rename to href_fixed_term_bases_u4;
alter index href_fixed_term_bases_u2 rename to href_fixed_term_bases_u3;

alter table href_fixed_term_bases add constraint href_fixed_term_bases_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter index href_sick_leave_reasons_u2 rename to href_sick_leave_reasons_u3;

alter table href_sick_leave_reasons add constraint href_sick_leave_reasons_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter index href_business_trip_reasons_u2 rename to href_business_trip_reasons_u3;

alter table href_business_trip_reasons add constraint href_business_trip_reasons_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter index htt_locations_u2 rename to htt_locations_u3;

alter table htt_locations add constraint htt_locations_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter index htt_schedules_u3 rename to htt_schedules_u4;
alter index htt_schedules_u2 rename to htt_schedules_u3;

alter table htt_schedules add constraint htt_schedules_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter index htt_time_kinds_u4 rename to htt_time_kinds_u5;
alter index htt_time_kinds_u3 rename to htt_time_kinds_u4;
alter index htt_time_kinds_u2 rename to htt_time_kinds_u3;

alter table htt_time_kinds add constraint htt_time_kinds_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpd_journals add constraint hpd_journals_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;
alter table hpd_journal_pages add constraint hpd_journal_pages_u3 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpr_timebooks add constraint hpr_timebooks_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter index hpr_oper_groups_u2 rename to hpr_oper_groups_u3;

alter table hpr_oper_groups add constraint hpr_oper_groups_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table htt_tracks add constraint htt_tracks_u3 unique (company_id, filial_Id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
drop package Uitvhr_Error;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_ftes');
exec fazo_z.run('href_dismissal_reasons');
exec fazo_z.run('href_indicators');
exec fazo_z.run('href_employment_sources');
exec fazo_z.run('href_fixed_term_bases');
exec fazo_z.run('href_sick_leave_reasons');
exec fazo_z.run('href_business_trip_reasons');

exec fazo_z.run('htt_locations');
exec fazo_z.run('htt_schedules');
exec fazo_z.run('htt_time_kinds');

exec fazo_z.run('hpd_journals');
exec fazo_z.run('hpd_journal_pages');

exec fazo_z.run('hpr_timebooks');
exec fazo_z.run('hpr_oper_groups');

exec fazo_z.run('htt_tracks');
