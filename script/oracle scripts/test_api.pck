create or replace package Test_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Job_One_Time;
end Test_Api;
/
create or replace package body Test_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Job_One_Time is
    v_Old_Company_Id number := 480;
    v_New_Company_Id number := Md_Pref.c_Migr_Company_Id;
  
    v_Start_Time number;
  begin
    /*  Biruni_Route.Context_Begin;
      Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
      Client_Migr.Migr_Biruni_Files;
      Biruni_Route.Context_End;
      commit;
    */
  
    -- migr_org_struct caches filials
    Client_Migr.Cache_Filial_Ids(v_New_Company_Id);
    Client_Migr.Activate_Division_Fix_Mode;
  
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    v_Start_Time := Dbms_Utility.Get_Time();
    Client_Migr.Migr_Staff_Lines(v_Old_Company_Id, v_New_Company_Id);
    Dbms_Output.Put_Line('Migr_Staff_Lines: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
    Biruni_Route.Context_End;
    commit;
    return;
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    v_Start_Time := Dbms_Utility.Get_Time();
    Client_Migr.Migr_Managers(v_Old_Company_Id, v_New_Company_Id);
    Dbms_Output.Put_Line('Migr_Managers: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
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
    Dbms_Output.Put_Line('Migr_Responsible_Persons: ' ||
                         ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
    Biruni_Route.Context_End;
    commit;
  
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    v_Start_Time := Dbms_Utility.Get_Time();
    Client_Migr.Staff_Refresh_Cache(v_New_Company_Id);
    Dbms_Output.Put_Line('Staff_Refresh_Cache: ' ||
                         ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
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
  end;
end Test_Api;
/
