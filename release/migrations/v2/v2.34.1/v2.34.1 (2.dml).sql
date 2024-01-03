prompt adding ignore tracks setting
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update htt_devices q
   set q.ignore_tracks = 'N';
commit;  
