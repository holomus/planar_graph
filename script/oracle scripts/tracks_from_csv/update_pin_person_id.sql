prompt updating Migr_Csv_Tracks
------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update Migr_Csv_Tracks q
   set q.Pin =
       (select p.Pin
          from Migr_Persons p
         where p.Full_Name = q.Full_Name)
 where q.Pin is null
   and q.Person_Id is null
   and q.Full_Name not in ('ABDIRASHIDOV AZIZ ABDIXOLIL O''G''LI');

update Migr_Csv_Tracks q
   set q.Person_Id =
       (select p.Person_Id
          from Htt_Persons p
         where p.Company_Id = 100
           and Upper(p.Pin) = Upper(q.Pin))
 where q.Pin is not null
   and q.Person_Id is null;
