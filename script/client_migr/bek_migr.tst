PL/SQL Developer Test script 3.0
125
declare
  v_Old_Company_Id number := 480;
  v_New_Company_Id number := 580;

  v_Subcompany_Id number := -1;
  v_Filial_Id     number := -1;

  v_Start_Time number;
begin
  -- fix schedules shift and other things before fixing period  
  -- because fixing schedule period creates duplicated schedules

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  Client_Migr.Migr_Biruni_Files;
  Biruni_Route.Context_End;
  commit;

  -- dont comment
  -- should be active on every run
  Client_Migr.Activate_Division_Fix_Mode;

  /*  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Schedules(i_Old_Company_Id => v_Old_Company_Id,
                             i_New_Company_Id => v_New_Company_Id,
                             i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Schedules: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;*/

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Persons(i_Old_Company_Id => v_Old_Company_Id,
                           i_New_Company_Id => v_New_Company_Id,
                           i_Subcompany_Id  => v_Subcompany_Id,
                           i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Persons: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Staff_Lines(i_Old_Company_Id => v_Old_Company_Id,
                               i_New_Company_Id => v_New_Company_Id,
                               i_Subcompany_Id  => v_Subcompany_Id,
                               i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Staff_Lines: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Schedule_Changes(i_Old_Company_Id => v_Old_Company_Id,
                                    i_New_Company_Id => v_New_Company_Id,
                                    i_Subcompany_Id  => v_Subcompany_Id,
                                    i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Schedule_Changes: ' ||
                       ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Locations_And_Devices(i_Old_Company_Id => v_Old_Company_Id,
                                         i_New_Company_Id => v_New_Company_Id,
                                         i_Subcompany_Id  => v_Subcompany_Id,
                                         i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Locations_And_Devices: ' ||
                       ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Tracks(i_Old_Company_Id => v_Old_Company_Id,
                          i_New_Company_Id => v_New_Company_Id,
                          i_Subcompany_Id  => v_Subcompany_Id,
                          i_Filial_Id      => v_Filial_Id,
                          i_Migr_Since     => to_date('01.11.2022', 'dd.mm.yyyy'));
  Dbms_Output.Put_Line('Migr_Tracks: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  v_Start_Time := Dbms_Utility.Get_Time();
  Client_Migr.Migr_Leaves(i_Old_Company_Id => v_Old_Company_Id,
                          i_New_Company_Id => v_New_Company_Id,
                          i_Subcompany_Id  => v_Subcompany_Id,
                          i_Filial_Id      => v_Filial_Id);
  Dbms_Output.Put_Line('Migr_Leaves: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  Biruni_Route.Context_End;
  commit;

  --   Biruni_Route.Context_Begin;
  --   Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  --   v_Start_Time := Dbms_Utility.Get_Time();
  --   Client_Migr.Gen_Schedule_Days(i_New_Company_Id => v_New_Company_Id,
  --                                 i_Year           => 2023,
  --                                 i_Filial_Id      => v_Filial_Id);
  --   Dbms_Output.Put_Line('Gen_Schedule_Days: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  --   Biruni_Route.Context_End;
  --   commit;

  --   v_Start_Time := Dbms_Utility.Get_Time();
  --   Client_Migr.Gen_Timesheets(i_New_Company_Id => v_New_Company_Id, i_Filial_Id => v_Filial_Id);
  --   Dbms_Output.Put_Line('Gen_Timesheets: ' || ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));

  --   Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  --   v_Start_Time := Dbms_Utility.Get_Time();
  --   Client_Migr.Migr_Timesheet_Plan_Changes(i_Old_Company_Id => v_Old_Company_Id,
  --                                           i_New_Company_Id => v_New_Company_Id,
  --                                           i_Subcompany_Id  => v_Subcompany_Id,
  --                                           i_Filial_Id      => v_Filial_Id);
  --   Dbms_Output.Put_Line('Migr_Timesheet_Plan_Changes: ' ||
  --                        ((Dbms_Utility.Get_Time() - v_Start_Time) / 100));
  --   commit;
end;
0
0
