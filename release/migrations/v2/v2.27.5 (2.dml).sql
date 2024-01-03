prompt adding hrm_setting column
----------------------------------------------------------------------------------------------------
update hrm_settings q
   set q.position_fixing = 'N';
commit;
