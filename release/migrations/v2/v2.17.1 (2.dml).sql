prompt migr from 15.02.2023
----------------------------------------------------------------------------------------------------  
prompt change column type to varchar2
----------------------------------------------------------------------------------------------------
update htt_persons      set temp_column = pin;
commit;
update hzk_migr_fprints set temp_column = pin;
commit;
update hzk_migr_tracks  set temp_column = pin;
commit;
update hzk_migr_persons set temp_column = pin;
commit;
