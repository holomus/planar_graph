create or replace package Ut_Hrm_Core is
  --%suite(hrm_core)
  --%suitepath(vhr.hrm.hrm_core)
  --%beforeall(create_filial)
  --%beforeeach(context_begin)
  --%aftereach(biruni_route.context_end)

  --%context(robot transactions)
  --%beforeall(enable_position_setting)

  --%test(open robot)
  --%beforetest(create_robot)
  Procedure Open_Robot;

  --%test(open opened robot)
  --%beforetest(create_opened_robot)
  --%throws(b.error_n)
  Procedure Open_Opened_Robot;

  --%test(close opened robot)
  --%beforetest(create_opened_robot)
  Procedure Close_Opened_Robot;

  --%test(close unopened robot)
  --%beforetest(create_robot)
  --%throws(b.error_n)
  Procedure Close_Unopened_Robot;

  --%test(close opened robot before open date)
  --%beforetest(create_opened_robot)
  --%throws(b.error_n)
  Procedure Close_Opened_Robot_Before_Open;

  --%test(occupy robot)
  --%beforetest(create_opened_robot)
  Procedure Occupy_Robot;

  --%test(occupy closed robot)
  --%beforetest(create_closed_robot)
  --%throws(b.error_n)
  Procedure Occupy_Closed_Robot;

  --%test(occupy closed robot before closed date)
  --%beforetest(create_closed_robot)
  --%throws(b.error_n)
  Procedure Occupy_Closed_Robot_Before_Close;

  --%test(close occupied robot)
  --%beforetest(create_occupied_robot)
  --%throws(b.error_n)
  Procedure Close_Occupied_Robot;

  --%test(unoccupy robot)
  --%beforetest(create_occupied_robot)
  Procedure Unoccupy_Robot;

  --%test(unoccupy robot before occupy date)
  --%beforetest(create_occupied_robot)
  --%throws(b.error_n)
  Procedure Unoccupy_Robot_Before_Occupy;

  --%test(unoccupy opened robot)
  --%beforetest(create_opened_robot)
  --%throws(b.error_n)
  Procedure Unoccupy_Opened_Robot;

  --%test(unoccupy unopened robot)
  --%beforetest(create_robot)
  --%throws(b.error_n)
  Procedure Unoccupy_Unopened_Robot;

  --%test(occupy robot with fte 1.5)
  --%beforetest(create_opened_robot)
  --%throws(b.error_n)
  Procedure Occupy_Exceeding_Fte;

  --%test(occupy two times consecutively)
  --%beforetest(create_opened_robot)
  Procedure Two_Occupies;

  --%test(book robot)
  --%beforetest(create_opened_robot)
  Procedure Book_Robot;

  --%test(occupy robot then book it)
  --%beforetest(create_opened_robot)
  Procedure Occupy_Then_Book_Robot;

  --%endcontext

  --%context(revise_robot_dates)
  --%beforeall(create_robot)

  --%context(no begin date exists)

  --%test(no open date no transactions)
  Procedure No_Begin_No_Trans;

  --%test(no open date occupy exists)
  --%beforetest(create_occupy)
  Procedure No_Begin_Occupy;

  --%test(no open date occupy next day unoccupy)
  --%beforetest(create_occupy_unoccupy)
  Procedure No_Begin_Occupy_Unoccupy;

  --%test(no open date occupy next day unoccupy next day occupy again)
  --%beforetest(create_occupy_unoccupy_occupy)
  Procedure No_Begin_Occupy_Unoccupy_Occupy;

  --%endcontext

  --%context(begin date exists)
  --%beforeall(create_robot_open)

  --%test(open date exists no transactions)
  Procedure Begin_No_Trans;

  --%test(occupy on open date)
  --%beforetest(create_occupy)
  Procedure Begin_Occupy;

  --%test(occupy on open date next day unoccupy)
  --%beforetest(create_occupy_unoccupy)
  Procedure Begin_Occupy_Unoccupy;

  --%test(occupy on open date next day unoccupy mext day occupy)
  --%beforetest(create_occupy_unoccupy_occupy)
  Procedure Begin_Occupy_Unoccupy_Occupy;

  --%test(occupy before open date)  
  --%beforetest(create_begin_occupy_before_open_date)
  Procedure Begin_Occupy_Before_Open_Date;

  --%test(occupy after date)
  --%beforetest(create_begin_occupy_after_open_date)
  Procedure Begin_Occupy_After_Open_Date;

  --%endcontext

  --%context(begin date and end date exist)
  --%beforeall(create_robot_open_close)

  --%test(open and close date exists no transactions)
  Procedure Begin_Close_No_Trans;

  --%test(close date exists occupy on open date)
  --%beforetest(create_occupy)
  Procedure Begin_Close_Occupy;

  --%test(close date exists occupy on open date next day unoccupy)
  --%beforetest(create_occupy_unoccupy)
  Procedure Begin_Close_Occupy_Unoccupy;

  --%test(close date exists occupy on open date next day unoccupy mext day occupy)
  --%beforetest(create_occupy_unoccupy_occupy)
  Procedure Begin_Close_Occupy_Unoccupy_Occupy;

  --%test(close date exists occupy after close date)
  --%beforetest(create_begin_close_occupy_unoccupy_after_closed)
  Procedure Begin_Close_Occupy_Unoccupy_After_Closed;

  --%test(close date exists occupy on close date)
  --%beforetest(create_begin_close_occupy_unoccupy_on_closed)
  Procedure Begin_Close_Occupy_Unoccupy_On_Closed;

  --%endcontext

  --%test(revise robot with booked trans)
  --%beforetest(create_revise_booked_trans_exists)
  --%throws(b.error_n)
  Procedure Revise_Booked_Trans_Exists;

  --%test(revise with position setting disabled)
  --%beforetest(enable_position_setting)
  Procedure Revise_Setting_Position_Disabled;

  --%test(occupy unoccupy same date, throws too many rows)
  --%beforetest(create_occupy_unoccupy_same_date)
  --%throws(-1422)
  Procedure Occupy_Unoccupy_Same_Date;

  --%test(open close same date, throws too many rows)
  --%beforetest(create_open_close_same_date)
  --%throws(-1422)
  Procedure Open_Close_Same_Date;

  --%test(occupy occupy same date, throws too many rows)
  --%beforetest(create_occupy_occupy_same_date)  
  --%throws(-1422)
  Procedure Occupy_Occupy_Same_Date;

  --%test(unoccupy unoccupy same date, throws too many rows)
  --%beforetest(create_unoccupy_unoccupy_same_date) 
  --%throws(-1422) 
  Procedure Unoccupy_Unoccupy_Same_Date;

  --%endcontext

  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial;
  ----------------------------------------------------------------------------------------------------
  Procedure Enable_Position_Setting;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Robot;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Opened_Robot;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Closed_Robot;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Occupied_Robot;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy_Occupy;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Robot_Open;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Robot_Open_Close;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Close_Occupy_Unoccupy_After_Closed;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Close_Occupy_Unoccupy_On_Closed;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Revise_Booked_Trans_Exists;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy_Same_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Open_Close_Same_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Occupy_Same_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Unoccupy_Unoccupy_Same_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Occupy_Before_Open_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Occupy_After_Open_Date;
