prompt v2.34.0 2.dml
---------------------------------------------------------------------------------------------------- 
whenever sqlerror exit failure rollback
----------------------------------------------------------------------------------------------------
prompt setting timesheet allowed/extra begin time to 0
---------------------------------------------------------------------------------------------------- 
update htt_timesheets q
   set q.allowed_late_time  = 0,
       q.allowed_early_time = 0,
       q.begin_late_time    = 0,
       q.end_early_time     = 0;
commit;       
       
update htt_schedules q
   set q.allowed_late_time  = 0,
       q.allowed_early_time = 0,
       q.begin_late_time    = 0,
       q.end_early_time     = 0;
       
update htt_schedule_registries q
   set q.allowed_late_time  = 0,
       q.allowed_early_time = 0,
       q.begin_late_time    = 0,
       q.end_early_time     = 0;
commit;
