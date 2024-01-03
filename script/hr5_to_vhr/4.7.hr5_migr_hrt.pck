create or replace package Hr5_Migr_Hrt is
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Hrt_References(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Hrt_Tracks(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------  
  Procedure Gen_Timesheet_Facts(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Hrt;
/
create or replace package body Hr5_Migr_Hrt is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Checkpoints is
    v_Total          number;
    v_Location_Id    number;
    v_Department_Ids Arraylist := Arraylist();
  begin
    Dbms_Application_Info.Set_Module('Migr_Checkpoints', 'started Migr_Checkpoints');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hrt_Checkpoints q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Hrt_Checkpoint
               and Uk.Old_Id = q.Checkpoint_Id);
  
    for r in (select a.*, Rownum
                from (select q.Checkpoint_Id,
                             min(q.Filial_Id) Filial_Id,
                             min(q.Name) name,
                             min(q.State) State,
                             Stats_Mode(Rd.Address) Address,
                             Stats_Mode(Rd.Lat_Lng) Lat_Lng,
                             max(Rd.Region_Id) Region_Id,
                             Json_Arrayagg(d.Department_Id) Department_Ids
                        from Hr5_Hrt_Checkpoints q
                        join Hr5_Hrt_Checkpoint_Departments d
                          on d.Checkpoint_Id = q.Checkpoint_Id
                        join Hr5_Hr_Ref_Departments Rd
                          on Rd.Department_Id = d.Department_Id
                       where not exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Hrt_Checkpoint
                                 and Uk.Old_Id = q.Checkpoint_Id)
                       group by q.Checkpoint_Id) a)
    loop
      Dbms_Application_Info.Set_Module('Migr_Checkpoints',
                                       'inserted ' || (r.Rownum - 1) || ' Checkpoint(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Location_Id := Htt_Next.Location_Id;
      
        z_Htt_Locations.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                   i_Location_Id      => v_Location_Id,
                                   i_Name             => r.Name,
                                   i_Location_Type_Id => null,
                                   i_Timezone_Code    => null,
                                   i_Region_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                  i_Key_Name   => Hr5_Migr_Pref.c_Mr_Region,
                                                                                  i_Old_Id     => r.Region_Id),
                                   i_Address          => r.Address,
                                   i_Latlng           => Nvl(r.Lat_Lng,
                                                             Hr5_Migr_Pref.c_Default_Latlng),
                                   i_Accuracy         => Hr5_Migr_Pref.c_Default_Accuracy,
                                   i_Bssids           => null,
                                   i_Prohibited       => 'N',
                                   i_State            => r.State,
                                   i_Code             => null);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Hrt_Checkpoint,
                                i_Old_Id     => r.Checkpoint_Id,
                                i_New_Id     => v_Location_Id);
      
        -- attach to filial
        z_Htt_Location_Filials.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                          i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                          i_Location_Id => v_Location_Id);
      
        -- attach to division
        v_Department_Ids := Fazo.Parse_Array(r.Department_Ids);
      
        for k in 1 .. v_Department_Ids.Count
        loop
          z_Htt_Location_Divisions.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                              i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                              i_Location_Id => v_Location_Id,
                                              i_Division_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                                                                        i_Old_Id     => v_Department_Ids.r_Number(k),
                                                                                        i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id));
        end loop;
      
        -- attach to person
        for Per in (select (select Ks.New_Id
                              from Hr5_Migr_Keys_Store_One Ks
                             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                               and Ks.Old_Id = Uc.User_Id) as Person_Id,
                           case
                              when exists (select 1
                                      from Hr5_Hr_Ref_Department_Users Du
                                     where Du.User_Id = Uc.User_Id
                                       and Du.Department_Id in
                                           (select Cd.Department_Id
                                              from Hr5_Hrt_Checkpoint_Departments Cd
                                             where Cd.Checkpoint_Id = r.Checkpoint_Id)) then
                               'A'
                              else
                               'M'
                            end as Attach_Type
                      from Hr5_Hrt_User_Checkpoints Uc
                     where Uc.Checkpoint_Id = r.Checkpoint_Id)
        loop
          z_Htt_Location_Persons.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                            i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                            i_Location_Id => v_Location_Id,
                                            i_Person_Id   => Per.Person_Id,
                                            i_Attach_Type => Per.Attach_Type);
        end loop;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hrt_Checkpoints',
                                 i_Key_Id        => r.Checkpoint_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Checkpoints', 'finished Migr_Checkpoints');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Zktime_Devices is
    v_Total             number;
    v_Device_Id         number;
    v_Terminal_Model_Id number;
    v_Device_Type_Id    number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
  begin
    Dbms_Application_Info.Set_Module('Migr_Zktime_Devices', 'started Migr_Zktime_Devices');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hrt_Zktime_Devices q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Hrt_Zktime_Device
               and Uk.Old_Id = Substr(q.Serial_Number, 5));
  
    -- terminal model
    select Tm.Model_Id
      into v_Terminal_Model_Id
      from Htt_Terminal_Models Tm
     where Tm.Pcode = Htt_Pref.c_Pcode_Zkteco_F18;
  
    for r in (select q.*, Rownum
                from Hr5_Hrt_Zktime_Devices q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Hrt_Zktime_Device
                         and Uk.Old_Id = Substr(q.Serial_Number, 5)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Zktime_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' Zktime Device(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Device_Id := Htt_Next.Device_Id;
      
        z_Htt_Devices.Insert_One(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                 i_Device_Id       => v_Device_Id,
                                 i_Name            => r.Name,
                                 i_Device_Type_Id  => v_Device_Type_Id,
                                 i_Serial_Number   => r.Serial_Number,
                                 i_Model_Id        => v_Terminal_Model_Id,
                                 i_Location_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                               i_Key_Name   => Hr5_Migr_Pref.c_Hrt_Checkpoint,
                                                                               i_Old_Id     => r.Checkpoint_Id),
                                 i_Track_Types     => null,
                                 i_Mark_Types      => null,
                                 i_Emotion_Types   => null,
                                 i_Lang_Code       => null,
                                 i_Use_Settings    => 'N',
                                 i_Autogen_Inputs  => 'N',
                                 i_Autogen_Outputs => 'N',
                                 i_Restricted_Type => null,
                                 i_Last_Seen_On    => r.Last_Seen,
                                 i_State           => 'A');
      
        -- insert zktime
        z_Hzk_Devices.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                 i_Device_Id          => v_Device_Id,
                                 i_Check_Sent_On      => r.Check_Sent_On,
                                 i_Check_Received_On  => r.Check_Received_On,
                                 i_User_Number        => r.User_Number,
                                 i_Fingerprint_Number => r.Fingerprint_Number,
                                 i_Attendance_Number  => r.Attendance_Number,
                                 i_Ip_Address         => r.Ip_Address,
                                 i_Stamp              => r.Stamp,
                                 i_Opstamp            => r.Opstamp,
                                 i_Photostamp         => r.Photostamp,
                                 i_Error_Delay        => r.Error_Delay,
                                 i_Delay              => r.Delay,
                                 i_Transtimes         => r.Transtimes,
                                 i_Transinterval      => r.Transinterval,
                                 i_Realtime           => r.Realtime);
      
        -- insert zktime person fprints
        for Fp in (select *
                     from Hr5_Hrt_Zktime_Server_Fps f
                    where f.Serial_Number = r.Serial_Number
                      and f.Fid between 0 and 9
                      and exists (select 1
                             from Hr5_Mr_Natural_Persons p
                            where p.Person_Id = f.Staff_Id))
        loop
          z_Hzk_Person_Fprints.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                          i_Person_Id  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                   i_Old_Id     => Fp.Staff_Id),
                                          i_Finger_No  => Fp.Fid,
                                          i_Tmp        => Fp.Tmp);
        
          z_Hzk_Device_Fprints.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                          i_Device_Id  => v_Device_Id,
                                          i_Person_Id  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                   i_Old_Id     => Fp.Staff_Id),
                                          i_Finger_No  => Fp.Fid);
        end loop;
      
        -- insert zktime persons
        for Com in (select *
                      from Hr5_Hrt_Zktime_Commands c
                     where c.Serial_Number = r.Serial_Number)
        loop
          z_Hzk_Commands.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                    i_Command_Id       => Hzk_Next.Command_Id,
                                    i_Device_Id        => v_Device_Id,
                                    i_Command          => Com.Command,
                                    i_Command_Clob     => null,
                                    i_State            => Com.State,
                                    i_State_Changed_On => Com.State_Changed_On);
        end loop;
      
        -- insert pins (device admins)      
        for a in (select s.Staff_Id
                    from Hr5_Hrt_Zktime_Device_Pins s
                   where s.Serial_Number = r.Serial_Number
                     and s.Kind = 14)
        loop
          z_Htt_Device_Admins.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Device_Id  => v_Device_Id,
                                         i_Person_Id  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                  i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                  i_Old_Id     => a.Staff_Id));
        end loop;
      
        -- insert migr persons
        for p in (select Mp.*
                    from Hr5_Hrt_Migr_Persons Mp
                   where Mp.Serial_Number = r.Serial_Number)
        loop
          z_Hzk_Migr_Persons.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                        i_Migr_Person_Id => Hzk_Next.Migr_Person_Id,
                                        i_Device_Id      => v_Device_Id,
                                        i_Pin            => p.Pin,
                                        i_Person_Name    => p.Name,
                                        i_Person_Role    => case
                                                              when p.Person_Kind = '14' then
                                                               'A'
                                                              else
                                                               'N'
                                                            end,
                                        i_Password       => null,
                                        i_Rfid_Code      => null);
        end loop;
      
        -- insert attlog erros
        for Att in (select *
                      from Hr5_Hrt_Attlog_Errors a
                     where a.Serial_Number = r.Serial_Number)
        loop
          z_Hzk_Attlog_Errors.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Error_Id   => Hzk_Next.Attlog_Error_Id,
                                         i_Device_Id  => v_Device_Id,
                                         i_Command    => Att.Command,
                                         i_Error      => Att.Error,
                                         i_Status     => Hzk_Pref.c_Attlog_Error_Status_New);
        end loop;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Hrt_Zktime_Device,
                                i_Old_Id     => Substr(r.Serial_Number, 5),
                                i_New_Id     => v_Device_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hrt_Zktime_Devices',
                                 i_Key_Id        => Substr(r.Serial_Number, 5),
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- insert errors  
    insert into Hzk_Errors
      (Error, Created_On)
      select Ze.Error_Log, Ze.Created_On
        from Hr5_Hrt_Zktime_Errors Ze
       where not exists (select *
                from Hzk_Errors s
               where s.Error = Ze.Error_Log);
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Zktime_Devices', 'finished Migr_Zktime_Devices');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Tracks is
    v_Total number;
    v_Num   number := 0;
  begin
    Dbms_Application_Info.Set_Module('Migr_Tracks', 'started Migr_Tracks');
    Biruni_Route.Context_Begin;
  
    select count(*)
      into v_Total
      from Hr5_Hrt_Tracks q
     where q.Mark_Time between Hr5_Migr_Pref.g_Begin_Date and Hr5_Migr_Pref.g_End_Date
       and not exists (select *
              from Htt_Tracks k
             where k.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and k.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and k.Track_Time = q.Mark_Time
               and k.Person_Id = (select Kso.New_Id
                                    from Hr5_Migr_Keys_Store_One Kso
                                   where Kso.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                     and Kso.Key_Name = Hr5_Migr_Pref.c_Md_Person
                                     and Kso.Old_Id = q.Staff_Id)
               and k.Track_Type = q.Track_Type);
  
    for r in (select Hr5_Migr_Pref.g_Company_Id as Company_Id,
                     Hr5_Migr_Pref.g_Filial_Id as Filial_Id,
                     Htt_Tracks_Sq.Nextval as Track_Id,
                     Trunc(q.Mark_Time) as Track_Date,
                     q.Mark_Time as Track_Time,
                     q.Mark_Time as Track_Datetime,
                     (select Kso.New_Id
                        from Hr5_Migr_Keys_Store_One Kso
                       where Kso.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Kso.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Kso.Old_Id = q.Staff_Id) as Person_Id,
                     q.Track_Type,
                     q.Mark_Type,
                     null as Device_Id,
                     (select Kso.New_Id
                        from Hr5_Migr_Keys_Store_One Kso
                       where Kso.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Kso.Key_Name = Hr5_Migr_Pref.c_Hrt_Checkpoint
                         and Kso.Old_Id = q.Checkpoint_Id) as Location_Id,
                     q.Lat_Lng as Latlng,
                     case
                        when q.Lat_Lng is not null then
                         Hr5_Migr_Pref.c_Default_Accuracy
                        else
                         null
                      end as Accuracy,
                     q.Photo_Sha,
                     null as Bssid,
                     null as Note,
                     q.Track_Type as Original_Type,
                     'N' as Trans_Input,
                     'N' as Trans_Output,
                     'N' as Trans_Check,
                     'Y' as Is_Valid,
                     Htt_Pref.c_Track_Status_Draft as Status,
                     Hr5_Migr_Pref.g_User_System as Created_By,
                     Current_Timestamp as Created_On,
                     Hr5_Migr_Pref.g_User_System as Modified_By,
                     Current_Timestamp as Modified_On,
                     Biruni_Modified_Sq.Nextval as Modified_Id
                from Hr5_Hrt_Tracks q
               where q.Mark_Time between Hr5_Migr_Pref.g_Begin_Date and Hr5_Migr_Pref.g_End_Date
                 and not exists
               (select *
                        from Htt_Tracks k
                       where k.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and k.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and k.Track_Time = q.Mark_Time
                         and k.Person_Id = (select Kso.New_Id
                                              from Hr5_Migr_Keys_Store_One Kso
                                             where Kso.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                               and Kso.Key_Name = Hr5_Migr_Pref.c_Md_Person
                                               and Kso.Old_Id = q.Staff_Id)
                         and k.Track_Type = q.Track_Type))
    loop
      Dbms_Application_Info.Set_Module('Migr_Tracks',
                                       'inserted ' || v_Num || ' track(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        insert into Htt_Tracks
        values r;
      
        Htt_Core.Track_Add(i_Company_Id     => r.Company_Id,
                           i_Filial_Id      => r.Filial_Id,
                           i_Track_Id       => r.Track_Id,
                           i_Employee_Id    => r.Person_Id,
                           i_Track_Datetime => r.Track_Datetime,
                           i_Track_Type     => r.Track_Type,
                           i_Trans_Input    => r.Trans_Input,
                           i_Trans_Output   => r.Trans_Output,
                           i_Trans_Check    => r.Trans_Check);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hrt_Tracks',
                                 i_Key_Id        => r.Person_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace || '; time:' ||
                                                    to_char(r.Track_Time,
                                                            Href_Pref.c_Date_Format_Second));
      end;
    
      v_Num := v_Num + 1;
    end loop;
  
    Biruni_Route.Context_End;
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Tracks', 'finished Migr_Tracks');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Hrt_References(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Checkpoints;
    Migr_Zktime_Devices;
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Hrt_Tracks(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Tracks;
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Gen_Timesheet_Facts(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Emp_Cnt   number;
    v_Track_Cnt number;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    select count(*)
      into v_Emp_Cnt
      from (select s.Employee_Id
              from Href_Staffs s
             where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and s.State = 'A'
             group by s.Employee_Id);
  
    for Emp in (select s.Employee_Id, Rownum
                  from (select s.Employee_Id
                          from Href_Staffs s
                         where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
                           and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                           and s.State = 'A'
                         group by s.Employee_Id) s)
    loop
      Biruni_Route.Context_Begin;
    
      select count(*)
        into v_Track_Cnt
        from Htt_Tracks t
       where t.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and t.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and t.Track_Date between Hr5_Migr_Pref.g_Begin_Date and Hr5_Migr_Pref.g_End_Date
         and t.Is_Valid = 'Y'
         and t.Person_Id = Emp.Employee_Id;
    
      for r in (select t.*, Rownum
                  from Htt_Tracks t
                 where t.Company_Id = Hr5_Migr_Pref.g_Company_Id
                   and t.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                   and t.Track_Date between Hr5_Migr_Pref.g_Begin_Date and Hr5_Migr_Pref.g_End_Date
                   and t.Is_Valid = 'Y'
                   and t.Person_Id = Emp.Employee_Id)
      loop
        Htt_Core.Track_Delete(i_Company_Id  => r.Company_Id,
                              i_Filial_Id   => r.Filial_Id,
                              i_Track_Id    => r.Track_Id,
                              i_Employee_Id => r.Person_Id);
      
        Htt_Core.Track_Add(i_Company_Id     => r.Company_Id,
                           i_Filial_Id      => r.Filial_Id,
                           i_Track_Id       => r.Track_Id,
                           i_Employee_Id    => r.Person_Id,
                           i_Track_Datetime => r.Track_Datetime,
                           i_Track_Type     => r.Track_Type,
                           i_Trans_Input    => r.Trans_Input,
                           i_Trans_Output   => r.Trans_Output,
                           i_Trans_Check    => r.Trans_Check);
      
        Dbms_Application_Info.Set_Module('tracks add',
                                         'inserted ' || r.Rownum || ' Track(s) out of ' ||
                                         v_Track_Cnt || ' for ' || Emp.Rownum || ' emp out of ' ||
                                         v_Emp_Cnt);
      end loop;
    
      Dbms_Application_Info.Set_Module('tracks add',
                                       'inserted all Track(s) for ' || Emp.Rownum || ' emp out of ' ||
                                       v_Emp_Cnt);
    
      Biruni_Route.Context_End;
    
      commit;
    end loop;
  
    Hr5_Migr_Util.Clear;
  end;

end Hr5_Migr_Hrt;
/
