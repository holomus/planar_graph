create or replace package Ut_Hpr_Core is
  --%suite(hpr_core)
  --%suitepath(vhr.hpr.hpr_core)
  --%beforeeach(ut_vhr_util.context_begin_with_filial)
  --%aftereach(biruni_route.context_end)

  --%context(lock timesheets)

  --%test(lock timesheets)
  --%beforetest(create_inserted_staff_with_timesheets)
  Procedure Lock_Timesheets;

  --%test(lock nonexistent timesheets)
  --%beforetest(create_staff_no_timesheets)
  Procedure Lock_Nonexistent_Timesheets;

  --%test(lock locked timesheets)
  --%beforetest(create_locked_timesheets)
  --%throws(b.fatal_n)
  Procedure Lock_Locked_Timesheets;

  --%endcontext

  --%context(unlock timesheets)

  --%test(unlock timesheets)
  --%beforetest(create_locked_timesheets)
  Procedure Unlock_Timesheets;

  --%test(unlock nonlocked timesheets)
  --%beforetest(create_staff_no_timesheets_with_insert)
  Procedure Unlock_Nonlocked_Timesheets;

  --%endcontext

  --%context(timebook staff insert)

  --%test(insert timebook staff)
  --%beforetest(create_staff_no_timesheets)
  Procedure Insert_Timebook_Staff;

  --%test(insert locked staff)
  --%beforetest(create_locked_timesheets)
  --%throws(b.fatal_n)
  Procedure Insert_Locked_Staff;

  --%test(insert staff with facts)
  --%beforetest(create_staff_with_facts)
  Procedure Insert_Staff_With_Facts;

  --%test(insert staff with two agreements)
  --%beforetest(create_staff_two_agreements)
  Procedure Insert_Staff_With_Two_Agreements;

  --%test(insert staff with child facts)
  --%beforetest(create_staff_with_child_fact)
  Procedure Insert_Staff_With_Child_Fact;

  --%test(insert dismissed staff)
  --%beforetest(create_dismissed_staff)
  Procedure Insert_Dismissed_Staff;

  --%endcontext

  --%context(update timebook)

  --%test(update timebook no staff)
  --%beforetest(create_timebook_no_staff)
  Procedure Update_Timebook_No_Staff;

  --%test(update timebook)
  --%beforetest(create_inserted_staff_with_facts)
  Procedure Update_Timebook;

  --%endcontext

  --%context(timebook save)

  --%test(save posted timebook)
  --%beforetest(create_posted_timebook_rt)
  --%throws(b.error_n)
  Procedure Save_Posted_Timebook;

  --%test(save timebook no staffs)
  --%beforetest(create_timebook_rt)
  Procedure Save_Timebook_No_Staffs;

  --%test(save existing timebook)
  --%beforetest(create_existing_timebook_rt)
  Procedure Save_Existing_Timebook;

  --%test(save timebook with staffs)
  --%beforetest(create_timebook_rt_with_staffs)
  Procedure Save_Timebook_With_Staffs;

  --%test(save existing timebook no staffs)
  --%beforetest(create_existing_timebook_rt_no_staff)
  Procedure Save_Existing_Timebook_No_Staff;

  --%endcontext

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Timesheets;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Inserted_Staff_With_Timesheets;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Inserted_Staff_With_Facts;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_No_Timesheets;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Locked_Timesheets;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Facts;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_Two_Agreements;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Child_Fact;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Dismissed_Staff;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_No_Staff;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_No_Timesheets_With_Insert;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Posted_Timebook_Rt;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_Rt;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Existing_Timebook_Rt;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_Rt_With_Staffs;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Existing_Timebook_Rt_No_Staff;
end Ut_Hpr_Core;
/
create or replace package body Ut_Hpr_Core is
  g_Staff_Id    number;
  g_Timebook_Id number;
  g_Turnout_Id  number;
  g_Schedule_Id number;
  g_Job_Id      number;
  g_Division_Id number;
  g_Barcode     Hpr_Timebooks.Barcode%type;
  g_Timebook_Rt Hpr_Pref.Timebook_Rt;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Timesheets is
  begin
    Hpr_Core.Lock_Timesheets(i_Company_Id   => Ui.Company_Id,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_Timebook_Id  => g_Timebook_Id,
                             i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                             i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    for i in 0 .. 2
    loop
      Ut.Expect(z_Htt_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_True();
    
      Ut.Expect(z_Hpr_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_True();
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Nonexistent_Timesheets is
  begin
    Hpr_Core.Lock_Timesheets(i_Company_Id   => Ui.Company_Id,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_Timebook_Id  => g_Timebook_Id,
                             i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                             i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    for i in 0 .. 2
    loop
      Ut.Expect(z_Htt_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    
      Ut.Expect(z_Hpr_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Locked_Timesheets is
  begin
    Hpr_Core.Lock_Timesheets(i_Company_Id   => Ui.Company_Id,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_Timebook_Id  => g_Timebook_Id,
                             i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                             i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    for i in 0 .. 2
    loop
      Ut.Expect(z_Htt_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_True();
    
      Ut.Expect(z_Hpr_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_True();
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unlock_Timesheets is
  begin
    Hpr_Core.Unlock_Timesheets(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Timebook_Id => g_Timebook_Id);
  
    for i in 0 .. 2
    loop
      Ut.Expect(z_Htt_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    
      Ut.Expect(z_Hpr_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Unlock_Nonlocked_Timesheets is
  begin
    Hpr_Core.Unlock_Timesheets(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Timebook_Id => g_Timebook_Id);
  
    for i in 0 .. 2
    loop
      Ut.Expect(z_Htt_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    
      Ut.Expect(z_Hpr_Timesheet_Locks.Exist(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Staff_Id       => g_Staff_Id,
                                            i_Timesheet_Date => Ut_Vhr_Util.c_Gen_Year + i)).To_Be_False();
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Timebook_Staff is
    r_Staff    Hpr_Timebook_Staffs%rowtype;
    v_Fact_Cnt number;
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Plan_Days).To_Equal(0);
    Ut.Expect(r_Staff.Plan_Hours).To_Equal(0);
    Ut.Expect(r_Staff.Fact_Days).To_Equal(0);
    Ut.Expect(r_Staff.Fact_Hours).To_Equal(0);
  
    select count(*)
      into v_Fact_Cnt
      from Hpr_Timebook_Facts p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id;
  
    Ut.Expect(v_Fact_Cnt).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Locked_Staff is
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Staff_With_Facts is
    r_Staff      Hpr_Timebook_Staffs%rowtype;
    v_Fact_Cnt   number;
    v_Fact_Hours number;
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Plan_Days).To_Equal(2);
    Ut.Expect(r_Staff.Plan_Hours).To_Equal(16);
    Ut.Expect(r_Staff.Fact_Days).To_Equal(2);
    Ut.Expect(r_Staff.Fact_Hours).To_Equal(8);
  
    select count(*), sum(p.Fact_Hours)
      into v_Fact_Cnt, v_Fact_Hours
      from Hpr_Timebook_Facts p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id;
  
    Ut.Expect(v_Fact_Cnt).To_Equal(1);
    Ut.Expect(v_Fact_Hours).To_Equal(8);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Staff_With_Two_Agreements is
    r_Staff Hpr_Timebook_Staffs%rowtype;
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Division_Id).To_Equal(g_Division_Id);
    Ut.Expect(r_Staff.Job_Id).To_Equal(g_Job_Id);
    Ut.Expect(r_Staff.Schedule_Id).To_Equal(g_Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Staff_With_Child_Fact is
    r_Staff      Hpr_Timebook_Staffs%rowtype;
    v_Fact_Cnt   number;
    v_Fact_Hours number;
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Plan_Days).To_Equal(2);
    Ut.Expect(r_Staff.Plan_Hours).To_Equal(16);
    Ut.Expect(r_Staff.Fact_Days).To_Equal(2);
    Ut.Expect(r_Staff.Fact_Hours).To_Equal(16);
  
    select count(*), sum(p.Fact_Hours)
      into v_Fact_Cnt, v_Fact_Hours
      from Hpr_Timebook_Facts p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id;
  
    Ut.Expect(v_Fact_Cnt).To_Equal(1);
    Ut.Expect(v_Fact_Hours).To_Equal(16);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Dismissed_Staff is
    r_Staff Hpr_Timebook_Staffs%rowtype;
  begin
    Hpr_Core.Timebook_Staff_Insert(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Timebook_Id  => g_Timebook_Id,
                                   i_Staff_Id     => g_Staff_Id,
                                   i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                   i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Division_Id).To_Equal(g_Division_Id);
    Ut.Expect(r_Staff.Job_Id).To_Equal(g_Job_Id);
    Ut.Expect(r_Staff.Schedule_Id).To_Equal(g_Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Timebook_No_Staff is
    v_Fact_Cnt number;
  begin
    Hpr_Core.Timebook_Staffs_Update(i_Company_Id   => Ui.Company_Id,
                                    i_Filial_Id    => Ui.Filial_Id,
                                    i_Timebook_Id  => g_Timebook_Id,
                                    i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                    i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    select count(*)
      into v_Fact_Cnt
      from Hpr_Timebook_Facts p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id;
  
    Ut.Expect(v_Fact_Cnt).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Timebook is
    r_Staff      Hpr_Timebook_Staffs%rowtype;
    v_Fact_Cnt   number;
    v_Fact_Hours number;
  begin
    Hpr_Core.Timebook_Staffs_Update(i_Company_Id   => Ui.Company_Id,
                                    i_Filial_Id    => Ui.Filial_Id,
                                    i_Timebook_Id  => g_Timebook_Id,
                                    i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                                    i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id,
                                          o_Row         => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.Plan_Days).To_Equal(2);
    Ut.Expect(r_Staff.Plan_Hours).To_Equal(16);
    Ut.Expect(r_Staff.Fact_Days).To_Equal(2);
    Ut.Expect(r_Staff.Fact_Hours).To_Equal(8);
  
    select count(*), sum(p.Fact_Hours)
      into v_Fact_Cnt, v_Fact_Hours
      from Hpr_Timebook_Facts p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id;
  
    Ut.Expect(v_Fact_Cnt).To_Equal(1);
    Ut.Expect(v_Fact_Hours).To_Equal(8);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Posted_Timebook is
  begin
    Hpr_Core.Timebook_Save(g_Timebook_Rt);
  
    Ut.Expect(z_Hpr_Timebooks.Exist(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Timebook_Id => g_Timebook_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Timebook_No_Staffs is
    r_Timebook  Hpr_Timebooks%rowtype;
    v_Staff_Cnt number;
  begin
    Hpr_Core.Timebook_Save(g_Timebook_Rt);
  
    Ut.Expect(z_Hpr_Timebooks.Exist(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Timebook_Id => g_Timebook_Id,
                                    o_Row         => r_Timebook)).To_Be_True();
  
    Ut.Expect(r_Timebook.Posted).To_Equal('N');
  
    select count(*)
      into v_Staff_Cnt
      from Hpr_Timebook_Staffs p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Timebook_Id = g_Timebook_Id;
  
    Ut.Expect(v_Staff_Cnt).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Existing_Timebook is
    r_Timebook  Hpr_Timebooks%rowtype;
    v_Staff_Cnt number;
  begin
    Hpr_Core.Timebook_Save(g_Timebook_Rt);
  
    Ut.Expect(z_Hpr_Timebooks.Exist(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Timebook_Id => g_Timebook_Id,
                                    o_Row         => r_Timebook)).To_Be_True();
  
    Ut.Expect(r_Timebook.Barcode).To_Equal(g_Barcode);
  
    select count(*)
      into v_Staff_Cnt
      from Hpr_Timebook_Staffs p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Timebook_Id = g_Timebook_Id;
  
    Ut.Expect(v_Staff_Cnt).To_Equal(1);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Timebook_With_Staffs is
    v_Staff_Cnt number;
  begin
    Hpr_Core.Timebook_Save(g_Timebook_Rt);
  
    Ut.Expect(z_Hpr_Timebooks.Exist(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Timebook_Id => g_Timebook_Id)).To_Be_True();
  
    select count(*)
      into v_Staff_Cnt
      from Hpr_Timebook_Staffs p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Timebook_Id = g_Timebook_Id;
  
    Ut.Expect(v_Staff_Cnt).To_Equal(1);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Existing_Timebook_No_Staff is
    v_Staff_Cnt number;
  begin
    Hpr_Core.Timebook_Save(g_Timebook_Rt);
  
    Ut.Expect(z_Hpr_Timebooks.Exist(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Timebook_Id => g_Timebook_Id)).To_Be_True();
  
    select count(*)
      into v_Staff_Cnt
      from Hpr_Timebook_Staffs p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Timebook_Id = g_Timebook_Id;
  
    Ut.Expect(v_Staff_Cnt).To_Equal(0);
  
    Ut.Expect(z_Hpr_Timebook_Staffs.Exist(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Timebook_Id => g_Timebook_Id,
                                          i_Staff_Id    => g_Staff_Id)).To_Be_False();
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Timesheet_Facts(i_Time_Kind_Id number) is
  begin
    insert into Htt_Timesheet_Facts t
      (t.Company_Id, --
       t.Filial_Id,
       t.Timesheet_Id,
       t.Time_Kind_Id,
       t.Fact_Value)
      select q.Company_Id, --
             q.Filial_Id,
             q.Timesheet_Id,
             i_Time_Kind_Id,
             14400
        from Htt_Timesheets q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Staff_Id = g_Staff_Id
         and q.Day_Kind = Htt_Pref.c_Day_Kind_Work;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_Rt is
    v_Date date := Ut_Vhr_Util.c_Gen_Year;
  begin
    g_Timebook_Id := Hpr_Next.Timebook_Id;
  
    Hpr_Util.Timebook_New(o_Timebook        => g_Timebook_Rt,
                          i_Company_Id      => Ui.Company_Id,
                          i_Filial_Id       => Ui.Filial_Id,
                          i_Timebook_Id     => g_Timebook_Id,
                          i_Timebook_Number => 'not a timebook number',
                          i_Timebook_Date   => Trunc(sysdate),
                          i_Period_Begin    => v_Date,
                          i_Period_End      => v_Date + 2,
                          i_Period_Kind     => Hpr_Pref.c_Timebook_Period_Custom,
                          i_Division_Id     => null,
                          i_Note            => null,
                          i_Staff_Ids       => Array_Number());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Existing_Timebook_Rt is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    Create_Staff_No_Timesheets_With_Insert;
  
    r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Timebook_Id => g_Timebook_Id);
  
    Hpr_Util.Timebook_New(o_Timebook        => g_Timebook_Rt,
                          i_Company_Id      => r_Timebook.Company_Id,
                          i_Filial_Id       => r_Timebook.Filial_Id,
                          i_Timebook_Id     => r_Timebook.Timebook_Id,
                          i_Timebook_Number => r_Timebook.Timebook_Number,
                          i_Timebook_Date   => r_Timebook.Timebook_Date,
                          i_Period_Begin    => r_Timebook.Period_Begin,
                          i_Period_End      => r_Timebook.Period_End,
                          i_Period_Kind     => r_Timebook.Period_Kind,
                          i_Division_Id     => r_Timebook.Division_Id,
                          i_Note            => r_Timebook.Note,
                          i_Staff_Ids       => Array_Number());
  
    select p.Staff_Id
      bulk collect
      into g_Timebook_Rt.Staff_Ids
      from Hpr_Timebook_Staffs p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Timebook_Id = g_Timebook_Id;
  
    g_Barcode := r_Timebook.Barcode;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_Rt_With_Staffs is
  begin
    Create_Timebook_Rt;
    g_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id);
  
    g_Timebook_Rt.Staff_Ids := Array_Number(g_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Existing_Timebook_Rt_No_Staff is
  begin
    Create_Existing_Timebook_Rt;
    g_Timebook_Rt.Staff_Ids := Array_Number();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Posted_Timebook_Rt is
  begin
    Create_Timebook_Rt;
    Create_Timebook_No_Staff;
    z_Hpr_Timebooks.Update_One(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Timebook_Id => g_Timebook_Id,
                               i_Posted      => Option_Varchar2('Y'));
  
    g_Timebook_Rt.Timebook_Id := g_Timebook_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timebook_No_Staff is
  begin
    g_Timebook_Id := Hpr_Next.Timebook_Id;
  
    z_Hpr_Timebooks.Insert_One(i_Company_Id      => Ui.Company_Id,
                               i_Filial_Id       => Ui.Filial_Id,
                               i_Timebook_Id     => g_Timebook_Id,
                               i_Timebook_Number => 'not a timebook number',
                               i_Timebook_Date   => Trunc(sysdate),
                               i_Division_Id     => null,
                               i_Note            => 'not a note',
                               i_Barcode         => 'not a barcode',
                               i_Posted          => 'N',
                               i_Period_Begin    => Ut_Vhr_Util.c_Gen_Year,
                               i_Period_End      => Ut_Vhr_Util.c_Gen_Year + 2,
                               i_Period_Kind     => Hpr_Pref.c_Timebook_Period_Custom);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Dismissed_Staff is
  begin
    Create_Staff_Two_Agreements;
  
    z_Href_Staffs.Update_One(i_Company_Id     => Ui.Company_Id,
                             i_Filial_Id      => Ui.Filial_Id,
                             i_Staff_Id       => g_Staff_Id,
                             i_Dismissal_Date => Option_Date(Ut_Vhr_Util.c_Gen_Year + 1));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Child_Fact is
    v_Meeting_Id number;
  begin
    Create_Staff_With_Facts;
  
    v_Meeting_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Meeting);
  
    Insert_Timesheet_Facts(v_Meeting_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_Two_Agreements is
    v_Robot_Id number;
    v_Date     date := Ut_Vhr_Util.c_Gen_Year + 1;
  begin
    Create_Staff_No_Timesheets;
  
    g_Division_Id := Ut_Vhr_Util.Create_Division(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Opened_Date => v_Date);
    g_Job_Id      := Ut_Vhr_Util.Create_Job(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id);
    v_Robot_Id    := Ut_Vhr_Util.Create_Robot(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Division_Id => g_Division_Id,
                                              i_Job_Id      => g_Job_Id,
                                              i_Opened_Date => v_Date);
    g_Schedule_Id := Ut_Vhr_Util.Create_Schedule_Three_Days_One_Rest(i_Company_Id => Ui.Company_Id,
                                                                     i_Filial_Id  => Ui.Filial_Id);
  
    Ut_Vhr_Util.Insert_Agreement(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Staff_Id   => g_Staff_Id,
                                 i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                 i_Period     => v_Date,
                                 i_Robot_Id   => v_Robot_Id);
  
    Ut_Vhr_Util.Insert_Agreement(i_Company_Id  => Ui.Company_Id,
                                 i_Filial_Id   => Ui.Filial_Id,
                                 i_Staff_Id    => g_Staff_Id,
                                 i_Trans_Type  => Hpd_Pref.c_Transaction_Type_Schedule,
                                 i_Period      => v_Date,
                                 i_Schedule_Id => g_Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Facts is
  begin
    Create_Staff_With_Timesheets;
  
    g_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Insert_Timesheet_Facts(g_Turnout_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Locked_Timesheets is
  begin
    Create_Inserted_Staff_With_Timesheets;
    Hpr_Core.Lock_Timesheets(i_Company_Id   => Ui.Company_Id,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_Timebook_Id  => g_Timebook_Id,
                             i_Period_Begin => Ut_Vhr_Util.c_Gen_Year,
                             i_Period_End   => Ut_Vhr_Util.c_Gen_Year + 2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_No_Timesheets is
  begin
    g_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id);
  
    Create_Timebook_No_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_No_Timesheets_With_Insert is
    -------------------------------------------------- 
    Procedure Insert_Timebook_Staff is
    begin
      insert into Hpr_Timebook_Staffs t
        (t.Company_Id,
         t.Filial_Id,
         t.Timebook_Id,
         t.Staff_Id,
         t.Schedule_Id,
         t.Job_Id,
         t.Division_Id,
         t.Plan_Days,
         t.Plan_Hours,
         t.Fact_Days,
         t.Fact_Hours)
        select p.Company_Id,
               p.Filial_Id,
               g_Timebook_Id,
               p.Staff_Id,
               p.Schedule_Id,
               p.Job_Id,
               p.Division_Id,
               0,
               0,
               0,
               0
          from Href_Staffs p
         where p.Company_Id = Ui.Company_Id
           and p.Filial_Id = Ui.Filial_Id
           and p.Staff_Id = g_Staff_Id;
    end;
  begin
    Create_Staff_No_Timesheets;
  
    Insert_Timebook_Staff;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Timesheets is
  begin
    insert into Htt_Timesheets t
      (t.Company_Id,
       t.Filial_Id,
       t.Timesheet_Id,
       t.Timesheet_Date,
       t.Staff_Id,
       t.Employee_Id,
       t.Schedule_Id,
       t.Calendar_Id,
       t.Day_Kind,
       t.Count_Late,
       t.Count_Early,
       t.Count_Lack,
       t.Shift_Begin_Time,
       t.Shift_End_Time,
       t.Input_Border,
       t.Output_Border,
       t.Begin_Time,
       t.End_Time,
       t.Break_Enabled,
       t.Break_Begin_Time,
       t.Break_End_Time,
       t.Input_Time,
       t.Output_Time,
       t.Track_Duration,
       t.Plan_Time,
       t.Full_Time,
       t.Planned_Marks,
       t.Done_Marks)
      select p.Company_Id,
             p.Filial_Id,
             Htt_Next.Timesheet_Id,
             p.Schedule_Date,
             q.Staff_Id,
             q.Employee_Id,
             p.Schedule_Id,
             null,
             p.Day_Kind,
             'Y',
             'Y',
             'Y',
             p.Shift_Begin_Time,
             p.Shift_End_Time,
             p.Input_Border,
             p.Output_Border,
             p.Begin_Time,
             p.End_Time,
             p.Break_Enabled,
             p.Break_Begin_Time,
             p.Break_End_Time,
             null,
             null,
             1440,
             p.Plan_Time * 60,
             p.Full_Time * 60,
             0,
             0
        from Htt_Schedule_Days p
        join Href_Staffs q
          on q.Company_Id = p.Company_Id
         and q.Filial_Id = p.Filial_Id
         and q.Schedule_Id = p.Schedule_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Staff_Id = g_Staff_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_With_Timesheets is
  begin
    Create_Staff_No_Timesheets;
    Create_Timesheets;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Inserted_Staff_With_Timesheets is
  begin
    Create_Staff_No_Timesheets_With_Insert;
    Create_Timesheets;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Inserted_Staff_With_Facts is
    v_Meeting_Id number;
  begin
    Create_Inserted_Staff_With_Timesheets;
  
    v_Meeting_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Meeting);
  
    Insert_Timesheet_Facts(v_Meeting_Id);
  end;

end Ut_Hpr_Core;
/
