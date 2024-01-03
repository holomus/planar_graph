prompt migr from 05.10.2022 (1.dml)
----------------------------------------------------------------------------------------------------
prompt adding modified_id
----------------------------------------------------------------------------------------------------
update href_ftes p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update href_dismissal_reasons p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update href_indicators t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update href_employment_sources t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update href_fixed_term_bases t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update href_sick_leave_reasons t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update href_business_trip_reasons t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update htt_locations p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update htt_schedules p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update htt_time_kinds p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update hpd_journals p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update hpd_journal_pages p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update hpr_timebooks p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

update hpr_oper_groups t
   set t.modified_id = biruni_modified_sq.nextval;
commit;

update htt_tracks p
   set p.modified_id = biruni_modified_sq.nextval;
commit;

