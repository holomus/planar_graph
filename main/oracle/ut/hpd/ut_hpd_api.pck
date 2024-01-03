create or replace package Ut_Hpd_Api is
  --%suite(hpd_api)
  --%suitepath(vhr.hpd.hpd_api)
  --%beforeeach(ut_vhr_util.context_begin_with_filial)
  --%aftereach(biruni_route.context_end)

  --%context(journal save)

  --%test(save journal with expected types)
  Procedure Save_Journal_With_Expected_Types;

  --%test(save journal with unexpected types)
  --%throws(b.error_n)
  Procedure Save_Journal_With_Unexpected_Types;

  --%test(save posted journal)
  --%beforetest(create_posted_journal)
  --%throws(b.error_n)
  Procedure Save_Posted_Journal;

  Procedure Create_Posted_Journal;
  --%endcontext

  --%context(hiring journal save)

  --%test(save generic journal)
  --%beforetest(create_unsaved_hiring_journal)
  Procedure Save_Generic_Journal;

  --%test(save hiring with existing staff)
  --%beforetest(create_hiring_journal)
  Procedure Save_Hiring_Old_Staff;

  --%test(save hiring with removed staff)
  --%beforetest(create_hiring_journal)
  Procedure Save_Removed_Staff_Hiring;

  --%test(save hiring, delay repairing)
  --%beforetest(create_hiring_journal)
  --%aftertest(repair_journal)
  Procedure Save_Hiring_Delay_Repairing;

  --%test(save hiring with different employment types)
  --%beforetest(create_journal_three_employment_types)
  Procedure Save_Hiring_Employment_Types;

  --%test(save hiring with wrong journal type)
  --%beforetest(create_unsaved_hiring_journal)
  --%throws(b.error_n)
  Procedure Save_Hiring_Wrong_Journal_Type;

  Procedure Create_Unsaved_Hiring_Journal;
  Procedure Create_Hiring_Journal;
  Procedure Create_Journal_Three_Employment_Types;
  --%endcontext

  --%context(vacation limit change journal save)

  --%test(save generic limit change journal)
  --%beforetest(create_generic_limit_journal)
  Procedure Save_Generic_Limit_Change_Journal;

  --%test(remove staff from saved limit change journal)
  --%beforetest(create_saved_limit_journal)
  Procedure Save_Limit_Change_Removed_Staff;

  --%test(save limit change journal delay repairing)
  --%beforetest(create_saved_limit_journal)
  --%aftertest(repair_journal)
  Procedure Save_Limit_Delay_Repairing;

  Procedure Create_Generic_Limit_Journal;
  Procedure Create_Saved_Limit_Journal;
  --%endcontext

  --%context(overtime save)

  --%test(save with correct datas)
  --%beforetest(create_basic_staff)
  Procedure Overtime_Journal_Save_With_Correct_Datas;

  --%test(overtime save with another journal id)
  --%beforetest(create_basic_staff)
  --%throws(b.fatal_n)
  Procedure Overtime_Journal_Save_With_Another_Journal_Id;

  --%endcontext

  Procedure Create_Basic_Staff;
  Procedure Repair_Journal;
