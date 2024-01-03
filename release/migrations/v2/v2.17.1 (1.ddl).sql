prompt migr from 15.02.2023
----------------------------------------------------------------------------------------------------  
prompt change column type to varchar2
----------------------------------------------------------------------------------------------------
alter table htt_persons      add temp_column varchar2(15);
alter table hzk_migr_fprints add temp_column varchar2(20);
alter table hzk_migr_tracks  add temp_column varchar2(20);
alter table hzk_migr_persons add temp_column varchar2(20);
