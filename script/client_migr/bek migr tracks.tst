PL/SQL Developer Test script 3.0
54
declare
  v_Old_Company_Id number := 480;
  v_New_Company_Id number := 580;

  v_Start_Time number;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
  Client_Migr.Migr_Biruni_Files;
  Biruni_Route.Context_End;
  commit;

  -- dont comment
  -- should be active on every run 
  Client_Migr.Activate_Division_Fix_Mode;

  for r in (select p.Filial_Id, p.Name, null Subcompany_Id
              from Md_Filials p
              /*join Migr_Keys_Store_One Ks
                on Ks.Company_Id = v_New_Company_Id
               and Ks.Key_Name = 'filial_id'
               and Ks.New_Id = p.Filial_Id*/
             where p.Company_Id = v_New_Company_Id
               and p.State = 'A')
  loop
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    Client_Migr.Migr_Tracks(i_Old_Company_Id => v_Old_Company_Id,
                            i_New_Company_Id => v_New_Company_Id,
                            i_Subcompany_Id  => r.Subcompany_Id,
                            i_Filial_Id      => r.Filial_Id,
                            i_Migr_Since     => to_date('01.11.2022', 'dd.mm.yyyy'));
    Biruni_Route.Context_End;
    commit;
  
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    Client_Migr.Migr_Leaves(i_Old_Company_Id => v_Old_Company_Id,
                            i_New_Company_Id => v_New_Company_Id,
                            i_Subcompany_Id  => r.Subcompany_Id,
                            i_Filial_Id      => r.Filial_Id);
    Biruni_Route.Context_End;
    commit;
  
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id => v_New_Company_Id);
    Client_Migr.Migr_Timesheet_Plan_Changes(i_Old_Company_Id => v_Old_Company_Id,
                                            i_New_Company_Id => v_New_Company_Id,
                                            i_Subcompany_Id  => r.Subcompany_Id,
                                            i_Filial_Id      => r.Filial_Id);
    Biruni_Route.Context_End;
    commit;
  end loop;
end;
0
0
