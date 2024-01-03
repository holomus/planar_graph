prompt adding staff_id to hpr_charges
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update Hpr_Charges q
   set q.Staff_Id =
       (select p.Staff_Id
          from Hpd_Lock_Intervals p
         where p.Company_Id = q.Company_Id
           and p.Filial_Id = q.Filial_Id
           and p.Interval_Id = q.Interval_Id)
 where q.Interval_Id is not null;
 
update Hpr_Charges q
   set q.Staff_Id =
       (select p.Staff_Id
          from Hpr_Charge_Document_Operations p
         where p.Company_Id = q.Company_Id
           and p.Filial_Id = q.Filial_Id
           and p.Operation_Id = q.Doc_Oper_Id)
 where q.Doc_Oper_Id is not null;
commit;
