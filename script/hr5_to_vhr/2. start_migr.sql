prompt ==== **start HR5 to Verifix HR migration** ====
prompt ==== ** HR5_MIGR Api level ** ====
@@3.1.hr5_migr_pref.pck;
@@3.2.hr5_migr_util.pck;
@@3.3.hr5_migr_api.pck;
@@8.1.hr5_migr_core.pck;

prompt ==== ** HR5_MIGR PCK ** ====
@@4.1.hr5_migr_md.pck;
@@4.2.hr5_migr_mr.pck;
@@4.3.hr5_migr_ref.pck;
@@4.4.hr5_migr_staff.pck;
@@4.5.hr5_migr_robot.pck;
@@4.6.hr5_migr_learn.pck;
@@4.7.hr5_migr_hrt.pck;
@@4.8.hr5_migr_cv.pck;

----------------------------------------------------------------------------------------------------
begin
  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '18:10',
                                           i_Procedure_Name => 'hr5_migr_core.run_migr');
  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '12:00',
                                           i_Procedure_Name => 'hr5_migr_core.run_migr');

  commit;
end;
/
