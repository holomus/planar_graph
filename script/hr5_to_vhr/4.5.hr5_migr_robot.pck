create or replace package Hr5_Migr_Robot is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Ref_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Journals(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_First_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timeoff_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Business_Trip_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staf_Refresh_Cache(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Try_Robot_Close(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Registry_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timebook_Adjustment_Journals(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timebook_Adjustment_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Users_For_Employees(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Robot;
/
create or replace package body Hr5_Migr_Robot is
  ----------------------------------------------------------------------------------------------------
  -- default schedule and default sick leave reason
  Procedure Create_Default_Data is
    v_Id number;
  begin
    Dbms_Application_Info.Set_Module('Create_Default_Data', 'started Create_Default_Data');
  
    -- default schedule
    begin
      select q.Schedule_Id
        into v_Id
        from Htt_Schedules q
       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and Rownum = 1;
    
    exception
      when No_Data_Found then
        v_Id := Htt_Next.Schedule_Id;
      
        z_Htt_Schedules.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Schedule_Id       => v_Id,
                                   i_Name              => 'График работы по умолчанию',
                                   i_Schedule_Kind     => Htt_Pref.c_Schedule_Kind_Custom,
                                   i_Shift             => 0,
                                   i_Input_Acceptance  => 0,
                                   i_Output_Acceptance => 0,
                                   i_Track_Duration    => 1440,
                                   i_Count_Late        => 'Y',
                                   i_Count_Early       => 'Y',
                                   i_Count_Lack        => 'Y',
                                   i_Calendar_Id       => null,
                                   i_Take_Holidays     => 'Y',
                                   i_Take_Nonworking   => 'Y',
                                   i_State             => 'A',
                                   i_Code              => null,
                                   i_Barcode           => null,
                                   i_Pcode             => null);
      
        z_Htt_Schedule_Patterns.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Schedule_Id    => v_Id,
                                           i_Schedule_Kind  => Htt_Pref.c_Pattern_Kind_Weekly,
                                           i_All_Days_Equal => 'Y',
                                           i_Count_Days     => 7);
      
        for i in 1 .. 5
        loop
          z_Htt_Schedule_Pattern_Days.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Filial_Id        => Hr5_Migr_Pref.g_Filial_Id,
                                                 i_Schedule_Id      => v_Id,
                                                 i_Day_No           => i,
                                                 i_Day_Kind         => Htt_Pref.c_Day_Kind_Work,
                                                 i_Plan_Time        => 480,
                                                 i_Begin_Time       => 540,
                                                 i_End_Time         => 1080,
                                                 i_Break_Enabled    => 'Y',
                                                 i_Break_Begin_Time => 780,
                                                 i_Break_End_Time   => 840);
        end loop;
      
        for i in 6 .. 7
        loop
          z_Htt_Schedule_Pattern_Days.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Filial_Id        => Hr5_Migr_Pref.g_Filial_Id,
                                                 i_Schedule_Id      => v_Id,
                                                 i_Day_No           => i,
                                                 i_Day_Kind         => Htt_Pref.c_Day_Kind_Rest,
                                                 i_Plan_Time        => 0,
                                                 i_Begin_Time       => 0,
                                                 i_End_Time         => 0,
                                                 i_Break_Enabled    => 'Y',
                                                 i_Break_Begin_Time => 0,
                                                 i_Break_End_Time   => 0);
        end loop;
      
        commit;
    end;
  
    -- default sick_leave_reason
    begin
      select q.Reason_Id
        into v_Id
        from Href_Sick_Leave_Reasons q
       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Id := Href_Next.Sick_Leave_Reason_Id;
      
        z_Href_Sick_Leave_Reasons.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                             i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                             i_Reason_Id   => v_Id,
                                             i_Name        => 'Причина ухода на больничный по умолчанию',
                                             i_Coefficient => 0,
                                             i_State       => 'A',
                                             i_Code        => null);
    end;
  
    -- default wage scale
    begin
      select q.Wage_Scale_Id
        into v_Id
        from Hrm_Wage_Scales q
       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Id := Hrm_Next.Wage_Scale_Id;
      
        z_Hrm_Wage_Scales.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                     i_Wage_Scale_Id     => v_Id,
                                     i_Name              => 'Тарифная группа по умолчанию',
                                     i_Full_Name         => 'Тарифная группа по умолчанию',
                                     i_State             => 'A',
                                     i_Last_Changed_Date => null);
    end;
  
    Dbms_Application_Info.Set_Module('Create_Default_Data', 'finished Create_Default_Data');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hrm_Settings is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
  
    r_Setting.Position_Enable        := 'Y';
    r_Setting.Advanced_Org_Structure := 'Y';
  
    Hrm_Api.Setting_Save(r_Setting);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Robots is
    v_Total         number;
    v_Id            number;
    v_Division_Id   number;
    v_Org_Unit_Id   number;
    v_Job_Id        number;
    v_Rank_Id       number;
    v_Wage_Scale_Id number;
    v_Name          Mrf_Robots.Name%type;
  begin
    Dbms_Application_Info.Set_Module('Migr_Robots', 'started Migr_Robots');
  
    -- wage scale id
    select q.Wage_Scale_Id
      into v_Wage_Scale_Id
      from Hrm_Wage_Scales q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and Rownum = 1;
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Robots q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
               and Uk.Old_Id = q.Robot_Id)
       and q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id;
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Robots q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
                         and Uk.Old_Id = q.Robot_Id)
                 and q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id)
    loop
      Dbms_Application_Info.Set_Module('Migr_Robots',
                                       'inserted ' || (r.Rownum - 1) || ' Robot(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mrf_Next.Robot_Id;
      
        v_Division_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                                  i_Old_Id     => r.Department_Id,
                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        v_Org_Unit_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Group,
                                                  i_Old_Id     => r.Group_Id,
                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        v_Job_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                             i_Key_Name   => Hr5_Migr_Pref.c_Ref_Post,
                                             i_Old_Id     => r.Post_Id,
                                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        /*v_Rank_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
        i_Key_Name   => Hr5_Migr_Pref.c_Ref_Rank,
        i_Old_Id     => r.Rank_Id,
        i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);*/
      
        v_Name := z_Mhr_Jobs.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                  i_Filial_Id => Hr5_Migr_Pref.g_Filial_Id, --
                  i_Job_Id => v_Job_Id).Name
                  -- rank and its name removed
                  -- || ', ' || --
                  /*z_Mhr_Ranks.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, -- i_Filial_Id => Hr5_Migr_Pref.g_Filial_Id, -- i_Rank_Id => v_Rank_Id).Name*/ --
                  || '/' ||
                  --
                  z_Mhr_Divisions.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                  i_Filial_Id => Hr5_Migr_Pref.g_Filial_Id, --
                  i_Division_Id => v_Division_Id).Name
                  --
                  || '/(' || v_Id || ')';
      
        z_Mrf_Robots.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                i_Robot_Id       => v_Id,
                                i_Name           => v_Name,
                                i_Code           => r.Code,
                                i_Person_Id      => null,
                                i_Robot_Group_Id => null,
                                i_Division_Id    => v_Division_Id,
                                i_Job_Id         => v_Job_Id,
                                i_Manager_Id     => null,
                                i_State          => r.State);
      
        z_Hrm_Robots.Insert_One(i_Company_Id           => Hr5_Migr_Pref.g_Company_Id,
                                i_Filial_Id            => Hr5_Migr_Pref.g_Filial_Id,
                                i_Robot_Id             => v_Id,
                                i_Org_Unit_Id          => Nvl(v_Org_Unit_Id, v_Division_Id),
                                i_Opened_Date          => r.Date_Begin,
                                i_Closed_Date          => null,
                                i_Schedule_Id          => null,
                                i_Rank_Id              => v_Rank_Id,
                                i_Labor_Function_Id    => null,
                                i_Description          => null,
                                i_Hiring_Condition     => null,
                                i_Contractual_Wage     => 'N',
                                i_Wage_Scale_Id        => v_Wage_Scale_Id,
                                i_Access_Hidden_Salary => 'N');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Robot,
                                i_Old_Id     => r.Robot_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Robots',
                                 i_Key_Id        => r.Robot_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Robots', 'finished Migr_Robots');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Division_Managers is
    v_Total number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Division_Managers', 'started Migr_Division_Managers');
  
    -- total count
    select count(*)
      into v_Total
      from (select q.*,
                   (select St.New_Id
                      from Hr5_Migr_Keys_Store_Two St
                     where St.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and St.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                       and St.Old_Id = q.Department_Id
                       and St.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as New_Division_Id,
                   (select St.New_Id
                      from Hr5_Migr_Keys_Store_Two St
                     where St.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and St.Key_Name = Hr5_Migr_Pref.c_Robot
                       and St.Old_Id = q.Robot_Id
                       and St.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as New_Robot_Id
              from Hr5_Hr_Robot_Dept_Responsibles q
             where exists (select 1
                      from Hr5_Migr_Used_Keys Uk
                     where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                       and Uk.Old_Id = q.Department_Id)
               and exists (select 1
                      from Hr5_Migr_Used_Keys Uk
                     where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
                       and Uk.Old_Id = q.Robot_Id)) q
     where not exists (select 1
              from Mrf_Division_Managers Dm
             where Dm.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Dm.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Dm.Division_Id = q.New_Division_Id
               and Dm.Manager_Id = q.New_Robot_Id);
  
    for r in (select q.*, Rownum
                from (select q.*,
                             (select St.New_Id
                                from Hr5_Migr_Keys_Store_Two St
                               where St.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and St.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                                 and St.Old_Id = q.Department_Id
                                 and St.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as New_Division_Id,
                             (select St.New_Id
                                from Hr5_Migr_Keys_Store_Two St
                               where St.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and St.Key_Name = Hr5_Migr_Pref.c_Robot
                                 and St.Old_Id = q.Robot_Id
                                 and St.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as New_Robot_Id
                        from Hr5_Hr_Robot_Dept_Responsibles q
                       where exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                                 and Uk.Old_Id = q.Department_Id)
                         and exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
                                 and Uk.Old_Id = q.Robot_Id)) q
               where not exists (select 1
                        from Mrf_Division_Managers Dm
                       where Dm.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Dm.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Dm.Division_Id = q.New_Division_Id
                         and Dm.Manager_Id = q.New_Robot_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Division_Managers',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Division Manager(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        z_Mrf_Division_Managers.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Division_Id => r.New_Division_Id,
                                           i_Manager_Id  => r.New_Robot_Id);
      
        Hrm_Api.Division_Manager_Save(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                      i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                      i_Division_Id => r.New_Division_Id,
                                      i_Robot_Id    => r.New_Robot_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Robot_Dept_Responsibles',
                                 i_Key_Id        => r.Department_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' robot_id=' || r.Robot_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Division_Managers', 'finished Migr_Division_Managers');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Open_Robot_Trans is
    v_Total number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Open_Robot_Trans', 'started Migr_Open_Robot_Trans');
  
    select count(*)
      into v_Total
      from Hr5_Hr_Robots q
      join Hr5_Migr_Keys_Store_Two Ks
        on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
       and Ks.Old_Id = q.Robot_Id
       and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and not exists (select 1
              from Hrm_Robot_Transactions Rt
             where Rt.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Rt.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Rt.Robot_Id = Ks.New_Id);
  
    for r in (select q.*, Ks.New_Id as New_Robot_Id, Rownum
                from Hr5_Hr_Robots q
                join Hr5_Migr_Keys_Store_Two Ks
                  on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
                 and Ks.Old_Id = q.Robot_Id
                 and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                 and not exists (select 1
                        from Hrm_Robot_Transactions Rt
                       where Rt.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Rt.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Rt.Robot_Id = Ks.New_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Open_Robot_Trans',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Open Robot transaction(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        Hrm_Core.Robot_Open(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                            i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                            i_Robot_Id   => r.New_Robot_Id,
                            i_Open_Date  => r.Date_Begin);
      
        Hrm_Core.Dirty_Robots_Revise(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hrm_Robot_Transactions_Open',
                                 i_Key_Id        => r.Robot_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' new_robot_id=' || r.New_Robot_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Open_Robot_Trans', 'finished Migr_Open_Robot_Trans');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Refill_Schedule_Registry_Data is
  begin
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'started Refill_Schedule_Registry_Data');
  
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data', 'deleting old data');
  
    delete from Hr5_Migr_Hr_Timesheets_Src;
    delete from Hr5_Migr_Hr_Timesheets_Src2;
    delete from Hr5_Migr_Hr_Timesheets;
    delete from Hr5_Migr_Schreg_Robots_Src;
    delete from Hr5_Migr_Schreg_Departments_Src;
    delete from Hr5_Migr_Schreg_Departments;
  
    commit;
  
    -- hr5_migr_hr_timesheets_src
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Hr_Timesheets_Src datas');
  
    insert into Hr5_Migr_Hr_Timesheets_Src
      (Timesheet_Id, Robot_Id, Timesheet_Date, Plan_Hours)
      select w.Timesheet_Id, w.Robot_Id, w.Timesheet_Date, w.Plan_Hours
        from Hr5_Hr_Timesheets w
       where w.Timesheet_Date >= Hr5_Migr_Pref.g_Begin_Date;
  
    commit;
  
    -- hr5_migr_hr_timesheets_src2
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Hr_Timesheets_Src2 datas');
  
    insert into Hr5_Migr_Hr_Timesheets_Src2
      (Robot_Id,
       Timesheet_Date,
       Input_Time,
       Output_Time,
       Lunch_Begin,
       Lunch_End,
       Plan_Time,
       Day_Kind)
      select w.Robot_Id,
             w.Timesheet_Date,
             to_char(Tt_i.Action_Time, 'sssss') / 60 as Input_Time,
             to_char(Tt_o.Action_Time, 'sssss') / 60 as Output_Time,
             Nullif(to_char(Tt_Lb.Action_Time, 'sssss') / 60, 0) as Lunch_Begin,
             to_char(Tt_Le.Action_Time, 'sssss') / 60 as Lunch_End,
             w.Plan_Hours * 60 Plan_Time,
             case
                when Nvl(w.Plan_Hours, 0) > 0 then
                 'W'
                else
                 'R'
              end as Day_Kind
        from Hr5_Migr_Hr_Timesheets_Src w
        left join Hr5_Hr_Timesheet_Tracks Tt_i
          on Tt_i.Timesheet_Id = w.Timesheet_Id
         and Tt_i.Timesheet_Kind = 'P'
         and Tt_i.Action_Kind = 'I'
        left join Hr5_Hr_Timesheet_Tracks Tt_o
          on Tt_o.Timesheet_Id = w.Timesheet_Id
         and Tt_o.Timesheet_Kind = 'P'
         and Tt_o.Action_Kind = 'O'
        left join Hr5_Hr_Timesheet_Tracks Tt_Lb
          on Tt_Lb.Timesheet_Id = w.Timesheet_Id
         and Tt_Lb.Timesheet_Kind = 'P'
         and Tt_Lb.Action_Kind = 'LB'
        left join Hr5_Hr_Timesheet_Tracks Tt_Le
          on Tt_Le.Timesheet_Id = w.Timesheet_Id
         and Tt_Le.Timesheet_Kind = 'P'
         and Tt_Le.Action_Kind = 'LE';
  
    commit;
  
    -- hr5_migr_hr_timesheets
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Hr_Timesheets datas');
  
    insert into Hr5_Migr_Hr_Timesheets
      (Robot_Id,
       Timesheet_Date,
       Input_Time,
       Output_Time,
       Lunch_Begin,
       Lunch_End,
       Plan_Time,
       Day_Kind,
       Max_Output_Time,
       Max_Lunch_End,
       Full_Time)
      select q.Robot_Id,
             q.Timesheet_Date,
             q.Input_Time,
             q.Output_Time,
             q.Lunch_Begin,
             q.Lunch_End,
             case
                when q.Full_Time < q.Plan_Time then
                 q.Full_Time
                else
                 q.Plan_Time
              end as Plan_Time,
             q.Day_Kind,
             q.Max_Output_Time,
             q.Max_Lunch_End,
             q.Full_Time
        from (select q.Robot_Id,
                     q.Timesheet_Date,
                     q.Input_Time,
                     q.Output_Time,
                     q.Lunch_Begin,
                     q.Lunch_End,
                     q.Plan_Time,
                     q.Day_Kind,
                     q.Max_Output_Time,
                     q.Max_Lunch_End,
                     q.Max_Output_Time - q.Input_Time -
                     (Nvl(q.Max_Lunch_End, 0) - Nvl(q.Lunch_Begin, 0)) as Full_Time
                from (select q.Robot_Id,
                             q.Timesheet_Date,
                             q.Input_Time,
                             q.Output_Time,
                             q.Lunch_Begin,
                             q.Lunch_End,
                             q.Plan_Time,
                             q.Day_Kind,
                             q.Output_Time + case
                                when q.Output_Time <= q.Input_Time then
                                 1440
                                else
                                 0
                              end as Max_Output_Time,
                             q.Lunch_End + case
                                when q.Lunch_End < q.Lunch_Begin then
                                 1440
                                else
                                 0
                              end as Max_Lunch_End
                        from (select q.Robot_Id,
                                     q.Timesheet_Date,
                                     Coalesce(q.Input_Time,
                                              (select Ht.Input_Time
                                                 from Hr5_Migr_Hr_Timesheets_Src2 Ht
                                                where Ht.Robot_Id = q.Robot_Id
                                                  and Trunc(Ht.Timesheet_Date, 'mon') =
                                                      Trunc(q.Timesheet_Date, 'mon')
                                                  and Ht.Plan_Time = q.Plan_Time
                                                  and Ht.Day_Kind = q.Day_Kind
                                                  and Ht.Input_Time is not null
                                                fetch first row only),
                                              (select Ht.Input_Time
                                                 from Hr5_Migr_Hr_Timesheets_Src2 Ht
                                                where Ht.Robot_Id = q.Robot_Id
                                                  and Trunc(Ht.Timesheet_Date, 'mon') =
                                                      Trunc(q.Timesheet_Date, 'mon')
                                                  and Ht.Day_Kind = q.Day_Kind
                                                  and Ht.Input_Time is not null
                                                fetch first row only)) as Input_Time,
                                     Coalesce(q.Output_Time,
                                              (select Ht.Output_Time
                                                 from Hr5_Migr_Hr_Timesheets_Src2 Ht
                                                where Ht.Robot_Id = q.Robot_Id
                                                  and Trunc(Ht.Timesheet_Date, 'mon') =
                                                      Trunc(q.Timesheet_Date, 'mon')
                                                  and Ht.Plan_Time = q.Plan_Time
                                                  and Ht.Day_Kind = q.Day_Kind
                                                  and Ht.Output_Time is not null
                                                fetch first row only),
                                              (select Ht.Output_Time
                                                 from Hr5_Migr_Hr_Timesheets_Src2 Ht
                                                where Ht.Robot_Id = q.Robot_Id
                                                  and Trunc(Ht.Timesheet_Date, 'mon') =
                                                      Trunc(q.Timesheet_Date, 'mon')
                                                  and Ht.Day_Kind = q.Day_Kind
                                                  and Ht.Output_Time is not null
                                                fetch first row only)) as Output_Time,
                                     Nvl2(q.Lunch_Begin + q.Lunch_End, q.Lunch_Begin, null) as Lunch_Begin,
                                     Nvl2(q.Lunch_Begin + q.Lunch_End, q.Lunch_End, null) as Lunch_End,
                                     q.Plan_Time,
                                     q.Day_Kind
                                from Hr5_Migr_Hr_Timesheets_Src2 q) q
                       where q.Day_Kind = 'R'
                          or q.Input_Time is not null
                         and q.Output_Time is not null) q) q;
  
    commit;
  
    -- hr5_migr_schreg_robots_src
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Schreg_Robots_Src datas');
  
    insert into Hr5_Migr_Schreg_Robots_Src
      (Robot_Id, month, New_Robot_Id, Department_Id, Input_Time, Output_Time, Max_Output_Time)
      select q.Robot_Id,
             q.Month,
             (select Ks.New_Id
                from Hr5_Migr_Keys_Store_Two Ks
               where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
                 and Ks.Old_Id = q.Robot_Id) as New_Robot_Id,
             q.Department_Id,
             q.Input_Time,
             q.Max_Output_Time - case
                when q.Max_Output_Time >= 1440 then
                 1440
                else
                 0
              end as Output_Time,
             q.Max_Output_Time
        from (select q.Robot_Id,
                     q.Department_Id,
                     Trunc(Ht.Timesheet_Date, 'mon') as month,
                     min(Ht.Input_Time) as Input_Time,
                     max(Ht.Max_Output_Time) as Max_Output_Time
                from Hr5_Hr_Robots q
                join Hr5_Migr_Hr_Timesheets Ht
                  on q.Robot_Id = Ht.Robot_Id
               group by q.Robot_Id, q.Department_Id, Trunc(Ht.Timesheet_Date, 'mon')) q;
  
    commit;
  
    -- hr5_migr_schreg_departments_src
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Schreg_Departments_Src datas');
  
    insert into Hr5_Migr_Schreg_Departments_Src
      (Department_Id, month, Shift_One, Shift_Two)
      select t.Department_Id,
             t.Month,
             min(t.Input_Time) as Shift_One,
             max(case
                    when t.Max_Output_Time > 1440 then
                     t.Output_Time
                    else
                     null
                  end) as Shift_Two
        from Hr5_Migr_Schreg_Robots_Src t
       where t.Max_Output_Time - t.Input_Time <= 1440
       group by t.Department_Id, t.Month;
  
    commit;
  
    -- hr5_migr_schreg_departments
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'insert into Hr5_Migr_Schreg_Departments datas');
  
    insert into Hr5_Migr_Schreg_Departments
      (Department_Id, month, New_Division_Id, Shift_One, Shift_Two, Shift_Three)
      select q.Department_Id,
             q.Month,
             (select Ks.New_Id
                from Hr5_Migr_Keys_Store_Two Ks
               where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                 and Ks.Old_Id = q.Department_Id) as New_Division_Id,
             q.Shift_One,
             q.Shift_Two,
             min(t.Input_Time) as Shift_Three
        from Hr5_Migr_Schreg_Departments_Src q
        left join Hr5_Migr_Schreg_Robots_Src t
          on t.Max_Output_Time - t.Input_Time <= 1440
         and t.Department_Id = q.Department_Id
         and t.Month = q.Month
         and t.Input_Time < q.Shift_Two
         and t.Output_Time > q.Shift_One
         and t.Input_Time >= t.Output_Time
       group by q.Department_Id, q.Month, q.Shift_One, q.Shift_Two;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Refill_Schedule_Registry_Data',
                                     'finished Refill_Schedule_Registry_Data');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Robot_Schedule_Registries is
    v_Total    number;
    v_Id       number;
    v_Registry Htt_Pref.Schedule_Registry_Rt;
    v_Unit     Htt_Pref.Registry_Unit_Rt;
    v_Day      Htt_Pref.Schedule_Day_Rt;
    v_Key_Name Hr5_Migr_Used_Keys.Key_Name%type;
  begin
    Dbms_Application_Info.Set_Module('Migr_Robot_Schedule_Registries',
                                     'started Migr_Robot_Schedule_Registries');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Migr_Schreg_Departments q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                   to_char(q.Month, Href_Pref.c_Date_Format_Month)
               and Uk.Old_Id = q.Department_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Migr_Schreg_Departments q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                             to_char(q.Month, Href_Pref.c_Date_Format_Month)
                         and Uk.Old_Id = q.Department_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Robot_Schedule_Registries',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Schedule Registry(ies) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        v_Key_Name := Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                      to_char(r.Month, Href_Pref.c_Date_Format_Month);
      
        v_Id := Htt_Next.Registry_Id;
      
        Htt_Util.Schedule_Registry_New(o_Schedule_Registry => v_Registry,
                                       i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                       i_Registry_Id       => v_Id,
                                       i_Registry_Date     => r.Month,
                                       i_Registry_Number   => null,
                                       i_Registry_Kind     => Htt_Pref.c_Registry_Kind_Robot,
                                       i_Schedule_Kind     => Htt_Pref.c_Schedule_Kind_Flexible,
                                       i_Month             => r.Month,
                                       i_Division_Id       => r.New_Division_Id,
                                       i_Note              => case
                                                                when r.Shift_Two is not null then
                                                                 'part1'
                                                                else
                                                                 null
                                                              end,
                                       i_Shift             => null,
                                       i_Input_Acceptance  => null,
                                       i_Output_Acceptance => null,
                                       i_Track_Duration    => null,
                                       i_Count_Late        => 'Y',
                                       i_Count_Early       => 'Y',
                                       i_Count_Lack        => 'Y',
                                       i_Calendar_Id       => null, -- ignored in api
                                       i_Take_Holidays     => 'Y', -- ignored in api
                                       i_Take_Nonworking   => 'Y'); -- ignored in api
      
        for Robot in (select *
                        from Hr5_Migr_Schreg_Robots_Src q
                       where q.Department_Id = r.Department_Id
                         and q.Month = r.Month
                         and q.Max_Output_Time - q.Input_Time <= 1440
                         and q.Max_Output_Time <= r.Shift_One + 1440)
        loop
          Htt_Util.Registry_Unit_New(o_Registry_Unit   => v_Unit,
                                     i_Unit_Id         => Htt_Next.Unit_Id,
                                     i_Staff_Id        => null,
                                     i_Robot_Id        => Robot.New_Robot_Id,
                                     i_Monthly_Minutes => 0,
                                     i_Monthly_Days    => 0);
        
          for Item in (select *
                         from Hr5_Migr_Hr_Timesheets q
                        where q.Robot_Id = Robot.Robot_Id
                          and Trunc(q.Timesheet_Date, 'mon') = r.Month)
          loop
            Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                      i_Schedule_Date    => Item.Timesheet_Date,
                                      i_Day_Kind         => Item.Day_Kind,
                                      i_Begin_Time       => Item.Input_Time,
                                      i_End_Time         => Item.Output_Time,
                                      i_Break_Enabled    => 'N',
                                      i_Break_Begin_Time => Item.Lunch_Begin,
                                      i_Break_End_Time   => Item.Lunch_End,
                                      i_Plan_Time        => Item.Plan_Time);
          
            if Item.Lunch_Begin is not null and Item.Lunch_End is not null then
              v_Day.Break_Enabled := 'Y';
            end if;
          
            if v_Day.Day_Kind = 'W' then
              v_Unit.Monthly_Minutes := v_Unit.Monthly_Minutes + v_Day.Plan_Time;
              v_Unit.Monthly_Days    := v_Unit.Monthly_Days + 1;
            end if;
          
            v_Unit.Unit_Days.Extend();
            v_Unit.Unit_Days(v_Unit.Unit_Days.Count) := v_Day;
          end loop;
        
          continue when v_Unit.Unit_Days.Count = 0;
        
          v_Registry.Units.Extend();
          v_Registry.Units(v_Registry.Units.Count) := v_Unit;
        end loop;
      
        if v_Registry.Units.Count > 0 then
          Htt_Api.Schedule_Registry_Save(v_Registry);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => v_Key_Name,
                                  i_Old_Id     => r.Department_Id,
                                  i_New_Id     => v_Registry.Registry_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end if;
      
        if r.Shift_Two is not null then
          if v_Registry.Units.Count > 0 then
            v_Key_Name       := Hr5_Migr_Pref.c_Schedule_Registry_Part2 || ':' ||
                                to_char(r.Month, Href_Pref.c_Date_Format_Month);
            v_Registry.Shift := null;
            v_Registry.Units := Htt_Pref.Registry_Unit_Nt();
            v_Registry.Note  := 'part2';
          end if;
        
          for Robot in (select *
                          from Hr5_Migr_Schreg_Robots_Src q
                         where q.Department_Id = r.Department_Id
                           and q.Month = r.Month
                           and q.Max_Output_Time - q.Input_Time <= 1440
                           and q.Max_Output_Time > r.Shift_One + 1440
                           and q.Input_Time >= r.Shift_Two
                           and q.Output_Time <= r.Shift_Two)
          loop
            Htt_Util.Registry_Unit_New(o_Registry_Unit   => v_Unit,
                                       i_Unit_Id         => Htt_Next.Unit_Id,
                                       i_Staff_Id        => null,
                                       i_Robot_Id        => Robot.New_Robot_Id,
                                       i_Monthly_Minutes => 0,
                                       i_Monthly_Days    => 0);
          
            for Item in (select *
                           from Hr5_Migr_Hr_Timesheets q
                          where q.Robot_Id = Robot.Robot_Id
                            and Trunc(q.Timesheet_Date, 'mon') = r.Month)
            loop
              Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                        i_Schedule_Date    => Item.Timesheet_Date,
                                        i_Day_Kind         => Item.Day_Kind,
                                        i_Begin_Time       => Item.Input_Time,
                                        i_End_Time         => Item.Output_Time,
                                        i_Break_Enabled    => 'N',
                                        i_Break_Begin_Time => Item.Lunch_Begin,
                                        i_Break_End_Time   => Item.Lunch_End,
                                        i_Plan_Time        => Item.Plan_Time);
            
              if Item.Lunch_Begin is not null and Item.Lunch_End is not null then
                v_Day.Break_Enabled := 'Y';
              end if;
            
              if v_Day.Day_Kind = 'W' then
                v_Unit.Monthly_Minutes := v_Unit.Monthly_Minutes + v_Day.Plan_Time;
                v_Unit.Monthly_Days    := v_Unit.Monthly_Days + 1;
              end if;
            
              v_Unit.Unit_Days.Extend();
              v_Unit.Unit_Days(v_Unit.Unit_Days.Count) := v_Day;
            end loop;
          
            continue when v_Unit.Unit_Days.Count = 0;
          
            v_Registry.Units.Extend();
            v_Registry.Units(v_Registry.Units.Count) := v_Unit;
          end loop;
        
          if v_Registry.Units.Count > 0 then
            v_Registry.Registry_Id := Htt_Next.Registry_Id;
            Htt_Api.Schedule_Registry_Save(v_Registry);
          
            Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                    i_Key_Name   => v_Key_Name,
                                    i_Old_Id     => r.Department_Id,
                                    i_New_Id     => v_Registry.Registry_Id,
                                    i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
          end if;
        
          if r.Shift_Three is not null then
            if v_Registry.Units.Count > 0 then
              v_Key_Name       := Hr5_Migr_Pref.c_Schedule_Registry_Part3 || ':' ||
                                  to_char(r.Month, Href_Pref.c_Date_Format_Month);
              v_Registry.Shift := null;
              v_Registry.Units := Htt_Pref.Registry_Unit_Nt();
              v_Registry.Note  := 'part3';
            end if;
          
            for Robot in (select *
                            from Hr5_Migr_Schreg_Robots_Src q
                           where q.Department_Id = r.Department_Id
                             and q.Month = r.Month
                             and q.Max_Output_Time - q.Input_Time <= 1440
                             and q.Max_Output_Time > r.Shift_One + 1440
                             and q.Input_Time < r.Shift_Two)
            loop
              Htt_Util.Registry_Unit_New(o_Registry_Unit   => v_Unit,
                                         i_Unit_Id         => Htt_Next.Unit_Id,
                                         i_Staff_Id        => null,
                                         i_Robot_Id        => Robot.New_Robot_Id,
                                         i_Monthly_Minutes => 0,
                                         i_Monthly_Days    => 0);
            
              for Item in (select *
                             from Hr5_Migr_Hr_Timesheets q
                            where q.Robot_Id = Robot.Robot_Id
                              and Trunc(q.Timesheet_Date, 'mon') = r.Month)
              loop
                Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                          i_Schedule_Date    => Item.Timesheet_Date,
                                          i_Day_Kind         => Item.Day_Kind,
                                          i_Begin_Time       => Item.Input_Time,
                                          i_End_Time         => Item.Output_Time,
                                          i_Break_Enabled    => 'N',
                                          i_Break_Begin_Time => Item.Lunch_Begin,
                                          i_Break_End_Time   => Item.Lunch_End,
                                          i_Plan_Time        => Item.Plan_Time);
              
                if Item.Lunch_Begin is not null and Item.Lunch_End is not null then
                  v_Day.Break_Enabled := 'Y';
                end if;
              
                if v_Day.Day_Kind = 'W' then
                  v_Unit.Monthly_Minutes := v_Unit.Monthly_Minutes + v_Day.Plan_Time;
                  v_Unit.Monthly_Days    := v_Unit.Monthly_Days + 1;
                end if;
              
                v_Unit.Unit_Days.Extend();
                v_Unit.Unit_Days(v_Unit.Unit_Days.Count) := v_Day;
              end loop;
            
              continue when v_Unit.Unit_Days.Count = 0;
            
              v_Registry.Units.Extend();
              v_Registry.Units(v_Registry.Units.Count) := v_Unit;
            end loop;
          
            if v_Registry.Units.Count > 0 then
              v_Registry.Registry_Id := Htt_Next.Registry_Id;
              Htt_Api.Schedule_Registry_Save(v_Registry);
            
              Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                      i_Key_Name   => v_Key_Name,
                                      i_Old_Id     => r.Department_Id,
                                      i_New_Id     => v_Registry.Registry_Id,
                                      i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
            end if;
          end if;
        end if;
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Htt_Schedule_Registries' || ':' ||
                                                    to_char(r.Month, Href_Pref.c_Date_Format_Month),
                                 i_Key_Id        => r.Department_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Robot_Schedule_Registries',
                                     'finished Migr_Robot_Schedule_Registries');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Ref_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Create_Default_Data;
    Save_Hrm_Settings;
    Migr_Robots;
    Migr_Division_Managers;
    Migr_Open_Robot_Trans;
  
    Refill_Schedule_Registry_Data;
    Migr_Robot_Schedule_Registries;
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Initial_Journals is
    v_Total number;
    v_Id    number;
  
    v_Fte_Id        number;
    v_Schedule_Id   number;
    v_Wage_Scale_Id number;
  
    v_Robot_Id    number;
    v_Employee_Id number;
    v_Rank_Id     number;
    v_Staff_Id    number;
    v_Page_Id     number;
  
    v_Error_Staff_Id  number := -1;
    v_Curent_Staff_Id number := -1;
  
    v_Hiring_Jt_Id   number;
    v_Transfer_Jt_Id number;
  
    v_Robot            Hpd_Pref.Robot_Rt;
    v_Hiring_Journal   Hpd_Pref.Hiring_Journal_Rt;
    v_Transfer_Journal Hpd_Pref.Transfer_Journal_Rt;
  
    v_Staff_Number Href_Staffs.Staff_Number%type;
  
    r_Robot Mrf_Robots%rowtype;
  
    --------------------------------------------------
    Function Closest_Unemployed
    (
      i_Staff_Id number,
      i_Period   date
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Hr5_Hr_Robot_Assignments m
       where m.Staff_Id = i_Staff_Id
         and m.State = 'U'
         and m.Date_End = (select max(m.Date_End)
                             from Hr5_Hr_Robot_Assignments m
                            where m.Staff_Id = i_Staff_Id
                              and m.Date_End < i_Period);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------
    Function Before_Exists(i_Assignment_Id number) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Hr5_Hr_Movements m
       where m.To_Assignment_Id = i_Assignment_Id;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------
    Function Staff_Number_Exists(i_Staff_Number Href_Staffs.Staff_Number%type) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Href_Staffs s
       where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and Lower(s.Staff_Number) = Lower(i_Staff_Number);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------
    Function Unemployed_Robot_Creatable
    (
      i_Staff_Id number,
      i_Robot_Id number,
      i_Date_End date
    ) return boolean is
      v_Last_Date date;
      v_Dummy     varchar2(1);
    begin
      begin
        select a.Date_Begin
          into v_Last_Date
          from Hr5_Hr_Robot_Assignments a
         where a.Staff_Id = i_Staff_Id
           and a.Date_Begin = (select min(a.Date_Begin)
                                 from Hr5_Hr_Robot_Assignments a
                                where a.Staff_Id = i_Staff_Id
                                  and a.Date_Begin > i_Date_End);
      exception
        when No_Data_Found then
          v_Last_Date := Href_Pref.c_Max_Date;
      end;
    
      select 'X'
        into v_Dummy
        from Hr5_Hr_Robot_Assignments a
       where a.Robot_Id = i_Robot_Id
         and a.Date_Begin between i_Date_End and v_Last_Date
         and a.Staff_Id <> i_Staff_Id
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        begin
          select 'X'
            into v_Dummy
            from Hr5_Hr_Robots r
           where r.Robot_Id = i_Robot_Id
             and r.Date_End is not null;
        
          return true;
        exception
          when No_Data_Found then
            return false;
        end;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Initial_Journals', 'started Migr_Initial_Journals');
  
    -- wage scale id
    select q.Wage_Scale_Id
      into v_Wage_Scale_Id
      from Hrm_Wage_Scales q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and Rownum = 1;
  
    v_Hiring_Jt_Id   := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    v_Transfer_Jt_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    v_Fte_Id         := Href_Util.Fte_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
  
    -- schedule id
    /*select q.Schedule_Id
     into v_Schedule_Id
     from Htt_Schedules q
    where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
      and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
      and Rownum = 1;*/
  
    v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                          i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
  
    if v_Schedule_Id is null then
      b.Raise_Error('Hr5_Migr_Robot.Migr_Initial_Journals: set schedule id');
    end if;
  
    select count(*)
      into v_Total
      from Hr5_Hr_Robot_Assignments q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
               and Uk.Old_Id = q.Assignment_Id);
  
    for r in (select q.*, Rownum
                from (select q.*,
                             (select s.Staff_Number
                                from Hr5_Hr_Staffs s
                               where s.Staff_Id = q.Staff_Id) as Staff_Number
                        from Hr5_Hr_Robot_Assignments q
                       where not exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                                 and Uk.Old_Id = q.Assignment_Id)
                       order by q.Staff_Id, q.Date_Begin) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Journals',
                                       'inserted ' || (r.Rownum - 1) || ' Journal(s) out of ' ||
                                       v_Total);
    
      if v_Error_Staff_Id = r.Staff_Id then
        continue;
      end if;
    
      if v_Curent_Staff_Id <> r.Staff_Id then
        commit;
      
        savepoint Try_Catch;
      
        v_Curent_Staff_Id := r.Staff_Id;
      end if;
    
      begin
        Biruni_Route.Context_Begin;
      
        v_Robot_Id    := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Robot,
                                                  i_Old_Id     => r.Robot_Id,
                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        v_Employee_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                  i_Old_Id     => r.Staff_Id);
        v_Id          := Hpd_Next.Journal_Id;
        v_Page_Id     := Hpd_Next.Page_Id;
      
        r_Robot := z_Mrf_Robots.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                     i_Robot_Id   => v_Robot_Id);
      
        begin
          select Rr.Rank_Id
            into v_Rank_Id
            from Hr5_Hr_Register_Ranks Rr
           where Rr.Robot_Id = r.Robot_Id
             and Rr.Changed_Date = (select max(Rr1.Changed_Date)
                                      from Hr5_Hr_Register_Ranks Rr1
                                     where Rr1.Robot_Id = r.Robot_Id
                                       and Rr1.Changed_Date <= r.Date_Begin);
        
          v_Rank_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Rank,
                                                i_Old_Id     => v_Rank_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        exception
          when No_Data_Found then
            v_Rank_Id := z_Hrm_Robots.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                         i_Filial_Id => Hr5_Migr_Pref.g_Filial_Id, --
                         i_Robot_Id => v_Robot_Id).Rank_Id;
        end;
      
        Hpd_Util.Robot_New(o_Robot           => v_Robot,
                           i_Robot_Id        => v_Robot_Id,
                           i_Division_Id     => r_Robot.Division_Id,
                           i_Job_Id          => r_Robot.Job_Id,
                           i_Rank_Id         => v_Rank_Id,
                           i_Wage_Scale_Id   => null,
                           i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                           i_Fte_Id          => v_Fte_Id,
                           i_Fte             => 1);
      
        if Closest_Unemployed(i_Staff_Id => r.Staff_Id, i_Period => r.Date_Begin) or
           r.State <> 'A' and Before_Exists(r.Assignment_Id) then
          -- transfer
          begin
            select s.Staff_Id
              into v_Staff_Id
              from Href_Staffs s
             where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and s.Employee_Id = v_Employee_Id
               and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and s.Hiring_Date <= r.Date_Begin
             order by s.Hiring_Date desc
             fetch first row only;
          exception
            when No_Data_Found then
              b.Raise_Error('staff id not found, assignment_id=$1, employee_id=$2, date=$3',
                            r.Assignment_Id,
                            v_Employee_Id,
                            r.Date_Begin);
          end;
        
          Hpd_Util.Transfer_Journal_New(o_Journal         => v_Transfer_Journal,
                                        i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                        i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                        i_Journal_Id      => v_Id,
                                        i_Journal_Type_Id => v_Transfer_Jt_Id,
                                        i_Journal_Number  => null,
                                        i_Journal_Date    => r.Date_Begin,
                                        i_Journal_Name    => r.Based_On_Doc);
        
          Hpd_Util.Journal_Add_Transfer(p_Journal             => v_Transfer_Journal,
                                        i_Page_Id             => v_Page_Id,
                                        i_Transfer_Begin      => r.Date_Begin,
                                        i_Transfer_End        => null,
                                        i_Staff_Id            => v_Staff_Id,
                                        i_Schedule_Id         => null,
                                        i_Vacation_Days_Limit => null,
                                        i_Transfer_Reason     => null,
                                        i_Transfer_Base       => null,
                                        i_Robot               => v_Robot,
                                        i_Contract            => null,
                                        i_Indicators          => Href_Pref.Indicator_Nt(),
                                        i_Oper_Types          => Href_Pref.Oper_Type_Nt());
        
          Hpd_Api.Transfer_Journal_Save(v_Transfer_Journal);
        else
          -- hiring
          Hpd_Util.Hiring_Journal_New(o_Journal         => v_Hiring_Journal,
                                      i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                      i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                      i_Journal_Id      => v_Id,
                                      i_Journal_Type_Id => v_Hiring_Jt_Id,
                                      i_Journal_Number  => null,
                                      i_Journal_Date    => r.Date_Begin,
                                      i_Journal_Name    => r.Based_On_Doc);
        
          v_Staff_Number := r.Staff_Number;
        
          if Staff_Number_Exists(r.Staff_Number) then
            v_Staff_Number := v_Staff_Number || '(' || v_Page_Id || ')';
          end if;
        
          Hpd_Util.Journal_Add_Hiring(p_Journal              => v_Hiring_Journal,
                                      i_Page_Id              => v_Page_Id,
                                      i_Employee_Id          => v_Employee_Id,
                                      i_Staff_Number         => v_Staff_Number,
                                      i_Hiring_Date          => r.Date_Begin,
                                      i_Trial_Period         => 0,
                                      i_Employment_Source_Id => null,
                                      i_Schedule_Id          => v_Schedule_Id,
                                      i_Vacation_Days_Limit  => null,
                                      i_Robot                => v_Robot,
                                      i_Contract             => null,
                                      i_Indicators           => Href_Pref.Indicator_Nt(),
                                      i_Oper_Types           => Href_Pref.Oper_Type_Nt());
        
          Hpd_Api.Hiring_Journal_Save(v_Hiring_Journal);
        
          select p.Staff_Id
            into v_Staff_Id
            from Hpd_Journal_Pages p
           where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
             and p.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
             and p.Page_Id = v_Page_Id;
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Robot_Assignment,
                                i_Old_Id     => r.Assignment_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Staff_Id := r.Staff_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Robot_Assignments',
                                 i_Key_Id        => r.Assignment_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' error_staff_id=' || v_Error_Staff_Id);
      end;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Initial_Journals', 'finished Migr_Initial_Journals');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Initial_Dis_Unemp_Journals is
    v_Total number;
    v_Id    number;
  
    v_Fte_Id        number;
    v_Schedule_Id   number;
    v_Wage_Scale_Id number;
  
    v_Robot_Id    number;
    v_Employee_Id number;
    v_Rank_Id     number;
    v_Staff_Id    number;
    v_Page_Id     number;
  
    v_Error_Staff_Id  number := -1;
    v_Curent_Staff_Id number := -1;
  
    v_Transfer_Jt_Id  number;
    v_Dismissal_Jt_Id number;
  
    v_Robot             Hpd_Pref.Robot_Rt;
    v_Transfer_Journal  Hpd_Pref.Transfer_Journal_Rt;
    v_Dismissal_Journal Hpd_Pref.Dismissal_Journal_Rt;
  
    r_Robot     Mrf_Robots%rowtype;
    r_Hrm_Robot Hrm_Robots%rowtype;
  
    --------------------------------------------------
    Function Unemployed_Robot_Creatable
    (
      i_Staff_Id number,
      i_Robot_Id number,
      i_Date_End date
    ) return boolean is
      v_Last_Date date;
      v_Dummy     varchar2(1);
    begin
      begin
        select a.Date_Begin
          into v_Last_Date
          from Hr5_Hr_Robot_Assignments a
         where a.Staff_Id = i_Staff_Id
           and a.Date_Begin = (select min(a.Date_Begin)
                                 from Hr5_Hr_Robot_Assignments a
                                where a.Staff_Id = i_Staff_Id
                                  and a.Date_Begin > i_Date_End);
      exception
        when No_Data_Found then
          v_Last_Date := Href_Pref.c_Max_Date;
      end;
    
      select 'X'
        into v_Dummy
        from Hr5_Hr_Robot_Assignments a
       where a.Robot_Id = i_Robot_Id
         and a.Date_Begin between i_Date_End and v_Last_Date
         and a.Staff_Id <> i_Staff_Id
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        begin
          select 'X'
            into v_Dummy
            from Hr5_Hr_Robots r
           where r.Robot_Id = i_Robot_Id
             and r.Date_End is not null;
        
          return true;
        exception
          when No_Data_Found then
            return false;
        end;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Initial_Dis_Unemp_Journals',
                                     'started Migr_Initial_Dis_Unemp_Journals');
  
    -- wage scale id
    select q.Wage_Scale_Id
      into v_Wage_Scale_Id
      from Hrm_Wage_Scales q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and Rownum = 1;
  
    v_Transfer_Jt_Id  := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    v_Dismissal_Jt_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
  
    -- schedule id
    /*select q.Schedule_Id
     into v_Schedule_Id
     from Htt_Schedules q
    where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
      and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
      and Rownum = 1;*/
  
    v_Schedule_Id := Htt_Util.Schedule_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                          i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
  
    if v_Schedule_Id is null then
      b.Raise_Error('Hr5_Migr_Robot.Migr_Initial_Dis_Unemp_Journals: set schedule id');
    end if;
  
    select count(*)
      into v_Total
      from Hr5_Hr_Robot_Assignments q
     where exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
               and Uk.Old_Id = q.Assignment_Id)
       and (q.State = 'D' and not exists
            (select 1
               from Hr5_Migr_Used_Keys Uk
              where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment_Dismissal
                and Uk.Old_Id = q.Assignment_Id) -- 
            or q.State = 'U' and not exists
            (select 1
               from Hr5_Migr_Used_Keys Uk
              where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                and Uk.Key_Name = Hr5_Migr_Pref.c_Unemployeed_Robot
                and Uk.Old_Id = q.Assignment_Id));
  
    for r in (select q.*, Rownum
                from (select q.*,
                             (select s.Staff_Number
                                from Hr5_Hr_Staffs s
                               where s.Staff_Id = q.Staff_Id) as Staff_Number
                        from Hr5_Hr_Robot_Assignments q
                       where exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                                 and Uk.Old_Id = q.Assignment_Id)
                         and (q.State = 'D' and not exists
                              (select 1
                                 from Hr5_Migr_Used_Keys Uk
                                where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                  and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment_Dismissal
                                  and Uk.Old_Id = q.Assignment_Id) --
                              or q.State = 'U' and not exists
                              (select 1
                                 from Hr5_Migr_Used_Keys Uk
                                where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                  and Uk.Key_Name = Hr5_Migr_Pref.c_Unemployeed_Robot
                                  and Uk.Old_Id = q.Assignment_Id))
                       order by q.Staff_Id, q.Date_Begin) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Dis_Unemp_Journals',
                                       'inserted ' || (r.Rownum - 1) || ' Journal(s) out of ' ||
                                       v_Total);
    
      if v_Error_Staff_Id = r.Staff_Id then
        continue;
      end if;
    
      if v_Curent_Staff_Id <> r.Staff_Id then
        commit;
      
        savepoint Try_Catch;
      
        v_Curent_Staff_Id := r.Staff_Id;
      end if;
    
      begin
        Biruni_Route.Context_Begin;
      
        v_Employee_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                  i_Old_Id     => r.Staff_Id);
      
        begin
          select s.Staff_Id
            into v_Staff_Id
            from Href_Staffs s
           where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
             and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
             and s.Employee_Id = v_Employee_Id
             and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
             and s.Hiring_Date <= r.Date_Begin
           order by s.Hiring_Date desc
           fetch first row only;
        exception
          when No_Data_Found then
            b.Raise_Error('Migr_Initial_Dis_Unemp_Journals: staff id not found, assignment_id=$1, employee_id=$2, date=$3',
                          r.Assignment_Id,
                          v_Employee_Id,
                          r.Date_Begin);
        end;
      
        if r.State = 'D' then
          -- dismissal
          v_Id := Hpd_Next.Journal_Id;
        
          Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Dismissal_Journal,
                                         i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Journal_Id      => v_Id,
                                         i_Journal_Type_Id => v_Dismissal_Jt_Id,
                                         i_Journal_Number  => null,
                                         i_Journal_Date    => r.Date_End,
                                         i_Journal_Name    => r.Note);
        
          Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Dismissal_Journal,
                                         i_Page_Id              => Hpd_Next.Page_Id,
                                         i_Staff_Id             => v_Staff_Id,
                                         i_Dismissal_Date       => r.Date_End,
                                         i_Dismissal_Reason_Id  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                            i_Key_Name   => Hr5_Migr_Pref.c_Ref_Reason,
                                                                                            i_Old_Id     => r.Reason_Id),
                                         i_Employment_Source_Id => null,
                                         i_Based_On_Doc         => null,
                                         i_Note                 => r.Note);
        
          Hpd_Api.Dismissal_Journal_Save(v_Dismissal_Journal);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Robot_Assignment_Dismissal,
                                  i_Old_Id     => r.Assignment_Id,
                                  i_New_Id     => v_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        elsif r.State = 'U' and
              Unemployed_Robot_Creatable(i_Staff_Id => r.Staff_Id,
                                         i_Robot_Id => r.Robot_Id,
                                         i_Date_End => r.Date_End) then
          -- creat new unemployeed robot
          v_Id := Mrf_Next.Robot_Id;
        
          v_Robot_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Key_Name   => Hr5_Migr_Pref.c_Robot,
                                                 i_Old_Id     => r.Robot_Id,
                                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          r_Robot := z_Mrf_Robots.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                       i_Robot_Id   => v_Robot_Id);
        
          r_Hrm_Robot := z_Hrm_Robots.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Robot_Id   => v_Robot_Id);
        
          begin
            select Rr.Rank_Id
              into v_Rank_Id
              from Hr5_Hr_Register_Ranks Rr
             where Rr.Robot_Id = r.Robot_Id
               and Rr.Changed_Date = (select max(Rr1.Changed_Date)
                                        from Hr5_Hr_Register_Ranks Rr1
                                       where Rr1.Robot_Id = r.Robot_Id
                                         and Rr1.Changed_Date <= r.Date_Begin);
          
            v_Rank_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Ref_Rank,
                                                  i_Old_Id     => v_Rank_Id,
                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
          exception
            when No_Data_Found then
              v_Rank_Id := r_Hrm_Robot.Rank_Id;
          end;
        
          z_Mrf_Robots.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                  i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                  i_Robot_Id       => v_Id,
                                  i_Name           => 'Безработный штат(' || v_Id || ')',
                                  i_Code           => null,
                                  i_Person_Id      => null,
                                  i_Robot_Group_Id => null,
                                  i_Division_Id    => r_Robot.Division_Id,
                                  i_Job_Id         => r_Robot.Job_Id,
                                  i_Manager_Id     => null,
                                  i_State          => 'P');
        
          z_Hrm_Robots.Insert_One(i_Company_Id           => Hr5_Migr_Pref.g_Company_Id,
                                  i_Filial_Id            => Hr5_Migr_Pref.g_Filial_Id,
                                  i_Robot_Id             => v_Id,
                                  i_Org_Unit_Id          => r_Hrm_Robot.Org_Unit_Id,
                                  i_Opened_Date          => r.Date_End + 1,
                                  i_Closed_Date          => null,
                                  i_Schedule_Id          => null,
                                  i_Rank_Id              => r_Hrm_Robot.Rank_Id,
                                  i_Labor_Function_Id    => null,
                                  i_Description          => null,
                                  i_Hiring_Condition     => null,
                                  i_Contractual_Wage     => 'N',
                                  i_Wage_Scale_Id        => v_Wage_Scale_Id,
                                  i_Access_Hidden_Salary => 'N');
        
          Hrm_Core.Robot_Open(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                              i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                              i_Robot_Id   => v_Id,
                              i_Open_Date  => r.Date_End + 1);
        
          Hrm_Core.Dirty_Robots_Revise(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          -- transfer to unemployed robot
          v_Robot_Id := v_Id;
          v_Id       := Hpd_Next.Journal_Id;
          v_Page_Id  := Hpd_Next.Page_Id;
        
          Hpd_Util.Robot_New(o_Robot           => v_Robot,
                             i_Robot_Id        => v_Robot_Id,
                             i_Division_Id     => r_Robot.Division_Id,
                             i_Job_Id          => r_Robot.Job_Id,
                             i_Rank_Id         => v_Rank_Id,
                             i_Wage_Scale_Id   => null,
                             i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                             i_Fte_Id          => v_Fte_Id,
                             i_Fte             => 1);
        
          Hpd_Util.Transfer_Journal_New(o_Journal         => v_Transfer_Journal,
                                        i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                        i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                        i_Journal_Id      => v_Id,
                                        i_Journal_Type_Id => v_Transfer_Jt_Id,
                                        i_Journal_Number  => null,
                                        i_Journal_Date    => r.Date_End,
                                        i_Journal_Name    => 'Unemployed robot');
        
          Hpd_Util.Journal_Add_Transfer(p_Journal             => v_Transfer_Journal,
                                        i_Page_Id             => v_Page_Id,
                                        i_Transfer_Begin      => r.Date_End + 1,
                                        i_Transfer_End        => null,
                                        i_Staff_Id            => v_Staff_Id,
                                        i_Schedule_Id         => null,
                                        i_Vacation_Days_Limit => null,
                                        i_Transfer_Reason     => null,
                                        i_Transfer_Base       => null,
                                        i_Robot               => v_Robot,
                                        i_Contract            => null,
                                        i_Indicators          => Href_Pref.Indicator_Nt(),
                                        i_Oper_Types          => Href_Pref.Oper_Type_Nt());
        
          Hpd_Api.Transfer_Journal_Save(v_Transfer_Journal);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Unemployeed_Robot,
                                  i_Old_Id     => r.Assignment_Id,
                                  i_New_Id     => v_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end if;
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Staff_Id := r.Staff_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Robot_Assignments Dis_Unemp_Journals',
                                 i_Key_Id        => r.Assignment_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' error_staff_id=' || v_Error_Staff_Id);
      end;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Initial_Dis_Unemp_Journals',
                                     'finished Migr_Initial_Dis_Unemp_Journals');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Rank_Change_Journals is
    v_Total             number;
    v_Journal_Id        number;
    v_Staff_Id          number;
    v_Rank_Change_Jt_Id number;
    v_Id                number;
  
    v_Rank_Change_Journal Hpd_Pref.Rank_Change_Journal_Rt;
  begin
    Dbms_Application_Info.Set_Module('Migr_Rank_Change_Journals',
                                     'started Migr_Rank_Change_Journals');
  
    v_Rank_Change_Jt_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
  
    -- total count
    -- ayrim(7404) rank change lar o'tmadi, chunki u paytda staff yo'q edi robotda
    -- shuningdek assignment date_begin date idagi rank changelar ham o'tmaydi
    select count(*)
      into v_Total
      from Hr5_Hr_Register_Ranks q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Rank_Change || ':' || q.Robot_Id || ':' ||
                   to_char(q.Changed_Date, 'yyyymmdd')
               and Uk.Old_Id = q.Rank_Id)
          /* and exists (select 1
                 from Hr5_Migr_Used_Keys Uk
                where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                  and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
                  and Uk.Old_Id = q.Robot_Id)
          and exists (select 1
                 from Hr5_Migr_Used_Keys Uk
                where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                  and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Rank
                  and Uk.Old_Id = q.Rank_Id)*/
       and exists (select 1
              from Hr5_Hr_Robot_Assignments Ra
             where Ra.Robot_Id = q.Robot_Id
               and q.Changed_Date > Ra.Date_Begin
               and q.Changed_Date <= Ra.Date_End_Nvl
               and exists (select 1
                      from Hr5_Migr_Used_Keys Uk
                     where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                       and Uk.Old_Id = Ra.Assignment_Id));
  
    Dbms_Application_Info.Set_Module('Migr_Rank_Change_Journals',
                                     'loop start Migr_Rank_Change_Journals');
  
    -- ayrim(7404) rank change lar o'tmadi, chunki u paytda staff yo'q edi robotda
    -- shuningdek assignment date_begin date idagi rank changelar ham o'tmaydi
    for r in (select q.*,
                     (select Ra.Assignment_Id
                        from Hr5_Hr_Robot_Assignments Ra
                       where Ra.Robot_Id = q.Robot_Id
                         and q.Changed_Date between Ra.Date_Begin and Ra.Date_End_Nvl) as Assignment_Id,
                     Rownum
                from Hr5_Hr_Register_Ranks q
               where not exists
               (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Rank_Change || ':' || q.Robot_Id || ':' ||
                             to_char(q.Changed_Date, 'yyyymmdd')
                         and Uk.Old_Id = q.Rank_Id)
                    /*and exists (select 1
                           from Hr5_Migr_Used_Keys Uk
                          where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                            and Uk.Key_Name = Hr5_Migr_Pref.c_Robot
                            and Uk.Old_Id = q.Robot_Id)
                    and exists (select 1
                           from Hr5_Migr_Used_Keys Uk
                          where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                            and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Rank
                            and Uk.Old_Id = q.Rank_Id)*/
                 and exists
               (select 1
                        from Hr5_Hr_Robot_Assignments Ra
                       where Ra.Robot_Id = q.Robot_Id
                         and q.Changed_Date > Ra.Date_Begin
                         and q.Changed_Date <= Ra.Date_End_Nvl
                         and exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                                 and Uk.Old_Id = Ra.Assignment_Id)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Rank_Change_Journals',
                                       'inserted ' || (r.Rownum - 1) || ' Robot Rank(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Journal_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Key_Name   => Hr5_Migr_Pref.c_Robot_Assignment,
                                                 i_Old_Id     => r.Assignment_Id,
                                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        select p.Staff_Id
          into v_Staff_Id
          from Hpd_Journal_Pages p
         where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
           and p.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
           and p.Journal_Id = v_Journal_Id;
      
        v_Id := Hpd_Next.Journal_Id;
      
        Hpd_Util.Rank_Change_Journal_New(o_Journal         => v_Rank_Change_Journal,
                                         i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Journal_Id      => v_Id,
                                         i_Journal_Number  => null,
                                         i_Journal_Date    => r.Changed_Date,
                                         i_Journal_Name    => null,
                                         i_Journal_Type_Id => v_Rank_Change_Jt_Id);
      
        Hpd_Util.Journal_Add_Rank_Change(p_Journal     => v_Rank_Change_Journal,
                                         i_Page_Id     => Hpd_Next.Page_Id,
                                         i_Staff_Id    => v_Staff_Id,
                                         i_Change_Date => r.Changed_Date,
                                         i_Rank_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Ref_Rank,
                                                                                   i_Old_Id     => r.Rank_Id,
                                                                                   i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id));
      
        Hpd_Api.Rank_Change_Journal_Save(v_Rank_Change_Journal);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Rank_Change || ':' || r.Robot_Id || ':' ||
                                                to_char(r.Changed_Date, 'yyyymmdd'),
                                i_Old_Id     => r.Rank_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Register_Ranks',
                                 i_Key_Id        => r.Rank_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' old_assignment_id=' || r.Assignment_Id ||
                                                    ' old_robot_id=' || r.Robot_Id ||
                                                    ' new_staff_id=' || v_Staff_Id ||
                                                    ' new_journal_id=' || v_Journal_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Rank_Change_Journals',
                                     'finished Migr_Rank_Change_Journals');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timeoff_Journals is
    v_Total          number;
    v_Reason_Id      number;
    v_Journal_Id     number;
    v_Timeoff_Id     number;
    v_Staff_Id       number;
    v_Id             number;
    v_Vacation_Tk_Id number;
  
    v_Shas Array_Varchar2;
  
    v_Sick_Leave_Journal Hpd_Pref.Sick_Leave_Journal_Rt;
    v_Vacation_Journal   Hpd_Pref.Vacation_Journal_Rt;
  begin
    Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals', 'started Migr_Timeoff_Journals');
  
    v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    select q.Reason_Id
      into v_Reason_Id
      from Href_Sick_Leave_Reasons q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and Rownum = 1;
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Leave_Docs q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Leave_Doc
               and Uk.Old_Id = q.Doc_Id)
       and exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
               and Uk.Old_Id = q.Assignment_Id)
       and q.Doc_Type <> 'F';
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Leave_Docs q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Leave_Doc
                         and Uk.Old_Id = q.Doc_Id)
                 and exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                         and Uk.Old_Id = q.Assignment_Id)
                 and q.Doc_Type <> 'F')
    loop
      Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals',
                                       'inserted ' || (r.Rownum - 1) || ' Timeoff(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Journal_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Key_Name   => Hr5_Migr_Pref.c_Robot_Assignment,
                                                 i_Old_Id     => r.Assignment_Id,
                                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        select p.Staff_Id
          into v_Staff_Id
          from Hpd_Journal_Pages p
         where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
           and p.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
           and p.Journal_Id = v_Journal_Id;
      
        v_Id         := Hpd_Next.Journal_Id;
        v_Timeoff_Id := Hpd_Next.Timeoff_Id;
      
        if r.Doc_Type = 'S' then
          -- sick leave
          select q.File_Sha
            bulk collect
            into v_Shas
            from Hr5_Hr_Doc_Files q
           where q.Doc_Id = r.Doc_Id
           order by q.Order_No;
        
          Hpd_Util.Sick_Leave_Journal_New(o_Journal        => v_Sick_Leave_Journal,
                                          i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                          i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                          i_Journal_Id     => v_Id,
                                          i_Journal_Number => null,
                                          i_Journal_Date   => r.Date_Begin,
                                          i_Journal_Name   => r.Name);
        
          Hpd_Util.Journal_Add_Sick_Leave(p_Journal           => v_Sick_Leave_Journal,
                                          i_Timeoff_Id        => v_Timeoff_Id,
                                          i_Staff_Id          => v_Staff_Id,
                                          i_Reason_Id         => v_Reason_Id,
                                          i_Coefficient       => r.Saved_Wage_Rate,
                                          i_Sick_Leave_Number => 'Sick leave Number(' || v_Id || ')',
                                          i_Begin_Date        => r.Date_Begin,
                                          i_End_Date          => r.Date_End,
                                          i_Shas              => v_Shas);
        
          Hpd_Api.Sick_Leave_Journal_Save(v_Sick_Leave_Journal);
        else
          -- vacation
          Hpd_Util.Vacation_Journal_New(o_Journal        => v_Vacation_Journal,
                                        i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                        i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                        i_Journal_Id     => v_Id,
                                        i_Journal_Number => null,
                                        i_Journal_Date   => r.Date_Begin,
                                        i_Journal_Name   => r.Name);
        
          Hpd_Util.Journal_Add_Vacation(p_Journal      => v_Vacation_Journal,
                                        i_Timeoff_Id   => v_Timeoff_Id,
                                        i_Staff_Id     => v_Staff_Id,
                                        i_Time_Kind_Id => v_Vacation_Tk_Id,
                                        i_Begin_Date   => r.Date_Begin,
                                        i_End_Date     => r.Date_End,
                                        i_Shas         => Array_Varchar2());
        
          Hpd_Api.Vacation_Journal_Save(v_Vacation_Journal);
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Leave_Doc,
                                i_Old_Id     => r.Doc_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Leave_Docs',
                                 i_Key_Id        => r.Doc_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' old_assisgnment_id=' || r.Assignment_Id ||
                                                    ' new_journal_id=' || v_Journal_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals', 'finished Migr_Timeoff_Journals');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Business_Trip_Journals is
    v_Total             number;
    v_Journal_Id        number;
    v_Timeoff_Id        number;
    v_Staff_Id          number;
    v_Id                number;
    v_Bt_Journal_Type   number;
    v_Default_Reason_Id number;
    v_Department_Name   varchar2(250 char);
    v_File_Shas         Array_Varchar2;
  
    v_Business_Trip_Journal Hpd_Pref.Business_Trip_Journal_Rt;
  
    -------------------------------------------------- 
    Function Department_Name(i_Departmen_Id number) return varchar2 is
      result varchar2(250 char);
    begin
      select q.Name
        into result
        from Hr5_Hr_Ref_Departments q
       where q.Department_Id = i_Departmen_Id;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Function Default_Reason_Id return number is
      c_Migr_Code constant varchar2(50) := 'migrated_trip_reason';
      v_Reason_Id number;
    begin
      select q.Reason_Id
        into v_Reason_Id
        from Href_Business_Trip_Reasons q
       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and q.Code = c_Migr_Code;
    
      return v_Reason_Id;
    exception
      when No_Data_Found then
        v_Reason_Id := Href_Next.Business_Trip_Reason_Id;
      
        z_Href_Business_Trip_Reasons.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                i_Reason_Id  => v_Reason_Id,
                                                i_Name       => 'Промигрированная командировка',
                                                i_State      => 'A',
                                                i_Code       => c_Migr_Code);
      
        return v_Reason_Id;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Business_Trip_Journals',
                                     'started Migr_Business_Trip_Journals');
  
    v_Bt_Journal_Type := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
  
    v_Default_Reason_Id := Default_Reason_Id;
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Business_Trip_Docs q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Business_Trip
               and Uk.Old_Id = q.Doc_Id)
       and exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
               and Uk.Old_Id = q.Assignment_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Business_Trip_Docs q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Business_Trip
                         and Uk.Old_Id = q.Doc_Id)
                 and exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                         and Uk.Old_Id = q.Assignment_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Business_Trip_Journals',
                                       'inserted ' || (r.Rownum - 1) || ' business trip(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Journal_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Key_Name   => Hr5_Migr_Pref.c_Robot_Assignment,
                                                 i_Old_Id     => r.Assignment_Id,
                                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        select p.Staff_Id
          into v_Staff_Id
          from Hpd_Journal_Pages p
         where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
           and p.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
           and p.Journal_Id = v_Journal_Id;
      
        v_Id         := Hpd_Next.Journal_Id;
        v_Timeoff_Id := Hpd_Next.Timeoff_Id;
      
        Hpd_Util.Business_Trip_Journal_New(o_Journal         => v_Business_Trip_Journal,
                                           i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Journal_Id      => v_Id,
                                           i_Journal_Type_Id => v_Bt_Journal_Type,
                                           i_Journal_Number  => null,
                                           i_Journal_Date    => r.Date_Begin,
                                           i_Journal_Name    => r.Name);
      
        -- business trip files
        select f.File_Sha
          bulk collect
          into v_File_Shas
          from Hr5_Hr_Doc_Files f
         where f.Doc_Id = r.Doc_Id
         order by f.Order_No;
      
        v_Department_Name := Department_Name(r.To_Department_Id);
      
        Hpd_Util.Journal_Add_Business_Trip(p_Journal    => v_Business_Trip_Journal,
                                           i_Timeoff_Id => v_Timeoff_Id,
                                           i_Staff_Id   => v_Staff_Id,
                                           i_Region_Ids => Array_Number(Md_Pref.Region_Id_Uzbekistan(Hr5_Migr_Pref.g_Company_Id)),
                                           i_Person_Id  => null,
                                           i_Reason_Id  => Coalesce(Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                             i_Key_Name   => Hr5_Migr_Pref.c_Ref_Business_Reason,
                                                                                             i_Old_Id     => r.Reason_Id),
                                                                    v_Default_Reason_Id),
                                           i_Begin_Date => r.Date_Begin,
                                           i_End_Date   => r.Date_End,
                                           i_Note       => r.Note || ' В департамент: ' ||
                                                           v_Department_Name || ' Коэффициент: ' ||
                                                           r.Saved_Wage_Rate,
                                           i_Shas       => Nvl(v_File_Shas, Array_Varchar2()));
      
        Hpd_Api.Business_Trip_Journal_Save(v_Business_Trip_Journal);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Business_Trip,
                                i_Old_Id     => r.Doc_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Business_Trip_Docs',
                                 i_Key_Id        => r.Doc_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' old_assisgnment_id=' || r.Assignment_Id ||
                                                    ' new_journal_id=' || v_Journal_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Business_Trip_Journals',
                                     'finished Migr_Business_Trip_Journals');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Journals(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Initial_Journals;
    Migr_Initial_Dis_Unemp_Journals;
    Migr_Rank_Change_Journals;
    Migr_Timeoff_Journals;
    Migr_Business_Trip_Journals;
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_First_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Hiring_Jt_Id      number;
    v_Transfer_Jt_Id    number;
    v_Dismissal_Jt_Id   number;
    v_Rank_Change_Jt_Id number;
  
    v_Total number;
  
    v_Error_Employee_Id  number := -1;
    v_Curent_Employee_Id number := -1;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Hpd_Pref.g_Migration_Active := true;
  
    v_Hiring_Jt_Id      := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    v_Transfer_Jt_Id    := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    v_Dismissal_Jt_Id   := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    v_Rank_Change_Jt_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
  
    Dbms_Application_Info.Set_Module('Migr_Journals_Post', 'started Migr_Journals_Post');
  
    Hpd_Pref.g_Migration_Active := true;
  
    -- total count
    select count(*)
      into v_Total
      from Hpd_Journals q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and q.Posted = 'N'
       and q.Journal_Type_Id in
           (v_Hiring_Jt_Id, v_Transfer_Jt_Id, v_Dismissal_Jt_Id, v_Rank_Change_Jt_Id)
       and exists (select 1
              from Hr5_Migr_Keys_Store_Two Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and (Uk.Key_Name in (Hr5_Migr_Pref.c_Robot_Assignment,
                                    Hr5_Migr_Pref.c_Robot_Assignment_Dismissal,
                                    Hr5_Migr_Pref.c_Unemployeed_Robot) or
                   Uk.Key_Name like (Hr5_Migr_Pref.c_Rank_Change || '%'))
               and Uk.New_Id = q.Journal_Id);
  
    for r in (select q.Journal_Id, q.Employee_Id, Rownum
                from (select (select Je.Employee_Id
                                from Hpd_Journal_Employees Je
                               where Je.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Je.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and Je.Journal_Id = q.Journal_Id) as Employee_Id,
                             q.*
                        from Hpd_Journals q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and q.Posted = 'N'
                         and q.Journal_Type_Id in (v_Hiring_Jt_Id,
                                                   v_Transfer_Jt_Id,
                                                   v_Dismissal_Jt_Id,
                                                   v_Rank_Change_Jt_Id)
                         and exists
                       (select 1
                                from Hr5_Migr_Keys_Store_Two Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and (Uk.Key_Name in
                                     (Hr5_Migr_Pref.c_Robot_Assignment,
                                       Hr5_Migr_Pref.c_Robot_Assignment_Dismissal,
                                       Hr5_Migr_Pref.c_Unemployeed_Robot) or
                                     Uk.Key_Name like (Hr5_Migr_Pref.c_Rank_Change || '%'))
                                 and Uk.New_Id = q.Journal_Id)
                       order by 1, q.Journal_Date) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Journals_Post',
                                       'posted ' || (r.Rownum - 1) || ' Journal(s) out of ' ||
                                       v_Total);
    
      if v_Error_Employee_Id = r.Employee_Id then
        continue;
      end if;
    
      if v_Curent_Employee_Id <> r.Employee_Id then
        begin
          Biruni_Route.Context_Begin;
        
          Hpd_Core.Dirty_Staffs_Evaluate(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
          Hpd_Core.Agreements_Evaluate(Hr5_Migr_Pref.g_Company_Id);
        
          Hrm_Core.Dirty_Robots_Revise(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          for r in (select q.*
                      from Hpd_Journal_Page_Cache q)
          loop
            Hpd_Core.Staff_Refresh_Cache(i_Company_Id => r.Company_Id,
                                         i_Filial_Id  => r.Filial_Id,
                                         i_Staff_Id   => r.Staff_Id);
          end loop;
        
          delete Hpd_Journal_Page_Cache;
        
          Biruni_Route.Context_End;
        
          commit;
        exception
          when others then
            rollback to Try_Catch;
          
            v_Error_Employee_Id := v_Curent_Employee_Id;
          
            Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                   i_Table_Name    => 'Hpd_Core_Actions',
                                   i_Key_Id        => v_Error_Employee_Id,
                                   i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                      Dbms_Utility.Format_Error_Backtrace);
        end;
      
        savepoint Try_Catch;
      
        v_Curent_Employee_Id := r.Employee_Id;
      end if;
    
      begin
        Hpd_Api.Journal_Post(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                             i_Journal_Id => r.Journal_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Employee_Id := r.Employee_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hpd_Journals',
                                 i_Key_Id        => r.Journal_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' error_employee_id' || v_Error_Employee_Id);
      end;
    end loop;
  
    if v_Curent_Employee_Id <> v_Error_Employee_Id then
      begin
        Biruni_Route.Context_Begin;
      
        Hpd_Core.Dirty_Staffs_Evaluate(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        Hpd_Core.Agreements_Evaluate(Hr5_Migr_Pref.g_Company_Id);
      
        Hrm_Core.Dirty_Robots_Revise(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        for r in (select q.*
                    from Hpd_Journal_Page_Cache q)
        loop
          Hpd_Core.Staff_Refresh_Cache(i_Company_Id => r.Company_Id,
                                       i_Filial_Id  => r.Filial_Id,
                                       i_Staff_Id   => r.Staff_Id);
        end loop;
      
        delete Hpd_Journal_Page_Cache;
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Employee_Id := v_Curent_Employee_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hpd_Core_Actions',
                                 i_Key_Id        => v_Error_Employee_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    end if;
  
    commit;
  
    Hpd_Pref.g_Migration_Active := false;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Journals_Post', 'finished Migr_Journals_Post');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timeoff_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Sick_Leave_Jt_Id number;
    v_Vacation_Jt_Id   number;
  
    v_Total number;
  
    v_Error_Employee_Id  number := -1;
    v_Curent_Employee_Id number := -1;
  begin
    return;
  
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Hpd_Pref.g_Migration_Active := true;
  
    v_Sick_Leave_Jt_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    v_Vacation_Jt_Id   := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  
    Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals_Post',
                                     'started Migr_Timeoff_Journals_Post');
  
    Hpd_Pref.g_Migration_Active := true;
  
    -- total count
    select count(*)
      into v_Total
      from Hpd_Journals q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and q.Posted = 'N'
       and q.Journal_Type_Id in (v_Sick_Leave_Jt_Id, v_Vacation_Jt_Id)
       and exists (select 1
              from Hr5_Migr_Keys_Store_Two Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Leave_Doc
               and Uk.New_Id = q.Journal_Id);
  
    for r in (select q.Journal_Id, q.Employee_Id, Rownum
                from (select (select Je.Employee_Id
                                from Hpd_Journal_Employees Je
                               where Je.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Je.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and Je.Journal_Id = q.Journal_Id) as Employee_Id,
                             q.*
                        from Hpd_Journals q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and q.Posted = 'N'
                         and q.Journal_Type_Id in (v_Sick_Leave_Jt_Id, v_Vacation_Jt_Id)
                         and exists (select 1
                                from Hr5_Migr_Keys_Store_Two Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Leave_Doc
                                 and Uk.New_Id = q.Journal_Id)
                       order by 1, q.Journal_Date) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals_Post',
                                       'posted ' || (r.Rownum - 1) || ' Journal(s) out of ' ||
                                       v_Total);
    
      if v_Error_Employee_Id = r.Employee_Id then
        continue;
      end if;
    
      if v_Curent_Employee_Id <> r.Employee_Id then
        commit;
      
        savepoint Try_Catch;
      
        v_Curent_Employee_Id := r.Employee_Id;
      end if;
    
      begin
        Hpd_Api.Journal_Post(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                             i_Journal_Id => r.Journal_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Employee_Id := r.Employee_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hpd_Journals',
                                 i_Key_Id        => r.Journal_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' error_employee_id' || v_Error_Employee_Id);
      end;
    end loop;
  
    commit;
  
    Hpd_Pref.g_Migration_Active := false;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Timeoff_Journals_Post',
                                     'finished Migr_Timeoff_Journals_Post');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Business_Trip_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total            number;
    v_Business_Trip_Jt number;
  
    v_Error_Employee_Id  number := -1;
    v_Curent_Employee_Id number := -1;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Hpd_Pref.g_Migration_Active := true;
  
    v_Business_Trip_Jt := Hpd_Util.Journal_Type_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
  
    Dbms_Application_Info.Set_Module('Migr_Business_Trip_Post', 'started Migr_Business_Trip_Post');
  
    Hpd_Pref.g_Migration_Active := true;
  
    -- total count
    select count(*)
      into v_Total
      from Hpd_Journals q
     where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and q.Posted = 'N'
       and q.Journal_Type_Id = v_Business_Trip_Jt
       and exists (select 1
              from Hr5_Migr_Keys_Store_Two Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Business_Trip
               and Uk.New_Id = q.Journal_Id);
  
    for r in (select q.Journal_Id, q.Employee_Id, Rownum
                from (select (select Je.Employee_Id
                                from Hpd_Journal_Employees Je
                               where Je.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Je.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and Je.Journal_Id = q.Journal_Id) as Employee_Id,
                             q.*
                        from Hpd_Journals q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and q.Posted = 'N'
                         and q.Journal_Type_Id = v_Business_Trip_Jt
                         and exists (select 1
                                from Hr5_Migr_Keys_Store_Two Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Business_Trip
                                 and Uk.New_Id = q.Journal_Id)
                       order by 1, q.Journal_Date) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Business_Trip_Post',
                                       'posted ' || (r.Rownum - 1) ||
                                       ' Hpd_Business_Trip(s) out of ' || v_Total);
    
      if v_Error_Employee_Id = r.Employee_Id then
        continue;
      end if;
    
      if v_Curent_Employee_Id <> r.Employee_Id then
        commit;
      
        savepoint Try_Catch;
      
        v_Curent_Employee_Id := r.Employee_Id;
      end if;
    
      begin
        Biruni_Route.Context_Begin;
        Hpd_Api.Journal_Post(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                             i_Journal_Id => r.Journal_Id);
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          v_Error_Employee_Id := r.Employee_Id;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hpd_Business_Trips',
                                 i_Key_Id        => r.Journal_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' error_employee_id' || v_Error_Employee_Id);
      end;
    end loop;
  
    commit;
  
    Hpd_Pref.g_Migration_Active := false;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Business_Trip_Post', 'finished Migr_Business_Trip_Post');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staf_Refresh_Cache(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Dbms_Application_Info.Set_Module('Run_Staf_Refresh_Cache', 'started Run_Staf_Refresh_Cache');
  
    Hpd_Core.Staff_Refresh_Cache(i_Company_Id);
  
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Biruni_Route.Context_Begin;
  
    for r in (select Je.Employee_Id
                from Hpd_Journal_Employees Je
               where Je.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Je.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                 and exists (select 1
                        from Hpd_Journals q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and q.Journal_Id = Je.Journal_Id
                         and q.Posted = 'Y')
                 and exists (select 1
                        from Hr5_Migr_Keys_Store_Two Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                         and Uk.New_Id = Je.Journal_Id)
               group by Je.Employee_Id)
    loop
      Htt_Core.Person_Sync_Locations(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                     i_Person_Id  => r.Employee_Id);
    end loop;
  
    for r in (select Je.Staff_Id
                from Hpd_Journal_Pages Je
               where Je.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Je.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                 and exists (select 1
                        from Hpd_Journals q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and q.Journal_Id = Je.Journal_Id
                         and q.Posted = 'Y')
                 and exists (select 1
                        from Hr5_Migr_Keys_Store_Two Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Robot_Assignment
                         and Uk.New_Id = Je.Journal_Id)
               group by Je.Staff_Id)
    loop
      Hrm_Core.Sync_Division_Managers(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                      i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                      i_Staff_Id   => r.Staff_Id);
    end loop;
  
    Biruni_Route.Context_End;
  
    commit;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Run_Staf_Refresh_Cache', 'finished Run_Staf_Refresh_Cache');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Try_Robot_Close(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total      number;
    v_Close_Date date;
  begin
    Dbms_Application_Info.Set_Module('Migr_Try_Robot_Close', 'started Migr_Try_Robot_Close');
  
    Hr5_Migr_Util.Init(i_Company_Id);
  
    select count(*)
      into v_Total
      from Hr5_Hr_Robots q
      join Hr5_Migr_Keys_Store_Two Ks
        on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
       and Ks.Old_Id = q.Robot_Id
       and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and not exists (select 1
              from Hrm_Robot_Transactions Rt
             where Rt.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Rt.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Rt.Robot_Id = Ks.New_Id
               and Rt.Tag = 'robot close')
       and q.Date_End is not null
       and q.Robot_Id <> 5498; -- staff ishlayotgan vaqtda yopilgan, sababi noma'lum
  
    for r in (select q.*, Ks.New_Id as New_Robot_Id, Rownum
                from Hr5_Hr_Robots q
                join Hr5_Migr_Keys_Store_Two Ks
                  on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
                 and Ks.Old_Id = q.Robot_Id
                 and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                 and not exists (select 1
                        from Hrm_Robot_Transactions Rt
                       where Rt.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Rt.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Rt.Tag = 'robot close')
                 and q.Date_End is not null
                 and q.Robot_Id <> 5498) -- staff ishlayotgan vaqtda yopilgan, sababi noma'lum
    loop
      Dbms_Application_Info.Set_Module('Migr_Try_Robot_Close',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' CLose Robot transaction(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        v_Close_Date := case
                          when r.Date_Begin > r.Date_End then
                           r.Date_Begin -- 4 ta ekan, assignment da foydalanailmagan
                          else
                           r.Date_End
                        end;
      
        Hrm_Core.Robot_Close(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                             i_Robot_Id   => r.New_Robot_Id,
                             i_Close_Date => v_Close_Date);
      
        Hrm_Core.Dirty_Robots_Revise(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        z_Hrm_Robots.Update_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                i_Robot_Id    => r.New_Robot_Id,
                                i_Closed_Date => Option_Date(v_Close_Date));
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hrm_Robot_Transactions_Close',
                                 i_Key_Id        => r.Robot_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' new_robot_id=' || r.New_Robot_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Try_Robot_Close', 'finished Migr_Try_Robot_Close');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Registry_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total number;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Registry_Post',
                                     'started Migr_Schedule_Registry_Post');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Migr_Schreg_Departments q
     where exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                   to_char(q.Month, Href_Pref.c_Date_Format_Month)
               and Uk.Old_Id = q.Department_Id)
       and exists (select 1
              from Htt_Schedule_Registries Sr
             where Sr.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Sr.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Sr.Registry_Id =
                   (select Ks.New_Id
                      from Hr5_Migr_Keys_Store_Two Ks
                     where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and Ks.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                           to_char(q.Month, Href_Pref.c_Date_Format_Month)
                       and Ks.Old_Id = q.Department_Id
                       and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id)
               and Sr.Posted = 'N');
  
    for r in (select q.Department_Id,
                     to_char(q.Month, Href_Pref.c_Date_Format_Month) as month,
                     (select Ks.New_Id
                        from Hr5_Migr_Keys_Store_Two Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                             to_char(q.Month, Href_Pref.c_Date_Format_Month)
                         and Ks.Old_Id = q.Department_Id
                         and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as Registry_Id,
                     (select Ks.New_Id
                        from Hr5_Migr_Keys_Store_Two Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part2 || ':' ||
                             to_char(q.Month, Href_Pref.c_Date_Format_Month)
                         and Ks.Old_Id = q.Department_Id
                         and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as Registry_Id2,
                     (select Ks.New_Id
                        from Hr5_Migr_Keys_Store_Two Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part3 || ':' ||
                             to_char(q.Month, Href_Pref.c_Date_Format_Month)
                         and Ks.Old_Id = q.Department_Id
                         and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as Registry_Id3,
                     Rownum
                from Hr5_Migr_Schreg_Departments q
               where exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                             to_char(q.Month, Href_Pref.c_Date_Format_Month)
                         and Uk.Old_Id = q.Department_Id)
                 and exists
               (select 1
                        from Htt_Schedule_Registries Sr
                       where Sr.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Sr.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and Sr.Registry_Id =
                             (select Ks.New_Id
                                from Hr5_Migr_Keys_Store_Two Ks
                               where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Ks.Key_Name = Hr5_Migr_Pref.c_Schedule_Registry_Part1 || ':' ||
                                     to_char(q.Month, Href_Pref.c_Date_Format_Month)
                                 and Ks.Old_Id = q.Department_Id
                                 and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id)
                         and Sr.Posted = 'N'))
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedule_Registry_Post',
                                       'posted ' || (r.Rownum - 1) ||
                                       ' Schedule Registry(ies) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        Htt_Api.Schedule_Registry_Post(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                       i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                       i_Registry_Id => r.Registry_Id);
      
        if r.Registry_Id2 is not null then
          Htt_Api.Schedule_Registry_Post(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Registry_Id => r.Registry_Id2);
        end if;
      
        if r.Registry_Id3 is not null then
          Htt_Api.Schedule_Registry_Post(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Registry_Id => r.Registry_Id3);
        end if;
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Htt_Schedule_Registries post' || ':' || r.Month,
                                 i_Key_Id        => r.Department_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Registry_Post',
                                     'finished Migr_Schedule_Registry_Post');
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timebook_Adjustment_Journals(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Journal    Hpd_Pref.Timebook_Adjustment_Journal_Rt;
    v_Adjustment Hpd_Pref.Adjustment_Rt;
    v_Total      number;
    v_Id         number;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals',
                                     'started Migr_Timebook_Adjustment_Journals');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Timesheet_Adjust_Docs q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Timesheet_Adjust_Doc
               and Uk.Old_Id = q.Doc_Cycle_Id)
       and q.Adjust_Date >= Hr5_Migr_Pref.g_Begin_Date;
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Timesheet_Adjust_Docs q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Timesheet_Adjust_Doc
                         and Uk.Old_Id = q.Doc_Cycle_Id)
                 and q.Adjust_Date >= Hr5_Migr_Pref.g_Begin_Date)
    loop
      Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Timebook Adjustment(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        Hpd_Util.Timebook_Adjustment_Journal_New(o_Journal         => v_Journal,
                                                 i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                                 i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                                 i_Journal_Id      => null,
                                                 i_Journal_Number  => null,
                                                 i_Journal_Date    => r.Doc_Date,
                                                 i_Journal_Name    => r.Name,
                                                 i_Division_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                               i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                                                                               i_Old_Id     => r.Department_Id,
                                                                                               i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                                 i_Adjustment_Date => r.Adjust_Date);
      
        for Item in (select q.*
                       from (select q.Doc_Cycle_Id,
                                    q.Adjust_Date,
                                    q.Robot_Id,
                                    q.Staff_Id,
                                    q.Redundant_Hours,
                                    q.Overtime_Hours,
                                    q.Extra_Hours,
                                    q.Xtime_Hours,
                                    q.Xtime_Rate,
                                    q.Kind,
                                    q.Note,
                                    (select s.Staff_Id
                                       from Href_Staffs s
                                      where s.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                        and s.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                        and s.Employee_Id = Ks.New_Id
                                        and s.State = 'A'
                                        and s.Hiring_Date <= q.Adjust_Date
                                        and (s.Dismissal_Date is null or
                                            s.Dismissal_Date >= q.Adjust_Date)) as New_Staff_Id,
                                    Ks2.New_Id as New_Robot_Id
                               from Hr5_Hr_Timesheet_Adjust_Items q
                               join Hr5_Migr_Keys_Store_One Ks
                                 on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                                and Ks.Old_Id = q.Staff_Id
                               join Hr5_Migr_Keys_Store_Two Ks2
                                 on Ks2.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                and Ks2.Key_Name = Hr5_Migr_Pref.c_Robot
                                and Ks2.Old_Id = q.Robot_Id
                              where q.Doc_Cycle_Id = r.Doc_Cycle_Id) q
                      where q.New_Robot_Id =
                            Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                          i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                          i_Staff_Id   => q.New_Staff_Id,
                                                          i_Period     => q.Adjust_Date)
                        and exists (select *
                               from Htt_Timesheets t
                              where t.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                and t.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                and t.Staff_Id = q.New_Staff_Id
                                and t.Timesheet_Date = r.Adjust_Date))
        loop
          if Item.Xtime_Hours < Item.Overtime_Hours + Item.Extra_Hours then
            Item.Xtime_Hours := Item.Overtime_Hours + Item.Extra_Hours;
          end if;
        
          Hpd_Util.Adjustment_New(o_Adjustment => v_Adjustment,
                                  i_Page_Id    => Hpd_Next.Page_Id,
                                  i_Staff_Id   => Item.New_Staff_Id);
        
          Hpd_Util.Adjustment_Add_Kind(p_Adjustment   => v_Adjustment,
                                       i_Kind         => Hpd_Pref.c_Adjustment_Kind_Full,
                                       i_Free_Time    => Item.Xtime_Hours * 60,
                                       i_Overtime     => Item.Overtime_Hours * 60,
                                       i_Turnout_Time => Item.Extra_Hours * 60);
        
          Hpd_Util.Timebook_Adjustment_Add_Adjustment(p_Journal    => v_Journal,
                                                      i_Adjustment => v_Adjustment);
        end loop;
      
        if v_Journal.Adjustments.Count > 0 then
          v_Id                 := Hpd_Next.Journal_Id;
          v_Journal.Journal_Id := v_Id;
        
          Hpd_Api.Timebook_Adjustment_Journal_Save(v_Journal);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Timesheet_Adjust_Doc,
                                  i_Old_Id     => r.Doc_Cycle_Id,
                                  i_New_Id     => v_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end if;
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Timesheet_Adjust_Docs',
                                 i_Key_Id        => r.Doc_Cycle_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals',
                                     'finished Migr_Timebook_Adjustment_Journals');
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timebook_Adjustment_Journals_Post(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total number;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals_Post',
                                     'started Migr_Timebook_Adjustment_Journals_Post');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Timesheet_Adjust_Docs q
      join Hr5_Migr_Keys_Store_Two Ks
        on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and Ks.Key_Name = Hr5_Migr_Pref.c_Timesheet_Adjust_Doc
       and Ks.Old_Id = q.Doc_Cycle_Id
       and exists (select *
              from Hpd_Journals j
             where j.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and j.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and j.Journal_Id = Ks.New_Id
               and j.Posted = 'N')
     where q.Dc_State = 'C'
       and q.Adjust_Date >= Hr5_Migr_Pref.g_Begin_Date;
  
    for r in (select q.Doc_Cycle_Id, Ks.New_Id, Rownum
                from Hr5_Hr_Timesheet_Adjust_Docs q
                join Hr5_Migr_Keys_Store_Two Ks
                  on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Timesheet_Adjust_Doc
                 and Ks.Old_Id = q.Doc_Cycle_Id
                 and exists (select *
                        from Hpd_Journals j
                       where j.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and j.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and j.Journal_Id = Ks.New_Id
                         and j.Posted = 'N')
               where q.Dc_State = 'C'
                 and q.Adjust_Date >= Hr5_Migr_Pref.g_Begin_Date)
    loop
      Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals_Post',
                                       'posted ' || (r.Rownum - 1) ||
                                       ' Timebook Adjustment Journal(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
      
        Hpd_Api.Journal_Post(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                             i_Journal_Id => r.New_Id);
      
        Biruni_Route.Context_End;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Timesheet_Adjust_Docs Post',
                                 i_Key_Id        => r.Doc_Cycle_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Timebook_Adjustment_Journals_Post',
                                     'finished Migr_Timebook_Adjustment_Journals_Post');
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Users_For_Employees(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total number;
  begin
    Dbms_Application_Info.Set_Module('Create_Users_For_Employees',
                                     'started Create_Users_For_Employees');
  
    Hr5_Migr_Util.Init(i_Company_Id);
    Biruni_Route.Context_Begin;
  
    select count(*)
      into v_Total
      from Hr5_Md_Users u
      join Hr5_Migr_Keys_Store_One Ks
        on Ks.Company_Id = i_Company_Id
       and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
       and Ks.Old_Id = u.User_Id
       and not exists (select 1
              from Md_Users U1
             where U1.Company_Id = i_Company_Id
               and U1.User_Id = Ks.New_Id)
       and exists (select *
              from Mhr_Employees e
             where e.Company_Id = i_Company_Id
               and e.Employee_Id = Ks.New_Id);
  
    for r in (select u.*,
                     Ks.New_Id,
                     (select n.Name
                        from Mr_Natural_Persons n
                       where n.Company_Id = i_Company_Id
                         and n.Person_Id = Ks.New_Id) as Person_Name,
                     (select n.Gender
                        from Mr_Natural_Persons n
                       where n.Company_Id = i_Company_Id
                         and n.Person_Id = Ks.New_Id) as Gender,
                     Rownum
                from Hr5_Md_Users u
                join Hr5_Migr_Keys_Store_One Ks
                  on Ks.Company_Id = i_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                 and Ks.Old_Id = u.User_Id
                 and not exists (select 1
                        from Md_Users U1
                       where U1.Company_Id = i_Company_Id
                         and U1.User_Id = Ks.New_Id)
                 and exists (select *
                        from Mhr_Employees e
                       where e.Company_Id = i_Company_Id
                         and e.Employee_Id = Ks.New_Id))
    loop
      Dbms_Application_Info.Set_Module('Create_Users_For_Employees',
                                       'inserted ' || (r.Rownum - 1) || ' user(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        z_Md_Users.Insert_One(i_Company_Id               => i_Company_Id,
                              i_User_Id                  => r.New_Id,
                              i_Name                     => r.Person_Name,
                              i_Login                    => r.Login,
                              i_Password                 => r.Password,
                              i_State                    => 'A',
                              i_User_Kind                => Md_Pref.c_Uk_Normal,
                              i_Gender                   => r.Gender,
                              i_Manager_Id               => Hr5_Migr_Util.Get_New_Id(i_Company_Id => i_Company_Id,
                                                                                     i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                     i_Old_Id     => r.Manager_Id),
                              i_Timezone_Code            => r.Timezone_Code,
                              i_Password_Changed_On      => r.Password_Changed_On,
                              i_Password_Change_Required => r.Forced_To_Change_Password,
                              i_Two_Factor_Verification  => Md_Pref.c_Two_Step_Verification_Disabled);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Md_Users',
                                 i_Key_Id        => r.User_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    insert into Md_User_Filials
      (Company_Id, User_Id, Filial_Id)
      select e.Company_Id, e.Employee_Id as User_Id, e.Filial_Id
        from Mhr_Employees e
       where e.Company_Id = i_Company_Id
         and not exists (select 1
                from Md_User_Filials Uf
               where Uf.Company_Id = i_Company_Id
                 and Uf.Filial_Id = e.Filial_Id
                 and Uf.User_Id = e.Employee_Id)
         and exists (select *
                from Md_Users u
               where u.Company_Id = i_Company_Id
                 and u.User_Id = e.Employee_Id);
  
    Biruni_Route.Context_End;
    Hr5_Migr_Util.Clear;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Create_Users_For_Employees',
                                     'finished Create_Users_For_Employees');
  end;

end Hr5_Migr_Robot;
/
