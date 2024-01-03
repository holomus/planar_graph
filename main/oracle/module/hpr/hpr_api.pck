create or replace package Hpr_Api is
  ----------------------------------------------------------------------------------------------------  
  Procedure Cv_Contract_Fact_Save(i_Contract_Fact Hpr_Pref.Cv_Contract_Fact_Rt);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Cv_Contract_Fact_New
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_To_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Accept
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Return_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Save(i_Penalty Hpr_Pref.Penalty_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Penalty_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nighttime_Policy_Save(i_Nighttime_Policy Hpr_Pref.Nighttime_Policy_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Nighttime_Policy_Delete
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Nighttime_Policy_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Timebook_Save(i_Timebook Hpr_Pref.Timebook_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Timebook_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Timebook_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Save(i_Wage_Sheet Hpr_Pref.Wage_Sheet_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Oper_Type_Save(i_Oper_Type Hpr_Pref.Oper_Type_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Oper_Type_Delete
  (
    i_Company_Id   number,
    i_Oper_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Save(i_Book Hpr_Pref.Book_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Save(i_Charge_Document Hpr_Pref.Charge_Document_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Advance_Save(i_Advance Hpr_Pref.Advance_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Coef_Save
  (
    i_Company_Id number,
    i_Value      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Save(i_Sales_Bonus_Payment Hpr_Pref.Sales_Bonus_Payment_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Currency_Settings_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Currency_Ids Array_Number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Timebook_Fill_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Settings   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Use_Subfilial_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Setting    varchar2
  );
  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Save(i_Credit Hpr_Pref.Credit_Rt);
  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Draft
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  );
  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Book
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  );
  ----------------------------------------------------------------------------------------------------    
  Procedure Credit_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  );
  ----------------------------------------------------------------------------------------------------     
  Procedure Credit_Archive
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  );
  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  );
end Hpr_Api;
/
create or replace package body Hpr_Api is
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
    return b.Translate('HPR:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cv_Contract_Fact_Save(i_Contract_Fact Hpr_Pref.Cv_Contract_Fact_Rt) is
  begin
    Hpr_Core.Cv_Contract_Fact_Save(i_Contract_Fact);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_New
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Lock_Load(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Fact_Id    => i_Fact_Id);
  
    if r_Fact.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_Complete then
      Hpr_Error.Raise_020(i_Fact_Id     => i_Fact_Id,
                          i_Status_Name => Hpr_Util.t_Cv_Fact_Status(r_Fact.Status));
    end if;
  
    z_Hpr_Cv_Contract_Facts.Update_One(i_Company_Id => r_Fact.Company_Id,
                                       i_Filial_Id  => r_Fact.Filial_Id,
                                       i_Fact_Id    => r_Fact.Fact_Id,
                                       i_Status     => Option_Varchar2(Hpr_Pref.c_Cv_Contract_Fact_Status_New));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_To_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Lock_Load(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Fact_Id    => i_Fact_Id);
  
    if r_Fact.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_New then
      Hpr_Error.Raise_021(i_Fact_Id     => i_Fact_Id,
                          i_Status_Name => Hpr_Util.t_Cv_Fact_Status(r_Fact.Status));
    end if;
  
    z_Hpr_Cv_Contract_Facts.Update_One(i_Company_Id => r_Fact.Company_Id,
                                       i_Filial_Id  => r_Fact.Filial_Id,
                                       i_Fact_Id    => r_Fact.Fact_Id,
                                       i_Status     => Option_Varchar2(Hpr_Pref.c_Cv_Contract_Fact_Status_Complete));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Accept
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact     Hpr_Cv_Contract_Facts%rowtype;
    r_Contract Hpd_Cv_Contracts%rowtype;
    v_Account  Mk_Account;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Lock_Load(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Fact_Id    => i_Fact_Id);
  
    if r_Fact.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_Complete then
      Hpr_Error.Raise_022(i_Fact_Id     => i_Fact_Id,
                          i_Status_Name => Hpr_Util.t_Cv_Fact_Status(r_Fact.Status));
    end if;
  
    z_Hpr_Cv_Contract_Facts.Update_One(i_Company_Id => r_Fact.Company_Id,
                                       i_Filial_Id  => r_Fact.Filial_Id,
                                       i_Fact_Id    => r_Fact.Fact_Id,
                                       i_Status     => Option_Varchar2(Hpr_Pref.c_Cv_Contract_Fact_Status_Accept));
  
    Mk_Journal.Pick(i_Company_Id   => r_Fact.Company_Id,
                    i_Filial_Id    => r_Fact.Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Cv_Contract_Fact(r_Fact.Fact_Id),
                    i_Trans_Date   => r_Fact.Month);
  
    Mk_Journal.Clear;
  
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => r_Fact.Company_Id,
                                               i_Filial_Id   => r_Fact.Filial_Id,
                                               i_Contract_Id => r_Fact.Contract_Id);
    v_Account  := Mkr_Account.Payroll_Accrual(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Currency_Id => z_Mk_Base_Currencies.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Currency_Id,
                                              i_Ref_Codes   => Mkr_Account.Ref_Codes(i_Person_Id => r_Contract.Person_Id));
  
    Mk_Journal.Add_Trans(i_Debit  => Mkr_Account.Expense_Others(i_Company_Id => r_Fact.Company_Id,
                                                                i_Filial_Id  => r_Fact.Filial_Id),
                         i_Credit => v_Account,
                         i_Amount => r_Fact.Total_Amount);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Return_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Lock_Load(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id,
                                                i_Fact_Id    => i_Fact_Id);
  
    if r_Fact.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_Accept then
      Hpr_Error.Raise_023(i_Fact_Id     => i_Fact_Id,
                          i_Status_Name => Hpr_Util.t_Cv_Fact_Status(r_Fact.Status));
    end if;
  
    z_Hpr_Cv_Contract_Facts.Update_One(i_Company_Id => r_Fact.Company_Id,
                                       i_Filial_Id  => r_Fact.Filial_Id,
                                       i_Fact_Id    => r_Fact.Fact_Id,
                                       i_Status     => Option_Varchar2(Hpr_Pref.c_Cv_Contract_Fact_Status_Complete));
  
    Mk_Journal.Pick(i_Company_Id   => r_Fact.Company_Id,
                    i_Filial_Id    => r_Fact.Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Cv_Contract_Fact(r_Fact.Fact_Id),
                    i_Trans_Date   => r_Fact.Month);
  
    Mk_Journal.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Save(i_Penalty Hpr_Pref.Penalty_Rt) is
  begin
    Hpr_Core.Penalty_Save(i_Penalty);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Penalty_Id number
  ) is
  begin
    z_Hpr_Penalties.Delete_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Penalty_Id => i_Penalty_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Rule_Periods(i_Rules Hpr_Pref.Nighttime_Rule_Nt) is
  begin
    for i in 1 .. i_Rules.Count
    loop
      for j in i + 1 .. i_Rules.Count
      loop
        if Greatest(i_Rules(i).Begin_Time, i_Rules(j).Begin_Time) <
           Least(i_Rules(i).End_Time, i_Rules(j).End_Time) then
          Hpr_Error.Raise_054(i_First_Row => i, i_Second_Row => j);
        end if;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nighttime_Policy_Save(i_Nighttime_Policy Hpr_Pref.Nighttime_Policy_Rt) is
    r_Policy             Hpr_Nighttime_Policies%rowtype;
    v_Exists             boolean := false;
    v_Policy_Begin_Times Array_Number := Array_Number();
  begin
    if z_Hpr_Nighttime_Policies.Exist(i_Company_Id          => i_Nighttime_Policy.Company_Id,
                                      i_Filial_Id           => i_Nighttime_Policy.Filial_Id,
                                      i_Nighttime_Policy_Id => i_Nighttime_Policy.Nigthttime_Policy_Id,
                                      o_Row                 => r_Policy) then
      if r_Policy.Month <> i_Nighttime_Policy.Month then
        Hpr_Error.Raise_052(r_Policy.Nighttime_Policy_Id);
      end if;
    
      if not Fazo.Equal(r_Policy.Division_Id, i_Nighttime_Policy.Division_Id) then
        Hpr_Error.Raise_053(r_Policy.Nighttime_Policy_Id);
      end if;
    
      v_Exists := true;
    else
      r_Policy.Company_Id          := i_Nighttime_Policy.Company_Id;
      r_Policy.Filial_Id           := i_Nighttime_Policy.Filial_Id;
      r_Policy.Nighttime_Policy_Id := i_Nighttime_Policy.Nigthttime_Policy_Id;
      r_Policy.Month               := i_Nighttime_Policy.Month;
      r_Policy.Division_Id         := i_Nighttime_Policy.Division_Id;
    end if;
  
    r_Policy.Name  := i_Nighttime_Policy.Name;
    r_Policy.State := i_Nighttime_Policy.State;
  
    if v_Exists then
      z_Hpr_Nighttime_Policies.Update_Row(r_Policy);
    else
      z_Hpr_Nighttime_Policies.Insert_Row(r_Policy);
    end if;
  
    v_Policy_Begin_Times.Extend(i_Nighttime_Policy.Rules.Count);
  
    Check_Rule_Periods(i_Nighttime_Policy.Rules);
  
    for i in 1 .. i_Nighttime_Policy.Rules.Count
    loop
      if i_Nighttime_Policy.Rules(i).Nighttime_Coef <= 1 then
        Hpr_Error.Raise_055(i);
      end if;
    
      z_Hpr_Nighttime_Rules.Save_One(i_Company_Id          => r_Policy.Company_Id,
                                     i_Filial_Id           => r_Policy.Filial_Id,
                                     i_Nighttime_Policy_Id => r_Policy.Nighttime_Policy_Id,
                                     i_Begin_Time          => i_Nighttime_Policy.Rules(i).Begin_Time,
                                     i_End_Time            => i_Nighttime_Policy.Rules(i).End_Time,
                                     i_Nighttime_Coef      => i_Nighttime_Policy.Rules(i).Nighttime_Coef);
    
      v_Policy_Begin_Times(i) := i_Nighttime_Policy.Rules(i).Begin_Time;
    end loop;
  
    if v_Exists then
      for r in (select *
                  from Hpr_Nighttime_Rules q
                 where q.Company_Id = r_Policy.Company_Id
                   and q.Filial_Id = r_Policy.Filial_Id
                   and q.Nighttime_Policy_Id = r_Policy.Nighttime_Policy_Id
                   and q.Begin_Time not member of v_Policy_Begin_Times)
      loop
        z_Hpr_Nighttime_Rules.Delete_One(i_Company_Id          => r.Company_Id,
                                         i_Filial_Id           => r.Filial_Id,
                                         i_Nighttime_Policy_Id => r.Nighttime_Policy_Id,
                                         i_Begin_Time          => r.Begin_Time);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nighttime_Policy_Delete
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Nighttime_Policy_Id number
  ) is
  begin
    z_Hpr_Nighttime_Policies.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Filial_Id           => i_Filial_Id,
                                        i_Nighttime_Policy_Id => i_Nighttime_Policy_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Timebook_Save(i_Timebook Hpr_Pref.Timebook_Rt) is
  begin
    Hpr_Core.Timebook_Save(i_Timebook);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  ) is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    r_Timebook := z_Hpr_Timebooks.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Timebook_Id => i_Timebook_Id);
  
    if r_Timebook.Posted = 'Y' then
      Hpr_Error.Raise_024(r_Timebook.Timebook_Number);
    end if;
  
    Hpr_Core.Lock_Timesheets(i_Company_Id   => r_Timebook.Company_Id,
                             i_Filial_Id    => r_Timebook.Filial_Id,
                             i_Timebook_Id  => r_Timebook.Timebook_Id,
                             i_Period_Begin => r_Timebook.Period_Begin,
                             i_Period_End   => r_Timebook.Period_End);
  
    Hpr_Core.Timebook_Staffs_Update(i_Company_Id   => r_Timebook.Company_Id,
                                    i_Filial_Id    => r_Timebook.Filial_Id,
                                    i_Timebook_Id  => r_Timebook.Timebook_Id,
                                    i_Period_Begin => r_Timebook.Period_Begin,
                                    i_Period_End   => r_Timebook.Period_End);
  
    for St in (select q.Staff_Id
                 from Hpr_Timebook_Staffs q
                where q.Company_Id = i_Company_Id
                  and q.Filial_Id = i_Filial_Id
                  and q.Timebook_Id = i_Timebook_Id)
    loop
      Hpd_Api.Timebook_Lock_Interval_Insert(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Timebook_Id => i_Timebook_Id,
                                            i_Staff_Id    => St.Staff_Id,
                                            i_Begin_Date  => r_Timebook.Period_Begin,
                                            i_End_Date    => r_Timebook.Period_End);
    end loop;
  
    z_Hpr_Timebooks.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Timebook_Id => i_Timebook_Id,
                               i_Posted      => Option_Varchar2('Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  ) is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    r_Timebook := z_Hpr_Timebooks.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Timebook_Id => i_Timebook_Id);
  
    if r_Timebook.Posted = 'N' then
      Hpr_Error.Raise_025(r_Timebook.Timebook_Number);
    end if;
  
    Hpr_Core.Unlock_Timesheets(i_Company_Id  => r_Timebook.Company_Id,
                               i_Filial_Id   => r_Timebook.Filial_Id,
                               i_Timebook_Id => r_Timebook.Timebook_Id);
  
    for r in (select q.Staff_Id, q.Interval_Id
                from Hpr_Timebook_Intervals q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Timebook_Id = i_Timebook_Id)
    loop
      z_Hpr_Timebook_Intervals.Delete_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Timebook_Id => i_Timebook_Id,
                                          i_Staff_Id    => r.Staff_Id);
    
      Hpd_Api.Lock_Interval_Delete(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Interval_Id => r.Interval_Id);
    end loop;
  
    z_Hpr_Timebooks.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Timebook_Id => i_Timebook_Id,
                               i_Posted      => Option_Varchar2('N'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  ) is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    r_Timebook := z_Hpr_Timebooks.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Timebook_Id => i_Timebook_Id);
  
    if r_Timebook.Posted = 'Y' then
      Hpr_Error.Raise_026(r_Timebook.Timebook_Number);
    end if;
  
    z_Hpr_Timebooks.Delete_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Timebook_Id => i_Timebook_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Save(i_Wage_Sheet Hpr_Pref.Wage_Sheet_Rt) is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  
    v_Exists      boolean := false;
    v_Round_Model Round_Model;
    v_Staff       Hpr_Pref.Sheet_Staff_Rt;
  begin
    if z_Hpr_Wage_Sheets.Exist_Lock(i_Company_Id => i_Wage_Sheet.Company_Id,
                                    i_Filial_Id  => i_Wage_Sheet.Filial_Id,
                                    i_Sheet_Id   => i_Wage_Sheet.Sheet_Id,
                                    o_Row        => r_Sheet) then
      if r_Sheet.Posted = 'Y' then
        Hpr_Error.Raise_027(r_Sheet.Sheet_Number);
      end if;
    
      v_Exists := true;
    else
      r_Sheet.Company_Id := i_Wage_Sheet.Company_Id;
      r_Sheet.Filial_Id  := i_Wage_Sheet.Filial_Id;
      r_Sheet.Sheet_Id   := i_Wage_Sheet.Sheet_Id;
      r_Sheet.Posted     := 'N';
    
      v_Exists := false;
    end if;
  
    r_Sheet.Sheet_Number := i_Wage_Sheet.Sheet_Number;
    r_Sheet.Sheet_Date   := i_Wage_Sheet.Sheet_Date;
    r_Sheet.Period_Begin := i_Wage_Sheet.Period_Begin;
    r_Sheet.Period_End   := i_Wage_Sheet.Period_End;
    r_Sheet.Period_Kind  := i_Wage_Sheet.Period_Kind;
    r_Sheet.Note         := i_Wage_Sheet.Note;
    r_Sheet.Sheet_Kind   := i_Wage_Sheet.Sheet_Kind;
    r_Sheet.Round_Value  := Nvl(i_Wage_Sheet.Round_Value, Hpr_Pref.c_Default_Round_Value);
  
    if v_Exists then
      z_Hpr_Wage_Sheets.Update_Row(r_Sheet);
    else
      if r_Sheet.Sheet_Number is null then
        r_Sheet.Sheet_Number := Md_Core.Gen_Number(i_Company_Id => i_Wage_Sheet.Company_Id,
                                                   i_Filial_Id  => i_Wage_Sheet.Filial_Id,
                                                   i_Table      => Zt.Hpr_Wage_Sheets,
                                                   i_Column     => z.Sheet_Id);
      end if;
    
      z_Hpr_Wage_Sheets.Insert_Row(r_Sheet);
    end if;
  
    -- delete wage sheet divisions
    delete Hpr_Wage_Sheet_Divisions q
     where q.Company_Id = r_Sheet.Company_Id
       and q.Filial_Id = r_Sheet.Filial_Id
       and q.Sheet_Id = r_Sheet.Sheet_Id;
  
    for i in 1 .. i_Wage_Sheet.Division_Ids.Count
    loop
      z_Hpr_Wage_Sheet_Divisions.Insert_One(i_Company_Id  => i_Wage_Sheet.Company_Id,
                                            i_Filial_Id   => i_Wage_Sheet.Filial_Id,
                                            i_Sheet_Id    => i_Wage_Sheet.Sheet_Id,
                                            i_Division_Id => i_Wage_Sheet.Division_Ids(i));
    end loop;
  
    -- delete staffs' parts
    delete Hpr_Sheet_Parts q
     where q.Company_Id = r_Sheet.Company_Id
       and q.Filial_Id = r_Sheet.Filial_Id
       and q.Sheet_Id = r_Sheet.Sheet_Id;
  
    -- delete sheet staffs
    delete Hpr_Onetime_Sheet_Staffs q
     where q.Company_Id = r_Sheet.Company_Id
       and q.Filial_Id = r_Sheet.Filial_Id
       and q.Sheet_Id = r_Sheet.Sheet_Id;
  
    if r_Sheet.Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Regular then
      if i_Wage_Sheet.Sheet_Staffs.Count > 0 then
        Hpr_Error.Raise_036;
      end if;
    
      v_Round_Model := Round_Model(r_Sheet.Round_Value);
    
      -- inserting staff parts
      for i in 1 .. i_Wage_Sheet.Staff_Ids.Count
      loop
        Hpr_Core.Sheet_Staff_Insert(i_Company_Id   => r_Sheet.Company_Id,
                                    i_Filial_Id    => r_Sheet.Filial_Id,
                                    i_Sheet_Id     => r_Sheet.Sheet_Id,
                                    i_Staff_Id     => i_Wage_Sheet.Staff_Ids(i),
                                    i_Period_Begin => r_Sheet.Period_Begin,
                                    i_Period_End   => r_Sheet.Period_End,
                                    i_Round_Model  => v_Round_Model);
      end loop;
    else
      if i_Wage_Sheet.Staff_Ids.Count > 0 then
        Hpr_Error.Raise_037;
      end if;
    
      -- inserting staffs
      for i in 1 .. i_Wage_Sheet.Sheet_Staffs.Count
      loop
        v_Staff := i_Wage_Sheet.Sheet_Staffs(i);
      
        Hpr_Core.Onetime_Staff_Insert(i_Company_Id     => r_Sheet.Company_Id,
                                      i_Filial_Id      => r_Sheet.Filial_Id,
                                      i_Sheet_Id       => r_Sheet.Sheet_Id,
                                      i_Staff_Id       => v_Staff.Staff_Id,
                                      i_Period_Begin   => r_Sheet.Period_Begin,
                                      i_Period_End     => r_Sheet.Period_End,
                                      i_Accrual_Amount => v_Staff.Accrual_Amount,
                                      i_Penalty_Amount => v_Staff.Penalty_Amount);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  ) is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Lock_Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Sheet_Id   => i_Sheet_Id);
  
    if r_Sheet.Posted = 'Y' then
      Hpr_Error.Raise_028(r_Sheet.Sheet_Number);
    end if;
  
    z_Hpr_Wage_Sheets.Delete_One(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Sheet_Id   => i_Sheet_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  ) is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Lock_Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Sheet_Id   => i_Sheet_Id);
  
    if r_Sheet.Posted = 'Y' then
      Hpr_Error.Raise_029(r_Sheet.Sheet_Number);
    end if;
  
    if r_Sheet.Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Regular then
      Hpr_Core.Sheet_Staffs_Update(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Sheet_Id     => i_Sheet_Id,
                                   i_Period_Begin => r_Sheet.Period_Begin,
                                   i_Period_End   => r_Sheet.Period_End,
                                   i_Round_Model  => Round_Model(r_Sheet.Round_Value));
    else
      Hpr_Core.Onetime_Sheet_Update(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Sheet_Id     => i_Sheet_Id,
                                    i_Period_Begin => r_Sheet.Period_Begin,
                                    i_Period_End   => r_Sheet.Period_End);
    end if;
  
    z_Hpr_Wage_Sheets.Update_One(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Sheet_Id   => i_Sheet_Id,
                                 i_Posted     => Option_Varchar2('Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Sheet_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sheet_Id   number
  ) is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Lock_Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Sheet_Id   => i_Sheet_Id);
  
    if r_Sheet.Posted = 'N' then
      Hpr_Error.Raise_030(r_Sheet.Sheet_Number);
    end if;
  
    z_Hpr_Wage_Sheets.Update_One(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Sheet_Id   => i_Sheet_Id,
                                 i_Posted     => Option_Varchar2('N'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Save(i_Oper_Type Hpr_Pref.Oper_Type_Rt) is
  begin
    Hpr_Core.Oper_Type_Save(i_Oper_Type);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Oper_Type_Delete
  (
    i_Company_Id   number,
    i_Oper_Type_Id number
  ) is
    r_Oper_Type Mpr_Oper_Types%rowtype;
  begin
    if z_Mpr_Oper_Types.Exist_Lock(i_Company_Id   => i_Company_Id,
                                   i_Oper_Type_Id => i_Oper_Type_Id,
                                   o_Row          => r_Oper_Type) then
      if r_Oper_Type.Pcode is not null then
        Hpr_Error.Raise_031(i_Oper_Type_Id => i_Oper_Type_Id, i_Oper_Type_Name => r_Oper_Type.Name);
      end if;
    
      z_Hpr_Oper_Types.Delete_One(i_Company_Id => i_Company_Id, i_Oper_Type_Id => i_Oper_Type_Id);
    
      Mpr_Api.Oper_Type_Delete(i_Company_Id => i_Company_Id, i_Oper_Type_Id => i_Oper_Type_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Save(i_Book Hpr_Pref.Book_Rt) is
  begin
    Hpr_Core.Book_Save(i_Book);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Book_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  ) is
  begin
    Hpr_Core.Book_Post(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Book_Id    => i_Book_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  ) is
  begin
    Hpr_Core.Book_Unpost(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Book_Id    => i_Book_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Book_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  ) is
  begin
    Hpr_Core.Book_Delete(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Book_Id    => i_Book_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Save(i_Charge_Document Hpr_Pref.Charge_Document_Rt) is
    v_Exist             boolean := false;
    v_Begin_Date        date := i_Charge_Document.Month;
    v_End_Date          date := Last_Day(v_Begin_Date);
    v_Dismissal_Date    date;
    v_New_Operation_Ids Array_Number := Array_Number();
    v_Operation         Hpr_Pref.Charge_Document_Operation_Rt;
    r_Document          Hpr_Charge_Documents%rowtype;
    r_Oper_Type         Hpr_Oper_Types%rowtype;
  begin
    if z_Hpr_Charge_Documents.Exist(i_Company_Id  => i_Charge_Document.Company_Id,
                                    i_Filial_Id   => i_Charge_Document.Filial_Id,
                                    i_Document_Id => i_Charge_Document.Document_Id,
                                    o_Row         => r_Document) then
      if r_Document.Posted = 'Y' then
        Hpr_Error.Raise_047(r_Document.Document_Id);
      end if;
    
      v_Exist := true;
    else
      r_Document.Company_Id  := i_Charge_Document.Company_Id;
      r_Document.Filial_Id   := i_Charge_Document.Filial_Id;
      r_Document.Document_Id := i_Charge_Document.Document_Id;
      r_Document.Posted      := 'N';
    end if;
  
    r_Document.Document_Number := i_Charge_Document.Document_Number;
    r_Document.Month           := i_Charge_Document.Month;
    r_Document.Document_Date   := i_Charge_Document.Document_Date;
    r_Document.Document_Name   := i_Charge_Document.Document_Name;
    r_Document.Oper_Type_Id    := i_Charge_Document.Oper_Type_Id;
    r_Document.Currency_Id     := i_Charge_Document.Currency_Id;
    r_Document.Division_Id     := i_Charge_Document.Division_Id;
    r_Document.Document_Kind   := i_Charge_Document.Document_Kind;
  
    if r_Document.Document_Number is null then
      r_Document.Document_Number := Md_Core.Gen_Number(i_Company_Id => i_Charge_Document.Company_Id,
                                                       i_Filial_Id  => i_Charge_Document.Filial_Id,
                                                       i_Table      => Zt.Hpr_Charge_Documents,
                                                       i_Column     => z.Document_Id);
    end if;
  
    if r_Document.Oper_Type_Id is not null then
      r_Oper_Type := z_Hpr_Oper_Types.Load(i_Company_Id   => i_Charge_Document.Company_Id,
                                           i_Oper_Type_Id => r_Document.Oper_Type_Id);
    
      if r_Oper_Type.Estimation_Type <> Hpr_Pref.c_Estimation_Type_Entered then
        Hpr_Error.Raise_051(r_Oper_Type.Oper_Type_Id);
      end if;
    end if;
  
    if v_Exist then
      z_Hpr_Charge_Documents.Update_Row(i_Row => r_Document);
    else
      z_Hpr_Charge_Documents.Insert_Row(i_Row => r_Document);
    end if;
  
    for i in 1 .. i_Charge_Document.Operations.Count
    loop
      v_Operation := i_Charge_Document.Operations(i);
    
      r_Oper_Type := z_Hpr_Oper_Types.Load(i_Company_Id   => i_Charge_Document.Company_Id,
                                           i_Oper_Type_Id => v_Operation.Oper_Type_Id);
    
      if r_Oper_Type.Estimation_Type <> Hpr_Pref.c_Estimation_Type_Entered then
        Hpr_Error.Raise_051(r_Oper_Type.Oper_Type_Id);
      end if;
    
      v_Dismissal_Date := z_Href_Staffs.Load(i_Company_Id => i_Charge_Document.Company_Id, --
                          i_Filial_Id => i_Charge_Document.Filial_Id, --
                          i_Staff_Id => v_Operation.Staff_Id).Dismissal_Date;
    
      z_Hpr_Charge_Document_Operations.Save_One(i_Company_Id   => i_Charge_Document.Company_Id,
                                                i_Filial_Id    => i_Charge_Document.Filial_Id,
                                                i_Document_Id  => i_Charge_Document.Document_Id,
                                                i_Operation_Id => v_Operation.Operation_Id,
                                                i_Staff_Id     => v_Operation.Staff_Id,
                                                i_Amount       => v_Operation.Amount,
                                                i_Note         => v_Operation.Note);
    
      Hpr_Core.Charge_Insert(i_Company_Id   => i_Charge_Document.Company_Id,
                             i_Filial_Id    => i_Charge_Document.Filial_Id,
                             i_Charge_Id    => v_Operation.Charge_Id,
                             i_Interval_Id  => null,
                             i_Doc_Oper_Id  => v_Operation.Operation_Id,
                             i_Staff_Id     => v_Operation.Staff_Id,
                             i_Oper_Type_Id => v_Operation.Oper_Type_Id,
                             i_Begin_Date   => v_Begin_Date,
                             i_End_Date     => Least(Nvl(v_Dismissal_Date, v_End_Date), v_End_Date),
                             i_Currency_Id  => i_Charge_Document.Currency_Id,
                             i_Amount       => Mk_Util.Calc_Amount_Base(i_Company_Id  => i_Charge_Document.Company_Id,
                                                                        i_Filial_Id   => i_Charge_Document.Filial_Id,
                                                                        i_Currency_Id => i_Charge_Document.Currency_Id,
                                                                        i_Rate_Date   => v_End_Date,
                                                                        i_Amount      => v_Operation.Amount),
                             i_Status       => Hpr_Pref.c_Charge_Status_Draft);
    
      v_New_Operation_Ids.Extend();
      v_New_Operation_Ids(v_New_Operation_Ids.Count) := v_Operation.Operation_Id;
    end loop;
  
    delete Hpr_Charge_Document_Operations q
     where q.Company_Id = i_Charge_Document.Company_Id
       and q.Filial_Id = i_Charge_Document.Filial_Id
       and q.Document_Id = i_Charge_Document.Document_Id
       and q.Operation_Id not in (select *
                                    from table(v_New_Operation_Ids));
  
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  ) is
    r_Document Hpr_Charge_Documents%rowtype;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Document_Id => i_Documentr_Id);
  
    if r_Document.Posted = 'Y' then
      Hpr_Error.Raise_047(i_Document_Number => r_Document.Document_Number);
    end if;
  
    z_Hpr_Charge_Documents.Update_One(i_Company_Id  => r_Document.Company_Id,
                                      i_Filial_Id   => r_Document.Filial_Id,
                                      i_Document_Id => r_Document.Document_Id,
                                      i_Posted      => Option_Varchar2('Y'));
  
    for r in (select Ch.Charge_Id, --
                     q.Document_Id
                from Hpr_Charge_Document_Operations q
                join Hpr_Charges Ch
                  on Ch.Company_Id = q.Company_Id
                 and Ch.Filial_Id = q.Filial_Id
                 and Ch.Doc_Oper_Id = q.Operation_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Document_Id = i_Documentr_Id)
    loop
      Hpr_Core.Charge_New(i_Company_Id  => i_Company_Id,
                          i_Filial_Id   => i_Filial_Id,
                          i_Charge_Id   => r.Charge_Id,
                          i_Document_Id => r.Document_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  ) is
    r_Document Hpr_Charge_Documents%rowtype;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Document_Id => i_Documentr_Id);
  
    if r_Document.Posted = 'N' then
      Hpr_Error.Raise_050(i_Document_Number => r_Document.Document_Number);
    end if;
  
    z_Hpr_Charge_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Document_Id => i_Documentr_Id,
                                      i_Posted      => Option_Varchar2('N'));
  
    for r in (select Ch.Charge_Id, -- 
                     q.Document_Id
                from Hpr_Charge_Document_Operations q
                join Hpr_Charges Ch
                  on Ch.Company_Id = q.Company_Id
                 and Ch.Filial_Id = q.Filial_Id
                 and Ch.Doc_Oper_Id = q.Operation_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Document_Id = i_Documentr_Id)
    loop
      Hpr_Core.Charge_Draft(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Charge_Id   => r.Charge_Id,
                            i_Document_Id => r.Document_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Document_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Documentr_Id number
  ) is
    r_Document Hpr_Charge_Documents%rowtype;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Document_Id => i_Documentr_Id);
  
    if r_Document.Posted = 'Y' then
      Hpr_Error.Raise_048(r_Document.Document_Number);
    end if;
  
    z_Hpr_Charge_Documents.Delete_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Document_Id => i_Documentr_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Advance_Save(i_Advance Hpr_Pref.Advance_Rt) is
  begin
    Hpr_Core.Advance_Save(i_Advance);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Coef_Save
  (
    i_Company_Id number,
    i_Value      number
  ) is
  begin
    if i_Value < 0 then
      Hpr_Error.Raise_032(i_Value);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hpr_Pref.c_Overtime_Coef,
                           i_Value      => Nvl(i_Value, Hpr_Pref.c_Overtime_Coef_Default));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Save(i_Sales_Bonus_Payment Hpr_Pref.Sales_Bonus_Payment_Rt) is
    r_Payment       Hpr_Sales_Bonus_Payments%rowtype;
    v_Operation     Hpr_Pref.Sales_Bonus_Payment_Operation_Rt;
    v_Operation_Ids Array_Number := Array_Number();
    v_Periods       Array_Date;
    v_Period_Begin  date;
    v_Period_End    date;
    v_Amount        number;
    v_Sales_Amount  number;
    v_Tot_Amount    number := 0;
    v_Exists        boolean;
  begin
    if z_Hpr_Sales_Bonus_Payments.Exist_Lock(i_Company_Id => i_Sales_Bonus_Payment.Company_Id,
                                             i_Filial_Id  => i_Sales_Bonus_Payment.Filial_Id,
                                             i_Payment_Id => i_Sales_Bonus_Payment.Payment_Id,
                                             o_Row        => r_Payment) then
      if r_Payment.Posted = 'Y' then
        Hpr_Error.Raise_038(Nvl(i_Sales_Bonus_Payment.Payment_Number, r_Payment.Payment_Number));
      end if;
    
      v_Exists := true;
    else
      r_Payment.Company_Id := i_Sales_Bonus_Payment.Company_Id;
      r_Payment.Filial_Id  := i_Sales_Bonus_Payment.Filial_Id;
      r_Payment.Payment_Id := i_Sales_Bonus_Payment.Payment_Id;
      r_Payment.Posted     := 'N';
    
      v_Exists := false;
    end if;
  
    r_Payment.Payment_Number := i_Sales_Bonus_Payment.Payment_Number;
    r_Payment.Payment_Date   := i_Sales_Bonus_Payment.Payment_Date;
    r_Payment.Payment_Name   := i_Sales_Bonus_Payment.Payment_Name;
    r_Payment.Begin_Date     := i_Sales_Bonus_Payment.Begin_Date;
    r_Payment.End_Date       := i_Sales_Bonus_Payment.End_Date;
    r_Payment.Division_Id    := i_Sales_Bonus_Payment.Division_Id;
    r_Payment.Job_Id         := i_Sales_Bonus_Payment.Job_Id;
    r_Payment.Bonus_Type     := i_Sales_Bonus_Payment.Bonus_Type;
    r_Payment.Payment_Type   := i_Sales_Bonus_Payment.Payment_Type;
    r_Payment.Amount         := 0;
    r_Payment.Note           := i_Sales_Bonus_Payment.Note;
  
    if r_Payment.Payment_Type = Mpr_Pref.c_Pt_Cashbox then
      r_Payment.Cashbox_Id      := i_Sales_Bonus_Payment.Cashbox_Id;
      r_Payment.Bank_Account_Id := null;
    else
      r_Payment.Cashbox_Id      := null;
      r_Payment.Bank_Account_Id := i_Sales_Bonus_Payment.Bank_Account_Id;
    end if;
  
    if v_Exists then
      z_Hpr_Sales_Bonus_Payments.Update_Row(r_Payment);
    else
      if r_Payment.Payment_Number is null then
        r_Payment.Payment_Number := Md_Core.Gen_Number(i_Company_Id => r_Payment.Company_Id,
                                                       i_Filial_Id  => r_Payment.Filial_Id,
                                                       i_Table      => Zt.Hpr_Sales_Bonus_Payments,
                                                       i_Column     => z.Payment_Id);
      end if;
    
      r_Payment.Barcode := Md_Core.Gen_Barcode(i_Table => Zt.Hpr_Sales_Bonus_Payments,
                                               i_Id    => r_Payment.Payment_Id);
    
      z_Hpr_Sales_Bonus_Payments.Insert_Row(r_Payment);
    end if;
  
    v_Operation_Ids.Extend(i_Sales_Bonus_Payment.Operations.Count);
  
    for i in 1 .. i_Sales_Bonus_Payment.Operations.Count
    loop
      v_Operation    := i_Sales_Bonus_Payment.Operations(i);
      v_Amount       := 0;
      v_Sales_Amount := 0;
      v_Periods      := Array_Date();
    
      if Hpr_Util.Is_Staff_Sales_Bonus_Calced(i_Company_Id   => r_Payment.Company_Id,
                                              i_Filial_Id    => r_Payment.Filial_Id,
                                              i_Staff_Id     => v_Operation.Staff_Id,
                                              i_Bonus_Type   => v_Operation.Bonus_Type,
                                              i_Period_Begin => v_Operation.Period_Begin,
                                              i_Period_End   => v_Operation.Period_End,
                                              o_Period_Begin => v_Period_Begin,
                                              o_Period_End   => v_Period_End) = 'Y' then
        Hpr_Error.Raise_039(i_Payment_Number  => r_Payment.Payment_Number,
                            i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => r_Payment.Company_Id,
                                                                      i_Filial_Id  => r_Payment.Filial_Id,
                                                                      i_Staff_Id   => v_Operation.Staff_Id),
                            i_Bonus_Type_Name => Hrm_Util.t_Bonus_Type(v_Operation.Bonus_Type),
                            i_Period_Begin    => v_Period_Begin,
                            i_Period_End      => v_Period_End);
      end if;
    
      if v_Operation.Period_Begin < r_Payment.Begin_Date or
         v_Operation.Period_End > r_Payment.End_Date then
        Hpr_Error.Raise_040(i_Payment_Number  => r_Payment.Payment_Number,
                            i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => r_Payment.Company_Id,
                                                                      i_Filial_Id  => r_Payment.Filial_Id,
                                                                      i_Staff_Id   => v_Operation.Staff_Id),
                            i_Bonus_Type_Name => Hrm_Util.t_Bonus_Type(v_Operation.Bonus_Type),
                            i_Period_Begin    => r_Payment.Begin_Date,
                            i_Period_End      => r_Payment.End_Date);
      end if;
    
      z_Hpr_Sales_Bonus_Payment_Operations.Save_One(i_Company_Id   => r_Payment.Company_Id,
                                                    i_Filial_Id    => r_Payment.Filial_Id,
                                                    i_Operation_Id => v_Operation.Operation_Id,
                                                    i_Payment_Id   => r_Payment.Payment_Id,
                                                    i_Staff_Id     => v_Operation.Staff_Id,
                                                    i_Bonus_Type   => v_Operation.Bonus_Type,
                                                    i_Period_Begin => v_Operation.Period_Begin,
                                                    i_Period_End   => v_Operation.Period_End,
                                                    i_Job_Id       => v_Operation.Job_Id,
                                                    i_Sales_Amount => 0,
                                                    i_Percentage   => v_Operation.Percentage,
                                                    i_Amount       => 0);
    
      for j in 1 .. v_Operation.Periods.Count
      loop
        if v_Operation.Periods(j) between v_Operation.Period_Begin and v_Operation.Period_End then
          z_Hpr_Sales_Bonus_Payment_Operation_Periods.Save_One(i_Company_Id   => r_Payment.Company_Id,
                                                               i_Filial_Id    => r_Payment.Filial_Id,
                                                               i_Operation_Id => v_Operation.Operation_Id,
                                                               i_Period       => v_Operation.Periods(j),
                                                               i_Sales_Amount => v_Operation.Sales_Amounts(j),
                                                               i_Amount       => v_Operation.Amounts(j),
                                                               i_c_Staff_Id   => v_Operation.Staff_Id,
                                                               i_c_Bonus_Type => v_Operation.Bonus_Type);
        
          v_Sales_Amount := v_Sales_Amount + v_Operation.Sales_Amounts(j);
          v_Amount       := v_Amount + v_Operation.Amounts(j);
        
          Fazo.Push(v_Periods, v_Operation.Periods(j));
        end if;
      end loop;
    
      z_Hpr_Sales_Bonus_Payment_Operations.Update_One(i_Company_Id   => r_Payment.Company_Id,
                                                      i_Filial_Id    => r_Payment.Filial_Id,
                                                      i_Operation_Id => v_Operation.Operation_Id,
                                                      i_Sales_Amount => Option_Number(v_Sales_Amount),
                                                      i_Amount       => Option_Number(v_Amount));
    
      v_Tot_Amount := v_Tot_Amount + v_Amount;
      v_Operation_Ids(i) := v_Operation.Operation_Id;
    
      if v_Exists then
        delete from Hpr_Sales_Bonus_Payment_Operation_Periods q
         where q.Company_Id = r_Payment.Company_Id
           and q.Filial_Id = r_Payment.Filial_Id
           and q.Operation_Id = v_Operation.Operation_Id
           and q.Period not member of v_Periods;
      end if;
    end loop;
  
    if v_Exists then
      delete from Hpr_Sales_Bonus_Payment_Operations q
       where q.Company_Id = r_Payment.Company_Id
         and q.Filial_Id = r_Payment.Filial_Id
         and q.Payment_Id = r_Payment.Payment_Id
         and q.Operation_Id not member of v_Operation_Ids;
    end if;
  
    z_Hpr_Sales_Bonus_Payments.Update_One(i_Company_Id => r_Payment.Company_Id,
                                          i_Filial_Id  => r_Payment.Filial_Id,
                                          i_Payment_Id => r_Payment.Payment_Id,
                                          i_Amount     => Option_Number(v_Tot_Amount));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  ) is
  begin
    Hpr_Core.Sales_Bonus_Payment_Post(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Payment_Id => i_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  ) is
  begin
    Hpr_Core.Sales_Bonus_Payment_Unpost(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Payment_Id => i_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  ) is
    r_Payment Hpr_Sales_Bonus_Payments%rowtype;
  begin
    r_Payment := z_Hpr_Sales_Bonus_Payments.Lock_Load(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Payment_Id => i_Payment_Id);
  
    if r_Payment.Posted = 'Y' then
      Hpr_Error.Raise_043(r_Payment.Payment_Number);
    end if;
  
    z_Hpr_Sales_Bonus_Payments.Delete_One(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Payment_Id => i_Payment_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Currency_Settings_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Currency_Ids Array_Number
  ) is
    v_Currency_Ids Array_Number := Nvl(i_Currency_Ids, Array_Number());
  begin
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hpr_Pref.c_Pref_Allow_Other_Currencies,
                           i_Value      => Fazo.Gather(v_Currency_Ids,
                                                       Href_Pref.c_Settings_Separator));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Timebook_Fill_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Settings   varchar2
  ) is
  begin
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hpr_Pref.c_Pref_Timebook_Fill_Settings,
                           i_Value      => i_Settings);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Use_Subfilial_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Setting    varchar2
  ) is
  begin
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hpr_Pref.c_Pref_Use_Subfilial_Settings,
                           i_Value      => i_Setting);
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Save(i_Credit Hpr_Pref.Credit_Rt) is
    r_Credit Hpr_Credits%rowtype;
    v_Exists boolean := true;
  begin
    if not z_Hpr_Credits.Exist_Lock(i_Company_Id => i_Credit.Company_Id,
                                    i_Filial_Id  => i_Credit.Filial_Id,
                                    i_Credit_Id  => i_Credit.Credit_Id,
                                    o_Row        => r_Credit) then
      r_Credit.Company_Id := i_Credit.Company_Id;
      r_Credit.Filial_Id  := i_Credit.Filial_Id;
      r_Credit.Credit_Id  := i_Credit.Credit_Id;
    
      v_Exists := false;
    end if;
  
    r_Credit.Credit_Number   := i_Credit.Credit_Number;
    r_Credit.Credit_Date     := i_Credit.Credit_Date;
    r_Credit.Booked_Date     := i_Credit.Booked_Date;
    r_Credit.Employee_Id     := i_Credit.Employee_Id;
    r_Credit.Begin_Month     := i_Credit.Begin_Month;
    r_Credit.End_Month       := i_Credit.End_Month;
    r_Credit.Credit_Amount   := i_Credit.Credit_Amount;
    r_Credit.Currency_Id     := i_Credit.Currency_Id;
    r_Credit.Payment_Type    := i_Credit.Payment_Type;
    r_Credit.Cashbox_Id      := i_Credit.Cashbox_Id;
    r_Credit.Bank_Account_Id := i_Credit.Bank_Account_Id;
    r_Credit.Status          := Hpr_Pref.c_Credit_Status_Draft;
    r_Credit.Note            := i_Credit.Note;
  
    if v_Exists then
      z_Hpr_Credits.Update_Row(r_Credit);
    else
      if r_Credit.Credit_Number is null then
        r_Credit.Credit_Number := Md_Core.Gen_Number(i_Company_Id => r_Credit.Company_Id,
                                                     i_Filial_Id  => r_Credit.Filial_Id,
                                                     i_Table      => Zt.Hpr_Credits,
                                                     i_Column     => z.Credit_Number);
      end if;
    
      z_Hpr_Credits.Insert_Row(r_Credit);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Draft
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
  begin
    Hpr_Core.Credit_Draft(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Credit_Id  => i_Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Book
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
  begin
    Hpr_Core.Credit_Book(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Credit_Id  => i_Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Credit_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
  begin
    Hpr_Core.Credit_Complete(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Credit_Id  => i_Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Credit_Archive
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
  begin
    Hpr_Core.Credit_Archive(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Credit_Id  => i_Credit_Id);
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
    r_Credit Hpr_Credits%rowtype;
  begin
    r_Credit := z_Hpr_Credits.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Credit_Id  => i_Credit_Id);
  
    if r_Credit.Status <> Hpr_Pref.c_Credit_Status_Draft then
      Hpr_Error.Raise_062(Hpr_Util.t_Credit_Status(r_Credit.Status));
    end if;
  
    z_Hpr_Credits.Delete_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Credit_Id  => i_Credit_Id);
  end;

end Hpr_Api;
/
