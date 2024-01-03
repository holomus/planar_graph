PL/SQL Developer Test script 3.0
17
-- Created on 5/12/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  Dbms_Scheduler.Create_Job(Job_Name     => 'erp_migr_700',
                            Job_Type     => 'PLSQL_BLOCK',
                            Job_Action   => 'begin erp_migr.Migr_Company(i_company_id=>700); end;',
                            Job_Class    => Biruni_Core.c_Job_Class,
                            Auto_Drop    => true,
                            Comments     => 'job',
                            Max_Runs     => 1,
                            Max_Failures => 1);

  Dbms_Scheduler.Run_Job(Job_Name => 'erp_migr_700', Use_Current_Session => false);
end;
0
0
