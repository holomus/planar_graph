prompt migrating training subjects
----------------------------------------------------------------------------------------------------
insert into Hln_Training_Current_Subjects
  (Company_Id, Filial_Id, Training_Id, Subject_Id)
  select q.Company_Id, q.Filial_Id, q.Training_Id, q.Subject_Id
    from Hln_Trainings q;
commit;

----------------------------------------------------------------------------------------------------
prompt migrating business trip regions
----------------------------------------------------------------------------------------------------
insert into Hpd_Business_Trip_Regions
  (Company_Id, Filial_Id, Timeoff_Id, Region_Id, order_no)
  select q.Company_Id, q.Filial_Id, q.Timeoff_Id, q.Region_Id, 1
    from Hpd_Business_Trips q;
commit;
