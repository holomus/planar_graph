create or replace package Ut_Hlic_Core is
  --%suite
  --%suitepath(vhr.hlic.hlic_core)
  --%beforeall(create_filial)
  --%beforeeach(context_begin)
  --%aftereach(biruni_route.context_end)

  --%context(revise license by dirty staffs)
  --%beforeall(create_staff)

  --%test(revise nonexistent staff)
  --%throws(b.fatal_n)
  Procedure Revise_Nonexistent_Staff;

  --%context(interval not exists)
  --%beforeall(create_license_balance_and_license_lock_holders_when_no_interval)

  --%test(staff passive)
  --%beforetest(make_no_interval_staff_passive)
  Procedure No_Interval_Staff_Passive;

  --%test(hire date before max gen date)
  --%beforetest(make_no_interval_hire_before_max_date)
  Procedure No_Interval_Hire_Before_Max_Date;

  --%test(hire date after max gen date)
  --%beforetest(make_no_interval_hire_after_max_date)
  Procedure No_Interval_Hire_After_Max_Date;

  --%test(dismissal date before max gen date)
  --%beforetest(make_no_internal_dismissal_before_max_date)
  Procedure No_Interval_Dismissal_Before_Max_Date;

  --%test(dismissal date on max gen date)
  --%beforetest(make_no_interval_dismissal_on_max_date)
  Procedure No_Interval_Dismissal_On_Max_Date;

  --%test(dismissal date after max gen date)
  --%beforetest(make_no_interval_dismissal_after_max_date)
  Procedure No_Interval_Dismissal_After_Max_Date;

  --%endcontext

  --%context(interval exists)
  --%beforeall(create_interval_and_dates)

  --%test(staff no change)
  --%beforetest(make_interval_staff_no_change)
  Procedure Interval_Staff_No_Change;

  --%test(dismissal after max gen)
  --%beforetest(make_interval_dismissal_after_max_gen)
  Procedure Interval_Dismissal_After_Max_Gen;

  --%test(dismissal before max gen)
  --%beforetest(make_interval_dismissal_before_max_gen)
  Procedure Interval_Dismissal_Before_Max_Gen;

  --%test(hire before interval begin)
  --%beforetest(make_interval_hire_before_interval_begin)
  Procedure Interval_Hire_Before_Interval_Begin;

  --%test(hire after interval begin)
  --%beforetest(make_interval_hire_after_interval_begin)
  Procedure Interval_Hire_After_Interval_Begin;

  --%test(hire after interval begin dismissal before max gen date)
  --%beforetest(make_interval_hire_after_dismissal_before)
  Procedure Interval_Hire_After_Dismissal_Before;

  --%test(hire before interval begin dismissal before max gen date)
  --%beforetest(make_interval_hire_before_dismissal_before)
  Procedure Interval_Hire_Before_Dismissal_Before;

  --%test(hire after interval begin dismissal after max gen date)
  --%beforetest(make_interval_hire_after_dismissal_after)
  Procedure Interval_Hire_After_Dismissal_After;

  --%test(hire and dismissal before interval begin)
  --%beforetest(make_interval_hire_and_dismissal_before_interval_begin)
  Procedure Interval_Hire_And_Dismissal_Before_Interval_Begin;

  --%test(hire and dismissal after interval begin)
  --%beforetest(make_interval_hire_and_dismissal_after_max_date)
  Procedure Interval_Hire_And_Dismissal_After_Max_Date;

  --%test(interval exists staff passive)
  --%beforetest(make_interval_exists_staff_passive)  
  Procedure Interval_Exists_Staff_Passive;

  --%test(hire same as interval begin date no dismissal date)
  --%beforetest(make_interval_hire_same_no_dismissal)
  Procedure Interval_Hire_Same_No_Dismissal;

  --%test(hire after interval begin date no dismissal date)
  --%beforetest(make_interval_hire_after_no_dismissal)
  Procedure Interval_Hire_After_No_Dismissal;

  --%test(hire before interval begin date no dismissal date)
  --%beforetest(make_interval_hire_before_no_dismissal)
  Procedure Interval_Hire_Before_No_Dismissal;

  --%test(same person exists in another filial hire after interval begin date)
  --%beforetest(make_interval_hire_after_no_dismissal_exists_employee_another_filial)
  --%aftertest(cleanup_second_interval)
  Procedure Interval_Hire_After_No_Dismissal_Exists_Employee_Another_Filial;

  --%endcontext

  --%endcontext

  --%context(generate required dates)
  --%beforeall(create_interval)

  --%test(generate nonexistent interval)
  --%throws(b.fatal_n)
  Procedure Generate_Nonexistent_Interval;

  --%test(generate stopped interval)
  --%beforetest(make_stopped_interval)
  Procedure Generate_Stopped_Interval;

  --%test(generate interval start date before max gen date)
  --%beforetest(make_interval_start_date_before_max_date)
  Procedure Interval_Start_Date_Before_Max_Date;

  --%test(generate interval start date on max date)
  --%beforetest(make_interval_start_date_on_max_date)
  Procedure Interval_Start_Date_On_Max_Date;

  --%test(generate interval start date after max date)
  --%beforetest(make_interval_start_date_after_max_date)
  Procedure Interval_Start_Date_After_Max_Date;

  --%test(generate interval where required date exists before max gen date)
  --%beforetest(make_interval_required_date_exists_before_max_date)
  Procedure Interval_Required_Date_Exists_Before_Max_Date;

  --%test(generate interval where required date exists after max gen date)
  --%beforetest(make_interval_required_date_exists_after_max_date)
  Procedure Interval_Required_Date_Exists_After_Max_Date;

  --%test(generate interval where required date exists on max gen date)
  --%beforetest(make_interval_required_date_exists_on_max_date)
  Procedure Interval_Required_Date_Exists_On_Max_Date;

  --%endcontext

  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Interval;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Interval_And_Dates;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_License_Balance_And_License_Lock_Holders_When_No_Interval;
  ----------------------------------------------------------------------------------------------------
  Procedure Cleanup_Second_Interval;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Staff_Passive;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Hire_Before_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Hire_After_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Internal_Dismissal_Before_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Dismissal_On_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Dismissal_After_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Staff_No_Change;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Dismissal_After_Max_Gen;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Dismissal_Before_Max_Gen;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_Interval_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Interval_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Dismissal_Before;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_Dismissal_Before;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Dismissal_After;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_And_Dismissal_Before_Interval_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_And_Dismissal_After_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Exists_Staff_Passive;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Same_No_Dismissal;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_No_Dismissal;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_No_Dismissal;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_No_Dismissal_Exists_Employee_Another_Filial;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Stopped_Interval;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_Before_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_On_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_After_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_Before_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_After_Max_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_On_Max_Date;
