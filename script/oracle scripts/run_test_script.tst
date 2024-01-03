PL/SQL Developer Test script 3.0
16
-- Created on 5/12/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  --Biruni_Route.Context_Begin;
/*  insert into Runner
    (Id)
  values
    (One_Time_Job_Sq.Nextval);*/

  Dbms_Scheduler.Run_Job(Job_Name => 'company', Use_Current_Session => false);

  --Biruni_Route.Context_End;
end;
0
0
