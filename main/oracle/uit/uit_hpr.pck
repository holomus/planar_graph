create or replace package Uit_Hpr is
  ----------------------------------------------------------------------------------------------------
  -- salary types of START
  ----------------------------------------------------------------------------------------------------
  c_Salary_Type_Hourly             constant varchar2(1) := 'H';
  c_Salary_Type_Daily              constant varchar2(1) := 'D';
  c_Salary_Type_Monthly            constant varchar2(1) := 'M';
  c_Salary_Type_Monthly_Summarized constant varchar2(1) := 'S';
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Wage_Sheet
  (
    i_Sheet_Id   number,
    i_Sheet_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Get_Unlicensed_Staffs
  (
    p_Staff_Ids    in out Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Facts
  (
    i_Staff_Ids    Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Totals
  (
    i_Staff_Ids    Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Timebook_Staff
  (
    i_Month    date,
    i_Staff_Id number
  ) return Hpr_Pref.Timebook_Staff_Info;
  ----------------------------------------------------------------------------------------------------
  Function Get_Salary_Type_Id(i_Salary_Type varchar2) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Sales_Bonus_Operations
  (
    i_Begin_Date  date,
    i_End_Date    date,
    i_Division_Id number := null,
    i_Job_Id      number := null,
    i_Bonus_Type  varchar2 := null,
    i_Staff_Ids   Array_Number := null
  ) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------
  Function Load_Allowed_Currencies return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Is_Approximately_Wage
  (
    i_Staff_Id       number,
    i_Dismissal_Date date,
    i_Hiring_Date    date,
    i_Begin_Date     date,
    i_End_Date       date,
    i_Is_Pro         boolean
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Calculation_Start
  (
    i_Staff_Id         number,
    i_Begin_Date       date,
    i_End_Date         date,
    o_Worked_Hours     out number,
    o_Worked_Days      out number,
    o_Wage_Amount      out number,
    o_Overtime_Amount  out number,
    o_Onetime_Accrual  out number,
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    o_Onetime_Penalty  out number,
    o_Total_Accrual    out number,
    o_Total_Deduction  out number,
    o_Payment          out number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Calculation_Pro
  (
    i_Staff_Id             number,
    i_Begin_Date           date,
    i_End_Date             date,
    o_Total_Accrual        out number,
    o_Total_Deduction      out number,
    o_Income_Tax           out number,
    o_Worked_Hours         out number,
    o_Worked_Days          out number,
    o_Payment              out number,
    o_Credit               out number,
    o_Accrual_Oper_Types   out Matrix_Varchar2,
    o_Deduction_Oper_Types out Matrix_Varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Assert_Access_To_Book(i_Book_Id number);
  ----------------------------------------------------------------------------------------------------  
  Function Load_Division_Subfilial(i_Division_Id number) return number;
end Uit_Hpr;
/
create or replace package body Uit_Hpr is
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Wage_Sheet
  (
    i_Sheet_Id   number,
    i_Sheet_Kind varchar2
  ) is
  begin
    if Uit_Href.User_Access_All_Employees = 'N' then
      if i_Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Regular then
        for r in (select (select s.Employee_Id
                            from Href_Staffs s
                           where s.Company_Id = q.Company_Id
                             and s.Filial_Id = q.Filial_Id
                             and s.Staff_Id = q.Staff_Id) Employee_Id
                    from Hpr_Sheet_Parts q
                   where q.Company_Id = Ui.Company_Id
                     and q.Filial_Id = Ui.Filial_Id
                     and q.Sheet_Id = i_Sheet_Id)
        loop
          Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r.Employee_Id);
        end loop;
      elsif i_Sheet_Kind = Hpr_Pref.c_Wage_Sheet_Onetime then
        for r in (select (select s.Employee_Id
                            from Href_Staffs s
                           where s.Company_Id = q.Company_Id
                             and s.Filial_Id = q.Filial_Id
                             and s.Staff_Id = q.Staff_Id) Employee_Id
                    from Hpr_Onetime_Sheet_Staffs q
                   where q.Company_Id = Ui.Company_Id
                     and q.Filial_Id = Ui.Filial_Id
                     and q.Sheet_Id = i_Sheet_Id)
        loop
          Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r.Employee_Id);
        end loop;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Unlicensed_Staffs
  (
    p_Staff_Ids    in out Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Arraylist is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Staff_Ids  Array_Number;
    result       Matrix_Varchar2;
  begin
    select Array_Varchar2(s.Staff_Id,
                          (select Np.Name
                             from Mr_Natural_Persons Np
                            where Np.Company_Id = v_Company_Id
                              and Np.Person_Id = s.Employee_Id),
                          s.Staff_Number),
           s.Staff_Id
      bulk collect
      into result, v_Staff_Ids
      from Href_Staffs s
     where s.Company_Id = v_Company_Id
       and s.Filial_Id = v_Filial_Id
       and s.Staff_Id in (select *
                            from table(p_Staff_Ids))
       and s.State = 'A'
       and s.Hiring_Date <= i_Period_End
       and Nvl(s.Dismissal_Date, i_Period_Begin) >= i_Period_Begin
       and exists (select 1
              from Href_Util.Staff_Licensed_Period(i_Company_Id   => v_Company_Id,
                                                   i_Filial_Id    => v_Filial_Id,
                                                   i_Staff_Id     => s.Staff_Id,
                                                   i_Period_Begin => i_Period_Begin,
                                                   i_Period_End   => i_Period_End) Lp
             where Lp.Licensed = 'N');
  
    p_Staff_Ids := p_Staff_Ids multiset Except v_Staff_Ids;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Facts
  (
    i_Staff_Ids    Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Arraylist is
    result Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Staff_Id,
                          q.Timesheet_Date,
                          q.Day_Kind,
                          Nvl(Tl.Facts_Changed, 'N'),
                          Nvl(Tk.Parent_Id, Tk.Time_Kind_Id),
                          Nvl(Round(sum(Tf.Fact_Value) / 3600, 2), 0))
      bulk collect
      into result
      from Htt_Timesheets q
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = q.Company_Id
       and Tf.Filial_Id = q.Filial_Id
       and Tf.Timesheet_Id = q.Timesheet_Id
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Tf.Company_Id
       and Tk.Time_Kind_Id = Tf.Time_Kind_Id
      left join Htt_Timesheet_Locks Tl
        on Tl.Company_Id = q.Company_Id
       and Tl.Filial_Id = q.Filial_Id
       and Tl.Staff_Id = q.Staff_Id
       and Tl.Timesheet_Date = q.Timesheet_Date
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id member of i_Staff_Ids
       and q.Timesheet_Date >= i_Period_Begin
       and q.Timesheet_Date <= i_Period_End
       and Tf.Fact_Value > 0
     group by q.Staff_Id, --
              q.Timesheet_Date,
              q.Day_Kind,
              Nvl(Tl.Facts_Changed, 'N'),
              Nvl(Tk.Parent_Id, Tk.Time_Kind_Id);
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Fact_Totals
  (
    i_Staff_Ids    Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Arraylist is
    result Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Staff_Id, --
                          Nvl(Tk.Parent_Id, Tk.Time_Kind_Id),
                          Round(sum(Tf.Fact_Value) / 3600, 2))
      bulk collect
      into result
      from Htt_Timesheets q
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = q.Company_Id
       and Tf.Filial_Id = q.Filial_Id
       and Tf.Timesheet_Id = q.Timesheet_Id
      join Htt_Time_Kinds Tk
        on Tk.Company_Id = Tf.Company_Id
       and Tk.Time_Kind_Id = Tf.Time_Kind_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id member of i_Staff_Ids
       and q.Timesheet_Date >= i_Period_Begin
       and q.Timesheet_Date <= i_Period_End
       and Tf.Fact_Value > 0
     group by q.Staff_Id, Nvl(Tk.Parent_Id, Tk.Time_Kind_Id);
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Totals
  (
    i_Staff_Ids    Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Hashmap is
    v_Turnout_Id number;
    v_Totals     Matrix_Varchar2;
    result       Hashmap := Hashmap();
  begin
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    with q_Timesheets as
     (select *
        from Htt_Timesheets t
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Staff_Id member of i_Staff_Ids
         and t.Timesheet_Date >= i_Period_Begin
         and t.Timesheet_Date <= i_Period_End)
    select Array_Varchar2(p.Staff_Id, --
                          Nvl(p.Plan_Days, 0),
                          Nvl(p.Plan_Hours, 0),
                          Nvl(f.Fact_Days, 0),
                          Nvl(f.Fact_Hours, 0))
      bulk collect
      into v_Totals
      from (select Qt.Staff_Id, --
                   count(*) Plan_Days,
                   Round(sum(Qt.Plan_Time) / 3600, 2) Plan_Hours
              from q_Timesheets Qt
             where Qt.Day_Kind in (Htt_Pref.c_Day_Kind_Nonworking, Htt_Pref.c_Day_Kind_Work)
               and Qt.Full_Time > 0
             group by Qt.Staff_Id) p
      left join (select Qt.Staff_Id,
                        count(distinct Qt.Timesheet_Id) Fact_Days,
                        Round(sum(Tf.Fact_Value) / 3600, 2) Fact_Hours
                   from q_Timesheets Qt
                   join Htt_Timesheet_Facts Tf
                     on Tf.Company_Id = Qt.Company_Id
                    and Tf.Filial_Id = Qt.Filial_Id
                    and Tf.Timesheet_Id = Qt.Timesheet_Id
                   join Htt_Time_Kinds Tk
                     on Tk.Company_Id = Tf.Company_Id
                    and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                  where Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Turnout_Id
                    and Tf.Fact_Value > 0
                  group by Qt.Staff_Id) f
        on f.Staff_Id = p.Staff_Id;
  
    Result.Put('fact_totals',
               Get_Staff_Fact_Totals(i_Staff_Ids    => i_Staff_Ids,
                                     i_Period_Begin => i_Period_Begin,
                                     i_Period_End   => i_Period_End));
  
    Result.Put('totals', Fazo.Zip_Matrix(v_Totals));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Timebook_Staff
  (
    i_Month    date,
    i_Staff_Id number
  ) return Hpr_Pref.Timebook_Staff_Info is
    result Hpr_Pref.Timebook_Staff_Info;
  begin
    select i_Staff_Id, --
           sum(q.Plan_Hours),
           sum(q.Plan_Days),
           sum(q.Fact_Hours),
           sum(q.Fact_Days)
      into result
      from Hpr_Timebook_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id = i_Staff_Id
       and exists (select *
              from Hpr_Timebooks w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Timebook_Id = q.Timebook_Id
               and w.Month = i_Month
               and w.Posted = 'Y');
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Salary_Type_Id(i_Salary_Type varchar2) return number is
    v_Salary_Pcode varchar2(20);
  begin
    case i_Salary_Type
      when c_Salary_Type_Monthly then
        v_Salary_Pcode := Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly;
      when c_Salary_Type_Daily then
        v_Salary_Pcode := Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily;
      when c_Salary_Type_Hourly then
        v_Salary_Pcode := Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly;
      else
        b.Raise_Not_Implemented;
    end case;
  
    return Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id, i_Pcode => v_Salary_Pcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Sales_Bonus_Operations
  (
    i_Begin_Date  date,
    i_End_Date    date,
    i_Division_Id number := null,
    i_Job_Id      number := null,
    i_Bonus_Type  varchar2 := null,
    i_Staff_Ids   Array_Number := null
  ) return Json_Array_t is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Staff_Count   number := 0;
    v_Last_Staff_Id number := -1;
    v_Period_Begin  date;
    v_Period_End    date;
    v_Currency_Id   number;
  
    v_Part    Gmap;
    v_Period  Gmap;
    v_Periods Glist;
    result    Glist := Glist;
  
    --------------------------------------------------
    Function Round_Amount(i_Val number) return number is
    begin
      return Mk_Util.Round_Amount(i_Company_Id  => v_Company_Id,
                                  i_Currency_Id => v_Currency_Id,
                                  i_Amount      => i_Val);
    end;
  
    --------------------------------------------------
    Function Personal_Division_Sales_Amount
    (
      i_Staff_Code    varchar2,
      i_Division_Code varchar2,
      i_Period        date
    ) return number is
      result number;
    begin
      select Nvl(sum(Cs.Sale_Amount), 0)
        into result
        from Hes_Billz_Consolidated_Sales Cs
       where Cs.Company_Id = v_Company_Id
         and Cs.Filial_Id = v_Filial_Id
         and Cs.Billz_Seller_Id = i_Staff_Code
         and Cs.Billz_Office_Id = i_Division_Code
         and Cs.Sale_Date = i_Period;
    
      return result;
    end;
  begin
    if i_Staff_Ids is not null then
      v_Staff_Count := i_Staff_Ids.Count;
    end if;
  
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id);
  
    for Trans in (with Trans as
                     (select s.Staff_Id,
                            s.Staff_Number,
                            s.Employee_Id,
                            s.Staff_Kind,
                            a.Trans_Id,
                            a.Period
                       from Href_Staffs s
                       join Hpd_Agreements a
                         on a.Company_Id = v_Company_Id
                        and a.Filial_Id = v_Filial_Id
                        and a.Staff_Id = s.Staff_Id
                        and a.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                        and a.Period = (select max(A1.Period)
                                          from Hpd_Agreements A1
                                         where A1.Company_Id = v_Company_Id
                                           and A1.Filial_Id = v_Filial_Id
                                           and A1.Staff_Id = s.Staff_Id
                                           and A1.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                           and A1.Period <= i_Begin_Date)
                      where s.Company_Id = v_Company_Id
                        and s.Filial_Id = v_Filial_Id
                        and s.State = 'A'
                        and s.Hiring_Date <= i_End_Date
                        and (s.Dismissal_Date is null or s.Dismissal_Date >= i_Begin_Date)
                        and (v_Staff_Count = 0 or s.Staff_Id member of i_Staff_Ids)
                     union
                     select s.Staff_Id,
                            s.Staff_Number,
                            s.Employee_Id,
                            s.Staff_Kind,
                            a.Trans_Id,
                            a.Period
                       from Href_Staffs s
                       join Hpd_Agreements a
                         on a.Company_Id = v_Company_Id
                        and a.Filial_Id = v_Filial_Id
                        and a.Staff_Id = s.Staff_Id
                        and a.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                        and a.Period between i_Begin_Date and i_End_Date
                      where s.Company_Id = v_Company_Id
                        and s.Filial_Id = v_Filial_Id
                        and s.State = 'A'
                        and s.Hiring_Date <= i_End_Date
                        and (s.Dismissal_Date is null or s.Dismissal_Date >= i_Begin_Date)
                        and (v_Staff_Count = 0 or s.Staff_Id member of i_Staff_Ids))
                    select q.Staff_Id,
                           q.Staff_Kind,
                           q.Employee_Id,
                           (select Np.Name
                              from Mr_Natural_Persons Np
                             where Np.Company_Id = v_Company_Id
                               and Np.Person_Id = q.Employee_Id) as Staff_Name,
                           (select Np.Code
                              from Mr_Natural_Persons Np
                             where Np.Company_Id = v_Company_Id
                               and Np.Person_Id = q.Employee_Id) as Staff_Code,
                           q.Staff_Number,
                           q.Period,
                           (select Mr.Name
                              from Mrf_Robots Mr
                             where Mr.Company_Id = v_Company_Id
                               and Mr.Filial_Id = v_Filial_Id
                               and Mr.Robot_Id = Tr.Robot_Id) as Robot_Name,
                           Tr.Division_Id,
                           (select d.Name
                              from Mhr_Divisions d
                             where d.Company_Id = v_Company_Id
                               and d.Filial_Id = v_Filial_Id
                               and d.Division_Id = Tr.Division_Id) as Division_Name,
                           (select d.Code
                              from Mhr_Divisions d
                             where d.Company_Id = v_Company_Id
                               and d.Filial_Id = v_Filial_Id
                               and d.Division_Id = Tr.Division_Id) as Division_Code,
                           Tr.Job_Id,
                           (select j.Name
                              from Mhr_Jobs j
                             where j.Company_Id = v_Company_Id
                               and j.Filial_Id = v_Filial_Id
                               and j.Job_Id = Tr.Job_Id) as Job_Name
                      from Trans q
                      join Hpd_Trans_Robots Tr
                        on Tr.Company_Id = v_Company_Id
                       and Tr.Filial_Id = v_Filial_Id
                       and Tr.Trans_Id = q.Trans_Id
                     order by q.Staff_Id, q.Period desc)
    loop
      if v_Last_Staff_Id <> Trans.Staff_Id then
        v_Last_Staff_Id := Trans.Staff_Id;
      
        v_Period_End := i_End_Date;
      end if;
    
      v_Period_Begin := Greatest(Trans.Period, i_Begin_Date);
    
      continue when(i_Division_Id is not null and Trans.Division_Id <> i_Division_Id) --
      or(i_Job_Id is not null and Trans.Job_Id <> i_Job_Id);
    
      -- calc periods
      v_Periods := Glist;
    
      for r in (select Period.Period,
                       j.Bonus_Type,
                       j.Percentage,
                       (select Nvl(sum(Cs.Sale_Amount), 0)
                          from Hes_Billz_Consolidated_Sales Cs
                         where Cs.Company_Id = v_Company_Id
                           and Cs.Filial_Id = v_Filial_Id
                           and (j.Bonus_Type = Hrm_Pref.c_Bonus_Type_Personal_Sales and
                               Cs.Billz_Seller_Id = Trans.Staff_Code or
                               j.Bonus_Type = Hrm_Pref.c_Bonus_Type_Department_Sales and
                               Cs.Billz_Office_Id = Trans.Division_Code)
                           and Cs.Sale_Date = Period.Period) as Sales_Amount
                  from (select v_Period_Begin + level - 1 as Period
                          from Dual
                        connect by level <= v_Period_End - v_Period_Begin + 1) Period
                  join Hrm_Job_Bonus_Types j
                    on j.Company_Id = v_Company_Id
                   and j.Filial_Id = v_Filial_Id
                   and j.Job_Id = Trans.Job_Id
                   and (i_Bonus_Type is null or j.Bonus_Type = i_Bonus_Type)
                   and (j.Bonus_Type = Hrm_Pref.c_Bonus_Type_Department_Sales or
                       Trans.Staff_Kind = Href_Pref.c_Staff_Kind_Primary)
                 where not exists (select 1
                          from Hpr_Sales_Bonus_Payment_Operation_Periods o
                         where o.Company_Id = v_Company_Id
                           and o.Filial_Id = v_Filial_Id
                           and o.c_Staff_Id = Trans.Staff_Id
                           and o.c_Bonus_Type = j.Bonus_Type
                           and o.Period = Period.Period
                           and exists (select 1
                                  from Hpr_Sales_Bonus_Payment_Intervals i
                                 where i.Company_Id = v_Company_Id
                                   and i.Filial_Id = v_Filial_Id
                                   and i.Operation_Id = o.Operation_Id)))
      loop
        -- todo; Owner: Sherzod; text: uncommit
      
        /*if r.Bonus_Type = Hrm_Pref.c_Bonus_Type_Successful_Delivery then
          v_Amount       := 0;
          v_Sales_Amount := 0;
        end if;*/
      
        if r.Bonus_Type = Hrm_Pref.c_Bonus_Type_Department_Sales then
          r.Sales_Amount := r.Sales_Amount -
                            Personal_Division_Sales_Amount(i_Staff_Code    => Trans.Staff_Code,
                                                           i_Division_Code => Trans.Division_Code,
                                                           i_Period        => r.Period);
        end if;
      
        v_Period := Gmap;
      
        v_Period.Put('period', r.Period);
        v_Period.Put('bonus_type', r.Bonus_Type);
        v_Period.Put('percentage', r.Percentage);
        v_Period.Put('sales_amount', r.Sales_Amount);
        v_Period.Put('amount', Round_Amount(r.Percentage * r.Sales_Amount / 100));
      
        v_Periods.Push(v_Period.Val);
      end loop;
    
      continue when v_Periods.Count = 0;
    
      v_Part := Gmap;
    
      v_Part.Put('employee_id', Trans.Employee_Id);
      v_Part.Put('staff_id', Trans.Staff_Id);
      v_Part.Put('staff_name', Trans.Staff_Name);
      v_Part.Put('staff_number', Trans.Staff_Number);
      v_Part.Put('period_begin', v_Period_Begin);
      v_Part.Put('period_end', v_Period_End);
      v_Part.Put('robot_name', Trans.Robot_Name);
      v_Part.Put('division_name', Trans.Division_Name);
      v_Part.Put('job_id', Trans.Job_Id);
      v_Part.Put('job_name', Trans.Job_Name);
      v_Part.Put('periods', v_Periods);
    
      v_Period_End := v_Period_Begin - 1;
    
      Result.Push(v_Part.Val);
    end loop;
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Allowed_Currencies return Arraylist is
    v_Currency_Ids   Array_Number;
    v_Settings_Array Arraylist;
    r_Currency       Mk_Currencies%rowtype;
  begin
    v_Currency_Ids := Hpr_Util.Load_Currency_Settings(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => Ui.Filial_Id);
  
    v_Settings_Array := Arraylist();
  
    for i in 1 .. v_Currency_Ids.Count
    loop
      if z_Mk_Currencies.Exist(i_Company_Id  => Ui.Company_Id,
                               i_Currency_Id => v_Currency_Ids(i),
                               o_Row         => r_Currency) then
        v_Settings_Array.Push(z_Mk_Currencies.To_Map(r_Currency, z.Currency_Id, z.Name));
      end if;
    end loop;
  
    return v_Settings_Array;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Approximately_Wage
  (
    i_Staff_Id       number,
    i_Dismissal_Date date,
    i_Hiring_Date    date,
    i_Begin_Date     date,
    i_End_Date       date,
    i_Is_Pro         boolean
  ) return varchar2 is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Month_Day   number;
    v_Period      number;
    v_Employee_Id number;
  
    --------------------------------------------------
    Function Book_Exists return boolean is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Mpr_Book_Operations q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Employee_Id = v_Employee_Id
         and exists (select *
                from Mpr_Books w
               where w.Company_Id = v_Company_Id
                 and w.Filial_Id = v_Filial_Id
                 and w.Book_Id = q.Book_Id
                 and w.Posted = 'Y'
                 and w.Month between i_Begin_Date and i_End_Date)
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id,
                                               i_Staff_Id   => i_Staff_Id);
  
    if i_Is_Pro then
      select Nvl(sum(t.Period_End - t.Period_Begin + 1), 0)
        into v_Period
        from Hpr_Timebooks t
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Period_Begin >= i_Begin_Date
         and t.Period_End <= i_End_Date
         and t.Posted = 'Y'
         and exists (select *
                from Hpr_Timebook_Staffs w
               where w.Company_Id = t.Company_Id
                 and w.Filial_Id = t.Filial_Id
                 and w.Timebook_Id = t.Timebook_Id
                 and w.Staff_Id = i_Staff_Id);
    else
      select Nvl(sum(q.Part_End - q.Part_Begin + 1), 0)
        into v_Period
        from Hpr_Sheet_Parts q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Part_Begin >= i_Begin_Date
         and q.Part_End <= i_End_Date
         and q.Staff_Id = i_Staff_Id
         and exists (select 1
                from Hpr_Wage_Sheets Sh
               where Sh.Company_Id = q.Company_Id
                 and Sh.Filial_Id = q.Filial_Id
                 and Sh.Sheet_Id = q.Sheet_Id
                 and Sh.Posted = 'Y');
    end if;
  
    v_Month_Day := Least(i_End_Date, Nvl(i_Dismissal_Date, i_End_Date)) -
                   Greatest(i_Begin_Date, i_Hiring_Date) + 1;
  
    if v_Period <> v_Month_Day or (i_Is_Pro and not Book_Exists) then
      return 'Y';
    end if;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Calculation_Start
  (
    i_Staff_Id         number,
    i_Begin_Date       date,
    i_End_Date         date,
    o_Worked_Hours     out number,
    o_Worked_Days      out number,
    o_Wage_Amount      out number,
    o_Overtime_Amount  out number,
    o_Onetime_Accrual  out number,
    o_Late_Amount      out number,
    o_Early_Amount     out number,
    o_Lack_Amount      out number,
    o_Day_Skip_Amount  out number,
    o_Mark_Skip_Amount out number,
    o_Onetime_Penalty  out number,
    o_Total_Accrual    out number,
    o_Total_Deduction  out number,
    o_Payment          out number
  ) is
    v_Company_Id       number := Ui.Company_Id;
    v_Filial_Id        number := Ui.Filial_Id;
    v_Oper_Group_Id    number;
    v_Oper_Type_Id     number;
    v_Overtime_Type_Id number;
    v_Hourly_Wage      number;
    v_Time_Kind_Id     number;
    v_Late_Amount      number;
    v_Early_Amount     number;
    v_Lack_Amount      number;
    v_Day_Skip_Amount  number;
    v_Mark_Skip_Amount number;
    v_Division_Id      number;
    v_Schedule_Id      number;
    v_Parts            Hpd_Pref.Transaction_Part_Nt;
    r_Staff            Href_Staffs%rowtype;
  begin
    o_Wage_Amount      := 0;
    o_Overtime_Amount  := 0;
    o_Late_Amount      := 0;
    o_Early_Amount     := 0;
    o_Lack_Amount      := 0;
    o_Day_Skip_Amount  := 0;
    o_Mark_Skip_Amount := 0;
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => o_Worked_Hours,
                                  o_Fact_Days    => o_Worked_Days,
                                  i_Company_Id   => v_Company_Id,
                                  i_Filial_Id    => v_Filial_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Time_Kind_Id => v_Time_Kind_Id,
                                  i_Begin_Date   => i_Begin_Date,
                                  i_End_Date     => i_End_Date);
  
    o_Worked_Hours := Round(Nvl(o_Worked_Hours / 3600, 0), 2);
  
    if Is_Approximately_Wage(i_Staff_Id       => r_Staff.Staff_Id,
                             i_Dismissal_Date => r_Staff.Dismissal_Date,
                             i_Hiring_Date    => r_Staff.Hiring_Date,
                             i_Begin_Date     => i_Begin_Date,
                             i_End_Date       => i_End_Date,
                             i_Is_Pro         => false) = 'N' then
      select Nvl(sum(q.Wage_Amount), 0),
             Nvl(sum(q.Overtime_Amount), 0),
             Nvl(sum(q.Late_Amount), 0),
             Nvl(sum(q.Early_Amount), 0),
             Nvl(sum(q.Lack_Amount), 0),
             Nvl(sum(q.Day_Skip_Amount), 0),
             Nvl(sum(q.Mark_Skip_Amount), 0)
        into o_Wage_Amount,
             o_Overtime_Amount,
             o_Late_Amount,
             o_Early_Amount,
             o_Lack_Amount,
             o_Day_Skip_Amount,
             o_Mark_Skip_Amount
        from Hpr_Sheet_Parts q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Part_Begin >= i_Begin_Date
         and q.Part_End <= i_End_Date
         and q.Staff_Id = r_Staff.Staff_Id
         and exists (select 1
                from Hpr_Wage_Sheets Sh
               where Sh.Company_Id = q.Company_Id
                 and Sh.Filial_Id = q.Filial_Id
                 and Sh.Sheet_Id = q.Sheet_Id
                 and Sh.Posted = 'Y');
    else
      v_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    
      v_Overtime_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => v_Company_Id,
                                                  i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Overtime);
    
      v_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id      => v_Company_Id,
                                                       i_Filial_Id       => v_Filial_Id,
                                                       i_Staff_Id        => i_Staff_Id,
                                                       i_Begin_Date      => i_Begin_Date,
                                                       i_End_Date        => i_End_Date,
                                                       i_Trans_Types     => Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                                                                           Hpd_Pref.c_Transaction_Type_Operation,
                                                                                           Hpd_Pref.c_Transaction_Type_Schedule),
                                                       i_With_Wage_Scale => true);
      for i in 1 .. v_Parts.Count
      loop
        v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => v_Company_Id,
                                                          i_Filial_Id  => v_Filial_Id,
                                                          i_Staff_Id   => r_Staff.Staff_Id,
                                                          i_Period     => v_Parts(i).Part_Begin);
      
        continue when v_Schedule_Id is null;
      
        continue when Htt_Util.Has_Undefined_Schedule(i_Company_Id  => v_Company_Id,
                                                      i_Filial_Id   => v_Filial_Id,
                                                      i_Staff_Id    => r_Staff.Staff_Id,
                                                      i_Schedule_Id => v_Schedule_Id,
                                                      i_Period      => v_Parts(i).Part_Begin);
      
        v_Oper_Type_Id := Hpd_Util.Get_Closest_Oper_Type_Id(i_Company_Id    => v_Company_Id,
                                                            i_Filial_Id     => v_Filial_Id,
                                                            i_Staff_Id      => r_Staff.Staff_Id,
                                                            i_Oper_Group_Id => v_Oper_Group_Id,
                                                            i_Period        => v_Parts(i).Part_Begin);
      
        o_Wage_Amount := o_Wage_Amount + Nvl(Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                                                  i_Filial_Id    => v_Filial_Id,
                                                                  i_Staff_Id     => r_Staff.Staff_Id,
                                                                  i_Oper_Type_Id => v_Oper_Type_Id,
                                                                  i_Part_Begin   => v_Parts(i).Part_Begin,
                                                                  i_Part_End     => v_Parts(i).Part_End),
                                             0);
      
        o_Overtime_Amount := o_Overtime_Amount + Nvl(Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                                                          i_Filial_Id    => v_Filial_Id,
                                                                          i_Staff_Id     => r_Staff.Staff_Id,
                                                                          i_Oper_Type_Id => v_Overtime_Type_Id,
                                                                          i_Part_Begin   => v_Parts(i).Part_Begin,
                                                                          i_Part_End     => v_Parts(i).Part_End),
                                                     0);
      
        v_Division_Id := Hpd_Util.Get_Closest_Division_Id(i_Company_Id => v_Company_Id,
                                                          i_Filial_Id  => v_Filial_Id,
                                                          i_Staff_Id   => r_Staff.Staff_Id,
                                                          i_Period     => v_Parts(i).Part_Begin);
      
        v_Hourly_Wage := Hpr_Util.Calc_Hourly_Wage(i_Company_Id   => v_Company_Id,
                                                   i_Filial_Id    => v_Filial_Id,
                                                   i_Staff_Id     => r_Staff.Staff_Id,
                                                   i_Oper_Type_Id => v_Oper_Type_Id,
                                                   i_Schedule_Id  => v_Schedule_Id,
                                                   i_Part_Begin   => v_Parts(i).Part_Begin,
                                                   i_Part_End     => v_Parts(i).Part_End);
      
        Hpr_Util.Calc_Penalty_Amounts(o_Late_Amount      => v_Late_Amount,
                                      o_Early_Amount     => v_Early_Amount,
                                      o_Lack_Amount      => v_Lack_Amount,
                                      o_Day_Skip_Amount  => v_Day_Skip_Amount,
                                      o_Mark_Skip_Amount => v_Mark_Skip_Amount,
                                      i_Company_Id       => v_Company_Id,
                                      i_Filial_Id        => v_Filial_Id,
                                      i_Staff_Id         => r_Staff.Staff_Id,
                                      i_Division_Id      => v_Division_Id,
                                      i_Hourly_Wage      => v_Hourly_Wage,
                                      i_Period_Begin     => v_Parts(i).Part_Begin,
                                      i_Period_End       => v_Parts(i).Part_End);
      
        o_Late_Amount      := o_Late_Amount + v_Late_Amount;
        o_Early_Amount     := o_Early_Amount + v_Early_Amount;
        o_Lack_Amount      := o_Lack_Amount + v_Lack_Amount;
        o_Day_Skip_Amount  := o_Day_Skip_Amount + v_Day_Skip_Amount;
        o_Mark_Skip_Amount := o_Mark_Skip_Amount + v_Mark_Skip_Amount;
      end loop;
    
      o_Wage_Amount      := Round(o_Wage_Amount, 2);
      o_Overtime_Amount  := Round(o_Overtime_Amount, 2);
      o_Late_Amount      := Round(o_Late_Amount, 2);
      o_Early_Amount     := Round(o_Early_Amount, 2);
      o_Lack_Amount      := Round(o_Lack_Amount, 2);
      o_Day_Skip_Amount  := Round(o_Day_Skip_Amount, 2);
      o_Mark_Skip_Amount := Round(o_Mark_Skip_Amount, 2);
    end if;
  
    select Nvl(sum(p.Accrual_Amount), 0), Nvl(sum(p.Penalty_Amount), 0)
      into o_Onetime_Accrual, --
           o_Onetime_Penalty
      from Hpr_Onetime_Sheet_Staffs p
     where p.Company_Id = v_Company_Id
       and p.Filial_Id = v_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Month = i_Begin_Date
       and exists (select *
              from Hpr_Wage_Sheets q
             where q.Company_Id = p.Company_Id
               and q.Filial_Id = p.Filial_Id
               and q.Sheet_Id = p.Sheet_Id
               and q.Posted = 'Y');
  
    o_Total_Accrual   := o_Wage_Amount + o_Overtime_Amount + o_Onetime_Accrual;
    o_Total_Deduction := o_Late_Amount + o_Early_Amount + o_Lack_Amount + o_Day_Skip_Amount +
                         o_Mark_Skip_Amount + o_Onetime_Penalty;
  
    select Nvl(sum(q.Pay_Amount_Base), 0)
      into o_Payment
      from Mpr_Payment_Employees q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Employee_Id = r_Staff.Employee_Id
       and q.Paid = 'Y'
       and Trunc(q.Paid_Date, 'Mon') = i_Begin_Date
       and exists (select 1
              from Mpr_Payments Mp
             where Mp.Company_Id = q.Company_Id
               and Mp.Filial_Id = q.Filial_Id
               and Mp.Payment_Id = q.Payment_Id
               and Mp.Status in (Mpr_Pref.c_Ps_Completed, --
                                 Mpr_Pref.c_Ps_Archived));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Calculation_Pro
  (
    i_Staff_Id             number,
    i_Begin_Date           date,
    i_End_Date             date,
    o_Total_Accrual        out number,
    o_Total_Deduction      out number,
    o_Income_Tax           out number,
    o_Worked_Hours         out number,
    o_Worked_Days          out number,
    o_Payment              out number,
    o_Credit               out number,
    o_Accrual_Oper_Types   out Matrix_Varchar2,
    o_Deduction_Oper_Types out Matrix_Varchar2
  ) is
    r_Staff                   Href_Staffs%rowtype;
    v_Company_Id              number := Ui.Company_Id;
    v_Filial_Id               number := Ui.Filial_Id;
    v_Time_Kind_Id            number;
    v_Oper_Group_Id           number;
    v_Deduction_Oper_Group_Id number;
    v_Overtime_Gruop_Id       number;
    v_Perf_Oper_Gruop_Id      number;
    v_Trans_Id                number;
    v_Oper_Type_Amount        number;
    v_Oper_Types              Array_Number;
    v_All_Oper_Types          Array_Number := Array_Number();
    v_Parts                   Hpd_Pref.Transaction_Part_Nt;
    v_Timebook_Staff_Info     Hpr_Pref.Timebook_Staff_Info;
    v_Calc                    Calc := Calc();
  begin
    o_Total_Accrual        := 0;
    o_Total_Deduction      := 0;
    o_Income_Tax           := 0;
    o_Accrual_Oper_Types   := Matrix_Varchar2();
    o_Deduction_Oper_Types := Matrix_Varchar2();
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if Is_Approximately_Wage(i_Staff_Id       => r_Staff.Staff_Id,
                             i_Dismissal_Date => r_Staff.Dismissal_Date,
                             i_Hiring_Date    => r_Staff.Hiring_Date,
                             i_Begin_Date     => i_Begin_Date,
                             i_End_Date       => i_End_Date,
                             i_Is_Pro         => true) = 'Y' then
      v_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => o_Worked_Hours,
                                    o_Fact_Days    => o_Worked_Days,
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => i_Staff_Id,
                                    i_Time_Kind_Id => v_Time_Kind_Id,
                                    i_Begin_Date   => i_Begin_Date,
                                    i_End_Date     => i_End_Date);
    
      o_Worked_Hours := Round(Nvl(o_Worked_Hours / 3600, 0), 2);
    
      v_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    
      v_Deduction_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                          i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
    
      v_Overtime_Gruop_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                    i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime);
    
      v_Perf_Oper_Gruop_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf);
    
      v_Parts := Hpd_Util.Get_Opened_Transaction_Dates(i_Company_Id      => v_Company_Id,
                                                       i_Filial_Id       => v_Filial_Id,
                                                       i_Staff_Id        => i_Staff_Id,
                                                       i_Begin_Date      => i_Begin_Date,
                                                       i_End_Date        => i_End_Date,
                                                       i_Trans_Types     => Array_Varchar2(Hpd_Pref.c_Transaction_Type_Robot,
                                                                                           Hpd_Pref.c_Transaction_Type_Operation,
                                                                                           Hpd_Pref.c_Transaction_Type_Schedule),
                                                       i_With_Wage_Scale => true);
    
      for i in 1 .. v_Parts.Count
      loop
        v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => v_Company_Id,
                                                  i_Filial_Id  => v_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                  i_Period     => v_Parts(i).Part_Begin);
      
        select t.Oper_Type_Id
          bulk collect
          into v_Oper_Types
          from Hpd_Trans_Oper_Types t
         where t.Company_Id = v_Company_Id
           and t.Filial_Id = v_Filial_Id
           and t.Trans_Id = v_Trans_Id
           and exists (select 1
                  from Hpr_Oper_Types s
                 where s.Company_Id = t.Company_Id
                   and s.Oper_Type_Id = t.Oper_Type_Id
                   and s.Oper_Group_Id in (v_Oper_Group_Id,
                                           v_Deduction_Oper_Group_Id,
                                           v_Perf_Oper_Gruop_Id,
                                           v_Overtime_Gruop_Id));
      
        v_All_Oper_Types := v_All_Oper_Types multiset union distinct
                            Nvl(v_Oper_Types, Array_Number());
      
        for j in 1 .. v_Oper_Types.Count
        loop
          continue when Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => v_Company_Id,
                                                         i_Filial_Id  => v_Filial_Id,
                                                         i_Staff_Id   => i_Staff_Id,
                                                         i_Period     => v_Parts(i).Part_End) is null;
          v_Calc.Plus(v_Oper_Types(j),
                      Hpr_Util.Calc_Amount(i_Company_Id   => v_Company_Id,
                                           i_Filial_Id    => v_Filial_Id,
                                           i_Staff_Id     => i_Staff_Id,
                                           i_Oper_Type_Id => v_Oper_Types(j),
                                           i_Part_Begin   => v_Parts(i).Part_Begin,
                                           i_Part_End     => v_Parts(i).Part_End));
        end loop;
      end loop;
    
      for r in (select *
                  from Mpr_Oper_Types q
                 where q.Company_Id = v_Company_Id
                   and q.Oper_Type_Id member of v_All_Oper_Types
                 order by q.Name)
      loop
        v_Oper_Type_Amount := Round(v_Calc.Get_Value(r.Oper_Type_Id), 2);
      
        if r.Operation_Kind = Mpr_Pref.c_Ok_Accrual then
          o_Total_Accrual := o_Total_Accrual + v_Oper_Type_Amount;
          o_Income_Tax    := o_Income_Tax + Nvl(r.Income_Tax_Rate, 0) * v_Oper_Type_Amount;
        
          Fazo.Push(o_Accrual_Oper_Types,
                    Array_Varchar2(Nvl(r.Short_Name, r.Name), v_Oper_Type_Amount));
        else
          o_Total_Deduction := o_Total_Deduction + v_Oper_Type_Amount;
        
          Fazo.Push(o_Deduction_Oper_Types,
                    Array_Varchar2(Nvl(r.Short_Name, r.Name), v_Oper_Type_Amount));
        end if;
      end loop;
    else
      v_Timebook_Staff_Info := Uit_Hpr.Get_Timebook_Staff(i_Month    => i_Begin_Date,
                                                          i_Staff_Id => i_Staff_Id);
    
      o_Worked_Hours := Round(Nvl(v_Timebook_Staff_Info.Fact_Hours, 0), 2);
      o_Worked_Days  := Nvl(v_Timebook_Staff_Info.Fact_Days, 0);
    
      for r in (select Oper.Oper_Type_Id,
                       Oper.Name,
                       Oper.Operation_Kind,
                       Nvl(sum(Oper.Amount_Base), 0) as Amount,
                       Nvl(sum(Oper.Income_Tax_Amount), 0) as Income_Tax_Amount
                  from (select q.Oper_Type_Id,
                               Ot.Name,
                               Ot.Operation_Kind,
                               q.Amount_Base,
                               q.Income_Tax_Amount
                          from Mpr_Book_Operations q
                          join Mpr_Oper_Types Ot
                            on Ot.Company_Id = q.Company_Id
                           and Ot.Oper_Type_Id = q.Oper_Type_Id
                         where q.Company_Id = v_Company_Id
                           and q.Filial_Id = v_Filial_Id
                           and q.Employee_Id = r_Staff.Employee_Id
                           and exists
                         (select 1
                                  from Mpr_Books Mb
                                 where Mb.Company_Id = q.Company_Id
                                   and Mb.Filial_Id = q.Filial_Id
                                   and Mb.Book_Id = q.Book_Id
                                   and Mb.Posted = 'Y'
                                   and Mb.Month between i_Begin_Date and i_End_Date)) Oper
                 group by Oper.Oper_Type_Id, Oper.Name, Oper.Operation_Kind
                 order by Oper.Name)
      loop
        if r.Operation_Kind = Mpr_Pref.c_Ok_Accrual then
          o_Total_Accrual := o_Total_Accrual + r.Amount;
          o_Income_Tax    := o_Income_Tax + r.Income_Tax_Amount;
        
          Fazo.Push(o_Accrual_Oper_Types, Array_Varchar2(r.Name, r.Amount));
        else
          o_Total_Deduction := o_Total_Deduction + r.Amount;
        
          Fazo.Push(o_Deduction_Oper_Types, Array_Varchar2(r.Name, r.Amount));
        end if;
      end loop;
    end if;
  
    o_Total_Deduction := o_Total_Deduction + o_Income_Tax;
  
    -- Credit
    o_Credit := Hpr_Util.Calc_Employee_Credit(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Employee_Id => r_Staff.Employee_Id,
                                              i_Month       => Trunc(i_Begin_Date, 'mon'));
  
    if o_Credit > 0 then
      o_Total_Deduction := o_Total_Deduction + o_Credit;
    end if;
  
    select Round(Nvl(sum(q.Pay_Amount_Base), 0), 2)
      into o_Payment
      from Mpr_Payment_Employees q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Employee_Id = r_Staff.Employee_Id
       and q.Paid = 'Y'
       and Trunc(q.Paid_Date, 'Mon') = i_Begin_Date
       and exists (select 1
              from Mpr_Payments Mp
             where Mp.Company_Id = q.Company_Id
               and Mp.Filial_Id = q.Filial_Id
               and Mp.Payment_Id = q.Payment_Id
               and Mp.Status in (Mpr_Pref.c_Ps_Completed, --
                                 Mpr_Pref.c_Ps_Archived));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Assert_Access_To_Book(i_Book_Id number) is
  begin
    if Uit_Href.User_Access_All_Employees = 'N' then
      for r in (select q.Employee_Id
                  from Mpr_Book_Operations q
                 where q.Company_Id = Ui.Company_Id
                   and q.Filial_Id = Ui.Filial_Id
                   and q.Book_Id = i_Book_Id)
      loop
        Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r.Employee_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Division_Subfilial(i_Division_Id number) return number is
    v_Subfilial_Id number;
    v_Parent_Id    number;
  begin
    select q.Subfilial_Id, w.Parent_Id
      into v_Subfilial_Id, v_Parent_Id
      from Hrm_Divisions q
      join Mhr_Divisions w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Division_Id = q.Division_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Division_Id = i_Division_Id;
  
    if v_Subfilial_Id is not null then
      return v_Subfilial_Id;
    elsif v_Parent_Id is not null then
      return Load_Division_Subfilial(v_Parent_Id);
    else
      return null;
    end if;
  
  exception
    when No_Data_Found then
      return null;
  end;

end Uit_Hpr;
/
