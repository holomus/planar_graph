prompt migr from 05.10.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt adding modified_id
----------------------------------------------------------------------------------------------------
alter table href_ftes                  add modified_id number(20);
alter table href_dismissal_reasons     add modified_id number(20);
alter table href_indicators            add modified_id number(20);
alter table href_employment_sources    add modified_id number(20);
alter table href_fixed_term_bases      add modified_id number(20);
alter table href_sick_leave_reasons    add modified_id number(20);
alter table href_business_trip_reasons add modified_id number(20);

alter table htt_locations  add modified_id number(20);
alter table htt_schedules  add modified_id number(20);
alter table htt_time_kinds add modified_id number(20);

alter table hpd_journals      add modified_id number(20);
alter table hpd_journal_pages add modified_id number(20);

alter table hpr_timebooks   add modified_id number(20);
alter table hpr_oper_groups add modified_id number(20);

alter table htt_tracks add modified_id number(20);
