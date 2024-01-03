PL/SQL Developer Test script 3.0
51
declare
  v_Company_Id number := 100; -- Md_Pref.c_Migr_Company_Id;
begin
  Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_One := Fazo.Number_Code_Aat();
  Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_Two := Fazo.Number_Code_Aat();

  Hr5_Migr_Pref.g_Begin_Date := Trunc(to_date('01.04.23', 'dd.mm.yy'), 'mon');
  Hr5_Migr_Pref.g_End_Date   := Trunc(to_date('30.04.23', 'dd.mm.yy'), 'mon');

  -- -- md module
  -- Hr5_Migr_Md.Migr_Biruni_Files(v_Company_Id);
  -- Hr5_Migr_Md.Migr_Initial_Persons(v_Company_Id);
  -- Hr5_Migr_Md.Migr_Filials(v_Company_Id);

  -- -- mr module
  -- Hr5_Migr_Mr.Migr_Regions(v_Company_Id);

  -- -- ref module
  -- Hr5_Migr_Ref.Migr_Reference_Data(v_Company_Id);

  -- -- staff module
  -- Hr5_Migr_Staff.Migr_Staff_Data(v_Company_Id);

  -- -- robot module
  -- Hr5_Migr_Robot.Migr_Ref_Data(v_Company_Id); -- 7:53 plan_docs, last 4 month 3:40
  -- Hr5_Migr_Robot.Migr_Journals(v_Company_Id);
  -- Hr5_Migr_Robot.Migr_First_Journals_Post(v_Company_Id);
  -- Hr5_Migr_Robot.Migr_Timeoff_Journals_Post(v_Company_Id); -- not implemented
  -- Hr5_Migr_Robot.Migr_Try_Robot_Close(v_Company_Id); -- bitta robot close bo'lmaydi
  -- Hr5_Migr_Robot.Migr_Schedule_Registry_Post(v_Company_Id);
  -- Hr5_Migr_Robot.Migr_Timebook_Adjustment_Journals(v_Company_Id);
  -- Hr5_Migr_Robot.Migr_Timebook_Adjustment_Journals_Post(v_Company_Id);

  -- -- learn module
  -- Hr5_Migr_Learn.Migr_Learn_References(v_Company_Id);
  -- Hr5_Migr_Learn.Migr_Learn_Data(v_Company_Id); -- traings da address not nul ekan, '-' qo'ydim

  -- -- hrt module
  -- Hr5_Migr_Hrt.Migr_Hrt_References(v_Company_Id);
  -- Hr5_Migr_Hrt.Migr_Hrt_Tracks(v_Company_Id);


  -- Hr5_Migr_Cv.Migr_Cv_Contracts(v_Company_Id);
  -- Hr5_Migr_Cv.Migr_Cv_Facts(v_Company_Id);
  -- Hr5_Migr_Cv.Migr_Cv_Cached_Contract_Item_Names(v_Company_Id);
  
  -- -- util functions
  -- Hr5_Migr_Robot.Run_Staf_Refresh_Cache(v_Company_Id);
  -- Hr5_Migr_Robot.Create_Users_For_Employees(v_Company_Id);
  -- Hr5_Migr_Hrt.Gen_Timesheet_Facts(v_Company_Id);
end;
0
0
