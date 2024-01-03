prompt adding schedule flex to individual schedules
----------------------------------------------------------------------------------------------------
update htt_schedule_registries q
   set q.schedule_kind = 'C';
commit;   
