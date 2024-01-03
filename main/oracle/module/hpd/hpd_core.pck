create or replace package Hpd_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Insert_Valid_Auto_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Journal_Id number,
    i_Page_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Insert_Valid_Auto_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Journal_Id number,
    i_Page_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Implicit_Robot_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Journal_Id  number,
    i_Page_Id     number,
    i_Open_Date   date,
    i_Close_Date  date,
    i_Schedule_Id number,
    i_Days_Limit  number,
    i_Currency_Id number,
    i_Robot       Hpd_Pref.Robot_Rt,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Unnecessary_Robots
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Update
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Robot_Id        number,
    i_Fte             number,
    i_Fte_Id          number,
    i_Rank_Id         number,
    i_Schedule_Id     number,
    i_Employment_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Intersection_Staff
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Run_Refresh_Cache;
  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Journal_Page_Cache
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Start_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Agreements_Evaluate(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Dirty_Staffs_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Function Get_Parent_Staff
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Employee_Id    number,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Trans_Insert
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Begin_Date date,
    i_End_Date   date,
    i_Order_No   number,
    i_Journal_Id number,
    i_Page_Id    number,
    i_Tag        varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Trans_Insert
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Page_Id          number,
    i_Staff_Id         number,
    i_Begin_Date       date,
    i_End_Date         date,
    i_Order_No         number,
    i_Robot_Id         number,
    i_Division_Id      number,
    i_Job_Id           number,
    i_Employment_Type  varchar2,
    i_Fte_Id           number,
    i_Fte              number,
    i_Wage_Scale_Id    number,
    i_Contractual_Wage varchar2,
    i_Source_Table     Fazo_Schema.w_Table_Name
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Schedule_Id  number,
    i_Source_Table Fazo_Schema.w_Table_Name
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Days_Limit   number,
    i_Source_Table Fazo_Schema.w_Table_Name
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Rank_Id      number,
    i_Source_Table Fazo_Schema.w_Table_Name
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Source_Table Fazo_Schema.w_Table_Name
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Trans_Clear
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null,
    i_Repost       boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Lock_Interval_Insert
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timeoff_Lock_Interval_Insert
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Perf_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Operation_Id  number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Interval_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Interval_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Interval_Id number,
    i_Timeoff_Id  number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Timeoff_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Remove_Timeoff_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Spend_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Free_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Journal_Id        number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Page_Ids   Array_Number := Array_Number()
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Application_Notification
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Title          varchar2,
    i_Grants         Array_Varchar2,
    i_Uri            varchar2,
    i_Uri_Param      Hashmap,
    i_Except_User_Id number,
    i_Created_By     number := null -- optional, specified if the user that created the application needs to be notified too
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Robot_Book_Transactions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  );
end Hpd_Core;
/
create or replace package body Hpd_Core is
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
    return b.Translate('HPD:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Insert_Valid_Auto_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Journal_Id number,
    i_Page_Id    number
  ) is
  begin
    update Hpd_Auto_Created_Staffs p
       set p.Valid = 'Y'
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id;
  
    if sql%notfound then
      insert into Hpd_Auto_Created_Staffs p
        (p.Company_Id, p.Filial_Id, p.Staff_Id, p.Journal_Id, p.Page_Id, p.Valid)
      values
        (i_Company_Id, i_Filial_Id, i_Staff_Id, i_Journal_Id, i_Page_Id, 'Y');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Insert_Valid_Auto_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Journal_Id number,
    i_Page_Id    number
  ) is
  begin
    update Hpd_Auto_Created_Robots p
       set p.Valid = 'Y'
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Robot_Id = i_Robot_Id;
  
    if sql%notfound then
      insert into Hpd_Auto_Created_Robots p
        (p.Company_Id, p.Filial_Id, p.Robot_Id, p.Journal_Id, p.Page_Id, p.Valid)
      values
        (i_Company_Id, i_Filial_Id, i_Robot_Id, i_Journal_Id, i_Page_Id, 'Y');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Implicit_Robot_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Journal_Id  number,
    i_Page_Id     number,
    i_Open_Date   date,
    i_Close_Date  date,
    i_Schedule_Id number,
    i_Days_Limit  number,
    i_Currency_Id number,
    i_Robot       Hpd_Pref.Robot_Rt,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt
  ) is
    r_Setting Hrm_Settings%rowtype;
    v_Robot   Hrm_Pref.Robot_Rt;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' then
      return;
    end if;
  
    Update_Insert_Valid_Auto_Robot(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => i_Robot.Robot_Id,
                                   i_Journal_Id => i_Journal_Id,
                                   i_Page_Id    => i_Page_Id);
  
    Hrm_Util.Robot_New(o_Robot                    => v_Robot,
                       i_Company_Id               => i_Company_Id,
                       i_Filial_Id                => i_Filial_Id,
                       i_Robot_Id                 => i_Robot.Robot_Id,
                       i_Name                     => Hrm_Util.Robot_Name(i_Company_Id  => i_Company_Id,
                                                                         i_Filial_Id   => i_Filial_Id,
                                                                         i_Robot_Id    => i_Robot.Robot_Id,
                                                                         i_Division_Id => i_Robot.Division_Id,
                                                                         i_Job_Id      => i_Robot.Job_Id,
                                                                         i_Rank_Id     => i_Robot.Rank_Id),
                       i_Code                     => null,
                       i_Robot_Group_Id           => null,
                       i_Division_Id              => i_Robot.Division_Id,
                       i_Job_Id                   => i_Robot.Job_Id,
                       i_Org_Unit_Id              => i_Robot.Org_Unit_Id,
                       i_State                    => 'A',
                       i_Opened_Date              => i_Open_Date,
                       i_Closed_Date              => i_Close_Date,
                       i_Schedule_Id              => i_Schedule_Id,
                       i_Rank_Id                  => i_Robot.Rank_Id,
                       i_Vacation_Days_Limit      => i_Days_Limit,
                       i_Labor_Function_Id        => null,
                       i_Description              => null,
                       i_Hiring_Condition         => null,
                       i_Contractual_Wage         => case
                                                       when i_Robot.Wage_Scale_Id is not null then
                                                        'N'
                                                       else
                                                        'Y'
                                                     end,
                       i_Position_Employment_Kind => case
                                                       when i_Robot.Employment_Type =
                                                            Hpd_Pref.c_Employment_Type_Contractor then
                                                        Hrm_Pref.c_Position_Employment_Contractor
                                                       else
                                                        Hrm_Pref.c_Position_Employment_Staff
                                                     end,
                       i_Wage_Scale_Id            => i_Robot.Wage_Scale_Id,
                       i_Currency_Id              => i_Currency_Id,
                       i_Access_Hidden_Salary     => 'N');
    v_Robot.Indicators := i_Indicators;
    v_Robot.Oper_Types := i_Oper_Types;
  
    Hrm_Api.Robot_Save(v_Robot,
                       i_Self => z_Hpd_Journal_Pages.Lock_Load(i_Company_Id => i_Company_Id, --
                                 i_Filial_Id => i_Filial_Id, --
                                 i_Page_Id => i_Page_Id).Employee_Id = Md_Env.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Unnecessary_Robots
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' then
      return;
    end if;
  
    for r in (select p.Company_Id, p.Filial_Id, p.Robot_Id
                from Hpd_Auto_Created_Robots p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Journal_Id = i_Journal_Id
                 and p.Valid = 'N')
    loop
      Hrm_Api.Robot_Delete(i_Company_Id => r.Company_Id,
                           i_Filial_Id  => r.Filial_Id,
                           i_Robot_Id   => r.Robot_Id);
    end loop;
  
    delete Hpd_Auto_Created_Robots;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff Href_Staffs%rowtype;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.State = 'A' then
      Hpd_Error.Raise_001(Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Staff_Id   => i_Staff_Id));
    end if;
  
    z_Href_Staffs.Delete_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Staff_Id   => i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Update
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Robot_Id        number,
    i_Fte             number,
    i_Fte_Id          number,
    i_Rank_Id         number,
    i_Schedule_Id     number,
    i_Employment_Type varchar2
  ) is
    r_Staff     Href_Staffs%rowtype;
    r_Robot     Mrf_Robots%rowtype;
    r_Hrm_Robot Hrm_Robots%rowtype;
    r_Employee  Mhr_Employees%rowtype;
  begin
    r_Robot := z_Mrf_Robots.Load(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Robot_Id   => i_Robot_Id);
  
    r_Hrm_Robot := z_Hrm_Robots.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Robot_Id   => i_Robot_Id);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Employee_Id => r_Staff.Employee_Id);
  
    z_Href_Staffs.Update_One(i_Company_Id      => i_Company_Id,
                             i_Filial_Id       => i_Filial_Id,
                             i_Staff_Id        => i_Staff_Id,
                             i_Robot_Id        => Option_Number(r_Robot.Robot_Id),
                             i_Division_Id     => Option_Number(r_Robot.Division_Id),
                             i_Job_Id          => Option_Number(r_Robot.Job_Id),
                             i_Org_Unit_Id     => Option_Number(r_Hrm_Robot.Org_Unit_Id),
                             i_Fte             => Option_Number(i_Fte),
                             i_Fte_Id          => Option_Number(i_Fte_Id),
                             i_Rank_Id         => Option_Number(i_Rank_Id),
                             i_Schedule_Id     => Option_Number(i_Schedule_Id),
                             i_Employment_Type => Option_Varchar2(i_Employment_Type));
  
    if r_Staff.Staff_Kind = Href_Pref.c_Staff_Kind_Primary and
       not (Fazo.Equal(r_Employee.Division_Id, r_Robot.Division_Id) and
        Fazo.Equal(r_Employee.Job_Id, r_Robot.Job_Id) and --
        Fazo.Equal(r_Employee.Rank_Id, i_Rank_Id)) --
     then
      Href_Api.Employee_Update(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Employee_Id => r_Staff.Employee_Id,
                               i_Division_Id => r_Robot.Division_Id,
                               i_Job_Id      => r_Robot.Job_Id,
                               i_Rank_Id     => i_Rank_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Intersection_Staff
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
    v_Dismissal_Date       date;
    v_Staff_Id             number;
    v_Intersected_Staff_Id number;
    v_Intersection_Date    date;
  begin
    for r in (select *
                from Href_Staffs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Employee_Id = i_Employee_Id
                 and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and q.State = 'A'
               order by q.Hiring_Date)
    loop
      if v_Dismissal_Date is not null and r.Hiring_Date <= v_Dismissal_Date then
        v_Intersected_Staff_Id := r.Staff_Id;
        v_Intersection_Date    := Least(Nvl(r.Dismissal_Date, Href_Pref.c_Max_Date),
                                        v_Dismissal_Date);
        exit;
      end if;
      v_Staff_Id       := r.Staff_Id;
      v_Dismissal_Date := Nvl(r.Dismissal_Date, Href_Pref.c_Max_Date);
    end loop;
  
    if v_Intersected_Staff_Id is not null then
      Hpd_Error.Raise_002(i_Staff_Name        => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                      i_Filial_Id  => i_Filial_Id,
                                                                      i_Staff_Id   => v_Staff_Id),
                          i_Intersection_Date => v_Intersection_Date);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff        Href_Staffs%rowtype;
    r_Robot        Hpd_Trans_Robots%rowtype;
    r_Rank         Hpd_Trans_Ranks%rowtype;
    r_Schedule     Hpd_Trans_Schedules%rowtype;
    v_Date         date := Trunc(sysdate);
    v_Desired_Date date;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.State = 'P' then
      return;
    end if;
  
    v_Desired_Date := Greatest(r_Staff.Hiring_Date,
                               Least(v_Date, Nvl(r_Staff.Dismissal_Date, v_Date)));
  
    r_Robot := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => i_Staff_Id,
                                      i_Period     => v_Desired_Date);
  
    r_Rank := Hpd_Util.Closest_Rank(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id,
                                    i_Period     => v_Desired_Date);
  
    r_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Period     => v_Desired_Date);
  
    Staff_Update(i_Company_Id      => i_Company_Id,
                 i_Filial_Id       => i_Filial_Id,
                 i_Staff_Id        => i_Staff_Id,
                 i_Robot_Id        => r_Robot.Robot_Id,
                 i_Fte             => r_Robot.Fte,
                 i_Fte_Id          => r_Robot.Fte_Id,
                 i_Rank_Id         => r_Rank.Rank_Id,
                 i_Schedule_Id     => r_Schedule.Schedule_Id,
                 i_Employment_Type => r_Robot.Employment_Type);
  
    if r_Staff.Staff_Kind = Href_Pref.c_Staff_Kind_Primary and --
       r_Staff.Dismissal_Date < v_Date then
      for r in (select *
                  from Htt_Location_Persons q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Person_Id = r_Staff.Employee_Id)
      loop
        Htt_Core.Location_Remove_Person(i_Company_Id  => r.Company_Id,
                                        i_Filial_Id   => r.Filial_Id,
                                        i_Location_Id => r.Location_Id,
                                        i_Person_Id   => r.Person_Id);
      end loop;
    
      if z_Md_User_Filials.Exist_Lock(i_Company_Id => i_Company_Id,
                                      i_User_Id    => r_Staff.Employee_Id,
                                      i_Filial_Id  => i_Filial_Id) then
        Md_Api.User_Remove_Filial(i_Company_Id   => i_Company_Id,
                                  i_User_Id      => r_Staff.Employee_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Remove_Roles => false);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache(i_Company_Id number) is
    v_Date        date := Trunc(sysdate);
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Verifix.Project_Code);
    
      for St in (select *
                   from Href_Staffs q
                  where q.Company_Id = r.Company_Id
                    and q.Filial_Id = r.Filial_Id
                    and q.State = 'A'
                    and q.Hiring_Date <= v_Date
                    and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date - 1)
                  order by q.Hiring_Date)
      loop
        Staff_Refresh_Cache(i_Company_Id => St.Company_Id,
                            i_Filial_Id  => St.Filial_Id,
                            i_Staff_Id   => St.Staff_Id);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Staff_Refresh_Cache is
  begin
    for r in (select q.*
                from Hpd_Journal_Page_Cache q)
    loop
      Staff_Refresh_Cache(i_Company_Id => r.Company_Id,
                          i_Filial_Id  => r.Filial_Id,
                          i_Staff_Id   => r.Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person_Locations
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) is
  begin
    if not Hpd_Util.Is_Hiring_Journal(i_Company_Id      => i_Company_Id,
                                      i_Journal_Type_Id => i_Journal_Type_Id) and
       not Hpd_Util.Is_Transfer_Journal(i_Company_Id      => i_Company_Id,
                                        i_Journal_Type_Id => i_Journal_Type_Id) and
       not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => i_Company_Id,
                                         i_Journal_Type_Id => i_Journal_Type_Id) then
      return;
    end if;
  
    for r in (select p.Company_Id, p.Filial_Id, p.Employee_Id
                from Hpd_Journal_Page_Cache p
               group by p.Company_Id, p.Filial_Id, p.Employee_Id)
    loop
      Htt_Core.Person_Sync_Locations(i_Company_Id => r.Company_Id,
                                     i_Filial_Id  => r.Filial_Id,
                                     i_Person_Id  => r.Employee_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Division_Managers
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) is
  begin
    if not Hpd_Util.Is_Hiring_Journal(i_Company_Id      => i_Company_Id,
                                      i_Journal_Type_Id => i_Journal_Type_Id) and
       not Hpd_Util.Is_Transfer_Journal(i_Company_Id      => i_Company_Id,
                                        i_Journal_Type_Id => i_Journal_Type_Id) and
       not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => i_Company_Id,
                                         i_Journal_Type_Id => i_Journal_Type_Id) then
      return;
    end if;
  
    for r in (select p.Company_Id, p.Filial_Id, p.Staff_Id
                from Hpd_Journal_Page_Cache p)
    loop
      Hrm_Core.Sync_Division_Managers(i_Company_Id => r.Company_Id,
                                      i_Filial_Id  => r.Filial_Id,
                                      i_Staff_Id   => r.Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissed_To_Candidate
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) is
  begin
    if not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => i_Company_Id,
                                         i_Journal_Type_Id => i_Journal_Type_Id) then
      return;
    end if;
  
    for r in (select p.*, Ds.Employment_Source_Id
                from Hpd_Journal_Page_Cache p
                join Hpd_Dismissal_Transactions Dt
                  on Dt.Company_Id = p.Company_Id
                 and Dt.Filial_Id = p.Filial_Id
                 and Dt.Staff_Id = p.Staff_Id
                join Hpd_Dismissals Ds
                  on Ds.Company_Id = Dt.Company_Id
                 and Ds.Filial_Id = Dt.Filial_Id
                 and Ds.Page_Id = Dt.Page_Id)
    loop
      Href_Core.Dismissed_Candidate_Save(i_Company_Id           => r.Company_Id,
                                         i_Filial_Id            => r.Filial_Id,
                                         i_Staff_Id             => r.Staff_Id,
                                         i_Employment_Source_Id => r.Employment_Source_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Journal_Page_Cache
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) is
  begin
    if Md_Pref.c_Migr_Company_Id != i_Company_Id then
      Journal_Staff_Refresh_Cache;
    end if;
  
    Sync_Person_Locations(i_Company_Id => i_Company_Id, i_Journal_Type_Id => i_Journal_Type_Id);
  
    Sync_Division_Managers(i_Company_Id => i_Company_Id, i_Journal_Type_Id => i_Journal_Type_Id);
  
    Dismissed_To_Candidate(i_Company_Id => i_Company_Id, i_Journal_Type_Id => i_Journal_Type_Id);
  
    delete Hpd_Journal_Page_Cache;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Journal_Staff_Cache
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    insert into Hpd_Journal_Page_Cache
      (Company_Id, Filial_Id, Staff_Id, Employee_Id)
      select p.Company_Id, p.Filial_Id, p.Staff_Id, p.Employee_Id
        from Hpd_Journal_Pages p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Journal_Id = i_Journal_Id
         and not exists (select *
                from Hpd_Journal_Page_Cache q
               where q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Staff_Id = p.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Refresh_Cache is
  begin
    for Cmp in (select c.Company_Id,
                       (select i.User_System
                          from Md_Company_Infos i
                         where i.Company_Id = c.Company_Id) User_System
                  from Md_Companies c
                 where c.State = 'A'
                   and (exists (select 1
                                  from Md_Company_Projects Cp
                                 where Cp.Company_Id = c.Company_Id
                                   and Cp.Project_Code = Verifix.Project_Code) or
                        c.Company_Id = Md_Pref.c_Company_Head))
    loop
      begin
        Staff_Refresh_Cache(Cmp.Company_Id);
      
        Hrm_Core.Robot_Person_Refresh_Cache(Cmp.Company_Id);
      
        Hrm_Core.Sync_Division_Managers(Cmp.Company_Id);
      
        Htt_Core.Person_Sync_Locations(Cmp.Company_Id);
      
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Turnover_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Days_Kind  varchar2,
    i_Days_Count number
  ) is
    v_Planned_Days number;
    v_Used_Days    number := 0;
    v_Periods      Array_Date;
  
    --------------------------------------------------
    Procedure Insert_Turnover is
      g Hpd_Vacation_Turnover%rowtype;
    begin
      for r in (select *
                  from (select *
                          from Hpd_Vacation_Turnover t
                         where t.Company_Id = i_Company_Id
                           and t.Filial_Id = i_Filial_Id
                           and t.Staff_Id = i_Staff_Id
                           and t.Period < i_Begin_Date
                           and t.Period >= Trunc(i_Begin_Date, 'yyyy')
                         order by t.Period desc)
                 where Rownum = 1)
      loop
        g              := r;
        g.Period       := i_Begin_Date;
        g.Planned_Days := Nvl(v_Planned_Days, g.Planned_Days);
        g.Used_Days    := g.Used_Days + v_Used_Days;
      
        z_Hpd_Vacation_Turnover.Insert_Row(g);
        return;
      end loop;
    
      g.Company_Id   := i_Company_Id;
      g.Filial_Id    := i_Filial_Id;
      g.Staff_Id     := i_Staff_Id;
      g.Period       := i_Begin_Date;
      g.Planned_Days := Coalesce(v_Planned_Days,
                                 Hpd_Util.Get_Closest_Vacation_Days_Limit(i_Company_Id => i_Company_Id,
                                                                          i_Filial_Id  => i_Filial_Id,
                                                                          i_Staff_Id   => i_Staff_Id,
                                                                          i_Period     => i_Begin_Date),
                                 0);
      g.Used_Days    := v_Used_Days;
    
      z_Hpd_Vacation_Turnover.Insert_Row(g);
    end;
  begin
    case i_Days_Kind
      when Hpd_Pref.c_Vacation_Turnover_Planned_Days then
        v_Planned_Days := i_Days_Count;
      when Hpd_Pref.c_Vacation_Turnover_Used_Days then
        v_Used_Days := i_Days_Count;
      else
        Hpd_Error.Raise_003;
    end case;
  
    update Hpd_Vacation_Turnover Lt
       set Lt.Planned_Days = Nvl(v_Planned_Days, Lt.Planned_Days),
           Lt.Used_Days    = Lt.Used_Days + v_Used_Days
     where Lt.Company_Id = i_Company_Id
       and Lt.Filial_Id = i_Filial_Id
       and Lt.Staff_Id = i_Staff_Id
       and Lt.Period >= i_Begin_Date
       and (i_End_Date is null or Lt.Period <= i_End_Date)
    returning Lt.Period bulk collect into v_Periods;
  
    if i_Begin_Date not member of v_Periods then
      Insert_Turnover;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Default_Calendar_Id number;
    v_Vacation_Tk_Id      number;
    v_Official_Days_Cnt   number;
    v_Vacation_Days_Cnt   number;
  begin
    v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    v_Default_Calendar_Id := Htt_Util.Default_Calendar_Id(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id);
  
    v_Official_Days_Cnt := Htt_Util.Official_Rest_Days_Count(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Calendar_Id => v_Default_Calendar_Id,
                                                             i_Begin_Date  => i_Begin_Date,
                                                             i_End_Date    => i_End_Date);
  
    select count(*)
      into v_Vacation_Days_Cnt
      from Hpd_Timeoff_Days p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Timeoff_Date between i_Begin_Date and i_End_Date
       and p.Time_Kind_Id = v_Vacation_Tk_Id
       and p.Turnout_Locked = 'N';
  
    return Greatest(v_Vacation_Days_Cnt - v_Official_Days_Cnt, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Used_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Start_Date date
  ) is
    v_Min_Cloned date;
  
    --------------------------------------------------
    Function Limit_Exists return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hpd_Agreements p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Staff_Id = i_Staff_Id
         and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Vacation_Limit
         and p.Period < i_Start_Date
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
  begin
    if Limit_Exists then
      return;
    end if;
  
    select Nvl(min(q.Period), Href_Pref.c_Max_Date)
      into v_Min_Cloned
      from Hpd_Cloned_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Vacation_Limit;
  
    for r in (select p.*
                from Hpd_Journal_Timeoffs p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Staff_Id = i_Staff_Id
                 and p.Begin_Date >= i_Start_Date
                 and p.Begin_Date < v_Min_Cloned
                 and exists (select *
                        from Hpd_Vacations q
                       where q.Company_Id = p.Company_Id
                         and q.Filial_Id = p.Filial_Id
                         and q.Timeoff_Id = p.Timeoff_Id))
    loop
      Spend_Vacation_Days(i_Company_Id => r.Company_Id,
                          i_Filial_Id  => r.Filial_Id,
                          i_Staff_Id   => r.Staff_Id,
                          i_Begin_Date => r.Begin_Date,
                          i_End_Date   => r.End_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Vacation_Turnovers
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    v_Min_Date   date;
    v_Days_Count number;
  begin
    select min(q.Period)
      into v_Min_Date
      from Hpd_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Vacation_Limit;
  
    delete Hpd_Vacation_Turnover p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Period < Nvl(v_Min_Date, Href_Pref.c_Max_Date);
  
    if sql%rowcount > 0 and v_Min_Date is not null then
      v_Days_Count := Calc_Vacation_Days(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Staff_Id   => i_Staff_Id,
                                         i_Begin_Date => Trunc(v_Min_Date, 'yyyy'),
                                         i_End_Date   => v_Min_Date - 1);
    
      Vacation_Turnover_Evaluate(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Begin_Date => v_Min_Date,
                                 i_End_Date   => Htt_Util.Year_Last_Day(v_Min_Date),
                                 i_Days_Kind  => Hpd_Pref.c_Vacation_Turnover_Used_Days,
                                 i_Days_Count => -v_Days_Count);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Vacation_Turnover
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    v_Staff_Name Mr_Natural_Persons.Name%type;
    v_Period     date;
    v_Planned    number;
    v_Used       number;
  begin
    v_Staff_Name := Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Staff_Id   => i_Staff_Id);
  
    select Qr.Period, Qr.Planned_Days, Qr.Used_Days
      into v_Period, v_Planned, v_Used
      from (select *
              from Hpd_Vacation_Turnover p
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
               and p.Staff_Id = i_Staff_Id
               and p.Free_Days < 0
             order by p.Period) Qr
     where Rownum = 1;
  
    Hpd_Error.Raise_004(i_Staff_Name    => v_Staff_Name,
                        i_Exceed_Date   => v_Period,
                        i_Exceed_Amount => v_Used - v_Planned);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Clone
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Begin_Date date
  ) is
  begin
    delete Hpd_Cloned_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type;
  
    insert into Hpd_Cloned_Agreements
      (Company_Id, Filial_Id, Staff_Id, Trans_Type, Period, Trans_Id, Action)
      select q.Company_Id, q.Filial_Id, q.Staff_Id, q.Trans_Type, q.Period, q.Trans_Id, q.Action
        from Hpd_Agreements q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Trans_Type = i_Trans_Type
         and q.Period >= i_Begin_Date;
  
    delete Hpd_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Period >= i_Begin_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Start_Date date
  ) is
    c_Format constant varchar2(20) := 'yyyymmdd';
    v_Start          date := i_Start_Date;
    f_Date_Set       Fazo.Boolean_Code_Aat;
    v_Key            varchar2(100);
    r_Trans          Hpd_Transactions%rowtype;
    r_Last_Trans     Hpd_Transactions%rowtype;
    v_Dismissal_Date date;
  begin
    f_Date_Set(to_char(v_Start, c_Format)) := true;
  
    for r in (select q.Begin_Date, q.End_Date
                from Hpd_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Trans_Type = i_Trans_Type
                 and q.Event != Hpd_Pref.c_Transaction_Event_To_Be_Deleted
                 and q.Begin_Date >= v_Start)
    loop
      f_Date_Set(to_char(r.Begin_Date, c_Format)) := true;
    
      if r.End_Date is not null then
        f_Date_Set(to_char(r.End_Date + 1, c_Format)) := true;
      end if;
    end loop;
  
    for r in (select q.End_Date
                from Hpd_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Trans_Type = i_Trans_Type
                 and q.Event != Hpd_Pref.c_Transaction_Event_To_Be_Deleted
                 and q.End_Date >= v_Start)
    loop
      f_Date_Set(to_char(r.End_Date + 1, c_Format)) := true;
    end loop;
  
    for r in (select q.Dismissal_Date
                from Hpd_Dismissal_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Event != Hpd_Pref.c_Transaction_Event_To_Be_Deleted)
    loop
      if v_Dismissal_Date is not null then
        Hpd_Error.Raise_005(i_Staff_Name       => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                       i_Filial_Id  => i_Filial_Id,
                                                                       i_Staff_Id   => i_Staff_Id),
                            i_First_Dismissal  => v_Dismissal_Date,
                            i_Second_Dismissal => r.Dismissal_Date);
      end if;
    
      f_Date_Set(to_char(r.Dismissal_Date, c_Format)) := true;
      v_Dismissal_Date := r.Dismissal_Date;
    end loop;
  
    Agreement_Clone(i_Company_Id => i_Company_Id, --
                    i_Filial_Id  => i_Filial_Id,
                    i_Staff_Id   => i_Staff_Id,
                    i_Trans_Type => i_Trans_Type,
                    i_Begin_Date => v_Start);
  
    v_Key := f_Date_Set.First;
  
    r_Last_Trans := Hpd_Util.Get_Changing_Transaction(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Staff_Id   => i_Staff_Id,
                                                      i_Trans_Type => i_Trans_Type,
                                                      i_Period     => to_date(v_Key, c_Format) - 1);
    while v_Key is not null
    loop
      v_Start := to_date(v_Key, c_Format);
    
      if v_Start = v_Dismissal_Date then
        if r_Last_Trans.Trans_Id is not null then
          z_Hpd_Agreements.Insert_One(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => i_Staff_Id,
                                      i_Trans_Type => i_Trans_Type,
                                      i_Period     => v_Start,
                                      i_Trans_Id   => null,
                                      i_Action     => Hpd_Pref.c_Transaction_Action_Stop);
        end if;
      
        exit;
      end if;
    
      r_Trans := Hpd_Util.Get_Changing_Transaction(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Staff_Id   => i_Staff_Id,
                                                   i_Trans_Type => i_Trans_Type,
                                                   i_Period     => v_Start);
    
      if r_Trans.Trans_Id is not null then
        if not Fazo.Equal(r_Trans.Trans_Id, r_Last_Trans.Trans_Id) then
          z_Hpd_Agreements.Insert_One(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => i_Staff_Id,
                                      i_Trans_Type => i_Trans_Type,
                                      i_Period     => v_Start,
                                      i_Trans_Id   => r_Trans.Trans_Id,
                                      i_Action     => Hpd_Pref.c_Transaction_Action_Continue);
        end if;
      
        r_Last_Trans := r_Trans;
      end if;
    
      v_Key := f_Date_Set.Next(v_Key);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Integrate_Robot_Agreements
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Start_Date date
  ) is
    r_Robot            Hpd_Trans_Robots%rowtype;
    v_Last_Trans_Id    number;
    v_Robot_Trans_Id   number;
    v_Last_Action      varchar2(1);
    v_Position_Booking varchar2(1) := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Position_Booking;
  begin
    -- clear robot transactions
    for r in (select q.Trans_Id, q.Robot_Id
                from Hrm_Robot_Transactions q
                join Hpd_Robot_Trans_Staffs w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Trans_Id = w.Robot_Trans_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and w.Staff_Id = i_Staff_Id
                 and q.Trans_Date >= i_Start_Date)
    loop
      z_Hpd_Robot_Trans_Staffs.Delete_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => r.Trans_Id);
    
      Hrm_Core.Robot_Transaction_Delete(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => r.Trans_Id);
    end loop;
  
    Hpd_Util.Closest_Trans_Info(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                i_Period     => i_Start_Date - 1,
                                o_Trans_Id   => v_Last_Trans_Id,
                                o_Action     => v_Last_Action);
  
    if v_Last_Action = Hpd_Pref.c_Transaction_Action_Continue then
      r_Robot := z_Hpd_Trans_Robots.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Trans_Id   => v_Last_Trans_Id);
    end if;
  
    for r in (select *
                from Hpd_Agreements q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and q.Period >= i_Start_Date
               order by q.Period)
    loop
      if v_Last_Action = Hpd_Pref.c_Transaction_Action_Continue then
        v_Robot_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => i_Company_Id,
                                                    i_Filial_Id   => i_Filial_Id,
                                                    i_Robot_Id    => r_Robot.Robot_Id,
                                                    i_Occupy_Date => r.Period,
                                                    i_Fte         => r_Robot.Fte,
                                                    i_Tag         => v_Last_Trans_Id);
      
        z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => v_Robot_Trans_Id,
                                          i_Staff_Id       => i_Staff_Id);
      end if;
    
      if r.Action = Hpd_Pref.c_Transaction_Action_Continue then
        r_Robot := z_Hpd_Trans_Robots.Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Trans_Id   => r.Trans_Id);
      
        v_Robot_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Robot_Id    => r_Robot.Robot_Id,
                                                  i_Occupy_Date => r.Period,
                                                  i_Fte         => r_Robot.Fte,
                                                  i_Tag         => r.Trans_Id);
      
        z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => v_Robot_Trans_Id,
                                          i_Staff_Id       => i_Staff_Id);
      end if;
    
      v_Last_Trans_Id := r.Trans_Id;
      v_Last_Action   := r.Action;
    end loop;
  
    if v_Position_Booking = 'Y' then
      for r in (select q.Robot_Id, --
                       Nvl((select f.Fte_Value
                             from Href_Ftes f
                            where f.Company_Id = q.Company_Id
                              and f.Fte_Id = q.Fte_Id),
                           q.Fte) Fte,
                       q.Page_Id,
                       d.Begin_Date,
                       d.End_Date
                  from Hpd_Page_Robots q
                  join Hpd_Journal_Pages p
                    on p.Company_Id = q.Company_Id
                   and p.Filial_Id = q.Filial_Id
                   and p.Page_Id = q.Page_Id
                   and p.Staff_Id = i_Staff_Id
                  join Hpd_Journals j
                    on j.Company_Id = p.Company_Id
                   and j.Filial_Id = p.Filial_Id
                   and j.Journal_Id = p.Journal_Id
                   and j.Posted = 'N'
                  join (select h.Company_Id, --
                              h.Filial_Id,
                              h.Page_Id,
                              h.Hiring_Date    Begin_Date,
                              h.Dismissal_Date End_Date
                         from Hpd_Hirings h
                       union
                       select t.Company_Id,
                              t.Filial_Id,
                              t.Page_Id,
                              t.Transfer_Begin Begin_Date,
                              t.Transfer_End   End_Date
                         from Hpd_Transfers t) d
                    on d.Company_Id = q.Company_Id
                   and d.Filial_Id = q.Filial_Id
                   and d.Page_Id = q.Page_Id
                   and d.Begin_Date >= i_Start_Date
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Is_Booked = 'Y')
      loop
        v_Robot_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Robot_Id    => r.Robot_Id,
                                                  i_Occupy_Date => r.Begin_Date,
                                                  i_Fte         => r.Fte,
                                                  i_Is_Booked   => true,
                                                  i_Tag         => r.Page_Id);
      
        z_Hpd_Robot_Trans_Pages.Insert_One(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Page_Id    => r.Page_Id,
                                           i_Trans_Id   => v_Robot_Trans_Id);
      
        z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => v_Robot_Trans_Id,
                                          i_Staff_Id       => i_Staff_Id);
      
        if r.End_Date is not null then
          v_Robot_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Robot_Id    => r.Robot_Id,
                                                      i_Occupy_Date => r.End_Date + 1,
                                                      i_Fte         => r.Fte,
                                                      i_Is_Booked   => true,
                                                      i_Tag         => r.Page_Id);
        
          z_Hpd_Robot_Trans_Pages.Insert_One(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Page_Id    => r.Page_Id,
                                             i_Trans_Id   => v_Robot_Trans_Id);
        
          z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                            i_Filial_Id      => i_Filial_Id,
                                            i_Robot_Trans_Id => v_Robot_Trans_Id,
                                            i_Staff_Id       => i_Staff_Id);
        end if;
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Integrate_Schedule_Agreements
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Staff_Id          number,
    i_Changed_Intervals Hpd_Pref.Transaction_Part_Nt
  ) is
    v_Schedule_Id number;
    v_Interval    Hpd_Pref.Transaction_Part_Rt;
  begin
    for i in 1 .. i_Changed_Intervals.Count
    loop
      v_Interval := i_Changed_Intervals(i);
    
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => v_Interval.Part_Begin);
    
      Htt_Core.Regenerate_Timesheets(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Staff_Id    => i_Staff_Id,
                                     i_Schedule_Id => v_Schedule_Id,
                                     i_Begin_Date  => v_Interval.Part_Begin,
                                     i_End_Date    => v_Interval.Part_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Integrate_Vacation_Limit_Agreements
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Start_Date date
  ) is
    v_Weighted_Plan_Sum number;
    v_Period_Plan       number := 0;
    v_Year_Begin        date;
    v_Year_End          date;
  begin
    for r in (select p.Days_Limit,
                     Greatest(q.Period, Trunc(i_Start_Date, 'yyyy')) Period_Begin,
                     Lead(q.Period) Over(order by q.Period) - 1 Period_End
                from Hpd_Agreements q
                join Hpd_Trans_Vacation_Limits p
                  on p.Company_Id = q.Company_Id
                 and p.Filial_Id = q.Filial_Id
                 and p.Trans_Id = q.Trans_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
                 and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Vacation_Limit
                 and q.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and (q.Period >= Trunc(i_Start_Date, 'yyyy') or
                     q.Period = (select max(k.Period)
                                    from Hpd_Agreements k
                                   where k.Company_Id = i_Company_Id
                                     and k.Filial_Id = i_Filial_Id
                                     and k.Staff_Id = i_Staff_Id
                                     and k.Trans_Type = Hpd_Pref.c_Transaction_Type_Vacation_Limit
                                     and k.Period <= Trunc(i_Start_Date, 'yyyy')))
               order by q.Period)
    loop
      v_Year_Begin  := Trunc(r.Period_Begin, 'yyyy');
      v_Year_End    := Htt_Util.Year_Last_Day(r.Period_Begin);
      v_Period_Plan := r.Days_Limit * (v_Year_End - r.Period_Begin + 1);
    
      v_Weighted_Plan_Sum := case
                               when r.Period_Begin <> v_Year_Begin then
                                Nvl(v_Weighted_Plan_Sum, r.Days_Limit * (r.Period_Begin - v_Year_Begin))
                               else
                                0
                             end;
    
      while Trunc(r.Period_Begin, 'yyyy') <> Trunc(r.Period_End, 'yyyy') or r.Period_End is null
      loop
        Vacation_Turnover_Evaluate(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Begin_Date => r.Period_Begin,
                                   i_End_Date   => v_Year_End,
                                   i_Days_Kind  => Hpd_Pref.c_Vacation_Turnover_Planned_Days,
                                   i_Days_Count => (v_Weighted_Plan_Sum + v_Period_Plan) /
                                                   (v_Year_End - v_Year_Begin + 1));
      
        r.Period_Begin      := v_Year_End + 1;
        v_Year_Begin        := Trunc(r.Period_Begin, 'yyyy');
        v_Year_End          := Htt_Util.Year_Last_Day(r.Period_Begin);
        v_Weighted_Plan_Sum := 0;
        v_Period_Plan       := r.Days_Limit * (v_Year_End - v_Year_Begin + 1);
      
        exit when r.Period_End is null;
      end loop;
    
      Vacation_Turnover_Evaluate(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Begin_Date => r.Period_Begin,
                                 i_End_Date   => r.Period_End,
                                 i_Days_Kind  => Hpd_Pref.c_Vacation_Turnover_Planned_Days,
                                 i_Days_Count => (v_Weighted_Plan_Sum + v_Period_Plan) /
                                                 (v_Year_End - v_Year_Begin + 1));
    
      v_Period_Plan := r.Days_Limit * (r.Period_End - r.Period_Begin + 1);
    
      v_Weighted_Plan_Sum := v_Weighted_Plan_Sum + v_Period_Plan;
    end loop;
  
    Delete_Vacation_Turnovers(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Staff_Id   => i_Staff_Id);
  
    Evaluate_Used_Vacation_Days(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Start_Date => i_Start_Date);
  
    Assert_Vacation_Turnover(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Staff_Id   => i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Changed_Intervals
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Start_Date date
  ) return Hpd_Pref.Transaction_Part_Nt is
    v_Last_Trans_Id number;
    v_Orig_Code     varchar2(4000);
    v_Clone_Code    varchar2(4000);
    v_Part          Hpd_Pref.Transaction_Part_Rt;
    result          Hpd_Pref.Transaction_Part_Nt := Hpd_Pref.Transaction_Part_Nt();
  begin
    v_Last_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Staff_Id   => i_Staff_Id,
                                                   i_Trans_Type => i_Trans_Type,
                                                   i_Period     => i_Start_Date - 1);
  
    v_Orig_Code := Hpd_Util.Get_Trans_Code(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Trans_Id   => v_Last_Trans_Id,
                                           i_Trans_Type => i_Trans_Type);
  
    v_Clone_Code := v_Orig_Code;
  
    for r in (select Nvl(p.Period, q.Period) Period_Start,
                     Lead(Nvl(p.Period, q.Period)) --
                     Over(order by Nvl(p.Period, q.Period)) - 1 Period_End,
                     p.Trans_Id,
                     q.Trans_Id Clone_Trans_Id,
                     p.Action,
                     q.Action Clone_Action
                from (select *
                        from Hpd_Agreements Og
                       where Og.Company_Id = i_Company_Id
                         and Og.Filial_Id = i_Filial_Id
                         and Og.Staff_Id = i_Staff_Id
                         and Og.Trans_Type = i_Trans_Type
                         and Og.Period >= i_Start_Date) p
                full join (select *
                            from Hpd_Cloned_Agreements Cl
                           where Cl.Company_Id = i_Company_Id
                             and Cl.Filial_Id = i_Filial_Id
                             and Cl.Staff_Id = i_Staff_Id
                             and Cl.Trans_Type = i_Trans_Type) q
                  on q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Staff_Id = p.Staff_Id
                 and q.Trans_Type = p.Trans_Type
                 and q.Period = p.Period
               order by Nvl(p.Period, q.Period))
    loop
      if r.Clone_Trans_Id is not null and --
         r.Clone_Action = Hpd_Pref.c_Transaction_Action_Continue then
        v_Clone_Code := Hpd_Util.Get_Trans_Code(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Trans_Id   => r.Clone_Trans_Id,
                                                i_Trans_Type => i_Trans_Type);
      end if;
    
      if r.Clone_Action = Hpd_Pref.c_Transaction_Action_Stop then
        v_Clone_Code := Gmap().Json();
      end if;
    
      if r.Trans_Id is not null and --
         r.Action = Hpd_Pref.c_Transaction_Action_Continue then
        v_Orig_Code := Hpd_Util.Get_Trans_Code(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Trans_Id   => r.Trans_Id,
                                               i_Trans_Type => i_Trans_Type);
      end if;
    
      if r.Action = Hpd_Pref.c_Transaction_Action_Stop then
        v_Orig_Code := Gmap().Json();
      end if;
    
      if v_Orig_Code <> v_Clone_Code then
        v_Part.Part_Begin := r.Period_Start;
        v_Part.Part_End   := r.Period_End;
      
        Result.Extend;
        result(Result.Count) := v_Part;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Timeoff_Interval_Kind
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Timeoff_Id number
  ) return varchar2 is
    result varchar2(1);
  begin
    select Coalesce((select Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Vacation
                      from Hpd_Vacations Vc
                     where Vc.Company_Id = Tn.Company_Id
                       and Vc.Filial_Id = Tn.Filial_Id
                       and Vc.Timeoff_Id = Tn.Timeoff_Id),
                    (select Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Sick_Leave
                       from Hpd_Sick_Leaves Sl
                      where Sl.Company_Id = Tn.Company_Id
                        and Sl.Filial_Id = Tn.Filial_Id
                        and Sl.Timeoff_Id = Tn.Timeoff_Id),
                    (select Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Business_Trip
                       from Hpd_Business_Trips Bt
                      where Bt.Company_Id = Tn.Company_Id
                        and Bt.Filial_Id = Tn.Filial_Id
                        and Bt.Timeoff_Id = Tn.Timeoff_Id),
                    null)
      into result
      from Hpd_Journal_Timeoffs Tn
     where Tn.Company_Id = i_Company_Id
       and Tn.Filial_Id = i_Filial_Id
       and Tn.Timeoff_Id = i_Timeoff_Id;
  
    if result is null then
      b.Raise_Not_Implemented;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Changed_Intervals
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Staff_Id          number,
    i_Trans_Type        varchar2,
    i_Changed_Intervals Hpd_Pref.Transaction_Part_Nt
  ) is
    v_Begin_Date    date;
    v_End_Date      date;
    v_Interval_Id   number;
    v_Timeoff_Id    number;
    v_Interval_Kind varchar2(1);
  begin
    if i_Trans_Type <> Hpd_Pref.c_Transaction_Type_Vacation_Limit then
      begin
        select Lc.Begin_Date, Lc.End_Date, Lc.Interval_Id, Lc.Kind
          into v_Begin_Date, v_End_Date, v_Interval_Id, v_Interval_Kind
          from Hpd_Lock_Intervals Lc
         where Lc.Company_Id = i_Company_Id
           and Lc.Filial_Id = i_Filial_Id
           and Lc.Staff_Id = i_Staff_Id
           and exists (select *
                  from table(i_Changed_Intervals) Ch
                 where Ch.Part_Begin <= Lc.End_Date
                   and Nvl(Ch.Part_End, Href_Pref.c_Max_Date) >= Lc.Begin_Date)
           and Rownum = 1;
      
        if v_Interval_Kind = Hpd_Pref.c_Lock_Interval_Kind_Timeoff then
          select p.Timeoff_Id
            into v_Timeoff_Id
            from Hpd_Timeoff_Intervals p
           where p.Company_Id = i_Company_Id
             and p.Filial_Id = i_Filial_Id
             and p.Interval_Id = v_Interval_Id;
        
          v_Interval_Kind := Get_Timeoff_Interval_Kind(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Timeoff_Id => v_Timeoff_Id);
        end if;
      
        Hpd_Error.Raise_006(i_Interval_Kind => v_Interval_Kind,
                            i_Trans_Type    => i_Trans_Type,
                            i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                            i_Begin_Date    => v_Begin_Date,
                            i_End_Date      => v_End_Date);
      exception
        when No_Data_Found then
          null;
      end;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Aggreement_Check
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2
  ) is
    v_Dummy    varchar2(1);
    v_Count    number;
    v_Min_Date date;
    r_Journal  Hpd_Journals%rowtype;
  begin
    select count(1), min(w.Begin_Date)
      into v_Count, v_Min_Date
      from Hpd_Transactions w
     where w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Staff_Id = i_Staff_Id
       and w.Trans_Type = i_Trans_Type
       and w.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated, --
                       Hpd_Pref.c_Transaction_Event_In_Progress);
  
    -- TODO comment  
    if v_Count = 0 then
      return;
    end if;
  
    select 'x'
      into v_Dummy
      from Hpd_Transactions w
     where w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Staff_Id = i_Staff_Id
       and w.Trans_Type = i_Trans_Type
       and w.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated, --
                       Hpd_Pref.c_Transaction_Event_In_Progress)
       and w.Begin_Date = v_Min_Date
       and w.End_Date is null
       and Rownum = 1;
  exception
    when No_Data_Found then
      select w.Journal_Id
        into r_Journal.Journal_Id
        from Hpd_Transactions w
       where w.Company_Id = i_Company_Id
         and w.Filial_Id = i_Filial_Id
         and w.Staff_Id = i_Staff_Id
         and w.Trans_Type = i_Trans_Type
         and w.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated, --
                         Hpd_Pref.c_Transaction_Event_In_Progress)
         and w.Begin_Date = v_Min_Date
       order by w.Order_No desc
       fetch first row only;
    
      r_Journal := z_Hpd_Journals.Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Journal_Id => r_Journal.Journal_Id);
    
      Hpd_Error.Raise_074(i_Journal_Id     => r_Journal.Journal_Id, --
                          i_Journal_Number => r_Journal.Journal_Number,
                          i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                   i_Filial_Id  => i_Filial_Id,
                                                                   i_Staff_Id   => i_Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Evaluate
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Staff_Id               number,
    i_Trans_Type             varchar2,
    i_Changed_Dismissal_Date date
  ) is
    v_Start             date := i_Changed_Dismissal_Date;
    v_Trans_Start       date;
    v_Changed_Intervals Hpd_Pref.Transaction_Part_Nt;
  begin
    Assert_Aggreement_Check(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => i_Staff_Id,
                            i_Trans_Type => i_Trans_Type);
  
    select min(q.Begin_Date)
      into v_Trans_Start
      from Hpd_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated,
                       Hpd_Pref.c_Transaction_Event_To_Be_Deleted);
  
    v_Start := Least(Nvl(v_Start, v_Trans_Start), Nvl(v_Trans_Start, v_Start));
  
    if v_Start is null then
      Hpd_Error.Raise_030;
    end if;
  
    Agreement_Fill(i_Company_Id => i_Company_Id, --
                   i_Filial_Id  => i_Filial_Id,
                   i_Staff_Id   => i_Staff_Id,
                   i_Trans_Type => i_Trans_Type,
                   i_Start_Date => v_Start);
  
    if not Hpd_Pref.g_Migration_Active and Md_Pref.c_Migr_Company_Id != i_Company_Id then
      v_Changed_Intervals := Get_Changed_Intervals(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Staff_Id   => i_Staff_Id,
                                                   i_Trans_Type => i_Trans_Type,
                                                   i_Start_Date => v_Start);
    
      Assert_Changed_Intervals(i_Company_Id        => i_Company_Id,
                               i_Filial_Id         => i_Filial_Id,
                               i_Staff_Id          => i_Staff_Id,
                               i_Trans_Type        => i_Trans_Type,
                               i_Changed_Intervals => v_Changed_Intervals);
    end if;
  
    case i_Trans_Type
      when Hpd_Pref.c_Transaction_Type_Robot then
        Integrate_Robot_Agreements(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Start_Date => v_Start);
      when Hpd_Pref.c_Transaction_Type_Schedule then
        if not Hpd_Pref.g_Migration_Active and Md_Pref.c_Migr_Company_Id != i_Company_Id then
          Integrate_Schedule_Agreements(i_Company_Id        => i_Company_Id,
                                        i_Filial_Id         => i_Filial_Id,
                                        i_Staff_Id          => i_Staff_Id,
                                        i_Changed_Intervals => v_Changed_Intervals);
        end if;
      when Hpd_Pref.c_Transaction_Type_Vacation_Limit then
        if not Hpd_Pref.g_Migration_Active and v_Changed_Intervals.Count > 0 then
          Integrate_Vacation_Limit_Agreements(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Staff_Id   => i_Staff_Id,
                                              i_Start_Date => v_Start);
        end if;
      else
        null;
    end case;
  
    -- deleting stacked transactions
    delete from Hpd_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Event = Hpd_Pref.c_Transaction_Event_To_Be_Deleted;
  
    -- move in progree stacked transactions
    update Hpd_Transactions q
       set q.Event = Hpd_Pref.c_Transaction_Event_In_Progress
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Event = Hpd_Pref.c_Transaction_Event_To_Be_Integrated;
  
  end;

  ----------------------------------------------------------------------------------------------------
  -- %param i_Start_Date date first in progress trans before first to_be_integrated/to_be_deleted trans 
  -- %param i_Finish_Date date first in progress trans after last to_be_integrated/to_be_deleted trans max among different trans types
  Procedure Fill_Agreements_Cache
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Start_Date     date,
    i_Finish_Date    date,
    i_Dismissal_Date date
  ) is
    v_Finish_Date date := Least(i_Finish_Date, Nvl(i_Dismissal_Date - 1, i_Finish_Date));
    v_Old_Cache   Hpd_Pref.Agreement_Cache_Nt;
  
    v_Min_Old_Begin date;
    v_Max_Old_End   date;
  
    -------------------------------------------------- 
    Procedure Integrate_Individual_Robot_Schedules is
      v_Cache             Hpd_Pref.Agreement_Cache_Rt;
      v_Robot_Schedule_Id number := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                                         i_Filial_Id  => i_Filial_Id,
                                                         i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    begin
      if v_Old_Cache.Count = 0 then
        v_Old_Cache.Extend;
        v_Old_Cache(1) := Hpd_Pref.Agreement_Cache_Rt(Staff_Id    => i_Staff_Id,
                                                      Robot_Id    => -1,
                                                      Schedule_Id => -1,
                                                      Begin_Date  => i_Start_Date,
                                                      End_Date    => v_Finish_Date);
      end if;
    
      if v_Min_Old_Begin is not null then
        -- adding period before old changes
        -- to register new changes in this period
        v_Cache := Hpd_Pref.Agreement_Cache_Rt(Staff_Id    => i_Staff_Id,
                                               Robot_Id    => -1,
                                               Schedule_Id => -1,
                                               Begin_Date  => Href_Pref.c_Min_Date,
                                               End_Date    => v_Min_Old_Begin - 1);
      
        v_Old_Cache.Extend;
        v_Old_Cache(v_Old_Cache.Count) := v_Cache;
      end if;
    
      if v_Max_Old_End is not null then
        -- adding period after old changes
        -- to register new changes in this period
        v_Cache := Hpd_Pref.Agreement_Cache_Rt(Staff_Id    => i_Staff_Id,
                                               Robot_Id    => -1,
                                               Schedule_Id => -1,
                                               Begin_Date  => case
                                                                when v_Max_Old_End <> Href_Pref.c_Max_Date then
                                                                 v_Max_Old_End + 1
                                                                else
                                                                 v_Max_Old_End
                                                              end,
                                               End_Date    => Href_Pref.c_Max_Date);
      
        v_Old_Cache.Extend;
        v_Old_Cache(v_Old_Cache.Count) := v_Cache;
      end if;
    
      for r in (with Old_Cache as
                   (select Oc.Begin_Date,
                          Oc.End_Date,
                          Oc.Robot_Id,
                          Nvl(Oc.Schedule_Id, -1) Schedule_Id
                     from table(v_Old_Cache) Oc),
                  New_Cache as
                   (select Nc.Begin_Date, Nc.End_Date, Nc.Robot_Id
                     from Hpd_Agreements_Cache Nc
                    where Nc.Company_Id = i_Company_Id
                      and Nc.Filial_Id = i_Filial_Id
                      and Nc.Staff_Id = i_Staff_Id
                      and Nc.Begin_Date between i_Start_Date and v_Finish_Date
                      and Nc.Schedule_Id = v_Robot_Schedule_Id)
                  select q.Robot_Id,
                         Greatest(q.Begin_Date, p.Begin_Date) Begin_Date,
                         Least(q.End_Date, p.End_Date) End_Date
                    from New_Cache q
                    join Old_Cache p
                      on p.Begin_Date <= q.End_Date
                     and p.End_Date >= q.Begin_Date
                     and (p.Robot_Id <> q.Robot_Id or p.Schedule_Id <> v_Robot_Schedule_Id))
      loop
        -- used min with max_date - 1 because later it may be used as end_date + 1
        -- and using max_date + 1 will cause error
        Htt_Core.Gen_Timesheet_Plan_Individual(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Staff_Id    => i_Staff_Id,
                                               i_Robot_Id    => r.Robot_Id,
                                               i_Schedule_Id => v_Robot_Schedule_Id,
                                               i_Begin_Date  => r.Begin_Date,
                                               i_End_Date    => Least(r.End_Date,
                                                                      Href_Pref.c_Max_Date - 1));
      end loop;
    end;
  begin
    select min(q.Begin_Date), max(q.End_Date)
      into v_Min_Old_Begin, v_Max_Old_End
      from Hpd_Agreements_Cache q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Begin_Date between i_Start_Date and i_Finish_Date;
  
    delete Hpd_Agreements_Cache q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Begin_Date between i_Start_Date and i_Finish_Date
    returning q.Staff_Id, q.Robot_Id, q.Schedule_Id, q.Begin_Date, q.End_Date bulk collect into v_Old_Cache;
  
    insert into Hpd_Agreements_Cache
      (Company_Id, Filial_Id, Staff_Id, Begin_Date, End_Date, Robot_Id, Schedule_Id)
      with Last_Cache as
       (select Gc.Robot_Id, Gc.Schedule_Id
          from Hpd_Agreements_Cache Gc
         where Gc.Company_Id = i_Company_Id
           and Gc.Filial_Id = i_Filial_Id
           and Gc.Staff_Id = i_Staff_Id
           and i_Start_Date - 1 between Gc.Begin_Date and Gc.End_Date)
      select i_Company_Id,
             i_Filial_Id,
             i_Staff_Id,
             Qr.Period Begin_Date,
             Lead(Qr.Period - 1, 1, v_Finish_Date) Over(order by Qr.Period) End_Date,
             Last_Value(Qr.Robot_Id Ignore nulls) Over(order by Qr.Period) Robot_Id,
             Last_Value(Qr.Schedule_Id Ignore nulls) Over(order by Qr.Period) Schedule_Id
        from (select p.Period, --
                     Nvl(max(Ts.Schedule_Id),
                         Decode(p.Period,
                                i_Start_Date,
                                (select Lc.Schedule_Id
                                   from Last_Cache Lc),
                                null)) Schedule_Id,
                     Nvl(max(Tr.Robot_Id),
                         Decode(p.Period,
                                i_Start_Date,
                                (select Lc.Robot_Id
                                   from Last_Cache Lc),
                                null)) Robot_Id
                from Hpd_Agreements p
                left join Hpd_Trans_Schedules Ts
                  on Ts.Company_Id = p.Company_Id
                 and Ts.Filial_Id = p.Filial_Id
                 and Ts.Trans_Id = p.Trans_Id
                left join Hpd_Trans_Robots Tr
                  on Tr.Company_Id = p.Company_Id
                 and Tr.Filial_Id = p.Filial_Id
                 and Tr.Trans_Id = p.Trans_Id
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Staff_Id = i_Staff_Id
                 and p.Period between i_Start_Date and v_Finish_Date
                 and p.Trans_Type in
                     (Hpd_Pref.c_Transaction_Type_Robot, Hpd_Pref.c_Transaction_Type_Schedule)
                 and p.Action = Hpd_Pref.c_Transaction_Action_Continue
               group by p.Period) Qr;
  
    Integrate_Individual_Robot_Schedules;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreements_Evaluate(i_Company_Id number) is
    r_Staff                  Href_Staffs%rowtype;
    r_Employee               Mhr_Employees%rowtype;
    r_Person                 Md_Persons%rowtype;
    v_Changed_Dismissal_Date date;
    v_Dismissal_Date         date;
    v_Min_Change_Date        date;
    v_Max_Change_Date        date;
  
    --------------------------------------------------
    Procedure Check_Transactions(i_Staff Href_Staffs%rowtype) is
    begin
      -- check exists transactions before hiring
      for r in (select *
                  from Hpd_Transactions q
                 where q.Company_Id = i_Staff.Company_Id
                   and q.Filial_Id = i_Staff.Filial_Id
                   and q.Staff_Id = i_Staff.Staff_Id
                   and q.Begin_Date < i_Staff.Hiring_Date
                   and q.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated,
                                   Hpd_Pref.c_Transaction_Event_In_Progress)
                   and Rownum = 1)
      loop
        r_Employee := z_Mhr_Employees.Load(i_Company_Id  => i_Staff.Company_Id,
                                           i_Filial_Id   => i_Staff.Filial_Id,
                                           i_Employee_Id => i_Staff.Employee_Id);
      
        r_Person := z_Md_Persons.Load(i_Company_Id => i_Staff.Company_Id,
                                      i_Person_Id  => i_Staff.Employee_Id);
      
        Hpd_Error.Raise_007(i_Staff_Name  => r_Person.Name,
                            i_Trans_Type  => r.Trans_Type,
                            i_Trans_Date  => r.Begin_Date,
                            i_Hiring_Date => i_Staff.Hiring_Date);
      end loop;
    
      -- check there are other documents after dismissal document
      if i_Staff.Dismissal_Date is not null then
        for r in (select *
                    from Hpd_Transactions q
                   where q.Company_Id = i_Staff.Company_Id
                     and q.Filial_Id = i_Staff.Filial_Id
                     and q.Staff_Id = i_Staff.Staff_Id
                     and q.Begin_Date > i_Staff.Dismissal_Date
                     and q.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated,
                                     Hpd_Pref.c_Transaction_Event_In_Progress)
                   order by q.Begin_Date
                   fetch first row only)
        loop
          r_Employee := z_Mhr_Employees.Load(i_Company_Id  => i_Staff.Company_Id,
                                             i_Filial_Id   => i_Staff.Filial_Id,
                                             i_Employee_Id => i_Staff.Employee_Id);
        
          r_Person := z_Md_Persons.Load(i_Company_Id => i_Staff.Company_Id,
                                        i_Person_Id  => i_Staff.Employee_Id);
        
          Hpd_Error.Raise_008(i_Staff_Name     => r_Person.Name,
                              i_Trans_Type     => r.Trans_Type,
                              i_Trans_Date     => r.Begin_Date,
                              i_Dismissal_Date => i_Staff.Dismissal_Date);
        end loop;
      end if;
    end;
  begin
    --
    for r in (select q.Company_Id, --
                     q.Filial_Id,
                     q.Staff_Id
                from Hpd_Dirty_Agreements q
               group by q.Company_Id, q.Filial_Id, q.Staff_Id)
    loop
      r_Staff := z_Href_Staffs.Load(i_Company_Id => r.Company_Id,
                                    i_Filial_Id  => r.Filial_Id,
                                    i_Staff_Id   => r.Staff_Id);
    
      -- check exists transactions before hiring
      Check_Transactions(r_Staff);
    
      -- get lowest changed dismissal date
      select min(q.Dismissal_Date),
             min(Decode(q.Event, Hpd_Pref.c_Transaction_Event_To_Be_Deleted, null, q.Dismissal_Date))
        into v_Changed_Dismissal_Date, v_Dismissal_Date
        from Hpd_Dismissal_Transactions q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Staff_Id = r.Staff_Id;
    
      select min(q.Begin_Date), max(q.Begin_Date)
        into v_Min_Change_Date, v_Max_Change_Date
        from Hpd_Transactions q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Staff_Id = r.Staff_Id
         and q.Trans_Type in
             (Hpd_Pref.c_Transaction_Type_Schedule, Hpd_Pref.c_Transaction_Type_Robot)
         and q.Event in (Hpd_Pref.c_Transaction_Event_To_Be_Integrated,
                         Hpd_Pref.c_Transaction_Event_To_Be_Deleted);
    
      v_Min_Change_Date := Nvl(Least(Nvl(v_Min_Change_Date, v_Changed_Dismissal_Date),
                                     Nvl(v_Changed_Dismissal_Date, v_Min_Change_Date)),
                               Href_Pref.c_Min_Date);
    
      v_Max_Change_Date := Nvl(v_Max_Change_Date, v_Min_Change_Date);
    
      select max(Qr.Begin_Date)
        into v_Max_Change_Date
        from (select min(Tr.Begin_Date) Begin_Date
                from (select q.Trans_Type, q.Begin_Date - 1 Begin_Date
                        from Hpd_Transactions q
                       where q.Company_Id = r.Company_Id
                         and q.Filial_Id = r.Filial_Id
                         and q.Staff_Id = r.Staff_Id
                         and q.Trans_Type in
                             (Hpd_Pref.c_Transaction_Type_Schedule, Hpd_Pref.c_Transaction_Type_Robot)
                         and q.Begin_Date > v_Max_Change_Date
                         and q.Event = Hpd_Pref.c_Transaction_Event_In_Progress
                      union all
                      select Hpd_Pref.c_Transaction_Type_Schedule, Href_Pref.c_Max_Date
                        from Dual
                      union all
                      select Hpd_Pref.c_Transaction_Type_Robot, Href_Pref.c_Max_Date
                        from Dual) Tr
               group by Tr.Trans_Type) Qr;
    
      select max(q.Begin_Date)
        into v_Min_Change_Date
        from Hpd_Transactions q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Staff_Id = r.Staff_Id
         and q.Trans_Type in
             (Hpd_Pref.c_Transaction_Type_Schedule, Hpd_Pref.c_Transaction_Type_Robot)
         and q.Begin_Date < v_Min_Change_Date
         and q.Event = Hpd_Pref.c_Transaction_Event_In_Progress;
    
      v_Min_Change_Date := Nvl(v_Min_Change_Date, Href_Pref.c_Min_Date);
    
      for Agr in (select q.Trans_Type
                    from Hpd_Dirty_Agreements q
                   where q.Company_Id = r.Company_Id
                     and q.Filial_Id = r.Filial_Id
                     and q.Staff_Id = r.Staff_Id)
      loop
        Agreement_Evaluate(i_Company_Id             => r.Company_Id,
                           i_Filial_Id              => r.Filial_Id,
                           i_Staff_Id               => r.Staff_Id,
                           i_Trans_Type             => Agr.Trans_Type,
                           i_Changed_Dismissal_Date => v_Changed_Dismissal_Date);
      end loop;
    
      -- if staff is passive, check that there are no more transactions
      if r_Staff.State = 'P' then
        for Trans in (select *
                        from Hpd_Transactions St
                       where St.Company_Id = r.Company_Id
                         and St.Filial_Id = r.Filial_Id
                         and St.Staff_Id = r.Staff_Id)
        loop
          Hpd_Error.Raise_009(Href_Util.Staff_Name(i_Company_Id => r_Staff.Company_Id,
                                                   i_Filial_Id  => r_Staff.Filial_Id,
                                                   i_Staff_Id   => r_Staff.Staff_Id));
        end loop;
      end if;
    
      Fill_Agreements_Cache(i_Company_Id     => r.Company_Id,
                            i_Filial_Id      => r.Filial_Id,
                            i_Staff_Id       => r.Staff_Id,
                            i_Start_Date     => v_Min_Change_Date,
                            i_Finish_Date    => v_Max_Change_Date,
                            i_Dismissal_Date => v_Dismissal_Date);
    end loop;
  
    -- deleting stacked dismissal transactions
    delete Hpd_Dismissal_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Event = Hpd_Pref.c_Transaction_Event_To_Be_Deleted;
  
    -- move in progree stacked dismissal transactions
    update Hpd_Dismissal_Transactions q
       set q.Event = Hpd_Pref.c_Transaction_Event_In_Progress
     where q.Company_Id = i_Company_Id
       and q.Event = Hpd_Pref.c_Transaction_Event_To_Be_Integrated;
  
    delete Hpd_Cloned_Agreements q
     where q.Company_Id = i_Company_Id;
  
    delete Hpd_Dirty_Agreements q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Dirty
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hpd_Dirty_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type;
  exception
    when No_Data_Found then
      insert into Hpd_Dirty_Agreements
        (Company_Id, Filial_Id, Staff_Id, Trans_Type)
      values
        (i_Company_Id, i_Filial_Id, i_Staff_Id, i_Trans_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Parent_Staff
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Employee_Id    number,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  ) return number is
    v_Dismissal_Date date := Nvl(i_Dismissal_Date, Href_Pref.c_Max_Date);
    result           Href_Staffs%rowtype;
  begin
    select q.*
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Employee_Id = i_Employee_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.State = 'A'
       and Nvl(q.Dismissal_Date, Href_Pref.c_Max_Date) >= i_Hiring_Date
       and q.Hiring_Date <= v_Dismissal_Date;
  
    -- check cross out from primary job
    if Result.Hiring_Date <= i_Hiring_Date and
       Nvl(Result.Dismissal_Date, Href_Pref.c_Max_Date) >= v_Dismissal_Date then
      return Result.Staff_Id;
    end if;
  
    if i_Hiring_Date < Result.Hiring_Date then
      Hpd_Error.Raise_010(i_Staff_Name       => Href_Util.Staff_Name(i_Company_Id => Result.Company_Id,
                                                                     i_Filial_Id  => Result.Filial_Id,
                                                                     i_Staff_Id   => Result.Staff_Id),
                          i_Primary_Hiring   => Result.Hiring_Date,
                          i_Secondary_Hiring => i_Hiring_Date);
    end if;
  
    if v_Dismissal_Date > Nvl(Result.Dismissal_Date, Href_Pref.c_Max_Date) then
      Hpd_Error.Raise_011(i_Staff_Name          => Href_Util.Staff_Name(i_Company_Id => Result.Company_Id,
                                                                        i_Filial_Id  => Result.Filial_Id,
                                                                        i_Staff_Id   => Result.Staff_Id),
                          i_Primary_Dismissal   => Result.Dismissal_Date,
                          i_Secondary_Dismissal => v_Dismissal_Date);
    end if;
  exception
    when No_Data_Found then
      Hpd_Error.Raise_012(i_Staff_Name  => z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, --
                                           i_Person_Id => i_Employee_Id).Name,
                          i_Hiring_Date => i_Hiring_Date);
    when Too_Many_Rows then
      Hpd_Error.Raise_013(i_Staff_Name  => z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, --
                                           i_Person_Id => i_Employee_Id).Name,
                          i_Hiring_Date => i_Hiring_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trans_Insert
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Begin_Date date,
    i_End_Date   date,
    i_Order_No   number,
    i_Journal_Id number,
    i_Page_Id    number,
    i_Tag        varchar2
  ) return number is
    r_Staff Href_Staffs%rowtype;
    r_Trans Hpd_Transactions%rowtype;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.Hiring_Date > i_Begin_Date then
      Hpd_Error.Raise_014(i_Staff_Name  => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                i_Filial_Id  => i_Filial_Id,
                                                                i_Staff_Id   => i_Staff_Id),
                          i_Trans_Type  => i_Trans_Type,
                          i_Trans_Date  => i_Begin_Date,
                          i_Hiring_Date => r_Staff.Hiring_Date);
    end if;
  
    r_Trans.Company_Id := i_Company_Id;
    r_Trans.Filial_Id  := i_Filial_Id;
    r_Trans.Trans_Id   := Hpd_Next.Trans_Id;
    r_Trans.Staff_Id   := i_Staff_Id;
    r_Trans.Trans_Type := i_Trans_Type;
    r_Trans.Begin_Date := i_Begin_Date;
    r_Trans.End_Date   := i_End_Date;
    r_Trans.Order_No   := i_Order_No;
    r_Trans.Journal_Id := i_Journal_Id;
    r_Trans.Page_Id    := i_Page_Id;
    r_Trans.Tag        := i_Tag;
    r_Trans.Event      := Hpd_Pref.c_Transaction_Event_To_Be_Integrated;
  
    z_Hpd_Transactions.Insert_Row(r_Trans);
  
    Agreement_Dirty(i_Company_Id => i_Company_Id,
                    i_Filial_Id  => i_Filial_Id,
                    i_Staff_Id   => i_Staff_Id,
                    i_Trans_Type => i_Trans_Type);
  
    return r_Trans.Trans_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Life_Cycle_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff  Href_Staffs%rowtype;
    v_Cnt    number;
    r_Person Md_Persons%rowtype;
    --------------------------------------------------
    Function Staff_State return varchar2 is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hpd_Hirings q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and exists (select *
                from Hpd_Journal_Pages w
                join Hpd_Journals k
                  on k.Company_Id = i_Company_Id
                 and k.Filial_Id = i_Filial_Id
                 and k.Journal_Id = w.Journal_Id
               where w.Company_Id = i_Company_Id
                 and w.Filial_Id = i_Filial_Id
                 and w.Page_Id = q.Page_Id
                 and k.Posted = 'Y');
    
      return 'A';
    exception
      when No_Data_Found then
        return 'P';
    end;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    r_Staff.State := Staff_State;
  
    select min(Dt.Dismissal_Date) - 1, min(k.Dismissal_Reason_Id), min(k.Note), count(1)
      into r_Staff.Dismissal_Date, r_Staff.Dismissal_Reason_Id, r_Staff.Dismissal_Note, v_Cnt
      from Hpd_Journal_Pages Jp
      join Hpd_Dismissal_Transactions Dt
        on Dt.Company_Id = Jp.Company_Id
       and Dt.Filial_Id = Jp.Filial_Id
       and Dt.Page_Id = Jp.Page_Id
       and Dt.Event in
           (Hpd_Pref.c_Transaction_Event_To_Be_Integrated, Hpd_Pref.c_Transaction_Event_In_Progress)
      left join Hpd_Dismissals k
        on k.Company_Id = Dt.Company_Id
       and k.Filial_Id = Dt.Filial_Id
       and k.Page_Id = Dt.Page_Id
     where Jp.Company_Id = i_Company_Id
       and Jp.Filial_Id = i_Filial_Id
       and Jp.Staff_Id = i_Staff_Id;
  
    if Nvl(v_Cnt, 0) > 1 then
      r_Person := z_Md_Persons.Load(i_Company_Id => r_Staff.Company_Id,
                                    i_Person_Id  => r_Staff.Employee_Id);
    
      Hpd_Error.Raise_015(i_Staff_Name => r_Person.Name, i_Dismissed_Cnt => v_Cnt);
    end if;
  
    if r_Staff.Hiring_Date > r_Staff.Dismissal_Date then
      Hpd_Error.Raise_016(i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => r_Staff.Company_Id,
                                                                   i_Filial_Id  => r_Staff.Filial_Id,
                                                                   i_Staff_Id   => r_Staff.Staff_Id),
                          i_Hiring_Date    => r_Staff.Hiring_Date,
                          i_Dismissal_Date => r_Staff.Dismissal_Date);
    end if;
  
    z_Href_Staffs.Save_Row(r_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Relationship_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff Href_Staffs%rowtype;
    v_Count number;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
    if r_Staff.State = 'P' then
      if r_Staff.Dismissal_Date is not null then
        Hpd_Error.Raise_017(Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id,
                                                 i_Staff_Id   => i_Staff_Id));
      end if;
    
      select count(1)
        into v_Count
        from Href_Staffs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Parent_Id = i_Staff_Id
         and q.State = 'A';
    
      if v_Count > 0 then
        Hpd_Error.Raise_018(Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id,
                                                 i_Staff_Id   => i_Staff_Id));
      end if;
    
      return;
    end if;
  
    if r_Staff.Staff_Kind = Href_Pref.c_Staff_Kind_Primary then
      Assert_Intersection_Staff(i_Company_Id  => i_Company_Id,
                                i_Filial_Id   => i_Filial_Id,
                                i_Employee_Id => r_Staff.Employee_Id);
      for r in (select *
                  from Href_Staffs q
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Parent_Id = i_Staff_Id
                   and q.State = 'A'
                   and not (r_Staff.Hiring_Date <= q.Hiring_Date and
                        Nvl(q.Dismissal_Date, Href_Pref.c_Max_Date) <=
                        Nvl(r_Staff.Dismissal_Date, Href_Pref.c_Max_Date)))
      loop
        Hpd_Error.Raise_019(i_Staff_Name       => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                       i_Filial_Id  => i_Filial_Id,
                                                                       i_Staff_Id   => i_Staff_Id),
                            i_Secondary_Hiring => r.Hiring_Date,
                            i_Primary_Hiring   => r_Staff.Hiring_Date);
      end loop;
    else
      z_Href_Staffs.Update_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Parent_Id  => Option_Number(Get_Parent_Staff(i_Company_Id     => r_Staff.Company_Id,
                                                                              i_Filial_Id      => r_Staff.Filial_Id,
                                                                              i_Employee_Id    => r_Staff.Employee_Id,
                                                                              i_Hiring_Date    => r_Staff.Hiring_Date,
                                                                              i_Dismissal_Date => r_Staff.Dismissal_Date)));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Employee_Number
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff        Href_Staffs%rowtype;
    v_Staff_Number varchar2(50 char);
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    select p.Staff_Number
      into v_Staff_Number
      from Href_Staffs p
     where p.Company_Id = r_Staff.Company_Id
       and p.Filial_Id = r_Staff.Filial_Id
       and p.Employee_Id = r_Staff.Employee_Id
       and p.State = 'A'
       and p.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
     order by p.Hiring_Date desc
     fetch first row only;
  
    z_Mhr_Employees.Update_One(i_Company_Id      => r_Staff.Company_Id,
                               i_Filial_Id       => r_Staff.Filial_Id,
                               i_Employee_Id     => r_Staff.Employee_Id,
                               i_Employee_Number => Option_Varchar2(v_Staff_Number));
  exception
    when No_Data_Found then
      return;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_User_Filial
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff   Href_Staffs%rowtype;
    r_Person  Mr_Natural_Persons%rowtype;
    r_User    Md_Users%rowtype;
    v_Role_Id number;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.Staff_Kind <> Href_Pref.c_Staff_Kind_Primary or --
       r_Staff.Dismissal_Date is not null then
      return;
    end if;
  
    if not z_Md_Users.Exist_Lock(i_Company_Id => i_Company_Id, --
                                 i_User_Id    => r_Staff.Employee_Id) then
      r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => i_Company_Id,
                                                 i_Person_Id  => r_Staff.Employee_Id);
    
      z_Md_Users.Init(p_Row        => r_User,
                      i_Company_Id => r_Person.Company_Id,
                      i_User_Id    => r_Person.Person_Id,
                      i_Name       => r_Person.Name,
                      i_User_Kind  => Md_Pref.c_Uk_Normal,
                      i_Gender     => r_Person.Gender,
                      i_State      => 'A');
    
      Md_Api.User_Save(r_User);
    end if;
  
    if not z_Md_User_Filials.Exist(i_Company_Id => i_Company_Id,
                                   i_User_Id    => r_Staff.Employee_Id,
                                   i_Filial_Id  => i_Filial_Id) then
      Md_Api.User_Add_Filial(i_Company_Id => i_Company_Id,
                             i_User_Id    => r_Staff.Employee_Id,
                             i_Filial_Id  => i_Filial_Id);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if not z_Md_User_Roles.Exist(i_Company_Id => i_Company_Id,
                                 i_User_Id    => r_Staff.Employee_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => i_Company_Id,
                        i_User_Id    => r_Staff.Employee_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dirty_Staffs_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Staff_Ids Array_Number;
  begin
    for r in (select *
                from Hpd_Dirty_Staffs q
               where q.Company_Id = i_Company_Id
               order by q.Staff_Id)
    loop
      Staff_Life_Cycle_Evaluate(i_Company_Id => r.Company_Id,
                                i_Filial_Id  => r.Filial_Id,
                                i_Staff_Id   => r.Staff_Id);
    end loop;
  
    for r in (select *
                from Hpd_Dirty_Staffs q
               where q.Company_Id = i_Company_Id
               order by q.Staff_Id)
    loop
      Staff_Relationship_Evaluate(i_Company_Id => r.Company_Id,
                                  i_Filial_Id  => r.Filial_Id,
                                  i_Staff_Id   => r.Staff_Id);
    end loop;
  
    for r in (select *
                from Hpd_Dirty_Staffs q
               where q.Company_Id = i_Company_Id
               order by q.Staff_Id)
    loop
      Update_Employee_Number(i_Company_Id => r.Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Staff_Id   => r.Staff_Id);
    end loop;
  
    for r in (select *
                from Hpd_Dirty_Staffs q
               where q.Company_Id = i_Company_Id)
    loop
      Attach_User_Filial(i_Company_Id => r.Company_Id,
                         i_Filial_Id  => r.Filial_Id,
                         i_Staff_Id   => r.Staff_Id);
    end loop;
  
    select q.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Hpd_Dirty_Staffs q
      join Href_Staffs w
        on q.Company_Id = w.Company_Id
       and q.Filial_Id = w.Filial_Id
       and q.Staff_Id = w.Staff_Id
     where q.Company_Id = i_Company_Id
     order by w.Employee_Id;
  
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Staff_Ids  => v_Staff_Ids);
  
    delete Hpd_Dirty_Staffs q
     where q.Company_Id = i_Company_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Trash_Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    for r in (select Jp.Employee_Id
                from Hpd_Journal_Pages Jp
               where Jp.Company_Id = i_Company_Id
                 and Jp.Filial_Id = i_Filial_Id
                 and Jp.Journal_Id = i_Journal_Id
               group by Jp.Employee_Id)
    loop
      Htt_Api.Make_Trash_Tracks(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Person_Id  => r.Employee_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hpd_Dirty_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  exception
    when No_Data_Found then
      insert into Hpd_Dirty_Staffs q
        (Company_Id, Filial_Id, Staff_Id)
      values
        (i_Company_Id, i_Filial_Id, i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Terminate
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Journal_Id     number,
    i_Page_Id        number,
    i_Dismissal_Date date
  ) is
    r_Staff Href_Staffs%rowtype;
    r_Trans Hpd_Dismissal_Transactions%rowtype;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.Hiring_Date > i_Dismissal_Date then
      Hpd_Error.Raise_020(i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                   i_Filial_Id  => i_Filial_Id,
                                                                   i_Staff_Id   => i_Staff_Id),
                          i_Hiring_Date    => r_Staff.Hiring_Date,
                          i_Dismissal_Date => i_Dismissal_Date);
    end if;
  
    r_Trans.Company_Id     := i_Company_Id;
    r_Trans.Filial_Id      := i_Filial_Id;
    r_Trans.Trans_Id       := Hpd_Next.Trans_Id;
    r_Trans.Staff_Id       := i_Staff_Id;
    r_Trans.Dismissal_Date := i_Dismissal_Date + 1;
    r_Trans.Journal_Id     := i_Journal_Id;
    r_Trans.Page_Id        := i_Page_Id;
    r_Trans.Event          := Hpd_Pref.c_Transaction_Event_To_Be_Integrated;
  
    z_Hpd_Dismissal_Transactions.Insert_Row(r_Trans);
  
    for r in (select q.Trans_Type
                from Hpd_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
               group by q.Trans_Type)
    loop
      Agreement_Dirty(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Staff_Id   => i_Staff_Id,
                      i_Trans_Type => r.Trans_Type);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Restore
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number,
    i_Staff_Id   number
  ) is
  begin
    for r in (select *
                from Hpd_Dismissal_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id)
    loop
      z_Hpd_Dismissal_Transactions.Update_One(i_Company_Id => r.Company_Id,
                                              i_Filial_Id  => r.Filial_Id,
                                              i_Trans_Id   => r.Trans_Id,
                                              i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Deleted));
    end loop;
  
    for r in (select q.Trans_Type
                from Hpd_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Id = i_Staff_Id
               group by q.Trans_Type)
    loop
      Agreement_Dirty(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Staff_Id   => i_Staff_Id,
                      i_Trans_Type => r.Trans_Type);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Trans_Insert
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Page_Id          number,
    i_Staff_Id         number,
    i_Begin_Date       date,
    i_End_Date         date,
    i_Order_No         number,
    i_Robot_Id         number,
    i_Division_Id      number,
    i_Job_Id           number,
    i_Employment_Type  varchar2,
    i_Fte_Id           number,
    i_Fte              number,
    i_Wage_Scale_Id    number,
    i_Contractual_Wage varchar2,
    i_Source_Table     Fazo_Schema.w_Table_Name
  ) is
    v_Fte      number := i_Fte;
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                               i_Journal_Id => i_Journal_Id,
                               i_Page_Id    => i_Page_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Begin_Date => i_Begin_Date,
                               i_End_Date   => i_End_Date,
                               i_Order_No   => i_Order_No,
                               i_Tag        => i_Source_Table.Name);
  
    if i_Fte_Id is not null then
      v_Fte := z_Href_Ftes.Load(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id).Fte_Value;
    end if;
  
    z_Hpd_Trans_Robots.Insert_One(i_Company_Id       => i_Company_Id,
                                  i_Filial_Id        => i_Filial_Id,
                                  i_Trans_Id         => v_Trans_Id,
                                  i_Robot_Id         => i_Robot_Id,
                                  i_Division_Id      => i_Division_Id,
                                  i_Job_Id           => i_Job_Id,
                                  i_Employment_Type  => i_Employment_Type,
                                  i_Fte_Id           => i_Fte_Id,
                                  i_Fte              => v_Fte,
                                  i_Contractual_Wage => i_Contractual_Wage,
                                  i_Wage_Scale_Id    => i_Wage_Scale_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Schedule_Id  number,
    i_Source_Table Fazo_Schema.w_Table_Name
  ) is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Trans_Type => Hpd_Pref.c_Transaction_Type_Schedule,
                               i_Journal_Id => i_Journal_Id,
                               i_Page_Id    => i_Page_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Begin_Date => i_Begin_Date,
                               i_End_Date   => i_End_Date,
                               i_Order_No   => i_Order_No,
                               i_Tag        => i_Source_Table.Name);
  
    z_Hpd_Trans_Schedules.Insert_One(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Trans_Id    => v_Trans_Id,
                                     i_Schedule_Id => i_Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Currency_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Currency_Id  number,
    i_Source_Table Fazo_Schema.w_Table_Name
  ) is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Trans_Type => Hpd_Pref.c_Transaction_Type_Currency,
                               i_Journal_Id => i_Journal_Id,
                               i_Page_Id    => i_Page_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Begin_Date => i_Begin_Date,
                               i_End_Date   => i_End_Date,
                               i_Order_No   => i_Order_No,
                               i_Tag        => i_Source_Table.Name);
  
    z_Hpd_Trans_Currencies.Insert_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Trans_Id    => v_Trans_Id,
                                      i_Currency_Id => i_Currency_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Days_Limit   number,
    i_Source_Table Fazo_Schema.w_Table_Name
  ) is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Trans_Type => Hpd_Pref.c_Transaction_Type_Vacation_Limit,
                               i_Journal_Id => i_Journal_Id,
                               i_Page_Id    => i_Page_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Begin_Date => i_Begin_Date,
                               i_End_Date   => i_End_Date,
                               i_Order_No   => i_Order_No,
                               i_Tag        => i_Source_Table.Name);
  
    z_Hpd_Trans_Vacation_Limits.Save_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Trans_Id   => v_Trans_Id,
                                         i_Days_Limit => i_Days_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Rank_Id      number,
    i_Source_Table Fazo_Schema.w_Table_Name
  ) is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Trans_Type => Hpd_Pref.c_Transaction_Type_Rank,
                               i_Journal_Id => i_Journal_Id,
                               i_Page_Id    => i_Page_Id,
                               i_Staff_Id   => i_Staff_Id,
                               i_Begin_Date => i_Begin_Date,
                               i_End_Date   => i_End_Date,
                               i_Order_No   => i_Order_No,
                               i_Tag        => i_Source_Table.Name);
  
    if i_Rank_Id is not null then
      z_Hpd_Trans_Ranks.Insert_One(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Trans_Id   => v_Trans_Id,
                                   i_Rank_Id    => i_Rank_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Trans_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Page_Id      number,
    i_Staff_Id     number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Order_No     number,
    i_Source_Table Fazo_Schema.w_Table_Name
  ) is
    v_Indicator     Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    v_Oper_Types    Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Indicator_Ids Array_Number;
    v_Trans_Id      number;
  begin
    for r in (select *
                from Hpd_Page_Indicators q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id)
    loop
      Hpd_Util.Indicator_Add(p_Indicator       => v_Indicator,
                             i_Indicator_Id    => r.Indicator_Id,
                             i_Indicator_Value => r.Indicator_Value);
    end loop;
  
    for r in (select q.*
                from Hpd_Page_Oper_Types q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id)
    loop
      select q.Indicator_Id
        bulk collect
        into v_Indicator_Ids
        from Hpd_Oper_Type_Indicators q
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Page_Id = r.Page_Id
         and q.Oper_Type_Id = r.Oper_Type_Id;
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Types,
                             i_Oper_Type_Id  => r.Oper_Type_Id,
                             i_Indicator_Ids => v_Indicator_Ids);
    end loop;
  
    if v_Oper_Types.Count > 0 then
      v_Trans_Id := Trans_Insert(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                 i_Journal_Id => i_Journal_Id,
                                 i_Page_Id    => i_Page_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Begin_Date => i_Begin_Date,
                                 i_End_Date   => i_End_Date,
                                 i_Order_No   => i_Order_No,
                                 i_Tag        => i_Source_Table.Name);
    
      for i in 1 .. v_Indicator.Count
      loop
        z_Hpd_Trans_Indicators.Insert_One(i_Company_Id      => i_Company_Id,
                                          i_Filial_Id       => i_Filial_Id,
                                          i_Trans_Id        => v_Trans_Id,
                                          i_Indicator_Id    => v_Indicator(i).Indicator_Id,
                                          i_Indicator_Value => v_Indicator(i).Indicator_Value);
      end loop;
    end if;
  
    for i in 1 .. v_Oper_Types.Count
    loop
      z_Hpd_Trans_Oper_Types.Insert_One(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => v_Trans_Id,
                                        
                                        i_Oper_Type_Id => v_Oper_Types(i).Oper_Type_Id);
    
      v_Indicator_Ids := v_Oper_Types(i).Indicator_Ids;
    
      for j in 1 .. v_Indicator_Ids.Count
      loop
        z_Hpd_Trans_Oper_Type_Indicators.Insert_One(i_Company_Id   => i_Company_Id,
                                                    i_Filial_Id    => i_Filial_Id,
                                                    i_Trans_Id     => v_Trans_Id,
                                                    i_Oper_Type_Id => v_Oper_Types(i).Oper_Type_Id,
                                                    i_Indicator_Id => v_Indicator_Ids(j));
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Trans_Clear
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number
  ) is
  begin
    for r in (select *
                from Hpd_Transactions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id)
    loop
      z_Hpd_Transactions.Update_One(i_Company_Id => r.Company_Id,
                                    i_Filial_Id  => r.Filial_Id,
                                    i_Trans_Id   => r.Trans_Id,
                                    i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Deleted));
    
      Agreement_Dirty(i_Company_Id => r.Company_Id,
                      i_Filial_Id  => r.Filial_Id,
                      i_Staff_Id   => r.Staff_Id,
                      i_Trans_Type => r.Trans_Type);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*,
                     w.Hiring_Date,
                     w.Dismissal_Date,
                     k.Robot_Id,
                     k.Fte_Id,
                     k.Fte,
                     k.Division_Id,
                     k.Job_Id,
                     k.Rank_Id,
                     k.Employment_Type,
                     b.Wage_Scale_Id,
                     b.Contractual_Wage,
                     s.Schedule_Id,
                     Pc.Currency_Id,
                     Pl.Days_Limit
                from Hpd_Journal_Pages q
                join Hpd_Hirings w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                left join Hpd_Page_Robots k
                  on q.Company_Id = k.Company_Id
                 and q.Filial_Id = k.Filial_Id
                 and q.Page_Id = k.Page_Id
                left join Hpd_Page_Schedules s
                  on q.Company_Id = s.Company_Id
                 and q.Filial_Id = s.Filial_Id
                 and q.Page_Id = s.Page_Id
                left join Hpd_Page_Currencies Pc
                  on q.Company_Id = Pc.Company_Id
                 and q.Filial_Id = Pc.Filial_Id
                 and q.Page_Id = Pc.Page_Id
                left join Hpd_Page_Vacation_Limits Pl
                  on q.Company_Id = Pl.Company_Id
                 and q.Filial_Id = Pl.Filial_Id
                 and q.Page_Id = Pl.Page_Id
                left join Hrm_Robots b
                  on b.Company_Id = k.Company_Id
                 and b.Filial_Id = k.Filial_Id
                 and b.Robot_Id = k.Robot_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id
               order by Nullif(k.Employment_Type, Hpd_Pref.c_Employment_Type_Internal_Parttime) nulls last) -- firstly primary jobs line opened
    loop
      Make_Dirty_Staff(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Staff_Id   => r.Staff_Id);
    
      Robot_Trans_Insert(i_Company_Id       => r.Company_Id,
                         i_Filial_Id        => r.Filial_Id,
                         i_Journal_Id       => r.Journal_Id,
                         i_Page_Id          => r.Page_Id,
                         i_Staff_Id         => r.Staff_Id,
                         i_Begin_Date       => r.Hiring_Date,
                         i_End_Date         => null,
                         i_Order_No         => i_Journal.Posted_Order_No,
                         i_Robot_Id         => r.Robot_Id,
                         i_Division_Id      => r.Division_Id,
                         i_Job_Id           => r.Job_Id,
                         i_Fte_Id           => r.Fte_Id,
                         i_Fte              => r.Fte,
                         i_Employment_Type  => r.Employment_Type,
                         i_Wage_Scale_Id    => r.Wage_Scale_Id,
                         i_Contractual_Wage => r.Contractual_Wage,
                         i_Source_Table     => Zt.Hpd_Hirings);
    
      if r.Dismissal_Date is not null then
        Staff_Terminate(i_Company_Id     => r.Company_Id,
                        i_Filial_Id      => r.Filial_Id,
                        i_Staff_Id       => r.Staff_Id,
                        i_Journal_Id     => r.Journal_Id,
                        i_Page_Id        => r.Page_Id,
                        i_Dismissal_Date => r.Dismissal_Date);
      end if;
    
      if r.Schedule_Id is not null then
        Schedule_Trans_Insert(i_Company_Id   => r.Company_Id,
                              i_Filial_Id    => r.Filial_Id,
                              i_Journal_Id   => r.Journal_Id,
                              i_Page_Id      => r.Page_Id,
                              i_Staff_Id     => r.Staff_Id,
                              i_Begin_Date   => r.Hiring_Date,
                              i_End_Date     => null,
                              i_Order_No     => i_Journal.Posted_Order_No,
                              i_Schedule_Id  => r.Schedule_Id,
                              i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      if r.Currency_Id is not null then
        Currency_Trans_Insert(i_Company_Id   => r.Company_Id,
                              i_Filial_Id    => r.Filial_Id,
                              i_Journal_Id   => r.Journal_Id,
                              i_Page_Id      => r.Page_Id,
                              i_Staff_Id     => r.Staff_Id,
                              i_Begin_Date   => r.Hiring_Date,
                              i_End_Date     => null,
                              i_Order_No     => i_Journal.Posted_Order_No,
                              i_Currency_Id  => r.Currency_Id,
                              i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      if r.Rank_Id is not null then
        Rank_Trans_Insert(i_Company_Id   => r.Company_Id,
                          i_Filial_Id    => r.Filial_Id,
                          i_Journal_Id   => r.Journal_Id,
                          i_Page_Id      => r.Page_Id,
                          i_Staff_Id     => r.Staff_Id,
                          i_Begin_Date   => r.Hiring_Date,
                          i_End_Date     => null,
                          i_Order_No     => i_Journal.Posted_Order_No,
                          i_Rank_Id      => r.Rank_Id,
                          i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      if r.Days_Limit is not null then
        Vacation_Limit_Trans_Insert(i_Company_Id   => r.Company_Id,
                                    i_Filial_Id    => r.Filial_Id,
                                    i_Journal_Id   => r.Journal_Id,
                                    i_Page_Id      => r.Page_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Begin_Date   => r.Hiring_Date,
                                    i_End_Date     => null,
                                    i_Order_No     => i_Journal.Posted_Order_No,
                                    i_Days_Limit   => r.Days_Limit,
                                    i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      Oper_Type_Trans_Insert(i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_Journal_Id   => r.Journal_Id,
                             i_Page_Id      => r.Page_Id,
                             i_Staff_Id     => r.Staff_Id,
                             i_Begin_Date   => r.Hiring_Date,
                             i_End_Date     => null,
                             i_Order_No     => i_Journal.Posted_Order_No,
                             i_Source_Table => Zt.Hpd_Hirings);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*,
                     Ct.Contract_Id,
                     w.Dismissal_Date,
                     Ct.End_Date,
                     Ct.Early_Closed_Date,
                     Ct.Early_Closed_Note,
                     Ct.Posted Contract_Posted
                from Hpd_Journal_Pages q
                join Hpd_Hirings w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                join Hpd_Cv_Contracts Ct
                  on Ct.Company_Id = w.Company_Id
                 and Ct.Filial_Id = w.Filial_Id
                 and Ct.Page_Id = w.Page_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      if r.Contract_Posted = 'Y' and --
         r.Dismissal_Date <> Nvl(r.Early_Closed_Date, r.End_Date) then
        Cv_Contract_Close(i_Company_Id        => r.Company_Id,
                          i_Filial_Id         => r.Filial_Id,
                          i_Contract_Id       => r.Contract_Id,
                          i_Early_Closed_Date => r.Dismissal_Date,
                          i_Early_Closed_Note => r.Early_Closed_Note);
      
      else
        z_Hpd_Cv_Contracts.Update_One(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Contract_Id => r.Contract_Id,
                                      i_End_Date    => Option_Date(r.Dismissal_Date));
      
        Cv_Contract_Post(i_Company_Id  => r.Company_Id,
                         i_Filial_Id   => r.Filial_Id,
                         i_Contract_Id => r.Contract_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*,
                     w.Transfer_Begin,
                     w.Transfer_End,
                     k.Robot_Id,
                     k.Fte_Id,
                     k.Fte,
                     k.Division_Id,
                     k.Job_Id,
                     k.Rank_Id,
                     k.Allow_Rank,
                     k.Employment_Type,
                     b.Wage_Scale_Id,
                     b.Contractual_Wage,
                     s.Schedule_Id,
                     Pc.Currency_Id,
                     St.Staff_Kind,
                     Pl.Days_Limit
                from Hpd_Journal_Pages q
                join Hpd_Transfers w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                join Href_Staffs St
                  on St.Company_Id = q.Company_Id
                 and St.Filial_Id = q.Filial_Id
                 and St.Staff_Id = q.Staff_Id
                left join Hpd_Page_Robots k
                  on q.Company_Id = k.Company_Id
                 and q.Filial_Id = k.Filial_Id
                 and q.Page_Id = k.Page_Id
                left join Hpd_Page_Schedules s
                  on q.Company_Id = s.Company_Id
                 and q.Filial_Id = s.Filial_Id
                 and q.Page_Id = s.Page_Id
                left join Hpd_Page_Currencies Pc
                  on q.Company_Id = Pc.Company_Id
                 and q.Filial_Id = Pc.Filial_Id
                 and q.Page_Id = Pc.Page_Id
                left join Hpd_Page_Vacation_Limits Pl
                  on q.Company_Id = Pl.Company_Id
                 and q.Filial_Id = Pl.Filial_Id
                 and q.Page_Id = Pl.Page_Id
                left join Hrm_Robots b
                  on b.Company_Id = k.Company_Id
                 and b.Filial_Id = k.Filial_Id
                 and b.Robot_Id = k.Robot_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      if r.Robot_Id is not null then
        if r.Staff_Kind != Hpd_Util.Cast_Staff_Kind_By_Emp_Type(r.Employment_Type) then
          Hpd_Error.Raise_021(Href_Util.Staff_Name(i_Company_Id => r.Company_Id,
                                                   i_Filial_Id  => r.Filial_Id,
                                                   i_Staff_Id   => r.Staff_Id));
        end if;
      
        Robot_Trans_Insert(i_Company_Id       => r.Company_Id,
                           i_Filial_Id        => r.Filial_Id,
                           i_Journal_Id       => r.Journal_Id,
                           i_Page_Id          => r.Page_Id,
                           i_Staff_Id         => r.Staff_Id,
                           i_Begin_Date       => r.Transfer_Begin,
                           i_End_Date         => r.Transfer_End,
                           i_Order_No         => i_Journal.Posted_Order_No,
                           i_Robot_Id         => r.Robot_Id,
                           i_Division_Id      => r.Division_Id,
                           i_Job_Id           => r.Job_Id,
                           i_Employment_Type  => r.Employment_Type,
                           i_Fte_Id           => r.Fte_Id,
                           i_Fte              => r.Fte,
                           i_Wage_Scale_Id    => r.Wage_Scale_Id,
                           i_Contractual_Wage => r.Contractual_Wage,
                           i_Source_Table     => Zt.Hpd_Transfers);
      end if;
    
      if r.Schedule_Id is not null then
        Schedule_Trans_Insert(i_Company_Id   => r.Company_Id,
                              i_Filial_Id    => r.Filial_Id,
                              i_Journal_Id   => r.Journal_Id,
                              i_Page_Id      => r.Page_Id,
                              i_Staff_Id     => r.Staff_Id,
                              i_Begin_Date   => r.Transfer_Begin,
                              i_End_Date     => r.Transfer_End,
                              i_Order_No     => i_Journal.Posted_Order_No,
                              i_Schedule_Id  => r.Schedule_Id,
                              i_Source_Table => Zt.Hpd_Transfers);
      end if;
    
      if r.Currency_Id is not null then
        Currency_Trans_Insert(i_Company_Id   => r.Company_Id,
                              i_Filial_Id    => r.Filial_Id,
                              i_Journal_Id   => r.Journal_Id,
                              i_Page_Id      => r.Page_Id,
                              i_Staff_Id     => r.Staff_Id,
                              i_Begin_Date   => r.Transfer_Begin,
                              i_End_Date     => r.Transfer_End,
                              i_Order_No     => i_Journal.Posted_Order_No,
                              i_Currency_Id  => r.Currency_Id,
                              i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      if r.Allow_Rank = 'Y' then
        Rank_Trans_Insert(i_Company_Id   => r.Company_Id,
                          i_Filial_Id    => r.Filial_Id,
                          i_Journal_Id   => r.Journal_Id,
                          i_Page_Id      => r.Page_Id,
                          i_Staff_Id     => r.Staff_Id,
                          i_Begin_Date   => r.Transfer_Begin,
                          i_End_Date     => r.Transfer_End,
                          i_Order_No     => i_Journal.Posted_Order_No,
                          i_Rank_Id      => r.Rank_Id,
                          i_Source_Table => Zt.Hpd_Transfers);
      end if;
    
      if r.Days_Limit is not null then
        Vacation_Limit_Trans_Insert(i_Company_Id   => r.Company_Id,
                                    i_Filial_Id    => r.Filial_Id,
                                    i_Journal_Id   => r.Journal_Id,
                                    i_Page_Id      => r.Page_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Begin_Date   => r.Transfer_Begin,
                                    i_End_Date     => r.Transfer_End,
                                    i_Order_No     => i_Journal.Posted_Order_No,
                                    i_Days_Limit   => r.Days_Limit,
                                    i_Source_Table => Zt.Hpd_Transfers);
      end if;
    
      Oper_Type_Trans_Insert(i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_Journal_Id   => r.Journal_Id,
                             i_Page_Id      => r.Page_Id,
                             i_Staff_Id     => r.Staff_Id,
                             i_Begin_Date   => r.Transfer_Begin,
                             i_End_Date     => r.Transfer_End,
                             i_Order_No     => i_Journal.Posted_Order_No,
                             i_Source_Table => Zt.Hpd_Transfers);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*, w.Dismissal_Date
                from Hpd_Journal_Pages q
                join Hpd_Dismissals w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                left join Href_Staffs e
                  on q.Company_Id = e.Company_Id
                 and q.Filial_Id = e.Filial_Id
                 and q.Staff_Id = e.Staff_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id
               order by Nullif(e.Staff_Kind, Href_Pref.c_Staff_Kind_Primary) nulls last) -- firstly secondary jobs line closed
    loop
      Make_Dirty_Staff(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Staff_Id   => r.Staff_Id);
    
      Staff_Terminate(i_Company_Id     => r.Company_Id,
                      i_Filial_Id      => r.Filial_Id,
                      i_Staff_Id       => r.Staff_Id,
                      i_Journal_Id     => i_Journal.Journal_Id,
                      i_Page_Id        => r.Page_Id,
                      i_Dismissal_Date => r.Dismissal_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*, w.Change_Date, Pc.Currency_Id
                from Hpd_Journal_Pages q
                join Hpd_Wage_Changes w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                left join Hpd_Page_Currencies Pc
                  on q.Company_Id = Pc.Company_Id
                 and q.Filial_Id = Pc.Filial_Id
                 and q.Page_Id = Pc.Page_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      if r.Currency_Id is not null then
        Currency_Trans_Insert(i_Company_Id   => r.Company_Id,
                              i_Filial_Id    => r.Filial_Id,
                              i_Journal_Id   => r.Journal_Id,
                              i_Page_Id      => r.Page_Id,
                              i_Staff_Id     => r.Staff_Id,
                              i_Begin_Date   => r.Change_Date,
                              i_End_Date     => null,
                              i_Order_No     => i_Journal.Posted_Order_No,
                              i_Currency_Id  => r.Currency_Id,
                              i_Source_Table => Zt.Hpd_Hirings);
      end if;
    
      Oper_Type_Trans_Insert(i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_Journal_Id   => r.Journal_Id,
                             i_Page_Id      => r.Page_Id,
                             i_Staff_Id     => r.Staff_Id,
                             i_Begin_Date   => r.Change_Date,
                             i_End_Date     => null,
                             i_Order_No     => i_Journal.Posted_Order_No,
                             i_Source_Table => Zt.Hpd_Wage_Changes);
    
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*, w.Change_Date, w.Rank_Id
                from Hpd_Journal_Pages q
                join Hpd_Rank_Changes w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Rank_Trans_Insert(i_Company_Id   => r.Company_Id,
                        i_Filial_Id    => r.Filial_Id,
                        i_Journal_Id   => r.Journal_Id,
                        i_Page_Id      => r.Page_Id,
                        i_Staff_Id     => r.Staff_Id,
                        i_Begin_Date   => r.Change_Date,
                        i_End_Date     => null,
                        i_Order_No     => i_Journal.Posted_Order_No,
                        i_Rank_Id      => r.Rank_Id,
                        i_Source_Table => Zt.Hpd_Rank_Changes);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Change_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*, r.Page_Id, r.Staff_Id
                from Hpd_Vacation_Limit_Changes q
                join Hpd_Journal_Pages r
                  on r.Company_Id = q.Company_Id
                 and r.Filial_Id = q.Filial_Id
                 and r.Journal_Id = q.Journal_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Vacation_Limit_Trans_Insert(i_Company_Id   => r.Company_Id,
                                  i_Filial_Id    => r.Filial_Id,
                                  i_Journal_Id   => r.Journal_Id,
                                  i_Page_Id      => r.Page_Id,
                                  i_Staff_Id     => r.Staff_Id,
                                  i_Begin_Date   => r.Change_Date,
                                  i_End_Date     => null,
                                  i_Order_No     => i_Journal.Posted_Order_No,
                                  i_Days_Limit   => r.Days_Limit,
                                  i_Source_Table => Zt.Hpd_Vacation_Limit_Changes);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.Begin_Date,
                     q.End_Date,
                     r.Page_Id,
                     r.Staff_Id,
                     (select s.Schedule_Id
                        from Hpd_Page_Schedules s
                       where s.Company_Id = i_Journal.Company_Id
                         and s.Filial_Id = i_Journal.Filial_Id
                         and s.Page_Id = r.Page_Id) as Schedule_Id
                from Hpd_Schedule_Changes q
                join Hpd_Journal_Pages r
                  on r.Company_Id = i_Journal.Company_Id
                 and r.Filial_Id = i_Journal.Filial_Id
                 and r.Journal_Id = q.Journal_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Schedule_Trans_Insert(i_Company_Id   => i_Journal.Company_Id,
                            i_Filial_Id    => i_Journal.Filial_Id,
                            i_Journal_Id   => i_Journal.Journal_Id,
                            i_Page_Id      => r.Page_Id,
                            i_Staff_Id     => r.Staff_Id,
                            i_Begin_Date   => r.Begin_Date,
                            i_End_Date     => r.End_Date,
                            i_Order_No     => i_Journal.Posted_Order_No,
                            i_Schedule_Id  => r.Schedule_Id,
                            i_Source_Table => Zt.Hpd_Schedule_Changes);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timeoff_Post(i_Journal Hpd_Journals%rowtype) is
    v_Interval_Id number;
  begin
    for r in (select q.*
                from Hpd_Journal_Timeoffs q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      v_Interval_Id := Hpd_Next.Lock_Interval_Id;
    
      Timeoff_Lock_Interval_Insert(i_Company_Id      => r.Company_Id,
                                   i_Filial_Id       => r.Filial_Id,
                                   i_Journal_Type_Id => i_Journal.Journal_Type_Id,
                                   i_Timeoff_Id      => r.Timeoff_Id,
                                   i_Staff_Id        => r.Staff_Id,
                                   i_Begin_Date      => r.Begin_Date,
                                   i_End_Date        => r.End_Date);
    
      Insert_Timeoff_Days(i_Company_Id      => r.Company_Id,
                          i_Filial_Id       => r.Filial_Id,
                          i_Journal_Type_Id => i_Journal.Journal_Type_Id,
                          i_Timeoff_Id      => r.Timeoff_Id,
                          i_Staff_Id        => r.Staff_Id,
                          i_Begin_Date      => r.Begin_Date,
                          i_End_Date        => r.End_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Post(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select *
                from Hpd_Journal_Overtimes q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Htt_Core.Insert_Overtime_Facts(i_Company_Id  => r.Company_Id,
                                     i_Filial_Id   => r.Filial_Id,
                                     i_Overtime_Id => r.Overtime_Id);
    
      for w in (select Tl.Timebook_Id
                  from Hpr_Timesheet_Locks Tl
                 where Tl.Company_Id = r.Company_Id
                   and Tl.Filial_Id = r.Filial_Id
                   and Tl.Staff_Id = r.Staff_Id
                   and Tl.Timesheet_Date between r.Begin_Date and r.End_Date
                 group by Tl.Timebook_Id)
      loop
        Hpr_Core.Regen_Timebook_Facts(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Timebook_Id => w.Timebook_Id,
                                      i_Staff_Id    => r.Staff_Id);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Post(i_Journal Hpd_Journals%rowtype) is
    r_Timebook_Adjustment Hpd_Journal_Timebook_Adjustments%rowtype;
    v_Timesheet_Id        number;
  
    --------------------------------------------------
    Procedure Assert_No_Lock_Intervals
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Staff_Id     number,
      i_Timeoff_Date date
    ) is
      v_Interval_Kind varchar2(1);
      v_Interval_Id   number;
      v_Timeoff_Id    number;
    begin
      select Lc.Interval_Id, Lc.Kind
        into v_Interval_Id, v_Interval_Kind
        from Hpd_Lock_Intervals Lc
       where Lc.Company_Id = i_Company_Id
         and Lc.Filial_Id = i_Filial_Id
         and Lc.Staff_Id = i_Staff_Id
         and i_Timeoff_Date <= Lc.End_Date
         and i_Timeoff_Date >= Lc.Begin_Date
         and Rownum = 1;
    
      if v_Interval_Kind = Hpd_Pref.c_Lock_Interval_Kind_Timeoff then
        select p.Timeoff_Id
          into v_Timeoff_Id
          from Hpd_Timeoff_Intervals p
         where p.Company_Id = i_Company_Id
           and p.Filial_Id = i_Filial_Id
           and p.Interval_Id = v_Interval_Id;
      
        v_Interval_Kind := Get_Timeoff_Interval_Kind(i_Company_Id => i_Company_Id,
                                                     i_Filial_Id  => i_Filial_Id,
                                                     i_Timeoff_Id => v_Timeoff_Id);
      end if;
    
      Hpd_Error.Raise_075(i_Interval_Kind => v_Interval_Kind,
                          i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                  i_Filial_Id  => i_Filial_Id,
                                                                  i_Staff_Id   => i_Staff_Id),
                          i_Timeoff_Date  => i_Timeoff_Date);
    exception
      when No_Data_Found then
        null;
    end;
  
  begin
    r_Timebook_Adjustment := z_Hpd_Journal_Timebook_Adjustments.Lock_Load(i_Company_Id => i_Journal.Company_Id,
                                                                          i_Filial_Id  => i_Journal.Filial_Id,
                                                                          i_Journal_Id => i_Journal.Journal_Id);
  
    -- check
    for r in (select q.Staff_Id,
                     (select j.Journal_Number
                        from Hpd_Journals j
                       where j.Company_Id = i_Journal.Company_Id
                         and j.Filial_Id = i_Journal.Filial_Id
                         and j.Journal_Id = q.Journal_Id) as Journal_Number,
                     (select j.Journal_Date
                        from Hpd_Journals j
                       where j.Company_Id = i_Journal.Company_Id
                         and j.Filial_Id = i_Journal.Filial_Id
                         and j.Journal_Id = q.Journal_Id) as Journal_Date
                from Hpd_Lock_Adjustments q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and (q.Staff_Id, q.Kind) in
                     (select q.Staff_Id, Pa.Kind
                        from Hpd_Journal_Pages q
                        join Hpd_Page_Adjustments Pa
                          on Pa.Company_Id = i_Journal.Company_Id
                         and Pa.Filial_Id = i_Journal.Filial_Id
                         and Pa.Page_Id = q.Page_Id
                       where q.Company_Id = i_Journal.Company_Id
                         and q.Filial_Id = i_Journal.Filial_Id
                         and q.Journal_Id = i_Journal.Journal_Id)
                 and q.Adjustment_Date = r_Timebook_Adjustment.Adjustment_Date
                 and q.Journal_Id <> i_Journal.Journal_Id
                 and Rownum = 1)
    loop
      Hpd_Error.Raise_053(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Journal.Company_Id,
                                                                    i_Filial_Id  => i_Journal.Filial_Id,
                                                                    i_Staff_Id   => r.Staff_Id),
                          i_Adjustment_Date => r_Timebook_Adjustment.Adjustment_Date,
                          i_Journal_Number  => r.Journal_Number,
                          i_Journal_Date    => r.Journal_Date);
    end loop;
  
    for r in (select q.Staff_Id, q.Page_Id
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      v_Timesheet_Id := Htt_Util.Timesheet(i_Company_Id => i_Journal.Company_Id, --
                        i_Filial_Id => i_Journal.Filial_Id, --
                        i_Staff_Id => r.Staff_Id, --
                        i_Timesheet_Date => r_Timebook_Adjustment.Adjustment_Date).Timesheet_Id;
    
      if v_Timesheet_Id is null then
        Hpd_Error.Raise_054(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Journal.Company_Id,
                                                                      i_Filial_Id  => i_Journal.Filial_Id,
                                                                      i_Staff_Id   => r.Staff_Id),
                            i_Adjustment_Date => r_Timebook_Adjustment.Adjustment_Date);
      end if;
    
      Assert_No_Lock_Intervals(i_Company_Id   => i_Journal.Company_Id,
                               i_Filial_Id    => i_Journal.Filial_Id,
                               i_Staff_Id     => r.Staff_Id,
                               i_Timeoff_Date => r_Timebook_Adjustment.Adjustment_Date);
    
      for Adj in (select a.Kind
                    from Hpd_Page_Adjustments a
                   where a.Company_Id = i_Journal.Company_Id
                     and a.Filial_Id = i_Journal.Filial_Id
                     and a.Page_Id = r.Page_Id)
      loop
        z_Hpd_Lock_Adjustments.Insert_One(i_Company_Id      => i_Journal.Company_Id,
                                          i_Filial_Id       => i_Journal.Filial_Id,
                                          i_Staff_Id        => r.Staff_Id,
                                          i_Adjustment_Date => r_Timebook_Adjustment.Adjustment_Date,
                                          i_Kind            => Adj.Kind,
                                          i_Journal_Id      => i_Journal.Journal_Id,
                                          i_Page_Id         => r.Page_Id);
      end loop;
    
      Htt_Core.Save_Adjustment_Fact(i_Company_Id     => i_Journal.Company_Id,
                                    i_Filial_Id      => i_Journal.Filial_Id,
                                    i_Staff_Id       => r.Staff_Id,
                                    i_Timesheet_Id   => v_Timesheet_Id,
                                    i_Timesheet_Date => r_Timebook_Adjustment.Adjustment_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Fte_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
    v_Current_Date date := Trunc(sysdate);
    v_Fte_Limit    Href_Pref.Fte_Limit_Rt := Href_Util.Load_Fte_Limit(i_Company_Id);
  begin
    if v_Fte_Limit.Fte_Limit_Setting = 'N' then
      return;
    end if;
  
    for r in (select e.Employee_Name
                from (select (select sum(St.Fte)
                                from Href_Staffs St
                               where St.Company_Id = w.Company_Id
                                 and St.Employee_Id = w.Employee_Id
                                 and St.State = 'A'
                                 and St.Hiring_Date <= v_Current_Date
                                 and (St.Dismissal_Date is null or --
                                     St.Dismissal_Date >= v_Current_Date)
                                 and exists (select 1
                                        from Md_Filials f
                                       where f.Company_Id = St.Company_Id
                                         and f.Filial_Id = St.Filial_Id
                                         and f.State = 'A')) Total_Fte,
                             (select Np.Name
                                from Mr_Natural_Persons Np
                               where Np.Company_Id = w.Company_Id
                                 and Np.Person_Id = w.Employee_Id) Employee_Name
                        from Hpd_Journal_Pages q
                        join Href_Staffs w
                          on w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Staff_Id = q.Staff_Id
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Journal_Id = i_Journal_Id) e
               where v_Fte_Limit.Fte_Limit < e.Total_Fte)
    loop
      Hpd_Error.Raise_078(r.Employee_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  ) is
    r_Journal               Hpd_Journals%rowtype;
    v_Sign_Document_Status  varchar2(1);
    v_Evaluate_Trash_Tracks boolean := false;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Journal_Id => i_Journal_Id);
  
    if r_Journal.Posted = 'Y' and not Hpd_Pref.g_Migration_Active then
      Hpd_Error.Raise_022(r_Journal.Journal_Number);
    end if;
  
    if not Fazo.Equal(r_Journal.Source_Table, i_Source_Table) or
       not Fazo.Equal(r_Journal.Source_Id, i_Source_Id) then
      Hpd_Error.Raise_069(i_Jounal_Id         => r_Journal.Journal_Id,
                          i_Journal_Number    => r_Journal.Journal_Number,
                          i_Journal_Type_Name => z_Hpd_Journal_Types.Load(i_Company_Id => i_Company_Id, i_Journal_Type_Id => r_Journal.Journal_Type_Id).Name,
                          i_Source_Table      => r_Journal.Source_Table,
                          i_Source_Id         => r_Journal.Source_Id);
    end if;
  
    -- Sign Document Check  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => i_Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null and v_Sign_Document_Status <> Mdf_Pref.c_Ds_Approved then
      Hpd_Error.Raise_084(i_Document_Status => Mdf_Pref.t_Document_Status(v_Sign_Document_Status),
                          i_Journal_Number  => r_Journal.Journal_Number);
    end if;
  
    r_Journal.Posted := 'Y';
  
    if r_Journal.Posted_Order_No is null then
      r_Journal.Posted_Order_No := Md_Core.Gen_Number(i_Company_Id => r_Journal.Company_Id,
                                                      i_Filial_Id  => r_Journal.Filial_Id,
                                                      i_Table      => Zt.Hpd_Journals,
                                                      i_Column     => z.Posted_Order_No);
    end if;
  
    z_Hpd_Journals.Save_Row(r_Journal);
  
    Fill_Journal_Staff_Cache(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
  
    if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hiring_Journal_Post(r_Journal);
    
      v_Evaluate_Trash_Tracks := true;
    elsif Hpd_Util.Is_Contractor_Journal(i_Company_Id      => r_Journal.Company_Id,
                                         i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hiring_Journal_Post(r_Journal);
    
      Hiring_Cv_Contract_Post(r_Journal);
    
      v_Evaluate_Trash_Tracks := true;
    elsif Hpd_Util.Is_Transfer_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Transfer_Journal_Post(r_Journal);
    elsif Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => r_Journal.Company_Id,
                                        i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Dismissal_Journal_Post(r_Journal);
    
      v_Evaluate_Trash_Tracks := true;
    elsif Hpd_Util.Is_Wage_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Wage_Change_Journal_Post(r_Journal);
    elsif Hpd_Util.Is_Rank_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Rank_Change_Journal_Post(r_Journal);
    elsif Hpd_Util.Is_Limit_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                           i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Vacation_Limit_Change_Journal_Post(r_Journal);
    elsif Hpd_Util.Is_Schedule_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                              i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Schedule_Change_Journal_Post(r_Journal);
    elsif Hpd_Util.Is_Sick_Leave_Journal(i_Company_Id      => r_Journal.Company_Id,
                                         i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Post(r_Journal);
    elsif Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => r_Journal.Company_Id,
                                            i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Post(r_Journal);
    elsif Hpd_Util.Is_Vacation_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Post(r_Journal);
    elsif Hpd_Util.Is_Overtime_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Overtime_Post(r_Journal);
    elsif Hpd_Util.Is_Timebook_Adjustment_Journal(i_Company_Id      => r_Journal.Company_Id,
                                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timebook_Adjustment_Post(r_Journal);
    else
      b.Raise_Not_Implemented;
    end if;
  
    if not Hpd_Pref.g_Migration_Active then
      Dirty_Staffs_Evaluate(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      Agreements_Evaluate(i_Company_Id);
    
      if v_Evaluate_Trash_Tracks then
        Evaluate_Trash_Tracks(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Journal_Id => i_Journal_Id);
      end if;
    
      Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      Evaluate_Journal_Page_Cache(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id);
    
      if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                    i_Journal_Type_Id => r_Journal.Journal_Type_Id) or
         Hpd_Util.Is_Transfer_Journal(i_Company_Id      => r_Journal.Company_Id,
                                      i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
        Check_Fte_Limit(i_Company_Id => r_Journal.Company_Id,
                        i_Filial_Id  => r_Journal.Filial_Id,
                        i_Journal_Id => r_Journal.Journal_Id);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
                left join Href_Staffs e
                  on q.Company_Id = e.Company_Id
                 and q.Filial_Id = e.Filial_Id
                 and q.Staff_Id = e.Staff_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id
               order by Nullif(e.Staff_Kind, Href_Pref.c_Staff_Kind_Secondary) nulls first) -- firstly secondary jobs line unposted
    loop
      Make_Dirty_Staff(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Staff_Id   => r.Staff_Id);
    
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    
      Staff_Restore(i_Company_Id => r.Company_Id,
                    i_Filial_Id  => r.Filial_Id,
                    i_Page_Id    => r.Page_Id,
                    i_Staff_Id   => r.Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Unpost
  (
    i_Journal Hpd_Journals%rowtype,
    i_Repost  boolean
  ) is
  begin
    for r in (select q.*, --
                     Ct.Contract_Id,
                     w.Dismissal_Date,
                     Ct.End_Date,
                     Ct.Early_Closed_Date
                from Hpd_Journal_Pages q
                join Hpd_Hirings w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Page_Id = w.Page_Id
                join Hpd_Cv_Contracts Ct
                  on Ct.Company_Id = w.Company_Id
                 and Ct.Filial_Id = w.Filial_Id
                 and Ct.Page_Id = w.Page_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      continue when i_Repost and r.Dismissal_Date <> Nvl(r.Early_Closed_Date, r.End_Date);
    
      Cv_Contract_Unpost(i_Company_Id  => r.Company_Id,
                         i_Filial_Id   => r.Filial_Id,
                         i_Contract_Id => r.Contract_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
                left join Href_Staffs w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Staff_Id = w.Staff_Id
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id
               order by Nullif(w.Staff_Kind, Href_Pref.c_Staff_Kind_Primary) nulls first) -- firstly primary jobs line reopen
    loop
      Make_Dirty_Staff(i_Company_Id => r.Company_Id,
                       i_Filial_Id  => r.Filial_Id,
                       i_Staff_Id   => r.Staff_Id);
    
      Staff_Restore(i_Company_Id => r.Company_Id,
                    i_Filial_Id  => r.Filial_Id,
                    i_Page_Id    => r.Page_Id,
                    i_Staff_Id   => r.Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Change_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Trans_Clear(i_Company_Id => r.Company_Id, --
                  i_Filial_Id  => r.Filial_Id,
                  i_Page_Id    => r.Page_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timeoff_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select q.*,
                     (select w.Interval_Id
                        from Hpd_Timeoff_Intervals w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Timeoff_Id = q.Timeoff_Id) as Interval_Id
                from Hpd_Journal_Timeoffs q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      z_Hpd_Timeoff_Intervals.Delete_One(i_Company_Id => r.Company_Id,
                                         i_Filial_Id  => r.Filial_Id,
                                         i_Timeoff_Id => r.Timeoff_Id);
    
      Lock_Interval_Delete(i_Company_Id  => r.Company_Id,
                           i_Filial_Id   => r.Filial_Id,
                           i_Interval_Id => r.Interval_Id,
                           i_Timeoff_Id  => r.Timeoff_Id);
    
      Remove_Timeoff_Days(i_Company_Id      => r.Company_Id,
                          i_Filial_Id       => r.Filial_Id,
                          i_Journal_Type_Id => i_Journal.Journal_Type_Id,
                          i_Timeoff_Id      => r.Timeoff_Id,
                          i_Staff_Id        => r.Staff_Id,
                          i_Begin_Date      => r.Begin_Date,
                          i_End_Date        => r.End_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Unpost(i_Journal Hpd_Journals%rowtype) is
  begin
    for r in (select *
                from Hpd_Journal_Overtimes q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      Htt_Core.Remove_Overtime_Facts(i_Company_Id  => r.Company_Id,
                                     i_Filial_Id   => r.Filial_Id,
                                     i_Overtime_Id => r.Overtime_Id);
    
      for w in (select Tl.Timebook_Id
                  from Hpr_Timesheet_Locks Tl
                 where Tl.Company_Id = r.Company_Id
                   and Tl.Filial_Id = r.Filial_Id
                   and Tl.Staff_Id = r.Staff_Id
                   and Tl.Timesheet_Date between r.Begin_Date and r.End_Date
                 group by Tl.Timebook_Id)
      loop
        Hpr_Core.Regen_Timebook_Facts(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Timebook_Id => w.Timebook_Id,
                                      i_Staff_Id    => r.Staff_Id);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Unpost(i_Journal Hpd_Journals%rowtype) is
    r_Timebook_Adjustment Hpd_Journal_Timebook_Adjustments%rowtype;
    v_Turnout_Adjustment  number;
    v_Overtime_Adjustment number;
    v_Lack_Tk_Id          number;
    v_Timesheet_Id        number;
  begin
    r_Timebook_Adjustment := z_Hpd_Journal_Timebook_Adjustments.Lock_Load(i_Company_Id => i_Journal.Company_Id,
                                                                          i_Filial_Id  => i_Journal.Filial_Id,
                                                                          i_Journal_Id => i_Journal.Journal_Id);
  
    v_Turnout_Adjustment  := Htt_Util.Time_Kind_Id(i_Company_Id => i_Journal.Company_Id,
                                                   i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout_Adjustment);
    v_Overtime_Adjustment := Htt_Util.Time_Kind_Id(i_Company_Id => i_Journal.Company_Id,
                                                   i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime_Adjustment);
    v_Lack_Tk_Id          := Htt_Util.Time_Kind_Id(i_Company_Id => i_Journal.Company_Id,
                                                   i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    for r in (select q.Staff_Id
                from Hpd_Journal_Pages q
               where q.Company_Id = i_Journal.Company_Id
                 and q.Filial_Id = i_Journal.Filial_Id
                 and q.Journal_Id = i_Journal.Journal_Id)
    loop
      v_Timesheet_Id := Htt_Util.Timesheet(i_Company_Id => i_Journal.Company_Id, --
                        i_Filial_Id => i_Journal.Filial_Id, --
                        i_Staff_Id => r.Staff_Id, --
                        i_Timesheet_Date => r_Timebook_Adjustment.Adjustment_Date).Timesheet_Id;
    
      continue when v_Timesheet_Id is null;
    
      z_Htt_Timesheet_Facts.Delete_One(i_Company_Id   => i_Journal.Company_Id,
                                       i_Filial_Id    => i_Journal.Filial_Id,
                                       i_Timesheet_Id => v_Timesheet_Id,
                                       i_Time_Kind_Id => v_Overtime_Adjustment);
    
      z_Htt_Timesheet_Facts.Delete_One(i_Company_Id   => i_Journal.Company_Id,
                                       i_Filial_Id    => i_Journal.Filial_Id,
                                       i_Timesheet_Id => v_Timesheet_Id,
                                       i_Time_Kind_Id => v_Turnout_Adjustment);
    end loop;
  
    for r in (select Df.*,
                     Ts.Timesheet_Id,
                     Nvl((select 'Y'
                           from Htt_Timesheet_Locks Tl
                          where Tl.Company_Id = La.Company_Id
                            and Tl.Filial_Id = La.Filial_Id
                            and Tl.Staff_Id = La.Staff_Id
                            and Tl.Timesheet_Date = La.Adjustment_Date),
                         'N') Timesheet_Locked
                from Hpd_Lock_Adjustments La
                join Hpd_Adjustment_Deleted_Facts Df
                  on Df.Company_Id = La.Company_Id
                 and Df.Filial_Id = La.Filial_Id
                 and Df.Staff_Id = La.Staff_Id
                 and Df.Adjustment_Date = La.Adjustment_Date
                join Htt_Timesheets Ts
                  on Ts.Company_Id = La.Company_Id
                 and Ts.Filial_Id = La.Filial_Id
                 and Ts.Staff_Id = La.Staff_Id
                 and Ts.Timesheet_Date = La.Adjustment_Date
               where La.Company_Id = i_Journal.Company_Id
                 and La.Filial_Id = i_Journal.Filial_Id
                 and La.Journal_Id = i_Journal.Journal_Id)
    loop
      if r.Timesheet_Locked = 'Y' then
        z_Htt_Timesheet_Facts.Update_One(i_Company_Id   => i_Journal.Company_Id,
                                         i_Filial_Id    => i_Journal.Filial_Id,
                                         i_Timesheet_Id => r.Timesheet_Id,
                                         i_Time_Kind_Id => v_Lack_Tk_Id,
                                         i_Fact_Value   => Option_Number(r.Fact_Value));
      
        z_Htt_Timesheet_Locks.Update_One(i_Company_Id     => i_Journal.Company_Id,
                                         i_Filial_Id      => i_Journal.Filial_Id,
                                         i_Staff_Id       => r.Staff_Id,
                                         i_Timesheet_Date => r.Adjustment_Date,
                                         i_Facts_Changed  => Option_Varchar2('Y'));
      else
        Htt_Core.Make_Dirty_Timesheet(i_Company_Id   => i_Journal.Company_Id,
                                      i_Filial_Id    => i_Journal.Filial_Id,
                                      i_Timesheet_Id => r.Timesheet_Id);
      end if;
    end loop;
  
    delete from Hpd_Lock_Adjustments q
     where q.Company_Id = i_Journal.Company_Id
       and q.Filial_Id = i_Journal.Filial_Id
       and q.Journal_Id = i_Journal.Journal_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null,
    i_Repost       boolean := false
  ) is
    r_Journal               Hpd_Journals%rowtype;
    v_Document_Status       varchar2(1);
    v_Evaluate_Trash_Tracks boolean := false;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Journal_Id => i_Journal_Id);
  
    if r_Journal.Posted = 'N' then
      Hpd_Error.Raise_023(r_Journal.Journal_Number);
    end if;
  
    if not Fazo.Equal(r_Journal.Source_Table, i_Source_Table) or
       not Fazo.Equal(r_Journal.Source_Id, i_Source_Id) then
      Hpd_Error.Raise_070(i_Jounal_Id         => r_Journal.Journal_Id,
                          i_Journal_Number    => r_Journal.Journal_Number,
                          i_Journal_Type_Name => z_Hpd_Journal_Types.Load(i_Company_Id => i_Company_Id, i_Journal_Type_Id => r_Journal.Journal_Type_Id).Name,
                          i_Source_Table      => r_Journal.Source_Table,
                          i_Source_Id         => r_Journal.Source_Id);
    end if;
  
    Fill_Journal_Staff_Cache(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
  
    if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hiring_Journal_Unpost(r_Journal);
    
      v_Evaluate_Trash_Tracks := true;
    elsif Hpd_Util.Is_Contractor_Journal(i_Company_Id      => r_Journal.Company_Id,
                                         i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hiring_Journal_Unpost(r_Journal);
    
      Hiring_Cv_Contract_Unpost(r_Journal, i_Repost);
    
      v_Evaluate_Trash_Tracks := true;
    elsif Hpd_Util.Is_Transfer_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Transfer_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => r_Journal.Company_Id,
                                        i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Dismissal_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Wage_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Wage_Change_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Rank_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Rank_Change_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Limit_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                           i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Vacation_Limit_Change_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Schedule_Change_Journal(i_Company_Id      => r_Journal.Company_Id,
                                              i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Schedule_Change_Journal_Unpost(r_Journal);
    elsif Hpd_Util.Is_Sick_Leave_Journal(i_Company_Id      => r_Journal.Company_Id,
                                         i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Unpost(r_Journal);
    elsif Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => r_Journal.Company_Id,
                                            i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Unpost(r_Journal);
    elsif Hpd_Util.Is_Vacation_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timeoff_Unpost(r_Journal);
    elsif Hpd_Util.Is_Overtime_Journal(i_Company_Id      => r_Journal.Company_Id,
                                       i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Overtime_Unpost(r_Journal);
    elsif Hpd_Util.Is_Timebook_Adjustment_Journal(i_Company_Id      => r_Journal.Company_Id,
                                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Timebook_Adjustment_Unpost(r_Journal);
    else
      b.Raise_Not_Implemented;
    end if;
  
    r_Journal.Posted := 'N';
  
    z_Hpd_Journals.Save_Row(r_Journal);
  
    -- Sign Document To Draft 
    v_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                            i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Document_Status is not null then
      Mdf_Api.Document_Draft(i_Company_Id  => r_Journal.Company_Id,
                             i_Document_Id => r_Journal.Sign_Document_Id);
    end if;
  
    if not i_Repost then
      Dirty_Staffs_Evaluate(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      Agreements_Evaluate(i_Company_Id);
    
      if v_Evaluate_Trash_Tracks then
        Evaluate_Trash_Tracks(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Journal_Id => i_Journal_Id);
      end if;
    
      Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      Evaluate_Journal_Page_Cache(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Used_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Accrual    boolean := true
  ) is
    v_Part       Hpd_Pref.Transaction_Part_Rt;
    v_Parts      Hpd_Pref.Transaction_Part_Nt;
    v_Days_Count number;
    v_Coef       number := 1;
  begin
    if not i_Accrual then
      v_Coef := -1;
    end if;
  
    v_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id        => i_Company_Id,
                                                     i_Filial_Id         => i_Filial_Id,
                                                     i_Staff_Id          => i_Staff_Id,
                                                     i_Begin_Date        => i_Begin_Date,
                                                     i_End_Date          => i_End_Date,
                                                     i_Trans_Types       => Array_Varchar2(Hpd_Pref.c_Transaction_Type_Vacation_Limit),
                                                     i_Partition_By_Year => true);
  
    for i in 1 .. v_Parts.Count
    loop
      v_Part := v_Parts(i);
    
      v_Days_Count := Calc_Vacation_Days(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Staff_Id   => i_Staff_Id,
                                         i_Begin_Date => v_Part.Part_Begin,
                                         i_End_Date   => v_Part.Part_End);
    
      Vacation_Turnover_Evaluate(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Begin_Date => v_Part.Part_Begin,
                                 i_End_Date   => Htt_Util.Year_Last_Day(v_Part.Part_Begin),
                                 i_Days_Kind  => Hpd_Pref.c_Vacation_Turnover_Used_Days,
                                 i_Days_Count => v_Coef * v_Days_Count);
    end loop;
  
    Assert_Vacation_Turnover(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Staff_Id   => i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Spend_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    Evaluate_Used_Vacation_Days(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Begin_Date => i_Begin_Date,
                                i_End_Date   => i_End_Date,
                                i_Accrual    => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Free_Vacation_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    Evaluate_Used_Vacation_Days(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Begin_Date => i_Begin_Date,
                                i_End_Date   => i_End_Date,
                                i_Accrual    => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Interval_Insert
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date,
    i_Kind            varchar2,
    i_Assertable      boolean := true,
    i_Journal_Type_Id number := null,
    o_Interval_Id     out number
  ) is
    v_Intersect_Begin date;
    v_Intersect_End   date;
    v_Interval_Kind   varchar2(1) := i_Kind;
  
    --------------------------------------------------
    Function Get_Timeoff_Interval_Kind return varchar2 is
    begin
      if Hpd_Util.Is_Sick_Leave_Journal(i_Company_Id      => i_Company_Id,
                                        i_Journal_Type_Id => i_Journal_Type_Id) then
        return Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Sick_Leave;
      elsif Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => i_Company_Id,
                                              i_Journal_Type_Id => i_Journal_Type_Id) then
        return Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Business_Trip;
      elsif Hpd_Util.Is_Vacation_Journal(i_Company_Id      => i_Company_Id,
                                         i_Journal_Type_Id => i_Journal_Type_Id) then
        return Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Vacation;
      else
        b.Raise_Not_Implemented;
      end if;
    
      return null;
    end;
  begin
    if i_Assertable then
      -- assert locked interval intersection
      begin
        select q.Begin_Date, q.End_Date
          into v_Intersect_Begin, v_Intersect_End
          from Hpd_Lock_Intervals q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Staff_Id = i_Staff_Id
           and q.Kind = i_Kind
           and Greatest(q.Begin_Date, i_Begin_Date) <= Least(q.End_Date, i_End_Date)
           and Rownum = 1;
      
        if v_Interval_Kind = Hpd_Pref.c_Lock_Interval_Kind_Timeoff then
          v_Interval_Kind := Get_Timeoff_Interval_Kind;
        end if;
      
        Hpd_Error.Raise_024(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                      i_Filial_Id  => i_Filial_Id,
                                                                      i_Staff_Id   => i_Staff_Id),
                            i_Interval_Begin  => i_Begin_Date,
                            i_Interval_End    => i_End_Date,
                            i_Intersect_Begin => v_Intersect_Begin,
                            i_Intersect_End   => v_Intersect_End,
                            i_Interval_Kind   => v_Interval_Kind);
      exception
        when No_Data_Found then
          null;
      end;
    end if;
  
    o_Interval_Id := Hpd_Next.Lock_Interval_Id;
  
    z_Hpd_Lock_Intervals.Insert_One(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Interval_Id => o_Interval_Id,
                                    i_Staff_Id    => i_Staff_Id,
                                    i_Begin_Date  => i_Begin_Date,
                                    i_End_Date    => i_End_Date,
                                    i_Kind        => i_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Lock_Interval_Insert
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    v_Trans_Id                   number;
    v_Parts                      Hpd_Pref.Transaction_Part_Nt;
    v_Oper_Type_Ids              Array_Number;
    v_Oper_Group_Id              number;
    v_No_Deduction_Oper_Group_Id number;
    v_Deduction_Oper_Group_Id    number;
    v_Overtime_Oper_Group_Id     number;
    o_Interval_Id                number;
  begin
    Lock_Interval_Insert(i_Company_Id  => i_Company_Id,
                         i_Filial_Id   => i_Filial_Id,
                         i_Staff_Id    => i_Staff_Id,
                         i_Begin_Date  => i_Begin_Date,
                         i_End_Date    => i_End_Date,
                         i_Kind        => Hpd_Pref.c_Lock_Interval_Kind_Timebook,
                         o_Interval_Id => o_Interval_Id);
  
    z_Hpr_Timebook_Intervals.Insert_One(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Timebook_Id => i_Timebook_Id,
                                        i_Staff_Id    => i_Staff_Id,
                                        i_Interval_Id => o_Interval_Id);
  
    v_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_No_Deduction_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                           i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage_No_Deduction);
  
    v_Deduction_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                        i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  
    v_Overtime_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                       i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  
    v_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id      => i_Company_Id,
                                                     i_Filial_Id       => i_Filial_Id,
                                                     i_Staff_Id        => i_Staff_Id,
                                                     i_Begin_Date      => i_Begin_Date,
                                                     i_End_Date        => i_End_Date,
                                                     i_Trans_Types     => Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                                                                         Hpd_Pref.c_Transaction_Type_Operation,
                                                                                         Hpd_Pref.c_Transaction_Type_Schedule,
                                                                                         Hpd_Pref.c_Transaction_Type_Currency),
                                                     i_With_Wage_Scale => true);
  
    for i in 1 .. v_Parts.Count
    loop
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Staff_Id   => i_Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => v_Parts(i).Part_Begin);
    
      select t.Oper_Type_Id
        bulk collect
        into v_Oper_Type_Ids
        from Hpd_Trans_Oper_Types t
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Trans_Id = v_Trans_Id
         and exists (select 1
                from Hpr_Oper_Types s
               where s.Company_Id = t.Company_Id
                 and s.Oper_Type_Id = t.Oper_Type_Id
                 and s.Oper_Group_Id in (v_Oper_Group_Id,
                                         v_No_Deduction_Oper_Group_Id,
                                         v_Deduction_Oper_Group_Id,
                                         v_Overtime_Oper_Group_Id));
    
      for j in 1 .. v_Oper_Type_Ids.Count
      loop
        -- this situation must be taken into account
        Hpr_Core.Charge_Insert(i_Company_Id   => i_Company_Id,
                               i_Filial_Id    => i_Filial_Id,
                               i_Interval_Id  => o_Interval_Id,
                               i_Staff_Id     => i_Staff_Id,
                               i_Oper_Type_Id => v_Oper_Type_Ids(j),
                               i_Begin_Date   => v_Parts(i).Part_Begin,
                               i_End_Date     => v_Parts(i).Part_End);
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timeoff_Lock_Interval_Insert
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  ) is
    v_Parts        Hpd_Pref.Transaction_Part_Nt := Hpd_Pref.Transaction_Part_Nt();
    v_Trans_Types  Array_Varchar2;
    v_Oper_Type_Id number;
    o_Interval_Id  number;
    r_Staff        Href_Staffs%rowtype;
  begin
    Lock_Interval_Insert(i_Company_Id      => i_Company_Id,
                         i_Filial_Id       => i_Filial_Id,
                         i_Staff_Id        => i_Staff_Id,
                         i_Begin_Date      => i_Begin_Date,
                         i_End_Date        => i_End_Date,
                         i_Kind            => Hpd_Pref.c_Lock_Interval_Kind_Timeoff,
                         i_Journal_Type_Id => i_Journal_Type_Id,
                         o_Interval_Id     => o_Interval_Id);
  
    z_Hpd_Timeoff_Intervals.Insert_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Timeoff_Id  => i_Timeoff_Id,
                                       i_Interval_Id => o_Interval_Id);
  
    if Hpd_Util.Is_Sick_Leave_Journal(i_Company_Id      => i_Company_Id,
                                      i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Sick_Leave);
      v_Trans_Types  := Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                       Hpd_Pref.c_Transaction_Type_Operation,
                                       Hpd_Pref.c_Transaction_Type_Schedule,
                                       Hpd_Pref.c_Transaction_Type_Currency);
    elsif Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => i_Company_Id,
                                            i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Business_Trip);
      v_Trans_Types  := Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                       Hpd_Pref.c_Transaction_Type_Operation,
                                       Hpd_Pref.c_Transaction_Type_Schedule,
                                       Hpd_Pref.c_Transaction_Type_Currency);
    elsif Hpd_Util.Is_Vacation_Journal(i_Company_Id      => i_Company_Id,
                                       i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Vacation);
      v_Trans_Types  := Array_Varchar2();
    else
      b.Raise_Not_Implemented;
    end if;
  
    if v_Trans_Types.Count > 0 then
      v_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id      => i_Company_Id,
                                                       i_Filial_Id       => i_Filial_Id,
                                                       i_Staff_Id        => i_Staff_Id,
                                                       i_Begin_Date      => i_Begin_Date,
                                                       i_End_Date        => i_End_Date,
                                                       i_Trans_Types     => v_Trans_Types,
                                                       i_With_Wage_Scale => true);
    else
      r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Staff_Id   => i_Staff_Id);
    
      v_Parts.Extend();
      v_Parts(v_Parts.Count) := Hpd_Pref.Transaction_Part_Rt(Part_Begin => Greatest(i_Begin_Date,
                                                                                    r_Staff.Hiring_Date),
                                                             Part_End   => Least(i_End_Date,
                                                                                 Nvl(r_Staff.Dismissal_Date,
                                                                                     i_End_Date)));
    end if;
  
    for i in 1 .. v_Parts.Count
    loop
      -- this situation must be taken into account
      Hpr_Core.Charge_Insert(i_Company_Id   => i_Company_Id,
                             i_Filial_Id    => i_Filial_Id,
                             i_Interval_Id  => o_Interval_Id,
                             i_Staff_Id     => i_Staff_Id,
                             i_Oper_Type_Id => v_Oper_Type_Id,
                             i_Begin_Date   => v_Parts(i).Part_Begin,
                             i_End_Date     => v_Parts(i).Part_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Perf_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date
  ) is
    v_Trans_Id              number;
    r_Staff_Plan            Hper_Staff_Plans%rowtype;
    v_Oper_Type_Ids         Array_Number;
    v_Perf_Oper_Group_Id    number;
    v_Penalty_Oper_Group_Id number;
    v_Begin_Date            date;
    v_End_Date              date;
    v_Trans_Date            date;
    o_Interval_Id           number;
    r_Staff                 Href_Staffs%rowtype;
  begin
    Lock_Interval_Insert(i_Company_Id  => i_Company_Id,
                         i_Filial_Id   => i_Filial_Id,
                         i_Staff_Id    => i_Staff_Id,
                         i_Begin_Date  => i_Begin_Date,
                         i_End_Date    => i_End_Date,
                         i_Kind        => Hpd_Pref.c_Lock_Interval_Kind_Performance,
                         i_Assertable  => false,
                         o_Interval_Id => o_Interval_Id);
  
    z_Hper_Staff_Plan_Intervals.Insert_One(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id,
                                           i_Interval_Id   => o_Interval_Id);
  
    v_Perf_Oper_Group_Id    := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf);
    v_Penalty_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    v_Begin_Date := Greatest(i_Begin_Date, r_Staff.Hiring_Date);
    v_End_Date   := Least(i_End_Date, Nvl(r_Staff.Dismissal_Date, i_End_Date));
  
    r_Staff_Plan := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                                 i_Filial_Id     => i_Filial_Id,
                                                 i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    select max(q.Begin_Date)
      into v_Trans_Date
      from Hpd_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id = r_Staff_Plan.Journal_Page_Id;
  
    v_Trans_Date := Greatest(v_Trans_Date, v_Begin_Date);
  
    v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Staff_Id   => i_Staff_Id,
                                              i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                              i_Period     => v_Trans_Date);
  
    select t.Oper_Type_Id
      bulk collect
      into v_Oper_Type_Ids
      from Hpd_Trans_Oper_Types t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Trans_Id = v_Trans_Id
       and exists
     (select 1
              from Hpr_Oper_Types s
             where s.Company_Id = t.Company_Id
               and s.Oper_Type_Id = t.Oper_Type_Id
               and s.Oper_Group_Id in (v_Perf_Oper_Group_Id, v_Penalty_Oper_Group_Id));
  
    for j in 1 .. v_Oper_Type_Ids.Count
    loop
      -- this situation must be taken into account
      Hpr_Core.Charge_Insert(i_Company_Id   => i_Company_Id,
                             i_Filial_Id    => i_Filial_Id,
                             i_Interval_Id  => o_Interval_Id,
                             i_Staff_Id     => i_Staff_Id,
                             i_Oper_Type_Id => v_Oper_Type_Ids(j),
                             i_Begin_Date   => v_Begin_Date,
                             i_End_Date     => v_End_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Operation_Id  number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Interval_Kind varchar2
  ) is
    v_Interval_Id number;
  begin
    Lock_Interval_Insert(i_Company_Id  => i_Company_Id,
                         i_Filial_Id   => i_Filial_Id,
                         i_Staff_Id    => i_Staff_Id,
                         i_Begin_Date  => i_Begin_Date,
                         i_End_Date    => i_End_Date,
                         i_Kind        => i_Interval_Kind,
                         o_Interval_Id => v_Interval_Id);
  
    z_Hpr_Sales_Bonus_Payment_Intervals.Insert_One(i_Company_Id   => i_Company_Id,
                                                   i_Filial_Id    => i_Filial_Id,
                                                   i_Operation_Id => i_Operation_Id,
                                                   i_Interval_Id  => v_Interval_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Interval_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Interval_Id number,
    i_Timeoff_Id  number := null
  ) is
    r_Interval   Hpd_Lock_Intervals%rowtype;
    v_Begin_Date date;
    v_End_Date   date;
  begin
    select q.Begin_Date, q.End_Date
      into v_Begin_Date, v_End_Date
      from Hpr_Charges q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Interval_Id = i_Interval_Id
       and q.Status <> Hpr_Pref.c_Charge_Status_New
       and Rownum = 1;
  
    r_Interval := z_Hpd_Lock_Intervals.Lock_Load(i_Company_Id  => i_Company_Id,
                                                 i_Filial_Id   => i_Filial_Id,
                                                 i_Interval_Id => i_Interval_Id);
  
    if r_Interval.Kind = Hpd_Pref.c_Lock_Interval_Kind_Timeoff then
      r_Interval.Kind := Get_Timeoff_Interval_Kind(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Timeoff_Id => i_Timeoff_Id);
    end if;
  
    Hpd_Error.Raise_025(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Interval.Company_Id,
                                                                i_Filial_Id  => r_Interval.Filial_Id,
                                                                i_Staff_Id   => r_Interval.Staff_Id),
                        i_Interval_Kind => r_Interval.Kind,
                        i_Charge_Begin  => v_Begin_Date,
                        i_Charge_End    => v_End_Date);
  exception
    when No_Data_Found then
      z_Hpd_Lock_Intervals.Delete_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Interval_Id => i_Interval_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- facts generation triggered by timeoffs
  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Timeoff_Facts
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Timeoff_Id     number,
    i_Staff_Id       number,
    i_Begin_Date     date,
    i_End_Date       date,
    i_Remove_Timeoff boolean := false
  ) is
  begin
    Htt_Core.Gen_Timeoff_Facts(i_Company_Id     => i_Company_Id,
                               i_Filial_Id      => i_Filial_Id,
                               i_Timeoff_Id     => i_Timeoff_Id,
                               i_Remove_Timeoff => i_Remove_Timeoff);
  
    for r in (select Tl.Timebook_Id
                from Hpr_Timesheet_Locks Tl
               where Tl.Company_Id = i_Company_Id
                 and Tl.Filial_Id = i_Filial_Id
                 and Tl.Staff_Id = i_Staff_Id
                 and Tl.Timesheet_Date between i_Begin_Date and i_End_Date
               group by Tl.Timebook_Id)
    loop
      -- careful with hpd_core <=> hpr_core recursion
      Hpr_Core.Regen_Timebook_Facts(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Timebook_Id => r.Timebook_Id,
                                    i_Staff_Id    => i_Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Timeoff_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  ) is
    v_Vacation_Tk_Id number;
    v_Timeoff_Tk_Id  number;
    v_Turnout_Id     number;
    v_Turnout_Locked varchar2(1);
    v_Timeoff_Date   date := i_Begin_Date;
  
    --------------------------------------------------
    Procedure Assert_No_Timesheet_Adjustments
    (
      i_Company_Id      number,
      i_Filial_Id       number,
      i_Staff_Id        number,
      i_Timeoff_Id      number,
      i_Adjustment_Date date
    ) is
    begin
      if z_Hpd_Lock_Adjustments.Exist(i_Company_Id      => i_Company_Id,
                                      i_Filial_Id       => i_Filial_Id,
                                      i_Staff_Id        => i_Staff_Id,
                                      i_Adjustment_Date => i_Adjustment_Date) then
        Hpd_Error.Raise_076(i_Interval_Kind   => Get_Timeoff_Interval_Kind(i_Company_Id => i_Company_Id,
                                                                           i_Filial_Id  => i_Filial_Id,
                                                                           i_Timeoff_Id => i_Timeoff_Id),
                            i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                      i_Filial_Id  => i_Filial_Id,
                                                                      i_Staff_Id   => i_Staff_Id),
                            i_Adjustment_Date => i_Adjustment_Date);
      end if;
    end;
  
  begin
    if Hpd_Util.Is_Sick_Leave_Journal(i_Company_Id      => i_Company_Id,
                                      i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Timeoff_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                               i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Sick);
    elsif Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => i_Company_Id,
                                            i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Timeoff_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                               i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Trip);
    elsif Hpd_Util.Is_Vacation_Journal(i_Company_Id      => i_Company_Id,
                                       i_Journal_Type_Id => i_Journal_Type_Id) then
      v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
      v_Timeoff_Tk_Id  := z_Hpd_Vacations.Load(i_Company_Id => i_Company_Id, --
                          i_Filial_Id => i_Filial_Id, --
                          i_Timeoff_Id => i_Timeoff_Id).Time_Kind_Id;
    else
      b.Raise_Not_Implemented;
    end if;
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    while v_Timeoff_Date <= i_End_Date
    loop
      if z_Htt_Timesheet_Locks.Exist_Lock(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Staff_Id       => i_Staff_Id,
                                          i_Timesheet_Date => v_Timeoff_Date) and
         Htt_Util.Get_Fact_Value(i_Company_Id     => i_Company_Id,
                                 i_Filial_Id      => i_Filial_Id,
                                 i_Staff_Id       => i_Staff_Id,
                                 i_Timesheet_Date => v_Timeoff_Date,
                                 i_Time_Kind_Id   => v_Turnout_Id) > 0 then
        v_Turnout_Locked := 'Y';
      else
        v_Turnout_Locked := 'N';
      end if;
    
      Assert_No_Timesheet_Adjustments(i_Company_Id      => i_Company_Id,
                                      i_Filial_Id       => i_Filial_Id,
                                      i_Staff_Id        => i_Staff_Id,
                                      i_Timeoff_Id      => i_Timeoff_Id,
                                      i_Adjustment_Date => v_Timeoff_Date);
    
      z_Hpd_Timeoff_Days.Insert_One(i_Company_Id     => i_Company_Id,
                                    i_Filial_Id      => i_Filial_Id,
                                    i_Staff_Id       => i_Staff_Id,
                                    i_Timeoff_Date   => v_Timeoff_Date,
                                    i_Timeoff_Id     => i_Timeoff_Id,
                                    i_Time_Kind_Id   => v_Timeoff_Tk_Id,
                                    i_Turnout_Locked => v_Turnout_Locked);
    
      v_Timeoff_Date := v_Timeoff_Date + 1;
    end loop;
  
    Regen_Timeoff_Facts(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Timeoff_Id => i_Timeoff_Id,
                        i_Staff_Id   => i_Staff_Id,
                        i_Begin_Date => i_Begin_Date,
                        i_End_Date   => i_End_Date);
  
    if v_Vacation_Tk_Id = v_Timeoff_Tk_Id and
       Hpd_Util.Is_Vacation_Journal(i_Company_Id      => i_Company_Id,
                                    i_Journal_Type_Id => i_Journal_Type_Id) then
      Spend_Vacation_Days(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Begin_Date => i_Begin_Date,
                          i_End_Date   => i_End_Date);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Remove_Timeoff_Days
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number,
    i_Timeoff_Id      number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date
  ) is
    v_Vacation_Tk_Id number;
  begin
    v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    if Hpd_Util.Is_Vacation_Journal(i_Company_Id      => i_Company_Id,
                                    i_Journal_Type_Id => i_Journal_Type_Id) and --
       v_Vacation_Tk_Id = --
       z_Hpd_Vacations.Load(i_Company_Id => i_Company_Id, --
       i_Filial_Id => i_Filial_Id, --
       i_Timeoff_Id => i_Timeoff_Id).Time_Kind_Id then
      Free_Vacation_Days(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Begin_Date => i_Begin_Date,
                         i_End_Date   => i_End_Date);
    end if;
  
    Regen_Timeoff_Facts(i_Company_Id     => i_Company_Id,
                        i_Filial_Id      => i_Filial_Id,
                        i_Timeoff_Id     => i_Timeoff_Id,
                        i_Staff_Id       => i_Staff_Id,
                        i_Begin_Date     => i_Begin_Date,
                        i_End_Date       => i_End_Date,
                        i_Remove_Timeoff => true);
  
    delete Hpd_Timeoff_Days Td
     where Td.Company_Id = i_Company_Id
       and Td.Filial_Id = i_Filial_Id
       and Td.Timeoff_Id = i_Timeoff_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Posted = 'Y' then
      Hpd_Error.Raise_026(i_Contract_Id);
    end if;
  
    if r_Contract.Contract_Kind = Hpd_Pref.c_Cv_Contract_Kind_Simple then
      Hpr_Core.Generate_Fact_Of_Cv_Contract(i_Company_Id  => r_Contract.Company_Id,
                                            i_Filial_Id   => r_Contract.Filial_Id,
                                            i_Contract_Id => r_Contract.Contract_Id,
                                            i_Month       => Trunc(r_Contract.End_Date, 'mon'));
    else
      r_Contract.Begin_Date := Trunc(r_Contract.Begin_Date, 'mon');
      r_Contract.End_Date   := Trunc(r_Contract.End_Date, 'mon');
    
      while r_Contract.Begin_Date <= r_Contract.End_Date
      loop
        Hpr_Core.Generate_Fact_Of_Cv_Contract(i_Company_Id  => r_Contract.Company_Id,
                                              i_Filial_Id   => r_Contract.Filial_Id,
                                              i_Contract_Id => r_Contract.Contract_Id,
                                              i_Month       => r_Contract.Begin_Date);
      
        r_Contract.Begin_Date := Add_Months(r_Contract.Begin_Date, 1);
      end loop;
    end if;
  
    z_Hpd_Cv_Contracts.Update_One(i_Company_Id  => r_Contract.Company_Id,
                                  i_Filial_Id   => r_Contract.Filial_Id,
                                  i_Contract_Id => r_Contract.Contract_Id,
                                  i_Posted      => Option_Varchar2('Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
    v_Month    date;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Posted = 'N' then
      Hpd_Error.Raise_027(i_Contract_Id);
    end if;
  
    begin
      select q.Month
        into v_Month
        from Hpr_Cv_Contract_Facts q
       where q.Company_Id = r_Contract.Company_Id
         and q.Filial_Id = r_Contract.Filial_Id
         and q.Contract_Id = r_Contract.Contract_Id
         and q.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_New
         and Rownum = 1;
    
      Hpd_Error.Raise_028(i_Person_Name => z_Mr_Natural_Persons.Load(i_Company_Id => r_Contract.Company_Id, --
                                           i_Person_Id => r_Contract.Person_Id).Name,
                          i_Fact_Month  => v_Month);
    exception
      when No_Data_Found then
        delete from Hpr_Cv_Contract_Facts q
         where q.Company_Id = r_Contract.Company_Id
           and q.Filial_Id = r_Contract.Filial_Id
           and q.Contract_Id = r_Contract.Contract_Id;
    end;
  
    z_Hpd_Cv_Contracts.Update_One(i_Company_Id        => r_Contract.Company_Id,
                                  i_Filial_Id         => r_Contract.Filial_Id,
                                  i_Contract_Id       => r_Contract.Contract_Id,
                                  i_Posted            => Option_Varchar2('N'),
                                  i_Early_Closed_Date => Option_Date(null),
                                  i_Early_Closed_Note => Option_Varchar2(null));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  ) is
    r_Contract    Hpd_Cv_Contracts%rowtype;
    v_Begin_Month date;
  
    --------------------------------------------------
    Function Exist_Fact(i_Month date) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hpr_Cv_Contract_Facts q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Contract_Id = i_Contract_Id
         and q.Month = i_Month
         and Rownum = 1;
      return true;
    
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------
    Procedure Gen(i_Month date) is
    begin
      if not Exist_Fact(i_Month) then
        Hpr_Core.Generate_Fact_Of_Cv_Contract(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Contract_Id => i_Contract_Id,
                                              i_Month       => i_Month);
      end if;
    end;
  begin
    if i_Early_Closed_Date is null then
      Hpd_Error.Raise_031(i_Contract_Id);
    end if;
  
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Posted = 'N' then
      Hpd_Error.Raise_029(i_Contract_Id);
    end if;
  
    z_Hpd_Cv_Contracts.Update_One(i_Company_Id        => r_Contract.Company_Id,
                                  i_Filial_Id         => r_Contract.Filial_Id,
                                  i_Contract_Id       => r_Contract.Contract_Id,
                                  i_Early_Closed_Date => Option_Date(i_Early_Closed_Date),
                                  i_Early_Closed_Note => Option_Varchar2(i_Early_Closed_Note));
  
    r_Contract.Begin_Date := Trunc(r_Contract.Begin_Date, 'mon');
    r_Contract.End_Date   := Trunc(i_Early_Closed_Date, 'mon');
  
    if r_Contract.Contract_Kind = Hpd_Pref.c_Cv_Contract_Kind_Simple then
      Gen(r_Contract.End_Date);
    else
      v_Begin_Month := r_Contract.Begin_Date;
    
      while v_Begin_Month <= r_Contract.End_Date
      loop
        Gen(v_Begin_Month);
        v_Begin_Month := Add_Months(v_Begin_Month, 1);
      end loop;
    end if;
  
    Hpr_Core.Cv_Contract_Facts_Delete(i_Company_Id        => r_Contract.Company_Id,
                                      i_Filial_Id         => r_Contract.Filial_Id,
                                      i_Contract_Id       => r_Contract.Contract_Id,
                                      i_Begin_Date        => r_Contract.Begin_Date,
                                      i_Early_Closed_Date => i_Early_Closed_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Posted = 'Y' then
      Hpd_Error.Raise_041(i_Contract_Id);
    end if;
  
    z_Hpd_Cv_Contracts.Delete_One(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Contract_Id => i_Contract_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Journal_Id        number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  ) is
  begin
    for r in (select q.*, Ct.Contract_Id
                from Hpd_Journal_Pages q
                join Hpd_Cv_Contracts Ct
                  on Ct.Company_Id = q.Company_Id
                 and Ct.Filial_Id = q.Filial_Id
                 and Ct.Page_Id = q.Page_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id)
    loop
      z_Hpd_Hirings.Update_One(i_Company_Id     => r.Company_Id,
                               i_Filial_Id      => r.Filial_Id,
                               i_Page_Id        => r.Page_Id,
                               i_Dismissal_Date => Option_Date(i_Early_Closed_Date));
    
      z_Hpd_Cv_Contracts.Update_One(i_Company_Id        => r.Company_Id,
                                    i_Filial_Id         => r.Filial_Id,
                                    i_Contract_Id       => r.Contract_Id,
                                    i_Early_Closed_Note => Option_Varchar2(i_Early_Closed_Note));
    end loop;
  
    Hpd_Core.Journal_Unpost(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Journal_Id => i_Journal_Id,
                            i_Repost     => true);
  
    Hpd_Core.Journal_Post(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Journal_Id => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Page_Ids   Array_Number := Array_Number()
  ) is
  begin
    for r in (select q.*, Ct.Contract_Id
                from Hpd_Journal_Pages q
                join Hpd_Cv_Contracts Ct
                  on Ct.Company_Id = q.Company_Id
                 and Ct.Filial_Id = q.Filial_Id
                 and Ct.Page_Id = q.Page_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id
                 and q.Page_Id not member of i_Page_Ids)
    loop
      Cv_Contract_Delete(i_Company_Id  => i_Company_Id,
                         i_Filial_Id   => i_Filial_Id,
                         i_Contract_Id => r.Contract_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Send_Application_Notification
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Title          varchar2,
    i_Grants         Array_Varchar2,
    i_Uri            varchar2,
    i_Uri_Param      Hashmap,
    i_Except_User_Id number,
    i_Created_By     number := null -- optional, specified if the user that created the application needs to be notified too
  ) is
  begin
    Href_Core.Send_Application_Notification(i_Company_Id         => i_Company_Id,
                                            i_Filial_Id          => i_Filial_Id,
                                            i_Title              => i_Title,
                                            i_Form               => Hpd_Pref.c_Form_Application_List,
                                            i_Action_Keys        => i_Grants,
                                            i_Uri                => i_Uri,
                                            i_Uri_Param          => i_Uri_Param,
                                            i_Except_User_Id     => i_Except_User_Id,
                                            i_Additional_User_Id => i_Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Robot_Book_Transactions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    for r in (select p.Page_Id, q.Trans_Id
                from Hpd_Journal_Pages p
                join Hpd_Robot_Trans_Pages q
                  on q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Page_Id = p.Page_Id
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Journal_Id = i_Journal_Id)
    loop
      z_Hpd_Robot_Trans_Staffs.Delete_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => r.Trans_Id);
    
      z_Hpd_Robot_Trans_Pages.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r.Page_Id,
                                         i_Trans_Id   => r.Trans_Id);
    
      Hrm_Core.Robot_Transaction_Delete(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => r.Trans_Id);
    end loop;
  
    Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  end;

end Hpd_Core;
/
