create or replace package Hper_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Plus
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Minus
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Eval_Fact
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Fact_Value    number,
    i_Fact_Note     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Clear_Fact
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Plan_Types;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Plan_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Function Plan_Date
  (
    i_Date             date,
    i_Month_Begin_Date date,
    i_Month_End_Date   date
  ) return date;
  ----------------------------------------------------------------------------------------------------  
  Procedure Gen_Staff_Plans
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Page_Id          number,
    i_Staff_Plan_Id    number,
    i_Period           date,
    i_Plan_Date        date,
    i_Month_Begin_Date date,
    i_Month_End_Date   date,
    i_Trans_Robot      Hpd_Trans_Robots%rowtype
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Plans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Plan_Id    number := null,
    i_Date       date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Generate_All;
end Hper_Core;
/
create or replace package body Hper_Core is
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
    return b.Translate('HPER:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Plus
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  ) is
  begin
    z_Hper_Staff_Plan_Parts.Insert_One(i_Company_Id    => i_Company_Id,
                                       i_Filial_Id     => i_Filial_Id,
                                       i_Part_Id       => Hper_Next.Part_Id,
                                       i_Staff_Plan_Id => i_Staff_Plan_Id,
                                       i_Plan_Type_Id  => i_Plan_Type_Id,
                                       i_Part_Date     => Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                                                                     i_Timezone  => null),
                                       i_Amount        => i_Amount);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Minus
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  ) is
    v_Amount number := i_Amount;
  begin
    for r in (select *
                from Hper_Staff_Plan_Parts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Plan_Id = i_Staff_Plan_Id
                 and q.Plan_Type_Id = i_Plan_Type_Id
               order by q.Part_Date desc)
    loop
      if r.Amount > v_Amount then
        r.Amount := r.Amount - v_Amount;
      
        v_Amount := 0;
      
        z_Hper_Staff_Plan_Parts.Update_Row(r);
      else
        v_Amount := v_Amount - r.Amount;
        z_Hper_Staff_Plan_Parts.Delete_One(i_Company_Id => r.Company_Id,
                                           i_Filial_Id  => r.Filial_Id,
                                           i_Part_Id    => r.Part_Id);
      end if;
    
      exit when v_Amount = 0;
    end loop;
  
    if v_Amount > 0 then
      Hper_Error.Raise_016(i_Staff_Plan_Id => i_Staff_Plan_Id,
                           i_Plan_Type_Id  => i_Plan_Type_Id,
                           i_Amount        => v_Amount);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Eval_Fact
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Fact_Value    number,
    i_Fact_Note     varchar2
  ) is
    r_Item Hper_Staff_Plan_Items%rowtype;
  begin
    r_Item := z_Hper_Staff_Plan_Items.Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id,
                                           i_Plan_Type_Id  => i_Plan_Type_Id);
  
    r_Item.Fact_Value := Nvl(r_Item.Fact_Value, 0);
  
    if r_Item.Fact_Value < i_Fact_Value then
      Staff_Plan_Part_Plus(i_Company_Id    => i_Company_Id,
                           i_Filial_Id     => i_Filial_Id,
                           i_Staff_Plan_Id => i_Staff_Plan_Id,
                           i_Plan_Type_Id  => i_Plan_Type_Id,
                           i_Amount        => i_Fact_Value - r_Item.Fact_Value);
    elsif r_Item.Fact_Value > i_Fact_Value then
      Staff_Plan_Part_Minus(i_Company_Id    => i_Company_Id,
                            i_Filial_Id     => i_Filial_Id,
                            i_Staff_Plan_Id => i_Staff_Plan_Id,
                            i_Plan_Type_Id  => i_Plan_Type_Id,
                            i_Amount        => r_Item.Fact_Value - i_Fact_Value);
    end if;
  
    z_Hper_Staff_Plan_Items.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Filial_Id     => i_Filial_Id,
                                       i_Staff_Plan_Id => i_Staff_Plan_Id,
                                       i_Plan_Type_Id  => i_Plan_Type_Id,
                                       i_Fact_Note     => Option_Varchar2(i_Fact_Note));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Clear_Fact
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  ) is
  begin
    delete Hper_Staff_Plan_Parts q
     where q.Company_Id = i_Company_Id
       and q.Staff_Plan_Id = i_Staff_Plan_Id
       and q.Plan_Type_Id = i_Plan_Type_Id;
  
    z_Hper_Staff_Plan_Items.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Filial_Id     => i_Filial_Id,
                                       i_Staff_Plan_Id => i_Staff_Plan_Id,
                                       i_Plan_Type_Id  => i_Plan_Type_Id,
                                       i_Fact_Value    => Option_Number(0),
                                       i_Fact_Percent  => Option_Number(0),
                                       i_Fact_Amount   => Option_Number(0));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Plan_Types is
  begin
    for r in (select q.*,
                     Nvl((select 'Y'
                           from Hper_Plan_Type_Divisions w
                          where w.Company_Id = q.Company_Id
                            and w.Filial_Id = q.Filial_Id
                            and w.Plan_Type_Id = q.Plan_Type_Id
                            and Rownum = 1),
                         'N') c_Divisions_Exist
                from Hper_Dirty_Plan_Types q)
    loop
      z_Hper_Plan_Types.Update_One(i_Company_Id        => r.Company_Id,
                                   i_Filial_Id         => r.Filial_Id,
                                   i_Plan_Type_Id      => r.Plan_Type_Id,
                                   i_c_Divisions_Exist => Option_Varchar2(r.c_Divisions_Exist));
    end loop;
  
    delete Hper_Dirty_Plan_Types;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Plan_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hper_Dirty_Plan_Types q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Plan_Type_Id = i_Plan_Type_Id;
  exception
    when No_Data_Found then
      insert into Hper_Dirty_Plan_Types
        (Company_Id, Filial_Id, Plan_Type_Id)
      values
        (i_Company_Id, i_Filial_Id, i_Plan_Type_Id);
    
      b.Add_Post_Callback('begin hper_core.fix_plan_types; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Date
  (
    i_Date             date,
    i_Month_Begin_Date date,
    i_Month_End_Date   date
  ) return date is
  begin
    if i_Date between i_Month_Begin_Date and i_Month_End_Date then
      return Trunc(i_Date, 'MON');
    end if;
  
    return Add_Months(Trunc(i_Date, 'MON'), 1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Staff_Plans
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Page_Id          number,
    i_Staff_Plan_Id    number,
    i_Period           date,
    i_Plan_Date        date,
    i_Month_Begin_Date date,
    i_Month_End_Date   date,
    i_Trans_Robot      Hpd_Trans_Robots%rowtype
  ) is
    r_Plan               Hper_Plans%rowtype;
    r_Page               Hpd_Journal_Pages%rowtype;
    r_Page_Robot         Hpd_Page_Robots%rowtype;
    r_Robot              Mrf_Robots%rowtype;
    v_Currency_Id        number;
    v_Operation_Trans_Id number;
    v_Staff_Plan_Id      number;
    v_Main_Plan_Amount   number;
    v_Extra_Plan_Amount  number;
    v_Indicator_Id       number;
  begin
    r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Page_Id    => i_Page_Id);
  
    r_Plan := Hper_Util.Job_Plan(i_Company_Id      => r_Page.Company_Id,
                                 i_Filial_Id       => r_Page.Filial_Id,
                                 i_Journal_Page_Id => r_Page.Page_Id,
                                 i_Plan_Date       => i_Plan_Date);
  
    if r_Plan.Company_Id is null then
      return;
    end if;
  
    r_Page_Robot := z_Hpd_Page_Robots.Load(i_Company_Id => r_Page.Company_Id,
                                           i_Filial_Id  => r_Page.Filial_Id,
                                           i_Page_Id    => r_Page.Page_Id);
  
    r_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Page_Robot.Company_Id,
                                 i_Filial_Id  => r_Page_Robot.Filial_Id,
                                 i_Robot_Id   => r_Page_Robot.Robot_Id);
  
    v_Operation_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => r_Plan.Company_Id,
                                                        i_Filial_Id  => r_Plan.Filial_Id,
                                                        i_Staff_Id   => r_Page.Staff_Id,
                                                        i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                        i_Period     => i_Period);
  
    v_Currency_Id := Hpd_Util.Get_Closest_Currency_Id(i_Company_Id => r_Plan.Company_Id,
                                                      i_Filial_Id  => r_Plan.Filial_Id,
                                                      i_Staff_Id   => r_Page.Staff_Id,
                                                      i_Period     => i_Month_End_Date);
  
    if r_Plan.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Plan.Company_Id,
                                               i_Pcode      => Href_Pref.c_Pcode_Indicator_Perf_Bonus);
    
      if i_Trans_Robot.Wage_Scale_Id is not null then
        v_Main_Plan_Amount := Hrm_Util.Closest_Wage_Scale_Indicator_Value(i_Company_Id    => i_Company_Id,
                                                                          i_Filial_Id     => i_Filial_Id,
                                                                          i_Wage_Scale_Id => i_Trans_Robot.Wage_Scale_Id,
                                                                          i_Indicator_Id  => v_Indicator_Id,
                                                                          i_Period        => i_Period,
                                                                          i_Rank_Id       => r_Page_Robot.Rank_Id);
      end if;
    
      if v_Main_Plan_Amount is null then
        select max(q.Indicator_Value)
          into v_Main_Plan_Amount
          from Hpd_Trans_Indicators q
         where q.Company_Id = r_Plan.Company_Id
           and q.Filial_Id = r_Plan.Filial_Id
           and q.Trans_Id = v_Operation_Trans_Id
           and q.Indicator_Id = v_Indicator_Id;
      end if;
    else
      select sum(q.Plan_Value * q.Plan_Amount)
        into v_Main_Plan_Amount
        from Hper_Plan_Items q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id
         and q.Plan_Type = Hper_Pref.c_Plan_Type_Main;
    
      if v_Currency_Id is not null then
        v_Main_Plan_Amount := Mk_Util.Calc_Amount(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Currency_Id => v_Currency_Id,
                                                  i_Rate_Date   => i_Month_End_Date,
                                                  i_Amount_Base => v_Main_Plan_Amount);
      end if;
    end if;
  
    if r_Plan.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Plan.Company_Id,
                                               i_Pcode      => Href_Pref.c_Pcode_Indicator_Perf_Extra_Bonus);
    
      if i_Trans_Robot.Wage_Scale_Id is not null then
        v_Extra_Plan_Amount := Hrm_Util.Closest_Wage_Scale_Indicator_Value(i_Company_Id    => i_Company_Id,
                                                                           i_Filial_Id     => i_Filial_Id,
                                                                           i_Wage_Scale_Id => i_Trans_Robot.Wage_Scale_Id,
                                                                           i_Indicator_Id  => v_Indicator_Id,
                                                                           i_Period        => i_Period,
                                                                           i_Rank_Id       => r_Page_Robot.Rank_Id);
      end if;
    
      if v_Extra_Plan_Amount is null then
        select max(q.Indicator_Value)
          into v_Extra_Plan_Amount
          from Hpd_Trans_Indicators q
         where q.Company_Id = r_Plan.Company_Id
           and q.Filial_Id = r_Plan.Filial_Id
           and q.Trans_Id = v_Operation_Trans_Id
           and q.Indicator_Id = v_Indicator_Id;
      end if;
    else
      select sum(q.Plan_Value * q.Plan_Amount)
        into v_Extra_Plan_Amount
        from Hper_Plan_Items q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id
         and q.Plan_Type = Hper_Pref.c_Plan_Type_Extra;
    
      if v_Currency_Id is not null then
        v_Extra_Plan_Amount := Mk_Util.Calc_Amount(i_Company_Id  => i_Company_Id,
                                                   i_Filial_Id   => i_Filial_Id,
                                                   i_Currency_Id => v_Currency_Id,
                                                   i_Rate_Date   => i_Month_End_Date,
                                                   i_Amount_Base => v_Extra_Plan_Amount);
      end if;
    end if;
  
    if i_Staff_Plan_Id is null then
      v_Staff_Plan_Id := Hper_Next.Staff_Plan_Id;
    else
      v_Staff_Plan_Id := i_Staff_Plan_Id;
    
      delete Hper_Staff_Plan_Items q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Staff_Plan_Id = v_Staff_Plan_Id;
    end if;
  
    z_Hper_Staff_Plans.Save_One(i_Company_Id           => r_Plan.Company_Id,
                                i_Filial_Id            => r_Plan.Filial_Id,
                                i_Staff_Plan_Id        => v_Staff_Plan_Id,
                                i_Staff_Id             => r_Page.Staff_Id,
                                i_Plan_Date            => i_Plan_Date,
                                i_Main_Calc_Type       => r_Plan.Main_Calc_Type,
                                i_Extra_Calc_Type      => r_Plan.Extra_Calc_Type,
                                i_Month_Begin_Date     => i_Month_Begin_Date,
                                i_Month_End_Date       => i_Month_End_Date,
                                i_Journal_Page_Id      => r_Page_Robot.Page_Id,
                                i_Division_Id          => r_Robot.Division_Id,
                                i_Job_Id               => r_Robot.Job_Id,
                                i_Rank_Id              => r_Page_Robot.Rank_Id,
                                i_Employment_Type      => r_Page_Robot.Employment_Type,
                                i_Begin_Date           => i_Month_Begin_Date,
                                i_End_Date             => i_Month_End_Date,
                                i_Main_Plan_Amount     => Nvl(v_Main_Plan_Amount, 0), --TODO
                                i_Extra_Plan_Amount    => Nvl(v_Extra_Plan_Amount, 0), --TODO
                                i_Main_Fact_Amount     => 0,
                                i_Extra_Fact_Amount    => 0,
                                i_Main_Fact_Percent    => 0,
                                i_Extra_Fact_Percent   => 0,
                                i_c_Main_Fact_Percent  => 0,
                                i_c_Extra_Fact_Percent => 0,
                                i_Status               => Hper_Pref.c_Staff_Plan_Status_Draft,
                                i_Note                 => t('autogenerated'));
  
    insert into Hper_Staff_Plan_Items
      (Company_Id,
       Filial_Id,
       Staff_Plan_Id,
       Plan_Type_Id,
       Plan_Type,
       Plan_Value,
       Plan_Amount,
       Calc_Kind,
       Note,
       Extra_Amount_Enabled,
       Sale_Kind,
       Extra_Amount)
      select q.Company_Id,
             q.Filial_Id,
             v_Staff_Plan_Id,
             q.Plan_Type_Id,
             q.Plan_Type,
             q.Plan_Value,
             q.Plan_Amount,
             s.Calc_Kind,
             q.Note,
             s.Extra_Amount_Enabled,
             s.Sale_Kind,
             0
        from Hper_Plan_Items q
        join Hper_Plan_Types s
          on s.Company_Id = q.Company_Id
         and s.Filial_Id = q.Filial_Id
         and s.Plan_Type_Id = q.Plan_Type_Id
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id;
  
    insert into Hper_Staff_Plan_Rules
      (Company_Id, Filial_Id, Staff_Plan_Id, Plan_Type_Id, From_Percent, To_Percent, Fact_Amount)
      select q.Company_Id,
             q.Filial_Id,
             v_Staff_Plan_Id,
             q.Plan_Type_Id,
             q.From_Percent,
             q.To_Percent,
             q.Fact_Amount
        from Hper_Plan_Rules q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id;
  
    insert into Hper_Staff_Plan_Type_Rules
      (Company_Id, Filial_Id, Staff_Plan_Id, Plan_Type_Id, From_Percent, To_Percent, Plan_Percent)
      select q.Company_Id,
             q.Filial_Id,
             v_Staff_Plan_Id,
             q.Plan_Type_Id,
             q.From_Percent,
             q.To_Percent,
             q.Plan_Percent
        from Hper_Plan_Type_Rules q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Type_Id in (select w.Plan_Type_Id
                                  from Hper_Plan_Items w
                                 where w.Company_Id = r_Plan.Company_Id
                                   and w.Filial_Id = r_Plan.Filial_Id
                                   and w.Plan_Id = r_Plan.Plan_Id);
  
    insert into Hper_Staff_Plan_Task_Types
      (Company_Id, Filial_Id, Staff_Plan_Id, Plan_Type_Id, Task_Type_Id)
      select q.Company_Id, q.Filial_Id, v_Staff_Plan_Id, q.Plan_Type_Id, w.Task_Type_Id
        from Hper_Plan_Items q
        join Hper_Plan_Type_Task_Types w
          on w.Company_Id = q.Company_Id
         and w.Filial_Id = q.Filial_Id
         and w.Plan_Type_Id = q.Plan_Type_Id
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id
         and exists (select 1
                from Hper_Plan_Types s
               where s.Company_Id = q.Company_Id
                 and s.Filial_Id = q.Filial_Id
                 and s.Plan_Type_Id = q.Plan_Type_Id
                 and s.Calc_Kind = Hper_Pref.c_Calc_Kind_Task);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Plans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Plan_Id    number := null,
    i_Date       date
  ) is
    v_Dates         Array_Date := Array_Date();
    v_Pages         Array_Number := Array_Number();
    v_Staff_Plan    Hper_Staff_Plans%rowtype;
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
    r_Trans         Hpd_Transactions%rowtype;
    r_Plan          Hper_Plans%rowtype;
  
    v_Month_Begin_Date date := Hper_Util.Month_Begin_Date(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id,
                                                          i_Date       => i_Date);
    v_Month_End_Date   date := Hper_Util.Month_End_Date(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Date       => i_Date);
  
    v_Plan_Date  date;
    v_Robot_Page Hpd_Page_Robots%rowtype;
    v_Robot      Mrf_Robots%rowtype;
  begin
    v_Plan_Date := Plan_Date(i_Date             => i_Date,
                             i_Month_Begin_Date => v_Month_Begin_Date,
                             i_Month_End_Date   => v_Month_End_Date);
  
    if i_Plan_Id is not null then
      r_Plan := z_Hper_Plans.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Plan_Id    => i_Plan_Id);
    end if;
  
    for r in (select *
                from Href_Staffs s
               where s.Company_Id = i_Company_Id
                 and s.Filial_Id = i_Filial_Id
                 and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Month_Begin_Date)
                 and s.State = 'A')
    loop
      select distinct k.Begin_Date
        bulk collect
        into v_Dates
        from Hpd_Transactions k
       where k.Company_Id = r.Company_Id
         and k.Filial_Id = r.Filial_Id
         and k.Staff_Id = r.Staff_Id
         and k.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
         and k.Begin_Date between v_Month_Begin_Date and v_Month_End_Date
         and exists (select 1
                from Hpd_Agreements a
               where a.Company_Id = k.Company_Id
                 and a.Filial_Id = k.Filial_Id
                 and a.Staff_Id = k.Staff_Id
                 and a.Trans_Type = k.Trans_Type
                 and a.Trans_Id = k.Trans_Id);
    
      if v_Month_Begin_Date not member of v_Dates then
        Fazo.Push(v_Dates, v_Month_Begin_Date);
      end if;
    
      if v_Month_End_Date not member of v_Dates then
        Fazo.Push(v_Dates, v_Month_End_Date);
      end if;
    
      v_Dates := Fazo.Sort(v_Dates);
      v_Pages := Array_Number();
    
      for i in 1 .. v_Dates.Count
      loop
        r_Closest_Robot := Hpd_Util.Closest_Robot(i_Company_Id => r.Company_Id,
                                                  i_Filial_Id  => r.Filial_Id,
                                                  i_Staff_Id   => r.Staff_Id,
                                                  i_Period     => v_Dates(i));
      
        continue when r_Closest_Robot.Company_Id is null;
      
        r_Trans := z_Hpd_Transactions.Load(i_Company_Id => r_Closest_Robot.Company_Id,
                                           i_Filial_Id  => r_Closest_Robot.Filial_Id,
                                           i_Trans_Id   => r_Closest_Robot.Trans_Id);
      
        if i_Plan_Id is not null then
          v_Robot_Page := z_Hpd_Page_Robots.Load(i_Company_Id => r_Trans.Company_Id,
                                                 i_Filial_Id  => r_Trans.Filial_Id,
                                                 i_Page_Id    => r_Trans.Page_Id);
        
          v_Robot := z_Mrf_Robots.Load(i_Company_Id => v_Robot_Page.Company_Id,
                                       i_Filial_Id  => v_Robot_Page.Filial_Id,
                                       i_Robot_Id   => v_Robot_Page.Robot_Id);
        
          if not (r_Plan.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard and
              Fazo.Equal(r_Plan.Division_Id, v_Robot.Division_Id) and
              Fazo.Equal(r_Plan.Job_Id, v_Robot.Job_Id) and
              Fazo.Equal(r_Plan.Rank_Id, v_Robot_Page.Rank_Id) and
              Fazo.Equal(r_Plan.Employment_Type, v_Robot_Page.Employment_Type) or
              r_Plan.Plan_Kind = Hper_Pref.c_Plan_Kind_Contract and
              Fazo.Equal(r_Plan.Journal_Page_Id, v_Robot_Page.Page_Id)) then
            continue;
          end if;
        end if;
      
        if r_Trans.Page_Id not member of v_Pages then
          Fazo.Push(v_Pages, r_Trans.Page_Id);
        
          v_Staff_Plan := Hper_Util.Staff_Plan(i_Company_Id => r_Trans.Company_Id,
                                               i_Filial_Id  => r_Trans.Filial_Id,
                                               i_Page_Id    => r_Trans.Page_Id,
                                               i_Plan_Date  => v_Plan_Date);
        
          continue when v_Staff_Plan.Status != Hper_Pref.c_Staff_Plan_Status_Draft;
        
          Gen_Staff_Plans(i_Company_Id       => r_Trans.Company_Id,
                          i_Filial_Id        => r_Trans.Filial_Id,
                          i_Page_Id          => r_Trans.Page_Id,
                          i_Staff_Plan_Id    => v_Staff_Plan.Staff_Plan_Id,
                          i_Period           => v_Dates(i),
                          i_Plan_Date        => v_Plan_Date,
                          i_Month_Begin_Date => v_Month_Begin_Date,
                          i_Month_End_Date   => v_Month_End_Date,
                          i_Trans_Robot      => r_Closest_Robot);
        
        end if;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_All is
    v_Gen_Date date;
  begin
    Biruni_Route.Context_Begin;
  
    for r in (select *
                from Md_Filials q
               where q.State = 'A')
    loop
      -- TODO review
      -- remove ui_auth from hper_core procedures
      Ui_Auth.Logon_As_System(r.Company_Id);
    
      v_Gen_Date := Trunc(Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                                     i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => r.Company_Id,
                                                                                           i_Filial_Id  => r.Filial_Id)) + 1);
      Gen_Plans(i_Company_Id => r.Company_Id, --
                i_Filial_Id  => r.Filial_Id,
                i_Date       => v_Gen_Date);
    end loop;
  
    Biruni_Route.Context_End;
  end;

end Hper_Core;
/
