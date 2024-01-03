prompt migr from 15.02.2023 (ddl after dml)
----------------------------------------------------------------------------------------------------
prompt change column type number to varchar2
----------------------------------------------------------------------------------------------------  
alter table htt_persons drop column pin;
alter table htt_persons rename column temp_column to pin;
alter table htt_persons add constraint htt_persons_c2 check (regexp_like(pin, '^\d+$')); 

alter table hzk_migr_fprints drop constraint hzk_migr_fprints_pk;
alter table hzk_migr_fprints drop column pin;
alter table hzk_migr_fprints rename column temp_column to pin;
alter table hzk_migr_fprints add constraint hzk_migr_fprints_pk primary key (company_id, device_id, pin, finger_no) using index tablespace GWS_INDEX;
alter table hzk_migr_fprints add constraint hzk_migr_fprints_c1 check (regexp_like(pin, '^\d+$'));
  
alter table hzk_migr_tracks drop column pin;
alter table hzk_migr_tracks rename column temp_column to pin; 
alter table hzk_migr_tracks add constraint hzk_migr_tracks_c3 check (regexp_like(pin, '^\d+$'));

alter table hzk_migr_persons drop constraint hzk_migr_persons_u2;
alter table hzk_migr_persons drop column pin;
alter table hzk_migr_persons rename column temp_column to pin;
alter table hzk_migr_persons add constraint hzk_migr_persons_u2 unique (company_id, device_id, pin) using index tablespace GWS_INDEX;
alter table hzk_migr_persons add constraint hzk_migr_persons_c1 check (regexp_like(pin, '^\d+$'));

--------------------------------------------------
prompt fazo_z.run()
--------------------------------------------------
exec fazo_z.run('hzk_migr_persons');
exec fazo_z.run('hzk_migr_tracks');
exec fazo_z.run('hzk_migr_fprints');
exec fazo_z.run('htt_persons');
