prompt adding trans_check
----------------------------------------------------------------------------------------------------
update htt_tracks
   set trans_check = 'N';
commit;

update htt_timesheet_tracks
   set trans_check = 'N';
commit;