end Ut_Hlic_Core;
/
create or replace package body Ut_Hlic_Core is
  g_Filial_Id          number;
  g_Second_Interval_Id number;
  g_Staff              Href_Staffs%rowtype;
  g_Interval           Hlic_Required_Intervals%rowtype;
  g_Assert_Interval    Hlic_Required_Intervals%rowtype;
  g_Max_Gen_Date       date := Hlic_Util.Max_License_Generate_Date;

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
  Procedure Create_Staff is
  begin
    g_Staff.Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                                 i_Filial_Id  => Ui.Filial_Id);
  
    g_Staff := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Staff_Id   => g_Staff.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_License_Balance_And_License_Lock_Holders
  (
    i_Begin_Date      date,
    i_End_Date        date,
    i_Interval_Exists boolean := false
  ) is
    v_Curr_Date       date := i_Begin_Date;
    v_Required_Amount number := 0;
  begin
    z_Kl_License_Lock_Holders.Insert_One(i_Company_Id => g_Staff.Company_Id,
                                         i_Holder_Id  => g_Staff.Employee_Id);
  
    if i_Interval_Exists then
      v_Required_Amount := 1;
    end if;
  
    while v_Curr_Date <= i_End_Date
    loop
      z_Kl_License_Balances.Save_One(i_Company_Id       => g_Staff.Company_Id,
                                     i_License_Code     => Hlic_Pref.c_License_Code_Hrm_Base,
                                     i_Balance_Date     => v_Curr_Date,
                                     i_Available_Amount => 0,
                                     i_Used_Amount      => 0,
                                     i_Required_Amount  => v_Required_Amount);
      if i_Interval_Exists then
        z_Kl_License_Holders.Insert_One(i_Company_Id   => g_Staff.Company_Id,
                                        i_License_Code => Hlic_Pref.c_License_Code_Hrm_Base,
                                        i_Hold_Date    => v_Curr_Date,
                                        i_Holder_Id    => g_Staff.Employee_Id,
                                        i_Licensed     => 'N');
      end if;
    
      v_Curr_Date := v_Curr_Date + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_License_Balance_And_License_Lock_Holders_When_No_Interval is
  begin
    Create_License_Balance_And_License_Lock_Holders(g_Max_Gen_Date - 5, g_Max_Gen_Date + 5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Interval_And_Dates is
    v_Gen_Date date;
  begin
    z_Hlic_Required_Intervals.Init(p_Row         => g_Interval,
                                   i_Company_Id  => g_Staff.Company_Id,
                                   i_Filial_Id   => g_Staff.Filial_Id,
                                   i_Interval_Id => Hlic_Next.Interval_Id,
                                   i_Staff_Id    => g_Staff.Staff_Id,
                                   i_Employee_Id => g_Staff.Employee_Id,
                                   i_Start_Date  => g_Max_Gen_Date -
                                                    Hlic_Pref.c_Count_Days_Need_To_Generate,
                                   i_Finish_Date => null,
                                   i_Status      => Hlic_Pref.c_Interval_Status_Continue);
  
    z_Hlic_Required_Intervals.Insert_Row(g_Interval);
  
    v_Gen_Date := g_Interval.Start_Date;
  
    while v_Gen_Date <= g_Max_Gen_Date
    loop
      z_Hlic_Required_Dates.Insert_One(i_Company_Id    => g_Interval.Company_Id,
                                       i_Filial_Id     => g_Interval.Filial_Id,
                                       i_Interval_Id   => g_Interval.Interval_Id,
                                       i_Required_Date => v_Gen_Date,
                                       i_Employee_Id   => g_Interval.Employee_Id,
                                       i_Staff_Id      => g_Interval.Staff_Id);
    
      v_Gen_Date := v_Gen_Date + 1;
    end loop;
  
    Create_License_Balance_And_License_Lock_Holders(g_Interval.Start_Date, --
                                                    g_Max_Gen_Date,
                                                    true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Interval is
  begin
    Create_Staff;
  
    z_Hlic_Required_Intervals.Init(p_Row         => g_Interval,
                                   i_Company_Id  => g_Staff.Company_Id,
                                   i_Filial_Id   => g_Staff.Filial_Id,
                                   i_Interval_Id => Hlic_Next.Interval_Id,
                                   i_Staff_Id    => g_Staff.Staff_Id,
                                   i_Employee_Id => g_Staff.Employee_Id,
                                   i_Start_Date  => g_Max_Gen_Date,
                                   i_Finish_Date => null,
                                   i_Status      => Hlic_Pref.c_Interval_Status_Continue);
  
    z_Hlic_Required_Intervals.Insert_Row(g_Interval);
  
    Create_License_Balance_And_License_Lock_Holders(g_Max_Gen_Date, g_Max_Gen_Date, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Interval is
  begin
    select *
      into g_Assert_Interval
      from Hlic_Required_Intervals p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff.Staff_Id;
  exception
    when No_Data_Found then
      g_Assert_Interval := null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Holders
  (
    i_Period_Begin date,
    i_Period_End   date
  ) is
    v_Total_Hold_Dates_Cnt   number;
    v_Tracked_Hold_Dates_Cnt number;
  begin
    select count(*),
           count(case
                    when p.Hold_Date between i_Period_Begin and i_Period_End then
                     1
                    else
                     null
                  end)
      into v_Total_Hold_Dates_Cnt, v_Tracked_Hold_Dates_Cnt
      from Kl_License_Holders p
     where p.Company_Id = Ui.Company_Id
       and p.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and p.Holder_Id = g_Staff.Employee_Id;
  
    Ut.Expect(v_Total_Hold_Dates_Cnt).To_Equal(v_Tracked_Hold_Dates_Cnt);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Assert_Balances_And_Holders is
    v_Period_Begin    date := g_Assert_Interval.Start_Date;
    v_Period_End      date := Nvl(g_Assert_Interval.Finish_Date, g_Max_Gen_Date);
    r_Second_Interval Hlic_Required_Intervals%rowtype;
  begin
    if g_Second_Interval_Id is not null then
      r_Second_Interval := z_Hlic_Required_Intervals.Load(i_Company_Id  => Ui.Company_Id,
                                                          i_Interval_Id => g_Second_Interval_Id);
    
      v_Period_Begin := Least(v_Period_Begin, r_Second_Interval.Start_Date);
      v_Period_End   := Greatest(v_Period_End, Nvl(r_Second_Interval.Finish_Date, g_Max_Gen_Date));
    end if;
  
    Assert_Holders(v_Period_Begin, v_Period_End);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Required_Dates(i_Zero_Dates boolean := false) is
    v_Total_Required_Cnt number;
    v_Required_Cnt       number;
  begin
    select count(*),
           count(case
                    when p.Required_Date between g_Assert_Interval.Start_Date and
                         Nvl(g_Assert_Interval.Finish_Date, g_Max_Gen_Date) then
                     1
                    else
                     null
                  end)
      into v_Total_Required_Cnt, v_Required_Cnt
      from Hlic_Required_Dates p
     where p.Company_Id = g_Assert_Interval.Company_Id
       and p.Interval_Id = g_Assert_Interval.Interval_Id;
  
    if i_Zero_Dates then
      v_Required_Cnt := 0;
    end if;
  
    Ut.Expect(v_Total_Required_Cnt).To_Equal(v_Required_Cnt);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Required_Interval_And_Dates is
  begin
    Load_Interval;
  
    Ut.Expect(g_Assert_Interval.Company_Id).To_Be_Not_Null;
  
    Ut.Expect(g_Assert_Interval.Start_Date).To_Equal(g_Staff.Hiring_Date);
    if g_Staff.Dismissal_Date is null then
      Ut.Expect(g_Assert_Interval.Finish_Date).To_Be_Null();
    else
      Ut.Expect(g_Assert_Interval.Finish_Date).To_Equal(g_Staff.Dismissal_Date);
    end if;
  
    Assert_Required_Dates;
  
    Assert_Balances_And_Holders;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Required_Interval_No_Exists is
  begin
    Load_Interval;
  
    Ut.Expect(g_Assert_Interval.Company_Id).To_Be_Null;
  
    Ut.Expect(g_Assert_Interval.Start_Date).To_Be_Null();
    Ut.Expect(g_Assert_Interval.Finish_Date).To_Be_Null();
  
    Assert_Required_Dates(true);
  
    Assert_Balances_And_Holders;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Generated_Interval(i_Required_Days_Cnt number) is
    v_Total_Days_Cnt number;
  begin
    Load_Interval;
  
    select count(*)
      into v_Total_Days_Cnt
      from Hlic_Required_Dates p
     where p.Company_Id = g_Assert_Interval.Company_Id
       and p.Interval_Id = g_Assert_Interval.Interval_Id;
  
    Ut.Expect(v_Total_Days_Cnt).To_Equal(i_Required_Days_Cnt);
  
    Assert_Balances_And_Holders;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cleanup_Second_Interval is
  begin
    g_Second_Interval_Id := null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Nonexistent_Staff is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(Href_Next.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Staff_Passive is
  begin
    g_Staff.State := 'P';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Staff_Passive is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_No_Exists;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Hire_Before_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date - 1;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Hire_Before_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Hire_After_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date + 1;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Hire_After_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Internal_Dismissal_Before_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date - 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date - 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Dismissal_Before_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Dismissal_On_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date - 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Dismissal_On_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_No_Interval_Dismissal_After_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date - 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date + 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Interval_Dismissal_After_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Staff_No_Change is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Staff_No_Change is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Dismissal_After_Max_Gen is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date;
    g_Staff.Dismissal_Date := g_Max_Gen_Date + 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Dismissal_After_Max_Gen is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Dismissal_Before_Max_Gen is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date;
    g_Staff.Dismissal_Date := g_Max_Gen_Date - 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Dismissal_Before_Max_Gen is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_Interval_Begin is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date - 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_Before_Interval_Begin is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Interval_Begin is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date + 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_After_Interval_Begin is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Dismissal_Before is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date + 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date - 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_After_Dismissal_Before is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_Dismissal_Before is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date - 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date - 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_Before_Dismissal_Before is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_Dismissal_After is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date + 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date + 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_After_Dismissal_After is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_And_Dismissal_Before_Interval_Begin is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date - 2;
    g_Staff.Dismissal_Date := g_Interval.Start_Date - 1;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_And_Dismissal_Before_Interval_Begin is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_And_Dismissal_After_Max_Date is
  begin
    g_Staff.Hiring_Date    := g_Max_Gen_Date + 1;
    g_Staff.Dismissal_Date := g_Max_Gen_Date + 2;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_And_Dismissal_After_Max_Date is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Exists_Staff_Passive is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'P';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Exists_Staff_Passive is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_No_Exists;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Same_No_Dismissal is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_Same_No_Dismissal is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_After_No_Dismissal is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date + 1;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_After_No_Dismissal is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Hire_Before_No_Dismissal is
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date - 1;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_Before_No_Dismissal is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Make_Interval_Hire_After_No_Dismissal_Exists_Employee_Another_Filial is
    v_Filial_Id number;
    v_Staff_Id  number;
  begin
    g_Staff.Hiring_Date    := g_Interval.Start_Date + 2;
    g_Staff.Dismissal_Date := null;
    g_Staff.State          := 'A';
  
    z_Href_Staffs.Update_Row(g_Staff);
  
    v_Filial_Id := Ut_Vhr_Util.Create_Filial(i_Company_Id => g_Staff.Company_Id,
                                             i_Name       => 'Another Test Filial');
  
    v_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id  => g_Staff.Company_Id,
                                                           i_Filial_Id   => v_Filial_Id,
                                                           i_Employee_Id => g_Staff.Employee_Id);
  
    g_Second_Interval_Id := Hlic_Next.Interval_Id;
  
    z_Hlic_Required_Intervals.Insert_One(i_Company_Id  => g_Staff.Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Interval_Id => g_Second_Interval_Id,
                                         i_Staff_Id    => v_Staff_Id,
                                         i_Employee_Id => g_Interval.Employee_Id,
                                         i_Start_Date  => g_Interval.Start_Date + 1,
                                         i_Finish_Date => g_Interval.Start_Date + 1,
                                         i_Status      => Hlic_Pref.c_Interval_Status_Stop);
  
    z_Hlic_Required_Dates.Insert_One(i_Company_Id    => g_Staff.Company_Id,
                                     i_Filial_Id     => v_Filial_Id,
                                     i_Interval_Id   => g_Second_Interval_Id,
                                     i_Required_Date => g_Interval.Start_Date + 1,
                                     i_Employee_Id   => g_Interval.Employee_Id,
                                     i_Staff_Id      => v_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Hire_After_No_Dismissal_Exists_Employee_Another_Filial is
  begin
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Staff_Ids  => Array_Number(g_Staff.Staff_Id));
  
    Assert_Required_Interval_And_Dates;
  
    Ut.Expect(z_Hlic_Required_Dates.Exist(i_Company_Id    => g_Interval.Company_Id,
                                          i_Interval_Id   => g_Second_Interval_Id,
                                          i_Required_Date => g_Interval.Start_Date + 1)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Nonexistent_Interval is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => Hlic_Next.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Stopped_Interval is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date;
    g_Interval.Finish_Date := g_Max_Gen_Date;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Stop;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Stopped_Interval is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_Before_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date - 1;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Start_Date_Before_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_On_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Start_Date_On_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Start_Date_After_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date + 1;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  
    z_Kl_License_Holders.Delete_One(i_Company_Id   => g_Interval.Company_Id,
                                    i_License_Code => Hlic_Pref.c_License_Code_Hrm_Base,
                                    i_Hold_Date    => g_Max_Gen_Date,
                                    i_Holder_Id    => g_Interval.Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Start_Date_After_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_Before_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date - 1;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  
    z_Hlic_Required_Dates.Insert_One(i_Company_Id    => g_Interval.Company_Id,
                                     i_Filial_Id     => g_Interval.Filial_Id,
                                     i_Interval_Id   => g_Interval.Interval_Id,
                                     i_Required_Date => g_Max_Gen_Date - 1,
                                     i_Employee_Id   => g_Interval.Employee_Id,
                                     i_Staff_Id      => g_Interval.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Required_Date_Exists_Before_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_After_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date - 1;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  
    z_Hlic_Required_Dates.Insert_One(i_Company_Id    => g_Interval.Company_Id,
                                     i_Filial_Id     => g_Interval.Filial_Id,
                                     i_Interval_Id   => g_Interval.Interval_Id,
                                     i_Required_Date => g_Max_Gen_Date + 1,
                                     i_Employee_Id   => g_Interval.Employee_Id,
                                     i_Staff_Id      => g_Interval.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Required_Date_Exists_After_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Interval_Required_Date_Exists_On_Max_Date is
  begin
    g_Interval.Start_Date  := g_Max_Gen_Date - 1;
    g_Interval.Finish_Date := null;
    g_Interval.Status      := Hlic_Pref.c_Interval_Status_Continue;
  
    z_Hlic_Required_Intervals.Update_Row(g_Interval);
  
    z_Hlic_Required_Dates.Insert_One(i_Company_Id    => g_Interval.Company_Id,
                                     i_Filial_Id     => g_Interval.Filial_Id,
                                     i_Interval_Id   => g_Interval.Interval_Id,
                                     i_Required_Date => g_Max_Gen_Date,
                                     i_Employee_Id   => g_Interval.Employee_Id,
                                     i_Staff_Id      => g_Interval.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Required_Date_Exists_On_Max_Date is
  begin
    Hlic_Core.Generate_Required_Dates(i_Company_Id    => Ui.Company_Id,
                                      i_Interval_Id   => g_Interval.Interval_Id,
                                      i_Last_Gen_Date => g_Max_Gen_Date);
    Assert_Generated_Interval(1);
  end;

end Ut_Hlic_Core;
/
