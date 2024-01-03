create or replace package Hpr_Core is
  ----------------------------------------------------------------------------------------------------  
  Procedure Generate_Fact_Of_Cv_Contract
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number,
    i_Month       date
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Cv_Contract_Fact_Save(i_Contract_Fact Hpr_Pref.Cv_Contract_Fact_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Cv_Contract_Facts_Delete
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Begin_Date        date,
    i_Early_Closed_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Save(i_Penalty Hpr_Pref.Penalty_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Timesheets
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Unlock_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Regen_Timebook_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Staff_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Staffs_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Save(i_Timebook Hpr_Pref.Timebook_Rt);
  ----------------------------------------------------------------------------------------------------
  Function Sheet_Staff_Used
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    o_Sheet_Id     out number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Staff_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Staffs_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Staff_Insert
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Sheet_Id       number,
    i_Staff_Id       number,
    i_Period_Begin   date,
    i_Period_End     date,
    i_Accrual_Amount number,
    i_Penalty_Amount number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Sheet_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  -- this function must be used only from hpd_core
  Procedure Charge_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Charge_Id    number := null,
    i_Interval_Id  number,
    i_Doc_Oper_Id  number := null,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Currency_Id  number := null,
    i_Amount       number := null,
    i_Status       varchar := Hpr_Pref.c_Charge_Status_New
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Draft
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Charge_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Charge_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Charge_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Save(i_Oper_Type Hpr_Pref.Oper_Type_Rt);
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
  Procedure Advance_Save(i_Advance Hpr_Pref.Advance_Rt);
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
  Procedure Run_Monthly_Credit_Transactions;
end Hpr_Core;
/
create or replace package body Hpr_Core is
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
  Procedure Generate_Fact_Of_Cv_Contract
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number,
    i_Month       date
  ) is
    r_Fact Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact.Company_Id  := i_Company_Id;
    r_Fact.Filial_Id   := i_Filial_Id;
    r_Fact.Fact_Id     := Hpr_Next.Cv_Contract_Fact_Id;
    r_Fact.Contract_Id := i_Contract_Id;
    r_Fact.Month       := i_Month;
    r_Fact.Status      := Hpr_Pref.c_Cv_Contract_Fact_Status_New;
  
    z_Hpr_Cv_Contract_Facts.Save_Row(r_Fact);
  
    for r in (select *
                from Hpd_Cv_Contract_Items q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Contract_Id = i_Contract_Id)
    loop
      z_Hpr_Cv_Contract_Fact_Items.Save_One(i_Company_Id       => r.Company_Id,
                                            i_Filial_Id        => r.Filial_Id,
                                            i_Fact_Item_Id     => Hpr_Next.Cv_Contract_Fact_Item_Id,
                                            i_Fact_Id          => r_Fact.Fact_Id,
                                            i_Contract_Item_Id => r.Contract_Item_Id,
                                            i_Plan_Quantity    => r.Quantity,
                                            i_Plan_Amount      => r.Amount,
                                            i_Fact_Quantity    => 0,
                                            i_Fact_Amount      => 0,
                                            i_Name             => r.Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Fact_Save(i_Contract_Fact Hpr_Pref.Cv_Contract_Fact_Rt) is
    r_Fact               Hpr_Cv_Contract_Facts%rowtype;
    r_Item               Hpr_Cv_Contract_Fact_Items%rowtype;
    v_Item               Hpr_Pref.Cv_Contract_Fact_Item_Rt;
    v_Access_To_Add_Item boolean;
    v_Fact_Item_Ids      Array_Number := Array_Number();
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Lock_Load(i_Company_Id => i_Contract_Fact.Company_Id,
                                                i_Filial_Id  => i_Contract_Fact.Filial_Id,
                                                i_Fact_Id    => i_Contract_Fact.Fact_Id);
  
    if r_Fact.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_New then
      Hpr_Error.Raise_001(i_Fact_Id     => r_Fact.Fact_Id,
                          i_Status_Name => Hpr_Util.t_Cv_Fact_Status(r_Fact.Status));
    end if;
  
    v_Access_To_Add_Item := z_Hpd_Cv_Contracts.Load(i_Company_Id => r_Fact.Company_Id, --
                            i_Filial_Id => r_Fact.Filial_Id, --
                            i_Contract_Id => r_Fact.Contract_Id).Access_To_Add_Item = 'Y';
  
    v_Fact_Item_Ids.Extend(i_Contract_Fact.Items.Count);
  
    for i in 1 .. i_Contract_Fact.Items.Count
    loop
      v_Item := i_Contract_Fact.Items(i);
    
      if z_Hpr_Cv_Contract_Fact_Items.Exist_Lock(i_Company_Id   => r_Fact.Company_Id,
                                                 i_Filial_Id    => r_Fact.Filial_Id,
                                                 i_Fact_Item_Id => v_Item.Fact_Item_Id,
                                                 o_Row          => r_Item) then
        if r_Item.Fact_Id != r_Fact.Fact_Id then
          Hpr_Error.Raise_002(i_Fact_Id      => r_Fact.Fact_Id,
                              i_Item_Fact_Id => r_Item.Fact_Id,
                              i_Item_Id      => r_Item.Fact_Item_Id);
        end if;
      
        r_Item.Fact_Amount := v_Item.Fact_Amount;
      
        if r_Item.Contract_Item_Id is not null then
          r_Item.Fact_Quantity := v_Item.Fact_Amount * r_Item.Plan_Quantity / r_Item.Plan_Amount;
        else
          if v_Access_To_Add_Item then
            r_Item.Name          := v_Item.Name;
            r_Item.Fact_Quantity := 1;
          else
            Hpr_Error.Raise_003(r_Fact.Contract_Id);
          end if;
        end if;
      
        z_Hpr_Cv_Contract_Fact_Items.Save_Row(r_Item);
      else
        if not v_Access_To_Add_Item then
          Hpr_Error.Raise_004(r_Fact.Contract_Id);
        end if;
      
        z_Hpr_Cv_Contract_Fact_Items.Insert_One(i_Company_Id    => r_Fact.Company_Id,
                                                i_Filial_Id     => r_Fact.Filial_Id,
                                                i_Fact_Item_Id  => v_Item.Fact_Item_Id,
                                                i_Fact_Id       => r_Fact.Fact_Id,
                                                i_Fact_Quantity => 1,
                                                i_Fact_Amount   => v_Item.Fact_Amount,
                                                i_Name          => v_Item.Name);
      end if;
    
      v_Fact_Item_Ids(i) := v_Item.Fact_Item_Id;
    end loop;
  
    delete Hpr_Cv_Contract_Fact_Items q
     where q.Company_Id = r_Fact.Company_Id
       and q.Filial_Id = r_Fact.Filial_Id
       and q.Fact_Id = r_Fact.Fact_Id
       and q.Fact_Item_Id not member of v_Fact_Item_Ids;
  
    select sum(q.Fact_Amount)
      into r_Fact.Total_Amount
      from Hpr_Cv_Contract_Fact_Items q
     where q.Company_Id = r_Fact.Company_Id
       and q.Filial_Id = r_Fact.Filial_Id
       and q.Fact_Id = r_Fact.Fact_Id;
  
    z_Hpr_Cv_Contract_Facts.Save_Row(r_Fact);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cv_Contract_Facts_Delete
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Begin_Date        date,
    i_Early_Closed_Date date
  ) is
    v_Fact_Id number;
    v_Month   date;
    v_Status  varchar2(1);
  begin
    select q.Fact_Id, q.Month, q.Status
      into v_Fact_Id, v_Month, v_Status
      from Hpr_Cv_Contract_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Contract_Id = i_Contract_Id
       and q.Month not between i_Begin_Date and i_Early_Closed_Date
       and q.Status != Hpr_Pref.c_Cv_Contract_Fact_Status_New
       and Rownum = 1;
  
    Hpr_Error.Raise_005(i_Fact_Id     => v_Fact_Id,
                        i_Month       => v_Month,
                        i_Status_Name => Hpr_Util.t_Cv_Fact_Status(v_Status));
  exception
    when No_Data_Found then
      delete from Hpr_Cv_Contract_Facts q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Contract_Id = i_Contract_Id
         and q.Month not between i_Begin_Date and i_Early_Closed_Date;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Penalty_Save(i_Penalty Hpr_Pref.Penalty_Rt) is
    r_Penalty       Hpr_Penalties%rowtype;
    v_Policy        Hpr_Pref.Penalty_Policy_Rt;
    v_Policy_2      Hpr_Pref.Penalty_Policy_Rt;
    v_Penalty_Codes Array_Varchar2;
    v_Key           varchar2(100);
    v_Index         number;
    v_Cache         Fazo.Number_Code_Aat;
    v_Ids           Array_Number;
    v_Matrix        Matrix_Number := Matrix_Number();
    v_Max_Value     number := 1000000000;
    v_Exists        boolean := false;
  
    -------------------------------------------------
    Function Penalty_Number(i_Penalty_Kind varchar2) return number is
    begin
      return --
      case i_Penalty_Kind --
      when Hpr_Pref.c_Penalty_Kind_Late then 1 --
      when Hpr_Pref.c_Penalty_Kind_Early then 2 --
      when Hpr_Pref.c_Penalty_Kind_Lack then 3 --
      when Hpr_Pref.c_Penalty_Kind_Day_Skip then 4 --
      when Hpr_Pref.c_Penalty_Kind_Mark_Skip then 5 --
      end;
    end;
  
    -------------------------------------------------  
    Function Penalty_Kind(i_Penalty_Number varchar2) return varchar2 is
    begin
      return --
      case i_Penalty_Number --
      when 1 then Hpr_Pref.c_Penalty_Kind_Late --
      when 2 then Hpr_Pref.c_Penalty_Kind_Early --
      when 3 then Hpr_Pref.c_Penalty_Kind_Lack --
      when 4 then Hpr_Pref.c_Penalty_Kind_Day_Skip --
      when 5 then Hpr_Pref.c_Penalty_Kind_Mark_Skip --
      end;
    end;
  
    -------------------------------------------------- 
    Procedure Fix_Policy(p_Policy in out nocopy Hpr_Pref.Penalty_Policy_Rt) is
    begin
      case p_Policy.Penalty_Type
        when Hpr_Pref.c_Penalty_Type_Coef then
          p_Policy.Penalty_Per_Time := null;
          p_Policy.Penalty_Amount   := null;
          p_Policy.Penalty_Time     := null;
        when Hpr_Pref.c_Penalty_Type_Amount then
          p_Policy.Penalty_Coef := null;
          p_Policy.Penalty_Time := null;
        when Hpr_Pref.c_Penalty_Type_Time then
          p_Policy.Penalty_Coef     := null;
          p_Policy.Penalty_Per_Time := null;
          p_Policy.Penalty_Amount   := null;
      end case;
    end;
  
    --------------------------------------------------
    Function Penalty_Unit_Min_Or_Times(i_Penalty_Kind varchar2) return varchar2 is
    begin
      if i_Penalty_Kind = Hpr_Pref.c_Penalty_Kind_Mark_Skip then
        return Hpr_Util.t_Penalty_Rule_Unit_Times;
      else
        return Hpr_Util.t_Penalty_Rule_Unit_Min;
      end if;
    end;
  begin
    -- check
    for i in 1 .. i_Penalty.Policies.Count
    loop
      v_Policy           := i_Penalty.Policies(i);
      v_Policy.From_Time := Nvl(v_Policy.From_Time, 0);
      v_Policy.To_Time   := Nvl(v_Policy.To_Time, v_Max_Value);
    
      v_Key := v_Policy.Penalty_Kind || ':' || v_Policy.From_Time || ':' || v_Policy.To_Time;
    
      begin
        v_Index := v_Cache(v_Key);
      exception
        when No_Data_Found then
          Fazo.Push(v_Matrix,
                    Array_Number(Penalty_Number(v_Policy.Penalty_Kind),
                                 v_Policy.From_Time,
                                 v_Policy.To_Time));
        
          v_Index := v_Matrix.Count;
          v_Cache(v_Key) := v_Index;
      end;
    
      Fazo.Push(v_Matrix(v_Index), i);
    end loop;
  
    -- matrix keeps penalty policies
    -- values in one matrix row:
    -- indexes:
    --        1: penalty_kind
    --        2: from_time 
    --        3: to_time
    --       >4: indexes of policies with same (from_time, to_time) 
    --           but different (from_day, to_day)
  
    for i in 1 .. v_Matrix.Count
    loop
      for j in i + 1 .. v_Matrix.Count
      loop
        if v_Matrix(i) (1) = v_Matrix(j) (1) and --
           v_Matrix(i) (3) > v_Matrix(j) (2) and v_Matrix(i) (2) < v_Matrix(j) (3) then
          Hpr_Error.Raise_006(i_Penalty_Kind => Hpr_Util.t_Penalty_Kind(Penalty_Kind(v_Matrix(i) (1))),
                              i_First_Rule   => Href_Util.t_From_To_Rule(i_From      => v_Matrix(i) (2),
                                                                         i_To        => v_Matrix(i) (3),
                                                                         i_Rule_Unit => Penalty_Unit_Min_Or_Times(v_Matrix(i) (1))),
                              i_Second_Rule  => Href_Util.t_From_To_Rule(i_From      => v_Matrix(j) (2),
                                                                         i_To        => v_Matrix(j) (3),
                                                                         i_Rule_Unit => Penalty_Unit_Min_Or_Times(v_Matrix(i) (1))));
        end if;
      end loop;
    end loop;
  
    for k in 1 .. v_Matrix.Count
    loop
      v_Ids := v_Matrix(k);
    
      for i in 4 .. v_Ids.Count
      loop
        v_Policy          := i_Penalty.Policies(v_Ids(i));
        v_Policy.From_Day := Nvl(v_Policy.From_Day, 0);
        v_Policy.To_Day   := Nvl(v_Policy.To_Day, v_Max_Value);
      
        for j in i + 1 .. v_Ids.Count
        loop
          v_Policy_2          := i_Penalty.Policies(v_Ids(j));
          v_Policy_2.From_Day := Nvl(v_Policy_2.From_Day, 0);
          v_Policy_2.To_Day   := Nvl(v_Policy_2.To_Day, v_Max_Value);
        
          if v_Policy.To_Day > v_Policy_2.From_Day and v_Policy.From_Day < v_Policy_2.To_Day then
            Hpr_Error.Raise_007(i_Time_Rule    => Href_Util.t_From_To_Rule(i_From      => v_Policy.From_Time,
                                                                           i_To        => v_Policy.To_Time,
                                                                           i_Rule_Unit => Hpr_Util.t_Penalty_Rule_Unit_Min),
                                i_Penalty_Kind => Hpr_Util.t_Penalty_Kind(v_Policy.Penalty_Kind),
                                i_First_Rule   => Href_Util.t_From_To_Rule(i_From      => v_Policy.From_Day,
                                                                           i_To        => v_Policy.To_Day,
                                                                           i_Rule_Unit => Hpr_Util.t_Penalty_Rule_Unit_Days),
                                i_Second_Rule  => Href_Util.t_From_To_Rule(i_From      => v_Policy_2.From_Day,
                                                                           i_To        => v_Policy_2.To_Day,
                                                                           i_Rule_Unit => Hpr_Util.t_Penalty_Rule_Unit_Days));
          end if;
        end loop;
      end loop;
    end loop;
  
    -- save
    if z_Hpr_Penalties.Exist_Lock(i_Company_Id => i_Penalty.Company_Id,
                                  i_Filial_Id  => i_Penalty.Filial_Id,
                                  i_Penalty_Id => i_Penalty.Penalty_Id,
                                  o_Row        => r_Penalty) then
      if r_Penalty.Month <> i_Penalty.Month then
        Hpr_Error.Raise_008(r_Penalty.Penalty_Id);
      end if;
    
      if not Fazo.Equal(r_Penalty.Division_Id, i_Penalty.Division_Id) then
        Hpr_Error.Raise_009(r_Penalty.Penalty_Id);
      end if;
    
      v_Exists := true;
    else
      r_Penalty.Company_Id  := i_Penalty.Company_Id;
      r_Penalty.Filial_Id   := i_Penalty.Filial_Id;
      r_Penalty.Penalty_Id  := i_Penalty.Penalty_Id;
      r_Penalty.Month       := i_Penalty.Month;
      r_Penalty.Division_Id := i_Penalty.Division_Id;
    end if;
  
    r_Penalty.Name  := i_Penalty.Name;
    r_Penalty.State := i_Penalty.State;
  
    if v_Exists then
      z_Hpr_Penalties.Update_Row(r_Penalty);
    else
      z_Hpr_Penalties.Insert_Row(r_Penalty);
    end if;
  
    v_Penalty_Codes := Array_Varchar2();
    v_Penalty_Codes.Extend(i_Penalty.Policies.Count);
  
    for i in 1 .. i_Penalty.Policies.Count
    loop
      v_Policy := i_Penalty.Policies(i);
    
      Fix_Policy(v_Policy);
    
      z_Hpr_Penalty_Policies.Save_One(i_Company_Id           => i_Penalty.Company_Id,
                                      i_Filial_Id            => i_Penalty.Filial_Id,
                                      i_Penalty_Id           => i_Penalty.Penalty_Id,
                                      i_Penalty_Kind         => v_Policy.Penalty_Kind,
                                      i_From_Day             => v_Policy.From_Day,
                                      i_From_Time            => v_Policy.From_Time,
                                      i_To_Day               => v_Policy.To_Day,
                                      i_To_Time              => v_Policy.To_Time,
                                      i_Penalty_Coef         => v_Policy.Penalty_Coef,
                                      i_Penalty_Per_Time     => v_Policy.Penalty_Per_Time,
                                      i_Penalty_Amount       => v_Policy.Penalty_Amount,
                                      i_Penalty_Time         => v_Policy.Penalty_Time,
                                      i_Calc_After_From_Time => v_Policy.Calc_After_From_Time);
    
      v_Penalty_Codes(i) := v_Policy.Penalty_Kind || ':' || v_Policy.From_Day || ':' ||
                            v_Policy.From_Time;
    end loop;
  
    if v_Exists then
      for r in (select *
                  from Hpr_Penalty_Policies q
                 where q.Company_Id = i_Penalty.Company_Id
                   and q.Filial_Id = i_Penalty.Filial_Id
                   and q.Penalty_Id = i_Penalty.Penalty_Id
                   and q.Penalty_Kind || ':' || q.From_Day || ':' || q.From_Time not member of
                 v_Penalty_Codes)
      loop
        z_Hpr_Penalty_Policies.Delete_One(i_Company_Id   => r.Company_Id,
                                          i_Filial_Id    => r.Filial_Id,
                                          i_Penalty_Id   => r.Penalty_Id,
                                          i_Penalty_Kind => r.Penalty_Kind,
                                          i_From_Day     => r.From_Day,
                                          i_From_Time    => r.From_Time);
      end loop;
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Lock_Timesheets
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    for r in (select *
                from Htt_Timesheets t
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and exists (select *
                        from Hpr_Timebook_Staffs Ts
                       where Ts.Company_Id = i_Company_Id
                         and Ts.Filial_Id = i_Filial_Id
                         and Ts.Timebook_Id = i_Timebook_Id
                         and Ts.Staff_Id = t.Staff_Id)
                 and t.Timesheet_Date >= i_Period_Begin
                 and t.Timesheet_Date <= i_Period_End)
    loop
      Htt_Core.Timesheet_Lock(i_Company_Id     => r.Company_Id,
                              i_Filial_Id      => r.Filial_Id,
                              i_Staff_Id       => r.Staff_Id,
                              i_Timesheet_Date => r.Timesheet_Date);
    
      z_Hpr_Timesheet_Locks.Insert_One(i_Company_Id     => r.Company_Id,
                                       i_Filial_Id      => r.Filial_Id,
                                       i_Staff_Id       => r.Staff_Id,
                                       i_Timesheet_Date => r.Timesheet_Date,
                                       i_Timebook_Id    => i_Timebook_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unlock_Timesheets
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number
  ) is
  begin
    for r in (select *
                from Hpr_Timesheet_Locks Tl
               where Tl.Company_Id = i_Company_Id
                 and Tl.Filial_Id = i_Filial_Id
                 and Tl.Timebook_Id = i_Timebook_Id)
    loop
      z_Hpr_Timesheet_Locks.Delete_One(i_Company_Id     => r.Company_Id,
                                       i_Filial_Id      => r.Filial_Id,
                                       i_Staff_Id       => r.Staff_Id,
                                       i_Timesheet_Date => r.Timesheet_Date);
    
      Htt_Core.Timesheet_Unlock(i_Company_Id     => r.Company_Id,
                                i_Filial_Id      => r.Filial_Id,
                                i_Staff_Id       => r.Staff_Id,
                                i_Timesheet_Date => r.Timesheet_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Timebook_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    v_Facts      Htt_Pref.Timesheet_Aggregated_Fact_Nt;
    v_Fact_Hours number;
  begin
    v_Facts := Htt_Util.Get_Full_Facts(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Begin_Date => i_Begin_Date,
                                       i_End_Date   => i_End_Date);
  
    -- save facts  
    for i in 1 .. v_Facts.Count
    loop
      v_Fact_Hours := Round(v_Facts(i).Fact_Value / 3600, 2);
    
      if v_Fact_Hours > 0 then
        z_Hpr_Timebook_Facts.Insert_One(i_Company_Id   => i_Company_Id,
                                        i_Filial_Id    => i_Filial_Id,
                                        i_Timebook_Id  => i_Timebook_Id,
                                        i_Staff_Id     => i_Staff_Id,
                                        i_Time_Kind_Id => v_Facts(i).Time_Kind_Id,
                                        i_Fact_Hours   => v_Fact_Hours);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  -- this function must be used only from hpd_core
  ---------------------------------------------------------------------------------------------------- 
  Procedure Regen_Timebook_Facts
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number
  ) is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    r_Timebook := z_Hpr_Timebooks.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Timebook_Id => i_Timebook_Id);
  
    delete Hpr_Timebook_Facts Tf
     where Tf.Company_Id = i_Company_Id
       and Tf.Filial_Id = i_Filial_Id
       and Tf.Timebook_Id = i_Timebook_Id
       and Tf.Staff_Id = i_Staff_Id;
  
    Gen_Timebook_Facts(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Timebook_Id => i_Timebook_Id,
                       i_Staff_Id    => i_Staff_Id,
                       i_Begin_Date  => r_Timebook.Period_Begin,
                       i_End_Date    => r_Timebook.Period_End);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Staff_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    r_Robot            Mrf_Robots%rowtype;
    r_Staff            Href_Staffs%rowtype;
    v_Desired_Date     date;
    v_Time_Kind_Id     number;
    v_Plan_Days        number;
    v_Plan_Hours       number;
    v_Fact_Days        number;
    v_Fact_Hours       number;
  
    --------------------------------------------------
    Function Get_Lock_Timebook_Number return number is
      result varchar2(50 char);
    begin
      select (select p.Timebook_Number
                from Hpr_Timebooks p
               where p.Company_Id = w.Company_Id
                 and p.Filial_Id = w.Filial_Id
                 and p.Timebook_Id = w.Timebook_Id)
        into result
        from Hpr_Timesheet_Locks w
       where w.Company_Id = i_Company_Id
         and w.Filial_Id = i_Filial_Id
         and w.Staff_Id = i_Staff_Id
         and w.Timesheet_Date >= i_Period_Begin
         and w.Timesheet_Date <= i_Period_End
         and (i_Timebook_Id is null or w.Timebook_Id <> i_Timebook_Id)
         and Rownum = 1;
    
      return result;
    end;
  begin
    if Hpr_Util.Is_Staff_Blocked(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Id     => i_Staff_Id,
                                 i_Timebook_Id  => i_Timebook_Id,
                                 i_Period_Begin => i_Period_Begin,
                                 i_Period_End   => i_Period_End) = 'Y' then
      Hpr_Error.Raise_010(i_Timebook_Number => Get_Lock_Timebook_Number,
                          i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                          i_Period_Begin    => i_Period_Begin,
                          i_Period_End      => i_Period_End);
    end if;
  
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    Href_Util.Assert_Staff_Licensed(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => i_Staff_Id,
                                    i_Period_Begin => i_Period_Begin,
                                    i_Period_End   => i_Period_End);
  
    v_Desired_Date := Least(i_Period_End, Nvl(r_Staff.Dismissal_Date, i_Period_End));
  
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Period     => v_Desired_Date);
  
    -- TODO: should be fixed  
    /*    if i_Division_Id is not null then
      if i_Division_Id <> r_Closest_Robot.Division_Id then
     Hpr_Error.Raise_033(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                i_Filial_Id  => i_Filial_Id,
                                                                i_Staff_Id   => i_Staff_Id),
                        i_Division_Name => z_Mhr_Divisions.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => i_Division_Id).Name); 
      end if;
    end if;*/
  
    -- plan_days is number of working days plus nonworking days that replace working days
    -- such nonworking days are determined by having plan time above zero
    -- counted from timesheets table
    -- since there may be several schedules working in same month
    select count(*), Round(sum(t.Plan_Time) / 3600, 2)
      into v_Plan_Days, v_Plan_Hours
      from Htt_Timesheets t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Id = i_Staff_Id
       and t.Timesheet_Date >= i_Period_Begin
       and t.Timesheet_Date <= i_Period_End
       and t.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking)
       and t.Full_Time > 0;
  
    -- fact days and hours for timebook staffs table
    -- such working days that have turnout time kind 
    -- and its child time kind fact value above zero
    v_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Hours,
                                  o_Fact_Days    => v_Fact_Days,
                                  i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Time_Kind_Id => v_Time_Kind_Id,
                                  i_Begin_Date   => i_Period_Begin,
                                  i_End_Date     => i_Period_End);
  
    v_Fact_Hours := Round(v_Fact_Hours / 3600, 2);
  
    r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => i_Staff_Id,
                                                    i_Period     => v_Desired_Date);
  
    z_Hpr_Timebook_Staffs.Insert_One(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Timebook_Id => i_Timebook_Id,
                                     i_Staff_Id    => i_Staff_Id,
                                     i_Schedule_Id => r_Closest_Schedule.Schedule_Id,
                                     i_Job_Id      => r_Robot.Job_Id,
                                     i_Division_Id => r_Robot.Division_Id,
                                     i_Plan_Days   => Nvl(v_Plan_Days, 0),
                                     i_Plan_Hours  => Nvl(v_Plan_Hours, 0),
                                     i_Fact_Days   => Nvl(v_Fact_Days, 0),
                                     i_Fact_Hours  => Nvl(v_Fact_Hours, 0));
  
    Gen_Timebook_Facts(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Timebook_Id => i_Timebook_Id,
                       i_Staff_Id    => i_Staff_Id,
                       i_Begin_Date  => i_Period_Begin,
                       i_End_Date    => i_Period_End);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Staffs_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
    v_Staff_Ids Array_Number;
  begin
    delete Hpr_Timebook_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Timebook_Id = i_Timebook_Id
    returning q.Staff_Id bulk collect into v_Staff_Ids;
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      Timebook_Staff_Insert(i_Company_Id   => i_Company_Id,
                            i_Filial_Id    => i_Filial_Id,
                            i_Timebook_Id  => i_Timebook_Id,
                            i_Staff_Id     => v_Staff_Ids(i),
                            i_Period_Begin => i_Period_Begin,
                            i_Period_End   => i_Period_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Timebook_Save(i_Timebook Hpr_Pref.Timebook_Rt) is
    r_Timebook Hpr_Timebooks%rowtype;
    v_Exists   boolean;
  begin
    if z_Hpr_Timebooks.Exist_Lock(i_Company_Id  => i_Timebook.Company_Id,
                                  i_Filial_Id   => i_Timebook.Filial_Id,
                                  i_Timebook_Id => i_Timebook.Timebook_Id,
                                  o_Row         => r_Timebook) then
      if r_Timebook.Posted = 'Y' then
        Hpr_Error.Raise_011(r_Timebook.Timebook_Number);
      end if;
    
      v_Exists := true;
    else
      r_Timebook.Company_Id  := i_Timebook.Company_Id;
      r_Timebook.Filial_Id   := i_Timebook.Filial_Id;
      r_Timebook.Timebook_Id := i_Timebook.Timebook_Id;
      r_Timebook.Posted      := 'N';
    
      v_Exists := false;
    end if;
  
    r_Timebook.Timebook_Number := i_Timebook.Timebook_Number;
    r_Timebook.Timebook_Date   := i_Timebook.Timebook_Date;
    r_Timebook.Division_Id     := i_Timebook.Division_Id;
    r_Timebook.Period_Begin    := i_Timebook.Period_Begin;
    r_Timebook.Period_End      := i_Timebook.Period_End;
    r_Timebook.Period_Kind     := i_Timebook.Period_Kind;
    r_Timebook.Note            := i_Timebook.Note;
  
    if v_Exists then
      z_Hpr_Timebooks.Update_Row(r_Timebook);
    else
      if r_Timebook.Timebook_Number is null then
        r_Timebook.Timebook_Number := Md_Core.Gen_Number(i_Company_Id => i_Timebook.Company_Id,
                                                         i_Filial_Id  => i_Timebook.Filial_Id,
                                                         i_Table      => Zt.Hpr_Timebooks,
                                                         i_Column     => z.Timebook_Id);
      end if;
    
      r_Timebook.Barcode := Md_Core.Gen_Barcode(i_Table => Zt.Hpr_Timebooks,
                                                i_Id    => i_Timebook.Timebook_Id);
    
      z_Hpr_Timebooks.Insert_Row(r_Timebook);
    end if;
  
    -- delete staffs
    delete Hpr_Timebook_Staffs q
     where q.Company_Id = r_Timebook.Company_Id
       and q.Filial_Id = r_Timebook.Filial_Id
       and q.Timebook_Id = r_Timebook.Timebook_Id;
  
    -- staff save
    for i in 1 .. i_Timebook.Staff_Ids.Count
    loop
      Timebook_Staff_Insert(i_Company_Id   => i_Timebook.Company_Id,
                            i_Filial_Id    => i_Timebook.Filial_Id,
                            i_Timebook_Id  => i_Timebook.Timebook_Id,
                            i_Staff_Id     => i_Timebook.Staff_Ids(i),
                            i_Period_Begin => i_Timebook.Period_Begin,
                            i_Period_End   => i_Timebook.Period_End);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sheet_Staff_Used
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    o_Sheet_Id     out number
  ) return boolean is
  begin
    select p.Sheet_Id
      into o_Sheet_Id
      from Hpr_Sheet_Parts p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Staff_Id = i_Staff_Id
       and p.Part_Begin <= i_Period_End
       and p.Part_End >= i_Period_Begin
       and exists (select *
              from Hpr_Wage_Sheets Ws
             where Ws.Company_Id = p.Company_Id
               and Ws.Filial_Id = p.Filial_Id
               and Ws.Sheet_Id = p.Sheet_Id
               and Ws.Posted = 'Y')
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Staff_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  ) is
    v_Part  Hpr_Pref.Sheet_Part_Rt;
    v_Parts Hpr_Pref.Sheet_Part_Nt;
  
    v_Lock_Sheet_Id number;
  begin
    if Sheet_Staff_Used(i_Company_Id   => i_Company_Id,
                        i_Filial_Id    => i_Filial_Id,
                        i_Staff_Id     => i_Staff_Id,
                        i_Period_Begin => i_Period_Begin,
                        i_Period_End   => i_Period_End,
                        o_Sheet_Id     => v_Lock_Sheet_Id) then
      Hpr_Error.Raise_012(i_Sheet_Number => z_Hpr_Wage_Sheets.Load(i_Company_Id => i_Company_Id, --
                                            i_Filial_Id => i_Filial_Id, --
                                            i_Sheet_Id => v_Lock_Sheet_Id).Sheet_Number,
                          i_Staff_Name   => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                 i_Filial_Id  => i_Filial_Id,
                                                                 i_Staff_Id   => i_Staff_Id),
                          i_Period_Begin => i_Period_Begin,
                          i_Period_End   => i_Period_End);
    end if;
  
    Href_Util.Assert_Staff_Licensed(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => i_Staff_Id,
                                    i_Period_Begin => i_Period_Begin,
                                    i_Period_End   => i_Period_End);
  
    v_Parts := Hpr_Util.Calc_Staff_Parts(i_Company_Id   => i_Company_Id,
                                         i_Filial_Id    => i_Filial_Id,
                                         i_Staff_Id     => i_Staff_Id,
                                         i_Period_Begin => i_Period_Begin,
                                         i_Period_End   => i_Period_End,
                                         i_Round_Model  => i_Round_Model);
  
    for i in 1 .. v_Parts.Count
    loop
      v_Part := v_Parts(i);
    
      z_Hpr_Sheet_Parts.Insert_One(i_Company_Id       => i_Company_Id,
                                   i_Filial_Id        => i_Filial_Id,
                                   i_Part_Id          => Hpr_Next.Sheet_Part_Id,
                                   i_Part_Begin       => v_Part.Part_Begin,
                                   i_Part_End         => v_Part.Part_End,
                                   i_Staff_Id         => i_Staff_Id,
                                   i_Sheet_Id         => i_Sheet_Id,
                                   i_Division_Id      => v_Part.Division_Id,
                                   i_Job_Id           => v_Part.Job_Id,
                                   i_Schedule_Id      => v_Part.Schedule_Id,
                                   i_Fte_Id           => v_Part.Fte_Id,
                                   i_Monthly_Amount   => v_Part.Monthly_Amount,
                                   i_Plan_Amount      => v_Part.Plan_Amount,
                                   i_Wage_Amount      => v_Part.Wage_Amount,
                                   i_Overtime_Amount  => v_Part.Overtime_Amount,
                                   i_Nighttime_Amount => v_Part.Nighttime_Amount,
                                   i_Late_Amount      => v_Part.Late_Amount,
                                   i_Early_Amount     => v_Part.Early_Amount,
                                   i_Lack_Amount      => v_Part.Lack_Amount,
                                   i_Day_Skip_Amount  => v_Part.Day_Skip_Amount,
                                   i_Mark_Skip_Amount => v_Part.Mark_Skip_Amount);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sheet_Staffs_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Round_Model  Round_Model
  ) is
    v_Staff_Ids Array_Number;
  begin
    delete Hpr_Sheet_Parts p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Sheet_Id = i_Sheet_Id
    returning p.Staff_Id bulk collect into v_Staff_Ids;
  
    v_Staff_Ids := set(v_Staff_Ids);
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      Sheet_Staff_Insert(i_Company_Id   => i_Company_Id,
                         i_Filial_Id    => i_Filial_Id,
                         i_Sheet_Id     => i_Sheet_Id,
                         i_Staff_Id     => v_Staff_Ids(i),
                         i_Period_Begin => i_Period_Begin,
                         i_Period_End   => i_Period_End,
                         i_Round_Model  => i_Round_Model);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Staff_Insert
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Sheet_Id       number,
    i_Staff_Id       number,
    i_Period_Begin   date,
    i_Period_End     date,
    i_Accrual_Amount number,
    i_Penalty_Amount number
  ) is
    r_Staff        Href_Staffs%rowtype;
    r_Robot        Hpd_Trans_Robots%rowtype;
    r_Schedule     Hpd_Trans_Schedules%rowtype;
    v_Desired_Date date;
  begin
    if i_Accrual_Amount is null and i_Penalty_Amount is null then
      return;
    end if;
  
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    Href_Util.Assert_Staff_Licensed(i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => i_Staff_Id,
                                    i_Period_Begin => i_Period_Begin,
                                    i_Period_End   => i_Period_End);
  
    v_Desired_Date := Least(i_Period_End, Nvl(r_Staff.Dismissal_Date, i_Period_End));
  
    r_Robot := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => i_Staff_Id,
                                      i_Period     => v_Desired_Date);
  
    r_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Period     => v_Desired_Date);
  
    z_Hpr_Onetime_Sheet_Staffs.Insert_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Sheet_Id       => i_Sheet_Id,
                                          i_Staff_Id       => i_Staff_Id,
                                          i_Month          => Trunc(i_Period_Begin, 'mon'),
                                          i_Division_Id    => r_Robot.Division_Id,
                                          i_Job_Id         => r_Robot.Job_Id,
                                          i_Schedule_Id    => r_Schedule.Schedule_Id,
                                          i_Accrual_Amount => Nvl(i_Accrual_Amount, 0),
                                          i_Penalty_Amount => Nvl(i_Penalty_Amount, 0));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Onetime_Sheet_Update
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Sheet_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
    v_Staff        Hpr_Pref.Sheet_Staff_Rt;
    v_Sheet_Staffs Hpr_Pref.Sheet_Staff_Nt;
  begin
    delete Hpr_Onetime_Sheet_Staffs p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id
       and p.Sheet_Id = i_Sheet_Id
    returning p.Staff_Id, p.Accrual_Amount, p.Penalty_Amount bulk collect into v_Sheet_Staffs;
  
    for i in 1 .. v_Sheet_Staffs.Count
    loop
      v_Staff := v_Sheet_Staffs(i);
    
      Onetime_Staff_Insert(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Sheet_Id       => i_Sheet_Id,
                           i_Staff_Id       => v_Staff.Staff_Id,
                           i_Period_Begin   => i_Period_Begin,
                           i_Period_End     => i_Period_End,
                           i_Accrual_Amount => v_Staff.Accrual_Amount,
                           i_Penalty_Amount => v_Staff.Penalty_Amount);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  -- this function must be used only from hpd_core
  Procedure Charge_Insert
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Charge_Id    number := null,
    i_Interval_Id  number,
    i_Doc_Oper_Id  number := null,
    i_Staff_Id     number,
    i_Oper_Type_Id number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Currency_Id  number := null,
    i_Amount       number := null,
    i_Status       varchar := Hpr_Pref.c_Charge_Status_New
  ) is
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    r_Closest_Rank     Hpd_Trans_Ranks%rowtype;
    r_Closest_Currency Hpd_Trans_Currencies%rowtype;
    r_Robot            Mrf_Robots%rowtype;
  
    v_Indicator_Ids Array_Number;
    v_Charge_Id     number := i_Charge_Id;
    v_Amount        number;
    v_Value         number;
  begin
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Period     => i_End_Date);
  
    r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => i_Staff_Id,
                                                    i_Period     => i_End_Date);
  
    r_Closest_Rank := Hpd_Util.Closest_Rank(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Period     => i_End_Date);
  
    if i_Currency_Id is null then
      r_Closest_Currency := Hpd_Util.Closest_Currency(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Staff_Id   => i_Staff_Id,
                                                      i_Period     => i_End_Date);
    end if;
  
    if r_Closest_Schedule.Schedule_Id is null and i_Charge_Id is null then
      return;
    end if;
  
    if Htt_Util.Has_Undefined_Schedule(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Staff_Id    => i_Staff_Id,
                                       i_Schedule_Id => r_Closest_Schedule.Schedule_Id,
                                       i_Period      => i_End_Date) and i_Charge_Id is null then
      return;
    end if;
  
    if v_Charge_Id is null then
      v_Charge_Id := Hpr_Next.Charge_Id;
    end if;
  
    z_Hpr_Charges.Save_One(i_Company_Id    => i_Company_Id,
                           i_Filial_Id     => i_Filial_Id,
                           i_Charge_Id     => v_Charge_Id,
                           i_Staff_Id      => i_Staff_Id,
                           i_Interval_Id   => i_Interval_Id,
                           i_Doc_Oper_Id   => i_Doc_Oper_Id,
                           i_Begin_Date    => i_Begin_Date,
                           i_End_Date      => i_End_Date,
                           i_Oper_Type_Id  => i_Oper_Type_Id,
                           i_Amount        => Nvl(i_Amount, 0),
                           i_Division_Id   => r_Robot.Division_Id,
                           i_Schedule_Id   => r_Closest_Schedule.Schedule_Id,
                           i_Currency_Id   => Nvl(i_Currency_Id, r_Closest_Currency.Currency_Id),
                           i_Job_Id        => r_Robot.Job_Id,
                           i_Rank_Id       => r_Closest_Rank.Rank_Id,
                           i_Robot_Id      => r_Robot.Robot_Id,
                           i_Wage_Scale_Id => Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => i_Company_Id,
                                                                                 i_Filial_Id  => i_Filial_Id,
                                                                                 i_Staff_Id   => i_Staff_Id,
                                                                                 i_Period     => i_Begin_Date),
                           i_Status        => i_Status);
  
    if i_Charge_Id = v_Charge_Id then
      return;
    end if;
  
    select q.Indicator_Id
      bulk collect
      into v_Indicator_Ids
      from Hpr_Oper_Type_Indicators q
     where q.Company_Id = i_Company_Id
       and q.Oper_Type_Id = i_Oper_Type_Id;
  
    for i in 1 .. v_Indicator_Ids.Count
    loop
      v_Value := Hpr_Util.Calc_Indicator_Value(i_Company_Id   => i_Company_Id,
                                               i_Filial_Id    => i_Filial_Id,
                                               i_Staff_Id     => i_Staff_Id,
                                               i_Charge_Id    => v_Charge_Id,
                                               i_Begin_Date   => i_Begin_Date,
                                               i_End_Date     => i_End_Date,
                                               i_Indicator_Id => v_Indicator_Ids(i));
    
      z_Hpr_Charge_Indicators.Insert_One(i_Company_Id      => i_Company_Id,
                                         i_Filial_Id       => i_Filial_Id,
                                         i_Charge_Id       => v_Charge_Id,
                                         i_Indicator_Id    => v_Indicator_Ids(i),
                                         i_Indicator_Value => v_Value);
    end loop;
  
    v_Amount := Hpr_Util.Calc_Amount(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Charge_Id  => v_Charge_Id);
  
    if v_Amount > 0 then
      z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Charge_Id  => v_Charge_Id,
                               i_Amount     => Option_Number(v_Amount));
    else
      z_Hpr_Charges.Delete_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Charge_Id  => v_Charge_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Draft
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Charge_Id   number,
    i_Document_Id number
  ) is
    r_Charge      Hpr_Charges%rowtype;
    r_Document    Hpr_Charge_Documents%rowtype;
    v_Book_Number varchar2(200);
    v_Book_Date   date;
    v_Staff_Id    number;
    v_Staff_Name  varchar2(200);
  
    -------------------------------------------------- 
    Procedure Get_Book_Infos is
    begin
      select q.Book_Number, q.Book_Date
        into v_Book_Number, v_Book_Date
        from Mpr_Books q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and exists (select 1
                from Hpr_Book_Operations w
               where w.Company_Id = i_Company_Id
                 and w.Filial_Id = i_Filial_Id
                 and w.Book_Id = q.Book_Id
                 and w.Charge_Id = i_Charge_Id);
    exception
      when No_Data_Found then
        null;
    end;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Document_Id => i_Document_Id);
  
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status <> Hpr_Pref.c_Charge_Status_New then
      Get_Book_Infos;
    
      v_Staff_Id := z_Hpr_Charge_Document_Operations.Take(i_Company_Id => i_Company_Id, --
                    i_Filial_Id => i_Filial_Id, --
                    i_Operation_Id => r_Charge.Doc_Oper_Id).Staff_Id;
    
      v_Staff_Name := z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                      i_Person_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id, --
                      i_Filial_Id => i_Filial_Id, --
                      i_Staff_Id => v_Staff_Id)).Name;
    
      Hpr_Error.Raise_049(i_Staff_Name      => v_Staff_Name,
                          i_Status          => Hpr_Pref.c_Charge_Status_New,
                          i_Document_Number => r_Document.Document_Number,
                          i_Document_Date   => r_Document.Document_Date,
                          i_Book_Number     => v_Book_Number,
                          i_Book_Date       => v_Book_Date);
    end if;
  
    z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Charge_Id  => i_Charge_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_Draft));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Charge_Id   number,
    i_Document_Id number
  ) is
    r_Charge     Hpr_Charges%rowtype;
    r_Document   Hpr_Charge_Documents%rowtype;
    v_Staff_Id   number;
    v_Staff_Name varchar2(200);
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Document_Id => i_Document_Id);
  
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status <> Hpr_Pref.c_Charge_Status_Draft then
      v_Staff_Id := z_Hpr_Charge_Document_Operations.Take(i_Company_Id => i_Company_Id, --
                    i_Filial_Id => i_Filial_Id, --
                    i_Operation_Id => r_Charge.Doc_Oper_Id).Staff_Id;
    
      v_Staff_Name := z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                      i_Person_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id, --
                      i_Filial_Id => i_Filial_Id, --
                      i_Staff_Id => v_Staff_Id)).Name;
    
      Hpr_Error.Raise_049(i_Charge_Id       => i_Charge_Id,
                          i_Staff_Name      => v_Staff_Name,
                          i_Status          => Hpr_Pref.c_Charge_Status_Draft,
                          i_Document_Number => r_Document.Document_Number,
                          i_Document_Date   => r_Document.Document_Date);
    end if;
  
    z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Charge_Id  => i_Charge_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_New));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Use
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Charge_Id  number
  ) is
    r_Charge Hpr_Charges%rowtype;
  begin
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status = Hpr_Pref.c_Charge_Status_Completed then
      Hpr_Error.Raise_013(i_Charge_Id    => i_Charge_Id,
                          i_Status_Names => Fazo.Gather(Array_Varchar2(Hpr_Util.t_Charge_Status(Hpr_Pref.c_Charge_Status_New),
                                                                       Hpr_Util.t_Charge_Status(Hpr_Pref.c_Charge_Status_Used)),
                                                        ', '));
    end if;
  
    z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Charge_Id  => i_Charge_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_Used));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Cancel_Used
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Charge_Id  number
  ) is
    r_Charge Hpr_Charges%rowtype;
    v_Dummy  varchar2(1);
  begin
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status <> Hpr_Pref.c_Charge_Status_Used then
      Hpr_Error.Raise_014(i_Charge_Id);
    end if;
  
    begin
      select 'X'
        into v_Dummy
        from Hpr_Book_Operations q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Charge_Id = i_Charge_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Charge_Id  => i_Charge_Id,
                                 i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_New));
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Charge_Id  number
  ) is
    r_Charge Hpr_Charges%rowtype;
  begin
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status <> Hpr_Pref.c_Charge_Status_Used then
      Hpr_Error.Raise_015(i_Charge_Id);
    end if;
  
    z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Charge_Id  => i_Charge_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_Completed));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Charge_Cancel_Completed
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Charge_Id  number
  ) is
    r_Charge Hpr_Charges%rowtype;
  begin
    r_Charge := z_Hpr_Charges.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Charge_Id  => i_Charge_Id);
  
    if r_Charge.Status <> Hpr_Pref.c_Charge_Status_Completed then
      Hpr_Error.Raise_016(i_Charge_Id);
    end if;
  
    z_Hpr_Charges.Update_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Charge_Id  => i_Charge_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Charge_Status_Used));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Save(i_Oper_Type Hpr_Pref.Oper_Type_Rt) is
    r_Oper_Type     Hpr_Oper_Types%rowtype;
    r_Mpr_Oper_Type Mpr_Oper_Types%rowtype;
    v_Indicator_Ids Array_Number;
    v_Indicators    Matrix_Varchar2;
    v_Errors        Array_Varchar2;
    v_Exists        boolean;
  begin
    if z_Hpr_Oper_Types.Exist_Lock(i_Company_Id   => i_Oper_Type.Oper_Type.Company_Id,
                                   i_Oper_Type_Id => i_Oper_Type.Oper_Type.Oper_Type_Id,
                                   o_Row          => r_Oper_Type) then
      r_Mpr_Oper_Type := z_Mpr_Oper_Types.Lock_Load(i_Company_Id   => r_Oper_Type.Company_Id,
                                                    i_Oper_Type_Id => r_Oper_Type.Oper_Type_Id);
    
      if r_Mpr_Oper_Type.Pcode like Verifix.Project_Code || '%' and
         not Fazo.Equal(r_Oper_Type.Oper_Group_Id, i_Oper_Type.Oper_Group_Id) then
        Hpr_Error.Raise_017(i_Oper_Type_Id   => r_Oper_Type.Oper_Type_Id,
                            i_Oper_Type_Name => i_Oper_Type.Oper_Type.Name);
      end if;
    
      v_Exists := true;
    end if;
  
    Mpr_Api.Oper_Type_Save(i_Oper_Type.Oper_Type);
  
    r_Oper_Type.Company_Id      := i_Oper_Type.Oper_Type.Company_Id;
    r_Oper_Type.Oper_Type_Id    := i_Oper_Type.Oper_Type.Oper_Type_Id;
    r_Oper_Type.Oper_Group_Id   := i_Oper_Type.Oper_Group_Id;
    r_Oper_Type.Estimation_Type := i_Oper_Type.Estimation_Type;
  
    if r_Oper_Type.Estimation_Type = Hpr_Pref.c_Estimation_Type_Formula then
      r_Oper_Type.Estimation_Formula := i_Oper_Type.Estimation_Formula;
    else
      r_Oper_Type.Estimation_Formula := null;
    end if;
  
    if v_Exists then
      z_Hpr_Oper_Types.Update_Row(r_Oper_Type);
    else
      z_Hpr_Oper_Types.Save_Row(r_Oper_Type);
    end if;
  
    if r_Oper_Type.Estimation_Type = Hpr_Pref.c_Estimation_Type_Formula then
      v_Indicators := Hpr_Util.Formula_Indicators(i_Company_Id => i_Oper_Type.Oper_Type.Company_Id,
                                                  i_Formula    => i_Oper_Type.Estimation_Formula);
    
      v_Indicator_Ids := Array_Number();
      v_Indicator_Ids.Extend(v_Indicators.Count);
    
      for i in 1 .. v_Indicators.Count
      loop
        v_Indicator_Ids(i) := v_Indicators(i) (1);
      
        z_Hpr_Oper_Type_Indicators.Save_One(i_Company_Id   => i_Oper_Type.Oper_Type.Company_Id,
                                            i_Oper_Type_Id => i_Oper_Type.Oper_Type.Oper_Type_Id,
                                            i_Indicator_Id => v_Indicators(i) (1),
                                            i_Identifier   => v_Indicators(i) (2));
      end loop;
    
      if v_Exists then
        for r in (select *
                    from Hpr_Oper_Type_Indicators q
                   where q.Company_Id = i_Oper_Type.Oper_Type.Company_Id
                     and q.Oper_Type_Id = i_Oper_Type.Oper_Type.Oper_Type_Id
                     and q.Indicator_Id not member of v_Indicator_Ids)
        loop
          z_Hpr_Oper_Type_Indicators.Delete_One(i_Company_Id   => i_Oper_Type.Oper_Type.Company_Id,
                                                i_Oper_Type_Id => i_Oper_Type.Oper_Type.Oper_Type_Id,
                                                i_Indicator_Id => r.Indicator_Id);
        end loop;
      end if;
    
      v_Errors := Hpr_Util.Formula_Validate(i_Company_Id => i_Oper_Type.Oper_Type.Company_Id,
                                            i_Formula    => i_Oper_Type.Estimation_Formula);
    
      if v_Errors.Count <> 0 then
        Hpr_Error.Raise_034(Fazo.Gather(v_Errors, Chr(10)));
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Save(i_Book Hpr_Pref.Book_Rt) is
    r_Book            Hpr_Books%rowtype;
    v_Operation       Hpr_Pref.Book_Operation_Rt;
    v_Staff_Ids       Array_Number;
    v_Last_Charge_Ids Array_Number;
    v_New_Charge_Ids  Array_Number := Array_Number();
    v_Exist           boolean;
  begin
    if z_Hpr_Books.Exist_Lock(i_Company_Id => i_Book.Book.Company_Id,
                              i_Filial_Id  => i_Book.Book.Filial_Id,
                              i_Book_Id    => i_Book.Book.Book_Id) then
      v_Exist := true;
    end if;
  
    r_Book.Company_Id   := i_Book.Book.Company_Id;
    r_Book.Filial_Id    := i_Book.Book.Filial_Id;
    r_Book.Book_Id      := i_Book.Book.Book_Id;
    r_Book.Book_Type_Id := i_Book.Book_Type_Id;
  
    select q.Charge_Id
      bulk collect
      into v_Last_Charge_Ids
      from Hpr_Book_Operations q
     where q.Company_Id = r_Book.Company_Id
       and q.Filial_Id = r_Book.Filial_Id
       and q.Book_Id = r_Book.Book_Id
       and q.Autofilled = 'Y';
  
    Mpr_Api.Book_Save(i_Book.Book);
  
    if v_Exist then
      z_Hpr_Books.Update_Row(r_Book);
    else
      z_Hpr_Books.Insert_Row(r_Book);
    end if;
  
    v_Staff_Ids := Array_Number();
    v_Staff_Ids.Extend(i_Book.Operations.Count);
  
    for i in 1 .. i_Book.Operations.Count
    loop
      v_Operation := i_Book.Operations(i);
      v_Staff_Ids(i) := v_Operation.Staff_Id;
    
      z_Hpr_Book_Operations.Save_One(i_Company_Id   => r_Book.Company_Id,
                                     i_Filial_Id    => r_Book.Filial_Id,
                                     i_Book_Id      => r_Book.Book_Id,
                                     i_Operation_Id => v_Operation.Operation_Id,
                                     i_Staff_Id     => v_Operation.Staff_Id,
                                     i_Charge_Id    => v_Operation.Charge_Id,
                                     i_Autofilled   => v_Operation.Autofilled);
    
      if v_Operation.Autofilled = 'Y' then
        Charge_Use(i_Company_Id => r_Book.Company_Id,
                   i_Filial_Id  => r_Book.Filial_Id,
                   i_Charge_Id  => v_Operation.Charge_Id);
      
        v_New_Charge_Ids.Extend;
        v_New_Charge_Ids(v_New_Charge_Ids.Count) := v_Operation.Charge_Id;
      end if;
    end loop;
  
    v_Last_Charge_Ids := v_Last_Charge_Ids multiset Except v_New_Charge_Ids;
  
    for i in 1 .. v_Last_Charge_Ids.Count
    loop
      Charge_Cancel_Used(i_Company_Id => r_Book.Company_Id,
                         i_Filial_Id  => r_Book.Filial_Id,
                         i_Charge_Id  => v_Last_Charge_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  ) is
  begin
    Mpr_Api.Book_Post(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Book_Id    => i_Book_Id);
  
    for r in (select q.Charge_Id
                from Hpr_Book_Operations q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Book_Id = i_Book_Id
                 and q.Autofilled = 'Y')
    loop
      Charge_Complete(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Charge_Id  => r.Charge_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Book_Unpost
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Book_Id    number
  ) is
  begin
    for r in (select q.Charge_Id
                from Hpr_Book_Operations q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Book_Id = i_Book_Id
                 and q.Autofilled = 'Y')
    loop
      Charge_Cancel_Completed(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Charge_Id  => r.Charge_Id);
    end loop;
  
    Mpr_Api.Book_Unpost(i_Company_Id => i_Company_Id,
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
    v_Charge_Ids Array_Number;
  begin
    select q.Charge_Id
      bulk collect
      into v_Charge_Ids
      from Hpr_Book_Operations q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Book_Id = i_Book_Id
       and q.Autofilled = 'Y';
  
    Mpr_Api.Book_Delete(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Book_Id    => i_Book_Id);
  
    for i in 1 .. v_Charge_Ids.Count
    loop
      Charge_Cancel_Used(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Charge_Id  => v_Charge_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Advance_Save(i_Advance Hpr_Pref.Advance_Rt) is
    v_Payment       Mpr_Pref.Payment_Rt;
    v_Employee_Id   number;
    v_Month_Begin   date;
    v_Staff_Id      number;
    v_Turnout_Count number;
  begin
    v_Payment := i_Advance.Payment;
  
    if i_Advance.Payment.Payment_Kind <> Mpr_Pref.c_Pk_Advance then
      Hpr_Error.Raise_035(Mpr_Util.t_Payment_Kind(i_Advance.Payment.Payment_Kind));
    end if;
  
    if i_Advance.Days_Limit is not null then
      v_Month_Begin := Trunc(v_Payment.Booked_Date, 'mon');
    
      for i in 1 .. i_Advance.Employee_Ids.Count
      loop
        v_Employee_Id := i_Advance.Employee_Ids(i);
      
        v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id   => v_Payment.Company_Id,
                                                     i_Filial_Id    => v_Payment.Filial_Id,
                                                     i_Employee_Id  => v_Employee_Id,
                                                     i_Period_Begin => v_Payment.Booked_Date -
                                                                       i_Advance.Days_Limit,
                                                     i_Period_End   => v_Payment.Booked_Date);
        if v_Staff_Id is not null then
          if i_Advance.Limit_Kind = Hpr_Pref.c_Advance_Limit_Turnout_Days then
            v_Turnout_Count := Htt_Util.Calc_Turnout_Days(i_Company_Id  => v_Payment.Company_Id,
                                                          i_Filial_Id   => v_Payment.Filial_Id,
                                                          i_Employee_Id => v_Employee_Id,
                                                          i_Begin_Date  => v_Month_Begin,
                                                          i_End_Date    => v_Payment.Booked_Date);
          
            if v_Turnout_Count < i_Advance.Days_Limit then
              Hpr_Error.Raise_018(i_Staff_Name  => Href_Util.Staff_Name(i_Company_Id => v_Payment.Company_Id,
                                                                        i_Filial_Id  => v_Payment.Filial_Id,
                                                                        i_Staff_Id   => v_Staff_Id),
                                  i_Turnout_Cnt => v_Turnout_Count,
                                  i_Days_Limit  => i_Advance.Days_Limit,
                                  i_Booked_Date => v_Payment.Booked_Date);
            end if;
          end if;
        else
          Hpr_Error.Raise_019(i_Days_Limit    => i_Advance.Days_Limit,
                              i_Employee_Name => z_Mr_Natural_Persons.Load(i_Company_Id => v_Payment.Company_Id, i_Person_Id => v_Employee_Id).Name,
                              i_Booked_Date   => v_Payment.Booked_Date);
        end if;
      end loop;
    end if;
  
    Mpr_Api.Payment_Save(i_Advance.Payment);
  
    z_Hpr_Advance_Settings.Save_One(i_Company_Id => v_Payment.Company_Id,
                                    i_Filial_Id  => v_Payment.Filial_Id,
                                    i_Payment_Id => v_Payment.Payment_Id,
                                    i_Limit_Kind => i_Advance.Limit_Kind,
                                    i_Days_Limit => i_Advance.Days_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Post
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Payment_Id number
  ) is
    r_Payment      Hpr_Sales_Bonus_Payments%rowtype;
    r_Robot        Mrf_Robots%rowtype;
    r_Job          Mhr_Jobs%rowtype;
    v_Period_Begin date;
    v_Period_End   date;
    v_Currency_Id  number;
    v_Corr_Account Mk_Account;
    v_Cash_Or_Bank Mk_Account;
    v_Payment      Mk_Account;
  
    --------------------------------------------------
    Function Interval_Kind(i_Bonus_Type varchar2) return varchar2 is
    begin
      return --
      case i_Bonus_Type --
      when Hrm_Pref.c_Bonus_Type_Personal_Sales then Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Personal_Sales --
      when Hrm_Pref.c_Bonus_Type_Department_Sales then Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Department_Sales --
      when Hrm_Pref.c_Bonus_Type_Successful_Delivery then Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery --
      end;
    end;
  begin
    r_Payment := z_Hpr_Sales_Bonus_Payments.Lock_Load(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Payment_Id => i_Payment_Id);
  
    if r_Payment.Posted = 'Y' then
      Hpr_Error.Raise_043(r_Payment.Payment_Number);
    end if;
  
    Mk_Journal.Pick(i_Company_Id   => i_Company_Id,
                    i_Filial_Id    => i_Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Sales_Bonus_Payment(i_Payment_Id),
                    i_Trans_Date   => r_Payment.Payment_Date);
  
    v_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Payment.Payment_Type = Mpr_Pref.c_Pt_Cashbox then
      v_Cash_Or_Bank := Mkr_Account.Cash(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Currency_Id => v_Currency_Id,
                                         i_Cashbox_Id  => r_Payment.Cashbox_Id);
    else
      v_Cash_Or_Bank := Mkr_Account.Bank(i_Company_Id      => i_Company_Id,
                                         i_Filial_Id       => i_Filial_Id,
                                         i_Currency_Id     => v_Currency_Id,
                                         i_Bank_Account_Id => r_Payment.Bank_Account_Id);
    end if;
  
    for r in (select q.*,
                     (select s.Employee_Id
                        from Href_Staffs s
                       where s.Company_Id = i_Company_Id
                         and s.Filial_Id = i_Filial_Id
                         and s.Staff_Id = q.Staff_Id) as Employee_Id,
                     (select s.Dismissal_Date
                        from Href_Staffs s
                       where s.Company_Id = i_Company_Id
                         and s.Filial_Id = i_Filial_Id
                         and s.Staff_Id = q.Staff_Id) as Dismissal_Date
                from Hpr_Sales_Bonus_Payment_Operations q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Payment_Id = i_Payment_Id)
    loop
      if Hpr_Util.Is_Staff_Sales_Bonus_Calced(i_Company_Id   => i_Company_Id,
                                              i_Filial_Id    => i_Filial_Id,
                                              i_Staff_Id     => r.Staff_Id,
                                              i_Bonus_Type   => r.Bonus_Type,
                                              i_Period_Begin => r.Period_Begin,
                                              i_Period_End   => r.Period_End,
                                              o_Period_Begin => v_Period_Begin,
                                              o_Period_End   => v_Period_End) = 'Y' then
        Hpr_Error.Raise_039(i_Payment_Number  => r_Payment.Payment_Number,
                            i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                      i_Filial_Id  => i_Filial_Id,
                                                                      i_Staff_Id   => r.Staff_Id),
                            i_Bonus_Type_Name => Hrm_Util.t_Bonus_Type(r.Bonus_Type),
                            i_Period_Begin    => v_Period_Begin,
                            i_Period_End      => v_Period_End);
      end if;
    
      Hpd_Api.Sales_Bonus_Payment_Lock_Interval_Insert(i_Company_Id    => i_Company_Id,
                                                       i_Filial_Id     => i_Filial_Id,
                                                       i_Operation_Id  => r.Operation_Id,
                                                       i_Staff_Id      => r.Staff_Id,
                                                       i_Begin_Date    => r.Period_Begin,
                                                       i_End_Date      => r.Period_End,
                                                       i_Interval_Kind => Interval_Kind(r.Bonus_Type));
    
      r_Job := z_Mhr_Jobs.Lock_Load(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Job_Id     => r.Job_Id);
    
      r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => r.Staff_Id,
                                            i_Period     => Least(r.Period_End,
                                                                  Nvl(r.Dismissal_Date, r.Period_End)));
    
      if r.Job_Id <> r_Robot.Job_Id then
        Hpr_Error.Raise_044(i_Payment_Number => r_Payment.Payment_Number,
                            i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                     i_Filial_Id  => i_Filial_Id,
                                                                     i_Staff_Id   => r.Staff_Id),
                            i_Job_Name       => r_Job.Name,
                            i_Period_Begin   => r.Period_Begin,
                            i_Period_End     => r.Period_End);
      end if;
    
      -- calc amount
      if r_Job.Expense_Coa_Id is not null then
        v_Corr_Account := Mk_Util.Account(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Coa_Id      => r_Job.Expense_Coa_Id,
                                          i_Currency_Id => v_Currency_Id,
                                          i_Ref_Set     => r_Job.Expense_Ref_Set);
      else
        Hpr_Error.Raise_045(i_Job_Name => r_Job.Name);
      end if;
    
      Mpr_Journal.Accrue(i_Company_Id   => i_Company_Id,
                         i_Filial_Id    => i_Filial_Id,
                         i_Employee_Id  => r.Employee_Id,
                         i_Corr_Account => v_Corr_Account,
                         i_Currency_Id  => v_Currency_Id,
                         i_Amount       => r.Amount,
                         i_Division_Id  => r_Robot.Division_Id,
                         i_Job_Id       => r.Job_Id);
    
      -- pay
      v_Payment := Mkr_Account.Payroll_Accrual(i_Company_Id                   => i_Company_Id,
                                               i_Filial_Id                    => i_Filial_Id,
                                               i_Currency_Id                  => v_Currency_Id,
                                               i_Person_Id                    => r.Employee_Id,
                                               i_Payroll_Accrual_Condition_Id => Mkr_Pref.c_Pac_Free);
    
      Mk_Journal.Add_Trans(i_Debit       => v_Payment,
                           i_Credit      => v_Cash_Or_Bank,
                           i_Amount      => r.Amount,
                           i_Amount_Base => r.Amount,
                           i_Note        => r_Payment.Note);
    end loop;
  
    z_Hpr_Sales_Bonus_Payments.Update_One(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Payment_Id => i_Payment_Id,
                                          i_Posted     => Option_Varchar2('Y'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Unpost
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
  
    if r_Payment.Posted = 'N' then
      Hpr_Error.Raise_042(r_Payment.Payment_Number);
    end if;
  
    Mk_Journal.Pick(i_Company_Id   => i_Company_Id,
                    i_Filial_Id    => i_Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Sales_Bonus_Payment(i_Payment_Id),
                    i_Trans_Date   => r_Payment.Payment_Date);
  
    Mk_Journal.Clear;
  
    for r in (select q.Operation_Id, q.Interval_Id
                from Hpr_Sales_Bonus_Payment_Intervals q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Operation_Id in (select q.Operation_Id
                                          from Hpr_Sales_Bonus_Payment_Operations p
                                         where p.Company_Id = i_Company_Id
                                           and p.Filial_Id = i_Filial_Id
                                           and p.Payment_Id = i_Payment_Id))
    loop
      z_Hpr_Sales_Bonus_Payment_Intervals.Delete_One(i_Company_Id   => i_Company_Id,
                                                     i_Filial_Id    => i_Filial_Id,
                                                     i_Operation_Id => r.Operation_Id);
      Hpd_Api.Lock_Interval_Delete(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Interval_Id => r.Interval_Id);
    end loop;
  
    z_Hpr_Sales_Bonus_Payments.Update_One(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Payment_Id => i_Payment_Id,
                                          i_Posted     => Option_Varchar2('N'));
  end;

  ----------------------------------------------------------------------------------------------------                  
  Procedure Credit_Draft
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
  
    if r_Credit.Status = Hpr_Pref.c_Credit_Status_Draft then
      Hpr_Error.Raise_059;
    end if;
  
    Mk_Journal.Pick(i_Company_Id   => r_Credit.Company_Id,
                    i_Filial_Id    => r_Credit.Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Credit(r_Credit.Credit_Id),
                    i_Trans_Date   => r_Credit.Credit_Date);
  
    Mk_Journal.Clear;
  
    z_Hpr_Credits.Update_One(i_Company_Id => r_Credit.Company_Id,
                             i_Filial_Id  => r_Credit.Filial_Id,
                             i_Credit_Id  => r_Credit.Credit_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Credit_Status_Draft));
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Credit_Book
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
  
    if r_Credit.Status = Hpr_Pref.c_Credit_Status_Booked then
      Hpr_Error.Raise_058;
    end if;
  
    Mk_Journal.Pick(i_Company_Id   => r_Credit.Company_Id,
                    i_Filial_Id    => r_Credit.Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Credit(r_Credit.Credit_Id),
                    i_Trans_Date   => r_Credit.Credit_Date);
  
    Mk_Journal.Clear;
  
    z_Hpr_Credits.Update_One(i_Company_Id => r_Credit.Company_Id,
                             i_Filial_Id  => r_Credit.Filial_Id,
                             i_Credit_Id  => r_Credit.Credit_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Credit_Status_Booked));
  end;

  ----------------------------------------------------------------------------------------------------                  
  Procedure Credit_Complete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number
  ) is
    v_Months_Count   number;
    v_Monthly_Amount number;
    v_Amount         number;
    v_Amount_Base    number;
    v_Current_Month  date := Trunc(sysdate, 'mon');
    v_Trans_Date     date;
  
    v_Payment      Mk_Account;
    v_Cash_Or_Bank Mk_Account;
    r_Credit       Hpr_Credits%rowtype;
  begin
    r_Credit := z_Hpr_Credits.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Credit_Id  => i_Credit_Id);
  
    if r_Credit.Status = Hpr_Pref.c_Credit_Status_Complete then
      Hpr_Error.Raise_060;
    end if;
  
    v_Months_Count   := Months_Between(r_Credit.End_Month, r_Credit.Begin_Month);
    v_Monthly_Amount := Round(r_Credit.Credit_Amount / (v_Months_Count + 1), 2);
  
    Mk_Journal.Pick(i_Company_Id   => r_Credit.Company_Id,
                    i_Filial_Id    => r_Credit.Filial_Id,
                    i_Journal_Code => Hpr_Util.Jcode_Credit(r_Credit.Credit_Id),
                    i_Trans_Date   => r_Credit.Credit_Date);
  
    Mk_Journal.Clear;
  
    if r_Credit.Payment_Type = Mpr_Pref.c_Pt_Cashbox then
      v_Cash_Or_Bank := Mkr_Account.Cash(i_Company_Id  => r_Credit.Company_Id,
                                         i_Filial_Id   => r_Credit.Filial_Id,
                                         i_Currency_Id => r_Credit.Currency_Id,
                                         i_Cashbox_Id  => r_Credit.Cashbox_Id);
    else
      v_Cash_Or_Bank := Mkr_Account.Bank(i_Company_Id      => r_Credit.Company_Id,
                                         i_Filial_Id       => r_Credit.Filial_Id,
                                         i_Currency_Id     => r_Credit.Currency_Id,
                                         i_Bank_Account_Id => r_Credit.Bank_Account_Id);
    end if;
  
    v_Payment := Hpr_Util.Payment_Credit(i_Company_Id  => r_Credit.Company_Id,
                                         i_Filial_Id   => r_Credit.Filial_Id,
                                         i_Currency_Id => r_Credit.Currency_Id,
                                         i_Person_Id   => r_Credit.Employee_Id);
  
    for i in 0 .. v_Months_Count
    loop
      v_Amount := Least(r_Credit.Credit_Amount, v_Monthly_Amount);
    
      exit when v_Amount = 0;
    
      v_Trans_Date := Add_Months(r_Credit.Begin_Month, i);
    
      if v_Trans_Date <= v_Current_Month then
        v_Amount_Base := Mk_Util.Calc_Amount_Base(i_Company_Id  => r_Credit.Company_Id,
                                                  i_Filial_Id   => r_Credit.Filial_Id,
                                                  i_Currency_Id => r_Credit.Currency_Id,
                                                  i_Rate_Date   => r_Credit.Credit_Date,
                                                  i_Amount      => v_Amount);
      
        Mk_Journal.Set_Trans_Date(v_Trans_Date);
        Mk_Journal.Set_Trans_Tag(r_Credit.Credit_Id);
        Mk_Journal.Add_Trans(i_Debit       => v_Payment,
                             i_Credit      => v_Cash_Or_Bank,
                             i_Amount      => v_Amount,
                             i_Amount_Base => v_Amount_Base,
                             i_Note        => r_Credit.Note);
      end if;
    end loop;
  
    z_Hpr_Credits.Update_One(i_Company_Id => r_Credit.Company_Id,
                             i_Filial_Id  => r_Credit.Filial_Id,
                             i_Credit_Id  => r_Credit.Credit_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Credit_Status_Complete));
  end;

  ----------------------------------------------------------------------------------------------------                    
  Procedure Credit_Archive
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
  
    if r_Credit.Status <> Hpr_Pref.c_Credit_Status_Complete then
      Hpr_Error.Raise_061(Hpr_Util.t_Credit_Status(r_Credit.Status));
    end if;
  
    z_Hpr_Credits.Update_One(i_Company_Id => r_Credit.Company_Id,
                             i_Filial_Id  => r_Credit.Filial_Id,
                             i_Credit_Id  => r_Credit.Credit_Id,
                             i_Status     => Option_Varchar2(Hpr_Pref.c_Credit_Status_Archived));
  end;

  ----------------------------------------------------------------------------------------------------                  
  Procedure Run_Monthly_Credit_Transactions is
    v_Current_Month  date := Trunc(sysdate, 'mon');
    v_Months_Count   number;
    v_Monthly_Amount number;
    v_Amount         number;
    v_Amount_Base    number;
    v_Trans_Date     date;
    v_Payment        Mk_Account;
    v_Cash_Or_Bank   Mk_Account;
  
    --------------------------------------------------
    Procedure Add_Transaction
    (
      i_Payment     Mk_Account,
      i_Credit      Mk_Account,
      i_Amount      number,
      i_Amount_Base number,
      i_Credit_Id   number,
      i_Trans_Date  date,
      i_Note        varchar2
    ) is
    begin
      Mk_Journal.Set_Trans_Date(i_Trans_Date);
      Mk_Journal.Set_Trans_Tag(i_Credit_Id);
      Mk_Journal.Add_Trans(i_Debit       => i_Payment,
                           i_Credit      => i_Credit,
                           i_Amount      => i_Amount,
                           i_Amount_Base => i_Amount_Base,
                           i_Note        => i_Note);
    end;
  
    --------------------------------------------------      
    Function Is_Transaction_Exists
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Credit_Id  number,
      i_Date       date
    ) return boolean is
      v_Journal_Code varchar2(100) := Hpr_Util.Jcode_Credit(i_Credit_Id);
      v_Dummy        number;
    begin
      select 1
        into v_Dummy
        from Mk_Transactions q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Tag = to_char(i_Credit_Id)
         and q.Trans_Date = i_Date
         and exists (select 1
                from Mk_Journals w
               where w.Company_Id = i_Company_Id
                 and w.Filial_Id = i_Filial_Id
                 and w.Journal_Code = v_Journal_Code)
       fetch first row only;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    for Com in (select q.Company_Id, Md_Pref.User_System(q.Company_Id) as User_System
                  from Md_Companies q)
    loop
      for Fil in (select w.Company_Id, w.Filial_Id
                    from Md_Filials w
                   where w.Company_Id = Com.Company_Id)
      loop
        Biruni_Route.Context_Begin;
        Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                             i_Filial_Id    => Fil.Filial_Id,
                             i_User_Id      => Com.User_System,
                             i_Project_Code => Verifix.Project_Code);
        for r in (select k.*
                    from Hpr_Credits k
                   where k.Company_Id = Fil.Company_Id
                     and k.Filial_Id = Fil.Filial_Id
                     and k.Status = Hpr_Pref.c_Credit_Status_Complete
                     and v_Current_Month between k.Begin_Month and k.End_Month)
        loop
        
          v_Months_Count   := Months_Between(r.End_Month, r.Begin_Month);
          v_Monthly_Amount := Round(r.Credit_Amount / (v_Months_Count + 1), 2);
        
          if r.Payment_Type = Mpr_Pref.c_Pt_Cashbox then
            v_Cash_Or_Bank := Mkr_Account.Cash(i_Company_Id  => r.Company_Id,
                                               i_Filial_Id   => r.Filial_Id,
                                               i_Currency_Id => r.Currency_Id,
                                               i_Cashbox_Id  => r.Cashbox_Id);
          else
            v_Cash_Or_Bank := Mkr_Account.Bank(i_Company_Id      => r.Company_Id,
                                               i_Filial_Id       => r.Filial_Id,
                                               i_Currency_Id     => r.Currency_Id,
                                               i_Bank_Account_Id => r.Bank_Account_Id);
          end if;
        
          Mk_Journal.Pick(i_Company_Id   => r.Company_Id,
                          i_Filial_Id    => r.Filial_Id,
                          i_Journal_Code => Hpr_Util.Jcode_Credit(r.Credit_Id),
                          i_Trans_Date   => r.Credit_Date);
        
          for i in 0 .. v_Months_Count
          loop
            v_Amount := Least(r.Credit_Amount, v_Monthly_Amount);
          
            exit when v_Amount = 0;
          
            v_Trans_Date := Add_Months(r.Begin_Month, i);
          
            if v_Trans_Date <= v_Current_Month and
               not Is_Transaction_Exists(r.Company_Id, r.Filial_Id, r.Credit_Id, v_Trans_Date) then
              v_Amount_Base := Mk_Util.Calc_Amount_Base(i_Company_Id  => r.Company_Id,
                                                        i_Filial_Id   => r.Filial_Id,
                                                        i_Currency_Id => r.Currency_Id,
                                                        i_Rate_Date   => r.Credit_Date,
                                                        i_Amount      => v_Amount);
            
              v_Payment := Hpr_Util.Payment_Credit(i_Company_Id  => r.Company_Id,
                                                   i_Filial_Id   => r.Filial_Id,
                                                   i_Currency_Id => r.Currency_Id,
                                                   i_Person_Id   => r.Employee_Id);
            
              Add_Transaction(i_Payment     => v_Payment,
                              i_Credit      => v_Cash_Or_Bank,
                              i_Amount      => v_Amount,
                              i_Amount_Base => v_Amount_Base,
                              i_Credit_Id   => r.Credit_Id,
                              i_Trans_Date  => v_Trans_Date,
                              i_Note        => r.Note);
            end if;
          end loop;
        end loop;
      
        Biruni_Route.Context_End;
      end loop;
    end loop;
  end;

end Hpr_Core;
/
