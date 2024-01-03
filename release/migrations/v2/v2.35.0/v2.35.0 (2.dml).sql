prompt add take additional rest days column
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update htt_schedule_templates 
   set take_additional_rest_days = 'N';
commit;
   
---------------------------------------------------------------------------------------------------- 
prompt adding ignore free time settings and gps turnout and additional rest days columns
----------------------------------------------------------------------------------------------------
update htt_schedules q
   set q.count_free = 'Y',
       q.take_additional_rest_days = 'N',
       q.gps_turnout_enabled = 'N',
       q.gps_use_location    = 'N';
   
update htt_schedule_registries q
   set q.count_free = 'Y',
       q.take_additional_rest_days = 'N',
       q.gps_turnout_enabled = 'N',
       q.gps_use_location    = 'N';
   
update htt_timesheets q
   set q.count_free = 'Y',
       q.gps_turnout_enabled = 'N',
       q.gps_use_location    = 'N';
commit;
