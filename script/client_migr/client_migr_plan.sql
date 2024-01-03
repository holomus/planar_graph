1. run create_synonyms scripts
1.1 run create_synonyms_step_1.sql on dump_user schema

1.2 run create_synonyms_step_2.sql on new_user schema

2. create tables at client_migr.sql    
      
3. create new company, take old company_id and new company_id
3.1 for company "bek cluster" correct job codes, there is two jobs with job code="1"     
    
3.2 and commit on each 50th loop iteration of migr_persons, migr_staff_lines, migr_tracks if company is very big (e. g.: "bek cluster") 

4. change Md_Pref.c_Migr_Company_id set it to new_company_id

5. use code below
   
   after code executed check migr_errors table 
   if there are any errors correct them  
   and run the code again
   
   when you run the code second time dont run migr_org_struct function again
   
   if process takes a long time you can watch it in session viewer
   
   using each migr function separately is preferred (so you can correct any error before next migr function)
     
   gen_timesheets function is especially slow   
   
6. refresh staff cache, generate schedule days for needed years, generate timesheets

7. change back Md_Pref.c_Migr_Company_id to -1

/*
declare
  v_Old_Company_Id number := ;
  v_New_Company_Id number := Md_Pref.c_Migr_Company_Id;

  v_Start_Time number;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  Client_Migr.Migr_Biruni_Files;
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Org_Struct(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Org_Struct: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  -- migr_org_struct caches filials
  Client_Migr.Cache_Filial_Ids(v_New_Company_Id);
  Client_Migr.Activate_Division_Fix_Mode;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Jobs_Ranks(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Jobs_Ranks: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_References(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_References: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Create_Basic_Oper_Types(v_New_Company_Id);
  Dbms_Output.Put_Line('Create_Basic_Oper_Types: ' ||
                       ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Schedules(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Schedules: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Persons(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Persons: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Staff_Lines(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Staff_Lines: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Locations_And_Devices(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Locations_And_Devices: ' ||
                       ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Tracks(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Tracks: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Leaves(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Leaves: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;
  
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Tasks(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Tasks: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Perf_Plan(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Perf_Plan: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Users(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Users: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;
  
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Responsible_Persons(v_Old_Company_Id, v_New_Company_Id);
  Dbms_Output.Put_Line('Migr_Responsible_Persons: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;
  
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Staff_Refresh_Cache(v_New_Company_Id);
  Dbms_Output.Put_Line('Staff_Refresh_Cache: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;
  
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  --Client_Migr.Gen_Schedule_Days(v_New_Company_Id,i_Year=>);
  Dbms_Output.Put_Line('Gen_Schedule_Days: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  --v_Start_Time := Dbms_Utility.Get_Time();
  --Client_Migr.Gen_Timesheets(v_New_Company_Id);
  --Dbms_Output.Put_Line('Gen_Timesheets: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  
  -- usable only after generating timesheets
  --Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  --v_Start_Time := Dbms_Utility.Get_Time();
  --Client_Migr.Migr_Timesheet_Plan_Changes(v_Old_Company_Id, v_New_Company_Id);
  --Dbms_Output.Put_Line('Migr_Timesheet_Plan_Changes: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));  
  --commit;
end;*/

  
