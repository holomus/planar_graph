create or replace package Hlic_Core is
  -- License calculation module 
  -- License is given to hired employees
  -- and taken from them when they are dismissed 

  ----------------------------------------------------------------------------------------------------
  -- %usage Gives or Takes license from employees if they are currently working
  -- Should only be called from functions 
  -- that hire and fire employees <br>
  -- if employee works in several filials: 
  -- <ul> 
  --    <li> he doesn't gain additional licenses if he is hired in another filial</li>
  --    <li> he doesn't lose licenses if he is fired from one of filials</li>
  -- </ul>
  Procedure Revise_License_By_Dirty_Staffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Ids  Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  -- %usage Uses kl_subscriptions table to check if license is available 
  -- %raises Hlic_Error.Raise_002 fired when company has expired license
  -- %param i_Company_Id       ID for that you want to check
  -- %param i_Subscription_End is date when you want to check license
  Procedure Check_Subscription
  (
    i_Company_Id       number,
    i_Subscription_End date
  );
  ----------------------------------------------------------------------------------------------------
  -- %usage updates subscription date in kl_subscriptions table  <br>
  -- searches latest date in current month ([current_date, last_day(current_date)]) from <b>kl_license_balances</b>
  -- uses kl_license_balances table rows for current month ([current_date, last_day(current_date)])
  -- to find latest date that doesn't require additional license <br>
  -- if latest date is before current_date 
  -- then subscription date is set to current_date - 1 <br>
  -- if latest date is equal to last_date in current_month (last_day(current_date))
  -- then subscription date is set to last date in next month 
  -- if next month doesn't require additional licenses <br>
  -- if latest date is in the remainder of current_month ([current_date, last_day(current_date)])
  -- then subsriotion date is set to latest date
  Procedure Update_Subscription_Date(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  -- %usage generates rows for Hlic_Required_Dates table starting from last generated date to i_last_gen_date
  -- doesn't generate any dates if interval is stoppped <br>
  -- if interval was not previouly generated 
  -- it generates dates starting from interval.start_date <br>
  -- also fills any holes in generation interval <br>
  -- fills cache for Hlic_Core.Run_Units_Revising <br>
  -- <b>Hlic_Core.Run_Units_Revising must be called after this function</b> <br>
  -- %param i_Interval_Id is primary key ID for Hlic_Required_Intervals   
  -- %param i_Last_Gen_Date is upper bound for date generation
  Procedure Generate_Required_Dates
  (
    i_Company_Id    number,
    i_Interval_Id   number,
    i_Last_Gen_Date date
  );
  ----------------------------------------------------------------------------------------------------
  -- %usage gives/takes license based for employees that are in cache for this function
  -- cache for this function is primarily filled by Hlic_Core.Generate_Required_Dates <br>
  -- other sources may appear in future <br>
  -- %raises Hlic_Error.Raise_001 fires when cache is empty (uninitialised)
  Procedure Run_Units_Revising(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  -- %usage calls Hlic_Core.Generate_Required_Dates and Hlic_Core.Update_Subscription_Date for each active company
  Procedure Generate;
end Hlic_Core;
/
create or replace package body Hlic_Core is
  ----------------------------------------------------------------------------------------------------
  c_Format constant varchar2(8) := 'yyyymmdd';
  ----------------------------------------------------------------------------------------------------
  g_Units       Matrix_Number;
  g_Unit_Indexs Fazo.Number_Code_Aat;
  ----------------------------------------------------------------------------------------------------
  Procedure Init_Units is
    v_Null Fazo.Number_Code_Aat;
  begin
    g_Units       := Matrix_Number();
    g_Unit_Indexs := v_Null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unit_Needs_To_Be_Revise
  (
    i_Person_Id   number,
    i_Revise_Date date
  ) is
    v_Key   varchar2(10) := to_char(i_Revise_Date, c_Format);
    v_Index number;
  begin
    if not g_Unit_Indexs.Exists(v_Key) then
      g_Units.Extend;
      g_Units(g_Units.Count) := Array_Number();
      g_Unit_Indexs(v_Key) := g_Units.Count;
    end if;
  
    v_Index := g_Unit_Indexs(v_Key);
  
    Fazo.Push(g_Units(v_Index), i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unit_Needs_To_Be_Mass_Revise
  (
    i_Person_Id    number,
    i_Revise_Dates Array_Date
  ) is
  begin
    for i in 1 .. i_Revise_Dates.Count
    loop
      Unit_Needs_To_Be_Revise(i_Person_Id   => i_Person_Id, --
                              i_Revise_Date => i_Revise_Dates(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Required_Dates_By_Period
  (
    i_Interval Hlic_Required_Intervals%rowtype,
    i_Start    date,
    i_Finish   date
  ) is
    v_Start date := i_Start;
  begin
    while v_Start <= i_Finish
    loop
      z_Hlic_Required_Dates.Insert_One(i_Company_Id    => i_Interval.Company_Id,
                                       i_Filial_Id     => i_Interval.Filial_Id,
                                       i_Interval_Id   => i_Interval.Interval_Id,
                                       i_Required_Date => v_Start,
                                       i_Employee_Id   => i_Interval.Employee_Id,
                                       i_Staff_Id      => i_Interval.Staff_Id);
    
      Unit_Needs_To_Be_Revise(i_Person_Id   => i_Interval.Employee_Id, --
                              i_Revise_Date => v_Start);
    
      v_Start := v_Start + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Units_Revising(i_Company_Id number) is
    v_Key         varchar2(10);
    v_Date        date;
    v_Index       number;
    v_Employee_Id number;
    v_Ids         Array_Number;
    r_Balance     Kl_License_Balances%rowtype;
    --------------------------------------------------
    Function Check_Return
    (
      i_Company_Id  number,
      i_Employee_Id number,
      i_Date        date
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hlic_Required_Dates q
       where q.Company_Id = i_Company_Id
         and q.Employee_Id = i_Employee_Id
         and q.Required_Date = i_Date
         and Rownum = 1;
    
      return false;
    exception
      when No_Data_Found then
        return true;
    end;
  begin
    if g_Units is null then
      Hlic_Error.Raise_001;
    end if;
  
    v_Key := g_Unit_Indexs.First;
  
    while v_Key is not null
    loop
      v_Index := g_Unit_Indexs(v_Key);
      v_Date  := to_date(v_Key, c_Format);
      v_Ids   := g_Units(v_Index);
    
      r_Balance := Kl_Core.License_Balance_Load(i_Company_Id   => i_Company_Id,
                                                i_License_Code => Hlic_Pref.c_License_Code_Hrm_Base,
                                                i_Balance_Date => v_Date);
    
      for i in 1 .. v_Ids.Count
      loop
      
        v_Employee_Id := v_Ids(i);
      
        if Check_Return(i_Company_Id  => i_Company_Id, --
                        i_Employee_Id => v_Employee_Id,
                        i_Date        => v_Date) then
          -- return license part
          Kl_Core.Return_License(p_Balance   => r_Balance, --
                                 i_Holder_Id => v_Employee_Id);
        else
          -- take license part
          Kl_Core.Take_License(p_Balance   => r_Balance, --
                               i_Holder_Id => v_Employee_Id);
        end if;
      end loop;
    
      Kl_Core.Distribute_Remain_Licenses(r_Balance);
    
      v_Key := g_Unit_Indexs.Next(v_Key);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Insert_And_Generate(i_Staff Href_Staffs%rowtype) is
    result Hlic_Required_Intervals%rowtype;
  begin
    Result.Company_Id  := i_Staff.Company_Id;
    Result.Filial_Id   := i_Staff.Filial_Id;
    Result.Interval_Id := Hlic_Next.Interval_Id;
    Result.Staff_Id    := i_Staff.Staff_Id;
    Result.Employee_Id := i_Staff.Employee_Id;
    Result.Start_Date  := i_Staff.Hiring_Date;
    Result.Finish_Date := i_Staff.Dismissal_Date;
  
    if i_Staff.Dismissal_Date is null then
      Result.Status := Hlic_Pref.c_Interval_Status_Continue;
    else
      Result.Status := Hlic_Pref.c_Interval_Status_Stop;
    end if;
  
    z_Hlic_Required_Intervals.Save_Row(result);
  
    -- generate interval dates
    Add_Required_Dates_By_Period(i_Interval => result,
                                 i_Start    => Result.Start_Date,
                                 i_Finish   => Nvl(Result.Finish_Date,
                                                   Hlic_Util.Max_License_Generate_Date));
  end;
  ----------------------------------------------------------------------------------------------------
  Function Interval_Lock_Load
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return Hlic_Required_Intervals%rowtype is
    result Hlic_Required_Intervals%rowtype;
  begin
    select *
      into result
      from Hlic_Required_Intervals q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       for update;
  
    return result;
  
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Update
  (
    i_Staff    Href_Staffs%rowtype,
    i_Interval Hlic_Required_Intervals%rowtype
  ) is
    r_Interval      Hlic_Required_Intervals%rowtype := i_Interval;
    v_Max_Gen_Date  date := Hlic_Util.Max_License_Generate_Date;
    v_Last_Gen_Date date;
    v_Start         date;
    v_Finish        date;
    v_Revise_Dates  Array_Date;
  begin
    select max(q.Required_Date)
      into v_Last_Gen_Date
      from Hlic_Required_Dates q
     where q.Company_Id = i_Interval.Company_Id
       and q.Interval_Id = i_Interval.Interval_Id;
  
    v_Last_Gen_Date := Nvl(v_Last_Gen_Date, i_Interval.Start_Date - 1);
  
    -- insert new dates; left side  
    Add_Required_Dates_By_Period(i_Interval => i_Interval,
                                 i_Start    => i_Staff.Hiring_Date,
                                 i_Finish   => i_Interval.Start_Date - 1);
  
    -- insert new dates; right side
    Add_Required_Dates_By_Period(i_Interval => i_Interval,
                                 i_Start    => v_Last_Gen_Date + 1,
                                 i_Finish   => Nvl(i_Staff.Dismissal_Date, v_Max_Gen_Date));
    -- remove excesses dates; left side  
    v_Finish := i_Staff.Hiring_Date;
  
    delete Hlic_Required_Dates q
     where q.Company_Id = i_Interval.Company_Id
       and q.Interval_Id = i_Interval.Interval_Id
       and q.Required_Date < v_Finish
    returning q.Required_Date bulk collect into v_Revise_Dates;
  
    Unit_Needs_To_Be_Mass_Revise(i_Person_Id    => i_Interval.Employee_Id,
                                 i_Revise_Dates => v_Revise_Dates);
  
    -- remove excesses dates; right side      
    v_Start := Nvl(i_Staff.Dismissal_Date, v_Max_Gen_Date);
  
    delete Hlic_Required_Dates q
     where q.Company_Id = i_Interval.Company_Id
       and q.Interval_Id = i_Interval.Interval_Id
       and q.Required_Date > v_Start
    returning q.Required_Date bulk collect into v_Revise_Dates;
  
    Unit_Needs_To_Be_Mass_Revise(i_Person_Id    => i_Interval.Employee_Id,
                                 i_Revise_Dates => v_Revise_Dates);
  
    -- update interval  
    r_Interval.Start_Date  := i_Staff.Hiring_Date;
    r_Interval.Finish_Date := i_Staff.Dismissal_Date;
  
    if r_Interval.Finish_Date is null then
      r_Interval.Status := Hlic_Pref.c_Interval_Status_Continue;
    else
      r_Interval.Status := Hlic_Pref.c_Interval_Status_Stop;
    end if;
  
    z_Hlic_Required_Intervals.Save_Row(r_Interval);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Interval_Remove(i_Interval Hlic_Required_Intervals%rowtype) is
    v_Revise_Dates Array_Date;
  begin
    delete Hlic_Required_Dates q
     where q.Company_Id = i_Interval.Company_Id
       and q.Interval_Id = i_Interval.Interval_Id
    returning q.Required_Date bulk collect into v_Revise_Dates;
  
    Unit_Needs_To_Be_Mass_Revise(i_Person_Id    => i_Interval.Employee_Id,
                                 i_Revise_Dates => v_Revise_Dates);
  
    z_Hlic_Required_Intervals.Delete_One(i_Company_Id  => i_Interval.Company_Id,
                                         i_Interval_Id => i_Interval.Interval_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Interval
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff    Href_Staffs%rowtype;
    r_Interval Hlic_Required_Intervals%rowtype;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    -- this is when primary staff changes secondary and need to remove
    if r_Staff.Staff_Kind = Href_Pref.c_Staff_Kind_Secondary then
      r_Staff.State := 'P';
    end if;
  
    Kl_Core.License_Lock_Holder_Lock(i_Company_Id => i_Company_Id,
                                     i_Holder_Id  => r_Staff.Employee_Id);
  
    r_Interval := Interval_Lock_Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id);
  
    if r_Interval.Company_Id is null then
      if r_Staff.State = 'P' then
        return;
      end if;
    
      Interval_Insert_And_Generate(r_Staff);
    elsif r_Staff.State = 'P' then
      Interval_Remove(r_Interval);
    else
      Interval_Update(i_Staff => r_Staff, i_Interval => r_Interval);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Subscription
  (
    i_Company_Id       number,
    i_Subscription_End date
  ) is
    v_Curr_Date        date := Trunc(Current_Date);
    v_Subscription_End date := Nvl(i_Subscription_End, Last_Day(v_Curr_Date));
    v_Available        number;
    v_Required         number;
  
    r_Subscription Kl_Subscriptions%rowtype;
  begin
    if Md_Util.License_Disabled(i_Company_Id) or i_Company_Id = Md_Pref.Company_Head then
      return;
    end if;
  
    r_Subscription := z_Kl_Subscriptions.Lock_Load(i_Company_Id   => i_Company_Id,
                                                   i_Project_Code => Verifix.Project_Code);
  
    if r_Subscription.End_Date < v_Curr_Date then
      select min(p.Available_Amount), max(p.Required_Amount)
        into v_Available, v_Required
        from Kl_License_Balances p
       where p.Company_Id = i_Company_Id
         and p.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
         and p.Balance_Date between v_Curr_Date and v_Subscription_End;
    
      Hlic_Error.Raise_002(v_Required - v_Available);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Subscription_Date(i_Company_Id number) is
    v_Curr_Date         date := Trunc(Current_Date);
    v_Subscription_Date date;
    v_Last_Date         date;
    v_Next_Last_Date    date;
    v_Subscribed        boolean := false;
    v_Cnt               number;
  begin
    v_Last_Date := Last_Day(v_Curr_Date);
  
    for r in (select *
                from Kl_License_Balances q
               where q.Company_Id = i_Company_Id
                 and q.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
                 and q.Balance_Date between v_Curr_Date and v_Last_Date
               order by q.Balance_Date desc)
    loop
      if r.Available_Amount > 0 and not v_Subscribed then
        v_Subscribed        := true;
        v_Subscription_Date := r.Balance_Date;
      end if;
    
      if v_Subscribed and r.Required_Amount > 0 then
        v_Subscribed := false;
        exit;
      end if;
    end loop;
  
    if not v_Subscribed then
      v_Subscription_Date := v_Curr_Date - 1;
    elsif v_Subscription_Date = v_Last_Date then
      v_Next_Last_Date := Last_Day(v_Last_Date + 1);
    
      select count(1)
        into v_Cnt
        from Kl_License_Balances Lb
       where Lb.Company_Id = i_Company_Id
         and Lb.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
         and Lb.Balance_Date between v_Last_Date + 1 and v_Next_Last_Date
         and Lb.Required_Amount = 0;
    
      if v_Cnt = v_Next_Last_Date - v_Last_Date then
        v_Subscription_Date := v_Next_Last_Date;
      end if;
    end if;
  
    z_Kl_Subscriptions.Save_One(i_Company_Id   => i_Company_Id,
                                i_Project_Code => Verifix.Project_Code,
                                i_End_Date     => v_Subscription_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_License_By_Dirty_Staffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Ids  Array_Number
  ) is
    v_Subscription_End date;
  begin
    return;
    Init_Units;
  
    for i in 1 .. i_Staff_Ids.Count
    loop
      Fix_Interval(i_Company_Id => i_Company_Id,
                   i_Filial_Id  => i_Filial_Id,
                   i_Staff_Id   => i_Staff_Ids(i));
    end loop;
  
    Run_Units_Revising(i_Company_Id);
  
    v_Subscription_End := z_Kl_Subscriptions.Take(i_Company_Id => i_Company_Id, --
                          i_Project_Code => Verifix.Project_Code).End_Date;
  
    Update_Subscription_Date(i_Company_Id);
  
    Check_Subscription(i_Company_Id, v_Subscription_End);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Required_Dates
  (
    i_Company_Id    number,
    i_Interval_Id   number,
    i_Last_Gen_Date date
  ) is
    r_Interval Hlic_Required_Intervals%rowtype;
    v_Start    date;
  begin
    r_Interval := z_Hlic_Required_Intervals.Lock_Load(i_Company_Id  => i_Company_Id,
                                                      i_Interval_Id => i_Interval_Id);
  
    if r_Interval.Status = Hlic_Pref.c_Interval_Status_Stop then
      return;
    end if;
  
    select max(q.Required_Date)
      into v_Start
      from Hlic_Required_Dates q
     where q.Company_Id = i_Company_Id
       and q.Interval_Id = i_Interval_Id;
  
    Add_Required_Dates_By_Period(i_Interval => r_Interval,
                                 i_Start    => Nvl(v_Start + 1, r_Interval.Start_Date),
                                 i_Finish   => i_Last_Gen_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Company(i_Company_Id number) is
    v_Date date := Hlic_Util.Max_License_Generate_Date;
  begin
    Biruni_Route.Context_Begin;
  
    Init_Units;
  
    for r in (select *
                from Hlic_Required_Intervals q
               where q.Company_Id = i_Company_Id
                 and q.Status = Hlic_Pref.c_Interval_Status_Continue
               order by q.Employee_Id)
    loop
      Kl_Core.License_Lock_Holder_Lock(i_Company_Id => i_Company_Id, --
                                       i_Holder_Id  => r.Employee_Id);
    
      Generate_Required_Dates(i_Company_Id    => i_Company_Id,
                              i_Interval_Id   => r.Interval_Id,
                              i_Last_Gen_Date => v_Date);
    end loop;
  
    Run_Units_Revising(i_Company_Id);
  
    Update_Subscription_Date(i_Company_Id);
  
    Biruni_Route.Context_End;
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate is
  begin
    return;
    for c in (select *
                from Md_Companies q
               where q.State = 'A'
               order by q.Company_Id)
    loop
      Generate_Company(c.Company_Id);
    end loop;
  end;

end Hlic_Core;
/
