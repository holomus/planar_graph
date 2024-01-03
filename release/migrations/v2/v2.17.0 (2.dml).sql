prompt migr from 03.02.2023 (dml)
----------------------------------------------------------------------------------------------------
prompt move data from htt_hikvision_servers to htt_acms_servers
----------------------------------------------------------------------------------------------------
insert into htt_acms_servers
  select * from htt_hikvision_servers;

----------------------------------------------------------------------------------------------------
prompt move data from htt_company_hikvision_servers to htt_company_acms_servers
----------------------------------------------------------------------------------------------------
insert into htt_company_acms_servers
  select * from htt_company_hikvision_servers;

----------------------------------------------------------------------------------------------------
prompt move data from htt_hikvision_tracks to htt_acms_tracks
----------------------------------------------------------------------------------------------------
insert into htt_acms_tracks
  (company_id,
   track_id,
   device_id,
   person_id,
   track_type,
   track_datetime,
   mark_type,
   status,
   error_text)
  select t.company_id,
         t.track_id,
         t.device_id,
         t.person_id,
         t.track_type,
         t.track_datetime,
         t.mark_type,
         decode(t.status, 'E', 'F', t.status),
         t.error_text
    from htt_hikvision_tracks t;

----------------------------------------------------------------------------------------------------
prompt move verifix hikvision job to acms job
----------------------------------------------------------------------------------------------------
declare
  c_Hikvision_Integration_Job constant varchar2(50) := 'HTT_JOB_HIKVISION_INTEGRATION_JOB';
  c_Acms_Integration_Job      constant varchar2(50) := 'HTT_JOB_ACMS_INTEGRATION_JOB';
begin
  for r in (select *
              from User_Scheduler_Jobs t
             where t.Job_Name = c_Hikvision_Integration_Job)
  loop
    Dbms_Scheduler.Drop_Job(c_Hikvision_Integration_Job);
  
    Dbms_Scheduler.Create_Job(Job_Name        => c_Acms_Integration_Job,
                              Job_Type        => 'STORED_PROCEDURE',
                              Job_Action      => 'htt_job.acms_integration_job',
                              Repeat_Interval => r.Repeat_Interval,
                              Enabled         => true,
                              Job_Class       => Biruni_Core.c_Job_Class,
                              Comments        => 'Supervise jobs');
  end loop;
end;
/
commit;
