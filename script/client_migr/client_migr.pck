create or replace package Client_Migr is
  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number,
    i_Filial_Id      number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Gen_Save_Staff_Plan_Id
  (
    i_New_Company_Id number,
    i_Emp_Plan_Id    number,
    i_Filial_Id      number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Id
  (
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Employee_Id    number,
    i_Period         date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Activate_Division_Fix_Mode;
  ----------------------------------------------------------------------------------------------------
  Procedure Deactivate_Division_Fix_Mode;
  ----------------------------------------------------------------------------------------------------
  Procedure Cache_Filial_Ids
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Org_Struct
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Jobs_Ranks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Disable_Position
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedules_Since
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Period         date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Dismissals_Since
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Period         date
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Staff_Lines
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Persons
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Locations_And_Devices
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Users
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Tracks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number,
    i_Migr_Since     date := to_date('01.01.2000', 'dd.mm.yyyy')
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Schedules
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_References
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Leaves
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Timesheet_Plan_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Tasks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Perf_Plan
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Schedule_Days
  (
    i_New_Company_Id number,
    i_Year           number,
    i_Filial_Id      number := null,
    i_Schedule_Id    number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheets
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Staff_Refresh_Cache(i_New_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Zktime
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Identity_Photos
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Responsible_Persons
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Managers
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Schedules_Fix
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Staff_Number
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Marks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Oper_Types(i_New_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Biruni_Files;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Overtimes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Schedule_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Gps_Tracks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Users_For_Employees(i_New_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Regions
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Restore_Org_Sctruct
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Subordinated_Divisions_V1
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Divisions_V1
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Subordinated_Divisions_V2
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Divisions_V2
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
end Client_Migr;
/
create or replace package body Client_Migr is
  ----------------------------------------------------------------------------------------------------
  g_Samsung_Kz     constant number := -1;
  g_Samsung_Filial constant number := -1;

  ----------------------------------------------------------------------------------------------------
  c_Perf_Bonus_Name constant varchar2(100) := 'perf_bonus';
  c_Timetable_Key   constant varchar2(100) := 'timetable_id';

  ---------------------------------------------------------------------------------------------------- 
  g_Migr_Keys_Store_One Fazo.Number_Code_Aat;
  g_Migr_Keys_Store_Two Fazo.Number_Code_Aat;

  ---------------------------------------------------------------------------------------------------- 
  g_Filial_Ids     Array_Number;
  g_Staff_Plan_Ids Array_Number := Array_Number();

  ----------------------------------------------------------------------------------------------------
  g_Dummy_Division_Fix_Mode boolean := false;

  ----------------------------------------------------------------------------------------------------
  g_Default_Schedule_Id number := -100;

  ----------------------------------------------------------------------------------------------------
  Procedure Activate_Division_Fix_Mode is
  begin
    g_Dummy_Division_Fix_Mode := true;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Deactivate_Division_Fix_Mode is
  begin
    g_Dummy_Division_Fix_Mode := false;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Log_Error
  (
    i_New_Company_Id number,
    i_Table_Name     varchar2,
    i_Key_Id         number,
    i_Error_Message  varchar2
  ) is
  begin
    insert into Migr_Errors
      (Company_Id, Table_Name, Key_Id, Error_Message)
    values
      (i_New_Company_Id, i_Table_Name, i_Key_Id, i_Error_Message);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Used_Key
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Key_Id         number
  ) is
  begin
    insert into Migr_Used_Keys
      (Company_Id, Key_Name, Old_Id)
    values
      (i_New_Company_Id, i_Key_Name, i_Key_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number
  ) return number is
    result number;
  begin
    return g_Migr_Keys_Store_One(i_Key_Name || ':' || i_Old_Id);
  exception
    when No_Data_Found then
      begin
        select New_Id
          into result
          from Migr_Keys_Store_One So
         where So.Company_Id = i_New_Company_Id
           and So.Key_Name = i_Key_Name
           and So.Old_Id = i_Old_Id;
      
        g_Migr_Keys_Store_One(i_Key_Name || ':' || i_Old_Id) := result;
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number,
    i_Filial_Id      number
  ) return number is
    result number;
  begin
    return g_Migr_Keys_Store_Two(i_Key_Name || ':' || i_Old_Id || ',' || 'filial_id:' ||
                                 i_Filial_Id);
  exception
    when No_Data_Found then
      begin
        select New_Id
          into result
          from Migr_Keys_Store_Two St
         where St.Company_Id = i_New_Company_Id
           and St.Key_Name = i_Key_Name
           and St.Old_Id = i_Old_Id
           and St.Filial_Id = i_Filial_Id;
      
        g_Migr_Keys_Store_Two(i_Key_Name || ':' || i_Old_Id || ',' || 'filial_id:' || i_Filial_Id) := result;
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Key
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number,
    i_New_Id         number
  ) is
    v_Dummy number;
  begin
    begin
      select 1
        into v_Dummy
        from Migr_Used_Keys Uk
       where Uk.Company_Id = i_New_Company_Id
         and Uk.Key_Name = i_Key_Name
         and Uk.Old_Id = i_Old_Id;
    
    exception
      when No_Data_Found then
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => i_Key_Name,
                        i_Key_Id         => i_Old_Id);
    end;
  
    insert into Migr_Keys_Store_One
      (Company_Id, Key_Name, Old_Id, New_Id)
    values
      (i_New_Company_Id, i_Key_Name, i_Old_Id, i_New_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Key
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number,
    i_New_Id         number,
    i_Filial_Id      number
  ) is
    v_Dummy number;
  begin
    begin
      select 1
        into v_Dummy
        from Migr_Used_Keys Uk
       where Uk.Company_Id = i_New_Company_Id
         and Uk.Key_Name = i_Key_Name
         and Uk.Old_Id = i_Old_Id;
    
    exception
      when No_Data_Found then
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => i_Key_Name,
                        i_Key_Id         => i_Old_Id);
    end;
  
    insert into Migr_Keys_Store_Two
      (Company_Id, Key_Name, Old_Id, Filial_Id, New_Id)
    values
      (i_New_Company_Id, i_Key_Name, i_Old_Id, i_Filial_Id, i_New_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Save_Staff_Plan_Id
  (
    i_New_Company_Id number,
    i_Emp_Plan_Id    number,
    i_Filial_Id      number
  ) return number is
    v_Staff_Plan_Id number := Hper_Next.Staff_Plan_Id;
  begin
    Insert_Key(i_New_Company_Id => i_New_Company_Id,
               i_Key_Name       => 'staff_plan_id',
               i_Old_Id         => i_Emp_Plan_Id,
               i_New_Id         => v_Staff_Plan_Id,
               i_Filial_Id      => i_Filial_Id);
  
    Fazo.Push(g_Staff_Plan_Ids, v_Staff_Plan_Id);
  
    return v_Staff_Plan_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Id
  (
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Employee_Id    number,
    i_Period         date
  ) return number is
    result number;
  begin
    select q.Staff_Id
      into result
      from Href_Staffs q
     where q.Company_Id = i_New_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Employee_Id = i_Employee_Id
       and q.State = 'A'
       and q.Hiring_Date <= i_Period
       and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Period);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Region_Id
  (
    i_New_Company_Id number,
    i_Old_Region_Id  number
  ) return number is
  begin
    return Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                      i_Key_Name       => 'region_id', --
                      i_Old_Id         => i_Old_Region_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Doc_Type_Id
  (
    i_New_Company_Id  number,
    i_Old_Doc_Type_Id number
  ) return number is
    result number := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'doc_type_id', --
                                i_Old_Id         => i_Old_Doc_Type_Id);
  begin
    if result is not null then
      return result;
    end if;
  
    -- only one pcode entry in old table
    result := Href_Util.Doc_Type_Id(i_Company_Id => i_New_Company_Id,
                                    i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Task_Group_Id
  (
    i_New_Company_Id    number,
    i_Old_Company_Id    number,
    i_Old_Task_Group_Id number
  ) return number is
    result number := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'task_group_id', --
                                i_Old_Id         => i_Old_Task_Group_Id);
  
    v_Pcode varchar2(20);
  begin
    if result is not null then
      return result;
    end if;
  
    select Pcode
      into v_Pcode
      from Old_Ms_Task_Groups
     where Company_Id = i_Old_Company_Id
       and Task_Group_Id = i_Old_Task_Group_Id;
  
    result := Ms_Pref.Task_Group_Id(i_Company_Id => i_New_Company_Id, i_Pcode => v_Pcode);
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Task_Status_Id
  (
    i_New_Company_Id     number,
    i_Old_Company_Id     number,
    i_Old_Task_Status_Id number
  ) return number is
    result number := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'status_id', --
                                i_Old_Id         => i_Old_Task_Status_Id);
  
    v_Pcode varchar2(20);
  begin
    if result is not null then
      return result;
    end if;
  
    select Pcode
      into v_Pcode
      from Old_Ms_Task_Statuses
     where Company_Id = i_Old_Company_Id
       and Status_Id = i_Old_Task_Status_Id;
  
    result := Ms_Pref.Task_Status_Id(i_Company_Id => i_New_Company_Id, i_Pcode => v_Pcode);
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cache_Filial_Ids
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  ) is
  begin
    g_Filial_Ids := Array_Number();
    for r in (select *
                from Md_Filials
               where Company_Id = i_New_Company_Id
                 and (i_Filial_Id is null or Filial_Id = i_Filial_Id)
                 and State = 'A')
    loop
      Fazo.Push(g_Filial_Ids, r.Filial_Id);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Add_Default_Schedule(i_New_Company_Id number) is
    v_Schedule       Htt_Pref.Schedule_Rt;
    v_Dummy_Schedule Htt_Pref.Schedule_Rt;
    v_Schedule_Day   Htt_Pref.Schedule_Day_Rt;
    v_Pattern        Htt_Pref.Schedule_Pattern_Rt;
    v_Pattern_Day    Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Current_Day    date;
    v_Last_Day       date := Add_Months(Trunc(sysdate, 'year'), 12);
    v_First_Day      date := Trunc(sysdate, 'year');
    v_Start_Day      date := Trunc(v_First_Day, 'IW');
  
    --------------------------------------------------
    Function Default_Exists(i_Filial_Id number) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Schedules q
       where q.Company_Id = i_New_Company_Id
         and q.Filial_Id = i_Filial_Id
         and Lower(q.Name) = Lower('DEFAULT SCHEDULE');
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
  begin
    Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Pattern,
                                  i_Schedule_Kind  => Htt_Pref.c_Schedule_Kind_Weekly,
                                  i_All_Days_Equal => 'Y',
                                  i_Count_Days     => 7);
  
    for i in 1 .. v_Pattern.Count_Days
    loop
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
                                        i_Day_No           => i,
                                        i_Day_Kind         => Htt_Pref.c_Day_Kind_Rest,
                                        i_Begin_Time       => 480,
                                        i_End_Time         => 1080,
                                        i_Break_Enabled    => 'Y',
                                        i_Break_Begin_Time => 780,
                                        i_Break_End_Time   => 840,
                                        i_Plan_Time        => 480);
      Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Pattern, --
                                        i_Day              => v_Pattern_Day);
    end loop;
  
    v_Dummy_Schedule.Days := Htt_Pref.Schedule_Day_Nt();
  
    v_Current_Day := v_First_Day;
  
    while v_Current_Day != v_Last_Day
    loop
      v_Pattern_Day := v_Pattern.Pattern_Day((v_Current_Day - v_Start_Day) mod
                                             v_Pattern.Count_Days + 1);
    
      Htt_Util.Schedule_Day_New(o_Day              => v_Schedule_Day,
                                i_Schedule_Date    => v_Current_Day,
                                i_Day_Kind         => v_Pattern_Day.Day_Kind,
                                i_Begin_Time       => v_Pattern_Day.Begin_Time,
                                i_End_Time         => v_Pattern_Day.End_Time,
                                i_Break_Enabled    => v_Pattern_Day.Break_Enabled,
                                i_Break_Begin_Time => v_Pattern_Day.Break_Begin_Time,
                                i_Break_End_Time   => v_Pattern_Day.Break_End_Time,
                                i_Plan_Time        => v_Pattern_Day.Plan_Time);
    
      Htt_Util.Schedule_Day_Add(o_Schedule => v_Dummy_Schedule, i_Day => v_Schedule_Day);
    
      v_Current_Day := v_Current_Day + 1;
    end loop;
  
    for f in 1 .. g_Filial_Ids.Count
    loop
      if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
        continue;
      end if;
    
      continue when Default_Exists(g_Filial_Ids(f));
    
      Htt_Util.Schedule_New(o_Schedule          => v_Schedule,
                            i_Company_Id        => i_New_Company_Id,
                            i_Filial_Id         => g_Filial_Ids(f),
                            i_Schedule_Id       => Htt_Next.Schedule_Id,
                            i_Name              => 'DEFAULT SCHEDULE',
                            i_Calendar_Id       => null,
                            i_Take_Holidays     => 'N',
                            i_Take_Nonworking   => 'N',
                            i_Shift             => 0,
                            i_Input_Acceptance  => 0,
                            i_Output_Acceptance => 0,
                            i_Track_Duration    => 1440,
                            i_Count_Late        => 'Y',
                            i_Count_Early       => 'Y',
                            i_Count_Lack        => 'Y',
                            i_State             => 'A',
                            i_Code              => null,
                            i_Year              => Extract(year from sysdate));
    
      v_Schedule.Pattern := v_Pattern;
      v_Schedule.Days    := v_Dummy_Schedule.Days;
    
      Htt_Api.Schedule_Save(v_Schedule);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'schedule_id',
                 i_Old_Id         => g_Default_Schedule_Id,
                 i_New_Id         => v_Schedule.Schedule_Id,
                 i_Filial_Id      => v_Schedule.Filial_Id);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Add_Filial
  (
    i_New_Company_Id  number,
    i_Old_Division_Id number,
    i_Filial_Id       number,
    i_Name            varchar2,
    i_State           varchar2
  ) is
    r_Filial Md_Filials%rowtype;
    r_Person Mr_Legal_Persons%rowtype;
  
    v_Currency_Id number;
  
    -------------------------------------------------- 
    Function Name_Used(i_Filial Md_Filials%rowtype) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Md_Filials f
       where f.Company_Id = i_Filial.Company_Id
         and Upper(f.Name) = Upper(i_Filial.Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    if g_Samsung_Kz = i_New_Company_Id then
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'filial_id',
                 i_Old_Id         => i_Old_Division_Id,
                 i_New_Id         => i_Filial_Id);
    
      return;
    end if;
  
    r_Filial.Company_Id := i_New_Company_Id;
    r_Filial.Filial_Id  := i_Filial_Id;
    r_Filial.Name       := i_Name;
    r_Filial.State      := i_State;
  
    r_Person.Company_Id := i_New_Company_Id;
    r_Person.Person_Id  := r_Filial.Filial_Id;
    r_Person.Name       := r_Filial.Name;
    r_Person.Short_Name := r_Filial.Name;
    r_Person.State      := r_Filial.State;
  
    if Name_Used(r_Filial) then
      return;
    end if;
  
    Mr_Api.Legal_Person_Save(r_Person);
  
    Md_Api.Filial_Save(r_Filial);
  
    select Currency_Id
      into v_Currency_Id
      from Mk_Currencies
     where Company_Id = r_Filial.Company_Id
       and Pcode = 'ANOR:1';
  
    Mk_Api.Base_Currency_Save(i_Company_Id  => r_Filial.Company_Id,
                              i_Filial_Id   => r_Filial.Filial_Id,
                              i_Currency_Id => v_Currency_Id);
  
    Insert_Key(i_New_Company_Id => i_New_Company_Id,
               i_Key_Name       => 'filial_id',
               i_Old_Id         => i_Old_Division_Id,
               i_New_Id         => r_Filial.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Division
  (
    i_New_Company_Id  number,
    i_Old_Division_Id number,
    i_Filial_Id       number,
    i_Name            varchar2,
    i_Parent_Id       number,
    i_State           varchar2,
    i_Code            varchar2
  ) is
    r_Division Mhr_Divisions%rowtype;
  
    -------------------------------------------------- 
    Function Name_Used(i_Division Mhr_Divisions%rowtype) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Mhr_Divisions d
       where d.Company_Id = i_Division.Company_Id
         and d.Filial_Id = i_Division.Filial_Id
         and Lower(d.Name) = Lower(i_Division.Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    r_Division.Company_Id  := i_New_Company_Id;
    r_Division.Filial_Id   := i_Filial_Id;
    r_Division.Division_Id := Mhr_Next.Division_Id;
    r_Division.Name        := i_Name;
    r_Division.Opened_Date := Trunc(sysdate);
    r_Division.State       := i_State;
    r_Division.Code        := i_Code;
  
    if Name_Used(r_Division) then
      r_Division.Name := r_Division.Name || ':' || r_Division.Division_Id;
    end if;
  
    -- parent division is filial
    if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                  i_Key_Name       => 'filial_id',
                  i_Old_Id         => i_Parent_Id) is not null then
      r_Division.Parent_Id := null;
    else
      r_Division.Parent_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                         i_Key_Name       => 'division_id',
                                         i_Old_Id         => i_Parent_Id);
    end if;
  
    Mhr_Api.Division_Save(r_Division);
  
    Insert_Key(i_New_Company_Id => i_New_Company_Id,
               i_Key_Name       => 'division_id',
               i_Old_Id         => i_Old_Division_Id,
               i_New_Id         => r_Division.Division_Id);
    Insert_Key(i_New_Company_Id => i_New_Company_Id,
               i_Key_Name       => 'division_filial_id',
               i_Old_Id         => i_Old_Division_Id,
               i_New_Id         => r_Division.Filial_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Org_Struct
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Filial_Id          number;
    v_Subcompany_Enabled varchar2(1);
    v_Filial_Exists      boolean := false;
    v_Total              number;
  begin
    -- add filials and divisions
    begin
      select p.Pref_Value
        into v_Subcompany_Enabled
        from Old_Md_Preferences p
       where p.Company_Id = i_Old_Company_Id
         and p.Filial_Id = (select q.Filial_Head
                              from Old_Md_Company_Infos q
                             where q.Company_Id = i_Old_Company_Id)
         and p.Pref_Code = 'VX:ORG_SUBCOMPANY_POLICY_ENABLED';
    
    exception
      when No_Data_Found then
        v_Subcompany_Enabled := 'N';
    end;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Divisions d
     where d.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name in ('division_id', 'filial_id')
               and Uk.Old_Id = d.Division_Id);
  
    if v_Subcompany_Enabled = 'Y' then
      for r in (select d.*, Rownum
                  from Old_Vx_Hr_Divisions d
                 where d.Company_Id = i_Old_Company_Id
                /* and not exists (select 1
                 from Migr_Used_Keys Uk
                where Uk.Company_Id = i_New_Company_Id
                  and Uk.Key_Name in ('division_id', 'filial_id')
                  and Uk.Old_Id = d.Division_Id)*/
                 start with d.Parent_Id is null
                connect by prior d.Division_Id = d.Parent_Id)
      loop
        Dbms_Application_Info.Set_Module('Migr_Org_Struct',
                                         'inserted ' || (r.Rownum - 1) || ' divisions out of ' ||
                                         v_Total);
      
        v_Filial_Exists := true;
        if r.Parent_Id is null then
        
          if z_Migr_Used_Keys.Exist(i_Company_Id => i_New_Company_Id,
                                    i_Key_Name   => 'filial_id',
                                    i_Old_Id     => r.Division_Id) then
            v_Filial_Id := z_Migr_Keys_Store_One.Load(i_Company_Id => i_New_Company_Id, --
                           i_Key_Name =>'filial_id', --
                           i_Old_Id => r.Division_Id).New_Id;
          else
            v_Filial_Id := Md_Next.Person_Id;
          
            Add_Filial(i_New_Company_Id  => i_New_Company_Id,
                       i_Old_Division_Id => r.Division_Id,
                       i_Filial_Id       => v_Filial_Id,
                       i_Name            => r.Name,
                       i_State           => r.State);
          end if;
          /*
          if g_Samsung_Kz = i_New_Company_Id then
            v_Filial_Id := g_Samsung_Filial;
          else
            v_Filial_Id := Md_Next.Person_Id;
          end if;*/
        
        else
          continue when z_Migr_Used_Keys.Exist(i_Company_Id => i_New_Company_Id,
                                               i_Key_Name   => 'division_id',
                                               i_Old_Id     => r.Division_Id);
          Add_Division(i_New_Company_Id  => i_New_Company_Id,
                       i_Old_Division_Id => r.Division_Id,
                       i_Filial_Id       => v_Filial_Id,
                       i_Name            => r.Name,
                       i_Parent_Id       => r.Parent_Id,
                       i_State           => r.State,
                       i_Code            => r.Code);
        end if;
      end loop;
    end if;
  
    if not v_Filial_Exists then
      if g_Samsung_Kz = i_New_Company_Id then
        v_Filial_Id := g_Samsung_Filial;
      else
        v_Filial_Id := Md_Next.Person_Id;
      end if;
    
      Add_Filial(i_New_Company_Id  => i_New_Company_Id,
                 i_Old_Division_Id => -1,
                 i_Filial_Id       => v_Filial_Id,
                 i_Name            => Md_Util.Company_Name(i_New_Company_Id),
                 i_State           => 'A');
    
      for r in (select d.*, Rownum
                  from Old_Vx_Hr_Divisions d
                 where d.Company_Id = i_Old_Company_Id
                   and not exists (select 1
                          from Migr_Used_Keys Uk
                         where Uk.Company_Id = i_New_Company_Id
                           and Uk.Key_Name in ('division_id', 'filial_id')
                           and Uk.Old_Id = d.Division_Id)
                 start with d.Parent_Id is null
                connect by prior d.Division_Id = d.Parent_Id)
      loop
        Dbms_Application_Info.Set_Module('Migr_Org_Struct',
                                         'inserted ' || (r.Rownum - 1) || ' divisions out of ' ||
                                         v_Total);
      
        Add_Division(i_New_Company_Id  => i_New_Company_Id,
                     i_Old_Division_Id => r.Division_Id,
                     i_Filial_Id       => v_Filial_Id,
                     i_Name            => r.Name,
                     i_Parent_Id       => r.Parent_Id,
                     i_State           => r.State,
                     i_Code            => r.Code);
      end loop;
    end if;
  
    Cache_Filial_Ids(i_New_Company_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Org_Struct', 'finished Migr_Org_Struct');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Jobs_Ranks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_Job_Group Mhr_Job_Groups%rowtype;
    r_Job       Mhr_Jobs%rowtype;
    r_Rank      Mhr_Ranks%rowtype;
  
    v_Used_Filials Array_Number;
    v_New_Filials  Array_Number;
  
    v_Filial_Id number;
    v_Total     number;
  
    -------------------------------------------------- 
    Function Name_Used(i_Job Mhr_Jobs%rowtype) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Mhr_Jobs j
       where j.Company_Id = i_Job.Company_Id
         and j.Filial_Id = i_Job.Filial_Id
         and Lower(j.Name) = Lower(i_Job.Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    -------------------------------------------------- 
    Function Name_Used(i_Rank Mhr_Ranks%rowtype) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Mhr_Ranks p
       where p.Company_Id = i_Rank.Company_Id
         and p.Filial_Id = i_Rank.Filial_Id
         and Lower(p.Name) = Lower(i_Rank.Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    -- add job groups
    select count(*)
      into v_Total
      from Old_Vx_Hr_Job_Groups g
     where g.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'job_group_id'
               and Uk.Old_Id = g.Job_Group_Id);
  
    for r in (select g.*, Rownum
                from Old_Vx_Hr_Job_Groups g
               where g.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'job_group_id'
                         and Uk.Old_Id = g.Job_Group_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Jobs_Ranks',
                                       'inserted ' || (r.Rownum - 1) || ' job groups out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        r_Job_Group.Company_Id   := i_New_Company_Id;
        r_Job_Group.Job_Group_Id := Mhr_Next.Job_Group_Id;
        r_Job_Group.Name         := r.Name;
        r_Job_Group.Code         := r.Code;
        r_Job_Group.State        := r.State;
      
        Mhr_Api.Job_Group_Save(r_Job_Group);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'job_group_id',
                   i_Old_Id         => r.Job_Group_Id,
                   i_New_Id         => r_Job_Group.Job_Group_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Job_Groups',
                    i_Key_Id         => r.Job_Group_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- add jobs every filial
    select St.Filial_Id
      bulk collect
      into v_Used_Filials
      from Migr_Keys_Store_Two St
     where St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'job_id';
  
    v_New_Filials := g_Filial_Ids multiset Except v_Used_Filials;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Jobs j
     where j.Company_Id = i_Old_Company_Id
       and v_New_Filials is not Empty
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'job_id'
               and St.Old_Id = j.Job_Id
               and St.Filial_Id member of v_New_Filials);
  
    for r in (select j.*, Rownum
                from Old_Vx_Hr_Jobs j
               where j.Company_Id = i_Old_Company_Id
                 and v_New_Filials is not Empty
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'job_id'
                         and St.Old_Id = j.Job_Id
                         and St.Filial_Id member of v_New_Filials))
    loop
      Dbms_Application_Info.Set_Module('Migr_Jobs_Ranks',
                                       'inserted ' || (r.Rownum - 1) || ' jobs out of ' || v_Total);
      begin
        savepoint Try_Catch;
      
        r_Job.Company_Id        := i_New_Company_Id;
        r_Job.Job_Group_Id      := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                              i_Key_Name       => 'job_group_id', --
                                              i_Old_Id         => r.Job_Group_Id);
        r_Job.Name              := r.Name;
        r_Job.State             := r.State;
        r_Job.Code              := r.Code;
        r_Job.c_Divisions_Exist := 'N';
      
        for f in 1 .. g_Filial_Ids.Count
        loop
          if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
            continue;
          end if;
        
          continue when z_Mhr_Jobs.Exist(i_Company_Id => i_New_Company_Id,
                                         i_Filial_Id  => g_Filial_Ids(f),
                                         i_Job_Id     => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                    i_Key_Name       => 'job_id',
                                                                    i_Old_Id         => r.Job_Id,
                                                                    i_Filial_Id      => g_Filial_Ids(f)));
        
          r_Job.Filial_Id := g_Filial_Ids(f);
          r_Job.Job_Id    := Mhr_Next.Job_Id;
        
          if Name_Used(r_Job) then
            r_Job.Name := r_Job.Name || ':' || r_Job.Job_Id;
          end if;
        
          Mhr_Api.Job_Save(r_Job);
        
          Insert_Key(i_New_Company_Id => i_New_Company_Id,
                     i_Key_Name       => 'job_id', --
                     i_Old_Id         => r.Job_Id,
                     i_New_Id         => r_Job.Job_Id,
                     i_Filial_Id      => r_Job.Filial_Id);
        end loop;
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Jobs',
                    i_Key_Id         => r.Job_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- attach jobs to divisions
    for r in (select *
                from Old_Vx_Hr_Job_Divisions d
               where d.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name in ('division_id', 'filial_id')
                         and p.Old_Id = d.Division_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'job_id'
                         and q.Old_Id = d.Job_Id))
    loop
      begin
        savepoint Try_Catch;
        -- this division is filial
        v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                  i_Key_Name       => 'filial_id',
                                  i_Old_Id         => r.Division_Id);
        if v_Filial_Id is not null then
          if g_Dummy_Division_Fix_Mode then
            r.Division_Id := -v_Filial_Id;
            if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                          i_Key_Name       => 'division_id',
                          i_Old_Id         => r.Division_Id) is null then
              Add_Division(i_New_Company_Id  => i_New_Company_Id,
                           i_Old_Division_Id => r.Division_Id,
                           i_Filial_Id       => v_Filial_Id,
                           i_Name            => 'DUMMY',
                           i_Parent_Id       => null,
                           i_State           => 'A',
                           i_Code            => null);
            end if;
          else
            Log_Error(i_New_Company_Id => i_New_Company_Id,
                      i_Table_Name     => 'Vx_Hr_Job_Divisions',
                      i_Key_Id         => r.Division_Id,
                      i_Error_Message  => 'fix divisions in Vx_Hr_Job_Divisions, division_id=' ||
                                          r.Division_Id);
            continue;
          end if;
        end if;
      
        v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                  i_Key_Name       => 'division_filial_id',
                                  i_Old_Id         => r.Division_Id);
      
        Mhr_Api.Job_Attach_Division(i_Company_Id  => i_New_Company_Id,
                                    i_Filial_Id   => v_Filial_Id,
                                    i_Job_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                i_Key_Name       => 'job_id',
                                                                i_Old_Id         => r.Job_Id,
                                                                i_Filial_Id      => v_Filial_Id),
                                    i_Division_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                i_Key_Name       => 'division_id',
                                                                i_Old_Id         => r.Division_Id));
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Job_Divisions',
                    i_Key_Id         => r.Job_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- add ranks
    select St.Filial_Id
      bulk collect
      into v_Used_Filials
      from Migr_Keys_Store_Two St
     where St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'rank_id';
  
    v_New_Filials := g_Filial_Ids multiset Except v_Used_Filials;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Job_Ranks p
     where p.Company_Id = i_Old_Company_Id
       and v_New_Filials is not Empty
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'rank_id'
               and St.Old_Id = p.Rank_Id
               and St.Filial_Id member of v_New_Filials);
  
    for r in (select r.*, Rownum
                from Old_Vx_Hr_Job_Ranks r
               where r.Company_Id = i_Old_Company_Id
                 and v_New_Filials is not Empty
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'rank_id'
                         and St.Old_Id = r.Rank_Id
                         and St.Filial_Id member of v_New_Filials))
    loop
      Dbms_Application_Info.Set_Module('Migr_Jobs_Ranks',
                                       'inserted ' || (r.Rownum - 1) || ' ranks out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        r_Rank.Company_Id := i_New_Company_Id;
        r_Rank.Name       := r.Name;
        r_Rank.Order_No   := r.Order_No;
      
        for f in 1 .. g_Filial_Ids.Count
        loop
          if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
            continue;
          end if;
        
          continue when z_Mhr_Ranks.Exist(i_Company_Id => i_New_Company_Id,
                                          i_Filial_Id  => g_Filial_Ids(f),
                                          i_Rank_Id    => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                     i_Key_Name       => 'rank_id',
                                                                     i_Old_Id         => r.Rank_Id,
                                                                     i_Filial_Id      => g_Filial_Ids(f)));
        
          r_Rank.Filial_Id := g_Filial_Ids(f);
          r_Rank.Rank_Id   := Mhr_Next.Rank_Id;
        
          if Name_Used(r_Rank) then
            r_Rank.Name := r_Rank.Name || ':' || r_Rank.Rank_Id;
          end if;
        
          Mhr_Api.Rank_Save(r_Rank);
        
          Insert_Key(i_New_Company_Id => i_New_Company_Id,
                     i_Key_Name       => 'rank_id', --
                     i_Old_Id         => r.Rank_Id,
                     i_New_Id         => r_Rank.Rank_Id,
                     i_Filial_Id      => r_Rank.Filial_Id);
        end loop;
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Job_Ranks',
                    i_Key_Id         => r.Rank_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Jobs_Ranks', 'finished Migr_Jobs_Ranks');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Disable_Position
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  ) is
  begin
    update Hrm_Settings p
       set p.Position_Enable = 'N'
     where p.Company_Id = i_New_Company_Id
       and (i_Filial_Id is null or p.Filial_Id = i_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedules_Since
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Period         date
  ) is
    v_Schedule_Journal Hpd_Pref.Schedule_Change_Journal_Rt;
    v_Total            number;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Tp_Timetables q
      join Migr_Keys_Store_One Ks
        on Ks.Company_Id = i_New_Company_Id
       and Ks.Key_Name = 'person_id'
       and Ks.Old_Id = q.Employee_Id
      join Href_Staffs p
        on p.Company_Id = i_New_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Employee_Id = Ks.New_Id
       and p.State = 'A'
       and p.Hiring_Date <= i_Period
       and (p.Dismissal_Date is null or p.Dismissal_Date >= i_Period)
     where q.Company_Id = i_Old_Company_Id
       and q.Begin_Date >= i_Period
       and not exists (select *
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = c_Timetable_Key
               and Uk.Old_Id = q.Timetable_Id);
  
    for r in (select Qr.*, Rownum
                from (select q.*, p.Staff_Id
                        from Old_Vx_Tp_Timetables q
                        join Migr_Keys_Store_One Ks
                          on Ks.Company_Id = i_New_Company_Id
                         and Ks.Key_Name = 'person_id'
                         and Ks.Old_Id = q.Employee_Id
                        join Href_Staffs p
                          on p.Company_Id = i_New_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Employee_Id = Ks.New_Id
                         and p.State = 'A'
                         and p.Hiring_Date <= q.Begin_Date
                         and (p.Dismissal_Date is null or p.Dismissal_Date >= q.Begin_Date)
                       where q.Company_Id = i_Old_Company_Id
                         and q.Begin_Date >= i_Period
                         and not exists (select *
                                from Migr_Used_Keys Uk
                               where Uk.Company_Id = i_New_Company_Id
                                 and Uk.Key_Name = c_Timetable_Key
                                 and Uk.Old_Id = q.Timetable_Id)) Qr)
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedules_Since',
                                       'inserted ' || (r.Rownum - 1) || ' timetables out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Schedule_Journal,
                                             i_Company_Id     => i_New_Company_Id,
                                             i_Filial_Id      => i_Filial_Id,
                                             i_Journal_Id     => Hpd_Next.Journal_Id,
                                             i_Journal_Number => null,
                                             i_Journal_Date   => r.Begin_Date,
                                             i_Journal_Name   => null,
                                             i_Division_Id    => null,
                                             i_Begin_Date     => r.Begin_Date,
                                             i_End_Date       => r.End_Date);
      
        Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Schedule_Journal,
                                             i_Page_Id     => Hpd_Next.Page_Id,
                                             i_Staff_Id    => r.Staff_Id,
                                             i_Schedule_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                         i_Key_Name       => 'schedule_id',
                                                                         i_Old_Id         => r.Schedule_Id,
                                                                         i_Filial_Id      => i_Filial_Id));
        Hpd_Api.Schedule_Change_Journal_Save(v_Schedule_Journal);
        Hpd_Api.Journal_Post(i_Company_Id => v_Schedule_Journal.Company_Id,
                             i_Filial_Id  => v_Schedule_Journal.Filial_Id,
                             i_Journal_Id => v_Schedule_Journal.Journal_Id);
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => c_Timetable_Key, --                        
                        i_Key_Id         => r.Timetable_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Tp_Timetables',
                    i_Key_Id         => r.Timetable_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedules_Since', 'finished Migr_Schedules_Since');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Dismissals_Since
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number,
    i_Period         date
  ) is
    v_Dismissal_Journal Hpd_Pref.Dismissal_Journal_Rt;
    v_Total             number;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Hr_Emp_Jobs q
      join Migr_Keys_Store_One Ks
        on Ks.Company_Id = i_New_Company_Id
       and Ks.Key_Name = 'person_id'
       and Ks.Old_Id = q.Employee_Id
      join Href_Staffs p
        on p.Company_Id = i_New_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Employee_Id = Ks.New_Id
       and p.State = 'A'
       and p.Hiring_Date <= q.Begin_Date
       and p.Dismissal_Date is null
     where q.Company_Id = i_Old_Company_Id
       and q.End_Date >= i_Period
       and q.Dismissal_Reason_Id is not null
       and exists (select *
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'vx_hr_emp_job'
               and Uk.Old_Id = q.Emp_Job_Id);
  
    for r in (select Qr.*, Rownum
                from (select q.*, p.Staff_Id
                        from Old_Vx_Hr_Emp_Jobs q
                        join Migr_Keys_Store_One Ks
                          on Ks.Company_Id = i_New_Company_Id
                         and Ks.Key_Name = 'person_id'
                         and Ks.Old_Id = q.Employee_Id
                        join Href_Staffs p
                          on p.Company_Id = i_New_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Employee_Id = Ks.New_Id
                         and p.State = 'A'
                         and p.Hiring_Date <= q.Begin_Date
                         and p.Dismissal_Date is null
                       where q.Company_Id = i_Old_Company_Id
                         and q.End_Date >= i_Period
                         and q.Dismissal_Reason_Id is not null
                         and exists (select *
                                from Migr_Used_Keys Uk
                               where Uk.Company_Id = i_New_Company_Id
                                 and Uk.Key_Name = 'vx_hr_emp_job'
                                 and Uk.Old_Id = q.Emp_Job_Id)) Qr)
    loop
      Dbms_Application_Info.Set_Module('Migr_Dismissals_Since',
                                       'inserted ' || (r.Rownum - 1) || ' dismissals out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Dismissal_Journal,
                                       i_Company_Id      => i_New_Company_Id,
                                       i_Filial_Id       => i_Filial_Id,
                                       i_Journal_Id      => Hpd_Next.Journal_Id,
                                       i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_New_Company_Id,
                                                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                       i_Journal_Number  => null,
                                       i_Journal_Date    => r.End_Date,
                                       i_Journal_Name    => null);
      
        Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Dismissal_Journal,
                                       i_Page_Id              => Hpd_Next.Page_Id,
                                       i_Staff_Id             => r.Staff_Id,
                                       i_Dismissal_Date       => r.End_Date,
                                       i_Dismissal_Reason_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                            i_Key_Name       => 'dismissal_reason_id',
                                                                            i_Old_Id         => r.Dismissal_Reason_Id),
                                       i_Employment_Source_Id => null,
                                       i_Based_On_Doc         => null,
                                       i_Note                 => null);
      
        Hpd_Api.Dismissal_Journal_Save(v_Dismissal_Journal);
      
        Hpd_Api.Journal_Post(i_Company_Id => i_New_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Journal_Id => v_Dismissal_Journal.Journal_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Emp_Jobs',
                    i_Key_Id         => r.Emp_Job_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Dismissals_Since', 'finished Migr_Dismissals_Since');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Staff_Lines
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    r_Job      Old_Vx_Hr_Emp_Jobs%rowtype;
    r_Last_Job Old_Vx_Hr_Emp_Jobs%rowtype;
  
    v_Employee_Id number;
    v_Staff_Id    number;
  
    --     v_Filial_Id         number;
    --     v_Prev_Filial_Id    number := -1;
  
    v_Prev_Employee_Id  number := -1;
    v_Error_Employee_Id number := -1;
    v_Total             number;
  
    v_Marimoloko_Id number := -1;
  
    -------------------------------------------------- 
    Function Get_Robot_Id
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Employee_Id number
    ) return number is
      v_Robot_Id number;
    begin
      select p.Robot_Id
        into v_Robot_Id
        from Mrf_Robots p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Person_Id = i_Employee_Id
         and p.Division_Id is null
         and p.Job_Id is null;
    
      return v_Robot_Id;
    end;
  
    --------------------------------------------------
    Function Get_Division_Id
    (
      i_New_Company_Id  number,
      i_Filial_Id       number,
      i_Old_Division_Id number
    ) return number is
      result number;
    begin
      result := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                           i_Key_Name       => 'division_id',
                           i_Old_Id         => i_Old_Division_Id);
    
      if not z_Mhr_Divisions.Exist(i_Company_Id  => i_New_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Division_Id => result) then
        result := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                             i_Key_Name       => 'division_id',
                             i_Old_Id         => -i_Filial_Id);
        if result is null then
          Add_Division(i_New_Company_Id  => i_New_Company_Id,
                       i_Old_Division_Id => -i_Filial_Id,
                       i_Filial_Id       => i_Filial_Id,
                       i_Name            => 'TEST',
                       i_Parent_Id       => null,
                       i_State           => 'A',
                       i_Code            => null);
        
          result := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                               i_Key_Name       => 'division_id',
                               i_Old_Id         => -i_Filial_Id);
        end if;
      end if;
    
      return result;
    end;
  
    -------------------------------------------------- 
    Procedure Dismiss_Emp
    (
      i_Last_Job  Old_Vx_Hr_Emp_Jobs%rowtype,
      i_Filial_Id number,
      i_Staff_Id  number
    ) is
      v_Dismissal_Journal Hpd_Pref.Dismissal_Journal_Rt;
    begin
      Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Dismissal_Journal,
                                     i_Company_Id      => i_New_Company_Id,
                                     i_Filial_Id       => i_Filial_Id,
                                     i_Journal_Id      => Hpd_Next.Journal_Id,
                                     i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_New_Company_Id,
                                                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                     i_Journal_Number  => null,
                                     i_Journal_Date    => i_Last_Job.End_Date,
                                     i_Journal_Name    => null);
    
      Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Dismissal_Journal,
                                     i_Page_Id              => Hpd_Next.Page_Id,
                                     i_Staff_Id             => i_Staff_Id,
                                     i_Dismissal_Date       => i_Last_Job.End_Date,
                                     i_Dismissal_Reason_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                          i_Key_Name       => 'dismissal_reason_id',
                                                                          i_Old_Id         => i_Last_Job.Dismissal_Reason_Id),
                                     i_Employment_Source_Id => null,
                                     i_Based_On_Doc         => null,
                                     i_Note                 => null);
    
      Hpd_Api.Dismissal_Journal_Save(v_Dismissal_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => i_New_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => v_Dismissal_Journal.Journal_Id);
    exception
      when others then
        b.Raise_Error('filial_id: ' || i_Filial_Id || ' , staff_id: ' || i_Staff_Id);
    end;
  
    -------------------------------------------------- 
    Procedure Hire_Emp
    (
      i_Job         Old_Vx_Hr_Emp_Jobs%rowtype,
      i_Filial_Id   number,
      i_Employee_Id number,
      o_Staff_Id    out number
    ) is
      v_Hiring_Journal Hpd_Pref.Hiring_Journal_Rt;
      v_Robot          Hpd_Pref.Robot_Rt;
      v_Indicators     Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
      v_Oper_Types     Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
      v_Page_Id        number;
      v_Robot_Id       number;
    
      -------------------------------------------------- 
      Function Get_Staff_Number(i_Job Old_Vx_Hr_Emp_Jobs%rowtype) return varchar2 is
        result varchar2(50 char);
      begin
        select p.Employee_Number
          into result
          from Old_Vx_Hr_Employees p
         where p.Company_Id = i_Job.Company_Id
           and p.Employee_Id = i_Job.Employee_Id
           and not exists (select 1
                  from Href_Staffs q
                 where q.Company_Id = i_New_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and Upper(q.Staff_Number) = Upper(p.Employee_Number));
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
    begin
      if v_Marimoloko_Id != i_New_Company_Id then
        v_Robot_Id := Mrf_Next.Robot_Id;
      else
        v_Robot_Id := Get_Robot_Id(i_Company_Id  => i_New_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Employee_Id => i_Employee_Id);
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => v_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => Get_Division_Id(i_New_Company_Id  => i_New_Company_Id,
                                                              i_Filial_Id       => i_Filial_Id,
                                                              i_Old_Division_Id => i_Job.Division_Id),
                         i_Job_Id          => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'job_id',
                                                         i_Old_Id         => i_Job.Job_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Rank_Id         => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'rank_id',
                                                         i_Old_Id         => i_Job.Rank_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte             => 1,
                         i_Fte_Id          => Href_Util.Fte_Id(i_Company_Id => i_New_Company_Id,
                                                               i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time));
    
      Hpd_Util.Hiring_Journal_New(o_Journal         => v_Hiring_Journal,
                                  i_Company_Id      => i_New_Company_Id,
                                  i_Filial_Id       => i_Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_New_Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                  i_Journal_Number  => null,
                                  i_Journal_Date    => i_Job.Begin_Date,
                                  i_Journal_Name    => null);
    
      v_Page_Id := Hpd_Next.Page_Id;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => v_Hiring_Journal,
                                  i_Page_Id              => v_Page_Id,
                                  i_Employee_Id          => i_Employee_Id,
                                  i_Staff_Number         => Get_Staff_Number(i_Job),
                                  i_Hiring_Date          => i_Job.Begin_Date,
                                  i_Trial_Period         => 0,
                                  i_Employment_Source_Id => null,
                                  i_Schedule_Id          => null,
                                  i_Vacation_Days_Limit  => null,
                                  i_Robot                => v_Robot,
                                  i_Contract             => null,
                                  i_Indicators           => v_Indicators,
                                  i_Oper_Types           => v_Oper_Types);
    
      Hpd_Api.Hiring_Journal_Save(v_Hiring_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => i_New_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => v_Hiring_Journal.Journal_Id);
    
      -- load staff id
      select p.Staff_Id
        into o_Staff_Id
        from Hpd_Journal_Pages p
       where p.Company_Id = i_New_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Page_Id = v_Page_Id;
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'page_id', --
                 i_Old_Id         => i_Job.Emp_Job_Id,
                 i_New_Id         => v_Page_Id);
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'page_filial_id', --
                 i_Old_Id         => i_Job.Emp_Job_Id,
                 i_New_Id         => i_Filial_Id);
    end;
  
    -------------------------------------------------- 
    Procedure Transfer_Emp
    (
      i_Job       Old_Vx_Hr_Emp_Jobs%rowtype,
      i_Filial_Id number,
      i_Staff_Id  number
    ) is
      v_Transfer_Journal Hpd_Pref.Transfer_Journal_Rt;
      v_Robot            Hpd_Pref.Robot_Rt;
      v_Page_Id          number;
      v_Robot_Id         number;
      v_Employee_Id      number;
    begin
      if v_Marimoloko_Id != i_New_Company_Id then
        v_Robot_Id := Mrf_Next.Robot_Id;
      else
        v_Employee_Id := z_Href_Staffs.Load(i_Company_Id => i_New_Company_Id, --
                         i_Filial_Id => i_Filial_Id, --
                         i_Staff_Id => i_Staff_Id).Employee_Id;
      
        v_Robot_Id := Get_Robot_Id(i_Company_Id  => i_New_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Employee_Id => v_Employee_Id);
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => v_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => Get_Division_Id(i_New_Company_Id  => i_New_Company_Id,
                                                              i_Filial_Id       => i_Filial_Id,
                                                              i_Old_Division_Id => i_Job.Division_Id),
                         i_Job_Id          => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'job_id',
                                                         i_Old_Id         => i_Job.Job_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Rank_Id         => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'rank_id',
                                                         i_Old_Id         => i_Job.Rank_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte             => 1,
                         i_Fte_Id          => Href_Util.Fte_Id(i_Company_Id => i_New_Company_Id,
                                                               i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time));
    
      Hpd_Util.Transfer_Journal_New(o_Journal         => v_Transfer_Journal,
                                    i_Company_Id      => i_New_Company_Id,
                                    i_Filial_Id       => i_Filial_Id,
                                    i_Journal_Id      => Hpd_Next.Journal_Id,
                                    i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_New_Company_Id,
                                                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                    i_Journal_Number  => null,
                                    i_Journal_Date    => i_Job.Begin_Date,
                                    i_Journal_Name    => null);
    
      v_Page_Id := Hpd_Next.Page_Id;
    
      Hpd_Util.Journal_Add_Transfer(p_Journal             => v_Transfer_Journal,
                                    i_Page_Id             => v_Page_Id,
                                    i_Transfer_Begin      => i_Job.Begin_Date,
                                    i_Transfer_End        => null,
                                    i_Staff_Id            => i_Staff_Id,
                                    i_Schedule_Id         => null,
                                    i_Vacation_Days_Limit => null,
                                    i_Transfer_Reason     => null,
                                    i_Transfer_Base       => null,
                                    i_Robot               => v_Robot,
                                    i_Contract            => null,
                                    i_Indicators          => Href_Pref.Indicator_Nt(),
                                    i_Oper_Types          => Href_Pref.Oper_Type_Nt());
    
      Hpd_Api.Transfer_Journal_Save(v_Transfer_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => i_New_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => v_Transfer_Journal.Journal_Id);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'page_id', --
                 i_Old_Id         => i_Job.Emp_Job_Id,
                 i_New_Id         => v_Page_Id);
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'page_filial_id', --
                 i_Old_Id         => i_Job.Emp_Job_Id,
                 i_New_Id         => i_Filial_Id);
    end;
  
    --------------------------------------------------
    Function Staff_Exists
    (
      i_Filial_Id   number,
      i_Employee_Id number,
      i_Period      date,
      o_Staff_Id    out number
    ) return boolean is
    begin
      o_Staff_Id := Get_Staff_Id(i_New_Company_Id => i_New_Company_Id,
                                 i_Filial_Id      => i_Filial_Id,
                                 i_Employee_Id    => i_Employee_Id,
                                 i_Period         => i_Period);
    
      return o_Staff_Id is not null;
    end;
  
  begin
    select count(*)
      into v_Total
      from Old_Vx_Hr_Emp_Jobs j
      join Old_Vx_Hr_Employees q
        on q.Company_Id = j.Company_Id
       and q.Employee_Id = j.Employee_Id
       and q.Subcompany_Id = i_Subcompany_Id
     where j.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'vx_hr_emp_job'
               and Uk.Old_Id = j.Emp_Job_Id);
  
    for r in (select q.*, Rownum
                from (select j.*
                        from Old_Vx_Hr_Emp_Jobs j
                        join Old_Vx_Hr_Employees q
                          on q.Company_Id = j.Company_Id
                         and q.Employee_Id = j.Employee_Id
                         and q.Subcompany_Id = i_Subcompany_Id
                       where j.Company_Id = i_Old_Company_Id
                         and not exists (select 1
                                from Migr_Used_Keys Uk
                               where Uk.Company_Id = i_New_Company_Id
                                 and Uk.Key_Name = 'vx_hr_emp_job'
                                 and Uk.Old_Id = j.Emp_Job_Id)
                       order by j.Employee_Id, j.Begin_Date) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Lines',
                                       'inserted ' || (r.Rownum - 1) || ' emp jobs out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        if v_Error_Employee_Id = r.Employee_Id then
          continue;
        end if;
      
        --         v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
        --                                   i_Key_Name       => 'filial_id',
        --                                   i_Old_Id         => r.Division_Id);
        --       
        --         this division is filial
        --         if v_Filial_Id is not null then
        --           if g_Dummy_Division_Fix_Mode then
        --             r.Division_Id := -v_Filial_Id;
        --             if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
        --                           i_Key_Name       => 'division_id',
        --                           i_Old_Id         => r.Division_Id) is null then
        --               Add_Division(i_New_Company_Id  => i_New_Company_Id,
        --                            i_Old_Division_Id => r.Division_Id,
        --                            i_Filial_Id       => v_Filial_Id,
        --                            i_Name            => 'DUMMY',
        --                            i_Parent_Id       => null,
        --                            i_State           => 'A',
        --                            i_Code            => null);
        --             end if;
        --           else
        --             b.Raise_Error('migr_staff_lines: this division is now filial, employee_id=$1, division_id=$2, emp_job_id=$3',
        --                           r.Employee_Id,
        --                           r.Division_Id,
        --                           r.Emp_Job_Id);
        --           end if;
        --         end if;
      
        r_Job.Company_Id          := r.Company_Id;
        r_Job.Emp_Job_Id          := r.Emp_Job_Id;
        r_Job.Employee_Id         := r.Employee_Id;
        r_Job.Division_Id         := r.Division_Id;
        r_Job.Job_Id              := r.Job_Id;
        r_Job.Type_Id             := r.Type_Id;
        r_Job.Begin_Date          := r.Begin_Date;
        r_Job.End_Date            := r.End_Date;
        r_Job.End_Date_Nvl        := r.End_Date_Nvl;
        r_Job.Note                := r.Note;
        r_Job.Rank_Id             := r.Rank_Id;
        r_Job.Dismissal_Reason_Id := r.Dismissal_Reason_Id;
      
        --         v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
        --                                   i_Key_Name       => 'division_filial_id', --
        --                                   i_Old_Id         => r.Division_Id);
      
        --if v_Prev_Filial_Id <> v_Filial_Id or v_Prev_Employee_Id <> r.Employee_Id or r_Last_Job.Dismissal_Reason_Id is not null
        if v_Prev_Employee_Id <> r.Employee_Id then
          if v_Error_Employee_Id = -1 and r_Last_Job.End_Date is not null and
             r_Last_Job.Employee_Id <> v_Error_Employee_Id then
            Dismiss_Emp(i_Last_Job  => r_Last_Job,
                        i_Filial_Id => i_Filial_Id,
                        i_Staff_Id  => v_Staff_Id);
          end if;
        
          v_Employee_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                      i_Key_Name       => 'person_id',
                                      i_Old_Id         => r.Employee_Id);
        
          if not Staff_Exists(i_Filial_Id   => i_Filial_Id,
                              i_Employee_Id => v_Employee_Id,
                              i_Period      => r.Begin_Date,
                              o_Staff_Id    => v_Staff_Id) then
            Hire_Emp(i_Job         => r_Job, --
                     i_Filial_Id   => i_Filial_Id,
                     i_Employee_Id => v_Employee_Id,
                     o_Staff_Id    => v_Staff_Id);
          else
            Transfer_Emp(i_Job       => r_Job, --
                         i_Filial_Id => i_Filial_Id,
                         i_Staff_Id  => v_Staff_Id);
          end if;
        else
          Transfer_Emp(i_Job       => r_Job, --
                       i_Filial_Id => i_Filial_Id,
                       i_Staff_Id  => v_Staff_Id);
        end if;
      
        r_Last_Job := r_Job;
        --v_Prev_Filial_Id    := v_Filial_Id;
        v_Prev_Employee_Id  := r.Employee_Id;
        v_Error_Employee_Id := -1;
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'vx_hr_emp_job', --                        
                        i_Key_Id         => r.Emp_Job_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Emp_Jobs',
                    i_Key_Id         => r.Emp_Job_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
          v_Error_Employee_Id := r.Employee_Id;
      end;
    end loop;
  
    begin
      if v_Error_Employee_Id = -1 and r_Last_Job.End_Date is not null and
         r_Last_Job.Employee_Id <> v_Error_Employee_Id then
        Dismiss_Emp(i_Last_Job  => r_Last_Job, --
                    i_Filial_Id => i_Filial_Id,
                    i_Staff_Id  => v_Staff_Id);
      end if;
    exception
      when others then
        Log_Error(i_New_Company_Id => i_New_Company_Id,
                  i_Table_Name     => 'Vx_Hr_Emp_Jobs',
                  i_Key_Id         => r_Last_Job.Employee_Id,
                  i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                      Dbms_Utility.Format_Error_Backtrace);
    end;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Lines', 'finished Migr_Staff_Lines');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    v_Employee_Id      number;
    v_Total            number;
    v_Desired_Date     date;
    v_Schedule_Journal Hpd_Pref.Schedule_Change_Journal_Rt;
  
    v_Page_Id number;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Tp_Timetables q
      join Old_Vx_Hr_Employees t
        on t.Company_Id = q.Company_Id
       and t.Employee_Id = q.Employee_Id
       and t.Subcompany_Id = i_Subcompany_Id
     where q.Company_Id = i_Old_Company_Id
       and not exists (select *
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = c_Timetable_Key
               and Uk.Old_Id = q.Timetable_Id);
  
    for r in (select Qr.*, Rownum
                from (select q.Company_Id,
                             q.Timetable_Id,
                             q.Employee_Id,
                             q.Begin_Date,
                             q.End_Date,
                             Nvl(q.End_Date, to_date('01.01.2999', 'dd.mm.yyyy')) End_Date_Nvl,
                             q.Schedule_Id,
                             q.Ignore_Late_Time,
                             q.Ignore_Early_Time
                        from Old_Vx_Tp_Timetables q
                        join Old_Vx_Hr_Employees t
                          on t.Company_Id = q.Company_Id
                         and t.Employee_Id = q.Employee_Id
                         and t.Subcompany_Id = i_Subcompany_Id
                       where q.Company_Id = i_Old_Company_Id
                         and not exists (select *
                                from Migr_Used_Keys Uk
                               where Uk.Company_Id = i_New_Company_Id
                                 and Uk.Key_Name = c_Timetable_Key
                                 and Uk.Old_Id = q.Timetable_Id)
                       order by q.Employee_Id, q.Begin_Date) Qr)
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedule_Changes',
                                       (r.Rownum - 1) || '/' || v_Total || ' timetables');
    
      begin
        savepoint Try_Catch;
        v_Employee_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                    i_Key_Name       => 'person_id',
                                    i_Old_Id         => r.Employee_Id);
      
        for St in (select *
                     from Href_Staffs p
                    where p.Company_Id = i_New_Company_Id
                      and p.Filial_Id = i_Filial_Id
                      and p.Employee_Id = v_Employee_Id
                      and p.State = 'A')
        loop
          v_Desired_Date := Greatest(r.Begin_Date, St.Hiring_Date);
        
          continue when r.End_Date_Nvl < v_Desired_Date;
        
          Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Schedule_Journal,
                                               i_Company_Id     => i_New_Company_Id,
                                               i_Filial_Id      => St.Filial_Id,
                                               i_Journal_Id     => Hpd_Next.Journal_Id,
                                               i_Journal_Number => null,
                                               i_Journal_Date   => r.Begin_Date,
                                               i_Journal_Name   => null,
                                               i_Division_Id    => null,
                                               i_Begin_Date     => Least(v_Desired_Date,
                                                                         Nvl(St.Dismissal_Date,
                                                                             v_Desired_Date)),
                                               i_End_Date       => null);
        
          v_Page_Id := Hpd_Next.Page_Id;
        
          Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Schedule_Journal,
                                               i_Page_Id     => v_Page_Id,
                                               i_Staff_Id    => St.Staff_Id,
                                               i_Schedule_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                           i_Key_Name       => 'schedule_id',
                                                                           i_Old_Id         => r.Schedule_Id,
                                                                           i_Filial_Id      => St.Filial_Id));
          Hpd_Api.Schedule_Change_Journal_Save(v_Schedule_Journal);
          Hpd_Api.Journal_Post(i_Company_Id => v_Schedule_Journal.Company_Id,
                               i_Filial_Id  => v_Schedule_Journal.Filial_Id,
                               i_Journal_Id => v_Schedule_Journal.Journal_Id);
        end loop;
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => c_Timetable_Key, --                        
                        i_Key_Id         => r.Timetable_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Tp_Timetables',
                    i_Key_Id         => r.Timetable_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Changes', 'finished Migr_Schedule_Changes');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Persons
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    r_User            Md_Users%rowtype;
    v_Person          Href_Pref.Person_Rt;
    v_Person_Identity Htt_Pref.Person_Rt;
    v_Employee        Href_Pref.Employee_Rt;
    v_Identity_Photos Array_Varchar2;
    v_Total           number;
    v_Person_Id       number;
  
    r_Person_Edu_Stage     Href_Person_Edu_Stages%rowtype;
    r_Person_Family_Member Href_Person_Family_Members%rowtype;
    r_Person_Document      Href_Person_Documents%rowtype;
  
    --------------------------------------------------
    Function Get_Person_Id(i_Name varchar2) return number is
      v_Person_Id number;
    begin
      begin
        select Np.Person_Id
          into v_Person_Id
          from Mr_Natural_Persons Np
         where Np.Company_Id = i_New_Company_Id
           and Lower(Np.Name) = Lower(i_Name);
      
      exception
        when No_Data_Found then
          v_Person_Id := Md_Next.Person_Id;
      end;
    
      return v_Person_Id;
    end;
  
    -------------------------------------------------- 
    Function Phone_Used(i_Phone varchar2) return boolean is
      v_Person_Id number;
    begin
      v_Person_Id := Md_Util.Take_Person_Id_By_Phone(i_Company_Id => i_New_Company_Id,
                                                     i_Phone      => Regexp_Replace(i_Phone, '\D', ''));
    
      return v_Person_Id is not null;
    end;
  
  begin
    select count(*)
      into v_Total
      from Old_Vx_Hr_Employees He
     where He.Company_Id = i_Old_Company_Id
       and He.Subcompany_Id = i_Subcompany_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'person_id'
               and Uk.Old_Id = He.Employee_Id);
  
    for r in (select Op.*,
                     He.Employee_Number,
                     He.Employee_Id,
                     He.Subcompany_Id,
                     Ou.Login,
                     Ou.Password,
                     Ou.Password_Change_Required,
                     Ou.Password_Changed_On,
                     Ou.Timezone_Code,
                     Rownum
                from Old_Vx_Hr_Employees He
                join Old_Vx_Org_Persons Op
                  on Op.Company_Id = He.Company_Id
                 and Op.Person_Id = He.Employee_Id
                left join Old_Md_Users Ou
                  on Ou.Company_Id = He.Company_Id
                 and Ou.User_Id = He.Employee_Id
               where He.Company_Id = i_Old_Company_Id
                 and He.Subcompany_Id = i_Subcompany_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'person_id'
                         and Uk.Old_Id = Op.Person_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Persons',
                                       'inserted ' || (r.Rownum - 1) || ' persons out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        if trim(Lower(r.Tin)) <> r.Tin then
          r.Tin := null;
        end if;
      
        if g_Samsung_Kz = i_New_Company_Id then
          v_Person_Id := Get_Person_Id(r.Name);
        else
          v_Person_Id := Md_Next.Person_Id;
        end if;
      
        Href_Util.Person_New(o_Person               => v_Person,
                             i_Company_Id           => i_New_Company_Id,
                             i_Person_Id            => v_Person_Id,
                             i_First_Name           => r.First_Name,
                             i_Last_Name            => r.Last_Name,
                             i_Middle_Name          => r.Middle_Name,
                             i_Gender               => r.Gender,
                             i_Birthday             => r.Birthday,
                             i_Nationality_Id       => null,
                             i_Photo_Sha            => r.Photo_Sha,
                             i_Tin                  => r.Tin,
                             i_Iapa                 => r.Iapa,
                             i_Npin                 => null,
                             i_Region_Id            => Get_Region_Id(i_New_Company_Id => i_New_Company_Id,
                                                                     i_Old_Region_Id  => r.Region_Id),
                             i_Main_Phone           => r.Mobile_Phone,
                             i_Email                => r.Email,
                             i_Address              => r.Address,
                             i_Legal_Address        => null,
                             i_Key_Person           => 'N',
                             i_Access_All_Employees => 'N',
                             i_State                => r.State,
                             i_Code                 => r.Code);
      
        Href_Api.Person_Save(v_Person);
      
        if r.Person_Kind = 'E' then
          v_Employee.Person := v_Person;
          v_Employee.State  := r.State;
        
          r_User.Company_Id               := i_New_Company_Id;
          r_User.User_Id                  := v_Person.Person_Id;
          r_User.Name                     := r.Name;
          r_User.Login                    := r.Login;
          r_User.User_Kind                := Md_Pref.c_Uk_Normal;
          r_User.Gender                   := v_Person.Gender;
          r_User.State                    := v_Person.State;
          r_User.Password                 := r.Password;
          r_User.Password_Change_Required := r.Password_Change_Required;
          r_User.Password_Changed_On      := r.Password_Changed_On;
          r_User.Timezone_Code            := r.Timezone_Code;
        
          Md_Api.User_Save(r_User);
        
          v_Employee.Filial_Id := i_Filial_Id;
        
          Href_Api.Employee_Save(v_Employee);
        
          Md_Api.User_Add_Filial(i_Company_Id => i_New_Company_Id,
                                 i_User_Id    => r_User.User_Id,
                                 i_Filial_Id  => v_Employee.Filial_Id);
        
          Mrf_Api.Filial_Add_Person(i_Company_Id => v_Person.Company_Id,
                                    i_Filial_Id  => v_Employee.Filial_Id,
                                    i_Person_Id  => v_Person.Person_Id,
                                    i_State      => v_Person.State);
        
          Md_Api.User_Add_Filial(i_Company_Id => i_New_Company_Id,
                                 i_User_Id    => r_User.User_Id,
                                 i_Filial_Id  => Md_Pref.Filial_Head(i_New_Company_Id));
        end if;
      
        z_Mr_Person_Details.Update_One(i_Company_Id => v_Person.Company_Id,
                                       i_Person_Id  => v_Person.Person_Id,
                                       i_Zip_Code   => Option_Varchar2(r.Postal_Code));
      
        select Pv.Sha
          bulk collect
          into v_Identity_Photos
          from Old_Vx_Cv_Person_Vectors Pv
         where Pv.Company_Id = r.Company_Id
           and Pv.Person_Id = r.Person_Id;
      
        Htt_Util.Person_New(o_Person     => v_Person_Identity,
                            i_Company_Id => v_Person.Company_Id,
                            i_Person_Id  => v_Person.Person_Id,
                            i_Pin        => null,
                            i_Pin_Code   => null,
                            i_Rfid_Code  => r.Rfid_Code,
                            i_Qr_Code    => Coalesce(r.Qr_Code,
                                                     Htt_Util.Qr_Code_Gen(v_Person.Person_Id)));
      
        Htt_Api.Person_Save(v_Person_Identity);
      
        for i in 1 .. v_Identity_Photos.Count
        loop
          Htt_Api.Person_Save_Photo(i_Company_Id => v_Person.Company_Id,
                                    i_Person_Id  => v_Person.Person_Id,
                                    i_Photo_Sha  => v_Identity_Photos(i),
                                    i_Is_Main    => case
                                                      when i = 1 then
                                                       'Y'
                                                      else
                                                       'N'
                                                    end);
        end loop;
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'person_id', --
                   i_Old_Id         => r.Person_Id,
                   i_New_Id         => v_Person.Person_Id);
      
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Org_Persons',
                    i_Key_Id         => r.Person_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- person specific info
    for r in (select *
                from Old_Vx_Hr_Emp_Edus q
               where q.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'person_id'
                         and Uk.Old_Id = q.Employee_Id)
                 and not exists (select *
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'edu_stage_id'
                         and p.Old_Id = q.Emp_Edu_Id))
    loop
      r_Person_Edu_Stage.Company_Id          := i_New_Company_Id;
      r_Person_Edu_Stage.Person_Edu_Stage_Id := Href_Next.Person_Edu_Stage_Id;
      r_Person_Edu_Stage.Person_Id           := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                           i_Key_Name       => 'person_id',
                                                           i_Old_Id         => r.Employee_Id);
      r_Person_Edu_Stage.Edu_Stage_Id        := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                           i_Key_Name       => 'edu_stage_id',
                                                           i_Old_Id         => r.Degree_Id);
      r_Person_Edu_Stage.Institution_Id      := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                           i_Key_Name       => 'institution_id',
                                                           i_Old_Id         => r.Institution_Id);
      r_Person_Edu_Stage.Begin_Date          := r.Start_Date;
      r_Person_Edu_Stage.End_Date            := r.Finish_Date;
    
      continue when not z_Md_Persons.Exist(i_Company_Id => i_New_Company_Id,
                                           i_Person_Id  => r_Person_Document.Person_Id);
    
      Href_Api.Person_Edu_Stage_Save(r_Person_Edu_Stage);
    
      for Edu_File in (select *
                         from Old_Vx_Hr_Emp_Edu_Files q
                        where q.Company_Id = i_Old_Company_Id
                          and q.Emp_Edu_Id = r.Emp_Edu_Id)
      loop
        Href_Api.Person_Edu_Stage_File_Save(i_Company_Id          => r_Person_Edu_Stage.Company_Id,
                                            i_Person_Edu_Stage_Id => r_Person_Edu_Stage.Person_Edu_Stage_Id,
                                            i_Sha                 => Edu_File.Sha);
      end loop;
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'edu_stage_id', --
                 i_Old_Id         => r.Emp_Edu_Id,
                 i_New_Id         => r_Person_Edu_Stage.Person_Edu_Stage_Id);
    end loop;
  
    for r in (select *
                from Old_Vx_Hr_Emp_Dependents d
               where d.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'person_id'
                         and Uk.Old_Id = d.Employee_Id)
                 and not exists (select *
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'family_member_id'
                         and p.Old_Id = d.Emp_Dependent_Id))
    loop
      r_Person_Family_Member.Company_Id := i_New_Company_Id;
      r_Person_Family_Member.Person_Id  := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                      i_Key_Name       => 'person_id',
                                                      i_Old_Id         => r.Employee_Id);
    
      r_Person_Family_Member.Person_Family_Member_Id := Href_Next.Person_Family_Member_Id;
    
      r_Person_Family_Member.Name := Mr_Util.Gen_Name(i_First_Name  => r.First_Name,
                                                      i_Last_Name   => r.Last_Name,
                                                      i_Middle_Name => r.Middle_Name);
    
      r_Person_Family_Member.Is_Dependent := 'N';
      if r.Relationship = 'C' then
        r_Person_Family_Member.Is_Dependent := 'Y';
      end if;
    
      r_Person_Family_Member.Is_Private := 'Y';
    
      r_Person_Family_Member.Birthday := r.Birthday;
    
      continue when not z_Md_Persons.Exist(i_Company_Id => i_New_Company_Id,
                                           i_Person_Id  => r_Person_Document.Person_Id);
    
      Href_Api.Person_Family_Member_Save(r_Person_Family_Member);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'family_member_id', --
                 i_Old_Id         => r.Emp_Dependent_Id,
                 i_New_Id         => r_Person_Family_Member.Person_Family_Member_Id);
    end loop;
  
    for r in (select *
                from Old_Vx_Hr_Emp_Documents d
               where d.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'person_id'
                         and Uk.Old_Id = d.Employee_Id)
                 and not exists (select *
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'emp_document_id'
                         and p.Old_Id = d.Emp_Doc_Id))
    loop
      r_Person_Document.Company_Id  := i_New_Company_Id;
      r_Person_Document.Document_Id := Href_Next.Person_Document_Id;
      r_Person_Document.Person_Id   := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                  i_Key_Name       => 'person_id',
                                                  i_Old_Id         => r.Employee_Id);
      r_Person_Document.Doc_Type_Id := Get_Doc_Type_Id(i_New_Company_Id  => i_New_Company_Id,
                                                       i_Old_Doc_Type_Id => r.Doc_Type_Id);
      r_Person_Document.Doc_Series  := r.Doc_Series;
      r_Person_Document.Doc_Number  := r.Doc_Number;
      r_Person_Document.Issued_By   := r.Issued_By;
      r_Person_Document.Issued_Date := r.Issued_Date;
      r_Person_Document.Begin_Date  := r.Begin_Date;
      r_Person_Document.Expiry_Date := r.Expiry_Date;
      r_Person_Document.Note        := r.Note;
    
      continue when not z_Md_Persons.Exist(i_Company_Id => i_New_Company_Id,
                                           i_Person_Id  => r_Person_Document.Person_Id);
    
      Href_Api.Person_Document_Save(r_Person_Document);
    
      Href_Api.Person_Document_File_Delete(i_Company_Id  => r_Person_Document.Company_Id,
                                           i_Document_Id => r_Person_Document.Document_Id,
                                           i_Sha         => r.Sha);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'emp_document_id', --
                 i_Old_Id         => r.Emp_Doc_Id,
                 i_New_Id         => r_Person_Document.Document_Id);
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Persons', 'finished Migr_Persons');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Locations_And_Devices
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    r_Location_Type Htt_Location_Types%rowtype;
  
    r_Location Htt_Locations%rowtype;
  
    r_Device Htt_Devices%rowtype;
    v_Zktime Hzk_Pref.Zktime_Rt;
  
    v_Zkteco_Model_Id number;
  
    v_Device_Type varchar2(20);
    v_Filial_Id   number;
    v_Location_Id number;
    v_Total       number;
  
    --------------------------------------------------
    Function Get_Location_Id(i_Name varchar2) return number is
      v_Location_Id number;
    begin
      begin
        select Lc.Location_Id
          into v_Location_Id
          from Htt_Locations Lc
         where Lc.Company_Id = i_New_Company_Id
           and Lower(Lc.Name) = Lower(i_Name)
           and Rownum = 1;
      
      exception
        when No_Data_Found then
          v_Location_Id := Htt_Next.Location_Id;
      end;
    
      return v_Location_Id;
    end;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Org_Location_Types t
     where t.Company_Id = i_Old_Company_Id;
  
    for r in (select l.*, Rownum
                from Old_Vx_Org_Location_Types l
               where l.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'location_type_id'
                         and Uk.Old_Id = l.Location_Type_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' locations types out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        r_Location_Type.Company_Id       := i_New_Company_Id;
        r_Location_Type.Location_Type_Id := Htt_Next.Location_Type_Id;
        r_Location_Type.Name             := r.Name;
        r_Location_Type.Color            := r.Color;
        r_Location_Type.State            := r.State;
        r_Location_Type.Code             := r.Code;
      
        Htt_Api.Location_Type_Save(r_Location_Type);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'location_type_id', --
                   i_Old_Id         => r.Location_Type_Id,
                   i_New_Id         => r_Location_Type.Location_Type_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Org_Location_Types',
                    i_Key_Id         => r.Location_Type_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Org_Locations q
     where q.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'location_id'
               and Uk.Old_Id = q.Location_Id);
  
    for r in (select l.*, Rownum
                from Old_Vx_Org_Locations l
               where l.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'location_id'
                         and Uk.Old_Id = l.Location_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' locations out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        r_Location.Company_Id := i_New_Company_Id;
      
        if g_Samsung_Kz = i_New_Company_Id then
          r_Location.Location_Id := Get_Location_Id(r.Name);
        else
          r_Location.Location_Id := Htt_Next.Location_Id;
        end if;
      
        r_Location.Name             := r.Name;
        r_Location.Location_Type_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                  i_Key_Name       => 'location_type_id',
                                                  i_Old_Id         => r.Location_Type_Id);
        r_Location.Timezone_Code    := r.Timezone_Code;
        r_Location.Region_Id        := Get_Region_Id(i_New_Company_Id => i_New_Company_Id,
                                                     i_Old_Region_Id  => r.Region_Id);
        r_Location.Address          := r.Address;
        r_Location.Accuracy         := r.Accuracy;
        r_Location.Latlng           := r.Latlng;
        r_Location.State            := r.State;
        r_Location.Code             := r.Code;
      
        Htt_Api.Location_Save(r_Location);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'location_id', --
                   i_Old_Id         => r.Location_Id,
                   i_New_Id         => r_Location.Location_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Org_Locations',
                    i_Key_Id         => r.Location_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    select count(*)
      into v_Total
      from Htt_Locations q
     where q.Company_Id = i_New_Company_Id
       and exists (select 1
              from Migr_Keys_Store_One Ks
             where Ks.Company_Id = i_New_Company_Id
               and Ks.Key_Name = 'location_id'
               and Ks.New_Id = q.Location_Id)
       and not exists (select 1
              from Htt_Location_Filials Lf
             where Lf.Company_Id = q.Company_Id
               and Lf.Filial_Id = i_Filial_Id
               and Lf.Location_Id = q.Location_Id);
  
    for r in (select q.*, Rownum
                from Htt_Locations q
               where q.Company_Id = i_New_Company_Id
                 and exists (select 1
                        from Migr_Keys_Store_One Ks
                       where Ks.Company_Id = i_New_Company_Id
                         and Ks.Key_Name = 'location_id'
                         and Ks.New_Id = q.Location_Id)
                 and not exists (select 1
                        from Htt_Location_Filials Lf
                       where Lf.Company_Id = q.Company_Id
                         and Lf.Filial_Id = i_Filial_Id
                         and Lf.Location_Id = q.Location_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' location_filials out of ' ||
                                       v_Total);
    
      Htt_Api.Location_Add_Filial(i_Company_Id  => i_New_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Location_Id => r.Location_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Org_Location_Persons Lp
      join Old_Vx_Hr_Employees t
        on t.Company_Id = Lp.Company_Id
       and t.Employee_Id = Lp.Person_Id
       and t.Subcompany_Id = i_Subcompany_Id
     where Lp.Company_Id = i_Old_Company_Id
       and exists (select 1
              from Migr_Used_Keys p
             where p.Company_Id = i_New_Company_Id
               and p.Key_Name = 'location_id'
               and p.Old_Id = Lp.Location_Id)
       and exists (select 1
              from Migr_Used_Keys q
             where q.Company_Id = i_New_Company_Id
               and q.Key_Name = 'person_id'
               and q.Old_Id = Lp.Person_Id);
  
    for r in (select Lp.*, Rownum
                from Old_Vx_Org_Location_Persons Lp
                join Old_Vx_Hr_Employees t
                  on t.Company_Id = Lp.Company_Id
                 and t.Employee_Id = Lp.Person_Id
                 and t.Subcompany_Id = i_Subcompany_Id
               where Lp.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'location_id'
                         and p.Old_Id = Lp.Location_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'person_id'
                         and q.Old_Id = Lp.Person_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' location_persons out of ' ||
                                       v_Total);
      v_Location_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                  i_Key_Name       => 'location_id',
                                  i_Old_Id         => r.Location_Id);
    
      if v_Location_Id is not null then
        Htt_Api.Location_Add_Person(i_Company_Id  => i_New_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Location_Id => v_Location_Id,
                                    i_Person_Id   => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                i_Key_Name       => 'person_id',
                                                                i_Old_Id         => r.Person_Id));
      end if;
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Division_Locations Dl
     where Dl.Company_Id = i_Old_Company_Id
       and Dl.Division_Id in (select p.Division_Id
                                from Old_Vx_Hr_Divisions p
                               where p.Company_Id = i_Old_Company_Id
                              connect by prior p.Division_Id = p.Parent_Id
                               start with p.Division_Id = i_Subcompany_Id)
       and exists (select 1
              from Migr_Used_Keys p
             where p.Company_Id = i_New_Company_Id
               and p.Key_Name = 'location_id'
               and p.Old_Id = Dl.Location_Id)
       and exists (select 1
              from Migr_Used_Keys q
             where q.Company_Id = i_New_Company_Id
               and q.Key_Name in ('division_id', 'filial_id')
               and q.Old_Id = Dl.Division_Id);
  
    for r in (select Dl.*, Rownum
                from Old_Vx_Hr_Division_Locations Dl
               where Dl.Company_Id = i_Old_Company_Id
                 and Dl.Division_Id in
                     (select p.Division_Id
                        from Old_Vx_Hr_Divisions p
                       where p.Company_Id = i_Old_Company_Id
                      connect by prior p.Division_Id = p.Parent_Id
                       start with p.Division_Id = i_Subcompany_Id)
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'location_id'
                         and p.Old_Id = Dl.Location_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name in ('division_id', 'filial_id')
                         and q.Old_Id = Dl.Division_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' location_divisions out of ' || v_Total);
    
      v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'filial_id',
                                i_Old_Id         => r.Division_Id);
      -- this division is filial
      if v_Filial_Id is not null then
        if g_Dummy_Division_Fix_Mode then
          r.Division_Id := -v_Filial_Id;
          if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'division_id',
                        i_Old_Id         => r.Division_Id) is null then
            Add_Division(i_New_Company_Id  => i_New_Company_Id,
                         i_Old_Division_Id => r.Division_Id,
                         i_Filial_Id       => v_Filial_Id,
                         i_Name            => 'DUMMY',
                         i_Parent_Id       => null,
                         i_State           => 'A',
                         i_Code            => null);
          end if;
        else
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Division_Locations',
                    i_Key_Id         => r.Division_Id,
                    i_Error_Message  => 'fix divisions in Vx_Hr_Division_Locations, division_id=' ||
                                        r.Division_Id);
          continue;
        end if;
      end if;
    
      v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'division_filial_id', --
                                i_Old_Id         => r.Division_Id);
    
      v_Location_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                  i_Key_Name       => 'location_id',
                                  i_Old_Id         => r.Location_Id);
    
      if v_Location_Id is not null then
        continue when v_Filial_Id <> i_Filial_Id;
      
        Htt_Api.Location_Add_Division(i_Company_Id  => i_New_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Location_Id => v_Location_Id,
                                      i_Division_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                  i_Key_Name       => 'division_id',
                                                                  i_Old_Id         => r.Division_Id));
      end if;
    end loop;
  
    begin
      select p.Model_Id
        into v_Zkteco_Model_Id
        from Htt_Terminal_Models p
       where p.Pcode = Htt_Pref.c_Pcode_Zkteco_F18;
    exception
      when No_Data_Found then
        null;
    end;
  
    select count(*)
      into v_Total
      from Old_Vx_Org_Devices d
     where d.Company_Id = i_Old_Company_Id
       and not exists
     (select 1
              from Migr_Used_Keys p
             where p.Company_Id = i_New_Company_Id
               and p.Key_Name = 'device_id'
               and p.Old_Id = d.Device_Id)
       and (exists (select 1
                      from Migr_Used_Keys q
                     where q.Company_Id = i_New_Company_Id
                       and q.Key_Name = 'location_id'
                       and q.Old_Id = d.Location_Id) or d.Location_Id is null);
  
    for r in (select d.*, Rownum
                from Old_Vx_Org_Devices d
               where d.Company_Id = i_Old_Company_Id
                 and not exists
               (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'device_id'
                         and p.Old_Id = d.Device_Id)
                 and (exists (select 1
                                from Migr_Used_Keys q
                               where q.Company_Id = i_New_Company_Id
                                 and q.Key_Name = 'location_id'
                                 and q.Old_Id = d.Location_Id) or d.Location_Id is null))
    loop
      Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                       'inserted ' || (r.Rownum - 1) || ' devices out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.Device_Kind in ('C', 'H') then
          continue;
        end if;
      
        case r.Device_Kind
          when 'T' then
            v_Device_Type := Htt_Pref.c_Pcode_Device_Type_Terminal;
          when 'P' then
            v_Device_Type := Htt_Pref.c_Pcode_Device_Type_Timepad;
          else
            v_Device_Type := Htt_Pref.c_Pcode_Device_Type_Staff;
        end case;
      
        r_Device.Company_Id     := i_New_Company_Id;
        r_Device.Device_Id      := Htt_Next.Device_Id;
        r_Device.Name           := r.Name;
        r_Device.Device_Type_Id := Htt_Util.Device_Type_Id(v_Device_Type);
        r_Device.Location_Id    := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                              i_Key_Name       => 'location_id',
                                              i_Old_Id         => r.Location_Id);
        r_Device.Serial_Number  := r.Serial_Number;
        r_Device.Lang_Code      := 'ru';
        r_Device.Use_Settings   := 'N';
        r_Device.State          := r.State;
      
        if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
          v_Zktime.Company_Id    := r_Device.Company_Id;
          v_Zktime.Device_Id     := r_Device.Device_Id;
          v_Zktime.Model_Id      := v_Zkteco_Model_Id;
          v_Zktime.Serial_Number := r_Device.Serial_Number;
          v_Zktime.Name          := r_Device.Name;
          v_Zktime.Location_Id   := r_Device.Location_Id;
          v_Zktime.State         := r_Device.State;
        
          Hzk_Api.Device_Add(v_Zktime);
        else
          Htt_Api.Device_Add(r_Device);
        end if;
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'device_id', --
                   i_Old_Id         => r.Device_Id,
                   i_New_Id         => r_Device.Device_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Org_Devices',
                    i_Key_Id         => r.Device_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Locations_And_Devices',
                                     'finished Migr_Locations_And_Devices');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Users
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_User   Md_Users%rowtype;
    r_Person Mr_Natural_Persons%rowtype;
    v_Total  number;
  begin
    select count(*)
      into v_Total
      from Old_Md_Users Ou
     where Company_Id = i_Old_Company_Id
       and Ou.User_Kind <> Md_Pref.Uk_Virtual
       and not exists (select 1
              from Old_Vx_Org_Persons Op
             where Op.Company_Id = Ou.Company_Id
               and Op.Person_Id = Ou.User_Id)
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'user_id'
               and Uk.Old_Id = Ou.User_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Users', 'total uncounted users: ' || v_Total);
  
    for r in (select *
                from Old_Md_Users Ou
               where Ou.Company_Id = i_Old_Company_Id
                 and Ou.User_Kind <> Md_Pref.Uk_Virtual
                 and not exists (select 1
                        from Old_Vx_Org_Persons Op
                       where Op.Company_Id = Ou.Company_Id
                         and Op.Person_Id = Ou.User_Id)
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'user_id'
                         and Uk.Old_Id = Ou.User_Id))
    loop
      begin
        savepoint Try_Catch;
      
        r_User.Company_Id               := i_New_Company_Id;
        r_User.User_Id                  := Md_Next.Person_Id;
        r_User.User_Kind                := r.User_Kind;
        r_User.Name                     := r.Name;
        r_User.Gender                   := r.Gender;
        r_User.Login                    := r.Login;
        r_User.Password                 := r.Password;
        r_User.Password_Changed_On      := r.Password_Changed_On;
        r_User.Password_Change_Required := r.Password_Change_Required;
        r_User.State                    := r.State;
        r_User.Timezone_Code            := r.Timezone_Code;
      
        Md_Api.Person_Save(i_Company_Id => r_User.Company_Id,
                           i_Person_Id  => r_User.User_Id,
                           i_Name       => r_User.Name,
                           i_State      => r_User.State,
                           Is_Legal     => false);
      
        r_Person.Company_Id := r_User.Company_Id;
        r_Person.Person_Id  := r_User.User_Id;
        r_Person.Name       := r_User.Name;
        r_Person.First_Name := r_User.Name;
        r_Person.Gender     := r_User.Gender;
        r_Person.State      := r_User.State;
      
        Mr_Api.Natural_Person_Save(r_Person);
      
        Md_Api.User_Save(r_User);
      
        for f in 1 .. g_Filial_Ids.Count
        loop
          Md_Api.User_Add_Filial(i_Company_Id => i_New_Company_Id,
                                 i_User_Id    => r_User.User_Id,
                                 i_Filial_Id  => g_Filial_Ids(f));
        end loop;
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'user_id', --
                        i_Key_Id         => r.User_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Md_Users',
                    i_Key_Id         => r.User_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Users', 'finished Migr_Users');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Tracks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number,
    i_Migr_Since     date := to_date('01.01.2000', 'dd.mm.yyyy')
  ) is
    r_Track Htt_Tracks%rowtype;
  
    v_Track_Type varchar2(1);
    v_Total      number;
  
    v_Timesheet_Id number;
  
    --------------------------------------------------
    Procedure Track_Add(i_Track Htt_Tracks%rowtype) is
      r_Track         Htt_Tracks%rowtype := i_Track;
      r_Location      Htt_Locations%rowtype;
      v_Timezone_Code Md_Timezones.Timezone_Code%type := Htt_Util.Load_Timezone(i_Company_Id => i_Track.Company_Id,
                                                                                i_Filial_Id  => i_Track.Filial_Id);
    
      --------------------------------------------------
      Function Track_Exists return boolean is
        v_Dummy varchar2(1);
      begin
        if r_Track.Device_Id is not null then
          select 'x'
            into v_Dummy
            from Htt_Tracks q
           where q.Company_Id = r_Track.Company_Id
             and q.Filial_Id = r_Track.Filial_Id
             and q.Track_Time = r_Track.Track_Time
             and q.Person_Id = r_Track.Person_Id
             and q.Device_Id = r_Track.Device_Id
             and q.Original_Type = r_Track.Original_Type;
        else
          select 'x'
            into v_Dummy
            from Htt_Tracks q
           where q.Company_Id = r_Track.Company_Id
             and q.Filial_Id = r_Track.Filial_Id
             and q.Track_Time = r_Track.Track_Time
             and q.Person_Id = r_Track.Person_Id
             and q.Original_Type = r_Track.Original_Type;
        end if;
      
        return true;
      exception
        when No_Data_Found then
          return false;
      end;
    begin
      if r_Track.Latlng is null and r_Track.Location_Id is not null then
        r_Location := z_Htt_Locations.Load(i_Company_Id  => r_Track.Company_Id,
                                           i_Location_Id => r_Track.Location_Id);
      
        r_Track.Latlng   := r_Location.Latlng;
        r_Track.Accuracy := r_Location.Accuracy;
      end if;
    
      r_Track.Track_Datetime := Htt_Util.Timestamp_To_Date(i_Timestamp => r_Track.Track_Time,
                                                           i_Timezone  => v_Timezone_Code);
      r_Track.Track_Date     := Trunc(r_Track.Track_Datetime);
      r_Track.Is_Valid       := Nvl(r_Track.Is_Valid, 'Y');
      r_Track.Status         := Htt_Pref.c_Track_Status_Draft;
      r_Track.Original_Type  := r_Track.Track_Type;
    
      if Track_Exists then
        return;
      end if;
    
      if Htt_Util.Is_Track_Accepted_Period(i_Company_Id  => r_Track.Company_Id,
                                           i_Filial_Id   => r_Track.Filial_Id,
                                           i_Employee_Id => r_Track.Person_Id,
                                           i_Period      => r_Track.Track_Date) = 'Y' then
        z_Htt_Tracks.Insert_Row(r_Track);
      
        /*if Md_Pref.c_Migr_Company_Id != i_Track.Company_Id then
          if r_Track.Is_Valid = 'Y' then
            Htt_Core.Track_Add(i_Company_Id     => r_Track.Company_Id,
                               i_Filial_Id      => r_Track.Filial_Id,
                               i_Track_Id       => r_Track.Track_Id,
                               i_Employee_Id    => r_Track.Person_Id,
                               i_Track_Datetime => r_Track.Track_Datetime,
                               i_Track_Type     => r_Track.Track_Type);
          end if;
        end if;*/
      else
        Htt_Core.Trash_Track_Insert(r_Track);
      end if;
    end;
  
    --------------------------------------------------
    Function Get_Timesheet_Id
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Employee_Id number,
      i_Date        date
    ) return number is
      result number;
    begin
      select p.Timesheet_Id
        into result
        from Htt_Timesheets p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Employee_Id = i_Employee_Id
         and p.Timesheet_Date = i_Date
         and Rownum = 1;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Org_Tracks t
      join Old_Vx_Hr_Employees Ep
        on Ep.Company_Id = t.Company_Id
       and Ep.Employee_Id = t.Person_Id
      -- and Ep.Subcompany_Id = i_Subcompany_Id
      join Migr_Keys_Store_One p
        on p.Company_Id = i_New_Company_Id
       and p.Key_Name = 'person_id'
       and p.Old_Id = t.Person_Id
      join Mhr_Employees Emp
        on Emp.Company_Id = i_New_Company_Id
       and Emp.Filial_Id = i_Filial_Id
       and Emp.Employee_Id = p.New_Id
     where t.Company_Id = i_Old_Company_Id
       and t.Track_Date >= i_Migr_Since
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'track_id'
               and St.Filial_Id = i_Filial_Id
               and St.Old_Id = t.Track_Id);
  
    for r in (select t.*, Emp.Filial_Id, Rownum
                from Old_Vx_Org_Tracks t
                join Old_Vx_Hr_Employees Ep
                  on Ep.Company_Id = t.Company_Id
                 and Ep.Employee_Id = t.Person_Id
                 --and Ep.Subcompany_Id = i_Subcompany_Id
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.Old_Id = t.Person_Id
                join Mhr_Employees Emp
                  on Emp.Company_Id = i_New_Company_Id
                 and Emp.Filial_Id = i_Filial_Id
                 and Emp.Employee_Id = p.New_Id
               where t.Company_Id = i_Old_Company_Id
                 and t.Track_Date >= i_Migr_Since
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'track_id'
                         and St.Filial_Id = i_Filial_Id
                         and St.Old_Id = t.Track_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Tracks',
                                       'inserted ' || (r.Rownum - 1) || ' tracks out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        case r.Track_Type
          when 'I' then
            v_Track_Type := Htt_Pref.c_Track_Type_Input;
          when 'O' then
            v_Track_Type := Htt_Pref.c_Track_Type_Output;
          else
            v_Track_Type := Htt_Pref.c_Track_Type_Check;
        end case;
      
        r_Track.Company_Id     := i_New_Company_Id;
        r_Track.Person_Id      := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                             i_Key_Name       => 'person_id', --
                                             i_Old_Id         => r.Person_Id);
        r_Track.Track_Type     := v_Track_Type;
        r_Track.Mark_Type      := r.Mark_Type;
        r_Track.Track_Date     := r.Track_Date;
        r_Track.Track_Datetime := r.Track_Datetime;
        r_Track.Track_Time     := r.Track_Time;
        r_Track.Latlng         := r.Latlng;
        r_Track.Accuracy       := r.Accuracy;
        r_Track.Photo_Sha      := r.Photo_Sha;
        r_Track.Note           := r.Note;
        r_Track.Is_Valid       := r.Valid;
      
        r_Track.Filial_Id   := i_Filial_Id;
        r_Track.Track_Id    := Htt_Next.Track_Id;
        r_Track.Device_Id   := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                          i_Key_Name       => 'device_id',
                                          i_Old_Id         => r.Device_Id);
        r_Track.Location_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                          i_Key_Name       => 'location_id', --
                                          i_Old_Id         => r.Location_Id);
      
        -- Htt_Api.Track_Add(r_Track);
      
        Track_Add(r_Track);
      
        v_Timesheet_Id := Get_Timesheet_Id(i_Company_Id  => r_Track.Company_Id,
                                           i_Filial_Id   => r_Track.Filial_Id,
                                           i_Employee_Id => r_Track.Person_Id,
                                           i_Date        => Trunc(r_Track.Track_Date));
      
        if v_Timesheet_Id is not null then
          Htt_Core.Make_Dirty_Timesheet(i_Company_Id   => r_Track.Company_Id,
                                        i_Filial_Id    => r_Track.Filial_Id,
                                        i_Timesheet_Id => v_Timesheet_Id);
        end if;
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'track_id', --
                   i_Old_Id         => r.Track_Id,
                   i_New_Id         => r_Track.Track_Id,
                   i_Filial_Id      => r_Track.Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Org_Tracks',
                    i_Key_Id         => r.Track_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Tracks', 'finished Migr_Tracks');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Schedules
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number
  ) is
    v_Schedule          Htt_Pref.Schedule_Rt;
    v_Dummy_Schedule    Htt_Pref.Schedule_Rt;
    v_Schedule_Day      Htt_Pref.Schedule_Day_Rt;
    v_Pattern           Htt_Pref.Schedule_Pattern_Rt;
    v_Pattern_Day       Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Marks             Htt_Pref.Mark_Nt;
    v_Day_Marks         Htt_Pref.Schedule_Day_Marks_Rt;
    v_Current_Day       date;
    v_Last_Day          date := Add_Months(Trunc(sysdate, 'year'), 12);
    v_First_Day         date := Trunc(sysdate, 'year');
    v_Start_Day         date;
    v_Plan_Time         number;
    v_Shift             number;
    v_Input_Acceptance  number;
    v_Output_Acceptance number;
    v_Total             number;
    v_Check_Break_Begin number;
    v_Check_Break_End   number;
    v_Check_Begin       number;
    v_Check_End         number;
  
    --     v_Used_Filials Array_Number;
    --     v_New_Filials  Array_Number;
  
    -------------------------------------------------- 
    Function Name_Used(i_Schedule Htt_Pref.Schedule_Rt) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Schedules s
       where s.Company_Id = i_Schedule.Company_Id
         and s.Filial_Id = i_Schedule.Filial_Id
         and Lower(s.Name) = Lower(i_Schedule.Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    -- TODO: migr vx_ref_location_schedules, vx_ref_schedule_marks
    /*select St.Filial_Id
      bulk collect
      into v_Used_Filials
      from Migr_Keys_Store_Two St
     where St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'schedule_id';
    
    v_New_Filials := g_Filial_Ids multiset Except v_Used_Filials;*/
  
    select count(*)
      into v_Total
      from Old_Vx_Ref_Schedules s
     where s.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'schedule_id'
               and St.Old_Id = s.Schedule_Id
               and St.Filial_Id = i_Filial_Id);
  
    for r in (select s.*, Rownum
                from Old_Vx_Ref_Schedules s
               where s.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'schedule_id'
                         and St.Old_Id = s.Schedule_Id
                         and St.Filial_Id = i_Filial_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedules',
                                       'inserted ' || (r.Rownum - 1) || ' schedules out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        v_Shift             := Nvl(r.Daily_Shift_Time, 0);
        v_Input_Acceptance  := 0;
        v_Output_Acceptance := 0;
      
        if r.Shift_Kind <> 'L' then
          select Nvl(min(Begin_Time), v_Shift)
            into v_Shift
            from Old_Vx_Ref_Schedule_Days
           where Company_Id = i_Old_Company_Id
             and Schedule_Id = r.Schedule_Id
             and exists
           (select *
                    from Old_Vx_Ref_Schedule_Days Sd
                   where Sd.Company_Id = i_Old_Company_Id
                     and Sd.Schedule_Id = r.Schedule_Id
                     and (Sd.Begin_Time < v_Shift or Sd.End_Time > v_Shift + 1440 or
                         Sd.End_Time + 1440 > v_Shift + 1440 and Sd.Begin_Time >= Sd.End_Time));
        end if;
      
        if r.Shift_Kind = 'L' then
          select min(Begin_Time)
            into v_Shift
            from Old_Vx_Ref_Schedule_Days
           where Company_Id = i_Old_Company_Id
             and Schedule_Id = r.Schedule_Id;
        
          r.Before_Begin_Time := Least(r.Before_Begin_Time, 480);
          r.After_End_Time    := Least(r.After_End_Time, 480);
        
          v_Input_Acceptance  := r.Before_Begin_Time;
          v_Output_Acceptance := r.After_End_Time;
        end if;
      
        Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Pattern,
                                      i_Schedule_Kind  => r.Schedule_Kind,
                                      i_All_Days_Equal => r.All_Days_Equal,
                                      i_Count_Days     => r.Count_Days);
        for Pd in (select *
                     from Old_Vx_Ref_Schedule_Days
                    where Company_Id = i_Old_Company_Id
                      and Schedule_Id = r.Schedule_Id
                    order by Day_No)
        loop
          if Pd.Begin_Time > Pd.Begin_Break_Time and Pd.Break_Time = 'Y' then
            v_Check_Break_Begin := Pd.Begin_Break_Time + 1440;
            v_Check_Break_End   := Pd.End_Break_Time;
          
            if v_Check_Break_Begin >= v_Check_Break_End then
              v_Check_Break_End := v_Check_Break_End + 1440;
            end if;
          
            /*if Pd.Begin_Time > v_Check_Break_Begin or v_Check_Break_End > Pd.End_Time then
              Pd.Begin_Break_Time := Pd.Begin_Time + 1;
              Pd.End_Break_Time   := Pd.Begin_Time + 2;
            end if;*/
          end if;
        
          v_Check_Begin       := Pd.Begin_Time;
          v_Check_End         := Pd.End_Time;
          v_Check_Break_Begin := Pd.Begin_Break_Time;
          v_Check_Break_End   := Pd.End_Break_Time;
        
          if Pd.Day_Kind = 'W' then
            if v_Check_End <= v_Check_Begin then
              v_Check_End := v_Check_End + 1440;
            end if;
          
            if v_Check_Break_End <= v_Check_Break_Begin then
              v_Check_Break_End := v_Check_Break_End + 1440;
            end if;
          
            v_Plan_Time := v_Check_End - v_Check_Begin;
          
            if Pd.Break_Time = 'Y' then
              v_Plan_Time := v_Plan_Time - Nvl(v_Check_Break_End - v_Check_Break_Begin, 0);
            end if;
          
            if v_Shift + 1440 < v_Check_End then
              Pd.End_Time := Pd.End_Time - 1;
              v_Plan_Time := v_Plan_Time - 1;
            end if;
          else
            v_Plan_Time := 0;
          end if;
        
          if r.Schedule_Mode <> 'S' and Nvl(Pd.Fixed_Time, 0) < v_Plan_Time then
            v_Plan_Time := Nvl(Pd.Fixed_Time, 0);
          end if;
        
          select mod(Sm.Begin_Time, 1440), mod(Sm.End_Time, 1440)
            bulk collect
            into v_Marks
            from Old_Vx_Ref_Schedule_Marks Sm
           where Sm.Company_Id = Pd.Company_Id
             and Sm.Schedule_Id = Pd.Schedule_Id
             and Sm.Day_No = Pd.Day_No;
        
          Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
                                            i_Day_No           => Pd.Day_No,
                                            i_Day_Kind         => Pd.Day_Kind,
                                            i_Begin_Time       => Pd.Begin_Time,
                                            i_End_Time         => Pd.End_Time,
                                            i_Break_Enabled    => Pd.Break_Time,
                                            i_Break_Begin_Time => Pd.Begin_Break_Time,
                                            i_Break_End_Time   => Pd.End_Break_Time,
                                            i_Plan_Time        => v_Plan_Time);
        
          v_Pattern_Day.Pattern_Marks := v_Marks;
        
          Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Pattern, --
                                            i_Day              => v_Pattern_Day);
        end loop;
      
        v_Dummy_Schedule.Days  := Htt_Pref.Schedule_Day_Nt();
        v_Dummy_Schedule.Marks := Htt_Pref.Schedule_Day_Marks_Nt();
      
        v_Current_Day := v_First_Day;
      
        if v_Pattern.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Weekly then
          v_Start_Day := Trunc(v_First_Day, 'IW');
        else
          v_Start_Day := v_First_Day;
        end if;
      
        while v_Current_Day != v_Last_Day
        loop
          v_Pattern_Day := v_Pattern.Pattern_Day((v_Current_Day - v_Start_Day) mod
                                                 v_Pattern.Count_Days + 1);
        
          Htt_Util.Schedule_Day_New(o_Day              => v_Schedule_Day,
                                    i_Schedule_Date    => v_Current_Day,
                                    i_Day_Kind         => v_Pattern_Day.Day_Kind,
                                    i_Begin_Time       => v_Pattern_Day.Begin_Time,
                                    i_End_Time         => v_Pattern_Day.End_Time,
                                    i_Break_Enabled    => v_Pattern_Day.Break_Enabled,
                                    i_Break_Begin_Time => v_Pattern_Day.Break_Begin_Time,
                                    i_Break_End_Time   => v_Pattern_Day.Break_End_Time,
                                    i_Plan_Time        => v_Pattern_Day.Plan_Time);
        
          Htt_Util.Schedule_Day_Add(o_Schedule => v_Dummy_Schedule, i_Day => v_Schedule_Day);
        
          Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                          i_Schedule_Date      => v_Current_Day);
          v_Day_Marks.Marks := v_Pattern_Day.Pattern_Marks;
        
          Htt_Util.Schedule_Day_Marks_Add(o_Schedule  => v_Dummy_Schedule,
                                          i_Day_Marks => v_Day_Marks);
        
          v_Current_Day := v_Current_Day + 1;
        end loop;
      
        Htt_Util.Schedule_New(o_Schedule          => v_Schedule,
                              i_Company_Id        => i_New_Company_Id,
                              i_Filial_Id         => i_Filial_Id,
                              i_Schedule_Id       => Htt_Next.Schedule_Id,
                              i_Name              => r.Name,
                              i_Calendar_Id       => null,
                              i_Take_Holidays     => 'N',
                              i_Take_Nonworking   => 'N',
                              i_Shift             => v_Shift,
                              i_Input_Acceptance  => v_Input_Acceptance,
                              i_Output_Acceptance => v_Output_Acceptance,
                              i_Track_Duration    => 1440 + v_Input_Acceptance + v_Output_Acceptance,
                              i_Count_Late        => 'Y',
                              i_Count_Early       => 'Y',
                              i_Count_Lack        => 'Y',
                              i_State             => r.State,
                              i_Code              => r.Code,
                              i_Year              => Extract(year from sysdate));
      
        v_Schedule.Pattern := v_Pattern;
        v_Schedule.Days    := v_Dummy_Schedule.Days;
        v_Schedule.Marks   := v_Dummy_Schedule.Marks;
      
        if Name_Used(v_Schedule) then
          v_Schedule.Name := v_Schedule.Name || ':' || v_Schedule.Schedule_Id;
        end if;
      
        Htt_Api.Schedule_Save(v_Schedule);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'schedule_id', --
                   i_Old_Id         => r.Schedule_Id,
                   i_New_Id         => v_Schedule.Schedule_Id,
                   i_Filial_Id      => v_Schedule.Filial_Id);
      
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Ref_Schedules',
                    i_Key_Id         => r.Schedule_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedules', 'finished Migr_Schedules');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_References
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_Institution      Href_Institutions%rowtype;
    r_Edu_Stage        Href_Edu_Stages%rowtype;
    r_Dismissal_Reason Href_Dismissal_Reasons%rowtype;
    r_Document_Type    Href_Document_Types%rowtype;
    v_Total            number;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Hr_Institutions Hi
     where Hi.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'institution_id'
               and Uk.Old_Id = Hi.Institution_Id);
  
    Dbms_Application_Info.Set_Module('Migr_References',
                                     'inserting institutions, total num: ' || v_Total);
  
    for r in (select Hi.*
                from Old_Vx_Hr_Institutions Hi
               where Hi.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'institution_id'
                         and Uk.Old_Id = Hi.Institution_Id))
    loop
      r_Institution.Company_Id     := i_New_Company_Id;
      r_Institution.Institution_Id := Href_Next.Institution_Id;
      r_Institution.Name           := r.Name;
      r_Institution.State          := r.State;
    
      Href_Api.Institution_Save(r_Institution);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'institution_id',
                 i_Old_Id         => r.Institution_Id,
                 i_New_Id         => r_Institution.Institution_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Edu_Degrees Ed
     where Ed.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'edu_stage_id'
               and Uk.Old_Id = Ed.Degree_Id);
  
    Dbms_Application_Info.Set_Module('Migr_References',
                                     'inserting edu degrees, total num: ' || v_Total);
  
    for r in (select Ed.*
                from Old_Vx_Hr_Edu_Degrees Ed
               where Ed.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'edu_stage_id'
                         and Uk.Old_Id = Ed.Degree_Id))
    loop
      r_Edu_Stage.Company_Id   := i_New_Company_Id;
      r_Edu_Stage.Edu_Stage_Id := Href_Next.Edu_Stage_Id;
      r_Edu_Stage.Name         := r.Name;
      r_Edu_Stage.State        := r.State;
    
      Href_Api.Edu_Stage_Save(r_Edu_Stage);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'edu_stage_id',
                 i_Old_Id         => r.Degree_Id,
                 i_New_Id         => r_Edu_Stage.Edu_Stage_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Dismissal_Reasons Dr
     where Dr.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'dismissal_reason_id'
               and Uk.Old_Id = Dr.Reason_Id);
  
    Dbms_Application_Info.Set_Module('Migr_References',
                                     'inserting dismissal reasons, total num: ' || v_Total);
  
    for r in (select Dr.*
                from Old_Vx_Hr_Dismissal_Reasons Dr
               where Dr.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'dismissal_reason_id'
                         and Uk.Old_Id = Dr.Reason_Id))
    loop
      r_Dismissal_Reason.Company_Id          := i_New_Company_Id;
      r_Dismissal_Reason.Dismissal_Reason_Id := Href_Next.Dismissal_Reason_Id;
      r_Dismissal_Reason.Name                := r.Name;
      r_Dismissal_Reason.Reason_Type         := r.Reason_Kind;
    
      Href_Api.Dismissal_Reason_Save(r_Dismissal_Reason);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'dismissal_reason_id',
                 i_Old_Id         => r.Reason_Id,
                 i_New_Id         => r_Dismissal_Reason.Dismissal_Reason_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Document_Types Dt
     where Dt.Company_Id = i_Old_Company_Id
       and Dt.Pcode is null
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'doc_type_id'
               and Uk.Old_Id = Dt.Doc_Type_Id);
  
    Dbms_Application_Info.Set_Module('Migr_References',
                                     'inserting doc types, total num: ' || v_Total);
  
    for r in (select Dt.*
                from Old_Vx_Hr_Document_Types Dt
               where Dt.Company_Id = i_Old_Company_Id
                 and Dt.Pcode is null
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'doc_type_id'
                         and Uk.Old_Id = Dt.Doc_Type_Id))
    loop
      r_Document_Type.Company_Id  := i_New_Company_Id;
      r_Document_Type.Doc_Type_Id := Href_Next.Document_Type_Id;
      r_Document_Type.Name        := r.Name;
      r_Document_Type.State       := r.State;
    
      Href_Api.Document_Type_Save(r_Document_Type);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'doc_type_id',
                 i_Old_Id         => r.Doc_Type_Id,
                 i_New_Id         => r_Document_Type.Doc_Type_Id);
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_References', 'finished Migr_References');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Leaves
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    r_Request_Kind Htt_Request_Kinds%rowtype;
    r_Accrual      Htt_Request_Kind_Accruals%rowtype;
    r_Request      Htt_Requests%rowtype;
  
    v_Staff_Id number;
    v_Total    number;
  begin
    -- TODO: vx_hr_leave_type_accruals, vx_hr_emp_leave_accruals, vx_hr_emp_leave_bonuses
    -- not added limit_exceeding, carryover and accrual policy 
    select count(*)
      into v_Total
      from Old_Vx_Hr_Leave_Types Lt
     where Lt.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'request_kind_id'
               and Uk.Old_Id = Lt.Leave_Type_Id);
  
    for r in (select Lt.*, Rownum
                from Old_Vx_Hr_Leave_Types Lt
               where Lt.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'request_kind_id'
                         and Uk.Old_Id = Lt.Leave_Type_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Leaves',
                                       'inserted ' || (r.Rownum - 1) || ' leave types out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        r_Request_Kind.Company_Id               := i_New_Company_Id;
        r_Request_Kind.Request_Kind_Id          := Htt_Next.Request_Kind_Id;
        r_Request_Kind.Name                     := r.Name;
        r_Request_Kind.Allow_Unused_Time        := r.Allow_Unused_Time;
        r_Request_Kind.User_Permitted           := r.Requestable;
        r_Request_Kind.Request_Restriction_Days := r.Request_Restriction_Days;
        r_Request_Kind.Annually_Limited         := r.Limit_Leave_Time;
        r_Request_Kind.Annual_Day_Limit         := r.Annually_Days;
        r_Request_Kind.Day_Count_Type           := Htt_Pref.c_Day_Count_Type_Work_Days;
        r_Request_Kind.Carryover_Policy         := r.Carryover_Policy;
        r_Request_Kind.Carryover_Cap_Days       := r.Carryover_Cap_Days;
        r_Request_Kind.Carryover_Expires_Days   := r.Carryover_Expires_Days;
      
        if r.Calc_Exceptional_Days = 'Y' then
          r_Request_Kind.Day_Count_Type := Htt_Pref.c_Day_Count_Type_Calendar_Days;
        end if;
      
        r_Request_Kind.Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_New_Company_Id,
                                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Leave);
        r_Request_Kind.State        := r.State;
      
        Htt_Api.Request_Kind_Save(r_Request_Kind);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'request_kind_id',
                   i_Old_Id         => r.Leave_Type_Id,
                   i_New_Id         => r_Request_Kind.Request_Kind_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Leave_Types',
                    i_Key_Id         => r.Leave_Type_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- this is for samsung Old_Vx_Hr_Emp_Leave_Types
    select count(*)
      into v_Total
      from Old_Vx_Hr_Emp_Leave_Types Elt
      join Old_Vx_Hr_Employees Ep
        on Ep.Company_Id = Elt.Company_Id
       and Ep.Employee_Id = Elt.Employee_Id
       and Ep.Subcompany_Id = i_Subcompany_Id
      join Migr_Keys_Store_One p
        on p.Company_Id = i_New_Company_Id
       and p.Key_Name = 'person_id'
       and p.Old_Id = Elt.Employee_Id
      join Mhr_Employees Emp
        on Emp.Company_Id = i_New_Company_Id
       and Emp.Filial_Id = i_Filial_Id
       and Emp.Employee_Id = p.New_Id
      join Migr_Keys_Store_One P1
        on P1.Company_Id = i_New_Company_Id
       and P1.Key_Name = 'request_kind_id'
       and P1.Old_Id = Elt.Leave_Type_Id
     where Elt.Company_Id = i_Old_Company_Id
       and not exists
     (select 1
              from Htt_Staff_Request_Kinds Sr
             where Sr.Company_Id = i_New_Company_Id
               and Sr.Filial_Id = i_Filial_Id
               and Sr.Staff_Id in (select s.Staff_Id
                                     from Href_Staffs s
                                    where s.Company_Id = i_New_Company_Id
                                      and s.Filial_Id = Emp.Filial_Id
                                      and s.Employee_Id = Emp.Employee_Id)
               and Sr.Request_Kind_Id = P1.New_Id);
  
    for r in (select Elt.*,
                     Emp.Filial_Id,
                     Emp.Employee_Id New_Employee_Id,
                     P1.New_Id       Request_Kind_Id,
                     Rownum
                from Old_Vx_Hr_Emp_Leave_Types Elt
                join Old_Vx_Hr_Employees Ep
                  on Ep.Company_Id = Elt.Company_Id
                 and Ep.Employee_Id = Elt.Employee_Id
                 and Ep.Subcompany_Id = i_Subcompany_Id
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.Old_Id = Elt.Employee_Id
                join Mhr_Employees Emp
                  on Emp.Company_Id = i_New_Company_Id
                 and Emp.Filial_Id = i_Filial_Id
                 and Emp.Employee_Id = p.New_Id
                join Migr_Keys_Store_One P1
                  on P1.Company_Id = i_New_Company_Id
                 and P1.Key_Name = 'request_kind_id'
                 and P1.Old_Id = Elt.Leave_Type_Id
               where Elt.Company_Id = i_Old_Company_Id
                 and not exists
               (select 1
                        from Htt_Staff_Request_Kinds Sr
                       where Sr.Company_Id = i_New_Company_Id
                         and Sr.Filial_Id = Emp.Filial_Id
                         and Sr.Staff_Id in (select s.Staff_Id
                                               from Href_Staffs s
                                              where s.Company_Id = i_New_Company_Id
                                                and s.Filial_Id = Emp.Filial_Id
                                                and s.Employee_Id = Emp.Employee_Id)
                         and Sr.Request_Kind_Id = P1.New_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Leaves',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' employee leave types out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_New_Company_Id,
                                                     i_Filial_Id   => i_Filial_Id,
                                                     i_Employee_Id => r.New_Employee_Id);
      
        continue when v_Staff_Id is null;
      
        z_Htt_Staff_Request_Kinds.Insert_Try(i_Company_Id      => i_New_Company_Id,
                                             i_Filial_Id       => i_Filial_Id,
                                             i_Staff_Id        => v_Staff_Id,
                                             i_Request_Kind_Id => r.Request_Kind_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Emp_Leave_Types' || r.Employee_Id,
                    i_Key_Id         => r.Leave_Type_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    -- this is for samsung Old_vx_hr_emp_leave_accruals
    select count(*)
      into v_Total
      from Old_Vx_Hr_Emp_Leave_Accruals Ea
      join Old_Vx_Hr_Employees Ep
        on Ep.Company_Id = Ea.Company_Id
       and Ep.Employee_Id = Ea.Employee_Id
       and Ep.Subcompany_Id = i_Subcompany_Id
      join Migr_Keys_Store_One p
        on p.Company_Id = i_New_Company_Id
       and p.Key_Name = 'person_id'
       and p.Old_Id = Ea.Employee_Id
      join Mhr_Employees Emp
        on Emp.Company_Id = i_New_Company_Id
       and Emp.Filial_Id = i_Filial_Id
       and Emp.Employee_Id = p.New_Id
     where Ea.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'emp_leave_accrual_id'
               and St.Old_Id = Ea.Emp_Leave_Accrual_Id);
  
    for r in (select Ea.*, Emp.Filial_Id, Emp.Employee_Id New_Employee_Id, Rownum
                from Old_Vx_Hr_Emp_Leave_Accruals Ea
                join Old_Vx_Hr_Employees Ep
                  on Ep.Company_Id = Ea.Company_Id
                 and Ep.Employee_Id = Ea.Employee_Id
                 and Ep.Subcompany_Id = i_Subcompany_Id
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.Old_Id = Ea.Employee_Id
                join Mhr_Employees Emp
                  on Emp.Company_Id = i_New_Company_Id
                 and Emp.Filial_Id = i_Filial_Id
                 and Emp.Employee_Id = p.New_Id
               where Ea.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'emp_leave_accrual_id'
                         and St.Old_Id = Ea.Emp_Leave_Accrual_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Leaves',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' employee request kind accruals out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        r_Accrual.Company_Id      := i_New_Company_Id;
        r_Accrual.Filial_Id       := i_Filial_Id;
        r_Accrual.Staff_Id        := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_New_Company_Id,
                                                                    i_Filial_Id   => i_Filial_Id,
                                                                    i_Employee_Id => r.New_Employee_Id);
        r_Accrual.Request_Kind_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                i_Key_Name       => 'request_kind_id',
                                                i_Old_Id         => r.Leave_Type_Id);
        r_Accrual.Period          := r.End_Date;
        r_Accrual.Accrual_Kind    := r.Accrual_Kind;
        r_Accrual.Accrued_Days    := r.Accrued_Days;
      
        continue when r_Accrual.Staff_Id is null;
      
        z_Htt_Request_Kind_Accruals.Save_Row(r_Accrual);
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'emp_leave_accrual_id',
                        i_Key_Id         => r.Emp_Leave_Accrual_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Emp_Leave_Accruals',
                    i_Key_Id         => r.Emp_Leave_Accrual_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Hr_Emp_Leaves El
      join Old_Vx_Hr_Employees Ep
        on Ep.Company_Id = El.Company_Id
       and Ep.Employee_Id = El.Employee_Id
      -- and Ep.Subcompany_Id = i_Subcompany_Id
      join Migr_Keys_Store_One p
        on p.Company_Id = i_New_Company_Id
       and p.Key_Name = 'person_id'
       and p.Old_Id = El.Employee_Id
      join Mhr_Employees Emp
        on Emp.Company_Id = i_New_Company_Id
       and Emp.Filial_Id = i_Filial_Id
       and Emp.Employee_Id = p.New_Id
     where El.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'request_id'
               and St.Filial_Id = i_Filial_Id
               and St.Old_Id = El.Emp_Leave_Id);
  
    for r in (select El.*, Emp.Filial_Id, Emp.Employee_Id New_Employee_Id, Rownum
                from Old_Vx_Hr_Emp_Leaves El
                join Old_Vx_Hr_Employees Ep
                  on Ep.Company_Id = El.Company_Id
                 and Ep.Employee_Id = El.Employee_Id
          --       and Ep.Subcompany_Id = i_Subcompany_Id
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.Old_Id = El.Employee_Id
                join Mhr_Employees Emp
                  on Emp.Company_Id = i_New_Company_Id
                 and Emp.Filial_Id = i_Filial_Id
                 and Emp.Employee_Id = p.New_Id
               where El.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'request_id'
                         and St.Filial_Id = i_Filial_Id
                         and St.Old_Id = El.Emp_Leave_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Leaves',
                                       'inserted ' || (r.Rownum - 1) || ' leaves out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
        r_Request.Company_Id      := i_New_Company_Id;
        r_Request.Request_Kind_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                i_Key_Name       => 'request_kind_id',
                                                i_Old_Id         => r.Leave_Type_Id);
        r_Request.Begin_Time      := r.Begin_Date;
        r_Request.End_Time        := r.End_Date;
        r_Request.Request_Type    := r.Leave_Kind;
        r_Request.Note            := r.Note;
        r_Request.Accrual_Kind    := r.Accrual_Kind;
      
        r_Request.Filial_Id  := i_Filial_Id;
        r_Request.Request_Id := Htt_Next.Request_Id;
        r_Request.Staff_Id   := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Request.Company_Id,
                                                               i_Filial_Id   => r_Request.Filial_Id,
                                                               i_Employee_Id => r.New_Employee_Id);
      
        continue when r_Request.Staff_Id is null;
      
        Htt_Api.Request_Save(r_Request);
      
        update Htt_Requests p
           set p.Created_On = r.Created_On
         where p.Company_Id = r_Request.Company_Id
           and p.Filial_Id = r_Request.Filial_Id
           and p.Request_Id = r_Request.Request_Id;
      
        if r.Status = 'A' then
          Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                                  i_Filial_Id    => r_Request.Filial_Id,
                                  i_Request_Id   => r_Request.Request_Id,
                                  i_Manager_Note => r.Manager_Note,
                                  i_User_Id      => Ui.User_Id);
        
          Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Request_Id => r_Request.Request_Id);
        end if;
      
        if r.Manager_Approval = 'A' and r.Status = 'U' then
          Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                                  i_Filial_Id    => r_Request.Filial_Id,
                                  i_Request_Id   => r_Request.Request_Id,
                                  i_Manager_Note => r.Manager_Note,
                                  i_User_Id      => Ui.User_Id);
        end if;
      
        if r.Manager_Approval = 'D' and r.Status <> 'A' or r.Status = 'D' then
          Htt_Api.Request_Deny(i_Company_Id   => r_Request.Company_Id,
                               i_Filial_Id    => r_Request.Filial_Id,
                               i_Request_Id   => r_Request.Request_Id,
                               i_Manager_Note => r.Manager_Note);
        end if;
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'request_id',
                   i_Old_Id         => r.Emp_Leave_Id,
                   i_New_Id         => r_Request.Request_Id,
                   i_Filial_Id      => r_Request.Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Emp_Leaves',
                    i_Key_Id         => r.Emp_Leave_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Leaves', 'finished Migr_Leaves');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Timesheet_Plan_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    v_Change     Htt_Pref.Change_Rt;
    v_Change_Day Htt_Pref.Change_Day_Rt;
    r_Timesheet  Htt_Timesheets%rowtype;
  
    v_Full_Time        number;
    v_Timesheet_Exists boolean;
  
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Tp_Emp_Changes Ch
      join Old_Vx_Hr_Employees Ep
        on Ep.Company_Id = Ch.Company_Id
       and Ep.Employee_Id = Ch.Employee_Id
     --  and Ep.Subcompany_Id = i_Subcompany_Id
      join Migr_Keys_Store_One p
        on p.Company_Id = i_New_Company_Id
       and p.Key_Name = 'person_id'
       and p.Old_Id = Ch.Employee_Id
      join Mhr_Employees Emp
        on Emp.Company_Id = i_New_Company_Id
       and Emp.Filial_Id = i_Filial_Id
       and Emp.Employee_Id = p.New_Id
     where Ch.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'change_id'
               and St.Filial_Id = i_Filial_Id
               and St.Old_Id = Ch.Emp_Change_Id);
  
    for r in (select Ch.*, Emp.Filial_Id, Emp.Employee_Id New_Employee_Id, Rownum
                from Old_Vx_Tp_Emp_Changes Ch
                join Old_Vx_Hr_Employees Ep
                  on Ep.Company_Id = Ch.Company_Id
                 and Ep.Employee_Id = Ch.Employee_Id
           --      and Ep.Subcompany_Id = i_Subcompany_Id
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.Old_Id = Ch.Employee_Id
                join Mhr_Employees Emp
                  on Emp.Company_Id = i_New_Company_Id
                 and Emp.Filial_Id = i_Filial_Id
                 and Emp.Employee_Id = p.New_Id
               where Ch.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'change_id'
                         and St.Filial_Id = i_Filial_Id
                         and St.Old_Id = Ch.Emp_Change_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Timesheet_Plan_Changes',
                                       'inserted ' || (r.Rownum - 1) || ' changes out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        Htt_Util.Change_New(o_Change      => v_Change,
                            i_Company_Id  => i_New_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Change_Id   => -1,
                            i_Staff_Id    => -1,
                            i_Change_Kind => r.Change_Kind,
                            i_Note        => r.Note);
      
        for Cd in (select *
                     from Old_Vx_Tp_Emp_Change_Dates Chd
                    where Chd.Company_Id = r.Company_Id
                      and Chd.Emp_Change_Id = r.Emp_Change_Id)
        loop
          v_Change_Day.Change_Date      := Cd.Change_Date;
          v_Change_Day.Day_Kind         := Cd.Day_Kind;
          v_Change_Day.Begin_Time       := Cd.Change_Date +
                                           Numtodsinterval(Cd.Begin_Time, 'minute');
          v_Change_Day.End_Time         := Cd.Change_Date + Numtodsinterval(Cd.End_Time, 'minute');
          v_Change_Day.Break_Enabled    := Cd.Break_Time;
          v_Change_Day.Break_Begin_Time := Cd.Change_Date +
                                           Numtodsinterval(Cd.Begin_Break_Time, 'minute');
          v_Change_Day.Break_End_Time   := Cd.Change_Date +
                                           Numtodsinterval(Cd.End_Break_Time, 'minute');
          v_Change_Day.Plan_Time        := Cd.Fixed_Time * 60;
        
          if v_Change_Day.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
            v_Change_Day.Begin_Time       := null;
            v_Change_Day.End_Time         := null;
            v_Change_Day.Break_Enabled    := null;
            v_Change_Day.Break_Begin_Time := null;
            v_Change_Day.Break_End_Time   := null;
            v_Change_Day.Plan_Time        := 0;
          else
            if v_Change_Day.End_Time <= v_Change_Day.Begin_Time then
              v_Change_Day.End_Time := v_Change_Day.End_Time + 1;
            end if;
          
            if v_Change_Day.Break_Enabled = 'Y' then
              if v_Change_Day.Break_Begin_Time <= v_Change_Day.Begin_Time then
                v_Change_Day.Break_Begin_Time := v_Change_Day.Break_Begin_Time + 1;
              end if;
            
              if v_Change_Day.Break_End_Time <= v_Change_Day.Break_Begin_Time then
                v_Change_Day.Break_End_Time := v_Change_Day.Break_End_Time + 1;
              end if;
            
            else
              v_Change_Day.Break_Begin_Time := null;
              v_Change_Day.Break_End_Time   := null;
            end if;
          end if;
        
          v_Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => v_Change_Day.Day_Kind,
                                                 i_Begin_Time       => v_Change_Day.Begin_Time,
                                                 i_End_Time         => v_Change_Day.End_Time,
                                                 i_Break_Begin_Time => v_Change_Day.Break_Begin_Time,
                                                 i_Break_End_Time   => v_Change_Day.Break_End_Time);
          v_Full_Time := v_Full_Time * 60;
        
          if v_Change_Day.Plan_Time is null or v_Full_Time < v_Change_Day.Plan_Time then
            v_Change_Day.Plan_Time := v_Full_Time;
          end if;
        
          Htt_Util.Change_Day_Add(o_Change           => v_Change,
                                  i_Change_Date      => v_Change_Day.Change_Date,
                                  i_Day_Kind         => v_Change_Day.Day_Kind,
                                  i_Begin_Time       => v_Change_Day.Begin_Time,
                                  i_End_Time         => v_Change_Day.End_Time,
                                  i_Break_Enabled    => v_Change_Day.Break_Enabled,
                                  i_Break_Begin_Time => v_Change_Day.Break_Begin_Time,
                                  i_Break_End_Time   => v_Change_Day.Break_End_Time,
                                  i_Plan_Time        => v_Change_Day.Plan_Time);
        end loop;
      
        if r.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
          continue when v_Change.Change_Days.Count <> 2;
        
          v_Change.Change_Days(1).Swapped_Date := v_Change.Change_Days(2).Change_Date;
          v_Change.Change_Days(2).Swapped_Date := v_Change.Change_Days(1).Change_Date;
        end if;
      
        v_Change.Filial_Id := i_Filial_Id;
        v_Change.Staff_Id  := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Change.Company_Id,
                                                             i_Filial_Id   => v_Change.Filial_Id,
                                                             i_Employee_Id => r.New_Employee_Id);
      
        continue when v_Change.Staff_Id is null;
      
        v_Timesheet_Exists := true;
      
        for i in 1 .. v_Change.Change_Days.Count
        loop
          v_Change_Day := v_Change.Change_Days(i);
        
          if Htt_Util.Exist_Timesheet(i_Company_Id     => v_Change.Company_Id,
                                      i_Filial_Id      => v_Change.Filial_Id,
                                      i_Staff_Id       => v_Change.Staff_Id,
                                      i_Timesheet_Date => v_Change_Day.Change_Date,
                                      o_Timesheet      => r_Timesheet) then
            if r_Timesheet.Shift_Begin_Time > v_Change_Day.Begin_Time or
               r_Timesheet.Shift_End_Time < v_Change_Day.End_Time then
              v_Change_Day.Begin_Time := r_Timesheet.Shift_Begin_Time;
              v_Change_Day.End_Time   := r_Timesheet.Shift_End_Time;
            
              v_Change_Day.Break_Begin_Time := Greatest(v_Change_Day.Break_Begin_Time,
                                                        v_Change_Day.Begin_Time +
                                                        Numtodsinterval(1, 'minute'));
              v_Change_Day.Break_End_Time   := Least(v_Change_Day.End_Time -
                                                     Numtodsinterval(1, 'minute'),
                                                     v_Change_Day.Break_End_Time);
            
              v_Full_Time := Htt_Util.Calc_Full_Time(i_Day_Kind         => v_Change_Day.Day_Kind,
                                                     i_Begin_Time       => v_Change_Day.Begin_Time,
                                                     i_End_Time         => v_Change_Day.End_Time,
                                                     i_Break_Begin_Time => v_Change_Day.Break_Begin_Time,
                                                     i_Break_End_Time   => v_Change_Day.Break_End_Time);
              v_Full_Time := v_Full_Time * 60;
            
              if v_Full_Time < v_Change_Day.Plan_Time then
                v_Change_Day.Plan_Time := v_Full_Time;
              end if;
            
              v_Change.Change_Days(i) := v_Change_Day;
            end if;
          else
            v_Timesheet_Exists := false;
          end if;
        end loop;
      
        continue when not v_Timesheet_Exists;
      
        v_Change.Change_Id := Htt_Next.Change_Id;
      
        Htt_Api.Change_Save(v_Change);
      
        update Htt_Plan_Changes p
           set p.Created_On = r.Created_On
         where p.Company_Id = v_Change.Company_Id
           and p.Filial_Id = v_Change.Filial_Id
           and p.Change_Id = v_Change.Change_Id;
      
        if r.Status = 'A' then
          Htt_Api.Change_Approve(i_Company_Id   => v_Change.Company_Id,
                                 i_Filial_Id    => v_Change.Filial_Id,
                                 i_Change_Id    => v_Change.Change_Id,
                                 i_Manager_Note => r.Manager_Note,
                                 i_User_Id      => Ui.User_Id);
        
          Biruni_Route.Context_Begin;
          Htt_Api.Change_Complete(i_Company_Id => v_Change.Company_Id,
                                  i_Filial_Id  => v_Change.Filial_Id,
                                  i_Change_Id  => v_Change.Change_Id);
          Biruni_Route.Context_End;
        end if;
      
        if r.Manager_Approval = 'A' and r.Status = 'U' then
          Htt_Api.Change_Approve(i_Company_Id   => v_Change.Company_Id,
                                 i_Filial_Id    => v_Change.Filial_Id,
                                 i_Change_Id    => v_Change.Change_Id,
                                 i_Manager_Note => r.Manager_Note,
                                 i_User_Id      => Ui.User_Id);
        end if;
      
        if r.Manager_Approval = 'D' and r.Status <> 'A' or r.Status = 'D' then
          Htt_Api.Change_Deny(i_Company_Id   => v_Change.Company_Id,
                              i_Filial_Id    => v_Change.Filial_Id,
                              i_Change_Id    => v_Change.Change_Id,
                              i_Manager_Note => r.Manager_Note);
        end if;
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'change_id',
                   i_Old_Id         => r.Emp_Change_Id,
                   i_New_Id         => v_Change.Change_Id,
                   i_Filial_Id      => v_Change.Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Tp_Emp_Changes',
                    i_Key_Id         => r.Emp_Change_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Timesheet_Plan_Changes',
                                     'finished Migr_Timesheet_Plan_Changes');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Tasks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_Task_Group   Ms_Task_Groups%rowtype;
    r_Task_Type    Ms_Task_Types%rowtype;
    r_Task_Project Ms_Task_Projects%rowtype;
    r_Task_Status  Ms_Task_Statuses%rowtype;
    r_Task         Ms_Tasks%rowtype;
  
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Old_Ms_Task_Groups Tg
     where Tg.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'task_group_id'
               and Uk.Old_Id = Tg.Task_Group_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Tasks',
                                     'inserting ms task groups, total num: ' || v_Total);
  
    for r in (select *
                from Old_Ms_Task_Groups Tg
               where Tg.Company_Id = i_Old_Company_Id
                 and (Tg.Pcode is null or Tg.Pcode not like 'CORE%')
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'task_group_id'
                         and Uk.Old_Id = Tg.Task_Group_Id))
    loop
      r_Task_Group.Company_Id    := i_New_Company_Id;
      r_Task_Group.Task_Group_Id := Ms_Next.Task_Group_Id;
      r_Task_Group.Name          := r.Name;
      r_Task_Group.State         := r.State;
    
      Ms_Api.Task_Group_Save(r_Task_Group);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'task_group_id',
                 i_Old_Id         => r.Task_Group_Id,
                 i_New_Id         => r_Task_Group.Task_Group_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Ms_Task_Types Tt
     where Tt.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'task_type_id'
               and Uk.Old_Id = Tt.Task_Type_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Tasks',
                                     'inserting ms task types, total num: ' || v_Total);
  
    for r in (select *
                from Old_Ms_Task_Types Tt
               where Tt.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'task_type_id'
                         and Uk.Old_Id = Tt.Task_Type_Id))
    loop
      r_Task_Type.Company_Id    := i_New_Company_Id;
      r_Task_Type.Task_Type_Id  := Ms_Next.Task_Type_Id;
      r_Task_Type.Task_Group_Id := Get_Task_Group_Id(i_New_Company_Id    => i_New_Company_Id,
                                                     i_Old_Company_Id    => i_Old_Company_Id,
                                                     i_Old_Task_Group_Id => r.Task_Group_Id);
      r_Task_Type.Name          := r.Name;
      r_Task_Type.State         := r.State;
      r_Task_Type.Color         := r.Color;
      r_Task_Type.Text_Color    := r.Text_Color;
      r_Task_Type.Order_No      := r.Order_No;
    
      Ms_Api.Task_Type_Save(r_Task_Type);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'task_type_id',
                 i_Old_Id         => r.Task_Type_Id,
                 i_New_Id         => r_Task_Type.Task_Type_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Ms_Task_Projects Tp
     where Tp.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'project_id'
               and Uk.Old_Id = Tp.Project_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Tasks',
                                     'inserting ms task projects, total num: ' || v_Total);
  
    for r in (select *
                from Old_Ms_Task_Projects Tp
               where Tp.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'project_id'
                         and Uk.Old_Id = Tp.Project_Id))
    loop
      r_Task_Project.Company_Id := i_New_Company_Id;
      r_Task_Project.Project_Id := Ms_Next.Project_Id;
      r_Task_Project.Name       := r.Name;
      r_Task_Project.State      := r.State;
      r_Task_Project.Begin_Time := r.Begin_Time;
      r_Task_Project.End_Time   := r.End_Time;
      r_Task_Project.Photo_Sha  := r.Photo_Sha;
      r_Task_Project.Order_No   := r.Order_No;
    
      Ms_Api.Project_Save(i_Company_Id => r_Task_Project.Company_Id,
                          i_User_Id    => Ui.User_Id,
                          i_Project    => r_Task_Project);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'project_id',
                 i_Old_Id         => r.Project_Id,
                 i_New_Id         => r_Task_Project.Project_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Ms_Task_Project_Persons Tp
     where Tp.Company_Id = i_Old_Company_Id
       and exists (select 1
              from Migr_Used_Keys p
             where p.Company_Id = i_New_Company_Id
               and p.Key_Name = 'project_id'
               and p.Old_Id = Tp.Project_Id)
       and exists (select 1
              from Migr_Used_Keys q
             where q.Company_Id = i_New_Company_Id
               and q.Key_Name = 'person_id'
               and q.Old_Id = Tp.Person_Id);
  
    for r in (select Tp.*, Rownum
                from Old_Ms_Task_Project_Persons Tp
               where Tp.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'project_id'
                         and p.Old_Id = Tp.Project_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'person_id'
                         and q.Old_Id = Tp.Person_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Tasks',
                                       'inserted ' || (r.Rownum - 1) || ' project persons out of ' ||
                                       v_Total);
    
      Ms_Api.Project_Add_Person(i_Company_Id  => i_New_Company_Id,
                                i_User_Id     => Ui.User_Id,
                                i_Project_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                            i_Key_Name       => 'project_id',
                                                            i_Old_Id         => r.Project_Id),
                                i_Person_Id   => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                            i_Key_Name       => 'person_id',
                                                            i_Old_Id         => r.Person_Id),
                                i_Access_Kind => r.Access_Kind);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Ms_Task_Statuses Ts
     where Ts.Company_Id = i_Old_Company_Id
       and Ts.Pcode is null
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'status_id'
               and Uk.Old_Id = Ts.Status_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Tasks',
                                     'inserting ms task statuses, total num: ' || v_Total);
  
    for r in (select *
                from Old_Ms_Task_Statuses Ts
               where Ts.Company_Id = i_Old_Company_Id
                 and Ts.Pcode is null
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'status_id'
                         and Uk.Old_Id = Ts.Status_Id))
    loop
      r_Task_Status.Company_Id := i_New_Company_Id;
      r_Task_Status.Status_Id  := Ms_Next.Status_Id;
      r_Task_Status.Name       := r.Name;
      r_Task_Status.State      := r.State;
      r_Task_Status.Color      := r.Color;
      r_Task_Status.Text_Color := r.Color;
      r_Task_Status.Order_No   := r.Order_No;
      r_Task_Status.Code       := r.Code;
    
      Ms_Api.Task_Status_Save(r_Task_Status);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'status_id',
                 i_Old_Id         => r.Status_Id,
                 i_New_Id         => r_Task_Status.Status_Id);
    end loop;
  
    select count(*)
      into v_Total
      from Old_Ms_Tasks t
     where t.Company_Id = i_Old_Company_Id
       and (t.Project_Id is null or exists
            (select 1
               from Migr_Used_Keys p
              where p.Company_Id = i_New_Company_Id
                and p.Key_Name = 'project_id'
                and p.Old_Id = t.Project_Id))
       and not exists (select 1
              from Migr_Used_Keys q
             where q.Company_Id = i_New_Company_Id
               and q.Key_Name = 'task_id'
               and q.Old_Id = t.Task_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Tasks', 'inserting ms tasks, total num: ' || v_Total);
  
    for r in (select *
                from Old_Ms_Tasks t
               where t.Company_Id = i_Old_Company_Id
                 and (t.Project_Id is null or exists
                      (select 1
                         from Migr_Used_Keys p
                        where p.Company_Id = i_New_Company_Id
                          and p.Key_Name = 'project_id'
                          and p.Old_Id = t.Project_Id))
                 and not exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'task_id'
                         and q.Old_Id = t.Task_Id)
               start with t.Parent_Id is null
              connect by prior t.Task_Id = t.Parent_Id)
    loop
      r_Task.Company_Id := i_New_Company_Id;
      r_Task.Task_Id    := Ms_Next.Task_Id;
      r_Task.Title      := r.Title;
      r_Task.Status_Id  := Get_Task_Status_Id(i_New_Company_Id     => i_New_Company_Id,
                                              i_Old_Company_Id     => i_Old_Company_Id,
                                              i_Old_Task_Status_Id => r.Status_Id);
      r_Task.Task_Kind  := r.Task_Kind;
      r_Task.Firing     := r.Firing;
      r_Task.Grade      := r.Grade;
      r_Task.Project_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                      i_Key_Name       => 'project_id', --
                                      i_Old_Id         => r.Project_Id);
      r_Task.Parent_Id  := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                      i_Key_Name       => 'task_id', --
                                      i_Old_Id         => r.Task_Id);
      r_Task.Begin_Time := r.Begin_Time;
      r_Task.End_Time   := r.End_Time;
      r_Task.Form       := null;
      r_Task.Form_Param := null;
      r_Task.Spent_Time := r.Spent_Time;
    
      Ms_Api.Task_Save(i_Company_Id => i_New_Company_Id, --
                       i_User_Id    => Ui.User_Id,
                       i_Task       => r_Task);
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'task_id', --
                 i_Old_Id         => r.Task_Id,
                 i_New_Id         => r_Task.Task_Id);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Perf_Plan
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_Plan_Group Hper_Plan_Groups%rowtype;
    r_Plan_Type  Hper_Plan_Types%rowtype;
    r_Plan       Old_Vx_Pr_Plans%rowtype;
  
    v_Used_Filials Array_Number;
    v_New_Filials  Array_Number;
  
    v_Plan_Filial_Ids Array_Number := Array_Number();
    v_Filial_Id       number;
    v_Total           number;
  
    -------------------------------------------------- 
    Procedure Add_Plan
    (
      i_Plan      Old_Vx_Pr_Plans%rowtype,
      i_Filial_Id number
    ) is
      v_Plan Hper_Pref.Plan_Rt;
    begin
      Hper_Util.Plan_New(o_Plan            => v_Plan,
                         i_Company_Id      => i_New_Company_Id,
                         i_Filial_Id       => i_Filial_Id,
                         i_Plan_Id         => Hper_Next.Plan_Id,
                         i_Plan_Date       => i_Plan.Plan_Date,
                         i_Main_Calc_Type  => i_Plan.Main_Calc_Type,
                         i_Extra_Calc_Type => i_Plan.Extra_Calc_Type,
                         i_Journal_Page_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'page_id',
                                                         i_Old_Id         => i_Plan.Emp_Job_Id),
                         i_Division_Id     => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'division_id',
                                                         i_Old_Id         => i_Plan.Division_Id),
                         i_Job_Id          => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'job_id',
                                                         i_Old_Id         => i_Plan.Job_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Rank_Id         => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                         i_Key_Name       => 'rank_id',
                                                         i_Old_Id         => i_Plan.Rank_Id,
                                                         i_Filial_Id      => i_Filial_Id),
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Note            => i_Plan.Note);
    
      for Item in (select *
                     from Old_Vx_Pr_Plan_Items
                    where Company_Id = i_Old_Company_Id
                      and Plan_Id = i_Plan.Plan_Id)
      loop
        Hper_Util.Plan_Add_Item(p_Plan         => v_Plan,
                                i_Plan_Type_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                             i_Key_Name       => 'plan_type_id',
                                                             i_Old_Id         => Item.Plan_Type_Id,
                                                             i_Filial_Id      => i_Filial_Id),
                                i_Plan_Type    => Item.Plan_Type,
                                i_Plan_Value   => Item.Plan_Value,
                                i_Plan_Amount  => Item.Plan_Amount,
                                i_Note         => Item.Note);
        for Rule in (select *
                       from Old_Vx_Pr_Plan_Rules
                      where Company_Id = i_Old_Company_Id
                        and Plan_Id = i_Plan.Plan_Id
                        and Plan_Type_Id = Item.Plan_Type_Id)
        loop
          Hper_Util.Plan_Add_Rule(p_Item         => v_Plan.Items(v_Plan.Items.Count),
                                  i_From_Percent => Rule.From_Percent,
                                  i_To_Percent   => Rule.To_Percent,
                                  i_Fact_Amount  => Rule.Fact_Amount);
        end loop;
      end loop;
    
      Hper_Api.Plan_Save(v_Plan);
    end;
  
  begin
    select St.Filial_Id
      bulk collect
      into v_Used_Filials
      from Migr_Keys_Store_Two St
     where St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'plan_group_id';
  
    v_New_Filials := g_Filial_Ids multiset Except v_Used_Filials;
  
    select count(*)
      into v_Total
      from Old_Vx_Pr_Plan_Groups Pg
     where Pg.Company_Id = i_Old_Company_Id
       and v_New_Filials is not Empty
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'plan_group_id'
               and St.Old_Id = Pg.Plan_Group_Id
               and St.Filial_Id member of v_New_Filials);
  
    Dbms_Application_Info.Set_Module('Migr_Perf_Plan',
                                     'inserting pr plan groups, total num: ' || v_Total);
  
    for r in (select *
                from Old_Vx_Pr_Plan_Groups Pg
               where Pg.Company_Id = i_Old_Company_Id
                 and v_New_Filials is not Empty
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'plan_group_id'
                         and St.Old_Id = Pg.Plan_Group_Id
                         and St.Filial_Id member of v_New_Filials))
    loop
      r_Plan_Group.Company_Id := i_New_Company_Id;
      r_Plan_Group.Name       := r.Name;
      r_Plan_Group.State      := r.State;
      r_Plan_Group.Order_No   := r.Order_No;
    
      for f in 1 .. g_Filial_Ids.Count
      loop
        if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
          continue;
        end if;
      
        continue when z_Hper_Plan_Groups.Exist(i_Company_Id    => i_New_Company_Id,
                                               i_Filial_Id     => g_Filial_Ids(f),
                                               i_Plan_Group_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                             i_Key_Name       => 'plan_group_id',
                                                                             i_Old_Id         => r.Plan_Group_Id,
                                                                             i_Filial_Id      => g_Filial_Ids(f)));
      
        r_Plan_Group.Filial_Id     := g_Filial_Ids(f);
        r_Plan_Group.Plan_Group_Id := Hper_Next.Plan_Group_Id;
      
        Hper_Api.Plan_Group_Save(r_Plan_Group);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'plan_group_id',
                   i_Old_Id         => r.Plan_Group_Id,
                   i_New_Id         => r_Plan_Group.Plan_Group_Id,
                   i_Filial_Id      => r_Plan_Group.Filial_Id);
      end loop;
    end loop;
  
    select St.Filial_Id
      bulk collect
      into v_Used_Filials
      from Migr_Keys_Store_Two St
     where St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'plan_type_id';
  
    v_New_Filials := g_Filial_Ids multiset Except v_Used_Filials;
  
    select count(*)
      into v_Total
      from Old_Vx_Pr_Plan_Types Pt
     where Pt.Company_Id = i_Old_Company_Id
       and v_New_Filials is not Empty
       and not exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'plan_type_id'
               and St.Old_Id = Pt.Plan_Type_Id
               and St.Filial_Id member of v_New_Filials);
  
    Dbms_Application_Info.Set_Module('Migr_Perf_Plan',
                                     'inserting pr plan types, total num: ' || v_Total);
  
    for r in (select *
                from Old_Vx_Pr_Plan_Types Pt
               where Pt.Company_Id = i_Old_Company_Id
                 and v_New_Filials is not Empty
                 and not exists (select 1
                        from Migr_Keys_Store_Two St
                       where St.Company_Id = i_New_Company_Id
                         and St.Key_Name = 'plan_type_id'
                         and St.Old_Id = Pt.Plan_Type_Id
                         and St.Filial_Id member of v_New_Filials))
    loop
      r_Plan_Type.Company_Id        := i_New_Company_Id;
      r_Plan_Type.Name              := r.Name;
      r_Plan_Type.Calc_Kind         := r.Calc_Kind;
      r_Plan_Type.With_Part         := r.With_Part;
      r_Plan_Type.State             := r.State;
      r_Plan_Type.Code              := r.Code;
      r_Plan_Type.Order_No          := r.Order_No;
      r_Plan_Type.c_Divisions_Exist := 'N';
    
      for f in 1 .. g_Filial_Ids.Count
      loop
        if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
          continue;
        end if;
      
        continue when z_Hper_Plan_Types.Exist(i_Company_Id   => i_New_Company_Id,
                                              i_Filial_Id    => g_Filial_Ids(f),
                                              i_Plan_Type_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                           i_Key_Name       => 'plan_type_id',
                                                                           i_Old_Id         => r.Plan_Type_Id,
                                                                           i_Filial_Id      => g_Filial_Ids(f)));
      
        r_Plan_Type.Filial_Id     := g_Filial_Ids(f);
        r_Plan_Type.Plan_Type_Id  := Hper_Next.Plan_Type_Id;
        r_Plan_Type.Plan_Group_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                i_Key_Name       => 'plan_group_id',
                                                i_Old_Id         => r.Plan_Group_Id,
                                                i_Filial_Id      => r_Plan_Type.Filial_Id);
      
        Hper_Api.Plan_Type_Save(r_Plan_Type);
      
        Insert_Key(i_New_Company_Id => i_New_Company_Id,
                   i_Key_Name       => 'plan_type_id',
                   i_Old_Id         => r.Plan_Type_Id,
                   i_New_Id         => r_Plan_Type.Plan_Type_Id,
                   i_Filial_Id      => r_Plan_Type.Filial_Id);
      end loop;
    end loop;
  
    for r in (select *
                from Old_Vx_Pr_Plan_Type_Divisions
               where Company_Id = i_Old_Company_Id)
    loop
      v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'filial_id',
                                i_Old_Id         => r.Division_Id);
    
      if v_Filial_Id is not null then
        -- this division is filial
        if g_Dummy_Division_Fix_Mode then
          r.Division_Id := -v_Filial_Id;
          if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'division_id',
                        i_Old_Id         => r.Division_Id) is null then
            Add_Division(i_New_Company_Id  => i_New_Company_Id,
                         i_Old_Division_Id => r.Division_Id,
                         i_Filial_Id       => v_Filial_Id,
                         i_Name            => 'DUMMY',
                         i_Parent_Id       => null,
                         i_State           => 'A',
                         i_Code            => null);
          end if;
        else
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Pr_Plan_Type_Divisions',
                    i_Key_Id         => r.Division_Id,
                    i_Error_Message  => 'fix divisions in Vx_Pr_Plan_Type_Divisions, division_id=' ||
                                        r.Division_Id);
          continue;
        end if;
      end if;
    
      v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'division_filial_id',
                                i_Old_Id         => r.Division_Id);
    
      Hper_Api.Plan_Type_Add_Division(i_Company_Id   => i_New_Company_Id,
                                      i_Filial_Id    => v_Filial_Id,
                                      i_Plan_Type_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                   i_Key_Name       => 'plan_type_id',
                                                                   i_Old_Id         => r.Plan_Type_Id,
                                                                   i_Filial_Id      => v_Filial_Id),
                                      i_Division_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                   i_Key_Name       => 'division_id',
                                                                   i_Old_Id         => r.Division_Id));
    end loop;
  
    for r in (select *
                from Old_Vx_Pr_Plan_Type_Task_Types
               where Company_Id = i_Old_Company_Id)
    loop
      for f in 1 .. g_Filial_Ids.Count
      loop
        if g_Filial_Ids(f) = Md_Pref.Filial_Head(i_New_Company_Id) then
          continue;
        end if;
      
        Hper_Api.Plan_Type_Add_Task_Type(i_Company_Id   => i_New_Company_Id,
                                         i_Filial_Id    => g_Filial_Ids(f),
                                         i_Plan_Type_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                      i_Key_Name       => 'plan_type_id',
                                                                      i_Old_Id         => r.Plan_Type_Id,
                                                                      i_Filial_Id      => g_Filial_Ids(f)),
                                         i_Task_Type_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                      i_Key_Name       => 'task_type_id',
                                                                      i_Old_Id         => r.Task_Type_Id));
      end loop;
    end loop;
  
    select count(*)
      into v_Total
      from Old_Vx_Pr_Plans p
     where p.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'pr_plan'
               and Uk.Old_Id = p.Plan_Id);
  
    for r in (select p.*, Rownum
                from Old_Vx_Pr_Plans p
               where p.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'pr_plan'
                         and Uk.Old_Id = p.Plan_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Perf_Plan',
                                       'inserted ' || (r.Rownum - 1) || ' pr plans out of ' ||
                                       v_Total);
      r_Plan.Company_Id      := r.Company_Id;
      r_Plan.Plan_Id         := r.Plan_Id;
      r_Plan.Plan_Date       := r.Plan_Date;
      r_Plan.Plan_Kind       := r.Plan_Kind;
      r_Plan.Emp_Job_Id      := r.Emp_Job_Id;
      r_Plan.Job_Id          := r.Job_Id;
      r_Plan.Rank_Id         := r.Rank_Id;
      r_Plan.Type_Id         := r.Type_Id;
      r_Plan.Main_Calc_Type  := r.Main_Calc_Type;
      r_Plan.Extra_Calc_Type := r.Extra_Calc_Type;
      r_Plan.Note            := r.Note;
      begin
        savepoint Try_Catch;
      
        if r.Plan_Kind = 'S' then
          v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                    i_Key_Name       => 'filial_id', --
                                    i_Old_Id         => r.Division_Id);
          if v_Filial_Id is not null then
            -- this division is filial
            if g_Dummy_Division_Fix_Mode then
              r.Division_Id := -v_Filial_Id;
              if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                            i_Key_Name       => 'division_id',
                            i_Old_Id         => r.Division_Id) is null then
                Add_Division(i_New_Company_Id  => i_New_Company_Id,
                             i_Old_Division_Id => r.Division_Id,
                             i_Filial_Id       => v_Filial_Id,
                             i_Name            => 'DUMMY',
                             i_Parent_Id       => null,
                             i_State           => 'A',
                             i_Code            => null);
              end if;
            else
              b.Raise_Error('fix divisions in Vx_Pr_Plans, plan_id=$1, division_id=$2',
                            r.Plan_Id,
                            r.Division_Id);
            end if;
          end if;
          r_Plan.Division_Id := r.Division_Id;
        
          v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                    i_Key_Name       => 'division_filial_id',
                                    i_Old_Id         => r.Division_Id);
          Add_Plan(i_Plan => r_Plan, i_Filial_Id => v_Filial_Id);
        else
          v_Filial_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                    i_Key_Name       => 'page_filial_id',
                                    i_Old_Id         => r.Emp_Job_Id);
          Add_Plan(i_Plan => r_Plan, i_Filial_Id => v_Filial_Id);
        end if;
      
        Fazo.Push(v_Plan_Filial_Ids, v_Filial_Id);
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'pr_plan', --
                        i_Key_Id         => r.Plan_Id);
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Pr_Plans',
                    i_Key_Id         => r.Plan_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
        
      end;
    end loop;
  
    insert into Hper_Staff_Plans
      (Company_Id,
       Filial_Id,
       Staff_Plan_Id,
       Staff_Id,
       Plan_Date,
       Main_Calc_Type,
       Extra_Calc_Type,
       Month_Begin_Date,
       Month_End_Date,
       Journal_Page_Id,
       Division_Id,
       Job_Id,
       Rank_Id,
       Employment_Type,
       Begin_Date,
       End_Date,
       Main_Plan_Amount,
       Extra_Plan_Amount,
       Main_Fact_Amount,
       Extra_Fact_Amount,
       Main_Fact_Percent,
       Extra_Fact_Percent,
       c_Main_Fact_Percent,
       c_Extra_Fact_Percent,
       Status,
       Note,
       Created_By,
       Created_On)
      select i_New_Company_Id,
             Fil.New_Id,
             Gen_Save_Staff_Plan_Id(i_New_Company_Id => i_New_Company_Id,
                                    i_Emp_Plan_Id    => p.Emp_Plan_Id, --
                                    i_Filial_Id      => Fil.New_Id),
             q.Staff_Id,
             p.Plan_Date,
             p.Main_Calc_Type,
             p.Extra_Calc_Type,
             p.Month_Begin_Date,
             p.Month_End_Date,
             Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'page_id', --
                        i_Old_Id         => p.Emp_Job_Id),
             Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'division_id', --
                        i_Old_Id         => p.Division_Id),
             Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'job_id', --
                        i_Old_Id         => p.Job_Id,
                        i_Filial_Id      => Fil.New_Id),
             Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'rank_id', --
                        i_Old_Id         => p.Rank_Id,
                        i_Filial_Id      => Fil.New_Id),
             Hpd_Pref.c_Employment_Type_Main_Job,
             p.Begin_Date,
             p.End_Date,
             p.Main_Plan_Amount,
             p.Extra_Plan_Amount,
             p.Main_Fact_Amount,
             p.Extra_Fact_Amount,
             p.Main_Fact_Percent,
             p.Extra_Fact_Percent,
             p.c_Main_Fact_Percent,
             p.c_Extra_Fact_Percent,
             p.Status,
             p.Note,
             Ui.User_Id,
             p.Created_On
        from Old_Vx_Pr_Emp_Plans p
        join Migr_Keys_Store_One Kt
          on Kt.Company_Id = i_New_Company_Id
         and Kt.Key_Name = 'person_id'
         and Kt.Old_Id = p.Employee_Id
        join Migr_Keys_Store_One Fil
          on Fil.Company_Id = i_New_Company_Id
         and Fil.Key_Name = 'page_filial_id'
         and Fil.Old_Id = p.Emp_Job_Id
        join Href_Staffs q
          on q.Company_Id = i_New_Company_Id
         and q.Filial_Id = Fil.New_Id
         and q.Employee_Id = Kt.New_Id
         and q.State = 'A'
         and q.Hiring_Date <= p.End_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= p.Begin_Date)
       where p.Company_Id = i_Old_Company_Id
         and not exists (select 1
                from Migr_Used_Keys t
               where t.Company_Id = i_New_Company_Id
                 and t.Key_Name = 'staff_plan_id'
                 and t.Old_Id = p.Emp_Plan_Id)
         and exists (select 1
                from Migr_Used_Keys q
               where q.Company_Id = i_New_Company_Id
                 and q.Key_Name = 'page_id'
                 and q.Old_Id = p.Emp_Job_Id)
         and exists (select 1
                from Migr_Used_Keys g
               where g.Company_Id = i_New_Company_Id
                 and g.Key_Name = 'division_id'
                 and g.Old_Id = p.Division_Id)
         and exists
       (select 1
                from Migr_Used_Keys j
               where j.Company_Id = i_New_Company_Id
                 and j.Key_Name = 'job_id'
                 and j.Old_Id = p.Job_Id)
         and (p.Rank_Id is null or exists (select 1
                                             from Migr_Used_Keys Uk
                                            where Uk.Company_Id = i_New_Company_Id
                                              and Uk.Key_Name = 'rank_id'
                                              and Uk.Old_Id = p.Rank_Id));
  
    insert into Hper_Staff_Plan_Items
      (Company_Id,
       Filial_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       Plan_Type,
       Plan_Value,
       Plan_Amount,
       Fact_Value,
       Fact_Percent,
       Fact_Amount,
       Calc_Kind,
       Note,
       Fact_Note)
      select v.Company_Id,
             v.Filial_Id,
             v.Staff_Plan_Id,
             v.Plan_Type_Id,
             v.Plan_Type,
             v.Plan_Value,
             v.Plan_Amount,
             v.Fact_Value,
             v.Fact_Percent,
             v.Fact_Amount,
             v.Calc_Kind,
             v.Note,
             v.Fact_Note
        from (select i_New_Company_Id Company_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'page_filial_id', --
                                i_Old_Id         => p.Emp_Job_Id) Filial_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'staff_plan_id', --
                                i_Old_Id         => Pi.Emp_Plan_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Staff_Plan_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'plan_type_id', --
                                i_Old_Id         => Pi.Plan_Type_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Plan_Type_Id,
                     Pi.Plan_Type Plan_Type,
                     Pi.Plan_Value Plan_Value,
                     Pi.Plan_Amount Plan_Amount,
                     Pi.Fact_Value Fact_Value,
                     Pi.Fact_Percent Fact_Percent,
                     Pi.Fact_Amount Fact_Amount,
                     Pi.Calc_Kind Calc_Kind,
                     Pi.Note Note,
                     Pi.Fact_Note Fact_Note
                from Old_Vx_Pr_Emp_Plan_Items Pi
                join Old_Vx_Pr_Emp_Plans p
                  on p.Company_Id = Pi.Company_Id
                 and p.Emp_Plan_Id = Pi.Emp_Plan_Id
               where Pi.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'staff_plan_id'
                         and Uk.Old_Id = Pi.Emp_Plan_Id)) v
       where v.Staff_Plan_Id member of g_Staff_Plan_Ids;
  
    insert into Hper_Staff_Plan_Parts
      (Company_Id,
       Filial_Id,
       Part_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       Part_Date,
       Amount,
       Note,
       Created_On,
       Created_By,
       Modified_On,
       Modified_By)
      select v.Company_Id,
             v.Filial_Id,
             v.Part_Id,
             v.Staff_Plan_Id,
             v.Plan_Type_Id,
             v.Part_Date,
             v.Amount,
             v.Note,
             v.Created_On,
             v.Created_By,
             v.Modified_On,
             v.Modified_By
        from (select i_New_Company_Id Company_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'page_filial_id', --
                                i_Old_Id         => p.Emp_Job_Id) Filial_Id,
                     Hper_Next.Part_Id Part_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'staff_plan_id', --
                                i_Old_Id         => Epp.Emp_Plan_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Staff_Plan_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'plan_type_id', --
                                i_Old_Id         => Epp.Plan_Type_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Plan_Type_Id,
                     Epp.Part_Date Part_Date,
                     Epp.Amount Amount,
                     Epp.Note Note,
                     Epp.Created_On Created_On,
                     Ui.User_Id Created_By,
                     sysdate Modified_On,
                     Ui.User_Id Modified_By
                from Old_Vx_Pr_Emp_Plan_Parts Epp
                join Old_Vx_Pr_Emp_Plans p
                  on p.Company_Id = Epp.Company_Id
                 and p.Emp_Plan_Id = Epp.Emp_Plan_Id
               where Epp.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'staff_plan_id'
                         and Uk.Old_Id = Epp.Emp_Plan_Id)) v
       where v.Staff_Plan_Id member of g_Staff_Plan_Ids;
  
    insert into Hper_Staff_Plan_Rules
      (Company_Id, --
       Filial_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       From_Percent,
       To_Percent,
       Fact_Amount)
      select v.Company_Id,
             v.Filial_Id,
             v.Staff_Plan_Id,
             v.Plan_Type_Id,
             v.From_Percent,
             v.To_Percent,
             v.Fact_Amount
        from (select i_New_Company_Id Company_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'page_filial_id', --
                                i_Old_Id         => p.Emp_Job_Id) Filial_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'staff_plan_id', --
                                i_Old_Id         => Epr.Emp_Plan_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Staff_Plan_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'plan_type_id', --
                                i_Old_Id         => Epr.Plan_Type_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Plan_Type_Id,
                     Epr.From_Percent From_Percent,
                     Epr.To_Percent To_Percent,
                     Epr.Fact_Amount Fact_Amount
                from Old_Vx_Pr_Emp_Plan_Rules Epr
                join Old_Vx_Pr_Emp_Plans p
                  on p.Company_Id = Epr.Company_Id
                 and p.Emp_Plan_Id = Epr.Emp_Plan_Id
               where Epr.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'staff_plan_id'
                         and Uk.Old_Id = Epr.Emp_Plan_Id)) v
       where v.Staff_Plan_Id member of g_Staff_Plan_Ids;
  
    insert into Hper_Staff_Plan_Task_Types
      (Company_Id, --
       Filial_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       Task_Type_Id)
      select v.Company_Id, --
             v.Filial_Id,
             v.Staff_Plan_Id,
             v.Plan_Type_Id,
             v.Task_Type_Id
        from (select i_New_Company_Id Company_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'page_filial_id', --
                                i_Old_Id         => p.Emp_Job_Id) Filial_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'staff_plan_id', --
                                i_Old_Id         => Tt.Emp_Plan_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Staff_Plan_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'plan_type_id', --
                                i_Old_Id         => Tt.Plan_Type_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Plan_Type_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'task_type_id', --
                                i_Old_Id         => Tt.Task_Type_Id) Task_Type_Id
                from Old_Vx_Pr_Emp_Plan_Task_Types Tt
                join Old_Vx_Pr_Emp_Plans p
                  on p.Company_Id = Tt.Company_Id
                 and p.Emp_Plan_Id = Tt.Emp_Plan_Id
               where Tt.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'staff_plan_id'
                         and Uk.Old_Id = Tt.Emp_Plan_Id)) v
       where v.Staff_Plan_Id member of g_Staff_Plan_Ids;
  
    insert into Hper_Staff_Plan_Tasks
      (Company_Id, --
       Filial_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       Task_Id)
      select v.Company_Id, --
             v.Filial_Id,
             v.Staff_Plan_Id,
             v.Plan_Type_Id,
             v.Task_Id
        from (select i_New_Company_Id Company_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'page_filial_id', --
                                i_Old_Id         => p.Emp_Job_Id) Filial_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'staff_plan_id', --
                                i_Old_Id         => t.Emp_Plan_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Staff_Plan_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'plan_type_id', --
                                i_Old_Id         => t.Plan_Type_Id,
                                i_Filial_Id      => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'page_filial_id', --
                                                               i_Old_Id         => p.Emp_Job_Id)) Plan_Type_Id,
                     Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'task_id', --
                                i_Old_Id         => t.Task_Id) Task_Id
                from Old_Vx_Pr_Emp_Plan_Tasks t
                join Old_Vx_Pr_Emp_Plans p
                  on p.Company_Id = t.Company_Id
                 and p.Emp_Plan_Id = t.Emp_Plan_Id
               where t.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'staff_plan_id'
                         and Uk.Old_Id = t.Emp_Plan_Id)) v
       where v.Staff_Plan_Id member of g_Staff_Plan_Ids;
  
    Dbms_Application_Info.Set_Module('Migr_Perf_Plan', 'finished Migr_Perf_Plan');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timesheets
  (
    i_New_Company_Id number,
    i_Filial_Id      number := null
  ) is
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Hpd_Agreements p
     where p.Company_Id = i_New_Company_Id
       and (i_Filial_Id is null or p.Filial_Id = i_Filial_Id)
       and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule;
  
    for r in (select Qr.*, Rownum
                from (select p.*,
                             q.Schedule_Id,
                             p.Period Begin_Date,
                             Lead(p.Period) Over(partition by p.Staff_Id order by p.Period) - 1 End_Date
                        from Hpd_Agreements p
                        left join Hpd_Trans_Schedules q
                          on q.Company_Id = p.Company_Id
                         and q.Filial_Id = p.Filial_Id
                         and q.Trans_Id = p.Trans_Id
                       where p.Company_Id = i_New_Company_Id
                         and (i_Filial_Id is null or p.Filial_Id = i_Filial_Id)
                         and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
                       order by p.Staff_Id, p.Period) Qr)
    loop
      continue when r.Action = Hpd_Pref.c_Transaction_Action_Stop;
    
      Dbms_Application_Info.Set_Module('Gen_Timesheets',
                                       'generated timesheets for ' || (r.Rownum - 1) ||
                                       ' staff parts out of ' || v_Total);
    
      Biruni_Route.Context_Begin;
    
      Htt_Core.Regenerate_Timesheets(i_Company_Id  => r.Company_Id,
                                     i_Filial_Id   => r.Filial_Id,
                                     i_Staff_Id    => r.Staff_Id,
                                     i_Schedule_Id => r.Schedule_Id,
                                     i_Begin_Date  => r.Begin_Date,
                                     i_End_Date    => r.End_Date);
    
      Biruni_Route.Context_End;
    
      if r.Rownum mod 50 = 0 then
        commit;
      end if;
    end loop;
  
    Dbms_Application_Info.Set_Module('Gen_Timesheets', 'finished Gen_Timesheets');
    commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Schedule_Days
  (
    i_New_Company_Id number,
    i_Year           number,
    i_Filial_Id      number := null,
    i_Schedule_Id    number := null
  ) is
    v_Period_Start date := to_date('01.01.2022', 'dd.mm.yyyy');
    v_First_Day    date := Trunc(to_date(i_Year, 'yyyy'), 'yyyy');
    v_Last_Day     date := Add_Months(v_First_Day, 12);
    v_Current_Day  date;
    v_Start_Day    date;
  
    v_Schedule     Htt_Pref.Schedule_Rt;
    v_Pattern      Htt_Pref.Schedule_Pattern_Rt;
    v_Pattern_Day  Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Pattern_Days Htt_Pref.Schedule_Pattern_Day_Nt;
    v_Schedule_Day Htt_Pref.Schedule_Day_Rt;
    v_Marks        Htt_Pref.Mark_Nt;
    v_Day_Marks    Htt_Pref.Schedule_Day_Marks_Rt;
  
    r_Pattern Htt_Schedule_Patterns%rowtype;
  
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Htt_Schedules s
     where s.Company_Id = i_New_Company_Id
       and s.Pcode is null
       and (i_Filial_Id is null or s.Filial_Id = i_Filial_Id)
       and (i_Schedule_Id is null or s.Schedule_Id = i_Schedule_Id)
       and not exists (select 1
              from Htt_Schedule_Origin_Days Od
             where Od.Company_Id = s.Company_Id
               and Od.Filial_Id = s.Filial_Id
               and Od.Schedule_Id = s.Schedule_Id
               and Extract(year from Od.Schedule_Date) = i_Year);
  
    for r in (select s.*, Rownum
                from Htt_Schedules s
               where s.Company_Id = i_New_Company_Id
                 and s.Pcode is null
                 and (i_Filial_Id is null or s.Filial_Id = i_Filial_Id)
                 and (i_Schedule_Id is null or s.Schedule_Id = i_Schedule_Id)
                 and not exists (select 1
                        from Htt_Schedule_Origin_Days Od
                       where Od.Company_Id = s.Company_Id
                         and Od.Filial_Id = s.Filial_Id
                         and Od.Schedule_Id = s.Schedule_Id
                         and Extract(year from Od.Schedule_Date) = i_Year))
    loop
      Dbms_Application_Info.Set_Module('Gen_Schedule_Days',
                                       'generated schedule days for ' || (r.Rownum - 1) ||
                                       ' out of ' || v_Total);
    
      Htt_Util.Schedule_New(o_Schedule          => v_Schedule,
                            i_Company_Id        => r.Company_Id,
                            i_Filial_Id         => r.Filial_Id,
                            i_Schedule_Id       => r.Schedule_Id,
                            i_Name              => r.Name,
                            i_Shift             => r.Shift,
                            i_Input_Acceptance  => r.Input_Acceptance,
                            i_Output_Acceptance => r.Output_Acceptance,
                            i_Track_Duration    => r.Track_Duration,
                            i_Count_Late        => r.Count_Late,
                            i_Count_Early       => r.Count_Early,
                            i_Count_Lack        => r.Count_Lack,
                            i_Calendar_Id       => r.Calendar_Id,
                            i_Take_Holidays     => r.Take_Holidays,
                            i_Take_Nonworking   => r.Take_Nonworking,
                            i_State             => r.State,
                            i_Code              => r.Code,
                            i_Year              => i_Year);
    
      r_Pattern := z_Htt_Schedule_Patterns.Load(i_Company_Id  => r.Company_Id,
                                                i_Filial_Id   => r.Filial_Id,
                                                i_Schedule_Id => r.Schedule_Id);
    
      Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Pattern,
                                    i_Schedule_Kind  => r_Pattern.Schedule_Kind,
                                    i_All_Days_Equal => r_Pattern.All_Days_Equal,
                                    i_Count_Days     => r_Pattern.Count_Days);
    
      v_Pattern_Days := Htt_Pref.Schedule_Pattern_Day_Nt();
    
      for Pd in (select Pd.Day_No,
                        Pd.Day_Kind,
                        Pd.Begin_Time,
                        Pd.End_Time,
                        Pd.Break_Enabled,
                        Pd.Break_Begin_Time,
                        Pd.Break_End_Time,
                        Pd.Plan_Time
                   from Htt_Schedule_Pattern_Days Pd
                  where Pd.Company_Id = r.Company_Id
                    and Pd.Filial_Id = r.Filial_Id
                    and Pd.Schedule_Id = r.Schedule_Id
                  order by Pd.Day_No)
      loop
        Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
                                          i_Day_No           => Pd.Day_No,
                                          i_Day_Kind         => Pd.Day_Kind,
                                          i_Begin_Time       => Pd.Begin_Time,
                                          i_End_Time         => Pd.End_Time,
                                          i_Break_Enabled    => Pd.Break_Enabled,
                                          i_Break_Begin_Time => Pd.Break_Begin_Time,
                                          i_Break_End_Time   => Pd.Break_End_Time,
                                          i_Plan_Time        => Pd.Plan_Time);
      
        select mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440)
          bulk collect
          into v_Marks
          from Htt_Schedule_Pattern_Marks Pm
         where Pm.Company_Id = r.Company_Id
           and Pm.Filial_Id = r.Filial_Id
           and Pm.Schedule_Id = r.Schedule_Id
           and Pm.Day_No = Pd.Day_No;
      
        v_Pattern_Day.Pattern_Marks := v_Marks;
      
        v_Pattern_Days.Extend();
        v_Pattern_Days(v_Pattern_Days.Count) := v_Pattern_Day;
      end loop;
    
      for i in 1 .. v_Pattern_Days.Count
      loop
        Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Pattern,
                                          i_Day              => v_Pattern_Days(i));
      end loop;
    
      v_Current_Day := v_First_Day;
    
      if v_Pattern.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Weekly then
        v_Start_Day := Trunc(v_First_Day, 'IW');
      else
        v_Start_Day := v_Period_Start;
      end if;
    
      while v_Current_Day != v_Last_Day
      loop
        v_Pattern_Day := v_Pattern_Days((v_Current_Day - v_Start_Day) mod v_Pattern.Count_Days + 1);
      
        Htt_Util.Schedule_Day_New(o_Day              => v_Schedule_Day,
                                  i_Schedule_Date    => v_Current_Day,
                                  i_Day_Kind         => v_Pattern_Day.Day_Kind,
                                  i_Begin_Time       => v_Pattern_Day.Begin_Time,
                                  i_End_Time         => v_Pattern_Day.End_Time,
                                  i_Break_Enabled    => v_Pattern_Day.Break_Enabled,
                                  i_Break_Begin_Time => v_Pattern_Day.Break_Begin_Time,
                                  i_Break_End_Time   => v_Pattern_Day.Break_End_Time,
                                  i_Plan_Time        => v_Pattern_Day.Plan_Time);
      
        Htt_Util.Schedule_Day_Add(o_Schedule => v_Schedule, i_Day => v_Schedule_Day);
      
        Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                        i_Schedule_Date      => v_Current_Day);
        v_Day_Marks.Marks := v_Pattern_Day.Pattern_Marks;
      
        Htt_Util.Schedule_Day_Marks_Add(o_Schedule => v_Schedule, i_Day_Marks => v_Day_Marks);
      
        v_Current_Day := v_Current_Day + 1;
      end loop;
    
      v_Schedule.Pattern := v_Pattern;
    
      Htt_Api.Schedule_Save(v_Schedule);
    end loop;
  
    Dbms_Application_Info.Set_Module('Gen_Schedule_Days', 'finished Gen_Schedule_Days');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache(i_New_Company_Id number) is
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Href_Staffs s
     where s.Company_Id = i_New_Company_Id;
  
    for r in (select s.*, Rownum
                from Href_Staffs s
               where s.Company_Id = i_New_Company_Id)
    loop
      Dbms_Application_Info.Set_Module('Staff_Refresh_Cache',
                                       'updated ' || (r.Rownum - 1) || ' staff caches out of ' ||
                                       v_Total);
    
      Hpd_Core.Staff_Refresh_Cache(i_Company_Id => r.Company_Id,
                                   i_Filial_Id  => r.Filial_Id,
                                   i_Staff_Id   => r.Staff_Id);
    end loop;
  
    Dbms_Application_Info.Set_Module('Staff_Refresh_Cache', 'finished Staff_Refresh_Cache');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Zktime
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Zktime', 'migrating fingerprints and device admins');
    -- devices migrated at migr_devices
    -- persons migrated at migr_persons
    for r in (select *
                from Old_Vx_Zktime_Fprints Fp
               where Fp.Company_Id = i_Old_Company_Id
                 and exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'person_id'
                         and Uk.Old_Id = Fp.Person_Id))
    loop
      z_Hzk_Person_Fprints.Save_One(i_Company_Id => i_New_Company_Id,
                                    i_Person_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                               i_Key_Name       => 'person_id',
                                                               i_Old_Id         => r.Person_Id),
                                    i_Finger_No  => r.Finger_Id,
                                    i_Tmp        => r.Tmp);
    end loop;
  
    for r in (select *
                from Old_Vx_Zktime_Device_Persons Dp
               where Dp.Company_Id = i_Old_Company_Id
                 and Dp.Person_Role = '14'
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'device_id '
                         and p.Old_Id = Dp.Device_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'person_id '
                         and q.Old_Id = Dp.Person_Id))
    loop
      Htt_Api.Device_Add_Admin(i_Company_Id => i_New_Company_Id,
                               i_Device_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                          i_Key_Name       => 'device_id',
                                                          i_Old_Id         => r.Device_Id),
                               i_Person_Id  => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                          i_Key_Name       => 'person_id',
                                                          i_Old_Id         => r.Person_Id));
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Zktime', 'finished Migr_Zktime');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Identity_Photos
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Identity_Photos', 'migrating indentity sha''s');
    insert into Htt_Person_Photos Ph
      (Ph.Company_Id, Ph.Person_Id, Ph.Photo_Sha)
      select i_New_Company_Id,
             Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'person_id', --
                        i_Old_Id         => Pv.Person_Id),
             Pv.Sha
        from Old_Vx_Cv_Person_Vectors Pv
       where Pv.Company_Id = i_Old_Company_Id
         and not exists (select 1
                from Htt_Person_Photos Pph
               where Pph.Company_Id = i_New_Company_Id
                 and Pph.Photo_Sha = Pv.Sha)
         and exists (select 1
                from Biruni_Files Bf
               where Bf.Sha = Pv.Sha);
    Dbms_Application_Info.Set_Module('Migr_Identity_Photos', 'finished Migr_Identity_Photos');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Responsible_Persons
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Filial_Id      number := null
  ) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Responsible_Person', 'migrating responsible persons');
  
    for r in (select Np.Person_Id, q.Manager_Id Old_Manager_Id
                from Mr_Natural_Persons Np
                join Migr_Keys_Store_One p
                  on p.Company_Id = i_New_Company_Id
                 and p.Key_Name = 'person_id'
                 and p.New_Id = Np.Person_Id
                join Old_Md_Users q
                  on q.Company_Id = i_Old_Company_Id
                 and q.User_Id = p.Old_Id
               where Np.Company_Id = i_New_Company_Id
                 and q.Manager_Id is not null
                 and (i_Filial_Id is null or exists
                      (select *
                         from Mrf_Persons Fp
                        where Fp.Company_Id = i_New_Company_Id
                          and Fp.Filial_Id = i_Filial_Id
                          and Fp.Person_Id = Np.Person_Id)))
    loop
      z_Mr_Natural_Persons.Update_One(i_Company_Id            => i_New_Company_Id,
                                      i_Person_Id             => r.Person_Id,
                                      i_Responsible_Person_Id => Option_Number(Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                                          i_Key_Name       => 'person_id', --
                                                                                          i_Old_Id         => r.Old_Manager_Id)));
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Responsible_Person', 'finished Migr_Responsible_Person');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Managers
  (
    i_Old_Company_Id number,
    i_New_Company_Id number,
    i_Subcompany_Id  number,
    i_Filial_Id      number
  ) is
    r_Manager   Mrf_Division_Managers%rowtype;
    r_Person    Mr_Legal_Persons%rowtype;
    v_Person_Id number;
  
    --------------------------------------------------
    Function Get_Robot_Id
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Person_Id  number
    ) return number is
      result number;
    begin
      select p.Robot_Id
        into result
        from Mrf_Robots p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Person_Id = i_Person_Id
         and Rownum = 1;
    
      return result;
    exception
      when No_Data_Found then
      
        return null;
    end;
  
    -------------------------------------------------- 
    Function Create_Robot
    (
      i_Filial_Id   number,
      i_Division_Id number,
      i_Person_Id   number
    ) return number is
      v_Robot_Id      number;
      v_Division_Name Mhr_Divisions.Name%type;
    begin
      v_Robot_Id := Mrf_Next.Robot_Id;
    
      v_Division_Name := z_Mhr_Divisions.Load(i_Company_Id => i_New_Company_Id, --
                         i_Filial_Id => i_Filial_Id, --
                         i_Division_Id => i_Division_Id).Name;
    
      z_Mrf_Robots.Save_One(i_Company_Id  => i_New_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Robot_Id    => v_Robot_Id,
                            i_Name        => v_Division_Name || '/' || v_Robot_Id,
                            i_Person_Id   => i_Person_Id,
                            i_Division_Id => i_Division_Id,
                            i_State       => 'A');
    
      z_Mrf_Robot_Persons.Insert_One(i_Company_Id => i_New_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Robot_Id   => v_Robot_Id,
                                     i_Person_Id  => i_Person_Id);
    
      return v_Robot_Id;
    end;
  
  begin
    for r in (select *
                from Old_Vx_Hr_Divisions d
               where d.Company_Id = i_Old_Company_Id
                 and d.Manager_Id is not null
                 and exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name in ('division_id', 'filial_id')
                         and p.Old_Id = d.Division_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'person_id'
                         and q.Old_Id = d.Manager_Id)
               start with d.Division_Id = i_Subcompany_Id
              connect by d.Parent_Id = prior d.Division_Id)
    loop
      begin
        savepoint Try_Catch;
      
        if Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                      i_Key_Name       => 'filial_id',
                      i_Old_Id         => r.Division_Id) is not null then
          r_Person := z_Mr_Legal_Persons.Load(i_Company_Id => i_New_Company_Id,
                                              i_Person_Id  => i_Filial_Id);
        
          r_Person.Primary_Person_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                   i_Key_Name       => 'person_id',
                                                   i_Old_Id         => r.Manager_Id);
        
          Mr_Api.Legal_Person_Save(r_Person);
        else
          r_Manager.Company_Id  := i_New_Company_Id;
          r_Manager.Filial_Id   := i_Filial_Id;
          r_Manager.Division_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                              i_Key_Name       => 'division_id', --
                                              i_Old_Id         => r.Division_Id);
          v_Person_Id           := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                              i_Key_Name       => 'person_id',
                                              i_Old_Id         => r.Manager_Id);
          r_Manager.Manager_Id  := Get_Robot_Id(i_Company_Id => r_Manager.Company_Id,
                                                i_Filial_Id  => r_Manager.Filial_Id,
                                                i_Person_Id  => v_Person_Id);
        
          if not z_Mrf_Division_Managers.Exist(i_Company_Id  => r_Manager.Company_Id,
                                               i_Filial_Id   => r_Manager.Filial_Id,
                                               i_Division_Id => r_Manager.Division_Id) then
            Hrm_Api.Division_Manager_Save(i_Company_Id  => r_Manager.Company_Id,
                                          i_Filial_Id   => r_Manager.Filial_Id,
                                          i_Division_Id => r_Manager.Division_Id,
                                          i_Robot_Id    => r_Manager.Manager_Id);
          end if;
        end if;
      
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Vx_Hr_Divisions',
                    i_Key_Id         => r.Division_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedules_Fix
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Total number;
  begin
    select count(*)
      into v_Total
      from Htt_Schedules p
      join Migr_Keys_Store_Two St
        on St.Company_Id = p.Company_Id
       and St.Filial_Id = p.Filial_Id
       and St.Key_Name = 'schedule_id'
       and St.New_Id = p.Schedule_Id
      join Old_Vx_Ref_Schedules q
        on q.Company_Id = i_Old_Company_Id
       and q.Schedule_Id = St.Old_Id
     where p.Company_Id = i_New_Company_Id
       and (p.Input_Acceptance <> 0 or p.Output_Acceptance <> 0)
       and q.Shift_Kind in ('D', 'M');
  
    for r in (select p.*, Rownum
                from Htt_Schedules p
                join Migr_Keys_Store_Two St
                  on St.Company_Id = p.Company_Id
                 and St.Filial_Id = p.Filial_Id
                 and St.Key_Name = 'schedule_id'
                 and St.New_Id = p.Schedule_Id
                join Old_Vx_Ref_Schedules q
                  on q.Company_Id = i_Old_Company_Id
                 and q.Schedule_Id = St.Old_Id
               where p.Company_Id = i_New_Company_Id
                 and (p.Input_Acceptance <> 0 or p.Output_Acceptance <> 0)
                 and q.Shift_Kind in ('D', 'M'))
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedules_Fix',
                                       'fixed ' || (r.Rownum - 1) || ' schedules out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
        Biruni_Route.Context_Begin;
        z_Htt_Schedules.Update_One(i_Company_Id        => r.Company_Id,
                                   i_Filial_Id         => r.Filial_Id,
                                   i_Schedule_Id       => r.Schedule_Id,
                                   i_Input_Acceptance  => Option_Number(0),
                                   i_Output_Acceptance => Option_Number(0),
                                   i_Track_Duration    => Option_Number(1440));
      
        delete Htt_Schedule_Days d
         where d.Company_Id = r.Company_Id
           and d.Filial_Id = r.Filial_Id
           and d.Schedule_Id = r.Schedule_Id;
      
        delete Htt_Schedule_Origin_Days Od
         where Od.Company_Id = r.Company_Id
           and Od.Filial_Id = r.Filial_Id
           and Od.Schedule_Id = r.Schedule_Id;
      
        Gen_Schedule_Days(i_New_Company_Id => i_New_Company_Id,
                          i_Year           => 2021,
                          i_Filial_Id      => r.Filial_Id,
                          i_Schedule_Id    => r.Schedule_Id);
      
        Gen_Schedule_Days(i_New_Company_Id => i_New_Company_Id,
                          i_Year           => 2022,
                          i_Filial_Id      => r.Filial_Id,
                          i_Schedule_Id    => r.Schedule_Id);
        Biruni_Route.Context_End;
      exception
        when others then
          Biruni_Route.Context_End;
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'Htt_Schedules',
                    i_Key_Id         => r.Schedule_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedules_Fix', 'finished Migr_Schedules_Fix');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Staff_Number
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
  begin
    for r in (select p.Filial_Id, p.Staff_Id, p.Employee_Id, q.Employee_Number
                from Href_Staffs p
                join Migr_Keys_Store_One Ks
                  on Ks.Company_Id = i_New_Company_Id
                 and Ks.Key_Name = 'person_id'
                 and Ks.New_Id = p.Employee_Id
                join Old_Vx_Hr_Employees q
                  on q.Company_Id = i_Old_Company_Id
                 and q.Employee_Id = Ks.Old_Id
               where p.Company_Id = i_New_Company_Id
                 and q.Employee_Number is not null)
    loop
      begin
        savepoint Try_Catch;
        z_Href_Staffs.Update_One(i_Company_Id   => i_New_Company_Id,
                                 i_Filial_Id    => r.Filial_Id,
                                 i_Staff_Id     => r.Staff_Id,
                                 i_Staff_Number => Option_Varchar2(r.Employee_Number));
      
        z_Mhr_Employees.Update_One(i_Company_Id      => i_New_Company_Id,
                                   i_Filial_Id       => r.Filial_Id,
                                   i_Employee_Id     => r.Employee_Id,
                                   i_Employee_Number => Option_Varchar2(r.Employee_Number));
      exception
        when others then
          rollback to Try_Catch;
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'href_staffs',
                    i_Key_Id         => r.Staff_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Schedule_Marks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Schedule_Marks', 'migration pattern marks');
  
    insert into Htt_Schedule_Pattern_Marks Pm
      (Pm.Company_Id, --
       Pm.Filial_Id,
       Pm.Schedule_Id,
       Pm.Day_No,
       Pm.Begin_Time,
       Pm.End_Time)
      select i_New_Company_Id, --
             St.Filial_Id,
             St.New_Id,
             Sm.Day_No,
             Sm.Begin_Time,
             Sm.End_Time
        from Old_Vx_Ref_Schedule_Marks Sm
        join Migr_Keys_Store_Two St
          on St.Company_Id = i_New_Company_Id
         and St.Key_Name = 'schedule_id'
         and St.Old_Id = Sm.Schedule_Id
       where Sm.Company_Id = i_Old_Company_Id;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Marks', 'inserting origin marks');
  
    insert into Htt_Schedule_Origin_Day_Marks Om
      (Om.Company_Id, --
       Om.Filial_Id,
       Om.Schedule_Id,
       Om.Schedule_Date,
       Om.Begin_Time,
       Om.End_Time)
      select Od.Company_Id, --
             Od.Filial_Id,
             Od.Schedule_Id,
             Od.Schedule_Date,
             Pm.Begin_Time,
             Pm.End_Time
        from Htt_Schedule_Origin_Days Od
        join Htt_Schedule_Patterns p
          on p.Company_Id = Od.Company_Id
         and p.Filial_Id = Od.Filial_Id
         and p.Schedule_Id = Od.Schedule_Id
        join Htt_Schedule_Pattern_Marks Pm
          on Pm.Company_Id = Od.Company_Id
         and Pm.Filial_Id = Od.Filial_Id
         and Pm.Schedule_Id = Od.Schedule_Id
         and case
               when p.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Weekly then
                Trunc(Od.Schedule_Date) - Trunc(Od.Schedule_Date, 'iw') + 1
               else
                mod(Trunc(Od.Schedule_Date) - Trunc(Od.Schedule_Date, 'year') + 1, p.Count_Days)
             end = Pm.Day_No
       where Od.Company_Id = i_New_Company_Id;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Marks',
                                     'regenerating schedule days with marks');
  
    for r in (select d.Company_Id,
                     d.Filial_Id,
                     d.Schedule_Id,
                     Extract(year from d.Schedule_Date) year,
                     cast(collect(d.Schedule_Date) as Array_Date) Dates
                from Htt_Schedule_Origin_Days d
               where d.Company_Id = i_New_Company_Id
                 and exists (select *
                        from Htt_Schedule_Origin_Day_Marks Dm
                       where Dm.Company_Id = d.Company_Id
                         and Dm.Filial_Id = d.Filial_Id
                         and Dm.Schedule_Id = d.Schedule_Id
                         and Dm.Schedule_Date = d.Schedule_Date)
               group by d.Company_Id, --
                        d.Filial_Id,
                        d.Schedule_Id,
                        Extract(year from d.Schedule_Date))
    loop
      Biruni_Route.Context_Begin;
      Htt_Core.Regen_Schedule_Days(i_Company_Id  => r.Company_Id,
                                   i_Filial_Id   => r.Filial_Id,
                                   i_Schedule_Id => r.Schedule_Id,
                                   i_Year        => r.Year,
                                   i_Dates       => r.Dates);
      Biruni_Route.Context_End;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Marks', 'finished Migr_Schedule_Marks');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Basic_Oper_Types(i_New_Company_Id number) is
    v_Oper_Type  Hpr_Pref.Oper_Type_Rt;
    r_Oper_Group Hpr_Oper_Groups%rowtype;
  
    v_Exists boolean;
    v_Dummy  number;
  begin
    Dbms_Application_Info.Set_Module('Create_Basic_Oper_Types',
                                     'creating monthly_pay and perf_bonus');
  
    begin
      v_Dummy  := Mpr_Util.Oper_Type_Id_By_Name(i_Company_Id => i_New_Company_Id,
                                                i_Name       => c_Perf_Bonus_Name);
      v_Exists := v_Dummy is not null;
    
      v_Exists := true;
    exception
      when others then
        v_Exists := false;
    end;
  
    if not v_Exists then
      r_Oper_Group := z_Hpr_Oper_Groups.Load(i_Company_Id    => i_New_Company_Id,
                                             i_Oper_Group_Id => Hpr_Util.Oper_Group_Id(i_Company_Id => i_New_Company_Id,
                                                                                       i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf));
    
      Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                             i_Company_Id             => i_New_Company_Id,
                             i_Oper_Type_Id           => Mpr_Next.Oper_Type_Id,
                             i_Oper_Group_Id          => r_Oper_Group.Oper_Group_Id,
                             i_Estimation_Type        => r_Oper_Group.Estimation_Type,
                             i_Estimation_Formula     => r_Oper_Group.Estimation_Formula,
                             i_Operation_Kind         => r_Oper_Group.Operation_Kind,
                             i_Name                   => c_Perf_Bonus_Name,
                             i_Short_Name             => null,
                             i_Accounting_Type        => Mpr_Pref.c_At_Employee,
                             i_Corr_Coa_Id            => null,
                             i_Corr_Ref_Set           => null,
                             i_Income_Tax_Exists      => null,
                             i_Income_Tax_Rate        => null,
                             i_Pension_Payment_Exists => null,
                             i_Pension_Payment_Rate   => null,
                             i_Social_Payment_Exists  => null,
                             i_Social_Payment_Rate    => null,
                             i_Note                   => null,
                             i_State                  => 'A',
                             i_Code                   => null);
    
      Hpr_Api.Oper_Type_Save(v_Oper_Type);
    end if;
  
    Dbms_Application_Info.Set_Module('Create_Basic_Oper_Types', 'finished Create_Basic_Oper_Types');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Biruni_Files is
  begin
    Dbms_Application_Info.Set_Module('Migr_Biruni_Files', 'migrating file sha''s');
    insert into Biruni_Files
      (Sha, Created_On, File_Size, File_Name, Content_Type)
      (select Sha, Created_On, File_Size, File_Name, Content_Type
         from Old_Biruni_Files Old_Bf
        where not exists (select 1
                 from Biruni_Files New_Bf
                where New_Bf.Sha = Old_Bf.Sha));
    Dbms_Application_Info.Set_Module('Migr_Biruni_Files', 'finished Migr_Biruni_Files');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Overtimes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Total      number;
    v_Last_Month date;
    v_Journal    Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes  Hpd_Pref.Overtime_Nt;
    v_Person_Id  number;
    v_Staff_Id   number;
  
    Function Exists_Overtime(i_Overtime_Id number) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Migr_Used_Keys Uk
       where Uk.Company_Id = i_New_Company_Id
         and Uk.Key_Name = 'overtime_id'
         and Uk.Old_Id = i_Overtime_Id;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    select count(*)
      into v_Total
      from Old_Vx_Tp_Overtimes t
     where t.Company_Id = i_Old_Company_Id
       and t.Status = 'C'
       and not exists (select 1
              from Migr_Used_Keys p
             where p.Company_Id = i_New_Company_Id
               and p.Key_Name = 'overtime_id'
               and p.Old_Id = t.Overtime_Id)
       and exists (select 1
              from Migr_Used_Keys q
             where q.Company_Id = i_New_Company_Id
               and q.Key_Name = 'person_id'
               and q.Old_Id = t.Employee_Id);
  
    for m in (select St.New_Id Filial_Id, Trunc(t.Overtime_Date, 'MON') Mon, t.Employee_Id
                from Old_Vx_Tp_Overtimes t
                join Old_Vx_Hr_Employees Emp
                  on Emp.Company_Id = t.Company_Id
                 and Emp.Employee_Id = t.Employee_Id
                join Migr_Keys_Store_One St
                  on St.Company_Id = i_New_Company_Id
                 and St.Key_Name in ('division_filial_id', 'filial_id')
                 and St.Old_Id = Emp.c_Division_Id
               where t.Company_Id = i_Old_Company_Id
                 and t.Status = 'C'
                 and not exists (select 1
                        from Migr_Used_Keys p
                       where p.Company_Id = i_New_Company_Id
                         and p.Key_Name = 'overtime_id'
                         and p.Old_Id = t.Overtime_Id)
                 and exists (select 1
                        from Migr_Used_Keys q
                       where q.Company_Id = i_New_Company_Id
                         and q.Key_Name = 'person_id'
                         and q.Old_Id = t.Employee_Id)
               group by St.New_Id, Trunc(t.Overtime_Date, 'MON'), t.Employee_Id
               order by 1, 2)
    loop
      if not Fazo.Equal(v_Last_Month, m.Mon) then
        if v_Journal.Company_Id is not null then
          Hpd_Api.Overtime_Journal_Save(v_Journal);
        end if;
      
        v_Journal := null;
        Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                      i_Company_Id       => i_New_Company_Id,
                                      i_Filial_Id        => m.Filial_Id,
                                      i_Journal_Id       => Hpd_Next.Journal_Id,
                                      i_Journal_Number   => null,
                                      i_Journal_Date     => m.Mon,
                                      i_Journal_Name     => 'migred overtimes');
      end if;
    
      v_Last_Month := m.Mon;
    
      v_Overtimes := Hpd_Pref.Overtime_Nt();
    
      for r in (select w.Overtime, w.Timesheet_Date, t.*, Rownum
                  from Old_Vx_Tp_Overtimes t
                  join Old_Vx_Tp_Overtime_Dates w
                    on t.Company_Id = w.Company_Id
                   and t.Overtime_Id = w.Overtime_Id
                 where t.Company_Id = i_Old_Company_Id
                   and Trunc(t.Overtime_Date, 'MON') = m.Mon
                   and t.Employee_Id = m.Employee_Id
                   and t.Status = 'C'
                   and not exists (select 1
                          from Migr_Used_Keys p
                         where p.Company_Id = i_New_Company_Id
                           and p.Key_Name = 'overtime_id'
                           and p.Old_Id = t.Overtime_Id)
                   and exists (select 1
                          from Migr_Used_Keys q
                         where q.Company_Id = i_New_Company_Id
                           and q.Key_Name = 'person_id'
                           and q.Old_Id = t.Employee_Id)
                   and exists (select 1
                          from Old_Vx_Tp_Timesheets Tt
                         where Tt.Company_Id = w.Company_Id
                           and Tt.Employee_Id = w.Employee_Id
                           and Tt.Timesheet_Date = w.Timesheet_Date
                           and Tt.Overtime > 0))
      loop
        Dbms_Application_Info.Set_Module('Migr_Overtimes',
                                         'inserted ' || (r.Rownum - 1) || ' overtime out of ' ||
                                         v_Total);
      
        Hpd_Util.Overtime_Add(p_Overtimes        => v_Overtimes,
                              i_Overtime_Date    => r.Timesheet_Date,
                              i_Overtime_Seconds => r.Overtime * 60);
      
        if not Exists_Overtime(r.Overtime_Id) then
          Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                          i_Key_Name       => 'overtime_id', --
                          i_Key_Id         => r.Overtime_Id);
        end if;
      end loop;
    
      v_Person_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                i_Key_Name       => 'person_id', --
                                i_Old_Id         => m.Employee_Id);
    
      v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_New_Company_Id,
                                                   i_Filial_Id   => m.Filial_Id,
                                                   i_Employee_Id => v_Person_Id,
                                                   i_Date        => sysdate);
    
      Hpd_Util.Journal_Add_Overtime(p_Journal     => v_Journal,
                                    i_Staff_Id    => v_Staff_Id,
                                    i_Month       => m.Mon,
                                    i_Overtime_Id => Hpd_Next.Overtime_Id,
                                    i_Overtimes   => v_Overtimes);
    
    end loop;
  
    if v_Journal.Company_Id is not null then
      Hpd_Api.Overtime_Journal_Save(v_Journal);
    end if;
  
    Dbms_Application_Info.Set_Module('Migr_Overtimes', 'finished Migr_Overtime');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Schedule_Journal Hpd_Pref.Schedule_Change_Journal_Rt;
  begin
    for St in (select p.Staff_Id,
                      p.Filial_Id,
                      p.Hiring_Date,
                      p.Dismissal_Date,
                      St.Old_Id Old_Employee_Id
                 from Href_Staffs p
                 join Migr_Keys_Store_One St
                   on St.Company_Id = p.Company_Id
                  and St.Key_Name = 'person_id'
                  and St.New_Id = p.Employee_Id
                where p.Company_Id = i_New_Company_Id
                  and p.State = 'A')
    loop
      for r in (select q.*
                  from Old_Vx_Tp_Timetables q
                 where q.Company_Id = i_Old_Company_Id
                   and q.Employee_Id = St.Old_Employee_Id
                   and not exists (select *
                          from Migr_Used_Keys Uk
                         where Uk.Company_Id = i_New_Company_Id
                           and Uk.Key_Name = c_Timetable_Key
                           and Uk.Old_Id = q.Timetable_Id)
                 order by q.Begin_Date)
      loop
        Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Schedule_Journal,
                                             i_Company_Id     => i_New_Company_Id,
                                             i_Filial_Id      => St.Filial_Id,
                                             i_Journal_Id     => Hpd_Next.Journal_Id,
                                             i_Journal_Number => null,
                                             i_Journal_Date   => r.Begin_Date,
                                             i_Journal_Name   => null,
                                             i_Division_Id    => null,
                                             i_Begin_Date     => Greatest(r.Begin_Date,
                                                                          St.Hiring_Date),
                                             i_End_Date       => Greatest(r.End_Date, St.Hiring_Date));
      
        Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Schedule_Journal,
                                             i_Page_Id     => Hpd_Next.Page_Id,
                                             i_Staff_Id    => St.Staff_Id,
                                             i_Schedule_Id => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                                         i_Key_Name       => 'schedule_id',
                                                                         i_Old_Id         => r.Schedule_Id,
                                                                         i_Filial_Id      => St.Filial_Id));
        Hpd_Api.Schedule_Change_Journal_Save(v_Schedule_Journal);
        Hpd_Api.Journal_Post(i_Company_Id => v_Schedule_Journal.Company_Id,
                             i_Filial_Id  => v_Schedule_Journal.Filial_Id,
                             i_Journal_Id => v_Schedule_Journal.Journal_Id);
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => c_Timetable_Key, --                        
                        i_Key_Id         => r.Timetable_Id);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Gps_Tracks
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Track    Htt_Pref.Gps_Track_Data_Rt;
    v_Latlng   Array_Varchar2;
    v_Tot_Dist number;
    v_Track_Id number;
    v_Blob     blob;
  
    v_Filial_Head number := Md_Pref.Filial_Head(i_New_Company_Id);
    v_User_Id     number := Md_Pref.User_System(i_New_Company_Id);
  
    v_Total number;
  
    -------------------------------------------------- 
    Procedure Writeappend(i_Text varchar2) is
    begin
      Dbms_Lob.Writeappend(v_Blob, Length(i_Text), Utl_Raw.Cast_To_Raw(i_Text));
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Gps_Tracks', 'started Migr_Gps_Tracks');
  
    Biruni_Route.Clear_Globals;
    Ui_Context.Init(i_User_Id => v_User_Id, i_Project_Code => 'vhr', i_Filial_Id => v_Filial_Head);
  
    Cache_Filial_Ids(i_New_Company_Id);
  
    -- total count
    select count(*)
      into v_Total
      from (select q.Person_Id, q.Track_Date, St.New_Id as New_Person_Id
              from Old_Vx_Org_Gps_Tracks q
              join Migr_Keys_Store_One St
                on St.Company_Id = i_New_Company_Id
               and St.Key_Name = 'person_id'
               and St.Old_Id = q.Person_Id
             where q.Company_Id = i_Old_Company_Id
               and not exists (select 1
                      from Htt_Gps_Tracks w
                     where w.Company_Id = i_New_Company_Id
                       and w.Person_Id = St.New_Id
                       and w.Track_Date = q.Track_Date)
             group by q.Person_Id, q.Track_Date, St.New_Id);
  
    for Gps_d in (select q.*, Rownum
                    from (select q.Person_Id, q.Track_Date, St.New_Id as New_Person_Id
                            from Old_Vx_Org_Gps_Tracks q
                            join Migr_Keys_Store_One St
                              on St.Company_Id = i_New_Company_Id
                             and St.Key_Name = 'person_id'
                             and St.Old_Id = q.Person_Id
                           where q.Company_Id = i_Old_Company_Id
                             and not exists (select 1
                                    from Htt_Gps_Tracks w
                                   where w.Company_Id = i_New_Company_Id
                                     and w.Person_Id = St.New_Id
                                     and w.Track_Date = q.Track_Date)
                           group by q.Person_Id, q.Track_Date, St.New_Id) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Gps_Tracks',
                                       'inserted ' || (Gps_d.Rownum - 1) ||
                                       ' days gps tracks out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        -- total_distance
        select Nvl(Trunc(sum(Power(Power(69.1 * (Lat2 - Lat1), 2) + Power(53.0 * (Lng2 - Lng1), 2),
                                   0.5)) / 0.00062137),
                   0)
          into v_Tot_Dist
          from (select Track_Date Track_Date1,
                       Lat Lat1,
                       Lng Lng1,
                       Lag(Track_Date) Over(order by Rownum) Track_Date2,
                       Lag(Lat) Over(order by Rownum) Lat2,
                       Lag(Lng) Over(order by Rownum) Lng2
                  from (select q.Track_Date,
                               Regexp_Substr(q.Latlng, '^[0-9\.]+') Lat,
                               Regexp_Substr(q.Latlng, '[0-9\.]+$') Lng
                          from Old_Vx_Org_Gps_Tracks q
                         where q.Company_Id = i_Old_Company_Id
                           and q.Track_Date = Gps_d.Track_Date
                           and q.Person_Id = Gps_d.Person_Id
                           and q.Accuracy <= 50
                         order by q.Track_Time))
         where Lat2 is not null
           and Track_Date1 = Track_Date2;
      
        -- blob data
        Dbms_Lob.Createtemporary(v_Blob, false);
        Dbms_Lob.Open(v_Blob, Dbms_Lob.Lob_Readwrite);
      
        for Track in (select *
                        from Old_Vx_Org_Gps_Tracks w
                       where w.Company_Id = i_Old_Company_Id
                         and w.Person_Id = Gps_d.Person_Id
                         and w.Track_Date = Gps_d.Track_Date
                       order by w.Track_Time)
        loop
          v_Latlng := Fazo.Split(Track.Latlng, ',');
        
          Writeappend(to_char(Track.Track_Time, 'hh24:mi:ss') || Chr(9) || v_Latlng(1) || Chr(9) ||
                      v_Latlng(2) || Chr(9) || Track.Accuracy || Chr(9) || Track.Provider ||
                      Chr(10));
        
          Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                          i_Key_Name       => 'gps_track_id',
                          i_Key_Id         => Track.Track_Id);
        end loop;
      
        Dbms_Lob.Close(v_Blob);
      
        for f in 1 .. g_Filial_Ids.Count
        loop
          if g_Filial_Ids(f) = v_Filial_Head then
            continue;
          end if;
        
          v_Track_Id := Htt_Next.Gps_Track_Id;
        
          insert into Htt_Gps_Tracks
            (Company_Id,
             Filial_Id,
             Track_Id,
             Person_Id,
             Track_Date,
             Total_Distance,
             Calculated,
             Created_By,
             Created_On,
             Modified_By,
             Modified_On)
          values
            (i_New_Company_Id,
             g_Filial_Ids(f),
             v_Track_Id,
             Gps_d.New_Person_Id,
             Gps_d.Track_Date,
             v_Tot_Dist,
             'Y',
             v_User_Id,
             Current_Timestamp,
             v_User_Id,
             Current_Timestamp);
        
          insert into Htt_Gps_Track_Datas
            (Company_Id, Filial_Id, Track_Id, Data)
          values
            (i_New_Company_Id, g_Filial_Ids(f), v_Track_Id, v_Blob);
        end loop;
      
        commit;
      exception
        when others then
          rollback to Try_Catch;
        
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'htt_gps_tracks' ||
                                        to_char(Gps_d.Track_Date, Href_Pref.c_Date_Format_Day),
                    i_Key_Id         => Gps_d.Person_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    commit;
  
    -- gps track parts
    -- total count
    select count(*)
      into v_Total
      from Old_Vx_Org_Gps_Tracks q
      join Migr_Keys_Store_One St
        on St.Company_Id = i_New_Company_Id
       and St.Key_Name = 'person_id'
       and St.Old_Id = q.Person_Id
     where q.Company_Id = i_Old_Company_Id
       and not exists (select *
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'gps_track_id'
               and Uk.Old_Id = q.Track_Id);
  
    v_Track.Company_Id := i_New_Company_Id;
  
    for r in (select q.*, St.New_Id as New_Person_Id, Rownum
                from Old_Vx_Org_Gps_Tracks q
                join Migr_Keys_Store_One St
                  on St.Company_Id = i_New_Company_Id
                 and St.Key_Name = 'person_id'
                 and St.Old_Id = q.Person_Id
               where q.Company_Id = i_Old_Company_Id
                 and not exists (select *
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'gps_track_id'
                         and Uk.Old_Id = q.Track_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Gps_Tracks',
                                       'inserted ' || (r.Rownum - 1) || ' gps track parts out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Latlng := Fazo.Split(r.Latlng, ',');
      
        v_Track.Person_Id  := r.New_Person_Id;
        v_Track.Track_Time := r.Track_Time;
        v_Track.Track_Date := Trunc(v_Track.Track_Time);
        v_Track.Lat        := v_Latlng(1);
        v_Track.Lng        := v_Latlng(2);
        v_Track.Accuracy   := r.Accuracy;
        v_Track.Provider   := r.Provider;
      
        for f in 1 .. g_Filial_Ids.Count
        loop
          if g_Filial_Ids(f) = v_Filial_Head then
            continue;
          end if;
        
          v_Track.Filial_Id := g_Filial_Ids(f);
          v_Track.Track_Id  := Htt_Util.Gps_Track_Id(i_Company_Id => v_Track.Company_Id,
                                                     i_Filial_Id  => v_Track.Filial_Id,
                                                     i_Person_Id  => v_Track.Person_Id,
                                                     i_Track_Date => v_Track.Track_Date);
        
          if v_Track.Track_Id is null then
            v_Track.Track_Id := Htt_Next.Gps_Track_Id;
          end if;
        
          Htt_Api.Gps_Track_Add(v_Track);
        end loop;
      
        Insert_Used_Key(i_New_Company_Id => i_New_Company_Id,
                        i_Key_Name       => 'gps_track_id',
                        i_Key_Id         => r.Track_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Log_Error(i_New_Company_Id => i_New_Company_Id,
                    i_Table_Name     => 'htt_gps_tracks',
                    i_Key_Id         => r.Track_Id,
                    i_Error_Message  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                        Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Gps_Tracks', 'finished Migr_Gps_Tracks');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Users_For_Employees(i_New_Company_Id number) is
    v_User_System number := Md_Pref.User_System(i_New_Company_Id);
    v_User_Ids    Array_Number;
  begin
    Biruni_Route.Clear_Globals;
  
    Ui_Context.Init(i_User_Id      => v_User_System,
                    i_Project_Code => Href_Pref.c_Pc_Verifix_Hr,
                    i_Filial_Id    => Md_Pref.Filial_Head(i_New_Company_Id));
  
    select e.Employee_Id
      bulk collect
      into v_User_Ids
      from Mhr_Employees e
     where e.Company_Id = i_New_Company_Id
       and not exists (select 1
              from Md_Users u
             where u.Company_Id = i_New_Company_Id
               and u.User_Id = e.Employee_Id)
     group by e.Employee_Id;
  
    insert into Md_Users
      (Company_Id,
       User_Id,
       name,
       State,
       User_Kind,
       Gender,
       Created_By,
       Created_On,
       Modified_By,
       Modified_On)
      select Np.Company_Id,
             Np.Person_Id as User_Id,
             Np.Name,
             'A' as State,
             Md_Pref.c_Uk_Normal as User_Kind,
             Np.Gender,
             v_User_System as Created_By,
             Current_Timestamp as Created_On,
             v_User_System as Modified_By,
             Current_Timestamp as Modified_On
        from Mr_Natural_Persons Np
       where Np.Company_Id = i_New_Company_Id
         and Np.Person_Id in (select *
                                from table(v_User_Ids));
  
    insert into Md_User_Filials
      (Company_Id, User_Id, Filial_Id)
      select e.Company_Id, e.Employee_Id as User_Id, e.Filial_Id
        from Mhr_Employees e
       where e.Company_Id = i_New_Company_Id
         and not exists (select 1
                from Md_User_Filials Uf
               where Uf.Company_Id = i_New_Company_Id
                 and Uf.Filial_Id = e.Filial_Id
                 and Uf.User_Id = e.Employee_Id);
  
    commit;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Regions
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    r_Region Md_Regions%rowtype;
    v_Total  number;
  
    -------------------------------------------------- 
    Function Get_Pcode_Region_Id(i_Pcode varchar2) return varchar2 is
      v_Pcode varchar2(20);
    begin
      case i_Pcode
        when 'CORE:1' then
          v_Pcode := 'CORE:1';
        when 'CORE:2' then
          v_Pcode := 'CORE:2';
        when 'CORE:3' then
          v_Pcode := 'CORE:3';
        when 'CORE:4' then
          v_Pcode := 'CORE:4';
        when 'CORE:5' then
          v_Pcode := 'CORE:5';
        when 'CORE:6' then
          v_Pcode := 'CORE:6';
        when 'CORE:7' then
          v_Pcode := 'CORE:7';
        when 'CORE:8' then
          v_Pcode := 'CORE:8';
        when 'CORE:9' then
          v_Pcode := 'CORE:9';
        when 'CORE:10' then
          v_Pcode := 'CORE:10';
        when 'CORE:11' then
          v_Pcode := 'CORE:11';
        when 'CORE:12' then
          v_Pcode := 'CORE:12';
        when 'CORE:13' then
          v_Pcode := 'CORE:13';
        when 'CORE:14' then
          v_Pcode := 'CORE:14';
        when 'CORE:15' then
          v_Pcode := 'CORE:15';
        when 'CORE:16' then
          v_Pcode := 'CORE:16';
        when 'CORE:17' then
          v_Pcode := 'CORE:17';
        when 'CORE:18' then
          v_Pcode := 'CORE:18';
        when 'CORE:19' then
          v_Pcode := 'CORE:19';
        when 'CORE:20' then
          v_Pcode := 'CORE:20';
        when 'CORE:21' then
          v_Pcode := 'CORE:21';
        when 'CORE:22' then
          v_Pcode := 'CORE:22';
        when 'CORE:23' then
          v_Pcode := 'CORE:23';
        when 'CORE:24' then
          v_Pcode := 'CORE:24';
        when 'CORE:25' then
          v_Pcode := 'CORE:25';
        when 'CORE:26' then
          v_Pcode := 'CORE:26';
        when 'CORE:27' then
          v_Pcode := 'CORE:27';
        when 'CORE:28' then
          v_Pcode := 'CORE:28';
        when 'CORE:29' then
          v_Pcode := 'CORE:29';
        when 'CORE:30' then
          v_Pcode := 'CORE:30';
        when 'CORE:31' then
          v_Pcode := 'CORE:31';
        when 'CORE:32' then
          v_Pcode := 'CORE:32';
        when 'CORE:33' then
          v_Pcode := 'CORE:33';
        when 'CORE:34' then
          v_Pcode := 'CORE:34';
        when 'CORE:35' then
          v_Pcode := 'CORE:35';
        when 'CORE:36' then
          v_Pcode := 'CORE:36';
        when 'CORE:37' then
          v_Pcode := 'CORE:37';
        when 'CORE:38' then
          v_Pcode := 'CORE:38';
        when 'CORE:39' then
          v_Pcode := 'CORE:39';
        when 'CORE:40' then
          v_Pcode := 'CORE:40';
        when 'CORE:41' then
          v_Pcode := 'CORE:41';
        when 'CORE:42' then
          v_Pcode := 'CORE:42';
        when 'CORE:50' then
          v_Pcode := 'CORE:43';
        when 'CORE:71' then
          v_Pcode := 'CORE:44';
        when 'CORE:72' then
          v_Pcode := 'CORE:45';
        when 'CORE:73' then
          v_Pcode := 'CORE:46';
        when 'CORE:74' then
          v_Pcode := 'CORE:47';
        when 'CORE:75' then
          v_Pcode := 'CORE:48';
        when 'CORE:76' then
          v_Pcode := 'CORE:49';
        when 'CORE:77' then
          v_Pcode := 'CORE:50';
        when 'CORE:78' then
          v_Pcode := 'CORE:51';
        when 'CORE:79' then
          v_Pcode := 'CORE:52';
        when 'CORE:80' then
          v_Pcode := 'CORE:53';
        when 'CORE:81' then
          v_Pcode := 'CORE:54';
        when 'CORE:82' then
          v_Pcode := 'CORE:55';
        when 'CORE:83' then
          v_Pcode := 'CORE:56';
        when 'CORE:84' then
          v_Pcode := 'CORE:57';
        when 'CORE:85' then
          v_Pcode := 'CORE:58';
        when 'CORE:86' then
          v_Pcode := 'CORE:59';
        when 'CORE:51' then
          v_Pcode := 'CORE:60';
        when 'CORE:52' then
          v_Pcode := 'CORE:61';
        when 'CORE:53' then
          v_Pcode := 'CORE:62';
      end case;
    
      return Md_Pref.Region_Id(i_Company_Id => i_New_Company_Id, i_Pcode => v_Pcode);
    end;
  begin
    select count(*)
      into v_Total
      from Old_Md_Regions Rg
     where Rg.Company_Id = i_Old_Company_Id
       and not exists (select 1
              from Migr_Used_Keys Uk
             where Uk.Company_Id = i_New_Company_Id
               and Uk.Key_Name = 'region_id'
               and Uk.Old_Id = Rg.Region_Id);
  
    Dbms_Application_Info.Set_Module('Migr_Regions', 'inserting regions, total num: ' || v_Total);
  
    for r in (select Rg.*
                from Old_Md_Regions Rg
               where Rg.Company_Id = i_Old_Company_Id
                 and not exists (select 1
                        from Migr_Used_Keys Uk
                       where Uk.Company_Id = i_New_Company_Id
                         and Uk.Key_Name = 'region_id'
                         and Uk.Old_Id = Rg.Region_Id)
               start with Rg.Parent_Id is null
              connect by prior Rg.Region_Id = Rg.Parent_Id)
    loop
      if r.Pcode is not null then
        r_Region.Region_Id := Get_Pcode_Region_Id(r.Pcode);
      else
        z_Md_Regions.Init(p_Row         => r_Region,
                          i_Company_Id  => i_New_Company_Id,
                          i_Region_Id   => Md_Next.Region_Id,
                          i_Name        => r.Name,
                          i_Region_Kind => r.Region_Kind,
                          i_State       => r.State,
                          i_Parent_Id   => Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                                      i_Key_Name       => 'region_id', --
                                                      i_Old_Id         => r.Region_Id),
                          i_Latlng      => r.Latlng,
                          i_Code        => null,
                          i_Pcode       => r.Pcode);
      
        Md_Api.Region_Save(r_Region);
      end if;
    
      Insert_Key(i_New_Company_Id => i_New_Company_Id,
                 i_Key_Name       => 'region_id',
                 i_Old_Id         => r.Region_Id,
                 i_New_Id         => r_Region.Region_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Restore_Org_Sctruct
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (select St.Company_Id,
                     St.Filial_Id,
                     (select q.Robot_Id
                        from Href_Staffs q
                       where q.Company_Id = St.Company_Id
                         and q.Filial_Id = St.Filial_Id
                         and q.Staff_Id = St.Staff_Id) Robot_Id,
                     St.Old_Division_Id,
                     St.New_Division_Id
                from Migr_Changed_Staffs St
               where St.Company_Id = i_Company_Id
                 and St.Filial_Id = i_Filial_Id)
    loop
      z_Mrf_Robots.Update_One(i_Company_Id  => r.Company_Id,
                              i_Filial_Id   => r.Filial_Id,
                              i_Robot_Id    => r.Robot_Id,
                              i_Division_Id => Option_Number(r.Old_Division_Id));
    
      Hrm_Api.Division_Manager_Delete(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Division_Id => r.Old_Division_Id);
    end loop;
    Biruni_Route.Context_End;
  
    update Hpd_Page_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    update Hpd_Trans_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    Hpd_Core.Staff_Refresh_Cache(i_Company_Id);
  
    delete Mhr_Divisions p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and exists (select 1
              from Migr_Changed_Staffs q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.New_Division_Id = p.Division_Id);
  
    delete Migr_Changed_Staffs p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Subordinated_Divisions_V1
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Division_Id number;
    r_Division    Mhr_Divisions%rowtype;
  begin
    Biruni_Route.Context_Begin;
  
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (with Employees as
                 (select q.Company_Id,
                        q.Filial_Id,
                        q.Robot_Id,
                        q.Division_Id,
                        q.Employee_Id,
                        Np.Name,
                        Np.Responsible_Person_Id
                   from Href_Staffs q
                   join Mr_Natural_Persons Np
                     on Np.Company_Id = q.Company_Id
                    and Np.Person_Id = q.Employee_Id
                    and Np.State = 'A'
                  where q.Company_Id = i_Company_Id
                    and q.Filial_Id = i_Filial_Id
                    and q.State = 'A'
                    and q.Dismissal_Date is null)
                select Ep.Company_Id,
                       Ep.Filial_Id,
                       Ep.Robot_Id,
                       Ep.Name,
                       Qr.Division_Id,
                       (select count(*)
                          from (select k.Responsible_Person_Id
                                  from Employees k
                                 where k.Responsible_Person_Id is not null
                                   and k.Division_Id = Qr.Division_Id
                                 group by k.Responsible_Person_Id)) Div_Child_Cnt
                  from Employees Ep
                  join (select t.Responsible_Person_Id, t.Division_Id
                          from Employees t
                         where t.Responsible_Person_Id is not null
                         group by t.Responsible_Person_Id, t.Division_Id) Qr
                    on Qr.Responsible_Person_Id = Ep.Employee_Id
                 where exists (select 1
                          from Mr_Natural_Persons w
                         where w.Company_Id = Ep.Company_Id
                           and w.Responsible_Person_Id = Ep.Employee_Id))
    loop
      if r.Div_Child_Cnt > 1 then
        v_Division_Id          := Mhr_Next.Division_Id;
        r_Division.Company_Id  := r.Company_Id;
        r_Division.Filial_Id   := r.Filial_Id;
        r_Division.Division_Id := v_Division_Id;
        r_Division.Parent_Id   := r.Division_Id;
        r_Division.State       := 'A';
        r_Division.Name        := 'Команда (' || r.Name || ')';
        r_Division.Opened_Date := Trunc(sysdate);
      
        Mhr_Api.Division_Save(r_Division);
      else
        v_Division_Id := r.Division_Id;
      end if;
      Hrm_Api.Division_Manager_Save(i_Company_Id  => r.Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Division_Id => v_Division_Id,
                                    i_Robot_Id    => r.Robot_Id);
    end loop;
  
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Divisions_V1
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Robot_Id,
                     q.Staff_Id,
                     q.Division_Id Old_Division_Id,
                     (select Dm.Division_Id
                        from Hrm_Division_Managers Dm
                       where Dm.Company_Id = q.Company_Id
                         and Dm.Filial_Id = q.Filial_Id
                         and Dm.Employee_Id = Np.Responsible_Person_Id
                         and exists (select 1
                                from Mhr_Divisions w
                               where w.Company_Id = Dm.Company_Id
                                 and w.Filial_Id = Dm.Filial_Id
                                 and w.Division_Id = Dm.Division_Id
                                 and w.Parent_Id = q.Division_Id)) New_Division_Id
                from Href_Staffs q
                join Mr_Natural_Persons Np
                  on Np.Company_Id = q.Company_Id
                 and Np.Person_Id = q.Employee_Id
                 and Np.State = 'A'
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A'
                 and q.Dismissal_Date is null
                 and Np.Responsible_Person_Id is not null
                 and not exists (select 1
                        from Hrm_Division_Managers k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Division_Id = q.Division_Id
                         and k.Employee_Id = Np.Responsible_Person_Id))
    loop
      z_Mrf_Robots.Update_One(i_Company_Id  => r.Company_Id,
                              i_Filial_Id   => r.Filial_Id,
                              i_Robot_Id    => r.Robot_Id,
                              i_Division_Id => Option_Number(r.New_Division_Id));
    
      insert into Migr_Changed_Staffs
        (Company_Id, Filial_Id, Staff_Id, Old_Division_Id, New_Division_Id)
      values
        (r.Company_Id, r.Filial_Id, r.Staff_Id, r.Old_Division_Id, r.New_Division_Id);
    end loop;
    Biruni_Route.Context_End;
  
    update Hpd_Page_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    update Hpd_Trans_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    Hpd_Core.Staff_Refresh_Cache(i_Company_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Subordinated_Divisions_V2
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Division_Id number;
    v_Parent_Id   number;
    r_Division    Mhr_Divisions%rowtype;
  
    v_Relation_Cache Fazo.Number_Id_Aat;
  begin
    Biruni_Route.Context_Begin;
  
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (select *
                from Hrm_Division_Managers Dm
               where Dm.Company_Id = i_Company_Id
                 and Dm.Filial_Id = i_Filial_Id)
    loop
      Hrm_Api.Division_Manager_Delete(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Division_Id => r.Division_Id);
    end loop;
  
    for r in (select *
                from (select q.Company_Id,
                             q.Filial_Id,
                             q.Robot_Id,
                             q.Division_Id,
                             q.Employee_Id,
                             Np.Name,
                             Np.Responsible_Person_Id
                        from Href_Staffs q
                        join Mr_Natural_Persons Np
                          on Np.Company_Id = q.Company_Id
                         and Np.Person_Id = q.Employee_Id
                         and Np.State = 'A'
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.State = 'A'
                         and q.Dismissal_Date is null
                         and exists (select 1
                                from Mr_Natural_Persons w
                               where w.Company_Id = q.Company_Id
                                 and w.Responsible_Person_Id = q.Employee_Id
                                 and w.State = 'A')) Qr
               start with Qr.Responsible_Person_Id is null
              connect by Qr.Responsible_Person_Id = prior Qr.Employee_Id)
    loop
      v_Division_Id := Mhr_Next.Division_Id;
    
      if v_Relation_Cache.Exists(r.Responsible_Person_Id) then
        v_Parent_Id := v_Relation_Cache(r.Responsible_Person_Id);
      else
        v_Parent_Id := r.Division_Id;
      end if;
    
      r_Division.Company_Id  := r.Company_Id;
      r_Division.Filial_Id   := r.Filial_Id;
      r_Division.Division_Id := v_Division_Id;
      r_Division.Parent_Id   := v_Parent_Id;
      r_Division.State       := 'A';
      r_Division.Name        := 'Команда (' || r.Name || ')';
      r_Division.Opened_Date := Trunc(sysdate);
    
      Mhr_Api.Division_Save(r_Division);
      Hrm_Api.Division_Manager_Save(i_Company_Id  => r.Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Division_Id => v_Division_Id,
                                    i_Robot_Id    => r.Robot_Id);
    
      v_Relation_Cache(r.Employee_Id) := v_Division_Id;
    end loop;
  
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Divisions_V2
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Robot_Id,
                     q.Staff_Id,
                     q.Division_Id Old_Division_Id,
                     (select Dm.Division_Id
                        from Hrm_Division_Managers Dm
                       where Dm.Company_Id = q.Company_Id
                         and Dm.Filial_Id = q.Filial_Id
                         and Dm.Employee_Id = Np.Responsible_Person_Id) New_Division_Id
                from Href_Staffs q
                join Mr_Natural_Persons Np
                  on Np.Company_Id = q.Company_Id
                 and Np.Person_Id = q.Employee_Id
                 and Np.State = 'A'
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A'
                 and q.Dismissal_Date is null
                 and Np.Responsible_Person_Id is not null
                 and not exists (select 1
                        from Hrm_Division_Managers k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Division_Id = q.Division_Id
                         and k.Employee_Id = Np.Responsible_Person_Id))
    loop
      z_Mrf_Robots.Update_One(i_Company_Id  => r.Company_Id,
                              i_Filial_Id   => r.Filial_Id,
                              i_Robot_Id    => r.Robot_Id,
                              i_Division_Id => Option_Number(r.New_Division_Id));
    
      insert into Migr_Changed_Staffs
        (Company_Id, Filial_Id, Staff_Id, Old_Division_Id, New_Division_Id)
      values
        (r.Company_Id, r.Filial_Id, r.Staff_Id, r.Old_Division_Id, r.New_Division_Id);
    end loop;
    Biruni_Route.Context_End;
  
    update Hpd_Page_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    update Hpd_Trans_Robots p
       set p.Division_Id =
           (select q.Division_Id
              from Mrf_Robots q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Robot_Id = p.Robot_Id)
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    Hpd_Core.Staff_Refresh_Cache(i_Company_Id);
  end;

end Client_Migr;
/