end Ut_Hpd_Api;
/
create or replace package body Ut_Hpd_Api is
  g_Staff_Id       number;
  g_Journal_Id     number;
  g_Hiring_Journal Hpd_Pref.Hiring_Journal_Rt;
  g_Limit_Journal  Hpd_Pref.Limit_Change_Journal_Rt;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Posted_Journal is
    v_Journal_Types   Array_Varchar2 := Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Business_Trip,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Vacation,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
    v_Journal_Id      number := Hpd_Next.Journal_Id;
    v_Journal_Type_Id number;
  begin
    select Jt.Journal_Type_Id
      into v_Journal_Type_Id
      from Hpd_Journal_Types Jt
     where Jt.Company_Id = Ui.Company_Id
       and Jt.Pcode member of v_Journal_Types
     order by Dbms_Random.Value()
     fetch first row only;
  
    Hpd_Api.Journal_Save(i_Company_Id               => Ui.Company_Id,
                         i_Filial_Id                => Ui.Filial_Id,
                         i_Journal_Id               => v_Journal_Id,
                         i_Journal_Type_Id          => v_Journal_Type_Id,
                         i_Journal_Number           => null,
                         i_Journal_Date             => Trunc(sysdate),
                         i_Journal_Name             => 'journal name',
                         i_Acceptable_Journal_Types => v_Journal_Types);
  
    g_Journal_Id := v_Journal_Id;
  
    z_Hpd_Journals.Update_One(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Journal_Id => g_Journal_Id,
                              i_Posted     => Option_Varchar2('Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Journal_With_Expected_Types is
    v_Journal_Types   Array_Varchar2 := Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Business_Trip,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Vacation,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
    v_Journal_Id      number := Hpd_Next.Journal_Id;
    v_Journal_Type_Id number;
  begin
    select Jt.Journal_Type_Id
      into v_Journal_Type_Id
      from Hpd_Journal_Types Jt
     where Jt.Company_Id = Ui.Company_Id
       and Jt.Pcode member of v_Journal_Types
     order by Dbms_Random.Value()
     fetch first row only;
  
    Hpd_Api.Journal_Save(i_Company_Id               => Ui.Company_Id,
                         i_Filial_Id                => Ui.Filial_Id,
                         i_Journal_Id               => v_Journal_Id,
                         i_Journal_Type_Id          => v_Journal_Type_Id,
                         i_Journal_Number           => null,
                         i_Journal_Date             => Trunc(sysdate),
                         i_Journal_Name             => 'journal name',
                         i_Acceptable_Journal_Types => v_Journal_Types);
  
    Ut.Expect(z_Hpd_Journals.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Journal_Id => v_Journal_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Journal_With_Unexpected_Types is
    v_Journal_Types   Array_Varchar2 := Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                                                       Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    v_Journal_Id      number := Hpd_Next.Journal_Id;
    v_Journal_Type_Id number;
  begin
    select Jt.Journal_Type_Id
      into v_Journal_Type_Id
      from Hpd_Journal_Types Jt
     where Jt.Company_Id = Ui.Company_Id
       and Jt.Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple,
                        Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                        Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change,
                        Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave,
                        Hpd_Pref.c_Pcode_Journal_Type_Business_Trip,
                        Hpd_Pref.c_Pcode_Journal_Type_Vacation,
                        Hpd_Pref.c_Pcode_Journal_Type_Rank_Change)
     order by Dbms_Random.Value()
     fetch first row only;
  
    Hpd_Api.Journal_Save(i_Company_Id               => Ui.Company_Id,
                         i_Filial_Id                => Ui.Filial_Id,
                         i_Journal_Id               => v_Journal_Id,
                         i_Journal_Type_Id          => v_Journal_Type_Id,
                         i_Journal_Number           => null,
                         i_Journal_Date             => Trunc(sysdate),
                         i_Journal_Name             => 'journal name',
                         i_Acceptable_Journal_Types => v_Journal_Types);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Posted_Journal is
    r_Journal       Hpd_Journals%rowtype;
    v_Journal_Types Array_Varchar2;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => g_Journal_Id);
  
    select Jt.Pcode
      bulk collect
      into v_Journal_Types
      from Hpd_Journal_Types Jt
     where Jt.Company_Id = r_Journal.Company_Id
       and Jt.Journal_Type_Id = r_Journal.Journal_Type_Id;
  
    Hpd_Api.Journal_Save(i_Company_Id               => r_Journal.Company_Id,
                         i_Filial_Id                => r_Journal.Filial_Id,
                         i_Journal_Id               => r_Journal.Journal_Id,
                         i_Journal_Type_Id          => r_Journal.Journal_Type_Id,
                         i_Journal_Number           => null,
                         i_Journal_Date             => r_Journal.Journal_Date,
                         i_Journal_Name             => r_Journal.Journal_Name,
                         i_Acceptable_Journal_Types => v_Journal_Types);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Generic_Journal is
    v_Hiring Hpd_Pref.Hiring_Rt;
    r_Page   Hpd_Journal_Pages%rowtype;
    r_Staff  Href_Staffs%rowtype;
  begin
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal);
  
    v_Hiring := g_Hiring_Journal.Hirings(1);
  
    Ut.Expect(z_Hpd_Journal_Pages.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                        i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                        i_Page_Id    => v_Hiring.Page_Id,
                                        o_Row        => r_Page)).To_Be_True();
    Ut.Expect(z_Hpd_Journal_Employees.Exist(i_Company_Id  => g_Hiring_Journal.Company_Id,
                                            i_Filial_Id   => g_Hiring_Journal.Filial_Id,
                                            i_Journal_Id  => g_Hiring_Journal.Journal_Id,
                                            i_Employee_Id => v_Hiring.Employee_Id)).To_Be_True();
    Ut.Expect(z_Hpd_Page_Robots.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                      i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                      i_Page_Id    => v_Hiring.Page_Id)).To_Be_True();
    Ut.Expect(z_Hpd_Page_Schedules.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                         i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                         i_Page_Id    => v_Hiring.Page_Id)).To_Be_True();
  
    Ut.Expect(z_Hpd_Page_Vacation_Limits.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                               i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                               i_Page_Id    => v_Hiring.Page_Id)).To_Be_True();
  
    Ut.Expect(z_Href_Staffs.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                  i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                  i_Staff_Id   => r_Page.Staff_Id,
                                  o_Row        => r_Staff)).To_Be_True();
  
    Ut.Expect(r_Staff.State).To_Equal('P');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hiring_Old_Staff is
    v_Hiring       Hpd_Pref.Hiring_Rt;
    v_Staff_Id     number;
    v_Staff_Number Href_Staffs.Staff_Number%type;
  
    v_New_Staff_Id     number;
    v_New_Staff_Number Href_Staffs.Staff_Number%type;
  begin
    v_Hiring := g_Hiring_Journal.Hirings(1);
  
    v_Staff_Id     := z_Hpd_Journal_Pages.Load(i_Company_Id => Ui.Company_Id, --
                      i_Filial_Id => Ui.Filial_Id, --
                      i_Page_Id => v_Hiring.Page_Id).Staff_Id;
    v_Staff_Number := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                      i_Filial_Id => Ui.Filial_Id, --
                      i_Staff_Id => v_Staff_Id).Staff_Number;
  
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal);
  
    v_New_Staff_Id     := z_Hpd_Journal_Pages.Load(i_Company_Id => Ui.Company_Id, --
                          i_Filial_Id => Ui.Filial_Id, --
                          i_Page_Id => v_Hiring.Page_Id).Staff_Id;
    v_New_Staff_Number := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                          i_Filial_Id => Ui.Filial_Id, --
                          i_Staff_Id => v_New_Staff_Id).Staff_Number;
  
    Ut.Expect(v_Staff_Id).To_Equal(v_New_Staff_Id);
    Ut.Expect(v_Staff_Number).To_Equal(v_New_Staff_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Removed_Staff_Hiring is
    v_Staff_Count number;
  begin
    g_Hiring_Journal.Hirings := Hpd_Pref.Hiring_Nt();
  
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal);
  
    select count(*)
      into v_Staff_Count
      from Hpd_Journal_Pages Jp
     where Jp.Company_Id = Ui.Company_Id
       and Jp.Filial_Id = Ui.Filial_Id
       and Jp.Journal_Id = g_Hiring_Journal.Journal_Id;
  
    Ut.Expect(v_Staff_Count).To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hiring_Delay_Repairing is
    v_Hiring        Hpd_Pref.Hiring_Rt;
    v_Invalid_Count number;
  begin
    v_Hiring := g_Hiring_Journal.Hirings(1);
  
    g_Hiring_Journal.Hirings := Hpd_Pref.Hiring_Nt();
  
    g_Journal_Id := g_Limit_Journal.Journal_Id;
  
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal, i_Delay_Repairing => true);
  
    Ut.Expect(z_Hpd_Journal_Pages.Exist(i_Company_Id => g_Hiring_Journal.Company_Id,
                                        i_Filial_Id  => g_Hiring_Journal.Filial_Id,
                                        i_Page_Id    => v_Hiring.Page_Id)).To_Be_True();
  
    select count(*)
      into v_Invalid_Count
      from Hpd_Journal_Pages Jp
     where Jp.Company_Id = Ui.Company_Id
       and Jp.Filial_Id = Ui.Filial_Id
       and Jp.Journal_Id = g_Hiring_Journal.Journal_Id;
  
    Ut.Expect(v_Invalid_Count).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hiring_Employment_Types is
    v_Staff_Ids  Array_Number;
    v_Staff_Kind varchar2(1);
  begin
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal);
  
    select Jp.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Hpd_Journal_Pages Jp
     where Jp.Company_Id = Ui.Company_Id
       and Jp.Filial_Id = Ui.Filial_Id
       and Jp.Journal_Id = g_Hiring_Journal.Journal_Id;
  
    v_Staff_Kind := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                    i_Filial_Id => Ui.Filial_Id, --
                    i_Staff_Id => v_Staff_Ids(1)).Staff_Kind;
  
    Ut.Expect(v_Staff_Kind).To_Equal(Href_Pref.c_Staff_Kind_Primary);
  
    v_Staff_Kind := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                    i_Filial_Id => Ui.Filial_Id, --
                    i_Staff_Id => v_Staff_Ids(2)).Staff_Kind;
  
    Ut.Expect(v_Staff_Kind).To_Equal(Href_Pref.c_Staff_Kind_Primary);
  
    v_Staff_Kind := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                    i_Filial_Id => Ui.Filial_Id, --
                    i_Staff_Id => v_Staff_Ids(3)).Staff_Kind;
  
    Ut.Expect(v_Staff_Kind).To_Equal(Href_Pref.c_Staff_Kind_Secondary);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Hiring_Wrong_Journal_Type is
  begin
    g_Hiring_Journal.Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
  
    Hpd_Api.Hiring_Journal_Save(g_Hiring_Journal);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Unsaved_Hiring_Journal is
  begin
    g_Hiring_Journal := Ut_Vhr_Util.Create_Generic_Hiring_Journal(i_Company_Id   => Ui.Company_Id,
                                                                  i_Filial_Id    => Ui.Filial_Id,
                                                                  i_Save_Journal => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Hiring_Journal is
  begin
    g_Hiring_Journal := Ut_Vhr_Util.Create_Generic_Hiring_Journal(i_Company_Id   => Ui.Company_Id,
                                                                  i_Filial_Id    => Ui.Filial_Id,
                                                                  i_Post_Journal => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Journal_Three_Employment_Types is
    v_Hiring   Hpd_Pref.Hiring_Rt;
    v_Robot    Hpd_Pref.Robot_Rt;
    v_Robot_Id number;
  
    r_Base_Robot  Mrf_Robots%rowtype;
    v_Opened_Date date;
  begin
    g_Hiring_Journal := Ut_Vhr_Util.Create_Generic_Hiring_Journal(i_Company_Id   => Ui.Company_Id,
                                                                  i_Filial_Id    => Ui.Filial_Id,
                                                                  i_Save_Journal => false);
  
    v_Hiring := g_Hiring_Journal.Hirings(1);
  
    r_Base_Robot := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Robot_Id   => v_Hiring.Robot.Robot_Id);
  
    v_Opened_Date := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id, --
                     i_Filial_Id => Ui.Filial_Id, --
                     i_Robot_Id => r_Base_Robot.Robot_Id).Opened_Date;
  
    v_Robot_Id := Ut_Vhr_Util.Create_Robot(i_Company_Id  => Ui.Company_Id,
                                           i_Filial_Id   => Ui.Filial_Id,
                                           i_Division_Id => r_Base_Robot.Division_Id,
                                           i_Job_Id      => r_Base_Robot.Job_Id,
                                           i_Opened_Date => v_Opened_Date);
  
    Hpd_Util.Robot_New(o_Robot           => v_Robot,
                       i_Robot_Id        => v_Robot_Id,
                       i_Division_Id     => r_Base_Robot.Division_Id,
                       i_Job_Id          => r_Base_Robot.Job_Id,
                       i_Rank_Id         => null,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_External_Parttime,
                       i_Fte             => 1);
  
    Hpd_Util.Journal_Add_Hiring(p_Journal              => g_Hiring_Journal,
                                i_Page_Id              => Hpd_Next.Page_Id,
                                i_Employee_Id          => Ut_Vhr_Util.Create_Employee(i_Company_Id => Ui.Company_Id,
                                                                                      i_Filial_Id  => Ui.Filial_Id),
                                i_Staff_Number         => Md_Core.Gen_Number(i_Company_Id => Ui.Company_Id,
                                                                             i_Filial_Id  => Ui.Filial_Id,
                                                                             i_Table      => Zt.Href_Staffs,
                                                                             i_Column     => z.Staff_Number),
                                i_Hiring_Date          => v_Hiring.Hiring_Date,
                                i_Trial_Period         => v_Hiring.Trial_Period,
                                i_Employment_Source_Id => v_Hiring.Employment_Source_Id,
                                i_Schedule_Id          => v_Hiring.Schedule_Id,
                                i_Vacation_Days_Limit  => v_Hiring.Vacation_Days_Limit,
                                i_Robot                => v_Robot,
                                i_Contract             => Hpd_Pref.Contract_Rt(),
                                i_Indicators           => Href_Pref.Indicator_Nt(),
                                i_Oper_Types           => Href_Pref.Oper_Type_Nt());
  
    v_Robot_Id := Ut_Vhr_Util.Create_Robot(i_Company_Id  => Ui.Company_Id,
                                           i_Filial_Id   => Ui.Filial_Id,
                                           i_Division_Id => r_Base_Robot.Division_Id,
                                           i_Job_Id      => r_Base_Robot.Job_Id,
                                           i_Opened_Date => v_Opened_Date);
  
    Hpd_Util.Robot_New(o_Robot           => v_Robot,
                       i_Robot_Id        => v_Robot_Id,
                       i_Division_Id     => r_Base_Robot.Division_Id,
                       i_Job_Id          => r_Base_Robot.Job_Id,
                       i_Rank_Id         => null,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Internal_Parttime,
                       i_Fte             => 1);
  
    Hpd_Util.Journal_Add_Hiring(p_Journal              => g_Hiring_Journal,
                                i_Page_Id              => Hpd_Next.Page_Id,
                                i_Employee_Id          => v_Hiring.Employee_Id,
                                i_Staff_Number         => Md_Core.Gen_Number(i_Company_Id => Ui.Company_Id,
                                                                             i_Filial_Id  => Ui.Filial_Id,
                                                                             i_Table      => Zt.Href_Staffs,
                                                                             i_Column     => z.Staff_Number),
                                i_Hiring_Date          => v_Hiring.Hiring_Date,
                                i_Trial_Period         => v_Hiring.Trial_Period,
                                i_Employment_Source_Id => v_Hiring.Employment_Source_Id,
                                i_Schedule_Id          => v_Hiring.Schedule_Id,
                                i_Vacation_Days_Limit  => v_Hiring.Vacation_Days_Limit,
                                i_Robot                => v_Robot,
                                i_Contract             => Hpd_Pref.Contract_Rt(),
                                i_Indicators           => Href_Pref.Indicator_Nt(),
                                i_Oper_Types           => Href_Pref.Oper_Type_Nt());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Generic_Limit_Change_Journal is
    v_Page Hpd_Pref.Page_Rt;
  begin
    Hpd_Api.Vacation_Limit_Change_Journal_Save(g_Limit_Journal);
  
    v_Page := g_Limit_Journal.Pages(1);
  
    Ut.Expect(z_Hpd_Vacation_Limit_Changes.Exist(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Journal_Id => g_Limit_Journal.Journal_Id)).To_Be_True();
    Ut.Expect(z_Hpd_Journal_Pages.Exist(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Page_Id    => v_Page.Page_Id)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Limit_Change_Removed_Staff is
    v_Page Hpd_Pref.Page_Rt;
  begin
    v_Page := g_Limit_Journal.Pages(1);
  
    g_Limit_Journal.Pages := Hpd_Pref.Page_Nt();
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(g_Limit_Journal);
  
    Ut.Expect(z_Hpd_Vacation_Limit_Changes.Exist(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Journal_Id => g_Limit_Journal.Journal_Id)).To_Be_True();
  
    Ut.Expect(z_Hpd_Journal_Pages.Exist(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Page_Id    => v_Page.Page_Id)).To_Be_False();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Limit_Delay_Repairing is
    v_Page Hpd_Pref.Page_Rt;
    r_Page Hpd_Journal_Pages%rowtype;
  begin
    v_Page := g_Limit_Journal.Pages(1);
  
    g_Limit_Journal.Pages := Hpd_Pref.Page_Nt();
  
    g_Journal_Id := g_Limit_Journal.Journal_Id;
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(g_Limit_Journal);
  
    Ut.Expect(z_Hpd_Vacation_Limit_Changes.Exist(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Journal_Id => g_Limit_Journal.Journal_Id)).To_Be_True();
  
    Ut.Expect(z_Hpd_Journal_Pages.Exist(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Page_Id    => v_Page.Page_Id,
                                        o_Row        => r_Page)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Generic_Limit_Journal is
  begin
    g_Staff_Id := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id);
  
    Hpd_Util.Limit_Change_Journal_New(o_Journal      => g_Limit_Journal,
                                      i_Company_Id   => Ui.Company_Id,
                                      i_Filial_Id    => Ui.Filial_Id,
                                      i_Journal_Id   => Hpd_Next.Journal_Id,
                                      i_Journal_Date => Ut_Vhr_Util.c_Gen_Year,
                                      i_Journal_Name => 'Test Limit Journal',
                                      i_Division_Id  => null,
                                      i_Days_Limit   => 15,
                                      i_Change_Date  => Ut_Vhr_Util.c_Gen_Year);
  
    Hpd_Util.Limit_Change_Add_Page(p_Journal  => g_Limit_Journal,
                                   i_Page_Id  => Hpd_Next.Page_Id,
                                   i_Staff_Id => g_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Saved_Limit_Journal is
  begin
    Create_Generic_Limit_Journal;
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(g_Limit_Journal);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Overtime_Journal_Save_With_Correct_Datas is
    v_Journal     Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes   Hpd_Pref.Overtime_Nt := Hpd_Pref.Overtime_Nt();
    v_Journal_Id  number := Hpd_Next.Journal_Id;
    v_Overtime_Id number := Hpd_Next.Overtime_Id;
    v_Date        date := Trunc(sysdate);
  begin
    Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                  i_Company_Id       => Ui.Company_Id,
                                  i_Filial_Id        => Ui.Filial_Id,
                                  i_Journal_Id       => v_Journal_Id,
                                  i_Journal_Date     => v_Date,
                                  i_Journal_Name     => 'Test Journal Name (' || v_Journal_Id || ')');
  
    Hpd_Util.Overtime_Add(p_Overtimes        => v_Overtimes,
                          i_Overtime_Date    => v_Date,
                          i_Overtime_Seconds => 200);
  
    Hpd_Util.Journal_Add_Overtime(p_Journal     => v_Journal,
                                  i_Staff_Id    => g_Staff_Id,
                                  i_Month       => Trunc(sysdate, 'mm'),
                                  i_Overtime_Id => v_Overtime_Id,
                                  i_Overtimes   => v_Overtimes);
  
    Hpd_Api.Overtime_Journal_Save(v_Journal);
  
    Ut.Expect(z_Hpd_Journals.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Journal_Id => v_Journal_Id)).To_Be_True();
    Ut.Expect(z_Hpd_Journal_Overtimes.Exist(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Overtime_Id => v_Overtime_Id)).To_Be_True();
    Ut.Expect(z_Hpd_Overtime_Days.Exist(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Id      => g_Staff_Id,
                                        i_Overtime_Date => v_Date)).To_Be_True();
    Ut.Expect(z_Hpd_Journal_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Journal_Id  => v_Journal_Id,
                                            i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                                                                       i_Filial_Id  => Ui.Filial_Id,
                                                                                       i_Staff_Id   => g_Staff_Id))).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_Save_With_Another_Journal_Id is
    v_Journal     Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes   Hpd_Pref.Overtime_Nt := Hpd_Pref.Overtime_Nt();
    v_Overtime_Id number := Hpd_Next.Overtime_Id;
    v_Date        date := Trunc(sysdate);
  begin
    z_Hpd_Journal_Overtimes.Insert_One(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Overtime_Id => v_Overtime_Id,
                                       i_Journal_Id  => Hpd_Next.Journal_Id,
                                       i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id,
                                                                                  i_Staff_Id   => g_Staff_Id),
                                       i_Staff_Id    => g_Staff_Id,
                                       i_Begin_Date  => sysdate,
                                       i_End_Date    => sysdate + 1 / 24);
  
    Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                  i_Company_Id       => Ui.Company_Id,
                                  i_Filial_Id        => Ui.Filial_Id,
                                  i_Journal_Id       => Hpd_Next.Journal_Id,
                                  i_Journal_Date     => v_Date,
                                  i_Journal_Name     => 'Test Journal Name');
  
    Hpd_Util.Overtime_Add(p_Overtimes        => v_Overtimes,
                          i_Overtime_Date    => v_Date,
                          i_Overtime_Seconds => 200);
  
    Hpd_Util.Journal_Add_Overtime(p_Journal     => v_Journal,
                                  i_Staff_Id    => g_Staff_Id,
                                  i_Month       => Trunc(sysdate, 'mm'),
                                  i_Overtime_Id => v_Overtime_Id,
                                  i_Overtimes   => v_Overtimes);
  
    Hpd_Api.Overtime_Journal_Save(v_Journal);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Staff is
  begin
    g_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Repair_Journal is
  begin
    Hpd_Api.Journal_Repairing(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Journal_Id => g_Journal_Id);
  end;

end Ut_Hpd_Api;
/
