prompt migr keys store
----------------------------------------------------------------------------------------------------
delete from Migr_Keys_Store_Two q
 where q.Key_Name in ('location_id', 'device_id');
commit;
