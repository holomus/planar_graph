prompt updating notification settings
----------------------------------------------------------------------------------------------------
update Hrm_Settings q
   set q.notification_enable = 'N';
commit;