end Ut_Hrm_Core;
/
create or replace package body Ut_Hrm_Core is
  g_Robot_Id  number;
  g_Filial_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin is
  begin
    Ut_Util.Context_Begin(i_Filial_Id => g_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial is
  begin
    Ut_Util.Context_Begin;
    g_Filial_Id := Ut_Vhr_Util.Create_Filial(Ui.Company_Id);
    Biruni_Route.Context_End;
    Context_Begin;
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trans_Load
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Trans_Date date,
    i_Fte_Kind   varchar2
  ) return Hrm_Robot_Transactions%rowtype is
    result Hrm_Robot_Transactions%rowtype;
  begin
    select p.*
      into result
      from Hrm_Robot_Transactions p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Robot_Id = i_Robot_Id
       and p.Trans_Date = i_Trans_Date
       and p.Fte_Kind = i_Fte_Kind;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Robot_Dates
  (
    i_Open_Date   date := null,
    i_Closed_Date date := null
  ) is
    r_Trans              Hrm_Robot_Transactions%rowtype;
    r_Robot              Hrm_Robots%rowtype;
    v_Trans_Cnt          number;
    v_Actual_Closed_Date date := i_Closed_Date - 1;
    --------------------------------------------------
    Function Trans_Cnt
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Robot_Id   number,
      i_Fte_Kind   varchar2
    ) return number is
      result number;
    begin
      select count(*)
        into result
        from Hrm_Robot_Transactions p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Robot_Id = i_Robot_Id
         and p.Fte_Kind = i_Fte_Kind;
    
      return result;
    end;
  begin
    r_Robot := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Robot_Id   => g_Robot_Id);
  
    r_Trans := Trans_Load(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Robot_Id   => g_Robot_Id,
                          i_Trans_Date => i_Open_Date,
                          i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
  
    if i_Open_Date is not null then
      Ut.Expect(r_Trans.Trans_Date).To_Equal(i_Open_Date);
    
      Ut.Expect(r_Robot.Opened_Date).To_Equal(i_Open_Date);
    else
      Ut.Expect(r_Trans.Trans_Date).To_Be_Null();
    
      v_Trans_Cnt := Trans_Cnt(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Robot_Id   => g_Robot_Id,
                               i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
    
      Ut.Expect(v_Trans_Cnt).To_Equal(0);
    end if;
  
    r_Trans := Trans_Load(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Robot_Id   => g_Robot_Id,
                          i_Trans_Date => i_Closed_Date,
                          i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
  
    if v_Actual_Closed_Date is not null then
      Ut.Expect(r_Trans.Trans_Date).To_Equal(i_Closed_Date);
    
      Ut.Expect(r_Robot.Closed_Date).To_Equal(v_Actual_Closed_Date);
    else
      Ut.Expect(r_Trans.Trans_Date).To_Be_Null();
    
      Ut.Expect(r_Robot.Closed_Date).To_Be_Null();
    
      v_Trans_Cnt := Trans_Cnt(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Robot_Id   => g_Robot_Id,
                               i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
    
      if i_Open_Date is null then
        Ut.Expect(v_Trans_Cnt).To_Equal(0);
      else
        Ut.Expect(v_Trans_Cnt).To_Equal(1);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Enable_Position_Setting is
  begin
    z_Hrm_Settings.Insert_One(i_Company_Id       => Ui.Company_Id,
                              i_Filial_Id        => Ui.Filial_Id,
                              i_Position_Enable  => 'Y',
                              i_Position_Check   => 'N',
                              i_Position_Booking => 'N',
                              i_Position_History => 'N',
                              i_Parttime_Enable  => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Open_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(v_Free_Fte).To_Equal(1);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Open_Opened_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate) - 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(v_Free_Fte).To_Equal(2);
    Ut.Expect(v_Planned_Fte).To_Equal(2);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Close_Opened_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  begin
    Hrm_Core.Robot_Close(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Robot_Id   => g_Robot_Id,
                         i_Close_Date => Trunc(sysdate) + 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(v_Free_Fte).To_Equal(0);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Close_Unopened_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  begin
    Hrm_Core.Robot_Close(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Robot_Id   => g_Robot_Id,
                         i_Close_Date => Trunc(sysdate));
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(v_Free_Fte).To_Equal(-1);
    Ut.Expect(v_Planned_Fte).To_Equal(-1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Close_Opened_Robot_Before_Open is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate) - 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(v_Free_Fte).To_Equal(0);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate),
                                        i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(0);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Closed_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(-1);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Closed_Robot_Before_Close is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) - 1,
                                        i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(-1);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Close_Occupied_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(-1);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unoccupy_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Robot_Id    => g_Robot_Id,
                                          i_Occupy_Date => Trunc(sysdate) + 1,
                                          i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(1);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unoccupy_Robot_Before_Occupy is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Robot_Id    => g_Robot_Id,
                                          i_Occupy_Date => Trunc(sysdate) - 1,
                                          i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(1);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Unoccupy_Opened_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Robot_Id    => g_Robot_Id,
                                          i_Occupy_Date => Trunc(sysdate) - 1,
                                          i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(2);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(-1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unoccupy_Unopened_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Robot_Id    => g_Robot_Id,
                                          i_Occupy_Date => Trunc(sysdate) - 1,
                                          i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(1);
    Ut.Expect(v_Planned_Fte).To_Equal(0);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(-1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Exceeding_Fte is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 1);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 2,
                                        i_Fte         => 0.5);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(-0.5);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(1.5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Two_Occupies is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 0.25);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 2,
                                        i_Fte         => 0.25);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(0.5);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0);
    Ut.Expect(v_Occupied_Fte).To_Equal(0.5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 1,
                                        i_Is_Booked   => true);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(0);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(1);
    Ut.Expect(v_Occupied_Fte).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Then_Book_Robot is
    v_Free_Fte     number;
    v_Planned_Fte  number;
    v_Booked_Fte   number;
    v_Occupied_Fte number;
  
    v_Trans_Id number;
  begin
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 1,
                                        i_Fte         => 0.25);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Robot_Id    => g_Robot_Id,
                                        i_Occupy_Date => Trunc(sysdate) + 2,
                                        i_Fte         => 0.25,
                                        i_Is_Booked   => true);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    select p.Fte, p.Planed_Fte, p.Booked_Fte, p.Occupied_Fte
      into v_Free_Fte, v_Planned_Fte, v_Booked_Fte, v_Occupied_Fte
      from Hrm_Robot_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Robot_Id = g_Robot_Id
       and p.Period = (select max(q.Period)
                         from Hrm_Robot_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Robot_Id = p.Robot_Id);
  
    Ut.Expect(z_Hrm_Robot_Transactions.Exist(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Trans_Id)).To_Be_True();
  
    Ut.Expect(v_Free_Fte).To_Equal(0.5);
    Ut.Expect(v_Planned_Fte).To_Equal(1);
    Ut.Expect(v_Booked_Fte).To_Equal(0.25);
    Ut.Expect(v_Occupied_Fte).To_Equal(0.25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Robot is
  begin
    g_Robot_Id := Mrf_Next.Robot_Id;
    z_Mrf_Robots.Insert_One(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Robot_Id   => g_Robot_Id,
                            i_Name       => 'Test Robot',
                            i_State      => 'A');
  
    z_Hrm_Robots.Insert_One(i_Company_Id       => Ui.Company_Id,
                            i_Filial_Id        => Ui.Filial_Id,
                            i_Robot_Id         => g_Robot_Id,
                            i_Opened_Date      => Trunc(sysdate),
                            i_Contractual_Wage => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Opened_Robot is
  begin
    Create_Robot;
  
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    Hrm_Core.Dirty_Robots_Revise;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Closed_Robot is
  begin
    Create_Robot;
  
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    Hrm_Core.Robot_Close(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Robot_Id   => g_Robot_Id,
                         i_Close_Date => Trunc(sysdate));
  
    Hrm_Core.Dirty_Robots_Revise;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupied_Robot is
    v_Id number;
  begin
    Create_Robot;
  
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  
    Hrm_Core.Dirty_Robots_Revise;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy is
    v_Id number;
  begin
    Create_Occupy;
  
    v_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Robot_Id    => g_Robot_Id,
                                    i_Occupy_Date => Trunc(sysdate) + 1,
                                    i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy_Occupy is
    v_Id number;
  begin
    Create_Occupy_Unoccupy;
  
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate) + 2,
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Robot_Open is
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Robot_Open_Close is
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    Hrm_Core.Robot_Close(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Robot_Id   => g_Robot_Id,
                         i_Close_Date => Trunc(sysdate) + 2);
  
    z_Hrm_Robots.Update_One(i_Company_Id  => Ui.Company_Id,
                            i_Filial_Id   => Ui.Filial_Id,
                            i_Robot_Id    => g_Robot_Id,
                            i_Closed_Date => Option_Date(Trunc(sysdate) + 2));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Begin_No_Trans is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Begin_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Begin_Occupy_Unoccupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate), i_Closed_Date => Trunc(sysdate) + 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Begin_Occupy_Unoccupy_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_No_Trans is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Occupy_Unoccupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate), i_Closed_Date => Trunc(sysdate) + 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Occupy_Unoccupy_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Occupy_Before_Open_Date is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate) - 1,
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Occupy_Before_Open_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate) - 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Occupy_After_Open_Date is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate) + 1,
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Occupy_After_Open_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate) + 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_No_Trans is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_Occupy_Unoccupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate), i_Closed_Date => Trunc(sysdate) + 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_Occupy_Unoccupy_Occupy is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Close_Occupy_Unoccupy_After_Closed is
    v_Id number;
  begin
    Create_Occupy;
  
    v_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Robot_Id    => g_Robot_Id,
                                    i_Occupy_Date => Trunc(sysdate) + 5,
                                    i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_Occupy_Unoccupy_After_Closed is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate), i_Closed_Date => Trunc(sysdate) + 5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Begin_Close_Occupy_Unoccupy_On_Closed is
    v_Id number;
  begin
    Create_Occupy;
  
    v_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Robot_Id    => g_Robot_Id,
                                    i_Occupy_Date => Trunc(sysdate) + 2,
                                    i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Close_Occupy_Unoccupy_On_Closed is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates(i_Open_Date => Trunc(sysdate), i_Closed_Date => Trunc(sysdate) + 2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Revise_Booked_Trans_Exists is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1,
                                  i_Is_Booked   => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Booked_Trans_Exists is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Setting_Position_Disabled is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Unoccupy_Same_Date is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  
    v_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Robot_Id    => g_Robot_Id,
                                    i_Occupy_Date => Trunc(sysdate),
                                    i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Unoccupy_Same_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Open_Close_Same_Date is
  begin
    Hrm_Core.Robot_Open(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Robot_Id   => g_Robot_Id,
                        i_Open_Date  => Trunc(sysdate));
  
    Hrm_Core.Robot_Close(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Robot_Id   => g_Robot_Id,
                         i_Close_Date => Trunc(sysdate) - 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Open_Close_Same_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Occupy_Occupy_Same_Date is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Occupy_Occupy_Same_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Unoccupy_Unoccupy_Same_Date is
    v_Id number;
  begin
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  
    v_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Robot_Id    => g_Robot_Id,
                                  i_Occupy_Date => Trunc(sysdate),
                                  i_Fte         => 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unoccupy_Unoccupy_Same_Date is
  begin
    Hrm_Core.Revise_Robot_Dates(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Robot_Id   => g_Robot_Id);
  
    Assert_Robot_Dates;
  end;

end Ut_Hrm_Core;
/
