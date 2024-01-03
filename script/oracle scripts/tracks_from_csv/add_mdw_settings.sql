prompt add mdw job settings
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
---------------------------------------------------------------------------------------------------- 
insert into Mdw_Task_Types
  (Task_Type_Id, Task_Procedure)
values
  (Migr_Tracks.Task_Type_Id, 'MIGR_TRACKS.RUN');

----------------------------------------------------------------------------------------------------
insert into Mdw_Task_Planners
  (Code, Plan_Procedure, Worker_Count, Minutes_Interval)
values
  (Migr_Tracks.Plan_Code, 'MIGR_TRACKS.PLAN', 10, 1440);
  
commit;
