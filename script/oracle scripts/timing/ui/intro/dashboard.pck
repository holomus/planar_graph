create or replace package Timing_Dashboard is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Query_Employee
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Load_Day_Stats_Piechart
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Load_Day_Stats_Xychart
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Access_All_User  number,
    i_Responsible_User number,
    i_Just_User        number
  );
end Timing_Dashboard;
/
create or replace package body Timing_Dashboard is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Query_Employee
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  ) is
    v_Begin timestamp;
    v_Diff  interval day to second;
    Ss_Id   number;
  
    v_Data Hashmap := Hashmap();
    v_Ids  Array_Number;
    result Hashmap;
  begin
    Dbms_Output.Put_Line('init');
    v_Begin := Current_Timestamp;
  
    select q.Division_Id
      bulk collect
      into v_Ids
      from Mhr_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('division_id', v_Ids);
  
    select q.Job_Id
      bulk collect
      into v_Ids
      from Mhr_Jobs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('job_id', v_Ids);
  
    select q.Schedule_Id
      bulk collect
      into v_Ids
      from Htt_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('schedule_id', v_Ids);
  
    select q.Rank_Id
      bulk collect
      into v_Ids
      from Mhr_Ranks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('rank_id', v_Ids);
  
    v_Data.Put('date', Trunc(sysdate));
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('timing init:' || Chr(9) || v_Diff);
    Dbms_Output.Put_Line('start');
  
    Biruni_Route.Context_Begin;
    Ui_Context.Init(i_User_Id      => i_User_Id,
                    i_Project_Code => Verifix.Project_Code,
                    i_Filial_Id    => i_Filial_Id);
  
    v_Begin := Current_Timestamp;
  
    -- run
    result := Ut_Vhr_Util.Run_Fazo_Query(i_Query  => Ui_Vhr100.Query_Employees(v_Data),
                                         i_Column => Array_Varchar2('staff_id',
                                                                    'responsible_person_id',
                                                                    'region_id' --
                                                                   ,
                                                                    'name',
                                                                    'first_name',
                                                                    'last_name',
                                                                    'middle_name',
                                                                    'gender',
                                                                    'photo_sha',
                                                                    'address',
                                                                    'state',
                                                                    'staff_number' --
                                                                   ,
                                                                    'tin',
                                                                    'cea',
                                                                    'main_phone',
                                                                    'email',
                                                                    'web',
                                                                    'fax',
                                                                    'telegram',
                                                                    'post_address',
                                                                    'login',
                                                                    'bank_account_name', --
                                                                    'iapa',
                                                                    'npin',
                                                                    'fprints',
                                                                    'code',
                                                                    'access_level',
                                                                    'staff_kind' --
                                                                   ,
                                                                    'hiring_date',
                                                                    'birthday' --
                                                                   ,
                                                                    'responsible_person_name',
                                                                    'region_name',
                                                                    --
                                                                    'begin_time',
                                                                    'late_time',
                                                                    --
                                                                    'kind',
                                                                    'input_time',
                                                                    'output_time',
                                                                    --
                                                                    'time_kind_name',
                                                                    'kind_name'),
                                         i_Limit  => 2000,
                                         i_Offset => 0,
                                         i_Filter => Arraylist(),
                                         i_Sort   => Array_Varchar2('name'));
  
    select Sys_Context('userenv', 'sessionid')
      into Ss_Id
      from Dual;
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('ui.session_id:' || Chr(9) || Ui.Session_Id);
    Dbms_Output.Put_Line('audsid:' || Chr(9) || Ss_Id);
    Dbms_Output.Put_Line('timing:' || Chr(9) || v_Diff);
  
    Biruni_Route.Context_End;
  
    rollback;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Load_Day_Stats_Piechart
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  ) is
    v_Begin timestamp;
    v_Diff  interval day to second;
    Ss_Id   number;
  
    v_Data Hashmap := Hashmap();
    v_Ids  Array_Number;
    result Hashmap;
  begin
    Dbms_Output.Put_Line('init');
    v_Begin := Current_Timestamp;
  
    select q.Division_Id
      bulk collect
      into v_Ids
      from Mhr_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('division_id', v_Ids);
  
    select q.Job_Id
      bulk collect
      into v_Ids
      from Mhr_Jobs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('job_id', v_Ids);
  
    select q.Schedule_Id
      bulk collect
      into v_Ids
      from Htt_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('schedule_id', v_Ids);
  
    select q.Rank_Id
      bulk collect
      into v_Ids
      from Mhr_Ranks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('rank_id', v_Ids);
  
    v_Data.Put('date', Trunc(sysdate));
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('timing init:' || Chr(9) || v_Diff);
    Dbms_Output.Put_Line('start');
  
    Biruni_Route.Context_Begin;
    Ui_Context.Init(i_User_Id      => i_User_Id,
                    i_Project_Code => Verifix.Project_Code,
                    i_Filial_Id    => i_Filial_Id);
  
    v_Begin := Current_Timestamp;
  
    -- run
    result := Ui_Vhr100.Load_Day_Stats_Piechart(v_Data);
  
    select Sys_Context('userenv', 'sessionid')
      into Ss_Id
      from Dual;
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('ui.session_id:' || Chr(9) || Ui.Session_Id);
    Dbms_Output.Put_Line('audsid:' || Chr(9) || Ss_Id);
    Dbms_Output.Put_Line('timing:' || Chr(9) || v_Diff);
  
    Biruni_Route.Context_End;
  
    rollback;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Load_Day_Stats_Xychart
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  ) is
    v_Begin timestamp;
    v_Diff  interval day to second;
    Ss_Id   number;
  
    v_Data Hashmap := Hashmap();
    v_Ids  Array_Number;
    result Arraylist;
  begin
    Dbms_Output.Put_Line('init');
    v_Begin := Current_Timestamp;
  
    select q.Division_Id
      bulk collect
      into v_Ids
      from Mhr_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('division_id', v_Ids);
  
    select q.Job_Id
      bulk collect
      into v_Ids
      from Mhr_Jobs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('job_id', v_Ids);
  
    select q.Schedule_Id
      bulk collect
      into v_Ids
      from Htt_Schedules q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('schedule_id', v_Ids);
  
    select q.Rank_Id
      bulk collect
      into v_Ids
      from Mhr_Ranks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id;
  
    v_Data.Put('rank_id', v_Ids);
  
    v_Data.Put('begin_date', Trunc(sysdate, 'mon'));
    v_Data.Put('end_date', Last_Day(sysdate));
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('timing init:' || Chr(9) || v_Diff);
    Dbms_Output.Put_Line('start');
  
    Biruni_Route.Context_Begin;
    Ui_Context.Init(i_User_Id      => i_User_Id,
                    i_Project_Code => Verifix.Project_Code,
                    i_Filial_Id    => i_Filial_Id);
  
    v_Begin := Current_Timestamp;
  
    -- run
    result := Ui_Vhr100.Load_Day_Stats_Xychart(v_Data);
  
    select Sys_Context('userenv', 'sessionid')
      into Ss_Id
      from Dual;
  
    v_Diff := Current_Timestamp - v_Begin;
  
    Dbms_Output.Put_Line('ui.session_id:' || Chr(9) || Ui.Session_Id);
    Dbms_Output.Put_Line('audsid:' || Chr(9) || Ss_Id);
    Dbms_Output.Put_Line('timing:' || Chr(9) || v_Diff);
  
    Biruni_Route.Context_End;
  
    rollback;
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Access_All_User  number,
    i_Responsible_User number,
    i_Just_User        number
  ) is
  begin
    -- query employee
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('query_employee: by admin');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Query_Employee(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_User_Id    => Md_Pref.User_Admin(i_Company_Id));
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('query_employee: by access all user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Query_Employee(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_User_Id    => i_Access_All_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('query_employee: by responsible');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Query_Employee(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_User_Id    => i_Responsible_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('query_employee: by just user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Query_Employee(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_User_Id    => i_Just_User);
  
    -- Load_Day_Stats_Piechart
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Piechart: by admin');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Piechart(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_User_Id    => Md_Pref.User_Admin(i_Company_Id));
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Piechart: by access all user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Piechart(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_User_Id    => i_Access_All_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Piechart: by responsible');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Piechart(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_User_Id    => i_Responsible_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Piechart: by just user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Piechart(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_User_Id    => i_Just_User);
  
    -- Load_Day_Stats_Xychart
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Xychart: by admin');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Xychart(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_User_Id    => Md_Pref.User_Admin(i_Company_Id));
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Xychart: by access all user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Xychart(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_User_Id    => i_Access_All_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Xychart: by responsible');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Xychart(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_User_Id    => i_Responsible_User);
  
    Dbms_Output.Put_Line('------------------------------------------');
    Dbms_Output.Put_Line('Load_Day_Stats_Xychart: by just user');
    Dbms_Output.Put_Line('------------------------------------------');
    Timing_Dashboard.Load_Day_Stats_Xychart(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_User_Id    => i_Just_User);
  end;

end Timing_Dashboard;
/
