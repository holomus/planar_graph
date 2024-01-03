prompt adding verifix jobs
----------------------------------------------------------------------------------------------------
begin
  delete from Biruni_Job_Daily_Procedures t
   where Regexp_Like(t.Procedure_Name, '^h', 'i');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '00:00',
                                           i_Procedure_Name => 'hlic_core.generate');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '02:00',
                                           i_Procedure_Name => 'hpd_core.run_refresh_cache');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '03:00',
                                           i_Procedure_Name => 'htt_core.calc_gps_track_distance');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '03:00',
                                           i_Procedure_Name => 'htt_core.transform_potential_outputs');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '03:00',
                                           i_Procedure_Name => 'htt_core.clear_qr_codes');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '00:00',
                                           i_Procedure_Name => 'htt_core.gen_request_kind_accruals');

  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '04:00',
                                           i_Procedure_Name => 'hln_core.generate_daily_notifications');
                                           
  z_Biruni_Job_Daily_Procedures.Insert_Try(i_Start_Time     => '05:00',
                                           i_Procedure_Name => 'hpr_core.run_monthly_credit_transactions');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'acms_person_sync',
                                            i_Class_Name         => 'com.verifix.vhr.AcmsPersonsJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.PERSON_SYNC_REQUEST_PROCEDURE',
                                            i_Response_Procedure => 'HAC_JOB.PERSON_SYNC_RESPONSE_PROCEDURE',
                                            i_Start_Time         => 180,  -- 03:00
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'A');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'ftp_file',
                                            i_Class_Name         => 'com.verifix.vhr.predicts.FileLoadJobProvider',
                                            i_Request_Procedure  => 'HSC_JOB.FTP_FILE_LOAD_REQUEST_PROCEDURE',
                                            i_Response_Procedure => 'HSC_JOB.FTP_FILE_LOAD_RESPONSE_PROCEDURE',
                                            i_Start_Time         => null, -- no delay
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'A');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'dahua_tracks',
                                            i_Class_Name         => 'com.verifix.vhr.AcmsJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.DAHUA_TRACK_LOAD_REQUEST_PROCEDURE',
                                            i_Response_Procedure => null,
                                            i_Start_Time         => 180,  -- 03:00
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'A');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'hik_face_tracks',
                                            i_Class_Name         => 'com.verifix.vhr.AcmsJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.HIK_TRACK_BY_FACE_REQUEST_PROCEDURE',
                                            i_Response_Procedure => null,
                                            i_Start_Time         => 210, -- 03:30
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'A');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'hik_card_tracks',
                                            i_Class_Name         => 'com.verifix.vhr.AcmsJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.HIK_TRACK_BY_CARD_REQUEST_PROCEDURE',
                                            i_Response_Procedure => null,
                                            i_Start_Time         => 240, -- 04:00
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'A');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'hik_finger_tracks',
                                            i_Class_Name         => 'com.verifix.vhr.AcmsJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.HIK_TRACK_BY_FINGERPRINT_REQUEST_PROCEDURE',
                                            i_Response_Procedure => null,
                                            i_Start_Time         => 270, -- 04:30
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'P');

  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'device_status_update',
                                            i_Class_Name         => 'com.verifix.vhr.DeviceUpdateJobProvider',
                                            i_Request_Procedure  => 'HAC_JOB.ALL_DEVICE_STATUS_UPDATE_REQUEST',
                                            i_Response_Procedure => 'HAC_JOB.ALL_DEVICE_STATUS_UPDATE_RESPONSE',
                                            i_Start_Time         => null,
                                            i_Period             => 2, -- every 2 minute 
                                            i_State              => 'A');
                                            
  z_Biruni_Application_Server_Jobs.Save_One(i_Code               => 'predict_monthly',
                                            i_Class_Name         => 'com.verifix.vhr.predicts.PredictJobProvider',
                                            i_Request_Procedure  => 'HSC_JOB.MONTHLY_PREDICT_REQUEST_PROCEDURE',
                                            i_Response_Procedure => null,
                                            i_Start_Time         => null,
                                            i_Period             => 1440, -- every 24 hours
                                            i_State              => 'P');

  commit;
end;
/
