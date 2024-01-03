create or replace package Ut_Hpd_Core is
  --%suite(hpd_core)
  --%suitepath(vhr.hpd.hpd_core)
  --%beforeall(create_filial)
  --%beforeeach(context_begin)
  --%aftereach(biruni_route.context_end)

  --%context(generic journal post tests)

  --%test(post posted journal)
  --%beforetest(create_posted_journal)
  --%throws(b.error_n)
  Procedure Post_Posted_Journal;

  --%test(post nonexistent journal)
  --%throws(b.fatal_n)
  Procedure Post_Nonexistent_Journal;

  --%test(Post journal with nonexistent pcode)
  --%beforetest(create_journal_nonexistent_pcode)
  --%throws(b.fatal_n)
  Procedure Post_Journal_Nonexistent_Pcode;

  --%endcontext

  --%context(vacation limit change journal post)

  --%test(post vacation limit change journal)
  --%beforetest(create_vacation_limit_change_journal)
  Procedure Post_Vacation_Limit_Journal;

  --%endcontext

  --%context(evaluate vacation limit changes)

  --%test(evaluate three limit changes on several dates)
  --%beforetest(create_limit_changes_three_dates)
  Procedure Evaluate_Limit_Changes_Three_Dates;

  --%test(evaluate limit changes when staff was hired inside year)
  --%beforetest(create_limit_changes_inside_year)
  Procedure Evaluate_Limit_Changes_Inside_Year;

  --%test(evaluate two limit changes after removal of third)
  --%beforetest(create_limit_changes_three_dates_for_removal)
  Procedure Evaluate_Limit_Changes_Three_Dates_With_Removal;

  --%test(evaluate limit changes inserted in two different years)
  --%beforetest(create_limit_changes_three_dates_two_years)
  Procedure Evaluate_Limit_Changes_Two_Years;

  --%test(evaluate two limit changes in two different years after removal of third)
  --%beforetest(create_limit_changes_two_years_for_removal)
  Procedure Evaluate_Limit_Changes_Two_Years_With_Removal;

  --%test(evaluate limit change inserted after vacation)
  --%beforetest(create_limit_change_after_vacation)
  Procedure Evaluate_Limit_Change_After_Vacation;

  --%test(evaluate removed limit change with inserted after vacation)
  --%beforetest(create_limit_change_after_vacation_for_removal)
  --%throws(b.error_n)
  Procedure Evaluate_Limit_Change_After_Vacation_With_Removal;

  --%test(evaluate vacation turnover with all journals unposted)
  --%beforetest(create_unposted_journals)
  Procedure Evaluate_Limit_Changes_All_Unpost;

  --%endcontext

  --%context(agreements fill)
  --%beforeall(create_staff_no_agreements, insert_journal, insert_page, create_hiring_trans)
  --%beforeeach(clear_agreement_dates)

  --%context(agreements with only hiring)

  --%test(agreement fill before hiring)
  --%beforetest(create_agreement_fill_before_hiring)
  Procedure Agreement_Fill_Before_Hiring;

  --%test(agreement fill after hiring)  
  Procedure Agreement_Fill_After_Hiring;

  --%test(agreement fill on hiring)  
  Procedure Agreement_Fill_On_Hiring;

  --%endcontext

  --%context(agreements with transfer trans)
  --%beforeall(create_transfer_trans)

  --%test(agreeement fill before transfer)
  --%beforetest(create_agreement_fill_before_transfer)
  Procedure Agreement_Fill_Before_Transfer;

  --%test(agreeement fill after transfer)  
  Procedure Agreement_Fill_After_Transfer;

  --%test(agreeement fill on transfer)  
  Procedure Agreement_Fill_On_Transfer;

  --%test(agreement fill transfer on hiring)
  --%beforetest(create_agreement_fill_transfer_on_hiring)
  Procedure Agreement_Fill_Transfer_On_Hiring;

  --%context(second trans with end date)
  --%beforeall(create_second_transfer_with_end_date)

  --%test(agreement fill between second transfer)
  --%beforetest(create_agreement_fill_between_second_transfer)
  Procedure Agreement_Fill_Between_Second_Transfer;

  --%test(agreement fill before second transfer)
  --%beforetest(create_agreement_fill_before_second_transfer)
  Procedure Agreement_Fill_Before_Second_Transfer;

  --%test(agreement fill after second transfer)
  Procedure Agreement_Fill_After_Second_Transfer;

  --%endcontext

  --%endcontext

  --%context(agreements with transfers trans with end date)
  --%beforeall(create_trans_with_end_date)

  --%test(agreement fill before transfer with end)
  --%beforetest(create_agreement_fill_before_transfer_with_end)
  Procedure Agreement_Fill_Before_Transfer_With_End;

  --%test(agreement fill between transfer with end)  
  Procedure Agreement_Fill_Between_Transfer_With_End;

  --%test(agreement fill after transfer with end)
  Procedure Agreement_Fill_After_Transfer_With_End;

  --%test(agreement fill on transfer with end)
  --%beforetest(create_agreement_fill_on_transfer_with_end_to_be_intergrated)
  Procedure Agreement_Fill_On_Transfer_With_End_To_Be_Intergrated;

  --%context(agreement with two transfers, second transfer is open)
  --%beforeall(create_agreement_fill_second_transfer_between_first)

  --%test(agreement fill between second transfer between first traanfer)
  Procedure Agreement_Fill_Between_Second_Transfer_Between_First;

  --%test(agreement fill on second transfer between first traanfer)
  --%beforetest(create_agreement_fill_on_second_transfer_between_first)
  Procedure Agreement_Fill_On_Second_Transfer_Between_First;

  --%test(agreement fill on second transfer on first traanfer)
  --%beforetest(create_agreement_fill_second_transfer_start_as_first)
  Procedure Agreement_Fill_On_Second_Transfer_Start_As_First;

  --%test(agreement fill before second transfer on first traanfer)
  --%beforetest(create_agreement_fill_second_transfer_start_as_first)
  Procedure Agreement_Fill_Before_Second_Transfer_Start_As_First;

  --%test(agreement fill after second transfer on first traanfer)
  --%beforetest(create_agreement_fill_after_second_transfer_start_as_first)
  Procedure Agreement_Fill_After_Second_Transfer_Start_As_First;

  --%endcontext

  --%endcontext

  --%context(agreements with stopped transactions)
  --%beforeall(create_stopped_transaction)

  --%test(agreement fill before transfer after stopped trans)
  --%beforetest(create_agreement_fill_transfer_after_stopped_trans, create_trans_after_stopped_trans)
  --%throws(b.error_n)
  Procedure Agreement_Fill_Before_Transfer_After_Stopped_Trans;

  --%test(agreement fill on transfer after stopped trans)
  --%beforetest(create_agreement_fill_transfer_after_stopped_trans, create_trans_after_stopped_trans)
  --%throws(b.error_n) 
  Procedure Agreement_Fill_On_Transfer_After_Stopped_Trans;

  --%test(agreement fill after transfer after stopped trans)
  --%beforetest(create_trans_after_stopped_trans)
  --%throws(b.error_n) 
  Procedure Agreement_Fill_After_Transfer_After_Stopped_Trans;

  --%test(agreement fill on stopped trans with transfer with end date)
  --%beforetest(create_agreement_fill_before_stopped_trans_with_transfer_with_end_date)
  Procedure Agreement_Fill_On_Stopped_Trans_With_Transfer_With_End_Date;

  --%endcontext

  --%endcontext

  --%context(overtime)
  --%beforeall(create_staff_no_agreements)

  --%test(overtime journal post with enoughly free time)
  Procedure Overtime_Journal_Post_With_Enoughly_Free_Time;

  --%test(overtime journal post with not enough free time)
  --%throws(b.error_n)
  Procedure Overtime_Journal_Post_With_Not_Enough_Free_Time;

  --%test(overtime journal post without timesheet facts)
  --%throws(b.error_n)
  Procedure Overtime_Journal_Post_Without_Timesheet_Facts;

  --%endcontext
  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Staff_No_Agreements;
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Journal;
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Page;
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Transaction
  (
    i_Begin_Date date,
    i_End_Date   date := null,
    i_Order_No   number,
    i_Action     varchar2 := Hpd_Pref.c_Transaction_Action_Continue,
    i_Event      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Agreement
  (
    i_Period date,
    i_Action varchar2 := Hpd_Pref.c_Transaction_Action_Continue
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Journal_Nonexistent_Pcode;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Posted_Journal;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Vacation_Limit_Change_Journal;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Changes_Three_Dates;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Changes_Inside_Year;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Changes_Three_Dates_For_Removal;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Changes_Three_Dates_Two_Years;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Changes_Two_Years_For_Removal;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Change_After_Vacation;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Limit_Change_After_Vacation_For_Removal;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Create_Unposted_Journals;
  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Agreement_Dates;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Hiring_Trans;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Hiring;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Transfer_Trans;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Transfer;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Transfer_On_Hiring;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Second_Transfer_With_End_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Between_Second_Transfer;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Second_Transfer;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Trans_With_End_Date;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Transfer_With_End;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_On_Transfer_With_End_To_Be_Intergrated;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Second_Transfer_Between_First;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_On_Second_Transfer_Between_First;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Second_Transfer_Start_As_First;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_After_Second_Transfer_Start_As_First;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Stopped_Transaction;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Transfer_After_Stopped_Trans;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Trans_After_Stopped_Trans;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Stopped_Trans_With_Transfer_With_End_Date;
end Ut_Hpd_Core;
/
create or replace package body Ut_Hpd_Core is
  g_Staff_Id         number;
  g_Filial_Id        number;
  g_Journal_Id       number;
  g_Page_Id          number;
  g_Trans_Id         number;
  g_Stopped_Trans_Id number;
  g_Vacation_Limit   number;
  g_Posted_Date      date;
  g_Agreement_Dates  Array_Date;

  ----------------------------------------------------------------------------------------------------
  c_Default_Test_Trans_Type constant varchar2(1) := Hpd_Pref.c_Transaction_Type_Robot;

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
  Procedure Create_Staff_No_Agreements is
  begin
    g_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id      => Ui.Company_Id,
                                                           i_Filial_Id       => Ui.Filial_Id,
                                                           i_With_Agreements => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Journal is
  begin
    g_Journal_Id := Hpd_Next.Journal_Id;
  
    z_Hpd_Journals.Insert_One(i_Company_Id      => Ui.Company_Id,
                              i_Filial_Id       => Ui.Filial_Id,
                              i_Journal_Id      => g_Journal_Id,
                              i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                            i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                              i_Journal_Number  => 'Test Journal',
                              i_Journal_Date    => Trunc(sysdate),
                              i_Journal_Name    => 'Test Journal',
                              i_Posted          => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Page is
    v_Employee_Id number;
  begin
    g_Page_Id := Hpd_Next.Page_Id;
  
    v_Employee_Id := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                     i_Filial_Id => Ui.Filial_Id, --
                     i_Staff_Id => g_Staff_Id).Employee_Id;
  
    z_Hpd_Journal_Pages.Insert_One(i_Company_Id  => Ui.Company_Id,
                                   i_Filial_Id   => Ui.Filial_Id,
                                   i_Journal_Id  => g_Journal_Id,
                                   i_Page_Id     => g_Page_Id,
                                   i_Employee_Id => v_Employee_Id,
                                   i_Staff_Id    => g_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Transaction
  (
    i_Begin_Date date,
    i_End_Date   date := null,
    i_Order_No   number,
    i_Action     varchar2 := Hpd_Pref.c_Transaction_Action_Continue,
    i_Event      varchar2
  ) is
  begin
    g_Trans_Id := Hpd_Next.Trans_Id;
  
    z_Hpd_Transactions.Insert_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Staff_Id   => g_Staff_Id,
                                  i_Trans_Type => c_Default_Test_Trans_Type,
                                  i_Begin_Date => i_Begin_Date,
                                  i_End_Date   => i_End_Date,
                                  i_Order_No   => i_Order_No,
                                  i_Journal_Id => g_Journal_Id,
                                  i_Page_Id    => g_Page_Id,
                                  i_Tag        => 'Test Tag',
                                  i_Event      => i_Event);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Agreement
  (
    i_Period date,
    i_Action varchar2 := Hpd_Pref.c_Transaction_Action_Continue
  ) is
  begin
    z_Hpd_Agreements.Insert_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => i_Period,
                                i_Trans_Id   => g_Trans_Id,
                                i_Action     => i_Action);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Agreement_Dates(i_Agreements_Cnt number) is
    v_Total_Cnt   number;
    v_Tracked_Cnt number;
  begin
    Ut.Expect(g_Agreement_Dates.Count).To_Equal(i_Agreements_Cnt);
  
    select count(*),
           count(case
                    when q.Period member of g_Agreement_Dates then
                     1
                    else
                     null
                  end)
      into v_Total_Cnt, v_Tracked_Cnt
      from Hpd_Agreements q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id = g_Staff_Id
       and q.Trans_Type = c_Default_Test_Trans_Type;
  
    Ut.Expect(v_Tracked_Cnt).To_Equal(i_Agreements_Cnt);
    Ut.Expect(v_Total_Cnt).To_Equal(v_Tracked_Cnt);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post_Posted_Journal is
  begin
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => g_Journal_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Post_Nonexistent_Journal is
  begin
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => Hpd_Next.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post_Journal_Nonexistent_Pcode is
  begin
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => g_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post_Vacation_Limit_Journal is
    r_Journal   Hpd_Journals%rowtype;
    r_Agreement Hpd_Agreements%rowtype;
    r_Trans     Hpd_Trans_Vacation_Limits%rowtype;
  begin
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => g_Journal_Id);
  
    Ut.Expect(z_Hpd_Journals.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Journal_Id => g_Journal_Id,
                                   o_Row        => r_Journal)).To_Be_True();
  
    Ut.Expect(r_Journal.Posted).To_Equal('Y');
    Ut.Expect(r_Journal.Posted_Order_No).To_Be_Not_Null();
  
    Ut.Expect(z_Hpd_Agreements.Exist(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Staff_Id   => g_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Vacation_Limit,
                                     i_Period     => g_Posted_Date,
                                     o_Row        => r_Agreement)).To_Be_True();
    Ut.Expect(z_Hpd_Trans_Vacation_Limits.Exist(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Trans_Id   => r_Agreement.Trans_Id,
                                                o_Row        => r_Trans)).To_Be_True();
    Ut.Expect(r_Trans.Days_Limit).To_Equal(g_Vacation_Limit);
    Ut.Expect(z_Hpd_Vacation_Turnover.Exist(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Staff_Id   => g_Staff_Id,
                                            i_Period     => g_Posted_Date)).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_Three_Dates is
    v_Free_Days number;
  begin
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Staff_Id = p.Staff_Id
                          and Trunc(q.Period, 'yyyy') = Trunc(g_Posted_Date, 'yyyy'));
  
    -- last turnover in posted year should be 18.835616
    Ut.Expect(v_Free_Days).To_Equal(18.835616);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period =
           (select max(q.Period)
              from Hpd_Vacation_Turnover q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Staff_Id = p.Staff_Id
               and Trunc(q.Period, 'yyyy') = Trunc(Add_Months(g_Posted_Date, 12), 'yyyy'));
  
    -- last turnover in next year should be 25
    Ut.Expect(v_Free_Days).To_Equal(25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_Inside_Year is
    v_Free_Days number;
  begin
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Staff_Id = p.Staff_Id);
  
    -- last turnover in posted year should be 15
    Ut.Expect(v_Free_Days).To_Equal(15);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_Three_Dates_With_Removal is
    v_Free_Days number;
  begin
    Hpd_Core.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Journal_Id => g_Journal_Id);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Staff_Id = p.Staff_Id
                          and Trunc(q.Period, 'yyyy') = Trunc(g_Posted_Date, 'yyyy'));
  
    -- last turnover in posted year should be 17.60274
    Ut.Expect(v_Free_Days).To_Equal(17.60274);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period =
           (select max(q.Period)
              from Hpd_Vacation_Turnover q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Staff_Id = p.Staff_Id
               and Trunc(q.Period, 'yyyy') = Trunc(Add_Months(g_Posted_Date, 12), 'yyyy'));
  
    -- last turnover in next year should be 25
    Ut.Expect(v_Free_Days).To_Equal(25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_Two_Years is
    v_Free_Days number;
  begin
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Staff_Id = p.Staff_Id
                          and Trunc(q.Period, 'yyyy') = Trunc(g_Posted_Date, 'yyyy'));
  
    -- last turnover in posted year should be 15
    Ut.Expect(v_Free_Days).To_Equal(15);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period =
           (select max(q.Period)
              from Hpd_Vacation_Turnover q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Staff_Id = p.Staff_Id
               and Trunc(q.Period, 'yyyy') = Trunc(Add_Months(g_Posted_Date, 12), 'yyyy'));
  
    -- last turnover in posted year should be 19.246575
    Ut.Expect(v_Free_Days).To_Equal(19.246575);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_Two_Years_With_Removal is
    v_Free_Days number;
  begin
    Hpd_Core.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Journal_Id => g_Journal_Id);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = p.Company_Id
                          and q.Filial_Id = p.Filial_Id
                          and q.Staff_Id = p.Staff_Id
                          and Trunc(q.Period, 'yyyy') = Trunc(g_Posted_Date, 'yyyy'));
  
    -- last turnover in posted year should be 15
    Ut.Expect(v_Free_Days).To_Equal(15);
  
    select p.Free_Days
      into v_Free_Days
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and p.Period =
           (select max(q.Period)
              from Hpd_Vacation_Turnover q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Staff_Id = p.Staff_Id
               and Trunc(q.Period, 'yyyy') = Trunc(Add_Months(g_Posted_Date, 12), 'yyyy'));
  
    -- last turnover in posted year should be 18.24658
    Ut.Expect(v_Free_Days).To_Equal(18.424658);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Change_After_Vacation is
    r_Turnover Hpd_Vacation_Turnover%rowtype;
  begin
    Ut.Expect(z_Hpd_Vacation_Turnover.Exist(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Staff_Id   => g_Staff_Id,
                                            i_Period     => g_Posted_Date + 15,
                                            o_Row        => r_Turnover)).To_Be_True();
  
    -- free days on vacation first days should be 0
    Ut.Expect(r_Turnover.Free_Days).To_Equal(0);
  
    Ut.Expect(z_Hpd_Vacation_Turnover.Exist(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Staff_Id   => g_Staff_Id,
                                            i_Period     => g_Posted_Date + 60,
                                            o_Row        => r_Turnover)).To_Be_True();
  
    -- free days on second limit change should be 4.178082
    Ut.Expect(r_Turnover.Free_Days).To_Equal(4.178082);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Change_After_Vacation_With_Removal is
  begin
    Hpd_Core.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Journal_Id => g_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_Limit_Changes_All_Unpost is
    v_Error_Count number;
  begin
    Hpd_Core.Agreements_Evaluate(Ui.Company_Id);
  
    select count(*)
      into v_Error_Count
      from Hpd_Vacation_Turnover p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Staff_Id = g_Staff_Id
       and (p.Planned_Days <> 0 or p.Used_Days <> 0);
  
    Ut.Expect(v_Error_Count, 'vacation turnover table has nonzero records').To_Equal(0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Journal_Nonexistent_Pcode is
    v_Journal_Type_Id number := Hpd_Next.Journal_Type_Id;
  begin
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => Ui.Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => 'Test Type',
                                 i_Order_No        => -v_Journal_Type_Id,
                                 i_Pcode           => 'Test:' ||
                                                      Hpd_Pref.c_Pcode_Journal_Type_Hiring);
  
    g_Journal_Id := Hpd_Next.Journal_Id;
  
    z_Hpd_Journals.Save_One(i_Company_Id      => Ui.Company_Id,
                            i_Filial_Id       => Ui.Filial_Id,
                            i_Journal_Id      => g_Journal_Id,
                            i_Journal_Type_Id => v_Journal_Type_Id,
                            i_Journal_Number  => -g_Journal_Id,
                            i_Journal_Date    => Ut_Vhr_Util.c_Gen_Year,
                            i_Journal_Name    => 'Test Posted Journal',
                            i_Posted          => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Posted_Journal is
    v_Journal_Type_Id number;
  begin
    v_Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    g_Journal_Id      := Hpd_Next.Journal_Id;
    z_Hpd_Journals.Save_One(i_Company_Id      => Ui.Company_Id,
                            i_Filial_Id       => Ui.Filial_Id,
                            i_Journal_Id      => g_Journal_Id,
                            i_Journal_Type_Id => v_Journal_Type_Id,
                            i_Journal_Number  => -g_Journal_Id,
                            i_Journal_Date    => Ut_Vhr_Util.c_Gen_Year,
                            i_Journal_Name    => 'Test Posted Journal',
                            i_Posted          => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Vacation_Limit_Change_Journal is
    v_Limit_Journal Hpd_Pref.Limit_Change_Journal_Rt;
  begin
    g_Posted_Date := Ut_Vhr_Util.c_Gen_Year;
  
    g_Staff_Id       := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                               i_Filial_Id  => Ui.Filial_Id,
                                                               i_Hire_Date  => g_Posted_Date);
    g_Journal_Id     := Hpd_Next.Journal_Id;
    g_Vacation_Limit := 20;
  
    Hpd_Util.Limit_Change_Journal_New(o_Journal      => v_Limit_Journal,
                                      i_Company_Id   => Ui.Company_Id,
                                      i_Filial_Id    => Ui.Filial_Id,
                                      i_Journal_Id   => g_Journal_Id,
                                      i_Journal_Date => g_Posted_Date,
                                      i_Journal_Name => 'Test Journal',
                                      i_Division_Id  => null,
                                      i_Days_Limit   => g_Vacation_Limit,
                                      i_Change_Date  => g_Posted_Date);
  
    Hpd_Util.Limit_Change_Add_Page(p_Journal  => v_Limit_Journal,
                                   i_Page_Id  => Hpd_Next.Page_Id,
                                   i_Staff_Id => g_Staff_Id);
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(v_Limit_Journal);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post_Limit_Change_Journal
  (
    i_Posted_Date date,
    i_Days_Limit  number
  ) is
    v_Limit_Journal Hpd_Pref.Limit_Change_Journal_Rt;
  begin
    g_Journal_Id := Hpd_Next.Journal_Id;
  
    Hpd_Util.Limit_Change_Journal_New(o_Journal      => v_Limit_Journal,
                                      i_Company_Id   => Ui.Company_Id,
                                      i_Filial_Id    => Ui.Filial_Id,
                                      i_Journal_Id   => g_Journal_Id,
                                      i_Journal_Date => i_Posted_Date,
                                      i_Journal_Name => 'Test Journal',
                                      i_Division_Id  => null,
                                      i_Days_Limit   => i_Days_Limit,
                                      i_Change_Date  => i_Posted_Date);
  
    Hpd_Util.Limit_Change_Add_Page(p_Journal  => v_Limit_Journal,
                                   i_Page_Id  => Hpd_Next.Page_Id,
                                   i_Staff_Id => g_Staff_Id);
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(v_Limit_Journal);
  
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => g_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Changes_Three_Dates is
  begin
    g_Posted_Date := Ut_Vhr_Util.c_Gen_Year;
  
    g_Staff_Id := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Hire_Date  => g_Posted_Date);
  
    Post_Limit_Change_Journal(g_Posted_Date, 15);
    Post_Limit_Change_Journal(g_Posted_Date + 180, 20);
    Post_Limit_Change_Journal(g_Posted_Date + 270, 25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Changes_Inside_Year is
  begin
    g_Posted_Date := Ut_Vhr_Util.c_Gen_Year + 180;
  
    g_Staff_Id := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Hire_Date  => g_Posted_Date);
  
    Post_Limit_Change_Journal(g_Posted_Date, 15);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Changes_Three_Dates_For_Removal is
  begin
    Create_Limit_Changes_Three_Dates;
  
    -- find journal id for removal
    select p.Journal_Id
      into g_Journal_Id
      from Hpd_Vacation_Limit_Changes p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Change_Date = g_Posted_Date + 180
       and p.Days_Limit = 20;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Changes_Three_Dates_Two_Years is
  begin
    g_Posted_Date := Ut_Vhr_Util.c_Gen_Year + 180;
  
    g_Staff_Id := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Hire_Date  => g_Posted_Date);
  
    Post_Limit_Change_Journal(g_Posted_Date, 15);
    Post_Limit_Change_Journal(Add_Months(g_Posted_Date, 12), 20);
    Post_Limit_Change_Journal(Add_Months(g_Posted_Date, 12) + 60, 25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Changes_Two_Years_For_Removal is
  begin
    Create_Limit_Changes_Three_Dates_Two_Years;
  
    -- find journal id for removal
    select p.Journal_Id
      into g_Journal_Id
      from Hpd_Vacation_Limit_Changes p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Change_Date = Add_Months(g_Posted_Date, 12)
       and p.Days_Limit = 20;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post_Vacation
  (
    i_Begin_Date date,
    i_End_Date   date
  ) is
    v_Vacation Hpd_Pref.Vacation_Journal_Rt;
  begin
    g_Journal_Id := Hpd_Next.Journal_Id;
  
    Hpd_Util.Vacation_Journal_New(o_Journal      => v_Vacation,
                                  i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Journal_Id   => g_Journal_Id,
                                  i_Journal_Date => i_Begin_Date,
                                  i_Journal_Name => 'Test Vacation');
  
    Hpd_Util.Journal_Add_Vacation(p_Journal    => v_Vacation,
                                  i_Timeoff_Id => Hpd_Next.Timeoff_Id,
                                  i_Staff_Id   => g_Staff_Id,
                                  i_Begin_Date => i_Begin_Date,
                                  i_End_Date   => i_End_Date);
  
    Hpd_Api.Vacation_Journal_Save(v_Vacation);
  
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => g_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Change_After_Vacation is
  begin
    g_Posted_Date := Ut_Vhr_Util.c_Gen_Year;
  
    g_Staff_Id := Ut_Vhr_Util.Create_Generic_Hired_Staff(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Hire_Date  => g_Posted_Date);
  
    Post_Limit_Change_Journal(g_Posted_Date, 20);
    Post_Vacation(g_Posted_Date + 15, g_Posted_Date + 34); -- 20 days vacation
    Post_Limit_Change_Journal(g_Posted_Date + 60, 25);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Limit_Change_After_Vacation_For_Removal is
  begin
    Create_Limit_Change_After_Vacation;
  
    -- find journal id for removal
    select p.Journal_Id
      into g_Journal_Id
      from Hpd_Vacation_Limit_Changes p
     where p.Company_Id = Ui.Company_Id
       and p.Filial_Id = Ui.Filial_Id
       and p.Change_Date = g_Posted_Date
       and p.Days_Limit = 20;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Unposted_Journals is
  begin
    Create_Limit_Changes_Three_Dates;
  
    for r in (select *
                from Hpd_Journals p
               where p.Company_Id = Ui.Company_Id
                 and p.Filial_Id = Ui.Filial_Id
               order by p.Posted_Order_No desc)
    loop
      Hpd_Core.Journal_Unpost(i_Company_Id => r.Company_Id,
                              i_Filial_Id  => r.Filial_Id,
                              i_Journal_Id => r.Journal_Id,
                              i_Repost     => true);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Agreement_Dates is
  begin
    g_Agreement_Dates := Array_Date();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Hiring_Trans is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate),
                       i_End_Date   => null,
                       i_Order_No   => 1,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate),
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Hiring is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate));
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Hiring is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) - 1);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate));
  
    Assert_Agreement_Dates(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Hiring is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 1);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate));
  
    Assert_Agreement_Dates(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Hiring is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate));
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate));
  
    Assert_Agreement_Dates(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Transfer_Trans is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 2,
                       i_End_Date   => null,
                       i_Order_No   => 2,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 2,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Transfer is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 2);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 1);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 2);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Transfer_On_Hiring is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 2);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Begin_Date => Option_Date(Trunc(sysdate)),
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Transfer_On_Hiring is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate));
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate));
  
    Assert_Agreement_Dates(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Second_Transfer_With_End_Date is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 5,
                       i_End_Date   => Trunc(sysdate) + 8,
                       i_Order_No   => 3,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 5,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
    Insert_Agreement(i_Period => Trunc(sysdate) + 9,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Between_Second_Transfer is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 9);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Between_Second_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 6);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate),
                                    Trunc(sysdate) + 2,
                                    Trunc(sysdate) + 5,
                                    Trunc(sysdate) + 9);
  
    Assert_Agreement_Dates(4);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Second_Transfer is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 9);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Second_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 6);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate),
                                    Trunc(sysdate) + 2,
                                    Trunc(sysdate) + 5,
                                    Trunc(sysdate) + 9);
  
    Assert_Agreement_Dates(4);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Second_Transfer is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 10);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate),
                                    Trunc(sysdate) + 2,
                                    Trunc(sysdate) + 5,
                                    Trunc(sysdate) + 9);
  
    Assert_Agreement_Dates(4);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Trans_With_End_Date is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 2,
                       i_End_Date   => Trunc(sysdate) + 5,
                       i_Order_No   => 2,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 2,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
    Insert_Agreement(i_Period => Trunc(sysdate) + 6,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Transfer_With_End is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 2);
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 6);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Transfer_With_End is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 1);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 6);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Between_Transfer_With_End is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 6);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Transfer_With_End is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 7);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 6);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_On_Transfer_With_End_To_Be_Intergrated is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 2);
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 6);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Transfer_With_End_To_Be_Intergrated is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 2);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 6);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Second_Transfer_Between_First is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 4,
                       i_End_Date   => null,
                       i_Order_No   => 3,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 4,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Between_Second_Transfer_Between_First is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 4);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_On_Second_Transfer_Between_First is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 4);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Second_Transfer_Between_First is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 4);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Second_Transfer_Start_As_First is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 4);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Trans_Id,
                                  i_Begin_Date => Option_Date(Trunc(sysdate) + 2),
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Second_Transfer_Start_As_First is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 2);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Second_Transfer_Start_As_First is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 1);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_After_Second_Transfer_Start_As_First is
  begin
    Create_Agreement_Fill_Second_Transfer_Start_As_First;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Second_Transfer_Start_As_First is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Stopped_Transaction is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 5,
                       i_End_Date   => null,
                       i_Order_No   => 2,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Stop,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 5,
                     i_Action => Hpd_Pref.c_Transaction_Action_Stop);
  
    g_Stopped_Trans_Id := g_Trans_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Transfer_After_Stopped_Trans is
  begin
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 5);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Stopped_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Trans_After_Stopped_Trans is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 7,
                       i_End_Date   => null,
                       i_Order_No   => 3,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_To_Be_Integrated);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_Before_Transfer_After_Stopped_Trans is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 3);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 5);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Transfer_After_Stopped_Trans is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 5);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 5);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_After_Transfer_After_Stopped_Trans is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 6);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 5);
  
    Assert_Agreement_Dates(2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Agreement_Fill_Before_Stopped_Trans_With_Transfer_With_End_Date is
  begin
    Insert_Transaction(i_Begin_Date => Trunc(sysdate) + 2,
                       i_End_Date   => Trunc(sysdate) + 4,
                       i_Order_No   => 2,
                       i_Action     => Hpd_Pref.c_Transaction_Action_Continue,
                       i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    Insert_Agreement(i_Period => Trunc(sysdate) + 2,
                     i_Action => Hpd_Pref.c_Transaction_Action_Continue);
  
    z_Hpd_Agreements.Delete_One(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Staff_Id   => g_Staff_Id,
                                i_Trans_Type => c_Default_Test_Trans_Type,
                                i_Period     => Trunc(sysdate) + 5);
  
    z_Hpd_Transactions.Update_One(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Trans_Id   => g_Stopped_Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Integrated));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Agreement_Fill_On_Stopped_Trans_With_Transfer_With_End_Date is
  begin
    Hpd_Core.Agreement_Fill(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Staff_Id   => g_Staff_Id,
                            i_Trans_Type => c_Default_Test_Trans_Type,
                            i_Start_Date => Trunc(sysdate) + 5);
  
    g_Agreement_Dates := Array_Date(Trunc(sysdate), Trunc(sysdate) + 2, Trunc(sysdate) + 5);
  
    Assert_Agreement_Dates(3);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Basic_Timesheet(i_Fact_Value number := null) return number is
    v_Timesheet_Id number := Htt_Next.Timesheet_Id;
  begin
    z_Htt_Timesheets.Insert_One(i_Company_Id       => Ui.Company_Id,
                                i_Filial_Id        => Ui.Filial_Id,
                                i_Timesheet_Id     => v_Timesheet_Id,
                                i_Timesheet_Date   => Trunc(sysdate),
                                i_Staff_Id         => g_Staff_Id,
                                i_Employee_Id      => Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                                                                i_Filial_Id  => Ui.Filial_Id,
                                                                                i_Staff_Id   => g_Staff_Id),
                                i_Schedule_Id      => Ut_Vhr_Util.Create_Generic_Schedule(i_Company_Id => Ui.Company_Id,
                                                                                          i_Filial_Id  => Ui.Filial_Id),
                                i_Calendar_Id      => null,
                                i_Day_Kind         => Htt_Pref.c_Day_Kind_Rest,
                                i_Track_Duration   => 86400,
                                i_Count_Late       => 'Y',
                                i_Count_Early      => 'Y',
                                i_Count_Lack       => 'Y',
                                i_Shift_Begin_Time => sysdate,
                                i_Shift_End_Time   => sysdate + 1,
                                i_Input_Border     => sysdate,
                                i_Output_Border    => sysdate + 2,
                                i_Begin_Time       => null,
                                i_End_Time         => null,
                                i_Break_Enabled    => null,
                                i_Break_Begin_Time => null,
                                i_Break_End_Time   => null,
                                i_Plan_Time        => 0,
                                i_Full_Time        => 0,
                                i_Input_Time       => null,
                                i_Output_Time      => null,
                                i_Planned_Marks    => 0,
                                i_Done_Marks       => 0);
  
    if i_Fact_Value is not null then
      z_Htt_Timesheet_Facts.Insert_One(i_Company_Id   => Ui.Company_Id,
                                       i_Filial_Id    => Ui.Filial_Id,
                                       i_Timesheet_Id => v_Timesheet_Id,
                                       i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                                               i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free),
                                       i_Fact_Value   => i_Fact_Value);
    end if;
  
    return v_Timesheet_Id;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Overtime_Journal_Post_With_Enoughly_Free_Time is
    v_Journal               Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes             Hpd_Pref.Overtime_Nt := Hpd_Pref.Overtime_Nt();
    v_Journal_Id            number := Hpd_Next.Journal_Id;
    v_Overtime_Id           number := Hpd_Next.Overtime_Id;
    v_Date                  date := Trunc(sysdate);
    v_Timesheet_Id          number;
    v_Overtime_Time_Kind_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  begin
    v_Timesheet_Id := Create_Basic_Timesheet(1000);
  
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
  
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => v_Journal_Id);
  
    Ut.Expect(z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id, --
              i_Filial_Id => Ui.Filial_Id, --
              i_Journal_Id => v_Journal_Id).Posted).To_Equal('Y');
  
    Ut.Expect(z_Htt_Timesheet_Facts.Exist(i_Company_Id   => Ui.Company_Id,
                                          i_Filial_Id    => Ui.Filial_Id,
                                          i_Timesheet_Id => v_Timesheet_Id,
                                          i_Time_Kind_Id => v_Overtime_Time_Kind_Id)).To_Be_True();
  
    Ut.Expect(z_Htt_Timesheet_Facts.Load(i_Company_Id => Ui.Company_Id, --
              i_Filial_Id => Ui.Filial_Id, --
              i_Timesheet_Id => v_Timesheet_Id, --
              i_Time_Kind_Id => v_Overtime_Time_Kind_Id).Fact_Value).To_Equal(200);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_Post_With_Not_Enough_Free_Time is
    v_Journal      Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes    Hpd_Pref.Overtime_Nt := Hpd_Pref.Overtime_Nt();
    v_Journal_Id   number := Hpd_Next.Journal_Id;
    v_Overtime_Id  number := Hpd_Next.Overtime_Id;
    v_Date         date := Trunc(sysdate);
    v_Timesheet_Id number;
  begin
    v_Timesheet_Id := Create_Basic_Timesheet(100);
  
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
  
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => v_Journal_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Overtime_Journal_Post_Without_Timesheet_Facts is
    v_Journal      Hpd_Pref.Overtime_Journal_Rt;
    v_Overtimes    Hpd_Pref.Overtime_Nt := Hpd_Pref.Overtime_Nt();
    v_Journal_Id   number := Hpd_Next.Journal_Id;
    v_Overtime_Id  number := Hpd_Next.Overtime_Id;
    v_Date         date := Trunc(sysdate);
    v_Timesheet_Id number;
  begin
    v_Timesheet_Id := Create_Basic_Timesheet;
  
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
  
    Hpd_Core.Journal_Post(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Journal_Id => v_Journal_Id);
  end;

end Ut_Hpd_Core;
/
