prompt migr keys store
----------------------------------------------------------------------------------------------------
insert into Migr_Keys_Store_One
  (Company_Id, Key_Name, Old_Id, New_Id)
  select q.Company_Id, q.Key_Name, q.Old_Id, q.New_Id
    from Migr_Keys_Store_Two q
   where q.Key_Name in ('location_id', 'device_id')
   group by q.Company_Id, q.Key_Name, q.Old_Id, q.New_Id;
commit;
