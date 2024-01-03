create or replace package Htt_Job is
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Start(i_Interval_In_Seconds number := null);
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Stop;
  ----------------------------------------------------------------------------------------------------
  Procedure Integrate_Company_Tracks(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Integration_Job;
end Htt_Job;
/
create or replace package body Htt_Job is
  c_Acms_Integration_Job constant varchar2(50) := 'HTT_JOB_ACMS_INTEGRATION_JOB';
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HTT:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Start(i_Interval_In_Seconds number := null) is
    pragma autonomous_transaction;
    v_Interval varchar2(100);
  begin
    if Biruni_Core.Job_Exists(c_Acms_Integration_Job) then
      return;
    end if;
  
    v_Interval := 'SYSTIMESTAMP + INTERVAL ''' || Nvl(i_Interval_In_Seconds, 60) || ''' SECOND';
    Dbms_Scheduler.Create_Job(Job_Name        => c_Acms_Integration_Job,
                              Job_Type        => 'STORED_PROCEDURE',
                              Job_Action      => 'htt_job.acms_integration_job',
                              Repeat_Interval => v_Interval,
                              Enabled         => true,
                              Job_Class       => Biruni_Core.c_Job_Class,
                              Comments        => 'Supervise jobs');
    commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Stop is
  begin
    if Biruni_Core.Job_Exists(c_Acms_Integration_Job) then
      Dbms_Scheduler.Drop_Job(c_Acms_Integration_Job, Defer => true);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Integrate_Company_Tracks(i_Company_Id number) is
    pragma autonomous_transaction;
    r_Track      Htt_Tracks%rowtype;
    v_Filial_Ids Array_Number;
    v_Error_Text varchar2(200 char);
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (select q.*, w.Location_Id, q.Rowid
                from Htt_Acms_Tracks q
                join Htt_Devices w
                  on q.Company_Id = w.Company_Id
                 and q.Device_Id = w.Device_Id
               where q.Company_Id = i_Company_Id
                 and q.Status = Htt_Pref.c_Acms_Track_Status_New)
    loop
      r_Track.Company_Id  := r.Company_Id;
      r_Track.Track_Time  := Htt_Util.Convert_Timestamp(i_Date     => r.Track_Datetime,
                                                        i_Timezone => Htt_Util.Load_Timezone(i_Company_Id  => r.Company_Id,
                                                                                             i_Location_Id => r.Location_Id));
      r_Track.Track_Type  := r.Track_Type;
      r_Track.Person_Id   := r.Person_Id;
      r_Track.Mark_Type   := r.Mark_Type;
      r_Track.Device_Id   := r.Device_Id;
      r_Track.Location_Id := r.Location_Id;
      r_Track.Is_Valid    := 'Y';
    
      v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r.Company_Id,
                                              i_Location_Id => r.Location_Id,
                                              i_Person_Id   => r.Person_Id);
    
      if v_Filial_Ids.Count = 0 then
        v_Error_Text := Substr(t('the person is not attached to the location where the device is installed, filial_id=$2, location_id=$1, person_id=$3',
                                 r_Track.Filial_Id,
                                 r_Track.Location_Id,
                                 r_Track.Person_Id),
                               200);
        update Htt_Acms_Tracks q
           set q.Status     = Htt_Pref.c_Acms_Track_Status_Failed,
               q.Error_Text = v_Error_Text
         where q.Rowid = r.Rowid;
      
        continue;
      
      end if;
    
      for j in 1 .. v_Filial_Ids.Count
      loop
        r_Track.Filial_Id := v_Filial_Ids(j);
        r_Track.Track_Id  := Htt_Next.Track_Id;
      
        Htt_Api.Track_Add(r_Track);
      end loop;
    
      update Htt_Acms_Tracks q
         set q.Status = Htt_Pref.c_Acms_Track_Status_Completed
       where q.Rowid = r.Rowid;
    end loop;
  
    Biruni_Route.Context_End;
  
    commit;
  exception
    when others then
      rollback;
    
      v_Error_Text := Substrb(Dbms_Utility.Format_Error_Backtrace, 1, 200);
    
      update Htt_Acms_Tracks q
         set q.Status     = Htt_Pref.c_Acms_Track_Status_Failed,
             q.Error_Text = v_Error_Text
       where q.Company_Id = i_Company_Id
         and q.Status = Htt_Pref.c_Acms_Track_Status_New;
      commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Integration_Job is
    v_Company_Ids Array_Number;
  begin
    select q.Company_Id
      bulk collect
      into v_Company_Ids
      from Htt_Acms_Tracks q
     where q.Status = Htt_Pref.c_Acms_Track_Status_New
     group by q.Company_Id;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Integrate_Company_Tracks(v_Company_Ids(i));
    end loop;
  end;

end Htt_Job;
/
